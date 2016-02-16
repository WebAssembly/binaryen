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
	i32.const	$push87=, 0
	i32.load	$0=, p($pop87)
	i32.const	$push86=, 0
	i32.load16_u	$2=, c($pop86)
	i32.const	$push85=, 0
	i32.const	$push0=, 234
	i32.store8	$discard=, b($pop85), $pop0
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push94=, 0
	i32.load	$push1=, k($pop94)
	i32.const	$push93=, 0
	i32.ne  	$push4=, $pop1, $pop93
	i32.const	$push92=, 65535
	i32.and 	$push2=, $2, $pop92
	i32.const	$push91=, 0
	i32.ne  	$push3=, $pop2, $pop91
	i32.and 	$push5=, $pop4, $pop3
	i32.const	$push90=, 0
	i32.load	$push6=, i($pop90)
	i32.const	$push89=, 1
	i32.lt_s	$push7=, $pop6, $pop89
	i32.sub 	$push8=, $pop5, $pop7
	i32.const	$push88=, 255
	i32.and 	$push9=, $pop8, $pop88
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.const	$push11=, 0
	i32.const	$push10=, 1
	i32.store16	$2=, c($pop11), $pop10
	i32.const	$push95=, 0
	i32.store	$1=, 0($0), $pop95
.LBB2_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push103=, 0
	i32.store	$discard=, g($pop103), $1
	block
	i32.const	$push102=, 0
	i32.load	$push12=, k($pop102)
	i32.const	$push101=, 0
	i32.ne  	$push15=, $pop12, $pop101
	i32.const	$push100=, 65535
	i32.and 	$push13=, $2, $pop100
	i32.const	$push99=, 0
	i32.ne  	$push14=, $pop13, $pop99
	i32.and 	$push16=, $pop15, $pop14
	i32.const	$push98=, 0
	i32.load	$push17=, i($pop98)
	i32.const	$push97=, 1
	i32.lt_s	$push18=, $pop17, $pop97
	i32.sub 	$push19=, $pop16, $pop18
	i32.const	$push96=, 255
	i32.and 	$push20=, $pop19, $pop96
	br_if   	0, $pop20       # 0: down to label1
# BB#3:                                 # %lor.rhs.1
	i32.const	$push105=, 0
	i32.const	$push21=, 1
	i32.store16	$2=, c($pop105), $pop21
	i32.const	$push104=, 0
	i32.store	$3=, 0($0), $pop104
.LBB2_4:                                # %lor.end.1
	end_block                       # label1:
	i32.const	$push113=, 0
	i32.store	$discard=, g($pop113), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push112=, 0
	i32.load	$push22=, k($pop112)
	i32.const	$push111=, 0
	i32.ne  	$push25=, $pop22, $pop111
	i32.const	$push110=, 65535
	i32.and 	$push23=, $2, $pop110
	i32.const	$push109=, 0
	i32.ne  	$push24=, $pop23, $pop109
	i32.and 	$push26=, $pop25, $pop24
	i32.const	$push108=, 0
	i32.load	$push27=, i($pop108)
	i32.const	$push107=, 1
	i32.lt_s	$push28=, $pop27, $pop107
	i32.sub 	$push29=, $pop26, $pop28
	i32.const	$push106=, 255
	i32.and 	$push30=, $pop29, $pop106
	br_if   	0, $pop30       # 0: down to label2
# BB#5:                                 # %lor.rhs.2
	i32.const	$push32=, 0
	i32.const	$push31=, 1
	i32.store16	$2=, c($pop32), $pop31
	i32.const	$push114=, 0
	i32.store	$1=, 0($0), $pop114
.LBB2_6:                                # %lor.end.2
	end_block                       # label2:
	i32.const	$push122=, 0
	i32.store	$discard=, g($pop122), $1
	block
	i32.const	$push121=, 0
	i32.load	$push33=, k($pop121)
	i32.const	$push120=, 0
	i32.ne  	$push36=, $pop33, $pop120
	i32.const	$push119=, 65535
	i32.and 	$push34=, $2, $pop119
	i32.const	$push118=, 0
	i32.ne  	$push35=, $pop34, $pop118
	i32.and 	$push37=, $pop36, $pop35
	i32.const	$push117=, 0
	i32.load	$push38=, i($pop117)
	i32.const	$push116=, 1
	i32.lt_s	$push39=, $pop38, $pop116
	i32.sub 	$push40=, $pop37, $pop39
	i32.const	$push115=, 255
	i32.and 	$push41=, $pop40, $pop115
	br_if   	0, $pop41       # 0: down to label3
# BB#7:                                 # %lor.rhs.3
	i32.const	$push124=, 0
	i32.const	$push42=, 1
	i32.store16	$2=, c($pop124), $pop42
	i32.const	$push123=, 0
	i32.store	$3=, 0($0), $pop123
.LBB2_8:                                # %lor.end.3
	end_block                       # label3:
	i32.const	$push132=, 0
	i32.store	$discard=, g($pop132), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push131=, 0
	i32.load	$push43=, k($pop131)
	i32.const	$push130=, 0
	i32.ne  	$push46=, $pop43, $pop130
	i32.const	$push129=, 65535
	i32.and 	$push44=, $2, $pop129
	i32.const	$push128=, 0
	i32.ne  	$push45=, $pop44, $pop128
	i32.and 	$push47=, $pop46, $pop45
	i32.const	$push127=, 0
	i32.load	$push48=, i($pop127)
	i32.const	$push126=, 1
	i32.lt_s	$push49=, $pop48, $pop126
	i32.sub 	$push50=, $pop47, $pop49
	i32.const	$push125=, 255
	i32.and 	$push51=, $pop50, $pop125
	br_if   	0, $pop51       # 0: down to label4
# BB#9:                                 # %lor.rhs.4
	i32.const	$push53=, 0
	i32.const	$push52=, 1
	i32.store16	$2=, c($pop53), $pop52
	i32.const	$push133=, 0
	i32.store	$1=, 0($0), $pop133
.LBB2_10:                               # %lor.end.4
	end_block                       # label4:
	i32.const	$push141=, 0
	i32.store	$discard=, g($pop141), $1
	block
	i32.const	$push140=, 0
	i32.load	$push54=, k($pop140)
	i32.const	$push139=, 0
	i32.ne  	$push57=, $pop54, $pop139
	i32.const	$push138=, 65535
	i32.and 	$push55=, $2, $pop138
	i32.const	$push137=, 0
	i32.ne  	$push56=, $pop55, $pop137
	i32.and 	$push58=, $pop57, $pop56
	i32.const	$push136=, 0
	i32.load	$push59=, i($pop136)
	i32.const	$push135=, 1
	i32.lt_s	$push60=, $pop59, $pop135
	i32.sub 	$push61=, $pop58, $pop60
	i32.const	$push134=, 255
	i32.and 	$push62=, $pop61, $pop134
	br_if   	0, $pop62       # 0: down to label5
# BB#11:                                # %lor.rhs.5
	i32.const	$push143=, 0
	i32.const	$push63=, 1
	i32.store16	$2=, c($pop143), $pop63
	i32.const	$push142=, 0
	i32.store	$3=, 0($0), $pop142
.LBB2_12:                               # %lor.end.5
	end_block                       # label5:
	i32.const	$push151=, 0
	i32.store	$discard=, g($pop151), $3
	i32.const	$3=, 1
	i32.const	$1=, 1
	block
	i32.const	$push150=, 0
	i32.load	$push64=, k($pop150)
	i32.const	$push149=, 0
	i32.ne  	$push67=, $pop64, $pop149
	i32.const	$push148=, 65535
	i32.and 	$push65=, $2, $pop148
	i32.const	$push147=, 0
	i32.ne  	$push66=, $pop65, $pop147
	i32.and 	$push68=, $pop67, $pop66
	i32.const	$push146=, 0
	i32.load	$push69=, i($pop146)
	i32.const	$push145=, 1
	i32.lt_s	$push70=, $pop69, $pop145
	i32.sub 	$push71=, $pop68, $pop70
	i32.const	$push144=, 255
	i32.and 	$push72=, $pop71, $pop144
	br_if   	0, $pop72       # 0: down to label6
# BB#13:                                # %lor.rhs.6
	i32.const	$push74=, 0
	i32.const	$push73=, 1
	i32.store16	$2=, c($pop74), $pop73
	i32.const	$push152=, 0
	i32.store	$1=, 0($0), $pop152
.LBB2_14:                               # %lor.end.6
	end_block                       # label6:
	i32.const	$push163=, 0
	i32.store	$discard=, g($pop163), $1
	i32.const	$push162=, 0
	i32.load	$1=, a($pop162)
	block
	i32.const	$push161=, 0
	i32.load	$push75=, k($pop161)
	i32.const	$push160=, 0
	i32.ne  	$push78=, $pop75, $pop160
	i32.const	$push159=, 65535
	i32.and 	$push76=, $2, $pop159
	i32.const	$push158=, 0
	i32.ne  	$push77=, $pop76, $pop158
	i32.and 	$push157=, $pop78, $pop77
	tee_local	$push156=, $2=, $pop157
	i32.const	$push155=, 0
	i32.load	$push79=, i($pop155)
	i32.const	$push154=, 1
	i32.lt_s	$push80=, $pop79, $pop154
	i32.sub 	$push81=, $pop156, $pop80
	i32.const	$push153=, 255
	i32.and 	$push82=, $pop81, $pop153
	br_if   	0, $pop82       # 0: down to label7
# BB#15:                                # %lor.rhs.7
	i32.const	$push165=, 0
	i32.const	$push83=, 1
	i32.store16	$discard=, c($pop165), $pop83
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
	i32.const	$push84=, 226
	i32.store8	$discard=, b($pop167), $pop84
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
