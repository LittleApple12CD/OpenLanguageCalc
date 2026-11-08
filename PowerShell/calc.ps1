# calc.ps1 - run: powershell -ExecutionPolicy Bypass -File calc.ps1
Write-Host "Enter: a op b  (op = + - * /, q to quit)"
while ($true) {
    $line = Read-Host ">"
    if ($null -eq $line) { break }
    $line = $line.Trim()
    if ($line -eq '') { continue }
    if ($line -ieq 'q') { break }

    $parts = $line -split '\s+'
    if ($parts.Count -ne 3) { Write-Host "Error: invalid input format."; continue }

    $a = 0.0; $b = 0.0
    if (-not [double]::TryParse($parts[0], [ref]$a) -or
        -not [double]::TryParse($parts[2], [ref]$b)) {
        Write-Host "Error: invalid number."; continue
    }
    if ([double]::IsNaN($a) -or [double]::IsInfinity($a) -or
        [double]::IsNaN($b) -or [double]::IsInfinity($b)) {
        Write-Host "Error: invalid number."; continue
    }

    try {
        switch ($parts[1]) {
            '+' { $r = $a + $b }
            '-' { $r = $a - $b }
            '*' { $r = $a * $b }
            '/' {
                if ($b -eq 0.0) { throw "division by zero" }
                $r = $a / $b
            }
            default { Write-Host "Error: unknown operator '$($parts[1])'."; continue }
        }
        Write-Host ("= " + $r.ToString("G10", [System.Globalization.CultureInfo]::InvariantCulture))
    } catch {
        Write-Host "Error: $($_.Exception.Message)."
    }
}