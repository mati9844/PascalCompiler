	jump.i	#main	;jump.i main
f:
	enter.i	#4		;enter.i	#4
	add.i	*BP+12,#10,BP-4	;add.i	$a,$10,$tmp0
	mov.i	BP-4, *BP+8	;mov.i	$tmp0, $f
	leave		;leave
	return		;return
main:
	exit		;exit
