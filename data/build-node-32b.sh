ln -s `which gold` /usr/local/bin/ld

cd third_party/node
NODE_VERSION=$(grep NODE_VERSION= update_node_binaries | cut -d\" -f2)
NODE_DIST_BASE_URL=$(grep BASE_URL= update_node_binaries | cut -d\" -f2)
wget -O - $NODE_DIST_BASE_URL/$NODE_VERSION/node-$NODE_VERSION.tar.xz | tar -x --xz
cd node-$NODE_VERSION
./configure --prefix=
make -j6
DESTDIR=$PWD/../linux/node-linux-x64 PREFIX= make install
cd ../../..

rm /usr/local/bin/ld