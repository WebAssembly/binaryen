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
	loop                            # label2:
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
# BB#3:                                 # %while.cond8.preheader
	end_loop                        # label3:
	i32.const	$5=, 0
	i32.const	$push8=, -1
	i32.le_s	$push9=, $7, $pop8
	br_if   	1, $pop9        # 1: down to label0
.LBB0_4:                                # %while.body10.preheader
	end_block                       # label1:
	i32.const	$push36=, 1
	i32.add 	$6=, $7, $pop36
	i32.const	$push35=, 2
	i32.shl 	$push10=, $7, $pop35
	i32.add 	$push11=, $2, $pop10
	i32.const	$push12=, 4
	i32.add 	$1=, $pop11, $pop12
.LBB0_5:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push13=, 0($1)
	i64.load	$push14=, 8($pop13)
	i64.gt_u	$push15=, $pop14, $0
	br_if   	1, $pop15       # 1: down to label5
# BB#6:                                 # %while.cond8
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push41=, -4
	i32.add 	$1=, $1, $pop41
	i32.const	$5=, 0
	i32.const	$push40=, -1
	i32.add 	$push39=, $6, $pop40
	tee_local	$push38=, $6=, $pop39
	i32.const	$push37=, 1
	i32.ge_s	$push16=, $pop38, $pop37
	br_if   	0, $pop16       # 0: up to label4
	br      	2               # 2: down to label0
.LBB0_7:
	end_loop                        # label5:
	copy_local	$5=, $2
.LBB0_8:                                # %cleanup
	end_block                       # label0:
	copy_local	$push42=, $5
                                        # fallthrough-return: $pop42
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


	.ident	"clang version 3.9.0 "
