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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, u
	block
	block
	i32.const	$push26=, 1
	i32.lt_s	$push0=, $0, $pop26
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$4=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load8_u	$push1=, u($4)
	i32.const	$push27=, 97
	i32.ne  	$push2=, $pop1, $pop27
	br_if   	3, $pop2        # 3: down to label0
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push30=, 1
	i32.add 	$push29=, $4, $pop30
	tee_local	$push28=, $4=, $pop29
	i32.lt_s	$push3=, $pop28, $0
	br_if   	0, $pop3        # 0: up to label2
# BB#4:                                 # %for.cond3.preheader.loopexit
	end_loop                        # label3:
	i32.const	$push4=, u
	i32.add 	$3=, $4, $pop4
.LBB1_5:                                # %for.cond3.preheader
	end_block                       # label1:
	block
	i32.const	$push31=, 1
	i32.lt_s	$push5=, $1, $pop31
	br_if   	0, $pop5        # 0: down to label4
# BB#6:                                 # %for.body6.preheader
	i32.const	$4=, 0
.LBB1_7:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.add 	$push6=, $3, $4
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop7, $2
	br_if   	3, $pop8        # 3: down to label0
# BB#8:                                 # %for.inc12
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push34=, 1
	i32.add 	$push33=, $4, $pop34
	tee_local	$push32=, $4=, $pop33
	i32.lt_s	$push9=, $pop32, $1
	br_if   	0, $pop9        # 0: up to label5
# BB#9:                                 # %for.body19.preheader.loopexit
	end_loop                        # label6:
	i32.add 	$3=, $3, $4
.LBB1_10:                               # %for.body19.preheader
	end_block                       # label4:
	i32.load8_u	$push10=, 0($3)
	i32.const	$push35=, 97
	i32.ne  	$push11=, $pop10, $pop35
	br_if   	0, $pop11       # 0: down to label0
# BB#11:                                # %for.inc25
	i32.load8_u	$push12=, 1($3)
	i32.const	$push36=, 97
	i32.ne  	$push13=, $pop12, $pop36
	br_if   	0, $pop13       # 0: down to label0
# BB#12:                                # %for.inc25.1
	i32.load8_u	$push14=, 2($3)
	i32.const	$push37=, 97
	i32.ne  	$push15=, $pop14, $pop37
	br_if   	0, $pop15       # 0: down to label0
# BB#13:                                # %for.inc25.2
	i32.load8_u	$push16=, 3($3)
	i32.const	$push38=, 97
	i32.ne  	$push17=, $pop16, $pop38
	br_if   	0, $pop17       # 0: down to label0
# BB#14:                                # %for.inc25.3
	i32.load8_u	$push18=, 4($3)
	i32.const	$push39=, 97
	i32.ne  	$push19=, $pop18, $pop39
	br_if   	0, $pop19       # 0: down to label0
# BB#15:                                # %for.inc25.4
	i32.load8_u	$push20=, 5($3)
	i32.const	$push40=, 97
	i32.ne  	$push21=, $pop20, $pop40
	br_if   	0, $pop21       # 0: down to label0
# BB#16:                                # %for.inc25.5
	i32.load8_u	$push22=, 6($3)
	i32.const	$push41=, 97
	i32.ne  	$push23=, $pop22, $pop41
	br_if   	0, $pop23       # 0: down to label0
# BB#17:                                # %for.inc25.6
	i32.load8_u	$push24=, 7($3)
	i32.const	$push42=, 97
	i32.ne  	$push25=, $pop24, $pop42
	br_if   	0, $pop25       # 0: down to label0
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
	loop                            # label8:
	i32.const	$push80=, u
	i32.const	$push79=, 97
	i32.const	$push78=, 31
	i32.call	$push0=, memset@FUNCTION, $pop80, $pop79, $pop78
	i32.const	$push77=, 0
	i32.call	$0=, memset@FUNCTION, $pop0, $pop77, $3
	i32.const	$1=, u
	block
	i32.const	$push76=, 1
	i32.lt_s	$push75=, $3, $pop76
	tee_local	$push74=, $2=, $pop75
	br_if   	0, $pop74       # 0: down to label10
# BB#2:                                 # %for.body6.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
.LBB2_3:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.load8_u	$push1=, u($1)
	br_if   	5, $pop1        # 5: down to label7
# BB#4:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push83=, 1
	i32.add 	$push82=, $1, $pop83
	tee_local	$push81=, $1=, $pop82
	i32.lt_s	$push2=, $pop81, $3
	br_if   	0, $pop2        # 0: up to label11
# BB#5:                                 # %for.body19.preheader.i.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label12:
	i32.add 	$1=, $1, $0
.LBB2_6:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load8_u	$push3=, 0($1)
	i32.const	$push84=, 97
	i32.ne  	$push4=, $pop3, $pop84
	br_if   	2, $pop4        # 2: down to label7
# BB#7:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push5=, 1($1)
	i32.const	$push85=, 97
	i32.ne  	$push6=, $pop5, $pop85
	br_if   	2, $pop6        # 2: down to label7
# BB#8:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push7=, 2($1)
	i32.const	$push86=, 97
	i32.ne  	$push8=, $pop7, $pop86
	br_if   	2, $pop8        # 2: down to label7
# BB#9:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push9=, 3($1)
	i32.const	$push87=, 97
	i32.ne  	$push10=, $pop9, $pop87
	br_if   	2, $pop10       # 2: down to label7
# BB#10:                                # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push11=, 4($1)
	i32.const	$push88=, 97
	i32.ne  	$push12=, $pop11, $pop88
	br_if   	2, $pop12       # 2: down to label7
# BB#11:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push13=, 5($1)
	i32.const	$push89=, 97
	i32.ne  	$push14=, $pop13, $pop89
	br_if   	2, $pop14       # 2: down to label7
# BB#12:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push15=, 6($1)
	i32.const	$push90=, 97
	i32.ne  	$push16=, $pop15, $pop90
	br_if   	2, $pop16       # 2: down to label7
# BB#13:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push17=, 7($1)
	i32.const	$push91=, 97
	i32.ne  	$push18=, $pop17, $pop91
	br_if   	2, $pop18       # 2: down to label7
# BB#14:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, u
	i32.const	$push93=, u
	i32.const	$push92=, 0
	i32.load8_u	$push19=, A($pop92)
	i32.call	$drop=, memset@FUNCTION, $pop93, $pop19, $3
	block
	br_if   	0, $2           # 0: down to label13
# BB#15:                                # %for.body6.i241.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
.LBB2_16:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label14:
	i32.load8_u	$push20=, u($1)
	i32.const	$push94=, 65
	i32.ne  	$push21=, $pop20, $pop94
	br_if   	5, $pop21       # 5: down to label7
# BB#17:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_16 Depth=2
	i32.const	$push97=, 1
	i32.add 	$push96=, $1, $pop97
	tee_local	$push95=, $1=, $pop96
	i32.lt_s	$push22=, $pop95, $3
	br_if   	0, $pop22       # 0: up to label14
# BB#18:                                # %for.body19.preheader.i249.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label15:
	i32.add 	$1=, $1, $0
.LBB2_19:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label13:
	i32.load8_u	$push23=, 0($1)
	i32.const	$push98=, 97
	i32.ne  	$push24=, $pop23, $pop98
	br_if   	2, $pop24       # 2: down to label7
# BB#20:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push25=, 1($1)
	i32.const	$push99=, 97
	i32.ne  	$push26=, $pop25, $pop99
	br_if   	2, $pop26       # 2: down to label7
# BB#21:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push27=, 2($1)
	i32.const	$push100=, 97
	i32.ne  	$push28=, $pop27, $pop100
	br_if   	2, $pop28       # 2: down to label7
# BB#22:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push29=, 3($1)
	i32.const	$push101=, 97
	i32.ne  	$push30=, $pop29, $pop101
	br_if   	2, $pop30       # 2: down to label7
# BB#23:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push31=, 4($1)
	i32.const	$push102=, 97
	i32.ne  	$push32=, $pop31, $pop102
	br_if   	2, $pop32       # 2: down to label7
# BB#24:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push33=, 5($1)
	i32.const	$push103=, 97
	i32.ne  	$push34=, $pop33, $pop103
	br_if   	2, $pop34       # 2: down to label7
# BB#25:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push35=, 6($1)
	i32.const	$push104=, 97
	i32.ne  	$push36=, $pop35, $pop104
	br_if   	2, $pop36       # 2: down to label7
# BB#26:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push37=, 7($1)
	i32.const	$push105=, 97
	i32.ne  	$push38=, $pop37, $pop105
	br_if   	2, $pop38       # 2: down to label7
# BB#27:                                # %check.exit272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, u
	i32.const	$push107=, u
	i32.const	$push106=, 66
	i32.call	$drop=, memset@FUNCTION, $pop107, $pop106, $3
	block
	br_if   	0, $2           # 0: down to label16
# BB#28:                                # %for.body6.i278.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
.LBB2_29:                               # %for.body6.i278
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label17:
	i32.load8_u	$push39=, u($1)
	i32.const	$push108=, 66
	i32.ne  	$push40=, $pop39, $pop108
	br_if   	5, $pop40       # 5: down to label7
# BB#30:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_29 Depth=2
	i32.const	$push111=, 1
	i32.add 	$push110=, $1, $pop111
	tee_local	$push109=, $1=, $pop110
	i32.lt_s	$push41=, $pop109, $3
	br_if   	0, $pop41       # 0: up to label17
# BB#31:                                # %for.body19.preheader.i286.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label18:
	i32.add 	$1=, $1, $0
.LBB2_32:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i32.load8_u	$push42=, 0($1)
	i32.const	$push112=, 97
	i32.ne  	$push43=, $pop42, $pop112
	br_if   	2, $pop43       # 2: down to label7
# BB#33:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push44=, 1($1)
	i32.const	$push113=, 97
	i32.ne  	$push45=, $pop44, $pop113
	br_if   	2, $pop45       # 2: down to label7
# BB#34:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push46=, 2($1)
	i32.const	$push114=, 97
	i32.ne  	$push47=, $pop46, $pop114
	br_if   	2, $pop47       # 2: down to label7
# BB#35:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push48=, 3($1)
	i32.const	$push115=, 97
	i32.ne  	$push49=, $pop48, $pop115
	br_if   	2, $pop49       # 2: down to label7
# BB#36:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push50=, 4($1)
	i32.const	$push116=, 97
	i32.ne  	$push51=, $pop50, $pop116
	br_if   	2, $pop51       # 2: down to label7
# BB#37:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push52=, 5($1)
	i32.const	$push117=, 97
	i32.ne  	$push53=, $pop52, $pop117
	br_if   	2, $pop53       # 2: down to label7
# BB#38:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push54=, 6($1)
	i32.const	$push118=, 97
	i32.ne  	$push55=, $pop54, $pop118
	br_if   	2, $pop55       # 2: down to label7
# BB#39:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push56=, 7($1)
	i32.const	$push119=, 97
	i32.ne  	$push57=, $pop56, $pop119
	br_if   	2, $pop57       # 2: down to label7
# BB#40:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push123=, 1
	i32.add 	$push122=, $3, $pop123
	tee_local	$push121=, $3=, $pop122
	i32.const	$push120=, 15
	i32.lt_s	$push58=, $pop121, $pop120
	br_if   	0, $pop58       # 0: up to label8
# BB#41:                                # %for.body13.preheader
	end_loop                        # label9:
	i32.const	$3=, 0
.LBB2_42:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push140=, u
	i32.const	$push139=, 97
	i32.const	$push138=, 31
	i32.call	$drop=, memset@FUNCTION, $pop140, $pop139, $pop138
	i32.const	$push137=, u+1
	i32.const	$push136=, 0
	i32.call	$1=, memset@FUNCTION, $pop137, $pop136, $3
	i32.const	$push135=, 1
	i32.const	$push134=, 0
	call    	check@FUNCTION, $pop135, $3, $pop134
	i32.const	$push133=, 0
	i32.load8_u	$push59=, A($pop133)
	i32.call	$drop=, memset@FUNCTION, $1, $pop59, $3
	i32.const	$push132=, 1
	i32.const	$push131=, 65
	call    	check@FUNCTION, $pop132, $3, $pop131
	i32.const	$push130=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop130, $3
	i32.const	$push129=, 1
	i32.const	$push128=, 66
	call    	check@FUNCTION, $pop129, $3, $pop128
	i32.const	$push127=, 1
	i32.add 	$push126=, $3, $pop127
	tee_local	$push125=, $3=, $pop126
	i32.const	$push124=, 15
	i32.ne  	$push60=, $pop125, $pop124
	br_if   	0, $pop60       # 0: up to label19
# BB#43:                                # %for.body33.preheader
	end_loop                        # label20:
	i32.const	$3=, 0
.LBB2_44:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label21:
	i32.const	$push157=, u
	i32.const	$push156=, 97
	i32.const	$push155=, 31
	i32.call	$drop=, memset@FUNCTION, $pop157, $pop156, $pop155
	i32.const	$push154=, u+2
	i32.const	$push153=, 0
	i32.call	$1=, memset@FUNCTION, $pop154, $pop153, $3
	i32.const	$push152=, 2
	i32.const	$push151=, 0
	call    	check@FUNCTION, $pop152, $3, $pop151
	i32.const	$push150=, 0
	i32.load8_u	$push61=, A($pop150)
	i32.call	$drop=, memset@FUNCTION, $1, $pop61, $3
	i32.const	$push149=, 2
	i32.const	$push148=, 65
	call    	check@FUNCTION, $pop149, $3, $pop148
	i32.const	$push147=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop147, $3
	i32.const	$push146=, 2
	i32.const	$push145=, 66
	call    	check@FUNCTION, $pop146, $3, $pop145
	i32.const	$push144=, 1
	i32.add 	$push143=, $3, $pop144
	tee_local	$push142=, $3=, $pop143
	i32.const	$push141=, 15
	i32.ne  	$push62=, $pop142, $pop141
	br_if   	0, $pop62       # 0: up to label21
# BB#45:                                # %for.body53.preheader
	end_loop                        # label22:
	i32.const	$3=, 0
.LBB2_46:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label23:
	i32.const	$push174=, u
	i32.const	$push173=, 97
	i32.const	$push172=, 31
	i32.call	$drop=, memset@FUNCTION, $pop174, $pop173, $pop172
	i32.const	$push171=, u+3
	i32.const	$push170=, 0
	i32.call	$1=, memset@FUNCTION, $pop171, $pop170, $3
	i32.const	$push169=, 3
	i32.const	$push168=, 0
	call    	check@FUNCTION, $pop169, $3, $pop168
	i32.const	$push167=, 0
	i32.load8_u	$push63=, A($pop167)
	i32.call	$drop=, memset@FUNCTION, $1, $pop63, $3
	i32.const	$push166=, 3
	i32.const	$push165=, 65
	call    	check@FUNCTION, $pop166, $3, $pop165
	i32.const	$push164=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop164, $3
	i32.const	$push163=, 3
	i32.const	$push162=, 66
	call    	check@FUNCTION, $pop163, $3, $pop162
	i32.const	$push161=, 1
	i32.add 	$push160=, $3, $pop161
	tee_local	$push159=, $3=, $pop160
	i32.const	$push158=, 15
	i32.ne  	$push64=, $pop159, $pop158
	br_if   	0, $pop64       # 0: up to label23
# BB#47:                                # %for.body73.preheader
	end_loop                        # label24:
	i32.const	$3=, 0
.LBB2_48:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$push191=, u
	i32.const	$push190=, 97
	i32.const	$push189=, 31
	i32.call	$drop=, memset@FUNCTION, $pop191, $pop190, $pop189
	i32.const	$push188=, u+4
	i32.const	$push187=, 0
	i32.call	$1=, memset@FUNCTION, $pop188, $pop187, $3
	i32.const	$push186=, 4
	i32.const	$push185=, 0
	call    	check@FUNCTION, $pop186, $3, $pop185
	i32.const	$push184=, 0
	i32.load8_u	$push65=, A($pop184)
	i32.call	$drop=, memset@FUNCTION, $1, $pop65, $3
	i32.const	$push183=, 4
	i32.const	$push182=, 65
	call    	check@FUNCTION, $pop183, $3, $pop182
	i32.const	$push181=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop181, $3
	i32.const	$push180=, 4
	i32.const	$push179=, 66
	call    	check@FUNCTION, $pop180, $3, $pop179
	i32.const	$push178=, 1
	i32.add 	$push177=, $3, $pop178
	tee_local	$push176=, $3=, $pop177
	i32.const	$push175=, 15
	i32.ne  	$push66=, $pop176, $pop175
	br_if   	0, $pop66       # 0: up to label25
# BB#49:                                # %for.body93.preheader
	end_loop                        # label26:
	i32.const	$3=, 0
.LBB2_50:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	i32.const	$push208=, u
	i32.const	$push207=, 97
	i32.const	$push206=, 31
	i32.call	$drop=, memset@FUNCTION, $pop208, $pop207, $pop206
	i32.const	$push205=, u+5
	i32.const	$push204=, 0
	i32.call	$1=, memset@FUNCTION, $pop205, $pop204, $3
	i32.const	$push203=, 5
	i32.const	$push202=, 0
	call    	check@FUNCTION, $pop203, $3, $pop202
	i32.const	$push201=, 0
	i32.load8_u	$push67=, A($pop201)
	i32.call	$drop=, memset@FUNCTION, $1, $pop67, $3
	i32.const	$push200=, 5
	i32.const	$push199=, 65
	call    	check@FUNCTION, $pop200, $3, $pop199
	i32.const	$push198=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop198, $3
	i32.const	$push197=, 5
	i32.const	$push196=, 66
	call    	check@FUNCTION, $pop197, $3, $pop196
	i32.const	$push195=, 1
	i32.add 	$push194=, $3, $pop195
	tee_local	$push193=, $3=, $pop194
	i32.const	$push192=, 15
	i32.ne  	$push68=, $pop193, $pop192
	br_if   	0, $pop68       # 0: up to label27
# BB#51:                                # %for.body113.preheader
	end_loop                        # label28:
	i32.const	$3=, 0
.LBB2_52:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label29:
	i32.const	$push225=, u
	i32.const	$push224=, 97
	i32.const	$push223=, 31
	i32.call	$drop=, memset@FUNCTION, $pop225, $pop224, $pop223
	i32.const	$push222=, u+6
	i32.const	$push221=, 0
	i32.call	$1=, memset@FUNCTION, $pop222, $pop221, $3
	i32.const	$push220=, 6
	i32.const	$push219=, 0
	call    	check@FUNCTION, $pop220, $3, $pop219
	i32.const	$push218=, 0
	i32.load8_u	$push69=, A($pop218)
	i32.call	$drop=, memset@FUNCTION, $1, $pop69, $3
	i32.const	$push217=, 6
	i32.const	$push216=, 65
	call    	check@FUNCTION, $pop217, $3, $pop216
	i32.const	$push215=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop215, $3
	i32.const	$push214=, 6
	i32.const	$push213=, 66
	call    	check@FUNCTION, $pop214, $3, $pop213
	i32.const	$push212=, 1
	i32.add 	$push211=, $3, $pop212
	tee_local	$push210=, $3=, $pop211
	i32.const	$push209=, 15
	i32.ne  	$push70=, $pop210, $pop209
	br_if   	0, $pop70       # 0: up to label29
# BB#53:                                # %for.body133.preheader
	end_loop                        # label30:
	i32.const	$3=, 0
.LBB2_54:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push242=, u
	i32.const	$push241=, 97
	i32.const	$push240=, 31
	i32.call	$drop=, memset@FUNCTION, $pop242, $pop241, $pop240
	i32.const	$push239=, u+7
	i32.const	$push238=, 0
	i32.call	$1=, memset@FUNCTION, $pop239, $pop238, $3
	i32.const	$push237=, 7
	i32.const	$push236=, 0
	call    	check@FUNCTION, $pop237, $3, $pop236
	i32.const	$push235=, 0
	i32.load8_u	$push71=, A($pop235)
	i32.call	$drop=, memset@FUNCTION, $1, $pop71, $3
	i32.const	$push234=, 7
	i32.const	$push233=, 65
	call    	check@FUNCTION, $pop234, $3, $pop233
	i32.const	$push232=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop232, $3
	i32.const	$push231=, 7
	i32.const	$push230=, 66
	call    	check@FUNCTION, $pop231, $3, $pop230
	i32.const	$push229=, 1
	i32.add 	$push228=, $3, $pop229
	tee_local	$push227=, $3=, $pop228
	i32.const	$push226=, 15
	i32.ne  	$push72=, $pop227, $pop226
	br_if   	0, $pop72       # 0: up to label31
# BB#55:                                # %for.end149
	end_loop                        # label32:
	i32.const	$push73=, 0
	call    	exit@FUNCTION, $pop73
	unreachable
.LBB2_56:                               # %if.then23.i287
	end_block                       # label7:
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
	.lcomm	u,32,4

	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
