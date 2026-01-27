#include "common.h"

// Adres fizyczny ramki obrazu (może się różnić, zależy od QEMU/Karty)
// W wersji profesjonalnej pobieramy go z mbi->framebuffer_addr
uint32_t* framebuffer = (uint32_t*)0xFD000000;

void put_pixel(int x, int y, uint32_t color) {
    framebuffer[y * 1024 + x] = color;
}

void clear_screen_graphic(uint32_t color) {
    for (int i = 0; i < 1024 * 768; i++) {
        framebuffer[i] = color;
    }
}

void kernel_main(void* mbi) {
    // Ciemne, gwieździste niebo dla StarOS
    clear_screen_graphic(0x000011); // Bardzo ciemny niebieski

    // Rysujemy prosty kwadrat (nasza "gwiazda")
    for(int y = 100; y < 110; y++) {
        for(int x = 100; x < 110; x++) {
            put_pixel(x, y, 0xFFFFFF); // Biały
        }
    }
}