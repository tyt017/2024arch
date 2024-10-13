.data
input_data: .word 278
str0: .string "0"
str1: .string "1"

.text
intput:
    la s0, input_data
    lw t0, 0(s0)
    add t4, t0, x0
my_clz:
    srli t3, t4, 1
    or t4, t4, t3 # x |= x >> 1
    srli t3, t4, 2
    or t4, t4, t3 # x |= x >> 2
    srli t3, t4, 4
    or t4, t4, t3 # x |= x >> 4
    srli t3, t4, 8
    or t4, t4, t3 # x |= x >> 8
    srli t3, t4, 16
    or t4, t4, t3 # x |= x >> 16
    
    li t5, 0x55555555
    srli t3, t4, 1
    and t3, t3, t5
    sub t4, t4, t3 # x -= x >> 1 & 0x55555555
    li t5, 0x33333333
    srli t3, t4, 2
    and t3, t3, t5
    and t5, t4, t5
    add t4, t3, t5 # x = (x >> 2 & 0x33333333) + (x & 0x33333333)
    li t5, 0x0F0F0F0F
    srli t3, t4, 4
    add t4, t3, t4
    and t4, t4, t5 # x = ((x >> 4) + x) & 0x0f0f0f0f
    srli t3, t4, 8
    add t4, t3, t4 # x += x >> 8
    srli t3, t4, 16
    add t4, t3, t4 # x += x >> 16
    li t5, 0x3F
    and t4, t4, t5
    add a0, x0, t4 # put the result into a0
out_my_clz:
    add t2, x0, a0 # loop counter for L-1 zeros
    addi t3, a0, -1 # the MSB of the input
    addi t5, a0, 0 # loop counter for output_binary
output:
    addi t2, t2, -1
    bgt t2, x0, output_zero
    j output_binary
output_zero:
    la a0, str0
    li a7, 4
    ecall
    j output
output_binary:
    srl t4, t0, t3
    andi t1, t4, 1
    addi t3, t3, -1
    addi t5, t5, -1
    blt t5, x0, exit
    beqz t1, output_zero
output_one:
    la a0, str1
    li a7, 4
    ecall
    bgt t5, x0, output_binary
exit:
    add x0, x0, x0 # nop
