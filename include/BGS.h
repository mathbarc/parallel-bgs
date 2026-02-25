#ifndef BGS_H
#define BGS_H 1
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

typedef unsigned char uchar;

void BGS(uchar* buffer, int size, uchar* frame, int frame_size, uchar* frameOut);

#endif
