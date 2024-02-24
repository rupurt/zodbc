const std = @import("std");

const Environment = @import("Environment.zig");
const Handle = @import("Handle.zig");

const odbc = @import("odbc");
const rc = odbc.return_codes;
const sql = odbc.sql;

const Self = @This();

handler: Handle,

pub fn init(env: Environment) !Self {
    const handler = try Handle.init(.DBC, env.handle());
    return .{ .handler = handler };
}

pub fn deinit(self: *const Self) void {
    self.handler.deinit();
}

pub fn handle(self: *const Self) ?*anyopaque {
    return self.handler.handle;
}

pub fn getLastError(self: *const Self) sql.LastError {
    return self.handler.getLastError();
}

pub fn connectWithString(self: *const Self, dsn: []const u8) !void {
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

pub fn disconnect(self: *Self) void {
    _ = self;
}

pub const DriverConnectError = error{
    Error,
    InvalidHandle,
    NoDataFound,
};
