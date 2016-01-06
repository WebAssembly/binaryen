	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020611-1.c"
	.globl	x
	.type	x,@function
x:                                      # @x
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, n($0)
	i32.const	$push1=, 31
	i32.lt_u	$push2=, $pop0, $pop1
	i32.store	$push3=, p($0), $pop2
	i32.store	$discard=, k($0), $pop3
	return
func_end0:
	.size	x, func_end0-x

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.load	$push0=, n($0)
	i32.const	$push1=, 31
	i32.lt_u	$push2=, $pop0, $pop1
	i32.store	$push3=, p($0), $pop2
	i32.store	$push4=, k($0), $pop3
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop4, $pop5
	br_if   	$pop6, BB1_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	n,@object               # @n
	.data
	.globl	n
	.align	2
n:
	.int32	30                      # 0x1e
	.size	n, 4

	.type	p,@object               # @p
	.bss
	.globl	p
	.align	2
p:
	.int32	0                       # 0x0
	.size	p, 4

	.type	k,@object               # @k
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
