const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.ConnectionAttributeValue;

test "setConnectAttr/1 can modify disconnected values across all statements items" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;

    var odbc_buf: [256]u8 = undefined;

    try con.setConnectAttr(.{ .OdbcCursors = .IfNeeded });
    @memset(odbc_buf[0..], 0);
    const odbc_cursors_value = try con.getConnectAttr(allocator, .OdbcCursors, odbc_buf[0..]);
    defer odbc_cursors_value.deinit(allocator);
    try expectEqual(
        AttributeValue.OdbcCursors.IfNeeded,
        odbc_cursors_value.OdbcCursors,
    );

    try con.setConnectAttr(.{ .LoginTimeout = 1000 });
    @memset(odbc_buf[0..], 0);
    const login_timeout_value = try con.getConnectAttr(allocator, .LoginTimeout, odbc_buf[0..]);
    defer login_timeout_value.deinit(allocator);
    try expectEqual(
        1000,
        login_timeout_value.LoginTimeout,
    );
}

test "setConnectAttr/1 can modify connected values across all statements items" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try env_con.con.connectWithString(con_str);

    var odbc_buf: [256]u8 = undefined;

    try con.setConnectAttr(.{ .AccessMode = .ReadOnly });
    @memset(odbc_buf[0..], 0);
    const access_mode_value = try con.getConnectAttr(allocator, .AccessMode, odbc_buf[0..]);
    defer access_mode_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AccessMode.ReadOnly,
        access_mode_value.AccessMode,
    );

    try con.setConnectAttr(.{ .Autocommit = .Off });
    @memset(odbc_buf[0..], 0);
    const autocommit_value = try con.getConnectAttr(allocator, .Autocommit, odbc_buf[0..]);
    defer autocommit_value.deinit(allocator);
    try expectEqual(
        AttributeValue.Autocommit.Off,
        autocommit_value.Autocommit,
    );

    try con.setConnectAttr(.{ .Trace = .On });
    @memset(odbc_buf[0..], 0);
    const trace_value = try con.getConnectAttr(allocator, .Trace, odbc_buf[0..]);
    defer trace_value.deinit(allocator);
    try expectEqual(
        AttributeValue.Trace.On,
        trace_value.Trace,
    );

    // try con.setConnectAttr(.{ .DriverThreading = 1 });
    // @memset(odbc_buf[0..], 0);
    // const driver_threading_value = try con.getConnectAttr(allocator, .DriverThreading, odbc_buf[0..]);
    // defer driver_threading_value.deinit(allocator);
    // try expectEqual(
    //     1,
    //     driver_threading_value.DriverThreading,
    // );

    try con.setConnectAttr(.{ .ConnectionTimeout = 100 });
    @memset(odbc_buf[0..], 0);
    const connection_timeout_value = try con.getConnectAttr(allocator, .ConnectionTimeout, odbc_buf[0..]);
    defer connection_timeout_value.deinit(allocator);
    try expectEqual(100, connection_timeout_value.ConnectionTimeout);

    // try con.setConnectAttr(.{ .DisconnectBehavior = .Disconnect });
    // @memset(odbc_buf[0..], 0);
    // const disconnect_behavior_info = try con.getConnectAttr(allocator, .DisconnectBehavior, odbc_buf[0..]);
    // defer disconnect_behavior_info.deinit(allocator);
    // try expectEqual(
    //     AttributeValue.DisconnectBehavior.Disconnect,
    //     disconnect_behavior_info.DisconnectBehavior,
    // );

    // try con.setConnectAttr(.{ .EnlistInDtc = .UnenlistExpensive });
    // @memset(odbc_buf[0..], 0);
    // const enlist_in_dtc_value = try con.getConnectAttr(allocator, .EnlistInDtc, odbc_buf[0..]);
    // defer enlist_in_dtc_value.deinit(allocator);
    // try expectEqual(
    //     AttributeValue.EnlistInDtc.EnlistExpensive,
    //     enlist_in_dtc_value.EnlistInDtc,
    // );

    try con.setConnectAttr(.{ .TxnIsolation = .ReadUncommitted });
    @memset(odbc_buf[0..], 0);
    const txn_isolation_value = try con.getConnectAttr(allocator, .TxnIsolation, odbc_buf[0..]);
    defer txn_isolation_value.deinit(allocator);
    try expectEqual(
        AttributeValue.TxnIsolation.ReadUncommitted,
        txn_isolation_value.TxnIsolation,
    );

    try con.setConnectAttr(.{ .AnsiApp = .False });
    @memset(odbc_buf[0..], 0);
    const ansi_app_value = try con.getConnectAttr(allocator, .AnsiApp, odbc_buf[0..]);
    defer ansi_app_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AnsiApp.False,
        ansi_app_value.AnsiApp,
    );

    try con.setConnectAttr(.{ .AsyncEnable = .On });
    @memset(odbc_buf[0..], 0);
    const async_enable_value = try con.getConnectAttr(allocator, .AsyncEnable, odbc_buf[0..]);
    defer async_enable_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AsyncEnable.On,
        async_enable_value.AsyncEnable,
    );

    // try con.setConnectAttr(.{ .ResetConnection = .Yes });
    // @memset(odbc_buf[0..], 0);
    // const reset_connection_value = try con.getConnectAttr(allocator, .ResetConnection, odbc_buf[0..]);
    // defer reset_connection_value.deinit(allocator);
    // try expectEqual(
    //     AttributeValue.ResetConnection.Yes,
    //     reset_connection_value.ResetConnection,
    // );

    try con.setConnectAttr(.{ .AsyncDbcFunctionsEnable = .On });
    @memset(odbc_buf[0..], 0);
    const async_dbc_functions_enable_value = try con.getConnectAttr(allocator, .AsyncDbcFunctionsEnable, odbc_buf[0..]);
    defer async_dbc_functions_enable_value.deinit(allocator);
    try expectEqual(
        AttributeValue.AsyncDbcFunctionsEnable.On,
        async_dbc_functions_enable_value.AsyncDbcFunctionsEnable,
    );
}

test "setConnectAttr/1 can modify disconnected Db2 specific items" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;

    var odbc_buf: [256]u8 = undefined;

    try con.setConnectAttr(.{ .FetBufSize = 131072 });
    @memset(odbc_buf[0..], 0);
    const fet_buf_size_value = try con.getConnectAttr(allocator, .FetBufSize, odbc_buf[0..]);
    defer fet_buf_size_value.deinit(allocator);
    try expectEqual(
        131072,
        fet_buf_size_value.FetBufSize,
    );
}

test "setConnectAttr/1 returns an error when item is immutable" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    try expectError(
        err.SetConnectAttrError.Error,
        con.setConnectAttr(.{ .ConnectionDead = .True }),
    );

    try expectError(
        err.SetConnectAttrError.Error,
        con.setConnectAttr(.{ .AutoIpd = .True }),
    );
}
