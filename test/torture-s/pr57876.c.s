	.text
	.file	"pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push45=, 0
	i32.const	$push43=, 0
	i32.load	$push42=, __stack_pointer($pop43)
	i32.const	$push44=, 16
	i32.sub 	$push168=, $pop42, $pop44
	tee_local	$push167=, $4=, $pop168
	i32.store	__stack_pointer($pop45), $pop167
	i32.const	$push166=, 0
	i32.load	$0=, d($pop166)
	i32.const	$push165=, 0
	i32.const	$push164=, 0
	i32.store	f($pop165), $pop164
	i32.const	$push163=, 0
	i32.load	$push162=, 0($0)
	tee_local	$push161=, $1=, $pop162
	i32.store	j($pop163), $pop161
	i32.const	$push160=, 0
	i32.const	$push0=, 1
	i32.store	f($pop160), $pop0
	i32.const	$push159=, 0
	i32.const	$push158=, 0
	i32.load	$push157=, a($pop158)
	tee_local	$push156=, $2=, $pop157
	i32.mul 	$push1=, $1, $pop156
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	h($pop159), $pop3
	i32.const	$push155=, 0
	i32.load	$push154=, 0($0)
	tee_local	$push153=, $1=, $pop154
	i32.store	j($pop155), $pop153
	i32.const	$push152=, 0
	i32.const	$push4=, 2
	i32.store	f($pop152), $pop4
	i32.const	$push151=, 0
	i32.mul 	$push5=, $2, $1
	i32.const	$push150=, -1
	i32.add 	$push6=, $pop5, $pop150
	i32.store	h($pop151), $pop6
	i32.const	$push149=, 0
	i32.load	$push148=, 0($0)
	tee_local	$push147=, $1=, $pop148
	i32.store	j($pop149), $pop147
	i32.const	$push146=, 0
	i32.const	$push7=, 3
	i32.store	f($pop146), $pop7
	i32.const	$push145=, 0
	i32.mul 	$push8=, $2, $1
	i32.const	$push144=, -1
	i32.add 	$push9=, $pop8, $pop144
	i32.store	h($pop145), $pop9
	i32.const	$push143=, 0
	i32.load	$push142=, 0($0)
	tee_local	$push141=, $1=, $pop142
	i32.store	j($pop143), $pop141
	i32.const	$push140=, 0
	i32.const	$push10=, 4
	i32.store	f($pop140), $pop10
	i32.const	$push139=, 0
	i32.mul 	$push11=, $2, $1
	i32.const	$push138=, -1
	i32.add 	$push12=, $pop11, $pop138
	i32.store	h($pop139), $pop12
	i32.const	$push137=, 0
	i32.load	$push136=, 0($0)
	tee_local	$push135=, $1=, $pop136
	i32.store	j($pop137), $pop135
	i32.const	$push134=, 0
	i32.const	$push13=, 5
	i32.store	f($pop134), $pop13
	i32.const	$push133=, 0
	i32.mul 	$push14=, $2, $1
	i32.const	$push132=, -1
	i32.add 	$push15=, $pop14, $pop132
	i32.store	h($pop133), $pop15
	i32.const	$push131=, 0
	i32.load	$push130=, 0($0)
	tee_local	$push129=, $1=, $pop130
	i32.store	j($pop131), $pop129
	i32.const	$push128=, 0
	i32.const	$push16=, 6
	i32.store	f($pop128), $pop16
	i32.const	$push127=, 0
	i32.mul 	$push17=, $2, $1
	i32.const	$push126=, -1
	i32.add 	$push18=, $pop17, $pop126
	i32.store	h($pop127), $pop18
	i32.const	$push125=, 0
	i32.load	$push124=, 0($0)
	tee_local	$push123=, $1=, $pop124
	i32.store	j($pop125), $pop123
	i32.const	$push122=, 0
	i32.const	$push19=, 7
	i32.store	f($pop122), $pop19
	i32.const	$push121=, 0
	i32.mul 	$push20=, $2, $1
	i32.const	$push120=, -1
	i32.add 	$push21=, $pop20, $pop120
	i32.store	h($pop121), $pop21
	i32.const	$push119=, 0
	i32.load	$push118=, 0($0)
	tee_local	$push117=, $1=, $pop118
	i32.store	j($pop119), $pop117
	i32.const	$push116=, 0
	i32.mul 	$push22=, $2, $1
	i32.const	$push115=, -1
	i32.add 	$push23=, $pop22, $pop115
	i32.store	h($pop116), $pop23
	i32.const	$push114=, 0
	i64.load32_s	$3=, b($pop114)
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i32.store	f($pop113), $pop112
	i32.const	$push111=, 0
	i32.load	$push110=, 0($0)
	tee_local	$push109=, $1=, $pop110
	i32.store	j($pop111), $pop109
	i32.const	$push108=, 0
	i32.const	$push107=, 1
	i32.store	f($pop108), $pop107
	i32.const	$push106=, 0
	i32.mul 	$push24=, $2, $1
	i32.const	$push105=, -1
	i32.add 	$push25=, $pop24, $pop105
	i32.store	h($pop106), $pop25
	i32.const	$push104=, 0
	i32.load	$push103=, 0($0)
	tee_local	$push102=, $1=, $pop103
	i32.store	j($pop104), $pop102
	i32.const	$push101=, 0
	i32.const	$push100=, 2
	i32.store	f($pop101), $pop100
	i32.const	$push99=, 0
	i32.mul 	$push26=, $2, $1
	i32.const	$push98=, -1
	i32.add 	$push27=, $pop26, $pop98
	i32.store	h($pop99), $pop27
	i32.const	$push97=, 0
	i32.load	$push96=, 0($0)
	tee_local	$push95=, $1=, $pop96
	i32.store	j($pop97), $pop95
	i32.const	$push94=, 0
	i32.const	$push93=, 3
	i32.store	f($pop94), $pop93
	i32.const	$push92=, 0
	i32.mul 	$push28=, $2, $1
	i32.const	$push91=, -1
	i32.add 	$push29=, $pop28, $pop91
	i32.store	h($pop92), $pop29
	i32.const	$push90=, 0
	i32.load	$push89=, 0($0)
	tee_local	$push88=, $1=, $pop89
	i32.store	j($pop90), $pop88
	i32.const	$push87=, 0
	i32.const	$push86=, 4
	i32.store	f($pop87), $pop86
	i32.const	$push85=, 0
	i32.mul 	$push30=, $2, $1
	i32.const	$push84=, -1
	i32.add 	$push31=, $pop30, $pop84
	i32.store	h($pop85), $pop31
	i32.const	$push83=, 0
	i32.load	$push82=, 0($0)
	tee_local	$push81=, $1=, $pop82
	i32.store	j($pop83), $pop81
	i32.const	$push80=, 0
	i32.const	$push79=, 5
	i32.store	f($pop80), $pop79
	i32.const	$push78=, 0
	i32.mul 	$push32=, $2, $1
	i32.const	$push77=, -1
	i32.add 	$push33=, $pop32, $pop77
	i32.store	h($pop78), $pop33
	i32.const	$push76=, 0
	i32.load	$push75=, 0($0)
	tee_local	$push74=, $1=, $pop75
	i32.store	j($pop76), $pop74
	i32.const	$push73=, 0
	i32.const	$push72=, 6
	i32.store	f($pop73), $pop72
	i32.const	$push71=, 0
	i32.mul 	$push34=, $2, $1
	i32.const	$push70=, -1
	i32.add 	$push35=, $pop34, $pop70
	i32.store	h($pop71), $pop35
	i32.const	$push69=, 0
	i32.load	$push68=, 0($0)
	tee_local	$push67=, $1=, $pop68
	i32.store	j($pop69), $pop67
	i32.const	$push66=, 0
	i32.const	$push65=, 7
	i32.store	f($pop66), $pop65
	i32.const	$push64=, 0
	i32.mul 	$push36=, $2, $1
	i32.const	$push63=, -1
	i32.add 	$push37=, $pop36, $pop63
	i32.store	h($pop64), $pop37
	i32.const	$push62=, 0
	i32.load	$push61=, 0($0)
	tee_local	$push60=, $0=, $pop61
	i32.store	j($pop62), $pop60
	i32.const	$push59=, 0
	i32.const	$push38=, 8
	i32.store	f($pop59), $pop38
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
	i32.eqz 	$push170=, $0
	br_if   	0, $pop170      # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push48=, 0
	i32.const	$push46=, 16
	i32.add 	$push47=, $4, $pop46
	i32.store	__stack_pointer($pop48), $pop47
	i32.const	$push169=, 0
	return  	$pop169
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
