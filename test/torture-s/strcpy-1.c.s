	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strcpy-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	block
	block
	loop                            # label2:
	i32.const	$push49=, u1
	i32.add 	$2=, $1, $pop49
	i32.const	$3=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop                            # label4:
	i32.const	$push51=, 65
	i32.add 	$5=, $3, $pop51
	i32.const	$push50=, u2
	i32.add 	$4=, $3, $pop50
	i32.const	$6=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop                            # label6:
	i32.const	$push54=, u1
	i32.const	$push53=, 97
	i32.const	$push52=, 97
	i32.call	$0=, memset@FUNCTION, $pop54, $pop53, $pop52
	i32.const	$9=, 65
	i32.const	$7=, -97
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label8:
	i32.const	$push62=, 65
	i32.const	$push61=, 24
	i32.shl 	$push1=, $9, $pop61
	i32.const	$push60=, 24
	i32.shr_s	$push2=, $pop1, $pop60
	i32.const	$push59=, 95
	i32.gt_s	$push3=, $pop2, $pop59
	i32.select	$push4=, $pop62, $9, $pop3
	i32.store8	$push0=, u2+97($7), $pop4
	i32.const	$push58=, 1
	i32.add 	$9=, $pop0, $pop58
	i32.const	$push57=, 1
	i32.add 	$push56=, $7, $pop57
	tee_local	$push55=, $7=, $pop56
	br_if   	0, $pop55       # 0: up to label8
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label9:
	i32.add 	$push5=, $6, $3
	i32.const	$push63=, 0
	i32.store8	$drop=, u2($pop5), $pop63
	i32.call	$push6=, strcpy@FUNCTION, $2, $4
	i32.ne  	$push7=, $pop6, $2
	br_if   	6, $pop7        # 6: down to label1
# BB#6:                                 # %for.cond21.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$8=, u1
	block
	i32.const	$push64=, 1
	i32.lt_s	$push8=, $1, $pop64
	br_if   	0, $pop8        # 0: down to label10
# BB#7:                                 # %for.body24.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$9=, 0
.LBB0_8:                                # %for.body24
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label11:
	i32.load8_u	$push9=, u1($9)
	i32.const	$push65=, 97
	i32.ne  	$push10=, $pop9, $pop65
	br_if   	9, $pop10       # 9: down to label1
# BB#9:                                 # %for.inc30
                                        #   in Loop: Header=BB0_8 Depth=4
	i32.const	$push68=, 1
	i32.add 	$push67=, $9, $pop68
	tee_local	$push66=, $9=, $pop67
	i32.lt_s	$push11=, $pop66, $1
	br_if   	0, $pop11       # 0: up to label11
# BB#10:                                # %for.body38.preheader.loopexit
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label12:
	i32.add 	$8=, $9, $0
.LBB0_11:                               # %for.body38.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label10:
	i32.const	$9=, 0
	copy_local	$7=, $5
.LBB0_12:                               # %for.body38
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label13:
	i32.add 	$push16=, $8, $9
	i32.load8_u	$push17=, 0($pop16)
	i32.const	$push75=, 65
	i32.const	$push74=, 24
	i32.shl 	$push12=, $7, $pop74
	i32.const	$push73=, 24
	i32.shr_s	$push13=, $pop12, $pop73
	i32.const	$push72=, 95
	i32.gt_s	$push14=, $pop13, $pop72
	i32.select	$push71=, $pop75, $7, $pop14
	tee_local	$push70=, $7=, $pop71
	i32.const	$push69=, 255
	i32.and 	$push15=, $pop70, $pop69
	i32.ne  	$push18=, $pop17, $pop15
	br_if   	8, $pop18       # 8: down to label1
# BB#13:                                # %for.inc50
                                        #   in Loop: Header=BB0_12 Depth=4
	i32.const	$push79=, 1
	i32.add 	$7=, $7, $pop79
	i32.const	$push78=, 1
	i32.add 	$push77=, $9, $pop78
	tee_local	$push76=, $9=, $pop77
	i32.lt_s	$push19=, $pop76, $6
	br_if   	0, $pop19       # 0: up to label13
# BB#14:                                # %for.end54
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label14:
	i32.add 	$push81=, $8, $9
	tee_local	$push80=, $9=, $pop81
	i32.load8_u	$push20=, 0($pop80)
	br_if   	6, $pop20       # 6: down to label1
# BB#15:                                # %for.cond61.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push83=, 1
	i32.add 	$push21=, $9, $pop83
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push82=, 97
	i32.ne  	$push23=, $pop22, $pop82
	br_if   	7, $pop23       # 7: down to label0
# BB#16:                                # %for.cond61
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push85=, 2
	i32.add 	$push24=, $9, $pop85
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push84=, 97
	i32.ne  	$push26=, $pop25, $pop84
	br_if   	7, $pop26       # 7: down to label0
# BB#17:                                # %for.cond61.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push87=, 3
	i32.add 	$push27=, $9, $pop87
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push86=, 97
	i32.ne  	$push29=, $pop28, $pop86
	br_if   	7, $pop29       # 7: down to label0
# BB#18:                                # %for.cond61.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push89=, 4
	i32.add 	$push30=, $9, $pop89
	i32.load8_u	$push31=, 0($pop30)
	i32.const	$push88=, 97
	i32.ne  	$push32=, $pop31, $pop88
	br_if   	7, $pop32       # 7: down to label0
# BB#19:                                # %for.cond61.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push91=, 5
	i32.add 	$push33=, $9, $pop91
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push90=, 97
	i32.ne  	$push35=, $pop34, $pop90
	br_if   	7, $pop35       # 7: down to label0
# BB#20:                                # %for.cond61.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push93=, 6
	i32.add 	$push36=, $9, $pop93
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push92=, 97
	i32.ne  	$push38=, $pop37, $pop92
	br_if   	7, $pop38       # 7: down to label0
# BB#21:                                # %for.cond61.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push95=, 7
	i32.add 	$push39=, $9, $pop95
	i32.load8_u	$push40=, 0($pop39)
	i32.const	$push94=, 97
	i32.ne  	$push41=, $pop40, $pop94
	br_if   	7, $pop41       # 7: down to label0
# BB#22:                                # %for.cond61.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push97=, 8
	i32.add 	$push42=, $9, $pop97
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push96=, 97
	i32.ne  	$push44=, $pop43, $pop96
	br_if   	7, $pop44       # 7: down to label0
# BB#23:                                # %for.cond61.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push101=, 1
	i32.add 	$push100=, $6, $pop101
	tee_local	$push99=, $6=, $pop100
	i32.const	$push98=, 80
	i32.lt_u	$push45=, $pop99, $pop98
	br_if   	0, $pop45       # 0: up to label6
# BB#24:                                # %for.inc77
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label7:
	i32.const	$push105=, 1
	i32.add 	$push104=, $3, $pop105
	tee_local	$push103=, $3=, $pop104
	i32.const	$push102=, 8
	i32.lt_u	$push46=, $pop103, $pop102
	br_if   	0, $pop46       # 0: up to label4
# BB#25:                                # %for.inc80
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	i32.const	$push109=, 1
	i32.add 	$push108=, $1, $pop109
	tee_local	$push107=, $1=, $pop108
	i32.const	$push106=, 8
	i32.lt_u	$push47=, $pop107, $pop106
	br_if   	0, $pop47       # 0: up to label2
# BB#26:                                # %for.end82
	end_loop                        # label3:
	i32.const	$push48=, 0
	call    	exit@FUNCTION, $pop48
	unreachable
.LBB0_27:                               # %if.then59
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_28:                               # %if.then68
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
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
