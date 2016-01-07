	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010904-2.c"
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

	.type	y,@object               # @y
	.bss
	.globl	y
	.align	5
y:
	.zero	2112
	.size	y, 2112


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
