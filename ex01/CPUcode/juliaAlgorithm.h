std::vector<unsigned char> juliaAlgorithm(unsigned width, unsigned height, juliaset& C,std::vector<unsigned char> image){

    std::cout << "Image is being created. Please wait ..... " << std::endl;

    for(unsigned i = 0;i< width;++i)
        for(unsigned j = 0;j< height;++j){
            juliaset Z,d;
            real zreal = d.transform( width,i );
            real zimag = d.transform( height,j);

            juliaset zold(zreal,zimag);
            unsigned iter, iterMax = 200;


            for(iter = 1; iter < iterMax; iter++){
            Z = (zold * zold) + C;
            zold = Z;
            if(Z.getMagnitude(Z) > 2) {break;}
            }
            //int a = (iter>>24) & 0xff;
            //int r = (iter>>16) & 0xff;
            //int g = (iter>>8) & 0xff;
            //int b = (iter) & 0xff;
                //buffer to image
                image[4 * width * j + 4 * i + 0] = 255 * (iter < 2)  ;
                image[4 * width * j + 4 * i + 1] = 255 * (iter < 10) ;
                image[4 * width * j + 4 * i + 2] = 255 * (iter < 15) ;
                image[4 * width * j + 4 * i + 3] =  255 *  (iter < 20) ;
              //  if ((iter>>24) & 0xff)
       //image[width * j + i] = ((iter>>24) & 0xff) || ((iter>>16) & 0xff) ||  ((iter>>8) & 0xff) || (iter & 0xff);
            //std::cout << "Iteration Number:" << iter << std::endl;
        }
    return image;
}
