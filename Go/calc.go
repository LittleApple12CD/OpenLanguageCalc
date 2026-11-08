// calc.go - run: go run calc.go
package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func parse(s string) (float64, bool) {
	v, err := strconv.ParseFloat(strings.TrimSpace(s), 64)
	if err != nil || math.IsInf(v, 0) || math.IsNaN(v) {
		return 0, false
	}
	return v, true
}

func main() {
	in := bufio.NewScanner(os.Stdin)
	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	fmt.Println("Enter: a op b  (op = + - * /, q to quit)")

	for {
		fmt.Print("> ")
		out.Flush()
		if !in.Scan() {
			break
		}
		line := strings.TrimSpace(in.Text())
		if line == "" {
			continue
		}
		if strings.EqualFold(line, "q") {
			break
		}

		parts := strings.Fields(line)
		if len(parts) != 3 {
			fmt.Println("Error: invalid input format.")
			continue
		}

		a, okA := parse(parts[0])
		b, okB := parse(parts[2])
		if !okA || !okB {
			fmt.Println("Error: invalid number.")
			continue
		}

		var r float64
		switch parts[1] {
		case "+":
			r = a + b
		case "-":
			r = a - b
		case "*":
			r = a * b
		case "/":
			if b == 0 {
				fmt.Println("Error: division by zero.")
				continue
			}
			r = a / b
		default:
			fmt.Printf("Error: unknown operator '%s'.\n", parts[1])
			continue
		}
		fmt.Printf("= %g\n", r)
	}
}