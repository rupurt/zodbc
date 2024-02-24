const odbc = @import("odbc");
const rc = odbc.return_codes;
const types = odbc.types;
const sql = odbc.sql;

const Self = @This();

handle_type: types.HandleType,
handle: ?*anyopaque,

pub fn init(handle_type: types.HandleType, input_handle: ?*anyopaque) !Self {
    var handler: Self = .{
        .handle_type = handle_type,
        .handle = null,
    };

    return switch (sql.SQLAllocHandle(
        handle_type,
        input_handle,
        &handler.handle,
    )) {
        .ERR => AllocError.Error,
        .INVALID_HANDLE => AllocError.InvalidHandle,
        else => handler,
    };
}

pub fn deinit(self: Self) void {
    _ = sql.SQLFreeHandle(self.handle_type, self.handle);
}

pub fn getLastError(self: Self) sql.LastError {
    return sql.getLastError(self.handle_type, self.handle);
}

pub const AllocError = error{
    Error,
    InvalidHandle,
};
