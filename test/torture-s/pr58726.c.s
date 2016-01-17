	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58726.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
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
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
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
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.skip	4
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.9.0 "
