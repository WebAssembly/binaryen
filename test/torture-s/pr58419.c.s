	.text
	.file	"pr58419.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.sub 	$push0=, $0, $1
	i32.const	$push1=, 24
	i32.shl 	$push2=, $pop0, $pop1
	i32.const	$push4=, 24
	i32.shr_s	$push3=, $pop2, $pop4
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# %bb.0:                                # %entry
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push50=, 0
	i32.const	$push0=, 234
	i32.store8	b($pop50), $pop0
	i32.const	$push49=, 0
	i32.load16_u	$3=, c($pop49)
	i32.const	$push48=, 0
	i32.load	$4=, k($pop48)
	i32.const	$push47=, 0
	i32.load	$2=, i($pop47)
	i32.const	$5=, 1
	i32.const	$push46=, 0
	i32.load	$0=, p($pop46)
	i32.const	$1=, 1
	block   	
	i32.const	$push45=, 0
	i32.ne  	$push2=, $4, $pop45
	i32.const	$push44=, 0
	i32.ne  	$push1=, $3, $pop44
	i32.and 	$push3=, $pop2, $pop1
	i32.const	$push43=, 1
	i32.lt_s	$push4=, $2, $pop43
	i32.sub 	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %lor.rhs
	i32.const	$push55=, 0
	i32.store	0($0), $pop55
	i32.const	$3=, 1
	i32.const	$push54=, 0
	i32.const	$push53=, 1
	i32.store16	c($pop54), $pop53
	i32.const	$push52=, 0
	i32.load	$2=, i($pop52)
	i32.const	$push51=, 0
	i32.load	$4=, k($pop51)
	i32.const	$1=, 0
.LBB2_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push59=, 0
	i32.store	g($pop59), $1
	block   	
	i32.const	$push58=, 0
	i32.ne  	$push7=, $4, $pop58
	i32.const	$push57=, 0
	i32.ne  	$push6=, $3, $pop57
	i32.and 	$push8=, $pop7, $pop6
	i32.const	$push56=, 1
	i32.lt_s	$push9=, $2, $pop56
	i32.sub 	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label1
# %bb.3:                                # %lor.rhs.1
	i32.const	$5=, 0
	i32.const	$push64=, 0
	i32.store	0($0), $pop64
	i32.const	$3=, 1
	i32.const	$push63=, 0
	i32.const	$push62=, 1
	i32.store16	c($pop63), $pop62
	i32.const	$push61=, 0
	i32.load	$2=, i($pop61)
	i32.const	$push60=, 0
	i32.load	$4=, k($pop60)
.LBB2_4:                                # %lor.end.1
	end_block                       # label1:
	i32.const	$push68=, 0
	i32.store	g($pop68), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block   	
	i32.const	$push67=, 0
	i32.ne  	$push12=, $4, $pop67
	i32.const	$push66=, 0
	i32.ne  	$push11=, $3, $pop66
	i32.and 	$push13=, $pop12, $pop11
	i32.const	$push65=, 1
	i32.lt_s	$push14=, $2, $pop65
	i32.sub 	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label2
# %bb.5:                                # %lor.rhs.2
	i32.const	$push73=, 0
	i32.store	0($0), $pop73
	i32.const	$3=, 1
	i32.const	$push72=, 0
	i32.const	$push71=, 1
	i32.store16	c($pop72), $pop71
	i32.const	$push70=, 0
	i32.load	$2=, i($pop70)
	i32.const	$push69=, 0
	i32.load	$4=, k($pop69)
	i32.const	$1=, 0
.LBB2_6:                                # %lor.end.2
	end_block                       # label2:
	i32.const	$push77=, 0
	i32.store	g($pop77), $1
	block   	
	i32.const	$push76=, 0
	i32.ne  	$push17=, $4, $pop76
	i32.const	$push75=, 0
	i32.ne  	$push16=, $3, $pop75
	i32.and 	$push18=, $pop17, $pop16
	i32.const	$push74=, 1
	i32.lt_s	$push19=, $2, $pop74
	i32.sub 	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label3
# %bb.7:                                # %lor.rhs.3
	i32.const	$5=, 0
	i32.const	$push82=, 0
	i32.store	0($0), $pop82
	i32.const	$3=, 1
	i32.const	$push81=, 0
	i32.const	$push80=, 1
	i32.store16	c($pop81), $pop80
	i32.const	$push79=, 0
	i32.load	$2=, i($pop79)
	i32.const	$push78=, 0
	i32.load	$4=, k($pop78)
.LBB2_8:                                # %lor.end.3
	end_block                       # label3:
	i32.const	$push86=, 0
	i32.store	g($pop86), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block   	
	i32.const	$push85=, 0
	i32.ne  	$push22=, $4, $pop85
	i32.const	$push84=, 0
	i32.ne  	$push21=, $3, $pop84
	i32.and 	$push23=, $pop22, $pop21
	i32.const	$push83=, 1
	i32.lt_s	$push24=, $2, $pop83
	i32.sub 	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label4
# %bb.9:                                # %lor.rhs.4
	i32.const	$push91=, 0
	i32.store	0($0), $pop91
	i32.const	$3=, 1
	i32.const	$push90=, 0
	i32.const	$push89=, 1
	i32.store16	c($pop90), $pop89
	i32.const	$push88=, 0
	i32.load	$2=, i($pop88)
	i32.const	$push87=, 0
	i32.load	$4=, k($pop87)
	i32.const	$1=, 0
.LBB2_10:                               # %lor.end.4
	end_block                       # label4:
	i32.const	$push95=, 0
	i32.store	g($pop95), $1
	block   	
	i32.const	$push94=, 0
	i32.ne  	$push27=, $4, $pop94
	i32.const	$push93=, 0
	i32.ne  	$push26=, $3, $pop93
	i32.and 	$push28=, $pop27, $pop26
	i32.const	$push92=, 1
	i32.lt_s	$push29=, $2, $pop92
	i32.sub 	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label5
# %bb.11:                               # %lor.rhs.5
	i32.const	$5=, 0
	i32.const	$push100=, 0
	i32.store	0($0), $pop100
	i32.const	$3=, 1
	i32.const	$push99=, 0
	i32.const	$push98=, 1
	i32.store16	c($pop99), $pop98
	i32.const	$push97=, 0
	i32.load	$2=, i($pop97)
	i32.const	$push96=, 0
	i32.load	$4=, k($pop96)
.LBB2_12:                               # %lor.end.5
	end_block                       # label5:
	i32.const	$push104=, 0
	i32.store	g($pop104), $5
	i32.const	$5=, 1
	i32.const	$1=, 1
	block   	
	i32.const	$push103=, 0
	i32.ne  	$push32=, $4, $pop103
	i32.const	$push102=, 0
	i32.ne  	$push31=, $3, $pop102
	i32.and 	$push33=, $pop32, $pop31
	i32.const	$push101=, 1
	i32.lt_s	$push34=, $2, $pop101
	i32.sub 	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label6
# %bb.13:                               # %lor.rhs.6
	i32.const	$push109=, 0
	i32.store	0($0), $pop109
	i32.const	$3=, 1
	i32.const	$push108=, 0
	i32.const	$push107=, 1
	i32.store16	c($pop108), $pop107
	i32.const	$push106=, 0
	i32.load	$2=, i($pop106)
	i32.const	$push105=, 0
	i32.load	$4=, k($pop105)
	i32.const	$1=, 0
.LBB2_14:                               # %lor.end.6
	end_block                       # label6:
	i32.const	$push114=, 0
	i32.store	g($pop114), $1
	i32.const	$push113=, 0
	i32.ne  	$push37=, $4, $pop113
	i32.const	$push112=, 0
	i32.ne  	$push36=, $3, $pop112
	i32.and 	$3=, $pop37, $pop36
	i32.const	$push111=, 0
	i32.load	$4=, a($pop111)
	block   	
	i32.const	$push110=, 1
	i32.lt_s	$push38=, $2, $pop110
	i32.sub 	$push39=, $3, $pop38
	br_if   	0, $pop39       # 0: down to label7
# %bb.15:                               # %lor.rhs.7
	i32.const	$5=, 0
	i32.const	$push116=, 0
	i32.store	0($0), $pop116
	i32.const	$push115=, 0
	i32.const	$push40=, 1
	i32.store16	c($pop115), $pop40
.LBB2_16:                               # %lor.end.7
	end_block                       # label7:
	i32.const	$push41=, 0
	i32.store16	h($pop41), $4
	i32.const	$push120=, 0
	i32.store	g($pop120), $5
	i32.const	$push119=, 0
	i32.store8	e($pop119), $3
	i32.const	$push118=, 0
	i32.const	$push42=, 226
	i32.store8	b($pop118), $pop42
	i32.call	$drop=, getpid@FUNCTION
	i32.const	$push117=, 0
                                        # fallthrough-return: $pop117
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	getpid, i32
