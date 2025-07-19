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

        pub fn Add(self: *const @This(), other: *const @This()) @This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                @panic("Matrix dimension mismacth in Add()");
            }

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] + other.data[i];
            }

            return result;
        }

        pub fn Sub(self: *const @This(), other: *const @This()) @This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                @panic("Matrix dimension mismacth in Sub()");
            }

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] - other.data[i];
            }

            return result;
        }

        pub fn Div(self: *const @This(), other: *const @This()) @This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                @panic("Matrix dimension mismacth in Div()");
            }

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] / other.data[i];
            }

            return result;
        }

        pub fn Mul(self: *const @This(), other: *const @This()) @This() {

            if (self.columns != other.rows) {
                @panic("Matrix rows doesn't match with target columns in Mul()");
            }

            var result = @This(){ 
                .rows = self.rows,
                .columns = other.columns,
                .data = undefined 
            };

            for (0..self.rows) | i| {
                for (0..other.columns) |j| {
                    var sum: f32 = 0.0;
                    for (0..self.columns) |k| {
                        sum += self.data[i * self.columns + k] * other.data[k * other.columns + j];
                    }
                    result.data[i * result.columns + j] = sum;
                }
            }

            return result;
        }

        pub fn Transpose(self: *const @This()) @This() {

            var result = @This(){ 
                .rows = self.columns,
                .columns = self.rows,
                .data = undefined 
            };

            for (0..self.column) |i| {
                for (0..self.row) |j| {
                    result.data[i * self.row + j] = self.data[j * self.columns + i];
                }
            }

            return result;
        }
    };
}