	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071120-1.c"
	.section	.text.vec_assert_fail,"ax",@progbits
	.hidden	vec_assert_fail
	.globl	vec_assert_fail
	.type	vec_assert_fail,@function
vec_assert_fail:                        # @vec_assert_fail
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vec_assert_fail, .Lfunc_end0-vec_assert_fail

	.section	.text.perform_access_checks,"ax",@progbits
	.hidden	perform_access_checks
	.globl	perform_access_checks
	.type	perform_access_checks,@function
perform_access_checks:                  # @perform_access_checks
	.param  	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	perform_access_checks, .Lfunc_end1-perform_access_checks

	.section	.text.pop_to_parent_deferring_access_checks,"ax",@progbits
	.hidden	pop_to_parent_deferring_access_checks
	.globl	pop_to_parent_deferring_access_checks
	.type	pop_to_parent_deferring_access_checks,@function
pop_to_parent_deferring_access_checks:  # @pop_to_parent_deferring_access_checks
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push13=, 0
	i32.load	$push12=, deferred_access_no_check($pop13)
	tee_local	$push11=, $0=, $pop12
	i32.eqz 	$push20=, $pop11
	br_if   	0, $pop20       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push14=, 0
	i32.const	$push1=, -1
	i32.add 	$push2=, $0, $pop1
	i32.store	$drop=, deferred_access_no_check($pop14), $pop2
	return
.LBB2_2:                                # %if.else
	end_block                       # label0:
	block
	block
	i32.const	$push17=, 0
	i32.load	$push16=, deferred_access_stack($pop17)
	tee_local	$push15=, $0=, $pop16
	i32.eqz 	$push21=, $pop15
	br_if   	0, $pop21       # 0: down to label2
# BB#3:                                 # %land.lhs.true.i
	i32.load	$push19=, 0($0)
	tee_local	$push18=, $1=, $pop19
	i32.eqz 	$push22=, $pop18
	br_if   	0, $pop22       # 0: down to label2
# BB#4:                                 # %land.lhs.true.i25
	i32.const	$push3=, -1
	i32.add 	$push4=, $1, $pop3
	i32.store	$push0=, 0($0), $pop4
	i32.eqz 	$push23=, $pop0
	br_if   	0, $pop23       # 0: down to label2
# BB#5:                                 # %VEC_deferred_access_base_last.exit29
	i32.const	$push5=, 3
	i32.shl 	$push6=, $1, $pop5
	i32.add 	$push7=, $0, $pop6
	i32.const	$push8=, -8
	i32.add 	$push9=, $pop7, $pop8
	i32.load	$push10=, 0($pop9)
	i32.eqz 	$push24=, $pop10
	br_if   	1, $pop24       # 1: down to label1
# BB#6:                                 # %if.end16
	return
.LBB2_7:                                # %cond.false.i26
	end_block                       # label2:
	call    	vec_assert_fail@FUNCTION
	unreachable
.LBB2_8:                                # %if.then15
	end_block                       # label1:
	call    	perform_access_checks@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	pop_to_parent_deferring_access_checks, .Lfunc_end2-pop_to_parent_deferring_access_checks

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 76
	i32.call	$push9=, __builtin_malloc@FUNCTION, $pop1
	tee_local	$push8=, $0=, $pop9
	i32.const	$push2=, 2
	i32.store	$drop=, 0($pop8), $pop2
	i32.const	$push3=, 0
	i32.store	$push0=, deferred_access_stack($pop3), $0
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop0, $pop4
	i32.const	$push6=, 1
	i32.store	$drop=, 0($pop5), $pop6
	call    	pop_to_parent_deferring_access_checks@FUNCTION
	i32.const	$push7=, 0
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	deferred_access_no_check,@object # @deferred_access_no_check
	.lcomm	deferred_access_no_check,4,2
	.hidden	gt_pch_rs_gt_cp_semantics_h # @gt_pch_rs_gt_cp_semantics_h
	.type	gt_pch_rs_gt_cp_semantics_h,@object
	.section	.data.rel.ro.gt_pch_rs_gt_cp_semantics_h,"aw",@progbits
	.globl	gt_pch_rs_gt_cp_semantics_h
	.p2align	2
gt_pch_rs_gt_cp_semantics_h:
	.int32	deferred_access_no_check
	.size	gt_pch_rs_gt_cp_semantics_h, 4

	.type	deferred_access_stack,@object # @deferred_access_stack
	.lcomm	deferred_access_stack,4,2

	.ident	"clang version 3.9.0 "
