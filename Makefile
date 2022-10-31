#
# A simple makefile for compiling a c++ project
#

NAME=code
TARGET=./$(NAME).cpp
GCC = g++
INCLUDE = /usr/software/anaconda3/envs/challenge/include
LD_LIBRARY = /usr/software/anaconda3/envs/challenge/lib
CFLAGS = -o $(NAME) -Wl,-rpath $(LD_LIBRARY) -I$(INCLUDE) -L$(LD_LIBRARY) -lopenblas

RM = rm -rf

default: code

code: $(TARGET)
	$(GCC) $(TARGET) $(CFLAGS) 

clean: 
	$(RM) code