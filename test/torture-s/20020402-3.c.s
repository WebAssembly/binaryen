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
	i32.const	$4=, 0
	block
	block
	i32.load	$push22=, 0($1)
	tee_local	$push21=, $5=, $pop22
	i32.load	$push20=, 0($pop21)
	tee_local	$push19=, $1=, $pop20
	i32.const	$push18=, 2
	i32.lt_s	$push1=, $pop19, $pop18
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.const	$4=, 0
	copy_local	$3=, $1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push33=, 1
	i32.add 	$push2=, $1, $pop33
	i32.const	$push32=, 1
	i32.shr_s	$push31=, $pop2, $pop32
	tee_local	$push30=, $7=, $pop31
	i32.add 	$1=, $pop30, $4
	i32.const	$push29=, 2
	i32.shl 	$push3=, $1, $pop29
	i32.add 	$push4=, $5, $pop3
	i32.const	$push28=, 4
	i32.add 	$push5=, $pop4, $pop28
	i32.load	$push6=, 0($pop5)
	i64.load	$push7=, 0($pop6)
	i64.gt_u	$push27=, $pop7, $0
	tee_local	$push26=, $6=, $pop27
	i32.select	$4=, $4, $1, $pop26
	i32.sub 	$2=, $3, $1
	i32.select	$push0=, $1, $3, $6
	copy_local	$3=, $pop0
	i32.select	$push25=, $7, $2, $6
	tee_local	$push24=, $1=, $pop25
	i32.const	$push23=, 1
	i32.gt_s	$push8=, $pop24, $pop23
	br_if   	0, $pop8        # 0: up to label2
# BB#3:                                 # %while.cond8.preheader
	end_loop                        # label3:
	i32.const	$3=, 0
	i32.const	$push9=, -1
	i32.le_s	$push10=, $4, $pop9
	br_if   	1, $pop10       # 1: down to label0
.LBB0_4:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push35=, 2
	i32.shl 	$push11=, $4, $pop35
	i32.add 	$push12=, $5, $pop11
	i32.const	$push13=, 4
	i32.add 	$1=, $pop12, $pop13
	i32.const	$push34=, 1
	i32.add 	$4=, $4, $pop34
.LBB0_5:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push14=, 0($1)
	i64.load	$push15=, 8($pop14)
	i64.gt_u	$push16=, $pop15, $0
	br_if   	1, $pop16       # 1: down to label5
# BB#6:                                 # %while.cond8
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push38=, -1
	i32.add 	$4=, $4, $pop38
	i32.const	$push37=, -4
	i32.add 	$1=, $1, $pop37
	i32.const	$3=, 0
	i32.const	$push36=, 1
	i32.ge_s	$push17=, $4, $pop36
	br_if   	0, $pop17       # 0: up to label4
	br      	2               # 2: down to label0
.LBB0_7:
	end_loop                        # label5:
	copy_local	$3=, $5
.LBB0_8:                                # %cleanup
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
