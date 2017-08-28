	.text
	.file	"divcmp-5.c"
	.section	.text.always_one_1,"ax",@progbits
	.hidden	always_one_1            # -- Begin function always_one_1
	.globl	always_one_1
	.type	always_one_1,@function
always_one_1:                           # @always_one_1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
