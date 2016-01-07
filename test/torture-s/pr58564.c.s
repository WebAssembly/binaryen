	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58564.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store	$push0=, b($0), $0
	return  	$pop0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	c,@object               # @c
	.bss
	.globl	c
	.align	2
c:
	.int32	0
	.size	c, 4

	.type	d,@object               # @d
	.data
	.globl	d
	.align	2
d:
	.int32	c
	.size	d, 4

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
