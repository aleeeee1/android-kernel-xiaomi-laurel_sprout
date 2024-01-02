#!/bin/bash

set -x

export PATH=$HOME/proton-clang/bin:$PATH
export ARCH=arm64
export LINUX_COMPILE_BY="Anirudh"
export LINUX_COMPILE_HOST="vinimec"

ccache -M 2G
export USE_CCACHE=1
export CCACHE_EXEC=$(command -v ccache)

[ -d out ] && rm -rf out
make -j $(nproc --all) vendor/laurel_sprout-perf_defconfig O=out
make -j $(nproc --all) -k CC="ccache clang" O=out CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-
make -j $(nproc --all) -C AnyKernel3 clean

if [ "$?" == 0 ]; then
   cp $(pwd)/out/arch/arm64/boot/Image $(pwd)/AnyKernel3
   cp $(pwd)/out/arch/arm64/boot/Image.gz-dtb $(pwd)/AnyKernel3
   cp $(pwd)/out/arch/arm64/boot/dtbo.img $(pwd)/AnyKernel3
   cp $(pwd)/out/arch/arm64/boot/dtb.img $(pwd)/AnyKernel3
   cd $(pwd)/AnyKernel3
   make -j $(nproc --all)
   # zipname=$(ls *.zip)
   # url=$(curl --upload-file ./${zipname} https://transfer.sh/${zipname})
   # echo -e "\nKernel Url:"
   # echo "${url}"
   # echo -e "\n"
   # cd ..
fi
