.text
.globl rng

rng:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
	
	# Load seed into register
    la   $t0, random_number
    lw   $t1, 0($t0)         # $t1 holds the LFSR value

    # Compute the tapped bits
    srl  $t2, $t1, 0         # Bit 0 (x^0)
    andi $t2, $t2, 1

    srl  $t3, $t1, 2         # Bit 2 (x^2)
    andi $t3, $t3, 1

    srl  $t4, $t1, 3         # Bit 3 (x^3)
    andi $t4, $t4, 1

    srl  $t5, $t1, 5         # Bit 5 (x^5)
    andi $t5, $t5, 1

    # XOR the tapped bits
    xor  $t6, $t2, $t3
    xor  $t6, $t6, $t4
    xor  $t6, $t6, $t5       # $t6 is the new bit

    # Shift right the LFSR and insert the new bit at bit 15
    srl  $t1, $t1, 1
    sll  $t6, $t6, 15
    or   $t1, $t1, $t6       # New LFSR value

    # Store updated LFSR
    sw   $t1, 0($t0)
    
end_of_rng:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    
get_loc:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    	jal rng
	lw $t1, random_number # random seed
	
	andi $t2 $t1 0x3F # random x: first 6 bits
	andi $t3 $t1 0x7C0 # random y: next 5 bits
	srl  $t3 $t3 6 # shift right to make y a number between 0-32
	blt $t2 40, put1
	andi $t2 $t2 31
	
	put1:
	blt $t3, 30, put2
	andi $t3 $t3 15
	

put2:
	ori $a0 $0 28
	ori $a1 $t2 0
	ori $a2 $t3 0
	
	ori $v0 $t2 0
	ori $v1 $t3 0 
	
	sw $t2 rng_x
	sw $t3 rng_y
	
	jal putChar_atXY
 
end_of_get_loc:   
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
