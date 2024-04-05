nop
nop
nop
nop
nop
addi $1, $0, 1
addi $2, $1, 1
add $3, $2, $1
mul $9, $3, $3
addi $10, $0, 10
div $5, $10, $2
addi $6, $0, 6
sw $6, 50($0)
nop
nop
nop
addi $6, $0, 1
nop
nop
nop
lw $6, 50($0)
bne $7, $0, end
nop
nop
addi $7, $0, 7
bne $7, $0, else
j end
else: 
addi $4, $0, 4
mul $8, $4, $2
nop
nop
nop
end:
nop
nop
nop
j end