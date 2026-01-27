#ifndef VGA_H
#define VGA_H

#define VGA_ADDRESS 0xB8000
#define WIDTH 80
#define HEIGHT 25

// Makro do obliczania indeksu
#define GET_INDEX(x, y) (((y) * WIDTH + (x)) * 2)

// Standardowy kolor: biały na czarnym
#define DEFAULT_COLOR 0x0F

#endif