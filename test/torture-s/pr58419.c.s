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
	i32.const	$push1=, 0
	i32.load	$push2=, p($pop1)
	i32.const	$push4=, 0
	i32.store	$0=, 0($pop2), $pop4
	i32.const	$push3=, 0
	i32.const	$push0=, 1
	i32.store16	$discard=, c($pop3), $pop0
	return  	$0
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
	i32.const	$push88=, 0
	i32.load	$0=, p($pop88)
	i32.const	$push87=, 0
	i32.load16_u	$2=, c($pop87)
	i32.const	$push86=, 0
	i32.const	$push1=, 234
	i32.store8	$discard=, b($pop86), $pop1
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push95=, 0
	i32.load	$push2=, k($pop95)
	i32.const	$push94=, 0
	i32.ne  	$push5=, $pop2, $pop94
	i32.const	$push93=, 65535
	i32.and 	$push3=, $2, $pop93
	i32.const	$push92=, 0
	i32.ne  	$push4=, $pop3, $pop92
	i32.and 	$push6=, $pop5, $pop4
	i32.const	$push91=, 0
	i32.load	$push7=, i($pop91)
	i32.const	$push90=, 1
	i32.lt_s	$push8=, $pop7, $pop90
	i32.sub 	$push9=, $pop6, $pop8
	i32.const	$push89=, 255
	i32.and 	$push10=, $pop9, $pop89
	br_if   	$pop10, 0       # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.const	$push12=, 0
	i32.const	$push11=, 1
	i32.store16	$2=, c($pop12), $pop11
	i32.const	$push96=, 0
	i32.store	$1=, 0($0), $pop96
.LBB2_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push104=, 0
	i32.store	$discard=, g($pop104), $1
	block
	i32.const	$push103=, 0
	i32.load	$push13=, k($pop103)
	i32.const	$push102=, 0
	i32.ne  	$push16=, $pop13, $pop102
	i32.const	$push101=, 65535
	i32.and 	$push14=, $2, $pop101
	i32.const	$push100=, 0
	i32.ne  	$push15=, $pop14, $pop100
	i32.and 	$push17=, $pop16, $pop15
	i32.const	$push99=, 0
	i32.load	$push18=, i($pop99)
	i32.const	$push98=, 1
	i32.lt_s	$push19=, $pop18, $pop98
	i32.sub 	$push20=, $pop17, $pop19
	i32.const	$push97=, 255
	i32.and 	$push21=, $pop20, $pop97
	br_if   	$pop21, 0       # 0: down to label1
# BB#3:                                 # %lor.rhs.1
	i32.const	$push106=, 0
	i32.const	$push22=, 1
	i32.store16	$2=, c($pop106), $pop22
	i32.const	$push105=, 0
	i32.store	$3=, 0($0), $pop105
.LBB2_4:                                # %lor.end.1
	end_block                       # label1:
	i32.const	$push114=, 0
	i32.store	$discard=, g($pop114), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push113=, 0
	i32.load	$push23=, k($pop113)
	i32.const	$push112=, 0
	i32.ne  	$push26=, $pop23, $pop112
	i32.const	$push111=, 65535
	i32.and 	$push24=, $2, $pop111
	i32.const	$push110=, 0
	i32.ne  	$push25=, $pop24, $pop110
	i32.and 	$push27=, $pop26, $pop25
	i32.const	$push109=, 0
	i32.load	$push28=, i($pop109)
	i32.const	$push108=, 1
	i32.lt_s	$push29=, $pop28, $pop108
	i32.sub 	$push30=, $pop27, $pop29
	i32.const	$push107=, 255
	i32.and 	$push31=, $pop30, $pop107
	br_if   	$pop31, 0       # 0: down to label2
# BB#5:                                 # %lor.rhs.2
	i32.const	$push33=, 0
	i32.const	$push32=, 1
	i32.store16	$2=, c($pop33), $pop32
	i32.const	$push115=, 0
	i32.store	$1=, 0($0), $pop115
.LBB2_6:                                # %lor.end.2
	end_block                       # label2:
	i32.const	$push123=, 0
	i32.store	$discard=, g($pop123), $1
	block
	i32.const	$push122=, 0
	i32.load	$push34=, k($pop122)
	i32.const	$push121=, 0
	i32.ne  	$push37=, $pop34, $pop121
	i32.const	$push120=, 65535
	i32.and 	$push35=, $2, $pop120
	i32.const	$push119=, 0
	i32.ne  	$push36=, $pop35, $pop119
	i32.and 	$push38=, $pop37, $pop36
	i32.const	$push118=, 0
	i32.load	$push39=, i($pop118)
	i32.const	$push117=, 1
	i32.lt_s	$push40=, $pop39, $pop117
	i32.sub 	$push41=, $pop38, $pop40
	i32.const	$push116=, 255
	i32.and 	$push42=, $pop41, $pop116
	br_if   	$pop42, 0       # 0: down to label3
# BB#7:                                 # %lor.rhs.3
	i32.const	$push125=, 0
	i32.const	$push43=, 1
	i32.store16	$2=, c($pop125), $pop43
	i32.const	$push124=, 0
	i32.store	$3=, 0($0), $pop124
.LBB2_8:                                # %lor.end.3
	end_block                       # label3:
	i32.const	$push133=, 0
	i32.store	$discard=, g($pop133), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push132=, 0
	i32.load	$push44=, k($pop132)
	i32.const	$push131=, 0
	i32.ne  	$push47=, $pop44, $pop131
	i32.const	$push130=, 65535
	i32.and 	$push45=, $2, $pop130
	i32.const	$push129=, 0
	i32.ne  	$push46=, $pop45, $pop129
	i32.and 	$push48=, $pop47, $pop46
	i32.const	$push128=, 0
	i32.load	$push49=, i($pop128)
	i32.const	$push127=, 1
	i32.lt_s	$push50=, $pop49, $pop127
	i32.sub 	$push51=, $pop48, $pop50
	i32.const	$push126=, 255
	i32.and 	$push52=, $pop51, $pop126
	br_if   	$pop52, 0       # 0: down to label4
# BB#9:                                 # %lor.rhs.4
	i32.const	$push54=, 0
	i32.const	$push53=, 1
	i32.store16	$2=, c($pop54), $pop53
	i32.const	$push134=, 0
	i32.store	$1=, 0($0), $pop134
.LBB2_10:                               # %lor.end.4
	end_block                       # label4:
	i32.const	$push142=, 0
	i32.store	$discard=, g($pop142), $1
	block
	i32.const	$push141=, 0
	i32.load	$push55=, k($pop141)
	i32.const	$push140=, 0
	i32.ne  	$push58=, $pop55, $pop140
	i32.const	$push139=, 65535
	i32.and 	$push56=, $2, $pop139
	i32.const	$push138=, 0
	i32.ne  	$push57=, $pop56, $pop138
	i32.and 	$push59=, $pop58, $pop57
	i32.const	$push137=, 0
	i32.load	$push60=, i($pop137)
	i32.const	$push136=, 1
	i32.lt_s	$push61=, $pop60, $pop136
	i32.sub 	$push62=, $pop59, $pop61
	i32.const	$push135=, 255
	i32.and 	$push63=, $pop62, $pop135
	br_if   	$pop63, 0       # 0: down to label5
# BB#11:                                # %lor.rhs.5
	i32.const	$push144=, 0
	i32.const	$push64=, 1
	i32.store16	$2=, c($pop144), $pop64
	i32.const	$push143=, 0
	i32.store	$3=, 0($0), $pop143
.LBB2_12:                               # %lor.end.5
	end_block                       # label5:
	i32.const	$push152=, 0
	i32.store	$discard=, g($pop152), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push151=, 0
	i32.load	$push65=, k($pop151)
	i32.const	$push150=, 0
	i32.ne  	$push68=, $pop65, $pop150
	i32.const	$push149=, 65535
	i32.and 	$push66=, $2, $pop149
	i32.const	$push148=, 0
	i32.ne  	$push67=, $pop66, $pop148
	i32.and 	$push69=, $pop68, $pop67
	i32.const	$push147=, 0
	i32.load	$push70=, i($pop147)
	i32.const	$push146=, 1
	i32.lt_s	$push71=, $pop70, $pop146
	i32.sub 	$push72=, $pop69, $pop71
	i32.const	$push145=, 255
	i32.and 	$push73=, $pop72, $pop145
	br_if   	$pop73, 0       # 0: down to label6
# BB#13:                                # %lor.rhs.6
	i32.const	$push75=, 0
	i32.const	$push74=, 1
	i32.store16	$2=, c($pop75), $pop74
	i32.const	$push153=, 0
	i32.store	$1=, 0($0), $pop153
.LBB2_14:                               # %lor.end.6
	end_block                       # label6:
	i32.const	$push163=, 0
	i32.store	$discard=, g($pop163), $1
	i32.const	$push162=, 0
	i32.load	$1=, a($pop162)
	block
	i32.const	$push161=, 0
	i32.load	$push76=, k($pop161)
	i32.const	$push160=, 0
	i32.ne  	$push79=, $pop76, $pop160
	i32.const	$push159=, 65535
	i32.and 	$push77=, $2, $pop159
	i32.const	$push158=, 0
	i32.ne  	$push78=, $pop77, $pop158
	i32.and 	$push0=, $pop79, $pop78
	tee_local	$push157=, $2=, $pop0
	i32.const	$push156=, 0
	i32.load	$push80=, i($pop156)
	i32.const	$push155=, 1
	i32.lt_s	$push81=, $pop80, $pop155
	i32.sub 	$push82=, $pop157, $pop81
	i32.const	$push154=, 255
	i32.and 	$push83=, $pop82, $pop154
	br_if   	$pop83, 0       # 0: down to label7
# BB#15:                                # %lor.rhs.7
	i32.const	$push165=, 0
	i32.const	$push84=, 1
	i32.store16	$discard=, c($pop165), $pop84
	i32.const	$push164=, 0
	i32.store	$3=, 0($0), $pop164
.LBB2_16:                               # %lor.end.7
	end_block                       # label7:
	i32.const	$push170=, 0
	i32.store	$discard=, g($pop170), $3
	i32.const	$push169=, 0
	i32.store16	$discard=, h($pop169), $1
	i32.const	$push168=, 0
	i32.store8	$discard=, e($pop168), $2
	i32.const	$push167=, 0
	i32.const	$push85=, 226
	i32.store8	$discard=, b($pop167), $pop85
	i32.call	$discard=, getpid@FUNCTION
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
