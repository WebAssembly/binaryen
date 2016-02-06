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
	tee_local	$push25=, $5=, $pop0
	i32.load	$1=, 0($pop25)
	i32.const	$4=, 0
	copy_local	$3=, $1
	block
	block
	i32.const	$push24=, 1
	i32.le_s	$push1=, $1, $pop24
	br_if   	$pop1, 0        # 0: down to label1
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push31=, 1
	i32.add 	$push2=, $1, $pop31
	i32.const	$push30=, 1
	i32.shr_s	$push3=, $pop2, $pop30
	tee_local	$push29=, $7=, $pop3
	i32.add 	$1=, $pop29, $4
	i32.const	$push4=, 2
	i32.shl 	$push5=, $1, $pop4
	i32.add 	$push6=, $5, $pop5
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop6, $pop7
	i32.load	$push9=, 0($pop8)
	i64.load	$push10=, 0($pop9)
	i64.gt_u	$push11=, $pop10, $0
	tee_local	$push28=, $6=, $pop11
	i32.select	$4=, $4, $1, $pop28
	i32.select	$2=, $1, $3, $6
	i32.sub 	$push12=, $3, $1
	i32.select	$1=, $7, $pop12, $6
	copy_local	$3=, $2
	i32.const	$push27=, 1
	i32.gt_s	$push13=, $1, $pop27
	br_if   	$pop13, 0       # 0: up to label2
# BB#2:                                 # %while.cond8.preheader
	end_loop                        # label3:
	i32.const	$3=, 0
	i32.const	$push14=, -1
	i32.le_s	$push15=, $4, $pop14
	br_if   	$pop15, 1       # 1: down to label0
.LBB0_3:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push16=, 2
	i32.shl 	$push17=, $4, $pop16
	i32.add 	$push18=, $pop17, $5
	i32.const	$push19=, 4
	i32.add 	$1=, $pop18, $pop19
	i32.const	$push26=, 1
	i32.add 	$4=, $4, $pop26
.LBB0_4:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	copy_local	$3=, $5
	i32.load	$push20=, 0($1)
	i64.load	$push21=, 8($pop20)
	i64.gt_u	$push22=, $pop21, $0
	br_if   	$pop22, 1       # 1: down to label5
# BB#5:                                 # %while.cond8
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push34=, -1
	i32.add 	$4=, $4, $pop34
	i32.const	$push33=, -4
	i32.add 	$1=, $1, $pop33
	i32.const	$3=, 0
	i32.const	$push32=, 1
	i32.ge_s	$push23=, $4, $pop32
	br_if   	$pop23, 0       # 0: up to label4
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
