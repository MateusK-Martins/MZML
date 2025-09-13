pub const std = @import("std");
pub const matrix = @import("matrix/matrix.zig");

pub fn main() void {
    var a = matrix.Matrix(2, 2).init();
    a.data = [_]f32{ 1.0, 2.0, 3.0, 4.0 };

    var b = matrix.Matrix(2, 2).init();
    b.data = [_]f32{ 5.0, 6.0, 7.0, 8.0 };

    const result = a
        .Add(.InplaceChain, &b)         
        .Sub(.InplaceChain, &b)   
        .Add(.InplaceChain, &a); 

    for (result.data, 0..) |val, i| {
        std.debug.print("[{}] = {}\n", .{ i, val });
    }
}