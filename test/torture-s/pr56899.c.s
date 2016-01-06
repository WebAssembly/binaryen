	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56899.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, -214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.const	$push0=, 214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.end
	return
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	f2, func_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
# BB#0:                                 # %entry
	block   	BB2_2
	i32.const	$push0=, -214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB2_2
# BB#1:                                 # %if.end
	return
BB2_2:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	f3, func_end2-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32
# BB#0:                                 # %entry
	block   	BB3_2
	i32.const	$push0=, 214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB3_2
# BB#1:                                 # %if.end
	return
BB3_2:                                  # %if.then
	call    	abort
	unreachable
func_end3:
	.size	f4, func_end3-f4

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 10
	call    	f1, $0
	i32.const	$1=, -10
	call    	f2, $1
	call    	f3, $0
	call    	f4, $1
	i32.const	$push0=, 0
	return  	$pop0
func_end4:
	.size	main, func_end4-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
