std::vector<unsigned char> juliaAlgorithm(unsigned width, unsigned height, juliaset& C,std::vector<unsigned char> image){

    std::cout << "Image is being created. Please wait ..... " << std::endl;

    for(unsigned i = 0;i< width;++i)
        for(unsigned j = 0;j< height;++j){
            juliaset Z,d;
            real zreal = d.transform( width,i );
            real zimag = d.transform( height,j);

            juliaset zold(zreal,zimag);
            unsigned iter;


            for(iter = 1; iter < 400; iter++){
            Z = (zold * zold) + C;
            zold = Z;
            if(Z.getMagnitude(Z) > 2) {break;}
            }
                //buffer to image
                image[4 * width * j + 4 * i + 0] = iter;
                image[4 * width * j + 4 * i + 1] = iter;
                image[4 * width * j + 4 * i + 2] = iter;
                image[4 * width * j + 4 * i + 3] = iter;
            //std::cout << "Iteration Number:" << iter << std::endl;
        }
    return image;
}
