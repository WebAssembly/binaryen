	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40404.c"
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
func_end0:
	.size	main, func_end0-main

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	2
s:
	.zero	4
	.size	s, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
