	.text
	.file	"pr63209.c"
	.section	.text.Predictor,"ax",@progbits
	.hidden	Predictor               # -- Begin function Predictor
	.globl	Predictor
	.type	Predictor,@function
Predictor:                              # @Predictor
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load	$1=, 4($1)
	i32.const	$push2=, 8
	i32.shr_u	$push3=, $0, $pop2
	i32.const	$push0=, 255
	i32.and 	$push4=, $pop3, $pop0
	i32.const	$push15=, 255
	i32.and 	$push1=, $0, $pop15
	i32.add 	$push5=, $pop4, $pop1
	i32.const	$push14=, 255
	i32.and 	$push6=, $1, $pop14
	i32.sub 	$push7=, $pop5, $pop6
	i32.const	$push13=, 8
	i32.shr_u	$push8=, $1, $pop13
	i32.const	$push12=, 255
	i32.and 	$push9=, $pop8, $pop12
	i32.gt_s	$push10=, $pop7, $pop9
	i32.select	$push11=, $0, $1, $pop10
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	Predictor, .Lfunc_end0-Predictor
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, -8684677
	i32.const	$push0=, main.top
	i32.call	$push2=, Predictor@FUNCTION, $pop1, $pop0
	i32.const	$push4=, -8684677
	i32.ne  	$push3=, $pop2, $pop4
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	main.top,@object        # @main.top
	.section	.rodata.main.top,"a",@progbits
	.p2align	2
main.top:
	.int32	4286216826              # 0xff7a7a7a
	.int32	4286216826              # 0xff7a7a7a
	.size	main.top, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
