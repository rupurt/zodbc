const std = @import("std");
const zig_cli = @import("zig-cli");
const zodbc = @import("zodbc");

const AttributeValue = zodbc.odbc.attributes.ConnectionAttributeValue;

pub var cmd = zig_cli.Command{
    .name = "connection",
    .options = &.{},
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn run() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const env = try zodbc.Environment.init(.V3);
    defer env.deinit();

    const con = try zodbc.Connection.init(env);
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    var value: AttributeValue = undefined;

    value = try con.getConnectAttr(.AccessMode);
    try stdout.print("SQL_ATTR_ACCESS_MODE={}\n", .{value.AccessMode});

    value = try con.getConnectAttr(.Autocommit);
    try stdout.print("SQL_ATTR_AUTO_COMMIT={}\n", .{value.Autocommit});

    value = try con.getConnectAttr(.TxnIsolation);
    try stdout.print("SQL_ATTR_TXN_ISOLATION={}\n", .{value.TxnIsolation});

    value = try con.getConnectAttr(.ConnectionTimeout);
    try stdout.print("SQL_ATTR_CONNECTION_TIMEOUT={}\n", .{value.ConnectionTimeout});

    value = try con.getConnectAttr(.LoginTimeout);
    try stdout.print("SQL_ATTR_LOGIN_TIMEOUT={}\n", .{value.LoginTimeout});

    value = try con.getConnectAttr(.OdbcCursors);
    try stdout.print("SQL_ATTR_ODBC_CURSORS={}\n", .{value.OdbcCursors});

    // value = try con.getConnectAttr(.PacketSize);
    // try stdout.print("SQL_ATTR_PACKET_SIZE={}\n", .{value.PacketSize});

    value = try con.getConnectAttr(.Trace);
    try stdout.print("SQL_ATTR_TRACE={}\n", .{value.Trace});

    value = try con.getConnectAttr(.AsyncEnable);
    try stdout.print("SQL_ATTR_ASYNC_ENABLE={}\n", .{value.AsyncEnable});

    try bw.flush();
}
