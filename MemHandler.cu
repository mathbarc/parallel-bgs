#include "MemHandler.h"

#define BLOCK_SIZE_X 8
#define BLOCK_SIZE_Y 8

__global__
void d_putInBuffer(const unsigned char* BUFF, const unsigned char* frameAtual, int cols, int rows, int sizeBUFF, int pos){
	int i = blockIdx.x * blockSize.x + threadIdx.x;
	int j = blockIdx.y * blockSize.y + threadIdx.y;

	int p = i*cols+j;

	*(BUFF+pos*cols*rows+p) = *(frameAtual+p);
}


void copyImgToGPU(const unsigned char* frameEntrada, const unsigned char* img, int cols, int rows){
	cudaMemcpy(frameEntrada, img, sizeof(uchar) * cols*rows, cudaMemcpyHostToDevice);
}


void putInBuffer(const unsigned char* BUFF, const unsigned char* frameAtual, int cols, int rows, int sizeBUFF, int pos){
	const dim3 block(BLOCK_SIZE_X,BLOCK_SIZE_Y,1);
	const dim3 grid(rows/BLOCK_SIZE_X,cols/BLOCK_SIZE_Y,1);
	
	d_putInBuffer<<< block, grid >>>(BUFF, frameAtual, cols, rows, sizeBUFF, pos);
}


void alloc(unsigned char* &frameEntrada, unsigned char* &frameIntermediario, unsigned char* &frameTratado, unsigned char* &fore, unsigned char* &BUFF, int cols, int rows, int sizeBUFF){

	cudaMalloc(frameEntrada, cols*rows*sizeof(unsigned char));
	cudaMalloc(frameIntermediario, cols*rows*sizeof(unsigned char));
	cudaMalloc(frameTratado, cols*rows*sizeof(unsigned char));
	cudaMalloc(fore, cols*rows*sizeof(unsigned char));

	cudaMalloc(BUFF, cols*rows*sizeof(unsigned char)*sizeBUFF);



}
void dealloc(unsigned char* &frameEntrada, unsigned char* &frameIntermediario, unsigned char* &frameTratado, unsigned char* &fore, unsigned char* &BUFF, int cols, int rows, int sizeBUFF){

	cudaFree(frameEntrada);
	cudaFree(frameIntermediario);
	cudaFree(frameTrarado);
	cudaFree(fore);

	cudaFree(BUFF);

}

