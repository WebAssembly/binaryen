	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020402-3.c"
	.section	.text.blockvector_for_pc_sect,"ax",@progbits
	.hidden	blockvector_for_pc_sect
	.globl	blockvector_for_pc_sect
	.type	blockvector_for_pc_sect,@function
blockvector_for_pc_sect:                # @blockvector_for_pc_sect
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	tee_local	$push26=, $5=, $pop0
	i32.load	$1=, 0($pop26)
	i32.const	$4=, 0
	copy_local	$3=, $1
	block
	block
	i32.const	$push25=, 1
	i32.le_s	$push1=, $1, $pop25
	br_if   	$pop1, 0        # 0: down to label1
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push33=, 1
	i32.add 	$push2=, $1, $pop33
	i32.const	$push32=, 1
	i32.shr_s	$push3=, $pop2, $pop32
	tee_local	$push31=, $7=, $pop3
	i32.add 	$push4=, $pop31, $4
	tee_local	$push30=, $1=, $pop4
	i32.const	$push5=, 2
	i32.shl 	$push6=, $pop30, $pop5
	i32.add 	$push7=, $5, $pop6
	i32.const	$push8=, 4
	i32.add 	$push9=, $pop7, $pop8
	i32.load	$push10=, 0($pop9)
	i64.load	$push11=, 0($pop10)
	i64.gt_u	$push12=, $pop11, $0
	tee_local	$push29=, $6=, $pop12
	i32.select	$4=, $pop29, $4, $1
	i32.select	$2=, $6, $1, $3
	i32.sub 	$push13=, $3, $1
	i32.select	$1=, $6, $7, $pop13
	copy_local	$3=, $2
	i32.const	$push28=, 1
	i32.gt_s	$push14=, $1, $pop28
	br_if   	$pop14, 0       # 0: up to label2
# BB#2:                                 # %while.cond8.preheader
	end_loop                        # label3:
	i32.const	$3=, 0
	i32.const	$push15=, -1
	i32.le_s	$push16=, $4, $pop15
	br_if   	$pop16, 1       # 1: down to label0
.LBB0_3:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push17=, 2
	i32.shl 	$push18=, $4, $pop17
	i32.add 	$push19=, $pop18, $5
	i32.const	$push20=, 4
	i32.add 	$1=, $pop19, $pop20
	i32.const	$push27=, 1
	i32.add 	$4=, $4, $pop27
.LBB0_4:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	copy_local	$3=, $5
	i32.load	$push21=, 0($1)
	i64.load	$push22=, 8($pop21)
	i64.gt_u	$push23=, $pop22, $0
	br_if   	$pop23, 1       # 1: down to label5
# BB#5:                                 # %while.cond8
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push36=, -1
	i32.add 	$4=, $4, $pop36
	i32.const	$push35=, -4
	i32.add 	$1=, $1, $pop35
	i32.const	$3=, 0
	i32.const	$push34=, 1
	i32.ge_s	$push24=, $4, $pop34
	br_if   	$pop24, 0       # 0: up to label4
.LBB0_6:                                # %cleanup
	end_loop                        # label5:
	end_block                       # label0:
	return  	$3
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
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
