	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57321.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push0=, a($0)
	br_if   	$pop0, BB0_2
# BB#1:                                 # %if.then.i
	i32.load	$push1=, b($0)
	i32.const	$push2=, 1
	i32.store	$discard=, 0($pop1), $pop2
BB0_2:                                  # %foo.exit
	return  	$0
func_end0:
	.size	main, func_end0-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0
	.size	b, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
