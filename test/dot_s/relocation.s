	.text
	.file	"relocation.c"
	.globl	main
	.type	main,@function
main:
	.result i32
	.local i32
	i32.const $push0=, a
	i32.load $push1=, 0($pop0)
	return $pop1
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	b,@object
	.data
	.globl	b
	.align	2
b:
	.int32	a
	.size	b, 4

	.type	a,@object
	.globl	a
	.align	2
a:
	.int32	b
	.size	a, 4



