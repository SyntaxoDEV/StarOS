#include "../include/shell.h"
#include "../include/screen.h"
#include "../include/io.h"
#include "../include/cpu.h"
#include "../include/multiboot.h"

// Musimy mieć dostęp do danych multiboot w shellu
extern multiboot_info_t* global_mbd; 

int strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) { s1++; s2++; }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

void shell_execute(char* cmd) {
    print_char('\n');

    if (strcmp(cmd, "hello") == 0) {
        print_str("StarOS System Ready.");
    } 
    else if (strcmp(cmd, "clear") == 0) {
        clear_screen();
    } 
    else if (strcmp(cmd, "cpu") == 0) {
        print_cpu_info();
    } 
    else if (strcmp(cmd, "mem") == 0) {
        unsigned int total_ram = (global_mbd->mem_upper + 1024) / 1024;
        print_str("Dostepna pamiec RAM: ");
        print_int(total_ram);
        print_str(" MB");
    } 
    else if (strcmp(cmd, "reboot") == 0) {
        print_str("Restartowanie...");
        unsigned char good = 0x02;
        while (good & 0x02) good = inb(0x64);
        outb(0x64, 0xFE);
    } 
    else if (cmd[0] != '\0') {
        print_str("Blad: Nieznana komenda '");
        print_str(cmd);
        print_str("'");
    }

    if (strcmp(cmd, "clear") != 0) {
        print_str("\nStarOS> ");
    } else {
        print_str("StarOS> ");
    }
}