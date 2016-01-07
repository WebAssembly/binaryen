	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58726.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, 16
	i32.lt_s	$push0=, $0, $1
	i32.load	$push1=, a($1)
	i32.select	$push2=, $pop0, $0, $pop1
	i32.shl 	$push3=, $pop2, $2
	i32.shr_s	$push4=, $pop3, $2
	return  	$pop4
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 56374
	i32.store	$discard=, b($0), $pop0
	i32.const	$push1=, -9162
	i32.store	$discard=, c($0), $pop1
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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
	.zero	4
	.size	b, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
