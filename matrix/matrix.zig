const std = @import("std");

pub const DimensionMismatch = error.DimensionMismatch;

pub fn Matrix(comptime Rows: usize, comptime Columns: usize) type {
    return struct {
        rows: usize = Rows,
        columns: usize = Columns,
        data: [Rows * Columns]f32,

        pub fn Random(self: *@This(), rng: *std.Random, range: [2]f32) void {
            for (&self.data) |*item| {
                const raw = rng.float(f32);
                item.* = range[0] + raw * (range[1] - range[0]);
            }
        }

        pub fn Add(self: *const @This(), other: *const @This()) @This() {

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] + other.data[i];
            }

            return result;
        }

        pub fn Sub(self: *const @This(), other: *const @This()) @This() {

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] - other.data[i];
            }

            return result;
        }

        pub fn Div(self: *const @This(), other: *const @This()) @This() {

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] / other.data[i];
            }

            return result;
        }

        pub fn Mul(self: *const @This(), comptime LocalColumns: u64, other: *const Matrix(Columns, LocalColumns)) @This() {

            if (self.columns != other.rows) {
                @panic("Matrix columns doesn't match with target rows in Mul()");
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

            for (0..self.columns) |i| {
                for (0..self.rows) |j| {
                    result.data[i * self.rows + j] = self.data[j * self.columns + i];
                }
            }

            return result;
        }
        
        //Safe Functions

        pub fn SAdd(self: *const @This(), comptime LocalRows: u64, comptime LocalColumns: u64, other: *const Matrix(LocalRows, LocalColumns)) !@This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                return DimensionMismatch;
            }

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] + other.data[i];
            }

            return result;
        }

        pub fn SSub(self: *const @This(), comptime LocalRows: u64, comptime LocalColumns: u64, other: *const Matrix(LocalRows, LocalColumns)) !@This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                return DimensionMismatch;
            }

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] - other.data[i];
            }

            return result;
        }

        pub fn SDiv(self: *const @This(), comptime LocalRows: u64, comptime LocalColumns: u64, other: *const Matrix(LocalRows, LocalColumns)) !@This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                return DimensionMismatch;
            }

            var result = @This(){ 
                .data = undefined 
            };

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] / other.data[i];
            }

            return result;
        }

        pub fn SMul(self: *const @This(), comptime LocalRows: u64, comptime LocalColumns: u64, other: *const Matrix(LocalRows, LocalColumns)) !@This() {

            if (self.columns != other.rows) {
                return DimensionMismatch;
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
    };
}