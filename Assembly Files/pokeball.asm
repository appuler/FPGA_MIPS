.text

.globl generate_pokeballs

generate_pokeballs:
		
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    # if (pokemon_list[0] >= 0)
    la   $t0, pokemon_list       # load address
    lw   $t1, 0($t0)             # load pokemon_list[0]
    blt $t1, $0 check_second       # if negative, skip

    li   $a0, 1                  # x = 1
    li   $a1, 6                  # y = 6
    jal  pokeball

check_second:
    # if (pokemon_list[1] >= 0)
    la   $t0, pokemon_list
    lw   $t1, 4($t0)             # load pokemon_list[1]
    blt $t1, $0 done_pokeballs               # if negative, skip

    li   $a0, 1                  # x = 1
    li   $a1, 16                 # y = 16
    jal  pokeball

done_pokeballs:


    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure




pokeball:

    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame

    move $s0, $a0               # save x into s0
    move $s1, $a1               # save y into s1

    li   $t0, 0                 # j = 0

pokeball_outer_loop:
    li   $t1, 0                 # k = 0 (inner loop)

pokeball_inner_loop:
    li   $t2, 55  
    sll $t3 $t0 1             # base 224
    add  $t3, $t0, $t3            # j * 2 + j = j * 3
    
    add  $t2, $t2, $t3          # 224 + j*3
    add  $t2, $t2, $t1          # 224 + j*3 + k

    add  $t4, $s0, $t1          # x + k
    add  $t5, $s1, $t0          # y + j

    move $a0, $t2               # putChar_atXY(char, x, y)
    move $a1, $t4
    move $a2, $t5
    jal  putChar_atXY

    addi $t1, $t1, 1            # k++
    li   $t6, 3
    blt  $t1, $t6, pokeball_inner_loop

    addi $t0, $t0, 1            # j++
    li   $t6, 3
    blt  $t0, $t6, pokeball_outer_loop
    
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
