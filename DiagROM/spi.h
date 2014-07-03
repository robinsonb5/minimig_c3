#ifndef SPI_H
#define SPI_H

#define SPIBASE 0xda4000
#define HW_SPI(x) *(volatile unsigned char *)(SPIBASE+x)

/* SPI registers */
#define HW_SPI_CS 0x04
#define HW_SPI_DATA 0x00 /* Blocks on both reads and writes, making BUSY signal redundant. */
#define HW_SPI_SPEED 0x08

#define EnableCard()  HW_SPI(HW_SPI_CS)=0x02
#define DisableCard() HW_SPI(HW_SPI_CS)=0x03

#define SPI_slow()  HW_SPI(HW_SPI_SPEED)=0x20
#define SPI_fast()  HW_SPI(HW_SPI_SPEED)=0x01   //14MHz/2

int spi_init();
int sd_read_sector(unsigned long lba,unsigned char *buf);
int sd_write_sector(unsigned long lba,unsigned char *buf); // FIXME - stub

#endif
