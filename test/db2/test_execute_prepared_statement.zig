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

    const con = try zodbc.Connection.init(allocator, env);
    defer {
        _ = con.deinit();
        allocator.destroy(con);
    }
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
    try con.connectWithString(con_str);

    const stmt = try zodbc.Statement.init(allocator, con);
    defer {
        _ = stmt.deinit();
        allocator.destroy(stmt);
    }
    try stmt.prepare("SELECT * FROM SYSIBM.SYSTABLES");

    const num_result_cols = try stmt.numResultCols();
    try testing.expect(num_result_cols > 0);

    const col_desc = try odbc.types.ColDescription.init(allocator);
    defer allocator.destroy(col_desc);
    // @note: Column index 0 is a bookmark, Db2 doesn't support bookmarks
    try stmt.describeCol(1, col_desc);
    try testing.expect(col_desc.name_buf_len > 0);
    try testing.expectEqualStrings(
        col_desc.name_buf[0..@intCast(col_desc.name_buf_len) :0],
        "NAME",
    );
    try testing.expect(col_desc.data_type >= 0);
    try testing.expect(col_desc.column_size > 0);
    try testing.expect(col_desc.decimal_digits >= 0);
    try testing.expect(col_desc.nullable >= 0);

    try stmt.execute();

    try stmt.fetchScroll(.NEXT, 0);

    // const rowset = stmt_reader.fetch();
    // try testing.expect(rowset.num_columns == 5);
    // try testing.expect(rowset.num_rows == 10);
}
