#ifndef KEYBOARD_H
#define KEYBOARD_H

// Pobiera surowy kod skanowania (scancode) bezpośrednio z portu 0x60
unsigned char get_scancode();

// Zamienia scancode na znak ASCII (obsługuje podstawowe litery i cyfry)
char scancode_to_char(unsigned char scancode);

#endif