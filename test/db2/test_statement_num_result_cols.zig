const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const types = zodbc.odbc.types;

test "numResultCols/0 returns the number of columns for a prepared statement" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try env_con.con.connectWithString(con_str);

    const stmt = try zodbc.Statement.init(env_con.con);
    defer stmt.deinit();
    try stmt.prepare("SELECT * FROM SYSIBM.SYSTABLES");

    const num_result_cols = try stmt.numResultCols();
    try testing.expect(num_result_cols > 0);
}

test "numResultCols/0 returns an error when called out of sequence order" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try env_con.con.connectWithString(con_str);

    const stmt = try zodbc.Statement.init(env_con.con);
    defer stmt.deinit();

    const col_desc = try types.ColDescription.init(allocator);
    defer allocator.destroy(col_desc);
    // @note: Column index 0 is a bookmark, Db2 doesn't support bookmarks
    try testing.expectError(
        err.NumResultColsError.Error,
        stmt.numResultCols(),
    );
}
