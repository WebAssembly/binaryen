	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59388.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load8_u	$push0=, b($0)
	i32.const	$push1=, 1
	i32.and 	$push2=, $pop0, $pop1
	i32.store	$push3=, a($0), $pop2
	return  	$pop3
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.zero	4
	.size	b, 4

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
