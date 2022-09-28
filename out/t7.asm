	jump.i	#main	;jump.i main
f:
	enter.i	#4		;enter.i	#4
	add.i	*BP+16,#10,BP-4	;add.i	$a,$10,$tmp0
	mov.i	BP-4, *BP+8	;mov.i	$tmp0, $f
	leave		;leave
	return		;return
main:
	realtoint.r	8,24	;realtoint.r	$g,$tmp1
	push.i	#24	;push.i	&tmp1
	inttoreal.i	0,28	;inttoreal.i	$x,$tmp2
	push.i	#28	;push.i	&tmp2
	push.i	#36	;push.i	&tmp3
	call.i	#f	;call.i	&f
	incsp.i	#12	;incsp.i	12
	mov.i	36, 0	;mov.i	$tmp3, $x
	exit		;exit
