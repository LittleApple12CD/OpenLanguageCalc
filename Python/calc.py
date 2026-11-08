# calc.py - run: python3 calc.py
import sys

def parse(s: str):
    try:
        v = float(s)
    except ValueError:
        return None
    if v != v or v in (float('inf'), float('-inf')):
        return None
    return v

def main():
    print("Enter: a op b  (op = + - * /, q to quit)")
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        if line.lower() == 'q':
            break
        parts = line.split()
        if len(parts) != 3:
            print("Error: invalid input format.")
            continue
        a, b = parse(parts[0]), parse(parts[2])
        if a is None or b is None:
            print("Error: invalid number.")
            continue
        op = parts[1]
        try:
            if op == '+':   r = a + b
            elif op == '-': r = a - b
            elif op == '*': r = a * b
            elif op == '/':
                if b == 0.0:
                    raise ZeroDivisionError
                r = a / b
            else:
                print(f"Error: unknown operator '{op}'.")
                continue
        except ZeroDivisionError:
            print("Error: division by zero.")
            continue
        print(f"= {r:.10g}")
        sys.stdout.flush()

if __name__ == "__main__":
    main()