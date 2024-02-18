#!/bin/bash
#
# build Android .so file

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

cp ../script/Android.mk .
cd $P 
cp Android.mk $S/.
cd ../android/jni
ln -sf ../../pcre2-master .
cd ..
ndk-build

ls -l libs




