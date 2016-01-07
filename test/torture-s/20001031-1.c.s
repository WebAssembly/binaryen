	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001031-1.c"
	.globl	t1
	.type	t1,@function
t1:                                     # @t1
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 4100
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	t1, .Lfunc_end0-t1

	.globl	t2
	.type	t2,@function
t2:                                     # @t2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4096
	return  	$pop0
.Lfunc_end1:
	.size	t2, .Lfunc_end1-t2

	.globl	t3
	.type	t3,@function
t3:                                     # @t3
	.param  	i64
# BB#0:                                 # %entry
	block   	.LBB2_2
	i64.const	$push0=, 2147487743
	i64.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB2_2
# BB#1:                                 # %if.end
	return
.LBB2_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	t3, .Lfunc_end2-t3

	.globl	t4
	.type	t4,@function
t4:                                     # @t4
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 4096
	return  	$pop0
.Lfunc_end3:
	.size	t4, .Lfunc_end3-t4

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
