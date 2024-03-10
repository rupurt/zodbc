const std = @import("std");
const builtin = @import("builtin");
const native_endian = builtin.target.cpu.arch.endian();

pub const c = @cImport({
    @cInclude("sql.h");
    @cInclude("sqltypes.h");
    @cInclude("sqlext.h");
});

pub const InfoType = enum(c_int) {
    // ODBC spec
    AccessibleProcedures = c.SQL_ACCESSIBLE_PROCEDURES,
    AccessibleTables = c.SQL_ACCESSIBLE_TABLES,
    ActiveEnvironments = c.SQL_ACTIVE_ENVIRONMENTS,
    AggregateFunctions = c.SQL_AGGREGATE_FUNCTIONS,
    AlterDomain = c.SQL_ALTER_DOMAIN,
    AlterTable = c.SQL_ALTER_TABLE,
    BatchRowCount = c.SQL_BATCH_ROW_COUNT,
    BatchSupport = c.SQL_BATCH_SUPPORT,
    BookmarkPersistence = c.SQL_BOOKMARK_PERSISTENCE,
    CatalogLocation = c.SQL_CATALOG_LOCATION,
    CatalogName = c.SQL_CATALOG_NAME,
    CatalogNameSeparator = c.SQL_CATALOG_NAME_SEPARATOR,
    CatalogTerm = c.SQL_CATALOG_TERM,
    CatalogUsage = c.SQL_CATALOG_USAGE,
    CollationSeq = c.SQL_COLLATION_SEQ,
    ColumnAlias = c.SQL_COLUMN_ALIAS,
    // ConcatNullBehavior = c.SQL_CONCAT_NULL_BEHAVIOR,
    ConvertBigint = c.SQL_CONVERT_BIGINT,
    ConvertBinary = c.SQL_CONVERT_BINARY,
    ConvertBit = c.SQL_CONVERT_BIT,
    ConvertChar = c.SQL_CONVERT_CHAR,
    ConvertDate = c.SQL_CONVERT_DATE,
    ConvertDecimal = c.SQL_CONVERT_DECIMAL,
    ConvertDouble = c.SQL_CONVERT_DOUBLE,
    ConvertFloat = c.SQL_CONVERT_FLOAT,
    ConvertInteger = c.SQL_CONVERT_INTEGER,
    ConvertIntervalDayTime = c.SQL_CONVERT_INTERVAL_DAY_TIME,
    ConvertIntervalYearMonth = c.SQL_CONVERT_INTERVAL_YEAR_MONTH,
    ConvertLongvarbinary = c.SQL_CONVERT_LONGVARBINARY,
    ConvertLongvarchar = c.SQL_CONVERT_LONGVARCHAR,
    ConvertNumeric = c.SQL_CONVERT_NUMERIC,
    ConvertReal = c.SQL_CONVERT_REAL,
    ConvertSmallint = c.SQL_CONVERT_SMALLINT,
    ConvertTime = c.SQL_CONVERT_TIME,
    ConvertTimestamp = c.SQL_CONVERT_TIMESTAMP,
    ConvertTinyint = c.SQL_CONVERT_TINYINT,
    ConvertVarbinary = c.SQL_CONVERT_VARBINARY,
    ConvertVarchar = c.SQL_CONVERT_VARCHAR,
    ConvertFunctions = c.SQL_CONVERT_FUNCTIONS,
    CorrelationName = c.SQL_CORRELATION_NAME,
    CreateAssertion = c.SQL_CREATE_ASSERTION,
    CreateCharacterSet = c.SQL_CREATE_CHARACTER_SET,
    CreateCollation = c.SQL_CREATE_COLLATION,
    CreateDomain = c.SQL_CREATE_DOMAIN,
    CreateSchema = c.SQL_CREATE_SCHEMA,
    CreateTable = c.SQL_CREATE_TABLE,
    CreateTranslation = c.SQL_CREATE_TRANSLATION,
    CursorCommitBehavior = c.SQL_CURSOR_COMMIT_BEHAVIOR,
    CursorRollbackBehavior = c.SQL_CURSOR_ROLLBACK_BEHAVIOR,
    CursorSensitivity = c.SQL_CURSOR_SENSITIVITY,
    DataSourceName = c.SQL_DATA_SOURCE_NAME,
    DataSourceReadOnly = c.SQL_DATA_SOURCE_READ_ONLY,
    DatabaseName = c.SQL_DATABASE_NAME,
    DbmsName = c.SQL_DBMS_NAME,
    DbmsVer = c.SQL_DBMS_VER,
    DdlIndex = c.SQL_DDL_INDEX,
    DefaultTxnIsolation = c.SQL_DEFAULT_TXN_ISOLATION,
    DescribeParameter = c.SQL_DESCRIBE_PARAMETER,
    DriverHdbc = c.SQL_DRIVER_HDBC,
    DriverHenv = c.SQL_DRIVER_HENV,
    DriverHlib = c.SQL_DRIVER_HLIB,
    DriverHstmt = c.SQL_DRIVER_HSTMT,
    DriverName = c.SQL_DRIVER_NAME,
    DriverOdbcVer = c.SQL_DRIVER_ODBC_VER,
    DriverVer = c.SQL_DRIVER_VER,
    DropAssertion = c.SQL_DROP_ASSERTION,
    DropCharacterSet = c.SQL_DROP_CHARACTER_SET,
    DropCollation = c.SQL_DROP_COLLATION,
    DropDomain = c.SQL_DROP_DOMAIN,
    DropSchema = c.SQL_DROP_SCHEMA,
    DropTable = c.SQL_DROP_TABLE,
    DropTranslation = c.SQL_DROP_TRANSLATION,
    DropView = c.SQL_DROP_VIEW,
    DynamicCursorAttributes1 = c.SQL_DYNAMIC_CURSOR_ATTRIBUTES1,
    DynamicCursorAttributes2 = c.SQL_DYNAMIC_CURSOR_ATTRIBUTES2,
    ExpressionsInOrderby = c.SQL_EXPRESSIONS_IN_ORDERBY,
    FetchDirection = c.SQL_FETCH_DIRECTION,
    FileUsage = c.SQL_FILE_USAGE,
    ForwardOnlyCursorAttributes1 = c.SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1,
    ForwardOnlyCursorAttributes2 = c.SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2,
    GetdataExtensions = c.SQL_GETDATA_EXTENSIONS,
    GroupBy = c.SQL_GROUP_BY,
    IdentifierCase = c.SQL_IDENTIFIER_CASE,
    IdentifierQuoteChar = c.SQL_IDENTIFIER_QUOTE_CHAR,
    InfoSchemaViews = c.SQL_INFO_SCHEMA_VIEWS,
    InsertStatement = c.SQL_INSERT_STATEMENT,
    Integrity = c.SQL_INTEGRITY,
    KeysetCursorAttributes1 = c.SQL_KEYSET_CURSOR_ATTRIBUTES1,
    KeysetCursorAttributes2 = c.SQL_KEYSET_CURSOR_ATTRIBUTES2,
    Keywords = c.SQL_KEYWORDS,
    LikeEscapeClause = c.SQL_LIKE_ESCAPE_CLAUSE,
    LockTypes = c.SQL_LOCK_TYPES,
    MaxAsyncConcurrentStatements = c.SQL_MAX_ASYNC_CONCURRENT_STATEMENTS,
    MaxBinaryLiteralLen = c.SQL_MAX_BINARY_LITERAL_LEN,
    MaxCatalogNameLen = c.SQL_MAX_CATALOG_NAME_LEN,
    MaxCharLiteralLen = c.SQL_MAX_CHAR_LITERAL_LEN,
    MaxColumnNameLen = c.SQL_MAX_COLUMN_NAME_LEN,
    MaxColumnsInGroupBy = c.SQL_MAX_COLUMNS_IN_GROUP_BY,
    MaxColumnsInIndex = c.SQL_MAX_COLUMNS_IN_INDEX,
    MaxColumnsInOrderBy = c.SQL_MAX_COLUMNS_IN_ORDER_BY,
    MaxColumnsInSelect = c.SQL_MAX_COLUMNS_IN_SELECT,
    MaxColumnsInTable = c.SQL_MAX_COLUMNS_IN_TABLE,
    MaxConcurrentActivities = c.SQL_MAX_CONCURRENT_ACTIVITIES,
    MaxCursorNameLen = c.SQL_MAX_CURSOR_NAME_LEN,
    MaxDriverConnections = c.SQL_MAX_DRIVER_CONNECTIONS,
    MaxIdentifierLen = c.SQL_MAX_IDENTIFIER_LEN,
    MaxIndexSize = c.SQL_MAX_INDEX_SIZE,
    MaxProcedureNameLen = c.SQL_MAX_PROCEDURE_NAME_LEN,
    MaxRowSize = c.SQL_MAX_ROW_SIZE,
    MaxRowSizeIncludesLong = c.SQL_MAX_ROW_SIZE_INCLUDES_LONG,
    MaxSchemaNameLen = c.SQL_MAX_SCHEMA_NAME_LEN,
    MaxStatementLen = c.SQL_MAX_STATEMENT_LEN,
    MaxTableNameLen = c.SQL_MAX_TABLE_NAME_LEN,
    MaxTablesInSelect = c.SQL_MAX_TABLES_IN_SELECT,
    MaxUserNameLen = c.SQL_MAX_USER_NAME_LEN,
    MultResultSets = c.SQL_MULT_RESULT_SETS,
    MultipleActiveTxn = c.SQL_MULTIPLE_ACTIVE_TXN,
    NeedLongDataLen = c.SQL_NEED_LONG_DATA_LEN,
    NonNullableColumns = c.SQL_NON_NULLABLE_COLUMNS,
    NullCollation = c.SQL_NULL_COLLATION,
    NumericFunctions = c.SQL_NUMERIC_FUNCTIONS,
    OdbcApiConformance = c.SQL_ODBC_API_CONFORMANCE,
    OdbcSagCliConformance = c.SQL_ODBC_SAG_CLI_CONFORMANCE,
    OdbcSqlConformance = c.SQL_ODBC_SQL_CONFORMANCE,
    OdbcVer = c.SQL_ODBC_VER,
    OjCapabilities = c.SQL_OJ_CAPABILITIES,
    OrderByColumnsInSelect = c.SQL_ORDER_BY_COLUMNS_IN_SELECT,
    OuterJoins = c.SQL_OUTER_JOINS,
    OwnerTerm = c.SQL_OWNER_TERM,
    ParamArrayRowCounts = c.SQL_PARAM_ARRAY_ROW_COUNTS,
    ParamArraySelects = c.SQL_PARAM_ARRAY_SELECTS,
    PosOperations = c.SQL_POS_OPERATIONS,
    PositionedStatements = c.SQL_POSITIONED_STATEMENTS,
    ProcedureTerm = c.SQL_PROCEDURE_TERM,
    Procedures = c.SQL_PROCEDURES,
    QuotedIdentifierCase = c.SQL_QUOTED_IDENTIFIER_CASE,
    RowUpdates = c.SQL_ROW_UPDATES,
    SchemaUsage = c.SQL_SCHEMA_USAGE,
    ScrollConcurrency = c.SQL_SCROLL_CONCURRENCY,
    ScrollOptions = c.SQL_SCROLL_OPTIONS,
    SearchPatternEscape = c.SQL_SEARCH_PATTERN_ESCAPE,
    ServerName = c.SQL_SERVER_NAME,
    SpecialCharacters = c.SQL_SPECIAL_CHARACTERS,
    Sql92Predicates = c.SQL_SQL92_PREDICATES,
    Sql92ValueExpressions = c.SQL_SQL92_VALUE_EXPRESSIONS,
    StaticCursorAttributes1 = c.SQL_STATIC_CURSOR_ATTRIBUTES1,
    StaticCursorAttributes2 = c.SQL_STATIC_CURSOR_ATTRIBUTES2,
    StaticSensitivity = c.SQL_STATIC_SENSITIVITY,
    StringFunctions = c.SQL_STRING_FUNCTIONS,
    Subqueries = c.SQL_SUBQUERIES,
    SystemFunctions = c.SQL_SYSTEM_FUNCTIONS,
    TableTerm = c.SQL_TABLE_TERM,
    TimedateAddIntervals = c.SQL_TIMEDATE_ADD_INTERVALS,
    TimedateDiffIntervals = c.SQL_TIMEDATE_DIFF_INTERVALS,
    TimedateFunctions = c.SQL_TIMEDATE_FUNCTIONS,
    TxnCapable = c.SQL_TXN_CAPABLE,
    TxnIsolationOption = c.SQL_TXN_ISOLATION_OPTION,
    Union = c.SQL_UNION,
    UserName = c.SQL_USER_NAME,
    XopenCliYear = c.SQL_XOPEN_CLI_YEAR,
    // IBM Db2 specific info types
    // AsciiGccsid = c.SQL_ASCII_GCCSID,
    // AsciiMccsid = c.SQL_ASCII_MCCSID,
    // AsciiSccsid = c.SQL_ASCII_SCCSID,
    // ConvertRowid = c.SQL_CONVERT_ROWID,
    // CloseBehavior = c.SQL_CLOSE_BEHAVIOR,
    // EbcdicGccsid = c.SQL_EBCDIC_GCCSID,
    // EbcdicMccsid = c.SQL_EBCDIC_MCCSID,
    // EbcdicSccsid = c.SQL_EBCDIC_SCCSID,
    // UnicodeGccsid = c.SQL_UNICODE_GCCSID,
    // UnicodeMccsid = c.SQL_UNICODE_MCCSID,
    // UnicodeSccsid = c.SQL_UNICODE_SCCSID,
};

const buf_len = 2048;

pub const InfoTypeValue = struct {
    info_type: InfoType,
    buf: [buf_len]u8 = undefined,
    str_len: i16 = undefined,

    pub fn tag(self: InfoTypeValue) Tag {
        return switch (self.info_type) {
            .AccessibleProcedures => .{ .AccessibleProcedures = strToBool(self.buf, self.str_len, "Y") },
            .AccessibleTables => .{ .AccessibleTables = strToBool(self.buf, self.str_len, "Y") },
            .ActiveEnvironments => .{ .ActiveEnvironments = readInt(u16, self.buf, 2) },
            .AggregateFunctions => .{ .AggregateFunctions = .{ .data = readInt(u32, self.buf, 4) } },
            .AlterDomain => .{ .AlterDomain = .{ .data = readInt(u32, self.buf, 4) } },
            .AlterTable => .{ .AlterTable = .{ .data = readInt(u32, self.buf, 4) } },
            .BatchRowCount => .{ .BatchRowCount = .{ .data = readInt(u32, self.buf, 4) } },
            .BatchSupport => .{ .BatchSupport = .{ .data = readInt(u32, self.buf, 4) } },
            .BookmarkPersistence => .{ .BookmarkPersistence = .{ .data = readInt(u32, self.buf, 4) } },
            .CatalogLocation => .{ .CatalogLocation = readInt(u16, self.buf, 2) },
            .CatalogName => .{ .CatalogName = strToBool(self.buf, self.str_len, "Y") },
            .CatalogNameSeparator => .{ .CatalogNameSeparator = self.buf[0..@intCast(self.str_len)] },
            .CatalogTerm => .{ .CatalogTerm = self.buf[0..@intCast(self.str_len)] },
            .CatalogUsage => .{ .CatalogUsage = .{ .data = readInt(u32, self.buf, 4) } },
            .CollationSeq => .{ .CollationSeq = self.buf[0..@intCast(self.str_len)] },
            .ColumnAlias => .{ .ColumnAlias = strToBool(self.buf, self.str_len, "Y") },
            // .ConcatNullBehavior => .{ .ConcatNullBehavior = value },
            .ConvertBigint => .{ .ConvertBigint = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertBinary => .{ .ConvertBinary = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertBit => .{ .ConvertBit = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertChar => .{ .ConvertChar = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertDate => .{ .ConvertDate = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertDecimal => .{ .ConvertDecimal = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertDouble => .{ .ConvertDouble = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertFloat => .{ .ConvertFloat = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertInteger => .{ .ConvertInteger = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertIntervalDayTime => .{ .ConvertIntervalDayTime = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertIntervalYearMonth => .{ .ConvertIntervalYearMonth = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertLongvarbinary => .{ .ConvertLongvarbinary = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertLongvarchar => .{ .ConvertLongvarchar = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertNumeric => .{ .ConvertNumeric = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertReal => .{ .ConvertReal = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertSmallint => .{ .ConvertSmallint = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertTime => .{ .ConvertTime = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertTimestamp => .{ .ConvertTimestamp = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertTinyint => .{ .ConvertTinyint = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertVarbinary => .{ .ConvertVarbinary = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertVarchar => .{ .ConvertVarchar = .{ .data = readInt(u32, self.buf, 4) } },
            .ConvertFunctions => .{ .ConvertFunctions = .{ .data = readInt(u32, self.buf, 4) } },
            .CorrelationName => .{ .CorrelationName = @enumFromInt(readInt(u16, self.buf, 2)) },
            .CreateAssertion => .{ .CreateAssertion = .{ .data = readInt(u32, self.buf, 4) } },
            .CreateCharacterSet => .{ .CreateCharacterSet = .{ .data = readInt(u32, self.buf, 4) } },
            .CreateCollation => .{ .CreateCollation = .{ .data = readInt(u32, self.buf, 4) } },
            .CreateDomain => .{ .CreateDomain = .{ .data = readInt(u32, self.buf, 4) } },
            .CreateSchema => .{ .CreateSchema = .{ .data = readInt(u32, self.buf, 4) } },
            .CreateTable => .{ .CreateTable = .{ .data = readInt(u32, self.buf, 4) } },
            .CreateTranslation => .{ .CreateTranslation = .{ .data = readInt(u32, self.buf, 4) } },
            .CursorCommitBehavior => .{ .CursorCommitBehavior = @enumFromInt(readInt(u16, self.buf, 2)) },
            .CursorRollbackBehavior => .{ .CursorRollbackBehavior = @enumFromInt(readInt(u16, self.buf, 2)) },
            .CursorSensitivity => .{ .CursorSensitivity = @enumFromInt(readInt(u32, self.buf, 4)) },
            .DataSourceName => .{ .DataSourceName = self.buf[0..@intCast(self.str_len)] },
            .DataSourceReadOnly => .{ .DataSourceReadOnly = strToBool(self.buf, self.str_len, "Y") },
            .DatabaseName => .{ .DatabaseName = self.buf[0..@intCast(self.str_len)] },
            .DbmsName => .{ .DbmsName = self.buf[0..@intCast(self.str_len)] },
            .DbmsVer => .{ .DbmsVer = self.buf[0..@intCast(self.str_len)] },
            .DdlIndex => .{ .DdlIndex = .{ .data = readInt(u32, self.buf, 4) } },
            .DefaultTxnIsolation => .{ .DefaultTxnIsolation = .{ .data = readInt(u32, self.buf, 4) } },
            .DescribeParameter => .{ .DescribeParameter = strToBool(self.buf, self.str_len, "Y") },
            .DriverHdbc => .{ .DriverHdbc = readInt(u32, self.buf, 4) },
            .DriverHenv => .{ .DriverHenv = readInt(u32, self.buf, 4) },
            .DriverHlib => .{ .DriverHlib = readInt(u32, self.buf, 4) },
            .DriverHstmt => .{ .DriverHstmt = readInt(u32, self.buf, 4) },
            .DriverName => .{ .DriverName = self.buf[0..@intCast(self.str_len)] },
            .DriverOdbcVer => .{ .DriverOdbcVer = self.buf[0..@intCast(self.str_len)] },
            .DriverVer => .{ .DriverVer = self.buf[0..@intCast(self.str_len)] },
            .DropAssertion => .{ .DropAssertion = .{ .data = readInt(u32, self.buf, 4) } },
            .DropCharacterSet => .{ .DropCharacterSet = .{ .data = readInt(u32, self.buf, 4) } },
            .DropCollation => .{ .DropCollation = .{ .data = readInt(u32, self.buf, 4) } },
            .DropDomain => .{ .DropDomain = .{ .data = readInt(u32, self.buf, 4) } },
            .DropSchema => .{ .DropSchema = .{ .data = readInt(u32, self.buf, 4) } },
            .DropTable => .{ .DropTable = .{ .data = readInt(u32, self.buf, 4) } },
            .DropTranslation => .{ .DropTranslation = .{ .data = readInt(u32, self.buf, 4) } },
            .DropView => .{ .DropView = .{ .data = readInt(u32, self.buf, 4) } },
            .DynamicCursorAttributes1 => .{ .DynamicCursorAttributes1 = .{ .data = readInt(u32, self.buf, 4) } },
            .DynamicCursorAttributes2 => .{ .DynamicCursorAttributes2 = .{ .data = readInt(u32, self.buf, 4) } },
            .ExpressionsInOrderby => .{ .ExpressionsInOrderby = strToBool(self.buf, self.str_len, "Y") },
            .FetchDirection => .{ .FetchDirection = .{ .data = readInt(u32, self.buf, 4) } },
            .FileUsage => .{ .FileUsage = readInt(u16, self.buf, 2) },
            .ForwardOnlyCursorAttributes1 => .{ .ForwardOnlyCursorAttributes1 = .{ .data = readInt(u32, self.buf, 4) } },
            .ForwardOnlyCursorAttributes2 => .{ .ForwardOnlyCursorAttributes2 = .{ .data = readInt(u32, self.buf, 4) } },
            .GetdataExtensions => .{ .GetdataExtensions = .{ .data = readInt(u32, self.buf, 4) } },
            .GroupBy => .{ .GroupBy = @enumFromInt(readInt(u16, self.buf, 2)) },
            .IdentifierCase => .{ .IdentifierCase = @enumFromInt(readInt(u16, self.buf, 2)) },
            .IdentifierQuoteChar => .{ .IdentifierQuoteChar = self.buf[0..@intCast(self.str_len)] },
            .InfoSchemaViews => .{ .InfoSchemaViews = .{ .data = readInt(u32, self.buf, 4) } },
            .InsertStatement => .{ .InsertStatement = .{ .data = readInt(u32, self.buf, 4) } },
            .Integrity => .{ .Integrity = strToBool(self.buf, self.str_len, "Y") },
            .KeysetCursorAttributes1 => .{ .KeysetCursorAttributes1 = .{ .data = readInt(u32, self.buf, 4) } },
            .KeysetCursorAttributes2 => .{ .KeysetCursorAttributes2 = .{ .data = readInt(u32, self.buf, 4) } },
            .Keywords => .{ .Keywords = self.buf[0..@intCast(self.str_len)] },
            .LikeEscapeClause => .{ .LikeEscapeClause = self.buf[0..@intCast(self.str_len)] },
            .LockTypes => .{ .LockTypes = .{ .data = readInt(u32, self.buf, 4) } },
            .MaxAsyncConcurrentStatements => .{ .MaxAsyncConcurrentStatements = readInt(u32, self.buf, 4) },
            .MaxBinaryLiteralLen => .{ .MaxBinaryLiteralLen = readInt(u32, self.buf, 4) },
            .MaxCatalogNameLen => .{ .MaxCatalogNameLen = readInt(u16, self.buf, 2) },
            .MaxCharLiteralLen => .{ .MaxCharLiteralLen = readInt(u32, self.buf, 4) },
            .MaxColumnNameLen => .{ .MaxColumnNameLen = readInt(u16, self.buf, 2) },
            .MaxColumnsInGroupBy => .{ .MaxColumnsInGroupBy = readInt(u16, self.buf, 2) },
            .MaxColumnsInIndex => .{ .MaxColumnsInIndex = readInt(u16, self.buf, 2) },
            .MaxColumnsInOrderBy => .{ .MaxColumnsInOrderBy = readInt(u16, self.buf, 2) },
            .MaxColumnsInSelect => .{ .MaxColumnsInSelect = readInt(u16, self.buf, 2) },
            .MaxColumnsInTable => .{ .MaxColumnsInTable = readInt(u16, self.buf, 2) },
            .MaxConcurrentActivities => .{ .MaxConcurrentActivities = readInt(u16, self.buf, 2) },
            .MaxCursorNameLen => .{ .MaxCursorNameLen = readInt(u16, self.buf, 2) },
            .MaxDriverConnections => .{ .MaxDriverConnections = readInt(u16, self.buf, 2) },
            .MaxIdentifierLen => .{ .MaxIdentifierLen = readInt(u16, self.buf, 2) },
            .MaxIndexSize => .{ .MaxIndexSize = readInt(u32, self.buf, 4) },
            .MaxProcedureNameLen => .{ .MaxProcedureNameLen = readInt(u16, self.buf, 2) },
            .MaxRowSize => .{ .MaxRowSize = readInt(u32, self.buf, 4) },
            .MaxRowSizeIncludesLong => .{ .MaxRowSizeIncludesLong = strToBool(self.buf, self.str_len, "Y") },
            .MaxSchemaNameLen => .{ .MaxSchemaNameLen = readInt(u16, self.buf, 2) },
            .MaxStatementLen => .{ .MaxStatementLen = readInt(u32, self.buf, 4) },
            .MaxTableNameLen => .{ .MaxTableNameLen = readInt(u16, self.buf, 2) },
            .MaxTablesInSelect => .{ .MaxTablesInSelect = readInt(u16, self.buf, 2) },
            .MaxUserNameLen => .{ .MaxUserNameLen = readInt(u16, self.buf, 2) },
            .MultResultSets => .{ .MultResultSets = strToBool(self.buf, self.str_len, "Y") },
            .MultipleActiveTxn => .{ .MultipleActiveTxn = strToBool(self.buf, self.str_len, "Y") },
            .NeedLongDataLen => .{ .NeedLongDataLen = strToBool(self.buf, self.str_len, "Y") },
            .NonNullableColumns => .{ .NonNullableColumns = @enumFromInt(readInt(u16, self.buf, 2)) },
            .NullCollation => .{ .NullCollation = @enumFromInt(readInt(u16, self.buf, 2)) },
            .NumericFunctions => .{ .NumericFunctions = .{ .data = readInt(u32, self.buf, 4) } },
            .OdbcApiConformance => .{ .OdbcApiConformance = @enumFromInt(readInt(u16, self.buf, 2)) },
            .OdbcSagCliConformance => .{ .OdbcSagCliConformance = @enumFromInt(readInt(u16, self.buf, 2)) },
            .OdbcSqlConformance => .{ .OdbcSqlConformance = @enumFromInt(readInt(u16, self.buf, 2)) },
            .OdbcVer => .{ .OdbcVer = self.buf[0..@intCast(self.str_len)] },
            .OjCapabilities => .{ .OjCapabilities = .{ .data = readInt(u32, self.buf, 4) } },
            .OrderByColumnsInSelect => .{ .OrderByColumnsInSelect = strToBool(self.buf, self.str_len, "Y") },
            .OuterJoins => .{ .OuterJoins = strToBool(self.buf, self.str_len, "Y") },
            .OwnerTerm => .{ .OwnerTerm = self.buf[0..@intCast(self.str_len)] },
            .ParamArrayRowCounts => .{ .ParamArrayRowCounts = @enumFromInt(readInt(u32, self.buf, 4)) },
            .ParamArraySelects => .{ .ParamArraySelects = @enumFromInt(readInt(u32, self.buf, 4)) },
            .PosOperations => .{ .PosOperations = .{ .data = readInt(u32, self.buf, 4) } },
            .PositionedStatements => .{ .PositionedStatements = .{ .data = readInt(u32, self.buf, 4) } },
            .ProcedureTerm => .{ .ProcedureTerm = self.buf[0..@intCast(self.str_len)] },
            .Procedures => .{ .Procedures = strToBool(self.buf, self.str_len, "Y") },
            .QuotedIdentifierCase => .{ .QuotedIdentifierCase = @enumFromInt(readInt(u16, self.buf, 2)) },
            .RowUpdates => .{ .RowUpdates = strToBool(self.buf, self.str_len, "Y") },
            .SchemaUsage => .{ .SchemaUsage = .{ .data = readInt(u32, self.buf, 4) } },
            .ScrollConcurrency => .{ .ScrollConcurrency = .{ .data = readInt(u32, self.buf, 4) } },
            .ScrollOptions => .{ .ScrollOptions = .{ .data = readInt(u32, self.buf, 4) } },
            .SearchPatternEscape => .{ .SearchPatternEscape = self.buf[0..@intCast(self.str_len)] },
            .ServerName => .{ .ServerName = self.buf[0..@intCast(self.str_len)] },
            .SpecialCharacters => .{ .SpecialCharacters = self.buf[0..@intCast(self.str_len)] },
            .Sql92Predicates => .{ .Sql92Predicates = .{ .data = readInt(u32, self.buf, 4) } },
            .Sql92ValueExpressions => .{ .Sql92ValueExpressions = .{ .data = readInt(u32, self.buf, 4) } },
            .StaticCursorAttributes1 => .{ .StaticCursorAttributes1 = .{ .data = readInt(u32, self.buf, 4) } },
            .StaticCursorAttributes2 => .{ .StaticCursorAttributes2 = .{ .data = readInt(u32, self.buf, 4) } },
            .StaticSensitivity => .{ .StaticSensitivity = .{ .data = readInt(u32, self.buf, 4) } },
            .StringFunctions => .{ .StringFunctions = .{ .data = readInt(u32, self.buf, 4) } },
            .Subqueries => .{ .Subqueries = .{ .data = readInt(u32, self.buf, 4) } },
            .SystemFunctions => .{ .SystemFunctions = .{ .data = readInt(u32, self.buf, 4) } },
            .TableTerm => .{ .TableTerm = self.buf[0..@intCast(self.str_len)] },
            .TimedateAddIntervals => .{ .TimedateAddIntervals = .{ .data = readInt(u32, self.buf, 4) } },
            .TimedateDiffIntervals => .{ .TimedateDiffIntervals = .{ .data = readInt(u32, self.buf, 4) } },
            .TimedateFunctions => .{ .TimedateFunctions = .{ .data = readInt(u32, self.buf, 4) } },
            .TxnCapable => .{ .TxnCapable = @enumFromInt(readInt(u16, self.buf, 2)) },
            .TxnIsolationOption => .{ .TxnIsolationOption = .{ .data = readInt(u32, self.buf, 4) } },
            .Union => .{ .Union = .{ .data = readInt(u32, self.buf, 4) } },
            .UserName => .{ .UserName = self.buf[0..@intCast(self.str_len)] },
            .XopenCliYear => .{ .XopenCliYear = self.buf[0..@intCast(self.str_len)] },
            // IBM Db2 specific info types
            // .AsciiGccsid => .{ .AsciiGccsid = value },
            // .AsciiMccsid => .{ .AsciiMccsid = value },
            // .AsciiSccsid => .{ .AsciiSccsid = value },
            // .ConvertRowid => .{ .ConvertRowid = value },
            // .CloseBehavior => .{ .CloseBehavior = value },
            // .EbcdicGccsid => .{ .EbcdicGccsid = value },
            // .EbcdicMccsid => .{ .EbcdicMccsid = value },
            // .EbcdicSccsid => .{ .EbcdicSccsid = value },
            // .UnicodeGccsid => .{ .UnicodeGccsid = value },
            // .UnicodeMccsid => .{ .UnicodeMccsid = value },
            // .UnicodeSccsid => .{ .UnicodeSccsid = value },
        };
    }

    pub const Tag = union(InfoType) {
        AccessibleProcedures: bool,
        AccessibleTables: bool,
        ActiveEnvironments: u16,
        AggregateFunctions: AggregateFunctionsMask,
        AlterDomain: AlterDomainMask,
        AlterTable: AlterTableMask,
        BatchRowCount: BatchRowCountMask,
        BatchSupport: BatchSupportMask,
        BookmarkPersistence: BookmarkPersistenceMask,
        CatalogLocation: u16,
        CatalogName: bool,
        CatalogNameSeparator: []const u8,
        CatalogTerm: []const u8,
        CatalogUsage: CatalogUsageMask,
        CollationSeq: []const u8,
        ColumnAlias: bool,
        // ConcatNullBehavior: [buf_len]u8,
        ConvertBigint: ConvertBigintMask,
        ConvertBinary: ConvertBinaryMask,
        ConvertBit: ConvertBitMask,
        ConvertChar: ConvertCharMask,
        ConvertDate: ConvertDateMask,
        ConvertDecimal: ConvertDecimalMask,
        ConvertDouble: ConvertDoubleMask,
        ConvertFloat: ConvertFloatMask,
        ConvertInteger: ConvertIntegerMask,
        ConvertIntervalDayTime: ConvertIntervalDayTimeMask,
        ConvertIntervalYearMonth: ConvertIntervalYearMonthMask,
        ConvertLongvarbinary: ConvertLongvarbinaryMask,
        ConvertLongvarchar: ConvertLongvarcharMask,
        ConvertNumeric: ConvertNumericMask,
        ConvertReal: ConvertRealMask,
        ConvertSmallint: ConvertSmallintMask,
        ConvertTime: ConvertTimeMask,
        ConvertTimestamp: ConvertTimestampMask,
        ConvertTinyint: ConvertTinyintMask,
        ConvertVarbinary: ConvertVarbinaryMask,
        ConvertVarchar: ConvertVarcharMask,
        ConvertFunctions: ConvertFunctionsMask,
        CorrelationName: CorrelationName,
        CreateAssertion: CreateAssertionMask,
        CreateCharacterSet: CreateCharacterSetMask,
        CreateCollation: CreateCollationMask,
        CreateDomain: CreateDomainMask,
        CreateSchema: CreateSchemaMask,
        CreateTable: CreateTableMask,
        CreateTranslation: CreateTranslationMask,
        CursorCommitBehavior: CursorBehavior,
        CursorRollbackBehavior: CursorBehavior,
        CursorSensitivity: CursorSensitivity,
        DataSourceName: []const u8,
        DataSourceReadOnly: bool,
        DatabaseName: []const u8,
        DbmsName: []const u8,
        DbmsVer: []const u8,
        DdlIndex: DdlIndexMask,
        DefaultTxnIsolation: DefaultTxnIsolationMask,
        DescribeParameter: bool,
        DriverHdbc: u32,
        DriverHenv: u32,
        DriverHlib: u32,
        DriverHstmt: u32,
        DriverName: []const u8,
        DriverOdbcVer: []const u8,
        DriverVer: []const u8,
        DropAssertion: DropAssertionMask,
        DropCharacterSet: DropCharacterSetMask,
        DropCollation: DropCollationMask,
        DropDomain: DropDomainMask,
        DropSchema: DropSchemaMask,
        DropTable: DropTableMask,
        DropTranslation: DropTranslationMask,
        DropView: DropViewMask,
        DynamicCursorAttributes1: DynamicCursorAttributes1Mask,
        DynamicCursorAttributes2: DynamicCursorAttributes2Mask,
        ExpressionsInOrderby: bool,
        FetchDirection: FetchDirectionMask,
        FileUsage: u16,
        ForwardOnlyCursorAttributes1: ForwardOnlyCursorAttributes1Mask,
        ForwardOnlyCursorAttributes2: ForwardOnlyCursorAttributes2Mask,
        GetdataExtensions: GetdataExtensionsMask,
        GroupBy: GroupBy,
        IdentifierCase: IdentifierCase,
        IdentifierQuoteChar: []const u8,
        InfoSchemaViews: InfoSchemaViewsMask,
        InsertStatement: InsertStatementMask,
        Integrity: bool,
        KeysetCursorAttributes1: KeysetCursorAttributes1Mask,
        KeysetCursorAttributes2: KeysetCursorAttributes2Mask,
        Keywords: []const u8,
        LikeEscapeClause: []const u8,
        LockTypes: LockTypesMask,
        MaxAsyncConcurrentStatements: u32,
        MaxBinaryLiteralLen: u32,
        MaxCatalogNameLen: u16,
        MaxCharLiteralLen: u32,
        MaxColumnNameLen: u16,
        MaxColumnsInGroupBy: u16,
        MaxColumnsInIndex: u16,
        MaxColumnsInOrderBy: u16,
        MaxColumnsInSelect: u16,
        MaxColumnsInTable: u16,
        MaxConcurrentActivities: u16,
        MaxCursorNameLen: u16,
        MaxDriverConnections: u16,
        MaxIdentifierLen: u16,
        MaxIndexSize: u32,
        MaxProcedureNameLen: u16,
        MaxRowSize: u32,
        MaxRowSizeIncludesLong: bool,
        MaxSchemaNameLen: u16,
        MaxStatementLen: u32,
        MaxTableNameLen: u16,
        MaxTablesInSelect: u16,
        MaxUserNameLen: u16,
        MultResultSets: bool,
        MultipleActiveTxn: bool,
        NeedLongDataLen: bool,
        NonNullableColumns: NonNullableColumns,
        NullCollation: NullCollation,
        NumericFunctions: NumericFunctionsMask,
        OdbcApiConformance: OdbcApiConformance,
        OdbcSagCliConformance: OdbcSagCliConformance,
        OdbcSqlConformance: OdbcSqlConformance,
        OdbcVer: []const u8,
        OjCapabilities: OjCapabilitiesMask,
        OrderByColumnsInSelect: bool,
        OuterJoins: bool,
        OwnerTerm: []const u8,
        ParamArrayRowCounts: ParamArrayRowCounts,
        ParamArraySelects: ParamArraySelects,
        PosOperations: PosOperationsMask,
        PositionedStatements: PositionedStatementsMask,
        ProcedureTerm: []const u8,
        Procedures: bool,
        QuotedIdentifierCase: QuotedIdentifierCase,
        RowUpdates: bool,
        SchemaUsage: SchemaUsageMask,
        ScrollConcurrency: ScrollConcurrencyMask,
        ScrollOptions: ScrollOptionsMask,
        SearchPatternEscape: []const u8,
        ServerName: []const u8,
        SpecialCharacters: []const u8,
        Sql92Predicates: Sql92PredicatesMask,
        Sql92ValueExpressions: Sql92ValueExpressionsMask,
        StaticCursorAttributes1: StaticCursorAttributes1Mask,
        StaticCursorAttributes2: StaticCursorAttributes2Mask,
        StaticSensitivity: StaticSensitivityMask,
        StringFunctions: StringFunctionsMask,
        Subqueries: SubqueriesMask,
        SystemFunctions: SystemFunctionsMask,
        TableTerm: []const u8,
        TimedateAddIntervals: TimedateAddIntervalsMask,
        TimedateDiffIntervals: TimedateDiffIntervalsMask,
        TimedateFunctions: TimedateFunctionsMask,
        TxnCapable: TxnCapable,
        TxnIsolationOption: TxnIsolationOptionMask,
        Union: UnionMask,
        UserName: []const u8,
        XopenCliYear: []const u8,
        // IBM Db2 specific info types
        // AsciiGccsid: [buf_len]u8,
        // AsciiMccsid: [buf_len]u8,
        // AsciiSccsid: [buf_len]u8,
        // ConvertRowid: [buf_len]u8,
        // CloseBehavior: [buf_len]u8,
        // EbcdicGccsid: [buf_len]u8,
        // EbcdicMccsid: [buf_len]u8,
        // EbcdicSccsid: [buf_len]u8,
        // UnicodeGccsid: [buf_len]u8,
        // UnicodeMccsid: [buf_len]u8,
        // UnicodeSccsid: [buf_len]u8,

        pub fn activeTag(self: InfoTypeValue) InfoType {
            return std.meta.activeTag(self);
        }

        pub const AggregateFunctionsMask = struct {
            data: u32 = undefined,
        };

        pub const AlterDomainMask = struct {
            data: u32 = undefined,
        };

        pub const AlterTableMask = struct {
            data: u32 = undefined,
        };

        pub const BatchRowCountMask = struct {
            data: u32 = undefined,
        };

        pub const BatchSupportMask = struct {
            data: u32 = undefined,
        };

        pub const BookmarkPersistenceMask = struct {
            data: u32 = undefined,
        };

        pub const CatalogUsageMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertBigintMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertBinaryMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertBitMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertCharMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertDateMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertDecimalMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertDoubleMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertFloatMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertIntegerMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertIntervalDayTimeMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertIntervalYearMonthMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertLongvarbinaryMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertLongvarcharMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertNumericMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertRealMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertSmallintMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertTimeMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertTimestampMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertTinyintMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertVarbinaryMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertVarcharMask = struct {
            data: u32 = undefined,
        };

        pub const ConvertFunctionsMask = struct {
            data: u32 = undefined,
        };

        pub const CorrelationName = enum(c_int) {
            Any = c.SQL_CN_ANY,
            None = c.SQL_CN_NONE,
            Different = c.SQL_CN_DIFFERENT,
        };

        pub const CreateAssertionMask = struct {
            data: u32 = undefined,
        };

        pub const CreateCharacterSetMask = struct {
            data: u32 = undefined,
        };

        pub const CreateCollationMask = struct {
            data: u32 = undefined,
        };

        pub const CreateDomainMask = struct {
            data: u32 = undefined,
        };

        pub const CreateSchemaMask = struct {
            data: u32 = undefined,
        };

        pub const CreateTableMask = struct {
            data: u32 = undefined,
        };

        pub const CreateTranslationMask = struct {
            data: u32 = undefined,
        };

        pub const CursorBehavior = enum(c_int) {
            Delete = c.SQL_CB_DELETE,
            Close = c.SQL_CB_CLOSE,
            Preserve = c.SQL_CB_PRESERVE,
        };

        pub const CursorSensitivity = enum(c_int) {
            Insensitive = c.SQL_INSENSITIVE,
            Unspecified = c.SQL_UNSPECIFIED,
            Sensitive = c.SQL_SENSITIVE,
        };

        pub const DdlIndexMask = struct {
            data: u32 = undefined,
        };

        pub const DefaultTxnIsolationMask = struct {
            data: u32 = undefined,
        };

        pub const DropAssertionMask = struct {
            data: u32 = undefined,
        };

        pub const DropCharacterSetMask = struct {
            data: u32 = undefined,
        };

        pub const DropCollationMask = struct {
            data: u32 = undefined,
        };

        pub const DropDomainMask = struct {
            data: u32 = undefined,
        };

        pub const DropSchemaMask = struct {
            data: u32 = undefined,
        };

        pub const DropTableMask = struct {
            data: u32 = undefined,
        };

        pub const DropTranslationMask = struct {
            data: u32 = undefined,
        };

        pub const DropViewMask = struct {
            data: u32 = undefined,
        };

        pub const DynamicCursorAttributes1Mask = struct {
            data: u32 = undefined,
        };

        pub const DynamicCursorAttributes2Mask = struct {
            data: u32 = undefined,
        };

        pub const FetchDirectionMask = struct {
            data: u32 = undefined,
        };

        pub const ForwardOnlyCursorAttributes1Mask = struct {
            data: u32 = undefined,
        };

        pub const ForwardOnlyCursorAttributes2Mask = struct {
            data: u32 = undefined,
        };

        pub const GetdataExtensionsMask = struct {
            data: u32 = undefined,
        };

        pub const GroupBy = enum(c_int) {
            NoRelation = c.SQL_GB_NO_RELATION,
            NotSupported = c.SQL_GB_NOT_SUPPORTED,
            GroupByEqualsSelect = c.SQL_GB_GROUP_BY_EQUALS_SELECT,
            GroupByContainsSelect = c.SQL_GB_GROUP_BY_CONTAINS_SELECT,
        };

        pub const IdentifierCase = enum(c_int) {
            Upper = c.SQL_IC_UPPER,
            Lower = c.SQL_IC_LOWER,
            Sensitive = c.SQL_IC_SENSITIVE,
            Mixed = c.SQL_IC_MIXED,
        };

        pub const InfoSchemaViewsMask = struct {
            data: u32 = undefined,
        };

        pub const InsertStatementMask = struct {
            data: u32 = undefined,
        };

        pub const KeysetCursorAttributes1Mask = struct {
            data: u32 = undefined,
        };

        pub const KeysetCursorAttributes2Mask = struct {
            data: u32 = undefined,
        };

        pub const LockTypesMask = struct {
            data: u32 = undefined,
        };

        pub const NonNullableColumns = enum(c_int) {
            NonNull = c.SQL_NNC_NON_NULL,
            Null = c.SQL_NNC_NULL,
        };

        pub const NullCollation = enum(c_int) {
            High = c.SQL_NC_HIGH,
            Low = c.SQL_NC_LOW,
        };

        pub const NumericFunctionsMask = struct {
            data: u32 = undefined,
        };

        pub const OdbcApiConformance = enum(c_int) {
            None = c.SQL_OAC_NONE,
            Level1 = c.SQL_OAC_LEVEL1,
            Level2 = c.SQL_OAC_LEVEL2,
        };

        pub const OdbcSagCliConformance = enum(c_int) {
            NotCompliant = c.SQL_OSCC_NOT_COMPLIANT,
            Compliant = c.SQL_OSCC_COMPLIANT,
        };

        pub const OdbcSqlConformance = enum(c_int) {
            Minimum = c.SQL_OSC_MINIMUM,
            Core = c.SQL_OSC_CORE,
            Extended = c.SQL_OSC_EXTENDED,
        };

        pub const OjCapabilitiesMask = struct {
            data: u32 = undefined,
        };

        pub const ParamArrayRowCounts = enum(c_int) {
            Batch = c.SQL_PARC_BATCH,
            NoBatch = c.SQL_PARC_NO_BATCH,
        };

        pub const ParamArraySelects = enum(c_int) {
            Batch = c.SQL_PAS_BATCH,
            NoBatch = c.SQL_PAS_NO_BATCH,
            NoSelect = c.SQL_PAS_NO_SELECT,
        };

        pub const PosOperationsMask = struct {
            data: u32 = undefined,
        };

        pub const PositionedStatementsMask = struct {
            data: u32 = undefined,
        };

        pub const QuotedIdentifierCase = enum(c_int) {
            Upper = c.SQL_IC_UPPER,
            Lower = c.SQL_IC_LOWER,
            Sensitive = c.SQL_IC_SENSITIVE,
            Mixed = c.SQL_IC_MIXED,
        };

        pub const SchemaUsageMask = struct {
            data: u32 = undefined,
        };

        pub const ScrollConcurrencyMask = struct {
            data: u32 = undefined,
        };

        pub const ScrollOptionsMask = struct {
            data: u32 = undefined,
        };

        pub const Sql92PredicatesMask = struct {
            data: u32 = undefined,
        };

        pub const Sql92ValueExpressionsMask = struct {
            data: u32 = undefined,
        };

        pub const StaticCursorAttributes1Mask = struct {
            data: u32 = undefined,
        };

        pub const StaticCursorAttributes2Mask = struct {
            data: u32 = undefined,
        };

        pub const StaticSensitivityMask = struct {
            data: u32 = undefined,
        };

        pub const StringFunctionsMask = struct {
            data: u32 = undefined,
        };

        pub const SubqueriesMask = struct {
            data: u32 = undefined,
        };

        pub const SystemFunctionsMask = struct {
            data: u32 = undefined,
        };

        pub const TimedateAddIntervalsMask = struct {
            data: u32 = undefined,
        };

        pub const TimedateDiffIntervalsMask = struct {
            data: u32 = undefined,
        };

        pub const TimedateFunctionsMask = struct {
            data: u32 = undefined,
        };

        pub const TxnCapable = enum(c_int) {
            Upper = c.SQL_TC_NONE,
            Dml = c.SQL_TC_DML,
            DdlCommit = c.SQL_TC_DDL_COMMIT,
            DdlIgnore = c.SQL_TC_DDL_IGNORE,
            All = c.SQL_TC_ALL,
        };

        pub const TxnIsolationOptionMask = struct {
            data: u32 = undefined,
        };

        pub const UnionMask = struct {
            data: u32 = undefined,
        };
    };
};

fn strToBool(buf: [buf_len]u8, len: i16, expected: []const u8) bool {
    return std.mem.eql(u8, buf[0..@intCast(len)], expected);
}

fn readInt(T: type, buf: [buf_len]u8, len: i16) T {
    const slice: []const u8 = buf[0..@intCast(len)];
    return std.mem.readInt(T, @ptrCast(slice), native_endian);
}
