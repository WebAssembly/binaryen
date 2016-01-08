	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44683.c"
	.section	.text.copysign_bug,"ax",@progbits
	.hidden	copysign_bug
	.globl	copysign_bug
	.type	copysign_bug,@function
copysign_bug:                           # @copysign_bug
	.param  	f64
	.result 	i32
	.local  	f64, i32
# BB#0:                                 # %entry
	f64.const	$1=, 0x0p0
	block   	.LBB0_3
	block   	.LBB0_2
	f64.eq  	$push2=, $0, $1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %entry
	i32.const	$2=, 1
	f64.const	$push1=, 0x1p-1
	f64.mul 	$push0=, $0, $pop1
	f64.eq  	$push3=, $pop0, $0
	br_if   	$pop3, .LBB0_3
.LBB0_2:                                # %if.end
	f64.const	$push4=, 0x1p0
	f64.copysign	$push5=, $pop4, $0
	f64.lt  	$push6=, $pop5, $1
	i32.const	$push8=, 2
	i32.const	$push7=, 3
	i32.select	$2=, $pop6, $pop8, $pop7
.LBB0_3:                                # %return
	return  	$2
.Lfunc_end0:
	.size	copysign_bug, .Lfunc_end0-copysign_bug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	f64.const	$push0=, -0x0p0
	i32.call	$push1=, copysign_bug, $pop0
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
