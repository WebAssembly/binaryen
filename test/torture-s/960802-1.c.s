	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/960802-1.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 306
	return  	$pop0
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1577058304
	return  	$pop0
func_end1:
	.size	f2, func_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$discard=, val($pop0), $0
	return
func_end2:
	.size	f3, func_end2-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1577058610
	i32.store	$discard=, val($pop0), $pop1
	return
func_end3:
	.size	f4, func_end3-f4

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 1577058610
	i32.store	$discard=, val($0), $pop0
	call    	exit, $0
	unreachable
func_end4:
	.size	main, func_end4-main

	.type	val,@object             # @val
	.data
	.globl	val
	.align	2
val:
	.int32	1577058304              # 0x5e000000
	.size	val, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
