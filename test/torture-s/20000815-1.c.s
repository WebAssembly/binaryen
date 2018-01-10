	.text
	.file	"20000815-1.c"
	.section	.text.invalidate_memory,"ax",@progbits
	.hidden	invalidate_memory       # -- Begin function invalidate_memory
	.globl	invalidate_memory
	.type	invalidate_memory,@function
invalidate_memory:                      # @invalidate_memory
	.param  	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.load8_u	$0=, 0($0)
	i32.const	$push0=, 4
	i32.and 	$2=, $0, $pop0
	i32.const	$push1=, 8
	i32.and 	$1=, $0, $pop1
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	block   	
	loop    	                # label1:
	i32.const	$push8=, 2
	i32.shl 	$push2=, $3, $pop8
	i32.const	$push7=, table
	i32.add 	$push3=, $pop2, $pop7
	i32.load	$4=, 0($pop3)
	block   	
	i32.eqz 	$push11=, $4
	br_if   	0, $pop11       # 0: down to label2
.LBB0_2:                                # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	copy_local	$0=, $4
	i32.load	$4=, 4($0)
	block   	
	i32.load8_u	$push4=, 36($0)
	i32.eqz 	$push12=, $pop4
	br_if   	0, $pop12       # 0: down to label4
# %bb.3:                                # %land.lhs.true
                                        #   in Loop: Header=BB0_2 Depth=2
	br_if   	4, $1           # 4: down to label0
# %bb.4:                                # %lor.lhs.false
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.eqz 	$push13=, $2
	br_if   	0, $pop13       # 0: down to label4
# %bb.5:                                # %land.lhs.true10
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.load8_u	$push5=, 37($0)
	br_if   	4, $pop5        # 4: down to label0
.LBB0_6:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label4:
	br_if   	0, $4           # 0: up to label3
.LBB0_7:                                # %for.inc15
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	end_block                       # label2:
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	i32.const	$push9=, 31
	i32.lt_u	$push6=, $3, $pop9
	br_if   	0, $pop6        # 0: up to label1
# %bb.8:                                # %for.end16
	end_loop
	return
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	invalidate_memory, .Lfunc_end0-invalidate_memory
                                        # -- End function
	.section	.text.cse_rtx_addr_varies_p,"ax",@progbits
	.hidden	cse_rtx_addr_varies_p   # -- Begin function cse_rtx_addr_varies_p
	.globl	cse_rtx_addr_varies_p
	.type	cse_rtx_addr_varies_p,@function
cse_rtx_addr_varies_p:                  # @cse_rtx_addr_varies_p
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	cse_rtx_addr_varies_p, .Lfunc_end1-cse_rtx_addr_varies_p
                                        # -- End function
	.section	.text.remove_from_table,"ax",@progbits
	.hidden	remove_from_table       # -- Begin function remove_from_table
	.globl	remove_from_table
	.type	remove_from_table,@function
remove_from_table:                      # @remove_from_table
	.param  	i32, i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	remove_from_table, .Lfunc_end2-remove_from_table
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 48
	i32.sub 	$3=, $pop15, $pop17
	i32.const	$push18=, 0
	i32.store	__stack_pointer($pop18), $3
	i32.const	$push0=, 40
	i32.add 	$push1=, $3, $pop0
	i64.const	$push2=, 0
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 32
	i32.add 	$push4=, $3, $pop3
	i64.const	$push31=, 0
	i64.store	0($pop4), $pop31
	i32.const	$push5=, 24
	i32.add 	$push6=, $3, $pop5
	i64.const	$push30=, 0
	i64.store	0($pop6), $pop30
	i32.const	$push7=, 16
	i32.add 	$push8=, $3, $pop7
	i64.const	$push29=, 0
	i64.store	0($pop8), $pop29
	i64.const	$push28=, 0
	i64.store	8($3), $pop28
	i32.const	$1=, 0
	i32.const	$push27=, 0
	i32.const	$push22=, 8
	i32.add 	$push23=, $3, $pop22
	i32.store	table($pop27), $pop23
	i32.const	$push26=, 1
	i32.store8	44($3), $pop26
	i32.const	$push24=, 8
	i32.add 	$push25=, $3, $pop24
	copy_local	$2=, $pop25
	block   	
	block   	
	br_if   	0, $2           # 0: down to label6
# %bb.1:
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
	i32.const	$push33=, 2
	i32.shl 	$push13=, $1, $pop33
	i32.const	$push32=, table
	i32.add 	$push14=, $pop13, $pop32
	i32.load	$2=, 0($pop14)
	i32.eqz 	$push36=, $2
	br_if   	8, $pop36       # 8: down to label10
# %bb.5:                                #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 0
	br      	11              # 11: up to label7
.LBB3_6:                                # %for.body6.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label18:
	i32.load	$0=, 4($2)
	i32.load8_u	$push9=, 36($2)
	i32.eqz 	$push37=, $pop9
	br_if   	5, $pop37       # 5: down to label12
# %bb.7:                                #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 1
	br      	10              # 10: up to label7
.LBB3_8:                                # %land.lhs.true10.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label17:
	i32.load8_u	$push10=, 37($2)
	br_if   	7, $pop10       # 7: down to label9
# %bb.9:                                #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 3
	br      	9               # 9: up to label7
.LBB3_10:                               # %for.inc.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label16:
	copy_local	$2=, $0
	br_if   	4, $0           # 4: down to label11
# %bb.11:                               #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 4
	br      	8               # 8: up to label7
.LBB3_12:                               # %for.inc15.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label15:
	i32.const	$push35=, 1
	i32.add 	$1=, $1, $pop35
	i32.const	$push34=, 30
	i32.le_u	$push11=, $1, $pop34
	br_if   	6, $pop11       # 6: down to label8
# %bb.13:                               #   in Loop: Header=BB3_3 Depth=1
	i32.const	$4=, 5
	br      	7               # 7: up to label7
.LBB3_14:                               # %invalidate_memory.exit
	end_block                       # label14:
	i32.const	$push21=, 0
	i32.const	$push19=, 48
	i32.add 	$push20=, $3, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	i32.const	$push12=, 0
	return  	$pop12
.LBB3_15:                               # %if.then.i
	end_block                       # label13:
	call    	abort@FUNCTION
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
                                        # -- End function
	.type	table,@object           # @table
	.section	.bss.table,"aw",@nobits
	.p2align	4
table:
	.skip	128
	.size	table, 128


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
