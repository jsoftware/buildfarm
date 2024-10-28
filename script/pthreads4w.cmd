@rem build windows on github actions

@rem x64 x86 arm64
IF "%~1"=="x86" GOTO L0
IF "%~1"=="arm64" GOTO L0
IF "%~1" NEQ "x64" EXIT /b 1
:L0

cd pthreads4w
IF "%~1"=="x86" GOTO L01A
IF "%~1"=="arm64" GOTO L01B
IF "%~1" NEQ "x64" EXIT /b 1
nmake -f Makefile2.win CC=clang-cl TARGET_CPU=x64 clean
nmake -f Makefile2.win CC=clang-cl TARGET_CPU=x64 all
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
GOTO L01C
:L01A
nmake -f Makefile2.win CC=clang-cl TARGET_CPU=x86 =0 clean
nmake -f Makefile2.win CC=clang-cl TARGET_CPU=x86 all
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
GOTO L01C
:L01B
nmake -f Makefile2.win CC=clang-cl TARGET_CPU=ARM64 clean
nmake -f Makefile2.win CC=clang-cl TARGET_CPU=ARM64 all
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
:L01C

cd ..
IF "%~1"=="x86" GOTO L02A
IF "%~1"=="arm64" GOTO L02B
IF "%~1" NEQ "x64" EXIT /b 1
mkdir ..\x64
copy pthreads4w\*.dll ..\x64
copy pthreads4w\*.lib ..\x64
GOTO L02C
:L02A
mkdir ..\x86
copy pthreads4w\*.dll ..\x86
copy pthreads4w\*.lib ..\x86
GOTO L02C
:L02B
mkdir ..\arm64
copy pthreads4w\*.dll ..\arm64
copy pthreads4w\*.lib ..\arm64
:L02C
