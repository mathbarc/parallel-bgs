#ifndef MEMHANDLER_H
#define MEMHANDLER_H 1

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

void putInBuffer(unsigned char* BUFF, const unsigned char* frameAtual, int cols, int rows, int sizeBUFF, int pos);

void alloc(unsigned char* &frameEntrada, unsigned char* &frameIntermediario, unsigned char* &frameTratado, unsigned char* &fore, unsigned char* &BUFF, int cols, int rows, int sizeBUFF);

void dealloc(unsigned char* &frameEntrada, unsigned char* &frameIntermediario, unsigned char* &frameTratado, unsigned char* &fore, unsigned char* &BUFF, int cols, int rows, int sizeBUFF);

#endif
