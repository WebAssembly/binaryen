	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011019-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, y($pop0)
	i32.const	$push2=, x+4
	i32.sub 	$push3=, $pop1, $pop2
	i32.const	$push4=, 2
	i32.shr_s	$push5=, $pop3, $pop4
	return  	$pop5
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, x+4
	i32.store	$discard=, y($0), $pop0
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	y,@object               # @y
	.bss
	.globl	y
	.align	2
y:
	.int32	0
	.size	y, 4

	.type	x,@object               # @x
	.globl	x
	.align	2
x:
	.zero	24
	.size	x, 24


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
