	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20101013-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	build_ref_for_offset@FUNCTION
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.build_ref_for_offset,"ax",@progbits
	.type	build_ref_for_offset,@function
build_ref_for_offset:                   # @build_ref_for_offset
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push12=, $pop4, $pop5
	i32.store	$push14=, __stack_pointer($pop6), $pop12
	tee_local	$push13=, $0=, $pop14
	i32.const	$push10=, 8
	i32.add 	$push11=, $pop13, $pop10
	call    	get_addr_base_and_unit_offset@FUNCTION, $pop11
	i64.load	$push1=, 8($0)
	i64.const	$push0=, 4
	i64.add 	$push2=, $pop1, $pop0
	call    	build_int_cst@FUNCTION, $pop2
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	build_ref_for_offset, .Lfunc_end1-build_ref_for_offset

	.section	.text.get_addr_base_and_unit_offset,"ax",@progbits
	.type	get_addr_base_and_unit_offset,@function
get_addr_base_and_unit_offset:          # @get_addr_base_and_unit_offset
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	$drop=, 0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	get_addr_base_and_unit_offset, .Lfunc_end2-get_addr_base_and_unit_offset

	.section	.text.build_int_cst,"ax",@progbits
	.type	build_int_cst,@function
build_int_cst:                          # @build_int_cst
	.param  	i64
# BB#0:                                 # %entry
	block
	i64.const	$push0=, 4
	i64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB3_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	build_int_cst, .Lfunc_end3-build_int_cst


	.ident	"clang version 3.9.0 "
	.functype	abort, void
