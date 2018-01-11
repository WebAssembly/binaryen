	.text
	.file	"921202-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %for.cond
	i32.call	$drop=, exxit@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.mpn_mul_1,"ax",@progbits
	.hidden	mpn_mul_1               # -- Begin function mpn_mul_1
	.globl	mpn_mul_1
	.type	mpn_mul_1,@function
mpn_mul_1:                              # @mpn_mul_1
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	mpn_mul_1, .Lfunc_end2-mpn_mul_1
                                        # -- End function
	.section	.text.mpn_print,"ax",@progbits
	.hidden	mpn_print               # -- Begin function mpn_print
	.globl	mpn_print
	.type	mpn_print,@function
mpn_print:                              # @mpn_print
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	mpn_print, .Lfunc_end3-mpn_print
                                        # -- End function
	.section	.text.mpn_random2,"ax",@progbits
	.hidden	mpn_random2             # -- Begin function mpn_random2
	.globl	mpn_random2
	.type	mpn_random2,@function
mpn_random2:                            # @mpn_random2
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	mpn_random2, .Lfunc_end4-mpn_random2
                                        # -- End function
	.section	.text.mpn_cmp,"ax",@progbits
	.hidden	mpn_cmp                 # -- Begin function mpn_cmp
	.globl	mpn_cmp
	.type	mpn_cmp,@function
mpn_cmp:                                # @mpn_cmp
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	mpn_cmp, .Lfunc_end5-mpn_cmp
                                        # -- End function
	.section	.text.exxit,"ax",@progbits
	.hidden	exxit                   # -- Begin function exxit
	.globl	exxit
	.type	exxit,@function
exxit:                                  # @exxit
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end6:
	.size	exxit, .Lfunc_end6-exxit
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
