.text
.globl horizontal_line


#a0: starting x
#a1: starting y 
#a2: size of line
#a3: charcode of the line
horizontal_line:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    
    
    ori  $t1, $a2, 0         # Load loop limit into $t1
    ori  $t0, $0, 0               # i = 0
    
    h_loop_start:
    beq  $t0, $t1, end_of_hl    # if i >= limit, exit loop

    
    # ---- loop body starts here ----
    
    addi $sp, $sp, -8
    sw $a0, 4($sp)
    sw $a1, 0($sp)
    
    or $a0, $0, $a3
    lw $a1, 4($sp)
    lw $a2, 0($sp)
    add $a1, $a1, $t0 # sets x = x + i to move through loop
    jal putChar_atXY
    
    lw $a1 0($sp)
    lw $a0 4($sp)
    addi $sp, $sp, 8
    
    # -------------------------------

    addi $t0, $t0, 1           # i++
    j    h_loop_start
    
    

end_of_hl:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    
    
code_line:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    jal pokemon_code_select
    addi $t0, $v0, 0 # new code
    
    addi $sp, $sp, -4
    sw $t0, 0($sp) # save value of t0 before jalling
 	
    	#erase old line
    	la $t4, old_code
    	lw $t5, 0($t4)
    	beq $t5, $t0, end_of_code_line
    	

	sll $t1, $t5, 3 # old code * 8
	sll $t2, $t5, 2 # old code * 4
	add $t3, $t2, $t1 # old code * 12
	addi $t3, $t3, 4 # 4 + old code * 12
    	
    	ori $a0, $t3, 0
    	ori $a1, $0, 15
    	ori $a2, $0, 7
    	ori $a3, $0, 27
    	jal horizontal_line
    	
    	la $t4, old_code
    	lw $t0, 0($sp) #bring back t0 and reset $sp 
    	addi $sp, $sp, 4
    	sw $t0 0($t4) # old_code = new_code
    	
    	# Generate new line
    	sll $t1, $t0, 3 # new code * 8
	sll $t2, $t0, 2 # new code * 4
	add $t3, $t2, $t1 # new code * 12
	addi $t3, $t3, 4 # 4 + new code * 12
    	
    	ori $a0, $t3, 0
    	ori $a1, $0, 15
    	ori $a2, $0, 7
    	ori $a3, $0, 28
    	jal horizontal_line
    
    
end_of_code_line:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    
    
# a0: x
# a1: y
vertical_line:

    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame

    move $s0, $a0             # store x in $s0
    move $s1, $a1             # store y in $s1

    li   $t0, 0               # i = 0

vline_loop:
    li   $a0, 28             # character = 195
    move $a1, $s0             # x stays the same
    add  $a2, $s1, $t0        # y + i

    jal  putChar_atXY         # call function

    addi $t0, $t0, 1          # i++
    li   $t1, 5
    blt  $t0, $t1, vline_loop # if i < 5, continue loop
    
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    
 
