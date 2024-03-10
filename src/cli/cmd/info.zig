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

    var odbc_buf: [2048]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const accessible_procedures_info = try con.getInfo(allocator, .AccessibleProcedures, odbc_buf[0..]);
    defer accessible_procedures_info.deinit(allocator);
    try stdout.print("SQL_ACCESSIBLE_PROCEDURES={}\n", .{accessible_procedures_info.AccessibleProcedures});

    @memset(odbc_buf[0..], 0);
    const accessible_tables_info = try con.getInfo(allocator, .AccessibleTables, odbc_buf[0..]);
    defer accessible_tables_info.deinit(allocator);
    try stdout.print("SQL_ACCESSIBLE_TABLES={}\n", .{accessible_tables_info.AccessibleTables});

    @memset(odbc_buf[0..], 0);
    const active_environments_info = try con.getInfo(allocator, .ActiveEnvironments, odbc_buf[0..]);
    defer active_environments_info.deinit(allocator);
    try stdout.print("SQL_ACTIVE_ENVIRONMENTS={}\n", .{active_environments_info.ActiveEnvironments});

    @memset(odbc_buf[0..], 0);
    const aggregate_functions_info = try con.getInfo(allocator, .AggregateFunctions, odbc_buf[0..]);
    defer aggregate_functions_info.deinit(allocator);
    try stdout.print("SQL_AGGREGATE_FUNCTIONS={}\n", .{aggregate_functions_info.AggregateFunctions});

    @memset(odbc_buf[0..], 0);
    const alter_domain_info = try con.getInfo(allocator, .AlterDomain, odbc_buf[0..]);
    defer alter_domain_info.deinit(allocator);
    try stdout.print("SQL_ALTER_DOMAIN={}\n", .{alter_domain_info.AlterDomain});

    @memset(odbc_buf[0..], 0);
    const alter_table_info = try con.getInfo(allocator, .AlterTable, odbc_buf[0..]);
    defer alter_table_info.deinit(allocator);
    try stdout.print("SQL_ALTER_TABLE={}\n", .{alter_table_info.AlterTable});

    @memset(odbc_buf[0..], 0);
    const batch_row_count_info = try con.getInfo(allocator, .BatchRowCount, odbc_buf[0..]);
    defer batch_row_count_info.deinit(allocator);
    try stdout.print("SQL_BATCH_ROW_COUNT={}\n", .{batch_row_count_info.BatchRowCount});

    @memset(odbc_buf[0..], 0);
    const batch_support_info = try con.getInfo(allocator, .BatchSupport, odbc_buf[0..]);
    defer batch_support_info.deinit(allocator);
    try stdout.print("SQL_BATCH_SUPPORT={}\n", .{batch_support_info.BatchSupport});

    @memset(odbc_buf[0..], 0);
    const bookmark_persistence_info = try con.getInfo(allocator, .BookmarkPersistence, odbc_buf[0..]);
    defer bookmark_persistence_info.deinit(allocator);
    try stdout.print("SQL_BOOKMARK_PERSISTENCE={}\n", .{bookmark_persistence_info.BookmarkPersistence});

    @memset(odbc_buf[0..], 0);
    const catalog_location_info = try con.getInfo(allocator, .CatalogLocation, odbc_buf[0..]);
    defer catalog_location_info.deinit(allocator);
    try stdout.print("SQL_CATALOG_LOCATION={}\n", .{catalog_location_info.CatalogLocation});

    @memset(odbc_buf[0..], 0);
    const catalog_name_info = try con.getInfo(allocator, .CatalogName, odbc_buf[0..]);
    defer catalog_name_info.deinit(allocator);
    try stdout.print("SQL_CATALOG_NAME={}\n", .{catalog_name_info.CatalogName});

    @memset(odbc_buf[0..], 0);
    const catalog_name_separator_info = try con.getInfo(allocator, .CatalogNameSeparator, odbc_buf[0..]);
    defer catalog_name_separator_info.deinit(allocator);
    try stdout.print("SQL_CATALOG_NAME_SEPARATOR={s}\n", .{catalog_name_separator_info.CatalogNameSeparator});

    @memset(odbc_buf[0..], 0);
    const catalog_term_info = try con.getInfo(allocator, .CatalogTerm, odbc_buf[0..]);
    defer catalog_term_info.deinit(allocator);
    try stdout.print("SQL_CATALOG_TERM={s}\n", .{catalog_term_info.CatalogTerm});

    @memset(odbc_buf[0..], 0);
    const catalog_usage_info = try con.getInfo(allocator, .CatalogUsage, odbc_buf[0..]);
    defer catalog_usage_info.deinit(allocator);
    try stdout.print("SQL_CATALOG_USAGE={}\n", .{catalog_usage_info.CatalogUsage});

    @memset(odbc_buf[0..], 0);
    const collation_seq_info = try con.getInfo(allocator, .CollationSeq, odbc_buf[0..]);
    defer collation_seq_info.deinit(allocator);
    try stdout.print("SQL_COLLATION_SEQ={s}\n", .{collation_seq_info.CollationSeq});

    @memset(odbc_buf[0..], 0);
    const column_alias_info = try con.getInfo(allocator, .ColumnAlias, odbc_buf[0..]);
    defer column_alias_info.deinit(allocator);
    try stdout.print("SQL_COLUMN_ALIAS={}\n", .{column_alias_info.ColumnAlias});

    @memset(odbc_buf[0..], 0);
    const concat_null_behavior_info = try con.getInfo(allocator, .ColumnAlias, odbc_buf[0..]);
    defer concat_null_behavior_info.deinit(allocator);
    try stdout.print("SQL_CONCAT_NULL_BEHAVIOR={}\n", .{concat_null_behavior_info.ConcatNullBehavior});

    @memset(odbc_buf[0..], 0);
    const convert_bigint_info = try con.getInfo(allocator, .ConvertBigint, odbc_buf[0..]);
    defer convert_bigint_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_BIGINT={}\n", .{convert_bigint_info.ConvertBigint});

    @memset(odbc_buf[0..], 0);
    const convert_binary_info = try con.getInfo(allocator, .ConvertBinary, odbc_buf[0..]);
    defer convert_binary_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_BINARY={}\n", .{convert_binary_info.ConvertBinary});

    @memset(odbc_buf[0..], 0);
    const convert_bit_info = try con.getInfo(allocator, .ConvertBit, odbc_buf[0..]);
    defer convert_bit_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_BIT={}\n", .{convert_bit_info.ConvertBit});

    @memset(odbc_buf[0..], 0);
    const convert_char_info = try con.getInfo(allocator, .ConvertChar, odbc_buf[0..]);
    defer convert_char_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_CHAR={}\n", .{convert_char_info.ConvertChar});

    @memset(odbc_buf[0..], 0);
    const convert_date_info = try con.getInfo(allocator, .ConvertDate, odbc_buf[0..]);
    defer convert_date_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_DATE={}\n", .{convert_date_info.ConvertDate});

    @memset(odbc_buf[0..], 0);
    const convert_decimal_info = try con.getInfo(allocator, .ConvertDecimal, odbc_buf[0..]);
    defer convert_decimal_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_DECIMAL={}\n", .{convert_date_info.ConvertDecimal});

    @memset(odbc_buf[0..], 0);
    const convert_double_info = try con.getInfo(allocator, .ConvertDouble, odbc_buf[0..]);
    defer convert_double_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_DOUBLE={}\n", .{convert_date_info.ConvertDouble});

    @memset(odbc_buf[0..], 0);
    const convert_float_info = try con.getInfo(allocator, .ConvertFloat, odbc_buf[0..]);
    defer convert_float_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_FLOAT={}\n", .{convert_date_info.ConvertFloat});

    @memset(odbc_buf[0..], 0);
    const convert_integer_info = try con.getInfo(allocator, .ConvertInteger, odbc_buf[0..]);
    defer convert_integer_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_INTEGER={}\n", .{convert_date_info.ConvertInteger});

    @memset(odbc_buf[0..], 0);
    const convert_interval_day_time_info = try con.getInfo(allocator, .ConvertIntervalDayTime, odbc_buf[0..]);
    defer convert_interval_day_time_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_INTERVAL_DAY_TIME={}\n", .{convert_interval_day_time_info.ConvertIntervalDayTime});

    @memset(odbc_buf[0..], 0);
    const convert_interval_year_month_info = try con.getInfo(allocator, .ConvertIntervalYearMonth, odbc_buf[0..]);
    defer convert_interval_year_month_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_INTERVAL_YEAR_MONTH={}\n", .{convert_interval_year_month_info.ConvertIntervalYearMonth});

    @memset(odbc_buf[0..], 0);
    const convert_longvarbinary_info = try con.getInfo(allocator, .ConvertLongvarbinary, odbc_buf[0..]);
    defer convert_longvarbinary_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_LONGVARBINARY={}\n", .{convert_longvarbinary_info.ConvertLongvarbinary});

    @memset(odbc_buf[0..], 0);
    const convert_longvarchar_info = try con.getInfo(allocator, .ConvertLongvarchar, odbc_buf[0..]);
    defer convert_longvarchar_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_LONGVARCHAR={}\n", .{convert_longvarchar_info.ConvertLongvarchar});

    @memset(odbc_buf[0..], 0);
    const convert_numeric_info = try con.getInfo(allocator, .ConvertNumeric, odbc_buf[0..]);
    defer convert_numeric_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_NUMERIC={}\n", .{convert_numeric_info.ConvertNumeric});

    @memset(odbc_buf[0..], 0);
    const convert_real_info = try con.getInfo(allocator, .ConvertReal, odbc_buf[0..]);
    defer convert_real_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_REAL={}\n", .{convert_real_info.ConvertReal});

    @memset(odbc_buf[0..], 0);
    const convert_smallint_info = try con.getInfo(allocator, .ConvertSmallint, odbc_buf[0..]);
    defer convert_smallint_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_SMALLINT={}\n", .{convert_smallint_info.ConvertSmallint});

    @memset(odbc_buf[0..], 0);
    const convert_time_info = try con.getInfo(allocator, .ConvertTime, odbc_buf[0..]);
    defer convert_time_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_TIME={}\n", .{convert_time_info.ConvertTime});

    @memset(odbc_buf[0..], 0);
    const convert_timestamp_info = try con.getInfo(allocator, .ConvertTimestamp, odbc_buf[0..]);
    defer convert_timestamp_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_TIMESTAMP={}\n", .{convert_time_info.ConvertTimestamp});

    @memset(odbc_buf[0..], 0);
    const convert_tinyint_info = try con.getInfo(allocator, .ConvertTinyint, odbc_buf[0..]);
    defer convert_tinyint_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_TINYINT={}\n", .{convert_time_info.ConvertTinyint});

    @memset(odbc_buf[0..], 0);
    const convert_varbinary_info = try con.getInfo(allocator, .ConvertVarbinary, odbc_buf[0..]);
    defer convert_varbinary_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_VARBINARY={}\n", .{convert_time_info.ConvertVarbinary});

    @memset(odbc_buf[0..], 0);
    const convert_varchar_info = try con.getInfo(allocator, .ConvertVarchar, odbc_buf[0..]);
    defer convert_varchar_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_VARCHAR={}\n", .{convert_time_info.ConvertVarchar});

    @memset(odbc_buf[0..], 0);
    const convert_functions_info = try con.getInfo(allocator, .ConvertFunctions, odbc_buf[0..]);
    defer convert_functions_info.deinit(allocator);
    try stdout.print("SQL_CONVERT_FUNCTIONS={}\n", .{convert_time_info.ConvertFunctions});

    @memset(odbc_buf[0..], 0);
    const correlation_name_info = try con.getInfo(allocator, .CorrelationName, odbc_buf[0..]);
    defer correlation_name_info.deinit(allocator);
    try stdout.print("SQL_CORRELATION_NAME={}\n", .{correlation_name_info.CorrelationName});

    @memset(odbc_buf[0..], 0);
    const create_assertion_info = try con.getInfo(allocator, .CreateAssertion, odbc_buf[0..]);
    defer create_assertion_info.deinit(allocator);
    try stdout.print("SQL_CREATE_ASSERTION={}\n", .{create_assertion_info.CreateAssertion});

    @memset(odbc_buf[0..], 0);
    const create_character_set_info = try con.getInfo(allocator, .CreateCharacterSet, odbc_buf[0..]);
    defer create_character_set_info.deinit(allocator);
    try stdout.print("SQL_CREATE_CHARACTER_SET={}\n", .{create_character_set_info.CreateCharacterSet});

    // CursorSensitivity = c.SQL_CURSOR_SENSITIVITY,

    @memset(odbc_buf[0..], 0);
    const create_collation_info = try con.getInfo(allocator, .CreateCollation, odbc_buf[0..]);
    defer create_collation_info.deinit(allocator);
    try stdout.print("SQL_CREATE_COLLATION={}\n", .{create_collation_info.CreateCollation});

    @memset(odbc_buf[0..], 0);
    const create_domain_info = try con.getInfo(allocator, .CreateDomain, odbc_buf[0..]);
    defer create_domain_info.deinit(allocator);
    try stdout.print("SQL_CREATE_DOMAIN={}\n", .{create_domain_info.CreateDomain});

    @memset(odbc_buf[0..], 0);
    const create_schema_info = try con.getInfo(allocator, .CreateSchema, odbc_buf[0..]);
    defer create_schema_info.deinit(allocator);
    try stdout.print("SQL_CREATE_SCHEMA={}\n", .{create_schema_info.CreateSchema});

    @memset(odbc_buf[0..], 0);
    const create_table_info = try con.getInfo(allocator, .CreateTable, odbc_buf[0..]);
    defer create_table_info.deinit(allocator);
    try stdout.print("SQL_CREATE_TABLE={}\n", .{create_table_info.CreateTable});

    @memset(odbc_buf[0..], 0);
    const create_translation_info = try con.getInfo(allocator, .CreateTranslation, odbc_buf[0..]);
    defer create_translation_info.deinit(allocator);
    try stdout.print("SQL_CREATE_TRANSLATION={}\n", .{create_translation_info.CreateTranslation});

    @memset(odbc_buf[0..], 0);
    const cursor_commit_behavior_info = try con.getInfo(allocator, .CursorCommitBehavior, odbc_buf[0..]);
    defer cursor_commit_behavior_info.deinit(allocator);
    try stdout.print("SQL_CURSOR_COMMIT_BEHAVIOR={}\n", .{cursor_commit_behavior_info.CursorCommitBehavior});

    @memset(odbc_buf[0..], 0);
    const cursor_rollback_behavior_info = try con.getInfo(allocator, .CursorRollbackBehavior, odbc_buf[0..]);
    defer cursor_rollback_behavior_info.deinit(allocator);
    try stdout.print("SQL_CURSOR_ROLLBACK_BEHAVIOR={}\n", .{cursor_rollback_behavior_info.CursorRollbackBehavior});

    @memset(odbc_buf[0..], 0);
    const cursor_sensitivity_info = try con.getInfo(allocator, .CursorSensitivity, odbc_buf[0..]);
    defer cursor_sensitivity_info.deinit(allocator);
    try stdout.print("SQL_CURSOR_SENSITIVITY={}\n", .{cursor_sensitivity_info.CursorSensitivity});

    @memset(odbc_buf[0..], 0);
    const data_source_name_info = try con.getInfo(allocator, .DataSourceName, odbc_buf[0..]);
    defer data_source_name_info.deinit(allocator);
    try stdout.print("SQL_DATA_SOURCE_NAME={s}\n", .{data_source_name_info.DataSourceName});

    @memset(odbc_buf[0..], 0);
    const data_source_read_only_info = try con.getInfo(allocator, .DataSourceReadOnly, odbc_buf[0..]);
    defer data_source_read_only_info.deinit(allocator);
    try stdout.print("SQL_DATA_SOURCE_READ_ONLY={}\n", .{data_source_read_only_info.DataSourceReadOnly});

    @memset(odbc_buf[0..], 0);
    const database_name_info = try con.getInfo(allocator, .DatabaseName, odbc_buf[0..]);
    defer database_name_info.deinit(allocator);
    try stdout.print("SQL_DATABASE_NAME={s}\n", .{database_name_info.DatabaseName});

    @memset(odbc_buf[0..], 0);
    const dbms_name_info = try con.getInfo(allocator, .DbmsName, odbc_buf[0..]);
    defer dbms_name_info.deinit(allocator);
    try stdout.print("SQL_DBMS_NAME={s}\n", .{dbms_name_info.DbmsName});

    @memset(odbc_buf[0..], 0);
    const dbms_ver_info = try con.getInfo(allocator, .DbmsVer, odbc_buf[0..]);
    defer dbms_ver_info.deinit(allocator);
    try stdout.print("SQL_DBMS_VER={s}\n", .{dbms_ver_info.DbmsVer});

    @memset(odbc_buf[0..], 0);
    const ddl_index_info = try con.getInfo(allocator, .DdlIndex, odbc_buf[0..]);
    defer ddl_index_info.deinit(allocator);
    try stdout.print("SQL_DDL_INDEX={}\n", .{ddl_index_info.DdlIndex});

    @memset(odbc_buf[0..], 0);
    const default_txn_isolation_info = try con.getInfo(allocator, .DefaultTxnIsolation, odbc_buf[0..]);
    defer default_txn_isolation_info.deinit(allocator);
    try stdout.print("SQL_DEFAULT_TXN_ISOLATION={}\n", .{default_txn_isolation_info.DefaultTxnIsolation});

    @memset(odbc_buf[0..], 0);
    const describe_parameter_info = try con.getInfo(allocator, .DescribeParameter, odbc_buf[0..]);
    defer describe_parameter_info.deinit(allocator);
    try stdout.print("SQL_DESCRIBE_PARAMETER={}\n", .{describe_parameter_info.DescribeParameter});

    @memset(odbc_buf[0..], 0);
    const driver_hdbc_info = try con.getInfo(allocator, .DriverHdbc, odbc_buf[0..]);
    defer driver_hdbc_info.deinit(allocator);
    try stdout.print("SQL_DRIVER_HDBC={}\n", .{driver_hdbc_info.DriverHdbc});

    @memset(odbc_buf[0..], 0);
    const driver_henv_info = try con.getInfo(allocator, .DriverHenv, odbc_buf[0..]);
    defer driver_henv_info.deinit(allocator);
    try stdout.print("SQL_DRIVER_HENV={}\n", .{driver_henv_info.DriverHenv});

    @memset(odbc_buf[0..], 0);
    const driver_hlib_info = try con.getInfo(allocator, .DriverHlib, odbc_buf[0..]);
    defer driver_hlib_info.deinit(allocator);
    try stdout.print("SQL_DRIVER_HLIB={}\n", .{driver_hlib_info.DriverHlib});

    // @memset(odbc_buf[0..], 0);
    // const driver_hstmt_info = try con.getInfo(allocator, .DriverHstmt, odbc_buf[0..]);
    // defer driver_hstmt_info.deinit(allocator);
    // try stdout.print("SQL_DRIVER_HSTMT={}\n", .{driver_hstmt_info.DriverHstmt});

    @memset(odbc_buf[0..], 0);
    const driver_name_info = try con.getInfo(allocator, .DriverName, odbc_buf[0..]);
    defer driver_name_info.deinit(allocator);
    try stdout.print("SQL_DRIVER_NAME={s}\n", .{driver_name_info.DriverName});

    @memset(odbc_buf[0..], 0);
    const driver_odbc_ver_info = try con.getInfo(allocator, .DriverOdbcVer, odbc_buf[0..]);
    defer driver_odbc_ver_info.deinit(allocator);
    try stdout.print("SQL_DRIVER_ODBC_VER={s}\n", .{driver_odbc_ver_info.DriverOdbcVer});

    @memset(odbc_buf[0..], 0);
    const driver_ver_info = try con.getInfo(allocator, .DriverVer, odbc_buf[0..]);
    defer driver_ver_info.deinit(allocator);
    try stdout.print("SQL_DRIVER_VER={s}\n", .{driver_ver_info.DriverVer});

    @memset(odbc_buf[0..], 0);
    const drop_assertion_info = try con.getInfo(allocator, .DropAssertion, odbc_buf[0..]);
    defer drop_assertion_info.deinit(allocator);
    try stdout.print("SQL_DROP_ASSERTION={}\n", .{drop_assertion_info.DropAssertion});

    @memset(odbc_buf[0..], 0);
    const drop_character_set_info = try con.getInfo(allocator, .DropCharacterSet, odbc_buf[0..]);
    defer drop_character_set_info.deinit(allocator);
    try stdout.print("SQL_DROP_CHARACTER_SET={}\n", .{drop_character_set_info.DropCharacterSet});

    @memset(odbc_buf[0..], 0);
    const drop_collation_info = try con.getInfo(allocator, .DropCollation, odbc_buf[0..]);
    defer drop_collation_info.deinit(allocator);
    try stdout.print("SQL_DROP_COLLATION={}\n", .{drop_collation_info.DropCollation});

    @memset(odbc_buf[0..], 0);
    const drop_domain_info = try con.getInfo(allocator, .DropDomain, odbc_buf[0..]);
    defer drop_domain_info.deinit(allocator);
    try stdout.print("SQL_DROP_DOMAIN={}\n", .{drop_domain_info.DropDomain});

    @memset(odbc_buf[0..], 0);
    const drop_schema_info = try con.getInfo(allocator, .DropSchema, odbc_buf[0..]);
    defer drop_schema_info.deinit(allocator);
    try stdout.print("SQL_DROP_SCHEMA={}\n", .{drop_schema_info.DropSchema});

    @memset(odbc_buf[0..], 0);
    const drop_table_info = try con.getInfo(allocator, .DropTable, odbc_buf[0..]);
    defer drop_table_info.deinit(allocator);
    try stdout.print("SQL_DROP_TABLE={}\n", .{drop_table_info.DropTable});

    @memset(odbc_buf[0..], 0);
    const drop_translation_info = try con.getInfo(allocator, .DropTranslation, odbc_buf[0..]);
    defer drop_translation_info.deinit(allocator);
    try stdout.print("SQL_DROP_TRANSLATION={}\n", .{drop_translation_info.DropTranslation});

    @memset(odbc_buf[0..], 0);
    const drop_view_info = try con.getInfo(allocator, .DropView, odbc_buf[0..]);
    defer drop_view_info.deinit(allocator);
    try stdout.print("SQL_DROP_VIEW={}\n", .{drop_view_info.DropView});

    @memset(odbc_buf[0..], 0);
    const dynamic_cursor_attributes_1 = try con.getInfo(allocator, .DynamicCursorAttributes1, odbc_buf[0..]);
    defer dynamic_cursor_attributes_1.deinit(allocator);
    try stdout.print("SQL_DYNAMIC_CURSOR_ATTRIBUTES1={}\n", .{dynamic_cursor_attributes_1.DynamicCursorAttributes1});

    @memset(odbc_buf[0..], 0);
    const dynamic_cursor_attributes_2 = try con.getInfo(allocator, .DynamicCursorAttributes2, odbc_buf[0..]);
    defer dynamic_cursor_attributes_2.deinit(allocator);
    try stdout.print("SQL_DYNAMIC_CURSOR_ATTRIBUTES2={}\n", .{dynamic_cursor_attributes_2.DynamicCursorAttributes2});

    @memset(odbc_buf[0..], 0);
    const expressions_in_orderby_info = try con.getInfo(allocator, .ExpressionsInOrderby, odbc_buf[0..]);
    defer expressions_in_orderby_info.deinit(allocator);
    try stdout.print("SQL_EXPRESSIONS_IN_ORDERBY={}\n", .{expressions_in_orderby_info.ExpressionsInOrderby});

    @memset(odbc_buf[0..], 0);
    const fetch_direction_info = try con.getInfo(allocator, .FetchDirection, odbc_buf[0..]);
    defer fetch_direction_info.deinit(allocator);
    try stdout.print("SQL_FETCH_DIRECTION={}\n", .{fetch_direction_info.FetchDirection});

    @memset(odbc_buf[0..], 0);
    const file_usage_info = try con.getInfo(allocator, .FileUsage, odbc_buf[0..]);
    defer file_usage_info.deinit(allocator);
    try stdout.print("SQL_FILE_USAGE={}\n", .{file_usage_info.FileUsage});

    @memset(odbc_buf[0..], 0);
    const forward_only_cursor_attributes_1_info = try con.getInfo(allocator, .ForwardOnlyCursorAttributes1, odbc_buf[0..]);
    defer forward_only_cursor_attributes_1_info.deinit(allocator);
    try stdout.print("SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1={}\n", .{forward_only_cursor_attributes_1_info.ForwardOnlyCursorAttributes1});

    @memset(odbc_buf[0..], 0);
    const forward_only_cursor_attributes_2_info = try con.getInfo(allocator, .ForwardOnlyCursorAttributes2, odbc_buf[0..]);
    defer forward_only_cursor_attributes_2_info.deinit(allocator);
    try stdout.print("SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2={}\n", .{forward_only_cursor_attributes_2_info.ForwardOnlyCursorAttributes2});

    @memset(odbc_buf[0..], 0);
    const getdata_extensions_info = try con.getInfo(allocator, .GetdataExtensions, odbc_buf[0..]);
    defer getdata_extensions_info.deinit(allocator);
    try stdout.print("SQL_GETDATA_EXTENSIONS={}\n", .{getdata_extensions_info.GetdataExtensions});

    @memset(odbc_buf[0..], 0);
    const group_by_info = try con.getInfo(allocator, .GroupBy, odbc_buf[0..]);
    defer group_by_info.deinit(allocator);
    try stdout.print("SQL_GROUP_BY={}\n", .{group_by_info.GroupBy});

    @memset(odbc_buf[0..], 0);
    const identifier_case_info = try con.getInfo(allocator, .IdentifierCase, odbc_buf[0..]);
    defer identifier_case_info.deinit(allocator);
    try stdout.print("SQL_IDENTIFIER_CASE={}\n", .{identifier_case_info.IdentifierCase});

    @memset(odbc_buf[0..], 0);
    const identifier_quote_char_info = try con.getInfo(allocator, .IdentifierQuoteChar, odbc_buf[0..]);
    defer identifier_quote_char_info.deinit(allocator);
    try stdout.print("SQL_IDENTIFIER_QUOTE_CHAR={s}\n", .{identifier_quote_char_info.IdentifierQuoteChar});

    @memset(odbc_buf[0..], 0);
    const info_schema_views_info = try con.getInfo(allocator, .InfoSchemaViews, odbc_buf[0..]);
    defer info_schema_views_info.deinit(allocator);
    try stdout.print("SQL_INFO_SCHEMA_VIEWS={}\n", .{info_schema_views_info.InfoSchemaViews});

    @memset(odbc_buf[0..], 0);
    const insert_statement_info = try con.getInfo(allocator, .InsertStatement, odbc_buf[0..]);
    defer insert_statement_info.deinit(allocator);
    try stdout.print("SQL_INSERT_STATEMENT={}\n", .{insert_statement_info.InsertStatement});

    @memset(odbc_buf[0..], 0);
    const integrity_info = try con.getInfo(allocator, .Integrity, odbc_buf[0..]);
    defer integrity_info.deinit(allocator);
    try stdout.print("SQL_INTEGRITY={}\n", .{integrity_info.Integrity});

    @memset(odbc_buf[0..], 0);
    const keyset_cursor_attributes_1_info = try con.getInfo(allocator, .KeysetCursorAttributes1, odbc_buf[0..]);
    defer keyset_cursor_attributes_1_info.deinit(allocator);
    try stdout.print("SQL_KEYSET_CURSOR_ATTRIBUTES1={}\n", .{keyset_cursor_attributes_1_info.KeysetCursorAttributes1});

    @memset(odbc_buf[0..], 0);
    const keyset_cursor_attributes_2_info = try con.getInfo(allocator, .KeysetCursorAttributes2, odbc_buf[0..]);
    defer keyset_cursor_attributes_2_info.deinit(allocator);
    try stdout.print("SQL_KEYSET_CURSOR_ATTRIBUTES2={}\n", .{keyset_cursor_attributes_2_info.KeysetCursorAttributes2});

    @memset(odbc_buf[0..], 0);
    const keywords_info = try con.getInfo(allocator, .Keywords, odbc_buf[0..]);
    defer keywords_info.deinit(allocator);
    try stdout.print("SQL_KEYWORDS={s}\n", .{keywords_info.Keywords});

    @memset(odbc_buf[0..], 0);
    const like_escape_clause_info = try con.getInfo(allocator, .LikeEscapeClause, odbc_buf[0..]);
    defer like_escape_clause_info.deinit(allocator);
    try stdout.print("SQL_LIKE_ESCAPE_CLAUSE={}\n", .{like_escape_clause_info.LikeEscapeClause});

    @memset(odbc_buf[0..], 0);
    const lock_types_info = try con.getInfo(allocator, .LockTypes, odbc_buf[0..]);
    defer lock_types_info.deinit(allocator);
    try stdout.print("SQL_LOCK_TYPES={}\n", .{lock_types_info.LockTypes});

    @memset(odbc_buf[0..], 0);
    const max_async_concurrent_statements_info = try con.getInfo(allocator, .MaxAsyncConcurrentStatements, odbc_buf[0..]);
    defer max_async_concurrent_statements_info.deinit(allocator);
    try stdout.print("SQL_MAX_ASYNC_CONCURRENT_STATEMENTS={}\n", .{max_async_concurrent_statements_info.MaxAsyncConcurrentStatements});

    @memset(odbc_buf[0..], 0);
    const max_binary_literal_len_info = try con.getInfo(allocator, .MaxBinaryLiteralLen, odbc_buf[0..]);
    defer max_binary_literal_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_BINARY_LITERAL_LEN={}\n", .{max_binary_literal_len_info.MaxBinaryLiteralLen});

    @memset(odbc_buf[0..], 0);
    const max_catalog_name_len_info = try con.getInfo(allocator, .MaxCatalogNameLen, odbc_buf[0..]);
    defer max_catalog_name_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_CATALOG_NAME_LEN={}\n", .{max_catalog_name_len_info.MaxCatalogNameLen});

    @memset(odbc_buf[0..], 0);
    const max_char_literal_len_info = try con.getInfo(allocator, .MaxCharLiteralLen, odbc_buf[0..]);
    defer max_char_literal_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_CHAR_LITERAL_LEN={}\n", .{max_char_literal_len_info.MaxCharLiteralLen});

    @memset(odbc_buf[0..], 0);
    const max_column_name_len_info = try con.getInfo(allocator, .MaxColumnNameLen, odbc_buf[0..]);
    defer max_column_name_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_COLUMN_NAME_LEN={}\n", .{max_column_name_len_info.MaxColumnNameLen});

    @memset(odbc_buf[0..], 0);
    const max_columns_in_group_by_info = try con.getInfo(allocator, .MaxColumnsInGroupBy, odbc_buf[0..]);
    defer max_columns_in_group_by_info.deinit(allocator);
    try stdout.print("SQL_MAX_COLUMNS_IN_GROUP_BY={}\n", .{max_columns_in_group_by_info.MaxColumnsInGroupBy});

    @memset(odbc_buf[0..], 0);
    const max_columns_in_index_info = try con.getInfo(allocator, .MaxColumnsInIndex, odbc_buf[0..]);
    defer max_columns_in_index_info.deinit(allocator);
    try stdout.print("SQL_MAX_COLUMNS_IN_INDEX={}\n", .{max_columns_in_index_info.MaxColumnsInIndex});

    @memset(odbc_buf[0..], 0);
    const max_columns_in_order_by_info = try con.getInfo(allocator, .MaxColumnsInOrderBy, odbc_buf[0..]);
    defer max_columns_in_order_by_info.deinit(allocator);
    try stdout.print("SQL_MAX_COLUMNS_IN_ORDER_BY={}\n", .{max_columns_in_order_by_info.MaxColumnsInOrderBy});

    @memset(odbc_buf[0..], 0);
    const max_columns_in_select_info = try con.getInfo(allocator, .MaxColumnsInSelect, odbc_buf[0..]);
    defer max_columns_in_select_info.deinit(allocator);
    try stdout.print("SQL_MAX_COLUMNS_IN_SELECT={}\n", .{max_columns_in_select_info.MaxColumnsInSelect});

    @memset(odbc_buf[0..], 0);
    const max_columns_in_table_info = try con.getInfo(allocator, .MaxColumnsInTable, odbc_buf[0..]);
    defer max_columns_in_table_info.deinit(allocator);
    try stdout.print("SQL_MAX_COLUMNS_IN_TABLE={}\n", .{max_columns_in_table_info.MaxColumnsInTable});

    @memset(odbc_buf[0..], 0);
    const max_concurrent_activities_info = try con.getInfo(allocator, .MaxConcurrentActivities, odbc_buf[0..]);
    defer max_concurrent_activities_info.deinit(allocator);
    try stdout.print("SQL_MAX_CONCURRENT_ACTIVITIES={}\n", .{max_concurrent_activities_info.MaxConcurrentActivities});

    @memset(odbc_buf[0..], 0);
    const max_cursor_name_len_info = try con.getInfo(allocator, .MaxCursorNameLen, odbc_buf[0..]);
    defer max_cursor_name_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_CURSOR_NAME_LEN={}\n", .{max_cursor_name_len_info.MaxCursorNameLen});

    @memset(odbc_buf[0..], 0);
    const max_driver_connections_info = try con.getInfo(allocator, .MaxDriverConnections, odbc_buf[0..]);
    defer max_driver_connections_info.deinit(allocator);
    try stdout.print("SQL_MAX_DRIVER_CONNECTIONS={}\n", .{max_driver_connections_info.MaxDriverConnections});

    @memset(odbc_buf[0..], 0);
    const max_identifier_len_info = try con.getInfo(allocator, .MaxIdentifierLen, odbc_buf[0..]);
    defer max_identifier_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_IDENTIFIER_LEN={}\n", .{max_identifier_len_info.MaxIdentifierLen});

    @memset(odbc_buf[0..], 0);
    const max_index_size_info = try con.getInfo(allocator, .MaxIndexSize, odbc_buf[0..]);
    defer max_index_size_info.deinit(allocator);
    try stdout.print("SQL_MAX_INDEX_SIZE={}\n", .{max_index_size_info.MaxIndexSize});

    @memset(odbc_buf[0..], 0);
    const max_procedure_name_len_info = try con.getInfo(allocator, .MaxProcedureNameLen, odbc_buf[0..]);
    defer max_procedure_name_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_PROCEDURE_NAME_LEN={}\n", .{max_procedure_name_len_info.MaxProcedureNameLen});

    @memset(odbc_buf[0..], 0);
    const max_row_size_info = try con.getInfo(allocator, .MaxRowSize, odbc_buf[0..]);
    defer max_row_size_info.deinit(allocator);
    try stdout.print("SQL_MAX_ROW_SIZE={}\n", .{max_row_size_info.MaxRowSize});

    @memset(odbc_buf[0..], 0);
    const max_row_size_includes_long_info = try con.getInfo(allocator, .MaxRowSizeIncludesLong, odbc_buf[0..]);
    defer max_row_size_includes_long_info.deinit(allocator);
    try stdout.print("SQL_MAX_ROW_SIZE_INCLUDES_LONG={}\n", .{max_row_size_includes_long_info.MaxRowSizeIncludesLong});

    @memset(odbc_buf[0..], 0);
    const max_schema_name_len_info = try con.getInfo(allocator, .MaxSchemaNameLen, odbc_buf[0..]);
    defer max_schema_name_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_SCHEMA_NAME_LEN={}\n", .{max_schema_name_len_info.MaxSchemaNameLen});

    @memset(odbc_buf[0..], 0);
    const max_table_name_len_info = try con.getInfo(allocator, .MaxTableNameLen, odbc_buf[0..]);
    defer max_table_name_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_TABLE_NAME_LEN={}\n", .{max_table_name_len_info.MaxTableNameLen});

    @memset(odbc_buf[0..], 0);
    const max_tables_in_select_info = try con.getInfo(allocator, .MaxTablesInSelect, odbc_buf[0..]);
    defer max_tables_in_select_info.deinit(allocator);
    try stdout.print("SQL_MAX_TABLES_IN_SELECT={}\n", .{max_tables_in_select_info.MaxTablesInSelect});

    @memset(odbc_buf[0..], 0);
    const max_user_name_len_info = try con.getInfo(allocator, .MaxUserNameLen, odbc_buf[0..]);
    defer max_user_name_len_info.deinit(allocator);
    try stdout.print("SQL_MAX_USER_NAME_LEN={}\n", .{max_user_name_len_info.MaxUserNameLen});

    @memset(odbc_buf[0..], 0);
    const multi_result_sets_info = try con.getInfo(allocator, .MultResultSets, odbc_buf[0..]);
    defer multi_result_sets_info.deinit(allocator);
    try stdout.print("SQL_MULT_RESULT_SETS={}\n", .{multi_result_sets_info.MultResultSets});

    @memset(odbc_buf[0..], 0);
    const multiple_active_txn_info = try con.getInfo(allocator, .MultipleActiveTxn, odbc_buf[0..]);
    defer multiple_active_txn_info.deinit(allocator);
    try stdout.print("SQL_MULTIPLE_ACTIVE_TXN={}\n", .{multiple_active_txn_info.MultipleActiveTxn});

    @memset(odbc_buf[0..], 0);
    const need_long_data_len_info = try con.getInfo(allocator, .NeedLongDataLen, odbc_buf[0..]);
    defer need_long_data_len_info.deinit(allocator);
    try stdout.print("SQL_NEED_LONG_DATA_LEN={}\n", .{need_long_data_len_info.NeedLongDataLen});

    @memset(odbc_buf[0..], 0);
    const non_nullable_columns_info = try con.getInfo(allocator, .NonNullableColumns, odbc_buf[0..]);
    defer non_nullable_columns_info.deinit(allocator);
    try stdout.print("SQL_NON_NULLABLE_COLUMNS={}\n", .{non_nullable_columns_info.NonNullableColumns});

    @memset(odbc_buf[0..], 0);
    const null_collation_info = try con.getInfo(allocator, .NullCollation, odbc_buf[0..]);
    defer null_collation_info.deinit(allocator);
    try stdout.print("SQL_NULL_COLLATION={}\n", .{null_collation_info.NullCollation});

    @memset(odbc_buf[0..], 0);
    const numeric_functions_info = try con.getInfo(allocator, .NumericFunctions, odbc_buf[0..]);
    defer numeric_functions_info.deinit(allocator);
    try stdout.print("SQL_NUMERIC_FUNCTIONS={}\n", .{numeric_functions_info.NumericFunctions});

    @memset(odbc_buf[0..], 0);
    const odbc_api_conformance_info = try con.getInfo(allocator, .OdbcApiConformance, odbc_buf[0..]);
    defer odbc_api_conformance_info.deinit(allocator);
    try stdout.print("SQL_ODBC_API_CONFORMANCE={}\n", .{odbc_api_conformance_info.OdbcApiConformance});

    @memset(odbc_buf[0..], 0);
    const odbc_sag_cli_conformance_info = try con.getInfo(allocator, .OdbcSagCliConformance, odbc_buf[0..]);
    defer odbc_sag_cli_conformance_info.deinit(allocator);
    try stdout.print("SQL_ODBC_SAG_CLI_CONFORMANCE={}\n", .{odbc_sag_cli_conformance_info.OdbcSagCliConformance});

    @memset(odbc_buf[0..], 0);
    const odbc_sql_conformance_info = try con.getInfo(allocator, .OdbcSqlConformance, odbc_buf[0..]);
    defer odbc_sql_conformance_info.deinit(allocator);
    try stdout.print("SQL_ODBC_SQL_CONFORMANCE={}\n", .{odbc_sql_conformance_info.OdbcSqlConformance});

    @memset(odbc_buf[0..], 0);
    const odbc_ver_info = try con.getInfo(allocator, .OdbcVer, odbc_buf[0..]);
    defer odbc_ver_info.deinit(allocator);
    try stdout.print("SQL_ODBC_VER={s}\n", .{odbc_ver_info.OdbcVer});

    @memset(odbc_buf[0..], 0);
    const oj_capabilities_info = try con.getInfo(allocator, .OjCapabilities, odbc_buf[0..]);
    defer oj_capabilities_info.deinit(allocator);
    try stdout.print("SQL_OJ_CAPABILITIES={}\n", .{oj_capabilities_info.OjCapabilities});

    @memset(odbc_buf[0..], 0);
    const order_by_columns_in_select_info = try con.getInfo(allocator, .OrderByColumnsInSelect, odbc_buf[0..]);
    defer oj_capabilities_info.deinit(allocator);
    try stdout.print("SQL_ORDER_BY_COLUMNS_IN_SELECT={}\n", .{order_by_columns_in_select_info.OrderByColumnsInSelect});

    @memset(odbc_buf[0..], 0);
    const outer_joins_info = try con.getInfo(allocator, .OuterJoins, odbc_buf[0..]);
    defer outer_joins_info.deinit(allocator);
    try stdout.print("SQL_OUTER_JOINS={}\n", .{outer_joins_info.OuterJoins});

    @memset(odbc_buf[0..], 0);
    const owner_term_info = try con.getInfo(allocator, .OwnerTerm, odbc_buf[0..]);
    defer owner_term_info.deinit(allocator);
    try stdout.print("SQL_OWNER_TERM={s}\n", .{owner_term_info.OwnerTerm});

    @memset(odbc_buf[0..], 0);
    const param_array_row_counts_info = try con.getInfo(allocator, .ParamArrayRowCounts, odbc_buf[0..]);
    defer param_array_row_counts_info.deinit(allocator);
    try stdout.print("SQL_PARAM_ARRAY_ROW_COUNTS={}\n", .{param_array_row_counts_info.ParamArrayRowCounts});

    @memset(odbc_buf[0..], 0);
    const param_array_selects_info = try con.getInfo(allocator, .ParamArraySelects, odbc_buf[0..]);
    defer param_array_selects_info.deinit(allocator);
    try stdout.print("SQL_PARAM_ARRAY_SELECTS={}\n", .{param_array_selects_info.ParamArraySelects});

    @memset(odbc_buf[0..], 0);
    const pos_operations_info = try con.getInfo(allocator, .PosOperations, odbc_buf[0..]);
    defer pos_operations_info.deinit(allocator);
    try stdout.print("SQL_POS_OPERATIONS={}\n", .{pos_operations_info.PosOperations});

    @memset(odbc_buf[0..], 0);
    const positioned_statements_info = try con.getInfo(allocator, .PositionedStatements, odbc_buf[0..]);
    defer positioned_statements_info.deinit(allocator);
    try stdout.print("SQL_POSITIONED_STATEMENTS={}\n", .{positioned_statements_info.PositionedStatements});

    @memset(odbc_buf[0..], 0);
    const procedure_term_info = try con.getInfo(allocator, .ProcedureTerm, odbc_buf[0..]);
    defer procedure_term_info.deinit(allocator);
    try stdout.print("SQL_PROCEDURE_TERM={s}\n", .{procedure_term_info.ProcedureTerm});

    @memset(odbc_buf[0..], 0);
    const procedures_info = try con.getInfo(allocator, .Procedures, odbc_buf[0..]);
    defer procedures_info.deinit(allocator);
    try stdout.print("SQL_PROCEDURES={}\n", .{procedures_info.Procedures});

    @memset(odbc_buf[0..], 0);
    const quoted_identifier_case_info = try con.getInfo(allocator, .QuotedIdentifierCase, odbc_buf[0..]);
    defer quoted_identifier_case_info.deinit(allocator);
    try stdout.print("SQL_QUOTED_IDENTIFIER_CASE={}\n", .{quoted_identifier_case_info.QuotedIdentifierCase});

    @memset(odbc_buf[0..], 0);
    const row_updates_info = try con.getInfo(allocator, .RowUpdates, odbc_buf[0..]);
    defer row_updates_info.deinit(allocator);
    try stdout.print("SQL_ROW_UPDATES={}\n", .{row_updates_info.RowUpdates});

    @memset(odbc_buf[0..], 0);
    const schema_usage_info = try con.getInfo(allocator, .SchemaUsage, odbc_buf[0..]);
    defer schema_usage_info.deinit(allocator);
    try stdout.print("SQL_SCHEMA_USAGE={}\n", .{schema_usage_info.SchemaUsage});

    @memset(odbc_buf[0..], 0);
    const scroll_concurrency_info = try con.getInfo(allocator, .ScrollConcurrency, odbc_buf[0..]);
    defer scroll_concurrency_info.deinit(allocator);
    try stdout.print("SQL_SCROLL_CONCURRENCY={}\n", .{scroll_concurrency_info.ScrollConcurrency});

    @memset(odbc_buf[0..], 0);
    const scroll_options_info = try con.getInfo(allocator, .ScrollOptions, odbc_buf[0..]);
    defer scroll_options_info.deinit(allocator);
    try stdout.print("SQL_SCROLL_OPTIONS={}\n", .{scroll_options_info.ScrollOptions});

    @memset(odbc_buf[0..], 0);
    const search_pattern_escape_info = try con.getInfo(allocator, .SearchPatternEscape, odbc_buf[0..]);
    defer search_pattern_escape_info.deinit(allocator);
    try stdout.print("SQL_SEARCH_PATTERN_ESCAPE={s}\n", .{search_pattern_escape_info.SearchPatternEscape});

    @memset(odbc_buf[0..], 0);
    const server_name_info = try con.getInfo(allocator, .ServerName, odbc_buf[0..]);
    defer server_name_info.deinit(allocator);
    try stdout.print("SQL_SERVER_NAME={s}\n", .{server_name_info.ServerName});

    @memset(odbc_buf[0..], 0);
    const special_characters_info = try con.getInfo(allocator, .SpecialCharacters, odbc_buf[0..]);
    defer special_characters_info.deinit(allocator);
    try stdout.print("SQL_SPECIAL_CHARACTERS={s}\n", .{special_characters_info.SpecialCharacters});

    @memset(odbc_buf[0..], 0);
    const sql92_predicates_info = try con.getInfo(allocator, .Sql92Predicates, odbc_buf[0..]);
    defer sql92_predicates_info.deinit(allocator);
    try stdout.print("SQL_SQL92_PREDICATES={}\n", .{sql92_predicates_info.Sql92Predicates});

    @memset(odbc_buf[0..], 0);
    const sql92_value_expressions_info = try con.getInfo(allocator, .Sql92ValueExpressions, odbc_buf[0..]);
    defer sql92_value_expressions_info.deinit(allocator);
    try stdout.print("SQL_SQL92_VALUE_EXPRESSIONS={}\n", .{sql92_value_expressions_info.Sql92ValueExpressions});

    @memset(odbc_buf[0..], 0);
    const static_cursor_attributes_1_info = try con.getInfo(allocator, .StaticCursorAttributes1, odbc_buf[0..]);
    defer static_cursor_attributes_1_info.deinit(allocator);
    try stdout.print("SQL_STATIC_CURSOR_ATTRIBUTES1={}\n", .{static_cursor_attributes_1_info.StaticCursorAttributes1});

    @memset(odbc_buf[0..], 0);
    const static_cursor_attributes_2_info = try con.getInfo(allocator, .StaticCursorAttributes2, odbc_buf[0..]);
    defer static_cursor_attributes_2_info.deinit(allocator);
    try stdout.print("SQL_STATIC_CURSOR_ATTRIBUTES2={}\n", .{static_cursor_attributes_2_info.StaticCursorAttributes2});

    @memset(odbc_buf[0..], 0);
    const static_sensitivity_info = try con.getInfo(allocator, .StaticSensitivity, odbc_buf[0..]);
    defer static_sensitivity_info.deinit(allocator);
    try stdout.print("SQL_STATIC_SENSITIVITY={}\n", .{static_sensitivity_info.StaticSensitivity});

    @memset(odbc_buf[0..], 0);
    const string_functions_info = try con.getInfo(allocator, .StringFunctions, odbc_buf[0..]);
    defer string_functions_info.deinit(allocator);
    try stdout.print("SQL_STRING_FUNCTIONS={}\n", .{string_functions_info.StringFunctions});

    @memset(odbc_buf[0..], 0);
    const subqueries_info = try con.getInfo(allocator, .Subqueries, odbc_buf[0..]);
    defer subqueries_info.deinit(allocator);
    try stdout.print("SQL_SUBQUERIES={}\n", .{subqueries_info.Subqueries});

    @memset(odbc_buf[0..], 0);
    const system_functions_info = try con.getInfo(allocator, .SystemFunctions, odbc_buf[0..]);
    defer system_functions_info.deinit(allocator);
    try stdout.print("SQL_SYSTEM_FUNCTIONS={}\n", .{system_functions_info.SystemFunctions});

    @memset(odbc_buf[0..], 0);
    const table_term_info = try con.getInfo(allocator, .TableTerm, odbc_buf[0..]);
    defer table_term_info.deinit(allocator);
    try stdout.print("SQL_TABLE_TERM={s}\n", .{table_term_info.TableTerm});

    @memset(odbc_buf[0..], 0);
    const timedate_add_intervals_info = try con.getInfo(allocator, .TimedateAddIntervals, odbc_buf[0..]);
    defer timedate_add_intervals_info.deinit(allocator);
    try stdout.print("SQL_TIMEDATE_ADD_INTERVALS={}\n", .{timedate_add_intervals_info.TimedateAddIntervals});

    @memset(odbc_buf[0..], 0);
    const timedate_diff_intervals_info = try con.getInfo(allocator, .TimedateDiffIntervals, odbc_buf[0..]);
    defer timedate_diff_intervals_info.deinit(allocator);
    try stdout.print("SQL_TIMEDATE_DIFF_INTERVALS={}\n", .{timedate_diff_intervals_info.TimedateDiffIntervals});

    @memset(odbc_buf[0..], 0);
    const timedate_functions_info = try con.getInfo(allocator, .TimedateFunctions, odbc_buf[0..]);
    defer timedate_functions_info.deinit(allocator);
    try stdout.print("SQL_TIMEDATE_FUNCTIONS={}\n", .{timedate_functions_info.TimedateFunctions});

    @memset(odbc_buf[0..], 0);
    const txn_capable_info = try con.getInfo(allocator, .TxnCapable, odbc_buf[0..]);
    defer txn_capable_info.deinit(allocator);
    try stdout.print("SQL_TXN_CAPABLE={}\n", .{txn_capable_info.TxnCapable});

    @memset(odbc_buf[0..], 0);
    const txn_isolation_option_info = try con.getInfo(allocator, .TxnIsolationOption, odbc_buf[0..]);
    defer txn_isolation_option_info.deinit(allocator);
    try stdout.print("SQL_TXN_ISOLATION_OPTION={}\n", .{txn_isolation_option_info.TxnIsolationOption});

    @memset(odbc_buf[0..], 0);
    const union_info = try con.getInfo(allocator, .Union, odbc_buf[0..]);
    defer union_info.deinit(allocator);
    try stdout.print("SQL_UNION={}\n", .{union_info.Union});

    @memset(odbc_buf[0..], 0);
    const user_name_info = try con.getInfo(allocator, .UserName, odbc_buf[0..]);
    defer user_name_info.deinit(allocator);
    try stdout.print("SQL_USER_NAME={s}\n", .{user_name_info.UserName});

    @memset(odbc_buf[0..], 0);
    const xopen_cli_year_info = try con.getInfo(allocator, .XopenCliYear, odbc_buf[0..]);
    defer xopen_cli_year_info.deinit(allocator);
    try stdout.print("SQL_XOPEN_CLI_YEAR={s}\n", .{xopen_cli_year_info.XopenCliYear});

    try bw.flush();
}
