const std = @import("std");
const testing = std.testing;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const types = zodbc.odbc.types;

test ".columns/3 can return table columns" {
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
    try stmt.columns("%", "%", "SYSTABLES", "%");

    try stmt.fetch();
}
