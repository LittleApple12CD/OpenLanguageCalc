; calc_mingw.asm
; 汇编: nasm -f win64 calc_mingw.asm -o calc_mingw.obj
; 链接: gcc calc_mingw.obj -o calc_mingw.exe

default rel

extern printf
extern sscanf
extern fflush
extern fgets
extern __acrt_iob_func

global main

section .data
    prompt   db "Enter: a op b  (op = + - * /, q to quit)", 10, "> ", 0
    fmtin    db "%lf %7s %lf", 0
    fmtres   db "= %.10g", 10, 0
    fmterr   db "Error: %s", 10, 0
    s_div    db "division by zero.", 0
    s_op     db "unknown operator.", 0
    s_fmt    db "invalid input format.", 0
    opbuf    times 8 db 0
    linebuf  times 256 db 0
    a        dq 0.0
    b        dq 0.0
    r        dq 0.0
    stdin_p  dq 0
    stdout_p dq 0

section .text
main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 64

    ; 预取 stdout（fd=1）
    mov     ecx, 1
    call    __acrt_iob_func
    mov     [stdout_p], rax

    ; 预取 stdin（fd=0）
    xor     ecx, ecx
    call    __acrt_iob_func
    mov     [stdin_p], rax

main_loop:
    ; printf(prompt)
    lea     rcx, [prompt]
    xor     edx, edx
    call    printf

    ; fflush(stdout)
    mov     rcx, [stdout_p]
    call    fflush

    ; fgets(linebuf, 256, stdin)
    lea     rcx, [linebuf]
    mov     edx, 256
    mov     r8,  [stdin_p]
    call    fgets
    test    rax, rax
    jz      main_done

    ; 去换行
    lea     rsi, [linebuf]
main_strip:
    mov     al, [rsi]
    test    al, al
    jz      main_parsed
    cmp     al, 10
    je      main_kill
    inc     rsi
    jmp     main_strip
main_kill:
    mov     byte [rsi], 0

main_parsed:
    cmp     byte [linebuf], 0
    je      main_loop
    mov     al, [linebuf]
    or      al, 0x20
    cmp     al, 'q'
    je      main_done

    ; sscanf(linebuf, "%lf %7s %lf", &a, opbuf, &b)
    lea     rcx, [linebuf]
    lea     rdx, [fmtin]
    lea     r8,  [a]
    lea     r9,  [opbuf]
    lea     rax, [b]
    mov     [rsp+32], rax
    xor     eax, eax
    call    sscanf
    cmp     eax, 3
    jne     main_badfmt

    mov     al, [opbuf]
    cmp     al, '+'
    je      main_add
    cmp     al, '-'
    je      main_sub
    cmp     al, '*'
    je      main_mul
    cmp     al, '/'
    je      main_div
    jmp     main_badop

main_add:
    movsd   xmm0, [a]
    addsd   xmm0, [b]
    jmp     main_store
main_sub:
    movsd   xmm0, [a]
    subsd   xmm0, [b]
    jmp     main_store
main_mul:
    movsd   xmm0, [a]
    mulsd   xmm0, [b]
    jmp     main_store
main_div:
    movsd   xmm1, [b]
    xorpd   xmm2, xmm2
    ucomisd xmm1, xmm2
    jne     main_divok
    lea     rcx, [fmterr]
    lea     rdx, [s_div]
    xor     eax, eax
    call    printf
    jmp     main_loop
main_divok:
    movsd   xmm0, [a]
    divsd   xmm0, [b]
main_store:
    movsd   [r], xmm0
    lea     rcx, [fmtres]
    movsd   xmm1, [r]
    movq    rdx, xmm1
    mov     eax, 1
    call    printf
    jmp     main_loop

main_badfmt:
    lea     rcx, [fmterr]
    lea     rdx, [s_fmt]
    xor     eax, eax
    call    printf
    jmp     main_loop
main_badop:
    lea     rcx, [fmterr]
    lea     rdx, [s_op]
    xor     eax, eax
    call    printf
    jmp     main_loop

main_done:
    xor     eax, eax
    leave
    ret