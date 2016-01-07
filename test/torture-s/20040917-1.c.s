	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040917-1.c"
	.globl	not_inlinable
	.type	not_inlinable,@function
not_inlinable:                          # @not_inlinable
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, -10
	i32.store	$discard=, test_var($pop0), $pop1
	return
.Lfunc_end0:
	.size	not_inlinable, .Lfunc_end0-not_inlinable

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 10
	i32.store	$1=, test_var($0), $pop0
	call    	not_inlinable
	block   	.LBB1_2
	i32.load	$push1=, test_var($0)
	i32.eq  	$push2=, $pop1, $1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	test_var,@object        # @test_var
	.lcomm	test_var,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
