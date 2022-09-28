	jump.i	#main	;jump.i main
gcd:
	enter.i	#12		;enter.i	#12
	je.i	*BP+12, #0, #lbl1	;je.i	$b, $0, $lbl1
	mov.i	#0, BP-4	;mov.i	$0, $tmp0
	jump.i	#lbl2		;jump.i	$lbl2
lbl1:
	mov.i	#1, BP-4	;mov.i	$1, $tmp0
lbl2:
	je.i	BP-4, #0, #lbl3	;je.i	$tmp0, $0, $lbl3
	mov.i	*BP+16, *BP+8	;mov.i	$a, $gcd
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mod.i	*BP+16,*BP+12,BP-8	;mod.i	$a,$b,$tmp1
	push.i	BP+12	;push.i	&b
	push.i	#BP-8	;push.i	&tmp1
	push.i	#BP-12	;push.i	&tmp2
	call.i	#gcd	;call.i	&gcd
	incsp.i	#12	;incsp.i	12
	mov.i	BP-12, *BP+8	;mov.i	$tmp2, $gcd
lbl4:
	leave		;leave
	return		;return
main:
	read.i	0	;read.i	$x
	read.i	4	;read.i	$y
	push.i	#0	;push.i	&x
	push.i	#4	;push.i	&y
	push.i	#24	;push.i	&tmp3
	call.i	#gcd	;call.i	&gcd
	incsp.i	#12	;incsp.i	12
	write.i	24	;write.i	$tmp3
	exit		;exit
