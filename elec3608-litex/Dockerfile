# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

FROM ubuntu

ARG DATE

LABEL maintainer="ELEC3608" date="${DATE}" url="https://github.com/phwl/elec3608"

RUN apt-get --assume-yes --quiet update \
 && apt-get --assume-yes --quiet install apt-utils gosu sudo \
 && apt-get --assume-yes --quiet install build-essential device-tree-compiler \
    wget git python3-setuptools

# Prerequisites
RUN git clone https://github.com/litex-hub/linux-on-litex-vexriscv \
 && cd linux-on-litex-vexriscv

# Install LiteX
RUN mkdir /opt/litex && cd /opt/litex \
 && wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py \
 && chmod +x litex_setup.py \
 && ./litex_setup.py init install --user root \
 && ./litex_setup.py gcc
ENV PATH="/opt/litex/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14/bin:${PATH}"

# Install verilator
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections 
RUN apt-get -y install verilator gtkwave libevent-dev libjson-c-dev 

# Install sbt
RUN apt-get -y install curl \
  && echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list 
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list 
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add 
RUN sudo apt-get update \
  && sudo apt-get -y install default-jre sbt

COPY images/* /linux-on-litex-vexriscv/images

#    9  ls images/
#   10  cd images/
#   11  unzip /mnt/Downloads/linux_2021_03_29.zip 
#   12  cp /mnt/Downloads/linux_2021_03_29/* .
#   17  ./sim.py 
#   18  cp /mnt/Downloads/opensbi.bin images/
#   19  ./sim.py 

ENTRYPOINT ["/bin/bash"]
