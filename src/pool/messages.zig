const std = @import("std");

const core = @import("core");

const Mailbox = @import("mailbox.zig").Mailbox;

pub const ParentMailbox = Mailbox(ParentMessage);
pub const ParentMessage = union(ParentMessageType) {
    stop: struct {},
    pong: struct {},
    initConnection: struct {},
    setConnectAttr: struct {},
    connectWithString: struct {},
    disconnect: struct {},
    cancel: struct {},
    prepare: struct {},
    execute: struct {},
    executeDirect: struct {},
    // setPos: struct {},
    fetchScroll: struct {},
};
pub const ParentMessageType = enum {
    stop,
    pong,
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
