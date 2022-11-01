#
# A simple makefile for compiling a c++ project
#
ROOT=/home/centos/miniconda/envs/hpl

NAME=code
TARGET=./$(NAME).cpp
GCC = g++
INCLUDE = $(ROOT)/include
LD_LIBRARY = $(ROOT)/lib
CFLAGS = -o $(NAME) -Wl,-rpath $(LD_LIBRARY) -I$(INCLUDE) -L$(LD_LIBRARY) -lopenblas

RM = rm -rf

default: code

code: $(TARGET)
	$(GCC) $(TARGET) $(CFLAGS) 

clean: 
	$(RM) code
