#!/bin/bash

BUILD_START=$(date +"%s")
VERSION=$2
PARAM=$1

echo
echo "Issue Build Commands"
echo

# CLANG_RELEASE=clang-r450784e
CLANG_RELEASE=clang-r416183b1
# CLANG_RELEASE=clang-r383902b

mkdir -p out
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=/mnt/Data/tools/Android_dev/Clang_Google/linux-x86/$CLANG_RELEASE/bin
export MKDTIMG_PATH=/mnt/Data/tools/Android_dev/mkdtimg/bin
export SPLIT_DTB_PATH=/mnt/Data/tools/Android_dev/split-appended-dtb-master
export DEV_PACK_PATH=/home/wlkmanist/Proj/guacamole/dev
export PATH=${CLANG_PATH}:${MKDTIMG_PATH}:${SPLIT_DTB_PATH}:${DEV_PACK_PATH}:${PATH}
# export DTC_EXT=/mnt/Data/tools/Android_dev/dtc-1.6.1/dtc
# export DTC_EXT=/home/wlkmanist/Proj/guacamole/project.black-guacamole/out/scripts/dtc/dtc
# export DTC_EXT=dtc
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=/mnt/Data/tools/Android_dev/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/mnt/Data/tools/Android_dev/gcc-linaro-7.5.0-2019.12-i686_aarch64-linux-gnu/bin/aarch64-linux-gnu-
export LD_LIBRARY_PATH=/mnt/Data/tools/Android_dev/Clang_Google/linux-x86/$CLANG_RELEASE/bin:$LD_LIBRARY_PATH

case "$PARAM" in
  "")
  ;;
  "def")
    echo
    echo "Set main DEFCONFIG"
    echo
    make ARCH=arm64 CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out black_defconfig
  ;;
  "dbg")
    echo
    echo "Set dbg DEFCONFIG"
    echo
    make ARCH=arm64 CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out blackdbg_defconfig
  ;;
  "cln")
    make clean && make mrproper
  ;;
  "rdy")
    if [ -z "$VERSION" ]; then
	echo "Usage: ./build rdy [version letter]"
	exit -1
    else
	cd ../dev
	copy_boot.sh $VERSION
	exit 0
    fi
  ;;
  "--help" | * )
    echo "Usage: ./build [param (optional)]"
    echo ""
    echo "Params:"
    echo "  [none]: build only"
    echo "  def   : build with main defconfig"
    echo "  dbg   : build with debug defconfig"
    echo "  cln   : make clean and build"
    echo "  rdy   : build only then export"
    echo "  --help: display this"

    exit 0
  ;;
esac

echo
echo "Build The Good Stuff"
echo 

rm -r /home/wlkmanist/Proj/guacamole/project.black-guacamole/out/arch/arm64/boot/*
make ARCH=arm64 CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out -j4

cd ~/Proj/guacamole/project.black-guacamole/out/arch/arm64/boot/
split-appended-dtb ./Image-dtb
cat ./dtbdump_*.dtb >> ./dtb

BUILD_END=$(date +"%s")
TIME_DIFF=$(($BUILD_END - $BUILD_START))

echo ""
echo -e "Build time: $((TIME_DIFF / 60))m $((TIME_DIFF % 60))s."
echo ""

