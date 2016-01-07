	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/920721-3.c"
	.globl	ru
	.type	ru,@function
ru:                                     # @ru
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 65535
	block   	.LBB0_4
	i32.and 	$push0=, $0, $1
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_4
# BB#1:                                 # %if.end
	block   	.LBB0_3
	i32.const	$push3=, 2
	i32.add 	$push4=, $0, $pop3
	i32.and 	$push5=, $pop4, $1
	i32.const	$push6=, 7
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB0_3
# BB#2:                                 # %if.end8
	return  	$0
.LBB0_3:                                  # %if.then7
	call    	abort
	unreachable
.LBB0_4:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	ru, .Lfunc_end0-ru

	.globl	rs
	.type	rs,@function
rs:                                     # @rs
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 65535
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 5
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end8
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	rs, .Lfunc_end1-rs

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
