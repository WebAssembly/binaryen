	.text
	.file	"20031214-1.c"
	.section	.text.b,"ax",@progbits
	.hidden	b                       # -- Begin function b
	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	b, .Lfunc_end0-b
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, g+8($pop0)
	i32.const	$push9=, 0
	i32.load	$1=, k($pop9)
	i32.gt_s	$push1=, $1, $0
	i32.select	$0=, $1, $0, $pop1
	i32.const	$push8=, 0
	i32.load	$1=, g+12($pop8)
	i32.const	$push7=, 0
	i32.gt_s	$push2=, $0, $1
	i32.select	$push3=, $0, $1, $pop2
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	k($pop7), $pop5
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	3
g:
	.int64	0                       # double 0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	g, 16

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
