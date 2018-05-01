#                         ICS 51, Lab #2
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
#      Remember to fill in your name, student ID in the designated fields.
#
#
#      contact sajjadt@uci.edu
###############################################################
#                           Data Section
.data

#
# Fill in your name, student ID in the designated sections.
#
student_name: .asciiz "Taylor Lang Lopez"
student_id: .asciiz "93664822"

filter_blur: .word 1, 2, 1, 2, 4, 2, 1, 2, 1
filter_dilate: .word 0, 1, 0, 1, 1, 1, 0, 1, 0
filter_sharpening: .word 0, -1, 0, -1, 5, -1, 0, -1, 0
filter_sobel_x: .word 1, 0, -1, 2, 0, -2, 1, 0, -1
filter_no_change: .word 0, 0, 0, 0, 1, 0, 0, 0, 0

input_1: .byte 100, 60, 81, 2
input_2: .byte 10, 20, 30, 110, 127, 130, 210, 220, 230
input_3: .byte 0, 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55

output_1: .space 4
output_2: .space 9
output_3: .space 16

# thresh value = 128
test_11_expected_output: .byte 0, 0, 0, 0
test_12_expected_output: .byte 0, 0, 0, 0, 0, 255, 255, 255, 255
test_13_expected_output: .byte 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0


# scale = 4
test_filter_1: .word 1, 2, 1, -1, -2, -1, 1, 2, 1
test_21_expected_output: .byte 100, 60, 81, 2
test_22_expected_output: .byte 10, 20, 30, 110, 116, 130, 210, 220, 230
test_23_expected_output: .byte 0, 10, 20, 30, 40, 108, 116, 130, 140, 150, 107, 230, 240, 250, 255, 55


new_line: .asciiz "\n"
space: .asciiz " "

i_str: .asciiz "Program input: " 
po_str: .asciiz "Program output: " 
eo_str: .asciiz "Expected output: " 
t1_str: .asciiz "Testing part 1: \n" 
t2_str: .asciiz "Testing part 2: \n" 

#
# Set these variables to point to the right files on your computer
#
fin: .asciiz "C:\Users\i1A489507\Documents\GitHub\UCI_ICS51\Lab2\lenna.pgm"
fout_thresh: .asciiz "C:\Users\i1A489507\Documents\GitHub\UCI_ICS51\Lab2\lenna_thresh.pgm"
fout_filter: .asciiz "C:\Users\i1A489507\Documents\GitHub\UCI_ICS51\Lab2\lenna_filtered.pgm"

.align 2
in_buffer: .space 400000
in_buffer_end:
.align 2
out_buffer: .space 400000
out_buffer_end:

###############################################################
#                           Text Section
.text
# Utility function to print byte arrays
#a0: array
#a1: length
print_array:

li $t1, 0
move $t2, $a0
print:

lb $a0, ($t2)
andi $a0, $a0, 0xff
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 1
addi $t1, $t1, 1
blt $t1, $a1, print



jr $ra
###############################################################
###############################################################
#                       PART 1 (Image thresholding)
#a0: input buffer address
#a1: output buffer address
#a2: image dimension
#a3: threshold value
###############################################################
threshold:
############################## Part 1: your code begins here ###
move $t5, $a0 # initialize to start of input_buffer
move $t6, $a1 # initialize to start of output_buffer
move $t7, $a3
mult $a2, $a2
mflo $t0
li $t1, 0x00

iter_pixels:
beq $t1, $t0, iter_finished
lb $t2, ($t5) #load pixel 
addi $t5, $t5, 0x01
addi $t1, $t1, 0x01
sltu $t3, $t2, $t7 # If t2 < threshold set $t3 == 1
bgtz $t3, store_dark
b store_light

store_dark:
li $t4, 0x00
sb $t4, ($t6)
addi $t6, $t6, 0x01
b iter_pixels

store_light:
li $t4, 0xFF
sb $t4, ($t6)
addi $t6, $t6, 0x01
b iter_pixels

iter_finished:
############################## Part 1: your code ends here ###
jr $ra
###############################################################
###############################################################
#                           PART 2 (Filters)
#a0: input buffer address
#a1: output buffer address
#a2: kernel (3x3) address
#a3: scale
#s0: image dimension
###############################################################
conv_filter:
############################### Part 2: your code begins here ##


############################### Part 2: your code ends here  ##
jr $ra
###############################################################
###############################################################
#                          Main Function
main:

.text

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall


# Test threshold function
li $v0, 4
la $a0, t1_str
syscall



la $a0, input_1
la $a1, output_1
li $a2, 2
li $a3, 128
jal threshold


la $a0, i_str
syscall
la $a0, input_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall


la $a0, eo_str
syscall
la $a0, test_11_expected_output
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_2
la $a1, output_2
li $a2, 3
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_12_expected_output
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall



la $a0, input_3
la $a1, output_3
li $a2, 4
li $a3, 128
jal threshold


la $a0, i_str
syscall
la $a0, input_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_13_expected_output
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

# Test filter function

li $v0, 4
la $a0, t2_str
syscall


li $s0, 2 # dim
la $a0, input_1
la $a1, output_1
la $a2, test_filter_1
li $a3, 16
jal conv_filter 
la $a0, i_str
syscall
la $a0, input_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, po_str
syscall
la $a0, output_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
la $a0, test_21_expected_output
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall



li $s0, 3 # dim
la $a0, input_2
la $a1, output_2
la $a2, test_filter_1
li $a3, 4
jal conv_filter 
la $a0, i_str
syscall
la $a0, input_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, po_str
syscall
la $a0, output_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
la $a0, test_22_expected_output
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall




li $s0, 4 # dim
la $a0, input_3
la $a1, output_3
la $a2, test_filter_1
li $a3, 4
jal conv_filter 
la $a0, i_str
syscall
la $a0, input_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, po_str
syscall
la $a0, output_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
la $a0, test_23_expected_output
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)



# Threshold
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
li $a2, 512
li $a3, 40
jal threshold 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_thresh      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor


# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall    

# Test conv 1
li $s0, 512 # dim
la $a0, in_buffer
add $a0, $a0, 16
la $a1, out_buffer
add $a1, $a1, 16
la $a2, filter_dilate
li $a3, 5
jal conv_filter 



#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_filter      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor


# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close file

_end:
# end program
li $v0, 10
syscall
