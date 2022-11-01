#!/bin/bash
function stream() { 
	#rm -f stream.c
        wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
        gcc -fopenmp -D_OPENMP -o3 -Ofast -mtune=native -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream
        export OMP_NUM_THREADS=2
        ./stream > stream.out
}
stream

