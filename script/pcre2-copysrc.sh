#!/bin/sh
set -evx
if [ "$1" = "linux" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.tar.gz
  tar -xzf master.tar.gz
elif [ "$1" = "raspberry" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.tar.gz
  tar -xzf master.tar.gz
elif [ "$1" = "darwin" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.tar.gz
  tar -xzf master.tar.gz
elif [ "$1" = "android" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.tar.gz
  tar -xzf master.tar.gz
elif [ "$1" = "openbsd" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.zip
  unzip  master.zip
elif [ "$1" = "freebsd" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.zip
  unzip master.zip
elif [ "$1" = "wasm" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.tar.gz
  tar -xzf master.tar.gz
elif [ "$1" = "win" ]; then
  curl -L -O https://github.com/PCRE2Project/pcre2/archive/master.tar.gz
  tar -xzf master.tar.gz
else
  echo "argument is linux|darwin|raspberry|android|openbsd|freebsd|wasm|win"
  exit 1
fi

