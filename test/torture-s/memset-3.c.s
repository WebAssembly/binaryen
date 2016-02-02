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
	i32.const	$push29=, 0
	i32.le_s	$push0=, $0, $pop29
	br_if   	$pop0, 0        # 0: down to label0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$push1=, u($5)
	i32.const	$push2=, 97
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 1        # 1: down to label2
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, u+1
	i32.add 	$3=, $5, $pop6
	i32.const	$push4=, 1
	i32.add 	$4=, $5, $pop4
	copy_local	$5=, $4
	i32.lt_s	$push5=, $4, $0
	br_if   	$pop5, 0        # 0: up to label1
	br      	2               # 2: down to label0
.LBB1_3:                                # %if.then
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %for.cond3.preheader
	end_block                       # label0:
	i32.const	$5=, 0
	copy_local	$4=, $3
	block
	i32.const	$push30=, 0
	i32.le_s	$push7=, $1, $pop30
	br_if   	$pop7, 0        # 0: down to label3
.LBB1_5:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.add 	$push8=, $3, $5
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop9, $2
	br_if   	$pop10, 1       # 1: down to label5
# BB#6:                                 # %for.inc12
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push11=, 1
	i32.add 	$5=, $5, $pop11
	i32.add 	$4=, $3, $5
	i32.lt_s	$push12=, $5, $1
	br_if   	$pop12, 0       # 0: up to label4
	br      	2               # 2: down to label3
.LBB1_7:                                # %if.then10
	end_loop                        # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %for.body19.preheader
	end_block                       # label3:
	block
	i32.load8_u	$push13=, 0($4)
	i32.const	$push31=, 97
	i32.ne  	$push14=, $pop13, $pop31
	br_if   	$pop14, 0       # 0: down to label6
# BB#9:                                 # %for.inc25
	i32.load8_u	$push15=, 1($4)
	i32.const	$push32=, 97
	i32.ne  	$push16=, $pop15, $pop32
	br_if   	$pop16, 0       # 0: down to label6
# BB#10:                                # %for.inc25.1
	i32.load8_u	$push17=, 2($4)
	i32.const	$push33=, 97
	i32.ne  	$push18=, $pop17, $pop33
	br_if   	$pop18, 0       # 0: down to label6
# BB#11:                                # %for.inc25.2
	i32.load8_u	$push19=, 3($4)
	i32.const	$push34=, 97
	i32.ne  	$push20=, $pop19, $pop34
	br_if   	$pop20, 0       # 0: down to label6
# BB#12:                                # %for.inc25.3
	i32.load8_u	$push21=, 4($4)
	i32.const	$push35=, 97
	i32.ne  	$push22=, $pop21, $pop35
	br_if   	$pop22, 0       # 0: down to label6
# BB#13:                                # %for.inc25.4
	i32.load8_u	$push23=, 5($4)
	i32.const	$push36=, 97
	i32.ne  	$push24=, $pop23, $pop36
	br_if   	$pop24, 0       # 0: down to label6
# BB#14:                                # %for.inc25.5
	i32.load8_u	$push25=, 6($4)
	i32.const	$push37=, 97
	i32.ne  	$push26=, $pop25, $pop37
	br_if   	$pop26, 0       # 0: down to label6
# BB#15:                                # %for.inc25.6
	i32.load8_u	$push27=, 7($4)
	i32.const	$push38=, 97
	i32.ne  	$push28=, $pop27, $pop38
	br_if   	$pop28, 0       # 0: down to label6
# BB#16:                                # %for.inc25.7
	return
.LBB1_17:                               # %if.then23
	end_block                       # label6:
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
                                        #     Child Loop BB2_14 Depth 2
                                        #     Child Loop BB2_26 Depth 2
	block
	block
	block
	loop                            # label10:
	i32.const	$push0=, u
	i32.const	$push107=, 97
	i32.const	$push106=, 31
	i32.call	$push1=, memset@FUNCTION, $pop0, $pop107, $pop106
	i32.const	$push105=, 0
	i32.call	$2=, memset@FUNCTION, $pop1, $pop105, $1
	i32.const	$3=, 0
	block
	i32.const	$push104=, 1
	i32.lt_s	$push2=, $1, $pop104
	tee_local	$push103=, $4=, $pop2
	br_if   	$pop103, 0      # 0: down to label12
.LBB2_2:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label13:
	i32.load8_u	$push3=, u($3)
	br_if   	$pop3, 1        # 1: down to label14
# BB#3:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push109=, u+1
	i32.add 	$2=, $3, $pop109
	i32.const	$push108=, 1
	i32.add 	$0=, $3, $pop108
	copy_local	$3=, $0
	i32.lt_s	$push4=, $0, $1
	br_if   	$pop4, 0        # 0: up to label13
	br      	2               # 2: down to label12
.LBB2_4:                                # %if.then10.i
	end_loop                        # label14:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.load8_u	$push5=, 0($2)
	i32.const	$push110=, 97
	i32.ne  	$push6=, $pop5, $pop110
	br_if   	$pop6, 4        # 4: down to label7
# BB#6:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push7=, 1($2)
	i32.const	$push111=, 97
	i32.ne  	$push8=, $pop7, $pop111
	br_if   	$pop8, 4        # 4: down to label7
# BB#7:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push9=, 2($2)
	i32.const	$push112=, 97
	i32.ne  	$push10=, $pop9, $pop112
	br_if   	$pop10, 4       # 4: down to label7
# BB#8:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push11=, 3($2)
	i32.const	$push113=, 97
	i32.ne  	$push12=, $pop11, $pop113
	br_if   	$pop12, 4       # 4: down to label7
# BB#9:                                 # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push13=, 4($2)
	i32.const	$push114=, 97
	i32.ne  	$push14=, $pop13, $pop114
	br_if   	$pop14, 4       # 4: down to label7
# BB#10:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push15=, 5($2)
	i32.const	$push115=, 97
	i32.ne  	$push16=, $pop15, $pop115
	br_if   	$pop16, 4       # 4: down to label7
# BB#11:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push17=, 6($2)
	i32.const	$push116=, 97
	i32.ne  	$push18=, $pop17, $pop116
	br_if   	$pop18, 4       # 4: down to label7
# BB#12:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push19=, 7($2)
	i32.const	$push117=, 97
	i32.ne  	$push20=, $pop19, $pop117
	br_if   	$pop20, 4       # 4: down to label7
# BB#13:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$3=, 0
	i32.const	$push21=, u
	i32.const	$push118=, 0
	i32.load8_u	$push22=, A($pop118)
	i32.call	$2=, memset@FUNCTION, $pop21, $pop22, $1
	block
	br_if   	$4, 0           # 0: down to label15
.LBB2_14:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label16:
	i32.load8_u	$push23=, u($3)
	i32.const	$push119=, 65
	i32.ne  	$push24=, $pop23, $pop119
	br_if   	$pop24, 1       # 1: down to label17
# BB#15:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_14 Depth=2
	i32.const	$push121=, u+1
	i32.add 	$2=, $3, $pop121
	i32.const	$push120=, 1
	i32.add 	$0=, $3, $pop120
	copy_local	$3=, $0
	i32.lt_s	$push25=, $0, $1
	br_if   	$pop25, 0       # 0: up to label16
	br      	2               # 2: down to label15
.LBB2_16:                               # %if.then10.i242
	end_loop                        # label17:
	call    	abort@FUNCTION
	unreachable
.LBB2_17:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i32.load8_u	$push26=, 0($2)
	i32.const	$push122=, 97
	i32.ne  	$push27=, $pop26, $pop122
	br_if   	$pop27, 3       # 3: down to label8
# BB#18:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push28=, 1($2)
	i32.const	$push123=, 97
	i32.ne  	$push29=, $pop28, $pop123
	br_if   	$pop29, 3       # 3: down to label8
# BB#19:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push30=, 2($2)
	i32.const	$push124=, 97
	i32.ne  	$push31=, $pop30, $pop124
	br_if   	$pop31, 3       # 3: down to label8
# BB#20:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push32=, 3($2)
	i32.const	$push125=, 97
	i32.ne  	$push33=, $pop32, $pop125
	br_if   	$pop33, 3       # 3: down to label8
# BB#21:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push34=, 4($2)
	i32.const	$push126=, 97
	i32.ne  	$push35=, $pop34, $pop126
	br_if   	$pop35, 3       # 3: down to label8
# BB#22:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push36=, 5($2)
	i32.const	$push127=, 97
	i32.ne  	$push37=, $pop36, $pop127
	br_if   	$pop37, 3       # 3: down to label8
# BB#23:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push38=, 6($2)
	i32.const	$push128=, 97
	i32.ne  	$push39=, $pop38, $pop128
	br_if   	$pop39, 3       # 3: down to label8
# BB#24:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push40=, 7($2)
	i32.const	$push129=, 97
	i32.ne  	$push41=, $pop40, $pop129
	br_if   	$pop41, 3       # 3: down to label8
# BB#25:                                # %check.exit272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push42=, u
	i32.const	$push130=, 66
	i32.call	$2=, memset@FUNCTION, $pop42, $pop130, $1
	i32.const	$3=, 0
	block
	br_if   	$4, 0           # 0: down to label18
.LBB2_26:                               # %for.body6.i278
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label19:
	i32.load8_u	$push43=, u($3)
	i32.const	$push131=, 66
	i32.ne  	$push44=, $pop43, $pop131
	br_if   	$pop44, 1       # 1: down to label20
# BB#27:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_26 Depth=2
	i32.const	$push133=, u+1
	i32.add 	$2=, $3, $pop133
	i32.const	$push132=, 1
	i32.add 	$0=, $3, $pop132
	copy_local	$3=, $0
	i32.lt_s	$push45=, $0, $1
	br_if   	$pop45, 0       # 0: up to label19
	br      	2               # 2: down to label18
.LBB2_28:                               # %if.then10.i279
	end_loop                        # label20:
	call    	abort@FUNCTION
	unreachable
.LBB2_29:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label18:
	i32.load8_u	$push46=, 0($2)
	i32.const	$push134=, 97
	i32.ne  	$push47=, $pop46, $pop134
	br_if   	$pop47, 2       # 2: down to label9
# BB#30:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push48=, 1($2)
	i32.const	$push135=, 97
	i32.ne  	$push49=, $pop48, $pop135
	br_if   	$pop49, 2       # 2: down to label9
# BB#31:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push50=, 2($2)
	i32.const	$push136=, 97
	i32.ne  	$push51=, $pop50, $pop136
	br_if   	$pop51, 2       # 2: down to label9
# BB#32:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push52=, 3($2)
	i32.const	$push137=, 97
	i32.ne  	$push53=, $pop52, $pop137
	br_if   	$pop53, 2       # 2: down to label9
# BB#33:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push54=, 4($2)
	i32.const	$push138=, 97
	i32.ne  	$push55=, $pop54, $pop138
	br_if   	$pop55, 2       # 2: down to label9
# BB#34:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push56=, 5($2)
	i32.const	$push139=, 97
	i32.ne  	$push57=, $pop56, $pop139
	br_if   	$pop57, 2       # 2: down to label9
# BB#35:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push58=, 6($2)
	i32.const	$push140=, 97
	i32.ne  	$push59=, $pop58, $pop140
	br_if   	$pop59, 2       # 2: down to label9
# BB#36:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push60=, 7($2)
	i32.const	$push141=, 97
	i32.ne  	$push61=, $pop60, $pop141
	br_if   	$pop61, 2       # 2: down to label9
# BB#37:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push102=, 1
	i32.add 	$1=, $1, $pop102
	i32.const	$3=, 0
	i32.const	$0=, 0
	i32.const	$push101=, 14
	i32.le_s	$push62=, $1, $pop101
	br_if   	$pop62, 0       # 0: up to label10
.LBB2_38:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label11:
	loop                            # label21:
	i32.const	$push63=, u
	i32.const	$push154=, 97
	i32.const	$push153=, 31
	i32.call	$2=, memset@FUNCTION, $pop63, $pop154, $pop153
	i32.const	$push64=, u+1
	i32.const	$push152=, 0
	i32.call	$1=, memset@FUNCTION, $pop64, $pop152, $0
	i32.const	$push151=, 1
	i32.const	$push150=, 0
	call    	check@FUNCTION, $pop151, $0, $pop150
	i32.const	$push149=, 0
	i32.load8_u	$push65=, A($pop149)
	i32.call	$discard=, memset@FUNCTION, $1, $pop65, $0
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
	i32.ne  	$push66=, $0, $pop142
	br_if   	$pop66, 0       # 0: up to label21
.LBB2_39:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label22:
	loop                            # label23:
	i32.const	$push166=, 97
	i32.const	$push165=, 31
	i32.call	$discard=, memset@FUNCTION, $2, $pop166, $pop165
	i32.const	$1=, 0
	i32.const	$push67=, u+2
	i32.const	$push164=, 0
	i32.call	$0=, memset@FUNCTION, $pop67, $pop164, $3
	i32.const	$push68=, 2
	i32.const	$push163=, 0
	call    	check@FUNCTION, $pop68, $3, $pop163
	i32.const	$push162=, 0
	i32.load8_u	$push69=, A($pop162)
	i32.call	$discard=, memset@FUNCTION, $0, $pop69, $3
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
	i32.ne  	$push70=, $3, $pop155
	br_if   	$pop70, 0       # 0: up to label23
.LBB2_40:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label24:
	loop                            # label25:
	i32.const	$push71=, u
	i32.const	$push178=, 97
	i32.const	$push177=, 31
	i32.call	$2=, memset@FUNCTION, $pop71, $pop178, $pop177
	i32.const	$push72=, u+3
	i32.const	$push176=, 0
	i32.call	$3=, memset@FUNCTION, $pop72, $pop176, $0
	i32.const	$push73=, 3
	i32.const	$push175=, 0
	call    	check@FUNCTION, $pop73, $0, $pop175
	i32.const	$push174=, 0
	i32.load8_u	$push74=, A($pop174)
	i32.call	$discard=, memset@FUNCTION, $3, $pop74, $0
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
	i32.ne  	$push75=, $0, $pop167
	br_if   	$pop75, 0       # 0: up to label25
.LBB2_41:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label26:
	loop                            # label27:
	i32.const	$push190=, 97
	i32.const	$push189=, 31
	i32.call	$discard=, memset@FUNCTION, $2, $pop190, $pop189
	i32.const	$0=, 0
	i32.const	$push76=, u+4
	i32.const	$push188=, 0
	i32.call	$3=, memset@FUNCTION, $pop76, $pop188, $1
	i32.const	$push77=, 4
	i32.const	$push187=, 0
	call    	check@FUNCTION, $pop77, $1, $pop187
	i32.const	$push186=, 0
	i32.load8_u	$push78=, A($pop186)
	i32.call	$discard=, memset@FUNCTION, $3, $pop78, $1
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
	i32.ne  	$push79=, $1, $pop179
	br_if   	$pop79, 0       # 0: up to label27
.LBB2_42:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label28:
	loop                            # label29:
	i32.const	$push80=, u
	i32.const	$push202=, 97
	i32.const	$push201=, 31
	i32.call	$1=, memset@FUNCTION, $pop80, $pop202, $pop201
	i32.const	$push81=, u+5
	i32.const	$push200=, 0
	i32.call	$2=, memset@FUNCTION, $pop81, $pop200, $3
	i32.const	$push82=, 5
	i32.const	$push199=, 0
	call    	check@FUNCTION, $pop82, $3, $pop199
	i32.const	$push198=, 0
	i32.load8_u	$push83=, A($pop198)
	i32.call	$discard=, memset@FUNCTION, $2, $pop83, $3
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
	i32.ne  	$push84=, $3, $pop191
	br_if   	$pop84, 0       # 0: up to label29
.LBB2_43:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label30:
	loop                            # label31:
	i32.const	$push214=, 97
	i32.const	$push213=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop214, $pop213
	i32.const	$push85=, u+6
	i32.const	$push212=, 0
	i32.call	$3=, memset@FUNCTION, $pop85, $pop212, $0
	i32.const	$push86=, 6
	i32.const	$push211=, 0
	call    	check@FUNCTION, $pop86, $0, $pop211
	i32.const	$push210=, 0
	i32.load8_u	$push87=, A($pop210)
	i32.call	$discard=, memset@FUNCTION, $3, $pop87, $0
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
	i32.ne  	$push88=, $0, $pop203
	br_if   	$pop88, 0       # 0: up to label31
.LBB2_44:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label32:
	loop                            # label33:
	i32.const	$push89=, u
	i32.const	$push91=, 97
	i32.const	$push90=, 31
	i32.call	$discard=, memset@FUNCTION, $pop89, $pop91, $pop90
	i32.const	$push92=, u+7
	i32.const	$push220=, 0
	i32.call	$1=, memset@FUNCTION, $pop92, $pop220, $3
	i32.const	$push93=, 7
	i32.const	$push219=, 0
	call    	check@FUNCTION, $pop93, $3, $pop219
	i32.const	$push218=, 0
	i32.load8_u	$push94=, A($pop218)
	i32.call	$discard=, memset@FUNCTION, $1, $pop94, $3
	i32.const	$push217=, 7
	i32.const	$push95=, 65
	call    	check@FUNCTION, $pop217, $3, $pop95
	i32.const	$push96=, 66
	i32.call	$discard=, memset@FUNCTION, $1, $pop96, $3
	i32.const	$push216=, 7
	i32.const	$push215=, 66
	call    	check@FUNCTION, $pop216, $3, $pop215
	i32.const	$push97=, 1
	i32.add 	$3=, $3, $pop97
	i32.const	$push98=, 15
	i32.ne  	$push99=, $3, $pop98
	br_if   	$pop99, 0       # 0: up to label33
# BB#45:                                # %for.end149
	end_loop                        # label34:
	i32.const	$push100=, 0
	call    	exit@FUNCTION, $pop100
	unreachable
.LBB2_46:                               # %if.then23.i287
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB2_47:                               # %if.then23.i250
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB2_48:                               # %if.then23.i
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
