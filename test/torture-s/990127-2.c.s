	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990127-2.c"
	.section	.text.fpEq,"ax",@progbits
	.hidden	fpEq
	.globl	fpEq
	.type	fpEq,@function
fpEq:                                   # @fpEq
	.param  	f64, f64
# BB#0:                                 # %entry
	block   	.LBB0_2
	f64.ne  	$push0=, $0, $1
	br_if   	$pop0, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	fpEq, .Lfunc_end0-fpEq

	.section	.text.fpTest,"ax",@progbits
	.hidden	fpTest
	.globl	fpTest
	.type	fpTest,@function
fpTest:                                 # @fpTest
	.param  	f64, f64
# BB#0:                                 # %entry
	block   	.LBB1_2
	f64.const	$push0=, 0x1.9p6
	f64.mul 	$push1=, $0, $pop0
	f64.div 	$push2=, $pop1, $1
	f64.const	$push3=, 0x1.3d55555555556p6
	f64.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB1_2
# BB#1:                                 # %fpEq.exit
	return
.LBB1_2:                                # %if.then.i
	call    	abort
	unreachable
.Lfunc_end1:
	.size	fpTest, .Lfunc_end1-fpTest

	.section	.text.main,"ax",@progbits
	.hidden	main
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
