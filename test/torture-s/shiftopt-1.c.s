	.text
	.file	"shiftopt-1.c"
	.section	.text.utest,"ax",@progbits
	.hidden	utest                   # -- Begin function utest
	.globl	utest
	.type	utest,@function
utest:                                  # @utest
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	utest, .Lfunc_end0-utest
                                        # -- End function
	.section	.text.stest,"ax",@progbits
	.hidden	stest                   # -- Begin function stest
	.globl	stest
	.type	stest,@function
stest:                                  # @stest
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	stest, .Lfunc_end1-stest
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
