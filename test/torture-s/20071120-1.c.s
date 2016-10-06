	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071120-1.c"
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push11=, 0
	i32.load	$push10=, deferred_access_no_check($pop11)
	tee_local	$push9=, $0=, $pop10
	i32.eqz 	$push20=, $pop9
	br_if   	0, $pop20       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push12=, 0
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.store	deferred_access_no_check($pop12), $pop1
	return
.LBB2_2:                                # %if.else
	end_block                       # label0:
	block   	
	block   	
	i32.const	$push15=, 0
	i32.load	$push14=, deferred_access_stack($pop15)
	tee_local	$push13=, $0=, $pop14
	i32.eqz 	$push21=, $pop13
	br_if   	0, $pop21       # 0: down to label2
# BB#3:                                 # %land.lhs.true.i
	i32.load	$push17=, 0($0)
	tee_local	$push16=, $1=, $pop17
	i32.eqz 	$push22=, $pop16
	br_if   	0, $pop22       # 0: down to label2
# BB#4:                                 # %land.lhs.true.i25
	i32.const	$push2=, -1
	i32.add 	$push19=, $1, $pop2
	tee_local	$push18=, $2=, $pop19
	i32.store	0($0), $pop18
	i32.eqz 	$push23=, $2
	br_if   	0, $pop23       # 0: down to label2
# BB#5:                                 # %VEC_deferred_access_base_last.exit29
	i32.const	$push3=, 3
	i32.shl 	$push4=, $1, $pop3
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, -8
	i32.add 	$push7=, $pop5, $pop6
	i32.load	$push8=, 0($pop7)
	i32.eqz 	$push24=, $pop8
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
	i32.const	$push0=, 76
	i32.call	$push8=, __builtin_malloc@FUNCTION, $pop0
	tee_local	$push7=, $0=, $pop8
	i32.const	$push1=, 2
	i32.store	0($pop7), $pop1
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	__builtin_malloc, i32
