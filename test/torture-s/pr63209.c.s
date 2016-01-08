	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr63209.c"
	.section	.text.Predictor,"ax",@progbits
	.hidden	Predictor
	.globl	Predictor
	.type	Predictor,@function
Predictor:                              # @Predictor
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($1)
	i32.const	$3=, 8
	i32.const	$1=, 255
	i32.shr_u	$push2=, $0, $3
	i32.and 	$push3=, $pop2, $1
	i32.and 	$push5=, $0, $1
	i32.add 	$push6=, $pop3, $pop5
	i32.and 	$push4=, $2, $1
	i32.sub 	$push7=, $pop6, $pop4
	i32.shr_u	$push0=, $2, $3
	i32.and 	$push1=, $pop0, $1
	i32.le_s	$push8=, $pop7, $pop1
	i32.select	$push9=, $pop8, $2, $0
	return  	$pop9
.Lfunc_end0:
	.size	Predictor, .Lfunc_end0-Predictor

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -8684677
	i32.const	$push0=, main.top
	i32.call	$push1=, Predictor, $0, $pop0
	i32.ne  	$push2=, $pop1, $0
	return  	$pop2
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.top,@object        # @main.top
	.section	.rodata.main.top,"a",@progbits
	.align	2
main.top:
	.int32	4286216826              # 0xff7a7a7a
	.int32	4286216826              # 0xff7a7a7a
	.size	main.top, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
