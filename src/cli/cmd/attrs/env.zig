const std = @import("std");
const zig_cli = @import("zig-cli");
const zodbc = @import("zodbc");

const AttributeValue = zodbc.odbc.attributes.EnvironmentAttributeValue;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub var cmd = zig_cli.Command{
    .name = "env",
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};

fn run() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const env = try zodbc.Environment.init(.V3);
    defer env.deinit();

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const odbc_version_attr = try env.getEnvAttr(allocator, .OdbcVersion, odbc_buf[0..]);
    defer odbc_version_attr.deinit(allocator);
    try stdout.print("SQL_ATTR_ODBC_VERSION={}\n", .{odbc_version_attr.OdbcVersion});

    @memset(odbc_buf[0..], 0);
    const output_nts_attr = try env.getEnvAttr(allocator, .OutputNts, odbc_buf[0..]);
    defer output_nts_attr.deinit(allocator);
    try stdout.print("SQL_ATTR_OUTPUT_NTS={}\n", .{output_nts_attr.OutputNts});

    @memset(odbc_buf[0..], 0);
    const connection_pooling_attr = try env.getEnvAttr(allocator, .ConnectionPooling, odbc_buf[0..]);
    defer connection_pooling_attr.deinit(allocator);
    try stdout.print("SQL_ATTR_CONNECTION_POOLING={}\n", .{connection_pooling_attr.ConnectionPooling});

    @memset(odbc_buf[0..], 0);
    const cp_match_attr = try env.getEnvAttr(allocator, .CpMatch, odbc_buf[0..]);
    defer cp_match_attr.deinit(allocator);
    try stdout.print("SQL_ATTR_CP_MATCH={}\n", .{cp_match_attr.ConnectionPooling});

    @memset(odbc_buf[0..], 0);
    const unixodbc_syspath_attr = try env.getEnvAttr(allocator, .UnixodbcSyspath, odbc_buf[0..]);
    defer unixodbc_syspath_attr.deinit(allocator);
    try stdout.print("SQL_ATTR_UNIXODBC_SYSPATH={s}\n", .{unixodbc_syspath_attr.UnixodbcSyspath});

    @memset(odbc_buf[0..], 0);
    const unixodbc_version_attr = try env.getEnvAttr(allocator, .UnixodbcVersion, odbc_buf[0..]);
    defer unixodbc_version_attr.deinit(allocator);
    try stdout.print("SQL_ATTR_UNIXODBC_VERSION={s}\n", .{unixodbc_version_attr.UnixodbcVersion});

    try bw.flush();
}
