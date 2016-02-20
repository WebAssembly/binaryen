	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-2.c"
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push105=, u
	i32.const	$push104=, 97
	i32.const	$push103=, 31
	i32.call	$discard=, memset@FUNCTION, $pop105, $pop104, $pop103
	i32.const	$push102=, 1
	i32.const	$push101=, 0
	i32.store8	$push100=, u($2), $pop101
	tee_local	$push99=, $1=, $pop100
	call    	check@FUNCTION, $2, $pop102, $pop99
	i32.load8_u	$push0=, A($1)
	i32.store8	$discard=, u($2), $pop0
	i32.const	$push98=, 1
	i32.const	$push97=, 65
	call    	check@FUNCTION, $2, $pop98, $pop97
	i32.const	$push96=, 1
	i32.const	$push95=, 66
	i32.store8	$push1=, u($2), $pop95
	call    	check@FUNCTION, $2, $pop96, $pop1
	i32.const	$push94=, 1
	i32.add 	$2=, $2, $pop94
	i32.const	$push93=, 8
	i32.ne  	$push2=, $2, $pop93
	br_if   	0, $pop2        # 0: up to label7
.LBB2_2:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label8:
	loop                            # label9:
	i32.const	$push119=, u
	i32.const	$push118=, 97
	i32.const	$push117=, 31
	i32.call	$discard=, memset@FUNCTION, $pop119, $pop118, $pop117
	i32.const	$push116=, 2
	i32.const	$push3=, 0
	i32.store16	$push115=, u($1):p2align=0, $pop3
	tee_local	$push114=, $2=, $pop115
	call    	check@FUNCTION, $1, $pop116, $pop114
	i32.load8_u	$push4=, A($2)
	i32.const	$push113=, 257
	i32.mul 	$push5=, $pop4, $pop113
	i32.store16	$discard=, u($1):p2align=0, $pop5
	i32.const	$push112=, 2
	i32.const	$push111=, 65
	call    	check@FUNCTION, $1, $pop112, $pop111
	i32.const	$push110=, 16962
	i32.store16	$discard=, u($1):p2align=0, $pop110
	i32.const	$push109=, 2
	i32.const	$push108=, 66
	call    	check@FUNCTION, $1, $pop109, $pop108
	i32.const	$push107=, 1
	i32.add 	$1=, $1, $pop107
	i32.const	$push106=, 8
	i32.ne  	$push6=, $1, $pop106
	br_if   	0, $pop6        # 0: up to label9
.LBB2_3:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label10:
	loop                            # label11:
	i32.const	$push133=, u
	i32.const	$push132=, 97
	i32.const	$push131=, 31
	i32.call	$discard=, memset@FUNCTION, $pop133, $pop132, $pop131
	i32.const	$push130=, 3
	i32.const	$push7=, 0
	i32.store8	$push8=, u+2($2), $pop7
	i32.store16	$push129=, u($2):p2align=0, $pop8
	tee_local	$push128=, $1=, $pop129
	call    	check@FUNCTION, $2, $pop130, $pop128
	i32.load8_u	$push9=, A($1)
	i32.store8	$push10=, u+2($2), $pop9
	i32.const	$push127=, 257
	i32.mul 	$push11=, $pop10, $pop127
	i32.store16	$discard=, u($2):p2align=0, $pop11
	i32.const	$push126=, 3
	i32.const	$push125=, 65
	call    	check@FUNCTION, $2, $pop126, $pop125
	i32.const	$push124=, 66
	i32.store8	$0=, u+2($2), $pop124
	i32.const	$push123=, 16962
	i32.store16	$discard=, u($2):p2align=0, $pop123
	i32.const	$push122=, 3
	call    	check@FUNCTION, $2, $pop122, $0
	i32.const	$push121=, 1
	i32.add 	$2=, $2, $pop121
	i32.const	$push120=, 8
	i32.ne  	$push12=, $2, $pop120
	br_if   	0, $pop12       # 0: up to label11
.LBB2_4:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label12:
	loop                            # label13:
	i32.const	$push147=, u
	i32.const	$push146=, 97
	i32.const	$push145=, 31
	i32.call	$discard=, memset@FUNCTION, $pop147, $pop146, $pop145
	i32.const	$push144=, 4
	i32.const	$push13=, 0
	i32.store	$push143=, u($1):p2align=0, $pop13
	tee_local	$push142=, $2=, $pop143
	call    	check@FUNCTION, $1, $pop144, $pop142
	i32.load8_u	$push14=, A($2)
	i32.const	$push141=, 16843009
	i32.mul 	$push15=, $pop14, $pop141
	i32.store	$discard=, u($1):p2align=0, $pop15
	i32.const	$push140=, 4
	i32.const	$push139=, 65
	call    	check@FUNCTION, $1, $pop140, $pop139
	i32.const	$push138=, 1111638594
	i32.store	$discard=, u($1):p2align=0, $pop138
	i32.const	$push137=, 4
	i32.const	$push136=, 66
	call    	check@FUNCTION, $1, $pop137, $pop136
	i32.const	$push135=, 1
	i32.add 	$1=, $1, $pop135
	i32.const	$push134=, 8
	i32.ne  	$push16=, $1, $pop134
	br_if   	0, $pop16       # 0: up to label13
.LBB2_5:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label14:
	loop                            # label15:
	i32.const	$push161=, u
	i32.const	$push160=, 97
	i32.const	$push159=, 31
	i32.call	$discard=, memset@FUNCTION, $pop161, $pop160, $pop159
	i32.const	$push158=, 5
	i32.const	$push17=, 0
	i32.store8	$push18=, u+4($2), $pop17
	i32.store	$push157=, u($2):p2align=0, $pop18
	tee_local	$push156=, $1=, $pop157
	call    	check@FUNCTION, $2, $pop158, $pop156
	i32.load8_u	$push19=, A($1)
	i32.store8	$push20=, u+4($2), $pop19
	i32.const	$push155=, 16843009
	i32.mul 	$push21=, $pop20, $pop155
	i32.store	$discard=, u($2):p2align=0, $pop21
	i32.const	$push154=, 5
	i32.const	$push153=, 65
	call    	check@FUNCTION, $2, $pop154, $pop153
	i32.const	$push152=, 66
	i32.store8	$0=, u+4($2), $pop152
	i32.const	$push151=, 1111638594
	i32.store	$discard=, u($2):p2align=0, $pop151
	i32.const	$push150=, 5
	call    	check@FUNCTION, $2, $pop150, $0
	i32.const	$push149=, 1
	i32.add 	$2=, $2, $pop149
	i32.const	$push148=, 8
	i32.ne  	$push22=, $2, $pop148
	br_if   	0, $pop22       # 0: up to label15
.LBB2_6:                                # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label16:
	loop                            # label17:
	i32.const	$push179=, u
	i32.const	$push178=, 97
	i32.const	$push177=, 31
	i32.call	$discard=, memset@FUNCTION, $pop179, $pop178, $pop177
	i32.const	$push176=, 6
	i32.const	$push23=, 0
	i32.store16	$push24=, u+4($1):p2align=0, $pop23
	i32.store	$push175=, u($1):p2align=0, $pop24
	tee_local	$push174=, $2=, $pop175
	call    	check@FUNCTION, $1, $pop176, $pop174
	i32.load8_u	$push173=, A($2)
	tee_local	$push172=, $0=, $pop173
	i32.const	$push171=, 257
	i32.mul 	$push25=, $pop172, $pop171
	i32.store16	$discard=, u+4($1):p2align=0, $pop25
	i32.const	$push170=, 16843009
	i32.mul 	$push26=, $0, $pop170
	i32.store	$discard=, u($1):p2align=0, $pop26
	i32.const	$push169=, 6
	i32.const	$push168=, 65
	call    	check@FUNCTION, $1, $pop169, $pop168
	i32.const	$push167=, 16962
	i32.store16	$discard=, u+4($1):p2align=0, $pop167
	i32.const	$push166=, 1111638594
	i32.store	$discard=, u($1):p2align=0, $pop166
	i32.const	$push165=, 6
	i32.const	$push164=, 66
	call    	check@FUNCTION, $1, $pop165, $pop164
	i32.const	$push163=, 1
	i32.add 	$1=, $1, $pop163
	i32.const	$push162=, 8
	i32.ne  	$push27=, $1, $pop162
	br_if   	0, $pop27       # 0: up to label17
.LBB2_7:                                # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label18:
	loop                            # label19:
	i32.const	$push197=, u
	i32.const	$push196=, 97
	i32.const	$push195=, 31
	i32.call	$discard=, memset@FUNCTION, $pop197, $pop196, $pop195
	i32.const	$push194=, 7
	i32.const	$push28=, 0
	i32.store8	$push29=, u+6($2), $pop28
	i32.store16	$push30=, u+4($2):p2align=0, $pop29
	i32.store	$push193=, u($2):p2align=0, $pop30
	tee_local	$push192=, $1=, $pop193
	call    	check@FUNCTION, $2, $pop194, $pop192
	i32.load8_u	$push31=, A($1)
	i32.store8	$push191=, u+6($2), $pop31
	tee_local	$push190=, $0=, $pop191
	i32.const	$push189=, 257
	i32.mul 	$push32=, $pop190, $pop189
	i32.store16	$discard=, u+4($2):p2align=0, $pop32
	i32.const	$push188=, 16843009
	i32.mul 	$push33=, $0, $pop188
	i32.store	$discard=, u($2):p2align=0, $pop33
	i32.const	$push187=, 7
	i32.const	$push186=, 65
	call    	check@FUNCTION, $2, $pop187, $pop186
	i32.const	$push185=, 66
	i32.store8	$0=, u+6($2), $pop185
	i32.const	$push184=, 16962
	i32.store16	$discard=, u+4($2):p2align=0, $pop184
	i32.const	$push183=, 1111638594
	i32.store	$discard=, u($2):p2align=0, $pop183
	i32.const	$push182=, 7
	call    	check@FUNCTION, $2, $pop182, $0
	i32.const	$push181=, 1
	i32.add 	$2=, $2, $pop181
	i32.const	$push180=, 8
	i32.ne  	$push34=, $2, $pop180
	br_if   	0, $pop34       # 0: up to label19
.LBB2_8:                                # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label20:
	loop                            # label21:
	i32.const	$push212=, u
	i32.const	$push211=, 97
	i32.const	$push210=, 31
	i32.call	$discard=, memset@FUNCTION, $pop212, $pop211, $pop210
	i32.const	$2=, 0
	i64.const	$push209=, 0
	i64.store	$discard=, u($1):p2align=0, $pop209
	i32.const	$push208=, 8
	i32.const	$push207=, 0
	call    	check@FUNCTION, $1, $pop208, $pop207
	i32.const	$push206=, 0
	i32.load8_u	$push35=, A($pop206)
	i32.const	$push205=, 16843009
	i32.mul 	$push36=, $pop35, $pop205
	i32.store	$push37=, u+4($1):p2align=0, $pop36
	i32.store	$discard=, u($1):p2align=0, $pop37
	i32.const	$push204=, 8
	i32.const	$push203=, 65
	call    	check@FUNCTION, $1, $pop204, $pop203
	i64.const	$push202=, 4774451407313060418
	i64.store	$discard=, u($1):p2align=0, $pop202
	i32.const	$push201=, 8
	i32.const	$push200=, 66
	call    	check@FUNCTION, $1, $pop201, $pop200
	i32.const	$push199=, 1
	i32.add 	$1=, $1, $pop199
	i32.const	$push198=, 8
	i32.ne  	$push38=, $1, $pop198
	br_if   	0, $pop38       # 0: up to label21
.LBB2_9:                                # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label22:
	loop                            # label23:
	i32.const	$push226=, u
	i32.const	$push225=, 97
	i32.const	$push224=, 31
	i32.call	$discard=, memset@FUNCTION, $pop226, $pop225, $pop224
	i32.const	$push223=, 9
	i32.const	$push39=, 0
	i32.store8	$push40=, u+8($2), $pop39
	i32.store	$push41=, u+4($2):p2align=0, $pop40
	i32.store	$push222=, u($2):p2align=0, $pop41
	tee_local	$push221=, $1=, $pop222
	call    	check@FUNCTION, $2, $pop223, $pop221
	i32.load8_u	$push42=, A($1)
	i32.store8	$push43=, u+8($2), $pop42
	i32.const	$push220=, 16843009
	i32.mul 	$push44=, $pop43, $pop220
	i32.store	$push45=, u+4($2):p2align=0, $pop44
	i32.store	$discard=, u($2):p2align=0, $pop45
	i32.const	$push219=, 9
	i32.const	$push218=, 65
	call    	check@FUNCTION, $2, $pop219, $pop218
	i32.const	$push217=, 66
	i32.store8	$0=, u+8($2), $pop217
	i32.const	$push216=, 1111638594
	i32.store	$push46=, u+4($2):p2align=0, $pop216
	i32.store	$discard=, u($2):p2align=0, $pop46
	i32.const	$push215=, 9
	call    	check@FUNCTION, $2, $pop215, $0
	i32.const	$push214=, 1
	i32.add 	$2=, $2, $pop214
	i32.const	$push213=, 8
	i32.ne  	$push47=, $2, $pop213
	br_if   	0, $pop47       # 0: up to label23
.LBB2_10:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label24:
	loop                            # label25:
	i32.const	$push244=, u
	i32.const	$push243=, 97
	i32.const	$push242=, 31
	i32.call	$discard=, memset@FUNCTION, $pop244, $pop243, $pop242
	i32.const	$push241=, 10
	i32.const	$push48=, 0
	i32.store16	$push49=, u+8($1):p2align=0, $pop48
	i32.store	$push50=, u+4($1):p2align=0, $pop49
	i32.store	$push240=, u($1):p2align=0, $pop50
	tee_local	$push239=, $2=, $pop240
	call    	check@FUNCTION, $1, $pop241, $pop239
	i32.load8_u	$push238=, A($2)
	tee_local	$push237=, $0=, $pop238
	i32.const	$push236=, 257
	i32.mul 	$push51=, $pop237, $pop236
	i32.store16	$discard=, u+8($1):p2align=0, $pop51
	i32.const	$push235=, 16843009
	i32.mul 	$push52=, $0, $pop235
	i32.store	$push53=, u+4($1):p2align=0, $pop52
	i32.store	$discard=, u($1):p2align=0, $pop53
	i32.const	$push234=, 10
	i32.const	$push233=, 65
	call    	check@FUNCTION, $1, $pop234, $pop233
	i32.const	$push232=, 16962
	i32.store16	$discard=, u+8($1):p2align=0, $pop232
	i32.const	$push231=, 1111638594
	i32.store	$push54=, u+4($1):p2align=0, $pop231
	i32.store	$discard=, u($1):p2align=0, $pop54
	i32.const	$push230=, 10
	i32.const	$push229=, 66
	call    	check@FUNCTION, $1, $pop230, $pop229
	i32.const	$push228=, 1
	i32.add 	$1=, $1, $pop228
	i32.const	$push227=, 8
	i32.ne  	$push55=, $1, $pop227
	br_if   	0, $pop55       # 0: up to label25
.LBB2_11:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label26:
	loop                            # label27:
	i32.const	$push262=, u
	i32.const	$push261=, 97
	i32.const	$push260=, 31
	i32.call	$discard=, memset@FUNCTION, $pop262, $pop261, $pop260
	i32.const	$push259=, 11
	i32.const	$push56=, 0
	i32.store8	$push57=, u+10($2), $pop56
	i32.store16	$push58=, u+8($2):p2align=0, $pop57
	i32.store	$push59=, u+4($2):p2align=0, $pop58
	i32.store	$push258=, u($2):p2align=0, $pop59
	tee_local	$push257=, $1=, $pop258
	call    	check@FUNCTION, $2, $pop259, $pop257
	i32.load8_u	$push60=, A($1)
	i32.store8	$push256=, u+10($2), $pop60
	tee_local	$push255=, $0=, $pop256
	i32.const	$push254=, 257
	i32.mul 	$push61=, $pop255, $pop254
	i32.store16	$discard=, u+8($2):p2align=0, $pop61
	i32.const	$push253=, 16843009
	i32.mul 	$push62=, $0, $pop253
	i32.store	$push63=, u+4($2):p2align=0, $pop62
	i32.store	$discard=, u($2):p2align=0, $pop63
	i32.const	$push252=, 11
	i32.const	$push251=, 65
	call    	check@FUNCTION, $2, $pop252, $pop251
	i32.const	$push250=, 66
	i32.store8	$0=, u+10($2), $pop250
	i32.const	$push249=, 16962
	i32.store16	$discard=, u+8($2):p2align=0, $pop249
	i32.const	$push248=, 1111638594
	i32.store	$push64=, u+4($2):p2align=0, $pop248
	i32.store	$discard=, u($2):p2align=0, $pop64
	i32.const	$push247=, 11
	call    	check@FUNCTION, $2, $pop247, $0
	i32.const	$push246=, 1
	i32.add 	$2=, $2, $pop246
	i32.const	$push245=, 8
	i32.ne  	$push65=, $2, $pop245
	br_if   	0, $pop65       # 0: up to label27
.LBB2_12:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label28:
	loop                            # label29:
	i32.const	$push278=, u
	i32.const	$push277=, 97
	i32.const	$push276=, 31
	i32.call	$discard=, memset@FUNCTION, $pop278, $pop277, $pop276
	i64.const	$push275=, 0
	i64.store	$discard=, u+4($1):p2align=0, $pop275
	i32.const	$push274=, 12
	i32.const	$push66=, 0
	i32.store	$push273=, u($1):p2align=0, $pop66
	tee_local	$push272=, $2=, $pop273
	call    	check@FUNCTION, $1, $pop274, $pop272
	i32.load8_u	$push67=, A($2)
	i32.const	$push271=, 16843009
	i32.mul 	$push68=, $pop67, $pop271
	i32.store	$push69=, u+8($1):p2align=0, $pop68
	i32.store	$push70=, u+4($1):p2align=0, $pop69
	i32.store	$discard=, u($1):p2align=0, $pop70
	i32.const	$push270=, 12
	i32.const	$push269=, 65
	call    	check@FUNCTION, $1, $pop270, $pop269
	i64.const	$push268=, 4774451407313060418
	i64.store	$discard=, u+4($1):p2align=0, $pop268
	i32.const	$push267=, 1111638594
	i32.store	$discard=, u($1):p2align=0, $pop267
	i32.const	$push266=, 12
	i32.const	$push265=, 66
	call    	check@FUNCTION, $1, $pop266, $pop265
	i32.const	$push264=, 1
	i32.add 	$1=, $1, $pop264
	i32.const	$push263=, 8
	i32.ne  	$push71=, $1, $pop263
	br_if   	0, $pop71       # 0: up to label29
.LBB2_13:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label30:
	loop                            # label31:
	i32.const	$push294=, u
	i32.const	$push293=, 97
	i32.const	$push292=, 31
	i32.call	$discard=, memset@FUNCTION, $pop294, $pop293, $pop292
	i32.const	$push72=, 0
	i32.store8	$1=, u+12($2), $pop72
	i64.const	$push291=, 0
	i64.store	$discard=, u+4($2):p2align=0, $pop291
	i32.const	$push290=, 13
	i32.store	$push289=, u($2):p2align=0, $1
	tee_local	$push288=, $1=, $pop289
	call    	check@FUNCTION, $2, $pop290, $pop288
	i32.load8_u	$push73=, A($1)
	i32.store8	$push74=, u+12($2), $pop73
	i32.const	$push287=, 16843009
	i32.mul 	$push75=, $pop74, $pop287
	i32.store	$push76=, u+8($2):p2align=0, $pop75
	i32.store	$push77=, u+4($2):p2align=0, $pop76
	i32.store	$discard=, u($2):p2align=0, $pop77
	i32.const	$push286=, 13
	i32.const	$push285=, 65
	call    	check@FUNCTION, $2, $pop286, $pop285
	i32.const	$push284=, 66
	i32.store8	$0=, u+12($2), $pop284
	i64.const	$push283=, 4774451407313060418
	i64.store	$discard=, u+4($2):p2align=0, $pop283
	i32.const	$push282=, 1111638594
	i32.store	$discard=, u($2):p2align=0, $pop282
	i32.const	$push281=, 13
	call    	check@FUNCTION, $2, $pop281, $0
	i32.const	$push280=, 1
	i32.add 	$2=, $2, $pop280
	i32.const	$push279=, 8
	i32.ne  	$push78=, $2, $pop279
	br_if   	0, $pop78       # 0: up to label31
.LBB2_14:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label32:
	loop                            # label33:
	i32.const	$push314=, u
	i32.const	$push313=, 97
	i32.const	$push312=, 31
	i32.call	$discard=, memset@FUNCTION, $pop314, $pop313, $pop312
	i32.const	$push79=, 0
	i32.store16	$2=, u+12($1):p2align=0, $pop79
	i64.const	$push311=, 0
	i64.store	$discard=, u+4($1):p2align=0, $pop311
	i32.const	$push310=, 14
	i32.store	$push309=, u($1):p2align=0, $2
	tee_local	$push308=, $2=, $pop309
	call    	check@FUNCTION, $1, $pop310, $pop308
	i32.load8_u	$push307=, A($2)
	tee_local	$push306=, $0=, $pop307
	i32.const	$push305=, 257
	i32.mul 	$push80=, $pop306, $pop305
	i32.store16	$discard=, u+12($1):p2align=0, $pop80
	i32.const	$push304=, 16843009
	i32.mul 	$push81=, $0, $pop304
	i32.store	$push82=, u+8($1):p2align=0, $pop81
	i32.store	$push83=, u+4($1):p2align=0, $pop82
	i32.store	$discard=, u($1):p2align=0, $pop83
	i32.const	$push303=, 14
	i32.const	$push302=, 65
	call    	check@FUNCTION, $1, $pop303, $pop302
	i32.const	$push301=, 16962
	i32.store16	$discard=, u+12($1):p2align=0, $pop301
	i64.const	$push300=, 4774451407313060418
	i64.store	$discard=, u+4($1):p2align=0, $pop300
	i32.const	$push299=, 1111638594
	i32.store	$discard=, u($1):p2align=0, $pop299
	i32.const	$push298=, 14
	i32.const	$push297=, 66
	call    	check@FUNCTION, $1, $pop298, $pop297
	i32.const	$push296=, 1
	i32.add 	$1=, $1, $pop296
	i32.const	$push295=, 8
	i32.ne  	$push84=, $1, $pop295
	br_if   	0, $pop84       # 0: up to label33
.LBB2_15:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label34:
	loop                            # label35:
	i32.const	$push335=, u
	i32.const	$push334=, 97
	i32.const	$push333=, 31
	i32.call	$discard=, memset@FUNCTION, $pop335, $pop334, $pop333
	i32.const	$push332=, 0
	i32.store8	$push85=, u+14($2), $pop332
	i32.store16	$1=, u+12($2):p2align=0, $pop85
	i64.const	$push331=, 0
	i64.store	$discard=, u+4($2):p2align=0, $pop331
	i32.const	$push330=, 15
	i32.store	$push329=, u($2):p2align=0, $1
	tee_local	$push328=, $1=, $pop329
	call    	check@FUNCTION, $2, $pop330, $pop328
	i32.load8_u	$push86=, A($1)
	i32.store8	$push327=, u+14($2), $pop86
	tee_local	$push326=, $1=, $pop327
	i32.const	$push325=, 257
	i32.mul 	$push87=, $pop326, $pop325
	i32.store16	$discard=, u+12($2):p2align=0, $pop87
	i32.const	$push324=, 16843009
	i32.mul 	$push88=, $1, $pop324
	i32.store	$push89=, u+8($2):p2align=0, $pop88
	i32.store	$push90=, u+4($2):p2align=0, $pop89
	i32.store	$discard=, u($2):p2align=0, $pop90
	i32.const	$push323=, 15
	i32.const	$push322=, 65
	call    	check@FUNCTION, $2, $pop323, $pop322
	i32.const	$push321=, 66
	i32.store8	$1=, u+14($2), $pop321
	i32.const	$push320=, 16962
	i32.store16	$discard=, u+12($2):p2align=0, $pop320
	i64.const	$push319=, 4774451407313060418
	i64.store	$discard=, u+4($2):p2align=0, $pop319
	i32.const	$push318=, 1111638594
	i32.store	$discard=, u($2):p2align=0, $pop318
	i32.const	$push317=, 15
	call    	check@FUNCTION, $2, $pop317, $1
	i32.const	$push316=, 1
	i32.add 	$2=, $2, $pop316
	i32.const	$push315=, 8
	i32.ne  	$push91=, $2, $pop315
	br_if   	0, $pop91       # 0: up to label35
# BB#16:                                # %for.end378
	end_loop                        # label36:
	i32.const	$push92=, 0
	call    	exit@FUNCTION, $pop92
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
