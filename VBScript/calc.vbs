' calc.vbs
' Run: cscript //nologo calc.vbs

Option Explicit

Dim line, parts, a, b, op, r, i, n
Dim stdin, stdout

Set stdin = WScript.StdIn
Set stdout = WScript.StdOut

stdout.WriteLine "Enter: a op b  (op = + - * /, q to quit)"

Do While Not stdin.AtEndOfStream
    stdout.Write "> "
    line = stdin.ReadLine
    line = Trim(line)

    If Len(line) = 0 Then
    ElseIf LCase(line) = "q" Then
        Exit Do
    Else
        parts = SplitMultiSpace(line)
        If UBound(parts) <> 2 Then
            stdout.WriteLine "Error: invalid input format."
        Else
            If Not IsNumeric(parts(0)) Or Not IsNumeric(parts(2)) Then
                stdout.WriteLine "Error: invalid number."
            Else
                a = CDbl(parts(0))
                b = CDbl(parts(2))
                op = parts(1)
                r = 0
                Select Case op
                    Case "+"
                        r = a + b
                    Case "-"
                        r = a - b
                    Case "*"
                        r = a * b
                    Case "/"
                        If b = 0 Then
                            stdout.WriteLine "Error: division by zero."
                            op = ""
                        Else
                            r = a / b
                        End If
                    Case Else
                        stdout.WriteLine "Error: unknown operator '" & op & "'."
                        op = ""
                End Select

                If op <> "" Then
                    stdout.WriteLine "= " & FormatNum(r)
                End If
            End If
        End If
    End If
Loop

Function SplitMultiSpace(s)
    Dim re, m
    Set re = New RegExp
    re.Pattern = "\s+"
    re.Global = True
    Dim trimmed
    trimmed = Trim(s)
    If Len(trimmed) = 0 Then
        SplitMultiSpace = Array()
        Exit Function
    End If
    SplitMultiSpace = Split(re.Replace(trimmed, " "), " ")
End Function

Function FormatNum(v)
    Dim s, i
    If v = Int(v) And Abs(v) < 1E+15 Then
        FormatNum = CStr(CLng(v))
    Else
        s = CStr(v)
        s = Replace(s, ",", ".")
        If InStr(s, ".") > 0 Then
            Do While Right(s, 1) = "0"
                s = Left(s, Len(s) - 1)
            Loop
            If Right(s, 1) = "." Then s = Left(s, Len(s) - 1)
        End If
        FormatNum = s
    End If
End Function