	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/980604-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push2=, a($0)
	i32.load	$push3=, b($0)
	i32.lt_s	$push4=, $pop2, $pop3
	i32.const	$push0=, c
	i32.const	$push1=, d
	i32.select	$push5=, $pop4, $pop0, $pop1
	i32.load	$push6=, 0($pop5)
	br_if   	$pop6, BB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	4294967295              # 0xffffffff
	.size	b, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	1                       # 0x1
	.size	c, 4

	.type	d,@object               # @d
	.bss
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
