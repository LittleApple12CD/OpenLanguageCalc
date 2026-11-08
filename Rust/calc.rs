// calc.rs - compile: rustc -O calc.rs
use std::io::{self, Write};

fn parse_num(s: &str) -> Option<f64> {
    s.trim().parse::<f64>().ok().filter(|v| v.is_finite())
}

fn main() {
    let stdin = io::stdin();
    let mut stdout = io::stdout();
    println!("Enter: a op b  (op = + - * /, q to quit)");

    loop {
        print!("> ");
        let _ = stdout.flush();

        let mut line = String::new();
        if stdin.read_line(&mut line).unwrap_or(0) == 0 { break; }
        let line = line.trim();
        if line.is_empty() { continue; }
        if line.eq_ignore_ascii_case("q") { break; }

        let parts: Vec<&str> = line.split_whitespace().collect();
        if parts.len() != 3 {
            println!("Error: invalid input format.");
            continue;
        }

        let a = match parse_num(parts[0]) { Some(v) => v, None => { println!("Error: invalid number."); continue; } };
        let b = match parse_num(parts[2]) { Some(v) => v, None => { println!("Error: invalid number."); continue; } };

        let r = match parts[1] {
            "+" => a + b,
            "-" => a - b,
            "*" => a * b,
            "/" => {
                if b == 0.0 { println!("Error: division by zero."); continue; }
                a / b
            }
            op => { println!("Error: unknown operator '{}'.", op); continue; }
        };
        println!("= {}", r);
    }
}