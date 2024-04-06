const std = @import("std");

const core = @import("core");
const Environment = core.Environment;
const Connection = core.Connection;

pub fn environment() !Environment {
    return try Environment.init(.V3);
}

pub fn connection() !EnvironmentConnection {
    const env = try environment();
    const con = try Connection.init(env);
    return .{ .env = env, .con = con };
}
pub const EnvironmentConnection = struct {
    env: Environment,
    con: Connection,
};

pub fn connectionWithEnv(env: Environment) !Connection {
    return try Connection.init(env);
}

pub fn db2ConnectionString(allocator: std.mem.Allocator) ![]const u8 {
    const db2_driver = try std.process.getEnvVarOwned(allocator, "DB2_DRIVER");
    defer allocator.free(db2_driver);
    return try std.fmt.allocPrint(
        allocator,
        "Driver={s};Hostname={s};Database={s};Port={d};Uid={s};Pwd={s};",
        .{
            db2_driver,
            "localhost",
            "testdb",
            50_000,
            "db2inst1",
            "password",
        },
    );
}
