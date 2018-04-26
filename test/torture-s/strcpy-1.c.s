	.text
	.file	"strcpy-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	block   	
	loop    	                # label1:
	i32.const	$push49=, u1
	i32.add 	$1=, $0, $pop49
	i32.const	$2=, 0
.LBB0_2:                                # %for.body3
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	loop    	                # label2:
	i32.const	$push51=, 65
	i32.add 	$4=, $2, $pop51
	i32.const	$push50=, u2
	i32.add 	$3=, $2, $pop50
	i32.const	$5=, 1
.LBB0_3:                                # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_8 Depth 4
                                        #         Child Loop BB0_13 Depth 4
	loop    	                # label3:
	i32.const	$push54=, u1
	i32.const	$push53=, 97
	i32.const	$push52=, 97
	i32.call	$7=, memset@FUNCTION, $pop54, $pop53, $pop52
	i32.const	$6=, 65
	i32.const	$8=, -97
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label4:
	i32.const	$push61=, 65
	i32.const	$push60=, 24
	i32.shl 	$push0=, $6, $pop60
	i32.const	$push59=, 24
	i32.shr_s	$push1=, $pop0, $pop59
	i32.const	$push58=, 95
	i32.gt_s	$push2=, $pop1, $pop58
	i32.select	$6=, $pop61, $6, $pop2
	i32.const	$push57=, u2+97
	i32.add 	$push3=, $8, $pop57
	i32.store8	0($pop3), $6
	i32.const	$push56=, 1
	i32.add 	$8=, $8, $pop56
	i32.const	$push55=, 1
	i32.add 	$6=, $6, $pop55
	br_if   	0, $8           # 0: up to label4
# %bb.5:                                # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$push4=, $5, $2
	i32.const	$push63=, u2
	i32.add 	$push5=, $pop4, $pop63
	i32.const	$push62=, 0
	i32.store8	0($pop5), $pop62
	i32.call	$push6=, strcpy@FUNCTION, $1, $3
	i32.ne  	$push7=, $pop6, $1
	br_if   	3, $pop7        # 3: down to label0
# %bb.6:                                # %if.end20
                                        #   in Loop: Header=BB0_3 Depth=3
	block   	
	block   	
	i32.eqz 	$push95=, $0
	br_if   	0, $pop95       # 0: down to label6
# %bb.7:                                # %for.body24.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$8=, 0
.LBB0_8:                                # %for.body24
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label7:
	i32.add 	$push8=, $8, $7
	i32.load8_u	$push9=, 0($pop8)
	i32.const	$push64=, 97
	i32.ne  	$push10=, $pop9, $pop64
	br_if   	6, $pop10       # 6: down to label0
# %bb.9:                                # %for.inc30
                                        #   in Loop: Header=BB0_8 Depth=4
	i32.const	$push65=, 1
	i32.add 	$8=, $8, $pop65
	i32.lt_u	$push11=, $8, $0
	br_if   	0, $pop11       # 0: up to label7
# %bb.10:                               # %for.body38.preheader.loopexit
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
	i32.const	$push70=, 65
	i32.const	$push69=, 24
	i32.shl 	$push12=, $6, $pop69
	i32.const	$push68=, 24
	i32.shr_s	$push13=, $pop12, $pop68
	i32.const	$push67=, 95
	i32.gt_s	$push14=, $pop13, $pop67
	i32.select	$6=, $pop70, $6, $pop14
	i32.add 	$push16=, $7, $8
	i32.load8_u	$push17=, 0($pop16)
	i32.const	$push66=, 255
	i32.and 	$push15=, $6, $pop66
	i32.ne  	$push18=, $pop17, $pop15
	br_if   	4, $pop18       # 4: down to label0
# %bb.14:                               # %for.inc50
                                        #   in Loop: Header=BB0_13 Depth=4
	i32.const	$push72=, 1
	i32.add 	$6=, $6, $pop72
	i32.const	$push71=, 1
	i32.add 	$8=, $8, $pop71
	i32.lt_u	$push19=, $8, $5
	br_if   	0, $pop19       # 0: up to label8
# %bb.15:                               # %for.end54
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$8=, $7, $8
	i32.load8_u	$push20=, 0($8)
	br_if   	3, $pop20       # 3: down to label0
# %bb.16:                               # %if.end60
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push74=, 1
	i32.add 	$push21=, $8, $pop74
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push73=, 97
	i32.ne  	$push23=, $pop22, $pop73
	br_if   	3, $pop23       # 3: down to label0
# %bb.17:                               # %for.cond61
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push76=, 2
	i32.add 	$push24=, $8, $pop76
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push75=, 97
	i32.ne  	$push26=, $pop25, $pop75
	br_if   	3, $pop26       # 3: down to label0
# %bb.18:                               # %for.cond61.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push78=, 3
	i32.add 	$push27=, $8, $pop78
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push77=, 97
	i32.ne  	$push29=, $pop28, $pop77
	br_if   	3, $pop29       # 3: down to label0
# %bb.19:                               # %for.cond61.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push80=, 4
	i32.add 	$push30=, $8, $pop80
	i32.load8_u	$push31=, 0($pop30)
	i32.const	$push79=, 97
	i32.ne  	$push32=, $pop31, $pop79
	br_if   	3, $pop32       # 3: down to label0
# %bb.20:                               # %for.cond61.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push82=, 5
	i32.add 	$push33=, $8, $pop82
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push81=, 97
	i32.ne  	$push35=, $pop34, $pop81
	br_if   	3, $pop35       # 3: down to label0
# %bb.21:                               # %for.cond61.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push84=, 6
	i32.add 	$push36=, $8, $pop84
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push83=, 97
	i32.ne  	$push38=, $pop37, $pop83
	br_if   	3, $pop38       # 3: down to label0
# %bb.22:                               # %for.cond61.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push86=, 7
	i32.add 	$push39=, $8, $pop86
	i32.load8_u	$push40=, 0($pop39)
	i32.const	$push85=, 97
	i32.ne  	$push41=, $pop40, $pop85
	br_if   	3, $pop41       # 3: down to label0
# %bb.23:                               # %for.cond61.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push88=, 8
	i32.add 	$push42=, $8, $pop88
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push87=, 97
	i32.ne  	$push44=, $pop43, $pop87
	br_if   	3, $pop44       # 3: down to label0
# %bb.24:                               # %for.cond61.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push90=, 1
	i32.add 	$5=, $5, $pop90
	i32.const	$push89=, 80
	i32.lt_u	$push45=, $5, $pop89
	br_if   	0, $pop45       # 0: up to label3
# %bb.25:                               # %for.inc77
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push92=, 1
	i32.add 	$2=, $2, $pop92
	i32.const	$push91=, 8
	i32.lt_u	$push46=, $2, $pop91
	br_if   	0, $pop46       # 0: up to label2
# %bb.26:                               # %for.inc80
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push94=, 1
	i32.add 	$0=, $0, $pop94
	i32.const	$push93=, 8
	i32.lt_u	$push47=, $0, $pop93
	br_if   	0, $pop47       # 0: up to label1
# %bb.27:                               # %for.end82
	end_loop
	i32.const	$push48=, 0
	call    	exit@FUNCTION, $pop48
	unreachable
.LBB0_28:                               # %if.then19
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
	.skip	112
	.size	u1, 112

	.type	u2,@object              # @u2
	.section	.bss.u2,"aw",@nobits
	.p2align	4
u2:
	.skip	112
	.size	u2, 112


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
