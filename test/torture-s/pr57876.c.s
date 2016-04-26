	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body4.1
	i32.const	$push157=, __stack_pointer
	i32.load	$push158=, 0($pop157)
	i32.const	$push159=, 16
	i32.sub 	$12=, $pop158, $pop159
	i32.const	$push160=, __stack_pointer
	i32.store	$discard=, 0($pop160), $12
	i32.const	$push0=, 0
	i32.load	$0=, d($pop0)
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.store	$2=, f($pop156), $pop155
	i32.const	$push154=, 0
	i64.load32_s	$1=, b($pop154)
	i32.load	$push153=, a($2)
	tee_local	$push152=, $11=, $pop153
	i32.load	$push1=, 0($0)
	i32.store	$push2=, j($2), $pop1
	i32.mul 	$push3=, $pop152, $pop2
	i32.const	$push4=, -1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	$push6=, h($2), $pop5
	i32.eqz 	$push7=, $pop6
	i64.extend_u/i32	$push8=, $pop7
	i64.lt_s	$push9=, $pop8, $1
	i32.store	$discard=, e($2), $pop9
	i32.const	$push10=, 1
	i32.store	$3=, f($2), $pop10
	i32.load	$push11=, 0($0)
	i32.store	$push12=, j($2), $pop11
	i32.mul 	$push13=, $11, $pop12
	i32.const	$push151=, -1
	i32.add 	$push14=, $pop13, $pop151
	i32.store	$push15=, h($2), $pop14
	i32.eqz 	$push16=, $pop15
	i64.extend_u/i32	$push17=, $pop16
	i64.lt_s	$push18=, $pop17, $1
	i32.store	$discard=, e($2), $pop18
	i32.const	$push19=, 2
	i32.store	$4=, f($2), $pop19
	i32.load	$push20=, 0($0)
	i32.store	$push21=, j($2), $pop20
	i32.mul 	$push22=, $11, $pop21
	i32.const	$push150=, -1
	i32.add 	$push23=, $pop22, $pop150
	i32.store	$push24=, h($2), $pop23
	i32.eqz 	$push25=, $pop24
	i64.extend_u/i32	$push26=, $pop25
	i64.lt_s	$push27=, $pop26, $1
	i32.store	$discard=, e($2), $pop27
	i32.const	$push28=, 3
	i32.store	$5=, f($2), $pop28
	i32.load	$push29=, 0($0)
	i32.store	$push30=, j($2), $pop29
	i32.mul 	$push31=, $11, $pop30
	i32.const	$push149=, -1
	i32.add 	$push32=, $pop31, $pop149
	i32.store	$push33=, h($2), $pop32
	i32.eqz 	$push34=, $pop33
	i64.extend_u/i32	$push35=, $pop34
	i64.lt_s	$push36=, $pop35, $1
	i32.store	$discard=, e($2), $pop36
	i32.const	$push37=, 4
	i32.store	$6=, f($2), $pop37
	i32.load	$push38=, 0($0)
	i32.store	$push39=, j($2), $pop38
	i32.mul 	$push40=, $11, $pop39
	i32.const	$push148=, -1
	i32.add 	$push41=, $pop40, $pop148
	i32.store	$push42=, h($2), $pop41
	i32.eqz 	$push43=, $pop42
	i64.extend_u/i32	$push44=, $pop43
	i64.lt_s	$push45=, $pop44, $1
	i32.store	$discard=, e($2), $pop45
	i32.const	$push46=, 5
	i32.store	$7=, f($2), $pop46
	i32.load	$push47=, 0($0)
	i32.store	$push48=, j($2), $pop47
	i32.mul 	$push49=, $11, $pop48
	i32.const	$push147=, -1
	i32.add 	$push50=, $pop49, $pop147
	i32.store	$push51=, h($2), $pop50
	i32.eqz 	$push52=, $pop51
	i64.extend_u/i32	$push53=, $pop52
	i64.lt_s	$push54=, $pop53, $1
	i32.store	$discard=, e($2), $pop54
	i32.const	$push55=, 6
	i32.store	$8=, f($2), $pop55
	i32.load	$push56=, 0($0)
	i32.store	$push57=, j($2), $pop56
	i32.mul 	$push58=, $11, $pop57
	i32.const	$push146=, -1
	i32.add 	$push59=, $pop58, $pop146
	i32.store	$push60=, h($2), $pop59
	i32.eqz 	$push61=, $pop60
	i64.extend_u/i32	$push62=, $pop61
	i64.lt_s	$push63=, $pop62, $1
	i32.store	$discard=, e($2), $pop63
	i32.const	$push64=, 7
	i32.store	$9=, f($2), $pop64
	i32.load	$push65=, 0($0)
	i32.store	$push66=, j($2), $pop65
	i32.mul 	$push67=, $11, $pop66
	i32.const	$push145=, -1
	i32.add 	$push68=, $pop67, $pop145
	i32.store	$push69=, h($2), $pop68
	i32.eqz 	$push70=, $pop69
	i64.extend_u/i32	$push71=, $pop70
	i64.lt_s	$push72=, $pop71, $1
	i32.store	$discard=, e($2), $pop72
	i32.const	$push73=, 8
	i32.store	$10=, f($2), $pop73
	i32.store	$discard=, f($2), $2
	i32.load	$push74=, 0($0)
	i32.store	$push75=, j($2), $pop74
	i32.mul 	$push76=, $11, $pop75
	i32.const	$push144=, -1
	i32.add 	$push77=, $pop76, $pop144
	i32.store	$push78=, h($2), $pop77
	i32.eqz 	$push79=, $pop78
	i64.extend_u/i32	$push80=, $pop79
	i64.lt_s	$push81=, $pop80, $1
	i32.store	$discard=, e($2), $pop81
	i32.store	$discard=, f($2), $3
	i32.load	$push82=, 0($0)
	i32.store	$push83=, j($2), $pop82
	i32.mul 	$push84=, $11, $pop83
	i32.const	$push143=, -1
	i32.add 	$push85=, $pop84, $pop143
	i32.store	$push86=, h($2), $pop85
	i32.eqz 	$push87=, $pop86
	i64.extend_u/i32	$push88=, $pop87
	i64.lt_s	$push89=, $pop88, $1
	i32.store	$discard=, e($2), $pop89
	i32.store	$discard=, f($2), $4
	i32.load	$push90=, 0($0)
	i32.store	$push91=, j($2), $pop90
	i32.mul 	$push92=, $11, $pop91
	i32.const	$push142=, -1
	i32.add 	$push93=, $pop92, $pop142
	i32.store	$push94=, h($2), $pop93
	i32.eqz 	$push95=, $pop94
	i64.extend_u/i32	$push96=, $pop95
	i64.lt_s	$push97=, $pop96, $1
	i32.store	$discard=, e($2), $pop97
	i32.store	$discard=, f($2), $5
	i32.load	$push98=, 0($0)
	i32.store	$push99=, j($2), $pop98
	i32.mul 	$push100=, $11, $pop99
	i32.const	$push141=, -1
	i32.add 	$push101=, $pop100, $pop141
	i32.store	$push102=, h($2), $pop101
	i32.eqz 	$push103=, $pop102
	i64.extend_u/i32	$push104=, $pop103
	i64.lt_s	$push105=, $pop104, $1
	i32.store	$discard=, e($2), $pop105
	i32.store	$discard=, f($2), $6
	i32.load	$push106=, 0($0)
	i32.store	$push107=, j($2), $pop106
	i32.mul 	$push108=, $11, $pop107
	i32.const	$push140=, -1
	i32.add 	$push109=, $pop108, $pop140
	i32.store	$push110=, h($2), $pop109
	i32.eqz 	$push111=, $pop110
	i64.extend_u/i32	$push112=, $pop111
	i64.lt_s	$push113=, $pop112, $1
	i32.store	$discard=, e($2), $pop113
	i32.store	$discard=, f($2), $7
	i32.load	$push114=, 0($0)
	i32.store	$push115=, j($2), $pop114
	i32.mul 	$push116=, $11, $pop115
	i32.const	$push139=, -1
	i32.add 	$push117=, $pop116, $pop139
	i32.store	$push118=, h($2), $pop117
	i32.eqz 	$push119=, $pop118
	i64.extend_u/i32	$push120=, $pop119
	i64.lt_s	$push121=, $pop120, $1
	i32.store	$discard=, e($2), $pop121
	i32.store	$discard=, f($2), $8
	i32.load	$push122=, 0($0)
	i32.store	$push123=, j($2), $pop122
	i32.mul 	$push124=, $11, $pop123
	i32.const	$push138=, -1
	i32.add 	$push125=, $pop124, $pop138
	i32.store	$push126=, h($2), $pop125
	i32.eqz 	$push127=, $pop126
	i64.extend_u/i32	$push128=, $pop127
	i64.lt_s	$push129=, $pop128, $1
	i32.store	$discard=, e($2), $pop129
	i32.store	$discard=, f($2), $9
	i32.load	$push130=, 0($0)
	i32.store	$push131=, j($2), $pop130
	i32.mul 	$push132=, $11, $pop131
	i32.const	$push137=, -1
	i32.add 	$push133=, $pop132, $pop137
	i32.store	$0=, h($2), $pop133
	i32.store	$discard=, f($2), $10
	i32.eqz 	$push134=, $0
	i64.extend_u/i32	$push135=, $pop134
	i64.lt_s	$push136=, $pop135, $1
	i32.store	$0=, e($2), $pop136
	i32.const	$push164=, 12
	i32.add 	$push165=, $12, $pop164
	i32.store	$discard=, g($2), $pop165
	block
	i32.const	$push166=, 0
	i32.eq  	$push167=, $0, $pop166
	br_if   	0, $pop167      # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push163=, __stack_pointer
	i32.const	$push161=, 16
	i32.add 	$push162=, $12, $pop161
	i32.store	$discard=, 0($pop163), $pop162
	return  	$2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	c
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.type	e,@object               # @e
	.lcomm	e,4,2
	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0
	.size	g, 4


	.ident	"clang version 3.9.0 "
