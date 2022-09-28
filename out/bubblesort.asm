	jump.i	#main	;jump.i main
czytajtab:
	enter.i	#20		;enter.i	#20
	mov.i	#1, BP-4	;mov.i	$1, $i
lbl1:
	jl.i	BP-4, #11, #lbl3	;jl.i	$i, $11, $lbl3
	mov.i	#0, BP-8	;mov.i	$0, $tmp0
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	mov.i	#1, BP-8	;mov.i	$1, $tmp0
lbl4:
	je.i	BP-8, #0, #lbl2	;je.i	$tmp0, $0, $lbl2
	sub.i	BP-4,#1,BP-12	;sub.i	$i,$1,$tmp1
	mul.i	BP-12, #4, BP-12	;mul.i	$tmp1, #4, $tmp1
	add.i	BP+8,BP-12,BP-16	;add.i	$a,$tmp1,$tmp2
	read.i	*BP-16	;read.i	$tmp2
	add.i	BP-4,#1,BP-20	;add.i	$i,$1,$tmp3
	mov.i	BP-20, BP-4	;mov.i	$tmp3, $i
	jump.i	#lbl1		;jump.i	$lbl1
lbl2:
	leave		;leave
	return		;return
bubblesort:
	enter.i	#100		;enter.i	#100
	mov.i	#1, BP-4	;mov.i	$1, $i
lbl5:
	jl.i	BP-4, #11, #lbl7	;jl.i	$i, $11, $lbl7
	mov.i	#0, BP-20	;mov.i	$0, $tmp4
	jump.i	#lbl8		;jump.i	$lbl8
lbl7:
	mov.i	#1, BP-20	;mov.i	$1, $tmp4
lbl8:
	je.i	BP-20, #0, #lbl6	;je.i	$tmp4, $0, $lbl6
	add.i	BP-4,#1,BP-24	;add.i	$i,$1,$tmp5
	mov.i	BP-24, BP-8	;mov.i	$tmp5, $j
lbl9:
	jl.i	BP-8, #11, #lbl11	;jl.i	$j, $11, $lbl11
	mov.i	#0, BP-28	;mov.i	$0, $tmp6
	jump.i	#lbl12		;jump.i	$lbl12
lbl11:
	mov.i	#1, BP-28	;mov.i	$1, $tmp6
lbl12:
	je.i	BP-28, #0, #lbl10	;je.i	$tmp6, $0, $lbl10
	sub.i	BP-4,#1,BP-32	;sub.i	$i,$1,$tmp7
	mul.i	BP-32, #4, BP-32	;mul.i	$tmp7, #4, $tmp7
	add.i	BP+8,BP-32,BP-36	;add.i	$a,$tmp7,$tmp8
	sub.i	BP-8,#1,BP-40	;sub.i	$j,$1,$tmp9
	mul.i	BP-40, #4, BP-40	;mul.i	$tmp9, #4, $tmp9
	add.i	BP+8,BP-40,BP-44	;add.i	$a,$tmp9,$tmp10
	jg.i	*BP-36, *BP-44, #lbl13	;jg.i	$tmp8, $tmp10, $lbl13
	mov.i	#0, BP-48	;mov.i	$0, $tmp11
	jump.i	#lbl14		;jump.i	$lbl14
lbl13:
	mov.i	#1, BP-48	;mov.i	$1, $tmp11
lbl14:
	je.i	BP-48, #0, #lbl15	;je.i	$tmp11, $0, $lbl15
	sub.i	BP-4,#1,BP-52	;sub.i	$i,$1,$tmp12
	mul.i	BP-52, #4, BP-52	;mul.i	$tmp12, #4, $tmp12
	add.i	BP+8,BP-52,BP-56	;add.i	$a,$tmp12,$tmp13
	inttoreal.i	*BP-56,BP-64	;inttoreal.i	$tmp13,$tmp14
	mov.r	BP-64, BP-16	;mov.r	$tmp14, $tmp
	sub.i	BP-4,#1,BP-68	;sub.i	$i,$1,$tmp15
	mul.i	BP-68, #4, BP-68	;mul.i	$tmp15, #4, $tmp15
	add.i	BP+8,BP-68,BP-72	;add.i	$a,$tmp15,$tmp16
	sub.i	BP-8,#1,BP-76	;sub.i	$j,$1,$tmp17
	mul.i	BP-76, #4, BP-76	;mul.i	$tmp17, #4, $tmp17
	add.i	BP+8,BP-76,BP-80	;add.i	$a,$tmp17,$tmp18
	mov.i	*BP-80, *BP-72	;mov.i	$tmp18, $tmp16
	sub.i	BP-8,#1,BP-84	;sub.i	$j,$1,$tmp19
	mul.i	BP-84, #4, BP-84	;mul.i	$tmp19, #4, $tmp19
	add.i	BP+8,BP-84,BP-88	;add.i	$a,$tmp19,$tmp20
	realtoint.r	BP-16,BP-92	;realtoint.r	$tmp,$tmp21
	mov.i	BP-92, *BP-88	;mov.i	$tmp21, $tmp20
	jump.i	#lbl16		;jump.i	$lbl16
lbl15:
lbl16:
	add.i	BP-8,#1,BP-96	;add.i	$j,$1,$tmp22
	mov.i	BP-96, BP-8	;mov.i	$tmp22, $j
	jump.i	#lbl9		;jump.i	$lbl9
lbl10:
	add.i	BP-4,#1,BP-100	;add.i	$i,$1,$tmp23
	mov.i	BP-100, BP-4	;mov.i	$tmp23, $i
	jump.i	#lbl5		;jump.i	$lbl5
lbl6:
	leave		;leave
	return		;return
wypisztab:
	enter.i	#20		;enter.i	#20
	mov.i	#1, BP-4	;mov.i	$1, $i
lbl17:
	jl.i	BP-4, #11, #lbl19	;jl.i	$i, $11, $lbl19
	mov.i	#0, BP-8	;mov.i	$0, $tmp24
	jump.i	#lbl20		;jump.i	$lbl20
lbl19:
	mov.i	#1, BP-8	;mov.i	$1, $tmp24
lbl20:
	je.i	BP-8, #0, #lbl18	;je.i	$tmp24, $0, $lbl18
	sub.i	BP-4,#1,BP-12	;sub.i	$i,$1,$tmp25
	mul.i	BP-12, #4, BP-12	;mul.i	$tmp25, #4, $tmp25
	add.i	BP+8,BP-12,BP-16	;add.i	$a,$tmp25,$tmp26
	write.i	*BP-16	;write.i	$tmp26
	add.i	BP-4,#1,BP-20	;add.i	$i,$1,$tmp27
	mov.i	BP-20, BP-4	;mov.i	$tmp27, $i
	jump.i	#lbl17		;jump.i	$lbl17
lbl18:
	leave		;leave
	return		;return
main:
	push.i	#12	;push.i	&p
	call.i	#czytajtab	;call.i	&czytajtab
	incsp.i	#4	;incsp.i	4
	push.i	#12	;push.i	&p
	call.i	#bubblesort	;call.i	&bubblesort
	incsp.i	#4	;incsp.i	4
	push.i	#12	;push.i	&p
	call.i	#wypisztab	;call.i	&wypisztab
	incsp.i	#4	;incsp.i	4
	exit		;exit
