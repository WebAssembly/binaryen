	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strcpy-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
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
	i32.const	$push51=, u1
	i32.add 	$1=, $0, $pop51
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop                            # label4:
	i32.const	$push53=, 65
	i32.add 	$4=, $2, $pop53
	i32.const	$push52=, u2
	i32.add 	$3=, $2, $pop52
	i32.const	$5=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop                            # label6:
	i32.const	$push56=, u1
	i32.const	$push55=, 97
	i32.const	$push54=, 97
	i32.call	$10=, memset@FUNCTION, $pop56, $pop55, $pop54
	i32.const	$9=, 65
	i32.const	$7=, -97
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label8:
	i32.const	$push64=, 65
	i32.const	$push63=, 24
	i32.shl 	$push1=, $9, $pop63
	i32.const	$push62=, 24
	i32.shr_s	$push2=, $pop1, $pop62
	i32.const	$push61=, 95
	i32.gt_s	$push3=, $pop2, $pop61
	i32.select	$push4=, $pop64, $9, $pop3
	i32.store8	$push0=, u2+97($7), $pop4
	i32.const	$push60=, 1
	i32.add 	$9=, $pop0, $pop60
	i32.const	$push59=, 1
	i32.add 	$push58=, $7, $pop59
	tee_local	$push57=, $7=, $pop58
	br_if   	0, $pop57       # 0: up to label8
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label9:
	i32.add 	$push5=, $5, $2
	i32.const	$push65=, 0
	i32.store8	$drop=, u2($pop5), $pop65
	i32.call	$push6=, strcpy@FUNCTION, $1, $3
	i32.ne  	$push7=, $pop6, $1
	br_if   	6, $pop7        # 6: down to label1
# BB#6:                                 # %for.cond21.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$8=, u1
	block
	i32.const	$push66=, 1
	i32.lt_s	$push8=, $0, $pop66
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
	i32.const	$push67=, 97
	i32.ne  	$push10=, $pop9, $pop67
	br_if   	9, $pop10       # 9: down to label1
# BB#9:                                 # %for.inc30
                                        #   in Loop: Header=BB0_8 Depth=4
	i32.const	$push70=, 1
	i32.add 	$push69=, $9, $pop70
	tee_local	$push68=, $9=, $pop69
	i32.lt_s	$push11=, $pop68, $0
	br_if   	0, $pop11       # 0: up to label11
# BB#10:                                # %for.body38.preheader.loopexit
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label12:
	i32.add 	$8=, $9, $10
.LBB0_11:                               # %for.body38.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label10:
	i32.load8_u	$9=, 0($8)
	i32.const	$10=, 0
	copy_local	$7=, $4
.LBB0_12:                               # %for.body38
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label13:
	i32.const	$push76=, 255
	i32.and 	$push12=, $9, $pop76
	i32.const	$push75=, 65
	i32.const	$push74=, 24
	i32.shl 	$push13=, $7, $pop74
	i32.const	$push73=, 24
	i32.shr_s	$push14=, $pop13, $pop73
	i32.const	$push72=, 95
	i32.gt_s	$push15=, $pop14, $pop72
	i32.select	$push16=, $pop75, $7, $pop15
	i32.const	$push71=, 255
	i32.and 	$push17=, $pop16, $pop71
	i32.ne  	$push18=, $pop12, $pop17
	br_if   	8, $pop18       # 8: down to label1
# BB#13:                                # %for.inc50
                                        #   in Loop: Header=BB0_12 Depth=4
	i32.const	$push81=, 1
	i32.add 	$7=, $9, $pop81
	i32.add 	$push20=, $8, $10
	i32.const	$push80=, 1
	i32.add 	$push21=, $pop20, $pop80
	i32.load8_u	$9=, 0($pop21)
	i32.const	$push79=, 1
	i32.add 	$push78=, $10, $pop79
	tee_local	$push77=, $6=, $pop78
	copy_local	$10=, $pop77
	i32.lt_s	$push19=, $6, $5
	br_if   	0, $pop19       # 0: up to label13
# BB#14:                                # %for.end54
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label14:
	i32.const	$push82=, 255
	i32.and 	$push22=, $9, $pop82
	br_if   	6, $pop22       # 6: down to label1
# BB#15:                                # %for.cond61.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.add 	$push86=, $8, $6
	tee_local	$push85=, $9=, $pop86
	i32.const	$push84=, 1
	i32.add 	$push23=, $pop85, $pop84
	i32.load8_u	$push24=, 0($pop23)
	i32.const	$push83=, 97
	i32.ne  	$push25=, $pop24, $pop83
	br_if   	7, $pop25       # 7: down to label0
# BB#16:                                # %for.cond61
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push88=, 2
	i32.add 	$push26=, $9, $pop88
	i32.load8_u	$push27=, 0($pop26)
	i32.const	$push87=, 97
	i32.ne  	$push28=, $pop27, $pop87
	br_if   	7, $pop28       # 7: down to label0
# BB#17:                                # %for.cond61.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push90=, 3
	i32.add 	$push29=, $9, $pop90
	i32.load8_u	$push30=, 0($pop29)
	i32.const	$push89=, 97
	i32.ne  	$push31=, $pop30, $pop89
	br_if   	7, $pop31       # 7: down to label0
# BB#18:                                # %for.cond61.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push92=, 4
	i32.add 	$push32=, $9, $pop92
	i32.load8_u	$push33=, 0($pop32)
	i32.const	$push91=, 97
	i32.ne  	$push34=, $pop33, $pop91
	br_if   	7, $pop34       # 7: down to label0
# BB#19:                                # %for.cond61.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push94=, 5
	i32.add 	$push35=, $9, $pop94
	i32.load8_u	$push36=, 0($pop35)
	i32.const	$push93=, 97
	i32.ne  	$push37=, $pop36, $pop93
	br_if   	7, $pop37       # 7: down to label0
# BB#20:                                # %for.cond61.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push96=, 6
	i32.add 	$push38=, $9, $pop96
	i32.load8_u	$push39=, 0($pop38)
	i32.const	$push95=, 97
	i32.ne  	$push40=, $pop39, $pop95
	br_if   	7, $pop40       # 7: down to label0
# BB#21:                                # %for.cond61.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push98=, 7
	i32.add 	$push41=, $9, $pop98
	i32.load8_u	$push42=, 0($pop41)
	i32.const	$push97=, 97
	i32.ne  	$push43=, $pop42, $pop97
	br_if   	7, $pop43       # 7: down to label0
# BB#22:                                # %for.cond61.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push100=, 8
	i32.add 	$push44=, $9, $pop100
	i32.load8_u	$push45=, 0($pop44)
	i32.const	$push99=, 97
	i32.ne  	$push46=, $pop45, $pop99
	br_if   	7, $pop46       # 7: down to label0
# BB#23:                                # %for.cond61.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push104=, 1
	i32.add 	$push103=, $5, $pop104
	tee_local	$push102=, $5=, $pop103
	i32.const	$push101=, 80
	i32.lt_u	$push47=, $pop102, $pop101
	br_if   	0, $pop47       # 0: up to label6
# BB#24:                                # %for.inc77
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label7:
	i32.const	$push108=, 1
	i32.add 	$push107=, $2, $pop108
	tee_local	$push106=, $2=, $pop107
	i32.const	$push105=, 8
	i32.lt_u	$push48=, $pop106, $pop105
	br_if   	0, $pop48       # 0: up to label4
# BB#25:                                # %for.inc80
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	i32.const	$push112=, 1
	i32.add 	$push111=, $0, $pop112
	tee_local	$push110=, $0=, $pop111
	i32.const	$push109=, 8
	i32.lt_u	$push49=, $pop110, $pop109
	br_if   	0, $pop49       # 0: up to label2
# BB#26:                                # %for.end82
	end_loop                        # label3:
	i32.const	$push50=, 0
	call    	exit@FUNCTION, $pop50
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
	.section	.bss.u1,"aw",@nobits
	.p2align	4
u1:
	.skip	112
	.size	u1, 112

	.type	u2,@object              # @u2
	.section	.bss.u2,"aw",@nobits
	.p2align	4
u2:
	.skip	112
	.size	u2, 112


	.ident	"clang version 4.0.0 "
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
