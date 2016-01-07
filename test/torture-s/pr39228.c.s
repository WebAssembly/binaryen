	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39228.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	f64.const	$push0=, infinity
	i32.call	$0=, __builtin_isinff, $pop0
	i32.const	$1=, 0
	block   	.LBB0_6
	i32.le_s	$push1=, $0, $1
	br_if   	$pop1, .LBB0_6
# BB#1:                                 # %if.end
	block   	.LBB0_5
	i32.const	$push2=, 1
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop2, $pop7
	br_if   	$pop8, .LBB0_5
# BB#2:                                 # %if.end4
	block   	.LBB0_4
	i64.const	$push4=, 0
	i64.const	$push3=, 9223090561878065152
	i32.call	$push5=, __builtin_isinfl, $pop4, $pop3
	i32.le_s	$push6=, $pop5, $1
	br_if   	$pop6, .LBB0_4
# BB#3:                                 # %if.end8
	return  	$1
.LBB0_4:                                  # %if.then7
	call    	abort
	unreachable
.LBB0_5:                                  # %if.then3
	call    	abort
	unreachable
.LBB0_6:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
