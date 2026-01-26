OS_NAME = StarOS
AS = nasm
CC = gcc
LD = ld
EMU = qemu-system-i386

ASFLAGS = -f elf32
CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -m elf_i386 -T linker.ld

BUILD_DIR = build
SRC_DIR = src
ISO_DIR = iso_root

OBJS = $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o

all: iso run

$(BUILD_DIR)/boot.o: $(SRC_DIR)/boot/boot.asm
	@mkdir -p $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel/kernel.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Linkowanie binarki
$(BUILD_DIR)/$(OS_NAME).bin: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# Tworzenie obrazu ISO
iso: $(BUILD_DIR)/$(OS_NAME).bin
	@mkdir -p $(ISO_DIR)/boot/grub
	cp $(BUILD_DIR)/$(OS_NAME).bin $(ISO_DIR)/boot/
	cp grub.cfg $(ISO_DIR)/boot/grub/
	grub-mkrescue -o $(OS_NAME).iso $(ISO_DIR)
	@echo "ISO gotowe: $(OS_NAME).iso"

# Odpalanie ISO w QEMU
run:
	$(EMU) -cdrom $(OS_NAME).iso -vga std

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR) $(OS_NAME).iso