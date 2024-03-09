const std = @import("std");
const zig_cli = @import("zig-cli");
const zodbc = @import("zodbc");
const InfoTypeValue = zodbc.odbc.info.InfoTypeValue;

var dsn = zig_cli.Option{
    .long_name = "dsn",
    .short_alias = 'd',
    .help = "Data source name connection string",
    .required = true,
    .value_ref = zig_cli.mkRef(&config.dsn),
};

pub var cmd = zig_cli.Command{
    .name = "info",
    .options = &.{
        &dsn,
    },
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};
var config = struct {
    dsn: []const u8 = undefined,
}{};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn run() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const env = try zodbc.Environment.init(.V3);
    defer env.deinit();
    const con = try zodbc.Connection.init(env);
    defer con.deinit();
    try con.connectWithString(config.dsn);

    var info_type: InfoTypeValue = undefined;

    info_type = try con.getInfo(.AccessibleProcedures);
    try stdout.print("SQL_ACCESSIBLE_PROCEDURES={}\n", .{info_type.tag().AccessibleProcedures});

    info_type = try con.getInfo(.AccessibleTables);
    try stdout.print("SQL_ACCESSIBLE_TABLES={}\n", .{info_type.tag().AccessibleTables});

    info_type = try con.getInfo(.ActiveEnvironments);
    try stdout.print("SQL_ACTIVE_ENVIRONMENTS={}\n", .{info_type.tag().ActiveEnvironments});

    info_type = try con.getInfo(.AggregateFunctions);
    try stdout.print("SQL_AGGREGATE_FUNCTIONS={}\n", .{info_type.tag().AggregateFunctions});

    info_type = try con.getInfo(.AlterDomain);
    try stdout.print("SQL_ALTER_DOMAIN={}\n", .{info_type.tag().AlterDomain});

    info_type = try con.getInfo(.AlterTable);
    try stdout.print("SQL_ALTER_TABLE={}\n", .{info_type.tag().AlterTable});

    info_type = try con.getInfo(.BatchRowCount);
    try stdout.print("SQL_BATCH_ROW_COUNT={}\n", .{info_type.tag().BatchRowCount});

    info_type = try con.getInfo(.BatchSupport);
    try stdout.print("SQL_BATCH_SUPPORT={}\n", .{info_type.tag().BatchSupport});

    info_type = try con.getInfo(.BookmarkPersistence);
    try stdout.print("SQL_BOOKMARK_PERSISTENEC={}\n", .{info_type.tag().BookmarkPersistence});

    info_type = try con.getInfo(.CatalogLocation);
    try stdout.print("SQL_CATALOG_LOCATION={}\n", .{info_type.tag().CatalogLocation});

    info_type = try con.getInfo(.CatalogName);
    try stdout.print("SQL_CATALOG_NAME={}\n", .{info_type.tag().CatalogName});

    info_type = try con.getInfo(.CatalogTerm);
    try stdout.print("SQL_CATALOG_TERM={s}\n", .{info_type.tag().CatalogTerm});

    info_type = try con.getInfo(.CatalogUsage);
    try stdout.print("SQL_CATALOG_USAGE={}\n", .{info_type.tag().CatalogUsage});

    info_type = try con.getInfo(.CollationSeq);
    try stdout.print("SQL_COLLATION_SEQ={s}\n", .{info_type.tag().CollationSeq});

    info_type = try con.getInfo(.ColumnAlias);
    try stdout.print("SQL_COLUMN_ALIAS={}\n", .{info_type.tag().ColumnAlias});

    // info_type = try con.getInfo(.ConcatNullBehavior);
    // try stdout.print("SQL_CONCAT_BEHAVIOR={}\n", .{info_type.tag().ConcatNullBehavior});

    info_type = try con.getInfo(.ConvertBigint);
    try stdout.print("SQL_CONVERT_BIGINT={}\n", .{info_type.tag().ConvertBigint});

    info_type = try con.getInfo(.ConvertBinary);
    try stdout.print("SQL_CONVERT_BINARY={}\n", .{info_type.tag().ConvertBinary});

    info_type = try con.getInfo(.ConvertBit);
    try stdout.print("SQL_CONVERT_BIT={}\n", .{info_type.tag().ConvertBit});

    info_type = try con.getInfo(.ConvertChar);
    try stdout.print("SQL_CONVERT_CHAR={}\n", .{info_type.tag().ConvertChar});

    info_type = try con.getInfo(.ConvertDate);
    try stdout.print("SQL_CONVERT_DATE={}\n", .{info_type.tag().ConvertDate});

    info_type = try con.getInfo(.ConvertDecimal);
    try stdout.print("SQL_CONVERT_DECIMAL={}\n", .{info_type.tag().ConvertDecimal});

    info_type = try con.getInfo(.ConvertDouble);
    try stdout.print("SQL_CONVERT_DOUBLE={}\n", .{info_type.tag().ConvertDouble});

    info_type = try con.getInfo(.ConvertFloat);
    try stdout.print("SQL_CONVERT_FLOAT={}\n", .{info_type.tag().ConvertFloat});

    info_type = try con.getInfo(.ConvertInteger);
    try stdout.print("SQL_CONVERT_INTEGER={}\n", .{info_type.tag().ConvertInteger});

    info_type = try con.getInfo(.ConvertIntervalDayTime);
    try stdout.print("SQL_CONVERT_INTERVAL_DAY_TIME={}\n", .{info_type.tag().ConvertIntervalDayTime});

    info_type = try con.getInfo(.ConvertIntervalYearMonth);
    try stdout.print("SQL_CONVERT_INTERVAL_YEAR_MONTH={}\n", .{info_type.tag().ConvertIntervalYearMonth});

    info_type = try con.getInfo(.ConvertLongvarbinary);
    try stdout.print("SQL_CONVERT_LONGVARBINARY={}\n", .{info_type.tag().ConvertLongvarbinary});

    info_type = try con.getInfo(.ConvertLongvarchar);
    try stdout.print("SQL_CONVERT_LONGVARCHAR={}\n", .{info_type.tag().ConvertLongvarchar});

    info_type = try con.getInfo(.ConvertNumeric);
    try stdout.print("SQL_CONVERT_NUMERIC={}\n", .{info_type.tag().ConvertNumeric});

    info_type = try con.getInfo(.ConvertReal);
    try stdout.print("SQL_CONVERT_REAL={}\n", .{info_type.tag().ConvertReal});

    info_type = try con.getInfo(.ConvertSmallint);
    try stdout.print("SQL_CONVERT_SMALLINT={}\n", .{info_type.tag().ConvertSmallint});

    info_type = try con.getInfo(.ConvertTime);
    try stdout.print("SQL_CONVERT_TIME={}\n", .{info_type.tag().ConvertTime});

    info_type = try con.getInfo(.ConvertTimestamp);
    try stdout.print("SQL_CONVERT_TIMESTAMP={}\n", .{info_type.tag().ConvertTimestamp});

    info_type = try con.getInfo(.ConvertTinyint);
    try stdout.print("SQL_CONVERT_TINYINT={}\n", .{info_type.tag().ConvertTinyint});

    info_type = try con.getInfo(.ConvertVarbinary);
    try stdout.print("SQL_CONVERT_VARBINARY={}\n", .{info_type.tag().ConvertVarbinary});

    info_type = try con.getInfo(.ConvertVarchar);
    try stdout.print("SQL_CONVERT_VARCHAR={}\n", .{info_type.tag().ConvertVarchar});

    info_type = try con.getInfo(.ConvertFunctions);
    try stdout.print("SQL_CONVERT_FUNCTIONS={}\n", .{info_type.tag().ConvertFunctions});

    info_type = try con.getInfo(.CorrelationName);
    try stdout.print("SQL_CORRELATION_NAME={}\n", .{info_type.tag().CorrelationName});

    info_type = try con.getInfo(.CreateAssertion);
    try stdout.print("SQL_CREATE_ASSERTION={}\n", .{info_type.tag().CreateAssertion});

    info_type = try con.getInfo(.CreateCharacterSet);
    try stdout.print("SQL_CREATE_CHARACTER_SET={}\n", .{info_type.tag().CreateCharacterSet});

    info_type = try con.getInfo(.CreateCollation);
    try stdout.print("SQL_CREATE_COLLATION={}\n", .{info_type.tag().CreateCollation});

    info_type = try con.getInfo(.CreateDomain);
    try stdout.print("SQL_CREATE_DOMAIN={}\n", .{info_type.tag().CreateDomain});

    info_type = try con.getInfo(.CreateSchema);
    try stdout.print("SQL_CREATE_SCHEMA={}\n", .{info_type.tag().CreateSchema});

    info_type = try con.getInfo(.CreateTable);
    try stdout.print("SQL_CREATE_TABLE={}\n", .{info_type.tag().CreateTable});

    info_type = try con.getInfo(.CreateTranslation);
    try stdout.print("SQL_CREATE_TRANSLATION={}\n", .{info_type.tag().CreateTranslation});

    info_type = try con.getInfo(.CursorCommitBehavior);
    try stdout.print("SQL_CURSOR_COMMIT_BEHAVIOR={}\n", .{info_type.tag().CursorCommitBehavior});

    info_type = try con.getInfo(.CursorRollbackBehavior);
    try stdout.print("SQL_CURSOR_ROLLBACK_BEHAVIOR={}\n", .{info_type.tag().CursorRollbackBehavior});

    info_type = try con.getInfo(.CursorSensitivity);
    try stdout.print("SQL_CURSOR_SENSITIVITY={}\n", .{info_type.tag().CursorSensitivity});

    info_type = try con.getInfo(.DataSourceName);
    try stdout.print("SQL_DATA_SOURCE_NAME={s}\n", .{info_type.tag().DataSourceName});

    info_type = try con.getInfo(.DataSourceReadOnly);
    try stdout.print("SQL_DATA_SOURCE_READ_ONLY={}\n", .{info_type.tag().DataSourceReadOnly});

    info_type = try con.getInfo(.DatabaseName);
    try stdout.print("SQL_DATABASE_NAME={s}\n", .{info_type.tag().DatabaseName});

    info_type = try con.getInfo(.DbmsName);
    try stdout.print("SQL_DBMS_NAME={s}\n", .{info_type.tag().DbmsName});

    info_type = try con.getInfo(.DbmsVer);
    try stdout.print("SQL_DBMS_VER={s}\n", .{info_type.tag().DbmsVer});

    info_type = try con.getInfo(.DdlIndex);
    try stdout.print("SQL_DDL_INDEX={}\n", .{info_type.tag().DdlIndex});

    info_type = try con.getInfo(.DefaultTxnIsolation);
    try stdout.print("SQL_DEFAULT_TXN_ISOLATION={}\n", .{info_type.tag().DefaultTxnIsolation});

    info_type = try con.getInfo(.DescribeParameter);
    try stdout.print("SQL_DESCRIBE_PARAMETER={}\n", .{info_type.tag().DescribeParameter});

    info_type = try con.getInfo(.DriverHdbc);
    try stdout.print("SQL_DRIVER_HDBC={}\n", .{info_type.tag().DriverHdbc});

    info_type = try con.getInfo(.DriverHenv);
    try stdout.print("SQL_DRIVER_HENV={}\n", .{info_type.tag().DriverHenv});

    info_type = try con.getInfo(.DriverHlib);
    try stdout.print("SQL_DRIVER_HLIB={}\n", .{info_type.tag().DriverHlib});

    // info_type = try con.getInfo(.DriverHstmt);
    // try stdout.print("SQL_DRIVER_HSTMT={}\n", .{info_type.tag().DriverHstmt});

    info_type = try con.getInfo(.DriverName);
    try stdout.print("SQL_DRIVER_NAME={s}\n", .{info_type.tag().DriverName});

    info_type = try con.getInfo(.DriverOdbcVer);
    try stdout.print("SQL_DRIVER_ODBC_VER={s}\n", .{info_type.tag().DriverOdbcVer});

    info_type = try con.getInfo(.DriverVer);
    try stdout.print("SQL_DRIVER_VER={s}\n", .{info_type.tag().DriverVer});

    info_type = try con.getInfo(.DropAssertion);
    try stdout.print("SQL_DROP_ASSERTION={}\n", .{info_type.tag().DropAssertion});

    info_type = try con.getInfo(.DropCharacterSet);
    try stdout.print("SQL_DROP_CHARACTER_SET={}\n", .{info_type.tag().DropCharacterSet});

    info_type = try con.getInfo(.DropCollation);
    try stdout.print("SQL_DROP_COLLATION={}\n", .{info_type.tag().DropCollation});

    info_type = try con.getInfo(.DropDomain);
    try stdout.print("SQL_DROP_DOMAIN={}\n", .{info_type.tag().DropDomain});

    info_type = try con.getInfo(.DropSchema);
    try stdout.print("SQL_DROP_SCHEMA={}\n", .{info_type.tag().DropSchema});

    info_type = try con.getInfo(.DropTable);
    try stdout.print("SQL_DROP_TABLE={}\n", .{info_type.tag().DropTable});

    info_type = try con.getInfo(.DropTranslation);
    try stdout.print("SQL_DROP_TRANSLATION={}\n", .{info_type.tag().DropTranslation});

    info_type = try con.getInfo(.DropView);
    try stdout.print("SQL_DROP_VIEW={}\n", .{info_type.tag().DropView});

    info_type = try con.getInfo(.DynamicCursorAttributes1);
    try stdout.print("SQL_DYNAMIC_CURSOR_ATTRIBUTES1={}\n", .{info_type.tag().DynamicCursorAttributes1});

    info_type = try con.getInfo(.DynamicCursorAttributes2);
    try stdout.print("SQL_DYNAMIC_CURSOR_ATTRIBUTES2={}\n", .{info_type.tag().DynamicCursorAttributes2});

    info_type = try con.getInfo(.ExpressionsInOrderby);
    try stdout.print("SQL_EXPRESSIONS_IN_ORDERBY={}\n", .{info_type.tag().ExpressionsInOrderby});

    info_type = try con.getInfo(.FetchDirection);
    try stdout.print("SQL_FETCH_DIRECTION={}\n", .{info_type.tag().FetchDirection});

    info_type = try con.getInfo(.FileUsage);
    try stdout.print("SQL_FILE_USAGE={}\n", .{info_type.tag().FileUsage});

    info_type = try con.getInfo(.ForwardOnlyCursorAttributes1);
    try stdout.print("SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1={}\n", .{info_type.tag().ForwardOnlyCursorAttributes1});

    info_type = try con.getInfo(.ForwardOnlyCursorAttributes2);
    try stdout.print("SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2={}\n", .{info_type.tag().ForwardOnlyCursorAttributes2});

    info_type = try con.getInfo(.GetdataExtensions);
    try stdout.print("SQL_GETDATA_EXTENSIONS={}\n", .{info_type.tag().GetdataExtensions});

    info_type = try con.getInfo(.GroupBy);
    try stdout.print("SQL_GROUP_BY={}\n", .{info_type.tag().GroupBy});

    info_type = try con.getInfo(.IdentifierCase);
    try stdout.print("SQL_IDENTIFIER_CASE={}\n", .{info_type.tag().IdentifierCase});

    info_type = try con.getInfo(.IdentifierQuoteChar);
    try stdout.print("SQL_IDENTIFIER_QUOTE_CHAR={s}\n", .{info_type.tag().IdentifierQuoteChar});

    info_type = try con.getInfo(.InfoSchemaViews);
    try stdout.print("SQL_INFO_SCHEMA_VIEWS={}\n", .{info_type.tag().InfoSchemaViews});

    info_type = try con.getInfo(.InsertStatement);
    try stdout.print("SQL_INSERT_STATEMENT={}\n", .{info_type.tag().InsertStatement});

    info_type = try con.getInfo(.Integrity);
    try stdout.print("SQL_INTEGRITY={}\n", .{info_type.tag().Integrity});

    info_type = try con.getInfo(.KeysetCursorAttributes1);
    try stdout.print("SQL_KEYSET_CURSOR_ATTRIBUTES1={}\n", .{info_type.tag().KeysetCursorAttributes1});

    info_type = try con.getInfo(.KeysetCursorAttributes2);
    try stdout.print("SQL_KEYSET_CURSOR_ATTRIBUTES2={}\n", .{info_type.tag().KeysetCursorAttributes2});

    info_type = try con.getInfo(.Keywords);
    try stdout.print("SQL_KEYWORDS={s}\n", .{info_type.tag().Keywords});

    info_type = try con.getInfo(.LikeEscapeClause);
    try stdout.print("SQL_LIKE_ESCAPE_CLAUSE={s}\n", .{info_type.tag().LikeEscapeClause});

    info_type = try con.getInfo(.LockTypes);
    try stdout.print("SQL_LOCK_TYPES={}\n", .{info_type.tag().LockTypes});

    info_type = try con.getInfo(.MaxAsyncConcurrentStatements);
    try stdout.print("SQL_MAX_ASYNC_CONCURRENT_STATEMENTS={}\n", .{info_type.tag().MaxAsyncConcurrentStatements});

    info_type = try con.getInfo(.MaxBinaryLiteralLen);
    try stdout.print("SQL_MAX_BINARY_LITERAL_LEN={}\n", .{info_type.tag().MaxBinaryLiteralLen});

    info_type = try con.getInfo(.MaxCatalogNameLen);
    try stdout.print("SQL_MAX_CATALOG_NAME_LEN={}\n", .{info_type.tag().MaxCatalogNameLen});

    info_type = try con.getInfo(.MaxCharLiteralLen);
    try stdout.print("SQL_MAX_CHAR_LITERAL_LEN={}\n", .{info_type.tag().MaxCharLiteralLen});

    info_type = try con.getInfo(.MaxColumnNameLen);
    try stdout.print("SQL_MAX_COLUMN_NAME_LEN={}\n", .{info_type.tag().MaxColumnNameLen});

    info_type = try con.getInfo(.MaxColumnsInGroupBy);
    try stdout.print("SQL_MAX_COLUMNS_IN_GROUP_BY={}\n", .{info_type.tag().MaxColumnsInGroupBy});

    info_type = try con.getInfo(.MaxColumnsInIndex);
    try stdout.print("SQL_MAX_COLUMNS_IN_INDEX={}\n", .{info_type.tag().MaxColumnsInIndex});

    info_type = try con.getInfo(.MaxColumnsInOrderBy);
    try stdout.print("SQL_MAX_COLUMNS_IN_ORDER_BY={}\n", .{info_type.tag().MaxColumnsInOrderBy});

    info_type = try con.getInfo(.MaxColumnsInSelect);
    try stdout.print("SQL_MAX_COLUMNS_IN_SELECT={}\n", .{info_type.tag().MaxColumnsInSelect});

    info_type = try con.getInfo(.MaxColumnsInTable);
    try stdout.print("SQL_MAX_COLUMNS_IN_TABLE={}\n", .{info_type.tag().MaxColumnsInTable});

    info_type = try con.getInfo(.MaxConcurrentActivities);
    try stdout.print("SQL_CONCURRENT_ACTIVITIES={}\n", .{info_type.tag().MaxConcurrentActivities});

    info_type = try con.getInfo(.MaxCursorNameLen);
    try stdout.print("SQL_MAX_CURSOR_NAME_LEN={}\n", .{info_type.tag().MaxCursorNameLen});

    info_type = try con.getInfo(.MaxDriverConnections);
    try stdout.print("SQL_MAX_DRIVER_CONNECTIONS={}\n", .{info_type.tag().MaxDriverConnections});

    info_type = try con.getInfo(.MaxIdentifierLen);
    try stdout.print("SQL_MAX_IDENTIFIER_LEN={}\n", .{info_type.tag().MaxIdentifierLen});

    info_type = try con.getInfo(.MaxIndexSize);
    try stdout.print("SQL_MAX_INDEX_SIZE={}\n", .{info_type.tag().MaxIndexSize});

    info_type = try con.getInfo(.MaxProcedureNameLen);
    try stdout.print("SQL_MAX_PROCEDURE_NAME_LEN={}\n", .{info_type.tag().MaxProcedureNameLen});

    info_type = try con.getInfo(.MaxRowSize);
    try stdout.print("SQL_MAX_ROW_SIZE={}\n", .{info_type.tag().MaxRowSize});

    info_type = try con.getInfo(.MaxRowSizeIncludesLong);
    try stdout.print("SQL_MAX_ROW_SIZE_INCLUDES_LONG={}\n", .{info_type.tag().MaxRowSizeIncludesLong});

    info_type = try con.getInfo(.MaxSchemaNameLen);
    try stdout.print("SQL_MAX_SCHEMA_NAME_LEN={}\n", .{info_type.tag().MaxSchemaNameLen});

    info_type = try con.getInfo(.MaxTableNameLen);
    try stdout.print("SQL_MAX_TABLE_NAME_LEN={}\n", .{info_type.tag().MaxTableNameLen});

    info_type = try con.getInfo(.MaxTablesInSelect);
    try stdout.print("SQL_MAX_TABLES_IN_SELECT={}\n", .{info_type.tag().MaxTablesInSelect});

    info_type = try con.getInfo(.MaxUserNameLen);
    try stdout.print("SQL_MAX_USER_NAME_LEN={}\n", .{info_type.tag().MaxUserNameLen});

    info_type = try con.getInfo(.MaxSchemaNameLen);
    try stdout.print("SQL_MAX_SCHEMA_NAME_LEN={}\n", .{info_type.tag().MaxSchemaNameLen});

    info_type = try con.getInfo(.MultResultSets);
    try stdout.print("SQL_MULT_RESULT_SETS={}\n", .{info_type.tag().MultResultSets});

    info_type = try con.getInfo(.MultipleActiveTxn);
    try stdout.print("SQL_MULTIPLE_ACTIVE_TXN={}\n", .{info_type.tag().MultipleActiveTxn});

    info_type = try con.getInfo(.NeedLongDataLen);
    try stdout.print("SQL_NEED_LONG_DATA_LEN={}\n", .{info_type.tag().NeedLongDataLen});

    info_type = try con.getInfo(.NonNullableColumns);
    try stdout.print("SQL_NON_NULLABLE_COLUMNS={}\n", .{info_type.tag().NonNullableColumns});

    info_type = try con.getInfo(.NullCollation);
    try stdout.print("SQL_NULL_COLLATION={}\n", .{info_type.tag().NullCollation});

    info_type = try con.getInfo(.NumericFunctions);
    try stdout.print("SQL_NUMERIC_FUNCTIONS={}\n", .{info_type.tag().NumericFunctions});

    info_type = try con.getInfo(.OdbcApiConformance);
    try stdout.print("SQL_ODBC_API_CONFORMANCE={}\n", .{info_type.tag().OdbcApiConformance});

    info_type = try con.getInfo(.OdbcSagCliConformance);
    try stdout.print("SQL_ODBC_SAG_CLI_CONFORMANCE={}\n", .{info_type.tag().OdbcSagCliConformance});

    info_type = try con.getInfo(.OdbcSqlConformance);
    try stdout.print("SQL_ODBC_SQL_CONFORMANCE={}\n", .{info_type.tag().OdbcSqlConformance});

    info_type = try con.getInfo(.OdbcVer);
    try stdout.print("SQL_ODBC_VER={s}\n", .{info_type.tag().OdbcVer});

    info_type = try con.getInfo(.OjCapabilities);
    try stdout.print("SQL_OJ_CAPABILITIES={}\n", .{info_type.tag().OjCapabilities});

    info_type = try con.getInfo(.OrderByColumnsInSelect);
    try stdout.print("SQL_ORDER_BY_COLUMNS_IN_SELECT={}\n", .{info_type.tag().OrderByColumnsInSelect});

    info_type = try con.getInfo(.OuterJoins);
    try stdout.print("SQL_OUTER_JOINS={}\n", .{info_type.tag().OuterJoins});

    info_type = try con.getInfo(.OwnerTerm);
    try stdout.print("SQL_OWNER_TERM={s}\n", .{info_type.tag().OwnerTerm});

    info_type = try con.getInfo(.ParamArrayRowCounts);
    try stdout.print("SQL_PARAM_ARRAY_ROW_COUNTS={}\n", .{info_type.tag().ParamArrayRowCounts});

    info_type = try con.getInfo(.ParamArraySelects);
    try stdout.print("SQL_PARAM_ARRAY_SELECTS={}\n", .{info_type.tag().ParamArraySelects});

    info_type = try con.getInfo(.PosOperations);
    try stdout.print("SQL_POS_OPERATIONS={}\n", .{info_type.tag().PosOperations});

    info_type = try con.getInfo(.PositionedStatements);
    try stdout.print("SQL_POSITIONED_STATEMENTS={}\n", .{info_type.tag().PositionedStatements});

    info_type = try con.getInfo(.ProcedureTerm);
    try stdout.print("SQL_PROCEDURE_TERM={s}\n", .{info_type.tag().ProcedureTerm});

    info_type = try con.getInfo(.Procedures);
    try stdout.print("SQL_PROCEDURES={}\n", .{info_type.tag().Procedures});

    info_type = try con.getInfo(.QuotedIdentifierCase);
    try stdout.print("SQL_QUOTED_IDENTIFIER_CASE={}\n", .{info_type.tag().QuotedIdentifierCase});

    info_type = try con.getInfo(.RowUpdates);
    try stdout.print("SQL_ROW_UPDATES={}\n", .{info_type.tag().RowUpdates});

    info_type = try con.getInfo(.SchemaUsage);
    try stdout.print("SQL_SCHEMA_USAGE={}\n", .{info_type.tag().SchemaUsage});

    info_type = try con.getInfo(.ScrollConcurrency);
    try stdout.print("SQL_SCROLL_CONCURRENCY={}\n", .{info_type.tag().ScrollConcurrency});

    info_type = try con.getInfo(.ScrollOptions);
    try stdout.print("SQL_SCROLL_OPTIONS={}\n", .{info_type.tag().ScrollOptions});

    info_type = try con.getInfo(.SearchPatternEscape);
    try stdout.print("SQL_SEARCH_PATTERN_ESCAPE={s}\n", .{info_type.tag().SearchPatternEscape});

    info_type = try con.getInfo(.ServerName);
    try stdout.print("SQL_SERVER_NAME={s}\n", .{info_type.tag().ServerName});

    info_type = try con.getInfo(.SpecialCharacters);
    try stdout.print("SQL_SPECIAL_CHARACTERS={s}\n", .{info_type.tag().SpecialCharacters});

    info_type = try con.getInfo(.Sql92Predicates);
    try stdout.print("SQL_SQL92_PREDICATES={}\n", .{info_type.tag().Sql92Predicates});

    info_type = try con.getInfo(.Sql92ValueExpressions);
    try stdout.print("SQL_SQL92_VALUE_EXPRESSIONS={}\n", .{info_type.tag().Sql92ValueExpressions});

    info_type = try con.getInfo(.StaticCursorAttributes1);
    try stdout.print("SQL_STATIC_CURSOR_ATTRIBUTES1={}\n", .{info_type.tag().StaticCursorAttributes1});

    info_type = try con.getInfo(.StaticCursorAttributes2);
    try stdout.print("SQL_STATIC_CURSOR_ATTRIBUTES2={}\n", .{info_type.tag().StaticCursorAttributes2});

    info_type = try con.getInfo(.StaticSensitivity);
    try stdout.print("SQL_STATIC_SENSITIVITY={}\n", .{info_type.tag().StaticSensitivity});

    info_type = try con.getInfo(.StringFunctions);
    try stdout.print("SQL_STRING_FUNCTIONS={}\n", .{info_type.tag().StringFunctions});

    info_type = try con.getInfo(.Subqueries);
    try stdout.print("SQL_SUBQUERIES={}\n", .{info_type.tag().Subqueries});

    info_type = try con.getInfo(.SystemFunctions);
    try stdout.print("SQL_SYSTEM_FUNCTIONS={}\n", .{info_type.tag().SystemFunctions});

    info_type = try con.getInfo(.TableTerm);
    try stdout.print("SQL_TABLE_TERM={s}\n", .{info_type.tag().TableTerm});

    info_type = try con.getInfo(.TimedateAddIntervals);
    try stdout.print("SQL_TIMEDATE_ADD_INTERVALS={}\n", .{info_type.tag().TimedateAddIntervals});

    info_type = try con.getInfo(.TimedateDiffIntervals);
    try stdout.print("SQL_TIMEDATE_DIFF_INTERVALS={}\n", .{info_type.tag().TimedateDiffIntervals});

    info_type = try con.getInfo(.TimedateFunctions);
    try stdout.print("SQL_TIMEDATE_FUNCTIONS={}\n", .{info_type.tag().TimedateFunctions});

    info_type = try con.getInfo(.TxnCapable);
    try stdout.print("SQL_TXN_CAPABLE={}\n", .{info_type.tag().TxnCapable});

    info_type = try con.getInfo(.TxnIsolationOption);
    try stdout.print("SQL_TXN_ISOLATION_OPTION={}\n", .{info_type.tag().TxnIsolationOption});

    info_type = try con.getInfo(.Union);
    try stdout.print("SQL_UNION={}\n", .{info_type.tag().Union});

    info_type = try con.getInfo(.UserName);
    try stdout.print("SQL_USER_NAME={s}\n", .{info_type.tag().UserName});

    info_type = try con.getInfo(.XopenCliYear);
    try stdout.print("SQL_XOPEN_CLI_YEAR={s}\n", .{info_type.tag().XopenCliYear});

    try bw.flush();
}
