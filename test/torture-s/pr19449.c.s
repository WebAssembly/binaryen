	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19449.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	return  	$pop0
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_3
	i32.load	$push1=, y($0)
	br_if   	$pop1, .LBB1_3
# BB#1:                                 # %entry
	i32.load	$push0=, z($0)
	i32.const	$push2=, 3
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	$pop3, .LBB1_3
# BB#2:                                 # %lor.lhs.false1
	return  	$0
.LBB1_3:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	z,@object               # @z
	.data
	.globl	z
	.align	2
z:
	.int32	3                       # 0x3
	.size	z, 4

	.type	y,@object               # @y
	.bss
	.globl	y
	.align	2
y:
	.int32	0                       # 0x0
	.size	y, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
