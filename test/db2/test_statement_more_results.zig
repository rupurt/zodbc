const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const types = zodbc.odbc.types;

test ".moreResults/1 todo..." {
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

    // var col_desc = try types.ColDescription.init(allocator);
    // defer col_desc.deinit();
    // try stmt.describeCol(1, &col_desc);
    // var col = try types.Column.init(allocator, col_desc);
    // defer col.deinit();
    // try stmt.bindCol(1, &col);
    //
    // try stmt.fetch();
    //
    // const more_results = try stmt.moreResults();
    // std.debug.print("more_results: {any}\n", .{more_results});
    // // expectEqual(true, more_results);
}
