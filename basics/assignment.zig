const std = @import("std");

pub fn arrayBasics() void {
    const vecInt = [_]u32{1, 2, 3};
    std.debug.print("Array size: {d}\n",.{vecInt.len});

    for(vecInt) | num, index | {
        std.debug.print("{d} -> {d}\n",.{index, num});
    }
    for(vecInt) | num | {
        std.debug.print("Item {d}\n",.{num});
    }
    for(vecInt) | _, index | {
        std.debug.print("Index {d}\n",.{index});
    }
}

pub fn main() void {
    var age: u32 = 21;
    age += 21;
    std.debug.print("Value: {d}\n", .{age});
    // explicit conversion
    const some_constant = @as(u64, 5000);
    std.debug.print("Constant: {d}\n", .{some_constant});
    // every constant and variable need a value
    var var_undefined: u8 = undefined;
    std.debug.print("Undefined: {d}\n", .{var_undefined});
    _ = 20;
    arrayBasics();
}
