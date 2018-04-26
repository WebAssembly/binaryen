	.text
	.file	"pr29695-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 128
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 128
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 896
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -128
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 2147483648
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 2147483648
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 15032385536
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	f7, .Lfunc_end6-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, -2147483648
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	f8, .Lfunc_end7-f8
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
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
