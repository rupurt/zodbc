const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const types = zodbc.odbc.types;

test ".getStmtAttr/1 todo..." {
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

    // var concurrency_value: isize = 0;
    // try stmt.getStmtAttr(.CONCURRENCY, &concurrency_value, 0, null);
    // try expectEqual(1, concurrency_value);
    //
    // var max_length_value: isize = 0;
    // try stmt.getStmtAttr(.MAX_LENGTH, &max_length_value, 0, null);
    // try expectEqual(0, max_length_value);
}
