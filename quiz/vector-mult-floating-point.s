		.data
n:		.word	4
x:
		.word 	1086849024
		.word	1075838976
		.word   1065353216
		.word 	1083179008
		
		.text
main:	
		la		$a0,x
		lw		$s0,0($a0)
		la		$t0,n
		lw		$a1,0($t0)
		
		jal		fprod
		
		move 	$a0,$v0
		li		$v0,1
		syscall
		
		li      $v0,10
		syscall
		
fprod:    		
		
		li		$t0,1 		#set counter i=1
LOOP:	
		slt		$t1,$t0,$a1
		beq		$t1,$0,EXIT
		
		sll		$t2,$t0,2
		add		$t3,$t2,$a0
		lw		$t4,0($t3)
		
		addi	$sp,$sp,-20
		sw		$ra,16($sp)
		sw		$a0,12($sp)
		sw		$a1,8($sp)
		sw		$t0,4($sp)
		
		move	$a0,$s0
		move 	$a1,$t4
		
		jal 	multFloat
		
		move 	$s0,$v0
		
		lw		$ra,16($sp)
		lw		$a0,12($sp)
		lw		$a1,8($sp)
		lw		$t0,4($sp)
		addi	$sp,$sp,16
		
		addi	$t0,$t0,1
		
		j		LOOP
		
EXIT:
		move	$v0,$s0
		
        jr      $ra	
		
		
multFloat:
        addi 	$sp, $sp, -8
		sw		$a1, 0($sp)
		sw 		$ra, 4($sp)
        
        jal     decodeFloat
		move	$t2,$v0
		move	$s0,$v1
		move	$s1,$s2
		
		lw      $a0,    0($sp)
		
		jal     decodeFloat
        
        xor     $a0,$v0,$t2
		
		add     $a1,$s0,$v1
        
        multu   $s2,$s1
	    mfhi    $a2
	    mflo    $t0
		
	    srl     $t3,$a2,15
		li		$t4,1
	    beq     $t3,$t4,normalize
		
		sll     $a2,$a2,9
		srl		$t5,$t0,22
		andi    $t5,    $t5,    1
		li      $t6,    1
		srl     $t0,    $t0,    23
		bne		$t5,$t6,go
		
		addi	$t0,1	    
go:
	    or      $a2,$a2,$t0 
	    
	    j       cont
		
normalize:
		sll     $a2,$a2,8
		srl		$t5,$t0,23
		andi	$t5,$t5,1
		srl     $t0,$t0,24
		li		$t6,1
		bne		$t5,$t6,go1
		addi	$t0,1	    
go1:
        or      $a2,$t0,$a2
        addi    $a1,$a1,1	    #αυξανω εκθετη αν ειναι 48bit
		
cont:   
        jal     encodeFloat
        
        move    $v0,    $a2
        
        lw 		$ra, 4($sp)
		addi	$sp,$sp,8
		
        jr      $ra             # return
        
decodeFloat:
		addi 	$sp, $sp, -8
		sw 		$ra, 4($sp)
		
		add 	$t0,$zero,$a0
		add 	$t1,$zero,$a0
	
        srl	    $v0,$t0,31	#sign to $v0
        
        and	    $t0,$t0,2139095040 #exponent off -127 to $v1 
		srl	    $t0,$t0,23
		sub     $v1,$t0,127
		
		and 	$t1,$t1,8388607   #mantissa whith 1 at 23-bit to $s2
		or		$t1,$t1,8388608
		add 	$s2,$zero,$t1
		
		lw 		$ra, 4($sp)
		addi	$sp,$sp,8
		
		jr		$ra
        
encodeFloat:
		addi 	$sp, $sp, -8
		sw 		$ra, 4($sp)
		
        li 	    $t0,4286578687  #logic and mantissa with 11111111011.. to get rid off the extra 1 at 23rd bit
		and	    $a2,$a2,$t0
		
		sll	    $a0,$a0,31		#move sign at 31th bit and add to mantissa
		or	    $a2,$a2,$a0
		
		addi    $a1,$a1,127 	#put exponent+127 at 30:23 bits
		sll	    $a1,$a1,23
		or      $a2,$a2,$a1
		
		lw 		$ra, 4($sp)
		addi	$sp,$sp,8
		
		jr      $ra
		
		