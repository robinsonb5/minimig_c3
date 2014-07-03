
#include "fpga.h"

#define EnableFpga()  *(volatile unsigned short *)0xda4004=0x10
#define DisableFpga() *(volatile unsigned short *)0xda4004=0x11

#define SPI(x) (*(volatile unsigned char *)0xda4000=x,*(volatile unsigned char *)0xda4000)
#define SPIW(x) (*(volatile unsigned short *)0xda4000=x,*(volatile unsigned short *)0xda4000)

#define CMD_RDTRK 0x01
#define CMD_WRTRK 0x02
#define CMD_HDRID 0xAACA

static int rom_nextchar(const char *c)
{
	static int *p;
	static int t;
	static int s;
	if(c)
	{
		p=(int *)c;
		s=0;
	}
	if(s==0)
		t=*p++;
	else
		t<<=8;
	s=(s+1)&3;
	return(t>>24);
}


static int rom_strlen(const char *str)
{
	int c=rom_nextchar(str);
	int r=0;
	while(1)
	{
		if(c)
		{
			++r;
			c=rom_nextchar(0);
		}
		else
			return(r);
	}
}


// print message on the boot screen
int BootPrint(const char *text)
{
    unsigned int c1, c2, c3, c4;
    unsigned int cmd;
    const char *p;
    unsigned int n;

    p = text;
    n = rom_strlen(text)+2;
	cmd=1;

    while (1)
    {
        EnableFpga();
		c1 = SPIW(0x1001);
		SPIW(0);
        c3 = SPIW(0);

        if (c1 & (CMD_RDTRK<<8))
        {
            if (cmd)
            { // command phase
                if (c3 == 0x8006) // command packet size must be 12 bytes
                {
                    cmd = 0;
                    SPIW(CMD_HDRID); // command header
					SPIW(0x0001);
                    // data packet size in bytes
					SPIW(0x0000);
					SPIW(n);
                    // don't care
					SPIW(0x0000);
					SPIW(0x0000);
                }
            }
            else
            { // data phase
                if (c3 == (0x8000 | (n >> 1)))
                {
                    c4 = rom_nextchar(text);
                    while (n--)
                    {
                        SPI(c4);
                        if (c4) // if current character is not zero go to next one
                            c4=rom_nextchar(0);
                    }
                    DisableFpga();
                    return 1;
                }
            }
        }
        DisableFpga();
    }
}

