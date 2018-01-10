	.text
	.file	"20071120-1.c"
	.section	.text.vec_assert_fail,"ax",@progbits
	.hidden	vec_assert_fail         # -- Begin function vec_assert_fail
	.globl	vec_assert_fail
	.type	vec_assert_fail,@function
vec_assert_fail:                        # @vec_assert_fail
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vec_assert_fail, .Lfunc_end0-vec_assert_fail
                                        # -- End function
	.section	.text.perform_access_checks,"ax",@progbits
	.hidden	perform_access_checks   # -- Begin function perform_access_checks
	.globl	perform_access_checks
	.type	perform_access_checks,@function
perform_access_checks:                  # @perform_access_checks
	.param  	i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	perform_access_checks, .Lfunc_end1-perform_access_checks
                                        # -- End function
	.section	.text.pop_to_parent_deferring_access_checks,"ax",@progbits
	.hidden	pop_to_parent_deferring_access_checks # -- Begin function pop_to_parent_deferring_access_checks
	.globl	pop_to_parent_deferring_access_checks
	.type	pop_to_parent_deferring_access_checks,@function
pop_to_parent_deferring_access_checks:  # @pop_to_parent_deferring_access_checks
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$0=, deferred_access_no_check($pop9)
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push10=, 0
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.store	deferred_access_no_check($pop10), $pop1
	return
.LBB2_2:                                # %if.else
	end_block                       # label0:
	i32.const	$push11=, 0
	i32.load	$0=, deferred_access_stack($pop11)
	block   	
	block   	
	i32.eqz 	$push13=, $0
	br_if   	0, $pop13       # 0: down to label2
# %bb.3:                                # %land.lhs.true.i
	i32.load	$1=, 0($0)
	i32.eqz 	$push14=, $1
	br_if   	0, $pop14       # 0: down to label2
# %bb.4:                                # %land.lhs.true.i25
	i32.const	$push2=, -1
	i32.add 	$2=, $1, $pop2
	i32.store	0($0), $2
	i32.eqz 	$push15=, $2
	br_if   	0, $pop15       # 0: down to label2
# %bb.5:                                # %VEC_deferred_access_base_last.exit29
	i32.const	$push3=, 3
	i32.shl 	$push4=, $1, $pop3
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, -8
	i32.add 	$push7=, $pop5, $pop6
	i32.load	$push8=, 0($pop7)
	i32.eqz 	$push16=, $pop8
	br_if   	1, $pop16       # 1: down to label1
# %bb.6:                                # %if.end16
	return
.LBB2_7:                                # %cond.false.i
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 76
	i32.call	$0=, __builtin_malloc@FUNCTION, $pop0
	i32.const	$push1=, 2
	i32.store	0($0), $pop1
	i32.const	$push2=, 0
	i32.store	deferred_access_stack($pop2), $0
	i32.const	$push3=, 8
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 1
	i32.store	0($pop4), $pop5
	call    	pop_to_parent_deferring_access_checks@FUNCTION
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.type	deferred_access_no_check,@object # @deferred_access_no_check
	.section	.bss.deferred_access_no_check,"aw",@nobits
	.p2align	2
deferred_access_no_check:
	.int32	0                       # 0x0
	.size	deferred_access_no_check, 4

	.hidden	gt_pch_rs_gt_cp_semantics_h # @gt_pch_rs_gt_cp_semantics_h
	.type	gt_pch_rs_gt_cp_semantics_h,@object
	.section	.rodata.gt_pch_rs_gt_cp_semantics_h,"a",@progbits
	.globl	gt_pch_rs_gt_cp_semantics_h
	.p2align	2
gt_pch_rs_gt_cp_semantics_h:
	.int32	deferred_access_no_check
	.size	gt_pch_rs_gt_cp_semantics_h, 4

	.type	deferred_access_stack,@object # @deferred_access_stack
	.section	.bss.deferred_access_stack,"aw",@nobits
	.p2align	2
deferred_access_stack:
	.int32	0
	.size	deferred_access_stack, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	__builtin_malloc, i32
