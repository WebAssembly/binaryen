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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push93=, u
	i32.const	$push92=, 97
	i32.const	$push91=, 31
	i32.call	$drop=, memset@FUNCTION, $pop93, $pop92, $pop91
	i32.const	$push90=, 1
	i32.const	$push89=, 0
	i32.store8	$push88=, u($1), $pop89
	tee_local	$push87=, $0=, $pop88
	call    	check@FUNCTION, $1, $pop90, $pop87
	i32.load8_u	$push33=, A($0)
	i32.store8	$drop=, u($1), $pop33
	i32.const	$push86=, 1
	i32.const	$push85=, 65
	call    	check@FUNCTION, $1, $pop86, $pop85
	i32.const	$push84=, 1
	i32.const	$push83=, 66
	i32.store8	$push0=, u($1), $pop83
	call    	check@FUNCTION, $1, $pop84, $pop0
	i32.const	$push82=, 1
	i32.add 	$1=, $1, $pop82
	i32.const	$push81=, 8
	i32.ne  	$push34=, $1, $pop81
	br_if   	0, $pop34       # 0: up to label7
# BB#2:                                 # %for.body18.preheader
	end_loop                        # label8:
	i32.const	$1=, 0
.LBB2_3:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.const	$push108=, u
	i32.const	$push107=, 97
	i32.const	$push106=, 31
	i32.call	$drop=, memset@FUNCTION, $pop108, $pop107, $pop106
	i32.const	$push105=, 2
	i32.const	$push104=, 0
	i32.store16	$push103=, u($1):p2align=0, $pop104
	tee_local	$push102=, $0=, $pop103
	call    	check@FUNCTION, $1, $pop105, $pop102
	i32.load8_u	$push35=, A($0)
	i32.const	$push101=, 257
	i32.mul 	$push36=, $pop35, $pop101
	i32.store16	$drop=, u($1):p2align=0, $pop36
	i32.const	$push100=, 2
	i32.const	$push99=, 65
	call    	check@FUNCTION, $1, $pop100, $pop99
	i32.const	$push98=, 16962
	i32.store16	$drop=, u($1):p2align=0, $pop98
	i32.const	$push97=, 2
	i32.const	$push96=, 66
	call    	check@FUNCTION, $1, $pop97, $pop96
	i32.const	$push95=, 1
	i32.add 	$1=, $1, $pop95
	i32.const	$push94=, 8
	i32.ne  	$push37=, $1, $pop94
	br_if   	0, $pop37       # 0: up to label9
# BB#4:                                 # %for.body44.preheader
	end_loop                        # label10:
	i32.const	$1=, 0
.LBB2_5:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	i32.const	$push123=, u
	i32.const	$push122=, 97
	i32.const	$push121=, 31
	i32.call	$drop=, memset@FUNCTION, $pop123, $pop122, $pop121
	i32.const	$push120=, 3
	i32.const	$push119=, 0
	i32.store8	$push1=, u+2($1), $pop119
	i32.store16	$push118=, u($1):p2align=0, $pop1
	tee_local	$push117=, $0=, $pop118
	call    	check@FUNCTION, $1, $pop120, $pop117
	i32.load8_u	$push38=, A($0)
	i32.store8	$push2=, u+2($1), $pop38
	i32.const	$push116=, 257
	i32.mul 	$push39=, $pop2, $pop116
	i32.store16	$drop=, u($1):p2align=0, $pop39
	i32.const	$push115=, 3
	i32.const	$push114=, 65
	call    	check@FUNCTION, $1, $pop115, $pop114
	i32.const	$push113=, 66
	i32.store8	$0=, u+2($1), $pop113
	i32.const	$push112=, 16962
	i32.store16	$drop=, u($1):p2align=0, $pop112
	i32.const	$push111=, 3
	call    	check@FUNCTION, $1, $pop111, $0
	i32.const	$push110=, 1
	i32.add 	$1=, $1, $pop110
	i32.const	$push109=, 8
	i32.ne  	$push40=, $1, $pop109
	br_if   	0, $pop40       # 0: up to label11
# BB#6:                                 # %for.body70.preheader
	end_loop                        # label12:
	i32.const	$1=, 0
.LBB2_7:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$push138=, u
	i32.const	$push137=, 97
	i32.const	$push136=, 31
	i32.call	$drop=, memset@FUNCTION, $pop138, $pop137, $pop136
	i32.const	$push135=, 4
	i32.const	$push134=, 0
	i32.store	$push133=, u($1):p2align=0, $pop134
	tee_local	$push132=, $0=, $pop133
	call    	check@FUNCTION, $1, $pop135, $pop132
	i32.load8_u	$push41=, A($0)
	i32.const	$push131=, 16843009
	i32.mul 	$push42=, $pop41, $pop131
	i32.store	$drop=, u($1):p2align=0, $pop42
	i32.const	$push130=, 4
	i32.const	$push129=, 65
	call    	check@FUNCTION, $1, $pop130, $pop129
	i32.const	$push128=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop128
	i32.const	$push127=, 4
	i32.const	$push126=, 66
	call    	check@FUNCTION, $1, $pop127, $pop126
	i32.const	$push125=, 1
	i32.add 	$1=, $1, $pop125
	i32.const	$push124=, 8
	i32.ne  	$push43=, $1, $pop124
	br_if   	0, $pop43       # 0: up to label13
# BB#8:                                 # %for.body96.preheader
	end_loop                        # label14:
	i32.const	$1=, 0
.LBB2_9:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push153=, u
	i32.const	$push152=, 97
	i32.const	$push151=, 31
	i32.call	$drop=, memset@FUNCTION, $pop153, $pop152, $pop151
	i32.const	$push150=, 5
	i32.const	$push149=, 0
	i32.store8	$push3=, u+4($1), $pop149
	i32.store	$push148=, u($1):p2align=0, $pop3
	tee_local	$push147=, $0=, $pop148
	call    	check@FUNCTION, $1, $pop150, $pop147
	i32.load8_u	$push44=, A($0)
	i32.store8	$push4=, u+4($1), $pop44
	i32.const	$push146=, 16843009
	i32.mul 	$push45=, $pop4, $pop146
	i32.store	$drop=, u($1):p2align=0, $pop45
	i32.const	$push145=, 5
	i32.const	$push144=, 65
	call    	check@FUNCTION, $1, $pop145, $pop144
	i32.const	$push143=, 66
	i32.store8	$0=, u+4($1), $pop143
	i32.const	$push142=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop142
	i32.const	$push141=, 5
	call    	check@FUNCTION, $1, $pop141, $0
	i32.const	$push140=, 1
	i32.add 	$1=, $1, $pop140
	i32.const	$push139=, 8
	i32.ne  	$push46=, $1, $pop139
	br_if   	0, $pop46       # 0: up to label15
# BB#10:                                # %for.body122.preheader
	end_loop                        # label16:
	i32.const	$1=, 0
.LBB2_11:                               # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label17:
	i32.const	$push172=, u
	i32.const	$push171=, 97
	i32.const	$push170=, 31
	i32.call	$drop=, memset@FUNCTION, $pop172, $pop171, $pop170
	i32.const	$push169=, 6
	i32.const	$push168=, 0
	i32.store16	$push5=, u+4($1):p2align=0, $pop168
	i32.store	$push167=, u($1):p2align=0, $pop5
	tee_local	$push166=, $0=, $pop167
	call    	check@FUNCTION, $1, $pop169, $pop166
	i32.load8_u	$push165=, A($0)
	tee_local	$push164=, $0=, $pop165
	i32.const	$push163=, 257
	i32.mul 	$push47=, $pop164, $pop163
	i32.store16	$drop=, u+4($1):p2align=0, $pop47
	i32.const	$push162=, 16843009
	i32.mul 	$push48=, $0, $pop162
	i32.store	$drop=, u($1):p2align=0, $pop48
	i32.const	$push161=, 6
	i32.const	$push160=, 65
	call    	check@FUNCTION, $1, $pop161, $pop160
	i32.const	$push159=, 16962
	i32.store16	$drop=, u+4($1):p2align=0, $pop159
	i32.const	$push158=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop158
	i32.const	$push157=, 6
	i32.const	$push156=, 66
	call    	check@FUNCTION, $1, $pop157, $pop156
	i32.const	$push155=, 1
	i32.add 	$1=, $1, $pop155
	i32.const	$push154=, 8
	i32.ne  	$push49=, $1, $pop154
	br_if   	0, $pop49       # 0: up to label17
# BB#12:                                # %for.body148.preheader
	end_loop                        # label18:
	i32.const	$1=, 0
.LBB2_13:                               # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push191=, u
	i32.const	$push190=, 97
	i32.const	$push189=, 31
	i32.call	$drop=, memset@FUNCTION, $pop191, $pop190, $pop189
	i32.const	$push188=, 7
	i32.const	$push187=, 0
	i32.store8	$push6=, u+6($1), $pop187
	i32.store16	$push7=, u+4($1):p2align=0, $pop6
	i32.store	$push186=, u($1):p2align=0, $pop7
	tee_local	$push185=, $0=, $pop186
	call    	check@FUNCTION, $1, $pop188, $pop185
	i32.load8_u	$push50=, A($0)
	i32.store8	$push184=, u+6($1), $pop50
	tee_local	$push183=, $0=, $pop184
	i32.const	$push182=, 257
	i32.mul 	$push51=, $pop183, $pop182
	i32.store16	$drop=, u+4($1):p2align=0, $pop51
	i32.const	$push181=, 16843009
	i32.mul 	$push52=, $0, $pop181
	i32.store	$drop=, u($1):p2align=0, $pop52
	i32.const	$push180=, 7
	i32.const	$push179=, 65
	call    	check@FUNCTION, $1, $pop180, $pop179
	i32.const	$push178=, 66
	i32.store8	$0=, u+6($1), $pop178
	i32.const	$push177=, 16962
	i32.store16	$drop=, u+4($1):p2align=0, $pop177
	i32.const	$push176=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop176
	i32.const	$push175=, 7
	call    	check@FUNCTION, $1, $pop175, $0
	i32.const	$push174=, 1
	i32.add 	$1=, $1, $pop174
	i32.const	$push173=, 8
	i32.ne  	$push53=, $1, $pop173
	br_if   	0, $pop53       # 0: up to label19
# BB#14:                                # %for.body174.preheader
	end_loop                        # label20:
	i32.const	$1=, 0
.LBB2_15:                               # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label21:
	i32.const	$push206=, u
	i32.const	$push205=, 97
	i32.const	$push204=, 31
	i32.call	$drop=, memset@FUNCTION, $pop206, $pop205, $pop204
	i64.const	$push203=, 0
	i64.store	$drop=, u($1):p2align=0, $pop203
	i32.const	$push202=, 8
	i32.const	$push201=, 0
	call    	check@FUNCTION, $1, $pop202, $pop201
	i32.const	$push200=, 0
	i32.load8_u	$push54=, A($pop200)
	i32.const	$push199=, 16843009
	i32.mul 	$push55=, $pop54, $pop199
	i32.store	$push8=, u+4($1):p2align=0, $pop55
	i32.store	$drop=, u($1):p2align=0, $pop8
	i32.const	$push198=, 8
	i32.const	$push197=, 65
	call    	check@FUNCTION, $1, $pop198, $pop197
	i64.const	$push196=, 4774451407313060418
	i64.store	$drop=, u($1):p2align=0, $pop196
	i32.const	$push195=, 8
	i32.const	$push194=, 66
	call    	check@FUNCTION, $1, $pop195, $pop194
	i32.const	$push193=, 1
	i32.add 	$1=, $1, $pop193
	i32.const	$push192=, 8
	i32.ne  	$push56=, $1, $pop192
	br_if   	0, $pop56       # 0: up to label21
# BB#16:                                # %for.body200.preheader
	end_loop                        # label22:
	i32.const	$1=, 0
.LBB2_17:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label23:
	i32.const	$push221=, u
	i32.const	$push220=, 97
	i32.const	$push219=, 31
	i32.call	$drop=, memset@FUNCTION, $pop221, $pop220, $pop219
	i32.const	$push218=, 9
	i32.const	$push217=, 0
	i32.store8	$push9=, u+8($1), $pop217
	i32.store	$push10=, u+4($1):p2align=0, $pop9
	i32.store	$push216=, u($1):p2align=0, $pop10
	tee_local	$push215=, $0=, $pop216
	call    	check@FUNCTION, $1, $pop218, $pop215
	i32.load8_u	$push57=, A($0)
	i32.store8	$push11=, u+8($1), $pop57
	i32.const	$push214=, 16843009
	i32.mul 	$push58=, $pop11, $pop214
	i32.store	$push12=, u+4($1):p2align=0, $pop58
	i32.store	$drop=, u($1):p2align=0, $pop12
	i32.const	$push213=, 9
	i32.const	$push212=, 65
	call    	check@FUNCTION, $1, $pop213, $pop212
	i32.const	$push211=, 66
	i32.store8	$0=, u+8($1), $pop211
	i32.const	$push210=, 1111638594
	i32.store	$push13=, u+4($1):p2align=0, $pop210
	i32.store	$drop=, u($1):p2align=0, $pop13
	i32.const	$push209=, 9
	call    	check@FUNCTION, $1, $pop209, $0
	i32.const	$push208=, 1
	i32.add 	$1=, $1, $pop208
	i32.const	$push207=, 8
	i32.ne  	$push59=, $1, $pop207
	br_if   	0, $pop59       # 0: up to label23
# BB#18:                                # %for.body226.preheader
	end_loop                        # label24:
	i32.const	$1=, 0
.LBB2_19:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$push240=, u
	i32.const	$push239=, 97
	i32.const	$push238=, 31
	i32.call	$drop=, memset@FUNCTION, $pop240, $pop239, $pop238
	i32.const	$push237=, 10
	i32.const	$push236=, 0
	i32.store16	$push14=, u+8($1):p2align=0, $pop236
	i32.store	$push15=, u+4($1):p2align=0, $pop14
	i32.store	$push235=, u($1):p2align=0, $pop15
	tee_local	$push234=, $0=, $pop235
	call    	check@FUNCTION, $1, $pop237, $pop234
	i32.load8_u	$push233=, A($0)
	tee_local	$push232=, $0=, $pop233
	i32.const	$push231=, 257
	i32.mul 	$push60=, $pop232, $pop231
	i32.store16	$drop=, u+8($1):p2align=0, $pop60
	i32.const	$push230=, 16843009
	i32.mul 	$push61=, $0, $pop230
	i32.store	$push16=, u+4($1):p2align=0, $pop61
	i32.store	$drop=, u($1):p2align=0, $pop16
	i32.const	$push229=, 10
	i32.const	$push228=, 65
	call    	check@FUNCTION, $1, $pop229, $pop228
	i32.const	$push227=, 16962
	i32.store16	$drop=, u+8($1):p2align=0, $pop227
	i32.const	$push226=, 1111638594
	i32.store	$push17=, u+4($1):p2align=0, $pop226
	i32.store	$drop=, u($1):p2align=0, $pop17
	i32.const	$push225=, 10
	i32.const	$push224=, 66
	call    	check@FUNCTION, $1, $pop225, $pop224
	i32.const	$push223=, 1
	i32.add 	$1=, $1, $pop223
	i32.const	$push222=, 8
	i32.ne  	$push62=, $1, $pop222
	br_if   	0, $pop62       # 0: up to label25
# BB#20:                                # %for.body252.preheader
	end_loop                        # label26:
	i32.const	$1=, 0
.LBB2_21:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label27:
	i32.const	$push259=, u
	i32.const	$push258=, 97
	i32.const	$push257=, 31
	i32.call	$drop=, memset@FUNCTION, $pop259, $pop258, $pop257
	i32.const	$push256=, 11
	i32.const	$push255=, 0
	i32.store8	$push18=, u+10($1), $pop255
	i32.store16	$push19=, u+8($1):p2align=0, $pop18
	i32.store	$push20=, u+4($1):p2align=0, $pop19
	i32.store	$push254=, u($1):p2align=0, $pop20
	tee_local	$push253=, $0=, $pop254
	call    	check@FUNCTION, $1, $pop256, $pop253
	i32.load8_u	$push63=, A($0)
	i32.store8	$push252=, u+10($1), $pop63
	tee_local	$push251=, $0=, $pop252
	i32.const	$push250=, 257
	i32.mul 	$push64=, $pop251, $pop250
	i32.store16	$drop=, u+8($1):p2align=0, $pop64
	i32.const	$push249=, 16843009
	i32.mul 	$push65=, $0, $pop249
	i32.store	$push21=, u+4($1):p2align=0, $pop65
	i32.store	$drop=, u($1):p2align=0, $pop21
	i32.const	$push248=, 11
	i32.const	$push247=, 65
	call    	check@FUNCTION, $1, $pop248, $pop247
	i32.const	$push246=, 66
	i32.store8	$0=, u+10($1), $pop246
	i32.const	$push245=, 16962
	i32.store16	$drop=, u+8($1):p2align=0, $pop245
	i32.const	$push244=, 1111638594
	i32.store	$push22=, u+4($1):p2align=0, $pop244
	i32.store	$drop=, u($1):p2align=0, $pop22
	i32.const	$push243=, 11
	call    	check@FUNCTION, $1, $pop243, $0
	i32.const	$push242=, 1
	i32.add 	$1=, $1, $pop242
	i32.const	$push241=, 8
	i32.ne  	$push66=, $1, $pop241
	br_if   	0, $pop66       # 0: up to label27
# BB#22:                                # %for.body278.preheader
	end_loop                        # label28:
	i32.const	$1=, 0
.LBB2_23:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label29:
	i32.const	$push276=, u
	i32.const	$push275=, 97
	i32.const	$push274=, 31
	i32.call	$drop=, memset@FUNCTION, $pop276, $pop275, $pop274
	i64.const	$push273=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop273
	i32.const	$push272=, 12
	i32.const	$push271=, 0
	i32.store	$push270=, u($1):p2align=0, $pop271
	tee_local	$push269=, $0=, $pop270
	call    	check@FUNCTION, $1, $pop272, $pop269
	i32.load8_u	$push67=, A($0)
	i32.const	$push268=, 16843009
	i32.mul 	$push68=, $pop67, $pop268
	i32.store	$push23=, u+8($1):p2align=0, $pop68
	i32.store	$push24=, u+4($1):p2align=0, $pop23
	i32.store	$drop=, u($1):p2align=0, $pop24
	i32.const	$push267=, 12
	i32.const	$push266=, 65
	call    	check@FUNCTION, $1, $pop267, $pop266
	i64.const	$push265=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop265
	i32.const	$push264=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop264
	i32.const	$push263=, 12
	i32.const	$push262=, 66
	call    	check@FUNCTION, $1, $pop263, $pop262
	i32.const	$push261=, 1
	i32.add 	$1=, $1, $pop261
	i32.const	$push260=, 8
	i32.ne  	$push69=, $1, $pop260
	br_if   	0, $pop69       # 0: up to label29
# BB#24:                                # %for.body304.preheader
	end_loop                        # label30:
	i32.const	$1=, 0
.LBB2_25:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push293=, u
	i32.const	$push292=, 97
	i32.const	$push291=, 31
	i32.call	$drop=, memset@FUNCTION, $pop293, $pop292, $pop291
	i32.const	$push290=, 0
	i32.store8	$0=, u+12($1), $pop290
	i64.const	$push289=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop289
	i32.const	$push288=, 13
	i32.store	$push287=, u($1):p2align=0, $0
	tee_local	$push286=, $0=, $pop287
	call    	check@FUNCTION, $1, $pop288, $pop286
	i32.load8_u	$push70=, A($0)
	i32.store8	$push25=, u+12($1), $pop70
	i32.const	$push285=, 16843009
	i32.mul 	$push71=, $pop25, $pop285
	i32.store	$push26=, u+8($1):p2align=0, $pop71
	i32.store	$push27=, u+4($1):p2align=0, $pop26
	i32.store	$drop=, u($1):p2align=0, $pop27
	i32.const	$push284=, 13
	i32.const	$push283=, 65
	call    	check@FUNCTION, $1, $pop284, $pop283
	i32.const	$push282=, 66
	i32.store8	$0=, u+12($1), $pop282
	i64.const	$push281=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop281
	i32.const	$push280=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop280
	i32.const	$push279=, 13
	call    	check@FUNCTION, $1, $pop279, $0
	i32.const	$push278=, 1
	i32.add 	$1=, $1, $pop278
	i32.const	$push277=, 8
	i32.ne  	$push72=, $1, $pop277
	br_if   	0, $pop72       # 0: up to label31
# BB#26:                                # %for.body330.preheader
	end_loop                        # label32:
	i32.const	$1=, 0
.LBB2_27:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label33:
	i32.const	$push314=, u
	i32.const	$push313=, 97
	i32.const	$push312=, 31
	i32.call	$drop=, memset@FUNCTION, $pop314, $pop313, $pop312
	i32.const	$push311=, 0
	i32.store16	$0=, u+12($1):p2align=0, $pop311
	i64.const	$push310=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop310
	i32.const	$push309=, 14
	i32.store	$push308=, u($1):p2align=0, $0
	tee_local	$push307=, $0=, $pop308
	call    	check@FUNCTION, $1, $pop309, $pop307
	i32.load8_u	$push306=, A($0)
	tee_local	$push305=, $0=, $pop306
	i32.const	$push304=, 257
	i32.mul 	$push73=, $pop305, $pop304
	i32.store16	$drop=, u+12($1):p2align=0, $pop73
	i32.const	$push303=, 16843009
	i32.mul 	$push74=, $0, $pop303
	i32.store	$push28=, u+8($1):p2align=0, $pop74
	i32.store	$push29=, u+4($1):p2align=0, $pop28
	i32.store	$drop=, u($1):p2align=0, $pop29
	i32.const	$push302=, 14
	i32.const	$push301=, 65
	call    	check@FUNCTION, $1, $pop302, $pop301
	i32.const	$push300=, 16962
	i32.store16	$drop=, u+12($1):p2align=0, $pop300
	i64.const	$push299=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop299
	i32.const	$push298=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop298
	i32.const	$push297=, 14
	i32.const	$push296=, 66
	call    	check@FUNCTION, $1, $pop297, $pop296
	i32.const	$push295=, 1
	i32.add 	$1=, $1, $pop295
	i32.const	$push294=, 8
	i32.ne  	$push75=, $1, $pop294
	br_if   	0, $pop75       # 0: up to label33
# BB#28:                                # %for.body356.preheader
	end_loop                        # label34:
	i32.const	$1=, 0
.LBB2_29:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label35:
	i32.const	$push335=, u
	i32.const	$push334=, 97
	i32.const	$push333=, 31
	i32.call	$drop=, memset@FUNCTION, $pop335, $pop334, $pop333
	i32.const	$push332=, 0
	i32.store8	$push30=, u+14($1), $pop332
	i32.store16	$0=, u+12($1):p2align=0, $pop30
	i64.const	$push331=, 0
	i64.store	$drop=, u+4($1):p2align=0, $pop331
	i32.const	$push330=, 15
	i32.store	$push329=, u($1):p2align=0, $0
	tee_local	$push328=, $0=, $pop329
	call    	check@FUNCTION, $1, $pop330, $pop328
	i32.load8_u	$push76=, A($0)
	i32.store8	$push327=, u+14($1), $pop76
	tee_local	$push326=, $0=, $pop327
	i32.const	$push325=, 257
	i32.mul 	$push77=, $pop326, $pop325
	i32.store16	$drop=, u+12($1):p2align=0, $pop77
	i32.const	$push324=, 16843009
	i32.mul 	$push78=, $0, $pop324
	i32.store	$push31=, u+8($1):p2align=0, $pop78
	i32.store	$push32=, u+4($1):p2align=0, $pop31
	i32.store	$drop=, u($1):p2align=0, $pop32
	i32.const	$push323=, 15
	i32.const	$push322=, 65
	call    	check@FUNCTION, $1, $pop323, $pop322
	i32.const	$push321=, 66
	i32.store8	$0=, u+14($1), $pop321
	i32.const	$push320=, 16962
	i32.store16	$drop=, u+12($1):p2align=0, $pop320
	i64.const	$push319=, 4774451407313060418
	i64.store	$drop=, u+4($1):p2align=0, $pop319
	i32.const	$push318=, 1111638594
	i32.store	$drop=, u($1):p2align=0, $pop318
	i32.const	$push317=, 15
	call    	check@FUNCTION, $1, $pop317, $0
	i32.const	$push316=, 1
	i32.add 	$1=, $1, $pop316
	i32.const	$push315=, 8
	i32.ne  	$push79=, $1, $pop315
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
