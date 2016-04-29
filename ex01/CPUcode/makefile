CC = g++
CFLAGS = -O3 -Wall -Winline -Wshadow -ansi -std=c++11
TARGET = main
OBJS = $(TARGET).o juliaset.o lodepng.o 

all: $(TARGET)

$(TARGET): $(OBJS) juliaset.o lodepng.o makefile
	$(CC) $(CFLAGS) -o juliaCPU $(OBJS)
	
$(TARGET).o: $(TARGET).cpp juliaset.h lodepng.h type.h Timer.h juliaAlgorithm.h makefile
	$(CC) -c $(CFLAGS) $(TARGET).cpp
	
juliaset.o: juliaset.cpp juliaset.h 
	$(CC) -c $(CFLAGS) juliaset.cpp
	
lodepng.o: lodepng.cpp lodepng.h
	$(CC) -c $(CFLAGS) lodepng.cpp
	
clean:
	@$(RM) -rf *.o $(TARGET) juliaCPU
	

