.section ".init"
_start:
    /*
       `mpidr_el1` register encodes the CPU index. So, `mpidr_el1` = 0 => CPU of number 0, `mpidr_el1` = 1 => CPU of number 1 etc.
       So we read this register value into the x1 register.
    */
    mrs    x1, mpidr_el1
    /* Then, we use an 'and' instruction to only select the last two bits of this register (as #3 is equal to 11 in binary). */
    and    x1, x1, #3
    /*
       If the value of these last two bits is not equal to 0, branch to the 'cpu_x' label. For the case when it's zero, it means
       we're at the CPU of index/number 0. In this case, the CPU 0 will just move to execute the code in the label `cpu_0`, which
       is the next instruction.
    */
    cbnz   x1, cpu_x

cpu_0:
    /*
       We need to point the Stack Pointer (SP) to a safe location that the C functions can use, otherwise they'll
       just point to a random sp value which might go bad. Our code in the RAM will start at the label `_start` define above,
       which will be put at the 0x80000 address in the RAM as stated in the `linker.ld` file.
       So, we essentially add 0x400 to this address to be the start of our Stack Pointer area in the memory, which should be enough to be safe.
       When running this code, we should see the CPU (when debugging with GDB), booting up and having the register `sp = 0x80400`, or better yet,
       `sp = 0x0000000000080400` (because the register has 64-bits in our CPU architecture, so it pad the rest of the bits with 0).
    */
    ldr    x2, =_start + 0x400
    mov    sp, x2
    /* Here we will branch to the label 'entry', which is our main C code function in `main.c`. */
    b      entry

cpu_x:
    /* wfe is the 'wait for event' instruction. It'll wait for interrupts for a bit, and if there is none, move to the next instruction. */
    wfe
    /* It keeps branch to the same label 'cpu_x', creating an infinite loop at this part of the code for all other CPUs that are not the CPU 0. */
    b      cpu_x
