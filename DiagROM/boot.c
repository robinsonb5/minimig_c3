/*	Firmware for loading files from SD card.
	Part of the ZPUTest project by Alastair M. Robinson.
	SPI and FAT code borrowed from the Minimig project.

	This boot ROM ends up stored in the ZPU stack RAM
	which in the current incarnation of the project is
	memory-mapped to 0x04000000
	Halfword and byte writes to the stack RAM aren't
	currently supported in hardware, so if you use
    hardware storeh/storeb, and initialised global
    variables in the boot ROM should be declared as
    int, not short or char.
	Uninitialised globals will automatically end up
	in SDRAM thanks to the linker script, which in most
	cases solves the problem.
*/

#include "spi.h"
#include "minfat.h"
#include "small_printf.h"

void _boot();
void _break();


#if 0
int puts(const char *msg)
{
	int c;
	int result=0;
	// Because we haven't implemented loadb from ROM yet, we can't use *<char*>++.
	// Therefore we read the source data in 32-bit chunks and shift-and-split accordingly.
	int *s2=(int*)msg;

	do
	{
		int i;
		int cs=*s2++;
		for(i=0;i<4;++i)
		{
			c=(cs>>24)&0xff;
			cs<<=8;
			if(c==0)
				return(result);
			putchar(c);
			++result;
		}
	}
	while(c);
	return(result);
}
#endif
int putchar(int c)
{
}

int main(int argc,char **argv)
{
	int i;

	puts("Initializing SD card\n");
	if(spi_init())
	{
		puts("Hunting for partition\n");
		FindDrive();
		if(LoadFile("OSDZPU01SYS",0))
		{
			_boot();
		}
		puts("Can't load firmware\n");
	}
	puts("Failed to initialize SD card\n");
	return(0);
}

