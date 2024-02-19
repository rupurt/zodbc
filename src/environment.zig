const std = @import("std");

const errors = @import("errors.zig");
const SetEnvAttrError = errors.SetEnvAttrError;

const handle = @import("handle.zig");
const Handle = handle.Handle;

const odbc = @import("odbc");
const rc = odbc.return_codes;
const types = odbc.types;
const sql = odbc.sql;

pub const Environment = struct {
    handler: Handle,

    pub fn init(allocator: std.mem.Allocator, odbc_version: types.OdbcVersion) !*Environment {
        const handler = try Handle.init(.ENV, null);

        const env = try allocator.create(Environment);
        env.* = .{ .handler = handler };

        return switch (sql.SQLSetEnvAttr(
            env.handle(),
            .ODBC_VERSION,
            @ptrFromInt(@intFromEnum(odbc_version)),
            0,
        )) {
            .SUCCESS, .SUCCESS_WITH_INFO => env,
            .ERR => SetEnvAttrError.Error,
        };
        // return switch (env.setEnvAttr(
        //     .ODBC_VERSION,
        //     @ptrFromInt(@intFromEnum(odbc_version)),
        //     0,
        // )) {
        //     .SUCCESS, .SUCCESS_WITH_INFO => env,
        //     .ERR => SetEnvAttrError.Error,
        // };
    }

    pub fn deinit(self: *Environment) rc.FreeHandleRC {
        return self.handler.deinit();
    }

    pub fn handle(self: *Environment) ?*anyopaque {
        return self.handler.handle;
    }

    pub fn getSQLCA(self: *Environment) !void {
        _ = self;
    }

    pub fn setEnvAttr(
        self: *Environment,
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
};
