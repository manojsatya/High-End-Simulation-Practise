//#pragma OPENCL_EXTENSION cl_khr_fp64 : enable
//typedef double2 Complex;
typedef float2 Complex;


Complex complex_multiply(Complex a, Complex b)
{
    return (Complex)(a.x*b.x-a.y*b.y, a.x*b.y+a.y*b.x);
    //return (Complex)( a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x);
    //return (Complex)(2, 3);
}

Complex complex_addition(Complex a, Complex b)
{
    return (Complex)(a.x+b.x, a.y+b.y);
}


float complex_modulus(Complex a)
{
    return (sqrt(a.x*a.x + a.y*a.y));
}


__kernel void juliaCL(__global unsigned char* output) // manipulate char array
{
    int i = get_global_id(0);
    int j = get_global_id(1);

    Complex z = (Complex)(-2.0 + 2.0*(i/1024.0), -2.0 + 2.0*(j/1024.0));
    Complex c = (Complex)(-0.8, 0.2);
    //Complex z = (Complex)(2.0,0.0);
    //Complex c = (Complex)(2.0,0.0);

    for (int k = 0; k < 4; k++) {
        z = complex_addition(complex_multiply(z, z), c);
    }
    printf("%f", z.x);
    
    if (complex_modulus(z) > 2) {
        output[3*i + 3*2048*j + 0] = 255;
    }

    //float z_mod = complex_modulus(z);
    //printf("%f", z_mod);



    //if (z_mod>2){
    //    output[3*i + 3*2048*j + 0] = 255;
    //    output[3*i + 3*2048*j + 1] = 0;
    //    output[3*i + 3*2048*j + 2] = 0;
    //}
    //} else {
    //   output[3*i + 3*2048*j + 0] = 255;
    ///   output[3*i + 3*2048*j + 1] = 0;
    //  output[3*i + 3*2048*j + 2] = 0;
    //}

}