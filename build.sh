git submodule init
git submodule update

. /etc/os-release

BUILD_TYPE=release
SOURCE_DIR=$(pwd)

cd ./aes
make
cd ../


cd mtcp

if [ ! -d "dpdk/x86_64-native-linuxapp-gcc" ]; then
  ./build_dpdk.sh
fi

export RTE_SDK=$PWD/dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc

cd ..
cd proto
protoc --cpp_out=. http.proto
protoc --cpp_out=. mcc.proto
cd ..
mkdir -p build/$BUILD_TYPE
cd build/$BUILD_TYPE

if [ "$ID" = "centos" ]; then
  cmake3 -D CMAKE_CXX_COMPILER=/opt/rh/devtoolset-8/root/bin/c++ \
    -D CMAKE_BUILD_TYPE=$BUILD_TYPE \
    $SOURCE_DIR
fi

make -j $(nproc)


