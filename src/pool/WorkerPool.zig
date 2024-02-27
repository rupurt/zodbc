const std = @import("std");

const core = @import("core");
const Environment = core.Environment;
const Connection = core.Connection;
const Statement = core.Statement;
const Rowset = core.Rowset;

const odbc = @import("odbc");
const types = odbc.types;

const messages = @import("messages.zig");
const ParentMailbox = messages.ParentMailbox;
const Worker = @import("worker.zig").Worker;

const Self = @This();

allocator: std.mem.Allocator,
n_workers: usize,
env: Environment,
conn: Connection,
stmt: Statement = undefined,
mailbox: ParentMailbox,
workers: WorkerList,

pub fn init(allocator: std.mem.Allocator, env: Environment, config: Config) !Self {
    const conn = try Connection.init(env);
    const n_workers = config.n_workers;
    const mailbox = ParentMailbox.init(allocator);
    var workers = try WorkerList.initCapacity(allocator, n_workers);
    for (0..n_workers) |_| try workers.append(.{});

    return .{
        .allocator = allocator,
        .n_workers = n_workers,
        .env = env,
        .conn = conn,
        .mailbox = mailbox,
        .workers = workers,
    };
}

pub fn deinit(self: Self) void {
    for (self.workers.items) |*w| w.join();
    self.workers.deinit();
    self.mailbox.deinit();
    self.stmt.deinit();
    self.conn.deinit();
}

pub fn connectWithString(self: *Self, dsn: []const u8) !void {
    try self.conn.connectWithString(dsn);
    const stmt = try Statement.init(self.conn);
    self.stmt = stmt;
    for (self.workers.items) |*worker| {
        try worker.spawn(self.allocator, &self.mailbox);
        try worker.post(.{ .connect = .{
            .env = self.env,
            .dsn = dsn,
        } });
    }
    var n_connected: usize = 0;
    while (n_connected < self.n_workers) {
        switch (self.mailbox.dequeue()) {
            .connect => n_connected += 1,
            else => {},
        }
    }
}

pub fn prepare(self: *Self, statement_str: []const u8) !void {
    try self.stmt.prepare(statement_str);
    for (self.workers.items) |*worker| {
        try worker.post(.{ .prepare = .{
            .statement_str = statement_str,
        } });
    }
    var n_prepared: usize = 0;
    while (n_prepared < self.n_workers) {
        switch (self.mailbox.dequeue()) {
            .prepare => n_prepared += 1,
            else => {},
        }
    }
}

pub fn execute(self: *Self) !void {
    try self.stmt.execute();
    for (self.workers.items) |*worker| {
        try worker.post(.{ .execute = .{} });
    }
    var n_executed: usize = 0;
    while (n_executed < self.n_workers) {
        switch (self.mailbox.dequeue()) {
            .execute => n_executed += 1,
            else => {},
        }
    }
}

pub fn batchReader(
    self: *Self,
    allocator: std.mem.Allocator,
    fetch_array_size: usize,
) !WorkerBatchReader {
    return WorkerBatchReader.init(
        allocator,
        &self.stmt,
        &self.workers,
        &self.mailbox,
        fetch_array_size,
    );
}

pub const Config = struct {
    // Number of ODBC connections to create within separate kernel threads
    n_workers: usize = 1,
};

const WorkerList = std.ArrayList(Worker);

const WorkerBatchReader = struct {
    allocator: std.mem.Allocator,
    stmt: *Statement,
    workers: *WorkerList,
    mailbox: *ParentMailbox,
    column_descriptions: []types.ColDescription,
    rowsets: []Rowset,
    fetch_array_size: usize,
    offset: usize,
    has_more_results: bool,

    pub fn init(
        allocator: std.mem.Allocator,
        stmt: *Statement,
        workers: *WorkerList,
        mailbox: *ParentMailbox,
        fetch_array_size: usize,
    ) !WorkerBatchReader {
        const num_result_cols = try stmt.numResultCols();
        const column_descriptions = try allocator.alloc(types.ColDescription, num_result_cols);
        for (0..num_result_cols) |i| {
            var col_desc = try types.ColDescription.init(allocator);
            try stmt.describeCol(i + 1, &col_desc);
            column_descriptions[i] = col_desc;
        }
        const rowsets = try allocator.alloc(Rowset, workers.items.len);
        for (0..rowsets.len) |i| {
            const rowset = try Rowset.init(allocator, column_descriptions, fetch_array_size);
            rowsets[i] = rowset;
        }

        return .{
            .allocator = allocator,
            .stmt = stmt,
            .workers = workers,
            .mailbox = mailbox,
            .column_descriptions = column_descriptions,
            .rowsets = rowsets,
            .fetch_array_size = fetch_array_size,
            .offset = 0,
            .has_more_results = true,
        };
    }

    pub fn deinit(self: WorkerBatchReader) void {
        self.allocator.free(self.rowsets);
        self.allocator.free(self.column_descriptions);
    }

    pub fn next(self: *WorkerBatchReader) ?Rowset {
        var rowset: ?Rowset = null;

        while (self.has_more_results) {
            if (self.offset == 0) {
                self.offset += self.fetch_array_size;
                self.has_more_results = false;
                rowset = self.rowsets[0];
            }
            for (self.workers.items) |*worker| {
                worker.post(.{
                    .fetchScroll = .{
                        // .orientation = .ABSOLUTE,
                        .orientation = .NEXT,
                        .offset = self.offset,
                    },
                }) catch {
                    std.debug.print("WorkerBatchReader.next: worker.post failed\n", .{});
                };
                self.offset += self.fetch_array_size;
            }
        }

        return rowset;
    }
};
