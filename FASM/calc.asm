; calc.asm - FASM 32-bit Win32 console application
; Compile: fasm calc.asm calc.exe
; Run: calc.exe

format PE console
entry start

include 'win32a.inc'

section '.data' data readable writeable
    prompt      db 'Enter: a op b  (op = + - * /, q to quit)', 13, 10, '> ', 0
    resfmt      db '= %.10g', 13, 10, 0
    errfmt      db 'Error: %s', 13, 10, 0
    errdiv      db 'division by zero.', 13, 10, 0
    errop       db 'unknown operator.', 13, 10, 0
    errfmt2     db 'invalid input format.', 13, 10, 0
    fmtin       db '%lf %7s %lf', 0
    qword1      dq 0.0
    qword2      dq 0.0
    qwordr      dq 0.0
    opbuf       rb 8
    linebuf     rb 256
    bytes_read  dd 0
    h_stdin     dd 0
    h_stdout    dd 0

section '.code' code readable executable
start:
    invoke  GetStdHandle, -10
    mov     [h_stdin], eax
    invoke  GetStdHandle, -11
    mov     [h_stdout], eax

.main_loop:
    invoke  printf, prompt
    invoke  fflush, 0

    invoke  ReadFile, [h_stdin], linebuf, 255, bytes_read, 0
    cmp     [bytes_read], 0
    je      .done

    mov     ecx, [bytes_read]
    mov     byte [linebuf + ecx], 0

    lea     esi, [linebuf]
.strip_nl:
    lodsb
    test    al, al
    jz      .parsed
    cmp     al, 10
    jne     .strip_nl
    dec     esi
    mov     byte [esi], 0
.parsed:

    cmp     byte [linebuf], 0
    je      .main_loop

    mov     al, [linebuf]
    or      al, 20h
    cmp     al, 'q'
    je      .done

    invoke  sscanf, linebuf, fmtin, qword1, opbuf, qword2
    cmp     eax, 3
    jne     .bad_format

    mov     al, [opbuf]
    cmp     al, '+'
    je      .add
    cmp     al, '-'
    je      .sub
    cmp     al, '*'
    je      .mul
    cmp     al, '/'
    je      .div
    jmp     .bad_op

.add:
    fld     qword [qword1]
    fadd    qword [qword2]
    fstp    qword [qwordr]
    jmp     .print_result

.sub:
    fld     qword [qword1]
    fsub    qword [qword2]
    fstp    qword [qwordr]
    jmp     .print_result

.mul:
    fld     qword [qword1]
    fmul    qword [qword2]
    fstp    qword [qwordr]
    jmp     .print_result

.div:
    fld     qword [qword2]
    fldz
    fucomip st0, st1
    fstp    st0
    jne     .do_div
    invoke  printf, errfmt, errdiv
    invoke  fflush, 0
    jmp     .main_loop

.do_div:
    fld     qword [qword1]
    fdiv    qword [qword2]
    fstp    qword [qwordr]

.print_result:
    push    dword [qwordr+4]
    push    dword [qwordr]
    push    resfmt
    call    [printf]
    add     esp, 12
    invoke  fflush, 0
    jmp     .main_loop

.bad_format:
    invoke  printf, errfmt, errfmt2
    invoke  fflush, 0
    jmp     .main_loop

.bad_op:
    invoke  printf, errfmt, errop
    invoke  fflush, 0
    jmp     .main_loop

.done:
    invoke  ExitProcess, 0

section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL', \
            msvcrt,   'MSVCRT.DLL'
            
    import  kernel32, \
            GetStdHandle, 'GetStdHandle', \
            ReadFile,     'ReadFile', \
            ExitProcess,  'ExitProcess'
            
    import  msvcrt, \
            printf,       'printf', \
            sscanf,       'sscanf', \
            fflush,       'fflush'