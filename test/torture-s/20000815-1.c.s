	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000815-1.c"
	.section	.text.invalidate_memory,"ax",@progbits
	.hidden	invalidate_memory
	.globl	invalidate_memory
	.type	invalidate_memory,@function
invalidate_memory:                      # @invalidate_memory
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load8_u	$push13=, 0($0)
	tee_local	$push12=, $0=, $pop13
	i32.const	$push3=, 4
	i32.and 	$push1=, $pop12, $pop3
	i32.const	$push11=, 255
	i32.and 	$push7=, $pop1, $pop11
	i32.eqz 	$1=, $pop7
	i32.const	$push2=, 8
	i32.and 	$push0=, $0, $pop2
	i32.const	$push10=, 255
	i32.and 	$2=, $pop0, $pop10
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	block
	loop                            # label1:
	block
	i32.const	$push16=, 2
	i32.shl 	$push4=, $3, $pop16
	i32.load	$push15=, table($pop4)
	tee_local	$push14=, $0=, $pop15
	i32.eqz 	$push25=, $pop14
	br_if   	0, $pop25       # 0: down to label3
.LBB0_2:                                # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	copy_local	$push21=, $0
	tee_local	$push20=, $4=, $pop21
	i32.load	$0=, 4($pop20)
	block
	i32.load16_u	$push19=, 36($4)
	tee_local	$push18=, $4=, $pop19
	i32.const	$push17=, 255
	i32.and 	$push5=, $pop18, $pop17
	i32.eqz 	$push26=, $pop5
	br_if   	0, $pop26       # 0: down to label6
# BB#3:                                 # %land.lhs.true
                                        #   in Loop: Header=BB0_2 Depth=2
	br_if   	6, $2           # 6: down to label0
# BB#4:                                 # %land.lhs.true
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push22=, 256
	i32.lt_u	$push8=, $4, $pop22
	i32.or  	$push6=, $1, $pop8
	i32.eqz 	$push27=, $pop6
	br_if   	6, $pop27       # 6: down to label0
.LBB0_5:                                # %for.cond5.backedge
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label6:
	br_if   	0, $0           # 0: up to label4
.LBB0_6:                                # %for.inc15
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push24=, 1
	i32.add 	$3=, $3, $pop24
	i32.const	$push23=, 31
	i32.lt_s	$push9=, $3, $pop23
	br_if   	0, $pop9        # 0: up to label1
# BB#7:                                 # %for.end16
	end_loop                        # label2:
	return
.LBB0_8:                                # %if.then
	end_block                       # label0:
	call    	remove_from_table@FUNCTION, $0, $0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	invalidate_memory, .Lfunc_end0-invalidate_memory

	.section	.text.cse_rtx_addr_varies_p,"ax",@progbits
	.hidden	cse_rtx_addr_varies_p
	.globl	cse_rtx_addr_varies_p
	.type	cse_rtx_addr_varies_p,@function
cse_rtx_addr_varies_p:                  # @cse_rtx_addr_varies_p
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	cse_rtx_addr_varies_p, .Lfunc_end1-cse_rtx_addr_varies_p

	.section	.text.remove_from_table,"ax",@progbits
	.hidden	remove_from_table
	.globl	remove_from_table
	.type	remove_from_table,@function
remove_from_table:                      # @remove_from_table
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	remove_from_table, .Lfunc_end2-remove_from_table

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push10=, __stack_pointer
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 48
	i32.sub 	$push20=, $pop8, $pop9
	i32.store	$push24=, 0($pop10), $pop20
	tee_local	$push23=, $3=, $pop24
	i32.const	$push14=, 8
	i32.add 	$push15=, $pop23, $pop14
	i32.const	$push22=, 0
	i32.const	$push0=, 40
	i32.call	$drop=, memset@FUNCTION, $pop15, $pop22, $pop0
	i32.const	$push1=, 1
	i32.store8	$0=, 44($3), $pop1
	i32.const	$push21=, 0
	i32.const	$push16=, 8
	i32.add 	$push17=, $3, $pop16
	i32.store	$drop=, table($pop21), $pop17
	i32.const	$push18=, 8
	i32.add 	$push19=, $3, $pop18
	copy_local	$2=, $pop19
.LBB3_1:                                # %for.body.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_2 Depth 2
	block
	loop                            # label8:
	block
	i32.eqz 	$push33=, $2
	br_if   	0, $pop33       # 0: down to label10
.LBB3_2:                                # %for.body6.i
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	copy_local	$push30=, $2
	tee_local	$push29=, $4=, $pop30
	i32.load	$2=, 4($pop29)
	block
	i32.load16_u	$push28=, 36($4)
	tee_local	$push27=, $4=, $pop28
	i32.const	$push26=, 256
	i32.lt_u	$push2=, $pop27, $pop26
	br_if   	0, $pop2        # 0: down to label13
# BB#3:                                 # %for.body6.i
                                        #   in Loop: Header=BB3_2 Depth=2
	i32.const	$push31=, 255
	i32.and 	$push3=, $4, $pop31
	br_if   	6, $pop3        # 6: down to label7
.LBB3_4:                                # %for.cond5.backedge.i
                                        #   in Loop: Header=BB3_2 Depth=2
	end_block                       # label13:
	br_if   	0, $2           # 0: up to label11
.LBB3_5:                                # %for.inc15.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_loop                        # label12:
	end_block                       # label10:
	i32.add 	$1=, $1, $0
	i32.const	$push32=, 30
	i32.gt_s	$push4=, $1, $pop32
	br_if   	1, $pop4        # 1: down to label9
# BB#6:                                 # %for.inc15.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push25=, 2
	i32.shl 	$push6=, $1, $pop25
	i32.load	$2=, table($pop6)
	br      	0               # 0: up to label8
.LBB3_7:                                # %invalidate_memory.exit
	end_loop                        # label9:
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 48
	i32.add 	$push12=, $3, $pop11
	i32.store	$drop=, 0($pop13), $pop12
	i32.const	$push5=, 0
	return  	$pop5
.LBB3_8:                                # %if.then.i
	end_block                       # label7:
	call    	remove_from_table@FUNCTION, $2, $2
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	table,@object           # @table
	.lcomm	table,128,4

	.ident	"clang version 3.9.0 "
