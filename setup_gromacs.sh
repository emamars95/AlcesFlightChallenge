#!/bin/bash

here=`pwd`

function setup_cuda() {
        export PATH="$PATH:/usr/local/cuda-11.8/bin"
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-11.8/lib64"
}

function setup_openmpi() {
	export PATH="$PATH:$HOME/openmpi/bin"
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/openmpi/lib"
}

function download() {
	gromacs=$1

	wget https://ftp.gromacs.org/gromacs/${gromacs}.tar.gz
	tar -xf ${gromacs}.tar.gz
	rm -f ${gromacs}.tar.gz
}

function build_gromacs() {

	gromacs=$1
        cd ${gromacs}
        mkdir -p build
        cd build

        #cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -DGMX_MPI=ON
        make -j8
        make check
        sudo make install
        source /usr/local/gromacs/bin/GMXRC
}

function install_gromacs() {
	gromacs=gromacs-2022.3

	#download $gromacs

	setup_cuda 
	set_openmpi
	build_gromacs $gromacs
}


install_gromacs

