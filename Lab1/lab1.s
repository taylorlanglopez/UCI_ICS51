.data
student_name: .asciiz "Taylor Lang Lopez"
student_id: .asciiz "93664822"

swap_bits_test_data:  .word 0xAAAAAAAA, 0x01234567, 0xFEDCBA98
swap_bits_expected_data:  .word 0x5555555d5, 0x02138A9B, 0xFDEC7564

double_range_test_data: .word 80000, 111, 0, -111, 11
double_range_expected_data: .word 160000, 0, -200

.text
main:

swap_bits:
li $t4, 0xAAAAAAAA #All even bits of 32 bit integers
li $t5, 0x55555555 #All odd bits of 32 bit integers
and $t1, $t0, $t4
and $t2, $t0, $t5
srl $t1, $t1, 0x01
sll $t2, $t2, 0x01
or $t0, $t1, $t2

li $v0, 1
move $a0, $t0
syscall

double_range:
li $t7, 1
move $t0, $a0
move $t1, $a1
move $t2, $a2
#####My Code########
move $t3, $t0 #MAX
move $t4, $t0 #MIN
#Finding min => $t3
find_min:
li $t6, 0
slt $t6, $t1, $t3
bgtz $t6, set_t1_0
beq $t6, $zero, check_t2_0

set_t1_0:
move $t3, $t1

check_t2_0:
li $t6, 0
slt $t6, $t2, $t3
bgtz $t6, set_t2_0
beq $t6, $zero, find_max

set_t2_0:
move $t3, $t2

find_max:
li $t6, 0
slt $t6, $t4, $t1 
bgtz $t6, set_t1_1
beq $t6, $zero, check_t2_1

set_t1_1:
move $t4, $t1 

check_t2_1:
li $t6, 0
slt $t6, $t4, $t2 
bgtz $t6, set_t2_1
beq $t6, $zero, find_max

set_t2_1:
move $t4, $t2 

#t4 has max, t3 has min
add $t7, $t4, $t3
sll $t7, $t7, 1
move $t0, $t7
####End My Code#####
move $v0, $t0
jr $ra

# end program
li $v0, 10
syscall
