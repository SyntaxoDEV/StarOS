#include "../include/screen.h"
#include "../include/io.h"

#define VIDEO_MEM ((unsigned short*)0xB8000)
static int term_col = 0;
static int term_row = 0;

// Czyścimy ekran wypełniając go spacjami z szarym kolorem (0x07)
void clear_screen() {
    for (int i = 0; i < 80 * 25; i++) {
        VIDEO_MEM[i] = (0x07 << 8) | ' ';
    }
    term_col = 0;
    term_row = 0;
}

void scroll() {
    // Przesuń wszystkie linie o jedną w górę
    for (int i = 0; i < 24 * 80; i++) {
        VIDEO_MEM[i] = VIDEO_MEM[i + 80];
    }
    // Wyczyść ostatnią linię
    for (int i = 24 * 80; i < 25 * 80; i++) {
        VIDEO_MEM[i] = (0x07 << 8) | ' ';
    }
    term_row = 24;
}

void print_char(char c) {
    if (c == '\n') {
        term_col = 0;
        term_row++;
    } else if (c == 8) { // Backspace
        if (term_col > 8) { // Zabezpieczenie promptu "StarOS> "
            term_col--;
            VIDEO_MEM[term_row * 80 + term_col] = (0x07 << 8) | ' ';
        }
    } else {
        VIDEO_MEM[term_row * 80 + term_col] = (0x07 << 8) | c;
        term_col++;
    }

    if (term_col >= 80) {
        term_col = 0;
        term_row++;
    }
    if (term_row >= 25) {
        scroll();
    }
}

void print_str(char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        print_char(str[i]);
    }
}

void print_int(int n) {
    if (n == 0) {
        print_char('0');
        return;
    }
    char buf[12];
    int i = 10;
    buf[11] = '\0';
    
    // Obsługa liczb ujemnych (opcjonalnie, ale warto mieć)
    if (n < 0) {
        print_char('-');
        n = -n;
    }

    while (n > 0 && i >= 0) {
        buf[i--] = (n % 10) + '0';
        n /= 10;
    }
    print_str(&buf[i + 1]);
}