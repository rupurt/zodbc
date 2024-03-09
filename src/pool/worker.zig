const std = @import("std");

const core = @import("core");
const Environment = core.Environment;
const Connection = core.Connection;
const Statement = core.Statement;

const odbc = @import("odbc");
const types = odbc.types;
const attrs = odbc.attributes;
const ConnectAttributeValue = attrs.ConnectionAttributeValue;

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
                .setConnectAttr => handleSetConnectAttr(msg, ctx),
                .initConnection => handleInitConnection(msg, ctx),
                .connectWithString => handleConnectWithString(msg, ctx),
                .disconnect => handleDisconnect(msg, ctx),
                .cancel => handleCancel(msg, ctx),
                .prepare => handlePrepare(msg, ctx),
                .execute => handleExecute(msg, ctx),
                .executeDirect => handleExecuteDirect(msg, ctx),
                // .setPos => handleSetPos(msg, ctx),
                .fetchScroll => handleFetchScroll(msg, ctx),
            };
        }

        inline fn handleJoin() HandleResult(ParentMessage) {
            return .{ .stop = .{} };
        }

        inline fn handlePing() HandleResult(ParentMessage) {
            return .{ .reply = .{ .pong = .{} } };
        }

        inline fn handleInitConnection(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            std.debug.print("Worker#handleInitConnection/2\n", .{});
            const con = Connection.init(msg.initConnection.env) catch |err| {
                std.debug.print("error initializing connection: {any}\n", .{err});
                return .{ .stop = .{} };
            };
            std.debug.print("Worker#handleInitConnection/2 - created con={any}\n", .{con});
            ctx.*.con = con;
            std.debug.print("Worker#handleInitConnection/2 - assigned con={any}\n", .{ctx.con});
            return .{ .reply = .{ .initConnection = .{} } };
        }

        inline fn handleSetConnectAttr(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            _ = ctx;
            _ = msg;
            std.debug.print("Worker#handleSetConnectAttr/2\n", .{});
            // ctx.con.?.setConnectAttr(msg.setConnectAttr.attr_value) catch |err| {
            //     std.debug.print("error setting connect attribute: {any}\n", .{err});
            //     return .{ .stop = .{} };
            // };
            return .{ .reply = .{ .setConnectAttr = .{} } };
        }

        inline fn handleConnectWithString(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            std.debug.print("Worker#handleConnectWithString/2\n", .{});
            std.debug.print("Worker#handleConnectWithString - BEFORE ctx.con={any}\n", .{ctx.con});
            ctx.con.?.connectWithString(msg.connectWithString.dsn) catch |err| {
                std.debug.print("error connecting to database: {any}\n", .{err});
                return .{ .stop = .{} };
            };
            std.debug.print("Worker#handleConnectWithString - AFTER ctx.con={any}\n", .{ctx.con});
            return .{ .reply = .{ .connectWithString = .{} } };
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

        // inline fn handleSetPos(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
        //     std.debug.print("Worker#handleSetPos/2 offset={any}\n", .{msg.setPos.offset});
        //     const m = msg.setPos;
        //     ctx.stmt.?.setPos(m.offset, m.operation, m.lock) catch |err| {
        //         std.debug.print("error executing statement: {any}\n", .{err});
        //         return .{ .stop = .{} };
        //     };
        //     return .{ .reply = .{ .setPos = .{} } };
        // }

        inline fn handleFetchScroll(msg: Message, ctx: *Context) HandleResult(ParentMessage) {
            std.debug.print("Worker#handleFetchScroll/2 offset={any}\n", .{msg.fetchScroll.offset});
            const m = msg.fetchScroll;
            ctx.stmt.?.fetchScroll(m.orientation, m.offset) catch |err| {
                std.debug.print("error executing statement: {any}\n", .{err});
                return .{ .stop = .{} };
            };
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
    initConnection: struct {
        env: Environment,
    },
    setConnectAttr: struct {
        attr_value: ConnectAttributeValue,
    },
    connectWithString: struct {
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
    // setPos: struct {
    //     offset: usize,
    //     operation: types.SetPosOperation,
    //     lock: types.Lock,
    // },
    fetchScroll: struct {
        orientation: types.FetchOrientation,
        offset: usize,
    },
};
const MessageType = enum {
    join,
    ping,
    initConnection,
    setConnectAttr,
    connectWithString,
    disconnect,
    cancel,
    prepare,
    execute,
    executeDirect,
    // setPos,
    fetchScroll,
};
