.text
.globl text_generator

# a0: address of array of text
# a1: size of array
# a2: x_start
# a3: y_start
text_generator:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    

	ori $t0 $0 0 # i
	ori $t1 $a0 0 # array_address
	ori $t2 $a1 0 # size 
	ori $t3 $a2 0 # x start
	ori $t4 $a3 0 # y
	
	text_loop:
	beq $t0 $t2 text_end
	lw $a0 0($t1) # loads the charcode
	ori $a1 $t3 0
	ori $a2 $t4 0
	jal putChar_atXY
	
	addi $t0 $t0 1
	addi $t1 $t1 4
	addi $t3 $t3 1
	
	j text_loop
	
text_end:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
