	.text
	.file	"20101013-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	build_ref_for_offset@FUNCTION
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.build_ref_for_offset,"ax",@progbits
	.type	build_ref_for_offset,@function # -- Begin function build_ref_for_offset
build_ref_for_offset:                   # @build_ref_for_offset
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push10=, 8
	i32.add 	$push11=, $0, $pop10
	call    	get_addr_base_and_unit_offset@FUNCTION, $pop11
	i64.load	$push1=, 8($0)
	i64.const	$push0=, 4
	i64.add 	$push2=, $pop1, $pop0
	call    	build_int_cst@FUNCTION, $pop2
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	build_ref_for_offset, .Lfunc_end1-build_ref_for_offset
                                        # -- End function
	.section	.text.get_addr_base_and_unit_offset,"ax",@progbits
	.type	get_addr_base_and_unit_offset,@function # -- Begin function get_addr_base_and_unit_offset
get_addr_base_and_unit_offset:          # @get_addr_base_and_unit_offset
	.param  	i32
# %bb.0:                                # %entry
	i64.const	$push0=, 0
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	get_addr_base_and_unit_offset, .Lfunc_end2-get_addr_base_and_unit_offset
                                        # -- End function
	.section	.text.build_int_cst,"ax",@progbits
	.type	build_int_cst,@function # -- Begin function build_int_cst
build_int_cst:                          # @build_int_cst
	.param  	i64
# %bb.0:                                # %entry
	block   	
	i64.const	$push0=, 4
	i64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB3_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	build_int_cst, .Lfunc_end3-build_int_cst
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
