	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23467.c"
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

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	3
v:
	.skip	16
	.size	v, 16


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
