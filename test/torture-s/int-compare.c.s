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
.Lfunc_end0:
	.size	gt, .Lfunc_end0-gt

	.globl	ge
	.type	ge,@function
ge:                                     # @ge
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ge_s	$push0=, $0, $1
	return  	$pop0
.Lfunc_end1:
	.size	ge, .Lfunc_end1-ge

	.globl	lt
	.type	lt,@function
lt:                                     # @lt
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.lt_s	$push0=, $0, $1
	return  	$pop0
.Lfunc_end2:
	.size	lt, .Lfunc_end2-lt

	.globl	le
	.type	le,@function
le:                                     # @le
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.le_s	$push0=, $0, $1
	return  	$pop0
.Lfunc_end3:
	.size	le, .Lfunc_end3-le

	.globl	true
	.type	true,@function
true:                                   # @true
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB4_2
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB4_2
# BB#1:                                 # %if.end
	return
.LBB4_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end4:
	.size	true, .Lfunc_end4-true

	.globl	false
	.type	false,@function
false:                                  # @false
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB5_2
	br_if   	$0, .LBB5_2
# BB#1:                                 # %if.end
	return
.LBB5_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end5:
	.size	false, .Lfunc_end5-false

	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %true.exit
	return  	$0
.Lfunc_end6:
	.size	f, .Lfunc_end6-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end7:
	.size	main, .Lfunc_end7-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
