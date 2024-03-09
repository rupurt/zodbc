const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const types = zodbc.odbc.types;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.StatementAttributeValue;

test "setStmtAttr/1 can modify values for a single statement" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    const stmt = try zodbc.Statement.init(con);
    defer stmt.deinit();

    var odbc_buf: [256]u8 = undefined;

    try stmt.setStmtAttr(.{ .RowBindType = 2 });
    @memset(odbc_buf[0..], 0);
    const row_bind_type_value = try stmt.getStmtAttr2(allocator, .RowBindType, odbc_buf[0..]);
    defer row_bind_type_value.deinit(allocator);
    try expectEqual(2, row_bind_type_value.RowBindType);

    try stmt.setStmtAttr(.{ .Concurrency = .Lock });
    @memset(odbc_buf[0..], 0);
    const concurrency_value = try stmt.getStmtAttr2(allocator, .Concurrency, odbc_buf[0..]);
    defer concurrency_value.deinit(allocator);
    try expectEqual(
        AttributeValue.Concurrency.Lock,
        concurrency_value.Concurrency,
    );
}
