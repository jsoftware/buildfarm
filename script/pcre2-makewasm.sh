#!/bin/sh
#
# build Linux .so file

set -evx

cd "$(dirname "$0")"
P="$(pwd)"

S=../pcre2-master
# ----------------

cd $S
rm -f src/*.o .libs/*.o

./autogen.sh

USE_WASM=1 CC=emcc AR=emar ./configure \
 --disable-shared \
 --enable-pcre2-8 \
 --disable-pcre2-16 \
 --disable-pcre2-32 \
 --disable-debug \
 --disable-jit \
 --enable-bsr-anycrlf \
 --enable-newline-is-anycrlf \

make -f Makefile clean
make -f Makefile
ls -l .libs
