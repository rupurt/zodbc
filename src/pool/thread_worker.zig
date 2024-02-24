const std = @import("std");
const Thread = std.Thread;

const mailbox = @import("mailbox.zig");
const Mailbox = mailbox.Mailbox;

pub fn ThreadWorker(
    comptime WorkerContext: type,
    comptime WorkerMessage: type,
    comptime ParentMessage: type,
    comptime Handler: type,
) type {
    return struct {
        const Self = @This();
        const WorkerMailbox = Mailbox(WorkerMessage);
        const ParentMailbox = Mailbox(ParentMessage);

        worker_ctx: WorkerContext = undefined,
        worker_mailbox: WorkerMailbox = undefined,
        parent_mailbox: *ParentMailbox = undefined,
        thread: Thread = undefined,

        pub fn spawn(
            self: *Self,
            allocator: std.mem.Allocator,
            parent_mailbox: *ParentMailbox,
        ) !void {
            self.worker_ctx = WorkerContext{};
            self.worker_mailbox = WorkerMailbox.init(allocator);
            self.parent_mailbox = parent_mailbox;
            self.thread = try Thread.spawn(
                .{ .allocator = allocator },
                work,
                .{ Handler.handleMessage, &self.worker_ctx, &self.worker_mailbox, self.parent_mailbox },
            );
        }

        pub fn join(self: *Self) void {
            self.post(.{ .join = .{} }) catch |err| {
                std.debug.print("error posting message to worker mailbox err={any}\n", .{err});
            };
            self.thread.join();
            self.worker_mailbox.deinit();
        }

        pub fn post(self: *Self, msg: WorkerMessage) !void {
            try self.worker_mailbox.post(msg);
        }

        fn work(
            handler: anytype,
            ctx: *WorkerContext,
            w_mailbox: *WorkerMailbox,
            p_mailbox: *ParentMailbox,
        ) void {
            while (true) {
                const msg = w_mailbox.dequeue();
                switch (@call(.auto, handler, .{ msg, ctx })) {
                    .stop => break,
                    .reply => |r| {
                        p_mailbox.post(r) catch |err| {
                            std.debug.print("error posting message to parent mailbox err={any}\n", .{err});
                            break;
                        };
                    },
                    .noreply => {},
                }
            }
        }
    };
}

pub fn HandleResult(comptime ParentMessage: type) type {
    return union(HandleResultType) {
        stop: struct {},
        reply: ParentMessage,
        noreply: struct {},
    };
}
pub const HandleResultType = enum {
    stop,
    reply,
    noreply,
};
