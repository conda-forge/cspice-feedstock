#!/bin/bash

mkdir -p ${PREFIX}/include/cspice

cd $(find ${SRC_DIR} -name "lib" -type d)

ar -x cspice.a
gcc -shared -fPIC -lm *.o -o libcspice.so

cd $(find ${SRC_DIR} -name "lib" -type d)/..

cp lib/libcspice.so ${PREFIX}/lib/
cp include/*.h ${PREFIX}/include/cspice/
