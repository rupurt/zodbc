const std = @import("std");

const errors = @import("errors.zig");
const PrepareError = errors.PrepareError;
const NumResultColsError = errors.NumResultColsError;
const DescribeColError = errors.DescribeColError;
const ExecuteError = errors.ExecuteError;
const FetchScrollError = errors.FetchScrollError;

const connection = @import("connection.zig");
const Connection = connection.Connection;

const handle = @import("handle.zig");
const Handle = handle.Handle;

const odbc = @import("odbc");
const rc = odbc.return_codes;
const types = odbc.types;
const sql = odbc.sql;

pub const Statement = struct {
    handler: Handle,

    pub fn init(allocator: std.mem.Allocator, con: *Connection) !*Statement {
        const handler = try Handle.init(.STMT, con.handle());

        const stmt = try allocator.create(Statement);
        stmt.* = .{ .handler = handler };
        return stmt;
    }

    pub fn deinit(self: *Statement) rc.FreeHandleRC {
        return self.handler.deinit();
    }

    pub fn handle(self: *Statement) ?*anyopaque {
        return self.handler.handle;
    }

    pub fn getLastError(self: Statement) sql.LastError {
        return self.handler.getLastError();
    }

    pub fn disconnect(self: *Statement) !void {
        _ = self;
    }

    pub fn dataSources(self: *Statement) !void {
        _ = self;
    }

    pub fn tables(self: *Statement) !void {
        _ = self;
    }

    pub fn tablePrivileges(self: *Statement) !void {
        _ = self;
    }

    pub fn specialColumns(self: *Statement) !void {
        _ = self;
    }

    pub fn columns(self: *Statement) !void {
        _ = self;
    }

    pub fn columnPrivleges(self: *Statement) !void {
        _ = self;
    }

    pub fn colAttribute(self: *Statement) !void {
        _ = self;
    }

    pub fn colAttributes(self: *Statement) !void {
        _ = self;
    }

    pub fn primaryKeys(self: *Statement) !void {
        _ = self;
    }

    pub fn foreignKeys(self: *Statement) !void {
        _ = self;
    }

    pub fn statistics(self: *Statement) !void {
        _ = self;
    }

    pub fn procedures(self: *Statement) !void {
        _ = self;
    }

    pub fn procedureColumns(self: *Statement) !void {
        _ = self;
    }

    pub fn getFunctions(self: *Statement) !void {
        _ = self;
    }

    pub fn cancel(self: *Statement) !void {
        _ = self;
    }

    pub fn endTran(self: *Statement) !void {
        _ = self;
    }

    pub fn describeParam(self: *Statement) !void {
        _ = self;
    }

    pub fn prepare(self: *Statement, stmt_str: []const u8) !void {
        return switch (sql.SQLPrepare(self.handle(), stmt_str)) {
            .SUCCESS, .SUCCESS_WITH_INFO => {},
            .ERR => PrepareError.Error,
            .INVALID_HANDLE => PrepareError.InvalidHandle,
        };
    }

    pub fn numResultCols(self: *Statement) !i32 {
        var column_count: i32 = 0;
        return switch (sql.SQLNumResultCols(self.handle(), &column_count)) {
            .SUCCESS => column_count,
            .ERR => NumResultColsError.Error,
            .INVALID_HANDLE => NumResultColsError.InvalidHandle,
            .STILL_EXECUTING => NumResultColsError.StillExecuting,
        };
    }

    pub fn describeCol(
        self: *Statement,
        col_number: c_ushort,
        col_desc: *types.ColDescription,
    ) !void {
        switch (sql.SQLDescribeCol(
            self.handle(),
            col_number,
            col_desc,
        )) {
            .SUCCESS => {},
            .ERR => {
                const lastError = self.getLastError();
                std.debug.print("lastError: {}\n", .{lastError});
                return DescribeColError.Error;
            },
            .INVALID_HANDLE => return DescribeColError.InvalidHandle,
            // .STILL_EXECUTING => return DescribeColError.StillExecuting,
        }
    }

    pub fn getCursorName() void {}

    pub fn setCursorName(self: *Statement) !void {
        _ = self;
    }

    pub fn setPos(self: *Statement) !void {
        _ = self;
    }

    pub fn execute(self: *Statement) !void {
        return switch (sql.SQLExecute(self.handle())) {
            .SUCCESS, .SUCCESS_WITH_INFO => {},
            .ERR => ExecuteError.Error,
            .INVALID_HANDLE => ExecuteError.InvalidHandle,
            .NEED_DATA => ExecuteError.NeedData,
            .NO_DATA_FOUND => ExecuteError.NoDataFound,
        };
    }

    pub fn execDirect(self: *Statement) !void {
        _ = self;
    }

    pub fn bindCol(self: *Statement) !void {
        _ = self;
    }

    pub fn bindFileToCol(self: *Statement) !void {
        _ = self;
    }

    pub fn bindFileToParam(self: *Statement) !void {
        _ = self;
    }

    pub fn bindParameter(self: *Statement) !void {
        _ = self;
    }

    pub fn setStmtAttr(self: *Statement) !void {
        _ = self;
    }

    pub fn getStmtAttr(self: *Statement) !void {
        _ = self;
    }

    pub fn moreResults(self: *Statement) !void {
        _ = self;
    }

    pub fn fetchScroll(
        self: *Statement,
        orientation: types.FetchOrientation,
        offset: i64,
    ) !void {
        return switch (sql.SQLFetchScroll(
            self.handle(),
            orientation,
            offset,
        )) {
            .SUCCESS, .SUCCESS_WITH_INFO => {},
            .ERR => FetchScrollError.Error,
            .INVALID_HANDLE => FetchScrollError.InvalidHandle,
            // .NEED_DATA => FetchScrollError.NeedData,
            // .NO_DATA_FOUND => FetchScrollError.NoDataFound,
        };
    }

    pub fn describeColumns(self: *Statement) !void {
        _ = self;
    }
};
