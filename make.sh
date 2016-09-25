#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j12"
DEFCONFIG="int3nse_defconfig"
VER="0.1"

# Vars

export CROSS_COMPILE=/home/joe/TC/aarch64-linux-android-6.x-kernel-linaro/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64

# Paths
KERNEL_DIR=`pwd`

# Functions
function clean_all {
		echo
		make mrproper
}

function clean_out {
                rm -f ../kernel_out/zImage
                rm -f ../kernel_out/INT3NSE*.zip
}

function make_kernel {
		echo
		make $DEFCONFIG
		make $THREAD
}

function modules {
                find ./ -type f -name '*.ko' -exec cp -f {} ../kernel_out/modules/ \;
}

function zImage {
                cp -f arch/arm64/boot/Image.gz-dtb ../kernel_out/zImage
    		ls -l ../kernel_out/zImage
		cd ../kernel_out
		zip -r -9 INT3NSEKernel-"$VER".zip * > /dev/null
}

DATE_START=$(date +"%s")

echo -e "${green}"
echo " Kernel Script:"
echo -e "${restore}"

while read -p "Clean build ? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
                clean_out
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Build kernel ? " dchoice
do
case "$dchoice" in
	y|Y)
		make_kernel
                modules
                zImage
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
