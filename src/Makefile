# Makefile for si-ee

ifeq ($(notdir $(CURDIR)),src)
$(error do not execute make in src directory)
endif

AS	= has
ASFLAGS	= -d
LD	= hlk
LD_R	= $(LD) -r
LDFLAGS	=

BINDIR	= /usr/local/bin
MANDIR	= /usr/local/man/cat1

SRCS	= si.s si_util.s si_emu.s si_model.s si_acc.s si_phantomx.s si_scsiex.s si_sram.s
OBJS	= $(SRCS:.s=.o)
SI_R	= si.r
SI_X	= si.x
SI_TXT	= si.txt

SRC_ZIP	= src.zip
SI_ZIP	= si.zip
ARCS	= $(SRC_ZIP) $(SI_ZIP)

all: $(SI_R)


$(SI_ZIP): $(SRC_ZIP) $(SI_TXT) $(SI_R)
	rm -f $@
	zip -9 $@ $^

$(SRC_ZIP): Makefile si.mac si_ver.mac $(SRCS)
	rm -f $@
	zip -9 $@ $^


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
	rm -f si.[xr] $(OBJS) $(ARCS)


# EOF
