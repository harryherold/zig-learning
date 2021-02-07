const expect = @import("std").testing.expect;

test "array iteration" {
    const vec = [_]u8{1, 2, 3};
    var sum: u32 = 0;
    for(vec) | num | {
        sum += num;
    }
    expect(sum == 6);

    var sum_index: u64 = 0;
    for(vec) | _, index | {
        sum_index += index;
    }
    expect(sum_index == 3);
}

test "if statement" {
    const a: bool = true;
    var num: u8 = 0;
    if(a) {
        num += 1;
    } else {
        num += 2;
    }
    expect(num == 1);
}

test "if statement expression" {
    const a: bool = true;
    const num: u8 = if(a) 1 else 2;
    expect(num == 1);
}

test "while without continuation expression" {
    var num: u8 = 2;
    while(num < 100) {
        num *= 2;
    }
    expect(num == 128);
}

test "while with continuation expression" {
    var i: u32 = 0;
    var sum: u32 = 0;
    while(i < 11) : (i += 1) {
        sum += i;
    }
    expect(sum == 55);
}

test "while with continuation expression and break" {
    var i: u32 = 0;
    var sum: u32 = 0;
    while(i < 4) : (i += 1) {
        if(i == 2) break;
        sum += i;
    }
    expect(sum == 1);
}

fn addNumbers(a: u32, b: u32) u32 {
    return a + b;
}

test "test custom function add" {
    const x = addNumbers(1, 2);
    expect(@TypeOf(x) == u32);
    expect(x == 3);
}

fn fibonacci(n: u16) u16 {
    if(n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "test fibonacci" {
    const x = fibonacci(10);
    expect(x == 55);
}

test "defer single value" {
    var x: u8 = 5;
    {
        defer x += 2;
        expect(x == 5);
    }
    expect(x == 7);
}

test "defer multiple values" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    expect(x == 4.5);
}

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound
};

const AllocationError = error{OutOfMemory};

test "coerce error from a subset to a superset" {
    const err: FileOpenError = FileOpenError.OutOfMemory;
    expect(err == FileOpenError.OutOfMemory);
}

test "error union" {
    const maybe_error: AllocationError! u16 = 10;
    const no_error = maybe_error catch 0;

    expect(@TypeOf(no_error) == u16);
    expect(no_error == 10);
}

fn fallingFunction() error{Oops}! void {
    return error.Oops;
}

test "Function returns error" {
    fallingFunction() catch | err | {
        expect(err == error.Oops);
        return;
    };
}

fn failFn() error{Oops}! u32 {
    try fallingFunction();
    return 12;
}

test "try" {
    var val = failFn() catch | err | {
        expect(err == error.Oops);
        return;
    };
    expect(val == 12); // not reached cause of the exception
}

var error_problems: u32 = 98;

fn failFnCounter() error{Oops}! void {
    errdefer error_problems += 1;
    try fallingFunction();
}

test "errdefer" {
    failFnCounter() catch | err | {
        expect(err == error.Oops);
        expect(error_problems == 99);
    };
}

fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    const x: error{AccessDenied} !void = createFile();
}

test "switch statement" {
    var x: i8 = 10;
    switch(x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            x = @divExact(x, 10);
        },
        else => {},
    }
    expect(x == 1);
}

test "switch expression" {
    var x: i8 = 10;
    x = switch(x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    expect(x == 1);
}

test "unreachable" {
    // const x: u8 = 1; 
    // => will cause a panic because the unreachable was reached
    const x: u8 = 2;
    const y: u8 = if(x == 2) 5 else unreachable;
}

fn asciiToUpper(c: u8) u8 {
    return switch(c) {
        'a'...'z' => c + 'A' - 'a',
        'A'...'Z' => c,
        else => unreachable,
    };
}

test "test ascii to upper" {
    expect(asciiToUpper('a') == 'A');
    expect(asciiToUpper('A') == 'A');
}

// Next pointers