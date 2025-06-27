.data 0x10010000
	main_x: .word 0
	main_y: .word 0
	dir: .word 0
	old_code: .word 0
	random_number: .word 0xACDE
	rng_x:.word 39
	rng_y:.word 39
	opp_code: .word 0
	battle_line: .word 0
	pokemon_list: .word 0, -1, -1, -1, -1, -1
	opp_health: .word 100
	our_health: .word 100
	cur_pokemon: .word 0
	double_hit: .word 32, 43, 49, 30, 40, 33, 27, 36, 37, 48
        throw_pokeball: .word 48, 36, 46, 43, 51, 27, 44, 43, 39, 33, 30, 29, 40, 40
        pick_your_starter: .word 44, 37, 31, 39, 27, 53, 43, 49, 46, 27, 47, 48, 29, 46, 48, 33, 46
        pokemon_fainted: .word 44, 43, 39, 33, 41, 43, 42, 27, 34, 29, 37, 42, 48, 33, 32
        pokemon_caught: .word 44, 43, 39, 33, 41, 43, 42, 27, 31, 29, 49, 35, 36, 48


.text 0x00400000
.globl main

main:
	lui $sp, 0x1001
	ori $sp, $sp, 0x1000
	
	addi $fp, $sp, -4
	

	# Init Screen
	jal clear_screen
	la $a0 pick_your_starter
	li $a1 17
	li $a2 12
	li $a3 3
	jal text_generator
	jal final_opening_screen # This is working as intended
	
	
	main_rpg:
	jal clear_screen # causing errors for no reason (some memory mapping issue at 1001FF60)
 	jal final_rpg # this is finally working
	
	jal clear_screen
	
	jal generate_pokeballs
	li $a0 0
	li $a1 5
	jal vertical_line
	#slider sort of working yipee
	jal final_battle_screen
	j main_rpg
	


end:
	
.include "procs_board.asm"
.include "generating_pokemon.asm"
.include "lines.asm"
.include "opening_screen.asm"
.include "rng.asm"
.include "battle.asm"
.include "text_generating.asm"
.include "rpg.asm"
.include "battle_code_line.asm"
.include "move2.asm"
.include "clear.asm"
.include "pokeball.asm"
