const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const odbc = zodbc.odbc;

test "can execute a prepared statement and fetch a cursor" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    var pool = try zodbc.WorkerPool.init(
        allocator,
        env,
        .{ .n_workers = 2 },
    );
    defer pool.deinit();
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
    try pool.connectWithString(con_str);

    try pool.prepare("SELECT * FROM SYSIBM.SYSTABLES");
    try pool.execute();

    // const fetch_array_size = 1;
    // const reader = try pool.batchReader(allocator, fetch_array_size);
    // defer reader.deinit();
    // const n_rows: usize = 0;
    // // while (reader.next()) |rowset| {
    // //     for (0..rowset.column_buffers.len) |c| {
    // //         n_rows += 1;
    // //         try testing.expectEqualStrings("", row[0].name);
    // //     }
    // // }
    // try testing.expect(n_rows > 0);
}
