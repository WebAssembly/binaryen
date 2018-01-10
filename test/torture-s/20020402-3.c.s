	.text
	.file	"20020402-3.c"
	.section	.text.blockvector_for_pc_sect,"ax",@progbits
	.hidden	blockvector_for_pc_sect # -- Begin function blockvector_for_pc_sect
	.globl	blockvector_for_pc_sect
	.type	blockvector_for_pc_sect,@function
blockvector_for_pc_sect:                # @blockvector_for_pc_sect
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.load	$2=, 0($1)
	i32.load	$3=, 0($2)
	i32.const	$1=, 0
	block   	
	block   	
	i32.const	$push18=, 2
	i32.lt_s	$push0=, $3, $pop18
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %while.body.preheader
	i32.const	$1=, 0
	copy_local	$5=, $3
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push23=, 1
	i32.add 	$push1=, $3, $pop23
	i32.const	$push22=, 1
	i32.shr_s	$push2=, $pop1, $pop22
	i32.add 	$3=, $pop2, $1
	i32.const	$push21=, 2
	i32.shl 	$push3=, $3, $pop21
	i32.add 	$push4=, $2, $pop3
	i32.const	$push20=, 4
	i32.add 	$push5=, $pop4, $pop20
	i32.load	$push6=, 0($pop5)
	i64.load	$push7=, 0($pop6)
	i64.gt_u	$4=, $pop7, $0
	i32.select	$1=, $1, $3, $4
	i32.select	$5=, $3, $5, $4
	i32.sub 	$3=, $5, $1
	i32.const	$push19=, 1
	i32.gt_s	$push8=, $3, $pop19
	br_if   	0, $pop8        # 0: up to label2
# %bb.3:                                # %while.end
	end_loop
	i32.const	$3=, 0
	i32.const	$push24=, 0
	i32.lt_s	$push9=, $1, $pop24
	br_if   	1, $pop9        # 1: down to label0
.LBB0_4:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push26=, 1
	i32.add 	$3=, $1, $pop26
	i32.const	$push25=, 2
	i32.shl 	$push10=, $1, $pop25
	i32.add 	$push11=, $2, $pop10
	i32.const	$push12=, 4
	i32.add 	$1=, $pop11, $pop12
.LBB0_5:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.load	$push13=, 0($1)
	i64.load	$push14=, 8($pop13)
	i64.gt_u	$push15=, $pop14, $0
	br_if   	1, $pop15       # 1: down to label3
# %bb.6:                                # %while.cond8
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push29=, -4
	i32.add 	$1=, $1, $pop29
	i32.const	$push28=, -1
	i32.add 	$3=, $3, $pop28
	i32.const	$push27=, 1
	i32.ge_s	$push16=, $3, $pop27
	br_if   	0, $pop16       # 0: up to label4
# %bb.7:
	end_loop
	i32.const	$push17=, 0
	return  	$pop17
.LBB0_8:
	end_block                       # label3:
	copy_local	$3=, $2
.LBB0_9:                                # %cleanup
	end_block                       # label0:
	copy_local	$push30=, $3
                                        # fallthrough-return: $pop30
	.endfunc
.Lfunc_end0:
	.size	blockvector_for_pc_sect, .Lfunc_end0-blockvector_for_pc_sect
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
