"use strict";
// calc.ts
// Compile: tsc calc.ts
// 运行: node calc.js
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const readline = __importStar(require("readline"));
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});
function ask(prompt) {
    return new Promise((resolve) => rl.question(prompt, resolve));
}
function parseNumber(s) {
    if (s.trim() === '')
        return null;
    const v = Number(s);
    if (!Number.isFinite(v))
        return null;
    return v;
}
function formatResult(n) {
    if (Number.isInteger(n) && Math.abs(n) < 1e15)
        return n.toString();
    return n.toPrecision(12).replace(/\.?0+$/, '');
}
async function main() {
    console.log('Enter: a op b  (op = + - * /, q to quit)');
    while (true) {
        const line = (await ask('> ')).trim();
        if (line === '')
            continue;
        if (line.toLowerCase() === 'q')
            break;
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
        let r;
        switch (op) {
            case '+':
                r = a + b;
                break;
            case '-':
                r = a - b;
                break;
            case '*':
                r = a * b;
                break;
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
