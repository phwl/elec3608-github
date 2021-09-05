#!/bin/bash

# https://github.com/riscv/riscv-pk/issues/39

TOP=/
[ -z "$TOP" ] && echo "TOP is not defined" && exit -1
[ -z "$RISCV" ] && echo "RISCV is not defined" && exit -1

cd $TOP
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
git checkout 1b80cbe97d2c29212398d3b74ddc54718ad32e23
rm -rf build && mkdir build && cd build
../configure --prefix=$RISCV --with-arch=rv32i --with-abi=ilp32 --with-xlen=32
make

cd $TOP
git clone https://github.com/riscv/riscv-fesvr.git
cd riscv-fesvr
git checkout 0d34fdbe104cbe0f07df6d9aceb2763f5fbba123
rm -rf build && mkdir build && cd build
../configure --prefix=$RISCV
sed -i 's:CXXFLAGS\s\++=:CXXFLAGS += -DTARGET_ARCH=\\"riscv32-unknown-elf\\":' Makefile
make
make install

cd $TOP
git clone https://github.com/riscv/riscv-pk.git
cd riscv-pk
git checkout 2bbd8e1a1bccae13ec87882baf423abfc6ef76fd
rm -rf build && mkdir build && cd build
../configure --prefix=$RISCV --host=riscv32-unknown-elf --enable-32bit
sed -i 's:-m32::g' Makefile
make
make install

cd $TOP
git clone https://github.com/riscv/riscv-isa-sim.git
cd riscv-isa-sim
git checkout 7e35a2a62f7433060e2ab1c98b3afd8b8a69b829
rm -rf build && mkdir build && cd build
../configure --prefix=$RISCV --with-fesvr=$RISCV --with-isa=rv32i --enable-histogram --with-xlen=32
make
make install
