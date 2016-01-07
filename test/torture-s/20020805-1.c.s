	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020805-1.c"
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, -1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, n($0)
	block   	.LBB1_2
	i32.const	$push0=, 2
	i32.sub 	$push1=, $pop0, $1
	i32.sub 	$push2=, $0, $1
	i32.or  	$push3=, $pop1, $pop2
	i32.const	$push4=, 1
	i32.or  	$push5=, $pop3, $pop4
	i32.const	$push6=, -1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB1_2
# BB#1:                                 # %check.exit
	call    	exit, $0
	unreachable
.LBB1_2:                                  # %if.then.i
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	n,@object               # @n
	.data
	.globl	n
	.align	2
n:
	.int32	1                       # 0x1
	.size	n, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
