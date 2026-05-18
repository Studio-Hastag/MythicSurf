#!/bin/bash
# set -e

echo "*************** Building Pipewire 1.0.5"
rm -rf pipewire*
version="1.0.5"
file_base="pipewire-${version}"
file="${file_base}.tar.gz"
src="https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/${version}/${file}"
wget ${src}

tar xf ${file}
echo "what"
cd ${file_base}
echo "how"


apt install -m -y libcamera-dev \
               libmysofa-dev \
               libffado-dev \
               liblilv-dev \
               libavahi-client-dev \
               libbluetooth-dev \
               libsdl2-dev \
               libroc-dev


meson setup build --prefix=/usr \
                  --buildtype=release \
                  --strip \
                  -Dsession-managers=[] \
                  -Dalsa=disabled \
                  -Dpipewire-alsa=disabled \
                  -Djack=disabled \
                  -Dpipewire-jack=disabled \
                  -Dselinux=disabled \
                  -Dsession-managers=[]

ninja -C build -j4
ninja -C build install

