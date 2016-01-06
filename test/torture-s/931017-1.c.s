	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/931017-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end0:
	.size	main, func_end0-main

	.globl	h1
	.type	h1,@function
h1:                                     # @h1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	h1, func_end1-h1

	.globl	h2
	.type	h2,@function
h2:                                     # @h2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB2_2
	i32.const	$push0=, v
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB2_2
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	return  	$pop2
BB2_2:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	h2, func_end2-h2

	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end3:
	.size	g, func_end3-g

	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
func_end4:
	.size	f, func_end4-f

	.type	v,@object               # @v
	.bss
	.globl	v
	.align	2
v:
	.int32	0                       # 0x0
	.size	v, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
