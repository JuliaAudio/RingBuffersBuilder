using BinaryBuilder

name = "pa_ringbuffer"
version = v"19.6.0"

# Include both the PortAudio sources, and our "bundled" directory, which contains
# our custom Makefile to build just the ringbuffers.
sources = [
    "http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz" =>
    "f5a21d7dcd6ee84397446fa1fa1a0675bb2e8a4a6dceb4305a8404698d8d1513",
    "./bundled",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/
make -f pa_ringbuffer.mk install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "pa_ringbuffer", :pa_ringbuffer),
    FileProduct(joinpath(prefix, "include", "pa_ringbuffer.h"), :pa_ringbuffer_h)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
