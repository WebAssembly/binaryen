	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23047.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 31
	i32.shr_s	$1=, $0, $pop0
	i32.add 	$push1=, $0, $1
	i32.xor 	$push2=, $pop1, $1
	i32.const	$push3=, -1
	i32.gt_s	$push4=, $pop2, $pop3
	br_if   	$pop4, BB0_2
# BB#1:                                 # %if.then
	return
BB0_2:                                  # %if.end
	call    	abort
	unreachable
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
