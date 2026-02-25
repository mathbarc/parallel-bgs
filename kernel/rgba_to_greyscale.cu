#include "utils.h"
#include <stdio.h>
__global__ void rgba_to_greyscale(const uchar4* const rgbaImage, unsigned char* const greyImage, int numRows, int numCols)
{

    int i = blockIdx.x * blockDim.x + threadIdx.x; // determina iteração das linhas
    int j = blockIdx.y * blockDim.y + threadIdx.y; // determina iteração das colunas
    if (i < numRows && j < numCols) {
        uchar4 rgba = rgbaImage[i * numCols + j];
        float channelSum = .299f * rgba.x + .587f * rgba.y + .114f * rgba.z;
        greyImage[i * numCols + j] = channelSum;
    }
}

void your_rgba_to_greyscale(const uchar4* const h_rgbaImage, uchar4* const d_rgbaImage, unsigned char* const d_greyImage, size_t numRows, size_t numCols)
{
    int blockWidth = 32; // Determino qual tamanho de bloco usar
    const dim3 blockSize(blockWidth, blockWidth, 1); // tamanho do bloco
    int blocksX = numRows / blockWidth + 1; // qtd de threads
    int blocksY = numCols / blockWidth + 1;
    const dim3 gridSize(blocksX, blocksY, 1); // Tamanho do grid
    rgba_to_greyscale<<<gridSize, blockSize>>>(d_rgbaImage, d_greyImage, numRows, numCols);
    cudaDeviceSynchronize();

    CHECK_CUDA_ERROR(cudaGetLastError());
}
