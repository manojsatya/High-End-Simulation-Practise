CC = g++
NVCC = nvcc 
NVCFLAGS = -O3 -arch=sm_20 -rdc=true
CFLAGS = -O3 -Wall -Winline -Wshadow -ansi 
TARGET = main
OBJS = $(TARGET).o juliaset.o lodepng.o 

all: $(TARGET)

$(TARGET): $(OBJS) juliaset.o lodepng.o makefile
	$(NVCC) $(NVCFLAGS) -o juliaCUDA $(OBJS)
	
$(TARGET).o: $(TARGET).cu juliaset.cuh lodepng.h type.h Timer.h makefile
	$(NVCC) -c $(NVCFLAGS) $(TARGET).cu
	
juliaset.o: juliaset.cu juliaset.cuh 
	$(NVCC) -c $(NVCFLAGS) juliaset.cu
	
lodepng.o: lodepng.cpp lodepng.h
	$(CC) -c $(CFLAGS) lodepng.cpp
	
clean:
	@$(RM) -rf *.o $(TARGET) juliaCUDA
	

