	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr22061-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	x,@object               # @x
	.bss
	.globl	x
	.align	2
x:
	.int32	0
	.size	x, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
