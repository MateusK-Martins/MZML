const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const tests = b.addTest(.{
        .root_source_file = .{ .cwd_relative = "../src/test_all.zig" },
        .target = target,
    });

    b.step("test", "Roda todos os testes").dependOn(&tests.step);
}
