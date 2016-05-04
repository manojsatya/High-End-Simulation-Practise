#include <iostream>
#include <vector>
#include <sys/time.h>
#include <string>
#include "type.h"
#include "juliaset.cuh"
#include "lodepng.h"
#include "juliaAlgorithm.cuh"

using namespace std;

void checkError(cudaError_t err) {
    if (err != cudaSuccess) {
        std::cout << cudaGetErrorString(err) << std::endl;
        exit(-1);
    }
}

double getSeconds() {
    timeval tp;
    gettimeofday(&tp, NULL);
    return ((double)tp.tv_sec * (double)tp.tv_usec * 1e-6);
}

int main(int argc, const char *argv[]){

    if(argc > 4 || argc < 1){std::cout << "Please enter only threadx and thready" << std::endl; abort();}
    int threadsX = std::atoi(argv[1]);
    int threadsY = std::atoi(argv[2]);
    const char* filename1 = "julia1.png"; //const char* filename2 = "julia2.png" ;
    const long long ARRAY_SIZE = 2048 * 2048 * 3;
    const long long ARRAY_BYTES = ARRAY_SIZE * sizeof(unsigned char);
    unsigned char* h_image_out = new unsigned char[ARRAY_SIZE];
    double startTime,stopTime;

    //unsigned char * d_image_out;
    unsigned char* d_image_out;// = new unsigned char[ARRAY_SIZE];

    checkError(cudaMalloc((void**)&d_image_out, ARRAY_BYTES));

    startTime = getSeconds();
    dim3 threadsPerBlock(threadsX,threadsY);
    dim3 numBlocks(2048/threadsPerBlock.x,2048/threadsPerBlock.y);
    // Kernel launch
    juliaAlgorithm <<<numBlocks , threadsPerBlock>>> (d_image_out);
    cudaError(cudaPeekAtLastError());
    cudaDeviceSynchronize();
    stopTime = getSeconds();
    std::cout << "time :" << (stopTime-startTime) * 1e-3 << "ms" << std::endl;
    checkError(cudaMemcpy(h_image_out, d_image_out, ARRAY_BYTES, cudaMemcpyDeviceToHost));
    lodepng::encode(filename1, h_image_out, 2048, 2048,LCT_RGB,8);
    checkError(cudaFree(d_image_out));

    return 0;
}
