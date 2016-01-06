	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020328-1.c"
	.globl	func
	.type	func,@function
func:                                   # @func
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
func_end0:
	.size	func, func_end0-func

	.globl	testit
	.type	testit,@function
testit:                                 # @testit
	.param  	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.const	$push0=, 20
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB1_2
# BB#1:                                 # %if.end
	return
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	testit, func_end1-testit

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
