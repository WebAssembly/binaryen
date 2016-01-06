	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000818-1.c"
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

	.globl	yylex
	.type	yylex,@function
yylex:                                  # @yylex
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	yylex, func_end1-yylex

	.type	temporary_obstack,@object # @temporary_obstack
	.bss
	.globl	temporary_obstack
	.align	2
temporary_obstack:
	.int32	0
	.size	temporary_obstack, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
