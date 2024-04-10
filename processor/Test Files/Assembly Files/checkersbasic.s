nop
nop
nop
nop
nop
addi $29, $0, 3800
j createBoard

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

malloc:
sub $29, $29, $2        #Add stack pointer by the a0 return v0
add $1, $0, $29 
jr $ra

mainLoop:
nop
nop
nop
j printBoard

printBoard:

add $4, $0, $1

add $19, $0, $0         #zero out registers
add $20, $0, $0         
add $21, $0, $0         
add $22, $0, $0         
add $23, $0, $0         
add $24, $0, $0
add $25, $0, $0                  

lw $25, 0($4)           #First row

sll $25, $25, 3
lw $10, 1($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 2($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 3($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 4($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 5($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 6($4)
add $25, $25, $10

sll $25, $25, 3
lw $10, 7($4)
add $25, $25, $10

j end

end:
nop
nop
nop
nop
nop
j end