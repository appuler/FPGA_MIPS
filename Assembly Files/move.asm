.text
.globl move_char

move_char:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame\
    
    
    addi $a0 $0 10
    jal pause_and_getkey
    addi $a0 $v0 0
    
	dir_1:
	addi $t2 $0 1
	bne $a0 $t2 dir_2
	beq $s0 $0 end_of_move
	addi $s0 $s0 -1
		
	
	dir_2:
	addi $t2 $0 2
	addi $t3 $0 39
	bne $a0 $t2 dir_3
	beq $s0 $t3 end_of_move
	addi $s0 $s0 1
	
	dir_3:
	addi $t2 $0 1
	bne $a0 $t2 dir_4
	beq $s1 $0 end_of_move
	addi $s1 $s1 -1
	
	dir_4:
	addi $t2 $0 2
	addi $t3 $0 29
	bne $a0 $t2 end_of_move
	beq $t1 $t3 end_of_move
	addi $t1 $t1 1
    
end_of_move:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure