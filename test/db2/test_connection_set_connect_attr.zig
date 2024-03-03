const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const types = zodbc.odbc.types;

test ".setConnectAttr/1 todo..." {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try env_con.con.connectWithString(con_str);

    // var get_autocommit_value: i32 = undefined;
    // try env_con.con.getConnectAttr(.AUTOCOMMIT, &get_autocommit_value, 0, null);
    // try expectEqual(1, get_autocommit_value);
    // var set_autocommit_value = @intFromEnum(types.Autocommit.OFF);
    // var set_autocommit_value: c_ulong = 0;
    // try env_con.con.setConnectAttr(.AUTOCOMMIT, &set_autocommit_value);
    // try env_con.con.getConnectAttr(.AUTOCOMMIT, &get_autocommit_value, 0, null);
    // try expectEqual(0, get_autocommit_value);
}
