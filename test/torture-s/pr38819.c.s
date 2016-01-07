	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38819.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.body
	i32.const	$0=, 0
	i32.load	$discard=, a($0)
	i32.load	$discard=, b($0)
	call    	foo
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	x,@object               # @x
	.data
	.globl	x
	.align	2
x:
	.int32	2                       # 0x2
	.size	x, 4

	.type	r,@object               # @r
	.globl	r
	.align	2
r:
	.int32	8                       # 0x8
	.size	r, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
