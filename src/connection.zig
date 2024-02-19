const std = @import("std");

const errors = @import("errors.zig");
const DriverConnectError = errors.DriverConnectError;

const environment = @import("environment.zig");
const Environment = environment.Environment;

const handle = @import("handle.zig");
const Handle = handle.Handle;

const odbc = @import("odbc");
const rc = odbc.return_codes;
const sql = odbc.sql;

pub const Connection = struct {
    handler: Handle,

    pub fn init(allocator: std.mem.Allocator, env: *Environment) !*Connection {
        const handler = try Handle.init(.DBC, env.handle());

        const con = try allocator.create(Connection);
        con.* = .{ .handler = handler };
        return con;
    }

    pub fn deinit(self: *Connection) rc.FreeHandleRC {
        return self.handler.deinit();
    }

    pub fn handle(self: *Connection) ?*anyopaque {
        return self.handler.handle;
    }

    pub fn getLastError(self: *Connection) sql.LastError {
        return self.handler.getLastError();
    }

    pub fn connectWithString(self: *Connection, dsn: []const u8) !void {
        return switch (sql.SQLDriverConnect(self.handle(), dsn)) {
            .SUCCESS, .SUCCESS_WITH_INFO => {},
            .ERR => {
                const lastError = self.getLastError();
                std.debug.print("lastError: {}\n", .{lastError});
                return DriverConnectError.Error;
            },
            .INVALID_HANDLE => DriverConnectError.InvalidHandle,
            .NO_DATA_FOUND => DriverConnectError.NoDataFound,
        };
    }
};
