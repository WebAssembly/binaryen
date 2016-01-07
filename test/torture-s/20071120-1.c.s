	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071120-1.c"
	.globl	vec_assert_fail
	.type	vec_assert_fail,@function
vec_assert_fail:                        # @vec_assert_fail
# BB#0:                                 # %entry
	call    	abort
	unreachable
.Lfunc_end0:
	.size	vec_assert_fail, .Lfunc_end0-vec_assert_fail

	.globl	perform_access_checks
	.type	perform_access_checks,@function
perform_access_checks:                  # @perform_access_checks
	.param  	i32
# BB#0:                                 # %entry
	call    	abort
	unreachable
.Lfunc_end1:
	.size	perform_access_checks, .Lfunc_end1-perform_access_checks

	.globl	pop_to_parent_deferring_access_checks
	.type	pop_to_parent_deferring_access_checks,@function
pop_to_parent_deferring_access_checks:  # @pop_to_parent_deferring_access_checks
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, deferred_access_no_check($1)
	block   	.LBB2_9
	block   	.LBB2_8
	block   	.LBB2_7
	block   	.LBB2_6
	block   	.LBB2_2
	i32.const	$push11=, 0
	i32.eq  	$push12=, $0, $pop11
	br_if   	$pop12, .LBB2_2
# BB#1:                                 # %if.then
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.store	$discard=, deferred_access_no_check($1), $pop1
	br      	.LBB2_6
.LBB2_2:                                  # %if.else
	i32.load	$1=, deferred_access_stack($1)
	i32.const	$push13=, 0
	i32.eq  	$push14=, $1, $pop13
	br_if   	$pop14, .LBB2_9
# BB#3:                                 # %land.lhs.true.i
	i32.load	$0=, 0($1)
	i32.const	$push15=, 0
	i32.eq  	$push16=, $0, $pop15
	br_if   	$pop16, .LBB2_9
# BB#4:                                 # %land.lhs.true.i25
	i32.const	$push2=, -1
	i32.add 	$push3=, $0, $pop2
	i32.store	$push4=, 0($1), $pop3
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop4, $pop17
	br_if   	$pop18, .LBB2_8
# BB#5:                                 # %VEC_deferred_access_base_last.exit29
	i32.const	$push5=, 3
	i32.shl 	$push6=, $0, $pop5
	i32.add 	$push7=, $pop6, $1
	i32.const	$push8=, -8
	i32.add 	$push9=, $pop7, $pop8
	i32.load	$push10=, 0($pop9)
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop10, $pop19
	br_if   	$pop20, .LBB2_7
.LBB2_6:                                  # %if.end16
	return
.LBB2_7:                                  # %if.then15
	call    	perform_access_checks, $1
	unreachable
.LBB2_8:                                  # %cond.false.i26
	call    	vec_assert_fail
	unreachable
.LBB2_9:                                  # %cond.false.i
	call    	vec_assert_fail
	unreachable
.Lfunc_end2:
	.size	pop_to_parent_deferring_access_checks, .Lfunc_end2-pop_to_parent_deferring_access_checks

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 76
	i32.call	$1=, __builtin_malloc, $pop0
	i32.const	$0=, 0
	i32.store	$discard=, deferred_access_stack($0), $1
	i32.const	$push1=, 2
	i32.store	$discard=, 0($1), $pop1
	i32.const	$push2=, 8
	i32.add 	$push3=, $1, $pop2
	i32.const	$push4=, 1
	i32.store	$discard=, 0($pop3), $pop4
	call    	pop_to_parent_deferring_access_checks
	return  	$0
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	deferred_access_no_check,@object # @deferred_access_no_check
	.lcomm	deferred_access_no_check,4,2
	.type	gt_pch_rs_gt_cp_semantics_h,@object # @gt_pch_rs_gt_cp_semantics_h
	.section	.data.rel.ro,"aw",@progbits
	.globl	gt_pch_rs_gt_cp_semantics_h
	.align	2
gt_pch_rs_gt_cp_semantics_h:
	.int32	deferred_access_no_check
	.size	gt_pch_rs_gt_cp_semantics_h, 4

	.type	deferred_access_stack,@object # @deferred_access_stack
	.lcomm	deferred_access_stack,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
