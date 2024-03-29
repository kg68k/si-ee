# Makefile for si-ee

ifeq ($(notdir $(CURDIR)),src)
$(error do not execute make in src directory)
endif

AS	= has060
ASFLAGS	= -d
LD	= hlk
LD_R	= $(LD) -r
LDFLAGS	=

BINDIR	= /usr/local/bin
MANDIR	= /usr/local/man/cat1

U8TOSJ = u8tosj
SRCDIR_MK = ../srcdir.mk
SRC_DIR = ../src
-include $(SRCDIR_MK)

SRCS	= si.s si_util.s si_emu.s si_model.s si_acc.s si_phantomx.s si_memory.s si_scsiex.s si_sram.s
OBJS	= $(SRCS:.s=.o)
SI_R	= si.r
SI_X	= si.x
DOCS	= si.txt changelog.txt

SI_ZIP	= siee.zip


.PHONY: all archive install clean
all: $(SI_R)


archive: $(SI_ZIP)

$(SI_ZIP): $(SI_R) $(DOCS)
	rm -f $@
	zip -9 $@ $^

si.txt: $(SRC_DIR)/../si.txt
	$(U8TOSJ) < $^ >! $@

changelog.txt: $(SRC_DIR)/../CHANGELOG.md
	$(U8TOSJ) < $^ >! $@


$(SI_R): $(OBJS)
	$(LD_R) $(LDFLAGS) -o $@ $(OBJS) -r

$(SI_X): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

si.o: si.s si_ver.mac

%.o: %.s si.mac
	$(AS) $(ASFLAGS) $<


install:
	cp $(SI_R) $(BINDIR)
	cp $(SI_TXT) $(MANDIR)

clean:
	rm -f $(SI_ZIP) $(DOCS) $(SI_R) $(SI_X) $(OBJS)

# EOF
