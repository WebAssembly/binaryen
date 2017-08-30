	.text
	.file	"20000121-1.c"
	.section	.text.big,"ax",@progbits
	.hidden	big                     # -- Begin function big
	.globl	big
	.type	big,@function
big:                                    # @big
	.param  	i64
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
