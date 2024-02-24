const std = @import("std");

const core = @import("core");

const Mailbox = @import("mailbox.zig").Mailbox;

pub const ParentMailbox = Mailbox(ParentMessage);
pub const ParentMessage = union(ParentMessageType) {
    pong: struct {},
    connect: struct {},
    disconnect: struct {},
    cancel: struct {},
    prepare: struct {},
    execute: struct {},
    executeDirect: struct {},
    setPos: struct {},
};
pub const ParentMessageType = enum {
    pong,
    connect,
    disconnect,
    cancel,
    prepare,
    execute,
    executeDirect,
    setPos,
};
