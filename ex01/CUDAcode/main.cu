#include <iostream>
#include <vector>
#include "type.h"
#include "juliaset.cuh"
#include "lodepng.h"
//#include "Timer.h"
//#include "juliaAlgorithm.cuh"

using namespace std;

void checkError(cudaError_t err) {
    if (err != cudaSuccess) {
        std::cout << cudaGetErrorString(err) << std::endl;
        exit(-1);
    }
}


void encodeToPng(const std::string& filename,unsigned char * image, unsigned width, unsigned height,
                 LodePNGColorType colortype = LCT_PALETTE,unsigned bitdepth = 4){

      //Encode the image
      unsigned error = lodepng::encode(filename, image, width, height);

      //if there's an error, display it
      if(error) std::cout << "encoder error " << error << ": "<< lodepng_error_text(error) << std::endl;
}

__global__ void juliaAlgorithm(unsigned width, unsigned height, juliaset& C,unsigned char* d_image_in,
                               unsigned char* d_image_out){

    //int ix = blockIdx.x * blockDim.x + threadIdx.x;
    //int iy = blockIdx.y * blockDim.y + threadIdx.y;
    int ix = threadIdx.x;
    int iy = threadIdx.y;
    //int x = blockIdx.x; int y = blockIdx.y;
    //int offset = x + y * gridDim.x;
    //std::cout << "Image is being created. Please wait ..... " << std::endl;
    //td::vector<unsigned char> image;
    //for(unsigned i = 0;i< width;++i)
      //  for(unsigned j = 0;j< height;++j){
            juliaset Z,d;
            real zreal = d.transform( width,ix );
            real zimag = d.transform( height,iy);

            juliaset zold(zreal,zimag);
            unsigned iter;


            for(iter = 1; iter < 400; iter++){
            Z = (zold * zold) + C;
            zold = Z;
            if(Z.getMagnitude(Z) > 2) {break;}
            }
                //buffer to image
                //d_image_out[4 * width * iy + 4 * ix + 0] = iter;
                //d_image_out[4 * width * iy + 4 * ix + 1] = iter;
                //d_image_out[4 * width * iy + 4 * ix + 2] = iter;
                //d_image_out[4 * width * iy + 4 * ix + 3] = iter;
            d_image_out[3*ix + 3*2048 * iy +0] = 255 * iter;
            //std::cout << "Iteration Number:" << iter << std::endl;
        //}
    //return image;
}

int main(){

    real cRe,cIm;
    unsigned width = 2048,height = 2048;
    const char* filename1 = "julia1.png"; //const char* filename2 = "julia2.png" ;
    const int ARRAY_SIZE = width * height;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

    //Vector Image for buffering
    //std::vector<unsigned char> h_image_in,h_image_out;

    //std::cout << "I am here" << std::endl;
    //unsigned char h_image_in[ARRAY_SIZE],h_image_out[ARRAY_SIZE];
    unsigned char* h_image_in = new unsigned char[ARRAY_SIZE];
    unsigned char* h_image_out = new unsigned char[ARRAY_SIZE];
    //for(int i = 0;i<ARRAY_SIZE;i++){
        //h_image_in[] = 0;
        //h_image_out[] = 0;
    //}
    //unsigned char* h_image_in;
    //unsigned char* h_image_out;
    //image.resize(width * height * 4);
    //std::cout << "I am here" << std::endl;
    //hespa::Timer time; // Start timer

    // Change Real and Imaginary according to the problem
    cRe = -0.8; cIm = 0.2;
    juliaset C(cRe,cIm);

    //Pointers for objects to host(h) and device(d)
    //juliaset *h_C_in; h_C_in = &C;
    //h_image_in[ARRAY_SIZE]; // host image
    //h_image_out[ARRAY_SIZE]; // device image

    //juliaset *d_C_in;
    //juliaset *d_C_out;

    //std::vector<unsigned char> d_image_in;
    //std::vector<unsigned char> d_image_out;
        // declare GPU pointers
    //unsigned char * d_image_in;
    unsigned char* d_image_in = new unsigned char[ARRAY_SIZE];
    //std::cout << "I am here" << std::endl;
    //unsigned char * d_image_out;
    unsigned char* d_image_out = new unsigned char[ARRAY_SIZE];

    checkError(cudaMalloc((void**)&d_image_in, ARRAY_BYTES));
    //std::cout << "I am here" << std::endl;
    checkError(cudaMalloc((void**)&d_image_out, ARRAY_BYTES));
    //std::cout << "I am here" << std::endl;

    // Allocating GPU memory
    //cudaMalloc((void**) &d_image_in, ARRAY_BYTES);
    //cudaMalloc((void**) &d_image_out, ARRAY_BYTES);

    //Transferrring array to GPU
    checkError(cudaMemcpy(d_image_in, h_image_in, ARRAY_BYTES, cudaMemcpyHostToDevice));

    std::cout << "I am here" << std::endl;
    dim3 threadsPerBlock(16,16);

    juliaAlgorithm <<<1,threadsPerBlock>>> (width,height,C, d_image_in, d_image_out); // Kernel launch
    cudaError(cudaPeekAtLastError());
    //juliaset *h_C_out; h_C_out = &C;

    checkError(cudaMemcpy(h_image_out, d_image_out, ARRAY_BYTES, cudaMemcpyDeviceToHost));
    //juliaAlgorithm<<< 1 , 1 >>>(width,height,C,image);


    //std::cout << "First image Executed in :" << time.elapsed() << "seconds" << std::endl;
    encodeToPng(filename1,h_image_out,width,height); // write image

    checkError(cudaFree(d_image_in));
    checkError(cudaFree(d_image_out));








    /*time.reset();

    cRe = 0.0; cIm = 0.8;
    juliaset D(cRe,cIm);

    image = juliaAlgorithm(width,height,D,image);
    std::cout << "Second image Executed in :" << time.elapsed() << "seconds" << std::endl;
    encodeToPng(filename2,image,width,height); // write image*/

    return 0;
}
