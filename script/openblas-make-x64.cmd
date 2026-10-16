git clone --depth=1 https://github.com/OpenMathLib/OpenBLAS.git
mkdir OpenBLAS\libs
cd OpenBLAS
..\script\gnumake clean
..\script\gnumake TARGET=NEHALEM BINARY=64 NO_STATIC=1 NO_LAPACKE=1 NOFORTRAN=1 FIXED_LIBNAME=1 libs netlib shared
copy libopenblas.dll libs\libopenblas.dll
..\script\gnumake clean
..\script\gnumake TARGET=HASWELL  BINARY=64 NO_STATIC=1 NO_LAPACKE=1 NOFORTRAN=1 FIXED_LIBNAME=1 libs netlib shared
copy libopenblas.dll libs\libopenblas-avx2.dll
cd libs
zip ..\..\openblas-w64.zip *
cd ..
cd ..
