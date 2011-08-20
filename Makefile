# Defaults flags:
#CC        = gcc -pipe -O -DHAVE_LIMITS_H -Wall -fno-common
#CFLAGS    = -Wall -O4 -march=i486
#MACHINE   = LINUX
#CC        = icc
#CFLAGS    = -w1 -O3 -march=pentiumiii -mcpu=pentiumpro -DAVOID_NAN_TEST
#MACHINE   = INTEL
#MAKE      = /usr/bin/make
#SYSLIB    = -export-dynamic -ldl -L/usr/X11R6/lib
HOSTTYPE  = Mac

# Windows 95/98/NT using Cygwin:
ifeq ($(HOSTTYPE),i686)
  MACHINE   = WINDOWS
  CFLAGS    = -Wall -O4 -march=i486
  MAKE      = make
  EXT       = .exe
  SYSLIB    =
endif
# Macintosh X:
ifeq ($(HOSTTYPE),Mac)
  MACHINE   = Mac
  MAKE      = make
  CC        = gcc
  CFLAGS    = -pipe -O -Wall -fno-common
  EXT       = 
  SYSLIB    =
endif
# Older Linux machines:
ifeq ($(HOSTTYPE),i386_linux2)
  SYSLIB    = -export-dynamic -ldl
endif
# New condor
ifeq ($(HOSTTYPE),i386)
  MACHINE   = CONDOR
endif
# Eagle:
ifeq ($(HOSTTYPE),hp9000s800)
  MACHINE   = EAGLE
  CC        = cc
  CFLAGS    = -Ae +Oall -w
  MAKE      = /opt/local/bin/make
  SYSLIB    = /usr/lib/X11R5/libX11.sl -ldld
endif
# SP2:
ifeq ($(HOSTTYPE),rs6000)
  MACHINE   = SP
  CFLAGS    = -O4 -I/usr/include
  MAKE      = /opt/local/bin/make
  SYSLIB    = -lld
endif
# Alpha 21264s
ifeq ($(HOSTTYPE),alpha)
  MACHINE   = ALPHA
  CC        = cc
  CFLAGS    = -arch ev6 -fast -O4
  MAKE      = /usr/home/dr/bin/make
  SYSLIB    = -non_shared -ldnet_stub
endif

DEF= CC="$(CC)" CFLAGS="$(CFLAGS)" MACHINE=$(MACHINE) SYSLIB="$(SYSLIB)" \
	TOP=$(shell pwd) EXT=$(EXT)

MAKE_LENS  = $(MAKE) -C Src lens$(EXT) $(DEF) EXEC=lens PKGS=
MAKE_ALENS = $(MAKE) -C Src alens$(EXT) $(DEF) EXEC=alens PKGS="-DADVANCED"
MAKE_LIBLENS  = $(MAKE) -C Src liblens $(DEF) EXEC=lens PKGS=
MAKE_LIBALENS = $(MAKE) -C Src libalens $(DEF) EXEC=alens PKGS="-DADVANCED"
MAKE_CLEAN = $(MAKE) -C Src $(DEF) clean

lens:: dirs
	$(MAKE_LENS)
liblens:: dirs
	$(MAKE_LIBLENS)
alens:: dirs
	$(MAKE_ALENS)
libalens:: dirs
	$(MAKE_LIBALENS)
clean::
	$(MAKE_CLEAN)

all:: dirs
	rm -f lens$(EXT) alens$(EXT)
	$(MAKE_CLEAN)
	$(MAKE_ALENS)
	$(MAKE_CLEAN)
	$(MAKE_LENS)

# This builds the necessary system-dependent subdirectories on unix machines
ifeq ($(MACHINE),WINDOWS)
dirs::
echo "HOST = WINDOWS"
else
echo "HOST = Mac:  $(HOSTTYPE)"
dirs:: Obj Bin
Obj::
	if test ! -d Obj; \
	then mkdir Obj; fi
Bin::
	if test ! -d Bin; \
	then mkdir Bin; fi
endif
