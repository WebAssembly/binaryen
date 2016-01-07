	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr25125.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	.LBB0_2
	i32.gt_s	$push0=, $0, $1
	br_if   	$pop0, .LBB0_2
# BB#1:                                 # %if.end
	i32.const	$push1=, 65535
	i32.and 	$push2=, $0, $pop1
	i32.const	$push3=, 32768
	i32.add 	$1=, $pop2, $pop3
.LBB0_2:                                  # %cleanup
	i32.const	$push4=, 65535
	i32.and 	$push5=, $1, $pop4
	return  	$pop5
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, -32767
	i32.call	$push1=, f, $pop0
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit, $pop4
	unreachable
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
