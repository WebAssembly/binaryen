	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB0_8
	i32.const	$push0=, 10
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, .LBB0_8
# BB#1:                                 # %if.end
	block   	.LBB0_7
	i32.const	$push2=, 11
	i32.ne  	$push3=, $2, $pop2
	br_if   	$pop3, .LBB0_7
# BB#2:                                 # %if.end6
	block   	.LBB0_6
	i32.const	$push4=, 12
	i32.ne  	$push5=, $3, $pop4
	br_if   	$pop5, .LBB0_6
# BB#3:                                 # %if.end10
	block   	.LBB0_5
	i32.const	$push6=, 123
	i32.ne  	$push7=, $4, $pop6
	br_if   	$pop7, .LBB0_5
# BB#4:                                 # %if.end13
	return  	$1
.LBB0_5:                                  # %if.then12
	call    	abort
	unreachable
.LBB0_6:                                  # %if.then9
	call    	abort
	unreachable
.LBB0_7:                                  # %if.then5
	call    	abort
	unreachable
.LBB0_8:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
