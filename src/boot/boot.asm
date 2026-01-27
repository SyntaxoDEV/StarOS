MBALIGN  equ  1 << 0
MEMINFO  equ  1 << 1
VIDEO_MODE equ 1 << 2          ; Flaga trybu graficznego
FLAGS    equ  MBALIGN | MEMINFO | VIDEO_MODE
MAGIC    equ  0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM
    ; Rezerwacja miejsca na parametry graficzne (Multiboot 1)
    dd 0, 0, 0, 0, 0
    dd 0                ; 0 = tryb graficzny
    dd 1024             ; Szerokość
    dd 768              ; Wysokość
    dd 32               ; Głębia kolorów (32-bit RGB)

section .bss
align 16
stack_bottom:
    resb 16384 ; 16 KiB stosu
stack_top:

section .text
global _start:function (_start.end - _start)
_start:
    mov esp, stack_top    ; Ustawienie stosu
    extern kernel_main
    call kernel_main      ; Skok do kodu w C

    cli
.hang:  hlt               ; Pętla nieskończona, jeśli kernel wróci
    jmp .hang
.end: