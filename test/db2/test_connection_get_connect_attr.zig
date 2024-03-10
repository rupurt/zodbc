const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.ConnectionAttributeValue;

test "getConnectAttr/3 can retrieve the current item values for disconnected connections" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const access_mode_value = try con.getConnectAttr(allocator, .AccessMode, odbc_buf[0..]);
    defer access_mode_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AccessMode.ReadWrite,
        access_mode_value.AccessMode,
    );

    @memset(odbc_buf[0..], 0);
    const autocommit_value = try con.getConnectAttr(allocator, .Autocommit, odbc_buf[0..]);
    defer autocommit_value.deinit(allocator);
    try expectEqual(
        AttributeValue.Autocommit.On,
        autocommit_value.Autocommit,
    );

    @memset(odbc_buf[0..], 0);
    const odbc_cursors_value = try con.getConnectAttr(allocator, .OdbcCursors, odbc_buf[0..]);
    defer odbc_cursors_value.deinit(allocator);
    try expectEqual(
        AttributeValue.OdbcCursors.UseDriver,
        odbc_cursors_value.OdbcCursors,
    );

    @memset(odbc_buf[0..], 0);
    const trace_value = try con.getConnectAttr(allocator, .Trace, odbc_buf[0..]);
    defer trace_value.deinit(allocator);
    try expectEqual(
        AttributeValue.Trace.Off,
        trace_value.Trace,
    );
}

test "getConnectAttr/3 can retrieve connected items" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const connection_dead_value = try con.getConnectAttr(allocator, .ConnectionDead, odbc_buf[0..]);
    defer connection_dead_value.deinit(allocator);
    try expectEqual(
        AttributeValue.ConnectionDead.False,
        connection_dead_value.ConnectionDead,
    );

    // @memset(odbc_buf[0..], 0);
    // const driver_threading_value = try con.getConnectAttr(allocator, .DriverThreading, odbc_buf[0..]);
    // defer driver_threading_value.deinit(allocator);
    // try expectEqual(1, driver_threading_value.DriverThreading);

    @memset(odbc_buf[0..], 0);
    const connection_timeout_value = try con.getConnectAttr(allocator, .ConnectionTimeout, odbc_buf[0..]);
    defer connection_timeout_value.deinit(allocator);
    try expectEqual(0, connection_timeout_value.ConnectionTimeout);

    // TODO:
    // - does this option require driver level connection pooling to be enabled?
    // @memset(odbc_buf[0..], 0);
    // const disconnect_behavior_value = try con.getConnectAttr(allocator, .DisconnectBehavior, odbc_buf[0..]);
    // defer disconnect_behavior_value.deinit(allocator);
    // try expectEqual(
    //     AttributeValue.DisconnectBehavior.ReturnToPool,
    //     disconnect_behavior_value.DisconnectBehavior,
    // );

    // TODO:
    // - figure out why this gets option out of range erro
    // @memset(odbc_buf[0..], 0);
    // const enlist_in_dtc_value = try con.getConnectAttr(allocator, .EnlistInDtc, odbc_buf[0..]);
    // defer enlist_in_dtc_value.deinit(allocator);
    // try expectEqual(
    //     AttributeValue.EnlistInDtc.EnlistExpensive,
    //     enlist_in_dtc_value.EnlistInDtc,
    // );

    @memset(odbc_buf[0..], 0);
    const login_timeout_value = try con.getConnectAttr(allocator, .LoginTimeout, odbc_buf[0..]);
    defer login_timeout_value.deinit(allocator);
    try expectEqual(0, login_timeout_value.LoginTimeout);

    @memset(odbc_buf[0..], 0);
    const txn_isolation_value = try con.getConnectAttr(allocator, .TxnIsolation, odbc_buf[0..]);
    defer txn_isolation_value.deinit(allocator);
    try expectEqual(
        AttributeValue.TxnIsolation.ReadCommitted,
        txn_isolation_value.TxnIsolation,
    );

    @memset(odbc_buf[0..], 0);
    const ansi_app_value = try con.getConnectAttr(allocator, .AnsiApp, odbc_buf[0..]);
    defer ansi_app_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AnsiApp.True,
        ansi_app_value.AnsiApp,
    );

    @memset(odbc_buf[0..], 0);
    const async_enable_value = try con.getConnectAttr(allocator, .AsyncEnable, odbc_buf[0..]);
    defer async_enable_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AsyncEnable.Off,
        async_enable_value.AsyncEnable,
    );

    @memset(odbc_buf[0..], 0);
    const auto_ipd_value = try con.getConnectAttr(allocator, .AutoIpd, odbc_buf[0..]);
    defer auto_ipd_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AutoIpd.True,
        auto_ipd_value.AutoIpd,
    );

    // @memset(odbc_buf[0..], 0);
    // const reset_connection_value = try con.getConnectAttr(allocator, .ResetConnection, odbc_buf[0..]);
    // defer reset_connection_value.deinit(allocator);
    // try expectEqual(
    //     AttributeValue.ResetConnection.Yes,
    //     reset_connection_value.ResetConnection,
    // );

    @memset(odbc_buf[0..], 0);
    const async_dbc_functions_enable_value = try con.getConnectAttr(allocator, .AsyncDbcFunctionsEnable, odbc_buf[0..]);
    defer async_dbc_functions_enable_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AsyncDbcFunctionsEnable.Off,
        async_dbc_functions_enable_value.AsyncDbcFunctionsEnable,
    );
}

test "getConnectAttr/3 can retrieve Db2 specific items" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const fet_buf_size_value = try con.getConnectAttr(allocator, .FetBufSize, odbc_buf[0..]);
    defer fet_buf_size_value.deinit(allocator);
    try expectEqual(65536, fet_buf_size_value.FetBufSize);
}

// IBM Db2 doesn't support SQL_ATTR_PACKET_SIZE
//
// - https://www.ibm.com/docs/en/db2/10.1.0?topic=attributes-connection-list
test "getConnectAttr/3 returns a not implemented error for unsupported items" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    try expectError(
        err.SetConnectAttrError.Error,
        con.getConnectAttr(allocator, .PacketSize, odbc_buf[0..]),
    );
}
