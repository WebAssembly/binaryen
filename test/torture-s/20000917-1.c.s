	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000917-1.c"
	.globl	one
	.type	one,@function
one:                                    # @one
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store	$push1=, 0($0), $pop0
	i32.store	$push2=, 4($0), $pop1
	i32.store	$discard=, 8($0), $pop2
	return
func_end0:
	.size	one, func_end0-one

	.globl	zero
	.type	zero,@function
zero:                                   # @zero
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	i32.store	$push2=, 4($0), $pop1
	i32.store	$discard=, 8($0), $pop2
	return
func_end1:
	.size	zero, func_end1-zero

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
