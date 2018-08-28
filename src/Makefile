#adapted from https://github.com/JuliaPackaging/BinaryBuilder.jl/blob/a5511753534f1f38c73653450086b4e4571021e7/test/build_tests/libfoo/Makefile

TARGET_BASENAME=pa_ringbuffer

# We provide sane defaults, but BinaryBuilder may override most of these values.
prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
incdir ?= $(prefix)/include
CC ?= gcc

ifeq ($(shell uname),Darwin)
CFLAGS = -target x86_64-apple-macosx10.7
INSTALL_NAME ?= -install_name '@rpath/$(TARGET_BASENAME).$(SHLIB_EXT)'
SHLIB_EXT ?= dylib
RPATH ?= -Wl,-rpath,'@executable_path/../lib' -Wl,-rpath,'@executable_path'
else ifneq ($(findstring MSYS,$(shell uname)),)
libdir ?= $(bindir)
SHLIB_EXT ?= dll
EXE_EXT ?= .exe
else
SHLIB_EXT ?= so
RPATH ?= -Wl,-rpath,'$$ORIGIN/../lib' -Wl,-rpath,'$$ORIGIN'
endif

default: $(TARGET_BASENAME).$(SHLIB_EXT)

$(bindir):
	mkdir -p $(bindir)
$(libdir):
	mkdir -p $(libdir)
$(incdir):
	mkdir -p $(incdir)

$(TARGET_BASENAME).$(SHLIB_EXT): ../portaudio/src/common/pa_ringbuffer.c Makefile
	$(CC) $(CFLAGS) $< -g -o $@ $(INSTALL_NAME) -shared
$(TARGET_BASENAME): $(TARGET_BASENAME).$(SHLIB_EXT)

install: $(libdir) $(incdir) $(TARGET_BASENAME).$(SHLIB_EXT)
	cp $(TARGET_BASENAME).$(SHLIB_EXT) $(libdir)/
	cp ../portaudio/src/common/pa_ringbuffer.h $(incdir)/

clean:
	rm -rf $(TARGET_BASENAME).so $(TARGET_BASENAME).dll $(TARGET_BASENAME).dylib $(TARGET_BASENAME).dylib.dSYM

.SUFFIXES:
