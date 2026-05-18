#cd buildtools/third_party/eu-strip
#./build.sh
#cd ../../..
# tools/clang/scripts/build.py --disable-asserts --without-android --without-fuchsia --gcc-toolchain=/usr --use-system-cmake

echo Building CMake
# Building clang requires a version of cmake newer than what's in
        # focal. Fetch it and build it from source.
CMAKE_VERSION=3.18.1
wget -O - https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz | tar -x -z
cd cmake-$CMAKE_VERSION
./bootstrap --prefix=/usr
make -j8 install
cd ..


echo Building initial clang
python3 tools/clang/scripts/build.py --skip-build --without-android --without-fuchsia

echo Patching libatomic
patch -p1 < ../patches/llvm/libatomic-32b.patch

echo Building final
python3 tools/clang/scripts/build.py --skip-checkout --bootstrap --disable-asserts --pgo --without-android --without-fuchsia --gcc-toolchain=/usr --use-system-cmake
