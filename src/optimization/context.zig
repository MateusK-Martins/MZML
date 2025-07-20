const std = @import("std");
const matrix = @import("../lib.zig").matrix;
const Activation = @import("activation.zig").Activation;
const LayerKinds = @import("../lib.zig").layer_kinds;

pub fn Context(comptime Size: u64) type {
    return struct {
        data: [Size]f32,
        activation: Activation,
        layer_kind: LayerKinds,

        pub fn init() @This() {
            return .{
                .data = undefined,
                .activation = Activation{
                    .forward = undefined,
                    .backward = undefined
                },
            };
        }

        pub fn SetActivation(self: *@This(), forward: fn (matrix.Matrix) matrix.Matrix, backward: fn (matrix.Matrix) matrix.Matrix) void {
            self.activation = Activation{
                .forward = forward,
                .backward = backward,
            };
        }
    };
}