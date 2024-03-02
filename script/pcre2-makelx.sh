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

./configure \
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

if [ "$1" = "linux" ]; then
mv .libs .libs-64
make -f Makefile clean

./configure \
 CC="clang -m32" CXX="clang++ -m32" \
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
mv .libs .libs-32
mv .libs-64 .libs

fi
