#include "Filtros.h"

#define BLOCK_SIZE_X 8
#define BLOCK_SIZE_Y 8


__global__
void gaussian_blur_d(const unsigned char* const inputChannel,
                   unsigned char* const outputChannel,
                   int numRows, int numCols,
                   const float* const filter, const int filterWidth)
{

    const int x =  blockIdx.x * blockDim.x + threadIdx.x;
    const int y =  blockIdx.y * blockDim.y + threadIdx.y;
    const int m = y * numCols + x;
    
    if(x >= numCols || y >= numRows)
         return;
    
    float color = 0.0f;
    
    for(int f_y = 0; f_y < filterWidth; f_y++) {
        for(int f_x = 0; f_x < filterWidth; f_x++) {
   
            int c_x = x + f_x - filterWidth/2;
            int c_y = y + f_y - filterWidth/2;
            c_x = min(max(c_x, 0), numCols - 1);
            c_y = min(max(c_y, 0), numRows - 1);
            float filter_value = filter[f_y*filterWidth + f_x];
            color += filter_value*static_cast<float>(inputChannel[c_y*numCols + c_x]);
            
        }
    }
    
    outputChannel[m] = color;
  
}


__global__
void rgb_to_greyscale_d(const unsigned char* const bgrImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols)
{

 int i = blockIdx.x * blockDim.x + threadIdx.x;// determina iteração das linhas
 int j = blockIdx.y * blockDim.y + threadIdx.y; //determina iteração das colunas
    if(i<numRows && j< numCols){
       //Y = 0.2126R + 0.7152G + 0.0722B
       float b = *(bgrImage+i*numCols+j);
       float g = *(bgrImage+1*numCols*numRows+i*numCols+j);
       float r = *(bgrImage+2*numCols*numRows+i*numCols+j);
       *(greyImage+i*numCols+j) = (unsigned char)(0.2126*r + 0.7152*g + 0.722*b);
    }
     
}

void gaussian_blur(const unsigned char* const inputChannel,
                   unsigned char* const outputChannel,
                   int numRows, int numCols,
                   const float* const filter, const int filterWidth){

	const dim3 block(BLOCK_SIZE_X,BLOCK_SIZE_Y,1);
	const dim3 grid(numRows/BLOCK_SIZE_X,numCols/BLOCK_SIZE_Y,1);
	gaussian_blur_d<<<block,grid>>>(inputChannel, outputChannel, numRows, numCols, filter, filterWidth);
}


void rgb_to_greyscale(const unsigned char* const bgrImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols){
	const dim3 block(BLOCK_SIZE_X,BLOCK_SIZE_Y,1);
	const dim3 grid(numRows/BLOCK_SIZE_X,numCols/BLOCK_SIZE_Y,1);
	rgb_to_greyscale_d<<<block,grid>>>(bgrImage, greyImage, numRows, numCols);

}

