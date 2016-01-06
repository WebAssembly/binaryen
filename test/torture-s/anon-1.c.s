	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/anon-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push0=, 6
	i32.store	$discard=, foo+8($2), $pop0
	i32.const	$push1=, 5
	i32.store	$discard=, foo+4($2), $pop1
	return  	$2
func_end0:
	.size	main, func_end0-main

	.type	foo,@object             # @foo
	.bss
	.globl	foo
	.align	2
foo:
	.zero	12
	.size	foo, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
