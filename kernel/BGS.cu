#include "BGS.h"

#define BLOCK_SIZE_X 8
#define BLOCK_SIZE_Y 8


__global__
void BGS_d(uchar* buffer, int buffer_size, uchar* frame, int frame_size, uchar* frameOut){
	const int x =  blockIdx.x * blockDim.x + threadIdx.x;
    int avg = 0;
    int sum = 0;
    uchar* aux;
    if(x < frame_size){
    	for(int i = 0; i < buffer_size; i++){
 	    aux = buffer + i*frame_size;
            sum += aux[x];
     	}
     	avg = sum / buffer_size;
     	frameOut[x] = frame[x] - avg;
        //calcula a diferença e escreve no frame do vetor resposta
    }
}

void BGS(uchar* buffer, int buffer_size, uchar* frame, int frame_size, uchar* frameOut){
	const dim3 block(BLOCK_SIZE_X,1,1);
	const dim3 grid(frame_size/BLOCK_SIZE_X,1);

	BGS_d <<<block, grid>>>(buffer, buffer_size, frame, frame_size, frameOut);
}

