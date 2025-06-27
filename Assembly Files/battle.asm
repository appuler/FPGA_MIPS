.text
.globl battle_screen

battle_screen:

		
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    #generate the two pokemon
 
   	jal rng
   	
   	la $t0 pokemon_list
    	lw $t1 0($t0) # t1: our pokemon
    	
	lw $t2 random_number
	andi $t2 $t2 3
	bne $t2 3 pbs
	addi $t2 $t2 -1
	
	pbs:
	sw $t2 opp_code
	
	addi $a0 $t1 0
	jal right_pokemon_charcode
	addi $a2 $v0 0
	
	li $a0 9
	li $a1 16
	jal generate_pokemon
	
	
	lw $a0 opp_code
	jal right_pokemon_charcode
	addi $a2 $v0 0
	li $a0 25
	li $a1 4
	jal generate_pokemon
	
		
	la $a0 double_hit
	ori $a1 $0 10
	ori $a2 $0 22
	ori $a3 $0 17
	jal text_generator
	
	la $a0 throw_pokeball
	ori $a1 $0 14
	ori $a2 $0 22
	ori $a3 $0 22
	jal text_generator
		
    
    
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    
    

    
final_battle_screen:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
	jal battle_screen
	addi $t0 $0 100
	sw $t0 opp_health
	sw $t0 our_health
	sw $0 cur_pokemon
	openb:
	# new_horizontal screen
	jal battle_under_line
	
	lw $t0 our_health
	lw $t1 opp_health
	
	sll $t0 $t0 16
	or $t0 $t0 $t1
	
	move $a0 $t0
	jal put_leds
	
	ori $a0, $0, 20
	ori $t9, $v0, 0 
	jal pause_and_getkey
	bne $v0 $0 battle_action
	j openb
	
battle_action:

    li $a0 227272
    jal put_sound
    li $a0 10
    jal pause
    jal sound_off

    # Load battle_line
    lw $t0, battle_line

    beqz $t0, battle_line_zero1  # if battle_line == 0, jump
    li  $t1, 1
    beq  $t0, $t1, battle_line_one1  # if battle_line == 1, jump

battle_line_zero1:
    # Call rng()
    jal rng
    lw  $t2, random_number     # t2 = random_number
    andi $t2, $t2, 0x1F         # r = random_number & 0x1F

    # Call rng() again
    jal rng
    lw  $t3, random_number     # t3 = random_number
    andi $t3, $t3, 0x1F         # s = random_number & 0x1F

    # opp_health -= r
    lw  $t4, opp_health
    sub $t4, $t4, $t2
    addi $t4, $t4, -16
    sw  $t4, opp_health

    # our_health -= s
    lw  $t5, our_health
    sub $t5, $t5, $t3
    sw  $t5, our_health

    # if (opp_health < 0)
    blt $t4, $0 opp_health_dead

    # if (our_health < 0)
    blt $t5, $0 our_health_dead

    j openb # go back to the battle

opp_health_dead:
    li $a0, 50
    jal pause
    j end_for_real

our_health_dead:
    lw $t6, cur_pokemon
    li $t7, 1
    beq $t6, $t7, end_for_real  # if cur_pokemon == 1, skip revive
    la $s5 pokemon_list
    lw $s6 4($s5)
    blt $s6 $0 end_for_real

    # cur_pokemon = 1
    sw $t7, cur_pokemon

    # our_health = 100
    li $t8, 100
    sw $t8, our_health

    # vertical_line(0, 15)
    li $a0, 0
    li $a1, 15
    jal vertical_line

    # generate_pokemon(9, 16, right_pokemon_charcode(pokemon_list[1]))
    li $t9, 4      # address offset for pokemon_list[1]
    la $t0, pokemon_list
    add $t0, $t0, $t9
    lw $t1, 0($t0)                 # load pokemon_list[1]
    move $a0, $t1
    jal right_pokemon_charcode     # result in $v0

    # pass args and call generate_pokemon(9, 16, result_of_previous)
    li $a0, 9
    li $a1, 16
    move $a2, $v0
    jal generate_pokemon

    la $a0 pokemon_fainted
    li $a1 15
    li $a2 5
    li $a3 5
    jal text_generator
    li $a0, 100
    jal pause
    
    li $a0 5
    li $a1 5
    li $a2 15
    li $a3 27
    jal horizontal_line
    
    j openb

battle_line_one1:
    # rng()
    jal rng
    lw  $t2, random_number
    andi $t2, $t2, 0x1F

    # our_health -= s
    lw  $t5, our_health
    sub $t5, $t5, $t2
    sw  $t5, our_health
    
    # if (opp_health < 40)
    lw  $t4, opp_health
    li  $t6, 40
    blt $t4, $t6, caught
    
    lw $t5 our_health
    blt $t5 $0 our_health_dead

    j openb

caught:
    # poke_list[1] = opp_code
    la $t7, pokemon_list
    li $t8, 4          # offset for poke_list[1]
    add $t7, $t7, $t8
    lw  $t9, opp_code
    sw  $t9, 0($t7)

    la $a0 pokemon_caught
    li $a1 14
    li $a2 5
    li $a3 5
    jal text_generator
    li $a0, 100
    jal pause

end_for_real:

	
addi $t0 $0 100
sw $t0 opp_health
addi $t0 $0 100
sw $t0 our_health
li $t1 0
sw $t1 cur_pokemon

    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    


#returns charcode based on pokemon_code
#a0: pokemon code
right_pokemon_charcode:
    addi    $sp, $sp, -8        # Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)         # Save $ra
    sw      $fp, 0($sp)         # Save $fp
    addi    $fp, $sp, 4         # Set $fp to the start of proc1's stack frame
    
    
    beq $a0 $0 zero_to_zero
    beq $a0 1 one_to_64
    beq $a0 2 two_to_128
    
    zero_to_zero:
    	li $v0 0
    	j final_rpcc
    	
    one_to_64:
    	li $v0 9
    	j final_rpcc
    	
    two_to_128:
    	li $v0 18
    	j final_rpcc
    
final_rpcc:  
    addi    $sp, $fp, 4     # Restore $sp
    lw      $ra, 0($fp)     # Restore $ra
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
    

    
