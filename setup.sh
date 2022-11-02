#!/bin/bash

function install_wget () {
        echo -e "INSTALL WGET\n"
        sudo yum -y install wget
}

function install_devtoll() {
        echo -e "INSTALL DEV TOOL\n"
        sudo yum -y groupinstall "Development tools"
        echo -e "INSTALL CMAKE\n"
        sudo yum -y install cmake
}


function setup_myenv(){
        eval "$(conda shell.bash hook)"

        conda activate myenv
        conda env list
        conda install -y -c conda-forge c-compiler compilers cxx-compiler
        conda install -y -c conda-forge openmpi openmpi-mpicc openmpi-mpicxx
}

function install_miniconda() {
        echo -e "INSTALL MINICONDA\n"
        sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
        bash $HOME/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
        $HOME/miniconda/condabin/conda init
        source $HOME/.bashrc
        echo -e "CREATE NEW ENVIROMENT\n"
        conda create --name myenv python=3.10 << EOF
y
EOF
        setup_myenv
}

function setup() {
        echo -e "STARTING SET UP\n\n"
        install_wget
        install_devtoll
        install_miniconda
}

function set_up_A40() {
        wget https://uk.download.nvidia.com/tesla/515.65.01/NVIDIA-Linux-x86_64-515.65.01.run
        chmod 770 NVIDIA-Linux-x86_64-515.65.01.run

        echo -e "INSTALL KERNEL\n\n"
        sudo yum install "kernel-devel-uname-r == $(uname -r)" << EOF
y
EOF
        echo -e "INSTALL A40 DRIVER\n"
        sudo ./NVIDIA-Linux-x86_64-515.65.01.run
        nvidia-smi
}

function gpu_driver() {
        echo -e "PRINT FOUND NVIDIA GPU\n"
        output=`sudo lshw -c display | grep "product:" | head -1`
        echo "$output"
        if [[ "${output}" == *"A40"* ]]; then
                echo -e "WE SET UP A40"
                set_up_A40
        else
                echo -e "NOT IMPLEMENTED YET"
        fi
}

function install_cuda() {
        echo -e "INSTALL CUDA\n\n"
        wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
        sudo sh cuda_11.8.0_520.61.05_linux.run
}


function cuda(){
        gpu_driver
        install_cuda
}


function openmpi() {
        ompi=openmpi-4.1.4

        wget https://download.open-mpi.org/release/open-mpi/v4.1/${ompi}.tar.gz
        tar -xf ${ompi}.tar.gz
        rm ${ompi}.tar.gz
        cd $HOME/${ompi}
        ./configure --prefix=/usr/local
        make -j8
        sudo make install
}

function download() {
        git clone https://github.com/emamars95/CIUK.git
        chmod 770 CIUK/*
}

function run_and_collect_gromacs(){
        bash gromacs.sh
        bash collect.sh
}

function shutdown(){
        bash shutdown.sh
}

setup
download
cuda
openmpi
bash CIUK/setup_gromacs.sh
~                                                                                                                         
