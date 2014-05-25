#ifndef FPGA_H
#define FPGA_H

void ShiftFpga(unsigned char data);
unsigned char ConfigureFpga(void);
char BootPrint(const char *text);
char PrepareBootUpload(unsigned char base, unsigned char size);
void BootExit(void);
void ClearMemory(unsigned long base, unsigned long size);
unsigned char GetFPGAStatus(void);

#endif

