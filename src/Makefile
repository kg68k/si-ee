# Makefile for si-ee

ifeq ($(notdir $(CURDIR)),src)
$(error do not execute make in src directory)
endif

AS	= has060
ASFLAGS	= -d -w2
LD	= hlk
LD_R	= $(LD) -r
LDFLAGS	=
U8TOSJ = u8tosj

BINDIR	= /usr/local/bin
MANDIR	= /usr/local/man/cat1

SRCS	= si.s si_util.s si_emu.s si_model.s si_acc.s si_phantomx.s \
	  si_mpuclk.s si_memory.s si_scsiex.s si_sram.s
OBJS	= $(SRCS:.s=.o)
SI_R	= si.r
SI_X	= si.x
DOCS	= si.txt changelog.txt

ARCHIVE_ZIP = siee.zip


.PHONY: all archive install clean
all: $(SI_R)


ifdef SRC_DIR
archive: $(ARCHIVE_ZIP)
else
archive: ../srcdir.txt
	$(if $(SRC_DIR_IS_DEFINED),$(error SRC_DIR is empty.))
	make $@ SRC_DIR_IS_DEFINED=yes SRC_DIR=$(shell cat ../srcdir.txt)
../srcdir.txt:
	$(error file 'srcdir.txt' created by src2build is required.)
endif

$(ARCHIVE_ZIP): $(SI_R) $(DOCS)
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
	rm -f $(ARCHIVE_ZIP) $(DOCS) $(SI_R) $(SI_X) $(OBJS)

# EOF
