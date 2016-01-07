	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33382.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, x+8($0)
	i32.const	$push0=, 1
	i32.store	$discard=, x+4($0), $pop0
	return  	$1
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, x+8($0)
	block   	.LBB1_2
	i32.const	$push0=, 1
	i32.store	$discard=, x+4($0), $pop0
	br_if   	$1, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	x,@object               # @x
	.data
	.globl	x
	.align	2
x:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.size	x, 20


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
