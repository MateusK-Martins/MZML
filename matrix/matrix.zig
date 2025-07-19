const std = @import("std");

pub fn Matrix(comptime rows: usize, comptime columns: usize) type {
    return struct {
        rows: usize = rows,
        columns: usize = columns,
        data: [rows * columns]f32,

        pub fn Random(self: *@This(), rng: *std.Random, range: [2]f64) void {
            for (&self.data) |*item| {
                const raw = rng.float(f32);
                item.* = raw * range[0] - range[1];
            }
        }
    };
}