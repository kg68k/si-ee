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

SIOPT	=
#	  -sENABLE_DISABLE
#	  -sSHUTDOWN_COUNT


SRCS	= si.s si_util.s si_emu.s si_model.s si_acc.s
OBJS	= $(SRCS:.s=.o)
SI_R	= si.r
SI_X	= si.x
SI_DOC	= si.txt

#all: both
all: $(SI_R)

both: $(SI_R) $(SI_X)


$(SI_R): $(OBJS)
	$(LD_R) $(LDFLAGS) -o $@ $(OBJS) -r

$(SI_X): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

%.o: %.s si.mac
	$(AS) $(ASFLAGS) $(SIOPT) $<


install:
	cp $(SI_R) $(BINDIR)
	cp $(SI_DOC) $(MANDIR)

clean:
	rm -f si.[ox]

distclean:
	rm -f si.[orx]

# EOF
