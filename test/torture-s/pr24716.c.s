	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr24716.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.const	$4=, 0
	block   	
	block   	
	i32.const	$push17=, 0
	i32.const	$push16=, 3
	i32.lt_s	$push0=, $pop17, $pop16
	br_if   	0, $pop0        # 0: down to label1
# BB#1:
	i32.const	$6=, 12
	br      	1               # 1: down to label0
.LBB0_2:
	end_block                       # label1:
	i32.const	$6=, 10
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
	loop    	i32             # label2:
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
	br_table 	$6, 3, 6, 7, 8, 9, 10, 11, 12, 16, 0, 2, 17, 1, 4, 5, 15, 14, 13, 13 # 3: down to label33
                                        # 6: down to label30
                                        # 7: down to label29
                                        # 8: down to label28
                                        # 9: down to label27
                                        # 10: down to label26
                                        # 11: down to label25
                                        # 12: down to label24
                                        # 16: down to label20
                                        # 0: down to label36
                                        # 2: down to label34
                                        # 17: down to label19
                                        # 1: down to label35
                                        # 4: down to label32
                                        # 5: down to label31
                                        # 15: down to label21
                                        # 14: down to label22
                                        # 13: down to label23
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label36:
	i32.const	$4=, 1
	i32.const	$0=, -1
	i32.const	$push18=, 3
	i32.lt_s	$push1=, $5, $pop18
	br_if   	17, $pop1       # 17: down to label18
# BB#5:                                 #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 12
	br      	33              # 33: up to label2
.LBB0_6:                                # %if.end.thread
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label35:
	i32.const	$push22=, -1
	i32.add 	$3=, $4, $pop22
	i32.const	$push21=, 1
	i32.add 	$push20=, $5, $pop21
	tee_local	$push19=, $5=, $pop20
	i32.gt_s	$push3=, $pop19, $1
	br_if   	20, $pop3       # 20: down to label14
	br      	21              # 21: down to label13
.LBB0_7:                                # %if.end
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label34:
	i32.const	$3=, 0
	i32.const	$push23=, 1
	i32.eq  	$push2=, $4, $pop23
	br_if   	17, $pop2       # 17: down to label16
# BB#8:                                 #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 0
	br      	31              # 31: up to label2
.LBB0_9:                                # %while.cond.preheader
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label33:
	i32.le_s	$push4=, $5, $1
	br_if   	15, $pop4       # 15: down to label17
# BB#10:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 13
	br      	30              # 30: up to label2
.LBB0_11:                               # %while.body.lr.ph
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label32:
	i32.eq  	$4=, $3, $1
# BB#12:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 14
	br      	29              # 29: up to label2
.LBB0_13:                               # %while.body
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label31:
	i32.add 	$push25=, $5, $4
	tee_local	$push24=, $5=, $pop25
	i32.gt_s	$push5=, $pop24, $1
	br_if   	15, $pop5       # 15: down to label15
# BB#14:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 1
	br      	28              # 28: up to label2
.LBB0_15:                               # %do.body10.preheader
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label30:
	i32.const	$push27=, 2
	i32.shl 	$push6=, $0, $pop27
	i32.const	$push26=, W
	i32.add 	$2=, $pop6, $pop26
# BB#16:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 2
	br      	27              # 27: up to label2
.LBB0_17:                               # %do.body10
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label29:
	i32.load	$4=, 0($2)
# BB#18:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 3
	br      	26              # 26: up to label2
.LBB0_19:                               # %do.body11
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label28:
	i32.eqz 	$push37=, $4
	br_if   	17, $pop37      # 17: down to label10
# BB#20:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 4
	br      	25              # 25: up to label2
.LBB0_21:                               # %if.then13
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label27:
	i32.const	$push28=, 0
	i32.store	0($2), $pop28
	i32.const	$5=, 1
# BB#22:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 5
	br      	24              # 24: up to label2
.LBB0_23:                               # %do.cond16
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label26:
	i32.const	$4=, 0
	i32.const	$push29=, 1
	i32.lt_s	$push7=, $1, $pop29
	br_if   	14, $pop7       # 14: down to label11
# BB#24:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 6
	br      	23              # 23: up to label2
.LBB0_25:                               # %do.cond19
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label25:
	i32.const	$push30=, 0
	i32.gt_s	$push8=, $0, $pop30
	br_if   	12, $pop8       # 12: down to label12
# BB#26:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 7
	br      	22              # 22: up to label2
.LBB0_27:                               # %do.body22
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label24:
	i32.const	$push33=, 2
	i32.shl 	$push9=, $0, $pop33
	i32.const	$push32=, Link
	i32.add 	$push10=, $pop9, $pop32
	i32.load	$0=, 0($pop10)
	i32.const	$1=, 0
	i32.const	$push31=, 0
	i32.lt_s	$push11=, $pop31, $3
	br_if   	17, $pop11      # 17: down to label6
	br      	18              # 18: down to label5
.LBB0_28:                               # %if.then28
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label23:
	i32.const	$push35=, 1
	i32.add 	$1=, $1, $pop35
	i32.const	$push34=, 1
	i32.add 	$5=, $5, $pop34
# BB#29:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 16
	br      	20              # 20: up to label2
.LBB0_30:                               # %while.cond24
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label22:
	i32.ge_s	$push12=, $1, $3
	br_if   	14, $pop12      # 14: down to label7
# BB#31:                                #   in Loop: Header=BB0_3 Depth=1
	i32.const	$6=, 15
	br      	19              # 19: up to label2
.LBB0_32:                               # %while.body26
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label21:
	i32.const	$push36=, -1
	i32.eq  	$push15=, $0, $pop36
	br_if   	17, $pop15      # 17: down to label3
	br      	16              # 16: down to label4
.LBB0_33:                               # %do.cond33
                                        #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label20:
	i32.const	$push13=, -1
	i32.ne  	$push14=, $0, $pop13
	br_if   	10, $pop14      # 10: down to label9
	br      	11              # 11: down to label8
.LBB0_34:                               # %for.end
	end_block                       # label19:
	return  	$5
.LBB0_35:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label18:
	i32.const	$6=, 10
	br      	15              # 15: up to label2
.LBB0_36:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label17:
	i32.const	$6=, 1
	br      	14              # 14: up to label2
.LBB0_37:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label16:
	i32.const	$6=, 11
	br      	13              # 13: up to label2
.LBB0_38:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label15:
	i32.const	$6=, 14
	br      	12              # 12: up to label2
.LBB0_39:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label14:
	i32.const	$6=, 13
	br      	11              # 11: up to label2
.LBB0_40:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label13:
	i32.const	$6=, 1
	br      	10              # 10: up to label2
.LBB0_41:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label12:
	i32.const	$6=, 2
	br      	9               # 9: up to label2
.LBB0_42:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label11:
	i32.const	$6=, 3
	br      	8               # 8: up to label2
.LBB0_43:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label10:
	i32.const	$6=, 5
	br      	7               # 7: up to label2
.LBB0_44:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label9:
	i32.const	$6=, 7
	br      	6               # 6: up to label2
.LBB0_45:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label8:
	i32.const	$6=, 9
	br      	5               # 5: up to label2
.LBB0_46:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label7:
	i32.const	$6=, 8
	br      	4               # 4: up to label2
.LBB0_47:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label6:
	i32.const	$6=, 15
	br      	3               # 3: up to label2
.LBB0_48:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label5:
	i32.const	$6=, 8
	br      	2               # 2: up to label2
.LBB0_49:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label4:
	i32.const	$6=, 17
	br      	1               # 1: up to label2
.LBB0_50:                               #   in Loop: Header=BB0_3 Depth=1
	end_block                       # label3:
	i32.const	$6=, 16
	br      	0               # 0: up to label2
.LBB0_51:
	end_loop
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$1=, 2
	i32.const	$2=, 0
	i32.const	$3=, 0
	block   	
	block   	
	i32.const	$push13=, 0
	i32.const	$push12=, 3
	i32.lt_s	$push0=, $pop13, $pop12
	br_if   	0, $pop0        # 0: down to label38
# BB#1:
	i32.const	$5=, 11
	br      	1               # 1: down to label37
.LBB1_2:
	end_block                       # label38:
	i32.const	$5=, 7
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label37:
	loop    	i32             # label39:
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
	block   	
	br_table 	$5, 3, 6, 7, 8, 9, 10, 0, 2, 11, 12, 13, 1, 4, 5, 5 # 3: down to label61
                                        # 6: down to label58
                                        # 7: down to label57
                                        # 8: down to label56
                                        # 9: down to label55
                                        # 10: down to label54
                                        # 0: down to label64
                                        # 2: down to label62
                                        # 11: down to label53
                                        # 12: down to label52
                                        # 13: down to label51
                                        # 1: down to label63
                                        # 4: down to label60
                                        # 5: down to label59
.LBB1_4:                                #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label64:
	i32.const	$3=, 1
	i32.const	$1=, 0
	i32.const	$4=, -1
	i32.const	$push14=, 3
	i32.lt_s	$push1=, $2, $pop14
	br_if   	13, $pop1       # 13: down to label50
# BB#5:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 11
	br      	24              # 24: up to label39
.LBB1_6:                                # %if.end.thread.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label63:
	i32.const	$push18=, -1
	i32.add 	$0=, $3, $pop18
	i32.const	$push17=, 1
	i32.add 	$push16=, $2, $pop17
	tee_local	$push15=, $2=, $pop16
	i32.gt_s	$push4=, $pop15, $1
	br_if   	16, $pop4       # 16: down to label46
	br      	17              # 17: down to label45
.LBB1_7:                                # %if.end.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label62:
	i32.const	$0=, 0
	i32.const	$push19=, 1
	i32.eq  	$push2=, $3, $pop19
	br_if   	13, $pop2       # 13: down to label48
# BB#8:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 0
	br      	22              # 22: up to label39
.LBB1_9:                                # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label61:
	i32.le_s	$push5=, $2, $1
	br_if   	11, $pop5       # 11: down to label49
# BB#10:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 12
	br      	21              # 21: up to label39
.LBB1_11:                               # %while.body.lr.ph.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label60:
	i32.eq  	$3=, $0, $1
# BB#12:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 13
	br      	20              # 20: up to label39
.LBB1_13:                               # %while.body.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label59:
	i32.add 	$push21=, $2, $3
	tee_local	$push20=, $2=, $pop21
	i32.gt_s	$push6=, $pop20, $1
	br_if   	11, $pop6       # 11: down to label47
# BB#14:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 1
	br      	19              # 19: up to label39
.LBB1_15:                               # %do.body10.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label58:
	i32.const	$push25=, 2
	i32.shl 	$push7=, $4, $pop25
	i32.const	$push24=, W
	i32.add 	$push23=, $pop7, $pop24
	tee_local	$push22=, $0=, $pop23
	i32.load	$3=, 0($pop22)
# BB#16:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 2
	br      	18              # 18: up to label39
.LBB1_17:                               # %do.body11.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label57:
	i32.eqz 	$push31=, $3
	br_if   	13, $pop31      # 13: down to label43
# BB#18:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 3
	br      	17              # 17: up to label39
.LBB1_19:                               # %if.then13.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label56:
	i32.const	$push26=, 0
	i32.store	0($0), $pop26
	i32.const	$2=, 1
# BB#20:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 4
	br      	16              # 16: up to label39
.LBB1_21:                               # %do.cond16.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label55:
	i32.const	$3=, 0
	i32.eqz 	$push32=, $1
	br_if   	10, $pop32      # 10: down to label44
# BB#22:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 5
	br      	15              # 15: up to label39
.LBB1_23:                               # %do.cond33.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label54:
	i32.const	$push30=, 2
	i32.shl 	$push9=, $4, $pop30
	i32.const	$push29=, Link
	i32.add 	$push10=, $pop9, $pop29
	i32.load	$push28=, 0($pop10)
	tee_local	$push27=, $4=, $pop28
	i32.const	$push8=, -1
	i32.ne  	$push11=, $pop27, $pop8
	br_if   	12, $pop11      # 12: down to label41
	br      	11              # 11: down to label42
.LBB1_24:                               # %f.exit
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label53:
	i32.eqz 	$push33=, $2
	br_if   	12, $pop33      # 12: down to label40
# BB#25:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 9
	br      	13              # 13: up to label39
.LBB1_26:                               # %if.end
	end_block                       # label52:
	i32.const	$push3=, 0
	return  	$pop3
.LBB1_27:                               # %if.then
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
.LBB1_28:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label50:
	i32.const	$5=, 7
	br      	10              # 10: up to label39
.LBB1_29:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label49:
	i32.const	$5=, 1
	br      	9               # 9: up to label39
.LBB1_30:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label48:
	i32.const	$5=, 8
	br      	8               # 8: up to label39
.LBB1_31:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label47:
	i32.const	$5=, 13
	br      	7               # 7: up to label39
.LBB1_32:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label46:
	i32.const	$5=, 12
	br      	6               # 6: up to label39
.LBB1_33:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label45:
	i32.const	$5=, 1
	br      	5               # 5: up to label39
.LBB1_34:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label44:
	i32.const	$5=, 2
	br      	4               # 4: up to label39
.LBB1_35:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label43:
	i32.const	$5=, 4
	br      	3               # 3: up to label39
.LBB1_36:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label42:
	i32.const	$5=, 6
	br      	2               # 2: up to label39
.LBB1_37:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label41:
	i32.const	$5=, 5
	br      	1               # 1: up to label39
.LBB1_38:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label40:
	i32.const	$5=, 10
	br      	0               # 0: up to label39
.LBB1_39:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	Link                    # @Link
	.type	Link,@object
	.section	.data.Link,"aw",@progbits
	.globl	Link
	.p2align	2
Link:
	.skip	4,255
	.size	Link, 4

	.hidden	W                       # @W
	.type	W,@object
	.section	.data.W,"aw",@progbits
	.globl	W
	.p2align	2
W:
	.int32	2                       # 0x2
	.size	W, 4


	.ident	"clang version 4.0.0 "
	.functype	abort, void
