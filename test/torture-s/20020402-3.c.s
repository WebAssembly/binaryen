	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020402-3.c"
	.section	.text.blockvector_for_pc_sect,"ax",@progbits
	.hidden	blockvector_for_pc_sect
	.globl	blockvector_for_pc_sect
	.type	blockvector_for_pc_sect,@function
blockvector_for_pc_sect:                # @blockvector_for_pc_sect
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	block   	
	block   	
	i32.load	$push23=, 0($1)
	tee_local	$push22=, $7=, $pop23
	i32.load	$push21=, 0($pop22)
	tee_local	$push20=, $1=, $pop21
	i32.const	$push19=, 2
	i32.lt_s	$push0=, $pop20, $pop19
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.const	$6=, 0
	copy_local	$5=, $1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push36=, 1
	i32.add 	$push1=, $1, $pop36
	i32.const	$push35=, 1
	i32.shr_s	$push34=, $pop1, $pop35
	tee_local	$push33=, $2=, $pop34
	i32.add 	$push32=, $pop33, $6
	tee_local	$push31=, $1=, $pop32
	i32.sub 	$3=, $5, $pop31
	i32.const	$push30=, 2
	i32.shl 	$push2=, $1, $pop30
	i32.add 	$push3=, $7, $pop2
	i32.const	$push29=, 4
	i32.add 	$push4=, $pop3, $pop29
	i32.load	$push5=, 0($pop4)
	i64.load	$push6=, 0($pop5)
	i64.gt_u	$push28=, $pop6, $0
	tee_local	$push27=, $4=, $pop28
	i32.select	$5=, $1, $5, $pop27
	i32.select	$6=, $6, $1, $4
	i32.select	$push26=, $2, $3, $4
	tee_local	$push25=, $1=, $pop26
	i32.const	$push24=, 1
	i32.gt_s	$push7=, $pop25, $pop24
	br_if   	0, $pop7        # 0: up to label2
# BB#3:                                 # %while.cond8.preheader
	end_loop
	i32.const	$push8=, -1
	i32.le_s	$push9=, $6, $pop8
	br_if   	1, $pop9        # 1: down to label0
.LBB0_4:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push38=, 1
	i32.add 	$5=, $6, $pop38
	i32.const	$push37=, 2
	i32.shl 	$push10=, $6, $pop37
	i32.add 	$push11=, $7, $pop10
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
# BB#6:                                 # %while.cond8
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push43=, -4
	i32.add 	$1=, $1, $pop43
	i32.const	$push42=, -1
	i32.add 	$push41=, $5, $pop42
	tee_local	$push40=, $5=, $pop41
	i32.const	$push39=, 1
	i32.ge_s	$push16=, $pop40, $pop39
	br_if   	0, $pop16       # 0: up to label4
# BB#7:
	end_loop
	i32.const	$push17=, 0
	return  	$pop17
.LBB0_8:                                # %cleanup
	end_block                       # label3:
	return  	$7
.LBB0_9:
	end_block                       # label0:
	i32.const	$push18=, 0
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end0:
	.size	blockvector_for_pc_sect, .Lfunc_end0-blockvector_for_pc_sect

	.section	.text.main,"ax",@progbits
	.hidden	main
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


	.ident	"clang version 4.0.0 "
