	.data

	.text
main:
		li   $a0,1
		li   $a1,4
		lui  $a2,141
		ori	 $a2,$a2,0
		
		li 	$t0,4286578687  #logic and mantissa with 11111111011.. to get rid off the extra 1 at 23rd bit
		and	$a2,$a2,$t0
		
		sll	$a0,$a0,31		#move sign at 31th bit and add to mantissa
		or	$a2,$a2,$a0
		
		addi $a1,$a1,127 	#put exponent+127 at 30:23 bits
		sll	 $a1,$a1,23
		or   $a2,$a2,$a1
		
		add  $a0,$zero,$a2
		li		$v0,1
		syscall
		
		jr 		$ra
	