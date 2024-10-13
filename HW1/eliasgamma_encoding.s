.data
input_data: .word 278
str0: .string "0"
str1: .string "1"

.text
intput:
    la s0, input_data
    lw t0, 0(s0)
    addi t3, x0, 31
my_clz:
    addi t4, x0, 1 #load 1
    sll t4, t4, t3 # 1 << i
    and t4, t0, t4 # x & (1 << i)
    blt x0, t4, out_my_clz # finish counting
    addi a0, a0, 1 # count++
    addi t3, t3, -1 #--i
    blt t3, x0, out_my_clz
    beqz t4, my_clz # keep counting
out_my_clz:
    li t1, 32
    sub t1, t1, a0
    add t2, x0, t1 # loop counter for L-1 zeros
    addi t3, t1, -1 # the MSB of the input
    add t5, t1, x0 # loop counter for output_binary
output:
    addi t2, t2, -1
    bgt t2, x0, output_zero
    j output_binary
output_zero: # print 0
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
output_one: # print 1
    la a0, str1
    li a7, 4
    ecall
    bgt t5, x0, output_binary
exit:
    add x0, x0, x0 # nop
