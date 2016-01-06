	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/921110-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	f,@object               # @f
	.data
	.globl	f
	.align	2
f:
	.int32	abort
	.size	f, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
