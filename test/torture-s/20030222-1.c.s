	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030222-1.c"
	.globl	ll_to_int
	.type	ll_to_int,@function
ll_to_int:                              # @ll_to_int
	.param  	i64, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i64.store32	$discard=, 0($1), $0
	return
.Lfunc_end0:
	.size	ll_to_int, .Lfunc_end0-ll_to_int

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$5=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	i32.const	$1=, 0
	i32.load	$2=, val($1)
	i64.extend_s/i32	$0=, $2
	#APP
	#NO_APP
	i64.store32	$discard=, 12($5), $0
	block   	.LBB1_2
	i32.load	$push0=, 12($5)
	i32.ne  	$push1=, $pop0, $2
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	call    	exit, $1
	unreachable
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	val,@object             # @val
	.data
	.globl	val
	.align	2
val:
	.int32	2147483649              # 0x80000001
	.size	val, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
