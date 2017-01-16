; Jacob Laney
; January 2016
;
; 32 Bit NASM x86 for macOS Sierra
;
; Objective: Write a library in NASM x86 similar to the
; C library string.h


global _jpl_strcmp

section .data

section .text
    syscall:
        int 80h
        ret
    ; int jpl_strcmp(const char * str1, const char * str2);
    _jpl_strcmp:
        push ebp
        mov ebp, esp

        push esi
        push edi

            mov esi, [ebp + 8] ; str 1
            mov edi, [ebp + 12] ; str2

            L1:
                mov al, byte [edi]
                cmp byte [esi], al
                jne END_L1
                    cmp byte[edi], 0
                    je Equal
                        inc esi
                        inc edi
                        jmp L1
            END_L1:
            ja Greater
            je Equal
            jb Less
            Greater:
                mov eax, 100
                jmp Return
            Equal:
                mov eax, 0
                jmp Return
            Less:
                mov eax, -9
                jmp Return

        Return:
            pop edi
            pop esi

            mov esp, ebp
            pop ebp


            ret
