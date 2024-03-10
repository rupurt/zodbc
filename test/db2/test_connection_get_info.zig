const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectEqualStrings = testing.expectEqualStrings;
const expectEqualSlices = testing.expectEqualSlices;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const info = zodbc.odbc.info;

const InfoTypeValue = info.InfoTypeValue;

test "getInfo/3 returns general information about the connected DBMS" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    var odbc_buf: [2048]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const accessible_procedures_info = try con.getInfo(allocator, .AccessibleProcedures, odbc_buf[0..]);
    defer accessible_procedures_info.deinit(allocator);
    try expectEqual(false, accessible_procedures_info.AccessibleProcedures);

    @memset(odbc_buf[0..], 0);
    const accessible_tables_info = try con.getInfo(allocator, .AccessibleTables, odbc_buf[0..]);
    defer accessible_tables_info.deinit(allocator);
    try expectEqual(false, accessible_tables_info.AccessibleTables);

    @memset(odbc_buf[0..], 0);
    const active_environments_info = try con.getInfo(allocator, .ActiveEnvironments, odbc_buf[0..]);
    defer active_environments_info.deinit(allocator);
    try expectEqual(1, active_environments_info.ActiveEnvironments);

    @memset(odbc_buf[0..], 0);
    const aggregate_functions_info = try con.getInfo(allocator, .AggregateFunctions, odbc_buf[0..]);
    defer aggregate_functions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.AggregateFunctionsMask{ .data = 64 },
        aggregate_functions_info.AggregateFunctions,
    );

    @memset(odbc_buf[0..], 0);
    const alter_domain_info = try con.getInfo(allocator, .AlterDomain, odbc_buf[0..]);
    defer alter_domain_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.AlterDomainMask{ .data = 0 },
        alter_domain_info.AlterDomain,
    );

    @memset(odbc_buf[0..], 0);
    const alter_table_info = try con.getInfo(allocator, .AlterTable, odbc_buf[0..]);
    defer alter_table_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.AlterTableMask{ .data = 61545 },
        alter_table_info.AlterTable,
    );

    @memset(odbc_buf[0..], 0);
    const batch_row_count_info = try con.getInfo(allocator, .BatchRowCount, odbc_buf[0..]);
    defer batch_row_count_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.BatchRowCountMask{ .data = 4 },
        batch_row_count_info.BatchRowCount,
    );

    @memset(odbc_buf[0..], 0);
    const batch_support_info = try con.getInfo(allocator, .BatchSupport, odbc_buf[0..]);
    defer batch_support_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.BatchSupportMask{ .data = 7 },
        batch_support_info.BatchSupport,
    );

    @memset(odbc_buf[0..], 0);
    const bookmark_persistence_info = try con.getInfo(allocator, .BookmarkPersistence, odbc_buf[0..]);
    defer bookmark_persistence_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.BookmarkPersistenceMask{ .data = 90 },
        bookmark_persistence_info.BookmarkPersistence,
    );

    @memset(odbc_buf[0..], 0);
    const catalog_location_info = try con.getInfo(allocator, .CatalogLocation, odbc_buf[0..]);
    defer catalog_location_info.deinit(allocator);
    try expectEqual(0, catalog_location_info.CatalogLocation);

    @memset(odbc_buf[0..], 0);
    const catalog_name_info = try con.getInfo(allocator, .CatalogName, odbc_buf[0..]);
    defer catalog_name_info.deinit(allocator);
    try expectEqual(false, catalog_name_info.CatalogName);

    @memset(odbc_buf[0..], 0);
    const catalog_name_separator_info = try con.getInfo(allocator, .CatalogNameSeparator, odbc_buf[0..]);
    defer catalog_name_separator_info.deinit(allocator);
    try expectEqualStrings(".", catalog_name_separator_info.CatalogNameSeparator);

    @memset(odbc_buf[0..], 0);
    const catalog_term_info = try con.getInfo(allocator, .CatalogTerm, odbc_buf[0..]);
    defer catalog_term_info.deinit(allocator);
    try expectEqualStrings("", catalog_term_info.CatalogTerm);

    @memset(odbc_buf[0..], 0);
    const catalog_usage_info = try con.getInfo(allocator, .CatalogUsage, odbc_buf[0..]);
    defer catalog_usage_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CatalogUsageMask{ .data = 0 },
        catalog_usage_info.CatalogUsage,
    );

    @memset(odbc_buf[0..], 0);
    const collation_seq_info = try con.getInfo(allocator, .CollationSeq, odbc_buf[0..]);
    defer collation_seq_info.deinit(allocator);
    try expectEqualStrings("", collation_seq_info.CollationSeq);

    @memset(odbc_buf[0..], 0);
    const column_alias_info = try con.getInfo(allocator, .ColumnAlias, odbc_buf[0..]);
    defer column_alias_info.deinit(allocator);
    try expectEqual(true, column_alias_info.ColumnAlias);

    @memset(odbc_buf[0..], 0);
    const concat_null_behavior_info = try con.getInfo(allocator, .ConcatNullBehavior, odbc_buf[0..]);
    defer concat_null_behavior_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConcatNullBehavior.Null,
        concat_null_behavior_info.ConcatNullBehavior,
    );

    @memset(odbc_buf[0..], 0);
    const convert_bigint_info = try con.getInfo(allocator, .ConvertBigint, odbc_buf[0..]);
    defer convert_bigint_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertBigintMask{ .data = 0 },
        convert_bigint_info.ConvertBigint,
    );

    @memset(odbc_buf[0..], 0);
    const convert_binary_info = try con.getInfo(allocator, .ConvertBinary, odbc_buf[0..]);
    defer convert_binary_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertBinaryMask{ .data = 0 },
        convert_binary_info.ConvertBinary,
    );

    @memset(odbc_buf[0..], 0);
    const convert_bit_info = try con.getInfo(allocator, .ConvertBit, odbc_buf[0..]);
    defer convert_bit_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertBitMask{ .data = 0 },
        convert_bit_info.ConvertBit,
    );

    @memset(odbc_buf[0..], 0);
    const convert_char_info = try con.getInfo(allocator, .ConvertChar, odbc_buf[0..]);
    defer convert_char_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertCharMask{ .data = 129 },
        convert_char_info.ConvertChar,
    );

    @memset(odbc_buf[0..], 0);
    const convert_date_info = try con.getInfo(allocator, .ConvertDate, odbc_buf[0..]);
    defer convert_date_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertDateMask{ .data = 1 },
        convert_date_info.ConvertDate,
    );

    @memset(odbc_buf[0..], 0);
    const convert_decimal_info = try con.getInfo(allocator, .ConvertDecimal, odbc_buf[0..]);
    defer convert_decimal_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertDecimalMask{ .data = 129 },
        convert_decimal_info.ConvertDecimal,
    );

    @memset(odbc_buf[0..], 0);
    const convert_double_info = try con.getInfo(allocator, .ConvertDouble, odbc_buf[0..]);
    defer convert_double_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertDoubleMask{ .data = 129 },
        convert_double_info.ConvertDouble,
    );

    @memset(odbc_buf[0..], 0);
    const convert_float_info = try con.getInfo(allocator, .ConvertFloat, odbc_buf[0..]);
    defer convert_float_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertFloatMask{ .data = 129 },
        convert_float_info.ConvertFloat,
    );

    @memset(odbc_buf[0..], 0);
    const convert_integer_info = try con.getInfo(allocator, .ConvertInteger, odbc_buf[0..]);
    defer convert_integer_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertIntegerMask{ .data = 129 },
        convert_integer_info.ConvertInteger,
    );

    @memset(odbc_buf[0..], 0);
    const convert_interval_day_time_info = try con.getInfo(allocator, .ConvertIntervalDayTime, odbc_buf[0..]);
    defer convert_interval_day_time_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertIntervalDayTimeMask{ .data = 0 },
        convert_interval_day_time_info.ConvertIntervalDayTime,
    );

    @memset(odbc_buf[0..], 0);
    const convert_interval_year_month_info = try con.getInfo(allocator, .ConvertIntervalYearMonth, odbc_buf[0..]);
    defer convert_interval_year_month_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertIntervalYearMonthMask{ .data = 0 },
        convert_interval_year_month_info.ConvertIntervalYearMonth,
    );

    @memset(odbc_buf[0..], 0);
    const convert_longvarbinary_info = try con.getInfo(allocator, .ConvertLongvarbinary, odbc_buf[0..]);
    defer convert_longvarbinary_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertLongvarbinaryMask{ .data = 0 },
        convert_longvarbinary_info.ConvertLongvarbinary,
    );

    @memset(odbc_buf[0..], 0);
    const convert_longvarchar_info = try con.getInfo(allocator, .ConvertLongvarchar, odbc_buf[0..]);
    defer convert_longvarchar_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertLongvarcharMask{ .data = 0 },
        convert_longvarchar_info.ConvertLongvarchar,
    );

    @memset(odbc_buf[0..], 0);
    const convert_numeric_info = try con.getInfo(allocator, .ConvertNumeric, odbc_buf[0..]);
    defer convert_numeric_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertNumericMask{ .data = 129 },
        convert_numeric_info.ConvertNumeric,
    );

    @memset(odbc_buf[0..], 0);
    const convert_real_info = try con.getInfo(allocator, .ConvertReal, odbc_buf[0..]);
    defer convert_real_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertRealMask{ .data = 0 },
        convert_real_info.ConvertReal,
    );

    @memset(odbc_buf[0..], 0);
    const convert_smallint_info = try con.getInfo(allocator, .ConvertSmallint, odbc_buf[0..]);
    defer convert_smallint_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertSmallintMask{ .data = 129 },
        convert_smallint_info.ConvertSmallint,
    );

    @memset(odbc_buf[0..], 0);
    const convert_time_info = try con.getInfo(allocator, .ConvertTime, odbc_buf[0..]);
    defer convert_time_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertTimeMask{ .data = 1 },
        convert_time_info.ConvertTime,
    );

    @memset(odbc_buf[0..], 0);
    const convert_timestamp_info = try con.getInfo(allocator, .ConvertTimestamp, odbc_buf[0..]);
    defer convert_timestamp_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertTimestampMask{ .data = 1 },
        convert_timestamp_info.ConvertTimestamp,
    );

    @memset(odbc_buf[0..], 0);
    const convert_tinyint_info = try con.getInfo(allocator, .ConvertTinyint, odbc_buf[0..]);
    defer convert_tinyint_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertTinyintMask{ .data = 0 },
        convert_tinyint_info.ConvertTinyint,
    );

    @memset(odbc_buf[0..], 0);
    const convert_varbinary_info = try con.getInfo(allocator, .ConvertVarbinary, odbc_buf[0..]);
    defer convert_varbinary_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertVarbinaryMask{ .data = 0 },
        convert_varbinary_info.ConvertVarbinary,
    );

    @memset(odbc_buf[0..], 0);
    const convert_varchar_info = try con.getInfo(allocator, .ConvertVarchar, odbc_buf[0..]);
    defer convert_varchar_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertVarcharMask{ .data = 128 },
        convert_varchar_info.ConvertVarchar,
    );

    @memset(odbc_buf[0..], 0);
    const convert_functions_info = try con.getInfo(allocator, .ConvertFunctions, odbc_buf[0..]);
    defer convert_functions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ConvertFunctionsMask{ .data = 3 },
        convert_functions_info.ConvertFunctions,
    );

    @memset(odbc_buf[0..], 0);
    const correlation_name_info = try con.getInfo(allocator, .CorrelationName, odbc_buf[0..]);
    defer correlation_name_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CorrelationName.Any,
        correlation_name_info.CorrelationName,
    );

    @memset(odbc_buf[0..], 0);
    const create_assertion_info = try con.getInfo(allocator, .CreateAssertion, odbc_buf[0..]);
    defer create_assertion_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CreateAssertionMask{ .data = 0 },
        create_assertion_info.CreateAssertion,
    );

    @memset(odbc_buf[0..], 0);
    const create_character_set_info = try con.getInfo(allocator, .CreateCharacterSet, odbc_buf[0..]);
    defer create_character_set_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CreateCharacterSetMask{ .data = 0 },
        create_character_set_info.CreateCharacterSet,
    );

    @memset(odbc_buf[0..], 0);
    const create_collation_info = try con.getInfo(allocator, .CreateCollation, odbc_buf[0..]);
    defer create_collation_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CreateCollationMask{ .data = 0 },
        create_collation_info.CreateCollation,
    );

    @memset(odbc_buf[0..], 0);
    const create_domain_info = try con.getInfo(allocator, .CreateDomain, odbc_buf[0..]);
    defer create_domain_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CreateDomainMask{ .data = 0 },
        create_domain_info.CreateDomain,
    );

    @memset(odbc_buf[0..], 0);
    const create_schema_info = try con.getInfo(allocator, .CreateSchema, odbc_buf[0..]);
    defer create_schema_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CreateSchemaMask{ .data = 3 },
        create_schema_info.CreateSchema,
    );

    @memset(odbc_buf[0..], 0);
    const create_table_info = try con.getInfo(allocator, .CreateTable, odbc_buf[0..]);
    defer create_table_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CreateTableMask{ .data = 9729 },
        create_table_info.CreateTable,
    );

    @memset(odbc_buf[0..], 0);
    const create_translation_info = try con.getInfo(allocator, .CreateTranslation, odbc_buf[0..]);
    defer create_translation_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CreateTranslationMask{ .data = 0 },
        create_translation_info.CreateTranslation,
    );

    @memset(odbc_buf[0..], 0);
    const cursor_commit_behavior_info = try con.getInfo(allocator, .CursorCommitBehavior, odbc_buf[0..]);
    defer cursor_commit_behavior_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CursorBehavior.Preserve,
        cursor_commit_behavior_info.CursorCommitBehavior,
    );

    @memset(odbc_buf[0..], 0);
    const cursor_rollback_behavior_info = try con.getInfo(allocator, .CursorRollbackBehavior, odbc_buf[0..]);
    defer cursor_rollback_behavior_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CursorBehavior.Close,
        cursor_rollback_behavior_info.CursorRollbackBehavior,
    );

    @memset(odbc_buf[0..], 0);
    const cursor_sensitivity_info = try con.getInfo(allocator, .CursorSensitivity, odbc_buf[0..]);
    defer cursor_sensitivity_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.CursorSensitivity.Unspecified,
        cursor_sensitivity_info.CursorSensitivity,
    );

    @memset(odbc_buf[0..], 0);
    const data_source_name_info = try con.getInfo(allocator, .DataSourceName, odbc_buf[0..]);
    defer data_source_name_info.deinit(allocator);
    try expectEqualStrings("", data_source_name_info.DataSourceName);

    @memset(odbc_buf[0..], 0);
    const data_source_read_only_info = try con.getInfo(allocator, .DataSourceReadOnly, odbc_buf[0..]);
    defer data_source_read_only_info.deinit(allocator);
    try expectEqual(false, data_source_read_only_info.DataSourceReadOnly);

    @memset(odbc_buf[0..], 0);
    const database_name_info = try con.getInfo(allocator, .DatabaseName, odbc_buf[0..]);
    defer database_name_info.deinit(allocator);
    try expectEqualStrings("TESTDB", database_name_info.DatabaseName);

    @memset(odbc_buf[0..], 0);
    const dbms_name_info = try con.getInfo(allocator, .DbmsName, odbc_buf[0..]);
    defer dbms_name_info.deinit(allocator);
    try expectEqualStrings("DB2/LINUXX8664", dbms_name_info.DbmsName);

    @memset(odbc_buf[0..], 0);
    const dbms_ver_info = try con.getInfo(allocator, .DbmsVer, odbc_buf[0..]);
    defer dbms_ver_info.deinit(allocator);
    try expectEqualStrings("11.05.0900", dbms_ver_info.DbmsVer);

    @memset(odbc_buf[0..], 0);
    const ddl_index_info = try con.getInfo(allocator, .DdlIndex, odbc_buf[0..]);
    defer ddl_index_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DdlIndexMask{ .data = 3 },
        ddl_index_info.DdlIndex,
    );

    @memset(odbc_buf[0..], 0);
    const default_txn_isolation_info = try con.getInfo(allocator, .DefaultTxnIsolation, odbc_buf[0..]);
    defer default_txn_isolation_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DefaultTxnIsolationMask{ .data = 2 },
        default_txn_isolation_info.DefaultTxnIsolation,
    );

    @memset(odbc_buf[0..], 0);
    const describe_parameter_info = try con.getInfo(allocator, .DescribeParameter, odbc_buf[0..]);
    defer describe_parameter_info.deinit(allocator);
    try expectEqual(true, describe_parameter_info.DescribeParameter);

    @memset(odbc_buf[0..], 0);
    const driver_hdbc_info = try con.getInfo(allocator, .DriverHdbc, odbc_buf[0..]);
    defer driver_hdbc_info.deinit(allocator);
    try expect(driver_hdbc_info.DriverHdbc > 0);

    @memset(odbc_buf[0..], 0);
    const driver_henv_info = try con.getInfo(allocator, .DriverHenv, odbc_buf[0..]);
    defer driver_henv_info.deinit(allocator);
    try expect(driver_henv_info.DriverHenv > 0);

    @memset(odbc_buf[0..], 0);
    const driver_hlib_info = try con.getInfo(allocator, .DriverHlib, odbc_buf[0..]);
    defer driver_hlib_info.deinit(allocator);
    try expect(driver_hlib_info.DriverHlib > 0);

    // TODO:
    // - seems to require a statement on the connection
    // @memset(odbc_buf[0..], 0);
    // const driver_hstmt_info = try con.getInfo(allocator, .DriverHstmt, odbc_buf[0..]);
    // defer driver_hstmt_info.deinit(allocator);
    // try expect(driver_hstmt_info.DriverHstmt > 0);

    @memset(odbc_buf[0..], 0);
    const driver_name_info = try con.getInfo(allocator, .DriverName, odbc_buf[0..]);
    defer driver_name_info.deinit(allocator);
    try expectEqualStrings("libdb2.a", driver_name_info.DriverName);

    @memset(odbc_buf[0..], 0);
    const driver_odbc_ver = try con.getInfo(allocator, .DriverOdbcVer, odbc_buf[0..]);
    defer driver_odbc_ver.deinit(allocator);
    try expectEqualStrings("03.51", driver_odbc_ver.DriverOdbcVer);

    @memset(odbc_buf[0..], 0);
    const driver_ver_info = try con.getInfo(allocator, .DriverVer, odbc_buf[0..]);
    defer driver_ver_info.deinit(allocator);
    try expectEqualStrings("11.05.0900", driver_ver_info.DriverVer);

    @memset(odbc_buf[0..], 0);
    const drop_assertion_info = try con.getInfo(allocator, .DropAssertion, odbc_buf[0..]);
    defer drop_assertion_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropAssertionMask{ .data = 0 },
        drop_assertion_info.DropAssertion,
    );

    @memset(odbc_buf[0..], 0);
    const drop_character_set_info = try con.getInfo(allocator, .DropCharacterSet, odbc_buf[0..]);
    defer drop_character_set_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropCharacterSetMask{ .data = 0 },
        drop_character_set_info.DropCharacterSet,
    );

    @memset(odbc_buf[0..], 0);
    const drop_collation_info = try con.getInfo(allocator, .DropCollation, odbc_buf[0..]);
    defer drop_collation_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropCollationMask{ .data = 0 },
        drop_collation_info.DropCollation,
    );

    @memset(odbc_buf[0..], 0);
    const drop_domain_info = try con.getInfo(allocator, .DropDomain, odbc_buf[0..]);
    defer drop_domain_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropDomainMask{ .data = 0 },
        drop_domain_info.DropDomain,
    );

    @memset(odbc_buf[0..], 0);
    const drop_schema_info = try con.getInfo(allocator, .DropSchema, odbc_buf[0..]);
    defer drop_schema_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropSchemaMask{ .data = 3 },
        drop_schema_info.DropSchema,
    );

    @memset(odbc_buf[0..], 0);
    const drop_table_info = try con.getInfo(allocator, .DropTable, odbc_buf[0..]);
    defer drop_table_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropTableMask{ .data = 1 },
        drop_table_info.DropTable,
    );

    @memset(odbc_buf[0..], 0);
    const drop_translation_info = try con.getInfo(allocator, .DropTranslation, odbc_buf[0..]);
    defer drop_translation_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropTranslationMask{ .data = 0 },
        drop_translation_info.DropTranslation,
    );

    @memset(odbc_buf[0..], 0);
    const drop_view_info = try con.getInfo(allocator, .DropView, odbc_buf[0..]);
    defer drop_view_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DropViewMask{ .data = 1 },
        drop_view_info.DropView,
    );

    @memset(odbc_buf[0..], 0);
    const dynamic_cursor_attributes_1 = try con.getInfo(allocator, .DynamicCursorAttributes1, odbc_buf[0..]);
    defer dynamic_cursor_attributes_1.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DynamicCursorAttributes1Mask{ .data = 0 },
        dynamic_cursor_attributes_1.DynamicCursorAttributes1,
    );

    @memset(odbc_buf[0..], 0);
    const dynamic_cursor_attributes_2 = try con.getInfo(allocator, .DynamicCursorAttributes2, odbc_buf[0..]);
    defer dynamic_cursor_attributes_2.deinit(allocator);
    try expectEqual(
        InfoTypeValue.DynamicCursorAttributes2Mask{ .data = 0 },
        dynamic_cursor_attributes_2.DynamicCursorAttributes2,
    );

    @memset(odbc_buf[0..], 0);
    const expressions_in_orderby_info = try con.getInfo(allocator, .ExpressionsInOrderby, odbc_buf[0..]);
    defer expressions_in_orderby_info.deinit(allocator);
    try expectEqual(true, expressions_in_orderby_info.ExpressionsInOrderby);

    @memset(odbc_buf[0..], 0);
    const fetch_direction_info = try con.getInfo(allocator, .FetchDirection, odbc_buf[0..]);
    defer fetch_direction_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.FetchDirectionMask{ .data = 255 },
        fetch_direction_info.FetchDirection,
    );

    @memset(odbc_buf[0..], 0);
    const forward_only_cursor_attributes_1 = try con.getInfo(allocator, .ForwardOnlyCursorAttributes1, odbc_buf[0..]);
    defer forward_only_cursor_attributes_1.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ForwardOnlyCursorAttributes1Mask{ .data = 57345 },
        forward_only_cursor_attributes_1.ForwardOnlyCursorAttributes1,
    );

    @memset(odbc_buf[0..], 0);
    const forward_only_cursor_attributes_2 = try con.getInfo(allocator, .ForwardOnlyCursorAttributes2, odbc_buf[0..]);
    defer forward_only_cursor_attributes_2.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ForwardOnlyCursorAttributes2Mask{ .data = 2179 },
        forward_only_cursor_attributes_2.ForwardOnlyCursorAttributes2,
    );

    @memset(odbc_buf[0..], 0);
    const getdata_extensions_info = try con.getInfo(allocator, .GetdataExtensions, odbc_buf[0..]);
    defer getdata_extensions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.GetdataExtensionsMask{ .data = 7 },
        getdata_extensions_info.GetdataExtensions,
    );

    @memset(odbc_buf[0..], 0);
    const group_by_info = try con.getInfo(allocator, .GroupBy, odbc_buf[0..]);
    defer group_by_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.GroupBy.GroupByContainsSelect,
        group_by_info.GroupBy,
    );

    @memset(odbc_buf[0..], 0);
    const identifier_case_info = try con.getInfo(allocator, .IdentifierCase, odbc_buf[0..]);
    defer identifier_case_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.IdentifierCase.Upper,
        identifier_case_info.IdentifierCase,
    );

    @memset(odbc_buf[0..], 0);
    const identifier_quote_char_info = try con.getInfo(allocator, .IdentifierQuoteChar, odbc_buf[0..]);
    defer identifier_quote_char_info.deinit(allocator);
    try expectEqualStrings(
        "\"",
        identifier_quote_char_info.IdentifierQuoteChar,
    );

    @memset(odbc_buf[0..], 0);
    const info_schema_views_info = try con.getInfo(allocator, .InfoSchemaViews, odbc_buf[0..]);
    defer info_schema_views_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.InfoSchemaViewsMask{ .data = 0 },
        info_schema_views_info.InfoSchemaViews,
    );

    @memset(odbc_buf[0..], 0);
    const insert_statement_info = try con.getInfo(allocator, .InsertStatement, odbc_buf[0..]);
    defer insert_statement_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.InsertStatementMask{ .data = 7 },
        insert_statement_info.InsertStatement,
    );

    @memset(odbc_buf[0..], 0);
    const integrity_info = try con.getInfo(allocator, .Integrity, odbc_buf[0..]);
    defer integrity_info.deinit(allocator);
    try expectEqual(true, integrity_info.Integrity);

    @memset(odbc_buf[0..], 0);
    const keyset_cursor_attributes1_info = try con.getInfo(allocator, .KeysetCursorAttributes1, odbc_buf[0..]);
    defer keyset_cursor_attributes1_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.KeysetCursorAttributes1Mask{ .data = 990799 },
        keyset_cursor_attributes1_info.KeysetCursorAttributes1,
    );

    @memset(odbc_buf[0..], 0);
    const keyset_cursor_attributes2_info = try con.getInfo(allocator, .KeysetCursorAttributes2, odbc_buf[0..]);
    defer keyset_cursor_attributes2_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.KeysetCursorAttributes2Mask{ .data = 16395 },
        keyset_cursor_attributes2_info.KeysetCursorAttributes2,
    );

    @memset(odbc_buf[0..], 0);
    const keywords_info = try con.getInfo(allocator, .Keywords, odbc_buf[0..]);
    defer keywords_info.deinit(allocator);
    try expectEqualStrings(
        "AFTER,ALIAS,ALLOW,APPLICATION,ASSOCIATE,ASUTIME,AUDIT,AUX,AUXILIARY,BEFORE,BINARY,BUFFERPOOL,CACHE,CALL,CALLED,CAPTURE,CARDINALITY,CCSID,CLUSTER,COLLECTION,COLLID,COMMENT,CONCAT,CONDITION,CONTAINS,COUNT_BIG,CURRENT_LC_CTYPE,CURRENT_PATH,CURRENT_SERVER,CURRENT_TIMEZONE,CYCLE,DATA,DATABASE,DAYS,DB2GENERAL,DB2GENRL,DB2SQL,DBINFO,DEFAULTS,DEFINITION,DETERMINISTIC,DISALLOW,DO,DSNHATTR,DSSIZE,DYNAMIC,EACH,EDITPROC,ELSEIF,ENCODING,END-EXEC1,ERASE,EXCLUDING,EXIT,FENCED,FIELDPROC,FILE,FINAL,FREE,FUNCTION,GENERAL,GENERATED,GRAPHIC,HANDLER,HOLD,HOURS,IF,INCLUDING,INCREMENT,INHERIT,INOUT,INTEGRITY,ISOBID,ITERATE,JAR,JAVA,LABEL,LC_CTYPE,LEAVE,LINKTYPE,LOCALE,LOCATOR,LOCATORS,LOCK,LOCKMAX,LOCKSIZE,LONG,LOOP,MAXVALUE,MICROSECOND,MICROSECONDS,MINUTES,MINVALUE,MODE,MODIFIES,MONTHS,NEW,NEW_TABLE,NOCACHE,NOCYCLE,NODENAME,NODENUMBER,NOMAXVALUE,NOMINVALUE,NOORDER,NULLS,NUMPARTS,OBID,OLD,OLD_TABLE,OPTIMIZATION,OPTIMIZE,OUT,OVERRIDING,PACKAGE,PARAMETER,PART,PARTITION,PATH,PIECESIZE,PLAN,PRIQTY,PROGRAM,PSID,QUERYNO,READS,RECOVERY,REFERENCING,RELEASE,RENAME,REPEAT,RESET,RESIGNAL,RESTART,RESULT,RESULT_SET_LOCATOR,RETURN,RETURNS,ROUTINE,ROW,RRN,RUN,SAVEPOINT,SCRATCHPAD,SECONDS,SECQTY,SECURITY,SENSITIVE,SIGNAL,SIMPLE,SOURCE,SPECIFIC,SQLID,STANDARD,START,STATIC,STAY,STOGROUP,STORES,STYLE,SUBPAGES,SYNONYM,SYSFUN,SYSIBM,SYSPROC,SYSTEM,TABLESPACE,TRIGGER,TYPE,UNDO,UNTIL,VALIDPROC,VARIABLE,VARIANT,VCAT,VOLUMES,WHILE,WLM,YEARS",
        keywords_info.Keywords,
    );

    @memset(odbc_buf[0..], 0);
    const like_escape_clause_info = try con.getInfo(allocator, .LikeEscapeClause, odbc_buf[0..]);
    defer like_escape_clause_info.deinit(allocator);
    try expectEqual(true, like_escape_clause_info.LikeEscapeClause);

    @memset(odbc_buf[0..], 0);
    const lock_types_info = try con.getInfo(allocator, .LockTypes, odbc_buf[0..]);
    defer lock_types_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.LockTypesMask{ .data = 0 },
        lock_types_info.LockTypes,
    );

    @memset(odbc_buf[0..], 0);
    const max_async_concurrent_statements_info = try con.getInfo(allocator, .MaxAsyncConcurrentStatements, odbc_buf[0..]);
    defer max_async_concurrent_statements_info.deinit(allocator);
    try expectEqual(1, max_async_concurrent_statements_info.MaxAsyncConcurrentStatements);

    @memset(odbc_buf[0..], 0);
    const max_binary_literal_len_info = try con.getInfo(allocator, .MaxBinaryLiteralLen, odbc_buf[0..]);
    defer max_binary_literal_len_info.deinit(allocator);
    try expectEqual(4000, max_binary_literal_len_info.MaxBinaryLiteralLen);

    @memset(odbc_buf[0..], 0);
    const max_catalog_name_len_info = try con.getInfo(allocator, .MaxCatalogNameLen, odbc_buf[0..]);
    defer max_catalog_name_len_info.deinit(allocator);
    try expectEqual(0, max_catalog_name_len_info.MaxCatalogNameLen);

    @memset(odbc_buf[0..], 0);
    const max_char_literal_len_info = try con.getInfo(allocator, .MaxCharLiteralLen, odbc_buf[0..]);
    defer max_char_literal_len_info.deinit(allocator);
    try expectEqual(32672, max_char_literal_len_info.MaxCharLiteralLen);

    @memset(odbc_buf[0..], 0);
    const max_column_name_len_info = try con.getInfo(allocator, .MaxColumnNameLen, odbc_buf[0..]);
    defer max_column_name_len_info.deinit(allocator);
    try expectEqual(128, max_column_name_len_info.MaxColumnNameLen);

    @memset(odbc_buf[0..], 0);
    const max_columns_in_group_by_info = try con.getInfo(allocator, .MaxColumnsInGroupBy, odbc_buf[0..]);
    defer max_columns_in_group_by_info.deinit(allocator);
    try expectEqual(1012, max_columns_in_group_by_info.MaxColumnsInGroupBy);

    @memset(odbc_buf[0..], 0);
    const max_columns_in_index_info = try con.getInfo(allocator, .MaxColumnsInIndex, odbc_buf[0..]);
    defer max_columns_in_index_info.deinit(allocator);
    try expectEqual(16, max_columns_in_index_info.MaxColumnsInIndex);

    @memset(odbc_buf[0..], 0);
    const max_columns_in_order_by_info = try con.getInfo(allocator, .MaxColumnsInOrderBy, odbc_buf[0..]);
    defer max_columns_in_order_by_info.deinit(allocator);
    try expectEqual(1012, max_columns_in_order_by_info.MaxColumnsInOrderBy);

    @memset(odbc_buf[0..], 0);
    const max_columns_in_select_info = try con.getInfo(allocator, .MaxColumnsInSelect, odbc_buf[0..]);
    defer max_columns_in_select_info.deinit(allocator);
    try expectEqual(1012, max_columns_in_select_info.MaxColumnsInSelect);

    @memset(odbc_buf[0..], 0);
    const max_columns_in_table_info = try con.getInfo(allocator, .MaxColumnsInTable, odbc_buf[0..]);
    defer max_columns_in_table_info.deinit(allocator);
    try expectEqual(1012, max_columns_in_table_info.MaxColumnsInTable);

    @memset(odbc_buf[0..], 0);
    const max_concurrent_activities_info = try con.getInfo(allocator, .MaxConcurrentActivities, odbc_buf[0..]);
    defer max_concurrent_activities_info.deinit(allocator);
    try expectEqual(0, max_concurrent_activities_info.MaxConcurrentActivities);

    @memset(odbc_buf[0..], 0);
    const max_cursor_name_len_info = try con.getInfo(allocator, .MaxCursorNameLen, odbc_buf[0..]);
    defer max_cursor_name_len_info.deinit(allocator);
    try expectEqual(128, max_cursor_name_len_info.MaxCursorNameLen);

    @memset(odbc_buf[0..], 0);
    const max_driver_connections_info = try con.getInfo(allocator, .MaxDriverConnections, odbc_buf[0..]);
    defer max_driver_connections_info.deinit(allocator);
    try expectEqual(0, max_driver_connections_info.MaxDriverConnections);

    @memset(odbc_buf[0..], 0);
    const max_identifier_len_info = try con.getInfo(allocator, .MaxIdentifierLen, odbc_buf[0..]);
    defer max_identifier_len_info.deinit(allocator);
    try expectEqual(128, max_identifier_len_info.MaxIdentifierLen);

    @memset(odbc_buf[0..], 0);
    const max_index_size_info = try con.getInfo(allocator, .MaxIndexSize, odbc_buf[0..]);
    defer max_index_size_info.deinit(allocator);
    try expectEqual(1024, max_index_size_info.MaxIndexSize);

    @memset(odbc_buf[0..], 0);
    const max_procedure_name_len_info = try con.getInfo(allocator, .MaxProcedureNameLen, odbc_buf[0..]);
    defer max_procedure_name_len_info.deinit(allocator);
    try expectEqual(128, max_procedure_name_len_info.MaxProcedureNameLen);

    @memset(odbc_buf[0..], 0);
    const max_row_size_info = try con.getInfo(allocator, .MaxRowSize, odbc_buf[0..]);
    defer max_row_size_info.deinit(allocator);
    try expectEqual(32677, max_row_size_info.MaxRowSize);

    @memset(odbc_buf[0..], 0);
    const max_row_size_includes_long_info = try con.getInfo(allocator, .MaxRowSizeIncludesLong, odbc_buf[0..]);
    defer max_row_size_includes_long_info.deinit(allocator);
    try expectEqual(false, max_row_size_includes_long_info.MaxRowSizeIncludesLong);

    @memset(odbc_buf[0..], 0);
    const max_schema_name_len_info = try con.getInfo(allocator, .MaxSchemaNameLen, odbc_buf[0..]);
    defer max_schema_name_len_info.deinit(allocator);
    try expectEqual(128, max_schema_name_len_info.MaxSchemaNameLen);

    @memset(odbc_buf[0..], 0);
    const max_statement_len_info = try con.getInfo(allocator, .MaxStatementLen, odbc_buf[0..]);
    defer max_statement_len_info.deinit(allocator);
    try expectEqual(2097152, max_statement_len_info.MaxStatementLen);

    @memset(odbc_buf[0..], 0);
    const max_table_name_len_info = try con.getInfo(allocator, .MaxTableNameLen, odbc_buf[0..]);
    defer max_table_name_len_info.deinit(allocator);
    try expectEqual(128, max_table_name_len_info.MaxTableNameLen);

    @memset(odbc_buf[0..], 0);
    const max_tables_in_select_info = try con.getInfo(allocator, .MaxTablesInSelect, odbc_buf[0..]);
    defer max_tables_in_select_info.deinit(allocator);
    try expectEqual(0, max_tables_in_select_info.MaxTablesInSelect);

    @memset(odbc_buf[0..], 0);
    const max_user_name_len_info = try con.getInfo(allocator, .MaxUserNameLen, odbc_buf[0..]);
    defer max_user_name_len_info.deinit(allocator);
    try expectEqual(8, max_user_name_len_info.MaxUserNameLen);

    @memset(odbc_buf[0..], 0);
    const mult_result_sets_info = try con.getInfo(allocator, .MultResultSets, odbc_buf[0..]);
    defer mult_result_sets_info.deinit(allocator);
    try expectEqual(true, mult_result_sets_info.MultResultSets);

    @memset(odbc_buf[0..], 0);
    const multiple_active_txn_info = try con.getInfo(allocator, .MultipleActiveTxn, odbc_buf[0..]);
    defer multiple_active_txn_info.deinit(allocator);
    try expectEqual(true, multiple_active_txn_info.MultipleActiveTxn);

    @memset(odbc_buf[0..], 0);
    const need_long_data_len_info = try con.getInfo(allocator, .NeedLongDataLen, odbc_buf[0..]);
    defer need_long_data_len_info.deinit(allocator);
    try expectEqual(false, need_long_data_len_info.NeedLongDataLen);

    @memset(odbc_buf[0..], 0);
    const non_nullable_columns_info = try con.getInfo(allocator, .NonNullableColumns, odbc_buf[0..]);
    defer non_nullable_columns_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.NonNullableColumns.NonNull,
        non_nullable_columns_info.NonNullableColumns,
    );

    @memset(odbc_buf[0..], 0);
    const null_collation_info = try con.getInfo(allocator, .NullCollation, odbc_buf[0..]);
    defer null_collation_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.NullCollation.High,
        null_collation_info.NullCollation,
    );

    @memset(odbc_buf[0..], 0);
    const numeric_functions_info = try con.getInfo(allocator, .NumericFunctions, odbc_buf[0..]);
    defer numeric_functions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.NumericFunctionsMask{ .data = 16777215 },
        numeric_functions_info.NumericFunctions,
    );

    @memset(odbc_buf[0..], 0);
    const odbc_api_conformance_info = try con.getInfo(allocator, .OdbcApiConformance, odbc_buf[0..]);
    defer odbc_api_conformance_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.OdbcApiConformance.Level2,
        odbc_api_conformance_info.OdbcApiConformance,
    );

    @memset(odbc_buf[0..], 0);
    const odbc_sag_cli_conformance_info = try con.getInfo(allocator, .OdbcSagCliConformance, odbc_buf[0..]);
    defer odbc_sag_cli_conformance_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.OdbcSagCliConformance.Compliant,
        odbc_sag_cli_conformance_info.OdbcSagCliConformance,
    );

    @memset(odbc_buf[0..], 0);
    const odbc_sql_conformance_info = try con.getInfo(allocator, .OdbcSqlConformance, odbc_buf[0..]);
    defer odbc_sql_conformance_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.OdbcSqlConformance.Extended,
        odbc_sql_conformance_info.OdbcSqlConformance,
    );

    @memset(odbc_buf[0..], 0);
    const odbc_ver_info = try con.getInfo(allocator, .OdbcVer, odbc_buf[0..]);
    defer odbc_ver_info.deinit(allocator);
    try expectEqualStrings("03.52", odbc_ver_info.OdbcVer);

    @memset(odbc_buf[0..], 0);
    const oj_capabilities_info = try con.getInfo(allocator, .OjCapabilities, odbc_buf[0..]);
    defer oj_capabilities_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.OjCapabilitiesMask{ .data = 127 },
        oj_capabilities_info.OjCapabilities,
    );

    @memset(odbc_buf[0..], 0);
    const order_by_columns_in_select_info = try con.getInfo(allocator, .OrderByColumnsInSelect, odbc_buf[0..]);
    defer order_by_columns_in_select_info.deinit(allocator);
    try expectEqual(false, order_by_columns_in_select_info.OrderByColumnsInSelect);

    @memset(odbc_buf[0..], 0);
    const outer_joins_info = try con.getInfo(allocator, .OuterJoins, odbc_buf[0..]);
    defer outer_joins_info.deinit(allocator);
    try expectEqual(true, outer_joins_info.OuterJoins);

    @memset(odbc_buf[0..], 0);
    const owner_term_info = try con.getInfo(allocator, .OwnerTerm, odbc_buf[0..]);
    defer owner_term_info.deinit(allocator);
    try expectEqualStrings("schema", owner_term_info.OwnerTerm);

    @memset(odbc_buf[0..], 0);
    const param_array_row_counts_info = try con.getInfo(allocator, .ParamArrayRowCounts, odbc_buf[0..]);
    defer param_array_row_counts_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ParamArrayRowCounts.NoBatch,
        param_array_row_counts_info.ParamArrayRowCounts,
    );

    @memset(odbc_buf[0..], 0);
    const param_array_selects_info = try con.getInfo(allocator, .ParamArraySelects, odbc_buf[0..]);
    defer param_array_selects_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ParamArraySelects.Batch,
        param_array_selects_info.ParamArraySelects,
    );

    @memset(odbc_buf[0..], 0);
    const pos_operations_info = try con.getInfo(allocator, .PosOperations, odbc_buf[0..]);
    defer pos_operations_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.PosOperationsMask{ .data = 31 },
        pos_operations_info.PosOperations,
    );

    @memset(odbc_buf[0..], 0);
    const positioned_statements_info = try con.getInfo(allocator, .PositionedStatements, odbc_buf[0..]);
    defer positioned_statements_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.PositionedStatementsMask{ .data = 7 },
        positioned_statements_info.PositionedStatements,
    );

    @memset(odbc_buf[0..], 0);
    const procedure_term_info = try con.getInfo(allocator, .ProcedureTerm, odbc_buf[0..]);
    defer procedure_term_info.deinit(allocator);
    try expectEqualStrings("stored procedure", procedure_term_info.ProcedureTerm);

    @memset(odbc_buf[0..], 0);
    const procedures_info = try con.getInfo(allocator, .Procedures, odbc_buf[0..]);
    defer procedures_info.deinit(allocator);
    try expectEqual(true, procedures_info.Procedures);

    @memset(odbc_buf[0..], 0);
    const quoted_identifier_case_info = try con.getInfo(allocator, .QuotedIdentifierCase, odbc_buf[0..]);
    defer quoted_identifier_case_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.QuotedIdentifierCase.Sensitive,
        quoted_identifier_case_info.QuotedIdentifierCase,
    );

    @memset(odbc_buf[0..], 0);
    const row_updates_info = try con.getInfo(allocator, .RowUpdates, odbc_buf[0..]);
    defer row_updates_info.deinit(allocator);
    try expectEqual(false, row_updates_info.RowUpdates);

    @memset(odbc_buf[0..], 0);
    const schema_usage_info = try con.getInfo(allocator, .SchemaUsage, odbc_buf[0..]);
    defer schema_usage_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.SchemaUsageMask{ .data = 31 },
        schema_usage_info.SchemaUsage,
    );

    @memset(odbc_buf[0..], 0);
    const scroll_concurrency_info = try con.getInfo(allocator, .ScrollConcurrency, odbc_buf[0..]);
    defer scroll_concurrency_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ScrollConcurrencyMask{ .data = 11 },
        scroll_concurrency_info.ScrollConcurrency,
    );

    @memset(odbc_buf[0..], 0);
    const scroll_options_info = try con.getInfo(allocator, .ScrollOptions, odbc_buf[0..]);
    defer scroll_options_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.ScrollOptionsMask{ .data = 19 },
        scroll_options_info.ScrollOptions,
    );

    @memset(odbc_buf[0..], 0);
    const search_pattern_escape_info = try con.getInfo(allocator, .SearchPatternEscape, odbc_buf[0..]);
    defer search_pattern_escape_info.deinit(allocator);
    try expectEqualStrings("\\", search_pattern_escape_info.SearchPatternEscape);

    @memset(odbc_buf[0..], 0);
    const server_name_info = try con.getInfo(allocator, .ServerName, odbc_buf[0..]);
    defer server_name_info.deinit(allocator);
    try expectEqualStrings("DB2", server_name_info.ServerName);

    @memset(odbc_buf[0..], 0);
    const special_characters_info = try con.getInfo(allocator, .SpecialCharacters, odbc_buf[0..]);
    defer special_characters_info.deinit(allocator);
    try expectEqualStrings("@#", special_characters_info.SpecialCharacters);

    @memset(odbc_buf[0..], 0);
    const sql92_predicates_info = try con.getInfo(allocator, .Sql92Predicates, odbc_buf[0..]);
    defer sql92_predicates_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.Sql92PredicatesMask{ .data = 15879 },
        sql92_predicates_info.Sql92Predicates,
    );

    @memset(odbc_buf[0..], 0);
    const sql92_value_expressions_info = try con.getInfo(allocator, .Sql92ValueExpressions, odbc_buf[0..]);
    defer sql92_value_expressions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.Sql92ValueExpressionsMask{ .data = 15 },
        sql92_value_expressions_info.Sql92ValueExpressions,
    );

    @memset(odbc_buf[0..], 0);
    const static_cursor_attributes_1_info = try con.getInfo(allocator, .StaticCursorAttributes1, odbc_buf[0..]);
    defer static_cursor_attributes_1_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.StaticCursorAttributes1Mask{ .data = 15 },
        static_cursor_attributes_1_info.StaticCursorAttributes1,
    );

    @memset(odbc_buf[0..], 0);
    const static_cursor_attributes_2_info = try con.getInfo(allocator, .StaticCursorAttributes2, odbc_buf[0..]);
    defer static_cursor_attributes_2_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.StaticCursorAttributes2Mask{ .data = 131 },
        static_cursor_attributes_2_info.StaticCursorAttributes2,
    );

    @memset(odbc_buf[0..], 0);
    const static_sensitivity_info = try con.getInfo(allocator, .StaticSensitivity, odbc_buf[0..]);
    defer static_sensitivity_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.StaticSensitivityMask{ .data = 0 },
        static_sensitivity_info.StaticSensitivity,
    );

    @memset(odbc_buf[0..], 0);
    const string_functions_info = try con.getInfo(allocator, .StringFunctions, odbc_buf[0..]);
    defer string_functions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.StringFunctionsMask{ .data = 524287 },
        string_functions_info.StringFunctions,
    );

    @memset(odbc_buf[0..], 0);
    const subqueries_info = try con.getInfo(allocator, .Subqueries, odbc_buf[0..]);
    defer subqueries_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.SubqueriesMask{ .data = 31 },
        subqueries_info.Subqueries,
    );

    @memset(odbc_buf[0..], 0);
    const system_functions_info = try con.getInfo(allocator, .SystemFunctions, odbc_buf[0..]);
    defer system_functions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.SystemFunctionsMask{ .data = 7 },
        system_functions_info.SystemFunctions,
    );

    @memset(odbc_buf[0..], 0);
    const table_term_info = try con.getInfo(allocator, .TableTerm, odbc_buf[0..]);
    defer table_term_info.deinit(allocator);
    try expectEqualStrings("table", table_term_info.TableTerm);

    @memset(odbc_buf[0..], 0);
    const timedate_add_intervals_info = try con.getInfo(allocator, .TimedateAddIntervals, odbc_buf[0..]);
    defer timedate_add_intervals_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.TimedateAddIntervalsMask{ .data = 511 },
        timedate_add_intervals_info.TimedateAddIntervals,
    );

    @memset(odbc_buf[0..], 0);
    const timedate_diff_intervals_info = try con.getInfo(allocator, .TimedateDiffIntervals, odbc_buf[0..]);
    defer timedate_diff_intervals_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.TimedateDiffIntervalsMask{ .data = 511 },
        timedate_diff_intervals_info.TimedateDiffIntervals,
    );

    @memset(odbc_buf[0..], 0);
    const timedate_functions_info = try con.getInfo(allocator, .TimedateFunctions, odbc_buf[0..]);
    defer timedate_functions_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.TimedateFunctionsMask{ .data = 131071 },
        timedate_functions_info.TimedateFunctions,
    );

    @memset(odbc_buf[0..], 0);
    const txn_capable_info = try con.getInfo(allocator, .TxnCapable, odbc_buf[0..]);
    defer txn_capable_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.TxnCapable.All,
        txn_capable_info.TxnCapable,
    );

    @memset(odbc_buf[0..], 0);
    const txn_isolation_option_info = try con.getInfo(allocator, .TxnIsolationOption, odbc_buf[0..]);
    defer txn_isolation_option_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.TxnIsolationOptionMask{ .data = 15 },
        txn_isolation_option_info.TxnIsolationOption,
    );

    @memset(odbc_buf[0..], 0);
    const union_info = try con.getInfo(allocator, .Union, odbc_buf[0..]);
    defer union_info.deinit(allocator);
    try expectEqual(
        InfoTypeValue.UnionMask{ .data = 3 },
        union_info.Union,
    );

    @memset(odbc_buf[0..], 0);
    const user_name_info = try con.getInfo(allocator, .UserName, odbc_buf[0..]);
    defer user_name_info.deinit(allocator);
    try expectEqualStrings("db2inst1", user_name_info.UserName);

    @memset(odbc_buf[0..], 0);
    const xopen_cli_year_info = try con.getInfo(allocator, .XopenCliYear, odbc_buf[0..]);
    defer xopen_cli_year_info.deinit(allocator);
    try expectEqualStrings("1995", xopen_cli_year_info.XopenCliYear);
}
