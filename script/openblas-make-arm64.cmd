git clone --depth=1 https://github.com/OpenMathLib/OpenBLAS.git
mkdir OpenBLAS\libs
cd OpenBLAS
..\script\gnumake clean
..\script\gnumake TARGET=CORTEXA57 BINARY=32 NO_STATIC=1 NO_LAPACKE=1 NOFORTRAN=1 FIXED_LIBNAME=1 libs netlib shared
copy libopenblas.dll libs\libopenblas-arm64.dll
cd libs
zip ..\..\openblas-warm64.zip *
cd ..
cd ..
