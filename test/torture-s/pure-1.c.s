	.text
	.file	"pure-1.c"
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
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.func0,"ax",@progbits
	.hidden	func0                   # -- Begin function func0
	.globl	func0
	.type	func0,@function
func0:                                  # @func0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, i($pop0)
	i32.sub 	$push2=, $0, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	func0, .Lfunc_end1-func0
                                        # -- End function
	.section	.text.func1,"ax",@progbits
	.hidden	func1                   # -- Begin function func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	func1, .Lfunc_end2-func1
                                        # -- End function
	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	2
i:
	.int32	2                       # 0x2
	.size	i, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
