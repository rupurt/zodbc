const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;
const expect = testing.expect;

const zodbc = @import("zodbc");
const types = zodbc.odbc.types;

test "can execute a prepared statement and fetch into a column binding" {
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
    try stmt.prepare("SELECT name FROM SYSIBM.SYSTABLES");

    var col_desc = try types.ColDescription.init(allocator);
    defer col_desc.deinit();
    try stmt.describeCol(1, &col_desc);

    var col = try types.Column.init(allocator, col_desc);
    defer col.deinit();
    try stmt.bindCol(1, &col);
    try stmt.execute();

    try stmt.fetch();
    try expect(col.buffer.len > 0);
    try expect(col.str_len_or_ind > 0);
}
