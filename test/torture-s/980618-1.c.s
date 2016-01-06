	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/980618-1.c"
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

	.globl	func
	.type	func,@function
func:                                   # @func
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, BB1_2
# BB#1:                                 # %if.then
	return
BB1_2:                                  # %if.else
	call    	abort
	unreachable
func_end1:
	.size	func, func_end1-func


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
