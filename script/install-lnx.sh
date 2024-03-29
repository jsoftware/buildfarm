#!/bin/sh
set -evx

sudo dpkg --add-architecture i386
sudo apt-get install -y build-essential gcc-multilib g++-multilib libc6-dev g++-mingw-w64-x86-64 autoconf automake libtool
# echo "fr_FR.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
# sudo locale-gen
cat /usr/include/features.h || true
ls -l /usr/include/x86_64-linux-gnu/sys/cdefs.h || true
find /usr/include -name cdefs.h || true
