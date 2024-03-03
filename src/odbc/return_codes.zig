pub const c = @cImport({
    @cInclude("sql.h");
    @cInclude("sqltypes.h");
    @cInclude("sqlext.h");
});

pub const AllocHandleRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
};

pub const FreeHandleRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
};

pub const GetEnvAttrRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
};

pub const SetEnvAttrRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
};

pub const SetConnectAttrRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
};

pub const DriverConnectRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
    NO_DATA_FOUND = c.SQL_NO_DATA_FOUND,
};

pub const SetStatementAttrRC = enum(c.SQLRETURN) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
};

pub const ColumnsRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
};

pub const PrepareRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
};

pub const NumResultColsRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
    STILL_EXECUTING = c.SQL_STILL_EXECUTING,
};

pub const DescribeColRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
    // TODO:
    // - can this be an error state???
    // STILL_EXECUTING = c.SQL_STILL_EXECUTING,
};

pub const BindColRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
};

pub const ExecuteRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
    NEED_DATA = c.SQL_NEED_DATA,
    NO_DATA_FOUND = c.SQL_NO_DATA_FOUND,
};

pub const FetchRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
    NO_DATA_FOUND = c.SQL_NO_DATA_FOUND,
};

pub const FetchScrollRC = enum(c_short) {
    SUCCESS = c.SQL_SUCCESS,
    SUCCESS_WITH_INFO = c.SQL_SUCCESS_WITH_INFO,
    ERR = c.SQL_ERROR,
    INVALID_HANDLE = c.SQL_INVALID_HANDLE,
    // NEED_DATA = c.SQL_NEED_DATA,
    // NO_DATA_FOUND = c.SQL_NO_DATA_FOUND,
};
