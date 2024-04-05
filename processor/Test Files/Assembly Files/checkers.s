#I do not plan on abiding by calling conventions, but I will name registers here:
#
#r1 = v0
#r2 = a0
#r4 = main board
#r29 = Heap Pointer
#r30 = Status Register
#r31 = Return Address
main:
nop
nop
nop
nop
nop
addi $29, $0, 3840
j createBoard

malloc:
sub $29, $29, $2        #Add stack pointer by the a0 return v0
add $1, $0, $29 
jr $ra

createBoard:
addi $2, $0, 64         #Malloc room for main board
jal malloc

                        #PIECES: 0-Nothing, 1-Black Piece, 2-Black King, -1-Red Piece, -2, Red King

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

addi $7, $0, -1         #Store all the starting black pieces

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
addi $7, $0, $0         #Reg 7 wait until ready button pressed
addi $8, $0, 1
rdyLoop1:
rdy $7                  #TODO IMPLEMENT THIS IN HARDWARE
blt $7, $8, rdyLoop1
swt $9, 0               #Store in $9-x, $10-y from switches
swt $10, 1              #TODO IMPLEMENT IN HARDWARE

addi $7, $0, $0         #Reg 7 wait until ready button pressed
addi $8, $0, 1
rdyLoop2:
rdy $7                  #TODO IMPLEMENT THIS IN HARDWARE
blt $7, $8, rdyLoop2
swt $11, 0              #Store in $11-x, $12-y from switches
swt $12, 1              #TODO IMPLEMENT IN HARDWARE

addi $7, $0, 8          #$9 becomes start location
mul $9, $9, $7
add $9, $9, $10

addi $7, $0, 8          #$10 becomes end location
mul $10, $11, $7
add $10, $10, $12

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

addi $13, $0, 2         #In this case promote to King
sw $13, 0($10)

not_black:

addi $13, $0, -1        #Jump past if not -1 in starting location, and not at row 7
#sub $13, $11, $13      #Same for this one
bne $13, $11, not_red
bne $12, $0, not_red

addi $13, $0, -2         #In this case promote to King
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
addi $14, $0, -7
bne $13, $14, delete_3

addi $13, $9, -7         #Set to 0 position up right
sw $0, 0($13) 

delete_3:

sub $13, $10, $9        #Skip ahead if not a jump up left
addi $14, $0, -9
bne $13, $14, delete_4

addi $13, $9, -9         #Set to 0 position up left
sw $0, 0($13) 

delete_4:

jr $ra




#TODO, implement deleting a piece if it was a jump


printBoard:
                        #NEED HARDWARE IMPLEMENTED FOR THIS

mainLoop:
add $4, $1, $0
jal                  #TODO IMPLEMENT HARDWARE TO PRINT TO VGA
jal playerMove
j mainLoop

