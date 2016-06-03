	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011121-1.c"
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
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s1                      # @s1
	.type	s1,@object
	.section	.bss.s1,"aw",@nobits
	.globl	s1
	.p2align	2
s1:
	.skip	76
	.size	s1, 76


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
