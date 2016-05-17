	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58419.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.sub 	$push0=, $0, $1
	i32.const	$push1=, 24
	i32.shl 	$push2=, $pop0, $pop1
	i32.const	$push4=, 24
	i32.shr_s	$push3=, $pop2, $pop4
	return  	$pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$0=, p($pop2)
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store16	$drop=, c($pop4), $pop1
	i32.const	$push3=, 0
	i32.store	$push0=, 0($0), $pop3
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$0=, p($pop0)
	i32.const	$push83=, 0
	i32.load16_u	$2=, c($pop83)
	i32.const	$push82=, 0
	i32.const	$push1=, 234
	i32.store8	$drop=, b($pop82), $pop1
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push81=, 0
	i32.load	$push2=, k($pop81)
	i32.const	$push80=, 0
	i32.ne  	$push5=, $pop2, $pop80
	i32.const	$push79=, 65535
	i32.and 	$push3=, $2, $pop79
	i32.const	$push78=, 0
	i32.ne  	$push4=, $pop3, $pop78
	i32.and 	$push6=, $pop5, $pop4
	i32.const	$push77=, 0
	i32.load	$push7=, i($pop77)
	i32.const	$push76=, 1
	i32.lt_s	$push8=, $pop7, $pop76
	i32.sub 	$push9=, $pop6, $pop8
	i32.const	$push75=, 255
	i32.and 	$push10=, $pop9, $pop75
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.const	$2=, 1
	i32.const	$1=, 0
	i32.const	$push86=, 0
	i32.const	$push85=, 1
	i32.store16	$drop=, c($pop86), $pop85
	i32.const	$push84=, 0
	i32.store	$drop=, 0($0), $pop84
.LBB2_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push94=, 0
	i32.store	$drop=, g($pop94), $1
	block
	i32.const	$push93=, 0
	i32.load	$push11=, k($pop93)
	i32.const	$push92=, 0
	i32.ne  	$push14=, $pop11, $pop92
	i32.const	$push91=, 65535
	i32.and 	$push12=, $2, $pop91
	i32.const	$push90=, 0
	i32.ne  	$push13=, $pop12, $pop90
	i32.and 	$push15=, $pop14, $pop13
	i32.const	$push89=, 0
	i32.load	$push16=, i($pop89)
	i32.const	$push88=, 1
	i32.lt_s	$push17=, $pop16, $pop88
	i32.sub 	$push18=, $pop15, $pop17
	i32.const	$push87=, 255
	i32.and 	$push19=, $pop18, $pop87
	br_if   	0, $pop19       # 0: down to label1
# BB#3:                                 # %lor.rhs.1
	i32.const	$2=, 1
	i32.const	$push97=, 0
	i32.const	$push96=, 1
	i32.store16	$drop=, c($pop97), $pop96
	i32.const	$push95=, 0
	i32.store	$drop=, 0($0), $pop95
	i32.const	$3=, 0
.LBB2_4:                                # %lor.end.1
	end_block                       # label1:
	i32.const	$push105=, 0
	i32.store	$drop=, g($pop105), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push104=, 0
	i32.load	$push20=, k($pop104)
	i32.const	$push103=, 0
	i32.ne  	$push23=, $pop20, $pop103
	i32.const	$push102=, 65535
	i32.and 	$push21=, $2, $pop102
	i32.const	$push101=, 0
	i32.ne  	$push22=, $pop21, $pop101
	i32.and 	$push24=, $pop23, $pop22
	i32.const	$push100=, 0
	i32.load	$push25=, i($pop100)
	i32.const	$push99=, 1
	i32.lt_s	$push26=, $pop25, $pop99
	i32.sub 	$push27=, $pop24, $pop26
	i32.const	$push98=, 255
	i32.and 	$push28=, $pop27, $pop98
	br_if   	0, $pop28       # 0: down to label2
# BB#5:                                 # %lor.rhs.2
	i32.const	$2=, 1
	i32.const	$1=, 0
	i32.const	$push108=, 0
	i32.const	$push107=, 1
	i32.store16	$drop=, c($pop108), $pop107
	i32.const	$push106=, 0
	i32.store	$drop=, 0($0), $pop106
.LBB2_6:                                # %lor.end.2
	end_block                       # label2:
	i32.const	$push116=, 0
	i32.store	$drop=, g($pop116), $1
	block
	i32.const	$push115=, 0
	i32.load	$push29=, k($pop115)
	i32.const	$push114=, 0
	i32.ne  	$push32=, $pop29, $pop114
	i32.const	$push113=, 65535
	i32.and 	$push30=, $2, $pop113
	i32.const	$push112=, 0
	i32.ne  	$push31=, $pop30, $pop112
	i32.and 	$push33=, $pop32, $pop31
	i32.const	$push111=, 0
	i32.load	$push34=, i($pop111)
	i32.const	$push110=, 1
	i32.lt_s	$push35=, $pop34, $pop110
	i32.sub 	$push36=, $pop33, $pop35
	i32.const	$push109=, 255
	i32.and 	$push37=, $pop36, $pop109
	br_if   	0, $pop37       # 0: down to label3
# BB#7:                                 # %lor.rhs.3
	i32.const	$2=, 1
	i32.const	$push119=, 0
	i32.const	$push118=, 1
	i32.store16	$drop=, c($pop119), $pop118
	i32.const	$push117=, 0
	i32.store	$drop=, 0($0), $pop117
	i32.const	$3=, 0
.LBB2_8:                                # %lor.end.3
	end_block                       # label3:
	i32.const	$push127=, 0
	i32.store	$drop=, g($pop127), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push126=, 0
	i32.load	$push38=, k($pop126)
	i32.const	$push125=, 0
	i32.ne  	$push41=, $pop38, $pop125
	i32.const	$push124=, 65535
	i32.and 	$push39=, $2, $pop124
	i32.const	$push123=, 0
	i32.ne  	$push40=, $pop39, $pop123
	i32.and 	$push42=, $pop41, $pop40
	i32.const	$push122=, 0
	i32.load	$push43=, i($pop122)
	i32.const	$push121=, 1
	i32.lt_s	$push44=, $pop43, $pop121
	i32.sub 	$push45=, $pop42, $pop44
	i32.const	$push120=, 255
	i32.and 	$push46=, $pop45, $pop120
	br_if   	0, $pop46       # 0: down to label4
# BB#9:                                 # %lor.rhs.4
	i32.const	$2=, 1
	i32.const	$1=, 0
	i32.const	$push130=, 0
	i32.const	$push129=, 1
	i32.store16	$drop=, c($pop130), $pop129
	i32.const	$push128=, 0
	i32.store	$drop=, 0($0), $pop128
.LBB2_10:                               # %lor.end.4
	end_block                       # label4:
	i32.const	$push138=, 0
	i32.store	$drop=, g($pop138), $1
	block
	i32.const	$push137=, 0
	i32.load	$push47=, k($pop137)
	i32.const	$push136=, 0
	i32.ne  	$push50=, $pop47, $pop136
	i32.const	$push135=, 65535
	i32.and 	$push48=, $2, $pop135
	i32.const	$push134=, 0
	i32.ne  	$push49=, $pop48, $pop134
	i32.and 	$push51=, $pop50, $pop49
	i32.const	$push133=, 0
	i32.load	$push52=, i($pop133)
	i32.const	$push132=, 1
	i32.lt_s	$push53=, $pop52, $pop132
	i32.sub 	$push54=, $pop51, $pop53
	i32.const	$push131=, 255
	i32.and 	$push55=, $pop54, $pop131
	br_if   	0, $pop55       # 0: down to label5
# BB#11:                                # %lor.rhs.5
	i32.const	$2=, 1
	i32.const	$push141=, 0
	i32.const	$push140=, 1
	i32.store16	$drop=, c($pop141), $pop140
	i32.const	$push139=, 0
	i32.store	$drop=, 0($0), $pop139
	i32.const	$3=, 0
.LBB2_12:                               # %lor.end.5
	end_block                       # label5:
	i32.const	$push149=, 0
	i32.store	$drop=, g($pop149), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push148=, 0
	i32.load	$push56=, k($pop148)
	i32.const	$push147=, 0
	i32.ne  	$push59=, $pop56, $pop147
	i32.const	$push146=, 65535
	i32.and 	$push57=, $2, $pop146
	i32.const	$push145=, 0
	i32.ne  	$push58=, $pop57, $pop145
	i32.and 	$push60=, $pop59, $pop58
	i32.const	$push144=, 0
	i32.load	$push61=, i($pop144)
	i32.const	$push143=, 1
	i32.lt_s	$push62=, $pop61, $pop143
	i32.sub 	$push63=, $pop60, $pop62
	i32.const	$push142=, 255
	i32.and 	$push64=, $pop63, $pop142
	br_if   	0, $pop64       # 0: down to label6
# BB#13:                                # %lor.rhs.6
	i32.const	$2=, 1
	i32.const	$1=, 0
	i32.const	$push152=, 0
	i32.const	$push151=, 1
	i32.store16	$drop=, c($pop152), $pop151
	i32.const	$push150=, 0
	i32.store	$drop=, 0($0), $pop150
.LBB2_14:                               # %lor.end.6
	end_block                       # label6:
	i32.const	$push163=, 0
	i32.store	$drop=, g($pop163), $1
	i32.const	$push162=, 0
	i32.load	$1=, a($pop162)
	block
	i32.const	$push161=, 0
	i32.load	$push65=, k($pop161)
	i32.const	$push160=, 0
	i32.ne  	$push68=, $pop65, $pop160
	i32.const	$push159=, 65535
	i32.and 	$push66=, $2, $pop159
	i32.const	$push158=, 0
	i32.ne  	$push67=, $pop66, $pop158
	i32.and 	$push157=, $pop68, $pop67
	tee_local	$push156=, $2=, $pop157
	i32.const	$push155=, 0
	i32.load	$push69=, i($pop155)
	i32.const	$push154=, 1
	i32.lt_s	$push70=, $pop69, $pop154
	i32.sub 	$push71=, $pop156, $pop70
	i32.const	$push153=, 255
	i32.and 	$push72=, $pop71, $pop153
	br_if   	0, $pop72       # 0: down to label7
# BB#15:                                # %lor.rhs.7
	i32.const	$push165=, 0
	i32.const	$push73=, 1
	i32.store16	$drop=, c($pop165), $pop73
	i32.const	$push164=, 0
	i32.store	$drop=, 0($0), $pop164
	i32.const	$3=, 0
.LBB2_16:                               # %lor.end.7
	end_block                       # label7:
	i32.const	$push170=, 0
	i32.store	$drop=, g($pop170), $3
	i32.const	$push169=, 0
	i32.store16	$drop=, h($pop169), $1
	i32.const	$push168=, 0
	i32.store8	$drop=, e($pop168), $2
	i32.const	$push167=, 0
	i32.const	$push74=, 226
	i32.store8	$drop=, b($pop167), $pop74
	i32.call	$drop=, getpid@FUNCTION
	i32.const	$push166=, 0
	return  	$pop166
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	1
c:
	.int16	0                       # 0x0
	.size	c, 2

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
b:
	.int8	0                       # 0x0
	.size	b, 1

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	1
h:
	.int16	0                       # 0x0
	.size	h, 2

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4


	.ident	"clang version 3.9.0 "
