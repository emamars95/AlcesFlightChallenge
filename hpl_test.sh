#!/bin/bash 

function install_openblas() {
	git clone https://github.com/xianyi/OpenBLAS.git
	cd OpenBLAS
	make -j4 
	make PREFIX="${HOME}/openblas"
}

function install_mkl() {
	wget https://registrationcenter-download.intel.com/akdlm/irc_nas/18721/l_onemkl_p_2022.1.0.223.sh
	sudo sh ./l_onemkl_p_2022.1.0.223.sh
	source /opt/intel/oneapi/mkl/2022.1.0/env/vars.sh intel64
}

function benchmark_hpl() {
        root="hpl-2.3"
        source="${root}.tar.gz"
        target="hpl"
        file_name=HPL.dat_A40

        rm -rf $HOME/${root}
        wget https://netlib.org/benchmark/hpl/$source
        tar -xf $source
        rm $source
        cd ${root}
#        ./configure --prefix=${HOME}/${target} LDFLAGS="-L${HOME}/openblas/"

	./configure --prefix=${HOME}/${target} 
        make install
        cd $HOME/${target}/bin
        wget https://raw.githubusercontent.com/emamars95/CIUK/main/$file_name
        mv $file_name HPL.dat
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${HOME}/OpenBLAS/"
        mpirun -np 64 xhpl > HPL.out
}

#install_openblas
benchmark_hpl
