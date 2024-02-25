#!/bin/bash
#
# build OSX .dylib file

set -evx

cd "$(dirname "$0")"
P="$(pwd)"

S=../pcre2-master
# ----------------

cd $S

rm -f src/*.o .libs/*.o

./autogen.sh

CC=clang ./configure \
 CPPFLAGS='-arch x86_64 ' \
 --enable-pcre2-8 \
 --disable-pcre2-16 \
 --disable-pcre2-32 \
 --disable-debug \
 --disable-jit \
 --enable-bsr-anycrlf \
 --enable-newline-is-anycrlf \

make -f Makefile clean
make -f Makefile
cp .libs/libpcre2-8.0.dylib libpcre2-8.0-x86_64.dylib

rm -f src/*.o .libs/*.o

CC=clang ./configure \
 CPPFLAGS='-arch arm64' \
 --enable-pcre2-8 \
 --disable-pcre2-16 \
 --disable-pcre2-32 \
 --disable-debug \
 --disable-jit \
 --enable-bsr-anycrlf \
 --enable-newline-is-anycrlf \

make -f Makefile clean
make -f Makefile
cp .libs/libpcre2-8.0.dylib libpcre2-8.0-arm64.dylib

lipo libpcre2-8.0-x86_64.dylib libpcre2-8.0-arm64.dylib -create -output libpcre2-8.0.dylib 
