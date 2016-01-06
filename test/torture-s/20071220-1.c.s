	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071220-1.c"
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i32.load	$push0=, 0($0)
	return  	$pop0
func_end0:
	.size	baz, func_end0-baz

	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$discard=, bar
	i32.const	$push0=, 17
	return  	$pop0
func_end1:
	.size	f1, func_end1-f1

	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, bar.b
	i32.call	$discard=, baz, $pop0
tmp0:                                   # Block address taken
# BB#1:                                 # %addr
	return  	$0
func_end2:
	.size	bar, func_end2-bar

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$discard=, bar
	i32.const	$push0=, 17
	return  	$pop0
func_end3:
	.size	f2, func_end3-f2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$discard=, f1
	i32.call	$discard=, f1
	i32.call	$discard=, f2
	i32.call	$discard=, f2
	i32.const	$push0=, 0
	return  	$pop0
func_end4:
	.size	main, func_end4-main

	.type	bar.b,@object           # @bar.b
	.data
	.align	2
bar.b:
	.int32	tmp0
	.size	bar.b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
