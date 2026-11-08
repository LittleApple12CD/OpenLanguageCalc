// calc.js - run: node calc.js
const readline = require('readline');

const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
const ask = (q) => new Promise(res => rl.question(q, res));

const OPS = {
  '+': (a, b) => a + b,
  '-': (a, b) => a - b,
  '*': (a, b) => a * b,
  '/': (a, b) => {
    if (b === 0) throw new Error('division by zero');
    return a / b;
  },
};

const fmt = (n) => {
  if (!Number.isFinite(n)) return String(n);
  const s = n.toPrecision(15).replace(/\.?0+$/, '');
  return s === '-0' ? '0' : s;
};

(async () => {
  console.log('Enter: a op b  (op = + - * /, q to quit)');
  for (;;) {
    const line = (await ask('> ')).trim();
    if (line === '') continue;
    if (line.toLowerCase() === 'q') break;

    const parts = line.split(/\s+/);
    if (parts.length !== 3) { console.log('Error: invalid input format.'); continue; }

    const a = Number(parts[0]);
    const b = Number(parts[2]);
    if (!Number.isFinite(a) || !Number.isFinite(b)) {
      console.log('Error: invalid number.'); continue;
    }

    const fn = OPS[parts[1]];
    if (!fn) { console.log(`Error: unknown operator '${parts[1]}'.`); continue; }

    try {
      console.log('= ' + fmt(fn(a, b)));
    } catch (e) {
      console.log('Error: ' + e.message + '.');
    }
  }
  rl.close();
})();