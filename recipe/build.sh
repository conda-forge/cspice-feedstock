#!/bin/bash

if [ "$(uname)" == "Darwin" ];
then
    LIBNAME=libcspice.66.dylib
    EXTRA_FLAGS="-dynamiclib -install_name @rpath/${LIBNAME}"
else
    LIBNAME=libcspice.so.66
    EXTRA_FLAGS="-shared -Wl,-soname,${LIBNAME}"
fi
# static library files names
CSPICENM=cspice.66.a
CSUPPTNM=csupport.66.a

#########################################
# Build Shared library
#########################################
#  cd to lib dir
cd ${SRC_DIR}/lib
#  compile c code
${CC} -Iinclude -c -fPIC -m64 -O2 -ansi -pedantic ./../src/cspice/*.c 
#  make the shared library
${CC} ${EXTRA_FLAGS} -fPIC -m64 -O2 -pedantic -o ${LIBNAME} *.o -lm
#  cd up to src dirctory
cd ${SRC_DIR}

#########################################
# Build Static library using NAIF scripts
#########################################
#  rebuild static library using NAIF scripts
export TKCOMPILER=${CC}
cd ${SRC_DIR}/src/cspice
./mkprodct.csh
cd ${SRC_DIR}/src/csupport
./mkprodct.csh
#  rename static libraries to include version number
cd ${SRC_DIR}/lib
mv cspice.a ${CSPICENM}
mv csupport.a ${CSUPPTNM}
#  cd up to src dirctory
cd ${SRC_DIR}

#########################################
# Build executables using NAIF scripts
#########################################
# cd into src directory
cd ${SRC_DIR}/src
# build each tool using NAIF scripts
for i in *_c; do cd $i && ./mkprodct.csh && cd -; done
#  cd up to src directory
cd ${SRC_DIR}

#########################################
# deploy built products
#########################################
# Deploy the built shared libraries and executables
#  make the target directories
mkdir -p ${PREFIX}/include/cspice
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/bin
#  copy the files to where they are needed
cp $(find $(find ${SRC_DIR} -name "exe" -type d) -type f) ${PREFIX}/bin
cp lib/* ${PREFIX}/lib/
cp include/*.h ${PREFIX}/include/cspice/
#  finally make symbolic links for sans version file names
if [ "$(uname)" == "Darwin" ];
then
    ln -s ${PREFIX}/lib/${LIBNAME} ${PREFIX}/lib/libcspice.dylib
else
    ln -s ${PREFIX}/lib/${LIBNAME} ${PREFIX}/lib/libcspice.so
fi
ln -s ${PREFIX}/lib/${CSPICENM} ${PREFIX}/lib/cspice.a
ln -s ${PREFIX}/lib/${CSUPPTNM} ${PREFIX}/lib/csupport.a