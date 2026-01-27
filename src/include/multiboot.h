#ifndef MULTIBOOT_H
#define MULTIBOOT_H

struct multiboot_info {
    unsigned int flags;
    unsigned int mem_lower;
    unsigned int mem_upper; // To nas interesuje (RAM w KB)
    // ... reszta pól jest teraz zbędna
} __attribute__((packed));

typedef struct multiboot_info multiboot_info_t;

#endif