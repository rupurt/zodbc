const std = @import("std");

const errors = @import("errors.zig");
const Handle = @import("Handle.zig");

const odbc = @import("odbc");
const rc = odbc.return_codes;
const types = odbc.types;
const sql = odbc.sql;

const Self = @This();

handler: Handle,

pub fn init(odbc_version: types.OdbcVersion) !Self {
    const handler = try Handle.init(.ENV, null);
    const env = Self{ .handler = handler };

    return switch (sql.SQLSetEnvAttr(
        env.handle(),
        .ODBC_VERSION,
        @ptrFromInt(@intFromEnum(odbc_version)),
        0,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => env,
        .ERR => SetEnvAttrError.Error,
    };
}

pub fn deinit(self: Self) void {
    self.handler.deinit();
}

pub fn handle(self: Self) ?*anyopaque {
    return self.handler.handle;
}

pub fn getSQLCA(self: Self) !void {
    _ = self;
}

pub fn setEnvAttr(
    self: Self,
    attr: types.SetEnvAttrAttribute,
    value: *anyopaque,
    // TODO:
    // - have can I make this argument optional??
    // - variadic??
    str_len: c_int,
) !void {
    return switch (sql.SQLSetEnvAttr(
        self.handle(),
        attr,
        // @ptrFromInt(@intFromEnum(OdbcVersion.v3_80)),
        value,
        // 0,
        str_len,
    )) {
        .ERR => SetEnvAttrError.Error,
        else => {},
    };
}

pub const SetEnvAttrError = error{
    Error,
};
