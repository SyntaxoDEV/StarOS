struct multiboot_info {
    unsigned int flags;
    unsigned int unused[10];
    unsigned int framebuffer_addr;
    unsigned int framebuffer_pitch;
    unsigned int framebuffer_width;
    unsigned int framebuffer_height;
    unsigned char framebuffer_bpp;
};

void kernel_main(struct multiboot_info* mbi) {
    // Sprawdźmy czy GRUB w ogóle podał nam adres
    if (!(mbi->flags & (1 << 11))) {
        // Jeśli tu wejdzie, to znaczy że GRUB nie ustawił trybu graficznego
        // Wtedy na starym porcie tekstowym wypiszemy błąd (0xB8000)
        char* vga = (char*)0xB8000;
        vga[0] = 'E'; vga[1] = 0x0C; // Czerwone 'E'
        while(1);
    }

    unsigned int* fb = (unsigned int*)(unsigned long)mbi->framebuffer_addr;
    
    // ZAMALUJ CAŁY EKRAN NA CZERWONO (Test połączenia)
    // Używamy prostej liczby, bo wiemy że szerokość to 1280
    for (unsigned int i = 0; i < 1280 * 1280; i++) {
        fb[i] = 0xFF0000; // Czysty czerwony
    }

    while(1);
}