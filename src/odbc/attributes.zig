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

//
// Connection
//

/// The integer codes for ODBC compliant connection attributes
pub const ConnectionAttribute = enum(c_int) {
    // ODBC spec
    ConnectionDead = c.SQL_ATTR_CONNECTION_DEAD,
    DriverThreading = c.SQL_ATTR_DRIVER_THREADING,
    // ODBC spec >= 3.0
    AccessMode = c.SQL_ATTR_ACCESS_MODE,
    Autocommit = c.SQL_ATTR_AUTOCOMMIT,
    ConnectionTimeout = c.SQL_ATTR_CONNECTION_TIMEOUT,
    // CurrentCatalog = c.SQL_ATTR_CURRENT_CATALOG,
    DisconnectBehavior = c.SQL_ATTR_DISCONNECT_BEHAVIOR,
    EnlistInDtc = c.SQL_ATTR_ENLIST_IN_DTC,
    // EnlistInXa = c.SQL_ATTR_ENLIST_IN_XA,
    LoginTimeout = c.SQL_ATTR_LOGIN_TIMEOUT,
    OdbcCursors = c.SQL_ATTR_ODBC_CURSORS,
    PacketSize = c.SQL_ATTR_PACKET_SIZE,
    // QuietMode = c.SQL_ATTR_QUIET_MODE,
    Trace = c.SQL_ATTR_TRACE,
    // TraceFile = c.SQL_ATTR_TRACEFILE,
    // TranslateLib = c.SQL_ATTR_TRANSLATE_LIB,
    // TranslateOption = c.SQL_ATTR_TRANSLATE_OPTION,
    TxnIsolation = c.SQL_ATTR_TXN_ISOLATION,
    // ODBC spec >= 3.51
    AnsiApp = c.SQL_ATTR_ANSI_APP,
    AsyncEnable = c.SQL_ATTR_ASYNC_ENABLE,
    AutoIpd = c.SQL_ATTR_AUTO_IPD,
    // ODBC spec >= 3.80
    ResetConnection = c.SQL_ATTR_RESET_CONNECTION,
    AsyncDbcFunctionsEnable = c.SQL_ATTR_ASYNC_DBC_FUNCTIONS_ENABLE,
    // Not sure what this group should be?
    // IBM Db2 specific additions
    // - https://www.ibm.com/docs/en/db2-for-zos/13?topic=functions-sqlsetconnectattr-set-connection-attributes
    // https://github.com/strongloop-forks/node-ibm_db/blob/master/deps/db2cli/include/sqlcli1.h#L690
    // ClientTimeZone = c.SQL_ATTR_CLIENT_TIME_ZONE,
    // ConcurrentAccessResolution = c.SQL_ATTR_CONCURRENT_ACCESS_RESOLUTION,
    // Connecttype = c.SQL_ATTR_CONNECTTYPE,
    // CurrentSchema = c.SQL_ATTR_CURRENT_SCHEMA,
    // Db2Explain = c.SQL_ATTR_DB2_EXPLAIN,
    // DecfloatRoundingMode = c.SQL_ATTR_DECFLOAT_ROUNDING_MODE,
    // ExtendedIndicators = c.SQL_ATTR_EXTENDED_INDICATORS,
    // InfoAcctstr = c.SQL_ATTR_INFO_ACCTSTR,
    // InfoApplname = c.SQL_ATTR_INFO_APPLNAME,
    // InfoUserid = c.SQL_ATTR_INFO_USERID,
    // InfoWrkstnname = c.SQL_ATTR_INFO_WRKSTNNAME,
    // KeepDynamic = c.SQL_ATTR_KEEP_DYNAMIC,
    // Maxconn = c.SQL_ATTR_MAXCONN,
    // MetadataId = c.SQL_ATTR_METADATA_ID,
    // SessionTimeZone = c.SQL_ATTR_SESSION_TIME_ZONE,
    // SyncPoint = c.SQL_ATTR_SYNC_POINT,
    // FetBufSize = c.SQL_ATTR_FET_BUF_SIZE,
    FetBufSize = 3001,
};

pub const ConnectionAttributeValue = union(ConnectionAttribute) {
    ConnectionDead: ConnectionDead,
    DriverThreading: u16,
    AccessMode: AccessMode,
    Autocommit: Autocommit,
    ConnectionTimeout: u32,
    // CurrentCatalog: CurrentCatalog,
    DisconnectBehavior: DisconnectBehavior,
    EnlistInDtc: EnlistInDtc,
    // EnlistInXa: EnlistInXa,
    LoginTimeout: u32,
    OdbcCursors: OdbcCursors,
    PacketSize: u32,
    // QuietMode: QuietMode,
    Trace: Trace,
    // TraceFile: []const u8,
    // TranslateLib: []const u8,
    // TranslateOption: []const u8,
    TxnIsolation: TxnIsolation,
    AnsiApp: AnsiApp,
    AsyncEnable: AsyncEnable,
    AutoIpd: AutoIpd,
    ResetConnection: ResetConnection,
    AsyncDbcFunctionsEnable: AsyncDbcFunctionsEnable,
    FetBufSize: u32,

    pub fn init(
        allocator: std.mem.Allocator,
        attr: ConnectionAttribute,
        odbc_buf: []u8,
        str_len: i32,
    ) !ConnectionAttributeValue {
        _ = str_len;
        _ = allocator;
        return switch (attr) {
            .ConnectionDead => .{ .ConnectionDead = @enumFromInt(readInt(i64, odbc_buf)) },
            .DriverThreading => .{ .DriverThreading = readInt(u16, odbc_buf) },
            .AccessMode => .{ .AccessMode = @enumFromInt(readInt(i32, odbc_buf)) },
            .Autocommit => .{ .Autocommit = @enumFromInt(readInt(u64, odbc_buf)) },
            .ConnectionTimeout => .{ .ConnectionTimeout = readInt(u32, odbc_buf) },
            // .CurrentCatalog => .{ .CurrentCatalog = readInt(u32, odbc_buf) },
            .DisconnectBehavior => .{ .TxnIsolation = @enumFromInt(readInt(i64, odbc_buf)) },
            .EnlistInDtc => .{ .EnlistInDtc = @enumFromInt(readInt(u32, odbc_buf)) },
            // .EnlistInXa => .{ .EnlistInXa = @enumFromInt(readInt(u32, odbc_buf)) },
            .LoginTimeout => .{ .LoginTimeout = readInt(u32, odbc_buf) },
            .OdbcCursors => .{ .OdbcCursors = @enumFromInt(readInt(u32, odbc_buf)) },
            .PacketSize => .{ .PacketSize = readInt(u32, odbc_buf) },
            // .QuietMode => .{ .QuietMode = readInt(u32, odbc_buf) },
            .Trace => .{ .Trace = @enumFromInt(readInt(u32, odbc_buf)) },
            // .TraceFile => {
            //     const str = try allocator.alloc(u8, @intCast(str_len));
            //     @memcpy(str, odbc_buf[0..@intCast(str_len)]);
            //     return .{ .TraceFile = str[0..] };
            // },
            // .TranslateLib => {
            //     const str = try allocator.alloc(u8, @intCast(str_len));
            //     @memcpy(str, odbc_buf[0..@intCast(str_len)]);
            //     return .{ .TranslateLib = str[0..] };
            // },
            // .TranslateOption => {
            //     const str = try allocator.alloc(u8, @intCast(str_len));
            //     @memcpy(str, odbc_buf[0..@intCast(str_len)]);
            //     return .{ .TranslateOption = str[0..] };
            // },
            .TxnIsolation => .{ .TxnIsolation = @enumFromInt(readInt(u32, odbc_buf)) },
            .AnsiApp => .{ .AnsiApp = @enumFromInt(readInt(u32, odbc_buf)) },
            .AsyncEnable => .{ .AsyncEnable = @enumFromInt(readInt(u32, odbc_buf)) },
            .AutoIpd => .{ .AutoIpd = @enumFromInt(readInt(u32, odbc_buf)) },
            .ResetConnection => .{ .ResetConnection = @enumFromInt(readInt(u32, odbc_buf)) },
            .AsyncDbcFunctionsEnable => .{ .AsyncDbcFunctionsEnable = @enumFromInt(readInt(u32, odbc_buf)) },
            .FetBufSize => .{ .FetBufSize = readInt(u32, odbc_buf) },
        };
    }

    pub fn deinit(
        self: ConnectionAttributeValue,
        allocator: std.mem.Allocator,
    ) void {
        _ = allocator;
        _ = self;
        // return switch (self) {
        //     .OdbcVersion, .ConnectionPooling, .CpMatch, .OutputNts => {},
        //     .UnixodbcSyspath => |v| allocator.free(v),
        // };
    }

    pub fn getActiveTag(self: ConnectionAttributeValue) ConnectionAttribute {
        return std.meta.activeTag(self);
    }

    pub fn getValue(self: ConnectionAttributeValue) *allowzero anyopaque {
        return switch (self) {
            // .UnixodbcSyspath, .UnixodbcVersion, .UnixodbcEnvattr => |v| @ptrCast(@constCast(v)),
            .ConnectionDead => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            .DriverThreading => |v| @ptrFromInt(@as(usize, v)),
            .AccessMode => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            .Autocommit => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .ConnectionTimeout => |v| @ptrFromInt(@as(usize, v)),
            .DisconnectBehavior => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .EnlistInDtc => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // .EnlisttInXa => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .LoginTimeout => |v| @ptrFromInt(@as(usize, v)),
            .OdbcCursors => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .PacketSize => |v| @ptrFromInt(@as(usize, v)),
            // .QuietMode => |v| @ptrFromInt(@as(usize, v)),
            .Trace => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .TxnIsolation => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            .AnsiApp => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            .AsyncEnable => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .AutoIpd => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            .ResetConnection => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            .AsyncDbcFunctionsEnable => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            .FetBufSize => |v| @ptrFromInt(@as(usize, v)),
        };
    }

    pub fn getStrLen(self: ConnectionAttributeValue) i32 {
        return switch (self) {
            .ConnectionDead,
            .DriverThreading,
            .AccessMode,
            .Autocommit,
            .ConnectionTimeout,
            .DisconnectBehavior,
            .EnlistInDtc,
            // .EnlisttInXa,
            .LoginTimeout,
            .OdbcCursors,
            .PacketSize,
            // .QuietMode,
            .Trace,
            .TxnIsolation,
            .AnsiApp,
            .AutoIpd,
            .ResetConnection,
            .AsyncDbcFunctionsEnable,
            .FetBufSize,
            => 0,
            // .CurrentCatalog, .TraceFile, .TranslateLib, .TranslateOption => |v| @intCast(v.len),
            else => 1,
        };
    }

    pub const ConnectionDead = enum(c_long) {
        True = c.SQL_CD_TRUE,
        False = c.SQL_CD_FALSE,
    };

    pub const AccessMode = enum(c_int) {
        ReadWrite = c.SQL_MODE_READ_WRITE,
        ReadOnly = c.SQL_MODE_READ_ONLY,
    };

    pub const Autocommit = enum(c_ulong) {
        Off = c.SQL_AUTOCOMMIT_OFF,
        On = c.SQL_AUTOCOMMIT_ON,
    };

    pub const DisconnectBehavior = enum(c_ulong) {
        ReturnToPool = c.SQL_DB_RETURN_TO_POOL,
        Disconnect = c.SQL_DB_DISCONNECT,
    };

    pub const EnlistInDtc = enum(c_long) {
        EnlistExpensive = c.SQL_DTC_ENLIST_EXPENSIVE,
        UnenlistExpensive = c.SQL_DTC_UNENLIST_EXPENSIVE,
    };

    pub const OdbcCursors = enum(c_ulong) {
        IfNeeded = c.SQL_CUR_USE_IF_NEEDED,
        UseOdbc = c.SQL_CUR_USE_ODBC,
        UseDriver = c.SQL_CUR_USE_DRIVER,
    };

    pub const Trace = enum(c_ulong) {
        Off = c.SQL_OPT_TRACE_OFF,
        On = c.SQL_OPT_TRACE_ON,
    };

    pub const TxnIsolation = enum(c_long) {
        ReadUncommitted = c.SQL_TXN_READ_UNCOMMITTED,
        ReadCommitted = c.SQL_TRANSACTION_READ_COMMITTED,
        RepeatableRead = c.SQL_TXN_REPEATABLE_READ,
        Serializable = c.SQL_TXN_SERIALIZABLE,
    };

    pub const AnsiApp = enum(c_long) {
        True = c.SQL_AA_TRUE,
        False = c.SQL_AA_FALSE,
    };

    pub const AsyncEnable = enum(c_ulong) {
        Off = c.SQL_ASYNC_ENABLE_OFF,
        On = c.SQL_ASYNC_ENABLE_ON,
    };

    pub const AutoIpd = enum(c_int) {
        True = c.SQL_TRUE,
        False = c.SQL_FALSE,
    };

    pub const ResetConnection = enum(c_ulong) {
        Yes = c.SQL_RESET_CONNECTION_YES,
    };

    pub const AsyncDbcFunctionsEnable = enum(c_int) {
        On = c.SQL_ASYNC_DBC_ENABLE_ON,
        Off = c.SQL_ASYNC_DBC_ENABLE_OFF,
    };
};
