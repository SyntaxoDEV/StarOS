# 🌟 StarOS

StarOS to hobbystyczny system operacyjny x86, budowany od zera. Projekt skupia się na czystej architekturze, trybie graficznym HD (LFB) i nauce niskopoziomowego programowania.

## 🚀 Aktualne możliwości
* **Bootloader**: Obsługa Multiboot (kompatybilny z GRUB).
* **Grafika**: Tryb Linear Framebuffer (LFB) w rozdzielczości 1280x720 (32-bit).
* **Kernel**: Pisany w C, wykonujący podstawowe operacje rysowania pikseli.
* **Kosmiczny Start**: Automatyczne czyszczenie ekranu i generowanie tła.

## 📁 Struktura folderów
* `src/boot/` - Kod assemblera (start procesora).
* `src/kernel/` - Serce systemu w C.
* `build/` - Pliki binarne (.o, .bin).
* `iso_root/` - Struktura plików dla obrazu ISO.

## 🛠️ Wymagania systemowe (Build Host)
Aby zbudować StarOS, potrzebujesz systemu Linux oraz następujących paczek:
```bash
sudo apt install build-essential nasm qemu-system-x86 xorriso mtools grub-pc-bin
```
Nastepnie wpisz w terminalu, wymagany jest QEMU:
```bash
Make
```

## 💫 Ostatnie zmiany

```
- Boot Grub
- Kernel
```

**26.01.2026 14:56**
