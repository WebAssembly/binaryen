	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-3.c"
	.section	.text.reset,"ax",@progbits
	.hidden	reset
	.globl	reset
	.type	reset,@function
reset:                                  # @reset
# BB#0:                                 # %entry
	i32.const	$push2=, u
	i32.const	$push1=, 97
	i32.const	$push0=, 31
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	reset, .Lfunc_end0-reset

	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	block   	
	i32.const	$push28=, 1
	i32.lt_s	$push0=, $0, $pop28
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push30=, u
	i32.add 	$push1=, $3, $pop30
	i32.load8_u	$push2=, 0($pop1)
	i32.const	$push29=, 97
	i32.ne  	$push3=, $pop2, $pop29
	br_if   	4, $pop3        # 4: down to label0
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push33=, 1
	i32.add 	$push32=, $3, $pop33
	tee_local	$push31=, $3=, $pop32
	i32.lt_s	$push4=, $pop31, $0
	br_if   	0, $pop4        # 0: up to label4
# BB#4:                                 # %for.cond3.preheader.loopexit
	end_loop
	i32.const	$push5=, u
	i32.add 	$0=, $3, $pop5
	i32.const	$push34=, 1
	i32.ge_s	$push7=, $1, $pop34
	br_if   	1, $pop7        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_5:
	end_block                       # label3:
	i32.const	$0=, u
	i32.const	$push35=, 1
	i32.lt_s	$push6=, $1, $pop35
	br_if   	1, $pop6        # 1: down to label1
.LBB1_6:                                # %for.body6.preheader
	end_block                       # label2:
	i32.const	$3=, 0
.LBB1_7:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.add 	$push8=, $0, $3
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop9, $2
	br_if   	2, $pop10       # 2: down to label0
# BB#8:                                 # %for.inc12
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push38=, 1
	i32.add 	$push37=, $3, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.lt_s	$push11=, $pop36, $1
	br_if   	0, $pop11       # 0: up to label5
# BB#9:                                 # %for.body19.preheader.loopexit
	end_loop
	i32.add 	$0=, $0, $3
.LBB1_10:                               # %for.body19.preheader
	end_block                       # label1:
	i32.load8_u	$push12=, 0($0)
	i32.const	$push39=, 97
	i32.ne  	$push13=, $pop12, $pop39
	br_if   	0, $pop13       # 0: down to label0
# BB#11:                                # %for.inc25
	i32.load8_u	$push14=, 1($0)
	i32.const	$push40=, 97
	i32.ne  	$push15=, $pop14, $pop40
	br_if   	0, $pop15       # 0: down to label0
# BB#12:                                # %for.inc25.1
	i32.load8_u	$push16=, 2($0)
	i32.const	$push41=, 97
	i32.ne  	$push17=, $pop16, $pop41
	br_if   	0, $pop17       # 0: down to label0
# BB#13:                                # %for.inc25.2
	i32.load8_u	$push18=, 3($0)
	i32.const	$push42=, 97
	i32.ne  	$push19=, $pop18, $pop42
	br_if   	0, $pop19       # 0: down to label0
# BB#14:                                # %for.inc25.3
	i32.load8_u	$push20=, 4($0)
	i32.const	$push43=, 97
	i32.ne  	$push21=, $pop20, $pop43
	br_if   	0, $pop21       # 0: down to label0
# BB#15:                                # %for.inc25.4
	i32.load8_u	$push22=, 5($0)
	i32.const	$push44=, 97
	i32.ne  	$push23=, $pop22, $pop44
	br_if   	0, $pop23       # 0: down to label0
# BB#16:                                # %for.inc25.5
	i32.load8_u	$push24=, 6($0)
	i32.const	$push45=, 97
	i32.ne  	$push25=, $pop24, $pop45
	br_if   	0, $pop25       # 0: down to label0
# BB#17:                                # %for.inc25.6
	i32.load8_u	$push26=, 7($0)
	i32.const	$push46=, 97
	i32.ne  	$push27=, $pop26, $pop46
	br_if   	0, $pop27       # 0: down to label0
# BB#18:                                # %for.inc25.7
	return
.LBB1_19:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	check, .Lfunc_end1-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_16 Depth 2
                                        #     Child Loop BB2_29 Depth 2
	block   	
	loop    	                # label7:
	i32.const	$push83=, u
	i32.const	$push82=, 97
	i32.const	$push81=, 31
	i32.call	$push0=, memset@FUNCTION, $pop83, $pop82, $pop81
	i32.const	$push80=, 0
	i32.call	$0=, memset@FUNCTION, $pop0, $pop80, $3
	i32.const	$2=, u
	block   	
	i32.const	$push79=, 1
	i32.lt_s	$push78=, $3, $pop79
	tee_local	$push77=, $1=, $pop78
	br_if   	0, $pop77       # 0: down to label8
# BB#2:                                 # %for.body6.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
.LBB2_3:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label9:
	i32.add 	$push2=, $2, $0
	i32.load8_u	$push3=, 0($pop2)
	br_if   	3, $pop3        # 3: down to label6
# BB#4:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push86=, 1
	i32.add 	$push85=, $2, $pop86
	tee_local	$push84=, $2=, $pop85
	i32.lt_s	$push4=, $pop84, $3
	br_if   	0, $pop4        # 0: up to label9
# BB#5:                                 # %for.body19.preheader.i.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_6:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.load8_u	$push5=, 0($2)
	i32.const	$push87=, 97
	i32.ne  	$push6=, $pop5, $pop87
	br_if   	1, $pop6        # 1: down to label6
# BB#7:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push7=, 1($2)
	i32.const	$push88=, 97
	i32.ne  	$push8=, $pop7, $pop88
	br_if   	1, $pop8        # 1: down to label6
# BB#8:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push9=, 2($2)
	i32.const	$push89=, 97
	i32.ne  	$push10=, $pop9, $pop89
	br_if   	1, $pop10       # 1: down to label6
# BB#9:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push11=, 3($2)
	i32.const	$push90=, 97
	i32.ne  	$push12=, $pop11, $pop90
	br_if   	1, $pop12       # 1: down to label6
# BB#10:                                # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push13=, 4($2)
	i32.const	$push91=, 97
	i32.ne  	$push14=, $pop13, $pop91
	br_if   	1, $pop14       # 1: down to label6
# BB#11:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push15=, 5($2)
	i32.const	$push92=, 97
	i32.ne  	$push16=, $pop15, $pop92
	br_if   	1, $pop16       # 1: down to label6
# BB#12:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push17=, 6($2)
	i32.const	$push93=, 97
	i32.ne  	$push18=, $pop17, $pop93
	br_if   	1, $pop18       # 1: down to label6
# BB#13:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push19=, 7($2)
	i32.const	$push94=, 97
	i32.ne  	$push20=, $pop19, $pop94
	br_if   	1, $pop20       # 1: down to label6
# BB#14:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, u
	i32.const	$push96=, u
	i32.const	$push95=, 0
	i32.load8_u	$push21=, A($pop95)
	i32.call	$drop=, memset@FUNCTION, $pop96, $pop21, $3
	block   	
	br_if   	0, $1           # 0: down to label10
# BB#15:                                # %for.body6.i241.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
.LBB2_16:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label11:
	i32.add 	$push22=, $2, $0
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push97=, 65
	i32.ne  	$push24=, $pop23, $pop97
	br_if   	3, $pop24       # 3: down to label6
# BB#17:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_16 Depth=2
	i32.const	$push100=, 1
	i32.add 	$push99=, $2, $pop100
	tee_local	$push98=, $2=, $pop99
	i32.lt_s	$push25=, $pop98, $3
	br_if   	0, $pop25       # 0: up to label11
# BB#18:                                # %for.body19.preheader.i249.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_19:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load8_u	$push26=, 0($2)
	i32.const	$push101=, 97
	i32.ne  	$push27=, $pop26, $pop101
	br_if   	1, $pop27       # 1: down to label6
# BB#20:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push28=, 1($2)
	i32.const	$push102=, 97
	i32.ne  	$push29=, $pop28, $pop102
	br_if   	1, $pop29       # 1: down to label6
# BB#21:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push30=, 2($2)
	i32.const	$push103=, 97
	i32.ne  	$push31=, $pop30, $pop103
	br_if   	1, $pop31       # 1: down to label6
# BB#22:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push32=, 3($2)
	i32.const	$push104=, 97
	i32.ne  	$push33=, $pop32, $pop104
	br_if   	1, $pop33       # 1: down to label6
# BB#23:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push34=, 4($2)
	i32.const	$push105=, 97
	i32.ne  	$push35=, $pop34, $pop105
	br_if   	1, $pop35       # 1: down to label6
# BB#24:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push36=, 5($2)
	i32.const	$push106=, 97
	i32.ne  	$push37=, $pop36, $pop106
	br_if   	1, $pop37       # 1: down to label6
# BB#25:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push38=, 6($2)
	i32.const	$push107=, 97
	i32.ne  	$push39=, $pop38, $pop107
	br_if   	1, $pop39       # 1: down to label6
# BB#26:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push40=, 7($2)
	i32.const	$push108=, 97
	i32.ne  	$push41=, $pop40, $pop108
	br_if   	1, $pop41       # 1: down to label6
# BB#27:                                # %check.exit272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, u
	i32.const	$push110=, u
	i32.const	$push109=, 66
	i32.call	$drop=, memset@FUNCTION, $pop110, $pop109, $3
	block   	
	br_if   	0, $1           # 0: down to label12
# BB#28:                                # %for.body6.i278.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
.LBB2_29:                               # %for.body6.i278
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i32.add 	$push42=, $2, $0
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push111=, 66
	i32.ne  	$push44=, $pop43, $pop111
	br_if   	3, $pop44       # 3: down to label6
# BB#30:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_29 Depth=2
	i32.const	$push114=, 1
	i32.add 	$push113=, $2, $pop114
	tee_local	$push112=, $2=, $pop113
	i32.lt_s	$push45=, $pop112, $3
	br_if   	0, $pop45       # 0: up to label13
# BB#31:                                # %for.body19.preheader.i286.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_32:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.load8_u	$push46=, 0($2)
	i32.const	$push115=, 97
	i32.ne  	$push47=, $pop46, $pop115
	br_if   	1, $pop47       # 1: down to label6
# BB#33:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push48=, 1($2)
	i32.const	$push116=, 97
	i32.ne  	$push49=, $pop48, $pop116
	br_if   	1, $pop49       # 1: down to label6
# BB#34:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push50=, 2($2)
	i32.const	$push117=, 97
	i32.ne  	$push51=, $pop50, $pop117
	br_if   	1, $pop51       # 1: down to label6
# BB#35:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push52=, 3($2)
	i32.const	$push118=, 97
	i32.ne  	$push53=, $pop52, $pop118
	br_if   	1, $pop53       # 1: down to label6
# BB#36:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push54=, 4($2)
	i32.const	$push119=, 97
	i32.ne  	$push55=, $pop54, $pop119
	br_if   	1, $pop55       # 1: down to label6
# BB#37:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push56=, 5($2)
	i32.const	$push120=, 97
	i32.ne  	$push57=, $pop56, $pop120
	br_if   	1, $pop57       # 1: down to label6
# BB#38:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push58=, 6($2)
	i32.const	$push121=, 97
	i32.ne  	$push59=, $pop58, $pop121
	br_if   	1, $pop59       # 1: down to label6
# BB#39:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push60=, 7($2)
	i32.const	$push122=, 97
	i32.ne  	$push61=, $pop60, $pop122
	br_if   	1, $pop61       # 1: down to label6
# BB#40:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push124=, 14
	i32.lt_s	$0=, $3, $pop124
	i32.const	$push123=, 1
	i32.add 	$push1=, $3, $pop123
	copy_local	$3=, $pop1
	br_if   	0, $0           # 0: up to label7
# BB#41:                                # %for.body13.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_42:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push141=, u
	i32.const	$push140=, 97
	i32.const	$push139=, 31
	i32.call	$drop=, memset@FUNCTION, $pop141, $pop140, $pop139
	i32.const	$push138=, u+1
	i32.const	$push137=, 0
	i32.call	$0=, memset@FUNCTION, $pop138, $pop137, $3
	i32.const	$push136=, 1
	i32.const	$push135=, 0
	call    	check@FUNCTION, $pop136, $3, $pop135
	i32.const	$push134=, 0
	i32.load8_u	$push62=, A($pop134)
	i32.call	$drop=, memset@FUNCTION, $0, $pop62, $3
	i32.const	$push133=, 1
	i32.const	$push132=, 65
	call    	check@FUNCTION, $pop133, $3, $pop132
	i32.const	$push131=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop131, $3
	i32.const	$push130=, 1
	i32.const	$push129=, 66
	call    	check@FUNCTION, $pop130, $3, $pop129
	i32.const	$push128=, 1
	i32.add 	$push127=, $3, $pop128
	tee_local	$push126=, $3=, $pop127
	i32.const	$push125=, 15
	i32.ne  	$push63=, $pop126, $pop125
	br_if   	0, $pop63       # 0: up to label14
# BB#43:                                # %for.body33.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_44:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push158=, u
	i32.const	$push157=, 97
	i32.const	$push156=, 31
	i32.call	$drop=, memset@FUNCTION, $pop158, $pop157, $pop156
	i32.const	$push155=, u+2
	i32.const	$push154=, 0
	i32.call	$0=, memset@FUNCTION, $pop155, $pop154, $3
	i32.const	$push153=, 2
	i32.const	$push152=, 0
	call    	check@FUNCTION, $pop153, $3, $pop152
	i32.const	$push151=, 0
	i32.load8_u	$push64=, A($pop151)
	i32.call	$drop=, memset@FUNCTION, $0, $pop64, $3
	i32.const	$push150=, 2
	i32.const	$push149=, 65
	call    	check@FUNCTION, $pop150, $3, $pop149
	i32.const	$push148=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop148, $3
	i32.const	$push147=, 2
	i32.const	$push146=, 66
	call    	check@FUNCTION, $pop147, $3, $pop146
	i32.const	$push145=, 1
	i32.add 	$push144=, $3, $pop145
	tee_local	$push143=, $3=, $pop144
	i32.const	$push142=, 15
	i32.ne  	$push65=, $pop143, $pop142
	br_if   	0, $pop65       # 0: up to label15
# BB#45:                                # %for.body53.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_46:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push175=, u
	i32.const	$push174=, 97
	i32.const	$push173=, 31
	i32.call	$drop=, memset@FUNCTION, $pop175, $pop174, $pop173
	i32.const	$push172=, u+3
	i32.const	$push171=, 0
	i32.call	$0=, memset@FUNCTION, $pop172, $pop171, $3
	i32.const	$push170=, 3
	i32.const	$push169=, 0
	call    	check@FUNCTION, $pop170, $3, $pop169
	i32.const	$push168=, 0
	i32.load8_u	$push66=, A($pop168)
	i32.call	$drop=, memset@FUNCTION, $0, $pop66, $3
	i32.const	$push167=, 3
	i32.const	$push166=, 65
	call    	check@FUNCTION, $pop167, $3, $pop166
	i32.const	$push165=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop165, $3
	i32.const	$push164=, 3
	i32.const	$push163=, 66
	call    	check@FUNCTION, $pop164, $3, $pop163
	i32.const	$push162=, 1
	i32.add 	$push161=, $3, $pop162
	tee_local	$push160=, $3=, $pop161
	i32.const	$push159=, 15
	i32.ne  	$push67=, $pop160, $pop159
	br_if   	0, $pop67       # 0: up to label16
# BB#47:                                # %for.body73.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_48:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push192=, u
	i32.const	$push191=, 97
	i32.const	$push190=, 31
	i32.call	$drop=, memset@FUNCTION, $pop192, $pop191, $pop190
	i32.const	$push189=, u+4
	i32.const	$push188=, 0
	i32.call	$0=, memset@FUNCTION, $pop189, $pop188, $3
	i32.const	$push187=, 4
	i32.const	$push186=, 0
	call    	check@FUNCTION, $pop187, $3, $pop186
	i32.const	$push185=, 0
	i32.load8_u	$push68=, A($pop185)
	i32.call	$drop=, memset@FUNCTION, $0, $pop68, $3
	i32.const	$push184=, 4
	i32.const	$push183=, 65
	call    	check@FUNCTION, $pop184, $3, $pop183
	i32.const	$push182=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop182, $3
	i32.const	$push181=, 4
	i32.const	$push180=, 66
	call    	check@FUNCTION, $pop181, $3, $pop180
	i32.const	$push179=, 1
	i32.add 	$push178=, $3, $pop179
	tee_local	$push177=, $3=, $pop178
	i32.const	$push176=, 15
	i32.ne  	$push69=, $pop177, $pop176
	br_if   	0, $pop69       # 0: up to label17
# BB#49:                                # %for.body93.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_50:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push209=, u
	i32.const	$push208=, 97
	i32.const	$push207=, 31
	i32.call	$drop=, memset@FUNCTION, $pop209, $pop208, $pop207
	i32.const	$push206=, u+5
	i32.const	$push205=, 0
	i32.call	$0=, memset@FUNCTION, $pop206, $pop205, $3
	i32.const	$push204=, 5
	i32.const	$push203=, 0
	call    	check@FUNCTION, $pop204, $3, $pop203
	i32.const	$push202=, 0
	i32.load8_u	$push70=, A($pop202)
	i32.call	$drop=, memset@FUNCTION, $0, $pop70, $3
	i32.const	$push201=, 5
	i32.const	$push200=, 65
	call    	check@FUNCTION, $pop201, $3, $pop200
	i32.const	$push199=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop199, $3
	i32.const	$push198=, 5
	i32.const	$push197=, 66
	call    	check@FUNCTION, $pop198, $3, $pop197
	i32.const	$push196=, 1
	i32.add 	$push195=, $3, $pop196
	tee_local	$push194=, $3=, $pop195
	i32.const	$push193=, 15
	i32.ne  	$push71=, $pop194, $pop193
	br_if   	0, $pop71       # 0: up to label18
# BB#51:                                # %for.body113.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_52:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push226=, u
	i32.const	$push225=, 97
	i32.const	$push224=, 31
	i32.call	$drop=, memset@FUNCTION, $pop226, $pop225, $pop224
	i32.const	$push223=, u+6
	i32.const	$push222=, 0
	i32.call	$0=, memset@FUNCTION, $pop223, $pop222, $3
	i32.const	$push221=, 6
	i32.const	$push220=, 0
	call    	check@FUNCTION, $pop221, $3, $pop220
	i32.const	$push219=, 0
	i32.load8_u	$push72=, A($pop219)
	i32.call	$drop=, memset@FUNCTION, $0, $pop72, $3
	i32.const	$push218=, 6
	i32.const	$push217=, 65
	call    	check@FUNCTION, $pop218, $3, $pop217
	i32.const	$push216=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop216, $3
	i32.const	$push215=, 6
	i32.const	$push214=, 66
	call    	check@FUNCTION, $pop215, $3, $pop214
	i32.const	$push213=, 1
	i32.add 	$push212=, $3, $pop213
	tee_local	$push211=, $3=, $pop212
	i32.const	$push210=, 15
	i32.ne  	$push73=, $pop211, $pop210
	br_if   	0, $pop73       # 0: up to label19
# BB#53:                                # %for.body133.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_54:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push243=, u
	i32.const	$push242=, 97
	i32.const	$push241=, 31
	i32.call	$drop=, memset@FUNCTION, $pop243, $pop242, $pop241
	i32.const	$push240=, u+7
	i32.const	$push239=, 0
	i32.call	$0=, memset@FUNCTION, $pop240, $pop239, $3
	i32.const	$push238=, 7
	i32.const	$push237=, 0
	call    	check@FUNCTION, $pop238, $3, $pop237
	i32.const	$push236=, 0
	i32.load8_u	$push74=, A($pop236)
	i32.call	$drop=, memset@FUNCTION, $0, $pop74, $3
	i32.const	$push235=, 7
	i32.const	$push234=, 65
	call    	check@FUNCTION, $pop235, $3, $pop234
	i32.const	$push233=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop233, $3
	i32.const	$push232=, 7
	i32.const	$push231=, 66
	call    	check@FUNCTION, $pop232, $3, $pop231
	i32.const	$push230=, 1
	i32.add 	$push229=, $3, $pop230
	tee_local	$push228=, $3=, $pop229
	i32.const	$push227=, 15
	i32.ne  	$push75=, $pop228, $pop227
	br_if   	0, $pop75       # 0: up to label20
# BB#55:                                # %for.end149
	end_loop
	i32.const	$push76=, 0
	call    	exit@FUNCTION, $pop76
	unreachable
.LBB2_56:                               # %if.then10.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	A                       # @A
	.type	A,@object
	.section	.data.A,"aw",@progbits
	.globl	A
A:
	.int8	65                      # 0x41
	.size	A, 1

	.type	u,@object               # @u
	.section	.bss.u,"aw",@nobits
	.p2align	4
u:
	.skip	32
	.size	u, 32


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
