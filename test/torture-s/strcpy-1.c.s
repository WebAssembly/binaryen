	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strcpy-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_11 Depth 4
	block
	block
	block
	block
	loop                            # label4:
	i32.const	$push51=, u1
	i32.add 	$1=, $0, $pop51
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_11 Depth 4
	loop                            # label6:
	i32.const	$push53=, u2
	i32.add 	$3=, $2, $pop53
	i32.const	$push52=, 65
	i32.add 	$4=, $2, $pop52
	i32.const	$5=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_11 Depth 4
	loop                            # label8:
	i32.const	$push56=, u1
	i32.const	$push55=, 97
	i32.const	$push54=, 97
	i32.call	$discard=, memset@FUNCTION, $pop56, $pop55, $pop54
	i32.const	$6=, 65
	i32.const	$8=, -97
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label10:
	i32.const	$push62=, 24
	i32.shl 	$push2=, $6, $pop62
	i32.const	$push61=, 24
	i32.shr_s	$push3=, $pop2, $pop61
	i32.const	$push60=, 95
	i32.gt_s	$push4=, $pop3, $pop60
	i32.const	$push59=, 65
	i32.select	$push5=, $pop4, $pop59, $6
	i32.store8	$push6=, u2+97($8), $pop5
	i32.const	$push58=, 1
	i32.add 	$6=, $pop6, $pop58
	i32.const	$push57=, 1
	i32.add 	$8=, $8, $pop57
	br_if   	$8, 0           # 0: up to label10
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label11:
	i32.add 	$push7=, $5, $2
	i32.const	$push63=, 0
	i32.store8	$discard=, u2($pop7), $pop63
	i32.call	$push8=, strcpy@FUNCTION, $1, $3
	i32.ne  	$push9=, $pop8, $1
	br_if   	$pop9, 9        # 9: down to label0
# BB#6:                                 # %for.cond21.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$8=, 0
	i32.const	$7=, u1
	block
	i32.const	$push64=, 0
	i32.le_s	$push10=, $0, $pop64
	br_if   	$pop10, 0       # 0: down to label12
.LBB0_7:                                # %for.body24
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label13:
	i32.load8_u	$push11=, u1($8)
	i32.const	$push65=, 97
	i32.ne  	$push12=, $pop11, $pop65
	br_if   	$pop12, 1       # 1: down to label14
# BB#8:                                 # %for.inc30
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push67=, u1+1
	i32.add 	$7=, $8, $pop67
	i32.const	$push66=, 1
	i32.add 	$6=, $8, $pop66
	copy_local	$8=, $6
	i32.lt_s	$push13=, $6, $0
	br_if   	$pop13, 0       # 0: up to label13
	br      	2               # 2: down to label12
.LBB0_9:                                # %if.then28
	end_loop                        # label14:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %for.body38.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label12:
	i32.const	$8=, 0
	copy_local	$6=, $4
.LBB0_11:                               # %for.body38
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label15:
	i32.add 	$push18=, $7, $8
	i32.load8_u	$push19=, 0($pop18)
	i32.const	$push73=, 24
	i32.shl 	$push14=, $6, $pop73
	i32.const	$push72=, 24
	i32.shr_s	$push15=, $pop14, $pop72
	i32.const	$push71=, 95
	i32.gt_s	$push16=, $pop15, $pop71
	i32.const	$push70=, 65
	i32.select	$push0=, $pop16, $pop70, $6
	tee_local	$push69=, $6=, $pop0
	i32.const	$push68=, 255
	i32.and 	$push17=, $pop69, $pop68
	i32.ne  	$push20=, $pop19, $pop17
	br_if   	$pop20, 10      # 10: down to label1
# BB#12:                                # %for.inc50
                                        #   in Loop: Header=BB0_11 Depth=4
	i32.const	$push75=, 1
	i32.add 	$8=, $8, $pop75
	i32.const	$push74=, 1
	i32.add 	$6=, $6, $pop74
	i32.lt_s	$push21=, $8, $5
	br_if   	$pop21, 0       # 0: up to label15
# BB#13:                                # %for.end54
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label16:
	i32.add 	$push1=, $7, $8
	tee_local	$push76=, $8=, $pop1
	i32.load8_u	$push22=, 0($pop76)
	br_if   	$pop22, 7       # 7: down to label2
# BB#14:                                # %for.cond61.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push78=, 1
	i32.add 	$push23=, $8, $pop78
	i32.load8_u	$push24=, 0($pop23)
	i32.const	$push77=, 97
	i32.ne  	$push25=, $pop24, $pop77
	br_if   	$pop25, 6       # 6: down to label3
# BB#15:                                # %for.cond61
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push80=, 2
	i32.add 	$push26=, $8, $pop80
	i32.load8_u	$push27=, 0($pop26)
	i32.const	$push79=, 97
	i32.ne  	$push28=, $pop27, $pop79
	br_if   	$pop28, 6       # 6: down to label3
# BB#16:                                # %for.cond61.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push86=, 3
	i32.add 	$push29=, $8, $pop86
	i32.load8_u	$push30=, 0($pop29)
	i32.const	$push85=, 97
	i32.ne  	$push31=, $pop30, $pop85
	br_if   	$pop31, 6       # 6: down to label3
# BB#17:                                # %for.cond61.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push88=, 4
	i32.add 	$push32=, $8, $pop88
	i32.load8_u	$push33=, 0($pop32)
	i32.const	$push87=, 97
	i32.ne  	$push34=, $pop33, $pop87
	br_if   	$pop34, 6       # 6: down to label3
# BB#18:                                # %for.cond61.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push90=, 5
	i32.add 	$push35=, $8, $pop90
	i32.load8_u	$push36=, 0($pop35)
	i32.const	$push89=, 97
	i32.ne  	$push37=, $pop36, $pop89
	br_if   	$pop37, 6       # 6: down to label3
# BB#19:                                # %for.cond61.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push92=, 6
	i32.add 	$push38=, $8, $pop92
	i32.load8_u	$push39=, 0($pop38)
	i32.const	$push91=, 97
	i32.ne  	$push40=, $pop39, $pop91
	br_if   	$pop40, 6       # 6: down to label3
# BB#20:                                # %for.cond61.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push94=, 7
	i32.add 	$push41=, $8, $pop94
	i32.load8_u	$push42=, 0($pop41)
	i32.const	$push93=, 97
	i32.ne  	$push43=, $pop42, $pop93
	br_if   	$pop43, 6       # 6: down to label3
# BB#21:                                # %for.cond61.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push96=, 8
	i32.add 	$push44=, $8, $pop96
	i32.load8_u	$push45=, 0($pop44)
	i32.const	$push95=, 97
	i32.ne  	$push46=, $pop45, $pop95
	br_if   	$pop46, 6       # 6: down to label3
# BB#22:                                # %for.cond61.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push98=, 1
	i32.add 	$5=, $5, $pop98
	i32.const	$push97=, 80
	i32.lt_u	$push47=, $5, $pop97
	br_if   	$pop47, 0       # 0: up to label8
# BB#23:                                # %for.inc77
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label9:
	i32.const	$push82=, 1
	i32.add 	$2=, $2, $pop82
	i32.const	$push81=, 8
	i32.lt_u	$push48=, $2, $pop81
	br_if   	$pop48, 0       # 0: up to label6
# BB#24:                                # %for.inc80
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label7:
	i32.const	$push84=, 1
	i32.add 	$0=, $0, $pop84
	i32.const	$push83=, 8
	i32.lt_u	$push49=, $0, $pop83
	br_if   	$pop49, 0       # 0: up to label4
# BB#25:                                # %for.end82
	end_loop                        # label5:
	i32.const	$push50=, 0
	call    	exit@FUNCTION, $pop50
	unreachable
.LBB0_26:                               # %if.then68
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_27:                               # %if.then59
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_28:                               # %if.then48
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_29:                               # %if.then19
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	u1,@object              # @u1
	.lcomm	u1,112,4
	.type	u2,@object              # @u2
	.lcomm	u2,112,4

	.ident	"clang version 3.9.0 "
