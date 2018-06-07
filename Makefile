# compilation flags for gcc and gas:

ASFLAGS = -g 

# .o文件
OBJS=  startup_stm32f10x.o system_stm32f10x.o  main.o
OBJS += stm32f10x_gpio.o stm32f10x_rcc.o

# Names of output binary files. ELF is the default type output:
# (The file name is the name of the current directory.)
ELF=$(notdir $(CURDIR)).elf
# Map file shows where each function and variable are allocated in memory:
MAP_FILE=$(notdir $(CURDIR)).map
# The '.bin' file will be burned into the processor:
BIN_FILE=$(notdir $(CURDIR)).bin  

CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy

# Library path
# The STM supplied peripheral functions and definitions can be reached from the library directory root:
# (Please look around in the library directories to see what is there to use.

# Paths of various components in the library specified here:
DEVICE=./Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
CORE=./Libraries/CMSIS/CM3/CoreSupport
PERIPH=./Libraries/STM32F10x_StdPeriph_Driver

USRCORE=./usr

# Search path for standard files
vpath %.c

# Search path for perpheral library
vpath %.c $(CORE)
vpath %.c $(PERIPH)/src
vpath %.c $(DEVICE)
vpath %.c $(USRCORE)
# Uncomment for the specific processor. STM32F103 is a Medium Density 'MD' device.
# This defines the Proc. clock definition in file:
# STM32F10x_StdPeriph_Lib_V3.5.0/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/system_stm32f10x.c, which is eventually included.
PTYPE = STM32F10X_MD
# OR uncomment the next line if a Value Line device is used 'VL':
#PTYPE = STM32F10X_MD_VL  


# Similarly, the linker script for the processor used must be specified. 
LDSCRIPT = ./stm32f103.ld

# Compilation Flags
FULLASSERT = -DUSE_FULL_ASSERT 

#LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m3 
# Modify linker flags to include a map file:
LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m3 -Wl,-Map=$(MAP_FILE)

CFLAGS  = -O1 -g
CFLAGS+= -mcpu=cortex-m3 -mthumb 
CFLAGS+= -I$(DEVICE) -I$(CORE) -I$(PERIPH)/inc -I. -I./usr
CFLAGS+= -D$(PTYPE) -DUSE_STDPERIPH_DRIVER $(FULLASSERT)

# Prepare the .bin binary file:
OBJCOPYFLAGS = -O binary

# Build executable 
$(BIN_FILE) : $(ELF)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@


$(ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS) $(LDFLAGS_POST)


# 编译生成.o文件
# compile and generate dependency info

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
	$(CC) -MM $(CFLAGS) $< > $*.d

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

clean:
#rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(MAP_FILE) startup_stm32f* $(CLEANOTHER)
	rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(MAP_FILE) $(STARTUP) $(CLEANOTHER) *.o

debug: $(ELF)
	arm-none-eabi-gdb $(ELF)


# pull in dependencies

-include $(OBJS:.o=.d)

