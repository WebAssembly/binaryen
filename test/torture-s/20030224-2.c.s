	.text
	.file	"20030224-2.c"
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
	.hidden	node                    # @node
	.type	node,@object
	.section	.bss.node,"aw",@nobits
	.globl	node
	.p2align	2
node:
	.skip	8
	.size	node, 8

	.hidden	node_p                  # @node_p
	.type	node_p,@object
	.section	.data.node_p,"aw",@progbits
	.globl	node_p
	.p2align	2
node_p:
	.int32	node
	.size	node_p, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
