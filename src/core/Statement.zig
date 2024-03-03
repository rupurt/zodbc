const std = @import("std");
const testing = std.testing;

const err = @import("errors.zig");
const Handle = @import("Handle.zig");
const Environment = @import("Environment.zig");
const Connection = @import("Connection.zig");

const odbc = @import("odbc");
const rc = odbc.return_codes;
const types = odbc.types;
const sql = odbc.sql;

const Self = @This();

handler: Handle,

pub fn init(con: Connection) !Self {
    const handler = try Handle.init(.STMT, con.handle());
    return .{ .handler = handler };
}

pub fn deinit(self: Self) void {
    self.handler.deinit();
}

pub fn handle(self: Self) ?*anyopaque {
    return self.handler.handle;
}

pub fn getLastError(self: Self) sql.LastError {
    return self.handler.getLastError();
}

pub fn disconnect(self: Self) !void {
    _ = self;
}

pub fn dataSources(self: Self) !void {
    _ = self;
}

pub fn tables(self: Self) !void {
    _ = self;
}

pub fn tablePrivileges(self: Self) !void {
    _ = self;
}

pub fn specialColumns(self: Self) !void {
    _ = self;
}

pub fn columns(
    self: Self,
    catalog_name: []const u8,
    schema_name: []const u8,
    table_name: []const u8,
    column_name: []const u8,
) !void {
    return switch (sql.SQLColumns(
        self.handle(),
        catalog_name,
        schema_name,
        table_name,
        column_name,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => ColumnsError.Error,
        .INVALID_HANDLE => ColumnsError.InvalidHandle,
    };
}

pub fn columnPrivileges(self: Self) !void {
    _ = self;
}

pub fn colAttribute(self: Self) !void {
    _ = self;
}

pub fn colAttributes(self: Self) !void {
    _ = self;
}

pub fn primaryKeys(self: Self) !void {
    _ = self;
}

pub fn foreignKeys(self: Self) !void {
    _ = self;
}

pub fn statistics(self: Self) !void {
    _ = self;
}

pub fn procedures(self: Self) !void {
    _ = self;
}

pub fn procedureColumns(self: Self) !void {
    _ = self;
}

pub fn getFunctions(self: Self) !void {
    _ = self;
}

pub fn cancel(self: Self) !void {
    _ = self;
}

pub fn endTran(self: Self) !void {
    _ = self;
}

pub fn describeParam(self: Self) !void {
    _ = self;
}

pub fn prepare(self: Self, stmt_str: []const u8) !void {
    return switch (sql.SQLPrepare(self.handle(), stmt_str)) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => PrepareError.Error,
        .INVALID_HANDLE => PrepareError.InvalidHandle,
    };
}

pub fn numResultCols(self: Self) !usize {
    var column_count: usize = 0;
    return switch (sql.SQLNumResultCols(self.handle(), &column_count)) {
        .SUCCESS => column_count,
        .ERR => NumResultColsError.Error,
        .INVALID_HANDLE => NumResultColsError.InvalidHandle,
        .STILL_EXECUTING => NumResultColsError.StillExecuting,
    };
}

pub fn describeCol(
    self: Self,
    col_number: usize,
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

pub fn bindCol(
    self: Self,
    col_number: c_ushort,
    col: *types.Column,
) !void {
    return switch (sql.SQLBindCol(
        self.handle(),
        col_number,
        col,
    )) {
        .SUCCESS => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return BindColError.Error;
        },
        .INVALID_HANDLE => BindColError.InvalidHandle,
    };
}

pub fn bindFileToCol(self: Self) !void {
    _ = self;
}

pub fn bindFileToParam(self: Self) !void {
    _ = self;
}

pub fn bindParameter(self: Self) !void {
    _ = self;
}

pub fn getCursorName(self: Self) void {
    _ = self;
}

pub fn setCursorName(self: Self) !void {
    _ = self;
}

pub fn setPos(self: Self) !void {
    _ = self;
}

pub fn execute(self: Self) !void {
    return switch (sql.SQLExecute(self.handle())) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => ExecuteError.Error,
        .INVALID_HANDLE => ExecuteError.InvalidHandle,
        .NEED_DATA => ExecuteError.NeedData,
        .NO_DATA_FOUND => ExecuteError.NoDataFound,
    };
}

pub fn execDirect(self: Self) !void {
    _ = self;
}

pub fn setStmtAttr(self: Self) !void {
    _ = self;
}

pub fn getStmtAttr(self: Self) !void {
    _ = self;
}

pub fn moreResults(self: Self) !void {
    _ = self;
}

pub fn fetch(self: Self) !void {
    return switch (sql.SQLFetch(self.handle())) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => FetchError.Error,
        .INVALID_HANDLE => FetchError.InvalidHandle,
        .NO_DATA_FOUND => FetchError.NoDataFound,
    };
}

pub fn fetchScroll(
    self: Self,
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

pub fn describeColumns(self: Self) !void {
    _ = self;
}

pub const ColumnsError = error{
    Error,
    InvalidHandle,
};

pub const PrepareError = error{
    Error,
    InvalidHandle,
};

pub const NumResultColsError = error{
    Error,
    InvalidHandle,
    StillExecuting,
};

pub const DescribeColError = error{
    Error,
    InvalidHandle,
    // StillExecuting,
};

pub const BindColError = error{
    Error,
    InvalidHandle,
};

pub const ExecuteError = error{
    Error,
    InvalidHandle,
    NeedData,
    NoDataFound,
};

pub const FetchError = error{
    Error,
    InvalidHandle,
    NoDataFound,
};

pub const FetchScrollError = error{
    Error,
    InvalidHandle,
    // NeedData,
    // NoDataFound,
};

test ".init/1 returns an error when called without an established connection" {
    const env = try Environment.init(.V3_80);
    defer env.deinit();
    const con = try Connection.init(env);
    defer con.deinit();

    try testing.expectError(
        err.AllocError.Error,
        Self.init(con),
    );
}
