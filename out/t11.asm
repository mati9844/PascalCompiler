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
	and.i	36,40,44	;and.i	$tmp0,$tmp1,$tmp2
	je.i	44, #0, #lbl5	;je.i	$tmp2, $0, $lbl5
	mov.r	#0.0, 12	;mov.r	$0.0, $x
	jump.i	#lbl6		;jump.i	$lbl6
lbl5:
	mov.r	#1.0, 12	;mov.r	$1.0, $x
lbl6:
	exit		;exit
