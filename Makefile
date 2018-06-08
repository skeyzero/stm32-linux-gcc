#######################################################
# Important:
# Modify the lines below defining: TOOLROOT and LIBROOT
#  to match their locations on your own computer!
#######################################################

#Comments start with '#'

# compilation flags for gcc and gas:
CFLAGS  = -O1 -g
ASFLAGS = -g 

# Files used in the processor startup.
# They are executed before control is passed over to main:
STARTUP= startup_stm32f10x.o system_stm32f10x.o 

# Object files which contain the funcions that are required by the final binary:
# They are in no specific order.
OBJS=  $(STARTUP) main.o
OBJS += stm32f10x_gpio.o stm32f10x_rcc.o io.o

# Names of output binary files. ELF is the default type output:
# (The file name is the name of the current directory.)
ELF=$(notdir $(CURDIR)).elf
# Map file shows where each function and variable are allocated in memory:
MAP_FILE=$(notdir $(CURDIR)).map


# 生成bin文件名字
# The '.bin' file will be burned into the processor:
BIN_FILE=main.bin  

# 使用到的指令
CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy

# 库文件位置
LIBROOT=.

# ARM-GCC编译选项 -I使用来指定源文件位置
DEVICE=$(LIBROOT)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
CORE=$(LIBROOT)/Libraries/CMSIS/CM3/CoreSupport
PERIPH=$(LIBROOT)/Libraries/STM32F10x_StdPeriph_Driver
STARTUPPH=./Startup
USRCODE=./usr

# Search path for standard files
vpath %.c

# Search path for perpheral library
vpath %.c $(CORE)
vpath %.c $(PERIPH)/src
vpath %.c $(DEVICE)
vpath %.c $(STARTUPPH)
vpath %.c $(USRCODE)

# ARM-GCC编译选项，指定CM3类型
PTYPE = STM32F10X_MD


# Similarly, the linker script for the processor used must be specified. 
LDSCRIPT = ./Startup/stm32f103.ld
#LDSCRIPT = ./stm32f100.ld

# Compilation Flags
FULLASSERT = -DUSE_FULL_ASSERT 

# ARM-GCC编译选项
LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m3 -Wl,-Map=$(MAP_FILE)
CFLAGS+= -mcpu=cortex-m3 -mthumb 
CFLAGS+= -I$(DEVICE) -I$(CORE) -I$(PERIPH)/inc -I. -I$(STARTUPPH) -I$(USRCODE)
CFLAGS+= -D$(PTYPE) -DUSE_STDPERIPH_DRIVER $(FULLASSERT)

# Prepare the .bin binary file:
OBJCOPYFLAGS = -O binary

# Build executable 
$(BIN_FILE) : $(ELF)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@
#编译完自动删除多余编译文件，如果需要调试功能，请将这里注释掉
#	rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(MAP_FILE) $(STARTUP) $(CLEANOTHER)

$(ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS) $(LDFLAGS_POST)


# compile and generate dependency info

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
	$(CC) -MM $(CFLAGS) $< > $*.d

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

clean:
#rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(MAP_FILE) startup_stm32f* $(CLEANOTHER)
	rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(MAP_FILE) $(STARTUP) $(CLEANOTHER)

debug: $(ELF)
	arm-none-eabi-gdb $(ELF)


# pull in dependencies

-include $(OBJS:.o=.d)

