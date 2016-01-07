	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-1.c"
	.globl	good_const
	.type	good_const,@function
good_const:                             # @good_const
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	good_const, .Lfunc_end0-good_const

	.globl	good_enum
	.type	good_enum,@function
good_enum:                              # @good_enum
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	good_enum, .Lfunc_end1-good_enum

	.globl	good_expr
	.type	good_expr,@function
good_expr:                              # @good_expr
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end2:
	.size	good_expr, .Lfunc_end2-good_expr

	.globl	good_vararg
	.type	good_vararg,@function
good_vararg:                            # @good_vararg
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end3:
	.size	good_vararg, .Lfunc_end3-good_vararg

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	arr,@object             # @arr
	.bss
	.globl	arr
	.align	4
arr:
	.zero	40
	.size	arr, 40


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
