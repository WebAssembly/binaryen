	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011121-1.c"
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

	.type	s1,@object              # @s1
	.bss
	.globl	s1
	.align	2
s1:
	.zero	76
	.size	s1, 76


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
