	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44858.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i64
# BB#0:                                 # %entry
	i32.div_s	$push0=, $0, $1
	i64.extend_s/i32	$push1=, $pop0
	return  	$pop1
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, a($0)
	i32.ne  	$push1=, $pop0, $0
	i32.store	$discard=, b($0), $pop1
	return  	$0
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.call	$discard=, bar
	i32.const	$0=, 0
	block   	.LBB2_2
	i32.load	$push0=, b($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB2_2
# BB#1:                                 # %if.end
	return  	$0
.LBB2_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	3                       # 0x3
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
