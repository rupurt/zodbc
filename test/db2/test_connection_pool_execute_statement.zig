const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const odbc = zodbc.odbc;

test "can execute a prepared statement and fetch a cursor" {
    const env = try zodbc.Environment.init(allocator, .v3_80);
    defer {
        _ = env.deinit();
        allocator.destroy(env);
    }

    const con_pool = try zodbc.ConnectionPool.init(allocator, env, .{});
    defer {
        _ = con_pool.deinit();
        allocator.destroy(con_pool);
    }
    // const con_str = try std.fmt.allocPrint(
    //     allocator,
    //     "Driver={s};Hostname={s};Database={s};Port={d};Uid={s};Pwd={s};",
    //     .{
    //         std.os.getenv("DB2_DRIVER") orelse "",
    //         "localhost",
    //         "testdb",
    //         50_000,
    //         "db2inst1",
    //         "password",
    //     },
    // );
    // defer allocator.free(con_str);
    // try con.connectWithString(con_str);
    //
    // const stmt = try zodbc.Statement.init(allocator, con);
    // defer {
    //     _ = stmt.deinit();
    //     allocator.destroy(stmt);
    // }
    // try stmt.prepare("SELECT * FROM SYSIBM.SYSTABLES");
}
