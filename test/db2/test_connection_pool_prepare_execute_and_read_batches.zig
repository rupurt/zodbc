const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const odbc = zodbc.odbc;

test "can execute a prepared statement and fetch a cursor" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    var con_pool = try zodbc.ConnectionPool.init(
        allocator,
        env,
        .{ .n_workers = 2 },
    );
    defer con_pool.deinit();
    const con_str = try std.fmt.allocPrint(
        allocator,
        "Driver={s};Hostname={s};Database={s};Port={d};Uid={s};Pwd={s};",
        .{
            std.os.getenv("DB2_DRIVER") orelse "",
            "localhost",
            "testdb",
            50_000,
            "db2inst1",
            "password",
        },
    );
    defer allocator.free(con_str);
    try con_pool.connectWithString(con_str);

    try con_pool.prepare("SELECT * FROM SYSIBM.SYSTABLES");
    try con_pool.execute();

    // const reader = con_pool.batchReader();
    // var n_rows: usize = 0;
    // for (reader.items()) |rowset| {
    //     for (rowset.items()) |row| {
    //         n_rows += 1;
    //         try testing.expectEqualStrings("", row[0].name);
    //     }
    // }
    // try testing.expect(n_rows > 0);
}
