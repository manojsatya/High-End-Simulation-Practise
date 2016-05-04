#ifndef JULIASET_H
#define JULIASET_H
#include "type.h"

class juliaset
{
public:
    __device__ __host__ juliaset();

    __device__ __host__ juliaset(real zRe_,real zIm_){zRe = zRe_; zIm = zIm_;}

    __device__ __host__ juliaset operator*(const juliaset& z){
        juliaset z2;
        z2.zRe = (z.zRe * zRe) - (z.zIm * zIm);
        z2.zIm = (zRe * z.zIm) + (zIm * z.zRe) ;
        return z2;
    }

    __device__ __host__ juliaset operator+(const juliaset& z){
        juliaset z2;
        z2.zRe = z.zRe + zRe;
        z2.zIm = z.zIm + zIm;
        return z2;
    }

    __device__ __host__ void operator=(const juliaset& z){
        zRe = z.zRe;
        zIm = z.zIm;
    }

    __device__ __host__ real transform(unsigned,unsigned);

    __device__ __host__ real getMagnitude(const juliaset&);

    __device__ __host__ void display();

private:
    real zRe,zIm;
};

#endif // JULIASET_H
