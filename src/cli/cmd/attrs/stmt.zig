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
    .name = "stmt",
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

    const stmt = try zodbc.Statement.init(con);
    defer stmt.deinit();

    var odbc_buf: [256]u8 = undefined;

    const row_bind_type_value = try stmt.getStmtAttr2(allocator, .RowBindType, odbc_buf[0..]);
    defer row_bind_type_value.deinit(allocator);
    try stdout.print("SQL_ATTR_ROW_BIND_TYPE={}\n", .{row_bind_type_value.RowBindType});

    const concurrency_value = try stmt.getStmtAttr2(allocator, .Concurrency, odbc_buf[0..]);
    defer concurrency_value.deinit(allocator);
    try stdout.print("SQL_ATTR_CONCURRENCY={}\n", .{concurrency_value.Concurrency});

    const cursor_scrollable_value = try stmt.getStmtAttr2(allocator, .CursorScrollable, odbc_buf[0..]);
    defer cursor_scrollable_value.deinit(allocator);
    try stdout.print("SQL_ATTR_CURSOR_SCROLLABLE={}\n", .{cursor_scrollable_value.CursorScrollable});

    const cursor_sensitivity_value = try stmt.getStmtAttr2(allocator, .CursorSensitivity, odbc_buf[0..]);
    defer cursor_sensitivity_value.deinit(allocator);
    try stdout.print("SQL_ATTR_CURSOR_SENSITIVITY={}\n", .{cursor_sensitivity_value.CursorSensitivity});

    const cursor_type_value = try stmt.getStmtAttr2(allocator, .CursorType, odbc_buf[0..]);
    defer cursor_type_value.deinit(allocator);
    try stdout.print("SQL_ATTR_CURSOR_TYPE={}\n", .{cursor_type_value.CursorType});

    const max_length_value = try stmt.getStmtAttr2(allocator, .MaxLength, odbc_buf[0..]);
    defer max_length_value.deinit(allocator);
    try stdout.print("SQL_ATTR_MAX_LENGTH={}\n", .{max_length_value.MaxLength});

    const max_rows_value = try stmt.getStmtAttr2(allocator, .MaxRows, odbc_buf[0..]);
    defer max_rows_value.deinit(allocator);
    try stdout.print("SQL_ATTR_MAX_ROWS={}\n", .{max_rows_value.MaxRows});

    const paramset_size_value = try stmt.getStmtAttr2(allocator, .ParamsetSize, odbc_buf[0..]);
    defer paramset_size_value.deinit(allocator);
    try stdout.print("SQL_ATTR_PARAMSET_SIZE={}\n", .{paramset_size_value.ParamsetSize});

    // const params_processed_ptr_value = try stmt.getStmtAttr2(allocator, .ParamsProcessedPtr, odbc_buf[0..]);
    // defer params_processed_ptr_value.deinit(allocator);
    // try stdout.print("SQL_ATTR_PARAMS_PROCESSED_PTR={}\n", .{params_processed_ptr_value.ParamsProcessedPtr});

    const retrieve_data_value = try stmt.getStmtAttr2(allocator, .RetrieveData, odbc_buf[0..]);
    defer retrieve_data_value.deinit(allocator);
    try stdout.print("SQL_ATTR_RETRIEVE_DATA={}\n", .{retrieve_data_value.RetrieveData});

    const row_array_size_value = try stmt.getStmtAttr2(allocator, .RowArraySize, odbc_buf[0..]);
    defer row_array_size_value.deinit(allocator);
    try stdout.print("SQL_ATTR_ROW_ARRAY_SIZE={}\n", .{row_array_size_value.RowArraySize});

    // const row_status_ptr_value = try stmt.getStmtAttr2(allocator, .RowStatus, odbc_buf[0..]);
    // defer row_status_ptr_value.deinit(allocator);
    // try stdout.print("SQL_ATTR_ROW_STATUS_PTR={}\n", .{row_status_ptr_value.RowStatus});

    // const rows_fetched_ptr_value = try stmt.getStmtAttr2(allocator, .RowsFetchedPtr, odbc_buf[0..]);
    // defer rows_fetched_ptr_value.deinit(allocator);
    // try stdout.print("SQL_ATTR_ROWS_FETCHED_PTR={}\n", .{rows_fetched_ptr_value.RowsFetchedPtr});

    const txn_isolation_value = try stmt.getStmtAttr2(allocator, .TxnIsolation, odbc_buf[0..]);
    defer txn_isolation_value.deinit(allocator);
    try stdout.print("SQL_ATTR_TXN_ISOLATION={}\n", .{txn_isolation_value.TxnIsolation});

    const use_bookmark_value = try stmt.getStmtAttr2(allocator, .UseBookmark, odbc_buf[0..]);
    defer use_bookmark_value.deinit(allocator);
    try stdout.print("SQL_ATTR_USE_BOOKMARK={}\n", .{use_bookmark_value.UseBookmark});

    try bw.flush();
}
