const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const types = zodbc.odbc.types;

test ".rowCount/1 returns -1 for an executed prepared SELECT statement" {
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
    try stmt.execute();

    const row_count = try stmt.rowCount();
    try expectEqual(-1, row_count);
}

test ".rowCount/1 returns -1 for a directly executed SELECT statement" {
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
    try stmt.execDirect("SELECT * FROM SYSIBM.SYSTABLES");

    const row_count = try stmt.rowCount();
    try expectEqual(-1, row_count);
}

test ".rowCount/1 returns an error when called out of sequence order" {
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

    try expectError(
        err.RowCountError.Error,
        stmt.rowCount(),
    );
}
