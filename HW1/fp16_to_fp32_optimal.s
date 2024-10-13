.data
input_data: .word 0x0000
answer: .word 0x00000000
str1: .string "TRUE"
str2: .string "FALSE"

.text
input:
    la s0, input_data # address of input
    lw t0, 0(s0)
    slli t0, t0 16 #extend 16-bit to 32-bit
    li t1, 0x80000000 #sign-bit mask
    and t1, t0, t1 #sign bit
    li t2, 0x7FFFFFFF #nonsign-bit mask
    and t2, t0, t2 #nonsign part
    add t4, t2, x0
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
    and t4, t4, t5 # x = ((x >> 4) + x) & 0x0F0F0F0F
    srli t3, t4, 8
    add t4, t3, t4 # x += x >> 8
    srli t3, t4, 16
    add t4, t3, t4 # x += x >> 16
    li t5, 0x3F
    and t4, t4, t5
    addi t3, x0, 32
    sub t3, t3, t4 # 32 - (x & 0x3F)
    add a0, x0, t3 # put the result into a0
renorm:
    add t5, a0, x0 # load #of leading zero
    addi t4, x0, 5
    sub t5, t5, t4
    bgt t5, x0, result # if (renorm - 5) > 0
    add t5, x0, x0 # t5 = renorm_shift
result:
    li t0, 0x04000000
    add s1, t2, t0
    srai s1, s1, 8
    li t0, 0x7F800000
    and s1, s1, t0 # s1 = inf_nan_mask
    addi s2, t2, -1
    srai s2, s2, 31 # s2 = zero_mask
    sll t2, t2, t5
    srli t2, t2, 3
    li t6, 0x70
    sub t6, t6, t5
    slli t6, t6, 23
    add t2, t2, t6
    or t2, t2, s1
    xori s2, s2, -1
    and t2, t2, s2
    or s1, t1, t2 # the result is stored in s1
    la s3, answer
    lw t1, 0(s3)
    beq s1, t1, true
    la a0, str2
    li a7, 4
    ecall
    j exit
true:
    la a0, str1
    li a7, 4
    ecall
exit:
    add x0, x0, x0 # nop
