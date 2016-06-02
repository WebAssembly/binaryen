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
	i32.const	$push25=, 1
	i32.lt_s	$push0=, $0, $pop25
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$4=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push28=, $4
	tee_local	$push27=, $3=, $pop28
	i32.load8_u	$push1=, u($pop27)
	i32.const	$push26=, 97
	i32.ne  	$push2=, $pop1, $pop26
	br_if   	3, $pop2        # 3: down to label0
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push31=, 1
	i32.add 	$push30=, $3, $pop31
	tee_local	$push29=, $4=, $pop30
	i32.lt_s	$push3=, $pop29, $0
	br_if   	0, $pop3        # 0: up to label2
# BB#4:
	end_loop                        # label3:
	i32.const	$push32=, u+1
	i32.add 	$3=, $3, $pop32
.LBB1_5:                                # %for.cond3.preheader
	end_block                       # label1:
	block
	i32.const	$push33=, 1
	i32.lt_s	$push4=, $1, $pop33
	br_if   	0, $pop4        # 0: down to label4
# BB#6:                                 # %for.body6.preheader
	i32.const	$4=, 0
.LBB1_7:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.add 	$push5=, $3, $4
	i32.load8_s	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop6, $2
	br_if   	3, $pop7        # 3: down to label0
# BB#8:                                 # %for.inc12
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push36=, 1
	i32.add 	$push35=, $4, $pop36
	tee_local	$push34=, $4=, $pop35
	i32.lt_s	$push8=, $pop34, $1
	br_if   	0, $pop8        # 0: up to label5
# BB#9:
	end_loop                        # label6:
	i32.add 	$3=, $3, $4
.LBB1_10:                               # %for.body19.preheader
	end_block                       # label4:
	i32.load8_u	$push9=, 0($3)
	i32.const	$push37=, 97
	i32.ne  	$push10=, $pop9, $pop37
	br_if   	0, $pop10       # 0: down to label0
# BB#11:                                # %for.inc25
	i32.load8_u	$push11=, 1($3)
	i32.const	$push38=, 97
	i32.ne  	$push12=, $pop11, $pop38
	br_if   	0, $pop12       # 0: down to label0
# BB#12:                                # %for.inc25.1
	i32.load8_u	$push13=, 2($3)
	i32.const	$push39=, 97
	i32.ne  	$push14=, $pop13, $pop39
	br_if   	0, $pop14       # 0: down to label0
# BB#13:                                # %for.inc25.2
	i32.load8_u	$push15=, 3($3)
	i32.const	$push40=, 97
	i32.ne  	$push16=, $pop15, $pop40
	br_if   	0, $pop16       # 0: down to label0
# BB#14:                                # %for.inc25.3
	i32.load8_u	$push17=, 4($3)
	i32.const	$push41=, 97
	i32.ne  	$push18=, $pop17, $pop41
	br_if   	0, $pop18       # 0: down to label0
# BB#15:                                # %for.inc25.4
	i32.load8_u	$push19=, 5($3)
	i32.const	$push42=, 97
	i32.ne  	$push20=, $pop19, $pop42
	br_if   	0, $pop20       # 0: down to label0
# BB#16:                                # %for.inc25.5
	i32.load8_u	$push21=, 6($3)
	i32.const	$push43=, 97
	i32.ne  	$push22=, $pop21, $pop43
	br_if   	0, $pop22       # 0: down to label0
# BB#17:                                # %for.inc25.6
	i32.load8_u	$push23=, 7($3)
	i32.const	$push44=, 97
	i32.ne  	$push24=, $pop23, $pop44
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
	i32.const	$3=, 0
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
	i32.call	$drop=, memset@FUNCTION, $pop0, $pop77, $3
	block
	i32.const	$push76=, 1
	i32.lt_s	$push75=, $3, $pop76
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
	tee_local	$push81=, $1=, $pop82
	i32.load8_u	$push1=, u($pop81)
	br_if   	5, $pop1        # 5: down to label7
# BB#4:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push85=, 1
	i32.add 	$push84=, $1, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.lt_s	$push2=, $pop83, $3
	br_if   	0, $pop2        # 0: up to label11
# BB#5:                                 #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label12:
	i32.const	$push86=, u+1
	i32.add 	$0=, $1, $pop86
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
	i32.call	$drop=, memset@FUNCTION, $pop96, $pop19, $3
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
	tee_local	$push98=, $1=, $pop99
	i32.load8_u	$push20=, u($pop98)
	i32.const	$push97=, 65
	i32.ne  	$push21=, $pop20, $pop97
	br_if   	5, $pop21       # 5: down to label7
# BB#17:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_16 Depth=2
	i32.const	$push102=, 1
	i32.add 	$push101=, $1, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.lt_s	$push22=, $pop100, $3
	br_if   	0, $pop22       # 0: up to label14
# BB#18:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label15:
	i32.const	$push103=, u+1
	i32.add 	$0=, $1, $pop103
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
	i32.call	$drop=, memset@FUNCTION, $pop113, $pop112, $3
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
	tee_local	$push115=, $1=, $pop116
	i32.load8_u	$push39=, u($pop115)
	i32.const	$push114=, 66
	i32.ne  	$push40=, $pop39, $pop114
	br_if   	5, $pop40       # 5: down to label7
# BB#30:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_29 Depth=2
	i32.const	$push119=, 1
	i32.add 	$push118=, $1, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.lt_s	$push41=, $pop117, $3
	br_if   	0, $pop41       # 0: up to label17
# BB#31:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label18:
	i32.const	$push120=, u+1
	i32.add 	$0=, $1, $pop120
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
	i32.const	$push132=, 1
	i32.add 	$push131=, $3, $pop132
	tee_local	$push130=, $3=, $pop131
	i32.const	$push129=, 15
	i32.lt_s	$push58=, $pop130, $pop129
	br_if   	0, $pop58       # 0: up to label8
# BB#41:                                # %for.body13.preheader
	end_loop                        # label9:
	i32.const	$3=, 0
.LBB2_42:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push149=, u
	i32.const	$push148=, 97
	i32.const	$push147=, 31
	i32.call	$drop=, memset@FUNCTION, $pop149, $pop148, $pop147
	i32.const	$push146=, u+1
	i32.const	$push145=, 0
	i32.call	$0=, memset@FUNCTION, $pop146, $pop145, $3
	i32.const	$push144=, 1
	i32.const	$push143=, 0
	call    	check@FUNCTION, $pop144, $3, $pop143
	i32.const	$push142=, 0
	i32.load8_u	$push59=, A($pop142)
	i32.call	$drop=, memset@FUNCTION, $0, $pop59, $3
	i32.const	$push141=, 1
	i32.const	$push140=, 65
	call    	check@FUNCTION, $pop141, $3, $pop140
	i32.const	$push139=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop139, $3
	i32.const	$push138=, 1
	i32.const	$push137=, 66
	call    	check@FUNCTION, $pop138, $3, $pop137
	i32.const	$push136=, 1
	i32.add 	$push135=, $3, $pop136
	tee_local	$push134=, $3=, $pop135
	i32.const	$push133=, 15
	i32.ne  	$push60=, $pop134, $pop133
	br_if   	0, $pop60       # 0: up to label19
# BB#43:                                # %for.body33.preheader
	end_loop                        # label20:
	i32.const	$3=, 0
.LBB2_44:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label21:
	i32.const	$push166=, u
	i32.const	$push165=, 97
	i32.const	$push164=, 31
	i32.call	$drop=, memset@FUNCTION, $pop166, $pop165, $pop164
	i32.const	$push163=, u+2
	i32.const	$push162=, 0
	i32.call	$0=, memset@FUNCTION, $pop163, $pop162, $3
	i32.const	$push161=, 2
	i32.const	$push160=, 0
	call    	check@FUNCTION, $pop161, $3, $pop160
	i32.const	$push159=, 0
	i32.load8_u	$push61=, A($pop159)
	i32.call	$drop=, memset@FUNCTION, $0, $pop61, $3
	i32.const	$push158=, 2
	i32.const	$push157=, 65
	call    	check@FUNCTION, $pop158, $3, $pop157
	i32.const	$push156=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop156, $3
	i32.const	$push155=, 2
	i32.const	$push154=, 66
	call    	check@FUNCTION, $pop155, $3, $pop154
	i32.const	$push153=, 1
	i32.add 	$push152=, $3, $pop153
	tee_local	$push151=, $3=, $pop152
	i32.const	$push150=, 15
	i32.ne  	$push62=, $pop151, $pop150
	br_if   	0, $pop62       # 0: up to label21
# BB#45:                                # %for.body53.preheader
	end_loop                        # label22:
	i32.const	$3=, 0
.LBB2_46:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label23:
	i32.const	$push183=, u
	i32.const	$push182=, 97
	i32.const	$push181=, 31
	i32.call	$drop=, memset@FUNCTION, $pop183, $pop182, $pop181
	i32.const	$push180=, u+3
	i32.const	$push179=, 0
	i32.call	$0=, memset@FUNCTION, $pop180, $pop179, $3
	i32.const	$push178=, 3
	i32.const	$push177=, 0
	call    	check@FUNCTION, $pop178, $3, $pop177
	i32.const	$push176=, 0
	i32.load8_u	$push63=, A($pop176)
	i32.call	$drop=, memset@FUNCTION, $0, $pop63, $3
	i32.const	$push175=, 3
	i32.const	$push174=, 65
	call    	check@FUNCTION, $pop175, $3, $pop174
	i32.const	$push173=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop173, $3
	i32.const	$push172=, 3
	i32.const	$push171=, 66
	call    	check@FUNCTION, $pop172, $3, $pop171
	i32.const	$push170=, 1
	i32.add 	$push169=, $3, $pop170
	tee_local	$push168=, $3=, $pop169
	i32.const	$push167=, 15
	i32.ne  	$push64=, $pop168, $pop167
	br_if   	0, $pop64       # 0: up to label23
# BB#47:                                # %for.body73.preheader
	end_loop                        # label24:
	i32.const	$3=, 0
.LBB2_48:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$push200=, u
	i32.const	$push199=, 97
	i32.const	$push198=, 31
	i32.call	$drop=, memset@FUNCTION, $pop200, $pop199, $pop198
	i32.const	$push197=, u+4
	i32.const	$push196=, 0
	i32.call	$0=, memset@FUNCTION, $pop197, $pop196, $3
	i32.const	$push195=, 4
	i32.const	$push194=, 0
	call    	check@FUNCTION, $pop195, $3, $pop194
	i32.const	$push193=, 0
	i32.load8_u	$push65=, A($pop193)
	i32.call	$drop=, memset@FUNCTION, $0, $pop65, $3
	i32.const	$push192=, 4
	i32.const	$push191=, 65
	call    	check@FUNCTION, $pop192, $3, $pop191
	i32.const	$push190=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop190, $3
	i32.const	$push189=, 4
	i32.const	$push188=, 66
	call    	check@FUNCTION, $pop189, $3, $pop188
	i32.const	$push187=, 1
	i32.add 	$push186=, $3, $pop187
	tee_local	$push185=, $3=, $pop186
	i32.const	$push184=, 15
	i32.ne  	$push66=, $pop185, $pop184
	br_if   	0, $pop66       # 0: up to label25
# BB#49:                                # %for.body93.preheader
	end_loop                        # label26:
	i32.const	$3=, 0
.LBB2_50:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	i32.const	$push217=, u
	i32.const	$push216=, 97
	i32.const	$push215=, 31
	i32.call	$drop=, memset@FUNCTION, $pop217, $pop216, $pop215
	i32.const	$push214=, u+5
	i32.const	$push213=, 0
	i32.call	$0=, memset@FUNCTION, $pop214, $pop213, $3
	i32.const	$push212=, 5
	i32.const	$push211=, 0
	call    	check@FUNCTION, $pop212, $3, $pop211
	i32.const	$push210=, 0
	i32.load8_u	$push67=, A($pop210)
	i32.call	$drop=, memset@FUNCTION, $0, $pop67, $3
	i32.const	$push209=, 5
	i32.const	$push208=, 65
	call    	check@FUNCTION, $pop209, $3, $pop208
	i32.const	$push207=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop207, $3
	i32.const	$push206=, 5
	i32.const	$push205=, 66
	call    	check@FUNCTION, $pop206, $3, $pop205
	i32.const	$push204=, 1
	i32.add 	$push203=, $3, $pop204
	tee_local	$push202=, $3=, $pop203
	i32.const	$push201=, 15
	i32.ne  	$push68=, $pop202, $pop201
	br_if   	0, $pop68       # 0: up to label27
# BB#51:                                # %for.body113.preheader
	end_loop                        # label28:
	i32.const	$3=, 0
.LBB2_52:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label29:
	i32.const	$push234=, u
	i32.const	$push233=, 97
	i32.const	$push232=, 31
	i32.call	$drop=, memset@FUNCTION, $pop234, $pop233, $pop232
	i32.const	$push231=, u+6
	i32.const	$push230=, 0
	i32.call	$0=, memset@FUNCTION, $pop231, $pop230, $3
	i32.const	$push229=, 6
	i32.const	$push228=, 0
	call    	check@FUNCTION, $pop229, $3, $pop228
	i32.const	$push227=, 0
	i32.load8_u	$push69=, A($pop227)
	i32.call	$drop=, memset@FUNCTION, $0, $pop69, $3
	i32.const	$push226=, 6
	i32.const	$push225=, 65
	call    	check@FUNCTION, $pop226, $3, $pop225
	i32.const	$push224=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop224, $3
	i32.const	$push223=, 6
	i32.const	$push222=, 66
	call    	check@FUNCTION, $pop223, $3, $pop222
	i32.const	$push221=, 1
	i32.add 	$push220=, $3, $pop221
	tee_local	$push219=, $3=, $pop220
	i32.const	$push218=, 15
	i32.ne  	$push70=, $pop219, $pop218
	br_if   	0, $pop70       # 0: up to label29
# BB#53:                                # %for.body133.preheader
	end_loop                        # label30:
	i32.const	$3=, 0
.LBB2_54:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push251=, u
	i32.const	$push250=, 97
	i32.const	$push249=, 31
	i32.call	$drop=, memset@FUNCTION, $pop251, $pop250, $pop249
	i32.const	$push248=, u+7
	i32.const	$push247=, 0
	i32.call	$0=, memset@FUNCTION, $pop248, $pop247, $3
	i32.const	$push246=, 7
	i32.const	$push245=, 0
	call    	check@FUNCTION, $pop246, $3, $pop245
	i32.const	$push244=, 0
	i32.load8_u	$push71=, A($pop244)
	i32.call	$drop=, memset@FUNCTION, $0, $pop71, $3
	i32.const	$push243=, 7
	i32.const	$push242=, 65
	call    	check@FUNCTION, $pop243, $3, $pop242
	i32.const	$push241=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop241, $3
	i32.const	$push240=, 7
	i32.const	$push239=, 66
	call    	check@FUNCTION, $pop240, $3, $pop239
	i32.const	$push238=, 1
	i32.add 	$push237=, $3, $pop238
	tee_local	$push236=, $3=, $pop237
	i32.const	$push235=, 15
	i32.ne  	$push72=, $pop236, $pop235
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
