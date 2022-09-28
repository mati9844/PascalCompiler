	jump.i	#main	;jump.i main
main:
	inttoreal.i	4,24	;inttoreal.i	$y,$tmp0
	mul.r	24,16,32	;mul.r	$tmp0,$h,$tmp1
	inttoreal.i	0,40	;inttoreal.i	$x,$tmp2
	add.r	40,32,48	;add.r	$tmp2,$tmp1,$tmp3
	mov.r	48, 8	;mov.r	$tmp3, $g
	write.r	8	;write.r	$g
	exit		;exit
