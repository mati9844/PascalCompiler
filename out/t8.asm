	jump.i	#main	;jump.i main
f:
	enter.i	#28		;enter.i	#28
	mov.i	#4, BP-4	;mov.i	$4, $q
	add.r	*BP+16,*BP+12,BP-12	;add.r	$a,$b,$tmp0
	inttoreal.i	BP-4,BP-20	;inttoreal.i	$q,$tmp1
	add.r	BP-12,BP-20,BP-28	;add.r	$tmp0,$tmp1,$tmp2
	mov.r	BP-28, *BP+8	;mov.r	$tmp2, $f
	leave		;leave
	return		;return
main:
	mov.r	#3.25, 8	;mov.r	$3.25, $g
	push.i	#8	;push.i	&g
	mov.r	#10.28, 24	;mov.r	$10.28, $tmp3
	push.i	#24	;push.i	&tmp3
	push.i	#32	;push.i	&tmp4
	call.i	#f	;call.i	&f
	incsp.i	#12	;incsp.i	12
	write.r	32	;write.r	$tmp4
	exit		;exit
