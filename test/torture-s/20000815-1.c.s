	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000815-1.c"
	.section	.text.invalidate_memory,"ax",@progbits
	.hidden	invalidate_memory
	.globl	invalidate_memory
	.type	invalidate_memory,@function
invalidate_memory:                      # @invalidate_memory
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load8_u	$push8=, 0($0)
	tee_local	$push7=, $0=, $pop8
	i32.const	$push0=, 4
	i32.and 	$2=, $pop7, $pop0
	i32.const	$push1=, 8
	i32.and 	$1=, $0, $pop1
	i32.const	$4=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	block   	
	loop    	                # label1:
	block   	
	i32.const	$push12=, 2
	i32.shl 	$push2=, $4, $pop12
	i32.const	$push11=, table
	i32.add 	$push3=, $pop2, $pop11
	i32.load	$push10=, 0($pop3)
	tee_local	$push9=, $0=, $pop10
	i32.eqz 	$push19=, $pop9
	br_if   	0, $pop19       # 0: down to label2
.LBB0_2:                                # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	copy_local	$push14=, $0
	tee_local	$push13=, $3=, $pop14
	i32.load	$0=, 4($pop13)
	block   	
	i32.load8_u	$push4=, 36($3)
	i32.eqz 	$push20=, $pop4
	br_if   	0, $pop20       # 0: down to label4
# BB#3:                                 # %land.lhs.true
                                        #   in Loop: Header=BB0_2 Depth=2
	br_if   	4, $1           # 4: down to label0
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.eqz 	$push21=, $2
	br_if   	0, $pop21       # 0: down to label4
# BB#5:                                 # %land.lhs.true10
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.load8_u	$push5=, 37($3)
	br_if   	4, $pop5        # 4: down to label0
.LBB0_6:                                # %for.cond5.backedge
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label4:
	br_if   	0, $0           # 0: up to label3
.LBB0_7:                                # %for.inc15
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	end_block                       # label2:
	i32.const	$push18=, 1
	i32.add 	$push17=, $4, $pop18
	tee_local	$push16=, $4=, $pop17
	i32.const	$push15=, 31
	i32.lt_s	$push6=, $pop16, $pop15
	br_if   	0, $pop6        # 0: up to label1
# BB#8:                                 # %for.end16
	end_loop
	return
.LBB0_9:                                # %if.then
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
                                        # fallthrough-return: $pop0
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 48
	i32.sub 	$push26=, $pop8, $pop9
	tee_local	$push25=, $3=, $pop26
	i32.store	__stack_pointer($pop10), $pop25
	i32.const	$1=, 0
	i32.const	$push14=, 8
	i32.add 	$push15=, $3, $pop14
	i32.const	$push24=, 0
	i32.const	$push0=, 40
	i32.call	$drop=, memset@FUNCTION, $pop15, $pop24, $pop0
	i32.const	$push23=, 0
	i32.const	$push16=, 8
	i32.add 	$push17=, $3, $pop16
	i32.store	table($pop23), $pop17
	i32.const	$push22=, 1
	i32.store8	44($3), $pop22
	block   	
	block   	
	i32.const	$push18=, 8
	i32.add 	$push19=, $3, $pop18
	copy_local	$push21=, $pop19
	tee_local	$push20=, $2=, $pop21
	br_if   	0, $pop20       # 0: down to label6
# BB#1:
	i32.const	$4=, 4
	br      	1               # 1: down to label5
.LBB3_2:
	end_block                       # label6:
	i32.const	$4=, 0
.LBB3_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label5:
	loop    	i32             # label7:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$4, 1, 2, 6, 3, 4, 5, 0, 0 # 1: down to label18
                                        # 2: down to label17
                                        # 6: down to label13
                                        # 3: down to label16
                                        # 4: down to label15
                                        # 5: down to label14
                                        # 0: down to label19
.LBB3_4:                                # %for.inc15.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label19:
	i32.const	$push30=, 2
	i32.shl 	$push5=, $1, $pop30
	i32.const	$push29=, table
	i32.add 	$push6=, $pop5, $pop29
	i32.load	$push28=, 0($pop6)
	tee_local	$push27=, $2=, $pop28
	i32.eqz 	$push35=, $pop27
	br_if   	8, $pop35       # 8: down to label10
# BB#5:                                 #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 0
	br      	11              # 11: up to label7
.LBB3_6:                                # %for.body6.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label18:
	i32.load	$0=, 4($2)
	i32.load8_u	$push1=, 36($2)
	i32.eqz 	$push36=, $pop1
	br_if   	5, $pop36       # 5: down to label12
# BB#7:                                 #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 1
	br      	10              # 10: up to label7
.LBB3_8:                                # %land.lhs.true10.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label17:
	i32.load8_u	$push2=, 37($2)
	br_if   	7, $pop2        # 7: down to label9
# BB#9:                                 #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 3
	br      	9               # 9: up to label7
.LBB3_10:                               # %for.cond5.backedge.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label16:
	copy_local	$2=, $0
	br_if   	4, $0           # 4: down to label11
# BB#11:                                #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 4
	br      	8               # 8: up to label7
.LBB3_12:                               # %for.inc15.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label15:
	i32.const	$push34=, 1
	i32.add 	$push33=, $1, $pop34
	tee_local	$push32=, $1=, $pop33
	i32.const	$push31=, 30
	i32.le_s	$push3=, $pop32, $pop31
	br_if   	6, $pop3        # 6: down to label8
# BB#13:                                #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 5
	br      	7               # 7: up to label7
.LBB3_14:                               # %invalidate_memory.exit
	end_block                       # label14:
	i32.const	$push13=, 0
	i32.const	$push11=, 48
	i32.add 	$push12=, $3, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	i32.const	$push4=, 0
	return  	$pop4
.LBB3_15:                               # %if.then.i
	end_block                       # label13:
	call    	remove_from_table@FUNCTION, $2, $2
	unreachable
.LBB3_16:                               #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label12:
	i32.const	$4=, 3
	br      	4               # 4: up to label7
.LBB3_17:                               #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label11:
	i32.const	$4=, 0
	br      	3               # 3: up to label7
.LBB3_18:                               #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label10:
	i32.const	$4=, 4
	br      	2               # 2: up to label7
.LBB3_19:                               #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label9:
	i32.const	$4=, 2
	br      	1               # 1: up to label7
.LBB3_20:                               #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label8:
	i32.const	$4=, 6
	br      	0               # 0: up to label7
.LBB3_21:
	end_loop
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	table,@object           # @table
	.section	.bss.table,"aw",@nobits
	.p2align	4
table:
	.skip	128
	.size	table, 128


	.ident	"clang version 4.0.0 "
	.functype	abort, void
