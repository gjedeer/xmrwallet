#!/bin/bash

# cd build
# ndkdir=/path/to/standalone/ndk/root ../external-libs/openssl/build.sh

OPENSSL_VERSION="1.0.2n"

BUILD_ROOT=`pwd`
OPENSSL_BUILD_ROOT="$BUILD_ROOT/openssl"

echo "SSL Build root: $OPENSSL_BUILD_ROOT"
mkdir -p $OPENSSL_BUILD_ROOT

if [ ! -f openssl-$OPENSSL_VERSION.tar.gz ]; then 
	wget -O openssl-$OPENSSL_VERSION.tar.gz https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
fi
tar xfz openssl-$OPENSSL_VERSION.tar.gz
cd openssl-$OPENSSL_VERSION/
perl -pi -e 's/install: all install_docs install_sw/install: install_docs install_sw/g' Makefile.org
CROSS_COMPILE= CC="$ndkdir/bin/arm-linux-androideabi-gcc" ./Configure shared no-ssl2 no-ssl3 no-comp no-hw no-engine android-armv7 --openssldir=$OPENSSL_BUILD_ROOT
make depend
make build_libs

cp -v libcrypto.a "$BUILD_ROOT/../external-libs/openssl/lib/armeabi-v7a/"
cp -v libssl.a "$BUILD_ROOT/../external-libs/openssl/lib/armeabi-v7a/"
