	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991202-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 32
	i32.store	$discard=, x($0), $pop0
	i32.const	$push1=, 64
	i32.store	$discard=, y($0), $pop1
	call    	exit, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	x,@object               # @x
	.bss
	.globl	x
	.align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.type	y,@object               # @y
	.globl	y
	.align	2
y:
	.int32	0                       # 0x0
	.size	y, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
