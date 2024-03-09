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

//
// Statement
//

/// The integer codes for ODBC compliant statement attributes
pub const StatementAttribute = enum(c_int) {
    // NOTE:
    // - attributes from unixODBC headers
    // // Statement attributes for ODBC 3.0
    // ASYNC_ENABLE = c.SQL_ATTR_ASYNC_ENABLE,
    // ENABLE_AUTO_IPD = c.SQL_ATTR_ENABLE_AUTO_IPD,
    // FETCH_BOOKMARK_PTR = c.SQL_ATTR_FETCH_BOOKMARK_PTR,
    // KEYSET_SIZE = c.SQL_ATTR_KEYSET_SIZE,
    // MAX_ROWS = c.SQL_ATTR_MAX_ROWS,
    // PARAM_BIND_OFFSET_PTR = c.SQL_ATTR_PARAM_BIND_OFFSET_PTR,
    // PARAM_BIND_TYPE = c.SQL_ATTR_PARAM_BIND_TYPE,
    // PARAM_OPERATION_PTR = c.SQL_ATTR_PARAM_OPERATION_PTR,
    // PARAM_STATUS_PTR = c.SQL_ATTR_PARAM_STATUS_PTR,
    // QUERY_TIMEOUT = c.SQL_ATTR_QUERY_TIMEOUT,
    // ROW_BIND_OFFSET_PTR = c.SQL_ATTR_ROW_BIND_OFFSET_PTR,
    // ROW_OPERATION_PTR = c.SQL_ATTR_ROW_OPERATION_PTR,
    // SIMULATE_CURSOR = c.SQL_ATTR_SIMULATE_CURSOR,
    // // Statement attributes for ODBC >= 3.80
    // ASYNC_STMT_EVENT = c.SQL_ATTR_ASYNC_STMT_EVENT,
    // // TODO:
    // // - not sure what this group should be?
    // // APP_ROW_DESC = c.SQL_ATTR_APP_ROW_DESC,
    // // APP_PARAM_DESC = c.SQL_ATTR_APP_PARAM_DESC,
    // // IMP_ROW_DESC = c.SQL_ATTR_IMP_ROW_DESC,
    // // IMP_PARAM_DESC = c.SQL_ATTR_IMP_PARAM_DESC,

    // ODBC spec 3.0
    RowBindType = c.SQL_ATTR_ROW_BIND_TYPE,
    Concurrency = c.SQL_ATTR_CONCURRENCY,
    CursorScrollable = c.SQL_ATTR_CURSOR_SCROLLABLE,
    CursorSensitivity = c.SQL_ATTR_CURSOR_SENSITIVITY,
    CursorType = c.SQL_ATTR_CURSOR_TYPE,
    MaxLength = c.SQL_ATTR_MAX_LENGTH,
    MaxRows = c.SQL_ATTR_MAX_ROWS,
    ParamsetSize = c.SQL_ATTR_PARAMSET_SIZE,
    ParamsProcessedPtr = c.SQL_ATTR_PARAMS_PROCESSED_PTR,
    RetrieveData = c.SQL_ATTR_RETRIEVE_DATA,
    RowArraySize = c.SQL_ATTR_ROW_ARRAY_SIZE,
    RowNumber = c.SQL_ATTR_ROW_NUMBER,
    RowStatusPtr = c.SQL_ATTR_ROW_STATUS_PTR,
    RowsFetchedPtr = c.SQL_ATTR_ROWS_FETCHED_PTR,
    TxnIsolation = c.SQL_ATTR_TXN_ISOLATION,
    UseBookmark = c.SQL_ATTR_USE_BOOKMARKS,
    // IBM Db2 specific additions
    // - https://www.ibm.com/docs/en/db2-for-zos/12?topic=functions-sqlsetstmtattr-set-statement-attributes
    // BindType = c.SQL_ATTR_BIND_TYPE,
    // CcsidChar = c.SQL_CCSID_CHAR,
    // CcsidGraphic = c.SQL_CCSID_GRAPHIC,
    // ClientTimeZone = c.SQL_ATTR_CLIENT_TIME_ZONE,
    // CloseBehavior = c.SQL_ATTR_CLOSE_BEHAVIOR,
    // CursorHold = c.SQL_ATTR_CURSOR_HOLD,
    // Nodescribe = c.SQL_ATTR_NODESCRIBE,
    // Noscan = c.SQL_ATTR_NOSCAN,
    // ParamoptAtomic = c.SQL_ATTR_PARAMOPT_ATOMIC,
    // RowOperationPointer = c.SQL_ATTR_ROW_OPERATION_POINTER,
    // RowsetSize = c.SQL_ATTR_ROWSET_SIZE,
    // StmttxnIsolation = c.SQL_ATTR_STMTTXN_ISOLATION,
};

pub const StatementAttributeValueFoo = union(StatementAttribute) {
    RowBindType: RowBindType,
    Concurrency: Concurrency,
    CursorScrollable: CursorScrollable,
    CursorSensitivity: CursorSensitivity,
    CursorType: CursorType,
    MaxLength: usize,
    MaxRows: usize,
    ParamsetSize: usize,
    ParamsProcessedPtr: *isize,
    RetrieveData: RetrieveData,
    RowArraySize: usize,
    RowNumber: usize,
    RowStatusPtr: *isize,
    RowsFetchedPtr: *isize,
    TxnIsolation: TxnIsolation,
    UseBookmark: UseBookmark,

    pub fn fromAttribute(attr: StatementAttribute, value: isize) StatementAttributeValueFoo {
        return switch (attr) {
            .RowBindType => .{ .RowBindType = @enumFromInt(value) },
            .Concurrency => .{ .Concurrency = @enumFromInt(value) },
            .CursorScrollable => .{ .CursorScrollable = @enumFromInt(value) },
            .CursorSensitivity => .{ .CursorSensitivity = @enumFromInt(value) },
            .CursorType => .{ .CursorType = @enumFromInt(value) },
            .MaxLength => .{ .MaxLength = @intCast(value) },
            .MaxRows => .{ .MaxRows = @intCast(value) },
            .ParamsetSize => .{ .ParamsetSize = @intCast(value) },
            .ParamsProcessedPtr => .{ .ParamsProcessedPtr = @ptrCast(@constCast(&value)) },
            .RetrieveData => .{ .RetrieveData = @enumFromInt(value) },
            .RowArraySize => .{ .RowArraySize = @intCast(value) },
            .RowNumber => .{ .RowNumber = @intCast(value) },
            .RowStatusPtr => .{ .RowStatusPtr = @ptrCast(@constCast(&value)) },
            .RowsFetchedPtr => .{ .RowsFetchedPtr = @ptrCast(@constCast(&value)) },
            .TxnIsolation => .{ .TxnIsolation = @enumFromInt(value) },
            .UseBookmark => .{ .UseBookmark = @enumFromInt(value) },
        };
    }

    pub fn activeTag(self: StatementAttributeValueFoo) StatementAttribute {
        return std.meta.activeTag(self);
    }

    pub fn getValue(self: StatementAttributeValueFoo) usize {
        return switch (self) {
            .RowBindType => |v| @as(usize, @intCast(@intFromEnum(v))),
            .Concurrency => |v| @as(usize, @intCast(@intFromEnum(v))),
            .CursorScrollable => |v| @as(usize, @intCast(@intFromEnum(v))),
            .CursorSensitivity => |v| @as(usize, @intCast(@intFromEnum(v))),
            .CursorType => |v| @as(usize, @intCast(@intFromEnum(v))),
            .MaxLength => |v| @as(usize, @intCast(@intFromEnum(v))),
            .MaxRows => |v| @as(usize, @intCast(@intFromEnum(v))),
            .ParamsetSize => |v| @as(usize, @intCast(@intFromEnum(v))),
            .ParamsProcessedPtr => |v| @as(usize, @intCast(@intFromEnum(v))),
            .RetrieveData => |v| @as(usize, @intCast(@intFromEnum(v))),
            .RowArraySize => |v| @as(usize, @intCast(@intFromEnum(v))),
            .RowNumber => |v| @as(usize, @intCast(@intFromEnum(v))),
            .RowStatusPtr => |v| @as(usize, @intCast(@intFromEnum(v))),
            .RowsFetchedPtr => |v| @as(usize, @intCast(@intFromEnum(v))),
            .TxnIsolation => |v| @as(usize, @intCast(@intFromEnum(v))),
            .UseBookmark => |v| @as(usize, @intCast(@intFromEnum(v))),
        };
    }

    pub const RowBindType = enum(c_ulong) {
        Column = c.SQL_BIND_BY_COLUMN,
    };

    pub const Concurrency = enum(c_int) {
        ReadOnly = c.SQL_CONCUR_READ_ONLY,
        Lock = c.SQL_CONCUR_LOCK,
    };

    pub const CursorScrollable = enum(c_int) {
        NonScrollable = c.SQL_NONSCROLLABLE,
        Scrollable = c.SQL_SCROLLABLE,
    };

    pub const CursorSensitivity = enum(c_int) {
        Unspecified = c.SQL_UNSPECIFIED,
        Insensitive = c.SQL_INSENSITIVE,
        Sensitive = c.SQL_SENSITIVE,
    };

    pub const CursorType = enum(c_ulong) {
        ForwardOnly = c.SQL_CURSOR_FORWARD_ONLY,
        Static = c.SQL_CURSOR_STATIC,
        Dynamic = c.SQL_CURSOR_DYNAMIC,
    };

    pub const RetrieveData = enum(c_ulong) {
        On = c.SQL_RD_ON,
        Off = c.SQL_RD_OFF,
    };

    pub const TxnIsolation = enum(c_long) {
        ReadUncommitted = c.SQL_TXN_READ_UNCOMMITTED,
        ReadCommitted = c.SQL_TRANSACTION_READ_COMMITTED,
        RepeatableRead = c.SQL_TXN_REPEATABLE_READ,
        Serializable = c.SQL_TXN_SERIALIZABLE,
    };

    pub const UseBookmark = enum(c_ulong) {
        Off = c.SQL_UB_OFF,
        Variable = c.SQL_UB_VARIABLE,
    };
};

pub const StatementAttributeValue = union(StatementAttribute) {
    RowBindType: u64,
    Concurrency: Concurrency,
    CursorScrollable: CursorScrollable,
    CursorSensitivity: CursorSensitivity,
    CursorType: CursorType,
    MaxLength: usize,
    MaxRows: usize,
    ParamsetSize: usize,
    ParamsProcessedPtr: *isize,
    RetrieveData: RetrieveData,
    RowArraySize: usize,
    RowNumber: usize,
    RowStatusPtr: *isize,
    RowsFetchedPtr: *isize,
    TxnIsolation: TxnIsolation,
    UseBookmark: UseBookmark,

    pub fn init(
        allocator: std.mem.Allocator,
        attr: StatementAttribute,
        odbc_buf: []u8,
        str_len: i32,
    ) !StatementAttributeValue {
        _ = str_len;
        _ = allocator;
        return switch (attr) {
            // .UnixodbcSyspath => {
            //     const str = try allocator.alloc(u8, @intCast(str_len));
            //     @memcpy(str, odbc_buf[0..@intCast(str_len)]);
            //     return .{ .UnixodbcSyspath = str[0..] };
            // },
            .RowBindType => .{ .RowBindType = readInt(u64, odbc_buf) },
            .Concurrency => .{ .Concurrency = @enumFromInt(readInt(u32, odbc_buf)) },
            .CursorScrollable => .{ .CursorScrollable = @enumFromInt(readInt(u32, odbc_buf)) },
            .CursorSensitivity => .{ .CursorSensitivity = @enumFromInt(readInt(u32, odbc_buf)) },
            .CursorType => .{ .CursorType = @enumFromInt(readInt(u32, odbc_buf)) },
            .MaxLength => .{ .MaxLength = readInt(u32, odbc_buf) },
            .MaxRows => .{ .MaxRows = readInt(u32, odbc_buf) },
            .ParamsetSize => .{ .ParamsetSize = readInt(u32, odbc_buf) },
            .ParamsProcessedPtr => .{ .ParamsProcessedPtr = @ptrFromInt(readInt(u32, odbc_buf)) },
            .RetrieveData => .{ .RetrieveData = @enumFromInt(readInt(u32, odbc_buf)) },
            .RowArraySize => .{ .RowArraySize = readInt(u32, odbc_buf) },
            .RowNumber => .{ .RowNumber = readInt(u32, odbc_buf) },
            .RowStatusPtr => .{ .RowStatusPtr = @ptrFromInt(readInt(u32, odbc_buf)) },
            .RowsFetchedPtr => .{ .RowsFetchedPtr = @ptrFromInt(readInt(u32, odbc_buf)) },
            .TxnIsolation => .{ .TxnIsolation = @enumFromInt(readInt(u32, odbc_buf)) },
            .UseBookmark => .{ .UseBookmark = @enumFromInt(readInt(u32, odbc_buf)) },
        };
    }

    pub fn deinit(
        self: StatementAttributeValue,
        allocator: std.mem.Allocator,
    ) void {
        _ = allocator;
        return switch (self) {
            // .UnixodbcSyspath => |v| allocator.free(v),
            else => {},
        };
    }

    pub fn getActiveTag(self: StatementAttributeValue) StatementAttribute {
        return std.meta.activeTag(self);
    }

    pub fn getValue(self: StatementAttributeValue) *allowzero anyopaque {
        return switch (self) {
            // .UnixodbcSyspath, .UnixodbcVersion, .UnixodbcEnvattr => |v| @ptrCast(@constCast(v)),
            // .ConnectionDead => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // .DriverThreading => |v| @ptrFromInt(@as(usize, v)),
            // .AccessMode => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // .Autocommit => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            // .ConnectionTimeout => |v| @ptrFromInt(@as(usize, v)),
            // .DisconnectBehavior => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            // .EnlistInDtc => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // // .EnlisttInXa => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            // .LoginTimeout => |v| @ptrFromInt(@as(usize, v)),
            // .OdbcCursors => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            // .PacketSize => |v| @ptrFromInt(@as(usize, v)),
            // // .QuietMode => |v| @ptrFromInt(@as(usize, v)),
            // .Trace => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            // .TxnIsolation => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // .AnsiApp => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // .AsyncEnable => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            // .AutoIpd => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // .ResetConnection => |v| @ptrFromInt(@as(usize, @intFromEnum(v))),
            // .AsyncDbcFunctionsEnable => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            // .FetBufSize => |v| @ptrFromInt(@as(usize, v)),
            .RowBindType => |v| @ptrFromInt(@as(usize, v)),
            .Concurrency => |v| @ptrFromInt(@as(usize, @intCast(@intFromEnum(v)))),
            else => @ptrFromInt(1),
        };
    }

    pub fn getStrLen(self: StatementAttributeValue) i32 {
        return switch (self) {
            .RowBindType,
            .Concurrency,
            => 0,
            // .CurrentCatalog => |v| @intCast(v.len),
            else => 1,
        };
    }

    pub const Concurrency = enum(c_int) {
        ReadOnly = c.SQL_CONCUR_READ_ONLY,
        Lock = c.SQL_CONCUR_LOCK,
    };

    pub const CursorScrollable = enum(c_int) {
        NonScrollable = c.SQL_NONSCROLLABLE,
        Scrollable = c.SQL_SCROLLABLE,
    };

    pub const CursorSensitivity = enum(c_int) {
        Unspecified = c.SQL_UNSPECIFIED,
        Insensitive = c.SQL_INSENSITIVE,
        Sensitive = c.SQL_SENSITIVE,
    };

    pub const CursorType = enum(c_ulong) {
        ForwardOnly = c.SQL_CURSOR_FORWARD_ONLY,
        Static = c.SQL_CURSOR_STATIC,
        Dynamic = c.SQL_CURSOR_DYNAMIC,
    };

    pub const RetrieveData = enum(c_ulong) {
        On = c.SQL_RD_ON,
        Off = c.SQL_RD_OFF,
    };

    pub const TxnIsolation = enum(c_long) {
        ReadUncommitted = c.SQL_TXN_READ_UNCOMMITTED,
        ReadCommitted = c.SQL_TRANSACTION_READ_COMMITTED,
        RepeatableRead = c.SQL_TXN_REPEATABLE_READ,
        Serializable = c.SQL_TXN_SERIALIZABLE,
    };

    pub const UseBookmark = enum(c_ulong) {
        Off = c.SQL_UB_OFF,
        Variable = c.SQL_UB_VARIABLE,
    };
};

pub const bind_by_column = c.SQL_BIND_BY_COLUMN;
