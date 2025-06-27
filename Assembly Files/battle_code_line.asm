.text
.globl battle_under_line

battle_under_line:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
        # Call get_accelX()
    jal get_accelX
    move $t0, $v0          # Save ax into $t0

    # if (ax > 342) battle_line = 0;
    li   $t1, 342
    ble  $t0, $t1, check_low  # if (ax <= 342) skip to check_low
    li   $t2, 0
    la   $t3, battle_line
    sw   $t2, 0($t3)
    j continue

check_low:
    # if (ax < 171) battle_line = 1;
    li   $t1, 171
    bge  $t0, $t1, continue   # if (ax >= 171) skip setting battle_line = 1
    li   $t2, 1
    la   $t3, battle_line
    sw   $t2, 0($t3)

continue:
    # horizontal_line(22, battle_line * 5 + 19, 16, 196);

    la   $t3, battle_line
    lw   $t4, 0($t3)         # load battle_line
    sll $t5 $t4 2
    add $t4 $t5 $t4       # battle_line * 5
    li   $t5, 19
    add  $t4, $t4, $t5       # (battle_line * 5) + 19

    li   $a0, 22             # 1st argument
    move $a1, $t4            # 2nd argument
    li   $a2, 16             # 3rd argument
    li   $a3, 28            # 4th argument
    jal horizontal_line

    # Now, handle battle_line == 0 and battle_line == 1 separately
    la   $t3, battle_line
    lw   $t4, 0($t3)

    beq $t4, $0 battle_line_zero  # if battle_line == 0

    # battle_line == 1 case
battle_line_one:
    li   $a0, 22
    li   $a1, 19
    li   $a2, 16
    li   $a3, 27
    jal horizontal_line      
    j battle_line_end   # return

battle_line_zero:
    li   $a0, 22
    li   $a1, 24
    li   $a2, 16
    li   $a3, 27
    jal horizontal_line
    
battle_line_end:
    
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
