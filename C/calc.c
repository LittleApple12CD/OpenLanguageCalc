/* calc.c - compile: gcc -O2 -o calc calc.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

static int read_line(char *buf, size_t size) {
    if (!fgets(buf, (int)size, stdin)) return 0;
    size_t len = strlen(buf);
    if (len && buf[len - 1] == '\n') buf[len - 1] = '\0';
    else { int c; while ((c = getchar()) != '\n' && c != EOF); }
    return 1;
}

static int parse_double(const char *s, double *out) {
    if (!s || !*s) return 0;
    errno = 0;
    char *end;
    double v = strtod(s, &end);
    while (*end == ' ' || *end == '\t') end++;
    if (*end != '\0' || errno == ERANGE) return 0;
    *out = v;
    return 1;
}

int main(void) {
    char line[256], ops[8];
    double a, b, r;

    for (;;) {
        printf("Enter: a op b  (op = + - * /, q to quit)\n> ");
        fflush(stdout);
        if (!read_line(line, sizeof line)) break;
        if (line[0] == 'q' || line[0] == 'Q') break;
        if (sscanf(line, "%lf %7s %lf", &a, ops, &b) != 3) {
            printf("Error: invalid input format.\n");
            continue;
        }
        switch (ops[0]) {
            case '+': r = a + b; break;
            case '-': r = a - b; break;
            case '*': r = a * b; break;
            case '/':
                if (b == 0.0) { printf("Error: division by zero.\n"); continue; }
                r = a / b; break;
            default:
                printf("Error: unknown operator '%s'.\n", ops); continue;
        }
        printf("= %.10g\n", r);
    }
    return 0;
}