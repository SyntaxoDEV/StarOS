# StarOS Makefile
OS_NAME = StarOS
BIN_DIR = bin
SRC_DIR = src
OBJ_DIR = obj

# Narzędzia
AS = nasm
CC = gcc
LD = ld

# Flagi
ASFLAGS = -f elf32
CFLAGS = -m32 -ffreestanding -O2 -Wall -I$(SRC_DIR)/kernel
LDFLAGS = -m elf_i386 -T linker.ld

# Ścieżki do plików
BOOT_SRC = $(SRC_DIR)/boot/boot.asm
KERNEL_SRC = $(SRC_DIR)/kernel/kernel.c
BOOT_OBJ = $(OBJ_DIR)/boot.o
KERNEL_OBJ = $(OBJ_DIR)/kernel.o

KERNEL_BIN = $(BIN_DIR)/staros.bin
ISO_NAME = staros.iso

all: setup $(ISO_NAME)

# Tworzenie potrzebnych folderów
setup:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)

# Kompilacja Bootloadera
$(BOOT_OBJ): $(BOOT_SRC)
	$(AS) $(ASFLAGS) $< -o $@

# Kompilacja Kernela
$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Linkowanie
$(KERNEL_BIN): $(BOOT_OBJ) $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

# Tworzenie ISO
$(ISO_NAME): $(KERNEL_BIN)
	@mkdir -p isodir/boot/grub
	cp $(KERNEL_BIN) isodir/boot/staros.bin
	@echo 'set timeout=0' > isodir/boot/grub/grub.cfg
	@echo 'set default=0' >> isodir/boot/grub/grub.cfg
	@echo 'menuentry "StarOS" {' >> isodir/boot/grub/grub.cfg
	@echo '	multiboot /boot/staros.bin' >> isodir/boot/grub/grub.cfg
	@echo '	boot' >> isodir/boot/grub/grub.cfg
	@echo '}' >> isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO_NAME) isodir
	@rm -rf isodir

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(ISO_NAME)

run: $(ISO_NAME)
	qemu-system-i386 -cdrom staros.iso
