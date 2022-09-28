	jump.i	#main	;jump.i main
main:
lbl1:
	jl.i	0, 4, #lbl3	;jl.i	$i, $j, $lbl3
	mov.i	#0, 36	;mov.i	$0, $tmp0
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mov.i	#1, 36	;mov.i	$1, $tmp0
lbl4:
	je.i	36, #0, #lbl2	;je.i	$tmp0, $0, $lbl2
	add.r	12,#1.35,40	;add.r	$x,$1.35,$tmp1
	mov.r	40, 12	;mov.r	$tmp1, $x
	jump.i	#lbl1		;jump.i	$lbl1
lbl2:
	exit		;exit
