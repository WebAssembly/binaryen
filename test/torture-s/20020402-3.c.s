	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020402-3.c"
	.section	.text.blockvector_for_pc_sect,"ax",@progbits
	.hidden	blockvector_for_pc_sect
	.globl	blockvector_for_pc_sect
	.type	blockvector_for_pc_sect,@function
blockvector_for_pc_sect:                # @blockvector_for_pc_sect
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 16
	i32.sub 	$push38=, $pop25, $pop26
	tee_local	$push37=, $5=, $pop38
	i32.const	$push36=, 0
	i32.store	$drop=, 12($pop37), $pop36
	i32.load	$push35=, 0($1)
	tee_local	$push34=, $2=, $pop35
	i32.load	$push33=, 0($pop34)
	tee_local	$push32=, $1=, $pop33
	i32.store	$drop=, 8($5), $pop32
	block
	block
	block
	i32.const	$push31=, 2
	i32.lt_s	$push0=, $1, $pop31
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, 0
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push27=, 8
	i32.add 	$push28=, $5, $pop27
	i32.const	$push29=, 12
	i32.add 	$push30=, $5, $pop29
	i32.const	$push49=, 1
	i32.add 	$push1=, $1, $pop49
	i32.const	$push48=, 1
	i32.shr_s	$push2=, $pop1, $pop48
	i32.add 	$push47=, $pop2, $3
	tee_local	$push46=, $3=, $pop47
	i32.const	$push45=, 2
	i32.shl 	$push3=, $pop46, $pop45
	i32.add 	$push4=, $2, $pop3
	i32.const	$push44=, 4
	i32.add 	$push5=, $pop4, $pop44
	i32.load	$push6=, 0($pop5)
	i64.load	$push7=, 0($pop6)
	i64.gt_u	$push8=, $pop7, $0
	i32.select	$push9=, $pop28, $pop30, $pop8
	i32.store	$drop=, 0($pop9), $3
	i32.load	$push10=, 8($5)
	i32.load	$push43=, 12($5)
	tee_local	$push42=, $3=, $pop43
	i32.sub 	$push41=, $pop10, $pop42
	tee_local	$push40=, $1=, $pop41
	i32.const	$push39=, 1
	i32.gt_s	$push11=, $pop40, $pop39
	br_if   	0, $pop11       # 0: up to label3
# BB#3:                                 # %while.cond8.preheader
	end_loop                        # label4:
	i32.const	$4=, 0
	i32.const	$push12=, -1
	i32.le_s	$push13=, $3, $pop12
	br_if   	1, $pop13       # 1: down to label1
.LBB0_4:                                # %while.body10.preheader
	end_block                       # label2:
	i32.const	$push14=, 1
	i32.add 	$1=, $3, $pop14
	i32.const	$push50=, 2
	i32.shl 	$push15=, $3, $pop50
	i32.add 	$push16=, $2, $pop15
	i32.const	$push17=, 4
	i32.add 	$3=, $pop16, $pop17
.LBB0_5:                                # %while.body10
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.load	$push18=, 0($3)
	i64.load	$push19=, 8($pop18)
	i64.gt_u	$push20=, $pop19, $0
	br_if   	3, $pop20       # 3: down to label0
# BB#6:                                 # %if.end15
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push56=, -2
	i32.add 	$push21=, $1, $pop56
	i32.store	$drop=, 12($5), $pop21
	i32.const	$push55=, -4
	i32.add 	$3=, $3, $pop55
	i32.const	$4=, 0
	i32.const	$push54=, -1
	i32.add 	$push53=, $1, $pop54
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 0
	i32.gt_s	$push22=, $pop52, $pop51
	br_if   	0, $pop22       # 0: up to label5
.LBB0_7:                                # %cleanup
	end_loop                        # label6:
	end_block                       # label1:
	return  	$4
.LBB0_8:
	end_block                       # label0:
	copy_local	$push23=, $2
                                        # fallthrough-return: $pop23
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
