#!/bin/bash

sudo yum install wget << EOF
y
EOF
rm -rf Miniconda3-latest-Linux-x86_64.sh << EOF
y
EOF
sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash $HOME/Miniconda3-latest-Linux-x86_64.sh -p $HOME/miniconda

rm -f conda.txt
wget https://raw.githubusercontent.com/emamars95/CIUK/main/conda.txt >> config.log
conda create -n challenge --file conda.txt 

eval "$(conda shell.bash hook)"
conda activate challenge

rm -f stream.c
wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
