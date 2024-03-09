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

    // info_type = try con.getInfo(.CatalogNameSeparator);
    // try expectEqualSlices(u8, "."[0..1], info_type.tag().CatalogNameSeparator);

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

    info_type = try con.getInfo(.CorrelationName);
    try expectEqual(
        InfoTypeValue.Tag.CorrelationName.Any,
        info_type.tag().CorrelationName,
    );

    info_type = try con.getInfo(.CreateAssertion);
    try expectEqual(
        InfoTypeValue.Tag.CreateAssertionMask{ .data = 0 },
        info_type.tag().CreateAssertion,
    );

    info_type = try con.getInfo(.CreateCharacterSet);
    try expectEqual(
        InfoTypeValue.Tag.CreateCharacterSetMask{ .data = 0 },
        info_type.tag().CreateCharacterSet,
    );

    info_type = try con.getInfo(.CreateCollation);
    try expectEqual(
        InfoTypeValue.Tag.CreateCollationMask{ .data = 0 },
        info_type.tag().CreateCollation,
    );

    info_type = try con.getInfo(.CreateDomain);
    try expectEqual(
        InfoTypeValue.Tag.CreateDomainMask{ .data = 0 },
        info_type.tag().CreateDomain,
    );

    info_type = try con.getInfo(.CreateSchema);
    try expectEqual(
        InfoTypeValue.Tag.CreateSchemaMask{ .data = 3 },
        info_type.tag().CreateSchema,
    );

    info_type = try con.getInfo(.CreateTable);
    try expectEqual(
        InfoTypeValue.Tag.CreateTableMask{ .data = 9729 },
        info_type.tag().CreateTable,
    );

    info_type = try con.getInfo(.CreateTranslation);
    try expectEqual(
        InfoTypeValue.Tag.CreateTranslationMask{ .data = 0 },
        info_type.tag().CreateTranslation,
    );

    info_type = try con.getInfo(.CursorCommitBehavior);
    try expectEqual(
        InfoTypeValue.Tag.CursorBehavior.Preserve,
        info_type.tag().CursorCommitBehavior,
    );

    info_type = try con.getInfo(.CursorRollbackBehavior);
    try expectEqual(
        InfoTypeValue.Tag.CursorBehavior.Close,
        info_type.tag().CursorRollbackBehavior,
    );

    info_type = try con.getInfo(.CursorSensitivity);
    try expectEqual(
        InfoTypeValue.Tag.CursorSensitivity.Unspecified,
        info_type.tag().CursorSensitivity,
    );

    info_type = try con.getInfo(.DataSourceName);
    try expectEqualStrings("", info_type.tag().DataSourceName);

    info_type = try con.getInfo(.DataSourceReadOnly);
    try expectEqual(
        false,
        info_type.tag().DataSourceReadOnly,
    );

    info_type = try con.getInfo(.DatabaseName);
    try expectEqualSlices(u8, "TESTDB"[0..6], info_type.tag().DatabaseName);

    // TODO:
    // - what is this returning?
    // - don't understand "2/IL"
    // - seems like the string handling logic isn't correct yet
    // info_type = try con.getInfo(.DbmsName);
    // std.debug.print("DbmsName: {s}|\n", .{info_type.tag().DbmsName});
    // std.debug.print("DbmsName: {}|\n", .{info_type.tag()});
    // try expectEqualStrings("", info_type.tag().DbmsName);

    // info_type = try con.getInfo(.DbmsVer);
    // try expectEqualStrings("11.05.0900", info_type.tag().DbmsVer);

    info_type = try con.getInfo(.DdlIndex);
    try expectEqual(
        InfoTypeValue.Tag.DdlIndexMask{ .data = 3 },
        info_type.tag().DdlIndex,
    );

    info_type = try con.getInfo(.DefaultTxnIsolation);
    try expectEqual(
        InfoTypeValue.Tag.DefaultTxnIsolationMask{ .data = 2 },
        info_type.tag().DefaultTxnIsolation,
    );

    info_type = try con.getInfo(.DescribeParameter);
    try expectEqual(true, info_type.tag().DescribeParameter);

    info_type = try con.getInfo(.DriverHdbc);
    try expect(info_type.tag().DriverHdbc > 0);

    info_type = try con.getInfo(.DriverHenv);
    try expect(info_type.tag().DriverHenv > 0);

    info_type = try con.getInfo(.DriverHlib);
    try expect(info_type.tag().DriverHlib > 0);

    // TODO:
    // - seems to require a statement on the connection
    // info_type = try con.getInfo(.DriverHstmt);
    // try expect(info_type.tag().DriverHstmt > 0);

    // TODO:
    // - seems like the string handling logic isn't correct yet
    // info_type = try con.getInfo(.DriverName);
    // try expectEqualStrings("libdb2.a", info_type.tag().DriverName);

    // info_type = try con.getInfo(.DriverOdbcVer);
    // try expectEqualStrings("", info_type.tag().DriverOdbcVer);

    // info_type = try con.getInfo(.DriverVer);
    // try expectEqualStrings("11.05.0900", info_type.tag().DriverVer);

    info_type = try con.getInfo(.DropAssertion);
    try expectEqual(
        InfoTypeValue.Tag.DropAssertionMask{ .data = 0 },
        info_type.tag().DropAssertion,
    );

    info_type = try con.getInfo(.DropCharacterSet);
    try expectEqual(
        InfoTypeValue.Tag.DropCharacterSetMask{ .data = 0 },
        info_type.tag().DropCharacterSet,
    );

    info_type = try con.getInfo(.DropCollation);
    try expectEqual(
        InfoTypeValue.Tag.DropCollationMask{ .data = 0 },
        info_type.tag().DropCollation,
    );

    info_type = try con.getInfo(.DropDomain);
    try expectEqual(
        InfoTypeValue.Tag.DropDomainMask{ .data = 0 },
        info_type.tag().DropDomain,
    );

    info_type = try con.getInfo(.DropSchema);
    try expectEqual(
        InfoTypeValue.Tag.DropSchemaMask{ .data = 3 },
        info_type.tag().DropSchema,
    );

    info_type = try con.getInfo(.DropTable);
    try expectEqual(
        InfoTypeValue.Tag.DropTableMask{ .data = 1 },
        info_type.tag().DropTable,
    );

    info_type = try con.getInfo(.DropTranslation);
    try expectEqual(
        InfoTypeValue.Tag.DropTranslationMask{ .data = 0 },
        info_type.tag().DropTranslation,
    );

    info_type = try con.getInfo(.DropView);
    try expectEqual(
        InfoTypeValue.Tag.DropViewMask{ .data = 1 },
        info_type.tag().DropView,
    );

    info_type = try con.getInfo(.DynamicCursorAttributes1);
    try expectEqual(
        InfoTypeValue.Tag.DynamicCursorAttributes1Mask{ .data = 0 },
        info_type.tag().DynamicCursorAttributes1,
    );

    info_type = try con.getInfo(.DynamicCursorAttributes2);
    try expectEqual(
        InfoTypeValue.Tag.DynamicCursorAttributes2Mask{ .data = 0 },
        info_type.tag().DynamicCursorAttributes2,
    );

    info_type = try con.getInfo(.ExpressionsInOrderby);
    try expectEqual(true, info_type.tag().ExpressionsInOrderby);

    info_type = try con.getInfo(.FetchDirection);
    try expectEqual(
        InfoTypeValue.Tag.FetchDirectionMask{ .data = 255 },
        info_type.tag().FetchDirection,
    );

    info_type = try con.getInfo(.ForwardOnlyCursorAttributes1);
    try expectEqual(
        InfoTypeValue.Tag.ForwardOnlyCursorAttributes1Mask{ .data = 57345 },
        info_type.tag().ForwardOnlyCursorAttributes1,
    );

    info_type = try con.getInfo(.ForwardOnlyCursorAttributes2);
    try expectEqual(
        InfoTypeValue.Tag.ForwardOnlyCursorAttributes2Mask{ .data = 2179 },
        info_type.tag().ForwardOnlyCursorAttributes2,
    );

    info_type = try con.getInfo(.GetdataExtensions);
    try expectEqual(
        InfoTypeValue.Tag.GetdataExtensionsMask{ .data = 7 },
        info_type.tag().GetdataExtensions,
    );

    info_type = try con.getInfo(.GroupBy);
    try expectEqual(
        InfoTypeValue.Tag.GroupBy.GroupByContainsSelect,
        info_type.tag().GroupBy,
    );

    info_type = try con.getInfo(.IdentifierCase);
    try expectEqual(
        InfoTypeValue.Tag.IdentifierCase.Upper,
        info_type.tag().IdentifierCase,
    );

    // info_type = try con.getInfo(.IdentifierQuoteChar);
    // try expectEqualStrings("\"", info_type.tag().IdentifierQuoteChar);

    info_type = try con.getInfo(.InfoSchemaViews);
    try expectEqual(
        InfoTypeValue.Tag.InfoSchemaViewsMask{ .data = 0 },
        info_type.tag().InfoSchemaViews,
    );

    info_type = try con.getInfo(.InsertStatement);
    try expectEqual(
        InfoTypeValue.Tag.InsertStatementMask{ .data = 7 },
        info_type.tag().InsertStatement,
    );

    info_type = try con.getInfo(.Integrity);
    try expectEqual(true, info_type.tag().Integrity);

    info_type = try con.getInfo(.KeysetCursorAttributes1);
    try expectEqual(
        InfoTypeValue.Tag.KeysetCursorAttributes1Mask{ .data = 990799 },
        info_type.tag().KeysetCursorAttributes1,
    );

    info_type = try con.getInfo(.KeysetCursorAttributes2);
    try expectEqual(
        InfoTypeValue.Tag.KeysetCursorAttributes2Mask{ .data = 16395 },
        info_type.tag().KeysetCursorAttributes2,
    );

    info_type = try con.getInfo(.Keywords);
    try expectEqualStrings(
        "AFTER,ALIAS,ALLOW,APPLICATION,ASSOCIATE,ASUTIME,AUDIT,AUX,AUXILIARY,BEFORE,BINARY,BUFFERPOOL,CACHE,CALL,CALLED,CAPTURE,CARDINALITY,CCSID,CLUSTER,COLLECTION,COLLID,COMMENT,CONCAT,CONDITION,CONTAINS,COUNT_BIG,CURRENT_LC_CTYPE,CURRENT_PATH,CURRENT_SERVER,CURRENT_TIMEZONE,CYCLE,DATA,DATABASE,DAYS,DB2GENERAL,DB2GENRL,DB2SQL,DBINFO,DEFAULTS,DEFINITION,DETERMINISTIC,DISALLOW,DO,DSNHATTR,DSSIZE,DYNAMIC,EACH,EDITPROC,ELSEIF,ENCODING,END-EXEC1,ERASE,EXCLUDING,EXIT,FENCED,FIELDPROC,FILE,FINAL,FREE,FUNCTION,GENERAL,GENERATED,GRAPHIC,HANDLER,HOLD,HOURS,IF,INCLUDING,INCREMENT,INHERIT,INOUT,INTEGRITY,ISOBID,ITERATE,JAR,JAVA,LABEL,LC_CTYPE,LEAVE,LINKTYPE,LOCALE,LOCATOR,LOCATORS,LOCK,LOCKMAX,LOCKSIZE,LONG,LOOP,MAXVALUE,MICROSECOND,MICROSECONDS,MINUTES,MINVALUE,MODE,MODIFIES,MONTHS,NEW,NEW_TABLE,NOCACHE,NOCYCLE,NODENAME,NODENUMBER,NOMAXVALUE,NOMINVALUE,NOORDER,NULLS,NUMPARTS,OBID,OLD,OLD_TABLE,OPTIMIZATION,OPTIMIZE,OUT,OVERRIDING,PACKAGE,PARAMETER,PART,PARTITION,PATH,PIECESIZE,PLAN,PRIQTY,PROGRAM,PSID,QUERYNO,READS,RECOVERY,REFERENCING,RELEASE,RENAME,REPEAT,RESET,RESIGNAL,RESTART,RESULT,RESULT_SET_LOCATOR,RETURN,RETURNS,ROUTINE,ROW,RRN,RUN,SAVEPOINT,SCRATCHPAD,SECONDS,SECQTY,SECURITY,SENSITIVE,SIGNAL,SIMPLE,SOURCE,SPECIFIC,SQLID,STANDARD,START,STATIC,STAY,STOGROUP,STORES,STYLE,SUBPAGES,SYNONYM,SYSFUN,SYSIBM,SYSPROC,SYSTEM,TABLESPACE,TRIGGER,TYPE,UNDO,UNTIL,VALIDPROC,VARIABLE,VARIANT,VCAT,VOLUMES,WHILE,WLM,YEARS",
        info_type.tag().Keywords,
    );

    // info_type = try con.getInfo(.LikeEscapeClause);
    // try expectEqualStrings("", info_type.tag().LikeEscapeClause);

    info_type = try con.getInfo(.LockTypes);
    try expectEqual(
        InfoTypeValue.Tag.LockTypesMask{ .data = 0 },
        info_type.tag().LockTypes,
    );

    info_type = try con.getInfo(.MaxAsyncConcurrentStatements);
    try expectEqual(1, info_type.tag().MaxAsyncConcurrentStatements);

    info_type = try con.getInfo(.MaxBinaryLiteralLen);
    try expectEqual(4000, info_type.tag().MaxBinaryLiteralLen);

    info_type = try con.getInfo(.MaxCatalogNameLen);
    try expectEqual(0, info_type.tag().MaxCatalogNameLen);

    info_type = try con.getInfo(.MaxCharLiteralLen);
    try expectEqual(32672, info_type.tag().MaxCharLiteralLen);

    info_type = try con.getInfo(.MaxColumnNameLen);
    try expectEqual(128, info_type.tag().MaxColumnNameLen);

    info_type = try con.getInfo(.MaxColumnsInGroupBy);
    try expectEqual(1012, info_type.tag().MaxColumnsInGroupBy);

    info_type = try con.getInfo(.MaxColumnsInIndex);
    try expectEqual(16, info_type.tag().MaxColumnsInIndex);

    info_type = try con.getInfo(.MaxColumnsInOrderBy);
    try expectEqual(1012, info_type.tag().MaxColumnsInOrderBy);

    info_type = try con.getInfo(.MaxColumnsInSelect);
    try expectEqual(1012, info_type.tag().MaxColumnsInSelect);

    info_type = try con.getInfo(.MaxColumnsInTable);
    try expectEqual(1012, info_type.tag().MaxColumnsInTable);

    info_type = try con.getInfo(.MaxConcurrentActivities);
    try expectEqual(0, info_type.tag().MaxConcurrentActivities);

    info_type = try con.getInfo(.MaxCursorNameLen);
    try expectEqual(128, info_type.tag().MaxCursorNameLen);

    info_type = try con.getInfo(.MaxDriverConnections);
    try expectEqual(0, info_type.tag().MaxDriverConnections);

    info_type = try con.getInfo(.MaxIdentifierLen);
    try expectEqual(128, info_type.tag().MaxIdentifierLen);

    info_type = try con.getInfo(.MaxIndexSize);
    try expectEqual(1024, info_type.tag().MaxIndexSize);

    info_type = try con.getInfo(.MaxProcedureNameLen);
    try expectEqual(128, info_type.tag().MaxProcedureNameLen);

    info_type = try con.getInfo(.MaxRowSize);
    try expectEqual(32677, info_type.tag().MaxRowSize);

    info_type = try con.getInfo(.MaxRowSizeIncludesLong);
    try expectEqual(false, info_type.tag().MaxRowSizeIncludesLong);

    info_type = try con.getInfo(.MaxSchemaNameLen);
    try expectEqual(128, info_type.tag().MaxSchemaNameLen);

    info_type = try con.getInfo(.MaxStatementLen);
    try expectEqual(2097152, info_type.tag().MaxStatementLen);

    info_type = try con.getInfo(.MaxTableNameLen);
    try expectEqual(128, info_type.tag().MaxTableNameLen);

    info_type = try con.getInfo(.MaxTablesInSelect);
    try expectEqual(0, info_type.tag().MaxTablesInSelect);

    info_type = try con.getInfo(.MaxUserNameLen);
    try expectEqual(8, info_type.tag().MaxUserNameLen);

    info_type = try con.getInfo(.MultResultSets);
    try expectEqual(true, info_type.tag().MultResultSets);

    info_type = try con.getInfo(.MultipleActiveTxn);
    try expectEqual(true, info_type.tag().MultipleActiveTxn);

    info_type = try con.getInfo(.NeedLongDataLen);
    try expectEqual(false, info_type.tag().NeedLongDataLen);

    info_type = try con.getInfo(.NonNullableColumns);
    try expectEqual(
        InfoTypeValue.Tag.NonNullableColumns.NonNull,
        info_type.tag().NonNullableColumns,
    );

    info_type = try con.getInfo(.NullCollation);
    try expectEqual(
        InfoTypeValue.Tag.NullCollation.High,
        info_type.tag().NullCollation,
    );

    info_type = try con.getInfo(.NumericFunctions);
    try expectEqual(
        InfoTypeValue.Tag.NumericFunctionsMask{ .data = 16777215 },
        info_type.tag().NumericFunctions,
    );

    info_type = try con.getInfo(.OdbcApiConformance);
    try expectEqual(
        InfoTypeValue.Tag.OdbcApiConformance.Level2,
        info_type.tag().OdbcApiConformance,
    );

    info_type = try con.getInfo(.OdbcSagCliConformance);
    try expectEqual(
        InfoTypeValue.Tag.OdbcSagCliConformance.Compliant,
        info_type.tag().OdbcSagCliConformance,
    );

    info_type = try con.getInfo(.OdbcSqlConformance);
    try expectEqual(
        InfoTypeValue.Tag.OdbcSqlConformance.Extended,
        info_type.tag().OdbcSqlConformance,
    );

    // info_type = try con.getInfo(.OdbcVer);
    // try expectEqualStrings("v", info_type.tag().OdbcVer);

    info_type = try con.getInfo(.OjCapabilities);
    try expectEqual(
        InfoTypeValue.Tag.OjCapabilitiesMask{ .data = 127 },
        info_type.tag().OjCapabilities,
    );

    info_type = try con.getInfo(.OrderByColumnsInSelect);
    try expectEqual(false, info_type.tag().OrderByColumnsInSelect);

    info_type = try con.getInfo(.OuterJoins);
    try expectEqual(true, info_type.tag().OuterJoins);

    // info_type = try con.getInfo(.OwnerTerm);
    // try expectEqualStrings("todo", info_type.tag().OwnerTerm);

    info_type = try con.getInfo(.ParamArrayRowCounts);
    try expectEqual(
        InfoTypeValue.Tag.ParamArrayRowCounts.NoBatch,
        info_type.tag().ParamArrayRowCounts,
    );

    info_type = try con.getInfo(.ParamArraySelects);
    try expectEqual(
        InfoTypeValue.Tag.ParamArraySelects.Batch,
        info_type.tag().ParamArraySelects,
    );

    info_type = try con.getInfo(.PosOperations);
    try expectEqual(
        InfoTypeValue.Tag.PosOperationsMask{ .data = 31 },
        info_type.tag().PosOperations,
    );

    info_type = try con.getInfo(.PositionedStatements);
    try expectEqual(
        InfoTypeValue.Tag.PositionedStatementsMask{ .data = 7 },
        info_type.tag().PositionedStatements,
    );

    // info_type = try con.getInfo(.ProcedureTerm);
    // try expectEqualStrings("", info_type.tag().ProcedureTerm);

    info_type = try con.getInfo(.Procedures);
    try expectEqual(true, info_type.tag().Procedures);

    info_type = try con.getInfo(.QuotedIdentifierCase);
    try expectEqual(
        InfoTypeValue.Tag.QuotedIdentifierCase.Sensitive,
        info_type.tag().QuotedIdentifierCase,
    );

    info_type = try con.getInfo(.RowUpdates);
    try expectEqual(false, info_type.tag().RowUpdates);

    info_type = try con.getInfo(.SchemaUsage);
    try expectEqual(
        InfoTypeValue.Tag.SchemaUsageMask{ .data = 31 },
        info_type.tag().SchemaUsage,
    );

    info_type = try con.getInfo(.ScrollConcurrency);
    try expectEqual(
        InfoTypeValue.Tag.ScrollConcurrencyMask{ .data = 11 },
        info_type.tag().ScrollConcurrency,
    );

    info_type = try con.getInfo(.ScrollOptions);
    try expectEqual(
        InfoTypeValue.Tag.ScrollOptionsMask{ .data = 19 },
        info_type.tag().ScrollOptions,
    );

    info_type = try con.getInfo(.SearchPatternEscape);
    try expectEqualStrings("\\", info_type.tag().SearchPatternEscape);

    info_type = try con.getInfo(.ServerName);
    try expectEqualStrings("DB2", info_type.tag().ServerName);

    // info_type = try con.getInfo(.SpecialCharacters);
    // try expectEqualStrings("", info_type.tag().SpecialCharacters);

    info_type = try con.getInfo(.Sql92Predicates);
    try expectEqual(
        InfoTypeValue.Tag.Sql92PredicatesMask{ .data = 15879 },
        info_type.tag().Sql92Predicates,
    );

    info_type = try con.getInfo(.Sql92ValueExpressions);
    try expectEqual(
        InfoTypeValue.Tag.Sql92ValueExpressionsMask{ .data = 15 },
        info_type.tag().Sql92ValueExpressions,
    );

    info_type = try con.getInfo(.StaticCursorAttributes1);
    try expectEqual(
        InfoTypeValue.Tag.StaticCursorAttributes1Mask{ .data = 15 },
        info_type.tag().StaticCursorAttributes1,
    );

    info_type = try con.getInfo(.StaticCursorAttributes2);
    try expectEqual(
        InfoTypeValue.Tag.StaticCursorAttributes2Mask{ .data = 131 },
        info_type.tag().StaticCursorAttributes2,
    );

    info_type = try con.getInfo(.StaticSensitivity);
    try expectEqual(
        InfoTypeValue.Tag.StaticSensitivityMask{ .data = 0 },
        info_type.tag().StaticSensitivity,
    );

    info_type = try con.getInfo(.StringFunctions);
    try expectEqual(
        InfoTypeValue.Tag.StringFunctionsMask{ .data = 524287 },
        info_type.tag().StringFunctions,
    );

    info_type = try con.getInfo(.Subqueries);
    try expectEqual(
        InfoTypeValue.Tag.SubqueriesMask{ .data = 31 },
        info_type.tag().Subqueries,
    );

    info_type = try con.getInfo(.SystemFunctions);
    try expectEqual(
        InfoTypeValue.Tag.SystemFunctionsMask{ .data = 7 },
        info_type.tag().SystemFunctions,
    );

    info_type = try con.getInfo(.TableTerm);
    try expectEqualStrings("table", info_type.tag().TableTerm);

    info_type = try con.getInfo(.TimedateAddIntervals);
    try expectEqual(
        InfoTypeValue.Tag.TimedateAddIntervalsMask{ .data = 511 },
        info_type.tag().TimedateAddIntervals,
    );

    info_type = try con.getInfo(.TimedateDiffIntervals);
    try expectEqual(
        InfoTypeValue.Tag.TimedateDiffIntervalsMask{ .data = 511 },
        info_type.tag().TimedateDiffIntervals,
    );

    info_type = try con.getInfo(.TimedateFunctions);
    try expectEqual(
        InfoTypeValue.Tag.TimedateFunctionsMask{ .data = 131071 },
        info_type.tag().TimedateFunctions,
    );

    info_type = try con.getInfo(.TxnCapable);
    try expectEqual(
        InfoTypeValue.Tag.TxnCapable.All,
        info_type.tag().TxnCapable,
    );

    info_type = try con.getInfo(.TxnIsolationOption);
    try expectEqual(
        InfoTypeValue.Tag.TxnIsolationOptionMask{ .data = 15 },
        info_type.tag().TxnIsolationOption,
    );

    info_type = try con.getInfo(.Union);
    try expectEqual(
        InfoTypeValue.Tag.UnionMask{ .data = 3 },
        info_type.tag().Union,
    );

    info_type = try con.getInfo(.UserName);
    try expectEqualStrings("db2inst1", info_type.tag().UserName);

    // info_type = try con.getInfo(.XopenCliYear);
    // try expectEqualStrings("", info_type.tag().XopenCliYear);
}
