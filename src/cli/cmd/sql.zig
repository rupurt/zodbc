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
    .options = &.{ &command, &dsn, &workers, &timing, &verbose },
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};
var config = struct {
    command: []const u8 = undefined,
    dsn: []const u8 = undefined,
    n_workers: u16 = 1,
    timing: bool = false,
    verbose: u8 = 0,
}{};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn run() !void {
    const env = try zodbc.Environment.init(.v3_80);
    defer env.deinit();
    var pool = try zodbc.ConnectionPool.init(allocator, env, .{ .n_workers = config.n_workers });
    defer pool.deinit();
    try pool.connectWithString(config.dsn);
    try pool.prepare(config.command);
    try pool.execute();

    const reader = pool.batchReader();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("[zodbc sql] reader={any}\n", .{reader});
    try bw.flush();
}
