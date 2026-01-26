ENTRY(_start)
SECTIONS {
    . = 1M; /* StarOS zacznie się od 1 megabajta pamięci */
    .text : { *(.multiboot) *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss)  }
}