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
	i32.load	$push23=, 0($1)
	tee_local	$push22=, $5=, $pop23
	i32.load	$push21=, 0($pop22)
	tee_local	$push20=, $1=, $pop21
	i32.const	$push19=, 1
	i32.le_s	$push0=, $pop20, $pop19
	br_if   	0, $pop0        # 0: down to label1
# BB#1:
	copy_local	$3=, $1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push33=, 1
	i32.add 	$push1=, $1, $pop33
	i32.const	$push32=, 1
	i32.shr_s	$push31=, $pop1, $pop32
	tee_local	$push30=, $7=, $pop31
	i32.add 	$1=, $pop30, $4
	i32.const	$push29=, 2
	i32.shl 	$push2=, $1, $pop29
	i32.add 	$push3=, $5, $pop2
	i32.const	$push28=, 4
	i32.add 	$push4=, $pop3, $pop28
	i32.load	$push5=, 0($pop4)
	i64.load	$push6=, 0($pop5)
	i64.gt_u	$push27=, $pop6, $0
	tee_local	$push26=, $6=, $pop27
	i32.select	$4=, $4, $1, $pop26
	i32.select	$2=, $1, $3, $6
	i32.sub 	$push7=, $3, $1
	i32.select	$1=, $7, $pop7, $6
	copy_local	$3=, $2
	i32.const	$push25=, 1
	i32.gt_s	$push8=, $1, $pop25
	br_if   	0, $pop8        # 0: up to label2
# BB#3:                                 # %while.cond8.preheader
	end_loop                        # label3:
	i32.const	$3=, 0
	i32.const	$push9=, -1
	i32.le_s	$push10=, $4, $pop9
	br_if   	1, $pop10       # 1: down to label0
.LBB0_4:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push11=, 2
	i32.shl 	$push12=, $4, $pop11
	i32.add 	$push13=, $5, $pop12
	i32.const	$push14=, 4
	i32.add 	$1=, $pop13, $pop14
	i32.const	$push24=, 1
	i32.add 	$4=, $4, $pop24
.LBB0_5:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push15=, 0($1)
	i64.load	$push16=, 8($pop15)
	i64.gt_u	$push17=, $pop16, $0
	br_if   	1, $pop17       # 1: down to label5
# BB#6:                                 # %while.cond8
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push36=, -1
	i32.add 	$4=, $4, $pop36
	i32.const	$push35=, -4
	i32.add 	$1=, $1, $pop35
	i32.const	$3=, 0
	i32.const	$push34=, 1
	i32.ge_s	$push18=, $4, $pop34
	br_if   	0, $pop18       # 0: up to label4
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
