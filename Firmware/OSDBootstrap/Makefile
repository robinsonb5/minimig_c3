# *nix Makefile for Minimig bootfirmware assembly
# Written by Christian Vogelgsang <chris@vogelgsang.org>

# ----- the following tools need to be installed -----
# vasm homepage http://sun.hasenbraten.de/vasm
ASM=vasmm68k_mot
ASM_OPTS=
HEXER=python ../hexer.py

.PRECIOUS: %.bin

# ----- rules -----
all: osdload.hex

clean:
	rm -f osdload.hex osdload.bin
	
%.hex: %.bin
	$(HEXER) -l 2048 $< $@

%.bin: %.asm
	$(ASM) $(ASM_OPTS) -Fbin -o $@ $<
