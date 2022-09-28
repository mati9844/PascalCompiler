	jump.i	#main	;jump.i main
main:
	mul.i	#2,#3,36	;mul.i	$2,$3,$tmp0
	div.i	36,#4,40	;div.i	$tmp0,$4,$tmp1
	add.i	#1,40,44	;add.i	$1,$tmp1,$tmp2
	inttoreal.i	44,48	;inttoreal.i	$tmp2,$tmp3
	mov.r	48, 0	;mov.r	$tmp3, $x
	mul.i	#2,#3,56	;mul.i	$2,$3,$tmp4
	inttoreal.i	56,60	;inttoreal.i	$tmp4,$tmp5
	div.r	60,#4.0,68	;div.r	$tmp5,$4.0,$tmp6
	inttoreal.i	#1,76	;inttoreal.i	$1,$tmp7
	add.r	76,68,84	;add.r	$tmp7,$tmp6,$tmp8
	mov.r	84, 8	;mov.r	$tmp8, $y
	write.r	0	;write.r	$x
	write.r	8	;write.r	$y
	mov.i	#4, 24	;mov.i	$4, $i
	mov.i	#5, 28	;mov.i	$5, $j
	div.i	24,28,92	;div.i	$i,$j,$tmp9
	mul.i	28,24,96	;mul.i	$j,$i,$tmp10
	add.i	92,96,100	;add.i	$tmp9,$tmp10,$tmp11
	mod.i	28,24,104	;mod.i	$j,$i,$tmp12
	add.i	100,104,108	;add.i	$tmp11,$tmp12,$tmp13
	sub.i	28,24,112	;sub.i	$j,$i,$tmp14
	add.i	108,112,116	;add.i	$tmp13,$tmp14,$tmp15
	mov.i	116, 32	;mov.i	$tmp15, $k
	write.i	32	;write.i	$k
	jg.i	32, #10, #lbl1	;jg.i	$k, $10, $lbl1
	mov.i	#0, 120	;mov.i	$0, $tmp16
	jump.i	#lbl2		;jump.i	$lbl2
lbl1:
	mov.i	#1, 120	;mov.i	$1, $tmp16
lbl2:
	je.i	120, #0, #lbl3	;je.i	$tmp16, $0, $lbl3
	inttoreal.i	#10,124	;inttoreal.i	$10,$tmp17
	mov.r	124, 16	;mov.r	$tmp17, $z
	jump.i	#lbl4		;jump.i	$lbl4
lbl3:
	inttoreal.i	#5,132	;inttoreal.i	$5,$tmp18
	mov.r	132, 16	;mov.r	$tmp18, $z
lbl4:
	write.r	16	;write.r	$z
	mov.i	#0, 24	;mov.i	$0, $i
	mov.i	#1, 28	;mov.i	$1, $j
	mov.i	#3, 32	;mov.i	$3, $k
	and.i	28,32,140	;and.i	$j,$k,$tmp19
	or.i	24,140,144	;or.i	$i,$tmp19,$tmp20
	je.i	144, #0, #lbl5	;je.i	$tmp20, $0, $lbl5
	write.i	#1	;write.i	$1
	jump.i	#lbl6		;jump.i	$lbl6
lbl5:
	write.i	#0	;write.i	$0
lbl6:
lbl7:
	jl.i	24, 32, #lbl9	;jl.i	$i, $k, $lbl9
	mov.i	#0, 148	;mov.i	$0, $tmp21
	jump.i	#lbl10		;jump.i	$lbl10
lbl9:
	mov.i	#1, 148	;mov.i	$1, $tmp21
lbl10:
	je.i	148, #0, #lbl8	;je.i	$tmp21, $0, $lbl8
	write.i	24	;write.i	$i
	add.i	24,#1,152	;add.i	$i,$1,$tmp22
	mov.i	152, 24	;mov.i	$tmp22, $i
	jump.i	#lbl7		;jump.i	$lbl7
lbl8:
	inttoreal.i	#6,156	;inttoreal.i	$6,$tmp23
	mod.r	#5.0,156,164	;mod.r	$5.0,$tmp23,$tmp24
	mov.r	164, 0	;mov.r	$tmp24, $x
	write.r	0	;write.r	$x
	exit		;exit
