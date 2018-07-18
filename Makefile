#++  以这个注释的需要根据实际修改

CFLAGS  = -O1 -g										#C语言和汇编编译选项
ASFLAGS = -g 
			
OBJS=  startup_stm32f10x.o system_stm32f10x.o			#依赖文件 这里不要改动，STM32官方启动文件需要用到这两个文件
OBJS += main.o io.o										#++  依赖文件都在这里修改 根据工程所有.c文件会生成相应.o目标文件

OUTPUT_DIR = ./output/

SOURCE_DIR += -I./usr									#++ 将设计到的源文件文件夹包含进来，编译选项						
SOURCE_DIR += -I./output
SOURCE_DIR += -I./startup

MAP_FILE=./output/STM32.map		# 生成MAP文件，如果不需要可一编译时删除 -Wl,-Map=$(MAP_FILE) 这个编译选项，调试时需要用到map
BIN_FILE=main.bin  				#++ 生成bin文件名字，此文件用于下载到实际芯片
ELF=stm32.elf					#++ 生成的可执行文件名字，

CC=arm-none-eabi-gcc			# 使用到的编译器，这样写为了方便修改
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy

vpath %.c ./startup								#++  makefile搜索路径，要告诉makefile你的源文件在哪里，每个地址独立写一行
vpath %.c ./usr									# %.c表示搜索所有.c文件

# ARM-GCC编译选项
PTYPE = STM32F10X_HD							#++ ARM-GCC编译选项，指定CM3类型。根据实际HD MD LD型改改就行
LDSCRIPT = ./startup/stm32f103.ld				# ARM-GCC编译选项，必须指明链接文件位置
FULLASSERT = -DUSE_FULL_ASSERT 					# Compilation Flags
LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m3 -Wl,-Map=$(MAP_FILE)
CFLAGS+= -mcpu=cortex-m3 -mthumb 
CFLAGS+= $(SOURCE_DIR)								#源文件文件夹
CFLAGS+= -D$(PTYPE) -DUSE_STDPERIPH_DRIVER $(FULLASSERT)
OBJCOPYFLAGS = -O binary

$(BIN_FILE) : $(ELF)
	$(OBJCOPY) $(OBJCOPYFLAGS) $(OUTPUT_DIR)$<  $(OUTPUT_DIR)$@

$(ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $(OUTPUT_DIR)$@ $(OUTPUT_DIR)*.o

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $(OUTPUT_DIR)$@
	$(CC) -MM $(CFLAGS) $< > $(OUTPUT_DIR)$*.d		#这项可用可不用

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $(OUTPUT_DIR)$@

clean:
	rm -r $(OUTPUT_DIR)*.o $(OUTPUT_DIR)*.elf $(OUTPUT_DIR)*.d $(OUTPUT_DIR)*.map
	
debug: $(ELF)
	arm-none-eabi-gdb $(ELF)
-include $(OBJS:.o=.d)

