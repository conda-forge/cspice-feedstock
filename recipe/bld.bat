mkdir %LIBRARY_INC%\cspice

rem copy needed files to cspice source directory
copy "%RECIPE_DIR%\\makeDynamicSpice.bat" %SRC_DIR%\src\cspice
copy "%RECIPE_DIR%\\cspice.def" %SRC_DIR%\src\cspice

cd %SRC_DIR%\src\cspice

call makeDynamicSpice.bat
if errorlevel 1 exit 1

copy "cspice.dll" %LIBRARY_BIN%
if errorlevel 1 exit 1

copy "cspice.dll" %LIBRARY_LIB%
if errorlevel 1 exit 1

cd %SRC_DIR%

copy "include\\*.h" %LIBRARY_INC%\cspice
if errorlevel 1 exit 1

rem now that we have built the shared library we can do a full rebuild of cspice
call makeall.bat
if errorlevel 1 exit 1

rem now copy static libraries to location they need to be in to get into path
copy lib\cspice.lib %LIBRARY_LIB%\
if errorlevel 1 exit 1
copy lib\csupport.lib %LIBRARY_LIB%\
if errorlevel 1 exit 1

rem now copy executables to location they need to be in to get into path
copy "exe\*"  %LIBRARY_BIN%\
if errorlevel 1 exit 1
