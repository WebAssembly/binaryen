	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40404.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, s($0)
	i32.const	$push1=, 131071
	i32.or  	$push2=, $pop0, $pop1
	i32.store	$discard=, s($0), $pop2
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 3.9.0 "
