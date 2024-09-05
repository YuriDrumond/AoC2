.data 
    x: .space 4096      # Espaço para 1024 inteiros (4 bytes cada)
    N: .word 1024       # Tamanho do array

.text 
.globl main

main:
    la $s1, x
    la $s4, N
    lw $t2, 0($s4)
    li $t0, 0

init_array:
    beq $t0, $t2, init_done
    mul $t1, $t0, 4
    add $t3, $s1, $t1
    sw $t0, 0($t3)
    addi $t0, $t0, 1
    j init_array

init_done:
    la $a0, x
    li $a1, 0
    lw $a2, 0($s4)
    addi $a2, $a2, -1
    jal quicksort

    li $v0, 10
    syscall

quicksort:                        
    addi $sp, $sp, -16
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $ra, 12($sp)

    move $t0, $a2

    slt $t1, $a1, $t0
    beq $t1, $zero, endif

    jal partition
    move $s0, $v0

    lw $a1, 4($sp)
    addi $a2, $s0, -1
    jal quicksort

    addi $a1, $s0, 1
    lw $a2, 8($sp)
    jal quicksort

endif:
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

partition: 						
    addi $sp, $sp, -16
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $ra, 12($sp)

    move $s1, $a1
    move $s2, $a2

    sll $t1, $s2, 2
    add $t1, $a0, $t1
    lw $t2, 0($t1)

    addi $t3, $s1, -1
    move $t4, $s1
    addi $t5, $s2, -1

forloop: 
    slt $t6, $t5, $t4
    bne $t6, $zero, endfor

    sll $t1, $t4, 2
    add $t1, $t1, $a0
    lw $t7, 0($t1)

    slt $t8, $t2, $t7
    bne $t8, $zero, endfif

    addi $t3, $t3, 1
    move $a1, $t3
    move $a2, $t4
    jal swap

endfif:
    addi $t4, $t4, 1
    j forloop

endfor:
    addi $a1, $t3, 1
    move $a2, $s2
    add $v0, $zero, $a1
    jal swap

    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# Swap method
swap:
    sll $t0, $a1, 2
    add $t0, $a0, $t0

    sll $t1, $a2, 2
    add $t1, $a0, $t1

    lw $t2, 0($t0)
    lw $t3, 0($t1)

    sw $t2, 0($t1)
    sw $t3, 0($t0)

    jr $ra
