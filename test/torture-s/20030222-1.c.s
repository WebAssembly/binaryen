	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030222-1.c"
	.section	.text.ll_to_int,"ax",@progbits
	.hidden	ll_to_int
	.globl	ll_to_int
	.type	ll_to_int,@function
ll_to_int:                              # @ll_to_int
	.param  	i64, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i64.store32	$discard=, 0($1), $0
	return
	.endfunc
.Lfunc_end0:
	.size	ll_to_int, .Lfunc_end0-ll_to_int

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$4=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	i32.const	$1=, 0
	i32.load	$1=, val($1)
	i64.extend_s/i32	$0=, $1
	#APP
	#NO_APP
	i64.store32	$discard=, 12($4), $0
	block
	i32.load	$push0=, 12($4)
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	val                     # @val
	.type	val,@object
	.section	.data.val,"aw",@progbits
	.globl	val
	.p2align	2
val:
	.int32	2147483649              # 0x80000001
	.size	val, 4


	.ident	"clang version 3.9.0 "
