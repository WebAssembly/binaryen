	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37125.c"
	.globl	func_44
	.type	func_44,@function
func_44:                                # @func_44
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, -9
	block   	BB0_2
	i32.mul 	$push0=, $0, $1
	i32.rem_u	$push1=, $pop0, $1
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	func_44, func_end0-func_44

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
