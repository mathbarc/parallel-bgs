#ifndef FILTROS_H
#define FILTROS_H 1
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>




void gaussian_blur(const unsigned char* const inputChannel,
                   unsigned char* const outputChannel,
                   int numRows, int numCols,
                   const float* const filter, const int filterWidth);


void rgb_to_greyscale(const unsigned char* const bgrImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols);


void trataImagem(const unsigned char* imgin, const unsigned char* imgout, int cols, int rows);
#endif
