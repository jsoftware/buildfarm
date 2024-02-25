#!/bin/sh
#
# build linux/macOS on github actions
#
# argument is linux|darwin|raspberry|android|openbsd|freebsd|wasm|win
# wasm is experimental

set -vex
CC=${CC-clang}
export CC

mkdir -p $HOME/temp

if [ "$1" = "linux" ]; then
  ext="so"
elif [ "$1" = "raspberry" ]; then
  ext="so"
elif [ "$1" = "darwin" ]; then
  ext="dylib"
elif [ "$1" = "android" ]; then
  ext="so"
elif [ "$1" = "openbsd" ]; then
  ext="so"
elif [ "$1" = "freebsd" ]; then
  ext="so"
elif [ "$1" = "wasm" ]; then
  ext=""
elif [ "$1" = "win" ]; then
  ext="dll"
else
  echo "argument is linux|darwin|raspberry|android|openbsd|freebsd|wasm|win"
  exit 1
fi
uname -a
uname -m
if [ "`uname -m`" != "armv6l" ] && [ "`uname -m`" != "i386" ] && [ "`uname -m`" != "i686" ] ; then
if [ "$1" = "wasm" ]; then
 m64=0
else
 m64=1
fi
else
 m64=0
fi

if [ $m64 -eq 1 ]; then
mkdir -p j64
else
mkdir -p j32
fi

if [ "x$MAKEFLAGS" = x'' ] ; then
if [ "$1" = "wasm" ] ; then
par=2
elif [ "$1" = "linux" ] || [ "$1" = "raspberry" ] ; then
par=`nproc` 
elif [ "$1" = "darwin" ] || [ "$1" = "openbsd" ] || [ "$1" = "freebsd" ] || [ "$1" = "android" ] ; then
par=`sysctl -n hw.ncpu` 
else 
par=2
fi
export MAKEFLAGS=-j$par
fi
echo "MAKEFLAGS=$MAKEFLAGS"

if [ "$1" = "android" ]; then
script/pcre2-makeandroid.sh
exit 0
fi

if [ "$1" = "wasm" ]; then
cd lib
USE_WASM=1 CC=emcc AR=emar ./pcre2-makewasm.sh
cp bin/$1/j32/* j32
find j32 -type d -exec chmod 755 {} \;
find j32 -type f -exec chmod 644 {} \;
ls -l j32
exit 0
fi

if [ "$1" = "win" ]; then
script/pcre2-makewin.sh
cp pcre2-master/.libs/libjpcre2.dll j64
ls -l j64
exit 0
fi

if [ $m64 -eq 1 ]; then
if [ "$1" = "darwin" ]; then
script/pcre2-makeosx.sh
else
cd script
whoami
chmod 777 ./pcre2-makelx.sh
ls -l
./pcre2-makelx.sh
cd ..
fi
else
script/pcre2-makelx.sh
fi

if [ $m64 -eq 1 ]; then
if [ "$1" = "darwin" ]; then
cp pcre2-master/.libs/libpcre2-8.dylib j64
else
cp pcre2-master/.libs/libpcre2-8.so j64
fi
else
cp pcre2-master/.libs/libpcre2-8.so j32
fi

if [ -d j64 ]; then
find j64 -type d -exec chmod 755 {} \;
find j64 -type f -exec chmod 644 {} \;
ls -l j64
fi

if [ -d j32 ]; then
find j32 -type d -exec chmod 755 {} \;
find j32 -type f -exec chmod 644 {} \;
ls -l j32
fi
