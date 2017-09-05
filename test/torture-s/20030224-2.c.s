	.text
	.file	"20030224-2.c"
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
