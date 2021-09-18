#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please, run this script as root"
	exit 1
fi

echo "Install packages for kernel compilling... (use this script only once)"

apt update -y && apt full-upgrade -y
apt-get -y install git automake lzop bison gperf build-essential curl zlib1g-dev libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng bc libstdc++6 wget python3 python3-pip python gcc clang libssl-dev rsync flex git-lfs libz3-dev libz3-4 axel clang gcc llvm gcc-9-arm* gcc-10-arm* gcc-aarch64-linux-gnu make bc bison flex build-essential lld  device-tree-compiler ccache libssl-dev python python2 python3 zip tar nano libncurses-dev libelf-dev wget python3-pip cpio lld lld-11
python3 -m pip install networkx

clear

echo "Done!!!"
exit 0
