#include "../include/multiboot.h"
#include "../include/screen.h"
#include "../include/io.h"
#include "../include/keyboard.h"
#include "../include/shell.h"
#include "../include/cpu.h"

// DEFINICJA ZMIENNEJ GLOBALNEJ - to tego brakowało linkerowi!
multiboot_info_t* global_mbd;

void kernel_main(multiboot_info_t* mbd) {
    // Przypisujemy adres struktury od GRUBa do naszej zmiennej globalnej
    global_mbd = mbd;

    clear_screen();
    print_str("--- StarOS v0.3 Loaded ---\n");
    print_str("Typuj 'help' aby zobaczyc komendy.\n\n");
    print_str("StarOS> ");

    char buffer[64];
    int buf_idx = 0;
    unsigned char last_scancode = 0;

    while (1) {
        unsigned char scancode = inb(0x60);
        if (scancode != last_scancode) {
            if (!(scancode & 0x80)) { // Key Down
                char c = scancode_to_char(scancode);
                if (scancode == 0x1C) { // ENTER
                    buffer[buf_idx] = '\0';
                    shell_execute(buffer);
                    buf_idx = 0;
                } else if (scancode == 0x0E) { // BACKSPACE
                    if (buf_idx > 0) {
                        buf_idx--;
                        print_char(8);
                    }
                } else if (c && buf_idx < 63) {
                    print_char(c);
                    buffer[buf_idx++] = c;
                }
            }
            last_scancode = scancode;
        }
        // Małe opóźnienie, żeby procesor nie płonął
        for(volatile int d = 0; d < 10000; d++);
    }
}