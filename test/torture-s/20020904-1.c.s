	.text
	.file	"20020904-1.c"
	.section	.text.fun,"ax",@progbits
	.hidden	fun                     # -- Begin function fun
	.globl	fun
	.type	fun,@function
fun:                                    # @fun
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 255
	i32.div_u	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	fun, .Lfunc_end0-fun
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
