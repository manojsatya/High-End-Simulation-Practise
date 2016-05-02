#include <iostream>
#include <vector>
#include "type.h"
#include "juliaset.h"
#include "lodepng.h"
#include "Timer.h"
#include "juliaAlgorithm.cuh"

using namespace std;

void encodeToPng(const std::string& filename,std::vector<unsigned char>& image, unsigned width, unsigned height,
                 LodePNGColorType colortype = LCT_PALETTE,unsigned bitdepth = 4){

      //Encode the image
      unsigned error = lodepng::encode(filename, image, width, height);

      //if there's an error, display it
      if(error) std::cout << "encoder error " << error << ": "<< lodepng_error_text(error) << std::endl;
}

int main(){

    real cRe,cIm;
    unsigned width = 2048,height = 2048;
    const char* filename1 = "julia1.png";const char* filename2 = "julia2.png" ;
    const int ARRAY_SIZE = width * height;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(real);

    //Vector Image for buffering
    std::vector<unsigned char> image;
    image.resize(width * height * 4);

    hespa::Timer time; // Start timer

    // Change Real and Imaginary according to the problem
    cRe = -0.8; cIm = 0.2;
    juliaset C(cRe,cIm);

    //Pointers for objects to host(h) and device(d)
    juliaset *h_C_in;
    juliaset *h_C_out;
    juliaset *d_C_in;
    juliaset *d_C_out;

    // Allocating GPU memory
    cudaMalloc((void**) &d_C_in, ARRAY_BYTES);
    cudaMalloc((void**) &d_C_out, ARRAY_BYTES);

    //Transferrring array to GPU
    cudaMemcpy(d_C_in, h_C_in, ARRAY_BYTES, cudaMemcpyHostToDevice);

    image = juliaAlgorithm<<<1,ARRAY_SIZE>>>(width,height,C,image); // Kernel launch

    cudaMemcpy(h_C_out, d_C_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);



    std::cout << "First image Executed in :" << time.elapsed() << "seconds" << std::endl;
    encodeToPng(filename1,image,width,height); // write image

    cudaFree(d_C_in);
    cudaFree(d_C_out);








    /*time.reset();

    cRe = 0.0; cIm = 0.8;
    juliaset D(cRe,cIm);

    image = juliaAlgorithm(width,height,D,image);
    std::cout << "Second image Executed in :" << time.elapsed() << "seconds" << std::endl;
    encodeToPng(filename2,image,width,height); // write image*/

    return 0;
}
