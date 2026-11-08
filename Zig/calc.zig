// calc.zig
// zig build-exe calc.zig -O ReleaseFast
// ./calc (Linux) or calc.exe (Windows)

const std = @import("std");

const CalcError = error{
    DivisionByZero,
    UnknownOperator,
};

fn calculate(a: f64, op: u8, b: f64) CalcError!f64 {
    return switch (op) {
        '+' => a + b,
        '-' => a - b,
        '*' => a * b,
        '/' => if (b == 0.0) CalcError.DivisionByZero else a / b,
        else => CalcError.UnknownOperator,
    };
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.Io.File.stdin().reader(io, &stdin_buffer);
    const stdin = &stdin_reader.interface;

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("Enter: a op b  (op = + - * /, q to quit)\n", .{});
    try stdout.flush();

    while (true) {
        try stdout.print("> ", .{});
        try stdout.flush();

        const line_raw = try stdin.takeDelimiter('\n') orelse break;
        const line = std.mem.trimEnd(u8, line_raw, "\r");
        if (line.len == 0) continue;
        if (std.mem.eql(u8, line, "q") or std.mem.eql(u8, line, "Q")) break;

        var it = std.mem.tokenizeAny(u8, line, " \t");
        const sa = it.next() orelse {
            try stdout.print("Error: invalid input format.\n", .{});
            try stdout.flush();
            continue;
        };
        const op_str = it.next() orelse {
            try stdout.print("Error: invalid input format.\n", .{});
            try stdout.flush();
            continue;
        };
        const sb = it.next() orelse {
            try stdout.print("Error: invalid input format.\n", .{});
            try stdout.flush();
            continue;
        };
        if (it.next() != null) {
            try stdout.print("Error: invalid input format.\n", .{});
            try stdout.flush();
            continue;
        }

        const a = std.fmt.parseFloat(f64, sa) catch {
            try stdout.print("Error: invalid number.\n", .{});
            try stdout.flush();
            continue;
        };
        const b = std.fmt.parseFloat(f64, sb) catch {
            try stdout.print("Error: invalid number.\n", .{});
            try stdout.flush();
            continue;
        };

        const r = calculate(a, op_str[0], b) catch |err| {
            switch (err) {
                CalcError.DivisionByZero => try stdout.print("Error: division by zero.\n", .{}),
                CalcError.UnknownOperator => try stdout.print("Error: unknown operator '{s}'.\n", .{op_str}),
            }
            try stdout.flush();
            continue;
        };

        try stdout.print("= {d}\n", .{r});
        try stdout.flush();
    }
}