	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56899.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, -214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	return
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB2_2
	i32.const	$push0=, -214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB2_2
# BB#1:                                 # %if.end
	return
.LBB2_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB3_2
	i32.const	$push0=, 214748365
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB3_2
# BB#1:                                 # %if.end
	return
.LBB3_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4

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
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
