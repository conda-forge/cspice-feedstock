#!/bin/bash

mkdir -p ${PREFIX}/include/cspice
mkdir -p ${PREFIX}/lib

cd $(find ${SRC_DIR} -name "lib" -type d)

ar -x cspice.a
gcc -shared -fPIC -lm *.o -o libcspice.so

cd $(find ${SRC_DIR} -name "lib" -type d)/..

cp lib/libcspice.so ${PREFIX}/lib/
cp include/*.h ${PREFIX}/include/cspice/
