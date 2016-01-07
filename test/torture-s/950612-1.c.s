	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/950612-1.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_s	$1=, $0, $pop0
	i32.add 	$push1=, $0, $1
	i32.xor 	$push2=, $pop1, $1
	return  	$pop2
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_s	$1=, $0, $pop0
	i32.add 	$push1=, $0, $1
	i32.xor 	$push2=, $pop1, $1
	return  	$pop2
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_s	$1=, $0, $pop0
	i64.add 	$push1=, $0, $1
	i64.xor 	$push2=, $pop1, $1
	return  	$pop2
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_s	$1=, $0, $pop0
	i64.add 	$push1=, $0, $1
	i64.xor 	$push2=, $pop1, $1
	return  	$pop2
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond.10
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
