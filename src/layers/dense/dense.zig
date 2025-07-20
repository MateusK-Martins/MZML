const std = @import("std");
const matrix = @import("../../lib.zig").matrix;

pub fn Dense(comptime InputSize: u64, comptime Neurons: u64) type {
    return struct {
        weights: matrix.Matrix(Neurons, InputSize),
        bias: matrix.Matrix(Neurons, 1),

        pub fn Random(self: *@This(), rng: *std.Random, weights_range: [2]f32, bias_range: [2]f32) void {

            for (&self.weights.data) |*w| {
                const raw = rng.float(f32);
                w.* = weights_range[0] + raw * (weights_range[1] - weights_range[0]);
            }

            for (&self.bias.data) |*b| {
                const raw = rng.float(f32);
                b.* = bias_range[0] + raw * (bias_range[1] - bias_range[0]);
            }
        }

        pub fn IOForward(self: *const @This(), input: *const matrix.Matrix(InputSize, 1)) matrix.Matrix(Neurons, 1) {
            return self.weights.Mul(1, input).Add(&self.bias);
        }

        // Safe Functions

        pub fn SIOForward(self: *const @This(), input: *const matrix.Matrix(InputSize, 1)) !matrix.Matrix(Neurons, 1) {
            const r = try self.weights.SMul(InputSize, 1, input);
            return try r.SAdd(r.rows, 1, &self.bias);
        }
    };
}