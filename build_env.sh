#!/bin/bash

work_path=$(dirname $(readlink -f $0))
echo 'base working dir is :' $work_path
cd $work_path
sudo apt-get install autoconf automake libtool curl make g++ unzip 
sudo apt install -y autoconf libtool cmake

git clone https://github.com/google/protobuf.git 
cd protobuf
git checkout v3.5.2
./autogen.sh 
./configure 
make 
sudo make check 
sudo make install 
sudo ldconfig


git clone https://github.com/grpc/grpc.git
cd grpc
git checkout v1.10.0
git submodule update --init
make
sudo make install
