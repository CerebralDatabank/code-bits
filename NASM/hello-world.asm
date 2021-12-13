extern _printf

section .text
    global _main

_main:
    push message
    call _printf
    add esp, 4
    ret

section .data
    message: db "Hello, World!", 0xA, 0