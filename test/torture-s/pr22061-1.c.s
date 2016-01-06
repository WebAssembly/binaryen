	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr22061-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, N($pop0)
	i32.add 	$push1=, $0, $1
	i32.store8	$discard=, 0($pop1), $1
	return
func_end1:
	.size	bar, func_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 4
	i32.store	$discard=, N($0), $pop0
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	N,@object               # @N
	.data
	.globl	N
	.align	2
N:
	.int32	1                       # 0x1
	.size	N, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
