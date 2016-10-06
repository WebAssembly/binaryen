	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32
# BB#0:                                 # %for.body4.1
	i32.const	$push45=, 0
	i32.const	$push42=, 0
	i32.load	$push43=, __stack_pointer($pop42)
	i32.const	$push44=, 16
	i32.sub 	$push170=, $pop43, $pop44
	tee_local	$push169=, $4=, $pop170
	i32.store	__stack_pointer($pop45), $pop169
	i32.const	$push168=, 0
	i32.load	$0=, d($pop168)
	i32.const	$push167=, 0
	i32.const	$push166=, 0
	i32.store	f($pop167), $pop166
	i32.const	$push165=, 0
	i32.load	$push164=, 0($0)
	tee_local	$push163=, $1=, $pop164
	i32.store	j($pop165), $pop163
	i32.const	$push162=, 0
	i32.const	$push0=, 1
	i32.store	f($pop162), $pop0
	i32.const	$push161=, 0
	i32.const	$push160=, 0
	i32.load	$push159=, a($pop160)
	tee_local	$push158=, $2=, $pop159
	i32.mul 	$push1=, $1, $pop158
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	h($pop161), $pop3
	i32.const	$push157=, 0
	i32.load	$push156=, 0($0)
	tee_local	$push155=, $1=, $pop156
	i32.store	j($pop157), $pop155
	i32.const	$push154=, 0
	i32.const	$push4=, 2
	i32.store	f($pop154), $pop4
	i32.const	$push153=, 0
	i32.mul 	$push5=, $2, $1
	i32.const	$push152=, -1
	i32.add 	$push6=, $pop5, $pop152
	i32.store	h($pop153), $pop6
	i32.const	$push151=, 0
	i32.load	$push150=, 0($0)
	tee_local	$push149=, $1=, $pop150
	i32.store	j($pop151), $pop149
	i32.const	$push148=, 0
	i32.const	$push7=, 3
	i32.store	f($pop148), $pop7
	i32.const	$push147=, 0
	i32.mul 	$push8=, $2, $1
	i32.const	$push146=, -1
	i32.add 	$push9=, $pop8, $pop146
	i32.store	h($pop147), $pop9
	i32.const	$push145=, 0
	i32.load	$push144=, 0($0)
	tee_local	$push143=, $1=, $pop144
	i32.store	j($pop145), $pop143
	i32.const	$push142=, 0
	i32.const	$push10=, 4
	i32.store	f($pop142), $pop10
	i32.const	$push141=, 0
	i32.mul 	$push11=, $2, $1
	i32.const	$push140=, -1
	i32.add 	$push12=, $pop11, $pop140
	i32.store	h($pop141), $pop12
	i32.const	$push139=, 0
	i32.load	$push138=, 0($0)
	tee_local	$push137=, $1=, $pop138
	i32.store	j($pop139), $pop137
	i32.const	$push136=, 0
	i32.const	$push13=, 5
	i32.store	f($pop136), $pop13
	i32.const	$push135=, 0
	i32.mul 	$push14=, $2, $1
	i32.const	$push134=, -1
	i32.add 	$push15=, $pop14, $pop134
	i32.store	h($pop135), $pop15
	i32.const	$push133=, 0
	i32.load	$push132=, 0($0)
	tee_local	$push131=, $1=, $pop132
	i32.store	j($pop133), $pop131
	i32.const	$push130=, 0
	i32.const	$push16=, 6
	i32.store	f($pop130), $pop16
	i32.const	$push129=, 0
	i32.mul 	$push17=, $2, $1
	i32.const	$push128=, -1
	i32.add 	$push18=, $pop17, $pop128
	i32.store	h($pop129), $pop18
	i32.const	$push127=, 0
	i32.load	$push126=, 0($0)
	tee_local	$push125=, $1=, $pop126
	i32.store	j($pop127), $pop125
	i32.const	$push124=, 0
	i32.const	$push19=, 7
	i32.store	f($pop124), $pop19
	i32.const	$push123=, 0
	i32.mul 	$push20=, $2, $1
	i32.const	$push122=, -1
	i32.add 	$push21=, $pop20, $pop122
	i32.store	h($pop123), $pop21
	i32.const	$push121=, 0
	i32.load	$push120=, 0($0)
	tee_local	$push119=, $1=, $pop120
	i32.store	j($pop121), $pop119
	i32.const	$push118=, 0
	i32.const	$push22=, 8
	i32.store	f($pop118), $pop22
	i32.const	$push117=, 0
	i32.mul 	$push23=, $2, $1
	i32.const	$push116=, -1
	i32.add 	$push24=, $pop23, $pop116
	i32.store	h($pop117), $pop24
	i32.const	$push115=, 0
	i64.load32_s	$3=, b($pop115)
	i32.const	$push114=, 0
	i32.const	$push113=, 0
	i32.store	f($pop114), $pop113
	i32.const	$push112=, 0
	i32.load	$push111=, 0($0)
	tee_local	$push110=, $1=, $pop111
	i32.store	j($pop112), $pop110
	i32.const	$push109=, 0
	i32.const	$push108=, 1
	i32.store	f($pop109), $pop108
	i32.const	$push107=, 0
	i32.mul 	$push25=, $2, $1
	i32.const	$push106=, -1
	i32.add 	$push26=, $pop25, $pop106
	i32.store	h($pop107), $pop26
	i32.const	$push105=, 0
	i32.load	$push104=, 0($0)
	tee_local	$push103=, $1=, $pop104
	i32.store	j($pop105), $pop103
	i32.const	$push102=, 0
	i32.const	$push101=, 2
	i32.store	f($pop102), $pop101
	i32.const	$push100=, 0
	i32.mul 	$push27=, $2, $1
	i32.const	$push99=, -1
	i32.add 	$push28=, $pop27, $pop99
	i32.store	h($pop100), $pop28
	i32.const	$push98=, 0
	i32.load	$push97=, 0($0)
	tee_local	$push96=, $1=, $pop97
	i32.store	j($pop98), $pop96
	i32.const	$push95=, 0
	i32.const	$push94=, 3
	i32.store	f($pop95), $pop94
	i32.const	$push93=, 0
	i32.mul 	$push29=, $2, $1
	i32.const	$push92=, -1
	i32.add 	$push30=, $pop29, $pop92
	i32.store	h($pop93), $pop30
	i32.const	$push91=, 0
	i32.load	$push90=, 0($0)
	tee_local	$push89=, $1=, $pop90
	i32.store	j($pop91), $pop89
	i32.const	$push88=, 0
	i32.const	$push87=, 4
	i32.store	f($pop88), $pop87
	i32.const	$push86=, 0
	i32.mul 	$push31=, $2, $1
	i32.const	$push85=, -1
	i32.add 	$push32=, $pop31, $pop85
	i32.store	h($pop86), $pop32
	i32.const	$push84=, 0
	i32.load	$push83=, 0($0)
	tee_local	$push82=, $1=, $pop83
	i32.store	j($pop84), $pop82
	i32.const	$push81=, 0
	i32.const	$push80=, 5
	i32.store	f($pop81), $pop80
	i32.const	$push79=, 0
	i32.mul 	$push33=, $2, $1
	i32.const	$push78=, -1
	i32.add 	$push34=, $pop33, $pop78
	i32.store	h($pop79), $pop34
	i32.const	$push77=, 0
	i32.load	$push76=, 0($0)
	tee_local	$push75=, $1=, $pop76
	i32.store	j($pop77), $pop75
	i32.const	$push74=, 0
	i32.const	$push73=, 6
	i32.store	f($pop74), $pop73
	i32.const	$push72=, 0
	i32.mul 	$push35=, $2, $1
	i32.const	$push71=, -1
	i32.add 	$push36=, $pop35, $pop71
	i32.store	h($pop72), $pop36
	i32.const	$push70=, 0
	i32.load	$push69=, 0($0)
	tee_local	$push68=, $1=, $pop69
	i32.store	j($pop70), $pop68
	i32.const	$push67=, 0
	i32.const	$push66=, 7
	i32.store	f($pop67), $pop66
	i32.const	$push65=, 0
	i32.mul 	$push37=, $2, $1
	i32.const	$push64=, -1
	i32.add 	$push38=, $pop37, $pop64
	i32.store	h($pop65), $pop38
	i32.const	$push63=, 0
	i32.load	$push62=, 0($0)
	tee_local	$push61=, $0=, $pop62
	i32.store	j($pop63), $pop61
	i32.const	$push60=, 0
	i32.const	$push59=, 8
	i32.store	f($pop60), $pop59
	i32.const	$push58=, 0
	i32.mul 	$push39=, $2, $0
	i32.const	$push57=, -1
	i32.add 	$push56=, $pop39, $pop57
	tee_local	$push55=, $0=, $pop56
	i32.store	h($pop58), $pop55
	i32.const	$push54=, 0
	i32.eqz 	$push40=, $0
	i64.extend_u/i32	$push41=, $pop40
	i64.lt_s	$push53=, $pop41, $3
	tee_local	$push52=, $0=, $pop53
	i32.store	e($pop54), $pop52
	i32.const	$push51=, 0
	i32.const	$push49=, 12
	i32.add 	$push50=, $4, $pop49
	i32.store	g($pop51), $pop50
	block   	
	i32.eqz 	$push172=, $0
	br_if   	0, $pop172      # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push48=, 0
	i32.const	$push46=, 16
	i32.add 	$push47=, $4, $pop46
	i32.store	__stack_pointer($pop48), $pop47
	i32.const	$push171=, 0
	return  	$pop171
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
