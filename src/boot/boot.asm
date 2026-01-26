bits 32
section .multiboot
    dd 0x1BADB002               ; Magic
    dd 0x00000005               ; Aligns + Graphics flag
    dd -(0x1BADB002 + 0x00000005)
    
    ; Dane graficzne dla GRUBa
    dd 0, 0, 0, 0, 0
    dd 0                        ; 0 = tryb liniowy
    dd 1280                     ; Szerokość
    dd 720                      ; Wysokość
    dd 32                       ; BPP

section .text
global _start
extern kernel_main

_start:
    mov esp, stack_top          ; USTAWIENIE STOSU - bez tego C nie zadziała!
    push ebx                    ; Przekaż dane o grafice
    call kernel_main
    hlt

section .bss
align 16
stack_bottom:
resb 16384                      ; 16 KB miejsca na stos
stack_top: