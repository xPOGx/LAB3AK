.syntax unified
.cpu cortex-m4
.thumb
#define A #7
#define B #4
#define C #8

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start 
.word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #1: "
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line
    
    // calculate 
    mov r5, 0
    mov r2, A 
    mov r3, B
    mov r4, C

    mul r0, r2, r3
    
    cmp r0, #10
    ite ge 
    orrGE r5, r2, r3
    andLT r5, r2, r3
    mul r5, r4
    
    ldr r0, =final
    bl dbgput
    mov r0, r5
    bl dbgput_num
    
    end:
    b end
