#export LC_CTYPE=en_US.UTF-8
# needed to run Vivado without weird locale errors
#export LC_ALL=C

# paths
export PATH=$PATH:$HOME/.local/bin/

export OPTDIR=/opt
export PATH=$OPTDIR/Xilinx/Vivado/2018.3/bin:$PATH
export LD_LIBRARY_PATH=$OPTDIR/altera18.1/modelsim_ase/lib32
export PATH=$OPTDIR/altera18.1/modelsim_ase/linux:$PATH
