const odbc = @import("odbc");
const rc = odbc.return_codes;
const types = odbc.types;
const sql = odbc.sql;

pub const Handle = struct {
    handle_type: types.HandleType,
    handle: ?*anyopaque,

    pub fn init(handle_type: types.HandleType, input_handle: ?*anyopaque) !Handle {
        var handler: Handle = .{
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

    pub fn deinit(self: *Handle) rc.FreeHandleRC {
        return sql.SQLFreeHandle(self.handle_type, self.handle);
    }

    pub fn getLastError(self: Handle) sql.LastError {
        return sql.getLastError(self.handle_type, self.handle);
    }
};

pub const AllocError = error{
    Error,
    InvalidHandle,
};
