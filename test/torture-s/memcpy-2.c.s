	.text
	.file	"memcpy-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	block   	
	loop    	                # label1:
	i32.const	$push43=, u1
	i32.add 	$1=, $0, $pop43
	i32.const	$2=, 0
.LBB0_2:                                # %for.body3
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop    	                # label2:
	i32.const	$push45=, 65
	i32.add 	$4=, $2, $pop45
	i32.const	$push44=, u2
	i32.add 	$3=, $2, $pop44
	i32.const	$5=, 1
.LBB0_3:                                # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop    	                # label3:
	i32.const	$push48=, u1
	i32.const	$push47=, 97
	i32.const	$push46=, 96
	i32.call	$7=, memset@FUNCTION, $pop48, $pop47, $pop46
	i32.const	$8=, 65
	i32.const	$6=, -96
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label4:
	i32.const	$push59=, u2+96
	i32.add 	$push3=, $6, $pop59
	i32.const	$push58=, 65
	i32.const	$push57=, 24
	i32.shl 	$push0=, $8, $pop57
	i32.const	$push56=, 24
	i32.shr_s	$push1=, $pop0, $pop56
	i32.const	$push55=, 95
	i32.gt_s	$push2=, $pop1, $pop55
	i32.select	$push54=, $pop58, $8, $pop2
	tee_local	$push53=, $8=, $pop54
	i32.store8	0($pop3), $pop53
	i32.const	$push52=, 1
	i32.add 	$8=, $8, $pop52
	i32.const	$push51=, 1
	i32.add 	$push50=, $6, $pop51
	tee_local	$push49=, $6=, $pop50
	br_if   	0, $pop49       # 0: up to label4
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.call	$drop=, memcpy@FUNCTION, $1, $3, $5
	block   	
	block   	
	i32.eqz 	$push104=, $0
	br_if   	0, $pop104      # 0: down to label6
# BB#6:                                 # %for.body23.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$8=, 0
.LBB0_7:                                # %for.body23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label7:
	i32.add 	$push4=, $8, $7
	i32.load8_u	$push5=, 0($pop4)
	i32.const	$push60=, 97
	i32.ne  	$push6=, $pop5, $pop60
	br_if   	6, $pop6        # 6: down to label0
# BB#8:                                 # %for.inc29
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push63=, 1
	i32.add 	$push62=, $8, $pop63
	tee_local	$push61=, $8=, $pop62
	i32.lt_u	$push7=, $pop61, $0
	br_if   	0, $pop7        # 0: up to label7
# BB#9:                                 # %for.body36.preheader.loopexit
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$7=, $8, $7
	br      	1               # 1: down to label5
.LBB0_10:                               #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label6:
	i32.const	$7=, u1
.LBB0_11:                               # %for.body36.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label5:
	i32.const	$8=, 0
	copy_local	$6=, $4
.LBB0_12:                               # %for.body36
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label8:
	i32.add 	$push12=, $7, $8
	i32.load8_u	$push13=, 0($pop12)
	i32.const	$push70=, 65
	i32.const	$push69=, 24
	i32.shl 	$push8=, $6, $pop69
	i32.const	$push68=, 24
	i32.shr_s	$push9=, $pop8, $pop68
	i32.const	$push67=, 95
	i32.gt_s	$push10=, $pop9, $pop67
	i32.select	$push66=, $pop70, $6, $pop10
	tee_local	$push65=, $6=, $pop66
	i32.const	$push64=, 255
	i32.and 	$push11=, $pop65, $pop64
	i32.ne  	$push14=, $pop13, $pop11
	br_if   	4, $pop14       # 4: down to label0
# BB#13:                                # %for.inc48
                                        #   in Loop: Header=BB0_12 Depth=4
	i32.const	$push74=, 1
	i32.add 	$6=, $6, $pop74
	i32.const	$push73=, 1
	i32.add 	$push72=, $8, $pop73
	tee_local	$push71=, $8=, $pop72
	i32.lt_u	$push15=, $pop71, $5
	br_if   	0, $pop15       # 0: up to label8
# BB#14:                                # %for.end52
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$push77=, $7, $8
	tee_local	$push76=, $8=, $pop77
	i32.load8_u	$push16=, 0($pop76)
	i32.const	$push75=, 97
	i32.ne  	$push17=, $pop16, $pop75
	br_if   	3, $pop17       # 3: down to label0
# BB#15:                                # %for.inc62
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push79=, 1
	i32.add 	$push18=, $8, $pop79
	i32.load8_u	$push19=, 0($pop18)
	i32.const	$push78=, 97
	i32.ne  	$push20=, $pop19, $pop78
	br_if   	3, $pop20       # 3: down to label0
# BB#16:                                # %for.inc62.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push81=, 2
	i32.add 	$push21=, $8, $pop81
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push80=, 97
	i32.ne  	$push23=, $pop22, $pop80
	br_if   	3, $pop23       # 3: down to label0
# BB#17:                                # %for.inc62.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push83=, 3
	i32.add 	$push24=, $8, $pop83
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push82=, 97
	i32.ne  	$push26=, $pop25, $pop82
	br_if   	3, $pop26       # 3: down to label0
# BB#18:                                # %for.inc62.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push85=, 4
	i32.add 	$push27=, $8, $pop85
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push84=, 97
	i32.ne  	$push29=, $pop28, $pop84
	br_if   	3, $pop29       # 3: down to label0
# BB#19:                                # %for.inc62.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push87=, 5
	i32.add 	$push30=, $8, $pop87
	i32.load8_u	$push31=, 0($pop30)
	i32.const	$push86=, 97
	i32.ne  	$push32=, $pop31, $pop86
	br_if   	3, $pop32       # 3: down to label0
# BB#20:                                # %for.inc62.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push89=, 6
	i32.add 	$push33=, $8, $pop89
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push88=, 97
	i32.ne  	$push35=, $pop34, $pop88
	br_if   	3, $pop35       # 3: down to label0
# BB#21:                                # %for.inc62.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push91=, 7
	i32.add 	$push36=, $8, $pop91
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push90=, 97
	i32.ne  	$push38=, $pop37, $pop90
	br_if   	3, $pop38       # 3: down to label0
# BB#22:                                # %for.inc62.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push95=, 1
	i32.add 	$push94=, $5, $pop95
	tee_local	$push93=, $5=, $pop94
	i32.const	$push92=, 80
	i32.lt_u	$push39=, $pop93, $pop92
	br_if   	0, $pop39       # 0: up to label3
# BB#23:                                # %for.inc69
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push99=, 1
	i32.add 	$push98=, $2, $pop99
	tee_local	$push97=, $2=, $pop98
	i32.const	$push96=, 8
	i32.lt_u	$push40=, $pop97, $pop96
	br_if   	0, $pop40       # 0: up to label2
# BB#24:                                # %for.inc72
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push103=, 1
	i32.add 	$push102=, $0, $pop103
	tee_local	$push101=, $0=, $pop102
	i32.const	$push100=, 8
	i32.lt_u	$push41=, $pop101, $pop100
	br_if   	0, $pop41       # 0: up to label1
# BB#25:                                # %for.end74
	end_loop
	i32.const	$push42=, 0
	call    	exit@FUNCTION, $pop42
	unreachable
.LBB0_26:                               # %if.then27
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
