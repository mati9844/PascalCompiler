	jump.i	#main	;jump.i main
main:
	jl.i	0, 4, #lbl1	;jl.i	$i, $j, $lbl1
	mov.i	#0, 36	;mov.i	$0, $tmp0
	jump.i	#lbl2		;jump.i	$lbl2
lbl1:
	mov.i	#1, 36	;mov.i	$1, $tmp0
lbl2:
	jl.i	4, 8, #lbl3	;jl.i	$j, $k, $lbl3
	mov.i	#0, 40	;mov.i	$0, $tmp1
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mov.i	#1, 40	;mov.i	$1, $tmp1
lbl4:
	jl.i	0, 8, #lbl5	;jl.i	$i, $k, $lbl5
	mov.i	#0, 44	;mov.i	$0, $tmp2
	jump.i	#lbl6		;jump.i	$lbl6
lbl5:
	mov.i	#1, 44	;mov.i	$1, $tmp2
lbl6:
	or.i	40,44,48	;or.i	$tmp1,$tmp2,$tmp3
	and.i	36,48,52	;and.i	$tmp0,$tmp3,$tmp4
	je.i	52, #0, #lbl7	;je.i	$tmp4, $0, $lbl7
	mov.r	#0.0, 12	;mov.r	$0.0, $x
	jump.i	#lbl8		;jump.i	$lbl8
lbl7:
	mov.r	#1.0, 12	;mov.r	$1.0, $x
lbl8:
	exit		;exit
