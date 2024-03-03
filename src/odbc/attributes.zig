const std = @import("std");

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
    // UNIXODBC_SYSPATH = c.SQL_ATTR_UNIXODBC_SYSPATH,
    // UNIXODBC_VERSION = c.SQL_ATTR_UNIXODBC_VERSION,
    // UNIXODBC_ENVATTR = c.SQL_ATTR_UNIXODBC_ENVATTR,
    // IBM Db2 specific additions
    // - https://www.ibm.com/docs/en/db2-for-zos/11?topic=functions-sqlsetenvattr-set-environment-attributes
    // INFO_ACCTSTR = c.SQL_ATTR_INFO_ACCTSTR,
    // INFO_APPLNAME = c.SQL_ATTR_INFO_APPLNAME,
    // INFO_USERID = c.SQL_ATTR_INFO_USERID,
    // INFO_WRKSTNNAME = c.SQL_ATTR_INFO_WRKSTNNAME,
    // INFO_CONNECTTYPE = c.SQL_ATTR_INFO_CONNECTTYPE,
    // INFO_MAXCONN = c.SQL_ATTR_INFO_MAXCONN,

};

pub const EnvironmentAttributeValue = union(EnvironmentAttribute) {
    OdbcVersion: OdbcVersion,
    OutputNts: OutputNts,
    ConnectionPooling: ConnectionPooling,
    CpMatch: CpMatch,

    pub fn fromAttribute(attr: EnvironmentAttribute, value: isize) EnvironmentAttributeValue {
        return switch (attr) {
            .OdbcVersion => .{ .OdbcVersion = @enumFromInt(value) },
            .OutputNts => .{ .OutputNts = @enumFromInt(value) },
            .ConnectionPooling => .{ .ConnectionPooling = @enumFromInt(value) },
            .CpMatch => .{ .CpMatch = @enumFromInt(value) },
        };
    }

    pub fn activeTag(self: EnvironmentAttributeValue) EnvironmentAttribute {
        return std.meta.activeTag(self);
    }

    pub fn getValue(self: EnvironmentAttributeValue) usize {
        return switch (self) {
            .OdbcVersion => |v| @as(usize, @intCast(@intFromEnum(v))),
            .OutputNts => |v| @as(usize, @intCast(@intFromEnum(v))),
            .ConnectionPooling => |v| @as(usize, @intCast(@intFromEnum(v))),
            .CpMatch => |v| @as(usize, @intCast(@intFromEnum(v))),
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
