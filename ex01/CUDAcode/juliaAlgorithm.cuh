__global__ void juliaAlgorithm(unsigned char* d_image_out){

    int ix = blockIdx.x * blockDim.x + threadIdx.x;
    int iy = blockIdx.y * blockDim.y + threadIdx.y;
    unsigned width = 2048,height = 2048;

    real cRe = -0.8,cIm = 0.2;
    juliaset C(cRe,cIm);
            juliaset Z,d;
            real zreal = d.transform( width,ix );
            real zimag = d.transform( height,iy);

            juliaset zold(zreal,zimag);
            unsigned iter;


            for(iter = 0; iter < 200; iter++){
            Z = (zold * zold) + C;
            zold = Z;
            if(Z.getMagnitude(Z) > 2) {break;}
            }

            d_image_out[3*ix + 3*2048*iy + 0] = (unsigned char)(255*(iter<2));
            d_image_out[3*ix + 3*2048*iy + 1] = (unsigned char)(255*(iter<10));
            d_image_out[3*ix + 3*2048*iy + 2] = (unsigned char)(255*(iter<30));

}
