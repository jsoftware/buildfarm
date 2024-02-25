#!/bin/sh
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

sed -i "" -e "s/^CPPFLAGS = $/CPPFLAGS = -arch arm64/" Makefile
sed -i "" -e "s/^LDFLAGS = $/LDFLAGS = -arch arm64/" Makefile

make -f Makefile clean
make -f Makefile
cp .libs/libpcre2-8.0.dylib libpcre2-8.0-arm64.dylib

rm -f .libs/*.o
lipo libpcre2-8.0-x86_64.dylib libpcre2-8.0-arm64.dylib -create -output .libs/libpcre2-8.dylib 
