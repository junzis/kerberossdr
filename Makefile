# Makefile for compiling Hydra DSP code
# Version : 1.0
# Date: August 2018
# Author: Tamás Pető
CC=gcc

# For Raspberry Pi 3/4
#CFLAGS=-Wall -O3 -march=native -mfloat-abi=hard -mfpu=neon-fp-armv8 -mneon-for-64bits

# For Raspberry Pi 3
#CFLAGS=-Wall -O3 -mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mneon-for-64bits -mtune=cortex-a53

# For Raspberry Pi 4
#CFLAGS=-Wall -mcpu=cortex-a72 -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mneon-for-64bits -O3

# For Tinkerboard
#CFLAGS=-Wall -O2 -march=armv7-a -mtune=cortex-a17 -mfpu=neon -mfloat-abi=hard

# For Generic x86
CFLAGS=-Wall -march=native

RM= rm -f

all: rtl_daq sync gate sim
	chmod +x run.sh kill.sh simulation/sim.sh

rtl_daq:
	$(CC) $(CFLAGS) src/rtl_daq.c -lpthread -Ldriver/build/src -lrtlsdr -o bin/rtl_daq
	chmod a+x bin/rtl_daq

sync:
	$(CC) $(CFLAGS) src/sync.c -lpthread -o bin/sync
	chmod a+x bin/sync

gate:
	$(CC) $(CFLAGS) src/gate.c -lpthread -o bin/gate
	chmod a+x bin/gate

sim:
	$(CC) $(CFLAGS) src/sim.c -o bin/sim
	chmod a+x bin/sim

clean:
	$(RM) bin/rtl_daq bin/sync bin/gate bin/sim
