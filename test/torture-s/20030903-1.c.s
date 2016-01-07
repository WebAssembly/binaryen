	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030903-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	.LBB0_2
	i32.load	$push0=, test($1)
	i32.const	$push1=, -1
	i32.add 	$0=, $pop0, $pop1
	i32.const	$push2=, 3
	i32.le_u	$push3=, $0, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %sw.epilog
	return  	$1
.LBB0_2:                                  # %entry
	block   	.LBB0_6
	block   	.LBB0_5
	block   	.LBB0_4
	block   	.LBB0_3
	tableswitch	$0, .LBB0_3, .LBB0_3, .LBB0_4, .LBB0_5, .LBB0_6
.LBB0_3:                                  # %sw.bb
	call    	y
	unreachable
.LBB0_4:                                  # %sw.bb1
	call    	y
	unreachable
.LBB0_5:                                  # %sw.bb2
	call    	y
	unreachable
.LBB0_6:                                  # %sw.bb3
	call    	y
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	y,@function
y:                                      # @y
# BB#0:                                 # %entry
	call    	abort
	unreachable
.Lfunc_end1:
	.size	y, .Lfunc_end1-y

	.type	test,@object            # @test
	.lcomm	test,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
