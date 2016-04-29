#ifndef JULIASET_H
#define JULIASET_H
#include "type.h"

class juliaset
{
public:
    juliaset();

    juliaset(real zRe_,real zIm_){zRe = zRe_; zIm = zIm_;}

    juliaset operator*(const juliaset& z){
        juliaset z2;
        z2.zRe = (z.zRe * zRe) - (z.zIm * zIm);
        z2.zIm = (zRe * z.zIm) + (zIm * z.zRe) ;
        return z2;
    }

    juliaset operator+(const juliaset& z){
        juliaset z2;
        z2.zRe = z.zRe + zRe;
        z2.zIm = z.zIm + zIm;
        return z2;
    }

    void operator=(const juliaset& z){
        zRe = z.zRe;
        zIm = z.zIm;
    }

    real transform(unsigned,unsigned);

    real getMagnitude(const juliaset&);

    void display();

private:
    real zRe,zIm;
};

#endif // JULIASET_H
