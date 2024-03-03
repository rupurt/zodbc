const std = @import("std");

const Environment = @import("Environment.zig");
const Handle = @import("Handle.zig");

const odbc = @import("odbc");
const info = odbc.info;
const attrs = odbc.attributes;
const sql = odbc.sql;

const InfoType = info.InfoType;
const InfoTypeValue = info.InfoTypeValue;
const Attribute = attrs.ConnectionAttribute;
const AttributeValue = attrs.ConnectionAttributeValue;

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

pub fn getInfo(self: Self, info_type: InfoType) !InfoTypeValue {
    var value = InfoTypeValue{ .info_type = info_type };

    return switch (sql.SQLGetInfo(
        self.handle(),
        info_type,
        &value.buf,
        value.buf.len,
        &value.str_len,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => {
            // std.debug.print("value={any}\n", .{value.buf});
            // std.debug.print("len={d}\n", .{value.str_len});
            return value;
        },
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return GetInfoError.Error;
        },
        .INVALID_HANDLE => GetInfoError.InvalidHandle,
    };
}

pub fn getConnectAttr(self: Self, attr: Attribute) !AttributeValue {
    var value: i32 = undefined;

    return switch (sql.SQLGetConnectAttr(
        self.handle(),
        attr,
        &value,
    )) {
        .SUCCESS, .SUCCESS_WITH_INFO => AttributeValue.fromAttribute(attr, value),
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return GetConnectAttrError.Error;
        },
        .INVALID_HANDLE => GetConnectAttrError.InvalidHandle,
        .NO_DATA => GetConnectAttrError.NoData,
    };
}

pub fn setConnectAttr(
    self: Self,
    attr: AttributeValue,
    value: *anyopaque,
) !void {
    return switch (sql.SQLSetConnectAttr(
        self.handle(),
        attr,
        value,
    )) {
        .SUCCESS => {},
        .ERR => {
            const lastError = self.getLastError();
            std.debug.print("lastError: {}\n", .{lastError});
            return SetConnectAttrError.Error;
        },
        .INVALID_HANDLE => SetConnectAttrError.InvalidHandle,
    };
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

pub const GetInfoError = error{
    Error,
    InvalidHandle,
};

pub const GetConnectAttrError = error{
    Error,
    InvalidHandle,
    NoData,
};

pub const SetConnectAttrError = error{
    Error,
    InvalidHandle,
};
