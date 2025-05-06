#! /bin/bash

# set up environment quickly
apt-get update -y
apt-get upgrade -y
apt-get install build-essential
apt-get install aptitude
apt-get install --reinstall ca-certificates -y
apt-get install apt-transport-https wget gnupg -y

# install git
apt-get install -y git
# install python 3.7
apt-get install -y python3.7
# install clang 13
wget -qO- https://apt.llvm.org/llvm.sh | bash -s -- 13
# install cmake 3.16
apt-get install -y cmake
# install conan 1.60
pip install conan
# libstdc++
apt-get install -y libstdc++6

# set up conan profile
conan profile new default --detect
conan profile update settings.compiler.cppstd=20 default
conan config set general.revisions_enabled=1
conan profile update settings.compiler.libcxx=libstdc++11 default
conan profile update 'conf.tools.build:cxxflags+=["-DBOOST_BEAST_USE_STD_STRING_VIEW"]' default
conan profile update 'env.CXXFLAGS="-DBOOST_BEAST_USE_STD_STRING_VIEW"' default
conan export external/snappy snappy/1.1.10@
conan export external/rocksdb rocksdb/9.7.3@
conan export external/soci soci/4.0.3@
conan export external/nudb nudb/2.0.8@

# build
mkdir .build
cd .build
conan install .. --output-folder . --build missing --settings build_type=Release
cmake -DCMAKE_TOOLCHAIN_FILE:FILEPATH=build/generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release -Dxrpld=ON -Dtests=ON ..
cmake --build .
