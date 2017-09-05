	.text
	.file	"20020402-3.c"
	.section	.text.blockvector_for_pc_sect,"ax",@progbits
	.hidden	blockvector_for_pc_sect # -- Begin function blockvector_for_pc_sect
	.globl	blockvector_for_pc_sect
	.type	blockvector_for_pc_sect,@function
blockvector_for_pc_sect:                # @blockvector_for_pc_sect
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, 0
	block   	
	block   	
	i32.load	$push21=, 0($1)
	tee_local	$push20=, $2=, $pop21
	i32.load	$push19=, 0($pop20)
	tee_local	$push18=, $1=, $pop19
	i32.const	$push17=, 2
	i32.lt_s	$push0=, $pop18, $pop17
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.const	$7=, 0
	copy_local	$6=, $1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push34=, 1
	i32.add 	$push1=, $1, $pop34
	i32.const	$push33=, 1
	i32.shr_s	$push32=, $pop1, $pop33
	tee_local	$push31=, $3=, $pop32
	i32.add 	$push30=, $pop31, $7
	tee_local	$push29=, $1=, $pop30
	i32.sub 	$4=, $6, $pop29
	i32.const	$push28=, 2
	i32.shl 	$push2=, $1, $pop28
	i32.add 	$push3=, $2, $pop2
	i32.const	$push27=, 4
	i32.add 	$push4=, $pop3, $pop27
	i32.load	$push5=, 0($pop4)
	i64.load	$push6=, 0($pop5)
	i64.gt_u	$push26=, $pop6, $0
	tee_local	$push25=, $5=, $pop26
	i32.select	$6=, $1, $6, $pop25
	i32.select	$7=, $7, $1, $5
	i32.select	$push24=, $3, $4, $5
	tee_local	$push23=, $1=, $pop24
	i32.const	$push22=, 1
	i32.gt_s	$push7=, $pop23, $pop22
	br_if   	0, $pop7        # 0: up to label2
# BB#3:                                 # %while.end
	end_loop
	i32.const	$1=, 0
	i32.const	$push35=, 0
	i32.lt_s	$push8=, $7, $pop35
	br_if   	1, $pop8        # 1: down to label0
.LBB0_4:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push37=, 1
	i32.add 	$6=, $7, $pop37
	i32.const	$push36=, 2
	i32.shl 	$push9=, $7, $pop36
	i32.add 	$push10=, $2, $pop9
	i32.const	$push11=, 4
	i32.add 	$1=, $pop10, $pop11
.LBB0_5:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.load	$push12=, 0($1)
	i64.load	$push13=, 8($pop12)
	i64.gt_u	$push14=, $pop13, $0
	br_if   	1, $pop14       # 1: down to label3
# BB#6:                                 # %while.cond8
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push42=, -4
	i32.add 	$1=, $1, $pop42
	i32.const	$push41=, -1
	i32.add 	$push40=, $6, $pop41
	tee_local	$push39=, $6=, $pop40
	i32.const	$push38=, 1
	i32.ge_s	$push15=, $pop39, $pop38
	br_if   	0, $pop15       # 0: up to label4
# BB#7:
	end_loop
	i32.const	$push16=, 0
	return  	$pop16
.LBB0_8:
	end_block                       # label3:
	copy_local	$1=, $2
.LBB0_9:                                # %cleanup
	end_block                       # label0:
	copy_local	$push43=, $1
                                        # fallthrough-return: $pop43
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
