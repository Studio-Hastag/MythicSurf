git clone https://github.com/intel/libva.git
cd libva
./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
make -j8
make install
cd ..
