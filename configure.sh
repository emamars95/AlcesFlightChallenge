#!/bin/bash

sudo yum group install "Development Tools"
sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo sh Miniconda3-latest-Linux-x86_64.sh

conda install -c conda-forge blas

wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
conda install -c conda-forge gcc
export OMP_NUM_THREADS=2 
gcc -fopenmp -D_OPENMP -o3 -Ofast -mtune=native -DSTREAM_ARRAY_SIZE=60000000 stream.c -o stream

