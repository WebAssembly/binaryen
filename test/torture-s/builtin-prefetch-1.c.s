	.text
	.file	"builtin-prefetch-1.c"
	.section	.text.good_const,"ax",@progbits
	.hidden	good_const              # -- Begin function good_const
	.globl	good_const
	.type	good_const,@function
good_const:                             # @good_const
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	good_const, .Lfunc_end0-good_const
                                        # -- End function
	.section	.text.good_enum,"ax",@progbits
	.hidden	good_enum               # -- Begin function good_enum
	.globl	good_enum
	.type	good_enum,@function
good_enum:                              # @good_enum
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	good_enum, .Lfunc_end1-good_enum
                                        # -- End function
	.section	.text.good_expr,"ax",@progbits
	.hidden	good_expr               # -- Begin function good_expr
	.globl	good_expr
	.type	good_expr,@function
good_expr:                              # @good_expr
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	good_expr, .Lfunc_end2-good_expr
                                        # -- End function
	.section	.text.good_vararg,"ax",@progbits
	.hidden	good_vararg             # -- Begin function good_vararg
	.globl	good_vararg
	.type	good_vararg,@function
good_vararg:                            # @good_vararg
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	good_vararg, .Lfunc_end3-good_vararg
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, arr
	call    	good_const@FUNCTION, $pop0
	i32.const	$push2=, arr
	call    	good_enum@FUNCTION, $pop2
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function
	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.bss.arr,"aw",@nobits
	.globl	arr
	.p2align	4
arr:
	.skip	40
	.size	arr, 40


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
