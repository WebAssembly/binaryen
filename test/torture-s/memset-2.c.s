	.text
	.file	"memset-2.c"
	.section	.text.reset,"ax",@progbits
	.hidden	reset                   # -- Begin function reset
	.globl	reset
	.type	reset,@function
reset:                                  # @reset
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 7016996765293437281
	i64.store	u+23($pop1):p2align=0, $pop0
	i32.const	$push7=, 0
	i64.const	$push6=, 7016996765293437281
	i64.store	u+16($pop7), $pop6
	i32.const	$push5=, 0
	i64.const	$push4=, 7016996765293437281
	i64.store	u+8($pop5), $pop4
	i32.const	$push3=, 0
	i64.const	$push2=, 7016996765293437281
	i64.store	u($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	reset, .Lfunc_end0-reset
                                        # -- End function
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
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
# BB#4:                                 # %for.end.loopexit
	end_loop
	i32.const	$push5=, u
	i32.add 	$0=, $3, $pop5
	i32.const	$push34=, 1
	i32.ge_s	$push7=, $1, $pop34
	br_if   	1, $pop7        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_5:
	end_block                       # label3:
	i32.const	$0=, u
	i32.const	$push35=, 1
	i32.lt_s	$push6=, $1, $pop35
	br_if   	1, $pop6        # 1: down to label1
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
# BB#9:                                 # %for.end15.loopexit
	end_loop
	i32.add 	$0=, $0, $3
.LBB1_10:                               # %for.end15
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
.LBB1_19:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	check, .Lfunc_end1-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push67=, 0
	i64.const	$push66=, 7016996765293437281
	i64.store	u+23($pop67):p2align=0, $pop66
	i32.const	$push65=, 0
	i64.const	$push64=, 7016996765293437281
	i64.store	u+16($pop65), $pop64
	i32.const	$push63=, 0
	i64.const	$push62=, 7016996765293437281
	i64.store	u+8($pop63), $pop62
	i32.const	$push61=, 0
	i64.const	$push60=, 7016996765293437281
	i64.store	u($pop61), $pop60
	i32.const	$push59=, u
	i32.add 	$push58=, $5, $pop59
	tee_local	$push57=, $2=, $pop58
	i32.const	$push56=, 0
	i32.store8	0($pop57), $pop56
	i32.const	$push55=, 1
	i32.const	$push54=, 0
	call    	check@FUNCTION, $5, $pop55, $pop54
	i32.const	$push53=, 0
	i32.load8_u	$push0=, A($pop53)
	i32.store8	0($2), $pop0
	i32.const	$push52=, 1
	i32.const	$push51=, 65
	call    	check@FUNCTION, $5, $pop52, $pop51
	i32.const	$push50=, 66
	i32.store8	0($2), $pop50
	i32.const	$push49=, 1
	i32.const	$push48=, 66
	call    	check@FUNCTION, $5, $pop49, $pop48
	i32.const	$push47=, 1
	i32.add 	$push46=, $5, $pop47
	tee_local	$push45=, $5=, $pop46
	i32.const	$push44=, 8
	i32.ne  	$push1=, $pop45, $pop44
	br_if   	0, $pop1        # 0: up to label6
# BB#2:                                 # %for.body18.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_3:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push92=, 0
	i64.const	$push91=, 7016996765293437281
	i64.store	u+23($pop92):p2align=0, $pop91
	i32.const	$push90=, 0
	i64.const	$push89=, 7016996765293437281
	i64.store	u+16($pop90), $pop89
	i32.const	$push88=, 0
	i64.const	$push87=, 7016996765293437281
	i64.store	u+8($pop88), $pop87
	i32.const	$push86=, 0
	i64.const	$push85=, 7016996765293437281
	i64.store	u($pop86), $pop85
	i32.const	$push84=, u
	i32.add 	$push83=, $5, $pop84
	tee_local	$push82=, $2=, $pop83
	i32.const	$push81=, 0
	i32.store16	0($pop82):p2align=0, $pop81
	i32.const	$push80=, 2
	i32.const	$push79=, 0
	call    	check@FUNCTION, $5, $pop80, $pop79
	i32.const	$push78=, 0
	i32.load8_u	$push2=, A($pop78)
	i32.const	$push77=, 257
	i32.mul 	$push3=, $pop2, $pop77
	i32.store16	0($2):p2align=0, $pop3
	i32.const	$push76=, 2
	i32.const	$push75=, 65
	call    	check@FUNCTION, $5, $pop76, $pop75
	i32.const	$push74=, 16962
	i32.store16	0($2):p2align=0, $pop74
	i32.const	$push73=, 2
	i32.const	$push72=, 66
	call    	check@FUNCTION, $5, $pop73, $pop72
	i32.const	$push71=, 1
	i32.add 	$push70=, $5, $pop71
	tee_local	$push69=, $5=, $pop70
	i32.const	$push68=, 8
	i32.ne  	$push4=, $pop69, $pop68
	br_if   	0, $pop4        # 0: up to label7
# BB#4:                                 # %for.body44.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_5:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push124=, 0
	i64.const	$push123=, 7016996765293437281
	i64.store	u+23($pop124):p2align=0, $pop123
	i32.const	$push122=, 0
	i64.const	$push121=, 7016996765293437281
	i64.store	u+16($pop122), $pop121
	i32.const	$push120=, 0
	i64.const	$push119=, 7016996765293437281
	i64.store	u+8($pop120), $pop119
	i32.const	$push118=, 0
	i64.const	$push117=, 7016996765293437281
	i64.store	u($pop118), $pop117
	i32.const	$push116=, u+2
	i32.add 	$push115=, $5, $pop116
	tee_local	$push114=, $2=, $pop115
	i32.const	$push113=, 0
	i32.store8	0($pop114), $pop113
	i32.const	$push112=, u
	i32.add 	$push111=, $5, $pop112
	tee_local	$push110=, $3=, $pop111
	i32.const	$push109=, 0
	i32.store16	0($pop110):p2align=0, $pop109
	i32.const	$push108=, 3
	i32.const	$push107=, 0
	call    	check@FUNCTION, $5, $pop108, $pop107
	i32.const	$push106=, 0
	i32.load8_u	$push105=, A($pop106)
	tee_local	$push104=, $0=, $pop105
	i32.store8	0($2), $pop104
	i32.const	$push103=, 257
	i32.mul 	$push5=, $0, $pop103
	i32.store16	0($3):p2align=0, $pop5
	i32.const	$push102=, 3
	i32.const	$push101=, 65
	call    	check@FUNCTION, $5, $pop102, $pop101
	i32.const	$push100=, 66
	i32.store8	0($2), $pop100
	i32.const	$push99=, 16962
	i32.store16	0($3):p2align=0, $pop99
	i32.const	$push98=, 3
	i32.const	$push97=, 66
	call    	check@FUNCTION, $5, $pop98, $pop97
	i32.const	$push96=, 1
	i32.add 	$push95=, $5, $pop96
	tee_local	$push94=, $5=, $pop95
	i32.const	$push93=, 8
	i32.ne  	$push6=, $pop94, $pop93
	br_if   	0, $pop6        # 0: up to label8
# BB#6:                                 # %for.body70.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_7:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push149=, 0
	i64.const	$push148=, 7016996765293437281
	i64.store	u+23($pop149):p2align=0, $pop148
	i32.const	$push147=, 0
	i64.const	$push146=, 7016996765293437281
	i64.store	u+16($pop147), $pop146
	i32.const	$push145=, 0
	i64.const	$push144=, 7016996765293437281
	i64.store	u+8($pop145), $pop144
	i32.const	$push143=, 0
	i64.const	$push142=, 7016996765293437281
	i64.store	u($pop143), $pop142
	i32.const	$push141=, u
	i32.add 	$push140=, $5, $pop141
	tee_local	$push139=, $2=, $pop140
	i32.const	$push138=, 0
	i32.store	0($pop139):p2align=0, $pop138
	i32.const	$push137=, 4
	i32.const	$push136=, 0
	call    	check@FUNCTION, $5, $pop137, $pop136
	i32.const	$push135=, 0
	i32.load8_u	$push7=, A($pop135)
	i32.const	$push134=, 16843009
	i32.mul 	$push8=, $pop7, $pop134
	i32.store	0($2):p2align=0, $pop8
	i32.const	$push133=, 4
	i32.const	$push132=, 65
	call    	check@FUNCTION, $5, $pop133, $pop132
	i32.const	$push131=, 1111638594
	i32.store	0($2):p2align=0, $pop131
	i32.const	$push130=, 4
	i32.const	$push129=, 66
	call    	check@FUNCTION, $5, $pop130, $pop129
	i32.const	$push128=, 1
	i32.add 	$push127=, $5, $pop128
	tee_local	$push126=, $5=, $pop127
	i32.const	$push125=, 8
	i32.ne  	$push9=, $pop126, $pop125
	br_if   	0, $pop9        # 0: up to label9
# BB#8:                                 # %for.body96.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_9:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push181=, 0
	i64.const	$push180=, 7016996765293437281
	i64.store	u+23($pop181):p2align=0, $pop180
	i32.const	$push179=, 0
	i64.const	$push178=, 7016996765293437281
	i64.store	u+16($pop179), $pop178
	i32.const	$push177=, 0
	i64.const	$push176=, 7016996765293437281
	i64.store	u+8($pop177), $pop176
	i32.const	$push175=, 0
	i64.const	$push174=, 7016996765293437281
	i64.store	u($pop175), $pop174
	i32.const	$push173=, u+4
	i32.add 	$push172=, $5, $pop173
	tee_local	$push171=, $2=, $pop172
	i32.const	$push170=, 0
	i32.store8	0($pop171), $pop170
	i32.const	$push169=, u
	i32.add 	$push168=, $5, $pop169
	tee_local	$push167=, $3=, $pop168
	i32.const	$push166=, 0
	i32.store	0($pop167):p2align=0, $pop166
	i32.const	$push165=, 5
	i32.const	$push164=, 0
	call    	check@FUNCTION, $5, $pop165, $pop164
	i32.const	$push163=, 0
	i32.load8_u	$push162=, A($pop163)
	tee_local	$push161=, $0=, $pop162
	i32.store8	0($2), $pop161
	i32.const	$push160=, 16843009
	i32.mul 	$push10=, $0, $pop160
	i32.store	0($3):p2align=0, $pop10
	i32.const	$push159=, 5
	i32.const	$push158=, 65
	call    	check@FUNCTION, $5, $pop159, $pop158
	i32.const	$push157=, 66
	i32.store8	0($2), $pop157
	i32.const	$push156=, 1111638594
	i32.store	0($3):p2align=0, $pop156
	i32.const	$push155=, 5
	i32.const	$push154=, 66
	call    	check@FUNCTION, $5, $pop155, $pop154
	i32.const	$push153=, 1
	i32.add 	$push152=, $5, $pop153
	tee_local	$push151=, $5=, $pop152
	i32.const	$push150=, 8
	i32.ne  	$push11=, $pop151, $pop150
	br_if   	0, $pop11       # 0: up to label10
# BB#10:                                # %for.body122.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_11:                               # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push214=, 0
	i64.const	$push213=, 7016996765293437281
	i64.store	u+23($pop214):p2align=0, $pop213
	i32.const	$push212=, 0
	i64.const	$push211=, 7016996765293437281
	i64.store	u+16($pop212), $pop211
	i32.const	$push210=, 0
	i64.const	$push209=, 7016996765293437281
	i64.store	u+8($pop210), $pop209
	i32.const	$push208=, 0
	i64.const	$push207=, 7016996765293437281
	i64.store	u($pop208), $pop207
	i32.const	$push206=, u+4
	i32.add 	$push205=, $5, $pop206
	tee_local	$push204=, $2=, $pop205
	i32.const	$push203=, 0
	i32.store16	0($pop204):p2align=0, $pop203
	i32.const	$push202=, u
	i32.add 	$push201=, $5, $pop202
	tee_local	$push200=, $3=, $pop201
	i32.const	$push199=, 0
	i32.store	0($pop200):p2align=0, $pop199
	i32.const	$push198=, 6
	i32.const	$push197=, 0
	call    	check@FUNCTION, $5, $pop198, $pop197
	i32.const	$push196=, 0
	i32.load8_u	$push195=, A($pop196)
	tee_local	$push194=, $0=, $pop195
	i32.const	$push193=, 257
	i32.mul 	$push12=, $pop194, $pop193
	i32.store16	0($2):p2align=0, $pop12
	i32.const	$push192=, 16843009
	i32.mul 	$push13=, $0, $pop192
	i32.store	0($3):p2align=0, $pop13
	i32.const	$push191=, 6
	i32.const	$push190=, 65
	call    	check@FUNCTION, $5, $pop191, $pop190
	i32.const	$push189=, 16962
	i32.store16	0($2):p2align=0, $pop189
	i32.const	$push188=, 1111638594
	i32.store	0($3):p2align=0, $pop188
	i32.const	$push187=, 6
	i32.const	$push186=, 66
	call    	check@FUNCTION, $5, $pop187, $pop186
	i32.const	$push185=, 1
	i32.add 	$push184=, $5, $pop185
	tee_local	$push183=, $5=, $pop184
	i32.const	$push182=, 8
	i32.ne  	$push14=, $pop183, $pop182
	br_if   	0, $pop14       # 0: up to label11
# BB#12:                                # %for.body148.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_13:                               # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	i32.const	$push252=, 0
	i64.const	$push251=, 7016996765293437281
	i64.store	u+23($pop252):p2align=0, $pop251
	i32.const	$push250=, 0
	i64.const	$push249=, 7016996765293437281
	i64.store	u+16($pop250), $pop249
	i32.const	$push248=, 0
	i64.const	$push247=, 7016996765293437281
	i64.store	u+8($pop248), $pop247
	i32.const	$push246=, 0
	i64.const	$push245=, 7016996765293437281
	i64.store	u($pop246), $pop245
	i32.const	$push244=, u+6
	i32.add 	$push243=, $5, $pop244
	tee_local	$push242=, $2=, $pop243
	i32.const	$push241=, 0
	i32.store8	0($pop242), $pop241
	i32.const	$push240=, u+4
	i32.add 	$push239=, $5, $pop240
	tee_local	$push238=, $3=, $pop239
	i32.const	$push237=, 0
	i32.store16	0($pop238):p2align=0, $pop237
	i32.const	$push236=, u
	i32.add 	$push235=, $5, $pop236
	tee_local	$push234=, $0=, $pop235
	i32.const	$push233=, 0
	i32.store	0($pop234):p2align=0, $pop233
	i32.const	$push232=, 7
	i32.const	$push231=, 0
	call    	check@FUNCTION, $5, $pop232, $pop231
	i32.const	$push230=, 0
	i32.load8_u	$push229=, A($pop230)
	tee_local	$push228=, $1=, $pop229
	i32.store8	0($2), $pop228
	i32.const	$push227=, 257
	i32.mul 	$push15=, $1, $pop227
	i32.store16	0($3):p2align=0, $pop15
	i32.const	$push226=, 16843009
	i32.mul 	$push16=, $1, $pop226
	i32.store	0($0):p2align=0, $pop16
	i32.const	$push225=, 7
	i32.const	$push224=, 65
	call    	check@FUNCTION, $5, $pop225, $pop224
	i32.const	$push223=, 66
	i32.store8	0($2), $pop223
	i32.const	$push222=, 16962
	i32.store16	0($3):p2align=0, $pop222
	i32.const	$push221=, 1111638594
	i32.store	0($0):p2align=0, $pop221
	i32.const	$push220=, 7
	i32.const	$push219=, 66
	call    	check@FUNCTION, $5, $pop220, $pop219
	i32.const	$push218=, 1
	i32.add 	$push217=, $5, $pop218
	tee_local	$push216=, $5=, $pop217
	i32.const	$push215=, 8
	i32.ne  	$push17=, $pop216, $pop215
	br_if   	0, $pop17       # 0: up to label12
# BB#14:                                # %for.body174.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_15:                               # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push277=, 0
	i64.const	$push276=, 7016996765293437281
	i64.store	u+23($pop277):p2align=0, $pop276
	i32.const	$push275=, 0
	i64.const	$push274=, 7016996765293437281
	i64.store	u+16($pop275), $pop274
	i32.const	$push273=, 0
	i64.const	$push272=, 7016996765293437281
	i64.store	u+8($pop273), $pop272
	i32.const	$push271=, 0
	i64.const	$push270=, 7016996765293437281
	i64.store	u($pop271), $pop270
	i32.const	$push269=, u
	i32.add 	$push268=, $5, $pop269
	tee_local	$push267=, $2=, $pop268
	i64.const	$push266=, 0
	i64.store	0($pop267):p2align=0, $pop266
	i32.const	$push265=, 8
	i32.const	$push264=, 0
	call    	check@FUNCTION, $5, $pop265, $pop264
	i32.const	$push263=, 0
	i64.load8_u	$push18=, A($pop263)
	i64.const	$push262=, 72340172838076673
	i64.mul 	$push19=, $pop18, $pop262
	i64.store	0($2):p2align=0, $pop19
	i32.const	$push261=, 8
	i32.const	$push260=, 65
	call    	check@FUNCTION, $5, $pop261, $pop260
	i64.const	$push259=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop259
	i32.const	$push258=, 8
	i32.const	$push257=, 66
	call    	check@FUNCTION, $5, $pop258, $pop257
	i32.const	$push256=, 1
	i32.add 	$push255=, $5, $pop256
	tee_local	$push254=, $5=, $pop255
	i32.const	$push253=, 8
	i32.ne  	$push20=, $pop254, $pop253
	br_if   	0, $pop20       # 0: up to label13
# BB#16:                                # %for.body200.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_17:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push310=, 0
	i64.const	$push309=, 7016996765293437281
	i64.store	u+23($pop310):p2align=0, $pop309
	i32.const	$push308=, 0
	i64.const	$push307=, 7016996765293437281
	i64.store	u+16($pop308), $pop307
	i32.const	$push306=, 0
	i64.const	$push305=, 7016996765293437281
	i64.store	u+8($pop306), $pop305
	i32.const	$push304=, 0
	i64.const	$push303=, 7016996765293437281
	i64.store	u($pop304), $pop303
	i32.const	$push302=, u+8
	i32.add 	$push301=, $5, $pop302
	tee_local	$push300=, $2=, $pop301
	i32.const	$push299=, 0
	i32.store8	0($pop300), $pop299
	i32.const	$push298=, u
	i32.add 	$push297=, $5, $pop298
	tee_local	$push296=, $3=, $pop297
	i64.const	$push295=, 0
	i64.store	0($pop296):p2align=0, $pop295
	i32.const	$push294=, 9
	i32.const	$push293=, 0
	call    	check@FUNCTION, $5, $pop294, $pop293
	i32.const	$push292=, 0
	i32.load8_u	$push291=, A($pop292)
	tee_local	$push290=, $0=, $pop291
	i32.store8	0($2), $pop290
	i64.extend_u/i32	$push21=, $0
	i64.const	$push289=, 255
	i64.and 	$push22=, $pop21, $pop289
	i64.const	$push288=, 72340172838076673
	i64.mul 	$push23=, $pop22, $pop288
	i64.store	0($3):p2align=0, $pop23
	i32.const	$push287=, 9
	i32.const	$push286=, 65
	call    	check@FUNCTION, $5, $pop287, $pop286
	i32.const	$push285=, 66
	i32.store8	0($2), $pop285
	i64.const	$push284=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop284
	i32.const	$push283=, 9
	i32.const	$push282=, 66
	call    	check@FUNCTION, $5, $pop283, $pop282
	i32.const	$push281=, 1
	i32.add 	$push280=, $5, $pop281
	tee_local	$push279=, $5=, $pop280
	i32.const	$push278=, 8
	i32.ne  	$push24=, $pop279, $pop278
	br_if   	0, $pop24       # 0: up to label14
# BB#18:                                # %for.body226.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_19:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push343=, 0
	i64.const	$push342=, 7016996765293437281
	i64.store	u+23($pop343):p2align=0, $pop342
	i32.const	$push341=, 0
	i64.const	$push340=, 7016996765293437281
	i64.store	u+16($pop341), $pop340
	i32.const	$push339=, 0
	i64.const	$push338=, 7016996765293437281
	i64.store	u+8($pop339), $pop338
	i32.const	$push337=, 0
	i64.const	$push336=, 7016996765293437281
	i64.store	u($pop337), $pop336
	i32.const	$push335=, u+8
	i32.add 	$push334=, $5, $pop335
	tee_local	$push333=, $2=, $pop334
	i32.const	$push332=, 0
	i32.store16	0($pop333):p2align=0, $pop332
	i32.const	$push331=, u
	i32.add 	$push330=, $5, $pop331
	tee_local	$push329=, $3=, $pop330
	i64.const	$push328=, 0
	i64.store	0($pop329):p2align=0, $pop328
	i32.const	$push327=, 10
	i32.const	$push326=, 0
	call    	check@FUNCTION, $5, $pop327, $pop326
	i32.const	$push325=, 0
	i32.load8_u	$push324=, A($pop325)
	tee_local	$push323=, $0=, $pop324
	i32.const	$push322=, 257
	i32.mul 	$push25=, $pop323, $pop322
	i32.store16	0($2):p2align=0, $pop25
	i64.extend_u/i32	$push26=, $0
	i64.const	$push321=, 72340172838076673
	i64.mul 	$push27=, $pop26, $pop321
	i64.store	0($3):p2align=0, $pop27
	i32.const	$push320=, 10
	i32.const	$push319=, 65
	call    	check@FUNCTION, $5, $pop320, $pop319
	i32.const	$push318=, 16962
	i32.store16	0($2):p2align=0, $pop318
	i64.const	$push317=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop317
	i32.const	$push316=, 10
	i32.const	$push315=, 66
	call    	check@FUNCTION, $5, $pop316, $pop315
	i32.const	$push314=, 1
	i32.add 	$push313=, $5, $pop314
	tee_local	$push312=, $5=, $pop313
	i32.const	$push311=, 8
	i32.ne  	$push28=, $pop312, $pop311
	br_if   	0, $pop28       # 0: up to label15
# BB#20:                                # %for.body252.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_21:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push381=, 0
	i64.const	$push380=, 7016996765293437281
	i64.store	u+23($pop381):p2align=0, $pop380
	i32.const	$push379=, 0
	i64.const	$push378=, 7016996765293437281
	i64.store	u+16($pop379), $pop378
	i32.const	$push377=, 0
	i64.const	$push376=, 7016996765293437281
	i64.store	u+8($pop377), $pop376
	i32.const	$push375=, 0
	i64.const	$push374=, 7016996765293437281
	i64.store	u($pop375), $pop374
	i32.const	$push373=, u+10
	i32.add 	$push372=, $5, $pop373
	tee_local	$push371=, $2=, $pop372
	i32.const	$push370=, 0
	i32.store8	0($pop371), $pop370
	i32.const	$push369=, u+8
	i32.add 	$push368=, $5, $pop369
	tee_local	$push367=, $3=, $pop368
	i32.const	$push366=, 0
	i32.store16	0($pop367):p2align=0, $pop366
	i32.const	$push365=, u
	i32.add 	$push364=, $5, $pop365
	tee_local	$push363=, $0=, $pop364
	i64.const	$push362=, 0
	i64.store	0($pop363):p2align=0, $pop362
	i32.const	$push361=, 11
	i32.const	$push360=, 0
	call    	check@FUNCTION, $5, $pop361, $pop360
	i32.const	$push359=, 0
	i32.load8_u	$push358=, A($pop359)
	tee_local	$push357=, $1=, $pop358
	i32.store8	0($2), $pop357
	i32.const	$push356=, 257
	i32.mul 	$push29=, $1, $pop356
	i32.store16	0($3):p2align=0, $pop29
	i64.extend_u/i32	$push30=, $1
	i64.const	$push355=, 72340172838076673
	i64.mul 	$push31=, $pop30, $pop355
	i64.store	0($0):p2align=0, $pop31
	i32.const	$push354=, 11
	i32.const	$push353=, 65
	call    	check@FUNCTION, $5, $pop354, $pop353
	i32.const	$push352=, 66
	i32.store8	0($2), $pop352
	i32.const	$push351=, 16962
	i32.store16	0($3):p2align=0, $pop351
	i64.const	$push350=, 4774451407313060418
	i64.store	0($0):p2align=0, $pop350
	i32.const	$push349=, 11
	i32.const	$push348=, 66
	call    	check@FUNCTION, $5, $pop349, $pop348
	i32.const	$push347=, 1
	i32.add 	$push346=, $5, $pop347
	tee_local	$push345=, $5=, $pop346
	i32.const	$push344=, 8
	i32.ne  	$push32=, $pop345, $pop344
	br_if   	0, $pop32       # 0: up to label16
# BB#22:                                # %for.body278.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_23:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push414=, 0
	i64.const	$push413=, 7016996765293437281
	i64.store	u+23($pop414):p2align=0, $pop413
	i32.const	$push412=, 0
	i64.const	$push411=, 7016996765293437281
	i64.store	u+16($pop412), $pop411
	i32.const	$push410=, 0
	i64.const	$push409=, 7016996765293437281
	i64.store	u+8($pop410), $pop409
	i32.const	$push408=, 0
	i64.const	$push407=, 7016996765293437281
	i64.store	u($pop408), $pop407
	i32.const	$push406=, u+8
	i32.add 	$push405=, $5, $pop406
	tee_local	$push404=, $2=, $pop405
	i32.const	$push403=, 0
	i32.store	0($pop404):p2align=0, $pop403
	i32.const	$push402=, u
	i32.add 	$push401=, $5, $pop402
	tee_local	$push400=, $3=, $pop401
	i64.const	$push399=, 0
	i64.store	0($pop400):p2align=0, $pop399
	i32.const	$push398=, 12
	i32.const	$push397=, 0
	call    	check@FUNCTION, $5, $pop398, $pop397
	i32.const	$push396=, 0
	i32.load8_u	$push395=, A($pop396)
	tee_local	$push394=, $0=, $pop395
	i32.const	$push393=, 16843009
	i32.mul 	$push33=, $pop394, $pop393
	i32.store	0($2):p2align=0, $pop33
	i64.extend_u/i32	$push34=, $0
	i64.const	$push392=, 72340172838076673
	i64.mul 	$push35=, $pop34, $pop392
	i64.store	0($3):p2align=0, $pop35
	i32.const	$push391=, 12
	i32.const	$push390=, 65
	call    	check@FUNCTION, $5, $pop391, $pop390
	i32.const	$push389=, 1111638594
	i32.store	0($2):p2align=0, $pop389
	i64.const	$push388=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop388
	i32.const	$push387=, 12
	i32.const	$push386=, 66
	call    	check@FUNCTION, $5, $pop387, $pop386
	i32.const	$push385=, 1
	i32.add 	$push384=, $5, $pop385
	tee_local	$push383=, $5=, $pop384
	i32.const	$push382=, 8
	i32.ne  	$push36=, $pop383, $pop382
	br_if   	0, $pop36       # 0: up to label17
# BB#24:                                # %for.body304.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_25:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push446=, 0
	i64.const	$push445=, 7016996765293437281
	i64.store	u+23($pop446):p2align=0, $pop445
	i32.const	$push444=, 0
	i64.const	$push443=, 7016996765293437281
	i64.store	u+16($pop444), $pop443
	i32.const	$push442=, 0
	i64.const	$push441=, 7016996765293437281
	i64.store	u+8($pop442), $pop441
	i32.const	$push440=, 0
	i64.const	$push439=, 7016996765293437281
	i64.store	u($pop440), $pop439
	i32.const	$push438=, u+5
	i32.add 	$push437=, $5, $pop438
	tee_local	$push436=, $2=, $pop437
	i64.const	$push435=, 0
	i64.store	0($pop436):p2align=0, $pop435
	i32.const	$push434=, u
	i32.add 	$push433=, $5, $pop434
	tee_local	$push432=, $3=, $pop433
	i64.const	$push431=, 0
	i64.store	0($pop432):p2align=0, $pop431
	i32.const	$push430=, 13
	i32.const	$push429=, 0
	call    	check@FUNCTION, $5, $pop430, $pop429
	i32.const	$push428=, 0
	i64.load8_u	$push37=, A($pop428)
	i64.const	$push427=, 72340172838076673
	i64.mul 	$push426=, $pop37, $pop427
	tee_local	$push425=, $4=, $pop426
	i64.store	0($2):p2align=0, $pop425
	i64.store	0($3):p2align=0, $4
	i32.const	$push424=, 13
	i32.const	$push423=, 65
	call    	check@FUNCTION, $5, $pop424, $pop423
	i64.const	$push422=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop422
	i64.const	$push421=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop421
	i32.const	$push420=, 13
	i32.const	$push419=, 66
	call    	check@FUNCTION, $5, $pop420, $pop419
	i32.const	$push418=, 1
	i32.add 	$push417=, $5, $pop418
	tee_local	$push416=, $5=, $pop417
	i32.const	$push415=, 8
	i32.ne  	$push38=, $pop416, $pop415
	br_if   	0, $pop38       # 0: up to label18
# BB#26:                                # %for.body330.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_27:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push478=, 0
	i64.const	$push477=, 7016996765293437281
	i64.store	u+23($pop478):p2align=0, $pop477
	i32.const	$push476=, 0
	i64.const	$push475=, 7016996765293437281
	i64.store	u+16($pop476), $pop475
	i32.const	$push474=, 0
	i64.const	$push473=, 7016996765293437281
	i64.store	u+8($pop474), $pop473
	i32.const	$push472=, 0
	i64.const	$push471=, 7016996765293437281
	i64.store	u($pop472), $pop471
	i32.const	$push470=, u+6
	i32.add 	$push469=, $5, $pop470
	tee_local	$push468=, $2=, $pop469
	i64.const	$push467=, 0
	i64.store	0($pop468):p2align=0, $pop467
	i32.const	$push466=, u
	i32.add 	$push465=, $5, $pop466
	tee_local	$push464=, $3=, $pop465
	i64.const	$push463=, 0
	i64.store	0($pop464):p2align=0, $pop463
	i32.const	$push462=, 14
	i32.const	$push461=, 0
	call    	check@FUNCTION, $5, $pop462, $pop461
	i32.const	$push460=, 0
	i64.load8_u	$push39=, A($pop460)
	i64.const	$push459=, 72340172838076673
	i64.mul 	$push458=, $pop39, $pop459
	tee_local	$push457=, $4=, $pop458
	i64.store	0($2):p2align=0, $pop457
	i64.store	0($3):p2align=0, $4
	i32.const	$push456=, 14
	i32.const	$push455=, 65
	call    	check@FUNCTION, $5, $pop456, $pop455
	i64.const	$push454=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop454
	i64.const	$push453=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop453
	i32.const	$push452=, 14
	i32.const	$push451=, 66
	call    	check@FUNCTION, $5, $pop452, $pop451
	i32.const	$push450=, 1
	i32.add 	$push449=, $5, $pop450
	tee_local	$push448=, $5=, $pop449
	i32.const	$push447=, 8
	i32.ne  	$push40=, $pop448, $pop447
	br_if   	0, $pop40       # 0: up to label19
# BB#28:                                # %for.body356.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_29:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push510=, 0
	i64.const	$push509=, 7016996765293437281
	i64.store	u+23($pop510):p2align=0, $pop509
	i32.const	$push508=, 0
	i64.const	$push507=, 7016996765293437281
	i64.store	u+16($pop508), $pop507
	i32.const	$push506=, 0
	i64.const	$push505=, 7016996765293437281
	i64.store	u+8($pop506), $pop505
	i32.const	$push504=, 0
	i64.const	$push503=, 7016996765293437281
	i64.store	u($pop504), $pop503
	i32.const	$push502=, u+7
	i32.add 	$push501=, $5, $pop502
	tee_local	$push500=, $2=, $pop501
	i64.const	$push499=, 0
	i64.store	0($pop500):p2align=0, $pop499
	i32.const	$push498=, u
	i32.add 	$push497=, $5, $pop498
	tee_local	$push496=, $3=, $pop497
	i64.const	$push495=, 0
	i64.store	0($pop496):p2align=0, $pop495
	i32.const	$push494=, 15
	i32.const	$push493=, 0
	call    	check@FUNCTION, $5, $pop494, $pop493
	i32.const	$push492=, 0
	i64.load8_u	$push41=, A($pop492)
	i64.const	$push491=, 72340172838076673
	i64.mul 	$push490=, $pop41, $pop491
	tee_local	$push489=, $4=, $pop490
	i64.store	0($2):p2align=0, $pop489
	i64.store	0($3):p2align=0, $4
	i32.const	$push488=, 15
	i32.const	$push487=, 65
	call    	check@FUNCTION, $5, $pop488, $pop487
	i64.const	$push486=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop486
	i64.const	$push485=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop485
	i32.const	$push484=, 15
	i32.const	$push483=, 66
	call    	check@FUNCTION, $5, $pop484, $pop483
	i32.const	$push482=, 1
	i32.add 	$push481=, $5, $pop482
	tee_local	$push480=, $5=, $pop481
	i32.const	$push479=, 8
	i32.ne  	$push42=, $pop480, $pop479
	br_if   	0, $pop42       # 0: up to label20
# BB#30:                                # %for.end378
	end_loop
	i32.const	$push43=, 0
	call    	exit@FUNCTION, $pop43
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
