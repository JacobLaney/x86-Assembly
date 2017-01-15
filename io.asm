; Jacob Laney
; January 2016
;
; 32 Bit NASM x86 for macOS Sierra
;
; build: clang -arch i386 -c headers.c
;        nasm -f macho32 io.asm
;        clang -arch i386 headers.o io.o -o io.out
; run:  ./io.out
;
; Objective: Learn to incorporate C functions
;
; Prompts for Name and Age then outputs user's input
;
; incorporates system calls and C library functions
;
; includes a procedure to trim newline characters from
; a string buffer
;
; Example Run:
;   Please Enter Your Name: Jacob Laney
;   Please Enter Your Age: 20
;
;   Name:  Jacob Laney
;   Age:  20



; ************ MUST LINK stdio.h ************
global start
global _main

extern _printf
extern _scanf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data
    ; File Descriptor Numbers
    %define stdin_fd    0
    %define stdout_fd   1
    %define stdout_fd   2
    ; SYSCALL CODES
    %define exit    1
    %define read    3
    %define write   4

    name_prompt: db "Please Enter Your Name: ", 0
        .len: equ $ - name_prompt
    name_buffer:  times 100 db 0
        .len: equ $ - name_buffer
    name_output: db "Name:  ", 0
        .len: equ $ - name_output
    name_format_output: db "%s", 10, 0

    age: dd 100

    age_prompt: db "Please Enter Your Age: ", 0
        .len: equ $ - age_prompt
    age_output: db "Age:  ", 0
        .len: equ $ - age_output
    age_format_input: db "%d", 0
    age_format_output: db "%d", 10, 0

    crlf: db " ", 10, 0
        .len: equ $ - crlf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text

; procedure, call the system interrupt
syscall:
    int 80h
    ret

; remove all newline character from a string buffer
; replace with a space character
;
; trim (char * string, size_t len)
trim:
    push ebp
    mov ebp, esp
        push ecx
        push esi
            mov ecx, [ebp + 12]
            mov esi, [ebp + 8]
            L1:
                cmp byte [esi], 10
                jne Not_Newline
                mov byte [esi], 30
                Not_Newline:
                inc esi
                loop L1
        pop esi
        pop ecx
    mov esp, ebp
    pop ebp
    ret

; main procedure
_main:
    push ebp    ; prepare the stack
    mov ebp, esp
    ;push count

        ; prompt for name
        push name_prompt.len
        push name_prompt
        push stdout_fd
        mov eax, write
            call syscall
        add esp, 12

        push name_buffer.len
        push name_buffer
        push stdout_fd
        mov eax, read
            call syscall
        add esp, 12

        ; trim newline characters off of name_buffer
        push name_buffer.len
        push name_buffer
            call trim
        add esp, 8

        ; prompt for age
        push age_prompt.len
        push age_prompt
        push stdout_fd
        mov eax, write
            call syscall
        add esp, 12

        push age
        push age_format_input
            call _scanf
        add esp, 8

        ; output newline
        push crlf.len
        push crlf
        push stdout_fd
        mov eax, write
            call syscall
        add esp, 12

        ; output name
        push name_output.len
        push name_output
        push stdout_fd
        mov eax, write
            call syscall
        add esp, 12

        push name_buffer
        push name_format_output
            call _printf
        add esp, 8

        ; ouput age
        push age_output.len
        push age_output
        push stdout_fd
        mov eax, write
            call syscall
        add esp, 12

        push dword [age]
        push age_format_output
            call _printf
        add esp, 8

    mov esp, ebp ; clean up the stack
    pop ebp

    ; exit (rval)
    mov eax, exit
    push 0
        call syscall ; return 0
