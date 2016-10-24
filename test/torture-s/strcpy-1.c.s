	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strcpy-1.c"
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
                                        #         Child Loop BB0_13 Depth 4
	block   	
	block   	
	block   	
	loop    	                # label3:
	i32.const	$push52=, u1
	i32.add 	$1=, $0, $pop52
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	loop    	                # label4:
	i32.const	$push54=, 65
	i32.add 	$4=, $2, $pop54
	i32.const	$push53=, u2
	i32.add 	$3=, $2, $pop53
	i32.const	$5=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	loop    	                # label5:
	i32.const	$push57=, u1
	i32.const	$push56=, 97
	i32.const	$push55=, 97
	i32.call	$10=, memset@FUNCTION, $pop57, $pop56, $pop55
	i32.const	$9=, 65
	i32.const	$7=, -97
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label6:
	i32.const	$push68=, u2+97
	i32.add 	$push3=, $7, $pop68
	i32.const	$push67=, 65
	i32.const	$push66=, 24
	i32.shl 	$push0=, $9, $pop66
	i32.const	$push65=, 24
	i32.shr_s	$push1=, $pop0, $pop65
	i32.const	$push64=, 95
	i32.gt_s	$push2=, $pop1, $pop64
	i32.select	$push63=, $pop67, $9, $pop2
	tee_local	$push62=, $9=, $pop63
	i32.store8	0($pop3), $pop62
	i32.const	$push61=, 1
	i32.add 	$9=, $9, $pop61
	i32.const	$push60=, 1
	i32.add 	$push59=, $7, $pop60
	tee_local	$push58=, $7=, $pop59
	br_if   	0, $pop58       # 0: up to label6
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$push4=, $5, $2
	i32.const	$push70=, u2
	i32.add 	$push5=, $pop4, $pop70
	i32.const	$push69=, 0
	i32.store8	0($pop5), $pop69
	i32.call	$push6=, strcpy@FUNCTION, $1, $3
	i32.ne  	$push7=, $pop6, $1
	br_if   	5, $pop7        # 5: down to label0
# BB#6:                                 # %for.cond21.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	block   	
	block   	
	i32.const	$push71=, 1
	i32.lt_s	$push8=, $0, $pop71
	br_if   	0, $pop8        # 0: down to label8
# BB#7:                                 # %for.body24.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$9=, 0
.LBB0_8:                                # %for.body24
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label9:
	i32.add 	$push9=, $9, $10
	i32.load8_u	$push10=, 0($pop9)
	i32.const	$push72=, 97
	i32.ne  	$push11=, $pop10, $pop72
	br_if   	6, $pop11       # 6: down to label2
# BB#9:                                 # %for.inc30
                                        #   in Loop: Header=BB0_8 Depth=4
	i32.const	$push75=, 1
	i32.add 	$push74=, $9, $pop75
	tee_local	$push73=, $9=, $pop74
	i32.lt_s	$push12=, $pop73, $0
	br_if   	0, $pop12       # 0: up to label9
# BB#10:                                # %for.body38.preheader.loopexit
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$8=, $9, $10
	br      	1               # 1: down to label7
.LBB0_11:                               #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label8:
	i32.const	$8=, u1
.LBB0_12:                               # %for.body38.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label7:
	i32.load8_u	$9=, 0($8)
	i32.const	$10=, 0
	copy_local	$7=, $4
.LBB0_13:                               # %for.body38
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label10:
	i32.const	$push81=, 255
	i32.and 	$push13=, $9, $pop81
	i32.const	$push80=, 65
	i32.const	$push79=, 24
	i32.shl 	$push14=, $7, $pop79
	i32.const	$push78=, 24
	i32.shr_s	$push15=, $pop14, $pop78
	i32.const	$push77=, 95
	i32.gt_s	$push16=, $pop15, $pop77
	i32.select	$push17=, $pop80, $7, $pop16
	i32.const	$push76=, 255
	i32.and 	$push18=, $pop17, $pop76
	i32.ne  	$push19=, $pop13, $pop18
	br_if   	4, $pop19       # 4: down to label2
# BB#14:                                # %for.inc50
                                        #   in Loop: Header=BB0_13 Depth=4
	i32.const	$push86=, 1
	i32.add 	$7=, $9, $pop86
	i32.add 	$push21=, $8, $10
	i32.const	$push85=, 1
	i32.add 	$push22=, $pop21, $pop85
	i32.load8_u	$9=, 0($pop22)
	i32.const	$push84=, 1
	i32.add 	$push83=, $10, $pop84
	tee_local	$push82=, $6=, $pop83
	copy_local	$10=, $pop82
	i32.lt_s	$push20=, $6, $5
	br_if   	0, $pop20       # 0: up to label10
# BB#15:                                # %for.end54
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.const	$push87=, 255
	i32.and 	$push23=, $9, $pop87
	br_if   	3, $pop23       # 3: down to label2
# BB#16:                                # %for.cond61.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.add 	$push91=, $8, $6
	tee_local	$push90=, $9=, $pop91
	i32.const	$push89=, 1
	i32.add 	$push24=, $pop90, $pop89
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push88=, 97
	i32.ne  	$push26=, $pop25, $pop88
	br_if   	4, $pop26       # 4: down to label1
# BB#17:                                # %for.cond61
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push93=, 2
	i32.add 	$push27=, $9, $pop93
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push92=, 97
	i32.ne  	$push29=, $pop28, $pop92
	br_if   	4, $pop29       # 4: down to label1
# BB#18:                                # %for.cond61.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push95=, 3
	i32.add 	$push30=, $9, $pop95
	i32.load8_u	$push31=, 0($pop30)
	i32.const	$push94=, 97
	i32.ne  	$push32=, $pop31, $pop94
	br_if   	4, $pop32       # 4: down to label1
# BB#19:                                # %for.cond61.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push97=, 4
	i32.add 	$push33=, $9, $pop97
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push96=, 97
	i32.ne  	$push35=, $pop34, $pop96
	br_if   	4, $pop35       # 4: down to label1
# BB#20:                                # %for.cond61.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push99=, 5
	i32.add 	$push36=, $9, $pop99
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push98=, 97
	i32.ne  	$push38=, $pop37, $pop98
	br_if   	4, $pop38       # 4: down to label1
# BB#21:                                # %for.cond61.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push101=, 6
	i32.add 	$push39=, $9, $pop101
	i32.load8_u	$push40=, 0($pop39)
	i32.const	$push100=, 97
	i32.ne  	$push41=, $pop40, $pop100
	br_if   	4, $pop41       # 4: down to label1
# BB#22:                                # %for.cond61.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push103=, 7
	i32.add 	$push42=, $9, $pop103
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push102=, 97
	i32.ne  	$push44=, $pop43, $pop102
	br_if   	4, $pop44       # 4: down to label1
# BB#23:                                # %for.cond61.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push105=, 8
	i32.add 	$push45=, $9, $pop105
	i32.load8_u	$push46=, 0($pop45)
	i32.const	$push104=, 97
	i32.ne  	$push47=, $pop46, $pop104
	br_if   	4, $pop47       # 4: down to label1
# BB#24:                                # %for.cond61.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push109=, 1
	i32.add 	$push108=, $5, $pop109
	tee_local	$push107=, $5=, $pop108
	i32.const	$push106=, 80
	i32.lt_u	$push48=, $pop107, $pop106
	br_if   	0, $pop48       # 0: up to label5
# BB#25:                                # %for.inc77
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push113=, 1
	i32.add 	$push112=, $2, $pop113
	tee_local	$push111=, $2=, $pop112
	i32.const	$push110=, 8
	i32.lt_u	$push49=, $pop111, $pop110
	br_if   	0, $pop49       # 0: up to label4
# BB#26:                                # %for.inc80
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push117=, 1
	i32.add 	$push116=, $0, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 8
	i32.lt_u	$push50=, $pop115, $pop114
	br_if   	0, $pop50       # 0: up to label3
# BB#27:                                # %for.end82
	end_loop
	i32.const	$push51=, 0
	call    	exit@FUNCTION, $pop51
	unreachable
.LBB0_28:                               # %if.then59
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_29:                               # %if.then68
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_30:                               # %if.then19
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
