const std = @import("std");
const zig_cli = @import("zig-cli");
const zodbc = @import("zodbc");

const AttributeValue = zodbc.odbc.attributes.EnvironmentAttributeValue;

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

    var value: AttributeValue = undefined;

    value = try env.getEnvAttr(.OdbcVersion);
    try stdout.print("SQL_ATTR_ODBC_VERSION={}\n", .{value.OdbcVersion});

    value = try env.getEnvAttr(.OutputNts);
    try stdout.print("SQL_ATTR_OUTPUT_NTS={}\n", .{value.OutputNts});

    value = try env.getEnvAttr(.ConnectionPooling);
    try stdout.print("SQL_ATTR_CONNECTION_POOLING={}\n", .{value.ConnectionPooling});

    value = try env.getEnvAttr(.CpMatch);
    try stdout.print("SQL_ATTR_CP_MATCH={}\n", .{value.CpMatch});

    try bw.flush();
}
