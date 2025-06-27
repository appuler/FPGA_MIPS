.text

.globl move2

# a0: direction
move2:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack 

    # if (dir != 0)
    beq $a0, $0, switch_start  # if dir == 0, skip the putChar_atXY(0, main_x, main_y)
    	 
    
    # Call putChar_atXY(0, main_x, main_y)
     # call putChar_atXY(0, main_x, main_y)

switch_start:
    # switch (dir)
    li   $t0, 0
    beq  $a0, $t0, return_zero

    li   $t0, 1
    beq  $a0, $t0, case1

    li   $t0, 2
    beq  $a0, $t0, case2

    li   $t0, 3
    beq  $a0, $t0, case3

    li   $t0, 4
    beq  $a0, $t0, case4

    # If none match, continue

case1:
    lw   $t1, main_x
    addi $t1, $t1, -1         # main_x = main_x - 1
    sw   $t1, main_x
    j after_cases
    # Fall through

case2:
    lw   $t1, main_x
    addi $t1, $t1, 1          # main_x = main_x + 1
    sw   $t1, main_x
    j after_cases
    # Fall through

case3:
    lw   $t1, main_y
    addi $t1, $t1, -1         # main_y = main_y - 1
    sw   $t1, main_y
    j after_cases
    # Fall through

case4:
    lw   $t1, main_y
    addi $t1, $t1, 1          # main_y = main_y + 1
    sw   $t1, main_y
    # Fall through to common code

# After switch/cases
after_cases:
    # Call putChar_atXY(1, main_x, main_y)
    li   $a0, 54             # argument ch = 1
    lw   $a1, main_x
    lw   $a2, main_y
    jal  putChar_atXY
    


return_zero:
    li   $v0, 0              # return 00

	
final_block:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
	
	

	
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
	
	
	
	
	
	
	
	
	
	
	
	
	
