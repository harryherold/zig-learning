const expect = @import("std").testing.expect;

test "out of bound access" {
    var vec = [_]u8{1, 2, 3};
    const index: u8 = vec.len;
    vec[index] = 8;
}

test "out of bound access no safety" {
    @setRuntimeSafety(false);
    const vec = [_]u8{1, 2, 3};
    const index: u8 = vec.len;
    const a = vec[index];
}
