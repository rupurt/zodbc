const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.StatementAttributeValue;

test ".getStmtAttr/1 can retrieve settings for statements" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    const stmt = try zodbc.Statement.init(env_con.con);
    defer stmt.deinit();

    const row_bind_type_attr = try stmt.getStmtAttr(.RowBindType);
    try expectEqual(
        AttributeValue.RowBindType.Column,
        row_bind_type_attr.RowBindType,
    );

    const concurrency_attr = try stmt.getStmtAttr(.Concurrency);
    try expectEqual(
        AttributeValue.Concurrency.ReadOnly,
        concurrency_attr.Concurrency,
    );

    const cursor_scrollable_attr = try stmt.getStmtAttr(.CursorScrollable);
    try expectEqual(
        AttributeValue.CursorScrollable.NonScrollable,
        cursor_scrollable_attr.CursorScrollable,
    );

    const cursor_sensitivity_attr = try stmt.getStmtAttr(.CursorSensitivity);
    try expectEqual(
        AttributeValue.CursorSensitivity.Unspecified,
        cursor_sensitivity_attr.CursorSensitivity,
    );

    const cursor_type_attr = try stmt.getStmtAttr(.CursorType);
    try expectEqual(
        AttributeValue.CursorType.ForwardOnly,
        cursor_type_attr.CursorType,
    );

    const max_length_attr = try stmt.getStmtAttr(.MaxLength);
    try expectEqual(
        0,
        max_length_attr.MaxLength,
    );

    const max_rows_attr = try stmt.getStmtAttr(.MaxRows);
    try expectEqual(
        0,
        max_rows_attr.MaxRows,
    );

    const paramset_size_attr = try stmt.getStmtAttr(.ParamsetSize);
    try expectEqual(
        1,
        paramset_size_attr.ParamsetSize,
    );

    // const params_processed_ptr = try stmt.getStmtAttr(.ParamsProcessedPtr);
    // try expectEqual(
    //     @as(*isize, @constCast(&0)),
    //     params_processed_ptr.ParamsProcessedPtr,
    // );

    const retrieve_data_attr = try stmt.getStmtAttr(.RetrieveData);
    try expectEqual(
        AttributeValue.RetrieveData.On,
        retrieve_data_attr.RetrieveData,
    );

    const row_array_size_attr = try stmt.getStmtAttr(.RowArraySize);
    try expectEqual(
        1,
        row_array_size_attr.RowArraySize,
    );

    // const row_status_ptr = try stmt.getStmtAttr(.RowStatusPtr);
    // try expectEqual(
    //     @as(*isize, @constCast(&0)),
    //     row_status_ptr.RowStatusPtr,
    // );

    // const rows_fetched_ptr = try stmt.getStmtAttr(.RowsFetchedPtr);
    // try expectEqual(
    //     @as(*isize, @constCast(&0)),
    //     rows_fetched_ptr.RowsFetchedPtr,
    // );

    const txn_isolation_attr = try stmt.getStmtAttr(.TxnIsolation);
    try expectEqual(
        AttributeValue.TxnIsolation.ReadCommitted,
        txn_isolation_attr.TxnIsolation,
    );

    const use_bookmark_attr = try stmt.getStmtAttr(.UseBookmark);
    try expectEqual(
        AttributeValue.UseBookmark.Off,
        use_bookmark_attr.UseBookmark,
    );
}
test ".getStmtAttr/1 can retrieve the cursor row number after a statement has been executed" {
    const env_con = try zodbc.testing.connection();
    defer {
        env_con.con.deinit();
        env_con.env.deinit();
    }
    const con = env_con.con;
    const con_str = try zodbc.testing.db2ConnectionString(allocator);
    defer allocator.free(con_str);
    try con.connectWithString(con_str);

    const stmt = try zodbc.Statement.init(env_con.con);
    defer stmt.deinit();

    // const row_number_attr = try stmt.getStmtAttr(.RowNumber);
    // try expectEqual(
    //     0,
    //     row_number_attr.RowNumber,
    // );
}
