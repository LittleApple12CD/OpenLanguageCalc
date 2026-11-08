// calc.ts
// Compile: tsc calc.ts
// 运行: node calc.js

import * as readline from 'readline';

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

function ask(prompt: string): Promise<string> {
    return new Promise((resolve) => rl.question(prompt, resolve));
}

function parseNumber(s: string): number | null {
    if (s.trim() === '') return null;
    const v = Number(s);
    if (!Number.isFinite(v)) return null;
    return v;
}

function formatResult(n: number): string {
    if (Number.isInteger(n) && Math.abs(n) < 1e15) return n.toString();
    return n.toPrecision(12).replace(/\.?0+$/, '');
}

async function main(): Promise<void> {
    console.log('Enter: a op b  (op = + - * /, q to quit)');

    while (true) {
        const line = (await ask('> ')).trim();
        if (line === '') continue;
        if (line.toLowerCase() === 'q') break;

        const parts = line.split(/\s+/);
        if (parts.length !== 3) {
            console.log('Error: invalid input format.');
            continue;
        }

        const a = parseNumber(parts[0]);
        const b = parseNumber(parts[2]);
        if (a === null || b === null) {
            console.log('Error: invalid number.');
            continue;
        }

        const op = parts[1];
        let r: number;
        switch (op) {
            case '+': r = a + b; break;
            case '-': r = a - b; break;
            case '*': r = a * b; break;
            case '/':
                if (b === 0) {
                    console.log('Error: division by zero.');
                    continue;
                }
                r = a / b;
                break;
            default:
                console.log(`Error: unknown operator '${op}'.`);
                continue;
        }

        console.log(`= ${formatResult(r)}`);
    }

    rl.close();
}

main();