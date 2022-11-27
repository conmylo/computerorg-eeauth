	.data

	.text
main:
		lui	$a0,3247243264
		add $t0,$zero,$a0
		add $t1,$zero,$a0
	
        srl	    $v0,$t0,31	#sign to $v0
        
        and	    $t0,$t0,2139095040 #exponent off -127 to $v1 
		srl	    $t0,$t0,23
		sub     $v1,$t0,127
		
		and $t1,$t1,8388607   #mantissa whith 1 at 23-bit to $a1
		or	$t1,$t1,8388608
		add $a1,$zero,$t1
		
		li  $v0,1
		syscall
	
		jr $ra