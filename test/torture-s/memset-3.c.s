	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-3.c"
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
	i32.ge_s	$push6=, $1, $pop34
	br_if   	1, $pop6        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_5:
	end_block                       # label3:
	i32.const	$0=, u
	i32.const	$push35=, 1
	i32.lt_s	$push7=, $1, $pop35
	br_if   	1, $pop7        # 1: down to label1
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
.LBB1_19:                               # %if.then23
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
	i32.add 	$push1=, $2, $0
	i32.load8_u	$push2=, 0($pop1)
	br_if   	3, $pop2        # 3: down to label6
# BB#4:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push86=, 1
	i32.add 	$push85=, $2, $pop86
	tee_local	$push84=, $2=, $pop85
	i32.lt_s	$push3=, $pop84, $3
	br_if   	0, $pop3        # 0: up to label9
# BB#5:                                 # %for.body19.preheader.i.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_6:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.load8_u	$push4=, 0($2)
	i32.const	$push87=, 97
	i32.ne  	$push5=, $pop4, $pop87
	br_if   	1, $pop5        # 1: down to label6
# BB#7:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push6=, 1($2)
	i32.const	$push88=, 97
	i32.ne  	$push7=, $pop6, $pop88
	br_if   	1, $pop7        # 1: down to label6
# BB#8:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push8=, 2($2)
	i32.const	$push89=, 97
	i32.ne  	$push9=, $pop8, $pop89
	br_if   	1, $pop9        # 1: down to label6
# BB#9:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push10=, 3($2)
	i32.const	$push90=, 97
	i32.ne  	$push11=, $pop10, $pop90
	br_if   	1, $pop11       # 1: down to label6
# BB#10:                                # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push12=, 4($2)
	i32.const	$push91=, 97
	i32.ne  	$push13=, $pop12, $pop91
	br_if   	1, $pop13       # 1: down to label6
# BB#11:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push14=, 5($2)
	i32.const	$push92=, 97
	i32.ne  	$push15=, $pop14, $pop92
	br_if   	1, $pop15       # 1: down to label6
# BB#12:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push16=, 6($2)
	i32.const	$push93=, 97
	i32.ne  	$push17=, $pop16, $pop93
	br_if   	1, $pop17       # 1: down to label6
# BB#13:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push18=, 7($2)
	i32.const	$push94=, 97
	i32.ne  	$push19=, $pop18, $pop94
	br_if   	1, $pop19       # 1: down to label6
# BB#14:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, u
	i32.const	$push96=, u
	i32.const	$push95=, 0
	i32.load8_u	$push20=, A($pop95)
	i32.call	$drop=, memset@FUNCTION, $pop96, $pop20, $3
	block   	
	br_if   	0, $1           # 0: down to label10
# BB#15:                                # %for.body6.i241.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
.LBB2_16:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label11:
	i32.add 	$push21=, $2, $0
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push97=, 65
	i32.ne  	$push23=, $pop22, $pop97
	br_if   	3, $pop23       # 3: down to label6
# BB#17:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_16 Depth=2
	i32.const	$push100=, 1
	i32.add 	$push99=, $2, $pop100
	tee_local	$push98=, $2=, $pop99
	i32.lt_s	$push24=, $pop98, $3
	br_if   	0, $pop24       # 0: up to label11
# BB#18:                                # %for.body19.preheader.i249.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_19:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load8_u	$push25=, 0($2)
	i32.const	$push101=, 97
	i32.ne  	$push26=, $pop25, $pop101
	br_if   	1, $pop26       # 1: down to label6
# BB#20:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push27=, 1($2)
	i32.const	$push102=, 97
	i32.ne  	$push28=, $pop27, $pop102
	br_if   	1, $pop28       # 1: down to label6
# BB#21:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push29=, 2($2)
	i32.const	$push103=, 97
	i32.ne  	$push30=, $pop29, $pop103
	br_if   	1, $pop30       # 1: down to label6
# BB#22:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push31=, 3($2)
	i32.const	$push104=, 97
	i32.ne  	$push32=, $pop31, $pop104
	br_if   	1, $pop32       # 1: down to label6
# BB#23:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push33=, 4($2)
	i32.const	$push105=, 97
	i32.ne  	$push34=, $pop33, $pop105
	br_if   	1, $pop34       # 1: down to label6
# BB#24:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push35=, 5($2)
	i32.const	$push106=, 97
	i32.ne  	$push36=, $pop35, $pop106
	br_if   	1, $pop36       # 1: down to label6
# BB#25:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push37=, 6($2)
	i32.const	$push107=, 97
	i32.ne  	$push38=, $pop37, $pop107
	br_if   	1, $pop38       # 1: down to label6
# BB#26:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push39=, 7($2)
	i32.const	$push108=, 97
	i32.ne  	$push40=, $pop39, $pop108
	br_if   	1, $pop40       # 1: down to label6
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
	i32.add 	$push41=, $2, $0
	i32.load8_u	$push42=, 0($pop41)
	i32.const	$push111=, 66
	i32.ne  	$push43=, $pop42, $pop111
	br_if   	3, $pop43       # 3: down to label6
# BB#30:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_29 Depth=2
	i32.const	$push114=, 1
	i32.add 	$push113=, $2, $pop114
	tee_local	$push112=, $2=, $pop113
	i32.lt_s	$push44=, $pop112, $3
	br_if   	0, $pop44       # 0: up to label13
# BB#31:                                # %for.body19.preheader.i286.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_32:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.load8_u	$push45=, 0($2)
	i32.const	$push115=, 97
	i32.ne  	$push46=, $pop45, $pop115
	br_if   	1, $pop46       # 1: down to label6
# BB#33:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push47=, 1($2)
	i32.const	$push116=, 97
	i32.ne  	$push48=, $pop47, $pop116
	br_if   	1, $pop48       # 1: down to label6
# BB#34:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push49=, 2($2)
	i32.const	$push117=, 97
	i32.ne  	$push50=, $pop49, $pop117
	br_if   	1, $pop50       # 1: down to label6
# BB#35:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push51=, 3($2)
	i32.const	$push118=, 97
	i32.ne  	$push52=, $pop51, $pop118
	br_if   	1, $pop52       # 1: down to label6
# BB#36:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push53=, 4($2)
	i32.const	$push119=, 97
	i32.ne  	$push54=, $pop53, $pop119
	br_if   	1, $pop54       # 1: down to label6
# BB#37:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push55=, 5($2)
	i32.const	$push120=, 97
	i32.ne  	$push56=, $pop55, $pop120
	br_if   	1, $pop56       # 1: down to label6
# BB#38:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push57=, 6($2)
	i32.const	$push121=, 97
	i32.ne  	$push58=, $pop57, $pop121
	br_if   	1, $pop58       # 1: down to label6
# BB#39:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push59=, 7($2)
	i32.const	$push122=, 97
	i32.ne  	$push60=, $pop59, $pop122
	br_if   	1, $pop60       # 1: down to label6
# BB#40:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push126=, 1
	i32.add 	$push125=, $3, $pop126
	tee_local	$push124=, $3=, $pop125
	i32.const	$push123=, 15
	i32.lt_s	$push61=, $pop124, $pop123
	br_if   	0, $pop61       # 0: up to label7
# BB#41:                                # %for.body13.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_42:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push143=, u
	i32.const	$push142=, 97
	i32.const	$push141=, 31
	i32.call	$drop=, memset@FUNCTION, $pop143, $pop142, $pop141
	i32.const	$push140=, u+1
	i32.const	$push139=, 0
	i32.call	$0=, memset@FUNCTION, $pop140, $pop139, $3
	i32.const	$push138=, 1
	i32.const	$push137=, 0
	call    	check@FUNCTION, $pop138, $3, $pop137
	i32.const	$push136=, 0
	i32.load8_u	$push62=, A($pop136)
	i32.call	$drop=, memset@FUNCTION, $0, $pop62, $3
	i32.const	$push135=, 1
	i32.const	$push134=, 65
	call    	check@FUNCTION, $pop135, $3, $pop134
	i32.const	$push133=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop133, $3
	i32.const	$push132=, 1
	i32.const	$push131=, 66
	call    	check@FUNCTION, $pop132, $3, $pop131
	i32.const	$push130=, 1
	i32.add 	$push129=, $3, $pop130
	tee_local	$push128=, $3=, $pop129
	i32.const	$push127=, 15
	i32.ne  	$push63=, $pop128, $pop127
	br_if   	0, $pop63       # 0: up to label14
# BB#43:                                # %for.body33.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_44:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push160=, u
	i32.const	$push159=, 97
	i32.const	$push158=, 31
	i32.call	$drop=, memset@FUNCTION, $pop160, $pop159, $pop158
	i32.const	$push157=, u+2
	i32.const	$push156=, 0
	i32.call	$0=, memset@FUNCTION, $pop157, $pop156, $3
	i32.const	$push155=, 2
	i32.const	$push154=, 0
	call    	check@FUNCTION, $pop155, $3, $pop154
	i32.const	$push153=, 0
	i32.load8_u	$push64=, A($pop153)
	i32.call	$drop=, memset@FUNCTION, $0, $pop64, $3
	i32.const	$push152=, 2
	i32.const	$push151=, 65
	call    	check@FUNCTION, $pop152, $3, $pop151
	i32.const	$push150=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop150, $3
	i32.const	$push149=, 2
	i32.const	$push148=, 66
	call    	check@FUNCTION, $pop149, $3, $pop148
	i32.const	$push147=, 1
	i32.add 	$push146=, $3, $pop147
	tee_local	$push145=, $3=, $pop146
	i32.const	$push144=, 15
	i32.ne  	$push65=, $pop145, $pop144
	br_if   	0, $pop65       # 0: up to label15
# BB#45:                                # %for.body53.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_46:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push177=, u
	i32.const	$push176=, 97
	i32.const	$push175=, 31
	i32.call	$drop=, memset@FUNCTION, $pop177, $pop176, $pop175
	i32.const	$push174=, u+3
	i32.const	$push173=, 0
	i32.call	$0=, memset@FUNCTION, $pop174, $pop173, $3
	i32.const	$push172=, 3
	i32.const	$push171=, 0
	call    	check@FUNCTION, $pop172, $3, $pop171
	i32.const	$push170=, 0
	i32.load8_u	$push66=, A($pop170)
	i32.call	$drop=, memset@FUNCTION, $0, $pop66, $3
	i32.const	$push169=, 3
	i32.const	$push168=, 65
	call    	check@FUNCTION, $pop169, $3, $pop168
	i32.const	$push167=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop167, $3
	i32.const	$push166=, 3
	i32.const	$push165=, 66
	call    	check@FUNCTION, $pop166, $3, $pop165
	i32.const	$push164=, 1
	i32.add 	$push163=, $3, $pop164
	tee_local	$push162=, $3=, $pop163
	i32.const	$push161=, 15
	i32.ne  	$push67=, $pop162, $pop161
	br_if   	0, $pop67       # 0: up to label16
# BB#47:                                # %for.body73.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_48:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push194=, u
	i32.const	$push193=, 97
	i32.const	$push192=, 31
	i32.call	$drop=, memset@FUNCTION, $pop194, $pop193, $pop192
	i32.const	$push191=, u+4
	i32.const	$push190=, 0
	i32.call	$0=, memset@FUNCTION, $pop191, $pop190, $3
	i32.const	$push189=, 4
	i32.const	$push188=, 0
	call    	check@FUNCTION, $pop189, $3, $pop188
	i32.const	$push187=, 0
	i32.load8_u	$push68=, A($pop187)
	i32.call	$drop=, memset@FUNCTION, $0, $pop68, $3
	i32.const	$push186=, 4
	i32.const	$push185=, 65
	call    	check@FUNCTION, $pop186, $3, $pop185
	i32.const	$push184=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop184, $3
	i32.const	$push183=, 4
	i32.const	$push182=, 66
	call    	check@FUNCTION, $pop183, $3, $pop182
	i32.const	$push181=, 1
	i32.add 	$push180=, $3, $pop181
	tee_local	$push179=, $3=, $pop180
	i32.const	$push178=, 15
	i32.ne  	$push69=, $pop179, $pop178
	br_if   	0, $pop69       # 0: up to label17
# BB#49:                                # %for.body93.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_50:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push211=, u
	i32.const	$push210=, 97
	i32.const	$push209=, 31
	i32.call	$drop=, memset@FUNCTION, $pop211, $pop210, $pop209
	i32.const	$push208=, u+5
	i32.const	$push207=, 0
	i32.call	$0=, memset@FUNCTION, $pop208, $pop207, $3
	i32.const	$push206=, 5
	i32.const	$push205=, 0
	call    	check@FUNCTION, $pop206, $3, $pop205
	i32.const	$push204=, 0
	i32.load8_u	$push70=, A($pop204)
	i32.call	$drop=, memset@FUNCTION, $0, $pop70, $3
	i32.const	$push203=, 5
	i32.const	$push202=, 65
	call    	check@FUNCTION, $pop203, $3, $pop202
	i32.const	$push201=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop201, $3
	i32.const	$push200=, 5
	i32.const	$push199=, 66
	call    	check@FUNCTION, $pop200, $3, $pop199
	i32.const	$push198=, 1
	i32.add 	$push197=, $3, $pop198
	tee_local	$push196=, $3=, $pop197
	i32.const	$push195=, 15
	i32.ne  	$push71=, $pop196, $pop195
	br_if   	0, $pop71       # 0: up to label18
# BB#51:                                # %for.body113.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_52:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push228=, u
	i32.const	$push227=, 97
	i32.const	$push226=, 31
	i32.call	$drop=, memset@FUNCTION, $pop228, $pop227, $pop226
	i32.const	$push225=, u+6
	i32.const	$push224=, 0
	i32.call	$0=, memset@FUNCTION, $pop225, $pop224, $3
	i32.const	$push223=, 6
	i32.const	$push222=, 0
	call    	check@FUNCTION, $pop223, $3, $pop222
	i32.const	$push221=, 0
	i32.load8_u	$push72=, A($pop221)
	i32.call	$drop=, memset@FUNCTION, $0, $pop72, $3
	i32.const	$push220=, 6
	i32.const	$push219=, 65
	call    	check@FUNCTION, $pop220, $3, $pop219
	i32.const	$push218=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop218, $3
	i32.const	$push217=, 6
	i32.const	$push216=, 66
	call    	check@FUNCTION, $pop217, $3, $pop216
	i32.const	$push215=, 1
	i32.add 	$push214=, $3, $pop215
	tee_local	$push213=, $3=, $pop214
	i32.const	$push212=, 15
	i32.ne  	$push73=, $pop213, $pop212
	br_if   	0, $pop73       # 0: up to label19
# BB#53:                                # %for.body133.preheader
	end_loop
	i32.const	$3=, 0
.LBB2_54:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push245=, u
	i32.const	$push244=, 97
	i32.const	$push243=, 31
	i32.call	$drop=, memset@FUNCTION, $pop245, $pop244, $pop243
	i32.const	$push242=, u+7
	i32.const	$push241=, 0
	i32.call	$0=, memset@FUNCTION, $pop242, $pop241, $3
	i32.const	$push240=, 7
	i32.const	$push239=, 0
	call    	check@FUNCTION, $pop240, $3, $pop239
	i32.const	$push238=, 0
	i32.load8_u	$push74=, A($pop238)
	i32.call	$drop=, memset@FUNCTION, $0, $pop74, $3
	i32.const	$push237=, 7
	i32.const	$push236=, 65
	call    	check@FUNCTION, $pop237, $3, $pop236
	i32.const	$push235=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop235, $3
	i32.const	$push234=, 7
	i32.const	$push233=, 66
	call    	check@FUNCTION, $pop234, $3, $pop233
	i32.const	$push232=, 1
	i32.add 	$push231=, $3, $pop232
	tee_local	$push230=, $3=, $pop231
	i32.const	$push229=, 15
	i32.ne  	$push75=, $pop230, $pop229
	br_if   	0, $pop75       # 0: up to label20
# BB#55:                                # %for.end149
	end_loop
	i32.const	$push76=, 0
	call    	exit@FUNCTION, $pop76
	unreachable
.LBB2_56:                               # %if.then23.i287
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
