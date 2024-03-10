const std = @import("std");

const mem = @import("mem.zig");
const readInt = mem.readInt;

pub const c = @cImport({
    @cInclude("sql.h");
    @cInclude("sqltypes.h");
    @cInclude("sqlext.h");
});

//
// Environment
//

/// The integer codes for ODBC compliant environment attributes
pub const EnvironmentAttribute = enum(c_int) {
    // ODBC spec
    OdbcVersion = c.SQL_ATTR_ODBC_VERSION,
    OutputNts = c.SQL_ATTR_OUTPUT_NTS,
    ConnectionPooling = c.SQL_ATTR_CONNECTION_POOLING,
    CpMatch = c.SQL_ATTR_CP_MATCH,
    // unixODBC additions
    UnixodbcSyspath = c.SQL_ATTR_UNIXODBC_SYSPATH,
    UnixodbcVersion = c.SQL_ATTR_UNIXODBC_VERSION,
    UnixodbcEnvattr = c.SQL_ATTR_UNIXODBC_ENVATTR,
    // IBM Db2 specific additions
    // - https://www.ibm.com/docs/en/db2-for-zos/11?topic=functions-sqlsetenvattr-set-environment-attributes
    // InfoAcctstr = c.SQL_ATTR_INFO_ACCTSTR,
    // InfoApplname = c.SQL_ATTR_INFO_APPLNAME,
    // InfoUserid = c.SQL_ATTR_INFO_USERID,
    // InfoWrkstnname = c.SQL_ATTR_INFO_WRKSTNNAME,
    // InfoConnecttype = c.SQL_ATTR_INFO_CONNECTTYPE,
    // InfoMaxconn = c.SQL_ATTR_INFO_MAXCONN,
};

pub const EnvironmentAttributeValue = union(EnvironmentAttribute) {
    OdbcVersion: OdbcVersion,
    OutputNts: OutputNts,
    ConnectionPooling: ConnectionPooling,
    CpMatch: CpMatch,
    UnixodbcSyspath: []const u8,
    UnixodbcVersion: []const u8,
    UnixodbcEnvattr: []const u8,

    pub fn init(
        allocator: std.mem.Allocator,
        attr: EnvironmentAttribute,
        odbc_buf: []u8,
        str_len: i32,
    ) !EnvironmentAttributeValue {
        return switch (attr) {
            .OdbcVersion => .{ .OdbcVersion = @enumFromInt(readInt(u32, odbc_buf)) },
            .ConnectionPooling => .{ .ConnectionPooling = @enumFromInt(readInt(u32, odbc_buf)) },
            .CpMatch => .{ .CpMatch = @enumFromInt(readInt(u32, odbc_buf)) },
            .OutputNts => .{ .OutputNts = @enumFromInt(readInt(u32, odbc_buf)) },
            .UnixodbcSyspath => {
                const str = try allocator.alloc(u8, @intCast(str_len));
                @memcpy(str, odbc_buf[0..@intCast(str_len)]);
                return .{ .UnixodbcSyspath = str[0..] };
            },
            .UnixodbcVersion => {
                const str = try allocator.alloc(u8, @intCast(str_len));
                @memcpy(str, odbc_buf[0..@intCast(str_len)]);
                return .{ .UnixodbcVersion = str[0..] };
            },
            .UnixodbcEnvattr => {
                const str = try allocator.alloc(u8, @intCast(str_len));
                @memcpy(str, odbc_buf[0..@intCast(str_len)]);
                return .{ .UnixodbcEnvattr = str[0..] };
            },
        };
    }

    pub fn deinit(
        self: EnvironmentAttributeValue,
        allocator: std.mem.Allocator,
    ) void {
        return switch (self) {
            .OdbcVersion, .ConnectionPooling, .CpMatch, .OutputNts => {},
            .UnixodbcSyspath => |v| allocator.free(v),
            .UnixodbcVersion => |v| allocator.free(v),
            .UnixodbcEnvattr => |v| allocator.free(v),
        };
    }

    pub fn getActiveTag(self: EnvironmentAttributeValue) EnvironmentAttribute {
        return std.meta.activeTag(self);
    }

    pub fn getValue(self: EnvironmentAttributeValue) *allowzero anyopaque {
        return switch (self) {
            .OdbcVersion => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .ConnectionPooling => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .CpMatch => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .OutputNts => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            .UnixodbcSyspath, .UnixodbcVersion, .UnixodbcEnvattr => |v| @ptrCast(@constCast(v)),
        };
    }

    pub fn getStrLen(self: EnvironmentAttributeValue) i32 {
        return switch (self) {
            .OdbcVersion, .OutputNts, .ConnectionPooling, .CpMatch => 0,
            .UnixodbcSyspath, .UnixodbcVersion, .UnixodbcEnvattr => |v| @intCast(v.len),
        };
    }

    pub const OdbcVersion = enum(c_ulong) {
        V2 = c.SQL_OV_ODBC2,
        V3 = c.SQL_OV_ODBC3,
        V3_80 = c.SQL_OV_ODBC3_80,
    };

    pub const OutputNts = enum(c_int) {
        True = c.SQL_TRUE,
        False = c.SQL_FALSE,
    };

    pub const ConnectionPooling = enum(c_ulong) {
        Off = c.SQL_CP_OFF,
        OnePerDriver = c.SQL_CP_ONE_PER_DRIVER,
        OnePerHenv = c.SQL_CP_ONE_PER_HENV,
    };

    pub const CpMatch = enum(c_ulong) {
        StrictMatch = c.SQL_CP_STRICT_MATCH,
        RelaxedMatch = c.SQL_CP_RELAXED_MATCH,
    };
};
