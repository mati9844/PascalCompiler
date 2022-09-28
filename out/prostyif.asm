	jump.i	#main	;jump.i main
main:
	mov.i	#2, 0	;mov.i	$2, $x
	jg.i	0, #3, #lbl1	;jg.i	$x, $3, $lbl1
	mov.i	#0, 4	;mov.i	$0, $tmp0
	jump.i	#lbl2		;jump.i	$lbl2
lbl1:
	mov.i	#1, 4	;mov.i	$1, $tmp0
lbl2:
	je.i	4, #0, #lbl3	;je.i	$tmp0, $0, $lbl3
	mov.i	#4, 0	;mov.i	$4, $x
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mov.i	#5, 0	;mov.i	$5, $x
lbl4:
	exit		;exit
