nop
nop
nop
nop
nop
addi $29, $0, 3800
nop
nop
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
add $24, $0, $0                  

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

j end

end:
nop
nop
nop
nop
nop
j end