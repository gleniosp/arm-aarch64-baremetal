# AArch64 Baremetal

This repository hosts the baremetal source code which is used to explore AArch64 architecture on Raspberry-Pi 4B.

## OpenOCD and GDB

1. Prerequisites

   ```
   sudo apt install binutils libtool pkg-config make libusb-1.0-0-dev gdb-multiarch python3-pygments
   ```

2. Install `openocd` version - `0.12`
   ```
   cd ~/Downloads
   git clone https://github.com/openocd-org/openocd.git
   cd openocd
   git checkout v0.12.0
   ./bootstrap
   ./configure --enable-ftdi --disable-werror
   make
   sudo make install
   ```
3. Confirm `openocd` version to be as expected
   ```
   $ openocd -v
   Open On-Chip Debugger 0.12.0-01004-g9ea7f3d64 (2025-07-20-11:26)
   Licensed under GNU GPL v2
   For bug reports, read
   	http://openocd.org/doc/doxygen/bugs.html
   ```
4. Change the adptor settings in the openocd configuration file
   1. edit: `sudo nano /usr/local/share/openocd/scripts/interface/ftdi/ft232h-module-swd.cfg`
   1. find and replace `transport select swd` with `transport select jtag`
5. Attach `openocd` to the board using the following command:
   ```
   sudo openocd -f interface/ftdi/ft232h-module-swd.cfg -f target/bcm2711.cfg
   ```
6. Install GDB dashboard
   ```
   wget -P ~ https://git.io/.gdbinit
   ```
7. start gdb
   ```
   gdb-multiarch kernel8.elf -ex "target extended-remote localhost:3333"
   ```

The `kernel8.elf` is generated as explained in [EXTRAS](./experiments/EXTRA.md).

## Documentation Links

1. [Raspberry-Pi Documents](https://www.raspberrypi.com/documentation/)
   1. [BCM2711-ARM-Peripherals](https://datasheets.raspberrypi.com/bcm2711/bcm2711-peripherals.pdf)
   1. [GPIO PIN Header](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#gpio-and-the-40-pin-header)
1. [OpenOCD and JTAG setup](https://medium.com/@0xNoor/setup-openocd-with-jtag-uart-on-raspberry-pi-4-using-ft232h-da05ca01c693)

# License

All rights reserved. Only for learning purposes.
