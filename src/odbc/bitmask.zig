const std = @import("std");
const Type = std.builtin.Type;

pub fn Bitmask(comptime BackingType: type, comptime fields: anytype) type {
    var incoming_fields: [fields.len]Type.StructField = undefined;
    inline for (fields, 0..) |field, i| {
        incoming_fields[i] = .{ .name = field[0], .type = bool, .default_value = &false, .is_comptime = false, .alignment = @alignOf(bool) };
    }

    const BitmaskFields = @Type(.{ .Struct = .{
        .layout = .Auto,
        .fields = incoming_fields[0..],
        .decls = &[_]std.builtin.Type.Declaration{},
        .is_tuple = false,
    } });

    return struct {
        pub const Result = BitmaskFields;

        /// Given a masked value, create an instance of the bitmask fields struct
        /// with the appropriate fields set to "true" based on the input value.
        pub inline fn applyBitmask(value: BackingType) Result {
            var result = Result{};
            inline for (fields) |field| {
                if (value & field[1] == field[1]) {
                    @field(result, field[0]) = true;
                }
            }

            return result;
        }

        /// Given a bitmask field struct, generate a masked value using the configured mask values
        /// for each field.
        pub inline fn createBitmask(bitmask_fields: BitmaskFields) BackingType {
            var result: BackingType = 0;

            inline for (fields) |field| {
                if (@field(bitmask_fields, field[0])) {
                    result |= field[1];
                }
            }

            return result;
        }
    };
}

test "bitmask" {
    const TestType = Bitmask(u4, .{ .{ "fieldA", 0b0001 }, .{ "fieldB", 0b0010 }, .{ "fieldC", 0b0100 } });

    const test_value = TestType.applyBitmask(0b0110);

    try std.testing.expect(!test_value.fieldA);
    try std.testing.expect(test_value.fieldB);
    try std.testing.expect(test_value.fieldC);

    const test_set: TestType.Result = .{ .fieldA = true, .fieldB = false, .fieldC = true };

    const test_set_result = TestType.createBitmask(test_set);

    try std.testing.expectEqual(@as(u4, 0b0101), test_set_result);
}
