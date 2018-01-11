	.text
	.file	"20080519-1.c"
	.section	.text.merge_overlapping_regs,"ax",@progbits
	.hidden	merge_overlapping_regs  # -- Begin function merge_overlapping_regs
	.globl	merge_overlapping_regs
	.type	merge_overlapping_regs,@function
merge_overlapping_regs:                 # @merge_overlapping_regs
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push4=, -1
	i32.ne  	$push1=, $pop0, $pop4
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push2=, 4($0)
	i32.const	$push5=, -1
	i32.ne  	$push3=, $pop2, $pop5
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	merge_overlapping_regs, .Lfunc_end0-merge_overlapping_regs
                                        # -- End function
	.section	.text.regrename_optimize,"ax",@progbits
	.hidden	regrename_optimize      # -- Begin function regrename_optimize
	.globl	regrename_optimize
	.type	regrename_optimize,@function
regrename_optimize:                     # @regrename_optimize
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push24=, 0
	i32.load	$push23=, __stack_pointer($pop24)
	i32.const	$push25=, 16
	i32.sub 	$5=, $pop23, $pop25
	i32.const	$push26=, 0
	i32.store	__stack_pointer($pop26), $5
	i64.const	$push0=, 0
	i64.store	8($5):p2align=2, $pop0
	i32.load	$4=, 0($0)
	block   	
	i32.eqz 	$push38=, $4
	br_if   	0, $pop38       # 0: down to label1
# %bb.1:                                # %for.body.preheader
	i32.const	$2=, 0
	i32.const	$3=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	copy_local	$1=, $4
	i32.load	$push1=, 4($0)
	i32.const	$push36=, 3
	i32.shl 	$4=, $pop1, $pop36
	i32.const	$push35=, reg_class_contents+4
	i32.add 	$push2=, $4, $pop35
	i32.load	$push3=, 0($pop2)
	i32.const	$push34=, -1
	i32.xor 	$push4=, $pop3, $pop34
	i32.or  	$2=, $2, $pop4
	i32.const	$push33=, reg_class_contents
	i32.add 	$push5=, $4, $pop33
	i32.load	$push6=, 0($pop5)
	i32.const	$push32=, -1
	i32.xor 	$push7=, $pop6, $pop32
	i32.or  	$3=, $3, $pop7
	i32.load	$4=, 0($1)
	copy_local	$0=, $1
	br_if   	0, $4           # 0: up to label2
# %bb.3:                                # %if.end
	end_loop
	i32.load	$push8=, 4($1)
	i32.const	$push9=, 3
	i32.shl 	$4=, $pop8, $pop9
	i32.const	$push16=, 12
	i32.add 	$push17=, $5, $pop16
	i32.const	$push10=, reg_class_contents+4
	i32.add 	$push11=, $4, $pop10
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, -1
	i32.xor 	$push14=, $pop12, $pop13
	i32.or  	$push15=, $2, $pop14
	i32.store	0($pop17), $pop15
	i32.const	$push18=, reg_class_contents
	i32.add 	$push19=, $4, $pop18
	i32.load	$push20=, 0($pop19)
	i32.const	$push37=, -1
	i32.xor 	$push21=, $pop20, $pop37
	i32.or  	$push22=, $3, $pop21
	i32.store	8($5), $pop22
	i32.const	$push30=, 8
	i32.add 	$push31=, $5, $pop30
	call    	merge_overlapping_regs@FUNCTION, $pop31
.LBB1_4:                                # %cleanup
	end_block                       # label1:
	i32.const	$push29=, 0
	i32.const	$push27=, 16
	i32.add 	$push28=, $5, $pop27
	i32.store	__stack_pointer($pop29), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	regrename_optimize, .Lfunc_end1-regrename_optimize
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	i64.const	$push0=, 0
	i64.store	8($0), $pop0
	i32.const	$push2=, 0
	i64.const	$push1=, -1
	i64.store	reg_class_contents($pop2), $pop1
	i32.const	$push15=, 0
	i64.const	$push14=, 0
	i64.store	reg_class_contents+8($pop15), $pop14
	i32.const	$push3=, 1
	i32.store	4($0), $pop3
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.store	0($0), $pop12
	call    	regrename_optimize@FUNCTION, $0
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push13=, 0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	reg_class_contents      # @reg_class_contents
	.type	reg_class_contents,@object
	.section	.bss.reg_class_contents,"aw",@nobits
	.globl	reg_class_contents
	.p2align	4
reg_class_contents:
	.skip	16
	.size	reg_class_contents, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
