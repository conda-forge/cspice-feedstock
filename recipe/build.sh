#!/bin/bash

LIBNAME=libcspice.so.66

mkdir -p ${PREFIX}/include/cspice
mkdir -p ${PREFIX}/lib

cd $(find ${SRC_DIR} -name "lib" -type d)

ar -x cspice.a
gcc -shared -Wl,-soname,${LIBNAME} -fPIC -lm *.o -o ${LIBNAME}

cd $(find ${SRC_DIR} -name "lib" -type d)/..

cp lib/${LIBNAME} ${PREFIX}/lib/
cp include/*.h ${PREFIX}/include/cspice/

ln -s ${PREFIX}/lib/${LIBNAME} ${PREFIX}/lib/libcspice.so
