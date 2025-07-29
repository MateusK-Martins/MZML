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

        pub fn GenerateGrad(
            self: *const @This(),
            grad: matrix.Matrix(Neurons, 1),
            input: *const matrix.Matrix(InputSize, 1),
        ) struct {
            grad_weights: matrix.Matrix(Neurons, InputSize),
            grad_bias: matrix.Matrix(Neurons, 1),
            delta_input: matrix.Matrix(InputSize, 1),
        } {
            const grad_weights = grad.Mul(1, input.Transpose()); 
            const grad_bias = grad; 
            const delta_input = self.weights.Transpose().Mul(1, &grad);

            return .{
                .grad_weights = grad_weights,
                .grad_bias = grad_bias,
                .delta_input = delta_input,
            };
        }

        pub fn ApplyGradients(
            self: *@This(),
            grad_weights: *const matrix.Matrix(Neurons, InputSize),
            grad_bias: *const matrix.Matrix(Neurons, 1),
            learning_rate: f32,
        ) void {
            self.*.weights = self.weights.Sub(&grad_weights.Scale(learning_rate));
            self.*.bias = self.bias.Sub(&grad_bias.Scale(learning_rate));
        }

        // Safe Functions

        pub fn SIOForward(self: *const @This(), input: *const matrix.Matrix(InputSize, 1)) !matrix.Matrix(Neurons, 1) {
            const r = try self.weights.SMul(InputSize, 1, input);
            return try r.SAdd(r.rows, 1, &self.bias);
        }
    };
}