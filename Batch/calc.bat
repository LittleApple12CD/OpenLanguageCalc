@echo off
setlocal enabledelayedexpansion
title Calculator (Batch)
echo Enter: a op b  (op = + - * /, q to quit)

:loop
set "line="
set /p "line=> "
if not defined line goto loop
if /i "!line!"=="q" goto :eof

set "A="
set "OP="
set "B="
for /f "tokens=1,2,3" %%a in ("!line!") do (
    set "A=%%a"
    set "OP=%%b"
    set "B=%%c"
)
if not defined B (
    echo Error: invalid input format.
    goto loop
)

call :tofixed "!A!" FA
if errorlevel 1 ( echo Error: invalid number. & goto loop )
call :tofixed "!B!" FB
if errorlevel 1 ( echo Error: invalid number. & goto loop )

set /a "IA=FA"
set /a "IB=FB"
set "R="

if "!OP!"=="+" set /a "R=IA+IB"
if "!OP!"=="-" set /a "R=IA-IB"
if "!OP!"=="*" (
    set /a "R=(IA/1000)*(IB/1000)"
)
if "!OP!"=="/" (
    if !IB!==0 (
        echo Error: division by zero.
        goto loop
    )
    set /a "R=(IA*1000000)/IB"
)

if not defined R (
    echo Error: unknown operator '!OP!'.
    goto loop
)

call :fromfixed !R!
echo = !RESULT!
set "R="
set "RESULT="
goto loop

:tofixed
set "s=%~1"
set "neg=0"
if "!s:~0,1!"=="-" ( set "neg=1" & set "s=!s:~1!" )
if "!s!"=="" exit /b 1

set "int="
set "frac="
for /f "tokens=1,2 delims=." %%i in ("!s!") do (
    set "int=%%i"
    set "frac=%%j"
)

if "!int!"=="" set "int=0"
for /f "delims=0123456789" %%x in ("!int!") do exit /b 1

if "!frac!"=="" set "frac=0"
set "frac=!frac!000000"
set "frac=!frac:~0,6!"

:lz_frac
if "!frac:~0,1!"=="0" if not "!frac!"=="0" (
    set "frac=!frac:~1!"
    goto lz_frac
)
if "!frac!"=="" set "frac=0"

:lz_int
if "!int:~0,1!"=="0" if not "!int!"=="0" (
    set "int=!int:~1!"
    goto lz_int
)
if "!int!"=="" set "int=0"

set /a "v=int*1000000+frac" 2>nul
if errorlevel 1 exit /b 1

if "!neg!"=="1" set /a "v=-v"
set "%2=!v!"
exit /b 0

:fromfixed
set "v=%~1"
set "neg=0"
if !v! lss 0 ( set "neg=1" & set /a "v=-v" )

set /a "ip=v/1000000"
set /a "fp=v%%1000000"

if !fp!==0 (
    set "RESULT=!ip!"
) else (
    set "fps=000000!fp!"
    set "fps=!fps:~-6!"
    :trimz
    if "!fps:~-1!"=="0" (
        set "fps=!fps:~0,-1!"
        if not "!fps!"=="" goto trimz
    )
    if "!fps!"=="" (
        set "RESULT=!ip!"
    ) else (
        set "RESULT=!ip!.!fps!"
    )
)

if "!neg!"=="1" set "RESULT=-!RESULT!"
exit /b 0