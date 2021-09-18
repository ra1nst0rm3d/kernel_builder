#!/bin/bash

export BUILDER=pwd
export KERNEL=$BUILDER/../kernel_xiaomi_begonia

echo "Removing compilled files in builder folder..."
rm -rf *_defconfig AnyKernel3/*.zip AnyKernel3/Image.gz-dtb *.zip
echo ""
echo "Removing 'out' folder in kernel..."
rm -rf $KERNEL/out
echo ""
echo "Cleaning kernel sources..."
cd $KERNEL
make mrproper
cd $BUILDER


echo "Done!!!"
exit 0
