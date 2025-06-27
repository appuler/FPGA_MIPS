.text
.globl generate_pokemon


#a0: Starting X
#a1: Starting Y
#a2: Pokemon Code
generate_pokemon:
	
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame


    ori   $t2, $0, 3      # outer_limit -> $t2
    ori   $t3, $0, 3       # inner_limit -> $t3

    ori   $t0, $0, 0                 # i = 0 (outer loop init)

outer_loop:
    beq  $t0, $t2, end_outer    # if i >= outer_limit, exit outer loop

    ori   $t1, $0, 0                 # j = 0 (inner loop init)

inner_loop:
    beq  $t1, $t3, end_inner    # if j >= inner_limit, exit inner loop

    # ---- loop body starts here ----
	sll $t4, $t0, 1 # i *  2
	add $t4, $t4, $t0
	add $t5, $t4, $a2 # i * 3 + char_code_start
	add $t5, $t5, $t1 # t5: Char_code for putatchat  = i *3 + char_code + j
	add $t6, $a0, $t1 # t6: x + j for put 
	add $t7, $a1, $t0 # t7: y + i for put
	
	addi $sp, $sp, -12
	sw $a2 8($sp)
	sw $a1 4($sp)
	sw $a0 0($sp)
	
	or $a0 $0 $t5 
	or $a1 $0 $t6
	or $a2 $0 $t7
	jal putChar_atXY
	
	lw $a2 8($sp)
	lw $a1 4($sp)
	lw $a0 0($sp)
	addi $sp, $sp, 12

    # ---------------------------------

    addi $t1, $t1, 1            # j++
    j    inner_loop

end_inner:
    addi $t0, $t0, 1            # i++
    j    outer_loop

end_outer:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    
# a0: x
#a1: y

    



