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

cd src
ln -s pcre2_chartables.c.dist pcre2_chartables.c
ls -l pcre2_chartables*
cd ..

./autogen.sh

CC=clang ./configure \
 --enable-pcre2-8 \
 --disable-pcre2-16 \
 --disable-pcre2-32 \
 --disable-debug \
 --disable-jit \
 --enable-bsr-anycrlf \
 --enable-newline-is-anycrlf \


cd $P 
cd ..
cp pcre2-android/Android.mk pcre2-master/.
cd pcre2-android/jni
ln -sf ../../pcre2-master .
cd ..

ls -l jni/pcre2-master/src/pcre2_chartables*

ndk-build

ls -l libs

zip -r ../pcre2-androidlibs.zip libs

