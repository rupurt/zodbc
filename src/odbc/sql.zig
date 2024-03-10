const std = @import("std");

pub const c = @cImport({
    @cInclude("sql.h");
    @cInclude("sqltypes.h");
    @cInclude("sqlext.h");
});

const types = @import("types.zig");
const info = @import("info.zig");
const attrs = @import("attributes.zig");
const rc = @import("return_codes.zig");

pub fn SQLAllocHandle(
    handle_type: types.HandleType,
    input_handle: ?*anyopaque,
    output_handle: *?*anyopaque,
) rc.AllocHandleRC {
    const return_code = c.SQLAllocHandle(
        @intFromEnum(handle_type),
        input_handle,
        @ptrCast(output_handle),
    );
    return @enumFromInt(return_code);
}

pub fn SQLFreeHandle(
    handle_type: types.HandleType,
    handle: ?*anyopaque,
) rc.FreeHandleRC {
    const return_code = c.SQLFreeHandle(@intFromEnum(handle_type), handle);
    return @enumFromInt(return_code);
}

pub fn SQLGetEnvAttr(
    handle: ?*anyopaque,
    attribute: attrs.EnvironmentAttribute,
    value: *anyopaque,
    buf_len: i32,
    str_len: *i32,
) rc.GetEnvAttrRC {
    const return_code = c.SQLGetEnvAttr(
        handle,
        @intFromEnum(attribute),
        value,
        buf_len,
        str_len,
    );
    return @enumFromInt(return_code);
}

pub fn SQLSetEnvAttr(
    handle: ?*anyopaque,
    attr: attrs.EnvironmentAttribute,
    value: *allowzero anyopaque,
    str_len: i32,
) rc.SetEnvAttrRC {
    const return_code = c.SQLSetEnvAttr(
        handle,
        @intFromEnum(attr),
        value,
        str_len,
    );
    return @enumFromInt(return_code);
}

pub fn SQLGetInfo(
    handle: ?*anyopaque,
    info_type: info.InfoType,
    value: *anyopaque,
    buf_len: i16,
    str_len: *i16,
) rc.GetInfoRC {
    const return_code = c.SQLGetInfo(
        handle,
        @intCast(@intFromEnum(info_type)),
        value,
        buf_len,
        str_len,
    );
    return @enumFromInt(return_code);
}

pub fn SQLGetConnectAttr(
    handle: ?*anyopaque,
    attr: attrs.ConnectionAttribute,
    value: *anyopaque,
    buf_len: i32,
    str_len: *i32,
) rc.GetConnectAttrRC {
    const return_code = c.SQLGetConnectAttr(
        handle,
        @intFromEnum(attr),
        value,
        buf_len,
        str_len,
    );
    return @enumFromInt(return_code);
}

pub fn SQLSetConnectAttr(
    handle: ?*anyopaque,
    attr: attrs.ConnectionAttribute,
    value: *allowzero anyopaque,
    str_len: i32,
) rc.SetConnectAttrRC {
    const return_code = c.SQLSetConnectAttr(
        handle,
        @intFromEnum(attr),
        value,
        str_len,
    );
    return @enumFromInt(return_code);
}

pub const MAX_DSN_LEN = 1024;

pub fn SQLDriverConnect(
    handle: ?*anyopaque,
    dsn: []const u8,
) rc.DriverConnectRC {
    // @note: We ignore the driver transformed dsn
    var con_str_out_buf: [MAX_DSN_LEN]u8 = undefined;
    var pcb_con_str_out: c_short = 0;
    const return_code = c.SQLDriverConnect(
        handle,
        null,
        @ptrCast(@constCast(dsn)),
        @intCast(dsn.len),
        con_str_out_buf[0..],
        con_str_out_buf.len,
        &pcb_con_str_out,
        c.SQL_DRIVER_NOPROMPT,
    );
    return @enumFromInt(return_code);
}

pub fn SQLColumns(
    handle: ?*anyopaque,
    catalog_name: []const u8,
    schema_name: []const u8,
    table_name: []const u8,
    column_name: []const u8,
) rc.ColumnsRC {
    var catalog_name_len: c_short = 0;
    if (!std.mem.eql(u8, catalog_name, "%")) {
        catalog_name_len = @intCast(catalog_name.len);
    }

    const return_code = c.SQLColumns(
        handle,
        @ptrCast(@constCast(catalog_name)),
        catalog_name_len,
        @ptrCast(@constCast(schema_name)),
        @intCast(schema_name.len),
        @ptrCast(@constCast(table_name)),
        @intCast(table_name.len),
        @ptrCast(@constCast(column_name)),
        @intCast(column_name.len),
    );
    return @enumFromInt(return_code);
}

pub fn SQLPrepare(
    handle: ?*anyopaque,
    stmt_str: []const u8,
) rc.PrepareRC {
    const return_code = c.SQLPrepare(
        handle,
        @ptrCast(@constCast(stmt_str)),
        @intCast(stmt_str.len),
    );
    return @enumFromInt(return_code);
}

pub fn SQLNumResultCols(
    handle: ?*anyopaque,
    column_count: *usize,
) rc.NumResultColsRC {
    const return_code = c.SQLNumResultCols(
        handle,
        @ptrCast(@alignCast(column_count)),
    );
    return @enumFromInt(return_code);
}

pub fn SQLDescribeCol(
    handle: ?*anyopaque,
    col_number: usize,
    col_desc: *types.ColDescription,
) rc.DescribeColRC {
    const return_code = c.SQLDescribeCol(
        handle,
        @intCast(col_number),
        @ptrCast(col_desc.name_buf),
        @intCast(col_desc.name_buf_len),
        @ptrCast(&col_desc.name_buf_len),
        @ptrCast(&col_desc.data_type),
        @ptrCast(@alignCast(&col_desc.column_size)),
        @ptrCast(&col_desc.decimal_digits),
        @ptrCast(&col_desc.nullable),
    );
    return @enumFromInt(return_code);
}

pub fn SQLBindCol(
    handle: ?*anyopaque,
    col_number: c_ushort,
    col: *types.Column,
) rc.BindColRC {
    const return_code = c.SQLBindCol(
        handle,
        @intCast(col_number),
        @intFromEnum(col.c_data_type),
        @ptrCast(col.buffer),
        @intCast(col.buffer.len),
        @ptrCast(&col.str_len_or_ind),
    );
    return @enumFromInt(return_code);
}

pub fn SQLExecute(
    handle: ?*anyopaque,
) rc.ExecuteRC {
    const return_code = c.SQLExecute(handle);
    return @enumFromInt(return_code);
}

pub fn SQLFetch(handle: ?*anyopaque) rc.FetchRC {
    const return_code = c.SQLFetch(handle);
    return @enumFromInt(return_code);
}

pub fn SQLFetchScroll(
    handle: ?*anyopaque,
    orientation: types.FetchOrientation,
    offset: i64,
) rc.FetchScrollRC {
    const return_code = c.SQLFetchScroll(
        handle,
        @intFromEnum(orientation),
        @intCast(offset),
    );
    return @enumFromInt(return_code);
}

// TODO:
// - handle errors in a cleaner way and but them in the correct files
pub const SqlState = enum {
    Success,
    GeneralWarning,
    CursorOperationConflict,
    DisconnectError,
    NullEliminated,
    StringRightTrunc,
    PrivilegeNotRevoked,
    PrivilegeNotGranted,
    InvalidConnectionStringAttr,
    ErrorInRow,
    OptionValueChanged,
    FetchBeforeFirstResultSet,
    FractionalTruncation,
    ErrorSavingFileDSN,
    InvalidKeyword,
    WrongNumberOfParameters,
    IncorrectCountField,
    PreparedStmtNotCursorSpec,
    RestrictedDataTypeAttr,
    InvalidDescIndex,
    InvalidDefaultParam,
    ClientConnectionError,
    ConnectionNameInUse,
    ConnectionNotOpen,
    ServerRejectedConnection,
    TransactionConnectionFailure,
    CommunicationLinkFailure,
    InsertValueColumnMismatch,
    DerivedTableDegreeColumnMismatch,
    IndicatorVarRequired,
    NumOutOfRange,
    InvalidDatetimeFormat,
    DatetimeOverflow,
    DivisionByZero,
    IntervalFieldOverflow,
    InvalidCharacterValue,
    InvalidEscapeCharacter,
    InvalidEscapeSequence,
    StringLengthMismatch,
    IntegrityConstraintViolation,
    DuplicateKeyConstraintViolation,
    InvalidCursorState,
    InvalidTransactionState,
    TransactionState,
    TransactionStillActive,
    TransactionRolledBack,
    InvalidAuthorization,
    InvalidCursorName,
    DuplicateCursorName,
    InvalidCatalogName,
    InvalidSchemaName,
    SerializationFailure,
    StatementCompletionUnknown,
    SyntaxErrorOrAccessViolation,
    SyntaxError,
    BaseTableOrViewAlreadyExists,
    BaseTableOrViewNotFound,
    IndexAlreadyExists,
    IndexNotFound,
    ColumnAlreadyExists,
    ColumnNotFound,
    WithCheckOptionViolation,
    GeneralError,
    MemoryAllocationFailure,
    InvalidAppBufferType,
    InvalidSqlDataType,
    StatementNotPrepared,
    OperationCanceled,
    InvalidNullPointer,
    FunctionSequnceError,
    AttributeCannotBeSetNow,
    InvalidTransactionOpcode,
    MemoryManagementError,
    ExcessHandles,
    NoCursorNameAvailable,
    CannotModifyImplRowDesc,
    InvalidDescHandleUse,
    ServerDeclinedCancel,
    NonCharOrBinaryDataSIP, // @note: SIP == Sent in Pieces
    AttemptToConcatNull,
    InconsistentDescInfo,
    InvalidAttributeValue,
    InvalidBufferLength,
    InvalidDescFieldIdentifier,
    InvalidAttributeIdentifier,
    FunctionTypeOutOfRange,
    InvalidInfoType,
    ColumnTypeOutOfRange,
    ScopeTypeOutOfRange,
    NullableTypeOutOfRange,
    UniquenessOptionTypeOutOfRange,
    AccuracyOptionTypeOutOfRange,
    InvalidRetrievalCode,
    InvalidPrecisionOrScaleValue,
    InvalidParamType,
    FetchTypeOutOfRange,
    RowValueOutOfRange,
    InvalidCursorPosition,
    InvalidDriverCompletion,
    InvalidBookmarkValue,
    OptionalFeatureNotImplemented,
    TimeoutExpired,
    ConnectionTimeoutExpired,
    FunctionNotSupported,
    DSNNotFound,
    DriverCouldNotBeLoaded,
    EnvHandleAllocFailed,
    ConnHandleAllocFailed,
    SetConnectionAttrFailed,
    DialogProhibited,
    DialogFailed,
    UnableToLoadTranslationDLL,
    DSNTooLong,
    DriverNameTooLong,
    DriverKeywordSyntaxError,
    TraceFileError,
    InvalidFileDSN,
    CorruptFileDataSource,

    fn toError(sql_state: SqlState) SqlStateError {
        inline for (@typeInfo(SqlStateError).ErrorSet.?) |error_field| {
            if (std.mem.eql(u8, error_field.name, @tagName(sql_state))) {
                // return @Type(std.builtin.Type{ .Error = error_field });
                return @field(SqlStateError, error_field.name);
            }
        }

        unreachable;
    }
};

pub const SqlStateError = EnumError(SqlState);

fn EnumError(comptime E: type) type {
    switch (@typeInfo(E)) {
        .Enum => {
            const tag_count = std.meta.fields(E).len;
            var error_tags: [tag_count]std.builtin.Type.Error = undefined;

            for (std.meta.fields(E), 0..) |enum_field, index| {
                error_tags[index] = .{ .name = enum_field.name };
            }

            const err_set: std.builtin.Type = .{ .ErrorSet = error_tags[0..] };
            return @Type(err_set);
        },
        else => @compileError("EnumError only accepts enum types."),
    }
}

pub const DiagnosticIdentifier = enum(c_short) {
    CursorRowCount = -1249,
    DynamicFunction = 7,
    DynamicFunctionCode = 12,
    Number = 2,
    ReturnCode = 1,
    RowCount = 3,
};

pub const odbc_error_map = std.ComptimeStringMap(SqlState, .{
    .{ "00000", .Success },
    .{ "01000", .GeneralWarning },
    .{ "01001", .CursorOperationConflict },
    .{ "01002", .DisconnectError },
    .{ "01003", .NullEliminated },
    .{ "01004", .StringRightTrunc },
    .{ "22001", .StringRightTrunc },
    .{ "01006", .PrivilegeNotRevoked },
    .{ "01007", .PrivilegeNotGranted },
    .{ "01S00", .InvalidConnectionStringAttr },
    .{ "01S01", .ErrorInRow },
    .{ "01S02", .OptionValueChanged },
    .{ "01S06", .FetchBeforeFirstResultSet },
    .{ "01S07", .FractionalTruncation },
    .{ "01S08", .ErrorSavingFileDSN },
    .{ "01S09", .InvalidKeyword },
    .{ "07001", .WrongNumberOfParameters },
    .{ "07002", .IncorrectCountField },
    .{ "07005", .PreparedStmtNotCursorSpec },
    .{ "07006", .RestrictedDataTypeAttr },
    .{ "07009", .InvalidDescIndex },
    .{ "07S01", .InvalidDefaultParam },
    .{ "08001", .ClientConnectionError },
    .{ "08002", .ConnectionNameInUse },
    .{ "08004", .ServerRejectedConnection },
    .{ "08007", .TransactionConnectionFailure },
    .{ "08S01", .CommunicationLinkFailure },
    .{ "21S01", .InsertValueColumnMismatch },
    .{ "21S02", .DerivedTableDegreeColumnMismatch },
    .{ "22002", .IndicatorVarRequired },
    .{ "22003", .NumOutOfRange },
    .{ "22007", .InvalidDatetimeFormat },
    .{ "22008", .DatetimeOverflow },
    .{ "22012", .DivisionByZero },
    .{ "22015", .IntervalFieldOverflow },
    .{ "22018", .InvalidCharacterValue },
    .{ "22019", .InvalidEscapeCharacter },
    .{ "22025", .InvalidEscapeSequence },
    .{ "22026", .StringLengthMismatch },
    .{ "23000", .IntegrityConstraintViolation },
    .{ "23505", .DuplicateKeyConstraintViolation },
    .{ "24000", .InvalidCursorState },
    .{ "25000", .InvalidTransactionState },
    .{ "25S01", .TransactionState },
    .{ "25S02", .TransactionStillActive },
    .{ "25S03", .TransactionRolledBack },
    .{ "28000", .InvalidAuthorization },
    .{ "34000", .InvalidCursorName },
    .{ "3C000", .DuplicateCursorName },
    .{ "3D000", .InvalidCatalogName },
    .{ "3F000", .InvalidSchemaName },
    .{ "40001", .SerializationFailure },
    .{ "40002", .IntegrityConstraintViolation },
    .{ "40003", .StatementCompletionUnknown },
    .{ "42000", .SyntaxErrorOrAccessViolation },
    .{ "42601", .SyntaxError },
    .{ "42S01", .BaseTableOrViewAlreadyExists },
    .{ "42S02", .BaseTableOrViewNotFound },
    .{ "42S11", .IndexAlreadyExists },
    .{ "42S12", .IndexNotFound },
    .{ "42S21", .ColumnAlreadyExists },
    .{ "42S22", .ColumnNotFound },
    .{ "44000", .WithCheckOptionViolation },
    .{ "HY000", .GeneralError },
    .{ "HY001", .MemoryAllocationFailure },
    .{ "HY003", .InvalidAppBufferType },
    .{ "HY004", .InvalidSqlDataType },
    .{ "HY007", .StatementNotPrepared },
    .{ "HY008", .OperationCanceled },
    .{ "HY009", .InvalidNullPointer },
    .{ "HY010", .FunctionSequnceError },
    .{ "HY011", .AttributeCannotBeSetNow },
    .{ "HY012", .InvalidTransactionOpcode },
    .{ "HY013", .MemoryManagementError },
    .{ "HY014", .ExcessHandles },
    .{ "HY015", .NoCursorNameAvailable },
    .{ "HY016", .CannotModifyImplRowDesc },
    .{ "HY017", .InvalidDescHandleUse },
    .{ "HY018", .ServerDeclinedCancel },
    .{ "HY019", .NonCharOrBinaryDataSIP },
    .{ "HY020", .AttemptToConcatNull },
    .{ "HY021", .InconsistentDescInfo },
    .{ "HY024", .InvalidAttributeValue },
    .{ "HY090", .InvalidBufferLength },
    .{ "HY091", .InvalidDescFieldIdentifier },
    .{ "HY092", .InvalidAttributeIdentifier },
    .{ "HY095", .FunctionTypeOutOfRange },
    .{ "HY096", .InvalidInfoType },
    .{ "HY097", .ColumnTypeOutOfRange },
    .{ "HY098", .ScopeTypeOutOfRange },
    .{ "HY099", .NullableTypeOutOfRange },
    .{ "HY100", .UniquenessOptionTypeOutOfRange },
    .{ "HY101", .AccuracyOptionTypeOutOfRange },
    .{ "HY103", .InvalidRetrievalCode },
    .{ "HY104", .InvalidPrecisionOrScaleValue },
    .{ "HY105", .InvalidParamType },
    .{ "HY106", .FetchTypeOutOfRange },
    .{ "HY107", .RowValueOutOfRange },
    .{ "HY109", .InvalidCursorPosition },
    .{ "HY110", .InvalidDriverCompletion },
    .{ "HY111", .InvalidBookmarkValue },
    .{ "HYC00", .OptionalFeatureNotImplemented },
    .{ "HYT00", .TimeoutExpired },
    .{ "HYT01", .ConnectionTimeoutExpired },
    .{ "IM001", .FunctionNotSupported },
    .{ "IM002", .DSNNotFound },
    .{ "IM003", .DriverCouldNotBeLoaded },
    .{ "IM004", .EnvHandleAllocFailed },
    .{ "IM005", .ConnHandleAllocFailed },
    .{ "IM006", .SetConnectionAttrFailed },
    .{ "IM007", .DialogProhibited },
    .{ "IM008", .DialogFailed },
    .{ "IM009", .UnableToLoadTranslationDLL },
    .{ "IM010", .DSNTooLong },
    .{ "IM011", .DriverNameTooLong },
    .{ "IM012", .DriverKeywordSyntaxError },
    .{ "IM013", .TraceFileError },
    .{ "IM014", .InvalidFileDSN },
    .{ "IM015", .CorruptFileDataSource },
});

pub const LastError = error{NoError} || SqlStateError;
pub fn getLastError(handle_type: types.HandleType, handle: ?*anyopaque) LastError {
    var num_records: u64 = 0;
    _ = c.SQLGetDiagField(@intFromEnum(handle_type), handle, 0, @intFromEnum(DiagnosticIdentifier.Number), &num_records, 0, null);

    if (num_records == 0) return error.NoError;

    var sql_state: [5:0]u8 = undefined;
    // var native_error: [1024:0]u8 = undefined;
    var message_text: [1024:0]u8 = undefined;

    const result = c.SQLGetDiagRec(@intFromEnum(handle_type), handle, 1, sql_state[0..], null, message_text[0..], 1024, null);
    // switch (@as(odbc.SqlReturn, @enumFromInt(result))) {
    //     .success, .success_with_info => {
    //         const error_state = odbc_error_map.get(sql_state[0..]) orelse .GeneralError;
    //         return error_state.toError();
    //     },
    //     // else => return null,
    //     else => return SqlStateError.GeneralError,
    // }
    std.debug.print("SQLGetDiagRec rc= {}\n", .{result});
    std.debug.print("message_text = {s}\n", .{message_text});
    if (result == 0 or result == 1) {
        const error_state = odbc_error_map.get(sql_state[0..]) orelse .GeneralError;
        return error_state.toError();
    }
    return SqlStateError.GeneralError;
}
