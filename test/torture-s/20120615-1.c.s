	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120615-1.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_3
	i32.const	$push0=, 17
	i32.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.shl 	$push3=, $pop2, $0
	i32.const	$push4=, 167936
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB0_3
# BB#2:                                 # %if.end6
	return
.LBB0_3:                                  # %if.end5
	call    	abort
	unreachable
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 15
	call    	test1, $pop0
	i32.const	$push1=, 0
	return  	$pop1
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
