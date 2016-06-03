	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-2.c"
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push95=, u
	i32.const	$push94=, 97
	i32.const	$push93=, 31
	i32.call	$drop=, memset@FUNCTION, $pop95, $pop94, $pop93
	i32.const	$push92=, 1
	i32.const	$push91=, 0
	i32.store8	$push90=, u($1), $pop91
	tee_local	$push89=, $0=, $pop90
	call    	check@FUNCTION, $1, $pop92, $pop89
	i32.load8_u	$push33=, A($0)
	i32.store8	$drop=, u($1), $pop33
	i32.const	$push88=, 1
	i32.const	$push87=, 65
	call    	check@FUNCTION, $1, $pop88, $pop87
	i32.const	$push86=, 1
	i32.const	$push85=, 66
	i32.store8	$push0=, u($1), $pop85
	call    	check@FUNCTION, $1, $pop86, $pop0
	i32.const	$push84=, 1
	i32.add 	$push83=, $1, $pop84
	tee_local	$push82=, $1=, $pop83
	i32.const	$push81=, 8
	i32.ne  	$push34=, $pop82, $pop81
	br_if   	0, $pop34       # 0: up to label7
# BB#2:                                 # %for.body18.preheader
	end_loop                        # label8:
	i32.const	$1=, 0
.LBB2_3:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.const	$push112=, u
	i32.const	$push111=, 97
	i32.const	$push110=, 31
	i32.call	$drop=, memset@FUNCTION, $pop112, $pop111, $pop110
	i32.const	$push109=, 2
	i32.const	$push108=, 0
	i32.store16	$push107=, u($1):p2align=0, $pop108
	tee_local	$push106=, $0=, $pop107
	call    	check@FUNCTION, $1, $pop109, $pop106
	i32.load8_u	$push35=, A($0)
	i32.const	$push105=, 257
	i32.mul 	$push36=, $pop35, $pop105
	i32.store16	$drop=, u($1):p2align=0, $pop36
	i32.const	$push104=, 2
	i32.const	$push103=, 65
	call    	check@FUNCTION, $1, $pop104, $pop103
	i32.const	$push102=, 16962
	i32.store16	$drop=, u($1):p2align=0, $pop102
	i32.const	$push101=, 2
	i32.const	$push100=, 66
	call    	check@FUNCTION, $1, $pop101, $pop100
	i32.const	$push99=, 1
	i32.add 	$push98=, $1, $pop99
	tee_local	$push97=, $1=, $pop98
	i32.const	$push96=, 8
	i32.ne  	$push37=, $pop97, $pop96
	br_if   	0, $pop37       # 0: up to label9
# BB#4:                                 # %for.body44.preheader
	end_loop                        # label10:
	i32.const	$1=, 0
.LBB2_5:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	i32.const	$push129=, u
	i32.const	$push128=, 97
	i32.const	$push127=, 31
	i32.call	$drop=, memset@FUNCTION, $pop129, $pop128, $pop127
	i32.const	$push126=, 3
	i32.const	$push125=, 0
	i32.store8	$push1=, u+2($1), $pop125
	i32.store16	$push124=, u($1):p2align=0, $pop1
	tee_local	$push123=, $0=, $pop124
	call    	check@FUNCTION, $1, $pop126, $pop123
	i32.load8_u	$push38=, A($0)
	i32.store8	$push2=, u+2($1), $pop38
	i32.const	$push122=, 257
	i32.mul 	$push39=, $pop2, $pop122
	i32.store16	$drop=, u($1):p2align=0, $pop39
	i32.const	$push121=, 3
	i32.const	$push120=, 65
	call    	check@FUNCTION, $1, $pop121, $pop120
	i32.const	$push119=, 66
	i32.store8	$0=, u+2($1), $pop119
	i32.const	$push118=, 16962
	i32.store16	$drop=, u($1):p2align=0, $pop118
	i32.const	$push117=, 3
	call    	check@FUNCTION, $1, $pop117, $0
	i32.const	$push116=, 1
	i32.add 	$push115=, $1, $pop116
	tee_local	$push114=, $1=, $pop115
	i32.const	$push113=, 8
	i32.ne  	$push40=, $pop114, $pop113
	br_if   	0, $pop40       # 0: up to label11
# BB#6:                                 # %for.body70.preheader
	end_loop                        # label12:
	i32.const	$1=, 0
.LBB2_7:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$push146=, u
	i32.const	$push145=, 97
	i32.const	$push144=, 31
	i32.call	$drop=, memset@FUNCTION, $pop146, $pop145, $pop144
	i32.const	$push143=, 4
	i32.const	$push142=, 0
	i32.store	$push141=, u($1):p2align=0, $pop142
	tee_local	$push140=, $0=, $pop141
	call    	check@FUNCTION, $1, $pop143, $pop140
	i32.load8_u	$push41=, A($0)
	i32.const	$push139=, 16843009
	i32.mul 	$push42=, $pop41, $pop139
	i32.store	$drop=, u($1):p2align=0, $pop42
	i32.const	$push138=, 4
	i32.const	$push137=, 65
	call    	check@FUNCTION, $1, $pop138, $pop137
	i32.const	$push136=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop136
	i32.const	$push135=, 4
	i32.const	$push134=, 66
	call    	check@FUNCTION, $1, $pop135, $pop134
	i32.const	$push133=, 1
	i32.add 	$push132=, $1, $pop133
	tee_local	$push131=, $1=, $pop132
	i32.const	$push130=, 8
	i32.ne  	$push43=, $pop131, $pop130
	br_if   	0, $pop43       # 0: up to label13
# BB#8:                                 # %for.body96.preheader
	end_loop                        # label14:
	i32.const	$1=, 0
.LBB2_9:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push163=, u
	i32.const	$push162=, 97
	i32.const	$push161=, 31
	i32.call	$drop=, memset@FUNCTION, $pop163, $pop162, $pop161
	i32.const	$push160=, 5
	i32.const	$push159=, 0
	i32.store8	$push3=, u+4($1), $pop159
	i32.store	$push158=, u($1):p2align=0, $pop3
	tee_local	$push157=, $0=, $pop158
	call    	check@FUNCTION, $1, $pop160, $pop157
	i32.load8_u	$push44=, A($0)
	i32.store8	$push4=, u+4($1), $pop44
	i32.const	$push156=, 16843009
	i32.mul 	$push45=, $pop4, $pop156
	i32.store	$drop=, u($1):p2align=0, $pop45
	i32.const	$push155=, 5
	i32.const	$push154=, 65
	call    	check@FUNCTION, $1, $pop155, $pop154
	i32.const	$push153=, 66
	i32.store8	$0=, u+4($1), $pop153
	i32.const	$push152=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop152
	i32.const	$push151=, 5
	call    	check@FUNCTION, $1, $pop151, $0
	i32.const	$push150=, 1
	i32.add 	$push149=, $1, $pop150
	tee_local	$push148=, $1=, $pop149
	i32.const	$push147=, 8
	i32.ne  	$push46=, $pop148, $pop147
	br_if   	0, $pop46       # 0: up to label15
# BB#10:                                # %for.body122.preheader
	end_loop                        # label16:
	i32.const	$1=, 0
.LBB2_11:                               # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label17:
	i32.const	$push184=, u
	i32.const	$push183=, 97
	i32.const	$push182=, 31
	i32.call	$drop=, memset@FUNCTION, $pop184, $pop183, $pop182
	i32.const	$push181=, 6
	i32.const	$push180=, 0
	i32.store16	$push5=, u+4($1):p2align=0, $pop180
	i32.store	$push179=, u($1):p2align=0, $pop5
	tee_local	$push178=, $0=, $pop179
	call    	check@FUNCTION, $1, $pop181, $pop178
	i32.load8_u	$push177=, A($0)
	tee_local	$push176=, $0=, $pop177
	i32.const	$push175=, 257
	i32.mul 	$push47=, $pop176, $pop175
	i32.store16	$drop=, u+4($1):p2align=0, $pop47
	i32.const	$push174=, 16843009
	i32.mul 	$push48=, $0, $pop174
	i32.store	$drop=, u($1):p2align=0, $pop48
	i32.const	$push173=, 6
	i32.const	$push172=, 65
	call    	check@FUNCTION, $1, $pop173, $pop172
	i32.const	$push171=, 16962
	i32.store16	$drop=, u+4($1):p2align=0, $pop171
	i32.const	$push170=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop170
	i32.const	$push169=, 6
	i32.const	$push168=, 66
	call    	check@FUNCTION, $1, $pop169, $pop168
	i32.const	$push167=, 1
	i32.add 	$push166=, $1, $pop167
	tee_local	$push165=, $1=, $pop166
	i32.const	$push164=, 8
	i32.ne  	$push49=, $pop165, $pop164
	br_if   	0, $pop49       # 0: up to label17
# BB#12:                                # %for.body148.preheader
	end_loop                        # label18:
	i32.const	$1=, 0
.LBB2_13:                               # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push205=, u
	i32.const	$push204=, 97
	i32.const	$push203=, 31
	i32.call	$drop=, memset@FUNCTION, $pop205, $pop204, $pop203
	i32.const	$push202=, 7
	i32.const	$push201=, 0
	i32.store8	$push6=, u+6($1), $pop201
	i32.store16	$push7=, u+4($1):p2align=0, $pop6
	i32.store	$push200=, u($1):p2align=0, $pop7
	tee_local	$push199=, $0=, $pop200
	call    	check@FUNCTION, $1, $pop202, $pop199
	i32.load8_u	$push50=, A($0)
	i32.store8	$push198=, u+6($1), $pop50
	tee_local	$push197=, $0=, $pop198
	i32.const	$push196=, 257
	i32.mul 	$push51=, $pop197, $pop196
	i32.store16	$drop=, u+4($1):p2align=0, $pop51
	i32.const	$push195=, 16843009
	i32.mul 	$push52=, $0, $pop195
	i32.store	$drop=, u($1):p2align=0, $pop52
	i32.const	$push194=, 7
	i32.const	$push193=, 65
	call    	check@FUNCTION, $1, $pop194, $pop193
	i32.const	$push192=, 66
	i32.store8	$0=, u+6($1), $pop192
	i32.const	$push191=, 16962
	i32.store16	$drop=, u+4($1):p2align=0, $pop191
	i32.const	$push190=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop190
	i32.const	$push189=, 7
	call    	check@FUNCTION, $1, $pop189, $0
	i32.const	$push188=, 1
	i32.add 	$push187=, $1, $pop188
	tee_local	$push186=, $1=, $pop187
	i32.const	$push185=, 8
	i32.ne  	$push53=, $pop186, $pop185
	br_if   	0, $pop53       # 0: up to label19
# BB#14:                                # %for.body174.preheader
	end_loop                        # label20:
	i32.const	$1=, 0
.LBB2_15:                               # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label21:
	i32.const	$push222=, u
	i32.const	$push221=, 97
	i32.const	$push220=, 31
	i32.call	$drop=, memset@FUNCTION, $pop222, $pop221, $pop220
	i64.const	$push219=, 0
	i64.store	$drop=, u($1):p2align=0, $pop219
	i32.const	$push218=, 8
	i32.const	$push217=, 0
	call    	check@FUNCTION, $1, $pop218, $pop217
	i32.const	$push216=, 0
	i32.load8_u	$push54=, A($pop216)
	i32.const	$push215=, 16843009
	i32.mul 	$push55=, $pop54, $pop215
	i32.store	$push8=, u+4($1):p2align=0, $pop55
	i32.store	$drop=, u($1):p2align=0, $pop8
	i32.const	$push214=, 8
	i32.const	$push213=, 65
	call    	check@FUNCTION, $1, $pop214, $pop213
	i64.const	$push212=, 4774451407313060418
	i64.store	$drop=, u($1):p2align=0, $pop212
	i32.const	$push211=, 8
	i32.const	$push210=, 66
	call    	check@FUNCTION, $1, $pop211, $pop210
	i32.const	$push209=, 1
	i32.add 	$push208=, $1, $pop209
	tee_local	$push207=, $1=, $pop208
	i32.const	$push206=, 8
	i32.ne  	$push56=, $pop207, $pop206
	br_if   	0, $pop56       # 0: up to label21
# BB#16:                                # %for.body200.preheader
	end_loop                        # label22:
	i32.const	$1=, 0
.LBB2_17:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label23:
	i32.const	$push239=, u
	i32.const	$push238=, 97
	i32.const	$push237=, 31
	i32.call	$drop=, memset@FUNCTION, $pop239, $pop238, $pop237
	i32.const	$push236=, 9
	i32.const	$push235=, 0
	i32.store8	$push9=, u+8($1), $pop235
	i32.store	$push10=, u+4($1):p2align=0, $pop9
	i32.store	$push234=, u($1):p2align=0, $pop10
	tee_local	$push233=, $0=, $pop234
	call    	check@FUNCTION, $1, $pop236, $pop233
	i32.load8_u	$push57=, A($0)
	i32.store8	$push11=, u+8($1), $pop57
	i32.const	$push232=, 16843009
	i32.mul 	$push58=, $pop11, $pop232
	i32.store	$push12=, u+4($1):p2align=0, $pop58
	i32.store	$drop=, u($1):p2align=0, $pop12
	i32.const	$push231=, 9
	i32.const	$push230=, 65
	call    	check@FUNCTION, $1, $pop231, $pop230
	i32.const	$push229=, 66
	i32.store8	$0=, u+8($1), $pop229
	i32.const	$push228=, 1111638594
	i32.store	$push13=, u+4($1):p2align=0, $pop228
	i32.store	$drop=, u($1):p2align=0, $pop13
	i32.const	$push227=, 9
	call    	check@FUNCTION, $1, $pop227, $0
	i32.const	$push226=, 1
	i32.add 	$push225=, $1, $pop226
	tee_local	$push224=, $1=, $pop225
	i32.const	$push223=, 8
	i32.ne  	$push59=, $pop224, $pop223
	br_if   	0, $pop59       # 0: up to label23
# BB#18:                                # %for.body226.preheader
	end_loop                        # label24:
	i32.const	$1=, 0
.LBB2_19:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$push260=, u
	i32.const	$push259=, 97
	i32.const	$push258=, 31
	i32.call	$drop=, memset@FUNCTION, $pop260, $pop259, $pop258
	i32.const	$push257=, 10
	i32.const	$push256=, 0
	i32.store16	$push14=, u+8($1):p2align=0, $pop256
	i32.store	$push15=, u+4($1):p2align=0, $pop14
	i32.store	$push255=, u($1):p2align=0, $pop15
	tee_local	$push254=, $0=, $pop255
	call    	check@FUNCTION, $1, $pop257, $pop254
	i32.load8_u	$push253=, A($0)
	tee_local	$push252=, $0=, $pop253
	i32.const	$push251=, 257
	i32.mul 	$push60=, $pop252, $pop251
	i32.store16	$drop=, u+8($1):p2align=0, $pop60
	i32.const	$push250=, 16843009
	i32.mul 	$push61=, $0, $pop250
	i32.store	$push16=, u+4($1):p2align=0, $pop61
	i32.store	$drop=, u($1):p2align=0, $pop16
	i32.const	$push249=, 10
	i32.const	$push248=, 65
	call    	check@FUNCTION, $1, $pop249, $pop248
	i32.const	$push247=, 16962
	i32.store16	$drop=, u+8($1):p2align=0, $pop247
	i32.const	$push246=, 1111638594
	i32.store	$push17=, u+4($1):p2align=0, $pop246
	i32.store	$drop=, u($1):p2align=0, $pop17
	i32.const	$push245=, 10
	i32.const	$push244=, 66
	call    	check@FUNCTION, $1, $pop245, $pop244
	i32.const	$push243=, 1
	i32.add 	$push242=, $1, $pop243
	tee_local	$push241=, $1=, $pop242
	i32.const	$push240=, 8
	i32.ne  	$push62=, $pop241, $pop240
	br_if   	0, $pop62       # 0: up to label25
# BB#20:                                # %for.body252.preheader
	end_loop                        # label26:
	i32.const	$1=, 0
.LBB2_21:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	i32.const	$push281=, u
	i32.const	$push280=, 97
	i32.const	$push279=, 31
	i32.call	$drop=, memset@FUNCTION, $pop281, $pop280, $pop279
	i32.const	$push278=, 11
	i32.const	$push277=, 0
	i32.store8	$push18=, u+10($1), $pop277
	i32.store16	$push19=, u+8($1):p2align=0, $pop18
	i32.store	$push20=, u+4($1):p2align=0, $pop19
	i32.store	$push276=, u($1):p2align=0, $pop20
	tee_local	$push275=, $0=, $pop276
	call    	check@FUNCTION, $1, $pop278, $pop275
	i32.load8_u	$push63=, A($0)
	i32.store8	$push274=, u+10($1), $pop63
	tee_local	$push273=, $0=, $pop274
	i32.const	$push272=, 257
	i32.mul 	$push64=, $pop273, $pop272
	i32.store16	$drop=, u+8($1):p2align=0, $pop64
	i32.const	$push271=, 16843009
	i32.mul 	$push65=, $0, $pop271
	i32.store	$push21=, u+4($1):p2align=0, $pop65
	i32.store	$drop=, u($1):p2align=0, $pop21
	i32.const	$push270=, 11
	i32.const	$push269=, 65
	call    	check@FUNCTION, $1, $pop270, $pop269
	i32.const	$push268=, 66
	i32.store8	$0=, u+10($1), $pop268
	i32.const	$push267=, 16962
	i32.store16	$drop=, u+8($1):p2align=0, $pop267
	i32.const	$push266=, 1111638594
	i32.store	$push22=, u+4($1):p2align=0, $pop266
	i32.store	$drop=, u($1):p2align=0, $pop22
	i32.const	$push265=, 11
	call    	check@FUNCTION, $1, $pop265, $0
	i32.const	$push264=, 1
	i32.add 	$push263=, $1, $pop264
	tee_local	$push262=, $1=, $pop263
	i32.const	$push261=, 8
	i32.ne  	$push66=, $pop262, $pop261
	br_if   	0, $pop66       # 0: up to label27
# BB#22:                                # %for.body278.preheader
	end_loop                        # label28:
	i32.const	$1=, 0
.LBB2_23:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label29:
	i32.const	$push300=, u
	i32.const	$push299=, 97
	i32.const	$push298=, 31
	i32.call	$drop=, memset@FUNCTION, $pop300, $pop299, $pop298
	i64.const	$push297=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop297
	i32.const	$push296=, 12
	i32.const	$push295=, 0
	i32.store	$push294=, u($1):p2align=0, $pop295
	tee_local	$push293=, $0=, $pop294
	call    	check@FUNCTION, $1, $pop296, $pop293
	i32.load8_u	$push67=, A($0)
	i32.const	$push292=, 16843009
	i32.mul 	$push68=, $pop67, $pop292
	i32.store	$push23=, u+8($1):p2align=0, $pop68
	i32.store	$push24=, u+4($1):p2align=0, $pop23
	i32.store	$drop=, u($1):p2align=0, $pop24
	i32.const	$push291=, 12
	i32.const	$push290=, 65
	call    	check@FUNCTION, $1, $pop291, $pop290
	i64.const	$push289=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop289
	i32.const	$push288=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop288
	i32.const	$push287=, 12
	i32.const	$push286=, 66
	call    	check@FUNCTION, $1, $pop287, $pop286
	i32.const	$push285=, 1
	i32.add 	$push284=, $1, $pop285
	tee_local	$push283=, $1=, $pop284
	i32.const	$push282=, 8
	i32.ne  	$push69=, $pop283, $pop282
	br_if   	0, $pop69       # 0: up to label29
# BB#24:                                # %for.body304.preheader
	end_loop                        # label30:
	i32.const	$1=, 0
.LBB2_25:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push319=, u
	i32.const	$push318=, 97
	i32.const	$push317=, 31
	i32.call	$drop=, memset@FUNCTION, $pop319, $pop318, $pop317
	i32.const	$push316=, 0
	i32.store8	$0=, u+12($1), $pop316
	i64.const	$push315=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop315
	i32.const	$push314=, 13
	i32.store	$push313=, u($1):p2align=0, $0
	tee_local	$push312=, $0=, $pop313
	call    	check@FUNCTION, $1, $pop314, $pop312
	i32.load8_u	$push70=, A($0)
	i32.store8	$push25=, u+12($1), $pop70
	i32.const	$push311=, 16843009
	i32.mul 	$push71=, $pop25, $pop311
	i32.store	$push26=, u+8($1):p2align=0, $pop71
	i32.store	$push27=, u+4($1):p2align=0, $pop26
	i32.store	$drop=, u($1):p2align=0, $pop27
	i32.const	$push310=, 13
	i32.const	$push309=, 65
	call    	check@FUNCTION, $1, $pop310, $pop309
	i32.const	$push308=, 66
	i32.store8	$0=, u+12($1), $pop308
	i64.const	$push307=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop307
	i32.const	$push306=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop306
	i32.const	$push305=, 13
	call    	check@FUNCTION, $1, $pop305, $0
	i32.const	$push304=, 1
	i32.add 	$push303=, $1, $pop304
	tee_local	$push302=, $1=, $pop303
	i32.const	$push301=, 8
	i32.ne  	$push72=, $pop302, $pop301
	br_if   	0, $pop72       # 0: up to label31
# BB#26:                                # %for.body330.preheader
	end_loop                        # label32:
	i32.const	$1=, 0
.LBB2_27:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label33:
	i32.const	$push342=, u
	i32.const	$push341=, 97
	i32.const	$push340=, 31
	i32.call	$drop=, memset@FUNCTION, $pop342, $pop341, $pop340
	i32.const	$push339=, 0
	i32.store16	$0=, u+12($1):p2align=0, $pop339
	i64.const	$push338=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop338
	i32.const	$push337=, 14
	i32.store	$push336=, u($1):p2align=0, $0
	tee_local	$push335=, $0=, $pop336
	call    	check@FUNCTION, $1, $pop337, $pop335
	i32.load8_u	$push334=, A($0)
	tee_local	$push333=, $0=, $pop334
	i32.const	$push332=, 257
	i32.mul 	$push73=, $pop333, $pop332
	i32.store16	$drop=, u+12($1):p2align=0, $pop73
	i32.const	$push331=, 16843009
	i32.mul 	$push74=, $0, $pop331
	i32.store	$push28=, u+8($1):p2align=0, $pop74
	i32.store	$push29=, u+4($1):p2align=0, $pop28
	i32.store	$drop=, u($1):p2align=0, $pop29
	i32.const	$push330=, 14
	i32.const	$push329=, 65
	call    	check@FUNCTION, $1, $pop330, $pop329
	i32.const	$push328=, 16962
	i32.store16	$drop=, u+12($1):p2align=0, $pop328
	i64.const	$push327=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop327
	i32.const	$push326=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop326
	i32.const	$push325=, 14
	i32.const	$push324=, 66
	call    	check@FUNCTION, $1, $pop325, $pop324
	i32.const	$push323=, 1
	i32.add 	$push322=, $1, $pop323
	tee_local	$push321=, $1=, $pop322
	i32.const	$push320=, 8
	i32.ne  	$push75=, $pop321, $pop320
	br_if   	0, $pop75       # 0: up to label33
# BB#28:                                # %for.body356.preheader
	end_loop                        # label34:
	i32.const	$1=, 0
.LBB2_29:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label35:
	i32.const	$push365=, u
	i32.const	$push364=, 97
	i32.const	$push363=, 31
	i32.call	$drop=, memset@FUNCTION, $pop365, $pop364, $pop363
	i32.const	$push362=, 0
	i32.store8	$push30=, u+14($1), $pop362
	i32.store16	$0=, u+12($1):p2align=0, $pop30
	i64.const	$push361=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop361
	i32.const	$push360=, 15
	i32.store	$push359=, u($1):p2align=0, $0
	tee_local	$push358=, $0=, $pop359
	call    	check@FUNCTION, $1, $pop360, $pop358
	i32.load8_u	$push76=, A($0)
	i32.store8	$push357=, u+14($1), $pop76
	tee_local	$push356=, $0=, $pop357
	i32.const	$push355=, 257
	i32.mul 	$push77=, $pop356, $pop355
	i32.store16	$drop=, u+12($1):p2align=0, $pop77
	i32.const	$push354=, 16843009
	i32.mul 	$push78=, $0, $pop354
	i32.store	$push31=, u+8($1):p2align=0, $pop78
	i32.store	$push32=, u+4($1):p2align=0, $pop31
	i32.store	$drop=, u($1):p2align=0, $pop32
	i32.const	$push353=, 15
	i32.const	$push352=, 65
	call    	check@FUNCTION, $1, $pop353, $pop352
	i32.const	$push351=, 66
	i32.store8	$0=, u+14($1), $pop351
	i32.const	$push350=, 16962
	i32.store16	$drop=, u+12($1):p2align=0, $pop350
	i64.const	$push349=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop349
	i32.const	$push348=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop348
	i32.const	$push347=, 15
	call    	check@FUNCTION, $1, $pop347, $0
	i32.const	$push346=, 1
	i32.add 	$push345=, $1, $pop346
	tee_local	$push344=, $1=, $pop345
	i32.const	$push343=, 8
	i32.ne  	$push79=, $pop344, $pop343
	br_if   	0, $pop79       # 0: up to label35
# BB#30:                                # %for.end378
	end_loop                        # label36:
	i32.const	$push80=, 0
	call    	exit@FUNCTION, $pop80
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
