	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030216-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	one,@object             # @one
	.section	.rodata,"a",@progbits
	.globl	one
	.align	3
one:
	.int64	4607182418800017408     # double 1
	.size	one, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
