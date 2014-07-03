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


int main(int argc,char **argv)
{
	int i;

//	BootPrint("Initializing SD card\n");
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

