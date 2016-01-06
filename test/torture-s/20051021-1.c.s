	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051021-1.c"
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, count($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, count($0), $pop2
	return  	$0
func_end0:
	.size	foo1, func_end0-foo1

	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, count($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, count($0), $pop2
	return  	$0
func_end1:
	.size	foo2, func_end1-foo2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, count($0)
	block   	BB2_2
	i32.const	$push0=, 2
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, count($0), $pop1
	br_if   	$1, BB2_2
# BB#1:                                 # %if.end7
	return  	$0
BB2_2:                                  # %if.then6
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	count,@object           # @count
	.bss
	.globl	count
	.align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
