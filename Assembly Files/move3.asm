.text
.globl move3

move3:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack 
    # call get_accelX()
    jal get_accelX
    move $t0, $v0      # save ax in $t0

    # call get_accelY()
    jal get_accelY
    move $t1, $v0      # save ay in $t1 (even though not used here)

    # if (ax < 171)
    li $t2, 171
    blt $t0, $t2, ax_less_than_171_1

check_ax_gt_342_1:
    # if (ax > 342)
    li $t3, 342
    bgt $t0, $t3, ax_greater_than_342_1

check_ax_less_than_171_2:
    # if (ax < 171) again
    li $t2, 171
    blt $t0, $t2, ax_less_than_171_2

check_ax_greater_than_342_2:
    # if (ax > 342) again
    li $t3, 342
    bgt $t0, $t3, ax_greater_than_342_2
    j after_all
    
 ax_less_than_171_1:
    # main_x = main_x + 1
    la $t4, main_x
    lw $t5, 0($t4)
    addi $t5, $t5, 1
    sw $t5, 0($t4)
    j check_ax_gt_342_1

ax_greater_than_342_1:
    # main_x = main_x - 1
    la $t4, main_x
    lw $t5, 0($t4)
    addi $t5, $t5, -1
    sw $t5, 0($t4)
    j check_ax_less_than_171_2

ax_less_than_171_2:
    # main_x = main_x + 1
    la $t4, main_x
    lw $t5, 0($t4)
    addi $t5, $t5, 1
    sw $t5, 0($t4)
    j check_ax_greater_than_342_2

ax_greater_than_342_2:
    # main_x = main_x - 1
    la $t4, main_x
    lw $t5, 0($t4)
    addi $t5, $t5, -1
    sw $t5, 0($t4)
    j after_all
    


after_all:

	    # Call putChar_atXY(1, main_x, main_y)
    li   $a0, 54             # argument ch = 1
    lw   $a1, main_x
    lw   $a2, main_y
    jal  putChar_atXY
    
    # pause(100)

    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure

########################################

    
    
    
 erase_old:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack 	
	
	lw $a0 dir

    li   $t0, 1
    beq  $a0, $t0, dcase1

    li   $t0, 2
    beq  $a0, $t0, dcase2

    li   $t0, 3
    beq  $a0, $t0, dcase3

    li   $t0, 4
    beq  $a0, $t0, dcase4

    j erase_old_final        # if dir is not 1-4, just return

dcase1:
    # putChar_atXY(192, main_x + 1, main_y)
    li   $a0, 27
    lw   $t1, main_x
    lw   $a2, main_y
    addi $a1, $t1, 1
    jal  putChar_atXY
    j erase_old_final
    # fall through

dcase2:
    # putChar_atXY(192, main_x - 1, main_y)
    li   $a0, 27
    lw   $t1, main_x
    lw   $a2, main_y
    addi $a1, $t1, -1
    jal  putChar_atXY
    j erase_old_final
    
    # fall through

dcase3:
    # putChar_atXY(192, main_x, main_y + 1)
    li   $a0, 27
    lw   $a1, main_x
    lw   $t2, main_y
    addi $a2, $t2, 1
    jal  putChar_atXY
    j erase_old_final
    # fall through

dcase4:
    # putChar_atXY(192, main_x, main_y - 1)
    li   $a0, 27
    lw   $a1, main_x
    lw   $t2, main_y
    addi $a2, $t2, -1
    jal  putChar_atXY

erase_old_final:	
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
	
	
	
	
	
	
	
	