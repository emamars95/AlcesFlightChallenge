#!/bin/bash

function conda_act() {
        eval "$(conda shell.bash hook)"
        conda activate hpl

        conda env list
}

function setup() {
        echo -e "STARTING SET UP\n\n"

        sudo yum install wget << EOF
        y

EOF

        rm -rf Miniconda3-latest-Linux-x86_64.sh << EOF
        y
EOF

        sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
        rm -rf $HOME/miniconda $HOME/.conda
        bash $HOME/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
        $HOME/miniconda/condabin/conda init
        source $HOME/.bashrc
        eval "$(conda shell.bash hook)"

        #wget https://raw.githubusercontent.com/emamars95/CIUK/main/conda.yml
        conda env create -n challenge --file conda.yml
}

function benchmark_memory() {
        rm -f stream.c
        wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
        gcc -fopenmp -D_OPENMP -o3 -Ofast -mtune=native -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream
        export OMP_NUM_THREADS=2
        ./stream >> stream.out
}

function benchmark_gpu_memory() {
        root=BabelStream

        rm -rf $root
        git clone https://github.com/UoB-HPC/${root}.git
        cd $root
        cmake -Bbuild -H. -DMODEL=cuda -DCMAKE_CUDA_COMPILER="$HOME/miniconda/envs/hpl/bin/nvcc" -DCUDA_ARCH="sm_86" -DCMAKE_CXX_COMPILER="/home/centos/openmpi/bin/mpicxx"
        cmake --build build
        ./build/cuda-stream > ./build/cuda.out
}


function compile_MPI() {
        wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz
        tar -xf openmpi-4.1.4.tar.gz
        rm openmpi-4.1.4.tar.gz
        cd $HOME/openmpi-4.1.4
        ./configure --prefix=$HOME/openmpi
        make
        make install
}

function benchmark_IMB() {
        echo "Implement here"
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
        cp setup/Make.Linux_PII_CBLAS $HOME/${root}
        #        ./configure --prefix=${HOME}/${target} LDFLAGS="-L${HOME}/miniconda/envs/challenge/lib -L${HOME}/openmpi/lib" CPPFLAGS="-I${HOME}/openmpi/include"
        ./configure --prefix=${HOME}/${target} CPPFLAGS="-I${HOME}/openmpi/include"
        make #arch=Linux_PII_CBLAS
        make install
        cd $HOME/${target}/bin
        wget https://raw.githubusercontent.com/emamars95/CIUK/main/$file_name
        mv $file_name HPL.dat
        mpirun -np 64 xhpl > HPL.out
}

function benchmark_manual() {
        folder="test_manual"

        mkdir -p $folder
        cd $folder
        wget https://raw.githubusercontent.com/emamars95/CIUK/main/code.cpp
        wget https://raw.githubusercontent.com/emamars95/CIUK/main/Makefile
        make
        ./code 3000 > code.out
}

function set_up_A40() {
        wget https://uk.download.nvidia.com/tesla/515.65.01/NVIDIA-Linux-x86_64-515.65.01.run
        sudo yum install "kernel-devel-uname-r == $(uname -r)"
        chmod 770 NVIDIA-Linux-x86_64-515.65.01.run
        sudo ./NVIDIA-Linux-x86_64-515.65.01.run
}

function set_up_gromacs() {
        root=gromacs-2022.1

        rm -rf $root
        wget http://ftp.gromacs.org/pub/gromacs/${root}.tar.gz
        tar -xf ${root}.tar.gz
        rm ${root}.tar.gz
        cd $root
        mkdir build
        cd build

        cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=OFF -DGMX_MPI=ON -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-11.8/ -DCMAKE_INSTALL_PREFIX=${HOME}/gromacs

        make -j10
        make check
        sudo make install
        source ${HOME}/gromacs/bin/GMXRC
}


function set_up_test()  {
        sudo yum install php
        sudo yum install php-xml
        sudo yum install php-pecl-json
        git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git
        cd phoronix-test-suite
        ./phoronix-test-suite benchmark gromacs
}

function benchmark() {
        #conda_act

        #benchmark_memory
        #compile_MPI
        #benchmark_IMB
        #benchmark_hpl
        #benchmark_manual

        #set_up_A40
        #benchmark_gpu_memory

        #export PATH="$PATH:/usr/local/cuda-11.8/bin"
        #export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-11.8/lib"
        #set_up_gromacs
        set_up_test()
}



#setup
benchmark
