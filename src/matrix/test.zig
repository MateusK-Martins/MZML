const std = @import("std");
const m = @import("matrix.zig");

test "Matrix Random Fills" {
    const Mat3x3 = m.Matrix(3, 3);

    const seed: u64 = @intCast(std.time.nanoTimestamp());
    var prng = std.Random.DefaultPrng.init(seed);
    var rng = prng.random();

    var mat = Mat3x3{ .data = undefined };

    const range = [2]f32{1.0, 5.0};

    mat.Random(&rng, range);

    for (mat.data) |val| {
        try std.testing.expect(val >= range[0]);
        try std.testing.expect(val <= range[1]);
    }
}

test "Matrix Add DimensionMismatch" {
    const a = m.Matrix(2, 3){ .data = [_]f32{1, 2, 3, 4, 5, 6} };
    const b = m.Matrix(3, 2){ .data = [_]f32{7, 8, 9, 10, 11, 12} };
    try std.testing.expectError(m.DimensionMismatch, a.SAdd(3, 2, &b));
}

test "Matrix Add" {
    const Mat2x2 = m.Matrix(2, 2);

    const a = Mat2x2{ .data = [_]f32{ 1, 2, 3, 4 } };
    const b = Mat2x2{ .data = [_]f32{ 5, 6, 7, 8 } };
    const expected = Mat2x2{ .data = [_]f32{ 6, 8, 10, 12 } };

    const result = a.Add(&b);

    for (0..3) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}

test "Matrix Sub DimensionMismatch" {
    const a = m.Matrix(2, 3){ .data = [_]f32{1, 2, 3, 4, 5, 6} };
    const b = m.Matrix(3, 2){ .data = [_]f32{7, 8, 9, 10, 11, 12} };
    try std.testing.expectError(m.DimensionMismatch, a.SSub(3, 2, &b));
}

test "Matrix Sub" {
    const Mat2x2 = m.Matrix(2, 2);

    const a = Mat2x2{ .data = [_]f32{ 1, 2, 3, 4 } };
    const b = Mat2x2{ .data = [_]f32{ 5, 6, 7, 8 } };
    const expected = Mat2x2{ .data = [_]f32{ -4, -4, -4, -4 } };

    const result = a.Sub(&b);

    for (0..3) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}

test "Matrix Div DimensionMismatch" {
    const a = m.Matrix(2, 3){ .data = [_]f32{1, 2, 3, 4, 5, 6} };
    const b = m.Matrix(3, 2){ .data = [_]f32{7, 8, 9, 10, 11, 12} };
    try std.testing.expectError(m.DimensionMismatch, a.SDiv(3, 2, &b));
}

test "Matrix Div" {
    const Mat2x2 = m.Matrix(2, 2);

    const a = Mat2x2{ .data = [_]f32{ 2, 6, 5, 4 } };
    const b = Mat2x2{ .data = [_]f32{ 2, 3, 2, 8 } };
    const expected = Mat2x2{ .data = [_]f32{ 1, 2, 2.5, 0.5 } };

    const result = a.Div(&b);

    for (0..3) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}

test "Matrix SMul" {
    const a = m.Matrix(2, 3){ .data = [_]f32{1, 2, 3, 4, 5, 6} };
    const b = m.Matrix(2, 3){ .data = [_]f32{7, 8, 9, 10, 11, 12} };

    try std.testing.expectError(m.DimensionMismatch, a.SMul(2, 3, &b));
}

test "Matrix Mul" {
    const Mat2x2 = m.Matrix(2, 2);
    const Mat2x1 = m.Matrix(2, 1);

    const a = Mat2x2{ .data = [_]f32{ 2, 6, 5, 4 } };
    const b = Mat2x1{ .data = [_]f32{ 2, 3 } };
    const expected = Mat2x1{ .data = [_]f32{ 22, 22 } };

    const result = a.Mul(1, &b);

    for (0..2) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}

test "Matrix Transpose" {
    const Mat2x2 = m.Matrix(2, 2);

    const a = Mat2x2{ .data = [_]f32{ 2, 6, 5, 4 } };
    const expected = Mat2x2{ .data = [_]f32{ 2, 5, 6, 4 } };

    const result = a.Transpose();

    for (0..4) |i| {
        try std.testing.expect(result.data[i] == expected.data[i]);
    }
}
