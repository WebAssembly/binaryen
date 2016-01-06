	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930513-2.c"
	.globl	sub3
	.type	sub3,@function
sub3:                                   # @sub3
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$1
func_end0:
	.size	sub3, func_end0-sub3

	.globl	eq
	.type	eq,@function
eq:                                     # @eq
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	BB1_2
	i32.load	$push0=, eq.i($2)
	i32.ne  	$push1=, $pop0, $0
	br_if   	$pop1, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.store	$discard=, eq.i($2), $pop3
	return  	$0
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	eq, func_end1-eq

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB2_2
	i32.load	$push0=, eq.i($0)
	br_if   	$pop0, BB2_2
# BB#1:                                 # %eq.exit.3
	i32.const	$push1=, 4
	i32.store	$discard=, eq.i($0), $pop1
	call    	exit, $0
	unreachable
BB2_2:                                  # %if.then.i
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	eq.i,@object            # @eq.i
	.lcomm	eq.i,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
