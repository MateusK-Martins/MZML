const std = @import("std");

pub const Mode = enum {
    Inplace,
    InplaceChain,
    Copy,
    InplaceCopy,
};

pub fn Matrix(comptime Rows: usize, comptime Columns: usize) type {
    return struct {
        pub const SelfRows = Rows;
        pub const SelfColumns = Columns;
        data: [SelfRows * SelfColumns]f32,

        pub fn init() @This() {
            return .{
                .data = [_]f32{0} ** (SelfRows * SelfColumns),
            };
        }

        pub fn Random(
            self: *@This(), 
            comptime mode: Mode,
            rng: *std.Random, 
            range: [2]f32
        ) switch (mode) {
                .Inplace => void,
                .InplaceChain => *@This(),
                .Copy => @This(),
                .InplaceCopy => @This(),
        }   {

            if (mode == .Inplace or mode == .InplaceCopy or mode == .InplaceChain) {
                for (&self.data) |*item| {
                    const raw = rng.float(f32);
                    item.* = range[0] + raw * (range[1] - range[0]);
                }

                if (mode == .Inplace) {
                    return;
                } else if (mode == .InplaceChain) {
                    return self; 
                } else {
                    return self.Copy();
                }
            } else {
                var result = @This().init();

                for (&result.data) |*item| {
                    const raw = rng.float(f32);
                    item.* = range[0] + raw * (range[1] - range[0]);
                }
                return result;
            }
        }

        pub fn Copy(self: @This()) @This() {
            return .{
                .data = self.data
            };
        }

        pub fn Add(
            self: *@This(), 
            comptime mode: Mode, 
            other: *const @This()
        ) switch (mode) {
                .Inplace => void,
                .InplaceChain => *@This(),
                .Copy => @This(),
                .InplaceCopy => @This(),
        }   {

            comptime {
                const OtherType = @typeInfo(@TypeOf(other)).pointer.child;

                if (SelfRows != OtherType.SelfRows or SelfColumns != OtherType.SelfColumns) {
                    @compileError("Dimension mismatch in Add: both matrices must have the same dimensions");
                }
            }

            if (mode == .Inplace or mode == .InplaceCopy or mode == .InplaceChain) {
                for (self.data, 0..) | _, i| {
                    self.data[i] = self.data[i] + other.data[i];
                }

                if (mode == .Inplace) {
                    return;
                } else if (mode == .InplaceChain) {
                    return self; 
                } else {
                    return self.Copy();
                }
            } else {
                var result = @This().init();

                for (result.data, 0..) | _, i| {
                    result.data[i] = self.data[i] + other.data[i];
                }
                return result;
            }
        }

        pub fn Sub(
            self: *@This(), 
            comptime mode: Mode, 
            other: *const @This()
        ) switch (mode) {
                .Inplace => void,
                .InplaceChain => *@This(),
                .Copy => @This(),
                .InplaceCopy => @This(),
        }   {

            comptime {
                const OtherType = @typeInfo(@TypeOf(other)).pointer.child;

                if (SelfRows != OtherType.SelfRows or SelfColumns != OtherType.SelfColumns) {
                    @compileError("Dimension mismatch in Add: both matrices must have the same dimensions");
                }
            }

            if (mode == .Inplace or mode == .InplaceCopy or mode == .InplaceChain) {
                for (self.data, 0..) | _, i| {
                    self.data[i] = self.data[i] - other.data[i];
                }

                if (mode == .Inplace) {
                    return;
                } else if (mode == .InplaceChain) {
                    return self; 
                } else {
                    return self.Copy();
                }
            } else {
                var result = @This().init();

                for (result.data, 0..) | _, i| {
                    result.data[i] = self.data[i] - other.data[i];
                }
                return result;
            }
        }

        pub fn Div(
            self: *@This(), 
            comptime mode: Mode, 
            other: *const @This()
        ) switch (mode) {
                .Inplace => void,
                .InplaceChain => *@This(),
                .Copy => @This(),
                .InplaceCopy => @This(),
        }   {

            comptime {
                const OtherType = @typeInfo(@TypeOf(other)).pointer.child;

                if (SelfRows != OtherType.SelfRows or SelfColumns != OtherType.SelfColumns) {
                    @compileError("Dimension mismatch in Add: both matrices must have the same dimensions");
                }
            }

            if (mode == .Inplace or mode == .InplaceCopy or mode == .InplaceChain) {
                for (self.data, 0..) | _, i| {
                    self.data[i] = self.data[i] / other.data[i];
                }

                if (mode == .Inplace) {
                    return;
                } else if (mode == .InplaceChain) {
                    return self; 
                } else {
                    return self.Copy();
                }
            } else {
                var result = @This().init();

                for (result.data, 0..) | _, i| {
                    result.data[i] = self.data[i] / other.data[i];
                }
                return result;
            }
        }


        pub fn Mul(
            self: *const @This(), 
            comptime MatType: type,
            other: *const MatType
        ) Matrix(SelfRows, MatType.SelfColumns) {

            comptime {
                if (SelfColumns != MatType.SelfRows) {
                    @compileError("Dimension mismatch in Mul: Matrix columns doesn't match with target rows");
                }
            }

            const ResultMatrix = Matrix(SelfRows, MatType.SelfColumns);
            var result: ResultMatrix = ResultMatrix.init();

            for (0..SelfRows) | i| {
                for (0..MatType.SelfColumns) |j| {
                    var sum: f32 = 0.0;
                    for (0..SelfColumns) |k| {
                        sum += self.data[i * SelfColumns + k] * other.data[k * MatType.SelfColumns + j];
                    }
                    result.data[i * MatType.SelfColumns + j] = sum;
                }
            }

            return result;
        }

        pub fn ElementWise(
            self: *@This(), 
            comptime mode: Mode, 
            other: *const @This()
        ) switch (mode) {
                .Inplace => void,
                .InplaceChain => *@This(),
                .Copy => @This(),
                .InplaceCopy => @This(),
        }   {

            comptime {
                const OtherType = @typeInfo(@TypeOf(other)).pointer.child;

                if (SelfRows != OtherType.SelfRows or SelfColumns != OtherType.SelfColumns) {
                    @compileError("Dimension mismatch in Add: both matrices must have the same dimensions");
                }
            }

            if (mode == .Inplace or mode == .InplaceCopy or mode == .InplaceChain) {
                for (self.data, 0..) | _, i| {
                    self.data[i] = self.data[i] * other.data[i];
                }

                if (mode == .Inplace) {
                    return;
                } else if (mode == .InplaceChain) {
                    return self; 
                } else {
                    return self.Copy();
                }
            } else {
                var result = @This().init();

                for (result.data, 0..) | _, i| {
                    result.data[i] = self.data[i] * other.data[i];
                }
                return result;
            }
        }

        pub fn Scale(
            self: *@This(), 
            comptime mode: Mode, 
            scalar: f32
        ) switch (mode) {
                .Inplace => void,
                .InplaceChain => *@This(),
                .Copy => @This(),
                .InplaceCopy => @This(),
        }   {

            if (mode == .Inplace or mode == .InplaceCopy or mode == .InplaceChain) {
                for (self.data, 0..) | _, i| {
                    self.data[i] = self.data[i] * scalar;
                }

                if (mode == .Inplace) {
                    return;
                } else if (mode == .InplaceChain) {
                    return self; 
                } else {
                    return self.Copy();
                }
            } else {
                var result = @This().init();

                for (result.data, 0..) | _, i| {
                    result.data[i] = self.data[i] * scalar;
                }
                return result;
            }
        }

        pub fn Transpose(
            self: *@This(), 
        ) Matrix(SelfColumns, SelfRows) {

            const ResultMatrix = Matrix(SelfColumns, SelfRows);
            var result: ResultMatrix = ResultMatrix.init();

            for (0..SelfColumns) |i| {
                for (0..SelfRows) |j| {
                    result.data[i * SelfRows + j] = self.data[j * SelfColumns + i];
                }
            }

            return result;
        }
    };
}