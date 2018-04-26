	.text
	.file	"pr58431.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push0=, k($pop22)
	i32.store	g($pop23), $pop0
	i32.const	$2=, 1
	i32.const	$push21=, 0
	i32.load16_u	$push1=, i($pop21)
	i32.const	$push20=, 1
	i32.xor 	$1=, $pop1, $pop20
	i32.const	$push19=, 0
	i32.store16	i($pop19), $1
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.store	b($pop18), $pop17
	i32.const	$push2=, 24
	i32.shl 	$push3=, $1, $pop2
	i32.const	$push16=, 24
	i32.shr_s	$1=, $pop3, $pop16
	i32.const	$push15=, 0
	i32.load8_s	$0=, a($pop15)
	block   	
	i32.const	$push14=, 0
	i32.load	$push4=, j($pop14)
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %lor.rhs
	i32.const	$push25=, 0
	i32.load	$push5=, c($pop25)
	i32.const	$push24=, 0
	i32.ne  	$2=, $pop5, $pop24
.LBB0_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push26=, 0
	i32.store	j($pop26), $2
	block   	
	block   	
	i32.eq  	$push6=, $1, $0
	br_if   	0, $pop6        # 0: down to label2
# %bb.3:                                # %if.then
	block   	
	i32.const	$push28=, 0
	i32.load	$push7=, d($pop28)
	i32.const	$push27=, 0
	i32.gt_s	$push8=, $pop7, $pop27
	br_if   	0, $pop8        # 0: down to label3
# %bb.4:                                # %for.inc.lr.ph
	i32.const	$push29=, 0
	i32.const	$push9=, 1
	i32.store	d($pop29), $pop9
.LBB0_5:                                # %if.end
	end_block                       # label3:
	i32.const	$push31=, 0
	i32.const	$push10=, 1
	i32.store	b($pop31), $pop10
	i32.const	$push30=, 0
	i32.load8_u	$push11=, h($pop30)
	br_if   	1, $pop11       # 1: down to label1
# %bb.6:                                # %if.end27
	i32.const	$push12=, 0
	return  	$pop12
.LBB0_7:                                # %if.else
	end_block                       # label2:
	i32.const	$push34=, 0
	i32.const	$push33=, 1
	i32.store8	h($pop34), $pop33
	block   	
	i32.const	$push32=, 0
	i32.load	$push13=, e($pop32)
	i32.eqz 	$push39=, $pop13
	br_if   	0, $pop39       # 0: down to label4
# %bb.8:                                # %for.inc17.lr.ph
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.store	e($pop36), $pop35
.LBB0_9:                                # %if.end.thread
	end_block                       # label4:
	i32.const	$push38=, 0
	i32.const	$push37=, 1
	i32.store	b($pop38), $pop37
.LBB0_10:                               # %if.then26
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	1
i:
	.int16	0                       # 0x0
	.size	i, 2

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
a:
	.int8	0                       # 0x0
	.size	a, 1

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
h:
	.int8	0                       # 0x0
	.size	h, 1

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
