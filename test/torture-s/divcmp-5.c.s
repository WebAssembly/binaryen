	.text
	.file	"divcmp-5.c"
	.section	.text.always_one_1,"ax",@progbits
	.hidden	always_one_1            # -- Begin function always_one_1
	.globl	always_one_1
	.type	always_one_1,@function
always_one_1:                           # @always_one_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	always_one_1, .Lfunc_end0-always_one_1
                                        # -- End function
	.section	.text.always_one_2,"ax",@progbits
	.hidden	always_one_2            # -- Begin function always_one_2
	.globl	always_one_2
	.type	always_one_2,@function
always_one_2:                           # @always_one_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	always_one_2, .Lfunc_end1-always_one_2
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
