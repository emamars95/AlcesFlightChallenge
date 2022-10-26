#!/bin/bash

sudo yum group install "Development Tools" << EOF
y
EOF
sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo sh Miniconda3-latest-Linux-x86_64.sh -u

conda install -c conda-forge blas << EOF
y 
EOF

wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
conda install -c conda-forge gcc << EOF
y 
EOF
export OMP_NUM_THREADS=2 
gcc -fopenmp -D_OPENMP -o3 -Ofast -mtune=native -DSTREAM_ARRAY_SIZE=60000000 stream.c -o stream

conda install -c "conda-forge/label/openmpi_rc" openmpi-mpicc << EOF
y
EOF 
conda install -c conda-forge libcblas << EOF
y
EOF
wget https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz 
tar -xf hpl-2.3.tar.gz 
# ---------------------
# cd hpl-2.3 
# cp setup/Make.Linux_PII_CBLAS .
# Edit the file Make.Linux_PII_CBLAS with the main root for openmpi
# ./configure
# make arch=Linux_PII_CBLAS
# ---------------------- 
