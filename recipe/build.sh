#!/bin/bash
set -ex

mkdir -p ${PREFIX}/include/cspice
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/bin

mkdir build
cd build

cmake ${CMAKE_ARGS} \
  -G Ninja \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_FIND_FRAMEWORK=NEVER \
  -DCMAKE_FIND_APPBUNDLE=NEVER \
  -DBUILD_EXECUTABLES=ON \
  -DBUILD_SHARED_LIBS=ON \
  ..

ninja install
