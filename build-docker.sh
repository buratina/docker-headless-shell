#!/bin/bash

set -e

SRC=$(realpath $(cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd ))

VER=$1

if [ ! -d $SRC/out ]; then
  echo "$SRC/out does not exist!"
  exit 1
fi

if [ -z "$1" ]; then
  pushd $SRC/out &> /dev/null

  VER=$(ls *.bz2|sort -r -V|head -1|sed -e 's/^headless-shell-//' -e 's/\.tar\.bz2$//')

  popd &> /dev/null
fi

pushd $SRC &> /dev/null

rm -rf $SRC/out/$VER
mkdir -p  $SRC/out/$VER
tar -jxf $SRC/out/headless-shell-$VER.tar.bz2 -C $SRC/out/$VER/

docker build --build-arg VER=$VER -t chromedp/headless-shell:$VER .

popd &> /dev/null
