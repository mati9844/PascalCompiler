	jump.i	#main	;jump.i main
main:
	mov.i	#2, 0	;mov.i	$2, $x
lbl1:
	jl.i	0, #5, #lbl3	;jl.i	$x, $5, $lbl3
	mov.i	#0, 4	;mov.i	$0, $tmp0
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mov.i	#1, 4	;mov.i	$1, $tmp0
lbl4:
	je.i	4, #0, #lbl2	;je.i	$tmp0, $0, $lbl2
	add.i	0,#1,8	;add.i	$x,$1,$tmp1
	mov.i	8, 0	;mov.i	$tmp1, $x
	jump.i	#lbl1		;jump.i	$lbl1
lbl2:
	exit		;exit
