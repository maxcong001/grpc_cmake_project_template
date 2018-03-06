#!/bin/bash

work_path=$(dirname $(readlink -f $0))
echo 'base working dir is :' $work_path
cd $work_path

git clone https://github.com/google/protobuf.git 
cd protobuf
sudo apt-get install autoconf automake libtool curl make g++ unzip 
./autogen.sh 
./configure 
make 
make check 
sudo make install 
sudo ldconfig

sudo apt install -y autoconf libtool cmake
git clone https://github.com/grpc/grpc.git
cd grpc
git submodule update --init
sudo make
sudo make install

cd $work_path
ls
