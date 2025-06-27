.text
.globl rpg

rpg:

    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    ori $a0 $0 54
    ori $a1 $s0 0
    ori $a2 $s1 0
    jal putChar_atXY
    
    jal get_loc
    
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    

final_rpg:

    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    	addi $a0, $0, 54
	lw $a1 main_x
	lw $a2 main_y
	jal putChar_atXY
	
	jal get_loc
	
	rpg_movement:
   
   	 
   	 addi $a0 $0 10
   	 jal pause_and_getkey  	 
   	 
   	 addi $a0, $v0, 0  
   	 sw $v0 dir
   	 jal move2
   	 
   	addi $a0, $0, 54
	lw $a1 main_x
	lw $a2 main_y
	jal putChar_atXY
	
	jal erase_old
	
	lw $t0 rng_x
	lw $t1 rng_y
	
	lw $t2 main_x
	lw $t3 main_y
	
	bne $t0 $t2 rpg_movement
	bne $t1 $t3 rpg_movement
    
    
end_of_rpg:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
