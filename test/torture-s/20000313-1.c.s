	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000313-1.c"
	.globl	buggy
	.type	buggy,@function
buggy:                                  # @buggy
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$2=, 0
	i32.store	$discard=, 0($0), $2
	i32.const	$push0=, -1
	i32.select	$push1=, $1, $pop0, $2
	return  	$pop1
func_end0:
	.size	buggy, func_end0-buggy

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end3
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
