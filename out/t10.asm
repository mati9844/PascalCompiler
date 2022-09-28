	jump.i	#main	;jump.i main
main:
	jl.i	0, 4, #lbl1	;jl.i	$i, $j, $lbl1
	mov.i	#0, 36	;mov.i	$0, $tmp0
	jump.i	#lbl2		;jump.i	$lbl2
lbl1:
	mov.i	#1, 36	;mov.i	$1, $tmp0
lbl2:
	je.i	36, #0, #lbl3	;je.i	$tmp0, $0, $lbl3
	mov.r	#0.0, 12	;mov.r	$0.0, $x
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mov.r	#1.0, 12	;mov.r	$1.0, $x
lbl4:
	exit		;exit
