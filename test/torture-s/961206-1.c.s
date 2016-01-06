	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/961206-1.c"
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
	return  	$pop1
func_end0:
	.size	sub1, func_end0-sub1

	.globl	sub2
	.type	sub2,@function
sub2:                                   # @sub2
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
	return  	$pop1
func_end1:
	.size	sub2, func_end1-sub2

	.globl	sub3
	.type	sub3,@function
sub3:                                   # @sub3
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
	return  	$pop1
func_end2:
	.size	sub3, func_end2-sub3

	.globl	sub4
	.type	sub4,@function
sub4:                                   # @sub4
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
	return  	$pop1
func_end3:
	.size	sub4, func_end3-sub4

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end12
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end4:
	.size	main, func_end4-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
