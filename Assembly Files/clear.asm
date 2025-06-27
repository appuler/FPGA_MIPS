.text
.globl clear_screen


clear_screen:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack

	
	li $t0 0x10020000
	addi $t1 $t0 4800
	addi $t2 $0 27
	
	screen_loop:
		sw $t2 0($t0)
		addi $t0 $t0 4
		bne $t0 $t1 screen_loop

end_outer_loop_cs:
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
