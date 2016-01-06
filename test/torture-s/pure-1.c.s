	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pure-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end0:
	.size	main, func_end0-main

	.globl	func0
	.type	func0,@function
func0:                                  # @func0
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, i($pop0)
	i32.sub 	$push2=, $0, $pop1
	return  	$pop2
func_end1:
	.size	func0, func_end1-func0

	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	func1, func_end2-func1

	.type	i,@object               # @i
	.data
	.globl	i
	.align	2
i:
	.int32	2                       # 0x2
	.size	i, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
