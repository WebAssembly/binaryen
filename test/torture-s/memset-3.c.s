	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-3.c"
	.section	.text.reset,"ax",@progbits
	.hidden	reset
	.globl	reset
	.type	reset,@function
reset:                                  # @reset
# BB#0:                                 # %entry
	i32.const	$push0=, u
	i32.const	$push2=, 97
	i32.const	$push1=, 31
	i32.call	$discard=, memset@FUNCTION, $pop0, $pop2, $pop1
	return
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
	i32.const	$3=, 0
	i32.const	$4=, u
	block
	block
	i32.const	$push25=, 0
	i32.le_s	$push0=, $0, $pop25
	br_if   	0, $pop0        # 0: down to label1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push29=, $3
	tee_local	$push28=, $4=, $pop29
	i32.load8_u	$push1=, u($pop28)
	i32.const	$push27=, 97
	i32.ne  	$push2=, $pop1, $pop27
	br_if   	3, $pop2        # 3: down to label0
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push30=, 1
	i32.add 	$3=, $4, $pop30
	i32.lt_s	$push3=, $3, $0
	br_if   	0, $pop3        # 0: up to label2
# BB#3:
	end_loop                        # label3:
	i32.const	$push31=, u+1
	i32.add 	$4=, $4, $pop31
.LBB1_4:                                # %for.cond3.preheader
	end_block                       # label1:
	i32.const	$3=, 0
	block
	i32.const	$push26=, 0
	i32.le_s	$push4=, $1, $pop26
	br_if   	0, $pop4        # 0: down to label4
.LBB1_5:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.add 	$push5=, $4, $3
	i32.load8_s	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop6, $2
	br_if   	3, $pop7        # 3: down to label0
# BB#6:                                 # %for.inc12
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push32=, 1
	i32.add 	$3=, $3, $pop32
	i32.lt_s	$push8=, $3, $1
	br_if   	0, $pop8        # 0: up to label5
# BB#7:
	end_loop                        # label6:
	i32.add 	$4=, $4, $3
.LBB1_8:                                # %for.body19.preheader
	end_block                       # label4:
	i32.load8_u	$push9=, 0($4)
	i32.const	$push33=, 97
	i32.ne  	$push10=, $pop9, $pop33
	br_if   	0, $pop10       # 0: down to label0
# BB#9:                                 # %for.inc25
	i32.load8_u	$push11=, 1($4)
	i32.const	$push34=, 97
	i32.ne  	$push12=, $pop11, $pop34
	br_if   	0, $pop12       # 0: down to label0
# BB#10:                                # %for.inc25.1
	i32.load8_u	$push13=, 2($4)
	i32.const	$push35=, 97
	i32.ne  	$push14=, $pop13, $pop35
	br_if   	0, $pop14       # 0: down to label0
# BB#11:                                # %for.inc25.2
	i32.load8_u	$push15=, 3($4)
	i32.const	$push36=, 97
	i32.ne  	$push16=, $pop15, $pop36
	br_if   	0, $pop16       # 0: down to label0
# BB#12:                                # %for.inc25.3
	i32.load8_u	$push17=, 4($4)
	i32.const	$push37=, 97
	i32.ne  	$push18=, $pop17, $pop37
	br_if   	0, $pop18       # 0: down to label0
# BB#13:                                # %for.inc25.4
	i32.load8_u	$push19=, 5($4)
	i32.const	$push38=, 97
	i32.ne  	$push20=, $pop19, $pop38
	br_if   	0, $pop20       # 0: down to label0
# BB#14:                                # %for.inc25.5
	i32.load8_u	$push21=, 6($4)
	i32.const	$push39=, 97
	i32.ne  	$push22=, $pop21, $pop39
	br_if   	0, $pop22       # 0: down to label0
# BB#15:                                # %for.inc25.6
	i32.load8_u	$push23=, 7($4)
	i32.const	$push40=, 97
	i32.ne  	$push24=, $pop23, $pop40
	br_if   	0, $pop24       # 0: down to label0
# BB#16:                                # %for.inc25.7
	return
.LBB1_17:                               # %if.then23
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
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_14 Depth 2
                                        #     Child Loop BB2_26 Depth 2
	block
	loop                            # label8:
	i32.const	$push0=, u
	i32.const	$push84=, 97
	i32.const	$push83=, 31
	i32.call	$push1=, memset@FUNCTION, $pop0, $pop84, $pop83
	i32.const	$push82=, 0
	i32.call	$3=, memset@FUNCTION, $pop1, $pop82, $1
	i32.const	$0=, 0
	block
	i32.const	$push81=, 1
	i32.lt_s	$push80=, $1, $pop81
	tee_local	$push79=, $2=, $pop80
	br_if   	0, $pop79       # 0: down to label10
.LBB2_2:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	copy_local	$push86=, $0
	tee_local	$push85=, $3=, $pop86
	i32.load8_u	$push2=, u($pop85)
	br_if   	5, $pop2        # 5: down to label7
# BB#3:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push87=, 1
	i32.add 	$0=, $3, $pop87
	i32.lt_s	$push3=, $0, $1
	br_if   	0, $pop3        # 0: up to label11
# BB#4:                                 #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label12:
	i32.const	$push88=, u+1
	i32.add 	$3=, $3, $pop88
.LBB2_5:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load8_u	$push4=, 0($3)
	i32.const	$push89=, 97
	i32.ne  	$push5=, $pop4, $pop89
	br_if   	2, $pop5        # 2: down to label7
# BB#6:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push6=, 1($3)
	i32.const	$push90=, 97
	i32.ne  	$push7=, $pop6, $pop90
	br_if   	2, $pop7        # 2: down to label7
# BB#7:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push8=, 2($3)
	i32.const	$push91=, 97
	i32.ne  	$push9=, $pop8, $pop91
	br_if   	2, $pop9        # 2: down to label7
# BB#8:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push10=, 3($3)
	i32.const	$push92=, 97
	i32.ne  	$push11=, $pop10, $pop92
	br_if   	2, $pop11       # 2: down to label7
# BB#9:                                 # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push12=, 4($3)
	i32.const	$push93=, 97
	i32.ne  	$push13=, $pop12, $pop93
	br_if   	2, $pop13       # 2: down to label7
# BB#10:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push14=, 5($3)
	i32.const	$push94=, 97
	i32.ne  	$push15=, $pop14, $pop94
	br_if   	2, $pop15       # 2: down to label7
# BB#11:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push16=, 6($3)
	i32.const	$push95=, 97
	i32.ne  	$push17=, $pop16, $pop95
	br_if   	2, $pop17       # 2: down to label7
# BB#12:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push18=, 7($3)
	i32.const	$push96=, 97
	i32.ne  	$push19=, $pop18, $pop96
	br_if   	2, $pop19       # 2: down to label7
# BB#13:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$0=, 0
	i32.const	$push20=, u
	i32.const	$push97=, 0
	i32.load8_u	$push21=, A($pop97)
	i32.call	$3=, memset@FUNCTION, $pop20, $pop21, $1
	block
	br_if   	0, $2           # 0: down to label13
.LBB2_14:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label14:
	copy_local	$push100=, $0
	tee_local	$push99=, $3=, $pop100
	i32.load8_u	$push22=, u($pop99)
	i32.const	$push98=, 65
	i32.ne  	$push23=, $pop22, $pop98
	br_if   	5, $pop23       # 5: down to label7
# BB#15:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_14 Depth=2
	i32.const	$push101=, 1
	i32.add 	$0=, $3, $pop101
	i32.lt_s	$push24=, $0, $1
	br_if   	0, $pop24       # 0: up to label14
# BB#16:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label15:
	i32.const	$push102=, u+1
	i32.add 	$3=, $3, $pop102
.LBB2_17:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label13:
	i32.load8_u	$push25=, 0($3)
	i32.const	$push103=, 97
	i32.ne  	$push26=, $pop25, $pop103
	br_if   	2, $pop26       # 2: down to label7
# BB#18:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push27=, 1($3)
	i32.const	$push104=, 97
	i32.ne  	$push28=, $pop27, $pop104
	br_if   	2, $pop28       # 2: down to label7
# BB#19:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push29=, 2($3)
	i32.const	$push105=, 97
	i32.ne  	$push30=, $pop29, $pop105
	br_if   	2, $pop30       # 2: down to label7
# BB#20:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push31=, 3($3)
	i32.const	$push106=, 97
	i32.ne  	$push32=, $pop31, $pop106
	br_if   	2, $pop32       # 2: down to label7
# BB#21:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push33=, 4($3)
	i32.const	$push107=, 97
	i32.ne  	$push34=, $pop33, $pop107
	br_if   	2, $pop34       # 2: down to label7
# BB#22:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push35=, 5($3)
	i32.const	$push108=, 97
	i32.ne  	$push36=, $pop35, $pop108
	br_if   	2, $pop36       # 2: down to label7
# BB#23:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push37=, 6($3)
	i32.const	$push109=, 97
	i32.ne  	$push38=, $pop37, $pop109
	br_if   	2, $pop38       # 2: down to label7
# BB#24:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push39=, 7($3)
	i32.const	$push110=, 97
	i32.ne  	$push40=, $pop39, $pop110
	br_if   	2, $pop40       # 2: down to label7
# BB#25:                                # %check.exit272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push41=, u
	i32.const	$push111=, 66
	i32.call	$3=, memset@FUNCTION, $pop41, $pop111, $1
	i32.const	$0=, 0
	block
	br_if   	0, $2           # 0: down to label16
.LBB2_26:                               # %for.body6.i278
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label17:
	copy_local	$push114=, $0
	tee_local	$push113=, $3=, $pop114
	i32.load8_u	$push42=, u($pop113)
	i32.const	$push112=, 66
	i32.ne  	$push43=, $pop42, $pop112
	br_if   	5, $pop43       # 5: down to label7
# BB#27:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_26 Depth=2
	i32.const	$push115=, 1
	i32.add 	$0=, $3, $pop115
	i32.lt_s	$push44=, $0, $1
	br_if   	0, $pop44       # 0: up to label17
# BB#28:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label18:
	i32.const	$push116=, u+1
	i32.add 	$3=, $3, $pop116
.LBB2_29:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i32.load8_u	$push45=, 0($3)
	i32.const	$push117=, 97
	i32.ne  	$push46=, $pop45, $pop117
	br_if   	2, $pop46       # 2: down to label7
# BB#30:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push47=, 1($3)
	i32.const	$push118=, 97
	i32.ne  	$push48=, $pop47, $pop118
	br_if   	2, $pop48       # 2: down to label7
# BB#31:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push49=, 2($3)
	i32.const	$push119=, 97
	i32.ne  	$push50=, $pop49, $pop119
	br_if   	2, $pop50       # 2: down to label7
# BB#32:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push51=, 3($3)
	i32.const	$push120=, 97
	i32.ne  	$push52=, $pop51, $pop120
	br_if   	2, $pop52       # 2: down to label7
# BB#33:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push53=, 4($3)
	i32.const	$push121=, 97
	i32.ne  	$push54=, $pop53, $pop121
	br_if   	2, $pop54       # 2: down to label7
# BB#34:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push55=, 5($3)
	i32.const	$push122=, 97
	i32.ne  	$push56=, $pop55, $pop122
	br_if   	2, $pop56       # 2: down to label7
# BB#35:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push57=, 6($3)
	i32.const	$push123=, 97
	i32.ne  	$push58=, $pop57, $pop123
	br_if   	2, $pop58       # 2: down to label7
# BB#36:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push59=, 7($3)
	i32.const	$push124=, 97
	i32.ne  	$push60=, $pop59, $pop124
	br_if   	2, $pop60       # 2: down to label7
# BB#37:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push78=, 1
	i32.add 	$1=, $1, $pop78
	i32.const	$push77=, 14
	i32.le_s	$push61=, $1, $pop77
	br_if   	0, $pop61       # 0: up to label8
# BB#38:
	end_loop                        # label9:
	i32.const	$0=, 0
.LBB2_39:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push139=, u
	i32.const	$push138=, 97
	i32.const	$push137=, 31
	i32.call	$discard=, memset@FUNCTION, $pop139, $pop138, $pop137
	i32.const	$1=, 0
	i32.const	$push136=, u+1
	i32.const	$push135=, 0
	i32.call	$3=, memset@FUNCTION, $pop136, $pop135, $0
	i32.const	$push134=, 1
	i32.const	$push133=, 0
	call    	check@FUNCTION, $pop134, $0, $pop133
	i32.const	$push132=, 0
	i32.load8_u	$push62=, A($pop132)
	i32.call	$discard=, memset@FUNCTION, $3, $pop62, $0
	i32.const	$push131=, 1
	i32.const	$push130=, 65
	call    	check@FUNCTION, $pop131, $0, $pop130
	i32.const	$push129=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop129, $0
	i32.const	$push128=, 1
	i32.const	$push127=, 66
	call    	check@FUNCTION, $pop128, $0, $pop127
	i32.const	$push126=, 1
	i32.add 	$0=, $0, $pop126
	i32.const	$push125=, 15
	i32.ne  	$push63=, $0, $pop125
	br_if   	0, $pop63       # 0: up to label19
.LBB2_40:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label20:
	loop                            # label21:
	i32.const	$push154=, u
	i32.const	$push153=, 97
	i32.const	$push152=, 31
	i32.call	$discard=, memset@FUNCTION, $pop154, $pop153, $pop152
	i32.const	$0=, 0
	i32.const	$push151=, u+2
	i32.const	$push150=, 0
	i32.call	$3=, memset@FUNCTION, $pop151, $pop150, $1
	i32.const	$push149=, 2
	i32.const	$push148=, 0
	call    	check@FUNCTION, $pop149, $1, $pop148
	i32.const	$push147=, 0
	i32.load8_u	$push64=, A($pop147)
	i32.call	$discard=, memset@FUNCTION, $3, $pop64, $1
	i32.const	$push146=, 2
	i32.const	$push145=, 65
	call    	check@FUNCTION, $pop146, $1, $pop145
	i32.const	$push144=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop144, $1
	i32.const	$push143=, 2
	i32.const	$push142=, 66
	call    	check@FUNCTION, $pop143, $1, $pop142
	i32.const	$push141=, 1
	i32.add 	$1=, $1, $pop141
	i32.const	$push140=, 15
	i32.ne  	$push65=, $1, $pop140
	br_if   	0, $pop65       # 0: up to label21
.LBB2_41:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label22:
	loop                            # label23:
	i32.const	$push169=, u
	i32.const	$push168=, 97
	i32.const	$push167=, 31
	i32.call	$discard=, memset@FUNCTION, $pop169, $pop168, $pop167
	i32.const	$1=, 0
	i32.const	$push166=, u+3
	i32.const	$push165=, 0
	i32.call	$3=, memset@FUNCTION, $pop166, $pop165, $0
	i32.const	$push164=, 3
	i32.const	$push163=, 0
	call    	check@FUNCTION, $pop164, $0, $pop163
	i32.const	$push162=, 0
	i32.load8_u	$push66=, A($pop162)
	i32.call	$discard=, memset@FUNCTION, $3, $pop66, $0
	i32.const	$push161=, 3
	i32.const	$push160=, 65
	call    	check@FUNCTION, $pop161, $0, $pop160
	i32.const	$push159=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop159, $0
	i32.const	$push158=, 3
	i32.const	$push157=, 66
	call    	check@FUNCTION, $pop158, $0, $pop157
	i32.const	$push156=, 1
	i32.add 	$0=, $0, $pop156
	i32.const	$push155=, 15
	i32.ne  	$push67=, $0, $pop155
	br_if   	0, $pop67       # 0: up to label23
.LBB2_42:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label24:
	loop                            # label25:
	i32.const	$push184=, u
	i32.const	$push183=, 97
	i32.const	$push182=, 31
	i32.call	$discard=, memset@FUNCTION, $pop184, $pop183, $pop182
	i32.const	$0=, 0
	i32.const	$push181=, u+4
	i32.const	$push180=, 0
	i32.call	$3=, memset@FUNCTION, $pop181, $pop180, $1
	i32.const	$push179=, 4
	i32.const	$push178=, 0
	call    	check@FUNCTION, $pop179, $1, $pop178
	i32.const	$push177=, 0
	i32.load8_u	$push68=, A($pop177)
	i32.call	$discard=, memset@FUNCTION, $3, $pop68, $1
	i32.const	$push176=, 4
	i32.const	$push175=, 65
	call    	check@FUNCTION, $pop176, $1, $pop175
	i32.const	$push174=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop174, $1
	i32.const	$push173=, 4
	i32.const	$push172=, 66
	call    	check@FUNCTION, $pop173, $1, $pop172
	i32.const	$push171=, 1
	i32.add 	$1=, $1, $pop171
	i32.const	$push170=, 15
	i32.ne  	$push69=, $1, $pop170
	br_if   	0, $pop69       # 0: up to label25
.LBB2_43:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label26:
	loop                            # label27:
	i32.const	$push199=, u
	i32.const	$push198=, 97
	i32.const	$push197=, 31
	i32.call	$discard=, memset@FUNCTION, $pop199, $pop198, $pop197
	i32.const	$3=, 0
	i32.const	$push196=, u+5
	i32.const	$push195=, 0
	i32.call	$1=, memset@FUNCTION, $pop196, $pop195, $0
	i32.const	$push194=, 5
	i32.const	$push193=, 0
	call    	check@FUNCTION, $pop194, $0, $pop193
	i32.const	$push192=, 0
	i32.load8_u	$push70=, A($pop192)
	i32.call	$discard=, memset@FUNCTION, $1, $pop70, $0
	i32.const	$push191=, 5
	i32.const	$push190=, 65
	call    	check@FUNCTION, $pop191, $0, $pop190
	i32.const	$push189=, 66
	i32.call	$discard=, memset@FUNCTION, $1, $pop189, $0
	i32.const	$push188=, 5
	i32.const	$push187=, 66
	call    	check@FUNCTION, $pop188, $0, $pop187
	i32.const	$push186=, 1
	i32.add 	$0=, $0, $pop186
	i32.const	$push185=, 15
	i32.ne  	$push71=, $0, $pop185
	br_if   	0, $pop71       # 0: up to label27
.LBB2_44:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label28:
	loop                            # label29:
	i32.const	$push214=, u
	i32.const	$push213=, 97
	i32.const	$push212=, 31
	i32.call	$discard=, memset@FUNCTION, $pop214, $pop213, $pop212
	i32.const	$1=, 0
	i32.const	$push211=, u+6
	i32.const	$push210=, 0
	i32.call	$0=, memset@FUNCTION, $pop211, $pop210, $3
	i32.const	$push209=, 6
	i32.const	$push208=, 0
	call    	check@FUNCTION, $pop209, $3, $pop208
	i32.const	$push207=, 0
	i32.load8_u	$push72=, A($pop207)
	i32.call	$discard=, memset@FUNCTION, $0, $pop72, $3
	i32.const	$push206=, 6
	i32.const	$push205=, 65
	call    	check@FUNCTION, $pop206, $3, $pop205
	i32.const	$push204=, 66
	i32.call	$discard=, memset@FUNCTION, $0, $pop204, $3
	i32.const	$push203=, 6
	i32.const	$push202=, 66
	call    	check@FUNCTION, $pop203, $3, $pop202
	i32.const	$push201=, 1
	i32.add 	$3=, $3, $pop201
	i32.const	$push200=, 15
	i32.ne  	$push73=, $3, $pop200
	br_if   	0, $pop73       # 0: up to label29
.LBB2_45:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label30:
	loop                            # label31:
	i32.const	$push229=, u
	i32.const	$push228=, 97
	i32.const	$push227=, 31
	i32.call	$discard=, memset@FUNCTION, $pop229, $pop228, $pop227
	i32.const	$push226=, u+7
	i32.const	$push225=, 0
	i32.call	$0=, memset@FUNCTION, $pop226, $pop225, $1
	i32.const	$push224=, 7
	i32.const	$push223=, 0
	call    	check@FUNCTION, $pop224, $1, $pop223
	i32.const	$push222=, 0
	i32.load8_u	$push74=, A($pop222)
	i32.call	$discard=, memset@FUNCTION, $0, $pop74, $1
	i32.const	$push221=, 7
	i32.const	$push220=, 65
	call    	check@FUNCTION, $pop221, $1, $pop220
	i32.const	$push219=, 66
	i32.call	$discard=, memset@FUNCTION, $0, $pop219, $1
	i32.const	$push218=, 7
	i32.const	$push217=, 66
	call    	check@FUNCTION, $pop218, $1, $pop217
	i32.const	$push216=, 1
	i32.add 	$1=, $1, $pop216
	i32.const	$push215=, 15
	i32.ne  	$push75=, $1, $pop215
	br_if   	0, $pop75       # 0: up to label31
# BB#46:                                # %for.end149
	end_loop                        # label32:
	i32.const	$push76=, 0
	call    	exit@FUNCTION, $pop76
	unreachable
.LBB2_47:                               # %if.then23.i287
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
