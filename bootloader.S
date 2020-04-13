.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb
#define step #2
#define half_word #16

.global bootload
.section .rodata
    image: .incbin "kernel.bin"
    end_of_image:
    str_boot_start: .asciz "bootloader started"
    str_boot_end: .asciz "bootloader end"
    str_boot_indicate: .asciz "#"
.section .text
bootload:
    ldrh r0, =str_boot_start
    movt r0, :upper16:str_boot_start
    bl dbgput_line
    ldrh r0, =end_of_image
    movt r0, :upper16:end_of_image
    ldrh r1, =image
    movt r1, :upper16:image
    ldrh r2, =_ram_start
    movt r2, :upper16:_ram_start
    mov r4, 0
    sub r5, r0, r1
    loop:
        ldrh r3, [r1, r4]
        strh r3, [r2, r4]
        
        add r4, step
        
        cmp r5, r4
        bhi loop
    bl newline
    
    ldrh r0, =str_boot_end
    movt r0, :upper16:str_boot_end
    bl dbgput_line
    ldrh lr, =bootload_end
    movt lr, :upper16:bootload_end
    add lr, #1
    ldrh r2, =_ram_start
    movt r2, :upper16:_ram_start
    add r2, #4 
    ldrh r0, [r2]
    mov r4, step
    ldrh r1, [r2, r4]
    lsl r1, half_word
    orr r0, r1

    bx r0

    bootload_end:
    b bootload_end
