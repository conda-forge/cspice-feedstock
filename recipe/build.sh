#!/bin/bash

if [ "$(uname)" == "Darwin" ];
then
    LIBNAME=libcspice.66.dylib
    EXTRA_FLAGS="-dynamiclib -install_name @rpath/${LIBNAME}"
else
    LIBNAME=libcspice.so.66
    EXTRA_FLAGS="-shared -Wl,-soname,${LIBNAME}"
fi

mkdir -p ${PREFIX}/include/cspice
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/bin

# Copy the binaries
cp $(find ${SRC_DIR}/exe -type f) ${PREFIX}/bin

# Package dynamic libraries
cd $(find ${SRC_DIR} -name "lib" -type d)

ar -x cspice.a
${CC} ${EXTRA_FLAGS} -fPIC -lm *.o -o ${LIBNAME}

cd $(find ${SRC_DIR} -name "lib" -type d)/..

cp lib/${LIBNAME} ${PREFIX}/lib/
cp include/*.h ${PREFIX}/include/cspice/

if [ "$(uname)" == "Darwin" ];
then
    ln -s ${PREFIX}/lib/${LIBNAME} ${PREFIX}/lib/libcspice.dylib
else
    ln -s ${PREFIX}/lib/${LIBNAME} ${PREFIX}/lib/libcspice.so
fi
