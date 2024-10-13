.data
input_data: .word 0x7FFF
answer: .word 0x7FFFFFFF
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
    addi t3, x0, 31 #loop counter i
my_clz:
    addi t4, x0, 1 #load 1
    sll t4, t4, t3 # 1 << i
    and t4, t2, t4 # nonsign & (1 << i)
    blt x0, t4, renorm # finish counting
    addi a0, a0, 1 # count++
    addi t3, t3, -1 #--i
    blt t3, x0, renorm
    beqz t4, my_clz # keep counting
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
    or a0, t1, t2 # the result is stored in a0
    la s3, answer
    lw t1, 0(s3)
    beq a0, t1, true
    la a0, str2 # the result is wrong
    li a7, 4
    ecall
true: # the result is the same with the answer
    la a0, str1
    li a7, 4
    ecall
