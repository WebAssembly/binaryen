	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58419.c"
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
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store16	c($pop1), $pop0
	i32.const	$push5=, 0
	i32.load	$push2=, p($pop5)
	i32.const	$push4=, 0
	i32.store	0($pop2), $pop4
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
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
	i32.const	$push56=, 0
	i32.const	$push0=, 234
	i32.store8	b($pop56), $pop0
	i32.const	$5=, 1
	i32.const	$push55=, 0
	i32.load	$0=, p($pop55)
	i32.const	$1=, 1
	block   	
	i32.const	$push54=, 0
	i32.load	$push53=, k($pop54)
	tee_local	$push52=, $4=, $pop53
	i32.const	$push51=, 0
	i32.ne  	$push2=, $pop52, $pop51
	i32.const	$push50=, 0
	i32.load16_u	$push49=, c($pop50)
	tee_local	$push48=, $3=, $pop49
	i32.const	$push47=, 0
	i32.ne  	$push1=, $pop48, $pop47
	i32.and 	$push3=, $pop2, $pop1
	i32.const	$push46=, 0
	i32.load	$push45=, i($pop46)
	tee_local	$push44=, $2=, $pop45
	i32.const	$push43=, 1
	i32.lt_s	$push4=, $pop44, $pop43
	i32.sub 	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.const	$push61=, 0
	i32.store	0($0), $pop61
	i32.const	$3=, 1
	i32.const	$push60=, 0
	i32.const	$push59=, 1
	i32.store16	c($pop60), $pop59
	i32.const	$push58=, 0
	i32.load	$2=, i($pop58)
	i32.const	$push57=, 0
	i32.load	$4=, k($pop57)
	i32.const	$1=, 0
.LBB2_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push65=, 0
	i32.store	g($pop65), $1
	block   	
	i32.const	$push64=, 0
	i32.ne  	$push7=, $4, $pop64
	i32.const	$push63=, 0
	i32.ne  	$push6=, $3, $pop63
	i32.and 	$push8=, $pop7, $pop6
	i32.const	$push62=, 1
	i32.lt_s	$push9=, $2, $pop62
	i32.sub 	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#3:                                 # %lor.rhs.1
	i32.const	$5=, 0
	i32.const	$push70=, 0
	i32.store	0($0), $pop70
	i32.const	$3=, 1
	i32.const	$push69=, 0
	i32.const	$push68=, 1
	i32.store16	c($pop69), $pop68
	i32.const	$push67=, 0
	i32.load	$2=, i($pop67)
	i32.const	$push66=, 0
	i32.load	$4=, k($pop66)
.LBB2_4:                                # %lor.end.1
	end_block                       # label1:
	i32.const	$push74=, 0
	i32.store	g($pop74), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block   	
	i32.const	$push73=, 0
	i32.ne  	$push12=, $4, $pop73
	i32.const	$push72=, 0
	i32.ne  	$push11=, $3, $pop72
	i32.and 	$push13=, $pop12, $pop11
	i32.const	$push71=, 1
	i32.lt_s	$push14=, $2, $pop71
	i32.sub 	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label2
# BB#5:                                 # %lor.rhs.2
	i32.const	$push79=, 0
	i32.store	0($0), $pop79
	i32.const	$3=, 1
	i32.const	$push78=, 0
	i32.const	$push77=, 1
	i32.store16	c($pop78), $pop77
	i32.const	$push76=, 0
	i32.load	$2=, i($pop76)
	i32.const	$push75=, 0
	i32.load	$4=, k($pop75)
	i32.const	$1=, 0
.LBB2_6:                                # %lor.end.2
	end_block                       # label2:
	i32.const	$push83=, 0
	i32.store	g($pop83), $1
	block   	
	i32.const	$push82=, 0
	i32.ne  	$push17=, $4, $pop82
	i32.const	$push81=, 0
	i32.ne  	$push16=, $3, $pop81
	i32.and 	$push18=, $pop17, $pop16
	i32.const	$push80=, 1
	i32.lt_s	$push19=, $2, $pop80
	i32.sub 	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label3
# BB#7:                                 # %lor.rhs.3
	i32.const	$5=, 0
	i32.const	$push88=, 0
	i32.store	0($0), $pop88
	i32.const	$3=, 1
	i32.const	$push87=, 0
	i32.const	$push86=, 1
	i32.store16	c($pop87), $pop86
	i32.const	$push85=, 0
	i32.load	$2=, i($pop85)
	i32.const	$push84=, 0
	i32.load	$4=, k($pop84)
.LBB2_8:                                # %lor.end.3
	end_block                       # label3:
	i32.const	$push92=, 0
	i32.store	g($pop92), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block   	
	i32.const	$push91=, 0
	i32.ne  	$push22=, $4, $pop91
	i32.const	$push90=, 0
	i32.ne  	$push21=, $3, $pop90
	i32.and 	$push23=, $pop22, $pop21
	i32.const	$push89=, 1
	i32.lt_s	$push24=, $2, $pop89
	i32.sub 	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label4
# BB#9:                                 # %lor.rhs.4
	i32.const	$push97=, 0
	i32.store	0($0), $pop97
	i32.const	$3=, 1
	i32.const	$push96=, 0
	i32.const	$push95=, 1
	i32.store16	c($pop96), $pop95
	i32.const	$push94=, 0
	i32.load	$2=, i($pop94)
	i32.const	$push93=, 0
	i32.load	$4=, k($pop93)
	i32.const	$1=, 0
.LBB2_10:                               # %lor.end.4
	end_block                       # label4:
	i32.const	$push101=, 0
	i32.store	g($pop101), $1
	block   	
	i32.const	$push100=, 0
	i32.ne  	$push27=, $4, $pop100
	i32.const	$push99=, 0
	i32.ne  	$push26=, $3, $pop99
	i32.and 	$push28=, $pop27, $pop26
	i32.const	$push98=, 1
	i32.lt_s	$push29=, $2, $pop98
	i32.sub 	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label5
# BB#11:                                # %lor.rhs.5
	i32.const	$5=, 0
	i32.const	$push106=, 0
	i32.store	0($0), $pop106
	i32.const	$3=, 1
	i32.const	$push105=, 0
	i32.const	$push104=, 1
	i32.store16	c($pop105), $pop104
	i32.const	$push103=, 0
	i32.load	$2=, i($pop103)
	i32.const	$push102=, 0
	i32.load	$4=, k($pop102)
.LBB2_12:                               # %lor.end.5
	end_block                       # label5:
	i32.const	$push110=, 0
	i32.store	g($pop110), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block   	
	i32.const	$push109=, 0
	i32.ne  	$push32=, $4, $pop109
	i32.const	$push108=, 0
	i32.ne  	$push31=, $3, $pop108
	i32.and 	$push33=, $pop32, $pop31
	i32.const	$push107=, 1
	i32.lt_s	$push34=, $2, $pop107
	i32.sub 	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label6
# BB#13:                                # %lor.rhs.6
	i32.const	$push115=, 0
	i32.store	0($0), $pop115
	i32.const	$3=, 1
	i32.const	$push114=, 0
	i32.const	$push113=, 1
	i32.store16	c($pop114), $pop113
	i32.const	$push112=, 0
	i32.load	$2=, i($pop112)
	i32.const	$push111=, 0
	i32.load	$4=, k($pop111)
	i32.const	$1=, 0
.LBB2_14:                               # %lor.end.6
	end_block                       # label6:
	i32.const	$push122=, 0
	i32.store	g($pop122), $1
	i32.const	$push121=, 0
	i32.load	$1=, a($pop121)
	block   	
	i32.const	$push120=, 0
	i32.ne  	$push37=, $4, $pop120
	i32.const	$push119=, 0
	i32.ne  	$push36=, $3, $pop119
	i32.and 	$push118=, $pop37, $pop36
	tee_local	$push117=, $4=, $pop118
	i32.const	$push116=, 1
	i32.lt_s	$push38=, $2, $pop116
	i32.sub 	$push39=, $pop117, $pop38
	br_if   	0, $pop39       # 0: down to label7
# BB#15:                                # %lor.rhs.7
	i32.const	$5=, 0
	i32.const	$push124=, 0
	i32.store	0($0), $pop124
	i32.const	$push123=, 0
	i32.const	$push40=, 1
	i32.store16	c($pop123), $pop40
.LBB2_16:                               # %lor.end.7
	end_block                       # label7:
	i32.const	$push41=, 0
	i32.store16	h($pop41), $1
	i32.const	$push128=, 0
	i32.store	g($pop128), $5
	i32.const	$push127=, 0
	i32.store8	e($pop127), $4
	i32.const	$push126=, 0
	i32.const	$push42=, 226
	i32.store8	b($pop126), $pop42
	i32.call	$drop=, getpid@FUNCTION
	i32.const	$push125=, 0
                                        # fallthrough-return: $pop125
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	getpid, i32
