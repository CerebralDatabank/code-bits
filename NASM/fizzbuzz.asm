; FizzBuzz solution in Windows NASM
; By Gopal Othayoth

extern _printf

section .text
    global _main

_main:
    mov edx, intro_msg
    call print

    mov ebx, 100  ; Loop goes from 1 to 100
    numloop:
        inc dword [num]

        ; Division: [edx:eax] / [ecx] = eax remainder edx
        ; Division by 15 (divisible by both 3 and 5)
        mov edx, 0
        mov eax, [num]
        mov ecx, 15
        div ecx
        
        cmp edx, 0
        jz print_fizzbuzz

        ; Division by 3
        mov edx, 0
        mov eax, [num]
        mov ecx, 3
        div ecx
        
        cmp edx, 0
        jz print_fizz

        ; Division by 5
        mov edx, 0
        mov eax, [num]
        mov ecx, 5
        div ecx
        
        cmp edx, 0
        jz print_buzz

        ; Print the number if neither Fizz nor Buzz
        jmp print_num

        print_fizz:
            mov edx, fizz
            call print
            jmp numloop_iter  ; Continue to next iteration
        
        print_buzz:
            mov edx, buzz
            call print
            jmp numloop_iter

        print_fizzbuzz:
            mov edx, fizzbuzz
            call print
            jmp numloop_iter
        
        print_num:
            push dword [num]
            push fmt_d
            call _printf
            add esp, 8
            jmp numloop_iter

        numloop_iter:
            dec ebx
            cmp ebx, 0
            jnz numloop
    
    mov edx, done_msg
    call print
    ret

print:
    push edx
    call _printf
    add esp, 4
    ret

section .data
    intro_msg: db "FizzBuzz up to 100", 0xA, 0
    done_msg: db "Done!", 0xA, 0
    fmt_d: db "%d", 0xA, 0
    fizz: db "Fizz", 0xA, 0
    buzz: db "Buzz", 0xA, 0
    fizzbuzz: db "FizzBuzz", 0xA, 0
    num: dd 0