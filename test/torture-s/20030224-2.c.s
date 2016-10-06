	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030224-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
