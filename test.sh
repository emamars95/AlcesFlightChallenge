#!/bin/bash

sudo yum install wget >> config.log << EOF
y
EOF
sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh >> config.log
bash ~/miniconda.sh -p $HOME/miniconda >> config.log

wget https://raw.githubusercontent.com/emamars95/CIUK/main/conda.txt >> config.log
conda create -n challenge --file conda.txt 

eval "$(conda shell.bash hook)"
conda activate challenge

wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
