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
	i32.const	$push57=, 0
	i32.const	$push1=, 234
	i32.store8	$drop=, b($pop57), $pop1
	i32.const	$5=, 1
	i32.const	$push56=, 0
	i32.load	$0=, p($pop56)
	i32.const	$1=, 1
	block
	i32.const	$push55=, 0
	i32.load	$push54=, k($pop55)
	tee_local	$push53=, $4=, $pop54
	i32.const	$push52=, 0
	i32.ne  	$push3=, $pop53, $pop52
	i32.const	$push51=, 0
	i32.load16_u	$push50=, c($pop51)
	tee_local	$push49=, $3=, $pop50
	i32.const	$push48=, 0
	i32.ne  	$push2=, $pop49, $pop48
	i32.and 	$push4=, $pop3, $pop2
	i32.const	$push47=, 0
	i32.load	$push46=, i($pop47)
	tee_local	$push45=, $2=, $pop46
	i32.const	$push44=, 1
	i32.lt_s	$push5=, $pop45, $pop44
	i32.sub 	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.const	$3=, 1
	i32.const	$push61=, 0
	i32.store	$push60=, 0($0), $pop61
	tee_local	$push59=, $4=, $pop60
	i32.const	$push58=, 1
	i32.store16	$drop=, c($pop59), $pop58
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push65=, 0
	i32.store	$drop=, g($pop65), $1
	block
	i32.const	$push64=, 0
	i32.ne  	$push8=, $4, $pop64
	i32.const	$push63=, 0
	i32.ne  	$push7=, $3, $pop63
	i32.and 	$push9=, $pop8, $pop7
	i32.const	$push62=, 1
	i32.lt_s	$push10=, $2, $pop62
	i32.sub 	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#3:                                 # %lor.rhs.1
	i32.const	$5=, 0
	i32.const	$3=, 1
	i32.const	$push69=, 0
	i32.store	$push68=, 0($0), $pop69
	tee_local	$push67=, $4=, $pop68
	i32.const	$push66=, 1
	i32.store16	$drop=, c($pop67), $pop66
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
.LBB2_4:                                # %lor.end.1
	end_block                       # label1:
	i32.const	$push73=, 0
	i32.store	$drop=, g($pop73), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block
	i32.const	$push72=, 0
	i32.ne  	$push13=, $4, $pop72
	i32.const	$push71=, 0
	i32.ne  	$push12=, $3, $pop71
	i32.and 	$push14=, $pop13, $pop12
	i32.const	$push70=, 1
	i32.lt_s	$push15=, $2, $pop70
	i32.sub 	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label2
# BB#5:                                 # %lor.rhs.2
	i32.const	$3=, 1
	i32.const	$push77=, 0
	i32.store	$push76=, 0($0), $pop77
	tee_local	$push75=, $4=, $pop76
	i32.const	$push74=, 1
	i32.store16	$drop=, c($pop75), $pop74
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_6:                                # %lor.end.2
	end_block                       # label2:
	i32.const	$push81=, 0
	i32.store	$drop=, g($pop81), $1
	block
	i32.const	$push80=, 0
	i32.ne  	$push18=, $4, $pop80
	i32.const	$push79=, 0
	i32.ne  	$push17=, $3, $pop79
	i32.and 	$push19=, $pop18, $pop17
	i32.const	$push78=, 1
	i32.lt_s	$push20=, $2, $pop78
	i32.sub 	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label3
# BB#7:                                 # %lor.rhs.3
	i32.const	$5=, 0
	i32.const	$3=, 1
	i32.const	$push85=, 0
	i32.store	$push84=, 0($0), $pop85
	tee_local	$push83=, $4=, $pop84
	i32.const	$push82=, 1
	i32.store16	$drop=, c($pop83), $pop82
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
.LBB2_8:                                # %lor.end.3
	end_block                       # label3:
	i32.const	$push89=, 0
	i32.store	$drop=, g($pop89), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block
	i32.const	$push88=, 0
	i32.ne  	$push23=, $4, $pop88
	i32.const	$push87=, 0
	i32.ne  	$push22=, $3, $pop87
	i32.and 	$push24=, $pop23, $pop22
	i32.const	$push86=, 1
	i32.lt_s	$push25=, $2, $pop86
	i32.sub 	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label4
# BB#9:                                 # %lor.rhs.4
	i32.const	$3=, 1
	i32.const	$push93=, 0
	i32.store	$push92=, 0($0), $pop93
	tee_local	$push91=, $4=, $pop92
	i32.const	$push90=, 1
	i32.store16	$drop=, c($pop91), $pop90
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_10:                               # %lor.end.4
	end_block                       # label4:
	i32.const	$push97=, 0
	i32.store	$drop=, g($pop97), $1
	block
	i32.const	$push96=, 0
	i32.ne  	$push28=, $4, $pop96
	i32.const	$push95=, 0
	i32.ne  	$push27=, $3, $pop95
	i32.and 	$push29=, $pop28, $pop27
	i32.const	$push94=, 1
	i32.lt_s	$push30=, $2, $pop94
	i32.sub 	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label5
# BB#11:                                # %lor.rhs.5
	i32.const	$5=, 0
	i32.const	$3=, 1
	i32.const	$push101=, 0
	i32.store	$push100=, 0($0), $pop101
	tee_local	$push99=, $4=, $pop100
	i32.const	$push98=, 1
	i32.store16	$drop=, c($pop99), $pop98
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
.LBB2_12:                               # %lor.end.5
	end_block                       # label5:
	i32.const	$push105=, 0
	i32.store	$drop=, g($pop105), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block
	i32.const	$push104=, 0
	i32.ne  	$push33=, $4, $pop104
	i32.const	$push103=, 0
	i32.ne  	$push32=, $3, $pop103
	i32.and 	$push34=, $pop33, $pop32
	i32.const	$push102=, 1
	i32.lt_s	$push35=, $2, $pop102
	i32.sub 	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label6
# BB#13:                                # %lor.rhs.6
	i32.const	$3=, 1
	i32.const	$push109=, 0
	i32.store	$push108=, 0($0), $pop109
	tee_local	$push107=, $4=, $pop108
	i32.const	$push106=, 1
	i32.store16	$drop=, c($pop107), $pop106
	i32.load	$2=, i($4)
	i32.load	$4=, k($4)
	i32.const	$1=, 0
.LBB2_14:                               # %lor.end.6
	end_block                       # label6:
	i32.const	$push116=, 0
	i32.store	$drop=, g($pop116), $1
	i32.const	$push115=, 0
	i32.load	$1=, a($pop115)
	block
	i32.const	$push114=, 0
	i32.ne  	$push38=, $4, $pop114
	i32.const	$push113=, 0
	i32.ne  	$push37=, $3, $pop113
	i32.and 	$push112=, $pop38, $pop37
	tee_local	$push111=, $4=, $pop112
	i32.const	$push110=, 1
	i32.lt_s	$push39=, $2, $pop110
	i32.sub 	$push40=, $pop111, $pop39
	br_if   	0, $pop40       # 0: down to label7
# BB#15:                                # %lor.rhs.7
	i32.const	$5=, 0
	i32.const	$push117=, 0
	i32.store	$push0=, 0($0), $pop117
	i32.const	$push41=, 1
	i32.store16	$drop=, c($pop0), $pop41
.LBB2_16:                               # %lor.end.7
	end_block                       # label7:
	i32.const	$push42=, 0
	i32.store16	$drop=, h($pop42), $1
	i32.const	$push121=, 0
	i32.store	$drop=, g($pop121), $5
	i32.const	$push120=, 0
	i32.store8	$drop=, e($pop120), $4
	i32.const	$push119=, 0
	i32.const	$push43=, 226
	i32.store8	$drop=, b($pop119), $pop43
	i32.call	$drop=, getpid@FUNCTION
	i32.const	$push118=, 0
                                        # fallthrough-return: $pop118
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


	.ident	"clang version 4.0.0 "
	.functype	getpid, i32
