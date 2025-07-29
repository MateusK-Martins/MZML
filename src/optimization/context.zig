const std = @import("std");
const matrix = @import("../lib.zig").matrix;
const Activation = @import("activation.zig").Activation;
const LayerKinds = @import("../lib.zig").layer_kinds;

pub fn Context(comptime Size: u64, comptime T: type) type {
    return struct {
        pub const size: u64 = Size;
        data: matrix.Matrix(Size, 1),
        activation_data: matrix.Matrix(Size, 1),
        activation: Activation(Size, 1),
        layer_kind: LayerKinds,
        ref: *T,

        pub fn init() @This() {
            return .{
                .activation_data = matrix.Matrix(Size, 1).init(),
                .data = matrix.Matrix(Size, 1).init(),
                .activation = Activation{
                    .forward = undefined,
                    .backward = undefined
                },
            };
        }

        pub fn SetActivation(self: *@This(), forward: fn (*matrix.Matrix(Size, 1)) void, backward: fn (*matrix.Matrix(Size, 1)) void) void {
            self.activation = Activation{
                .forward = forward,
                .backward = backward,
            };
        }

        pub fn SetLayer(self: *@This(), t: *T) void {
            self.*.ref = t;
        }
    };
}