#include "../include/cpu.h"
#include "../include/screen.h"

void get_cpu_vendor(char* vendor) {
    unsigned int ebx, edx, ecx;
    // W "a"(0) wrzucamy 0 do EAX przed wykonaniem cpuid
    __asm__ volatile("cpuid" : "=b"(ebx), "=d"(edx), "=c"(ecx) : "a"(0));
    
    ((unsigned int*)vendor)[0] = ebx;
    ((unsigned int*)vendor)[1] = edx;
    ((unsigned int*)vendor)[2] = ecx;
    vendor[12] = '\0';
}

void print_cpu_info() {
    char vendor[13];
    get_cpu_vendor(vendor);
    print_str("CPU Vendor: ");
    print_str(vendor);
    print_char('\n');
}