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
	i32.call	$drop=, memset@FUNCTION, $pop0, $pop2, $pop1
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
	i32.const	$4=, u
	block
	block
	i32.const	$push25=, 1
	i32.lt_s	$push0=, $0, $pop25
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push28=, $3
	tee_local	$push27=, $4=, $pop28
	i32.load8_u	$push1=, u($pop27)
	i32.const	$push26=, 97
	i32.ne  	$push2=, $pop1, $pop26
	br_if   	3, $pop2        # 3: down to label0
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push31=, 1
	i32.add 	$push30=, $4, $pop31
	tee_local	$push29=, $3=, $pop30
	i32.lt_s	$push3=, $pop29, $0
	br_if   	0, $pop3        # 0: up to label2
# BB#4:
	end_loop                        # label3:
	i32.const	$push32=, u+1
	i32.add 	$4=, $4, $pop32
.LBB1_5:                                # %for.cond3.preheader
	end_block                       # label1:
	block
	i32.const	$push33=, 1
	i32.lt_s	$push4=, $1, $pop33
	br_if   	0, $pop4        # 0: down to label4
# BB#6:                                 # %for.body6.preheader
	i32.const	$3=, 0
.LBB1_7:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.add 	$push5=, $4, $3
	i32.load8_s	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop6, $2
	br_if   	3, $pop7        # 3: down to label0
# BB#8:                                 # %for.inc12
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push34=, 1
	i32.add 	$3=, $3, $pop34
	i32.lt_s	$push8=, $3, $1
	br_if   	0, $pop8        # 0: up to label5
# BB#9:
	end_loop                        # label6:
	i32.add 	$4=, $4, $3
.LBB1_10:                               # %for.body19.preheader
	end_block                       # label4:
	i32.load8_u	$push9=, 0($4)
	i32.const	$push35=, 97
	i32.ne  	$push10=, $pop9, $pop35
	br_if   	0, $pop10       # 0: down to label0
# BB#11:                                # %for.inc25
	i32.load8_u	$push11=, 1($4)
	i32.const	$push36=, 97
	i32.ne  	$push12=, $pop11, $pop36
	br_if   	0, $pop12       # 0: down to label0
# BB#12:                                # %for.inc25.1
	i32.load8_u	$push13=, 2($4)
	i32.const	$push37=, 97
	i32.ne  	$push14=, $pop13, $pop37
	br_if   	0, $pop14       # 0: down to label0
# BB#13:                                # %for.inc25.2
	i32.load8_u	$push15=, 3($4)
	i32.const	$push38=, 97
	i32.ne  	$push16=, $pop15, $pop38
	br_if   	0, $pop16       # 0: down to label0
# BB#14:                                # %for.inc25.3
	i32.load8_u	$push17=, 4($4)
	i32.const	$push39=, 97
	i32.ne  	$push18=, $pop17, $pop39
	br_if   	0, $pop18       # 0: down to label0
# BB#15:                                # %for.inc25.4
	i32.load8_u	$push19=, 5($4)
	i32.const	$push40=, 97
	i32.ne  	$push20=, $pop19, $pop40
	br_if   	0, $pop20       # 0: down to label0
# BB#16:                                # %for.inc25.5
	i32.load8_u	$push21=, 6($4)
	i32.const	$push41=, 97
	i32.ne  	$push22=, $pop21, $pop41
	br_if   	0, $pop22       # 0: down to label0
# BB#17:                                # %for.inc25.6
	i32.load8_u	$push23=, 7($4)
	i32.const	$push42=, 97
	i32.ne  	$push24=, $pop23, $pop42
	br_if   	0, $pop24       # 0: down to label0
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
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_16 Depth 2
                                        #     Child Loop BB2_29 Depth 2
	block
	loop                            # label8:
	i32.const	$0=, u
	i32.const	$push80=, u
	i32.const	$push79=, 97
	i32.const	$push78=, 31
	i32.call	$push0=, memset@FUNCTION, $pop80, $pop79, $pop78
	i32.const	$push77=, 0
	i32.call	$drop=, memset@FUNCTION, $pop0, $pop77, $1
	block
	i32.const	$push76=, 1
	i32.lt_s	$push75=, $1, $pop76
	tee_local	$push74=, $2=, $pop75
	br_if   	0, $pop74       # 0: down to label10
# BB#2:                                 # %for.body6.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$0=, 0
.LBB2_3:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	copy_local	$push82=, $0
	tee_local	$push81=, $3=, $pop82
	i32.load8_u	$push1=, u($pop81)
	br_if   	5, $pop1        # 5: down to label7
# BB#4:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push85=, 1
	i32.add 	$push84=, $3, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.lt_s	$push2=, $pop83, $1
	br_if   	0, $pop2        # 0: up to label11
# BB#5:                                 #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label12:
	i32.const	$push86=, u+1
	i32.add 	$0=, $3, $pop86
.LBB2_6:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load8_u	$push3=, 0($0)
	i32.const	$push87=, 97
	i32.ne  	$push4=, $pop3, $pop87
	br_if   	2, $pop4        # 2: down to label7
# BB#7:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push5=, 1($0)
	i32.const	$push88=, 97
	i32.ne  	$push6=, $pop5, $pop88
	br_if   	2, $pop6        # 2: down to label7
# BB#8:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push7=, 2($0)
	i32.const	$push89=, 97
	i32.ne  	$push8=, $pop7, $pop89
	br_if   	2, $pop8        # 2: down to label7
# BB#9:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push9=, 3($0)
	i32.const	$push90=, 97
	i32.ne  	$push10=, $pop9, $pop90
	br_if   	2, $pop10       # 2: down to label7
# BB#10:                                # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push11=, 4($0)
	i32.const	$push91=, 97
	i32.ne  	$push12=, $pop11, $pop91
	br_if   	2, $pop12       # 2: down to label7
# BB#11:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push13=, 5($0)
	i32.const	$push92=, 97
	i32.ne  	$push14=, $pop13, $pop92
	br_if   	2, $pop14       # 2: down to label7
# BB#12:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push15=, 6($0)
	i32.const	$push93=, 97
	i32.ne  	$push16=, $pop15, $pop93
	br_if   	2, $pop16       # 2: down to label7
# BB#13:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push17=, 7($0)
	i32.const	$push94=, 97
	i32.ne  	$push18=, $pop17, $pop94
	br_if   	2, $pop18       # 2: down to label7
# BB#14:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$0=, u
	i32.const	$push96=, u
	i32.const	$push95=, 0
	i32.load8_u	$push19=, A($pop95)
	i32.call	$drop=, memset@FUNCTION, $pop96, $pop19, $1
	block
	br_if   	0, $2           # 0: down to label13
# BB#15:                                # %for.body6.i241.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$0=, 0
.LBB2_16:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label14:
	copy_local	$push99=, $0
	tee_local	$push98=, $3=, $pop99
	i32.load8_u	$push20=, u($pop98)
	i32.const	$push97=, 65
	i32.ne  	$push21=, $pop20, $pop97
	br_if   	5, $pop21       # 5: down to label7
# BB#17:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_16 Depth=2
	i32.const	$push102=, 1
	i32.add 	$push101=, $3, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.lt_s	$push22=, $pop100, $1
	br_if   	0, $pop22       # 0: up to label14
# BB#18:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label15:
	i32.const	$push103=, u+1
	i32.add 	$0=, $3, $pop103
.LBB2_19:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label13:
	i32.load8_u	$push23=, 0($0)
	i32.const	$push104=, 97
	i32.ne  	$push24=, $pop23, $pop104
	br_if   	2, $pop24       # 2: down to label7
# BB#20:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push25=, 1($0)
	i32.const	$push105=, 97
	i32.ne  	$push26=, $pop25, $pop105
	br_if   	2, $pop26       # 2: down to label7
# BB#21:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push27=, 2($0)
	i32.const	$push106=, 97
	i32.ne  	$push28=, $pop27, $pop106
	br_if   	2, $pop28       # 2: down to label7
# BB#22:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push29=, 3($0)
	i32.const	$push107=, 97
	i32.ne  	$push30=, $pop29, $pop107
	br_if   	2, $pop30       # 2: down to label7
# BB#23:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push31=, 4($0)
	i32.const	$push108=, 97
	i32.ne  	$push32=, $pop31, $pop108
	br_if   	2, $pop32       # 2: down to label7
# BB#24:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push33=, 5($0)
	i32.const	$push109=, 97
	i32.ne  	$push34=, $pop33, $pop109
	br_if   	2, $pop34       # 2: down to label7
# BB#25:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push35=, 6($0)
	i32.const	$push110=, 97
	i32.ne  	$push36=, $pop35, $pop110
	br_if   	2, $pop36       # 2: down to label7
# BB#26:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push37=, 7($0)
	i32.const	$push111=, 97
	i32.ne  	$push38=, $pop37, $pop111
	br_if   	2, $pop38       # 2: down to label7
# BB#27:                                # %check.exit272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$0=, u
	i32.const	$push113=, u
	i32.const	$push112=, 66
	i32.call	$drop=, memset@FUNCTION, $pop113, $pop112, $1
	block
	br_if   	0, $2           # 0: down to label16
# BB#28:                                # %for.body6.i278.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$0=, 0
.LBB2_29:                               # %for.body6.i278
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label17:
	copy_local	$push116=, $0
	tee_local	$push115=, $3=, $pop116
	i32.load8_u	$push39=, u($pop115)
	i32.const	$push114=, 66
	i32.ne  	$push40=, $pop39, $pop114
	br_if   	5, $pop40       # 5: down to label7
# BB#30:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_29 Depth=2
	i32.const	$push119=, 1
	i32.add 	$push118=, $3, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.lt_s	$push41=, $pop117, $1
	br_if   	0, $pop41       # 0: up to label17
# BB#31:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label18:
	i32.const	$push120=, u+1
	i32.add 	$0=, $3, $pop120
.LBB2_32:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i32.load8_u	$push42=, 0($0)
	i32.const	$push121=, 97
	i32.ne  	$push43=, $pop42, $pop121
	br_if   	2, $pop43       # 2: down to label7
# BB#33:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push44=, 1($0)
	i32.const	$push122=, 97
	i32.ne  	$push45=, $pop44, $pop122
	br_if   	2, $pop45       # 2: down to label7
# BB#34:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push46=, 2($0)
	i32.const	$push123=, 97
	i32.ne  	$push47=, $pop46, $pop123
	br_if   	2, $pop47       # 2: down to label7
# BB#35:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push48=, 3($0)
	i32.const	$push124=, 97
	i32.ne  	$push49=, $pop48, $pop124
	br_if   	2, $pop49       # 2: down to label7
# BB#36:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push50=, 4($0)
	i32.const	$push125=, 97
	i32.ne  	$push51=, $pop50, $pop125
	br_if   	2, $pop51       # 2: down to label7
# BB#37:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push52=, 5($0)
	i32.const	$push126=, 97
	i32.ne  	$push53=, $pop52, $pop126
	br_if   	2, $pop53       # 2: down to label7
# BB#38:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push54=, 6($0)
	i32.const	$push127=, 97
	i32.ne  	$push55=, $pop54, $pop127
	br_if   	2, $pop55       # 2: down to label7
# BB#39:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push56=, 7($0)
	i32.const	$push128=, 97
	i32.ne  	$push57=, $pop56, $pop128
	br_if   	2, $pop57       # 2: down to label7
# BB#40:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push130=, 1
	i32.add 	$1=, $1, $pop130
	i32.const	$push129=, 15
	i32.lt_s	$push58=, $1, $pop129
	br_if   	0, $pop58       # 0: up to label8
# BB#41:                                # %for.body13.preheader
	end_loop                        # label9:
	i32.const	$1=, 0
.LBB2_42:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push145=, u
	i32.const	$push144=, 97
	i32.const	$push143=, 31
	i32.call	$drop=, memset@FUNCTION, $pop145, $pop144, $pop143
	i32.const	$push142=, u+1
	i32.const	$push141=, 0
	i32.call	$0=, memset@FUNCTION, $pop142, $pop141, $1
	i32.const	$push140=, 1
	i32.const	$push139=, 0
	call    	check@FUNCTION, $pop140, $1, $pop139
	i32.const	$push138=, 0
	i32.load8_u	$push59=, A($pop138)
	i32.call	$drop=, memset@FUNCTION, $0, $pop59, $1
	i32.const	$push137=, 1
	i32.const	$push136=, 65
	call    	check@FUNCTION, $pop137, $1, $pop136
	i32.const	$push135=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop135, $1
	i32.const	$push134=, 1
	i32.const	$push133=, 66
	call    	check@FUNCTION, $pop134, $1, $pop133
	i32.const	$push132=, 1
	i32.add 	$1=, $1, $pop132
	i32.const	$push131=, 15
	i32.ne  	$push60=, $1, $pop131
	br_if   	0, $pop60       # 0: up to label19
# BB#43:                                # %for.body33.preheader
	end_loop                        # label20:
	i32.const	$1=, 0
.LBB2_44:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label21:
	i32.const	$push160=, u
	i32.const	$push159=, 97
	i32.const	$push158=, 31
	i32.call	$drop=, memset@FUNCTION, $pop160, $pop159, $pop158
	i32.const	$push157=, u+2
	i32.const	$push156=, 0
	i32.call	$0=, memset@FUNCTION, $pop157, $pop156, $1
	i32.const	$push155=, 2
	i32.const	$push154=, 0
	call    	check@FUNCTION, $pop155, $1, $pop154
	i32.const	$push153=, 0
	i32.load8_u	$push61=, A($pop153)
	i32.call	$drop=, memset@FUNCTION, $0, $pop61, $1
	i32.const	$push152=, 2
	i32.const	$push151=, 65
	call    	check@FUNCTION, $pop152, $1, $pop151
	i32.const	$push150=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop150, $1
	i32.const	$push149=, 2
	i32.const	$push148=, 66
	call    	check@FUNCTION, $pop149, $1, $pop148
	i32.const	$push147=, 1
	i32.add 	$1=, $1, $pop147
	i32.const	$push146=, 15
	i32.ne  	$push62=, $1, $pop146
	br_if   	0, $pop62       # 0: up to label21
# BB#45:                                # %for.body53.preheader
	end_loop                        # label22:
	i32.const	$1=, 0
.LBB2_46:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label23:
	i32.const	$push175=, u
	i32.const	$push174=, 97
	i32.const	$push173=, 31
	i32.call	$drop=, memset@FUNCTION, $pop175, $pop174, $pop173
	i32.const	$push172=, u+3
	i32.const	$push171=, 0
	i32.call	$0=, memset@FUNCTION, $pop172, $pop171, $1
	i32.const	$push170=, 3
	i32.const	$push169=, 0
	call    	check@FUNCTION, $pop170, $1, $pop169
	i32.const	$push168=, 0
	i32.load8_u	$push63=, A($pop168)
	i32.call	$drop=, memset@FUNCTION, $0, $pop63, $1
	i32.const	$push167=, 3
	i32.const	$push166=, 65
	call    	check@FUNCTION, $pop167, $1, $pop166
	i32.const	$push165=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop165, $1
	i32.const	$push164=, 3
	i32.const	$push163=, 66
	call    	check@FUNCTION, $pop164, $1, $pop163
	i32.const	$push162=, 1
	i32.add 	$1=, $1, $pop162
	i32.const	$push161=, 15
	i32.ne  	$push64=, $1, $pop161
	br_if   	0, $pop64       # 0: up to label23
# BB#47:                                # %for.body73.preheader
	end_loop                        # label24:
	i32.const	$1=, 0
.LBB2_48:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$push190=, u
	i32.const	$push189=, 97
	i32.const	$push188=, 31
	i32.call	$drop=, memset@FUNCTION, $pop190, $pop189, $pop188
	i32.const	$push187=, u+4
	i32.const	$push186=, 0
	i32.call	$0=, memset@FUNCTION, $pop187, $pop186, $1
	i32.const	$push185=, 4
	i32.const	$push184=, 0
	call    	check@FUNCTION, $pop185, $1, $pop184
	i32.const	$push183=, 0
	i32.load8_u	$push65=, A($pop183)
	i32.call	$drop=, memset@FUNCTION, $0, $pop65, $1
	i32.const	$push182=, 4
	i32.const	$push181=, 65
	call    	check@FUNCTION, $pop182, $1, $pop181
	i32.const	$push180=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop180, $1
	i32.const	$push179=, 4
	i32.const	$push178=, 66
	call    	check@FUNCTION, $pop179, $1, $pop178
	i32.const	$push177=, 1
	i32.add 	$1=, $1, $pop177
	i32.const	$push176=, 15
	i32.ne  	$push66=, $1, $pop176
	br_if   	0, $pop66       # 0: up to label25
# BB#49:                                # %for.body93.preheader
	end_loop                        # label26:
	i32.const	$1=, 0
.LBB2_50:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	i32.const	$push205=, u
	i32.const	$push204=, 97
	i32.const	$push203=, 31
	i32.call	$drop=, memset@FUNCTION, $pop205, $pop204, $pop203
	i32.const	$push202=, u+5
	i32.const	$push201=, 0
	i32.call	$0=, memset@FUNCTION, $pop202, $pop201, $1
	i32.const	$push200=, 5
	i32.const	$push199=, 0
	call    	check@FUNCTION, $pop200, $1, $pop199
	i32.const	$push198=, 0
	i32.load8_u	$push67=, A($pop198)
	i32.call	$drop=, memset@FUNCTION, $0, $pop67, $1
	i32.const	$push197=, 5
	i32.const	$push196=, 65
	call    	check@FUNCTION, $pop197, $1, $pop196
	i32.const	$push195=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop195, $1
	i32.const	$push194=, 5
	i32.const	$push193=, 66
	call    	check@FUNCTION, $pop194, $1, $pop193
	i32.const	$push192=, 1
	i32.add 	$1=, $1, $pop192
	i32.const	$push191=, 15
	i32.ne  	$push68=, $1, $pop191
	br_if   	0, $pop68       # 0: up to label27
# BB#51:                                # %for.body113.preheader
	end_loop                        # label28:
	i32.const	$1=, 0
.LBB2_52:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label29:
	i32.const	$push220=, u
	i32.const	$push219=, 97
	i32.const	$push218=, 31
	i32.call	$drop=, memset@FUNCTION, $pop220, $pop219, $pop218
	i32.const	$push217=, u+6
	i32.const	$push216=, 0
	i32.call	$0=, memset@FUNCTION, $pop217, $pop216, $1
	i32.const	$push215=, 6
	i32.const	$push214=, 0
	call    	check@FUNCTION, $pop215, $1, $pop214
	i32.const	$push213=, 0
	i32.load8_u	$push69=, A($pop213)
	i32.call	$drop=, memset@FUNCTION, $0, $pop69, $1
	i32.const	$push212=, 6
	i32.const	$push211=, 65
	call    	check@FUNCTION, $pop212, $1, $pop211
	i32.const	$push210=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop210, $1
	i32.const	$push209=, 6
	i32.const	$push208=, 66
	call    	check@FUNCTION, $pop209, $1, $pop208
	i32.const	$push207=, 1
	i32.add 	$1=, $1, $pop207
	i32.const	$push206=, 15
	i32.ne  	$push70=, $1, $pop206
	br_if   	0, $pop70       # 0: up to label29
# BB#53:                                # %for.body133.preheader
	end_loop                        # label30:
	i32.const	$1=, 0
.LBB2_54:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push235=, u
	i32.const	$push234=, 97
	i32.const	$push233=, 31
	i32.call	$drop=, memset@FUNCTION, $pop235, $pop234, $pop233
	i32.const	$push232=, u+7
	i32.const	$push231=, 0
	i32.call	$0=, memset@FUNCTION, $pop232, $pop231, $1
	i32.const	$push230=, 7
	i32.const	$push229=, 0
	call    	check@FUNCTION, $pop230, $1, $pop229
	i32.const	$push228=, 0
	i32.load8_u	$push71=, A($pop228)
	i32.call	$drop=, memset@FUNCTION, $0, $pop71, $1
	i32.const	$push227=, 7
	i32.const	$push226=, 65
	call    	check@FUNCTION, $pop227, $1, $pop226
	i32.const	$push225=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop225, $1
	i32.const	$push224=, 7
	i32.const	$push223=, 66
	call    	check@FUNCTION, $pop224, $1, $pop223
	i32.const	$push222=, 1
	i32.add 	$1=, $1, $pop222
	i32.const	$push221=, 15
	i32.ne  	$push72=, $1, $pop221
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
