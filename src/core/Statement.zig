const std = @import("std");
const testing = std.testing;

const err = @import("errors.zig");
const Handle = @import("Handle.zig");
const Environment = @import("Environment.zig");
const Connection = @import("Connection.zig");

const odbc = @import("odbc");
const attrs = odbc.attributes;
const types = odbc.types;
const sql = odbc.sql;

const Attribute = attrs.StatementAttribute;
const AttributeValue = attrs.StatementAttributeValue;
const AttributeValueFoo = attrs.StatementAttributeValueFoo;

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

pub fn setPos(
    self: Self,
    offset: usize,
    operation: types.SetPosOperation,
    lock: types.Lock,
) !void {
    return switch (sql.SQLSetPos(
        self.handle(),
        offset,
        operation,
        lock,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return BindColError.Error;
        },
        .INVALID_HANDLE => SetPosError.InvalidHandle,
        .NEED_DATA => SetPosError.NeedData,
        .STILL_EXECUTING => SetPosError.StillExecuting,
    };
}

pub fn execute(self: Self) !void {
    return switch (sql.SQLExecute(self.handle())) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return ExecuteError.Error;
        },
        .INVALID_HANDLE => ExecuteError.InvalidHandle,
        .NEED_DATA => ExecuteError.NeedData,
        .NO_DATA_FOUND => ExecuteError.NoDataFound,
    };
}

pub fn execDirect(self: Self, stmt_str: []const u8) !void {
    return switch (sql.SQLExecDirect(
        self.handle(),
        stmt_str,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return ExecDirectError.Error;
        },
        .INVALID_HANDLE => ExecDirectError.InvalidHandle,
        .NEED_DATA => ExecDirectError.NeedData,
        .NO_DATA_FOUND => ExecDirectError.NoDataFound,
    };
}

pub fn rowCount(self: Self) !isize {
    var row_count: isize = 0;
    return switch (sql.SQLRowCount(
        self.handle(),
        &row_count,
    )) {
        .SUCCESS => @intCast(row_count),
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return RowCountError.Error;
        },
        .INVALID_HANDLE => RowCountError.InvalidHandle,
    };
}

pub fn getStmtAttr(self: Self, attr: Attribute) !AttributeValueFoo {
    var value: i32 = undefined;

    return switch (sql.SQLGetStmtAttr(
        self.handle(),
        attr,
        &value,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => AttributeValueFoo.fromAttribute(attr, value),
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return GetStmtAttrError.Error;
        },
        .INVALID_HANDLE => GetStmtAttrError.InvalidHandle,
    };
}
pub fn getStmtAttr2(
    self: Self,
    allocator: std.mem.Allocator,
    attr: Attribute,
    odbc_buf: []u8,
) !AttributeValue {
    var str_len: i32 = undefined;

    return switch (sql.SQLGetStmtAttr2(
        self.handle(),
        attr,
        odbc_buf.ptr,
        @intCast(odbc_buf.len),
        &str_len,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => AttributeValue.init(allocator, attr, odbc_buf, str_len),
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return GetStmtAttrError.Error;
        },
        .INVALID_HANDLE => GetStmtAttrError.InvalidHandle,
    };
}

pub fn setStmtAttr(
    self: Self,
    attr_value: AttributeValue,
) !void {
    return switch (sql.SQLSetStmtAttr(
        self.handle(),
        attr_value.getActiveTag(),
        attr_value.getValue(),
        attr_value.getStrLen(),
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return SetStmtAttrError.Error;
        },
        .INVALID_HANDLE => SetStmtAttrError.InvalidHandle,
    };
}

pub fn moreResults(self: Self) !bool {
    return switch (sql.SQLMoreResults(self.handle())) {
        .SUCCESS, .SUCCESS_WITH_INFO => true,
        .NO_DATA_FOUND => false,
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return MoreResultsError.Error;
        },
        .INVALID_HANDLE => MoreResultsError.InvalidHandle,
    };
}

pub fn fetch(self: Self) !void {
    return switch (sql.SQLFetch(self.handle())) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return FetchError.Error;
        },
        .INVALID_HANDLE => FetchError.InvalidHandle,
        .NO_DATA_FOUND => FetchError.NoDataFound,
    };
}

pub fn fetchScroll(
    self: Self,
    orientation: types.FetchOrientation,
    offset: usize,
) !void {
    return switch (sql.SQLFetchScroll(
        self.handle(),
        orientation,
        offset,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return FetchScrollError.Error;
        },
        .INVALID_HANDLE => FetchScrollError.InvalidHandle,
        .NO_DATA_FOUND => FetchScrollError.NoDataFound,
    };
}

pub fn describeColumns(self: Self) !void {
    _ = self;
}

pub const GetStmtAttrError = error{
    Error,
    InvalidHandle,
};

pub const SetStmtAttrError = error{
    Error,
    InvalidHandle,
};

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

pub const ExecDirectError = error{
    Error,
    InvalidHandle,
    NeedData,
    NoDataFound,
};

pub const RowCountError = error{
    Error,
    InvalidHandle,
};

pub const MoreResultsError = error{
    Error,
    InvalidHandle,
};

pub const SetPosError = error{
    Error,
    InvalidHandle,
    NeedData,
    StillExecuting,
};

pub const FetchError = error{
    Error,
    InvalidHandle,
    NoDataFound,
};

pub const FetchScrollError = error{
    Error,
    InvalidHandle,
    NoDataFound,
};

test "init/1 returns an error when called without an established connection" {
    const env = try Environment.init(.V3);
    defer env.deinit();
    const con = try Connection.init(env);
    defer con.deinit();

    try testing.expectError(
        err.AllocError.Error,
        Self.init(con),
    );
}
