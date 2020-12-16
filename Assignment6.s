##################################
# Name: Vinh Ta
# Description: Array iputted from user and searches for elements
##################################

	.data
arraysize:	.word 9
numbers:	.word 0
msg1:		.asciiz "Enter an integer to specify how many times to repeat:\n"
msg2:		.asciiz "Specify how many numbers should be stored in the array (at most 9):\n"
msg3:		.asciiz "Enter an integer to search:\n"
msg4:		.asciiz "Result Array Content:\n"
msg5:		.asciiz "The entered element was not found\n"
msg6:		.asciiz "The entered element was found\n"
msg7:		.asciiz "Enter an integer: \n"
msg8:		.asciiz "The array content:\n"
line:		.asciiz "\n"

#program
	.text
	.globl main
main:
	la $a0, msg1
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $s0, $v0		# $s0 = repeat
	li $s1, 0		# $s1 = i
	
  For:
	slt $t0, $s1, $s0	# i < repeat, $t0 =1
	beq $t0, $zero, Ex_For	# i >= repeat, branch
	addi $sp, $sp, -4
	la $a0, numbers		# load numbers[] to $a0
	la $t0, arraysize
	lw $a1, 0($t0)		# load arraysize to $a1
	sw $ra, 0($sp)		# store current PC
	jal searchElement	# call searchElement()
	lw $ra, 0($sp)		# load back PC
	addi $sp, $sp, 4
	addi $s1, 1		# i++
	j For
  Ex_For:
	jr $ra		# return


############################################################################
# Procedure searchElement
# Description: call readArray and search for elements in array and double searched element
# parameters: $a0 = address of array && $a1 = arraysize
# return value: NA
# registers to be used: $s2, $s3, $s4 will be used.
############################################################################
 
searchElement:
	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0
	
	   la $a0, msg2		# prompt msg2
	   li $v0, 4
	   syscall	

	li $v0, 5
	syscall
	move $a2, $v0		# $a2 = howMany

	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)		# store current PC
	jal readArray
	lw $ra, 0($sp)		# load back PC
	addi $sp, $sp, 4

	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0

	   la $a0, msg3		# prompt msg3
	   li $v0, 4
	   syscall

	li $v0, 5
	syscall
	move $s2, $v0		# $s2 = search

	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4

	li $s3, 0		# $s3 = found
	li $s4, 0		# $s4 = i

  While_SE:
	slt $t0, $s4, $a2	# i < howMany, $t0 =1
	beq $t0, $zero, Ex_whiSE
	slt $t0, $s4, $a1	# i < length, $t0 =1
	beq $t0, $zero, Ex_whiSE
	
	sll $t0, $s4, 2		# $t0 = i*4
	add $t1, $t0, $a0	# combine i & array[]
	lw $t2, 0($t1)		# $t2 = array[i]
	bne $t2, $s2, Ex_if	# array[i] != search, branch
	li $s3, 1		# found =1
	sll $t2, $t2, 1		# array[i] *= 2
	sw $t2, 0($t1)
   Ex_if:
	addi $s4, $s4, 1	# i++
	j While_SE
  
  Ex_whiSE:
	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0

	   la $a0, msg4
	   li $v0, 4
	   syscall

	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4
	
	li $s4, 0		# i =0
  While_SE2:
	slt $t0, $s4, $a2	# i < howMany, $t0 =1
	beq $t0, $zero, Ex_whiSE2
	slt $t0, $s4, $a1	# i < length, $t0 =1
	beq $t0, $zero, Ex_whiSE2
	
	sll $t0, $s4, 2		# $t0 = i*4
	add $t1, $t0, $a0	# combine i & array[]
	lw $t2, 0($t1)		# $t2 = array[i]
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0

	   move $a0, $t2
	   li $v0, 1
	   syscall
	   
	   la $a0, line		# print array
	   li $v0, 4
	   syscall

	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4
	addi $s4, $s4, 1
	j While_SE2

  Ex_whiSE2:
	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0

	bne $s3, $zero, Else_SE
	la $a0, msg5
	li $v0, 4
	syscall
	j Ex_ifSE
   Else_SE:
	la $a0, msg6
	li $v0, 4
	syscall
   Ex_ifSE:
	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4

	jr $ra			# return



############################################################################
# Procedure readArray
# Description: scan in and print array content
# parameters: $a0 = address of array, $a1 = length, $a2 = howMany 
# return value: NA
# registers to be used: $s5, $s6 will be used.
############################################################################

readArray:
	li $s6, 0		# i =0
  While_RA:	
	slt $t0, $s6, $a2	# i < howMany, $t0 =1
	beq $t0, $zero, Ex_whiRA
	slt $t0, $s6, $a1	# i < length, $t0 =1
	beq $t0, $zero, Ex_whiRA

	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0
	
	   la $a0, msg7		# prompt msg7
	   li $v0, 4
	   syscall

	   li $v0, 5
	   syscall
	   move $s5, $v0	# $s5 = num

	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4

	sll $t0, $s6, 2		# $t0 = i*4
	add $t1, $t0, $a0	# combine i & array
	lw $t2, 0($t1)		# $t2 = array[i]
	move $t2, $s5		# $t2 = num
	sw $t2, 0($t1)
	addi $s6, $s6, 1	# i++
	j While_RA
  
  Ex_whiRA:
	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0
	
	   la $a0, msg8		# prompt msg8
	   li $v0, 4
	   syscall

	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4

	li $s6, 0		# i =0
  While_RA2:
	slt $t0, $s6, $a2	# i < howMany, $t0 =1
	beq $t0, $zero, Ex_whiRA2
	slt $t0, $s6, $a1	# i < length, $t0 =1
	beq $t0, $zero, Ex_whiRA2

	sll $t0, $s6, 2		# $t0 = i*4
	add $t1, $t0, $a0	# combine i & array[]
	lw $t2, 0($t1)		# $t2 = array[i]

	addi $sp, $sp, -4
	sw $a0, 0($sp)		# store $a0
	
	   move $a0, $t2	# print array
	   li $v0, 1
	   syscall

	   la $a0, line
	   li $v0, 4
	   syscall

	lw $a0, 0($sp)		# load back $a0
	addi $sp, $sp, 4
	addi $s6, $s6, 1	# i++
	j While_RA2

  Ex_whiRA2:
	jr $ra		# return



	

