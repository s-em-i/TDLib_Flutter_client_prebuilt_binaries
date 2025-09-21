#!/bin/bash
set -e  # Exit on error

echo "[+] Starting TDLib Multi-Arch Build with Clang-18"
echo "[+] Installed tools: $(clang-18 --version | head -1)"

# 1. x86_64 Release Build
echo "=== Building x86_64 Release ==="
mkdir -p build-x86_64-release && cd build-x86_64-release

cat > toolchain-x86_64.cmake << 'EOF'
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER clang-18)
set(CMAKE_CXX_COMPILER clang++-18)
set(CMAKE_AR llvm-ar-18)
set(CMAKE_RANLIB llvm-ranlib-18)
set(CMAKE_NM llvm-nm-18)
set(CMAKE_OBJDUMP llvm-objdump-18)
set(CMAKE_LINKER lld-18)
set(CMAKE_CXX_FLAGS "-stdlib=libc++")
set(CMAKE_C_FLAGS "")
EOF

CXXFLAGS="-stdlib=libc++" CC=clang-18 CXX=clang++-18 \
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_TOOLCHAIN_FILE=../toolchain-x86_64.cmake \
      -DCMAKE_INSTALL_PREFIX=../tdlib-x86_64-release \
      -DTD_ENABLE_LTO=ON \
      -G "Unix Makefiles" \
      ..

make -j$(nproc)
make install
cd ..

# 2. x86_64 Debug Build
echo "=== Building x86_64 Debug ==="
mkdir -p build-x86_64-debug && cd build-x86_64-debug

cat > toolchain-x86_64.cmake << 'EOF'
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER clang-18)
set(CMAKE_CXX_COMPILER clang++-18)
set(CMAKE_AR llvm-ar-18)
set(CMAKE_RANLIB llvm-ranlib-18)
set(CMAKE_NM llvm-nm-18)
set(CMAKE_OBJDUMP llvm-objdump-18)
set(CMAKE_LINKER lld-18)
set(CMAKE_CXX_FLAGS "-stdlib=libc++ -g -O0")
set(CMAKE_C_FLAGS "-g -O0")
EOF

CXXFLAGS="-stdlib=libc++ -g -O0" CC=clang-18 CXX=clang++-18 \
cmake -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_TOOLCHAIN_FILE=../toolchain-x86_64.cmake \
      -DCMAKE_INSTALL_PREFIX=../tdlib-x86_64-debug \
      -DTD_ENABLE_LTO=OFF \
      -G "Unix Makefiles" \
      ..

make -j$(nproc)
make install
cd ..

# 3. ARM64 Release Build
echo "=== Building ARM64 Release ==="
mkdir -p build-arm64-release && cd build-arm64-release

cat > toolchain-arm64.cmake << 'EOF'
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_C_COMPILER clang-18)
set(CMAKE_CXX_COMPILER clang++-18)
set(CMAKE_AR llvm-ar-18)
set(CMAKE_RANLIB llvm-ranlib-18)
set(CMAKE_NM llvm-nm-18)
set(CMAKE_OBJDUMP llvm-objdump-18)
set(CMAKE_LINKER lld-18)
set(CMAKE_C_FLAGS "-target aarch64-linux-gnu")
set(CMAKE_CXX_FLAGS "-target aarch64-linux-gnu -stdlib=libc++")
set(CMAKE_EXE_LINKER_FLAGS "-target aarch64-linux-gnu")
set(CMAKE_SHARED_LINKER_FLAGS "-target aarch64-linux-gnu")
set(CMAKE_FIND_ROOT_PATH /usr/aarch64-linux-gnu)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF

CXXFLAGS="-stdlib=libc++ -target aarch64-linux-gnu" \
CC=clang-18 \
CXX=clang++-18 \
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm64.cmake \
      -DCMAKE_INSTALL_PREFIX=../tdlib-arm64-release \
      -DTD_ENABLE_LTO=ON \
      -G "Unix Makefiles" \
      ..

make -j$(nproc)
make install

# Verify ARM64 binary
cd ../tdlib-arm64-release/lib/
file libtdjson.so
cd ../../..

echo "[+] All builds completed!"
echo "[+] x86_64 Release: tdlib-x86_64-release/"
echo "[+] x86_64 Debug: tdlib-x86_64-debug/"  
echo "[+] ARM64 Release: tdlib-arm64-release/"

# Create summary
echo "=== BUILD SUMMARY ===" 
ls -la tdlib-*-release/lib/ | grep libtdjson
