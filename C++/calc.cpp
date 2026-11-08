// calc.cpp - compile: g++ -O2 -std=c++17 -o calc calc.cpp
#include <iostream>
#include <sstream>
#include <string>
#include <charconv>
#include <cmath>

static bool parse_double(const std::string& s, double& out) {
    if (s.empty()) return false;
    const char* first = s.data();
    const char* last  = s.data() + s.size();
    auto res = std::from_chars(first, last, out);
    return res.ec == std::errc() && res.ptr == last;
}

int main() {
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
    std::cout << "Enter: a op b  (op = + - * /, q to quit)\n";
    std::string line;
    while (true) {
        std::cout << "> " << std::flush;
        if (!std::getline(std::cin, line)) break;
        if (line == "q" || line == "Q") break;
        std::istringstream iss(line);
        std::string sa, op, sb;
        if (!(iss >> sa >> op >> sb)) { std::cout << "Error: invalid input format.\n"; continue; }
        double a, b, r;
        if (!parse_double(sa, a) || !parse_double(sb, b)) {
            std::cout << "Error: invalid number.\n"; continue;
        }
        switch (op[0]) {
            case '+': r = a + b; break;
            case '-': r = a - b; break;
            case '*': r = a * b; break;
            case '/':
                if (b == 0.0) { std::cout << "Error: division by zero.\n"; continue; }
                r = a / b; break;
            default:
                std::cout << "Error: unknown operator '" << op << "'.\n"; continue;
        }
        std::cout << "= " << r << "\n";
    }
    return 0;
}