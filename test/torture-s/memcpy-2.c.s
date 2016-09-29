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
	i32.const	$push60=, u2+96
	i32.add 	$push3=, $7, $pop60
	i32.const	$push59=, 65
	i32.const	$push58=, 24
	i32.shl 	$push0=, $9, $pop58
	i32.const	$push57=, 24
	i32.shr_s	$push1=, $pop0, $pop57
	i32.const	$push56=, 95
	i32.gt_s	$push2=, $pop1, $pop56
	i32.select	$push55=, $pop59, $9, $pop2
	tee_local	$push54=, $9=, $pop55
	i32.store8	$drop=, 0($pop3), $pop54
	i32.const	$push53=, 1
	i32.add 	$9=, $9, $pop53
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
	i32.const	$push61=, 1
	i32.lt_s	$push4=, $1, $pop61
	br_if   	0, $pop4        # 0: down to label9
# BB#6:                                 # %for.body23.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$9=, 0
.LBB0_7:                                # %for.body23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label10:
	i32.add 	$push5=, $9, $0
	i32.load8_u	$push6=, 0($pop5)
	i32.const	$push62=, 97
	i32.ne  	$push7=, $pop6, $pop62
	br_if   	9, $pop7        # 9: down to label0
# BB#8:                                 # %for.inc29
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push65=, 1
	i32.add 	$push64=, $9, $pop65
	tee_local	$push63=, $9=, $pop64
	i32.lt_s	$push8=, $pop63, $1
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
	i32.const	$push72=, 65
	i32.const	$push71=, 24
	i32.shl 	$push9=, $7, $pop71
	i32.const	$push70=, 24
	i32.shr_s	$push10=, $pop9, $pop70
	i32.const	$push69=, 95
	i32.gt_s	$push11=, $pop10, $pop69
	i32.select	$push68=, $pop72, $7, $pop11
	tee_local	$push67=, $7=, $pop68
	i32.const	$push66=, 255
	i32.and 	$push12=, $pop67, $pop66
	i32.ne  	$push15=, $pop14, $pop12
	br_if   	8, $pop15       # 8: down to label0
# BB#12:                                # %for.inc48
                                        #   in Loop: Header=BB0_11 Depth=4
	i32.const	$push76=, 1
	i32.add 	$7=, $7, $pop76
	i32.const	$push75=, 1
	i32.add 	$push74=, $9, $pop75
	tee_local	$push73=, $9=, $pop74
	i32.lt_s	$push16=, $pop73, $6
	br_if   	0, $pop16       # 0: up to label12
# BB#13:                                # %for.body56.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label13:
	i32.add 	$push79=, $8, $9
	tee_local	$push78=, $9=, $pop79
	i32.load8_u	$push17=, 0($pop78)
	i32.const	$push77=, 97
	i32.ne  	$push18=, $pop17, $pop77
	br_if   	6, $pop18       # 6: down to label0
# BB#14:                                # %for.inc62
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push81=, 1
	i32.add 	$push19=, $9, $pop81
	i32.load8_u	$push20=, 0($pop19)
	i32.const	$push80=, 97
	i32.ne  	$push21=, $pop20, $pop80
	br_if   	6, $pop21       # 6: down to label0
# BB#15:                                # %for.inc62.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push83=, 2
	i32.add 	$push22=, $9, $pop83
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push82=, 97
	i32.ne  	$push24=, $pop23, $pop82
	br_if   	6, $pop24       # 6: down to label0
# BB#16:                                # %for.inc62.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push85=, 3
	i32.add 	$push25=, $9, $pop85
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push84=, 97
	i32.ne  	$push27=, $pop26, $pop84
	br_if   	6, $pop27       # 6: down to label0
# BB#17:                                # %for.inc62.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push87=, 4
	i32.add 	$push28=, $9, $pop87
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push86=, 97
	i32.ne  	$push30=, $pop29, $pop86
	br_if   	6, $pop30       # 6: down to label0
# BB#18:                                # %for.inc62.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push89=, 5
	i32.add 	$push31=, $9, $pop89
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push88=, 97
	i32.ne  	$push33=, $pop32, $pop88
	br_if   	6, $pop33       # 6: down to label0
# BB#19:                                # %for.inc62.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push91=, 6
	i32.add 	$push34=, $9, $pop91
	i32.load8_u	$push35=, 0($pop34)
	i32.const	$push90=, 97
	i32.ne  	$push36=, $pop35, $pop90
	br_if   	6, $pop36       # 6: down to label0
# BB#20:                                # %for.inc62.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push93=, 7
	i32.add 	$push37=, $9, $pop93
	i32.load8_u	$push38=, 0($pop37)
	i32.const	$push92=, 97
	i32.ne  	$push39=, $pop38, $pop92
	br_if   	6, $pop39       # 6: down to label0
# BB#21:                                # %for.inc62.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push97=, 1
	i32.add 	$push96=, $6, $pop97
	tee_local	$push95=, $6=, $pop96
	i32.const	$push94=, 80
	i32.lt_u	$push40=, $pop95, $pop94
	br_if   	0, $pop40       # 0: up to label5
# BB#22:                                # %for.inc69
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label6:
	i32.const	$push101=, 1
	i32.add 	$push100=, $3, $pop101
	tee_local	$push99=, $3=, $pop100
	i32.const	$push98=, 8
	i32.lt_u	$push41=, $pop99, $pop98
	br_if   	0, $pop41       # 0: up to label3
# BB#23:                                # %for.inc72
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push105=, 1
	i32.add 	$push104=, $1, $pop105
	tee_local	$push103=, $1=, $pop104
	i32.const	$push102=, 8
	i32.lt_u	$push42=, $pop103, $pop102
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
	.section	.bss.u1,"aw",@nobits
	.p2align	4
u1:
	.skip	96
	.size	u1, 96

	.type	u2,@object              # @u2
	.section	.bss.u2,"aw",@nobits
	.p2align	4
u2:
	.skip	96
	.size	u2, 96


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
