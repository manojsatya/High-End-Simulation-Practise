#include <iostream>
#include <vector>
#include "type.h"
#include "juliaset.h"
#include "lodepng.h"
#include "Timer.h"
#include "juliaAlgorithm.h"

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
    unsigned width = 10240,height = 10240;
    const char* filename1 = "julia1.png";const char* filename2 = "julia2.png" ;

    //Vector Image for buffering
    std::vector<unsigned char> image;
    image.resize(width * height * 4);

    hespa::Timer time; // Start timer

    // Change Real and Imaginary according to the problem
    cRe = -0.8; cIm = 0.2;
    juliaset C(cRe,cIm);

    image = juliaAlgorithm(width,height,C,image);
    std::cout << "First image Executed in :" << time.elapsed() << "seconds" << std::endl;
    encodeToPng(filename1,image,width,height); // write image

    time.reset();

    cRe = 0.0; cIm = 0.8;
    juliaset D(cRe,cIm);

    image = juliaAlgorithm(width,height,D,image);
    std::cout << "Second image Executed in :" << time.elapsed() << "seconds" << std::endl;
    encodeToPng(filename2,image,width,height); // write image

    return 0;
}
