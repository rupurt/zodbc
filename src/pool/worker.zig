const std = @import("std");

const core = @import("core");
const Environment = core.Environment;
const Connection = core.Connection;
const Statement = core.Statement;

const thread_worker = @import("thread_worker.zig");
const ThreadWorker = thread_worker.ThreadWorker;
const HandleResult = thread_worker.HandleResult;

const messages = @import("messages.zig");
const ParentMessage = messages.ParentMessage;

pub const Worker = ThreadWorker(
    Context,
    Message,
    ParentMessage,
    struct {
        pub fn handleMessage(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            return switch (msg) {
                .join => handleJoin(),
                .ping => handlePing(),
                .connect => handleConnectWithString(msg, ctx),
                .disconnect => handleDisconnect(msg, ctx),
                .cancel => handleCancel(msg, ctx),
                .prepare => handlePrepare(msg, ctx),
                .execute => handleExecute(msg, ctx),
                .executeDirect => handleExecuteDirect(msg, ctx),
                .setPos => handleSetPos(msg, ctx),
                .fetchScroll => handleFetchScroll(msg, ctx),
            };
        }

        inline fn handleJoin() HandleResult(ParentMessage) {
            // std.debug.print("Worker#handleJoin/2\n", .{});
            return .{ .stop = .{} };
        }

        inline fn handlePing() HandleResult(ParentMessage) {
            // std.debug.print("Worker#handlePing/2\n", .{});
            return .{ .reply = .{ .pong = .{} } };
        }

        inline fn handleConnectWithString(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            // std.debug.print("Worker#handleConnectWithString/2\n", .{});
            ctx.con = Connection.init(msg.connect.env) catch |err| {
                std.debug.print("error creating connection: {any}\n", .{err});
                return .{ .stop = .{} };
            };
            ctx.con.?.connectWithString(msg.connect.dsn) catch |err| {
                std.debug.print("error connecting to database: {any}\n", .{err});
                return .{ .stop = .{} };
            };
            return .{ .reply = .{ .connect = .{} } };
        }

        inline fn handleDisconnect(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            _ = ctx;
            _ = msg;
            // std.debug.print("Worker#handleDisconnect/2\n", .{});
            return .{ .reply = .{ .disconnect = .{} } };
        }

        inline fn handleCancel(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            _ = ctx;
            _ = msg;
            // std.debug.print("Worker#handleCancel/2\n", .{});
            return .{
                .reply = .{ .cancel = .{} },
            };
        }

        inline fn handlePrepare(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            // std.debug.print("Worker#handlePrepare/2\n", .{});
            ctx.stmt = Statement.init(ctx.con.?) catch |err| {
                std.debug.print("error creating statement: {any}\n", .{err});
                return .{ .stop = .{} };
            };
            ctx.stmt.?.prepare(msg.prepare.statement_str) catch |err| {
                std.debug.print("error preparing statement: {any}\n", .{err});
                return .{ .stop = .{} };
            };
            return .{ .reply = .{ .prepare = .{} } };
        }

        inline fn handleExecute(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            _ = msg;
            // std.debug.print("Worker#handleExecute/2\n", .{});
            ctx.stmt.?.execute() catch |err| {
                std.debug.print("error executing statement: {any}\n", .{err});
                return .{ .stop = .{} };
            };
            return .{ .reply = .{ .execute = .{} } };
        }

        inline fn handleExecuteDirect(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            _ = ctx;
            _ = msg;
            // std.debug.print("Worker#handleExecuteDirect/2\n", .{});
            return .{ .reply = .{ .execute = .{} } };
        }

        inline fn handleSetPos(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            _ = ctx;
            _ = msg;
            std.debug.print("Worker#handleSetPos/2\n", .{});
            return .{ .reply = .{ .setPos = .{} } };
        }

        inline fn handleFetchScroll(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            _ = ctx;
            _ = msg;
            std.debug.print("Worker#handleFetchScroll/2\n", .{});
            return .{ .reply = .{ .fetchScroll = .{} } };
        }
    },
);

const Context = struct {
    con: ?Connection = null,
    stmt: ?Statement = null,
};

const Message = union(MessageType) {
    join: struct {},
    ping: struct {},
    connect: struct {
        env: Environment,
        dsn: []const u8,
    },
    disconnect: struct {},
    cancel: struct {},
    prepare: struct {
        statement_str: []const u8,
    },
    execute: struct {},
    executeDirect: struct {
        statement_str: []const u8,
    },
    setPos: struct {
        offset: usize,
    },
    fetchScroll: struct {},
};
const MessageType = enum {
    join,
    ping,
    connect,
    disconnect,
    cancel,
    prepare,
    execute,
    executeDirect,
    setPos,
    fetchScroll,
};
