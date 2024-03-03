const std = @import("std");

const errors = @import("errors.zig");
const Handle = @import("Handle.zig");

const odbc = @import("odbc");
const attrs = odbc.attributes;
const sql = odbc.sql;

const Attribute = attrs.EnvironmentAttribute;
const AttributeValue = attrs.EnvironmentAttributeValue;

const Self = @This();

handler: Handle,

pub fn init(odbc_version: AttributeValue.OdbcVersion) !Self {
    const handler = try Handle.init(.ENV, null);
    const env = Self{ .handler = handler };
    try env.setEnvAttr(.{ .OdbcVersion = odbc_version });
    return env;
}

pub fn deinit(self: Self) void {
    self.handler.deinit();
}

pub fn handle(self: Self) ?*anyopaque {
    return self.handler.handle;
}

pub fn getLastError(self: *const Self) sql.LastError {
    return self.handler.getLastError();
}

pub fn getSQLCA(self: Self) !void {
    _ = self;
}

pub fn getEnvAttr(self: Self, attr: Attribute) !AttributeValue {
    var value: i32 = undefined;

    return switch (sql.SQLGetEnvAttr(
        self.handle(),
        attr,
        &value,
    )) {
        .SUCCESS => AttributeValue.fromAttribute(attr, value),
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return GetEnvAttrError.Error;
        },
        .INVALID_HANDLE => GetEnvAttrError.InvalidHandle,
    };
}

pub fn setEnvAttr(self: Self, attr: AttributeValue) !void {
    return switch (sql.SQLSetEnvAttr(
        self.handle(),
        attr.activeTag(),
        @ptrFromInt(attr.getValue()),
    )) {
        .SUCCESS => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return SetEnvAttrError.Error;
        },
        .INVALID_HANDLE => SetEnvAttrError.InvalidHandle,
    };
}

pub const GetEnvAttrError = error{
    Error,
    InvalidHandle,
};

pub const SetEnvAttrError = error{
    Error,
    InvalidHandle,
};
