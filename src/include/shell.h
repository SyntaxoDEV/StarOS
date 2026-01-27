#ifndef SHELL_H
#define SHELL_H

// Przyjmuje bufor tekstowy i sprawdza, czy to hello, clear itp.
void shell_execute(char* cmd);

// Pomocnicza funkcja do porównywania tekstu
int strcmp(const char* s1, const char* s2);

#endif