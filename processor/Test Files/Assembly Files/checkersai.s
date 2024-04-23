#I do not plan on abiding by calling conventions, but I will name registers here:
#
#r1 = v0
#r2 = a0
#r4 = main board

#r19-25 game state
#r26, 27 switch inputs
#r28 - ready input
#r29 = Heap Pointer
#r30 = Status Register
#r31 = Return Address
main:
nop
nop
nop
nop
nop
addi $29, $0, 3800
j createBoard

switch1:                #Translate switch 1 reg to log2(switch1reg)

addi $15, $0, 1
bne $26, $15, j_0
addi $1, $0, 0
jr $ra
j_0:

addi $15, $0, 2
bne $26, $15, j_1
addi $1, $0, 1
jr $ra
j_1:

addi $15, $0, 4
bne $26, $15, j_2
addi $1, $0, 2
jr $ra
j_2:

addi $15, $0, 8
bne $26, $15, j_3
addi $1, $0, 3
jr $ra
j_3:

addi $15, $0, 16
bne $26, $15, j_4
addi $1, $0, 4
jr $ra
j_4:

addi $15, $0, 32
bne $26, $15, j_5
addi $1, $0, 5
jr $ra
j_5:

addi $15, $0, 64
bne $26, $15, j_6
addi $1, $0, 6
jr $ra
j_6:

addi $15, $0, 128
bne $26, $15, j_7
addi $1, $0, 7
jr $ra
j_7:

add $1, $0, $0
jr $ra

switch2:                        #Translate switch 2 reg to log2(switch2reg)

addi $15, $0, 1
bne $27, $15, j_01
addi $1, $0, 0
jr $ra
j_01:

addi $15, $0, 2
bne $27, $15, j_11
addi $1, $0, 1
jr $ra
j_11:

addi $15, $0, 4
bne $27, $15, j_21
addi $1, $0, 2
jr $ra
j_21:

addi $15, $0, 8
bne $27, $15, j_31
addi $1, $0, 3
jr $ra
j_31:

addi $15, $0, 16
bne $27, $15, j_41
addi $1, $0, 4
jr $ra
j_41:

addi $15, $0, 32
bne $27, $15, j_51
addi $1, $0, 5
jr $ra
j_51:

addi $15, $0, 64
bne $27, $15, j_61
addi $1, $0, 6
jr $ra
j_61:

addi $15, $0, 128
bne $27, $15, j_71
addi $1, $0, 7
jr $ra
j_71:

add $1, $0, $0
jr $ra

malloc:
sub $29, $29, $2        #Add stack pointer by the a0 return v0
add $1, $0, $29 
jr $ra

createBoard:
addi $2, $0, 64         #Malloc room for main board
jal malloc

                        #PIECES 0-Nothing 1-Black Piece 2-Black King -1-Red Piece -2 Red King

addi $7, $0, 1          #Store all the starting black pieces

sw $7, 0($1)
sw $7, 2($1)
sw $7, 4($1)
sw $7, 6($1)

sw $7, 9($1)
sw $7, 11($1)
sw $7, 13($1)
sw $7, 15($1)

sw $7, 16($1)
sw $7, 18($1)
sw $7, 20($1)
sw $7, 22($1)

addi $7, $0, 2         #Store all the starting black pieces

sw $7, 63($1)
sw $7, 61($1)
sw $7, 59($1)
sw $7, 57($1)

sw $7, 54($1)
sw $7, 52($1)
sw $7, 50($1)
sw $7, 48($1)

sw $7, 47($1)
sw $7, 45($1)
sw $7, 43($1)
sw $7, 41($1)

j mainLoop

playerMove:
sw $ra, 3840($0)

#addi $7, $0, $0         #Reg 7 wait until ready button pressed
#addi $8, $0, 1
rdyLoop1:
addi $7, $0, 1                 
bne $7, $28, rdyLoop1

waitLoop1:
addi, $7, $0, 0
bne $7, $28, waitLoop1

addi $18, $0, 1

jal switch1
add $9, $1, $0
jal switch2
add $10, $1, $0          #Store in $9-x, $10-y from switches

jal sleep

#addi $7, $0, $0         #Reg 7 wait until ready button pressed
#addi $8, $0, 1
rdyLoop2:
addi $7, $0, 1                 
bne $7, $28, rdyLoop2

waitLoop2:
addi, $7, $0, 0
bne $7, $28, waitLoop2

addi $18, $0, 0

jal switch1
nop
add $11, $1, $0
add $17, $11, $0
nop
jal switch2
nop
add $12, $1, $0          #Store in $11-x, $12-y from switches


addi $7, $0, 8          #$9 becomes start location
mul $10, $10, $7
add $9, $9, $10
#add $17, $9, $0

addi $7, $0, 8          #$10 becomes end location
mul $10, $12, $7
add $10, $10, $11



add $9, $4, $9          #$11 becomes piece in start location
lw $11, 0($9)

sw $0, 0($9)            #start = empty, end = start piece
add $10, $10, $4
sw $11, 0($10)

addi $13, $0, 1         #Jump past if not 1 in starting location, and not at row 7
#sub $13, $11, $13      #Don't know why this line was here initially
bne $13, $11, not_black
addi $13, $0, 7
blt $12, $13, not_black

addi $13, $0, 7         #In this case promote to King
sw $13, 0($10)

not_black:

addi $13, $0, 2        #Jump past if not -1 in starting location, and not at row 7
#sub $13, $11, $13      #Same for this one
bne $13, $11, not_red
bne $12, $0, not_red

addi $13, $0, 4         #In this case promote to King
sw $13, 0($10)

not_red:

sub $13, $10, $9        #Skip ahead if not a jump down left
addi $14, $0, 14
bne $13, $14, delete_1

addi $13, $9, 7         #Set to 0 position down left
sw $0, 0($13) 

delete_1:


sub $13, $10, $9        #Skip ahead if not a jump down right
addi $14, $0, 18
bne $13, $14, delete_2

addi $13, $9, 9         #Set to 0 position down right
sw $0, 0($13) 

delete_2:


sub $13, $10, $9        #Skip ahead if not a jump up right
addi $14, $0, -14
bne $13, $14, delete_3

addi $13, $9, -7         #Set to 0 position up right
sw $0, 0($13) 

delete_3:

sub $13, $10, $9        #Skip ahead if not a jump up left
addi $14, $0, -18
bne $13, $14, delete_4

addi $13, $9, -9         #Set to 0 position up left
sw $0, 0($13) 

delete_4:

lw $ra, 3840($0)
jr $ra




printBoard:

add $19, $0, $0         #zero out registers
add $20, $0, $0         
add $21, $0, $0         
add $22, $0, $0         
add $23, $0, $0         
add $24, $0, $0
add $25, $0, $0                  

lw $19, 0($4)           #First row

sll $19, $19, 3
lw $10, 1($4)
add $19, $19, $10

sll $19, $19, 3
lw $10, 2($4)
add $19, $19, $10

sll $19, $19, 3
lw $10, 3($4)
add $19, $19, $10

sll $19, $19, 3
lw $10, 4($4)
add $19, $19, $10

sll $19, $19, 3
lw $10, 5($4)
add $19, $19, $10

sll $19, $19, 3
lw $10, 6($4)
add $19, $19, $10

sll $19, $19, 3
lw $10, 7($4)
add $19, $19, $10



sll $19, $19, 3         #Second row
lw $10, 8($4)
add $19, $19, $10

sll $19, $19, 3
lw $10, 9($4)
add $19, $19, $10

lw $20, 10($4)           #Switch to reg 20

sll $20, $20, 3
lw $10, 11($4)
add $20, $20, $10

sll $20, $20, 3
lw $10, 12($4)
add $20, $20, $10

sll $20, $20, 3
lw $10, 13($4)
add $20, $20, $10

sll $20, $20, 3
lw $10, 14($4)
add $20, $20, $10

sll $20, $20, 3
lw $10, 15($4)
add $20, $20, $10



sll $20, $20, 3         $Row 3
lw $10, 16($4)
add $20, $20, $10

sll $20, $20, 3
lw $10, 17($4)
add $20, $20, $10

sll $20, $20, 3
lw $10, 18($4)
add $20, $20, $10

sll $20, $20, 3
lw $10, 19($4)
add $20, $20, $10

lw $21, 20($4)         #Switch to reg 21

sll $21, $21, 3
lw $10, 21($4)
add $21, $21, $10

sll $21, $21, 3
lw $10, 22($4)
add $21, $21, $10

sll $21, $21, 3
lw $10, 23($4)
add $21, $21, $10



sll $21, $21, 3        #Row 4
lw $10, 24($4)
add $21, $21, $10

sll $21, $21, 3
lw $10, 25($4)
add $21, $21, $10

sll $21, $21, 3
lw $10, 26($4)
add $21, $21, $10

sll $21, $21, 3
lw $10, 27($4)
add $21, $21, $10

sll $21, $21, 3
lw $10, 28($4)
add $21, $21, $10

sll $21, $21, 3
lw $10, 29($4)
add $21, $21, $10

lw $22, 30($4)          #Switch to reg 22

sll $22, $22, 3
lw $10, 31($4)
add $22, $22, $10



sll $22, $22, 3         $Row 5
lw $10, 32($4)
add $22, $22, $10

sll $22, $22, 3
lw $10, 33($4)
add $22, $22, $10

sll $22, $22, 3
lw $10, 34($4)
add $22, $22, $10

sll $22, $22, 3
lw $10, 35($4)
add $22, $22, $10

sll $22, $22, 3
lw $10, 36($4)
add $22, $22, $10

sll $22, $22, 3
lw $10, 37($4)
add $22, $22, $10

sll $22, $22, 3
lw $10, 38($4)
add $22, $22, $10

sll $22, $22, 3
lw $10, 39($4)
add $22, $22, $10



lw $23, 40($4)              #Row 6 and switch to reg 23

sll $23, $23, 3
lw $10, 41($4)
add $23, $23, $10

sll $23, $23, 3
lw $10, 42($4)
add $23, $23, $10

sll $23, $23, 3
lw $10, 43($4)
add $23, $23, $10

sll $23, $23, 3
lw $10, 44($4)
add $23, $23, $10

sll $23, $23, 3
lw $10, 45($4)
add $23, $23, $10

sll $23, $23, 3
lw $10, 46($4)
add $23, $23, $10

sll $23, $23, 3
lw $10, 47($4)
add $23, $23, $10



sll $23, $23, 3             #Row 7 
lw $10, 48($4)
add $23, $23, $10

sll $23, $23, 3
lw $10, 49($4)
add $23, $23, $10

lw $24, 50($4)              #Switch to reg 24

sll $24, $24, 3
lw $10, 51($4)
add $24, $24, $10

sll $24, $24, 3
lw $10, 52($4)
add $24, $24, $10

sll $24, $24, 3
lw $10, 53($4)
add $24, $24, $10

sll $24, $24, 3
lw $10, 54($4)
add $24, $24, $10

sll $24, $24, 3
lw $10, 55($4)
add $24, $24, $10



sll $24, $24, 3             #Row 8
lw $10, 56($4)
add $24, $24, $10

sll $24, $24, 3
lw $10, 57($4)
add $24, $24, $10

sll $24, $24, 3
lw $10, 58($4)
add $24, $24, $10

sll $24, $24, 3
lw $10, 59($4)
add $24, $24, $10

lw $25, 60($4)              #Switch to reg 25

sll $25, $25, 3
lw $10, 61($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 62($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 63($4)
add $25, $25, $10

jr $ra





                        #NEED HARDWARE IMPLEMENTED FOR THIS

mainLoop:
nop
nop
nop
add $4, $1, $0
mainLoop2:
nop
jal printBoard                 #TODO IMPLEMENT HARDWARE TO PRINT TO VGA
nop
jal playerMove
nop
jal sleep
nop
jal printBoard
nop
jal aiMove
nop
j mainLoop2




end:
nop
nop
nop
nop
j end



sleep:
add $3, $0, $0
addi $16, $0, 10000000
sleep_j:
addi $3, $3, 1
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
bne $3, $16, sleep_j
jr $ra



aiMove:

add $9, $0, $0          #9 = i
addi $10, $0, 63

addi $15, $0, -1         #15 = max score

loopEval:

blt $10, $9, escapeLoop     #while i < 64

add $11, $9, $4     #11 - i + board
addi $12, $0, 1     #CHECK THIS THIS IS ONLY IF 1 is BLACK PIECE

lw $13, 0($11)
bne $12, $13, aiCheck1      #If it is a black piece

j is_my_piece

aiCheck1:

addi $12, $0, 7     #CHECK THIS THIS IS ONLY IF 4 is BLACK KING

bne $12, $13, aiCheck2          #If it is a black king
j is_my_king

aiCheck2:
j end_loop_ai

is_my_king:

#KING LOGIC


addi $12, $0, 1                 #If we have found a jump, go ahead and stop the loop and do that move
bne $15, $12, not_jump_found_k
addi $9, $0, 64
j loopEval
not_jump_found_k:

addi $5, $0, 8
div $6, $9, $5          #6 = y
mul $7, $5, $6 
sub $5, $9, $7          #5 = x

addi $8, $0, 1
blt $5, $8, cant_down_left_k

blt $6, $8 cant_up_left_k

lw $7, -9($11)
bne $0, $7, cant_up_left_k  
addi $15, $0, 0         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, -9        #17 = best end pos
cant_up_left_k:

addi $8, $0, 6
blt $8, $6, cant_down_left_k

lw $7, 7($11)
bne $0, $7, cant_down_left_k  
addi $15, $0, 0         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 7        #17 = best end pos
cant_down_left_k:

addi $8, $0, 6
blt $8, $5, cant_down_right_k

addi $8, $0, 1
blt $6, $8, cant_up_right_k

lw $7, -7($11)
bne $0, $7, cant_up_right_k 
addi $15, $0, 0         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, -7        #17 = best end pos
cant_up_right_k:

addi $8, $0, 6
blt $8, $6, cant_down_right_k

lw $7, 9($11)
bne $0, $7, cant_down_right_k 
addi $15, $0, 0         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 9        #17 = best end pos
cant_down_right_k:

addi $8, $0, 2
blt $6, $8, cant_jump_up_k

blt $5, $8, cant_jump_up_left_k

lw $7, -18($11)          
lw $8, -9($11)
bne $7, $0, cant_jump_up_left_k
addi $7, $0, 2                          #NEED TO CHECK KING NUMS
bne $7, $8, jul_not_red_k
j jul_correct_k
jul_not_red_k:
addi $7, $0, 4
bne $7, $8, cant_jump_up_left_k
jul_correct_k:
addi $15, $0, 1         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, -18        #17 = best end pos
cant_jump_up_left_k:

addi $8, $0, 5
blt $8, $5, cant_jump_up_right_k

lw $7, -14($11)          
lw $8, -7($11)
bne $7, $0, cant_jump_up_right_k
addi $7, $0, 2                          #NEED TO CHECK KING NUMS
bne $7, $8, jur_not_red_k
j jur_correct_k
jur_not_red_k:
addi $7, $0, 4
bne $7, $8, cant_jump_up_right_k
jur_correct_k:
addi $15, $0, 1         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, -14        #17 = best end pos
cant_jump_up_right_k:

cant_jump_up_k:

addi $8, $0, 5
blt $8, $6, end_loop_ai

addi $8, $0, 2
blt $6, $8, cant_jump_down_left_k

lw $7, 14($11)          
lw $8, 7($11)
bne $7, $0, cant_jump_down_left_k
addi $7, $0, 2                          #NEED TO CHECK KING NUMS
bne $7, $8, jdl_not_red_k
j jdl_correct_k
jdl_not_red_k:
addi $7, $0, 4
bne $7, $8, cant_jump_down_left_k
jdl_correct_k:
addi $15, $0, 1         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 14        #17 = best end pos
cant_jump_down_left_k:

addi $8, $0, 5
blt $8, $5, cant_jump_down_right_k

lw $7, 18($11)          
lw $8, 9($11)
bne $7, $0, cant_jump_down_right_k
addi $7, $0, 2                          #NEED TO CHECK KING NUMS
bne $7, $8, jdr_not_red_k
j jdr_correct_k
jdr_not_red_k:
addi $7, $0, 4
bne $7, $8, cant_jump_down_right_k
jdr_correct_k:
addi $15, $0, 1         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 18        #17 = best end pos
cant_jump_down_right_k:


j end_loop_ai

is_my_piece:

addi $12, $0, 1                 #If we have found a jump, go ahead and stop the loop and do that move
bne $15, $12, not_jump_found
addi $9, $0, 64
j loopEval
not_jump_found:

addi $5, $0, 8
div $6, $9, $5          #6 = y
mul $7, $5, $6 
sub $5, $9, $7          #5 = x

addi $8, $0, 1
blt $5, $8, cant_down_left

lw $7, 7($11)
bne $0, $7, cant_down_left  
addi $15, $0, 0         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 7        #17 = best end pos
cant_down_left:

addi $8, $0, 6
blt $8, $5, cant_down_right

lw $7, 9($11)
bne $0, $7, cant_down_right  
addi $15, $0, 0         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 9        #17 = best end pos
cant_down_right:

addi $8, $0, 5
blt $8, $6, end_loop_ai

addi $8, $0, 2
blt $6, $8, cant_jump_down_left

lw $7, 14($11)          
lw $8, 7($11)
bne $7, $0, cant_jump_down_left
addi $7, $0, 2                          #NEED TO CHECK KING NUMS
bne $7, $8, jdl_not_red
j jdl_correct
jdl_not_red:
addi $7, $0, 4
bne $7, $8, cant_jump_down_left
jdl_correct:
addi $15, $0, 1         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 14        #17 = best end pos
cant_jump_down_left:

addi $8, $0, 5
blt $8, $5, cant_jump_down_right

lw $7, 18($11)          
lw $8, 9($11)
bne $7, $0, cant_jump_down_right
addi $7, $0, 2                          #NEED TO CHECK KING NUMS
bne $7, $8, jdr_not_red
j jdr_correct
jdr_not_red:
addi $7, $0, 4
bne $7, $8, cant_jump_down_right
jdr_correct:
addi $15, $0, 1         #best score = 0
add $16, $0, $11        #16 = best start pos
addi $17, $11, 18        #17 = best end pos
cant_jump_down_right:


end_loop_ai:
addi $9, $9, 1
j loopEval

escapeLoop:

lw $9, 0($16)
sw $0, 0($16)
sw $9, 0($17)

addi $13, $0, 10                        #Delete middle piece
sub $12, $16, $17
blt $12, $13, not_forward_jump       #different when doing backwards
j is_a_jump
not_forward_jump:
addi $13, $0, -10
blt $13, $12, not_jump_so_skip
is_a_jump:
addi $11, $0, 2
add $10 $17, $16
div $10, $10, $11
sw $0, 0($10)
not_jump_so_skip:

addi $10, $0, 8                 #If at end promote to king
sub $7, $17, $4
div $10, $7, $10
addi $11, $0, 7
bne $10, $11, no_promotion
addi $10, $0, 7
sw $10, 0($17)
no_promotion:

jr $ra