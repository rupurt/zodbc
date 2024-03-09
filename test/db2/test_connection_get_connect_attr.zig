const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.ConnectionAttributeValue;

test ".getConnectAttr/1 can retrieve settings for disconnected connections" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;

    const access_mode_attr = try con.getConnectAttr(.AccessMode);
    try expectEqual(
        AttributeValue.AccessMode.ReadWrite,
        access_mode_attr.AccessMode,
    );

    const autocommit_attr = try con.getConnectAttr(.Autocommit);
    try expectEqual(
        AttributeValue.Autocommit.On,
        autocommit_attr.Autocommit,
    );

    const odbc_cursors_attr = try con.getConnectAttr(.OdbcCursors);
    try expectEqual(
        AttributeValue.OdbcCursors.UseDriver,
        odbc_cursors_attr.OdbcCursors,
    );

    const trace_attr = try con.getConnectAttr(.Trace);
    try expectEqual(
        AttributeValue.Trace.Off,
        trace_attr.Trace,
    );
}

test ".getConnectAttr/1 can retrieve settings for connected connections" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    const txn_isolation_attr = try con.getConnectAttr(.TxnIsolation);
    try expectEqual(
        AttributeValue.TxnIsolation.ReadCommitted,
        txn_isolation_attr.TxnIsolation,
    );

    const connection_timeout_attr = try con.getConnectAttr(.ConnectionTimeout);
    try expectEqual(
        0,
        connection_timeout_attr.ConnectionTimeout,
    );

    // const disconnect_behavior_attr = try con.getConnectAttr(.DisconnectBehavior);
    // try expectEqual(
    //     AttributeValue.DisconnectBehavior.ReadCommitted,
    //     disconnect_behavior_attr.DisconnectBehavior,
    // );

    // const enlist_in_dtc_attr = try con.getConnectAttr(.EnlistInDtc);
    // try expectEqual(
    //     AttributeValue.EnlistInDtc.EnlistExpensive,
    //     enlist_in_dtc_attr.EnlistInDtc,
    // );

    const login_timeout_attr = try con.getConnectAttr(.LoginTimeout);
    try expectEqual(
        0,
        login_timeout_attr.LoginTimeout,
    );

    // const driver_threading_attr = try con.getConnectAttr(.DriverThreading);
    // try expectEqual(
    //     AttributeValue.DriverThreading.Off,
    //     driver_threading_attr.DriverThreading,
    // );

    const async_enable_attr = try con.getConnectAttr(.AsyncEnable);
    try expectEqual(
        AttributeValue.AsyncEnable.Off,
        async_enable_attr.AsyncEnable,
    );
}

// IBM Db2 doesn't support SQL_ATTR_PACKET_SIZE
//
// - https://www.ibm.com/docs/en/db2/10.1.0?topic=attributes-connection-list
test ".getConnectAttr/1 returns a not implemented error" {
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
        con.getConnectAttr(.PacketSize),
    );
}
