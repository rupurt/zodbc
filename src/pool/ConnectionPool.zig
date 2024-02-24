const std = @import("std");

const core = @import("core");
const Environment = core.Environment;

const messages = @import("messages.zig");
const ParentMailbox = messages.ParentMailbox;
const Worker = @import("worker.zig").Worker;
const PoolBatchReader = @import("PoolBatchReader.zig");

const Self = @This();

allocator: std.mem.Allocator,
n_workers: usize,
env: Environment,
mailbox: ParentMailbox,
workers: WorkerList,

pub fn init(allocator: std.mem.Allocator, env: Environment, config: Config) !Self {
    const n_workers = config.n_workers;
    const mailbox = ParentMailbox.init(allocator);
    var workers = try WorkerList.initCapacity(allocator, n_workers);
    for (0..n_workers) |_| try workers.append(.{});

    return .{
        .allocator = allocator,
        .n_workers = n_workers,
        .env = env,
        .mailbox = mailbox,
        .workers = workers,
    };
}

pub fn deinit(self: Self) void {
    for (self.workers.items) |*w| w.join();
    self.workers.deinit();
    self.mailbox.deinit();
}

pub fn connectWithString(self: *Self, dsn: []const u8) !void {
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

pub fn batchReader(self: *Self) PoolBatchReader {
    _ = self;
    return .{};
}

pub const Config = struct {
    // The maximum number of ODBC connections that will be created and managed
    // by the connection pool
    n_workers: usize = 2,
};

const WorkerList = std.ArrayList(Worker);
