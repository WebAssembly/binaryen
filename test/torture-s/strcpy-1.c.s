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
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	block   	
	loop    	                # label1:
	i32.const	$push50=, u1
	i32.add 	$1=, $0, $pop50
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	loop    	                # label2:
	i32.const	$push52=, 65
	i32.add 	$4=, $2, $pop52
	i32.const	$push51=, u2
	i32.add 	$3=, $2, $pop51
	i32.const	$5=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	loop    	                # label3:
	i32.const	$push55=, u1
	i32.const	$push54=, 97
	i32.const	$push53=, 97
	i32.call	$7=, memset@FUNCTION, $pop55, $pop54, $pop53
	i32.const	$8=, 65
	i32.const	$6=, -97
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label4:
	i32.const	$push66=, u2+97
	i32.add 	$push3=, $6, $pop66
	i32.const	$push65=, 65
	i32.const	$push64=, 24
	i32.shl 	$push0=, $8, $pop64
	i32.const	$push63=, 24
	i32.shr_s	$push1=, $pop0, $pop63
	i32.const	$push62=, 95
	i32.gt_s	$push2=, $pop1, $pop62
	i32.select	$push61=, $pop65, $8, $pop2
	tee_local	$push60=, $8=, $pop61
	i32.store8	0($pop3), $pop60
	i32.const	$push59=, 1
	i32.add 	$8=, $8, $pop59
	i32.const	$push58=, 1
	i32.add 	$push57=, $6, $pop58
	tee_local	$push56=, $6=, $pop57
	br_if   	0, $pop56       # 0: up to label4
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$push4=, $5, $2
	i32.const	$push68=, u2
	i32.add 	$push5=, $pop4, $pop68
	i32.const	$push67=, 0
	i32.store8	0($pop5), $pop67
	i32.call	$push6=, strcpy@FUNCTION, $1, $3
	i32.ne  	$push7=, $pop6, $1
	br_if   	3, $pop7        # 3: down to label0
# BB#6:                                 # %for.cond21.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	block   	
	block   	
	i32.const	$push69=, 1
	i32.lt_s	$push8=, $0, $pop69
	br_if   	0, $pop8        # 0: down to label6
# BB#7:                                 # %for.body24.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$8=, 0
.LBB0_8:                                # %for.body24
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label7:
	i32.add 	$push9=, $8, $7
	i32.load8_u	$push10=, 0($pop9)
	i32.const	$push70=, 97
	i32.ne  	$push11=, $pop10, $pop70
	br_if   	6, $pop11       # 6: down to label0
# BB#9:                                 # %for.inc30
                                        #   in Loop: Header=BB0_8 Depth=4
	i32.const	$push73=, 1
	i32.add 	$push72=, $8, $pop73
	tee_local	$push71=, $8=, $pop72
	i32.lt_s	$push12=, $pop71, $0
	br_if   	0, $pop12       # 0: up to label7
# BB#10:                                # %for.body38.preheader.loopexit
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$7=, $8, $7
	br      	1               # 1: down to label5
.LBB0_11:                               #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label6:
	i32.const	$7=, u1
.LBB0_12:                               # %for.body38.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label5:
	i32.const	$8=, 0
	copy_local	$6=, $4
.LBB0_13:                               # %for.body38
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label8:
	i32.add 	$push17=, $7, $8
	i32.load8_u	$push18=, 0($pop17)
	i32.const	$push80=, 65
	i32.const	$push79=, 24
	i32.shl 	$push13=, $6, $pop79
	i32.const	$push78=, 24
	i32.shr_s	$push14=, $pop13, $pop78
	i32.const	$push77=, 95
	i32.gt_s	$push15=, $pop14, $pop77
	i32.select	$push76=, $pop80, $6, $pop15
	tee_local	$push75=, $6=, $pop76
	i32.const	$push74=, 255
	i32.and 	$push16=, $pop75, $pop74
	i32.ne  	$push19=, $pop18, $pop16
	br_if   	4, $pop19       # 4: down to label0
# BB#14:                                # %for.inc50
                                        #   in Loop: Header=BB0_13 Depth=4
	i32.const	$push84=, 1
	i32.add 	$6=, $6, $pop84
	i32.const	$push83=, 1
	i32.add 	$push82=, $8, $pop83
	tee_local	$push81=, $8=, $pop82
	i32.lt_s	$push20=, $pop81, $5
	br_if   	0, $pop20       # 0: up to label8
# BB#15:                                # %for.end54
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$push86=, $7, $8
	tee_local	$push85=, $8=, $pop86
	i32.load8_u	$push21=, 0($pop85)
	br_if   	3, $pop21       # 3: down to label0
# BB#16:                                # %for.cond61.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push88=, 1
	i32.add 	$push22=, $8, $pop88
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push87=, 97
	i32.ne  	$push24=, $pop23, $pop87
	br_if   	3, $pop24       # 3: down to label0
# BB#17:                                # %for.cond61
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push90=, 2
	i32.add 	$push25=, $8, $pop90
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push89=, 97
	i32.ne  	$push27=, $pop26, $pop89
	br_if   	3, $pop27       # 3: down to label0
# BB#18:                                # %for.cond61.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push92=, 3
	i32.add 	$push28=, $8, $pop92
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push91=, 97
	i32.ne  	$push30=, $pop29, $pop91
	br_if   	3, $pop30       # 3: down to label0
# BB#19:                                # %for.cond61.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push94=, 4
	i32.add 	$push31=, $8, $pop94
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push93=, 97
	i32.ne  	$push33=, $pop32, $pop93
	br_if   	3, $pop33       # 3: down to label0
# BB#20:                                # %for.cond61.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push96=, 5
	i32.add 	$push34=, $8, $pop96
	i32.load8_u	$push35=, 0($pop34)
	i32.const	$push95=, 97
	i32.ne  	$push36=, $pop35, $pop95
	br_if   	3, $pop36       # 3: down to label0
# BB#21:                                # %for.cond61.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push98=, 6
	i32.add 	$push37=, $8, $pop98
	i32.load8_u	$push38=, 0($pop37)
	i32.const	$push97=, 97
	i32.ne  	$push39=, $pop38, $pop97
	br_if   	3, $pop39       # 3: down to label0
# BB#22:                                # %for.cond61.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push100=, 7
	i32.add 	$push40=, $8, $pop100
	i32.load8_u	$push41=, 0($pop40)
	i32.const	$push99=, 97
	i32.ne  	$push42=, $pop41, $pop99
	br_if   	3, $pop42       # 3: down to label0
# BB#23:                                # %for.cond61.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push102=, 8
	i32.add 	$push43=, $8, $pop102
	i32.load8_u	$push44=, 0($pop43)
	i32.const	$push101=, 97
	i32.ne  	$push45=, $pop44, $pop101
	br_if   	3, $pop45       # 3: down to label0
# BB#24:                                # %for.cond61.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push106=, 1
	i32.add 	$push105=, $5, $pop106
	tee_local	$push104=, $5=, $pop105
	i32.const	$push103=, 80
	i32.lt_u	$push46=, $pop104, $pop103
	br_if   	0, $pop46       # 0: up to label3
# BB#25:                                # %for.inc77
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push110=, 1
	i32.add 	$push109=, $2, $pop110
	tee_local	$push108=, $2=, $pop109
	i32.const	$push107=, 8
	i32.lt_u	$push47=, $pop108, $pop107
	br_if   	0, $pop47       # 0: up to label2
# BB#26:                                # %for.inc80
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push114=, 1
	i32.add 	$push113=, $0, $pop114
	tee_local	$push112=, $0=, $pop113
	i32.const	$push111=, 8
	i32.lt_u	$push48=, $pop112, $pop111
	br_if   	0, $pop48       # 0: up to label1
# BB#27:                                # %for.end82
	end_loop
	i32.const	$push49=, 0
	call    	exit@FUNCTION, $pop49
	unreachable
.LBB0_28:                               # %if.then19
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
