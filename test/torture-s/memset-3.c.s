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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.const	$3=, u
	block
	block
	block
	block
	i32.const	$push29=, 0
	i32.le_s	$push0=, $0, $pop29
	br_if   	0, $pop0        # 0: down to label3
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load8_u	$push1=, u($5)
	i32.const	$push2=, 97
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	3, $pop3        # 3: down to label2
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, u+1
	i32.add 	$3=, $5, $pop6
	i32.const	$push4=, 1
	i32.add 	$4=, $5, $pop4
	copy_local	$5=, $4
	i32.lt_s	$push5=, $4, $0
	br_if   	0, $pop5        # 0: up to label4
.LBB1_3:                                # %for.cond3.preheader
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$5=, 0
	copy_local	$4=, $3
	block
	i32.const	$push30=, 0
	i32.le_s	$push7=, $1, $pop30
	br_if   	0, $pop7        # 0: down to label6
.LBB1_4:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.add 	$push8=, $3, $5
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop9, $2
	br_if   	4, $pop10       # 4: down to label1
# BB#5:                                 # %for.inc12
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.const	$push11=, 1
	i32.add 	$5=, $5, $pop11
	i32.add 	$4=, $3, $5
	i32.lt_s	$push12=, $5, $1
	br_if   	0, $pop12       # 0: up to label7
.LBB1_6:                                # %for.body19.preheader
	end_loop                        # label8:
	end_block                       # label6:
	i32.load8_u	$push13=, 0($4)
	i32.const	$push31=, 97
	i32.ne  	$push14=, $pop13, $pop31
	br_if   	2, $pop14       # 2: down to label0
# BB#7:                                 # %for.inc25
	i32.load8_u	$push15=, 1($4)
	i32.const	$push32=, 97
	i32.ne  	$push16=, $pop15, $pop32
	br_if   	2, $pop16       # 2: down to label0
# BB#8:                                 # %for.inc25.1
	i32.load8_u	$push17=, 2($4)
	i32.const	$push33=, 97
	i32.ne  	$push18=, $pop17, $pop33
	br_if   	2, $pop18       # 2: down to label0
# BB#9:                                 # %for.inc25.2
	i32.load8_u	$push19=, 3($4)
	i32.const	$push34=, 97
	i32.ne  	$push20=, $pop19, $pop34
	br_if   	2, $pop20       # 2: down to label0
# BB#10:                                # %for.inc25.3
	i32.load8_u	$push21=, 4($4)
	i32.const	$push35=, 97
	i32.ne  	$push22=, $pop21, $pop35
	br_if   	2, $pop22       # 2: down to label0
# BB#11:                                # %for.inc25.4
	i32.load8_u	$push23=, 5($4)
	i32.const	$push36=, 97
	i32.ne  	$push24=, $pop23, $pop36
	br_if   	2, $pop24       # 2: down to label0
# BB#12:                                # %for.inc25.5
	i32.load8_u	$push25=, 6($4)
	i32.const	$push37=, 97
	i32.ne  	$push26=, $pop25, $pop37
	br_if   	2, $pop26       # 2: down to label0
# BB#13:                                # %for.inc25.6
	i32.load8_u	$push27=, 7($4)
	i32.const	$push38=, 97
	i32.ne  	$push28=, $pop27, $pop38
	br_if   	2, $pop28       # 2: down to label0
# BB#14:                                # %for.inc25.7
	return
.LBB1_15:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %if.then10
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_13 Depth 2
                                        #     Child Loop BB2_24 Depth 2
	block
	block
	block
	block
	block
	block
	loop                            # label15:
	i32.const	$push0=, u
	i32.const	$push107=, 97
	i32.const	$push106=, 31
	i32.call	$push1=, memset@FUNCTION, $pop0, $pop107, $pop106
	i32.const	$push105=, 0
	i32.call	$2=, memset@FUNCTION, $pop1, $pop105, $1
	i32.const	$3=, 0
	block
	i32.const	$push104=, 1
	i32.lt_s	$push103=, $1, $pop104
	tee_local	$push102=, $4=, $pop103
	br_if   	0, $pop102      # 0: down to label17
.LBB2_2:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label18:
	i32.load8_u	$push2=, u($3)
	br_if   	5, $pop2        # 5: down to label14
# BB#3:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push109=, u+1
	i32.add 	$2=, $3, $pop109
	i32.const	$push108=, 1
	i32.add 	$0=, $3, $pop108
	copy_local	$3=, $0
	i32.lt_s	$push3=, $0, $1
	br_if   	0, $pop3        # 0: up to label18
.LBB2_4:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label19:
	end_block                       # label17:
	i32.load8_u	$push4=, 0($2)
	i32.const	$push110=, 97
	i32.ne  	$push5=, $pop4, $pop110
	br_if   	5, $pop5        # 5: down to label11
# BB#5:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push6=, 1($2)
	i32.const	$push111=, 97
	i32.ne  	$push7=, $pop6, $pop111
	br_if   	5, $pop7        # 5: down to label11
# BB#6:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push8=, 2($2)
	i32.const	$push112=, 97
	i32.ne  	$push9=, $pop8, $pop112
	br_if   	5, $pop9        # 5: down to label11
# BB#7:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push10=, 3($2)
	i32.const	$push113=, 97
	i32.ne  	$push11=, $pop10, $pop113
	br_if   	5, $pop11       # 5: down to label11
# BB#8:                                 # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push12=, 4($2)
	i32.const	$push114=, 97
	i32.ne  	$push13=, $pop12, $pop114
	br_if   	5, $pop13       # 5: down to label11
# BB#9:                                 # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push14=, 5($2)
	i32.const	$push115=, 97
	i32.ne  	$push15=, $pop14, $pop115
	br_if   	5, $pop15       # 5: down to label11
# BB#10:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push16=, 6($2)
	i32.const	$push116=, 97
	i32.ne  	$push17=, $pop16, $pop116
	br_if   	5, $pop17       # 5: down to label11
# BB#11:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push18=, 7($2)
	i32.const	$push117=, 97
	i32.ne  	$push19=, $pop18, $pop117
	br_if   	5, $pop19       # 5: down to label11
# BB#12:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$3=, 0
	i32.const	$push20=, u
	i32.const	$push118=, 0
	i32.load8_u	$push21=, A($pop118)
	i32.call	$2=, memset@FUNCTION, $pop20, $pop21, $1
	block
	br_if   	0, $4           # 0: down to label20
.LBB2_13:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label21:
	i32.load8_u	$push22=, u($3)
	i32.const	$push119=, 65
	i32.ne  	$push23=, $pop22, $pop119
	br_if   	6, $pop23       # 6: down to label13
# BB#14:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_13 Depth=2
	i32.const	$push121=, u+1
	i32.add 	$2=, $3, $pop121
	i32.const	$push120=, 1
	i32.add 	$0=, $3, $pop120
	copy_local	$3=, $0
	i32.lt_s	$push24=, $0, $1
	br_if   	0, $pop24       # 0: up to label21
.LBB2_15:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label22:
	end_block                       # label20:
	i32.load8_u	$push25=, 0($2)
	i32.const	$push122=, 97
	i32.ne  	$push26=, $pop25, $pop122
	br_if   	6, $pop26       # 6: down to label10
# BB#16:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push27=, 1($2)
	i32.const	$push123=, 97
	i32.ne  	$push28=, $pop27, $pop123
	br_if   	6, $pop28       # 6: down to label10
# BB#17:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push29=, 2($2)
	i32.const	$push124=, 97
	i32.ne  	$push30=, $pop29, $pop124
	br_if   	6, $pop30       # 6: down to label10
# BB#18:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push31=, 3($2)
	i32.const	$push125=, 97
	i32.ne  	$push32=, $pop31, $pop125
	br_if   	6, $pop32       # 6: down to label10
# BB#19:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push33=, 4($2)
	i32.const	$push126=, 97
	i32.ne  	$push34=, $pop33, $pop126
	br_if   	6, $pop34       # 6: down to label10
# BB#20:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push35=, 5($2)
	i32.const	$push127=, 97
	i32.ne  	$push36=, $pop35, $pop127
	br_if   	6, $pop36       # 6: down to label10
# BB#21:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push37=, 6($2)
	i32.const	$push128=, 97
	i32.ne  	$push38=, $pop37, $pop128
	br_if   	6, $pop38       # 6: down to label10
# BB#22:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push39=, 7($2)
	i32.const	$push129=, 97
	i32.ne  	$push40=, $pop39, $pop129
	br_if   	6, $pop40       # 6: down to label10
# BB#23:                                # %check.exit272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push41=, u
	i32.const	$push130=, 66
	i32.call	$2=, memset@FUNCTION, $pop41, $pop130, $1
	i32.const	$3=, 0
	block
	br_if   	0, $4           # 0: down to label23
.LBB2_24:                               # %for.body6.i278
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label24:
	i32.load8_u	$push42=, u($3)
	i32.const	$push131=, 66
	i32.ne  	$push43=, $pop42, $pop131
	br_if   	7, $pop43       # 7: down to label12
# BB#25:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_24 Depth=2
	i32.const	$push133=, u+1
	i32.add 	$2=, $3, $pop133
	i32.const	$push132=, 1
	i32.add 	$0=, $3, $pop132
	copy_local	$3=, $0
	i32.lt_s	$push44=, $0, $1
	br_if   	0, $pop44       # 0: up to label24
.LBB2_26:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label25:
	end_block                       # label23:
	i32.load8_u	$push45=, 0($2)
	i32.const	$push134=, 97
	i32.ne  	$push46=, $pop45, $pop134
	br_if   	7, $pop46       # 7: down to label9
# BB#27:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push47=, 1($2)
	i32.const	$push135=, 97
	i32.ne  	$push48=, $pop47, $pop135
	br_if   	7, $pop48       # 7: down to label9
# BB#28:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push49=, 2($2)
	i32.const	$push136=, 97
	i32.ne  	$push50=, $pop49, $pop136
	br_if   	7, $pop50       # 7: down to label9
# BB#29:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push51=, 3($2)
	i32.const	$push137=, 97
	i32.ne  	$push52=, $pop51, $pop137
	br_if   	7, $pop52       # 7: down to label9
# BB#30:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push53=, 4($2)
	i32.const	$push138=, 97
	i32.ne  	$push54=, $pop53, $pop138
	br_if   	7, $pop54       # 7: down to label9
# BB#31:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push55=, 5($2)
	i32.const	$push139=, 97
	i32.ne  	$push56=, $pop55, $pop139
	br_if   	7, $pop56       # 7: down to label9
# BB#32:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push57=, 6($2)
	i32.const	$push140=, 97
	i32.ne  	$push58=, $pop57, $pop140
	br_if   	7, $pop58       # 7: down to label9
# BB#33:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push59=, 7($2)
	i32.const	$push141=, 97
	i32.ne  	$push60=, $pop59, $pop141
	br_if   	7, $pop60       # 7: down to label9
# BB#34:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push101=, 1
	i32.add 	$1=, $1, $pop101
	i32.const	$3=, 0
	i32.const	$0=, 0
	i32.const	$push100=, 14
	i32.le_s	$push61=, $1, $pop100
	br_if   	0, $pop61       # 0: up to label15
.LBB2_35:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label16:
	loop                            # label26:
	i32.const	$push62=, u
	i32.const	$push154=, 97
	i32.const	$push153=, 31
	i32.call	$2=, memset@FUNCTION, $pop62, $pop154, $pop153
	i32.const	$push63=, u+1
	i32.const	$push152=, 0
	i32.call	$1=, memset@FUNCTION, $pop63, $pop152, $0
	i32.const	$push151=, 1
	i32.const	$push150=, 0
	call    	check@FUNCTION, $pop151, $0, $pop150
	i32.const	$push149=, 0
	i32.load8_u	$push64=, A($pop149)
	i32.call	$discard=, memset@FUNCTION, $1, $pop64, $0
	i32.const	$push148=, 1
	i32.const	$push147=, 65
	call    	check@FUNCTION, $pop148, $0, $pop147
	i32.const	$push146=, 66
	i32.call	$discard=, memset@FUNCTION, $1, $pop146, $0
	i32.const	$push145=, 1
	i32.const	$push144=, 66
	call    	check@FUNCTION, $pop145, $0, $pop144
	i32.const	$push143=, 1
	i32.add 	$0=, $0, $pop143
	i32.const	$push142=, 15
	i32.ne  	$push65=, $0, $pop142
	br_if   	0, $pop65       # 0: up to label26
.LBB2_36:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label27:
	loop                            # label28:
	i32.const	$push166=, 97
	i32.const	$push165=, 31
	i32.call	$discard=, memset@FUNCTION, $2, $pop166, $pop165
	i32.const	$1=, 0
	i32.const	$push66=, u+2
	i32.const	$push164=, 0
	i32.call	$0=, memset@FUNCTION, $pop66, $pop164, $3
	i32.const	$push67=, 2
	i32.const	$push163=, 0
	call    	check@FUNCTION, $pop67, $3, $pop163
	i32.const	$push162=, 0
	i32.load8_u	$push68=, A($pop162)
	i32.call	$discard=, memset@FUNCTION, $0, $pop68, $3
	i32.const	$push161=, 2
	i32.const	$push160=, 65
	call    	check@FUNCTION, $pop161, $3, $pop160
	i32.const	$push159=, 66
	i32.call	$discard=, memset@FUNCTION, $0, $pop159, $3
	i32.const	$push158=, 2
	i32.const	$push157=, 66
	call    	check@FUNCTION, $pop158, $3, $pop157
	i32.const	$push156=, 1
	i32.add 	$3=, $3, $pop156
	i32.const	$0=, 0
	i32.const	$push155=, 15
	i32.ne  	$push69=, $3, $pop155
	br_if   	0, $pop69       # 0: up to label28
.LBB2_37:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label29:
	loop                            # label30:
	i32.const	$push70=, u
	i32.const	$push178=, 97
	i32.const	$push177=, 31
	i32.call	$2=, memset@FUNCTION, $pop70, $pop178, $pop177
	i32.const	$push71=, u+3
	i32.const	$push176=, 0
	i32.call	$3=, memset@FUNCTION, $pop71, $pop176, $0
	i32.const	$push72=, 3
	i32.const	$push175=, 0
	call    	check@FUNCTION, $pop72, $0, $pop175
	i32.const	$push174=, 0
	i32.load8_u	$push73=, A($pop174)
	i32.call	$discard=, memset@FUNCTION, $3, $pop73, $0
	i32.const	$push173=, 3
	i32.const	$push172=, 65
	call    	check@FUNCTION, $pop173, $0, $pop172
	i32.const	$push171=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop171, $0
	i32.const	$push170=, 3
	i32.const	$push169=, 66
	call    	check@FUNCTION, $pop170, $0, $pop169
	i32.const	$push168=, 1
	i32.add 	$0=, $0, $pop168
	i32.const	$push167=, 15
	i32.ne  	$push74=, $0, $pop167
	br_if   	0, $pop74       # 0: up to label30
.LBB2_38:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label31:
	loop                            # label32:
	i32.const	$push190=, 97
	i32.const	$push189=, 31
	i32.call	$discard=, memset@FUNCTION, $2, $pop190, $pop189
	i32.const	$0=, 0
	i32.const	$push75=, u+4
	i32.const	$push188=, 0
	i32.call	$3=, memset@FUNCTION, $pop75, $pop188, $1
	i32.const	$push76=, 4
	i32.const	$push187=, 0
	call    	check@FUNCTION, $pop76, $1, $pop187
	i32.const	$push186=, 0
	i32.load8_u	$push77=, A($pop186)
	i32.call	$discard=, memset@FUNCTION, $3, $pop77, $1
	i32.const	$push185=, 4
	i32.const	$push184=, 65
	call    	check@FUNCTION, $pop185, $1, $pop184
	i32.const	$push183=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop183, $1
	i32.const	$push182=, 4
	i32.const	$push181=, 66
	call    	check@FUNCTION, $pop182, $1, $pop181
	i32.const	$push180=, 1
	i32.add 	$1=, $1, $pop180
	i32.const	$3=, 0
	i32.const	$push179=, 15
	i32.ne  	$push78=, $1, $pop179
	br_if   	0, $pop78       # 0: up to label32
.LBB2_39:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label33:
	loop                            # label34:
	i32.const	$push79=, u
	i32.const	$push202=, 97
	i32.const	$push201=, 31
	i32.call	$1=, memset@FUNCTION, $pop79, $pop202, $pop201
	i32.const	$push80=, u+5
	i32.const	$push200=, 0
	i32.call	$2=, memset@FUNCTION, $pop80, $pop200, $3
	i32.const	$push81=, 5
	i32.const	$push199=, 0
	call    	check@FUNCTION, $pop81, $3, $pop199
	i32.const	$push198=, 0
	i32.load8_u	$push82=, A($pop198)
	i32.call	$discard=, memset@FUNCTION, $2, $pop82, $3
	i32.const	$push197=, 5
	i32.const	$push196=, 65
	call    	check@FUNCTION, $pop197, $3, $pop196
	i32.const	$push195=, 66
	i32.call	$discard=, memset@FUNCTION, $2, $pop195, $3
	i32.const	$push194=, 5
	i32.const	$push193=, 66
	call    	check@FUNCTION, $pop194, $3, $pop193
	i32.const	$push192=, 1
	i32.add 	$3=, $3, $pop192
	i32.const	$push191=, 15
	i32.ne  	$push83=, $3, $pop191
	br_if   	0, $pop83       # 0: up to label34
.LBB2_40:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label35:
	loop                            # label36:
	i32.const	$push214=, 97
	i32.const	$push213=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop214, $pop213
	i32.const	$push84=, u+6
	i32.const	$push212=, 0
	i32.call	$3=, memset@FUNCTION, $pop84, $pop212, $0
	i32.const	$push85=, 6
	i32.const	$push211=, 0
	call    	check@FUNCTION, $pop85, $0, $pop211
	i32.const	$push210=, 0
	i32.load8_u	$push86=, A($pop210)
	i32.call	$discard=, memset@FUNCTION, $3, $pop86, $0
	i32.const	$push209=, 6
	i32.const	$push208=, 65
	call    	check@FUNCTION, $pop209, $0, $pop208
	i32.const	$push207=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop207, $0
	i32.const	$push206=, 6
	i32.const	$push205=, 66
	call    	check@FUNCTION, $pop206, $0, $pop205
	i32.const	$push204=, 1
	i32.add 	$0=, $0, $pop204
	i32.const	$3=, 0
	i32.const	$push203=, 15
	i32.ne  	$push87=, $0, $pop203
	br_if   	0, $pop87       # 0: up to label36
.LBB2_41:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label37:
	loop                            # label38:
	i32.const	$push88=, u
	i32.const	$push90=, 97
	i32.const	$push89=, 31
	i32.call	$discard=, memset@FUNCTION, $pop88, $pop90, $pop89
	i32.const	$push91=, u+7
	i32.const	$push220=, 0
	i32.call	$1=, memset@FUNCTION, $pop91, $pop220, $3
	i32.const	$push92=, 7
	i32.const	$push219=, 0
	call    	check@FUNCTION, $pop92, $3, $pop219
	i32.const	$push218=, 0
	i32.load8_u	$push93=, A($pop218)
	i32.call	$discard=, memset@FUNCTION, $1, $pop93, $3
	i32.const	$push217=, 7
	i32.const	$push94=, 65
	call    	check@FUNCTION, $pop217, $3, $pop94
	i32.const	$push95=, 66
	i32.call	$discard=, memset@FUNCTION, $1, $pop95, $3
	i32.const	$push216=, 7
	i32.const	$push215=, 66
	call    	check@FUNCTION, $pop216, $3, $pop215
	i32.const	$push96=, 1
	i32.add 	$3=, $3, $pop96
	i32.const	$push97=, 15
	i32.ne  	$push98=, $3, $pop97
	br_if   	0, $pop98       # 0: up to label38
# BB#42:                                # %for.end149
	end_loop                        # label39:
	i32.const	$push99=, 0
	call    	exit@FUNCTION, $pop99
	unreachable
.LBB2_43:                               # %if.then10.i
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB2_44:                               # %if.then10.i242
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB2_45:                               # %if.then10.i279
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB2_46:                               # %if.then23.i
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB2_47:                               # %if.then23.i250
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB2_48:                               # %if.then23.i287
	end_block                       # label9:
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
