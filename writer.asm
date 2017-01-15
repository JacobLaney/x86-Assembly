; Jacob Laney
; January 2016
;
; NASM x86 for Mac OSX
; build:    nasm -f macho64 writer.asm && ld writer.o -o writer
; run:      ./writer
;
; Obective is to produce an assortment of procedures for printing data
; to stdout

global start

section .data
    ; SYSTEM CALL CODES
    %define exit    0x2000001
    %define read    0x2000003
    %define write   0x2000004

    msg:    db      "Hello World!", 10, 0
    .len:   equ     $ - msg

section .text
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    start:
        default rel ; use relative addressing

        mov rsi, msg
        call WriteStr

        mov rax, exit
        mov rdi, 0
        syscall
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; WriteStr(char * message)
    ; input:
    ;   rsi - address of 0 terminated string max 100 chars
    ; output:
    ;   prints string to stdout
    WriteStr:
        push rax
        push rdx
        push rdi

        push rsi
        push rcx
            mov ecx, 100    ; max 100 rep
            mov rdx, 0      ; count length of string
            StrLenCountLoop:    ; check for termination of string
                cmp byte [rsi], 0
                pushf
                    inc rsi ; move to next address in string
                    inc rdx ; increment size of string
                popf
                loopne StrLenCountLoop
        pop rcx
        pop rsi

        mov rax, write
        mov rdi, 1  ; stdout
        syscall ; write the string

        Return:
            pop rdi
            pop rdx
            pop rax
            ret
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
