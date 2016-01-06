	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/int-compare.c"
	.globl	gt
	.type	gt,@function
gt:                                     # @gt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.gt_s	$push0=, $0, $1
	return  	$pop0
func_end0:
	.size	gt, func_end0-gt

	.globl	ge
	.type	ge,@function
ge:                                     # @ge
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ge_s	$push0=, $0, $1
	return  	$pop0
func_end1:
	.size	ge, func_end1-ge

	.globl	lt
	.type	lt,@function
lt:                                     # @lt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_s	$push0=, $0, $1
	return  	$pop0
func_end2:
	.size	lt, func_end2-lt

	.globl	le
	.type	le,@function
le:                                     # @le
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.le_s	$push0=, $0, $1
	return  	$pop0
func_end3:
	.size	le, func_end3-le

	.globl	true
	.type	true,@function
true:                                   # @true
	.param  	i32
# BB#0:                                 # %entry
	block   	BB4_2
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, BB4_2
# BB#1:                                 # %if.end
	return
BB4_2:                                  # %if.then
	call    	abort
	unreachable
func_end4:
	.size	true, func_end4-true

	.globl	false
	.type	false,@function
false:                                  # @false
	.param  	i32
# BB#0:                                 # %entry
	block   	BB5_2
	br_if   	$0, BB5_2
# BB#1:                                 # %if.end
	return
BB5_2:                                  # %if.then
	call    	abort
	unreachable
func_end5:
	.size	false, func_end5-false

	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %true.exit
	return  	$0
func_end6:
	.size	f, func_end6-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end7:
	.size	main, func_end7-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
