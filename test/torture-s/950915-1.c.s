	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/950915-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.load32_s	$push1=, b($0)
	i64.load32_s	$push0=, a($0)
	i64.mul 	$push2=, $pop1, $pop0
	i64.const	$push3=, 16
	i64.shr_u	$push4=, $pop2, $pop3
	i32.wrap/i64	$push5=, $pop4
	return  	$pop5
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i64.load32_s	$push1=, b($0)
	i64.load32_s	$push0=, a($0)
	i64.mul 	$push2=, $pop1, $pop0
	i64.const	$push3=, 16
	i64.shr_u	$push4=, $pop2, $pop3
	i32.wrap/i64	$push5=, $pop4
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $pop5, $pop6
	br_if   	$pop7, BB1_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
BB1_2:                                  # %if.end
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	100000                  # 0x186a0
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	21475                   # 0x53e3
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
