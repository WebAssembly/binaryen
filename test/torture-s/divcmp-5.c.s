	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/divcmp-5.c"
	.globl	always_one_1
	.type	always_one_1,@function
always_one_1:                           # @always_one_1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end0:
	.size	always_one_1, func_end0-always_one_1

	.globl	always_one_2
	.type	always_one_2,@function
always_one_2:                           # @always_one_2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end1:
	.size	always_one_2, func_end1-always_one_2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
