	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000717-4.c"
	.globl	x
	.type	x,@function
x:                                      # @x
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, s+8($pop0)
	return  	$pop1
func_end0:
	.size	x, func_end0-x

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	2
s:
	.zero	100
	.size	s, 100


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
