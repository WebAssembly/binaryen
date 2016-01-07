	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040820-1.c"
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$3=, 1
	block   	.LBB1_2
	i32.ne  	$push1=, $1, $2
	i32.shl 	$push2=, $pop1, $3
	i32.ne  	$push0=, $0, $2
	i32.or  	$push3=, $pop2, $pop0
	i32.ne  	$push4=, $pop3, $3
	br_if   	$pop4, .LBB1_2
# BB#1:                                 # %check.exit
	return
.LBB1_2:                                  # %if.then.i
	call    	abort
	unreachable
.Lfunc_end1:
	.size	test, .Lfunc_end1-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
