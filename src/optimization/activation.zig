const std = @import("std");
const matrix = @import("../lib.zig").matrix;

pub fn Activation(comptime Rows: u64, comptime Columns: u64) type {
    return struct {
        forward: fn (*matrix.Matrix(Rows, Columns)) void,
        backward: fn (*matrix.Matrix(Rows, Columns)) void,

        pub fn relu() Activation {
            return Activation{
                .forward = reluForward,
                .backward = reluBackward,
            };
        }

        pub fn sigmoid() Activation {
            return Activation{
                .forward = sigmoidForward,
                .backward = sigmoidBackward,
            };
        }

        fn reluForward(x: *matrix.Matrix(Rows, Columns)) void {
            for (&x.data) |*d| {
                d.* = if (d.* > 0.0) d.* else 0.0;
            }
        }

        fn reluBackward(x: *matrix.Matrix(Rows, Columns)) void {
            for (&x.data) |*d| {
                d.* = if (d.* > 0.0) 1.0 else 0.0;
            }
        }

        fn sigmoidForward(x: *matrix.Matrix(Rows, Columns)) void {
            for (&x.data) |*d| {
                d.* = 1.0 / (1.0 + @exp(-d.*));
            }
        }
        fn sigmoidBackward(x: *matrix.Matrix(Rows, Columns)) void {
            for (&x.data) |*d| {
                const s = 1.0 / (1.0 + @exp(-d.*));
                d.* = s * (1.0 - s);
            }
        }

    };
    
}