.text
.globl opening_screen

opening_screen:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    
    # generate the three starting pokemon
    	ori $a0 $0 6
	ori $a1 $0 11
	ori $a2 $0 0
	jal generate_pokemon
	
	ori $a0 $0 18
	ori $a1 $0 11
	ori $a2 $0 9
	jal generate_pokemon
	
	ori $a0 $0 30
	ori $a1 $0 11
	ori $a2 $0 18
	jal generate_pokemon
    # end of generating starter pokemon
    

end_of_opening_screen:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    

# No input required
# Output: v0 = what starter pokemon is selected
#
pokemon_code_select:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    
    ori   $t1, $0, 171             # Load condition1 value
    ori  $t2, $0,  342       # Load condition2 value

    jal  get_accelY      # Example input value (can be anything)
    ori $t0 $v0 0       # get the accelY value
    
    	### creating seed for random number generator
		lw $t9 random_number
		add $t9 $t9 $t0
		sw $t0 random_number
	###


    # if (t0 == t1)
    blt  $t0, $t1, if_block

    # else if (t0 == t2)
    bgt  $t0, $t2, elif_block

    # else
    j    else_block

if_block:
    # ---- code block 1 ----
    # Insert logic for "if" here

    ori $v0 $0 2
    la $t9 pokemon_list
    sw $v0 0($t9)
    j    end_of_code_select               # Jump past other blocks

elif_block:
    # ---- code block 2 ----
    # Insert logic for "else if" here
    ori $v0 $0 0
    la $t9 pokemon_list
    sw $v0 0($t9)
    j    end_of_code_select              # Jump past else block

else_block:
	ori $v0 $0 1	
	 la $t9 pokemon_list
    	sw $v0 0($t9)
    # ---- code block 3 ----
    # Insert logic for "else" here

    
    end_of_code_select:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    
final_opening_screen:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
	jal opening_screen
	
	openf:
	# new_horizontal screen
	jal code_line
	
	ori $a0, $0, 40
	ori $t9, $v0, 0 
	jal get_accelX
	
	addi $t4 $0 475
	bge $v0 $t4 end_fos
	
	jal pause_and_getkey
	bne $v0, $0, end_fos
	j openf
	
end_fos:
	lw $t0 old_code
	sw $t0 pokemon_list

    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure

    
    
    
	   
