const std = @import("std");
const matrix = @import("../../lib.zig").matrix;
const l = @import("dense.zig");

test "Layer Random Fills" {
    const l3x2 = l.Dense(3, 2);

    const seed: u64 = @intCast(std.time.nanoTimestamp());
    var prng = std.Random.DefaultPrng.init(seed);
    var rng = prng.random();

    const range_w = [2]f32{-1.0, 2.0};
    const range_b = [2]f32{-1.0, 1.0};

    var layer = l3x2{ 
        .weights = undefined,
        .bias = undefined
    };

    layer.Random(&rng, range_w, range_b);

    for (layer.weights.data) |val| {
        try std.testing.expect(val >= range_w[0]);
        try std.testing.expect(val <= range_w[1]);
    }
    for (layer.bias.data) |val| {
        try std.testing.expect(val >= range_b[0]);
        try std.testing.expect(val <= range_b[1]);
    }
}

test "Forward Layer" {
    const l3x2 = l.Dense(2, 2);

    const input = matrix.Matrix(2, 1){ .data = [_]f32{1.0, 2.0} };

    const layer = l3x2{ 
        .weights = matrix.Matrix(2, 2){ .data = [_]f32{1.0, 2.0, 3.0, 4.0} },
        .bias = matrix.Matrix(2, 1){ .data = [_]f32{0.5, 0.5} }
    };

    const expected = matrix.Matrix(2, 1){.data = [_]f32{5.5, 11.5} };

    const t = matrix.Matrix(2, 2){ .data = [_]f32{1.0, 2.0, 3.0, 4.0} };
    _ = t.Mul(1, &input);

    const result = layer.Forward(&input);

    for (expected.data, 0..) |e, i| {
        try std.testing.expectEqual(e, result.data[i]);
    }
}