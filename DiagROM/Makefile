BASE	= zpu-elf
CC      = $(BASE)-gcc
LD      = $(BASE)-gcc
AS      = $(BASE)-as
CP      = $(BASE)-objcopy
DUMP    = $(BASE)-objdump

BUILD_DIR=zpu_obj

DIAG_PRJ = DiagROM

ZPUFLEXDIR = ../ZPUFlex
# we use crt0.s from here
STARTUP_DIR = $(ZPUFLEXDIR)/Firmware/startup

STARTUP_SRC = $(STARTUP_DIR)/mincrt0.s
STARTUP_OBJ = $(patsubst $(STARTUP_DIR)/%.s,$(BUILD_DIR)/%.o,$(STARTUP_SRC))

ROMGEN = $(ZPUFLEXDIR)/Firmware/zpuromgen
# we fetch ROM prologue / epilogue from here
RTL_DIR = $(ZPUFLEXDIR)/RTL/

COMMON_SRC = 
COMMON_OBJ = $(patsubst ../Common/%.c,$(BUILD_DIR)/%.o,$(COMMON_SRC))

DIAG_SRC_C = main.c fpga.c
DIAG_OBJ_C = $(patsubst %.c,$(BUILD_DIR)/%.o,$(DIAG_SRC_C))
DIAG_OBJ = $(STARTUP_OBJ) $(COMMON_OBJ) $(DIAG_OBJ_C)

# FIXME - change this to mixed, allocating some SDRAM to the BSS section
LINKMAP  = $(ZPUFLEXDIR)/Firmware/standalone_remapped.ld
LIBDIR   = 

ZPUOPTS= # -mno-poppcrel -mno-pushspadd -mno-callpcrel -mno-mult -mno-div # -mno-neg
ZPUOPTS= -mno-poppcrel -mno-pushspadd -mno-callpcrel -mno-neg # no-neg requires bugfixed toolchain

CFLAGS  = -I. -I../Common/ -c -O6 $(ZPUOPTS) -DPRINTF_HEX_ONLY # -DDISABLE_PRINTF -DDISABLE_UART
AFLAGS  = 
LFLAGS  = -T$(LINKMAP) -nostartfiles -O6 -Wl,--relax

# Libraries.
LIBS       =

# Our target.
all: $(BUILD_DIR) $(DIAG_PRJ)_ROM.vhd $(DIAG_PRJ).rpt

clean:
	rm -f $(BUILD_DIR)/*.o *.elf *.rpt *.srec *.ld *~ */*.o *.bin

# Convert ELF binary to bin file.
%.bin: %.elf
	$(CP) -O binary $< $@

$(ROMGEN): $(ZPUFLEXDIR)/Firmware/zpuromgen.c
	gcc -o $(ZPUFLEXDIR)/Firmware/zpuromgen $(ZPUFLEXDIR)/Firmware/zpuromgen.c

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_ROM/' >$*_ROM.vhd <$(RTL_DIR)/rom_prologue.vhd
	$(ROMGEN) $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(RTL_DIR)/rom_epilogue.vhd

%.rpt: %.elf
	echo >$@ -n "End of code:\t"
	$(DUMP) -x $< | grep >>$@ _romend
	echo >>$@ -n "Start of BSS:\t"
	$(DUMP) -x $< | grep  >>$@ __bss_start__
	echo >>$@ -n "End of BSS:\t"
	$(DUMP) -x $< | grep >>$@ __bss_end__
	cat $@

# Link - this produces an ELF binary.

$(DIAG_PRJ).elf: $(DIAG_OBJ)
	$(LD) $(LFLAGS) -o $@ $+ $(LIBS)

$(BUILD_DIR)/%.o: ../Common/%.c Makefile
	$(CC) $(CFLAGS)  -o $@ -c $<

$(BUILD_DIR)/%.o: ../Common/%.s Makefile
	$(CC) $(CFLAGS)  -o $@ -c $<

$(BUILD_DIR)/%.o: %.c Makefile
	$(CC) $(CFLAGS)  -o $@ -c $<

$(BUILD_DIR)/%.o: $(STARTUP_DIR)/%.s
	$(AS) -o $@ $<

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

