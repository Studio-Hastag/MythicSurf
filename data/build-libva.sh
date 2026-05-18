#!/bin/bash
#set -e

BITS="${1}"
echo Bits: $BITS

echo "*********** Building intel-gmmlib"
src="https://github.com/intel/gmmlib/archive/intel-gmmlib-20.3.3.tar.gz"
wget -nc ${src}

tar xf intel-gmmlib-20.3.3.tar.gz
cd gmmlib-intel-gmmlib-20.3.3

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
make -j4
strip Source/GmmLib/libigdgmm.so 
sudo make install

cd ../..

echo "*********** Building libva 2.9"
src="https://github.com/intel/libva/releases/download/2.9.0/libva-2.9.0.tar.bz2"
sha1file="https://github.com/intel/libva/releases/download/2.9.0/libva-2.9.0.tar.bz2.sha1sum"

wget -nc ${src}
wget -nc ${sha1file}

echo Checking sha1sum
sha=`sha1sum libva-2.9.0.tar.bz2`

if [ "$sha" != "`cat libva-2.9.0.tar.bz2.sha1sum`" ]; then
    echo "sha1sum doesn't match."
    exit 1
fi

echo sha1sum succeeded

tar xf libva-2.9.0.tar.bz2
cd libva-2.9.0

# patch -p1 < ../data/revert-upstream-pkgconfig-commit.patch
# patch -p1 < ../data/revert-upstream-pkgconfig-commit.patch

meson builddir --prefix=/usr -Dbuildtype=release -Dstrip=true
ninja -C builddir -j4
echo Installing libva 2.9
sudo ninja -C builddir install

cd ..

echo "*********** Building intel-media-driver"
src="https://github.com/intel/media-driver/archive/intel-media-20.3.0.tar.gz"
wget -nc ${src}

tar xf intel-media-20.3.0.tar.gz
cd media-driver-intel-media-20.3.0

if [ "$BITS" = "32" ]; then
    sed -i -e 's|-m${ARCH}||' media_driver/cmake/linux/media_compile_flags_linux.cmake
fi

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_CXX_FLAGS='-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64' ..
make -j4
strip media_driver/iHD_drv_video.so
strip cmrtlib/linux/libigfxcmrt.so

sudo make install




echo "*********** Building intel-vaapi-driver"
src="https://github.com/intel/intel-vaapi-driver/releases/download/2.4.1/intel-vaapi-driver-2.4.1.tar.bz2"
sha1file="https://github.com/intel/intel-vaapi-driver/releases/download/2.4.1/intel-vaapi-driver-2.4.1.tar.bz2.sha1sum"

wget -nc ${src}
wget -nc ${sha1file}

echo Checking sha1sum
sha=`sha1sum intel-vaapi-driver-2.4.1.tar.bz2`

if [ "$sha" != "`cat intel-vaapi-driver-2.4.1.tar.bz2.sha1sum`" ]; then
    echo "sha1sum doesn't match."
    exit 1
fi

echo sha1sum succeeded

tar xf intel-vaapi-driver-2.4.1.tar.bz2
cd intel-vaapi-driver-2.4.1

meson builddir --prefix=/usr -Dbuildtype=release
ninja -C builddir -j4
echo Installing intel-vaapi-driver
sudo ninja -C builddir install

cd ..


exit 0
