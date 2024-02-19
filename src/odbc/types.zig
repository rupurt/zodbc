const std = @import("std");

pub const c = @cImport({
    @cInclude("sql.h");
    @cInclude("sqltypes.h");
    @cInclude("sqlext.h");
});

pub const HandleType = enum(c_short) {
    ENV = c.SQL_HANDLE_ENV,
    DBC = c.SQL_HANDLE_DBC,
    STMT = c.SQL_HANDLE_STMT,
    DESC = c.SQL_HANDLE_DESC,
};

pub const SetEnvAttrAttribute = enum(c_int) {
    // Environment attributes for ODBC
    ODBC_VERSION = c.SQL_ATTR_ODBC_VERSION,
    OUTPUT_NTS = c.SQL_ATTR_OUTPUT_NTS,
    CONNECTION_POOLING = c.SQL_ATTR_CONNECTION_POOLING,
    CP_MATCH = c.SQL_ATTR_CP_MATCH,
    // unixODBC additions
    UNIXODBC_SYSPATH = c.SQL_ATTR_UNIXODBC_SYSPATH,
    UNIXODBC_VERSION = c.SQL_ATTR_UNIXODBC_VERSION,
    UNIXODBC_ENVATTR = c.SQL_ATTR_UNIXODBC_ENVATTR,
    // IBM specific additions
    // - https://www.ibm.com/docs/en/db2-for-zos/11?topic=functions-sqlsetenvattr-set-environment-attributes
    // CONNECTTYPE = c.SQL_ATTR_CONNECTTYPE,
    // MAXCONN = c.SQL_ATTR_MAXCONN,
};

pub const OdbcVersion = enum(c_ulong) {
    v2 = c.SQL_OV_ODBC2,
    v3 = c.SQL_OV_ODBC3,
    v3_80 = c.SQL_OV_ODBC3_80,
};

pub const SetConnectAttrAttribute = enum(c_int) {
    // Connection attributes for ODBC 3.0
    ACCESS_MODE = c.SQL_ATTR_ACCESS_MODE,
    AUTOCOMMIT = c.SQL_ATTR_AUTOCOMMIT,
    CONNECTION_TIMEOUT = c.SQL_ATTR_CONNECTION_TIMEOUT,
    CURRENT_CATALOG = c.SQL_ATTR_CURRENT_CATALOG,
    DISCONNECT_BEHAVIOR = c.SQL_ATTR_DISCONNECT_BEHAVIOR,
    ENLIST_IN_DTC = c.SQL_ATTR_ENLIST_IN_DTC,
    ENLIST_IN_XA = c.SQL_ATTR_ENLIST_IN_XA,
    LOGIN_TIMEOUT = c.SQL_ATTR_LOGIN_TIMEOUT,
    ODBC_CURSORS = c.SQL_ATTR_ODBC_CURSORS,
    PACKET_SIZE = c.SQL_ATTR_PACKET_SIZE,
    QUIET_MODE = c.SQL_ATTR_QUIET_MODE,
    TRACE = c.SQL_ATTR_TRACE,
    TRACEFILE = c.SQL_ATTR_TRACEFILE,
    TRANSLATE_LIB = c.SQL_ATTR_TRANSLATE_LIB,
    TRANSLATE_OPTION = c.SQL_ATTR_TRANSLATE_OPTION,
    TXN_ISOLATION = c.SQL_ATTR_TXN_ISOLATION,
    // Connection attributes for ODBC >= 3.0
    AUTO_IPD = c.SQL_ATTR_AUTO_IPD,
    METADATA_ID = c.SQL_ATTR_METADATA_ID,
    // GetConnectAttr only
    CONNECTION_DEAD = c.SQL_ATTR_CONNECTION_DEAD,
    // Driver threading level
    DRIVER_THREADING = c.SQL_ATTR_DRIVER_THREADING,
    // TODO:
    // - not sure what this group should be?
    ANSI_APP = c.SQL_ATTR_ANSI_APP,
    RESET_CONNECTION = c.SQL_ATTR_RESET_CONNECTION,
    ASYNC_DBC_FUNCTIONS_ENABLE = c.SQL_ATTR_ASYNC_DBC_FUNCTIONS_ENABLE,
};

pub const SetStatementAttrAttribute = enum(c_int) {
    // Statement attributes for ODBC 3.0
    ASYNC_ENABLE = c.SQL_ATTR_ASYNC_ENABLE,
    CONCURRENCY = c.SQL_ATTR_CONCURRENCY,
    CURSOR_TYPE = c.SQL_ATTR_CURSOR_TYPE,
    ENABLE_AUTO_IPD = c.SQL_ATTR_ENABLE_AUTO_IPD,
    FETCH_BOOKMARK_PTR = c.SQL_ATTR_FETCH_BOOKMARK_PTR,
    KEYSET_SIZE = c.SQL_ATTR_KEYSET_SIZE,
    MAX_LENGTH = c.SQL_ATTR_MAX_LENGTH,
    MAX_ROWS = c.SQL_ATTR_MAX_ROWS,
    NOSCAN = c.SQL_ATTR_NOSCAN,
    PARAM_BIND_OFFSET_PTR = c.SQL_ATTR_PARAM_BIND_OFFSET_PTR,
    PARAM_BIND_TYPE = c.SQL_ATTR_PARAM_BIND_TYPE,
    PARAM_OPERATION_PTR = c.SQL_ATTR_PARAM_OPERATION_PTR,
    PARAM_STATUS_PTR = c.SQL_ATTR_PARAM_STATUS_PTR,
    PARAMS_PROCESSED_PTR = c.SQL_ATTR_PARAMS_PROCESSED_PTR,
    PARAMSET_SIZE = c.SQL_ATTR_PARAMSET_SIZE,
    QUERY_TIMEOUT = c.SQL_ATTR_QUERY_TIMEOUT,
    RETRIEVE_DATA = c.SQL_ATTR_RETRIEVE_DATA,
    ROW_BIND_OFFSET_PTR = c.SQL_ATTR_ROW_BIND_OFFSET_PTR,
    ROW_BIND_TYPE = c.SQL_ATTR_ROW_BIND_TYPE,
    ROW_NUMBER = c.SQL_ATTR_ROW_NUMBER,
    ROW_OPERATION_PTR = c.SQL_ATTR_ROW_OPERATION_PTR,
    ROW_STATUS_PTR = c.SQL_ATTR_ROW_STATUS_PTR,
    ROWS_FETCHED_PTR = c.SQL_ATTR_ROWS_FETCHED_PTR,
    ROW_ARRAY_SIZE = c.SQL_ATTR_ROW_ARRAY_SIZE,
    SIMULATE_CURSOR = c.SQL_ATTR_SIMULATE_CURSOR,
    USE_BOOKMARKS = c.SQL_ATTR_USE_BOOKMARKS,
    // Statement attributes for ODBC >= 3.80
    ASYNC_STMT_EVENT = c.SQL_ATTR_ASYNC_STMT_EVENT,
    // TODO:
    // - not sure what this group should be?
    // APP_ROW_DESC = c.SQL_ATTR_APP_ROW_DESC,
    // APP_PARAM_DESC = c.SQL_ATTR_APP_PARAM_DESC,
    // IMP_ROW_DESC = c.SQL_ATTR_IMP_ROW_DESC,
    // IMP_PARAM_DESC = c.SQL_ATTR_IMP_PARAM_DESC,
    // CURSOR_SCROLLABLE = c.SQL_ATTR_CURSOR_SCROLLABLE,
    // CURSOR_SENSITIVITY = c.SQL_ATTR_CURSOR_SENSITIVITY,
};

pub const ColAttributes = enum(c_int) {
    // Subdefines for SQL_COLUMN_UPDATABLE
    READONLY = c.SQL_ATTR_READONLY,
    WRITE = c.SQL_ATTR_WRITE,
    READWRITE_UNKNOWN = c.SQL_ATTR_READWRITE_UNKNOWN,
};

pub const ColDescription = struct {
    name_buf: [256]u8,
    name_buf_len: c_short,
    data_type: c_short,
    column_size: u32,
    decimal_digits: c_short,
    nullable: c_short,

    pub fn init(allocator: std.mem.Allocator) !*ColDescription {
        const col_desc = try allocator.create(ColDescription);
        col_desc.* = .{
            .name_buf = undefined,
            .name_buf_len = -1,
            .data_type = -1,
            .column_size = 0,
            .decimal_digits = -1,
            .nullable = -1,
        };
        return col_desc;
    }
};

pub const FetchOrientation = enum(c_short) {
    NEXT = c.SQL_FETCH_NEXT,
    FIRST = c.SQL_FETCH_FIRST,
    LAST = c.SQL_FETCH_LAST,
    PRIOR = c.SQL_FETCH_PRIOR,
    ABSOLUTE = c.SQL_FETCH_ABSOLUTE,
    RELATIVE = c.SQL_FETCH_RELATIVE,
};
