extern _printf

section .text
    global _main

_main:
    mov ebx, 0
    numloop:
        push ebx
        push fmt_d
        call _printf
        add esp, 8
        inc ebx
        jmp numloop
    ret

section .data
    fmt_d: db "%d", 0xA, 0