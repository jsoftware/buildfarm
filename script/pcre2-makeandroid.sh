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


cd src
ln -sf pcre2_chartables.c.dist pcre2_chartables.c
cd ..

cd $P 
cd ..
cp pcre2-android/Android.mk pcre2-master/.
cd pcre2-android/jni
ln -sf ../../pcre2-master .
cd ..

ndk-build

ls -l libs

zip -r ../pcre2-androidlibs.zip libs

