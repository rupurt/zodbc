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

test ".getInfo/1 returns general information about the connected DBMS" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    var info_type: InfoTypeValue = undefined;

    info_type = try con.getInfo(.AccessibleProcedures);
    try expectEqual(false, info_type.tag().AccessibleProcedures);

    info_type = try con.getInfo(.AccessibleTables);
    try expectEqual(false, info_type.tag().AccessibleTables);

    info_type = try con.getInfo(.ActiveEnvironments);
    try expectEqual(1, info_type.tag().ActiveEnvironments);

    info_type = try con.getInfo(.AggregateFunctions);
    try expectEqual(
        InfoTypeValue.Tag.AggregateFunctionsMask{ .data = 64 },
        info_type.tag().AggregateFunctions,
    );

    info_type = try con.getInfo(.AlterDomain);
    try expectEqual(
        InfoTypeValue.Tag.AlterDomainMask{ .data = 0 },
        info_type.tag().AlterDomain,
    );

    info_type = try con.getInfo(.AlterTable);
    try expectEqual(
        InfoTypeValue.Tag.AlterTableMask{ .data = 61545 },
        info_type.tag().AlterTable,
    );

    info_type = try con.getInfo(.BatchRowCount);
    try expectEqual(
        InfoTypeValue.Tag.BatchRowCountMask{ .data = 4 },
        info_type.tag().BatchRowCount,
    );

    info_type = try con.getInfo(.BatchSupport);
    try expectEqual(
        InfoTypeValue.Tag.BatchSupportMask{ .data = 7 },
        info_type.tag().BatchSupport,
    );

    info_type = try con.getInfo(.BookmarkPersistence);
    try expectEqual(
        InfoTypeValue.Tag.BookmarkPersistenceMask{ .data = 90 },
        info_type.tag().BookmarkPersistence,
    );

    info_type = try con.getInfo(.CatalogLocation);
    try expectEqual(0, info_type.tag().CatalogLocation);

    info_type = try con.getInfo(.CatalogName);
    try expectEqual(false, info_type.tag().CatalogName);

    info_type = try con.getInfo(.CatalogNameSeparator);
    try expectEqualSlices(u8, "."[0..1], info_type.tag().CatalogNameSeparator);

    info_type = try con.getInfo(.CatalogTerm);
    try expectEqualStrings("", info_type.tag().CatalogTerm);

    info_type = try con.getInfo(.CatalogUsage);
    try expectEqual(
        InfoTypeValue.Tag.CatalogUsageMask{ .data = 0 },
        info_type.tag().CatalogUsage,
    );

    info_type = try con.getInfo(.CollationSeq);
    try expectEqualStrings("", info_type.tag().CollationSeq);

    info_type = try con.getInfo(.ColumnAlias);
    try expectEqual(true, info_type.tag().ColumnAlias);

    // info_type = try con.getInfo(.ConcatNullBehavior);
    // try expectEqual(
    //     .{'Y'},
    //     info_type.ConcatNullBehavior,
    // );

    info_type = try con.getInfo(.ConvertBigint);
    try expectEqual(
        InfoTypeValue.Tag.ConvertBigintMask{ .data = 0 },
        info_type.tag().ConvertBigint,
    );

    info_type = try con.getInfo(.ConvertBinary);
    try expectEqual(
        InfoTypeValue.Tag.ConvertBinaryMask{ .data = 0 },
        info_type.tag().ConvertBinary,
    );

    info_type = try con.getInfo(.ConvertBit);
    try expectEqual(
        InfoTypeValue.Tag.ConvertBitMask{ .data = 0 },
        info_type.tag().ConvertBit,
    );

    info_type = try con.getInfo(.ConvertChar);
    try expectEqual(
        InfoTypeValue.Tag.ConvertCharMask{ .data = 129 },
        info_type.tag().ConvertChar,
    );

    info_type = try con.getInfo(.ConvertDate);
    try expectEqual(
        InfoTypeValue.Tag.ConvertDateMask{ .data = 1 },
        info_type.tag().ConvertDate,
    );

    info_type = try con.getInfo(.ConvertDecimal);
    try expectEqual(
        InfoTypeValue.Tag.ConvertDecimalMask{ .data = 129 },
        info_type.tag().ConvertDecimal,
    );

    info_type = try con.getInfo(.ConvertDouble);
    try expectEqual(
        InfoTypeValue.Tag.ConvertDoubleMask{ .data = 129 },
        info_type.tag().ConvertDouble,
    );

    info_type = try con.getInfo(.ConvertFloat);
    try expectEqual(
        InfoTypeValue.Tag.ConvertFloatMask{ .data = 129 },
        info_type.tag().ConvertFloat,
    );

    info_type = try con.getInfo(.ConvertInteger);
    try expectEqual(
        InfoTypeValue.Tag.ConvertIntegerMask{ .data = 129 },
        info_type.tag().ConvertInteger,
    );

    info_type = try con.getInfo(.ConvertIntervalDayTime);
    try expectEqual(
        InfoTypeValue.Tag.ConvertIntervalDayTimeMask{ .data = 0 },
        info_type.tag().ConvertIntervalDayTime,
    );

    info_type = try con.getInfo(.ConvertIntervalYearMonth);
    try expectEqual(
        InfoTypeValue.Tag.ConvertIntervalYearMonthMask{ .data = 0 },
        info_type.tag().ConvertIntervalYearMonth,
    );

    info_type = try con.getInfo(.ConvertLongvarbinary);
    try expectEqual(
        InfoTypeValue.Tag.ConvertLongvarbinaryMask{ .data = 0 },
        info_type.tag().ConvertLongvarbinary,
    );

    info_type = try con.getInfo(.ConvertLongvarchar);
    try expectEqual(
        InfoTypeValue.Tag.ConvertLongvarcharMask{ .data = 0 },
        info_type.tag().ConvertLongvarchar,
    );

    info_type = try con.getInfo(.ConvertNumeric);
    try expectEqual(
        InfoTypeValue.Tag.ConvertNumericMask{ .data = 129 },
        info_type.tag().ConvertNumeric,
    );

    info_type = try con.getInfo(.ConvertReal);
    try expectEqual(
        InfoTypeValue.Tag.ConvertRealMask{ .data = 0 },
        info_type.tag().ConvertReal,
    );

    info_type = try con.getInfo(.ConvertSmallint);
    try expectEqual(
        InfoTypeValue.Tag.ConvertSmallintMask{ .data = 129 },
        info_type.tag().ConvertSmallint,
    );

    info_type = try con.getInfo(.ConvertTime);
    try expectEqual(
        InfoTypeValue.Tag.ConvertTimeMask{ .data = 1 },
        info_type.tag().ConvertTime,
    );

    info_type = try con.getInfo(.ConvertTimestamp);
    try expectEqual(
        InfoTypeValue.Tag.ConvertTimestampMask{ .data = 1 },
        info_type.tag().ConvertTimestamp,
    );

    info_type = try con.getInfo(.ConvertTinyint);
    try expectEqual(
        InfoTypeValue.Tag.ConvertTinyintMask{ .data = 0 },
        info_type.tag().ConvertTinyint,
    );

    info_type = try con.getInfo(.ConvertVarbinary);
    try expectEqual(
        InfoTypeValue.Tag.ConvertVarbinaryMask{ .data = 0 },
        info_type.tag().ConvertVarbinary,
    );

    info_type = try con.getInfo(.ConvertVarchar);
    try expectEqual(
        InfoTypeValue.Tag.ConvertVarcharMask{ .data = 128 },
        info_type.tag().ConvertVarchar,
    );

    info_type = try con.getInfo(.ConvertFunctions);
    try expectEqual(
        InfoTypeValue.Tag.ConvertFunctionsMask{ .data = 3 },
        info_type.tag().ConvertFunctions,
    );

    // info_type = try con.getInfo(.CorrelationName);
    // try expectEqual(
    //     InfoTypeValue.Tag.CorrelationNameMask{ .data = 0 },
    //     info_type.tag().CorrelationName,
    // );

    // // CreateAssertion = c.SQL_CREATE_ASSERTION,
    // // CreateCharacterSet = c.SQL_CREATE_CHARACTER_SET,
    // // CreateCollation = c.SQL_CREATE_COLLATION,
    // // CreateDomain = c.SQL_CREATE_DOMAIN,
    // // CreateSchema = c.SQL_CREATE_SCHEMA,
    // // CreateTable = c.SQL_CREATE_TABLE,
    // // CreateTranslation = c.SQL_CREATE_TRANSLATION,
    // // CursorCommitBehavior = c.SQL_CURSOR_COMMIT_BEHAVIOR,
    // // CursorRollbackBehavior = c.SQL_CURSOR_ROLLBACK_BEHAVIOR,
    // // CursorSensitivity = c.SQL_CURSOR_SENSITIVITY,
    //
    // const data_source_name_info = try con.getInfo(.DataSourceName);
    // try expectEqual(
    //     .{'Y'},
    //     data_source_name_info.DataSourceName,
    // );
    //
    // const driver_name_info = try con.getInfo(.DriverName);
    // try expectEqual(
    //     .{'Y'},
    //     driver_name_info.DriverName,
    // );
    //
    // const driver_odbc_ver_info = try con.getInfo(.DriverOdbcVer);
    // try expectEqual(
    //     .{'Y'},
    //     driver_odbc_ver_info.DriverOdbcVer,
    // );
    //
    // const driver_ver_info = try con.getInfo(.DriverVer);
    // try expectEqual(
    //     .{'Y'},
    //     driver_ver_info.DriverVer,
    // );
}
