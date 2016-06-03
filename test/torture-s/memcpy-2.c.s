	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-2.c"
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
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_11 Depth 4
	block
	loop                            # label1:
	i32.const	$push44=, u1
	i32.add 	$2=, $1, $pop44
	i32.const	$3=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_11 Depth 4
	loop                            # label3:
	i32.const	$push46=, 65
	i32.add 	$5=, $3, $pop46
	i32.const	$push45=, u2
	i32.add 	$4=, $3, $pop45
	i32.const	$6=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_11 Depth 4
	loop                            # label5:
	i32.const	$push49=, u1
	i32.const	$push48=, 97
	i32.const	$push47=, 96
	i32.call	$0=, memset@FUNCTION, $pop49, $pop48, $pop47
	i32.const	$9=, 65
	i32.const	$7=, -96
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label7:
	i32.const	$push57=, 65
	i32.const	$push56=, 24
	i32.shl 	$push1=, $9, $pop56
	i32.const	$push55=, 24
	i32.shr_s	$push2=, $pop1, $pop55
	i32.const	$push54=, 95
	i32.gt_s	$push3=, $pop2, $pop54
	i32.select	$push4=, $pop57, $9, $pop3
	i32.store8	$push0=, u2+96($7), $pop4
	i32.const	$push53=, 1
	i32.add 	$9=, $pop0, $pop53
	i32.const	$push52=, 1
	i32.add 	$push51=, $7, $pop52
	tee_local	$push50=, $7=, $pop51
	br_if   	0, $pop50       # 0: up to label7
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label8:
	i32.call	$drop=, memcpy@FUNCTION, $2, $4, $6
	i32.const	$8=, u1
	block
	i32.const	$push58=, 1
	i32.lt_s	$push5=, $1, $pop58
	br_if   	0, $pop5        # 0: down to label9
# BB#6:                                 # %for.body23.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$9=, 0
.LBB0_7:                                # %for.body23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label10:
	i32.load8_u	$push6=, u1($9)
	i32.const	$push59=, 97
	i32.ne  	$push7=, $pop6, $pop59
	br_if   	9, $pop7        # 9: down to label0
# BB#8:                                 # %for.inc29
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push62=, 1
	i32.add 	$push61=, $9, $pop62
	tee_local	$push60=, $9=, $pop61
	i32.lt_s	$push8=, $pop60, $1
	br_if   	0, $pop8        # 0: up to label10
# BB#9:                                 # %for.body36.preheader.loopexit
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label11:
	i32.add 	$8=, $9, $0
.LBB0_10:                               # %for.body36.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label9:
	i32.const	$9=, 0
	copy_local	$7=, $5
.LBB0_11:                               # %for.body36
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label12:
	i32.add 	$push13=, $8, $9
	i32.load8_u	$push14=, 0($pop13)
	i32.const	$push69=, 65
	i32.const	$push68=, 24
	i32.shl 	$push9=, $7, $pop68
	i32.const	$push67=, 24
	i32.shr_s	$push10=, $pop9, $pop67
	i32.const	$push66=, 95
	i32.gt_s	$push11=, $pop10, $pop66
	i32.select	$push65=, $pop69, $7, $pop11
	tee_local	$push64=, $7=, $pop65
	i32.const	$push63=, 255
	i32.and 	$push12=, $pop64, $pop63
	i32.ne  	$push15=, $pop14, $pop12
	br_if   	8, $pop15       # 8: down to label0
# BB#12:                                # %for.inc48
                                        #   in Loop: Header=BB0_11 Depth=4
	i32.const	$push73=, 1
	i32.add 	$7=, $7, $pop73
	i32.const	$push72=, 1
	i32.add 	$push71=, $9, $pop72
	tee_local	$push70=, $9=, $pop71
	i32.lt_s	$push16=, $pop70, $6
	br_if   	0, $pop16       # 0: up to label12
# BB#13:                                # %for.body56.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label13:
	i32.add 	$push76=, $8, $9
	tee_local	$push75=, $9=, $pop76
	i32.load8_u	$push17=, 0($pop75)
	i32.const	$push74=, 97
	i32.ne  	$push18=, $pop17, $pop74
	br_if   	6, $pop18       # 6: down to label0
# BB#14:                                # %for.inc62
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push78=, 1
	i32.add 	$push19=, $9, $pop78
	i32.load8_u	$push20=, 0($pop19)
	i32.const	$push77=, 97
	i32.ne  	$push21=, $pop20, $pop77
	br_if   	6, $pop21       # 6: down to label0
# BB#15:                                # %for.inc62.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push80=, 2
	i32.add 	$push22=, $9, $pop80
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push79=, 97
	i32.ne  	$push24=, $pop23, $pop79
	br_if   	6, $pop24       # 6: down to label0
# BB#16:                                # %for.inc62.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push82=, 3
	i32.add 	$push25=, $9, $pop82
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push81=, 97
	i32.ne  	$push27=, $pop26, $pop81
	br_if   	6, $pop27       # 6: down to label0
# BB#17:                                # %for.inc62.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push84=, 4
	i32.add 	$push28=, $9, $pop84
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push83=, 97
	i32.ne  	$push30=, $pop29, $pop83
	br_if   	6, $pop30       # 6: down to label0
# BB#18:                                # %for.inc62.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push86=, 5
	i32.add 	$push31=, $9, $pop86
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push85=, 97
	i32.ne  	$push33=, $pop32, $pop85
	br_if   	6, $pop33       # 6: down to label0
# BB#19:                                # %for.inc62.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push88=, 6
	i32.add 	$push34=, $9, $pop88
	i32.load8_u	$push35=, 0($pop34)
	i32.const	$push87=, 97
	i32.ne  	$push36=, $pop35, $pop87
	br_if   	6, $pop36       # 6: down to label0
# BB#20:                                # %for.inc62.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push90=, 7
	i32.add 	$push37=, $9, $pop90
	i32.load8_u	$push38=, 0($pop37)
	i32.const	$push89=, 97
	i32.ne  	$push39=, $pop38, $pop89
	br_if   	6, $pop39       # 6: down to label0
# BB#21:                                # %for.inc62.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push94=, 1
	i32.add 	$push93=, $6, $pop94
	tee_local	$push92=, $6=, $pop93
	i32.const	$push91=, 80
	i32.lt_u	$push40=, $pop92, $pop91
	br_if   	0, $pop40       # 0: up to label5
# BB#22:                                # %for.inc69
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label6:
	i32.const	$push98=, 1
	i32.add 	$push97=, $3, $pop98
	tee_local	$push96=, $3=, $pop97
	i32.const	$push95=, 8
	i32.lt_u	$push41=, $pop96, $pop95
	br_if   	0, $pop41       # 0: up to label3
# BB#23:                                # %for.inc72
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push102=, 1
	i32.add 	$push101=, $1, $pop102
	tee_local	$push100=, $1=, $pop101
	i32.const	$push99=, 8
	i32.lt_u	$push42=, $pop100, $pop99
	br_if   	0, $pop42       # 0: up to label1
# BB#24:                                # %for.end74
	end_loop                        # label2:
	i32.const	$push43=, 0
	call    	exit@FUNCTION, $pop43
	unreachable
.LBB0_25:                               # %if.then60
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	u1,@object              # @u1
	.lcomm	u1,96,4
	.type	u2,@object              # @u2
	.lcomm	u2,96,4

	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
