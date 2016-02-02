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
	i32.const	$push1=, 8
	i32.shr_u	$push5=, $0, $pop1
	i32.const	$push3=, 255
	i32.and 	$push6=, $pop5, $pop3
	i32.const	$push17=, 255
	i32.and 	$push8=, $0, $pop17
	i32.add 	$push9=, $pop6, $pop8
	i32.load	$push0=, 4($1)
	tee_local	$push16=, $1=, $pop0
	i32.const	$push15=, 255
	i32.and 	$push7=, $pop16, $pop15
	i32.sub 	$push10=, $pop9, $pop7
	i32.const	$push14=, 8
	i32.shr_u	$push2=, $1, $pop14
	i32.const	$push13=, 255
	i32.and 	$push4=, $pop2, $pop13
	i32.le_s	$push11=, $pop10, $pop4
	i32.select	$push12=, $pop11, $1, $0
	return  	$pop12
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
