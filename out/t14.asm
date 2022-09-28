	jump.i	#main	;jump.i main
main:
lbl1:
	jl.i	0, 4, #lbl3	;jl.i	$i, $j, $lbl3
	mov.i	#0, 36	;mov.i	$0, $tmp0
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mov.i	#1, 36	;mov.i	$1, $tmp0
lbl4:
	je.i	36, #0, #lbl5	;je.i	$tmp0, $0, $lbl5
	mov.i	#0, 40	;mov.i	$0, $tmp1
	jump.i	#lbl6		;jump.i	$lbl6
lbl5:
	mov.i	#1, 40	;mov.i	$1, $tmp1
lbl6:
	jg.i	8, 4, #lbl7	;jg.i	$k, $j, $lbl7
	mov.i	#0, 44	;mov.i	$0, $tmp2
	jump.i	#lbl8		;jump.i	$lbl8
lbl7:
	mov.i	#1, 44	;mov.i	$1, $tmp2
lbl8:
	or.i	40,44,48	;or.i	$tmp1,$tmp2,$tmp3
	je.i	48, #0, #lbl2	;je.i	$tmp3, $0, $lbl2
	add.r	12,#1.35,52	;add.r	$x,$1.35,$tmp4
	mov.r	52, 12	;mov.r	$tmp4, $x
	jump.i	#lbl1		;jump.i	$lbl1
lbl2:
	exit		;exit
