	.text
	.file	"pr58984.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push13=, 0
	i32.load	$push0=, e($pop13)
	i32.const	$push12=, 1
	i32.gt_s	$push1=, $pop0, $pop12
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.i
	i32.const	$push15=, 0
	i32.load	$0=, c($pop15)
	i32.load	$push2=, 0($0)
	i32.const	$push14=, 1
	i32.xor 	$push3=, $pop2, $pop14
	i32.store	0($0), $pop3
.LBB0_2:                                # %foo.exit
	end_block                       # label0:
	i32.const	$push19=, 0
	i32.const	$push18=, 1
	i32.store	m($pop19), $pop18
	block   	
	i32.const	$push17=, 0
	i32.load	$push4=, a($pop17)
	i32.const	$push16=, 1
	i32.ne  	$push5=, $pop4, $pop16
	br_if   	0, $pop5        # 0: down to label1
# %bb.3:                                # %bar.exit
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.store	e($pop26), $pop25
	i32.const	$push24=, 0
	i32.load	$0=, c($pop24)
	i32.load	$push6=, 0($0)
	i32.const	$push7=, 1
	i32.xor 	$push8=, $pop6, $pop7
	i32.store	0($0), $pop8
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push9=, m($pop22)
	i32.const	$push21=, 1
	i32.or  	$push10=, $pop9, $pop21
	i32.store	m($pop23), $pop10
	i32.const	$push20=, 0
	i32.load	$push11=, a($pop20)
	br_if   	0, $pop11       # 0: down to label1
# %bb.4:                                # %if.end11
	i32.const	$push27=, 0
	return  	$pop27
.LBB0_5:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	a
	.size	c, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.hidden	m                       # @m
	.type	m,@object
	.section	.bss.m,"aw",@nobits
	.globl	m
	.p2align	2
m:
	.int32	0                       # 0x0
	.size	m, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
