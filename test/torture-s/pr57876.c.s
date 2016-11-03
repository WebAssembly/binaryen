	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %for.body4.1
	i32.const	$push75=, 0
	i32.const	$push72=, 0
	i32.load	$push73=, __stack_pointer($pop72)
	i32.const	$push74=, 16
	i32.sub 	$push245=, $pop73, $pop74
	tee_local	$push244=, $4=, $pop245
	i32.store	__stack_pointer($pop75), $pop244
	i32.const	$push243=, 0
	i64.load32_s	$0=, b($pop243)
	i32.const	$push242=, 0
	i32.load	$1=, d($pop242)
	i32.const	$push241=, 0
	i32.const	$push240=, 0
	i32.store	f($pop241), $pop240
	i32.const	$push239=, 0
	i32.load	$push238=, 0($1)
	tee_local	$push237=, $2=, $pop238
	i32.store	j($pop239), $pop237
	i32.const	$push236=, 0
	i32.const	$push0=, 1
	i32.store	f($pop236), $pop0
	i32.const	$push235=, 0
	i32.const	$push234=, 0
	i32.load	$push233=, a($pop234)
	tee_local	$push232=, $3=, $pop233
	i32.mul 	$push1=, $2, $pop232
	i32.const	$push2=, -1
	i32.add 	$push231=, $pop1, $pop2
	tee_local	$push230=, $2=, $pop231
	i32.store	h($pop235), $pop230
	i32.const	$push229=, 0
	i32.eqz 	$push3=, $2
	i64.extend_u/i32	$push4=, $pop3
	i64.lt_s	$push5=, $pop4, $0
	i32.store	e($pop229), $pop5
	i32.const	$push228=, 0
	i32.load	$push227=, 0($1)
	tee_local	$push226=, $2=, $pop227
	i32.store	j($pop228), $pop226
	i32.const	$push225=, 0
	i32.const	$push6=, 2
	i32.store	f($pop225), $pop6
	i32.const	$push224=, 0
	i32.mul 	$push7=, $3, $2
	i32.const	$push223=, -1
	i32.add 	$push222=, $pop7, $pop223
	tee_local	$push221=, $2=, $pop222
	i32.store	h($pop224), $pop221
	i32.const	$push220=, 0
	i32.eqz 	$push8=, $2
	i64.extend_u/i32	$push9=, $pop8
	i64.lt_s	$push10=, $pop9, $0
	i32.store	e($pop220), $pop10
	i32.const	$push219=, 0
	i32.load	$push218=, 0($1)
	tee_local	$push217=, $2=, $pop218
	i32.store	j($pop219), $pop217
	i32.const	$push216=, 0
	i32.const	$push11=, 3
	i32.store	f($pop216), $pop11
	i32.const	$push215=, 0
	i32.mul 	$push12=, $3, $2
	i32.const	$push214=, -1
	i32.add 	$push213=, $pop12, $pop214
	tee_local	$push212=, $2=, $pop213
	i32.store	h($pop215), $pop212
	i32.const	$push211=, 0
	i32.eqz 	$push13=, $2
	i64.extend_u/i32	$push14=, $pop13
	i64.lt_s	$push15=, $pop14, $0
	i32.store	e($pop211), $pop15
	i32.const	$push210=, 0
	i32.load	$push209=, 0($1)
	tee_local	$push208=, $2=, $pop209
	i32.store	j($pop210), $pop208
	i32.const	$push207=, 0
	i32.const	$push16=, 4
	i32.store	f($pop207), $pop16
	i32.const	$push206=, 0
	i32.mul 	$push17=, $3, $2
	i32.const	$push205=, -1
	i32.add 	$push204=, $pop17, $pop205
	tee_local	$push203=, $2=, $pop204
	i32.store	h($pop206), $pop203
	i32.const	$push202=, 0
	i32.eqz 	$push18=, $2
	i64.extend_u/i32	$push19=, $pop18
	i64.lt_s	$push20=, $pop19, $0
	i32.store	e($pop202), $pop20
	i32.const	$push201=, 0
	i32.load	$push200=, 0($1)
	tee_local	$push199=, $2=, $pop200
	i32.store	j($pop201), $pop199
	i32.const	$push198=, 0
	i32.const	$push21=, 5
	i32.store	f($pop198), $pop21
	i32.const	$push197=, 0
	i32.mul 	$push22=, $3, $2
	i32.const	$push196=, -1
	i32.add 	$push195=, $pop22, $pop196
	tee_local	$push194=, $2=, $pop195
	i32.store	h($pop197), $pop194
	i32.const	$push193=, 0
	i32.eqz 	$push23=, $2
	i64.extend_u/i32	$push24=, $pop23
	i64.lt_s	$push25=, $pop24, $0
	i32.store	e($pop193), $pop25
	i32.const	$push192=, 0
	i32.load	$push191=, 0($1)
	tee_local	$push190=, $2=, $pop191
	i32.store	j($pop192), $pop190
	i32.const	$push189=, 0
	i32.const	$push26=, 6
	i32.store	f($pop189), $pop26
	i32.const	$push188=, 0
	i32.mul 	$push27=, $3, $2
	i32.const	$push187=, -1
	i32.add 	$push186=, $pop27, $pop187
	tee_local	$push185=, $2=, $pop186
	i32.store	h($pop188), $pop185
	i32.const	$push184=, 0
	i32.eqz 	$push28=, $2
	i64.extend_u/i32	$push29=, $pop28
	i64.lt_s	$push30=, $pop29, $0
	i32.store	e($pop184), $pop30
	i32.const	$push183=, 0
	i32.load	$push182=, 0($1)
	tee_local	$push181=, $2=, $pop182
	i32.store	j($pop183), $pop181
	i32.const	$push180=, 0
	i32.const	$push31=, 7
	i32.store	f($pop180), $pop31
	i32.const	$push179=, 0
	i32.mul 	$push32=, $3, $2
	i32.const	$push178=, -1
	i32.add 	$push177=, $pop32, $pop178
	tee_local	$push176=, $2=, $pop177
	i32.store	h($pop179), $pop176
	i32.const	$push175=, 0
	i32.eqz 	$push33=, $2
	i64.extend_u/i32	$push34=, $pop33
	i64.lt_s	$push35=, $pop34, $0
	i32.store	e($pop175), $pop35
	i32.const	$push174=, 0
	i32.load	$push173=, 0($1)
	tee_local	$push172=, $2=, $pop173
	i32.store	j($pop174), $pop172
	i32.const	$push171=, 0
	i32.const	$push36=, 8
	i32.store	f($pop171), $pop36
	i32.const	$push170=, 0
	i32.mul 	$push37=, $3, $2
	i32.const	$push169=, -1
	i32.add 	$push168=, $pop37, $pop169
	tee_local	$push167=, $2=, $pop168
	i32.store	h($pop170), $pop167
	i32.const	$push166=, 0
	i32.eqz 	$push38=, $2
	i64.extend_u/i32	$push39=, $pop38
	i64.lt_s	$push40=, $pop39, $0
	i32.store	e($pop166), $pop40
	i32.const	$push165=, 0
	i32.const	$push164=, 0
	i32.store	f($pop165), $pop164
	i32.const	$push163=, 0
	i32.load	$push162=, 0($1)
	tee_local	$push161=, $2=, $pop162
	i32.store	j($pop163), $pop161
	i32.const	$push160=, 0
	i32.const	$push159=, 1
	i32.store	f($pop160), $pop159
	i32.const	$push158=, 0
	i32.mul 	$push41=, $3, $2
	i32.const	$push157=, -1
	i32.add 	$push156=, $pop41, $pop157
	tee_local	$push155=, $2=, $pop156
	i32.store	h($pop158), $pop155
	i32.const	$push154=, 0
	i32.eqz 	$push42=, $2
	i64.extend_u/i32	$push43=, $pop42
	i64.lt_s	$push44=, $pop43, $0
	i32.store	e($pop154), $pop44
	i32.const	$push153=, 0
	i32.load	$push152=, 0($1)
	tee_local	$push151=, $2=, $pop152
	i32.store	j($pop153), $pop151
	i32.const	$push150=, 0
	i32.const	$push149=, 2
	i32.store	f($pop150), $pop149
	i32.const	$push148=, 0
	i32.mul 	$push45=, $3, $2
	i32.const	$push147=, -1
	i32.add 	$push146=, $pop45, $pop147
	tee_local	$push145=, $2=, $pop146
	i32.store	h($pop148), $pop145
	i32.const	$push144=, 0
	i32.eqz 	$push46=, $2
	i64.extend_u/i32	$push47=, $pop46
	i64.lt_s	$push48=, $pop47, $0
	i32.store	e($pop144), $pop48
	i32.const	$push143=, 0
	i32.load	$push142=, 0($1)
	tee_local	$push141=, $2=, $pop142
	i32.store	j($pop143), $pop141
	i32.const	$push140=, 0
	i32.const	$push139=, 3
	i32.store	f($pop140), $pop139
	i32.const	$push138=, 0
	i32.mul 	$push49=, $3, $2
	i32.const	$push137=, -1
	i32.add 	$push136=, $pop49, $pop137
	tee_local	$push135=, $2=, $pop136
	i32.store	h($pop138), $pop135
	i32.const	$push134=, 0
	i32.eqz 	$push50=, $2
	i64.extend_u/i32	$push51=, $pop50
	i64.lt_s	$push52=, $pop51, $0
	i32.store	e($pop134), $pop52
	i32.const	$push133=, 0
	i32.load	$push132=, 0($1)
	tee_local	$push131=, $2=, $pop132
	i32.store	j($pop133), $pop131
	i32.const	$push130=, 0
	i32.const	$push129=, 4
	i32.store	f($pop130), $pop129
	i32.const	$push128=, 0
	i32.mul 	$push53=, $3, $2
	i32.const	$push127=, -1
	i32.add 	$push126=, $pop53, $pop127
	tee_local	$push125=, $2=, $pop126
	i32.store	h($pop128), $pop125
	i32.const	$push124=, 0
	i32.eqz 	$push54=, $2
	i64.extend_u/i32	$push55=, $pop54
	i64.lt_s	$push56=, $pop55, $0
	i32.store	e($pop124), $pop56
	i32.const	$push123=, 0
	i32.load	$push122=, 0($1)
	tee_local	$push121=, $2=, $pop122
	i32.store	j($pop123), $pop121
	i32.const	$push120=, 0
	i32.const	$push119=, 5
	i32.store	f($pop120), $pop119
	i32.const	$push118=, 0
	i32.mul 	$push57=, $3, $2
	i32.const	$push117=, -1
	i32.add 	$push116=, $pop57, $pop117
	tee_local	$push115=, $2=, $pop116
	i32.store	h($pop118), $pop115
	i32.const	$push114=, 0
	i32.eqz 	$push58=, $2
	i64.extend_u/i32	$push59=, $pop58
	i64.lt_s	$push60=, $pop59, $0
	i32.store	e($pop114), $pop60
	i32.const	$push113=, 0
	i32.load	$push112=, 0($1)
	tee_local	$push111=, $2=, $pop112
	i32.store	j($pop113), $pop111
	i32.const	$push110=, 0
	i32.const	$push109=, 6
	i32.store	f($pop110), $pop109
	i32.const	$push108=, 0
	i32.mul 	$push61=, $3, $2
	i32.const	$push107=, -1
	i32.add 	$push106=, $pop61, $pop107
	tee_local	$push105=, $2=, $pop106
	i32.store	h($pop108), $pop105
	i32.const	$push104=, 0
	i32.eqz 	$push62=, $2
	i64.extend_u/i32	$push63=, $pop62
	i64.lt_s	$push64=, $pop63, $0
	i32.store	e($pop104), $pop64
	i32.const	$push103=, 0
	i32.load	$push102=, 0($1)
	tee_local	$push101=, $2=, $pop102
	i32.store	j($pop103), $pop101
	i32.const	$push100=, 0
	i32.const	$push99=, 7
	i32.store	f($pop100), $pop99
	i32.const	$push98=, 0
	i32.mul 	$push65=, $3, $2
	i32.const	$push97=, -1
	i32.add 	$push96=, $pop65, $pop97
	tee_local	$push95=, $2=, $pop96
	i32.store	h($pop98), $pop95
	i32.const	$push94=, 0
	i32.eqz 	$push66=, $2
	i64.extend_u/i32	$push67=, $pop66
	i64.lt_s	$push68=, $pop67, $0
	i32.store	e($pop94), $pop68
	i32.const	$push93=, 0
	i32.load	$push92=, 0($1)
	tee_local	$push91=, $1=, $pop92
	i32.store	j($pop93), $pop91
	i32.const	$push90=, 0
	i32.const	$push89=, 8
	i32.store	f($pop90), $pop89
	i32.const	$push88=, 0
	i32.mul 	$push69=, $3, $1
	i32.const	$push87=, -1
	i32.add 	$push86=, $pop69, $pop87
	tee_local	$push85=, $1=, $pop86
	i32.store	h($pop88), $pop85
	i32.const	$push84=, 0
	i32.eqz 	$push70=, $1
	i64.extend_u/i32	$push71=, $pop70
	i64.lt_s	$push83=, $pop71, $0
	tee_local	$push82=, $1=, $pop83
	i32.store	e($pop84), $pop82
	i32.const	$push81=, 0
	i32.const	$push79=, 12
	i32.add 	$push80=, $4, $pop79
	i32.store	g($pop81), $pop80
	block   	
	i32.eqz 	$push247=, $1
	br_if   	0, $pop247      # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push78=, 0
	i32.const	$push76=, 16
	i32.add 	$push77=, $4, $pop76
	i32.store	__stack_pointer($pop78), $pop77
	i32.const	$push246=, 0
	return  	$pop246
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
	.section	.bss.e,"aw",@nobits
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
