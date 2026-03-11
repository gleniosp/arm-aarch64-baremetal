MEMORY
{
    /*
    Once the Raspberry Pi 4B hands over control to the Linux kernel, which lives at this 0x80000 address,
    then it'll actually run our code because we'll replace the kernel file with our own code.
    */
    RAM : ORIGIN = 0x80000, LENGTH = 4K
}

SECTIONS
{
    .text : {
        *(.init*)
        *(.text*)
    } > RAM

    .data : {
        . = ALIGN(8);
        *(.data*)
    } > RAM

    .bss : {
        . = ALIGN(8);
        *(.bss*)
    } > RAM

    .rodata : {
        . = ALIGN(8);
        *(.rodata*)
    } > RAM
}