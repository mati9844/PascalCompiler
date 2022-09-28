	jump.i	#main	;jump.i main
f:
	enter.i	#4		;enter.i	#4
	add.i	*BP+12,#10,BP-4	;add.i	$a,$10,$tmp0
	mov.i	BP-4, *BP+8	;mov.i	$tmp0, $f
	leave		;leave
	return		;return
main:
	mov.i	#3, 24	;mov.i	$3, $tmp1
	push.i	#24	;push.i	&tmp1
	push.i	#28	;push.i	&tmp2
	call.i	#f	;call.i	&f
	incsp.i	#8	;incsp.i	8
	mov.i	28, 0	;mov.i	$tmp2, $x
	exit		;exit
