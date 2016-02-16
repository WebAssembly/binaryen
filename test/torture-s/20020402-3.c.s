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
	i32.load	$push23=, 0($1)
	tee_local	$push22=, $5=, $pop23
	i32.load	$1=, 0($pop22)
	i32.const	$4=, 0
	copy_local	$3=, $1
	block
	block
	i32.const	$push21=, 1
	i32.le_s	$push0=, $1, $pop21
	br_if   	0, $pop0        # 0: down to label1
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push31=, 1
	i32.add 	$push1=, $1, $pop31
	i32.const	$push30=, 1
	i32.shr_s	$push29=, $pop1, $pop30
	tee_local	$push28=, $7=, $pop29
	i32.add 	$1=, $pop28, $4
	i32.const	$push2=, 2
	i32.shl 	$push3=, $1, $pop2
	i32.add 	$push4=, $5, $pop3
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop4, $pop5
	i32.load	$push7=, 0($pop6)
	i64.load	$push8=, 0($pop7)
	i64.gt_u	$push27=, $pop8, $0
	tee_local	$push26=, $6=, $pop27
	i32.select	$4=, $4, $1, $pop26
	i32.select	$2=, $1, $3, $6
	i32.sub 	$push9=, $3, $1
	i32.select	$1=, $7, $pop9, $6
	copy_local	$3=, $2
	i32.const	$push25=, 1
	i32.gt_s	$push10=, $1, $pop25
	br_if   	0, $pop10       # 0: up to label2
# BB#2:                                 # %while.cond8.preheader
	end_loop                        # label3:
	i32.const	$3=, 0
	i32.const	$push11=, -1
	i32.le_s	$push12=, $4, $pop11
	br_if   	1, $pop12       # 1: down to label0
.LBB0_3:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push13=, 2
	i32.shl 	$push14=, $4, $pop13
	i32.add 	$push15=, $pop14, $5
	i32.const	$push16=, 4
	i32.add 	$1=, $pop15, $pop16
	i32.const	$push24=, 1
	i32.add 	$4=, $4, $pop24
.LBB0_4:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	copy_local	$3=, $5
	i32.load	$push17=, 0($1)
	i64.load	$push18=, 8($pop17)
	i64.gt_u	$push19=, $pop18, $0
	br_if   	1, $pop19       # 1: down to label5
# BB#5:                                 # %while.cond8
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push34=, -1
	i32.add 	$4=, $4, $pop34
	i32.const	$push33=, -4
	i32.add 	$1=, $1, $pop33
	i32.const	$3=, 0
	i32.const	$push32=, 1
	i32.ge_s	$push20=, $4, $pop32
	br_if   	0, $pop20       # 0: up to label4
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
