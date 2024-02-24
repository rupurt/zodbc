const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;
const expect = testing.expect;
const expectEqualStrings = testing.expectEqualStrings;
const expectError = testing.expectError;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const types = zodbc.odbc.types;

test ".describeCol/2 returns the column descriptions of a prepared statement" {
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

    var col_desc = try types.ColDescription.init(allocator);
    defer col_desc.deinit();
    // @note: Column index 0 is a bookmark, Db2 doesn't support bookmarks
    try stmt.describeCol(1, &col_desc);
    try expect(col_desc.name_buf_len > 0);
    try expectEqualStrings(
        col_desc.name_buf[0..@intCast(col_desc.name_buf_len) :0],
        "NAME",
    );
    try expect(col_desc.data_type >= 0);
    try expect(col_desc.column_size > 0);
    try expect(col_desc.decimal_digits >= 0);
    try expect(col_desc.nullable >= 0);
}

test ".describeCol/2 returns an error when called on the bookmark column index 0" {
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

    var col_desc = try types.ColDescription.init(allocator);
    defer col_desc.deinit();
    // @note: Column index 0 is a bookmark, Db2 doesn't support bookmarks
    try expectError(
        err.DescribeColError.Error,
        stmt.describeCol(0, &col_desc),
    );
}

test ".describeCol/2 returns an error when called out of sequence order" {
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

    var col_desc = try types.ColDescription.init(allocator);
    defer col_desc.deinit();
    try expectError(
        err.DescribeColError.Error,
        stmt.describeCol(1, &col_desc),
    );
}
