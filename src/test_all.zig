const std = @import("std");

test {
    _ = @import("matrix/test.zig");
    _ = @import("layers/dense/test.zig");
}
