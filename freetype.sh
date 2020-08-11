#/bin/zsh

wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.bz2
tar xvf freetype-2.4.12.tar.bz2
cd freetype-2.4.12
./configure --build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
make -j8
cd ..
mkdir -p /opt/altera18.1/modelsim_ase/lib32
cp freetype-2.4.12/objs/.libs/libfreetype.so* /opt/altera18.1/modelsim_ase/lib32
# Dumb fixes for Modelsim
sed -i "s/linux_rh60/linux/g" /opt/altera18.1/modelsim_ase/bin/vsim
# https://fabianlee.org/2018/10/28/linux-using-sed-to-insert-lines-before-or-after-a-match/
sed -i '0,/dir=`dirname/!b;//a export LD_LIBRARY_PATH=${dir}\/lib32' /opt/altera18.1/modelsim_ase/bin/vsim
