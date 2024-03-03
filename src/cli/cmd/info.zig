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
    try stdout.print("SQLAccessibleProcedures={}\n", .{info_type.tag().AccessibleProcedures});

    info_type = try con.getInfo(.AccessibleTables);
    try stdout.print("SQLAccessibleTable={}\n", .{info_type.tag().AccessibleTables});

    info_type = try con.getInfo(.ActiveEnvironments);
    try stdout.print("SQLActiveEnvironments={}\n", .{info_type.tag().ActiveEnvironments});

    info_type = try con.getInfo(.AggregateFunctions);
    try stdout.print("SQLAggregateFunctions={}\n", .{info_type.tag().AggregateFunctions});

    info_type = try con.getInfo(.AlterDomain);
    try stdout.print("SQLAlterDomain={}\n", .{info_type.tag().AlterDomain});

    info_type = try con.getInfo(.AlterTable);
    try stdout.print("SQLAlterTable={}\n", .{info_type.tag().AlterTable});

    info_type = try con.getInfo(.BatchRowCount);
    try stdout.print("SQLBatchRowCount={}\n", .{info_type.tag().BatchRowCount});

    info_type = try con.getInfo(.BatchSupport);
    try stdout.print("SQLBatchSupport={}\n", .{info_type.tag().BatchSupport});

    info_type = try con.getInfo(.BookmarkPersistence);
    try stdout.print("SQLBookmarkPersistence={}\n", .{info_type.tag().BookmarkPersistence});

    info_type = try con.getInfo(.CatalogLocation);
    try stdout.print("SQLCatalogLocation={}\n", .{info_type.tag().CatalogLocation});

    info_type = try con.getInfo(.CatalogName);
    try stdout.print("SQLCatalogName={}\n", .{info_type.tag().CatalogName});

    info_type = try con.getInfo(.CatalogTerm);
    try stdout.print("SQLCatalogTerm={s}\n", .{info_type.tag().CatalogTerm});

    // info_type = try con.getInfo(.ConcatNullBehavior);
    // try stdout.print("SQLConcatNullBehavior={}\n", .{info_type.tag().ConcatNullBehavior});

    info_type = try con.getInfo(.ConvertBigint);
    try stdout.print("SQLConvertBigint={}\n", .{info_type.tag().ConvertBigint});

    info_type = try con.getInfo(.ConvertBinary);
    try stdout.print("SQLConvertBinary={}\n", .{info_type.tag().ConvertBinary});

    info_type = try con.getInfo(.ConvertBit);
    try stdout.print("SQLConvertBit={}\n", .{info_type.tag().ConvertBit});

    info_type = try con.getInfo(.ConvertChar);
    try stdout.print("SQLConvertChar={}\n", .{info_type.tag().ConvertChar});

    info_type = try con.getInfo(.ConvertDate);
    try stdout.print("SQLConvertDate={}\n", .{info_type.tag().ConvertDate});

    info_type = try con.getInfo(.ConvertDecimal);
    try stdout.print("SQLConvertDecimal={}\n", .{info_type.tag().ConvertDecimal});

    info_type = try con.getInfo(.ConvertDouble);
    try stdout.print("SQLConvertDouble={}\n", .{info_type.tag().ConvertDouble});

    info_type = try con.getInfo(.ConvertFloat);
    try stdout.print("SQLConvertFloat={}\n", .{info_type.tag().ConvertFloat});

    info_type = try con.getInfo(.ConvertInteger);
    try stdout.print("SQLConvertInteger={}\n", .{info_type.tag().ConvertInteger});

    info_type = try con.getInfo(.ConvertIntervalDayTime);
    try stdout.print("SQLConvertIntervalDayTime={}\n", .{info_type.tag().ConvertIntervalDayTime});

    info_type = try con.getInfo(.ConvertIntervalYearMonth);
    try stdout.print("SQLConvertIntervalYearMonth={}\n", .{info_type.tag().ConvertIntervalYearMonth});

    info_type = try con.getInfo(.ConvertLongvarbinary);
    try stdout.print("SQLConvertLongvarbinary={}\n", .{info_type.tag().ConvertLongvarbinary});

    info_type = try con.getInfo(.ConvertLongvarchar);
    try stdout.print("SQLConvertLongvarchar={}\n", .{info_type.tag().ConvertLongvarchar});

    info_type = try con.getInfo(.ConvertNumeric);
    try stdout.print("SQLConvertNumeric={}\n", .{info_type.tag().ConvertNumeric});

    info_type = try con.getInfo(.ConvertReal);
    try stdout.print("SQLConvertReal={}\n", .{info_type.tag().ConvertReal});

    info_type = try con.getInfo(.ConvertSmallint);
    try stdout.print("SQLConvertSmallint={}\n", .{info_type.tag().ConvertSmallint});

    info_type = try con.getInfo(.ConvertTime);
    try stdout.print("SQLConvertTime={}\n", .{info_type.tag().ConvertTime});

    info_type = try con.getInfo(.ConvertTimestamp);
    try stdout.print("SQLConvertTimestamp={}\n", .{info_type.tag().ConvertTimestamp});

    info_type = try con.getInfo(.ConvertTinyint);
    try stdout.print("SQLConvertTinyint={}\n", .{info_type.tag().ConvertTinyint});

    info_type = try con.getInfo(.ConvertVarbinary);
    try stdout.print("SQLConvertVarbinary={}\n", .{info_type.tag().ConvertVarbinary});

    info_type = try con.getInfo(.ConvertVarchar);
    try stdout.print("SQLConvertVarchar={}\n", .{info_type.tag().ConvertVarchar});

    info_type = try con.getInfo(.ConvertFunctions);
    try stdout.print("SQLConvertFunctions={}\n", .{info_type.tag().ConvertFunctions});

    try bw.flush();
}
