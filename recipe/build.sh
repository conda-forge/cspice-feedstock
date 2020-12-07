#!/bin/bash

if [ "$(uname)" == "Darwin" ];
then
    LIBNAME=libcspice.66.dylib
    EXTRA_FLAGS="-dynamiclib -install_name @rpath/${LIBNAME}"
else
    LIBNAME=libcspice.so.66
    EXTRA_FLAGS="-shared -Wl,-soname,${LIBNAME}"
fi

# Build and Package dynamic libraries
#  cd to lib dir
cd ${SRC_DIR}/lib
#  compile c code
${CC} -Iinclude -c -fPIC -m64 -O2 -ansi -pedantic ./../src/cspice/*.c 
#  make the shared library
${CC} ${EXTRA_FLAGS} -fPIC -m64 -O2 -pedantic -o ${LIBNAME} *.o -lm
#  todo add rebuilding of static library here 
#  cd up to src dirctory
cd ${SRC_DIR} 


# todo add rebuilding of all executeables

# Deploy the built shared libraries and executables
#  make the target directories
mkdir -p ${PREFIX}/include/cspice
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/bin
#  copy the files to where they are needed
cp $(find $(find ${SRC_DIR} -name "exe" -type d) -type f) ${PREFIX}/bin
cp lib/${LIBNAME} ${PREFIX}/lib/
cp include/*.h ${PREFIX}/include/cspice/

# finally copy the dylib or so file to where it is needed
if [ "$(uname)" == "Darwin" ];
then
    ln -s ${PREFIX}/lib/${LIBNAME} ${PREFIX}/lib/libcspice.dylib
else
    ln -s ${PREFIX}/lib/${LIBNAME} ${PREFIX}/lib/libcspice.so
fi
