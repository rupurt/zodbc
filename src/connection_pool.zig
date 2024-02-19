const std = @import("std");

const environment = @import("environment.zig");
const Environment = environment.Environment;

const connection = @import("connection.zig");
const Connection = connection.Connection;

pub const ConnectionPool = struct {
    connections: []*Connection,

    pub fn init(
        allocator: std.mem.Allocator,
        env: *Environment,
        config: ConnectionPoolConfig,
    ) !*ConnectionPool {
        _ = config;
        _ = env;
        const pool = allocator.create(ConnectionPool);
        return pool;
    }

    pub fn deinit(self: *ConnectionPool) void {
        _ = self;
    }

    pub fn connectWithString(self: *ConnectionPool) !void {
        _ = self;
    }
};

pub const ConnectionPoolConfig = struct {
    // The maximum number of ODBC connections that will be created and managed
    // by the connection pool
    max_connections: usize = 2,
    // The maximum number of times an individual connection managed by the
    // connection pool will attempt to reconnect before returning an error
    max_reconnect_limit: usize = 0,
};
