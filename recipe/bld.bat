@echo on
mkdir build
cd build

cmake -G "Ninja" ^
  %CMAKE_ARGS% ^
  -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DBUILD_EXECUTABLES=ON ^
  -DBUILD_SHARED_LIBS=ON ^
  ..

if errorlevel 1 exit /b 1
ninja install
if errorlevel 1 exit /b 1

