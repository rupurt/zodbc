const std = @import("std");
const Semaphore = std.Thread.Semaphore;

pub fn Mailbox(comptime T: type) type {
    return struct {
        const Self = @This();
        const MessageList = std.DoublyLinkedList(T);

        sem: Semaphore = .{},
        allocator: std.mem.Allocator,
        messages: MessageList,

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .messages = .{},
            };
        }

        pub fn deinit(self: Self) void {
            _ = self;
            // while (true) {
            //     const node = self.messages.popFirst();
            //     if (node == null) {
            //         break;
            //     }
            //     self.allocator.destroy(node);
            // }
        }

        pub fn post(self: *Self, message: T) !void {
            const node = try self.allocator.create(MessageList.Node);
            node.* = .{ .data = message };
            self.messages.append(node);
            self.sem.post();
        }

        pub fn dequeue(self: *Self) T {
            const node = self.messages.popFirst();
            if (node == null) {
                self.sem.wait();
                return self.dequeue();
            }
            defer self.allocator.destroy(node.?);
            return node.?.*.data;
        }
    };
}
