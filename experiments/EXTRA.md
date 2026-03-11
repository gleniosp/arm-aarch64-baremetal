This can be run in your local computer, connected to the Raspberry Pi 4B via the FT232H adapter.

To compile our code, which is generated as the `kernel8.img` file, we run: `make img` or simply `make` (if the `img` is the first command in the Makefile, because `make` alone runs the first command it finds).
The idea is that in a normal process the Raspberry Pi would search for a file named `kernel8.img` to boot up the Linux Kernel. However, we're going to trick it into loading our code instead by compiling our code and naming it `kernel8.img` as well.
The contents for the SD Card are in the `sdcard` folder, and we replace the existent `kernel8.img` there. We then copy the contents in these folder to our SD Card and insert into the Pi. These SD Card files were obtained by downloading the Raspberry Pi OS image from the Pi website, extracting the image, we only getting what was essential within the `bootfs` partition. The `rootfs` partition isn't relevant to us because it is the Linux Kernel itself.

A `kernel8.elf` is generated as well from our compilation process, which we can use to debug our code with GDB, becase the ELF file provides the debug symbols to GDB. So, `kernel8.img` is used to run on the Pi and `kernel8.elf` is used in our machine to help debug the running code with GDB.

Once you have these files, follow the instructions in the [README](../README.md).

The [pinout](../docs/ft232h-rpi-connection.jpg) image shows how to connect the FT232H board to the Pi. Then we power the Pi through its USB power port, connect the FT232H via USB to our PC and start openocd server and then GDB. By the way, when running openocd you'll see that it creates a gdb server connection for each of the 4 CPUs available in the Pi. The CPU 0 is the one connected via the 3333 port (which was used in the [README](../README.md)).
Once GDB is connected, we can run `ni` so it moves the first instruction, which will be our code which starts at the 0x80000 RAM address as per our `linker.ld` script. This might be different at this point, but the first code we used in `start.S` to test things out was,

```assembly
.section ".init"
_start:
    b .
```

we essentially have an infinite loop created by `b .`, so we'll only see the GDB always looping at the same initial address 0x80000.
We can also send the `c` instruction to GDB to let it run freely in its infinite loop, then we can do `Ctrl + C` to make it stop at the current instructions, which will be the same instruction `b .` (or `b 0x80000`, which is the current location).
Keep in mind that the 4 CPUs that the Pi has will be jumping and looping to the same logic. We'll need to change this later so we can control which CPU runs what, like making 1 CPU run the loop and the others stay idle.

Finally, after all this, we'll be able move on to create more complex programs, like printing "Hello World" via UART.
