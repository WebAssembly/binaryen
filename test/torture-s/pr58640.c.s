	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58640.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_4
	i32.load	$push0=, b($0)
	i32.gt_s	$push1=, $pop0, $0
	br_if   	$pop1, BB0_4
# BB#1:                                 # %for.body3.lr.ph.i
	block   	BB0_3
	i32.load	$push2=, d($0)
	br_if   	$pop2, BB0_3
# BB#2:                                 # %for.inc25.i.preheader
	i32.const	$push5=, 1
	i32.store	$discard=, b($0), $pop5
	br      	BB0_4
BB0_3:                                  # %for.cond4.preheader.split.i
	i32.const	$push3=, 1
	i32.store	$discard=, e($0), $pop3
	i32.const	$push4=, 4
	i32.store	$discard=, c($0), $pop4
BB0_4:                                  # %foo.exit
	call    	exit, $0
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	d,@object               # @d
	.data
	.globl	d
	.align	2
d:
	.int32	1                       # 0x1
	.size	d, 4

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	e,@object               # @e
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
