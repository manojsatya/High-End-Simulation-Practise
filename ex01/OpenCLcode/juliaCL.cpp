#include <iostream>
#include <fstream>
#include <string>
#include <assert.h>

#define __CL_ENABLE_EXCEPTIONS
#define CL_USE_DEPRECATED_OPENCL_1_1_APIS
#include <CL/cl.hpp>
//#define __NO_STD_VECTOR

#include "lodepng.h"




int main(int argc, char *argv[])
{
    //int threadsX = std::stoi(argv[0]);
    //int threadsY = std::stoi(argv[1]);
    try {

        int threadsX = atoi(argv[0]);
        int threadsY = atoi(argv[1]);

        std::vector<cl::Platform> platforms;
        cl::Platform::get(&platforms);
        assert(platforms.size() > 0);

        std::vector<cl::Device> devices;
        //platforms[1].getDevices(CL_DEVICE_TYPE_GPU, &devices);
        platforms[0].getDevices(CL_DEVICE_TYPE_CPU, &devices);

        assert(devices.size() > 0);


        cl::Context context(devices);// or devices[0]?


        std::ifstream fin("juliaCL.cl");
        std::istreambuf_iterator<char> begin(fin), end;
        std::string kernel_code(begin, end);


        cl::Program::Sources sources;
        sources.push_back(std::make_pair(kernel_code.c_str(), kernel_code.length() + 1));


        cl::Program program(context, sources);
        try{
            program.build(devices);
        } catch (cl::Error e) {
            std::cout << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(devices[0]) << std::endl;
        }


        //for (unsigned int i = 0; i < devices.size(); ++i) // devices more than 1? perhaps need to do try-catch here
        //    std::cout << program.getBuildInfo <CL_PROGRAM_BUILD_LOG>(*it) << std::endl;
        //std::cout << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(devices[0]) << std::endl;

        cl::Kernel juliaCL(program, "juliaCL");


        //create buffer here
        cl::Buffer output(context,CL_MEM_WRITE_ONLY, sizeof(cl_char)*2048*2048*3);
        juliaCL.setArg(0, output); // also pass threadX and threadY?


        cl::CommandQueue queue(context, devices[0]);//, 0);

    
        queue.enqueueNDRangeKernel(juliaCL, cl::NullRange, cl::NDRange(2048, 2048));

        unsigned char* results = new unsigned char[2048*2048*3];
        //std::vector<unsigned char> results;

        queue.enqueueReadBuffer(output, CL_TRUE, 0, sizeof(cl_char)*2048*2048*3, results);


    // get device, context, and command queue

    //context = clCreateContextFromType(NULL, CL_DEVICE_TYPE_GPU, NULL, NULL, NULL);

        // get device info?
        // cl_image cl_mem buffer
        // write and reading the object data
        // compile and create kernel, build log
        // set kernel, enque kernel
        // get_global_id(0) for 1D, work dim
        // local_size is size of 1 group

        //unsigned error = 
        lodepng::encode("julia.png", results, 2048, 2048, LCT_RGB, 8);
        //encodeOneStep("julia.png", results, 2048, 2048);

    } catch (cl::Error e) {
        std::cout << e.what() << ": Error code " << e.err() << std::endl;
    }

    return 0;

}
