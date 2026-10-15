#!/bin/sh
#
# build linux/macOS on github actions
#
# argument is linux|windows|darwin|raspberry|android|openbsd|freebsd|wasm [arm64|armv6l|i386|x86_64|wasm32]
# wasm is experimental

set -vex
CC=${CC-clang}
export CC

git clone --depth=1 https://github.com/OpenMathLib/OpenBLAS.git || exit 1

x86() {
make clean
make \
    TARGET=BULLDOZER BINARY=32\
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    HOSTCC=clang \
    -j4
cp libopenblas.${ext} libs/libopenblas_32.${ext}
}

x86_64() {
## This will build for x86_64 
make clean
make \
    TARGET=NEHALEM BINARY=64\
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    HOSTCC=clang \
    -j4
cp libopenblas.${ext} libs/libopenblas.${ext}
}

x86_64avx2() {
## This will build for x86_64 
make clean
make \
    TARGET=HASWELL BINARY=64\
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    HOSTCC=clang \
    -j4
cp libopenblas.${ext} libs/libopenblas-avx2.${ext}
}

arm64() {
## This will build for arm64 
make clean
make \
    TARGET=CORTEXA57 BINARY=64\
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    HOSTCC=clang \
    -j4
cp libopenblas.${ext} libs/libopenblas.${ext}
}

rpi32() {
make clean
make \
    TARGET=ARMV6 BINARY=32 \
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    HOSTCC=gcc \
    -j4
cp libopenblas.${ext} libs/libopenblas.${ext}
}

android_armv7() {
make clean
make \
    TARGET=ARMV7 BINARY=32 \
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    CC="$TOOLCHAIN"/bin/armv7a-linux-androideabi24-clang \
    AR="$TOOLCHAIN"/bin/llvm-ar \
    RANLIB="$TOOLCHAIN"/bin/llvm-ranlib \
    HOSTCC=clang \
    ARM_SOFTFP_ABI=1 \
    -j4
cp libopenblas.${ext} libs/libopenblas-armv7.${ext}
}

android_armv8() {
make clean
make \
    TARGET=CORTEXA57 BINARY=64 \
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    CC="$TOOLCHAIN"/bin/aarch64-linux-android24-clang \
    AR="$TOOLCHAIN"/bin/llvm-ar \
    RANLIB="$TOOLCHAIN"/bin/llvm-ranlib \
    HOSTCC=clang \
    -j4
cp libopenblas.${ext} libs/libopenblas-armv8.${ext}
}

android_x86() {
make clean
make \
    TARGET=ATOM BINARY=32\
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    CC="$TOOLCHAIN"/bin/i686-linux-android24-clang \
    AR="$TOOLCHAIN"/bin/llvm-ar \
    RANLIB="$TOOLCHAIN"/bin/llvm-ranlib \
    HOSTCC=clang \
    -j4
cp libopenblas.${ext} libs/libopenblas-x86.${ext}
}

android_x64() {
## This will build for x86_64 
make clean
make \
    TARGET=ATOM BINARY=64\
    BUILD_TESTING=0 \
    NO_STATIC=1 \
    NO_LAPACKE=1 \
    NOFORTRAN=1 \
    FIXED_LIBNAME=1 \
    CC="$TOOLCHAIN"/bin/x86_64-linux-android24-clang \
    AR="$TOOLCHAIN"/bin/llvm-ar \
    RANLIB="$TOOLCHAIN"/bin/llvm-ranlib \
    HOSTCC=clang \
    ARM_SOFTFP_ABI=1 \
    -j4
cp libopenblas.${ext} libs/libopenblas-x64.${ext}
}

mkdir -p OpenBLAS/libs
cd OpenBLAS

if [ "$1" = "linux" ]; then
 ext="so"
 x86
 x86_64
 x86_64avx2
 cd libs
 zip ../../"$1".zip *
 cd -
elif [ "$1" = "raspberry" ]; then
 ext="so"
 if [ "$2" = "arm64" ]; then
  arm64
  cd libs
  zip ../../"$1"-rpi64.zip *
 else
  rpi32
  cd libs
  zip ../../"$1"-rpi32.zip *
 fi
 cd -
elif [ "$1" = "darwin" ]; then
 ext="dylib"
 if [ "$2" = "x86_64" ]; then
  x86_64
  cd libs
  zip ../../"$1"-m64.zip *
 else
  arm64
  cd libs
  zip ../../"$1"-m64arm.zip *
 fi
 cd -
elif [ "$1" = "android" ]; then
 which ndk-build
 export ANDROID_NDK_HOME=/Users/runner/hostedtoolcache/ndk/r24/arm64
 export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64
 ext="so"
 android_armv7
 android_armv8
 android_x86
 android_x64
 cd libs
 zip ../../"$1".zip *
 cd -
elif [ "$1" = "openbsd" ]; then
 ext="so"
 x86_64
 x86_64avx2
 cd libs
 zip ../../"$1".zip *
 cd -
elif [ "$1" = "freebsd" ]; then
 ext="so"
 x86_64
 x86_64avx2
 cd libs
 zip ../../"$1".zip *
 cd -
elif [ "$1" = "windows" ]; then
 ext="dll"
elif [ "$1" = "wasm" ]; then
 ext=""
else
 echo "argument is linux|windows|darwin|raspberry|android|openbsd|freebsd|wasm"
 exit 1
fi

cd -

