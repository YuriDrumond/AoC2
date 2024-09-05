.data
    x: .space 4096        # Espaço para 1024 inteiros (4 * 1024 = 4096 bytes)
    N: .word 1024         # Tamanho do array

.text
.globl main

main:
    # Inicializa o array 
    la   $s1, x           
    li   $t0, 0           
    li   $t1, 1024        

init_loop:
    bge  $t0, $t1, init_done  
    
    sw   $t0, 0($s1)     

    addi $t0, $t0, 1     
    addi $s1, $s1, 4     
    j    init_loop       

init_done:
	
    la $s1, x
    la   $a0, x
    la   $a1, N
    lw   $a1, 0($a1)
    li   $a2, 0           
    jal  selection_sort

    li   $v0, 10 
    syscall


selection_sort:
    addi    $sp, $sp, -20
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    sw      $s1, 8($sp)
    sw      $s2, 12($sp)
    sw      $s3, 16($sp)

    move    $s0, $a0
    move    $s1, $zero
    subi    $s2, $a1, 1

isort_for:
    bge     $s1, $s2, isort_exit   
    
    move    $a0, $s0
    move    $a1, $s1
    move    $a2, $s2
    jal     mini
    move    $s3, $v0  

    move    $a0, $s0
    move    $a1, $s1
    move    $a2, $s3
    jal     swap

    addi    $s1, $s1, 1
    j       isort_for

isort_exit:
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    lw      $s3, 16($sp)
    addi    $sp, $sp, 20
    jr      $ra

mini:
    move    $t0, $a0
    move    $t1, $a1
    move    $t2, $a2
    
    sll     $t3, $t1, 2
    add     $t3, $t3, $t0
    lw      $t4, 0($t3)
    
    addi    $t5, $t1, 1
mini_for:
    bgt     $t5, $t2, mini_end   
    
    sll     $t6, $t5, 2
    add     $t6, $t6, $t0
    lw      $t7, 0($t6)

    bge     $t7, $t4, mini_if_exit
    
    move    $t1, $t5
    move    $t4, $t7

mini_if_exit:
    addi    $t5, $t5, 1
    j       mini_for

mini_end:
    move    $v0, $t1
    jr      $ra


swap:
    sll     $t1, $a1, 2
    add     $t1, $a0, $t1
    
    sll     $t2, $a2, 2
    add     $t2, $t2, $a0

    lw      $t0, 0($t1)
    lw      $t3, 0($t2)

    sw      $t3, 0($t1)
    sw      $t0, 0($t2)

    jr      $ra
