_Minimum_Stack_Size = 256;/*用户自定义栈大小*/
ENTRY(Reset_Handler)
MEMORY
{
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 48K
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 256K
}
__ram_start__ = ORIGIN(RAM);
__ram_size__  = LENGTH(RAM);
__ram_end__   = __ram_start__ + __ram_size__;
_estack = __ram_end__;
/* highest address of the user mode stack */
PROVIDE ( _Stack_Limit = _estack - _Minimum_Stack_Size );
/* Sections Definitions */
SECTIONS
{
    .text :
    {
        KEEP(*(.isr_vector))            /* Startup code */
        *(.text)                   /* code */
        *(.text.*)                 /* remaining code */
        *(.rodata)                 /* read-only data (constants) */
        *(.rodata.*)
        *(.glue_7)
        *(.glue_7t)
        *(.vfp11_veneer)
        *(.v4_bx)
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } >FLASH
    . = ALIGN(4);
    _sidata = .;
    /* .data secion */
    .data  : AT ( _sidata )
    {
        . = ALIGN(4);
        _sdata = . ; /* This is used by the startup in order to initialize the .data secion */
        *(.data)
        *(.data.*)
        . = ALIGN(4);
        _edata = . ; /* This is used by the startup in order to initialize the .data secion */
    } >RAM
    /* .bss secion */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;/* This is used by the startup in order to initialize the .bss secion */
	__bss_start__ = _sbss;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = . ; /* This is used by the startup in order to initialize the .bss secion */
	__bss_end__ = _ebss;
    } >RAM
    PROVIDE ( end = _ebss );
    PROVIDE ( _end = _ebss );
    PROVIDE ( _exit = _ebss );
    PROVIDE (_stackend = ORIGIN(RAM) + LENGTH(RAM) - _Minimum_Stack_Size);
}
