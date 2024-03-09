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

//
// Connection
//

/// The integer codes for ODBC compliant connection attributes
pub const ConnectionAttribute = enum(c_int) {
    // ODBC spec 3.0
    AccessMode = c.SQL_ATTR_ACCESS_MODE,
    Autocommit = c.SQL_ATTR_AUTOCOMMIT,
    TxnIsolation = c.SQL_ATTR_TXN_ISOLATION,
    ConnectionTimeout = c.SQL_ATTR_CONNECTION_TIMEOUT,
    // CurrentCatalog = c.SQL_ATTR_CURRENT_CATALOG,
    // DisconnectBehavior = c.SQL_ATTR_DISCONNECT_BEHAVIOR,
    // EnlistInDtc = c.SQL_ATTR_ENLIST_IN_DTC,
    // EnlistInXa = c.SQL_ATTR_ENLIST_IN_XA,
    LoginTimeout = c.SQL_ATTR_LOGIN_TIMEOUT,
    OdbcCursors = c.SQL_ATTR_ODBC_CURSORS,
    PacketSize = c.SQL_ATTR_PACKET_SIZE,
    // QuietMode = c.SQL_ATTR_QUIET_MODE,
    Trace = c.SQL_ATTR_TRACE,
    // Tracefile = c.SQL_ATTR_TRACEFILE,
    // TranslateLib = c.SQL_ATTR_TRANSLATE_LIB,
    // TranslateOption = c.SQL_ATTR_TRANSLATE_OPTION,
    // ODBC spec >= 3.0
    // AutoIpd = c.SQL_ATTR_AUTO_IPD,
    // MetadataId = c.SQL_ATTR_METADATA_ID,
    // ConnectionDead = c.SQL_ATTR_CONNECTION_DEAD,
    // DriverThreading = c.SQL_ATTR_DRIVER_THREADING,
    // Not sure what this group should be?
    // AnsiApp = c.SQL_ATTR_ANSI_APP,
    // ResetConnection = c.SQL_ATTR_RESET_CONNECTION,
    AsyncEnable = c.SQL_ATTR_ASYNC_ENABLE,
    // AsyncDbcFunctionsEnable = c.SQL_ATTR_ASYNC_DBC_FUNCTIONS_ENABLE,
    // IBM Db2 specific additions
    // - https://www.ibm.com/docs/en/db2-for-zos/13?topic=functions-sqlsetconnectattr-set-connection-attributes
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
    // SessionTimeZone = c.SQL_ATTR_SESSION_TIME_ZONE,
    // SyncPoint = c.SQL_ATTR_SYNC_POINT,
    // FetBufSize = c.SQL_ATTR_FET_BUF_SIZE,
};

pub const ConnectionAttributeValue = union(ConnectionAttribute) {
    AccessMode: AccessMode,
    Autocommit: Autocommit,
    TxnIsolation: TxnIsolation,
    ConnectionTimeout: usize,
    // DisconnectBehavior: DisconnectBehavior,
    // EnlistInDtc: EnlistInDtc,
    LoginTimeout: usize,
    OdbcCursors: OdbcCursors,
    PacketSize: usize,
    Trace: Trace,
    // DriverThreading: DriverThreading,
    AsyncEnable: AsyncEnable,

    pub fn fromAttribute(attr: ConnectionAttribute, value: isize) ConnectionAttributeValue {
        return switch (attr) {
            .AccessMode => .{ .AccessMode = @enumFromInt(value) },
            .Autocommit => .{ .Autocommit = @enumFromInt(value) },
            .TxnIsolation => .{ .TxnIsolation = @enumFromInt(value) },
            .ConnectionTimeout => .{ .ConnectionTimeout = @intCast(value) },
            // .DisconnectBehavior => .{ .TxnIsolation = @enumFromInt(value) },
            // .EnlistInDtc => .{ .EnlistInDtc = @enumFromInt(value) },
            .LoginTimeout => .{ .LoginTimeout = @intCast(value) },
            .OdbcCursors => .{ .OdbcCursors = @enumFromInt(value) },
            .PacketSize => .{ .PacketSize = @intCast(value) },
            .Trace => .{ .Trace = @enumFromInt(value) },
            // .DriverThreading => .{ .DriverThreading = @enumFromInt(value) },
            .AsyncEnable => .{ .AsyncEnable = @enumFromInt(value) },
        };
    }

    pub fn activeTag(self: ConnectionAttributeValue) ConnectionAttribute {
        return std.meta.activeTag(self);
    }

    pub fn getValue(self: ConnectionAttributeValue) usize {
        return switch (self) {
            .AccessMode => |v| @as(usize, @intCast(@intFromEnum(v))),
            .Autocommit => |v| @as(usize, @intCast(@intFromEnum(v))),
            .TxnIsolation => |v| @as(usize, @intCast(@intFromEnum(v))),
            .ConnectionTimeout => |v| @as(usize, @intCast(@intFromEnum(v))),
            // .DisconnectBehavior => |v| @as(usize, @intCast(@intFromEnum(v))),
            // .EnlistInDtc => |v| @as(usize, @intCast(@intFromEnum(v))),
            .LoginTimeout => |v| @as(usize, @intCast(@intFromEnum(v))),
            .OdbcCursors => |v| @as(usize, @intCast(@intFromEnum(v))),
            .PacketSize => |v| @as(usize, @intCast(@intFromEnum(v))),
            .Trace => |v| @as(usize, @intCast(@intFromEnum(v))),
            // .DriverThreading => |v| @as(usize, @intCast(@intFromEnum(v))),
            .AsyncEnable => |v| @as(usize, @intCast(@intFromEnum(v))),
        };
    }

    pub const AccessMode = enum(c_int) {
        ReadWrite = c.SQL_MODE_READ_WRITE,
        ReadOnly = c.SQL_MODE_READ_ONLY,
    };

    pub const Autocommit = enum(c_ulong) {
        Off = c.SQL_AUTOCOMMIT_OFF,
        On = c.SQL_AUTOCOMMIT_ON,
    };

    pub const TxnIsolation = enum(c_long) {
        ReadUncommitted = c.SQL_TXN_READ_UNCOMMITTED,
        ReadCommitted = c.SQL_TRANSACTION_READ_COMMITTED,
        RepeatableRead = c.SQL_TXN_REPEATABLE_READ,
        Serializable = c.SQL_TXN_SERIALIZABLE,
    };

    // pub const DisconnectBehavior = enum(c_long) {
    //     ReadUncommitted = c.SQL_TXN_READ_UNCOMMITTED,
    //     ReadCommitted = c.SQL_TRANSACTION_READ_COMMITTED,
    //     RepeatableRead = c.SQL_TXN_REPEATABLE_READ,
    //     Serializable = c.SQL_TXN_SERIALIZABLE,
    // };

    // pub const EnlistInDtc = enum(c_long) {
    //     EnlistExpensive = c.SQL_DTC_ENLIST_EXPENSIVE,
    //     UnenlistExpensive = c.SQL_DTC_UNENLIST_EXPENSIVE,
    // };

    pub const OdbcCursors = enum(c_ulong) {
        IfNeeded = c.SQL_CUR_USE_IF_NEEDED,
        UseOdbc = c.SQL_CUR_USE_ODBC,
        UseDriver = c.SQL_CUR_USE_DRIVER,
    };

    pub const Trace = enum(c_ulong) {
        Off = c.SQL_OPT_TRACE_OFF,
        On = c.SQL_OPT_TRACE_ON,
    };

    // pub const DriverThreading = enum(c_ulong) {
    //     Off = c.SQL_OPT_TRACE_OFF,
    //     On = c.SQL_OPT_TRACE_ON,
    // };

    pub const AsyncEnable = enum(c_ulong) {
        Off = c.SQL_ASYNC_ENABLE_OFF,
        On = c.SQL_ASYNC_ENABLE_ON,
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

pub const StatementAttributeValue = union(StatementAttribute) {
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

    pub fn fromAttribute(attr: StatementAttribute, value: isize) StatementAttributeValue {
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

    pub fn activeTag(self: StatementAttributeValue) StatementAttribute {
        return std.meta.activeTag(self);
    }

    pub fn getValue(self: StatementAttributeValue) usize {
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
