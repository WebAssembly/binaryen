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
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push1=, 1
	i32.store16	$drop=, c($pop2), $pop1
	i32.const	$push5=, 0
	i32.load	$push3=, p($pop5)
	i32.const	$push4=, 0
	i32.store	$push0=, 0($pop3), $pop4
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push66=, 0
	i32.const	$push1=, 234
	i32.store8	$drop=, b($pop66), $pop1
	i32.const	$5=, 1
	i32.const	$push65=, 0
	i32.load	$0=, p($pop65)
	i32.const	$1=, 1
	block
	i32.const	$push64=, 0
	i32.load	$push63=, k($pop64)
	tee_local	$push62=, $4=, $pop63
	i32.const	$push61=, 0
	i32.ne  	$push3=, $pop62, $pop61
	i32.const	$push60=, 0
	i32.load16_u	$push59=, c($pop60)
	tee_local	$push58=, $3=, $pop59
	i32.const	$push57=, 0
	i32.ne  	$push2=, $pop58, $pop57
	i32.and 	$push4=, $pop3, $pop2
	i32.const	$push56=, 0
	i32.load	$push55=, i($pop56)
	tee_local	$push54=, $2=, $pop55
	i32.const	$push53=, 1
	i32.lt_s	$push5=, $pop54, $pop53
	i32.sub 	$push6=, $pop4, $pop5
	i32.const	$push52=, 255
	i32.and 	$push7=, $pop6, $pop52
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.const	$3=, 1
	i32.const	$push70=, 0
	i32.store	$push69=, 0($0), $pop70
	tee_local	$push68=, $4=, $pop69
	i32.const	$push67=, 1
	i32.store16	$drop=, c($pop68), $pop67
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push75=, 0
	i32.store	$drop=, g($pop75), $1
	block
	i32.const	$push74=, 0
	i32.ne  	$push9=, $4, $pop74
	i32.const	$push73=, 0
	i32.ne  	$push8=, $3, $pop73
	i32.and 	$push10=, $pop9, $pop8
	i32.const	$push72=, 1
	i32.lt_s	$push11=, $2, $pop72
	i32.sub 	$push12=, $pop10, $pop11
	i32.const	$push71=, 255
	i32.and 	$push13=, $pop12, $pop71
	br_if   	0, $pop13       # 0: down to label1
# BB#3:                                 # %lor.rhs.1
	i32.const	$5=, 0
	i32.const	$3=, 1
	i32.const	$push79=, 0
	i32.store	$push78=, 0($0), $pop79
	tee_local	$push77=, $4=, $pop78
	i32.const	$push76=, 1
	i32.store16	$drop=, c($pop77), $pop76
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
.LBB2_4:                                # %lor.end.1
	end_block                       # label1:
	i32.const	$push84=, 0
	i32.store	$drop=, g($pop84), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block
	i32.const	$push83=, 0
	i32.ne  	$push15=, $4, $pop83
	i32.const	$push82=, 0
	i32.ne  	$push14=, $3, $pop82
	i32.and 	$push16=, $pop15, $pop14
	i32.const	$push81=, 1
	i32.lt_s	$push17=, $2, $pop81
	i32.sub 	$push18=, $pop16, $pop17
	i32.const	$push80=, 255
	i32.and 	$push19=, $pop18, $pop80
	br_if   	0, $pop19       # 0: down to label2
# BB#5:                                 # %lor.rhs.2
	i32.const	$3=, 1
	i32.const	$push88=, 0
	i32.store	$push87=, 0($0), $pop88
	tee_local	$push86=, $4=, $pop87
	i32.const	$push85=, 1
	i32.store16	$drop=, c($pop86), $pop85
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_6:                                # %lor.end.2
	end_block                       # label2:
	i32.const	$push93=, 0
	i32.store	$drop=, g($pop93), $1
	block
	i32.const	$push92=, 0
	i32.ne  	$push21=, $4, $pop92
	i32.const	$push91=, 0
	i32.ne  	$push20=, $3, $pop91
	i32.and 	$push22=, $pop21, $pop20
	i32.const	$push90=, 1
	i32.lt_s	$push23=, $2, $pop90
	i32.sub 	$push24=, $pop22, $pop23
	i32.const	$push89=, 255
	i32.and 	$push25=, $pop24, $pop89
	br_if   	0, $pop25       # 0: down to label3
# BB#7:                                 # %lor.rhs.3
	i32.const	$5=, 0
	i32.const	$3=, 1
	i32.const	$push97=, 0
	i32.store	$push96=, 0($0), $pop97
	tee_local	$push95=, $4=, $pop96
	i32.const	$push94=, 1
	i32.store16	$drop=, c($pop95), $pop94
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
.LBB2_8:                                # %lor.end.3
	end_block                       # label3:
	i32.const	$push102=, 0
	i32.store	$drop=, g($pop102), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block
	i32.const	$push101=, 0
	i32.ne  	$push27=, $4, $pop101
	i32.const	$push100=, 0
	i32.ne  	$push26=, $3, $pop100
	i32.and 	$push28=, $pop27, $pop26
	i32.const	$push99=, 1
	i32.lt_s	$push29=, $2, $pop99
	i32.sub 	$push30=, $pop28, $pop29
	i32.const	$push98=, 255
	i32.and 	$push31=, $pop30, $pop98
	br_if   	0, $pop31       # 0: down to label4
# BB#9:                                 # %lor.rhs.4
	i32.const	$3=, 1
	i32.const	$push106=, 0
	i32.store	$push105=, 0($0), $pop106
	tee_local	$push104=, $4=, $pop105
	i32.const	$push103=, 1
	i32.store16	$drop=, c($pop104), $pop103
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_10:                               # %lor.end.4
	end_block                       # label4:
	i32.const	$push111=, 0
	i32.store	$drop=, g($pop111), $1
	block
	i32.const	$push110=, 0
	i32.ne  	$push33=, $4, $pop110
	i32.const	$push109=, 0
	i32.ne  	$push32=, $3, $pop109
	i32.and 	$push34=, $pop33, $pop32
	i32.const	$push108=, 1
	i32.lt_s	$push35=, $2, $pop108
	i32.sub 	$push36=, $pop34, $pop35
	i32.const	$push107=, 255
	i32.and 	$push37=, $pop36, $pop107
	br_if   	0, $pop37       # 0: down to label5
# BB#11:                                # %lor.rhs.5
	i32.const	$5=, 0
	i32.const	$3=, 1
	i32.const	$push115=, 0
	i32.store	$push114=, 0($0), $pop115
	tee_local	$push113=, $4=, $pop114
	i32.const	$push112=, 1
	i32.store16	$drop=, c($pop113), $pop112
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
.LBB2_12:                               # %lor.end.5
	end_block                       # label5:
	i32.const	$push120=, 0
	i32.store	$drop=, g($pop120), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block
	i32.const	$push119=, 0
	i32.ne  	$push39=, $4, $pop119
	i32.const	$push118=, 0
	i32.ne  	$push38=, $3, $pop118
	i32.and 	$push40=, $pop39, $pop38
	i32.const	$push117=, 1
	i32.lt_s	$push41=, $2, $pop117
	i32.sub 	$push42=, $pop40, $pop41
	i32.const	$push116=, 255
	i32.and 	$push43=, $pop42, $pop116
	br_if   	0, $pop43       # 0: down to label6
# BB#13:                                # %lor.rhs.6
	i32.const	$3=, 1
	i32.const	$push124=, 0
	i32.store	$push123=, 0($0), $pop124
	tee_local	$push122=, $4=, $pop123
	i32.const	$push121=, 1
	i32.store16	$drop=, c($pop122), $pop121
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_14:                               # %lor.end.6
	end_block                       # label6:
	i32.const	$push132=, 0
	i32.store	$drop=, g($pop132), $1
	i32.const	$push131=, 0
	i32.load	$1=, a($pop131)
	block
	i32.const	$push130=, 0
	i32.ne  	$push45=, $4, $pop130
	i32.const	$push129=, 0
	i32.ne  	$push44=, $3, $pop129
	i32.and 	$push128=, $pop45, $pop44
	tee_local	$push127=, $4=, $pop128
	i32.const	$push126=, 1
	i32.lt_s	$push46=, $2, $pop126
	i32.sub 	$push47=, $pop127, $pop46
	i32.const	$push125=, 255
	i32.and 	$push48=, $pop47, $pop125
	br_if   	0, $pop48       # 0: down to label7
# BB#15:                                # %lor.rhs.7
	i32.const	$5=, 0
	i32.const	$push133=, 0
	i32.store	$push0=, 0($0), $pop133
	i32.const	$push49=, 1
	i32.store16	$drop=, c($pop0), $pop49
.LBB2_16:                               # %lor.end.7
	end_block                       # label7:
	i32.const	$push50=, 0
	i32.store16	$drop=, h($pop50), $1
	i32.const	$push137=, 0
	i32.store	$drop=, g($pop137), $5
	i32.const	$push136=, 0
	i32.store8	$drop=, e($pop136), $4
	i32.const	$push135=, 0
	i32.const	$push51=, 226
	i32.store8	$drop=, b($pop135), $pop51
	i32.call	$drop=, getpid@FUNCTION
	i32.const	$push134=, 0
                                        # fallthrough-return: $pop134
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
	.functype	getpid, i32
