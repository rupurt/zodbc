const std = @import("std");
const zig_cli = @import("zig-cli");
const zodbc = @import("zodbc");

var dsn = zig_cli.Option{
    .long_name = "dsn",
    .short_alias = 'd',
    .help = "Data source name connection string",
    .required = true,
    .value_ref = zig_cli.mkRef(&config.dsn),
};
pub var cmd = zig_cli.Command{
    .name = "con",
    .options = &.{
        &dsn,
    },
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};
var config = struct {
    dsn: []const u8 = undefined,
}{};

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

    var odbc_buf: [256]u8 = undefined;

    const connection_dead_value = try con.getConnectAttr(allocator, .ConnectionDead, odbc_buf[0..]);
    defer connection_dead_value.deinit(allocator);
    try stdout.print("SQL_ATTR_CONNECTION_DEAD={}\n", .{connection_dead_value.ConnectionDead});

    // const driver_threading_value = try con.getConnectAttr(allocator, .DriverThreading, odbc_buf[0..]);
    // defer driver_threading_value.deinit(allocator);
    // try stdout.print("SQL_ATTR_DRIVER_THREADING={}\n", .{driver_threading_value.DriverThreading});

    const access_mode_value = try con.getConnectAttr(allocator, .AccessMode, odbc_buf[0..]);
    defer access_mode_value.deinit(allocator);
    try stdout.print("SQL_ATTR_ACCESS_MODE={}\n", .{access_mode_value.AccessMode});

    const autocommit_value = try con.getConnectAttr(allocator, .Autocommit, odbc_buf[0..]);
    defer autocommit_value.deinit(allocator);
    try stdout.print("SQL_ATTR_AUTO_COMMIT={}\n", .{autocommit_value.Autocommit});

    const connection_timeout_value = try con.getConnectAttr(allocator, .ConnectionTimeout, odbc_buf[0..]);
    defer connection_timeout_value.deinit(allocator);
    try stdout.print("SQL_ATTR_CONNECTION_TIMEOUT={}\n", .{connection_timeout_value.ConnectionTimeout});

    // const disconnect_behavior_value = try con.getConnectAttr(allocator, .DisconnectBehavior, odbc_buf[0..]);
    // defer disconnect_behavior_value.deinit(allocator);
    // try stdout.print("SQL_ATTR_DISCONNECT_BEHAVIOR={}\n", .{disconnect_behavior_value.DisconnectBehavior});

    // const enlist_in_dtc_value = try con.getConnectAttr(allocator, .EnlistInDtc, odbc_buf[0..]);
    // defer enlist_in_dtc_value.deinit(allocator);
    // try stdout.print("SQL_ATTR_ENLIST_IN_DTC={}\n", .{enlist_in_dtc_value.EnlistInDtc});

    const login_timeout_value = try con.getConnectAttr(allocator, .LoginTimeout, odbc_buf[0..]);
    defer login_timeout_value.deinit(allocator);
    try stdout.print("SQL_ATTR_LOGIN_TIMEOUT={}\n", .{login_timeout_value.LoginTimeout});

    const odbc_cursors_value = try con.getConnectAttr(allocator, .OdbcCursors, odbc_buf[0..]);
    defer odbc_cursors_value.deinit(allocator);
    try stdout.print("SQL_ATTR_ODBC_CURSORS={}\n", .{odbc_cursors_value.OdbcCursors});

    // const packet_size_value = try con.getConnectAttr(allocator, .PacketSize, odbc_buf[0..]);
    // defer packet_size_value.deinit(allocator);
    // try stdout.print("SQL_ATTR_PACKET_SIZE={}\n", .{packet_size_value.PacketSize});

    const trace_value = try con.getConnectAttr(allocator, .Trace, odbc_buf[0..]);
    defer trace_value.deinit(allocator);
    try stdout.print("SQL_ATTR_TRACE={}\n", .{trace_value.Trace});

    const txn_isolation_value = try con.getConnectAttr(allocator, .TxnIsolation, odbc_buf[0..]);
    defer txn_isolation_value.deinit(allocator);
    try stdout.print("SQL_ATTR_TXN_ISOLATION={}\n", .{txn_isolation_value.TxnIsolation});

    const ansi_app_value = try con.getConnectAttr(allocator, .AnsiApp, odbc_buf[0..]);
    defer ansi_app_value.deinit(allocator);
    try stdout.print("SQL_ANSI_APP={}\n", .{ansi_app_value.AnsiApp});

    const async_enable_value = try con.getConnectAttr(allocator, .AsyncEnable, odbc_buf[0..]);
    defer async_enable_value.deinit(allocator);
    try stdout.print("SQL_ASYNC_ENABLE={}\n", .{async_enable_value.AsyncEnable});

    // const reset_connection_value = try con.getConnectAttr(allocator, .ResetConnection, odbc_buf[0..]);
    // defer reset_connection_value.deinit(allocator);
    // try stdout.print("SQL_RESET_CONNECTION={}\n", .{reset_connection_value.ResetConnection});

    const async_dbc_functions_enable_value = try con.getConnectAttr(allocator, .AsyncDbcFunctionsEnable, odbc_buf[0..]);
    defer async_dbc_functions_enable_value.deinit(allocator);
    try stdout.print("SQL_ATTR_ASYNC_DBC_FUNCTIONS_ENABLE={}\n", .{async_dbc_functions_enable_value.AsyncDbcFunctionsEnable});

    const fet_buf_size_value = try con.getConnectAttr(allocator, .FetBufSize, odbc_buf[0..]);
    defer fet_buf_size_value.deinit(allocator);
    try stdout.print("SQL_ATTR_FET_BUF_SIZE={}\n", .{fet_buf_size_value.FetBufSize});

    try bw.flush();
}
