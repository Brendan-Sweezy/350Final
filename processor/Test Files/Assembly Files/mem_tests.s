nop
nop
nop
nop
addi $sp, $zero, 117
jal link
addi $1, $zero, 999
link:
sw $ra, 0($sp)
lw $2, 0($sp)
nop
nop
nop