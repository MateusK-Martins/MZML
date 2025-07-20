const std = @import("std");
const m = @import("matrix.zig");

pub fn Layer(comptime InputSize: u64, comptime Neurons: u64) type {
    return struct {
        weights: m.Matrix(Neurons, InputSize),
        bias: m.Matrix(Neurons, 1),

        pub fn Random(self: *@This(), rng: *std.Random, weights_range: [2]f64, bias_range: [2]f64) void {

            for (&self.weights.data) |*w| {
                const raw = rng.float(f32);
                w.* = weights_range[0] + raw * (weights_range[1] - weights_range[0]);
            }

            for (&self.bias.data) |*b| {
                const raw = rng.float(f32);
                b.* = bias_range[0] + raw * (bias_range[1] - bias_range[0]);
            }
        }

        pub fn Forward(self: *const @This(), input: *const m.Matrix(InputSize, 1)) m.Matrix(Neurons, 1) {
            return self.weights.Mul(1, input).Add(self.bias);
        }

        // Safe Functions

        pub fn SForward(self: *const @This(), input: *const m.Matrix(InputSize, 1)) !m.Matrix(Neurons, 1) {
            const r = try self.weights.SMul(InputSize, 1, input);
            return try r.SAdd(r.rows, 1, self.bias);
        }
    };
}