	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr63209.c"
	.section	.text.Predictor,"ax",@progbits
	.hidden	Predictor
	.globl	Predictor
	.type	Predictor,@function
Predictor:                              # @Predictor
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$1=, 4($1)
	i32.const	$push0=, 8
	i32.shr_u	$push4=, $0, $pop0
	i32.const	$push2=, 255
	i32.and 	$push5=, $pop4, $pop2
	i32.const	$push15=, 255
	i32.and 	$push7=, $0, $pop15
	i32.add 	$push8=, $pop5, $pop7
	i32.const	$push14=, 255
	i32.and 	$push6=, $1, $pop14
	i32.sub 	$push9=, $pop8, $pop6
	i32.const	$push13=, 8
	i32.shr_u	$push1=, $1, $pop13
	i32.const	$push12=, 255
	i32.and 	$push3=, $pop1, $pop12
	i32.le_s	$push10=, $pop9, $pop3
	i32.select	$push11=, $1, $0, $pop10
	return  	$pop11
	.endfunc
.Lfunc_end0:
	.size	Predictor, .Lfunc_end0-Predictor

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, -8684677
	i32.const	$push0=, main.top
	i32.call	$push2=, Predictor@FUNCTION, $pop1, $pop0
	i32.const	$push4=, -8684677
	i32.ne  	$push3=, $pop2, $pop4
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.top,@object        # @main.top
	.section	.rodata.main.top,"a",@progbits
	.p2align	2
main.top:
	.int32	4286216826              # 0xff7a7a7a
	.int32	4286216826              # 0xff7a7a7a
	.size	main.top, 8


	.ident	"clang version 3.9.0 "
