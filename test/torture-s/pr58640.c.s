	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58640.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push9=, 0
	i32.load	$push0=, b($pop9)
	i32.const	$push8=, 0
	i32.gt_s	$push1=, $pop0, $pop8
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %for.body3.lr.ph.i
	block
	i32.const	$push10=, 0
	i32.load	$push2=, d($pop10)
	br_if   	$pop2, 0        # 0: down to label1
# BB#2:                                 # %for.inc25.i.preheader
	i32.const	$push6=, 0
	i32.const	$push7=, 1
	i32.store	$discard=, b($pop6), $pop7
	br      	1               # 1: down to label0
.LBB0_3:                                # %for.cond4.preheader.split.i
	end_block                       # label1:
	i32.const	$push3=, 0
	i32.const	$push4=, 1
	i32.store	$discard=, e($pop3), $pop4
	i32.const	$push11=, 0
	i32.const	$push5=, 4
	i32.store	$discard=, c($pop11), $pop5
.LBB0_4:                                # %foo.exit
	end_block                       # label0:
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	1                       # 0x1
	.size	d, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.9.0 "
