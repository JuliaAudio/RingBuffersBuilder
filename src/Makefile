#adapted from https://github.com/JuliaPackaging/BinaryBuilder.jl/blob/a5511753534f1f38c73653450086b4e4571021e7/test/build_tests/libfoo/Makefile

TARGET_BASENAME=pa_ringbuffer

# We provide sane defaults, but BinaryBuilder may override most of these values.
# For instance, `$prefix` is typically set to `/workspace/destdir`, and `CC`
# is set to things like `x86_64-linux-gnu-gcc`.  `$bindir` and friends are not
# typically set, though we still support a fancy caller who wants to change
# things up.
prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
incdir ?= $(prefix)/include
CC ?= gcc

# We default to -fPIC and -g for $(CFLAGS); if you override this make sure to
# add in -fPIC at least.  :)
CFLAGS ?= -g -fPIC

# We do our best here to set up rpaths and shared library extensions and
# whatnot properly here, but note that within BinaryBuilder the RPATH stuff
# will get fixed up automatically, and shared library extensions and whatnot
# are available through the ${shlib_ext} environment variable.  
ifeq ($(shell uname),Darwin)
# On Darwin, we tell the linker to set the "install name" (e.g. dependent
# objects should embed within themselves to find this object) to be relative
# to the @rpath.  So, if something links against libpa_ringbuffer.dylib, the
# path embedded will be '@rpath/pa_ringbuffer.dylib' instead of something
# like '/Users/Me/src/pa_ringbuffer.dylib'.
INSTALL_NAME ?= -install_name '@rpath/$(TARGET_BASENAME).$(SHLIB_EXT)'
SHLIB_EXT ?= dylib
RPATH ?= -Wl,-rpath,'@executable_path/../lib' -Wl,-rpath,'@executable_path'

# We default to a macosx minimum deployment target of 10.8.  BinaryBuilder
# will automatically do this for you.
LDFLAGS ?= -mmacosx-version-min=10.8 

else ifneq ($(findstring MSYS,$(shell uname)),)
libdir ?= $(bindir)
SHLIB_EXT ?= dll
EXE_EXT ?= .exe
else
SHLIB_EXT ?= so
RPATH ?= -Wl,-rpath,'$$ORIGIN/../lib' -Wl,-rpath,'$$ORIGIN'
endif

# The first target in a Makefile is the default one.  We also name it `default`.
default: $(TARGET_BASENAME).$(SHLIB_EXT)

# Rules to automatically create these directories if they don't already exist.
$(bindir):
	mkdir -p $(bindir)
$(libdir):
	mkdir -p $(libdir)
$(incdir):
	mkdir -p $(incdir)


# Lists of sources
HEADERS=../portaudio/src/common/pa_ringbuffer.h 
SRCS=../portaudio/src/common/pa_ringbuffer.c

# This is the target that actually builds `pa_ringbuffer.{so,dll,dylib}`.
$(TARGET_BASENAME).$(SHLIB_EXT): $(SRCS) $(HEADERS) Makefile
	@# This expands out to something like:
	@# gcc -fPIC -g -o pa_ringbuffer.so -shared
	$(CC) $(CPPFLAGS) $(CFLAGS) $(SRCS) -o $@ $(INSTALL_NAME) -shared

# `make install` copies our built library to `$libdir`, and our headers
# to `$incdir`.
install: $(libdir) $(incdir) $(TARGET_BASENAME).$(SHLIB_EXT) $(HEADERS)
	install -m755 $(TARGET_BASENAME).$(SHLIB_EXT) $(libdir)/
	install -m644 $(HEADERS) $(incdir)/

# `make clean` removes all of our build products
clean:
	rm -rf $(TARGET_BASENAME).so $(TARGET_BASENAME).dll $(TARGET_BASENAME).dylib $(TARGET_BASENAME).dylib.dSYM

.SUFFIXES:
