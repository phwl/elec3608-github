FROM ubuntu:18.04 as baseline
 
MAINTAINER Nachiket Kapre <nachiket@uwaterloo.ca>
 
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/altera18.1/modelsim_ase/linux:/opt/Xilinx/Vivado/2018.3/bin:${PATH}
# install dependences for Vivado and Modelsim:
# Vivado compile quit after ~30 mins failing to find libxtst6
RUN apt-get update && apt-get install -y \
  wget \
  curl \
  build-essential \
  git \
  bash \
  zsh \
  libxtst6 \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  vim-gnome \
  x11-apps \
  python \
  verilator \
  unzip \
  tmux \
  python-numpy
 
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
COPY .zshrc /root
 
# setup modelsim ase
FROM baseline as modelsim
 
ARG MODELSIM_FILE="ModelSimSetup-18.1.0.625-linux.run"
COPY ${MODELSIM_FILE} /
RUN chmod 755 ${MODELSIM_FILE} \
 && /${MODELSIM_FILE} --mode unattended --accept_eula 1 --installdir /opt/altera18.1 && rm -f /${MODELSIM_FILE} \
 && rm -rf /opt/altera18.1/modelsim_ase/altera
 
 
FROM modelsim as modelsim1
# Fixes for Modelsim
# From https://gist.github.com/PrieureDeSion/e2c0945cc78006b00d4206846bdb7657
RUN dpkg --add-architecture i386
RUN apt-get install build-essential
RUN apt-get update && apt-get install -y \
      gcc-multilib g++-multilib \
      lib32z1 lib32stdc++6 lib32gcc1 \
      expat:i386 fontconfig:i386 libfreetype6:i386 libexpat1:i386 libc6:i386 libgtk-3-0:i386 \
      libcanberra0:i386 libice6:i386 libsm6:i386 libncurses5:i386 zlib1g:i386 \
      libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 \
      libxt6:i386 libxtst6:i386
 
COPY freetype.sh /
RUN chmod 755 /freetype.sh
RUN /freetype.sh
 
FROM modelsim1 as sim-only
# Setting up user
ARG USER_NAME=elec3608
RUN adduser --disabled-password --gecos '' ${USER_NAME}
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
COPY .zshrc /home/${USER_NAME}
COPY .bashrc /home/${USER_NAME}
ENTRYPOINT ["/bin/bash"]
