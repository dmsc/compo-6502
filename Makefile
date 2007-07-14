
# Sources
ASM_SRC=\
	all.asm\
	gira.asm\
	circ.asm\
	fillRect.asm\
	mapcopy.asm\
	text.asm\
	moireSmooth.asm\
	textdata.asm\

C_SRC=textConv.c
SCRIPTS=toDcb.sh

ALL_SRC=$(ASM_SRC) $(C_SRC) $(SCRIPTS) Makefile COPYING

# Vars
CC=gcc
CFLAGS=-O2 -Wall
ACME=acme

all: all.dcb

all.bin: $(ASM_SRC)
	$(ACME) -v1 all.asm

all.dcb: all.bin
	./toDcb.sh $< > $@ || ( rm -f $@ && false )
	@echo "--- OK, generated file '$<' ---"

textConv: textConv.c

textdata.asm: message.txt textConv
	./textConv < $< > $@ || rm -f $@

.phony: dist
dist:
	( DIR=`basename \`pwd\``; cd ..; tar cvvzf $$DIR-`date '+%Y%m%d-%H%M'`.tar.gz $(ALL_SRC:%=$$DIR/%) )

