	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23467.c"
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

	.type	v,@object               # @v
	.bss
	.globl	v
	.align	3
v:
	.zero	16
	.size	v, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
