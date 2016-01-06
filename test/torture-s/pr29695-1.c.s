	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr29695-1.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 128
	return  	$pop0
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 128
	return  	$pop0
func_end1:
	.size	f2, func_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 896
	return  	$pop0
func_end2:
	.size	f3, func_end2-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -128
	return  	$pop0
func_end3:
	.size	f4, func_end3-f4

	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	return  	$pop0
func_end4:
	.size	f5, func_end4-f5

	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	return  	$pop0
func_end5:
	.size	f6, func_end5-f6

	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 15032385536
	return  	$pop0
func_end6:
	.size	f7, func_end6-f7

	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, -2147483648
	return  	$pop0
func_end7:
	.size	f8, func_end7-f8

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end8:
	.size	main, func_end8-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
