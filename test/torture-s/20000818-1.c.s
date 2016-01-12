	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000818-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.yylex,"ax",@progbits
	.hidden	yylex
	.globl	yylex
	.type	yylex,@function
yylex:                                  # @yylex
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	yylex, .Lfunc_end1-yylex

	.hidden	temporary_obstack       # @temporary_obstack
	.type	temporary_obstack,@object
	.section	.bss.temporary_obstack,"aw",@nobits
	.globl	temporary_obstack
	.align	2
temporary_obstack:
	.int32	0
	.size	temporary_obstack, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
