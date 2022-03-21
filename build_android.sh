#!/bin/bash
set -e
export NDK_HOME=/Users/leoliu/Library/Android/sdk/ndk-bundle
export PLATFORM_VERSION=android-10
export X264_LOCATION=/Volumes/MacData/Works/wxpayiot/aux/x264/android
function build
{
    echo "start build ffmpeg for $ARCH"
	make clean
	set -x
    ./configure --target-os=android \
    --prefix=$PREFIX --arch=$ARCH \
    --disable-doc \
    --enable-shared \
    --disable-static \
    --disable-yasm \
    --disable-asm \
    --disable-symver \
    --enable-gpl \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --cross-prefix=$CROSS_COMPILE \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --enable-small \
        --nm=$NM \
        --strip=$STRIP \
        --enable-libx264 \
        --extra-cflags="-I$InclueX264" \
        --extra-ldflags="-L$LinkX264"
    make -j8
    make install
    echo "build ffmpeg for $ARCH finished"
}


#x86
ARCH=x86_64
CPU=x86_64
PREFIX=$(pwd)/android/$ARCH
TOOLCHAIN=$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin
CROSS_COMPILE=$TOOLCHAIN/x86_64-linux-android26-
STRIP=$TOOLCHAIN/llvm-strip
NM=$TOOLCHAIN/llvm-nm
ADDI_CFLAGS="-marm"
InclueX264=$X264_LOCATION/$ARCH/include
LinkX264=$X264_LOCATION/$ARCH/lib
SYSROOT=$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
build

#arm64
ARCH=arm64
CPU=arm64
PREFIX=$(pwd)/android/$ARCH
TOOLCHAIN=$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin
CROSS_COMPILE=$TOOLCHAIN/aarch64-linux-android26-
ADDI_CFLAGS="-marm"
SYSROOT=$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
STRIP=$TOOLCHAIN/llvm-strip
NM=$TOOLCHAIN/llvm-nm
InclueX264=$X264_LOCATION/$ARCH/include
LinkX264=$X264_LOCATION/$ARCH/lib
build

#arm
ARCH=armv7a
CPU=armv7a
PREFIX=$(pwd)/android/$ARCH
TOOLCHAIN=$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin
CROSS_COMPILE=$TOOLCHAIN/armv7a-linux-androideabi26-
ADDI_CFLAGS="-marm"
SYSROOT=$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
STRIP=$TOOLCHAIN/llvm-strip
NM=$TOOLCHAIN/llvm-nm
InclueX264=$X264_LOCATION/$ARCH/include
LinkX264=$X264_LOCATION/$ARCH/lib
build

#http://lokie.wang/article/104
