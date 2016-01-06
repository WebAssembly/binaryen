	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031214-1.c"
	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
# BB#0:                                 # %entry
	return
func_end0:
	.size	b, func_end0-b

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, k($0)
	i32.load	$2=, g+8($0)
	i32.load	$3=, g+12($0)
	i32.gt_s	$push0=, $1, $2
	i32.select	$1=, $pop0, $1, $2
	i32.gt_s	$push1=, $1, $3
	i32.select	$push2=, $pop1, $1, $3
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$discard=, k($0), $pop4
	return  	$0
func_end1:
	.size	main, func_end1-main

	.type	g,@object               # @g
	.data
	.globl	g
	.align	3
g:
	.int64	0                       # double 0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	g, 16

	.type	k,@object               # @k
	.bss
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
