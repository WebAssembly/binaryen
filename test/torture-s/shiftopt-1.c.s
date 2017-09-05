	.text
	.file	"shiftopt-1.c"
	.section	.text.utest,"ax",@progbits
	.hidden	utest                   # -- Begin function utest
	.globl	utest
	.type	utest,@function
utest:                                  # @utest
	.param  	i32
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
