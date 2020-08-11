# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

FROM ubuntu

ARG DATE

LABEL maintainer="ELEC3608" date="${DATE}" url="https://github.com/phwl/elec3608"

RUN apt-get --assume-yes --quiet update \
 && apt-get --assume-yes --quiet install apt-utils gosu sudo \
 && apt-get --assume-yes --quiet install autoconf automake \
    autotools-dev curl libmpc-dev \
    libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
    gperf libtool patchutils bc zlib1g-dev git libexpat1-dev

# The build seems to trigger an existing bug, see, e.g., [1], related to the 
# maximum path length supported by the underlying file system: we'll create 
# a path that cannot then be removed.  The fix is simple: we just relocate a 
# sub-directory, shortening the path so it *can* then be removed.
# 
# [1] https://github.com/moby/moby/issues/13451

ENV RISCV "/opt/riscv32i"

RUN mkdir /opt/riscv32i 

RUN git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i \
 && cd /riscv-gnu-toolchain-rv32i \
 && git checkout 411d134 \
 && git submodule update --init --recursive \
 && mkdir build && cd build \
 && ../configure --with-arch=rv32i --prefix=/opt/riscv32i \
 && make -j$(nproc) \
 && rm -rf /riscv-gnu-toolchain-rv32i 

RUN git clone https://github.com/riscv/riscv-isa-sim.git \
 && cd riscv-isa-sim \
 && apt-get --assume-yes --quiet install python3 vim \
 && apt-get --assume-yes --quiet install device-tree-compiler \
 && mkdir build \
 && cd build \
 && ../configure --prefix=$RISCV \
 && make \
 && make install \
 && rm -rf /riscv-isa-sim

ENV PATH=/opt/riscv32i/bin:$PATH

RUN git clone https://github.com/riscv/riscv-pk.git \
 && cd riscv-pk \
 && mkdir build \
 && cd build \
 && ../configure --prefix=$RISCV --with-arch=rv32i --host=riscv32-unknown-elf \
 && make \
 && make install \
 && rm -rf /riscv-pk \
 && apt-get clean autoclean autoremove

ENTRYPOINT ["/bin/bash"]
