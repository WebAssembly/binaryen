	.text
	.file	"20000121-1.c"
	.section	.text.big,"ax",@progbits
	.hidden	big                     # -- Begin function big
	.globl	big
	.type	big,@function
big:                                    # @big
	.param  	i64
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	big, .Lfunc_end0-big
                                        # -- End function
	.section	.text.doit,"ax",@progbits
	.hidden	doit                    # -- Begin function doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	doit, .Lfunc_end1-doit
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
