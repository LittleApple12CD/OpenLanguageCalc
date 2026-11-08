// calc.kt
// 编译: kotlinc calc.kt -include-runtime -d calc.jar
// 运行: java -jar calc.jar

import kotlin.system.exitProcess

fun formatResult(r: Double): String {
    if (r.isNaN() || r.isInfinite()) return r.toString()
    if (r == Math.floor(r) && Math.abs(r) < 1e15) {
        return r.toLong().toString()
    }
    return r.toString()
}

fun main() {
    println("Enter: a op b  (op = + - * /, q to quit)")

    while (true) {
        print("> ")
        System.out.flush()

        val line = readlnOrNull()?.trim() ?: break
        if (line.isEmpty()) continue
        if (line.equals("q", ignoreCase = true)) break

        val parts = line.split(Regex("\\s+"))
        if (parts.size != 3) {
            println("Error: invalid input format.")
            continue
        }

        val a = parts[0].toDoubleOrNull()
        val b = parts[2].toDoubleOrNull()
        if (a == null || b == null || a.isNaN() || a.isInfinite() || b.isNaN() || b.isInfinite()) {
            println("Error: invalid number.")
            continue
        }

        val op = parts[1]
        val r: Double = when (op) {
            "+" -> a + b
            "-" -> a - b
            "*" -> a * b
            "/" -> {
                if (b == 0.0) {
                    println("Error: division by zero.")
                    continue
                }
                a / b
            }
            else -> {
                println("Error: unknown operator '$op'.")
                continue
            }
        }

        println("= ${formatResult(r)}")
    }
}