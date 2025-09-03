const std = @import("std");
const m = @import("matrix.zig");

test "Matrix Random Fills" {
    const Mat3x3 = m.Matrix(3, 3);

    const seed: u64 = @intCast(std.time.nanoTimestamp());
    var prng = std.Random.DefaultPrng.init(seed);
    var rng = prng.random();

    var mat = Mat3x3.init();

    const range = [2]f32{1.0, 5.0};

    mat.Random(.Inplace, &rng, range);

    for (mat.data) |val| {
        try std.testing.expect(val >= range[0]);
        try std.testing.expect(val <= range[1]);
    }
}

test "Matrix Add" {
    const Mat2x2 = m.Matrix(2, 2);

    var a = Mat2x2{ .data = [_]f32{ 1, 2, 3, 4 } };
    const b = Mat2x2{ .data = [_]f32{ 5, 6, 7, 8 } };
    const expected = Mat2x2{ .data = [_]f32{ 6, 8, 10, 12 } };

    const result = a.Add(.Copy, &b);

    for (0..4) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}

test "Matrix Sub" {
    const Mat2x2 = m.Matrix(2, 2);

    var a = Mat2x2{ .data = [_]f32{ 1, 2, 3, 4 } };
    const b = Mat2x2{ .data = [_]f32{ 5, 6, 7, 8 } };
    const expected = Mat2x2{ .data = [_]f32{ -4, -4, -4, -4 } };

    const result = a.Sub(.Copy, &b);

    for (0..4) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}

test "Matrix Div" {
    const Mat2x2 = m.Matrix(2, 2);

    var a = Mat2x2{ .data = [_]f32{ 2, 6, 5, 4 } };
    const b = Mat2x2{ .data = [_]f32{ 2, 3, 2, 8 } };
    const expected = Mat2x2{ .data = [_]f32{ 1, 2, 2.5, 0.5 } };

    const result = a.Div(.Copy, &b);

    for (0..4) |i| {
        try std.testing.expect(@abs(result.data[i] - expected.data[i]) < 0.0001);
    }
}

test "Matrix Mul" {
    const Mat2x2 = m.Matrix(2, 2);
    const Mat2x1 = m.Matrix(2, 1);

    var a = Mat2x2{ .data = [_]f32{ 2, 6, 5, 4 } };
    const b = Mat2x1{ .data = [_]f32{ 2, 3 } };
    const expected = Mat2x1{ .data = [_]f32{ 22, 22 } };

    const result = a.Mul(m.Matrix(2, 1), &b);

    for (0..2) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}

test "Matrix Transpose" {
    const Mat2x2 = m.Matrix(2, 2);

    var a = Mat2x2{ .data = [_]f32{ 2, 6, 5, 4 } };
    const expected = Mat2x2{ .data = [_]f32{ 2, 5, 6, 4 } };

    const result = a.Transpose();

    for (0..4) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}
