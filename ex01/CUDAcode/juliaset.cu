#include "juliaset.cuh"
#include <iostream>
#include <cmath>

__device__ __host__ juliaset::juliaset(){}

__device__ __host__ void juliaset::display(){
//std::cout << zRe << " +i"<<zIm<<std::endl;
}

__device__ __host__ real juliaset::transform(unsigned width,unsigned pixelNumber)
{
    real Z = (pixelNumber - (width * 0.5)) / (0.25* width);
    return Z;
}

__device__ __host__ real juliaset::getMagnitude(const juliaset& Z){
    return std::sqrt((Z.zRe*Z.zRe) + (Z.zIm * Z.zIm));
}

