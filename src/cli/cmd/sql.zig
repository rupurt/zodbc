const std = @import("std");
const zig_cli = @import("zig-cli");
const zodbc = @import("zodbc");

var command = zig_cli.Option{
    .long_name = "command",
    .short_alias = 'c',
    .help = "SQL statement that will be executed",
    .required = true,
    .value_ref = zig_cli.mkRef(&config.command),
};
var dsn = zig_cli.Option{
    .long_name = "dsn",
    .short_alias = 'd',
    .help = "Data source name connection string",
    .required = true,
    .value_ref = zig_cli.mkRef(&config.dsn),
};
var fetch_array_size = zig_cli.Option{
    .long_name = "fetch-array-size",
    .help = "Buffer size for each fetch operation",
    .value_ref = zig_cli.mkRef(&config.fetch_array_size),
};
var output = zig_cli.Option{
    .long_name = "output",
    .short_alias = 'o',
    .help = "Output file path",
    .value_ref = zig_cli.mkRef(&config.output),
};
var include_headers = zig_cli.Option{
    .long_name = "include-headers",
    .help = "Include column headers in the output file",
    .value_ref = zig_cli.mkRef(&config.include_headers),
};
var workers = zig_cli.Option{
    .long_name = "workers",
    .short_alias = 'w',
    .help = "Number of connections to use within separate kernel threads",
    .value_ref = zig_cli.mkRef(&config.n_workers),
};
var timing = zig_cli.Option{
    .long_name = "timing",
    .short_alias = 't',
    .help = "Log execution time metrics",
    .value_ref = zig_cli.mkRef(&config.timing),
};
var verbose = zig_cli.Option{
    .long_name = "verbose",
    .short_alias = 'v',
    .help = "Log memory and call trace information",
    .value_ref = zig_cli.mkRef(&config.verbose),
};
pub var cmd = zig_cli.Command{
    .name = "sql",
    .options = &.{
        &command,
        &dsn,
        &output,
        &include_headers,
        &workers,
        &timing,
        &verbose,
    },
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};
var config = struct {
    command: []const u8 = undefined,
    dsn: []const u8 = undefined,
    fetch_array_size: u32 = 1,
    output: []const u8 = undefined,
    include_headers: bool = true,
    n_workers: u16 = 1,
    timing: bool = false,
    verbose: u8 = 0,
}{};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn run() !void {
    var timer = std.time.Timer.start() catch @panic("need timer to work");
    const start_at = timer.read();
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const env = try zodbc.Environment.init(.V3);
    defer env.deinit();
    var pool = try zodbc.WorkerPool.init(allocator, env, .{ .n_workers = config.n_workers });
    defer pool.deinit();

    const connect_start_at = timer.read();
    try pool.connectWithString(config.dsn);
    const connect_end_at = timer.read();

    const prepare_start_at = timer.read();
    try pool.prepare(config.command);
    const prepare_end_at = timer.read();

    const execute_start_at = timer.read();
    try pool.execute();
    const execute_end_at = timer.read();

    const reader_init_start_at = timer.read();
    var reader = try pool.batchReader(allocator, config.fetch_array_size);
    defer reader.deinit();
    const reader_init_end_at = timer.read();

    const fetch_start_at = timer.read();
    if (std.mem.eql(u8, "", config.output)) {
        const rowset = reader.next();
        try stdout.print("[zodbc sql] write to stdout rowset={any}\n", .{rowset});
    } else {
        const file = try std.fs.cwd().createFile(
            config.output,
            .{ .read = true },
        );
        defer file.close();
        var total_bytes_written: usize = 0;
        var wrote_headers = false;
        while (reader.next()) |rowset| {
            if (config.include_headers and !wrote_headers) {
                for (rowset.column_descriptions, 0..) |col_desc, i| {
                    if (i > 0) {
                        total_bytes_written += try file.write(",");
                    }
                    total_bytes_written += try file.write(col_desc.name_buf[0..col_desc.name_buf_len]);
                }
                wrote_headers = true;
            }
            // while (rowset.items.next()) |rowset| {
            // }
        }
        if (config.verbose > 0) {
            try stdout.print("output\n", .{});
            try stdout.print(" - size={d} bytes\n", .{total_bytes_written});
        }
    }
    const fetch_end_at = timer.read();

    const end_at = timer.read();
    if (config.timing) {
        const wall_time = run_time(end_at, start_at);
        const connect_time = run_time(connect_end_at, connect_start_at);
        const prepare_time = run_time(prepare_end_at, prepare_start_at);
        const execute_time = run_time(execute_end_at, execute_start_at);
        const reader_init_time = run_time(reader_init_end_at, reader_init_start_at);
        const fetch_time = run_time(fetch_end_at, fetch_start_at);
        try stdout.print("timing:\n", .{});
        try stdout.print(" - wall={d:0.6}s\n", .{wall_time});
        try stdout.print(" - connect={d:0.6}s\n", .{connect_time});
        try stdout.print(" - prepare={d:0.6}s\n", .{prepare_time});
        try stdout.print(" - execute={d:0.6}s\n", .{execute_time});
        try stdout.print(" - reader.init={d:0.6}s\n", .{reader_init_time});
        try stdout.print(" - fetch={d:0.6}s\n", .{fetch_time});
    }

    try bw.flush();
}

fn run_time(end_at: usize, start_at: usize) f64 {
    return ns_to_s(@as(f64, @floatFromInt(end_at - start_at)));
}

fn ns_to_s(ns: f64) f64 {
    return ns / 1000.0 / 1000.0 / 1000.0;
}
