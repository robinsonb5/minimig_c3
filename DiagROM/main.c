
#include "fpga.h"

#if 0
int puts(const char *msg)
{
	int c;
//	int result=0;
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
				return;//(result);
			putchar(c);
//			++result;
		}
	}
	while(c);
//	return(result);
}
#endif

int main(int argc,char**argv)
{
	puts("Hello, world!\n");
	while(1)
		;
}


