const std = @import("std");
const Mutex = std.Thread.Mutex;
const Semaphore = std.Thread.Semaphore;

pub fn Mailbox(comptime T: type) type {
    return struct {
        const Self = @This();
        const MessageList = std.DoublyLinkedList(T);

        mut: Mutex = .{},
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
            self.mut.lock();
            self.messages.append(node);
            self.mut.unlock();
            self.sem.post();
        }

        pub fn dequeue(self: *Self) T {
            self.mut.lock();
            const node = self.messages.popFirst();
            self.mut.unlock();
            if (node == null) {
                self.sem.wait();
                return self.dequeue();
            }
            defer self.allocator.destroy(node.?);
            return node.?.*.data;
        }
    };
}
