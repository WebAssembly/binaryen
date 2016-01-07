	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030224-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	node,@object            # @node
	.bss
	.globl	node
	.align	2
node:
	.zero	8
	.size	node, 8

	.type	node_p,@object          # @node_p
	.data
	.globl	node_p
	.align	2
node_p:
	.int32	node
	.size	node_p, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
