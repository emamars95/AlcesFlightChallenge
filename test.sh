#!/bin/bash

sudo yum install wget << EOF
y
EOF
sudo wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ~/miniconda.sh -p $HOME/miniconda



eval "$(conda shell.bash hook)"
conda activate <env-name>

wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
