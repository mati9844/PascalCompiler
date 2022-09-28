	jump.i	#main	;jump.i main
p:
	enter.i	#0		;enter.i	#0
	leave		;leave
	return		;return
f:
	enter.i	#0		;enter.i	#0
	mov.i	#10, *BP+8	;mov.i	$10, $f
	leave		;leave
	return		;return
main:
	call.i	#p	;call.i	&p
	push.i	#24	;push.i	&tmp0
	call.i	#f	;call.i	&f
	incsp.i	#4	;incsp.i	4
	mov.i	24, 0	;mov.i	$tmp0, $x
	exit		;exit
