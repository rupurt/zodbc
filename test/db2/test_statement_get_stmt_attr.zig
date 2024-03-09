const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.StatementAttributeValue;

test "getStmtAttr/1 can retrieve the current values" {
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

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const row_bind_type_value = try stmt.getStmtAttr2(allocator, .RowBindType, odbc_buf[0..]);
    defer row_bind_type_value.deinit(allocator);
    try expectEqual(attrs.bind_by_column, row_bind_type_value.RowBindType);

    @memset(odbc_buf[0..], 0);
    const concurrency_value = try stmt.getStmtAttr2(allocator, .Concurrency, odbc_buf[0..]);
    defer concurrency_value.deinit(allocator);
    try expectEqual(
        AttributeValue.Concurrency.ReadOnly,
        concurrency_value.Concurrency,
    );

    @memset(odbc_buf[0..], 0);
    const cursor_scrollable_value = try stmt.getStmtAttr2(allocator, .CursorScrollable, odbc_buf[0..]);
    defer cursor_scrollable_value.deinit(allocator);
    try expectEqual(
        AttributeValue.CursorScrollable.NonScrollable,
        cursor_scrollable_value.CursorScrollable,
    );

    @memset(odbc_buf[0..], 0);
    const cursor_sensitivity_value = try stmt.getStmtAttr2(allocator, .CursorSensitivity, odbc_buf[0..]);
    defer cursor_sensitivity_value.deinit(allocator);
    try expectEqual(
        AttributeValue.CursorSensitivity.Unspecified,
        cursor_sensitivity_value.CursorSensitivity,
    );

    @memset(odbc_buf[0..], 0);
    const cursor_type_value = try stmt.getStmtAttr2(allocator, .CursorType, odbc_buf[0..]);
    defer cursor_type_value.deinit(allocator);
    try expectEqual(
        AttributeValue.CursorType.ForwardOnly,
        cursor_type_value.CursorType,
    );

    @memset(odbc_buf[0..], 0);
    const max_length_value = try stmt.getStmtAttr2(allocator, .MaxLength, odbc_buf[0..]);
    defer max_length_value.deinit(allocator);
    try expectEqual(0, max_length_value.MaxLength);

    @memset(odbc_buf[0..], 0);
    const max_rows_value = try stmt.getStmtAttr2(allocator, .MaxRows, odbc_buf[0..]);
    defer max_rows_value.deinit(allocator);
    try expectEqual(0, max_rows_value.MaxRows);

    @memset(odbc_buf[0..], 0);
    const paramset_size_value = try stmt.getStmtAttr2(allocator, .ParamsetSize, odbc_buf[0..]);
    defer paramset_size_value.deinit(allocator);
    try expectEqual(1, paramset_size_value.ParamsetSize);

    // @memset(odbc_buf[0..], 0);
    // const params_processed_ptr_value = try stmt.getStmtAttr2(allocator, .ParamsProcessedPtr, odbc_buf[0..]);
    // defer params_processed_ptr_value.deinit(allocator);
    // try expectEqual(@ptrFromInt(0), params_processed_ptr_value.ParamsProcessedPtr);

    @memset(odbc_buf[0..], 0);
    const retrieve_data_value = try stmt.getStmtAttr2(allocator, .RetrieveData, odbc_buf[0..]);
    defer retrieve_data_value.deinit(allocator);
    try expectEqual(
        AttributeValue.RetrieveData.On,
        retrieve_data_value.RetrieveData,
    );

    @memset(odbc_buf[0..], 0);
    const row_array_size_value = try stmt.getStmtAttr2(allocator, .RowArraySize, odbc_buf[0..]);
    defer row_array_size_value.deinit(allocator);
    try expectEqual(1, row_array_size_value.RowArraySize);

    // @memset(odbc_buf[0..], 0);
    // const row_status_ptr_value = try stmt.getStmtAttr2(allocator, .RowStatusPtr, odbc_buf[0..]);
    // defer row_status_ptr_value.deinit(allocator);
    // try expectEqual(@ptrFromInt(0), row_status_ptr_value.RowStatusPtr);

    // @memset(odbc_buf[0..], 0);
    // const rows_fetched_ptr_value = try stmt.getStmtAttr2(allocator, .RowsFetchedPtr, odbc_buf[0..]);
    // defer rows_fetched_ptr_value.deinit(allocator);
    // try expectEqual(@ptrFromInt(0), rows_fetched_ptr_value.RowsFetchedPtr);

    @memset(odbc_buf[0..], 0);
    const txn_isolation_value = try stmt.getStmtAttr2(allocator, .TxnIsolation, odbc_buf[0..]);
    defer txn_isolation_value.deinit(allocator);
    try expectEqual(
        AttributeValue.TxnIsolation.ReadCommitted,
        txn_isolation_value.TxnIsolation,
    );

    @memset(odbc_buf[0..], 0);
    const use_bookmark_value = try stmt.getStmtAttr2(allocator, .UseBookmark, odbc_buf[0..]);
    defer use_bookmark_value.deinit(allocator);
    try expectEqual(
        AttributeValue.UseBookmark.Off,
        use_bookmark_value.UseBookmark,
    );
}
test "getStmtAttr/1 can retrieve the cursor row number after a statement has been executed" {
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

    // var odbc_buf: [256]u8 = undefined;
    //
    // @memset(odbc_buf[0..], 0);
    // const row_numer_value = try stmt.getStmtAttr2(allocator, .RowNumber, odbc_buf[0..]);
    // defer row_numer_value.deinit(allocator);
    // try expectEqual(0, row_numer_value.RowNumber);
}
