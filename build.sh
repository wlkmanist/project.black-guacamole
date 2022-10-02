#!/bin/bash

BUILD_START=$(date +"%s")

# echo
# echo "Clean Build Directory"
# echo 

# make clean && make mrproper

echo
echo "Issue Build Commands"
echo

#CLANG_RELEASE=clang-r450784e
CLANG_RELEASE=clang-r416183b1
# CLANG_RELEASE=clang-r383902b

mkdir -p out
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=/mnt/Data/tools/Android_dev/Clang_Google/linux-x86/$CLANG_RELEASE/bin
export PATH=${CLANG_PATH}:${PATH}
export DTC_EXT=/mnt/Data/tools/Android_dev/dtc-1.6.1/dtc
# export DTC_EXT=dtc
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=/mnt/Data/tools/Android_dev/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
# export CROSS_COMPILE=~/Android_Build/GCC_Google_Arm64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
# export CROSS_COMPILE_ARM32=~/Android_Build/GCC_Google_Arm32/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export LD_LIBRARY_PATH=/mnt/Data/tools/Android_dev/Clang_Google/linux-x86/$CLANG_RELEASE/bin:$LD_LIBRARY_PATH

echo
echo "Set DEFCONFIG"
echo 
make ARCH=arm64 CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out black_defconfig

echo
echo "Build The Good Stuff"
echo 

make ARCH=arm64 CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out -j4

BUILD_END=$(date +"%s")
TIME_DIFF=$(($BUILD_END - $BUILD_START))

echo ""
echo -e "Build time: $((TIME_DIFF / 60))m $((TIME_DIFF % 60))s."
echo ""

