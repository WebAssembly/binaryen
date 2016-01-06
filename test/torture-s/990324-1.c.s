	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/990324-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB0_2
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.gt_s	$push2=, $pop1, $1
	br_if   	$pop2, BB0_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
BB0_2:                                  # %if.else
	call    	exit, $1
	unreachable
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -255
	call    	f, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
