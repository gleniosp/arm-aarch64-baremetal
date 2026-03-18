// this writes an integer to a generic register
#define w32(addr, value) *((volatile unsigned int *)addr) = value
// this reads an integer from a generic register
#define r32(addr) *((volatile unsigned int *)addr)

void uart_init(void)
{
    /*
        See chapter 2 of the document: https://pip-assets.raspberrypi.com/categories/545-raspberry-pi-4-model-b/documents/RP-008248-DS-1-bcm2711-peripherals.pdf?disposition=inline
        The registers also don't initialize with 0x7E but with 0xFE because they are legacy master addresses. See section "1.2.4. Legacy master addresses" in the document.
    */
    w32(0xFE215004, 1);
    w32(0xFE215044, 0);
    w32(0xFE215060, 0);

    /*
        We tested with 0 value here to the register and it didn't work. It only worked by writing the value 3.
        This seems to be different from what the documentation says for the "AUX_MU_LCR_REG Register", as the bits 5:1 are reserved, so
        we only could write to the first bit and the bits 6 and 7. By writing 3 here, we're writing 11 to this register, which would
        affect the bit position 1 in the register, which is reserved. So, maybe the documentation has this misleading information.
    */
    w32(0xFE21504c, 3);
    w32(0xFE215050, 0);

    // 115200 is the baud rate. The 500MHz value comes from the configurations we set in the config.txt file in the sdcard folder of this project.
    w32(0xFE215068, ((500000000 / (8 * (115200 + 1)))));

    /*
        Configuring the GPIOs for UART usage. This will configure GPIO14 and GPIO15 to use the 'alternate function 5', as the value of the bits
        are being set to 2, which means this 'alternate function 5'. The alternate function 5 represents TXD1 function for GPIO14 and RXD1 function
        for GPIO15. See sections "5.2. Register View" and "5.3. Alternative Function Assignments" in the document.
    */
    w32(0xFE200004, ((2 << 12) | (2 << 15)));

    w32(0xFE215060, 3);
}

void uart_putc(const char c)
{
    // While the transmition is not empty, loop here.
    while (!(r32(0xFE215054) & 0x20))
        ;
    // If UART is not transmiting anymore, we leave the above loop and can transmit/write to the UART.
    // The address to write and read is the same, it'll depending if who is transmiting and who is receiving at the time.
    w32(0xFE215040, (unsigned int)c);
}

void uart_puts(char *str)
{
    while (*str)
    {
        uart_putc(*str);
        str++;
    }
}

void entry()
{
    uart_init();
    while (1)
    {
        uart_puts("Hello, World!\n\r");
    }
}