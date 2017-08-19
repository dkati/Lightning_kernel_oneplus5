#!/bin/bash

#
#  Build Script for Chemi Kernel for OnePlus 5!
#  Based off RenderBroken's build script which is...
#  ...based off AK's build script - Thanks!
#

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image.gz-dtb"
DEFCONFIG="lightning_defconfig"

# Kernel Details
VER=Lightning-Kernel-V8
VARIANT="OP5-LOS-N-V8"

# Vars
export LOCALVERSION=~`echo $VER`
export ARCH=arm64
export SUBARCH=arm64

# Paths
KERNEL_DIR="${HOME}/android/op5cm14/kernel/oneplus/lightning"
REPACK_DIR="${HOME}/android/op5cm14/kernel/oneplus/anykernel"
PATCH_DIR="${HOME}/android/op5cm14/kernel/oneplus/anykernel/patch/"
MODULES_DIR="${HOME}/android/op5cm14/kernel/oneplus/anykernel/modules/"
ZIP_MOVE="${HOME}/android/op5cm14"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm64/boot"

function clean_all {
		cd $REPACK_DIR
		rm -rf $MODULES_DIR/*
		rm -rf $KERNEL
		rm -rf zImage
		cd $KERNEL_DIR
		echo
		make clean && make mrproper
}

function make_kernel {
		echo
		make $DEFCONFIG
		make $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/zImage
}

function make_modules {
		rm `echo $MODULES_DIR"/*"`
		find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
}

function make_zip {
		cd $REPACK_DIR
		zip -r9 Lightning-Kernel-"$VARIANT".zip *
		mv Lightning-Kernel-"$VARIANT".zip $ZIP_MOVE
		cd $KERNEL_DIR
}


DATE_START=$(date +"%s")

echo "Build Script:"
export CROSS_COMPILE=${HOME}/android/op5cm14/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
echo

while read -p "Do you want to clean (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
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

while read -p "Do you want to build kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_kernel
		make_modules
		make_zip
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

echo "-------------------"
echo "Build Completed in:"
echo "-------------------"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
