	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020402-3.c"
	.section	.text.blockvector_for_pc_sect,"ax",@progbits
	.hidden	blockvector_for_pc_sect
	.globl	blockvector_for_pc_sect
	.type	blockvector_for_pc_sect,@function
blockvector_for_pc_sect:                # @blockvector_for_pc_sect
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($1)
	i32.load	$1=, 0($2)
	i32.const	$4=, 1
	i32.const	$8=, 0
	copy_local	$7=, $1
	block
	block
	i32.le_s	$push0=, $1, $4
	br_if   	$pop0, 0        # 0: down to label1
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.add 	$push1=, $1, $4
	i32.shr_s	$5=, $pop1, $4
	i32.add 	$1=, $5, $8
	i32.const	$push2=, 2
	i32.shl 	$push3=, $1, $pop2
	i32.add 	$push4=, $2, $pop3
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop4, $pop5
	i32.load	$push7=, 0($pop6)
	i64.load	$push8=, 0($pop7)
	i64.gt_u	$6=, $pop8, $0
	i32.select	$8=, $6, $8, $1
	i32.select	$3=, $6, $1, $7
	i32.sub 	$push9=, $7, $1
	i32.select	$1=, $6, $5, $pop9
	copy_local	$7=, $3
	i32.gt_s	$push10=, $1, $4
	br_if   	$pop10, 0       # 0: up to label2
# BB#2:                                 # %while.cond8.preheader
	end_loop                        # label3:
	i32.const	$7=, 0
	i32.const	$push11=, -1
	i32.le_s	$push12=, $8, $pop11
	br_if   	$pop12, 1       # 1: down to label0
.LBB0_3:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push13=, 2
	i32.shl 	$push14=, $8, $pop13
	i32.add 	$push15=, $pop14, $2
	i32.const	$push16=, 4
	i32.add 	$1=, $pop15, $pop16
	i32.add 	$6=, $8, $4
.LBB0_4:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	copy_local	$7=, $2
	i32.load	$push17=, 0($1)
	i64.load	$push18=, 8($pop17)
	i64.gt_u	$push19=, $pop18, $0
	br_if   	$pop19, 1       # 1: down to label5
# BB#5:                                 # %while.cond8
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push20=, -1
	i32.add 	$6=, $6, $pop20
	i32.const	$push21=, -4
	i32.add 	$1=, $1, $pop21
	i32.const	$7=, 0
	i32.ge_s	$push22=, $6, $4
	br_if   	$pop22, 0       # 0: up to label4
.LBB0_6:                                # %cleanup
	end_loop                        # label5:
	end_block                       # label0:
	return  	$7
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
	.section	".note.GNU-stack","",@progbits
