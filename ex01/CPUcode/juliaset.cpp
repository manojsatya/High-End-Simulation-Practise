#include "juliaset.h"
#include <iostream>
#include <cmath>

juliaset::juliaset(){}

void juliaset::display(){
std::cout << zRe << " +i"<<zIm<<std::endl;
}

real juliaset::transform(unsigned width,unsigned pixelNumber)
{
    real Z = (pixelNumber - (width * 0.5)) / (0.25* width);
    return Z;
}

real juliaset::getMagnitude(const juliaset& Z){
    return std::sqrt((Z.zRe*Z.zRe) + (Z.zIm * Z.zIm));
}

