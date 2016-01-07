	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/981130-1.c"
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, .LBB0_2
# BB#1:                                 # %if.then
	i32.const	$push1=, 0
	call    	exit, $pop1
	unreachable
.LBB0_2:                                  # %if.else
	call    	abort
	unreachable
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i64.load	$push0=, s2($0)
	i64.store	$push1=, s1($0), $pop0
	i32.wrap/i64	$push2=, $pop1
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB1_2
# BB#1:                                 # %if.then.i
	call    	exit, $0
	unreachable
.LBB1_2:                                  # %if.else.i
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	s2,@object              # @s2
	.data
	.globl	s2
	.align	3
s2:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	s2, 8

	.type	s1,@object              # @s1
	.bss
	.globl	s1
	.align	3
s1:
	.zero	8
	.size	s1, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
