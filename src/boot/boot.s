; src/boot/boot.s
MBOOT_PAGE_ALIGN    equ 1 << 0
MBOOT_MEM_INFO      equ 1 << 1
MBOOT_HEADER_MAGIC  equ 0x1BADB002
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

section .multiboot
    align 4
    dd MBOOT_HEADER_MAGIC
    dd MBOOT_HEADER_FLAGS
    dd MBOOT_CHECKSUM

section .bss
align 16
stack_bottom:
    resb 16384 ; 16 KB
stack_top:

section .text
global _start
extern kernel_main ; To musi pasować do nazwy w C!

_start:
    mov esp, stack_top
    push ebx ; Przekazujemy strukturę Multiboot
    call kernel_main
    
    cli
.hang:
    hlt
    jmp .hang

; Sekcja zapobiegająca ostrzeżeniu o "executable stack"
section .note.GNU-stack noalloc noexec nowrite progbits