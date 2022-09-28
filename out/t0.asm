	jump.i	#main	;jump.i main
main:
	add.i	0,4,24	;add.i	$x,$y,$tmp0
	inttoreal.i	24,28	;inttoreal.i	$tmp0,$tmp1
	mov.r	28, 8	;mov.r	$tmp1, $g
	write.r	8	;write.r	$g
	exit		;exit
