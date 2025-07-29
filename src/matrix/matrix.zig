const std = @import("std");

pub const DimensionMismatch = error.DimensionMismatch;

pub fn Matrix(comptime SelfRows: usize, comptime SelfColumns: usize) type {
    return struct {
        rows: usize = SelfRows,
        columns: usize = SelfColumns,
        data: [SelfRows * SelfColumns]f32,

        pub fn init() @This() {
            return .{
                .rows = SelfRows,
                .columns = SelfColumns,
                .data = [_]f32{0} ** (SelfRows * SelfColumns),
            };
        }

        pub fn Random(self: *@This(), rng: *std.Random, range: [2]f32) void {
            for (&self.data) |*item| {
                const raw = rng.float(f32);
                item.* = range[0] + raw * (range[1] - range[0]);
            }
        }

        pub fn Add(self: *const @This(), other: *const @This()) @This() {

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] + other.data[i];
            }

            return result;
        }

        pub fn Sub(self: *const @This(), other: *const @This()) @This() {

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] - other.data[i];
            }

            return result;
        }

        pub fn Div(self: *const @This(), other: *const @This()) @This() {

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] / other.data[i];
            }

            return result;
        }

        pub fn Mul(self: *const @This(), comptime OtherColumns: u64, other: *const Matrix(SelfColumns,OtherColumns)) Matrix(SelfRows,OtherColumns) {

            if (self.columns != other.rows) {
                @panic("Matrix columns doesn't match with target rows in Mul()");
            }

            const ResultMatrix = Matrix(SelfRows, OtherColumns);
            var result: ResultMatrix = ResultMatrix.init(SelfRows, OtherColumns);

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

        pub fn ElementWise(self: *const @This(), other: *const @This()) @This() {

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] * other.data[i];
            }

            return result;
        }

        pub fn Scale(self: *const @This(), scalar: f32) @This() {
            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] * scalar;
            }

            return result;
        }

        pub fn Transpose(self: *const @This()) Matrix(SelfColumns, SelfRows) {

            const ResultMatrix = Matrix(SelfColumns, SelfRows);
            var result: ResultMatrix = ResultMatrix.init(SelfColumns, SelfRows);

            for (0..self.columns) |i| {
                for (0..self.rows) |j| {
                    result.data[i * self.rows + j] = self.data[j * self.columns + i];
                }
            }

            return result;
        }
        
        //Safe Functions

        pub fn SAdd(self: *const @This(), comptime OtherRows: u64, comptime OtherColumns: u64, other: *const Matrix(OtherRows, OtherColumns)) !@This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                return DimensionMismatch;
            }

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] + other.data[i];
            }

            return result;
        }

        pub fn SSub(self: *const @This(), comptime OtherRows: u64, comptime OtherColumns: u64, other: *const Matrix(OtherRows, OtherColumns)) !@This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                return DimensionMismatch;
            }

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] - other.data[i];
            }

            return result;
        }

        pub fn SDiv(self: *const @This(), comptime OtherRows: u64, comptime OtherColumns: u64, other: *const Matrix(OtherRows, OtherColumns)) !@This() {

            if (self.rows != other.rows or self.columns != other.columns) {
                return DimensionMismatch;
            }

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] / other.data[i];
            }

            return result;
        }

        pub fn SMul(self: *const @This(), comptime OtherRows: u64, comptime OtherColumns: u64, other: *const Matrix(OtherRows,OtherColumns)) !Matrix(SelfRows,OtherColumns) {

            if (self.columns != other.rows) {
                return DimensionMismatch;
            }

            const ResultMatrix = Matrix(SelfRows, OtherColumns);
            var result: ResultMatrix = ResultMatrix.init(SelfRows, OtherColumns);

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

        pub fn SElementWise(self: *const @This(), other: *const @This()) !@This() {
            
            if (self.rows != other.rows or self.columns != other.columns) {
                return DimensionMismatch;
            }

            var result = @This().init(self.rows, self.columns);

            for (0..self.rows * self.columns) | i| {
                result.data[i] = self.data[i] * other.data[i];
            }

            return result;
        }
    };
}