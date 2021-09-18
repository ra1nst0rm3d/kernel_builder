#!/bin/bash
# Script For Building Kernel
#
# Copyright (c) 2021 7Soldier
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
######################################################################
#                     Preparation for build                          #
######################################################################
echo "~~~~~~~~~~~~~~~~~~~"
echo "~~~CCCCCCCCCCCC~~~~"
echo "~~CC~~~~~~~~~~CC~~~"
echo "~CC~~~L~~~~~~~~CC~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "~CC~~~LLLLLL~~~CC~~"
echo "~~CC~~~~~~~~~~CC~~~"
echo "~~~CCCCCCCCCCCC~~~~"
echo "~~~~~~~~~~~~~~~~~~~"
echo "###################"
echo "# CLegacy prepare #"
echo "###################"

# Installing vars...
echo ""
echo "Setting vars..."
echo ""

export DATE=$(date +"%m-%d-%Y")
export BUILDER=$(pwd)
export KERNEL=$BUILDER/../kernel_xiaomi_begonia
export PATH="$BUILDER/toolchain/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64
export KERNELVERSION=v1.0

echo "OK!"

# Checking for kernel and other things...
echo ""
echo "Checking dependencies..."
echo ""

if ! [ -d $KERNEL ]; then
	echo 'Kernel not found!'
	echo 'Should I download the kernel?'
	echo '0) No'
	echo '1) Yes'
	read KERNELDOWNLOAD
	if [ "$KERNELDOWNLOAD" == 1 ]; then
		echo ""
		echo "Downloading kernel..."
		echo ""
		cd ..
		git clone https://github.com/7Soldier/kernel_xiaomi_begonia -b CLegacy
		cd $BUILDER
		echo "Download completed!"
		echo ""
	else
		echo ""
		echo "Aborting..."
		exit 0
	fi
fi

if ! [ -d $BUILDER/toolchain ]; then
	cd $BUILDER
	echo 'Compiller not found!'
	echo 'Downloading compiller...'
	git clone https://github.com/kdrag0n/proton-clang toolchain --depth=1
	echo 'Download completed!'
	echo ''
fi

if ! [ -d $BUILDER/AnyKernel3 ]; then
	cd $BUILDER
	echo 'AnyKernel not found!'
	echo 'Downloading anykernel...'
	git clone https://github.com/7Soldier/AnyKernel3
	echo 'Download completed!'
	echo ''
fi

echo "OK!"

# Defconfig setting
echo ""
echo "Installing kernel defcofnigs..."
echo ""

cd $KERNEL/arch/arm64/configs/
rm CLegacy_defconfig Neglect_defconfig Helium_defconfig
wget https://raw.githubusercontent.com/7Soldier/kernel_xiaomi_begonia/Configs/Neglect_defconfig
wget https://raw.githubusercontent.com/7Soldier/kernel_xiaomi_begonia/Configs/CLegacy_defconfig
#wget https://raw.githubusercontent.com/7Soldier/kernel_xiaomi_begonia/Configs/Helium_defconfig
cd $BUILDER

echo "OK!"

rm -rf *.zip
clear

######################################################################
#                         Start of building                          #
######################################################################
echo "~~~~~~~~~~~~~~~~~~~"
echo "~~~CCCCCCCCCCCC~~~~"
echo "~~CC~~~~~~~~~~CC~~~"
echo "~CC~~~L~~~~~~~~CC~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "~CC~~~LLLLLL~~~CC~~"
echo "~~CC~~~~~~~~~~CC~~~"
echo "~~~CCCCCCCCCCCC~~~~"
echo "~~~~~~~~~~~~~~~~~~~"
echo "###################"
echo "# CLegacy builder #"
echo "###################"

# Choosing a defconfig
echo ""
echo "Select the defconfig:"
echo "0) For CLegacy"
echo "1) For CLegacy mod - Neglect (for Lineage Os 18.1 by bugreporter)"
#echo "2) For CLegacy mod - Helium (for Nethunter)"
read DEFCONFIG

if ! [ "$DEFCONFIG" == 1 ]; then
	echo ""
	echo "Compiling CLegacy defconfig..."
	echo ""
	cd $KERNEL
	rm -rf out
	make mrproper
	make O=out ARCH=arm64 СС=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- CLegacy_defconfig
	cd $BUILDER

elif ! [ "$DEFCONFIG" == 2 ]; then
	echo ""
	echo "Compiling Neglect defconfig..."
	echo ""
	cd $KERNEL
	rm -rf out
	make mrproper
	make O=out ARCH=arm64 СС=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- Neglect_defconfig
	cd $BUILDER

#elif ! [ "DEFCONFIG" == 3 ]; then
#	echo ""
#	echo "Compiling Helium defconfig..."
#	echo ""
#	cd $KERNEL
#	rm -rf out
#	make mrproper
#	make O=out ARCH=arm64 СС=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- Helium_defconfig
#	cd $BUILDER

else
	echo ""
	echo "Compiling CLegacy defconfig..."
	echo ""
	cd $KERNEL
	rm -rf out
	make mrproper
	make O=out ARCH=arm64 CLegacy_defconfig
	cd $BUILDER
fi

# Building kernel
echo ""
echo "Start kernel building..."
echo ""

cd $KERNEL
make -j$(nproc) O=out ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-
cd $BUILDER

clear

######################################################################
#                         Result of build                            #
######################################################################
echo "~~~~~~~~~~~~~~~~~~~"
echo "~~~CCCCCCCCCCCC~~~~"
echo "~~CC~~~~~~~~~~CC~~~"
echo "~CC~~~L~~~~~~~~CC~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "CC~~~~L~~~~~~~~~~~~"
echo "~CC~~~LLLLLL~~~CC~~"
echo "~~CC~~~~~~~~~~CC~~~"
echo "~~~CCCCCCCCCCCC~~~~"
echo "~~~~~~~~~~~~~~~~~~~"
echo "###################"
echo "#   Build final   #"
echo "###################"

Zipper() {
	cp $KERNEL/out/arch/arm64/boot/Image.gz-dtb $BUILDER/AnyKernel3
	cd $BUILDER/AnyKernel3
	rm -rf *.zip

	if ! [ "$DEFCONFIG" == 1 ]; then
		zip -r9 CLegacy-[RELEASE-$KERNELVERSION]-[$DATE].zip *

	elif ! [ "$DEFCONFIG" == 2 ]; then
		zip -r9 Neglect-[RELEASE-$KERNELVERSION]-[$DATE].zip *

	#elif ! ["$DEFCONFIG" == 3]; then
	#	zip -r9 Helium-[RELEASE-$KERNELVERSION]-[$DATE].zip *

	else
		zip -r9 CLegacy-[RELEASE-$KERNELVERSION]-[$DATE].zip *
	fi

	cp $BUILDER/AnyKernel3/*.zip $BUILDER/
	cd $BUILDER

}

if [ -f $KERNEL/out/arch/arm64/boot/Image.gz-dtb ]; then
    	Zipper
	echo "Kernel was builded!"
	echo "Done!!!"
	exit 0
else
	echo "Kernel build failed!"
	cd $BUILDER
	exit 1
fi
