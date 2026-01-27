# Nazwa systemu
OS_NAME = staros

# Narzędzia
CC = gcc
AS = nasm
LD = ld

# Flagi kompilacji
# -Isrc/include pozwala na używanie #include "plik.h" bez ../
CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra -fno-stack-protector -nostdlib -Isrc/include
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld

# Pliki obiektowe - dodaliśmy cpu.o i shell.o
OBJS = build/boot.o \
       build/kernel.o \
       build/io.o \
       build/keyboard.o \
       build/screen.o \
       build/shell.o \
       build/cpu.o

.PHONY: all clean run

all: build_dir $(OS_NAME).iso

# Tworzenie folderu na pliki binarne
build_dir:
	@mkdir -p build

# Kompilacja Asemblera (Bootloader)
build/boot.o: src/boot/boot.s
	$(AS) $(ASFLAGS) $< -o $@

# Kompilacja plików C
build/%.o: src/kernel/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Linkowanie jądra
$(OS_NAME).bin: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# Tworzenie obrazu ISO (wymaga grub-mkrescue i xorriso)
$(OS_NAME).iso: $(OS_NAME).bin
	@mkdir -p isodir/boot/grub
	cp $(OS_NAME).bin isodir/boot/
	@printf 'set timeout=0\nset default=0\nmenuentry "StarOS" {\n  multiboot /boot/staros.bin\n  boot\n}' > isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(OS_NAME).iso isodir

# Uruchamianie w QEMU z dużą ilością RAMu (1GB)
run: all
	qemu-system-i386 -m 1024M -cdrom $(OS_NAME).iso

# Czyszczenie projektu
clean:
	rm -rf build isodir $(OS_NAME).bin $(OS_NAME).iso