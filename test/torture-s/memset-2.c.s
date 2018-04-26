	.text
	.file	"memset-2.c"
	.section	.text.reset,"ax",@progbits
	.hidden	reset                   # -- Begin function reset
	.globl	reset
	.type	reset,@function
reset:                                  # @reset
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	block   	
	i32.const	$push28=, 1
	i32.lt_s	$push0=, $0, $pop28
	br_if   	0, $pop0        # 0: down to label3
# %bb.1:                                # %for.body.preheader
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
# %bb.3:                                # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push31=, 1
	i32.add 	$3=, $3, $pop31
	i32.lt_s	$push4=, $3, $0
	br_if   	0, $pop4        # 0: up to label4
# %bb.4:                                # %for.end.loopexit
	end_loop
	i32.const	$push5=, u
	i32.add 	$0=, $3, $pop5
	i32.const	$push32=, 1
	i32.ge_s	$push7=, $1, $pop32
	br_if   	1, $pop7        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_5:
	end_block                       # label3:
	i32.const	$0=, u
	i32.const	$push33=, 1
	i32.lt_s	$push6=, $1, $pop33
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
# %bb.8:                                # %for.inc12
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push34=, 1
	i32.add 	$3=, $3, $pop34
	i32.lt_s	$push11=, $3, $1
	br_if   	0, $pop11       # 0: up to label5
# %bb.9:                                # %for.end15.loopexit
	end_loop
	i32.add 	$0=, $0, $3
.LBB1_10:                               # %for.end15
	end_block                       # label1:
	i32.load8_u	$push12=, 0($0)
	i32.const	$push35=, 97
	i32.ne  	$push13=, $pop12, $pop35
	br_if   	0, $pop13       # 0: down to label0
# %bb.11:                               # %for.inc25
	i32.load8_u	$push14=, 1($0)
	i32.const	$push36=, 97
	i32.ne  	$push15=, $pop14, $pop36
	br_if   	0, $pop15       # 0: down to label0
# %bb.12:                               # %for.inc25.1
	i32.load8_u	$push16=, 2($0)
	i32.const	$push37=, 97
	i32.ne  	$push17=, $pop16, $pop37
	br_if   	0, $pop17       # 0: down to label0
# %bb.13:                               # %for.inc25.2
	i32.load8_u	$push18=, 3($0)
	i32.const	$push38=, 97
	i32.ne  	$push19=, $pop18, $pop38
	br_if   	0, $pop19       # 0: down to label0
# %bb.14:                               # %for.inc25.3
	i32.load8_u	$push20=, 4($0)
	i32.const	$push39=, 97
	i32.ne  	$push21=, $pop20, $pop39
	br_if   	0, $pop21       # 0: down to label0
# %bb.15:                               # %for.inc25.4
	i32.load8_u	$push22=, 5($0)
	i32.const	$push40=, 97
	i32.ne  	$push23=, $pop22, $pop40
	br_if   	0, $pop23       # 0: down to label0
# %bb.16:                               # %for.inc25.5
	i32.load8_u	$push24=, 6($0)
	i32.const	$push41=, 97
	i32.ne  	$push25=, $pop24, $pop41
	br_if   	0, $pop25       # 0: down to label0
# %bb.17:                               # %for.inc25.6
	i32.load8_u	$push26=, 7($0)
	i32.const	$push42=, 97
	i32.ne  	$push27=, $pop26, $pop42
	br_if   	0, $pop27       # 0: down to label0
# %bb.18:                               # %for.inc25.7
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
# %bb.0:                                # %entry
	i32.const	$5=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push63=, 0
	i64.const	$push62=, 7016996765293437281
	i64.store	u+23($pop63):p2align=0, $pop62
	i32.const	$push61=, 0
	i64.const	$push60=, 7016996765293437281
	i64.store	u+16($pop61), $pop60
	i32.const	$push59=, 0
	i64.const	$push58=, 7016996765293437281
	i64.store	u+8($pop59), $pop58
	i32.const	$push57=, 0
	i64.const	$push56=, 7016996765293437281
	i64.store	u($pop57), $pop56
	i32.const	$push55=, u
	i32.add 	$2=, $5, $pop55
	i32.const	$push54=, 0
	i32.store8	0($2), $pop54
	i32.const	$push53=, 1
	i32.const	$push52=, 0
	call    	check@FUNCTION, $5, $pop53, $pop52
	i32.const	$push51=, 0
	i32.load8_u	$push0=, A($pop51)
	i32.store8	0($2), $pop0
	i32.const	$push50=, 1
	i32.const	$push49=, 65
	call    	check@FUNCTION, $5, $pop50, $pop49
	i32.const	$push48=, 66
	i32.store8	0($2), $pop48
	i32.const	$push47=, 1
	i32.const	$push46=, 66
	call    	check@FUNCTION, $5, $pop47, $pop46
	i32.const	$push45=, 1
	i32.add 	$5=, $5, $pop45
	i32.const	$push44=, 8
	i32.ne  	$push1=, $5, $pop44
	br_if   	0, $pop1        # 0: up to label6
# %bb.2:                                # %for.body18.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_3:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push84=, 0
	i64.const	$push83=, 7016996765293437281
	i64.store	u+23($pop84):p2align=0, $pop83
	i32.const	$push82=, 0
	i64.const	$push81=, 7016996765293437281
	i64.store	u+16($pop82), $pop81
	i32.const	$push80=, 0
	i64.const	$push79=, 7016996765293437281
	i64.store	u+8($pop80), $pop79
	i32.const	$push78=, 0
	i64.const	$push77=, 7016996765293437281
	i64.store	u($pop78), $pop77
	i32.const	$push76=, u
	i32.add 	$2=, $5, $pop76
	i32.const	$push75=, 0
	i32.store16	0($2):p2align=0, $pop75
	i32.const	$push74=, 2
	i32.const	$push73=, 0
	call    	check@FUNCTION, $5, $pop74, $pop73
	i32.const	$push72=, 0
	i32.load8_u	$push2=, A($pop72)
	i32.const	$push71=, 257
	i32.mul 	$push3=, $pop2, $pop71
	i32.store16	0($2):p2align=0, $pop3
	i32.const	$push70=, 2
	i32.const	$push69=, 65
	call    	check@FUNCTION, $5, $pop70, $pop69
	i32.const	$push68=, 16962
	i32.store16	0($2):p2align=0, $pop68
	i32.const	$push67=, 2
	i32.const	$push66=, 66
	call    	check@FUNCTION, $5, $pop67, $pop66
	i32.const	$push65=, 1
	i32.add 	$5=, $5, $pop65
	i32.const	$push64=, 8
	i32.ne  	$push4=, $5, $pop64
	br_if   	0, $pop4        # 0: up to label7
# %bb.4:                                # %for.body44.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_5:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push108=, 0
	i64.const	$push107=, 7016996765293437281
	i64.store	u+23($pop108):p2align=0, $pop107
	i32.const	$push106=, 0
	i64.const	$push105=, 7016996765293437281
	i64.store	u+16($pop106), $pop105
	i32.const	$push104=, 0
	i64.const	$push103=, 7016996765293437281
	i64.store	u+8($pop104), $pop103
	i32.const	$push102=, 0
	i64.const	$push101=, 7016996765293437281
	i64.store	u($pop102), $pop101
	i32.const	$push100=, u+2
	i32.add 	$2=, $5, $pop100
	i32.const	$push99=, 0
	i32.store8	0($2), $pop99
	i32.const	$push98=, u
	i32.add 	$3=, $5, $pop98
	i32.const	$push97=, 0
	i32.store16	0($3):p2align=0, $pop97
	i32.const	$push96=, 3
	i32.const	$push95=, 0
	call    	check@FUNCTION, $5, $pop96, $pop95
	i32.const	$push94=, 0
	i32.load8_u	$0=, A($pop94)
	i32.store8	0($2), $0
	i32.const	$push93=, 257
	i32.mul 	$push5=, $0, $pop93
	i32.store16	0($3):p2align=0, $pop5
	i32.const	$push92=, 3
	i32.const	$push91=, 65
	call    	check@FUNCTION, $5, $pop92, $pop91
	i32.const	$push90=, 66
	i32.store8	0($2), $pop90
	i32.const	$push89=, 16962
	i32.store16	0($3):p2align=0, $pop89
	i32.const	$push88=, 3
	i32.const	$push87=, 66
	call    	check@FUNCTION, $5, $pop88, $pop87
	i32.const	$push86=, 1
	i32.add 	$5=, $5, $pop86
	i32.const	$push85=, 8
	i32.ne  	$push6=, $5, $pop85
	br_if   	0, $pop6        # 0: up to label8
# %bb.6:                                # %for.body70.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_7:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push129=, 0
	i64.const	$push128=, 7016996765293437281
	i64.store	u+23($pop129):p2align=0, $pop128
	i32.const	$push127=, 0
	i64.const	$push126=, 7016996765293437281
	i64.store	u+16($pop127), $pop126
	i32.const	$push125=, 0
	i64.const	$push124=, 7016996765293437281
	i64.store	u+8($pop125), $pop124
	i32.const	$push123=, 0
	i64.const	$push122=, 7016996765293437281
	i64.store	u($pop123), $pop122
	i32.const	$push121=, u
	i32.add 	$2=, $5, $pop121
	i32.const	$push120=, 0
	i32.store	0($2):p2align=0, $pop120
	i32.const	$push119=, 4
	i32.const	$push118=, 0
	call    	check@FUNCTION, $5, $pop119, $pop118
	i32.const	$push117=, 0
	i32.load8_u	$push7=, A($pop117)
	i32.const	$push116=, 16843009
	i32.mul 	$push8=, $pop7, $pop116
	i32.store	0($2):p2align=0, $pop8
	i32.const	$push115=, 4
	i32.const	$push114=, 65
	call    	check@FUNCTION, $5, $pop115, $pop114
	i32.const	$push113=, 1111638594
	i32.store	0($2):p2align=0, $pop113
	i32.const	$push112=, 4
	i32.const	$push111=, 66
	call    	check@FUNCTION, $5, $pop112, $pop111
	i32.const	$push110=, 1
	i32.add 	$5=, $5, $pop110
	i32.const	$push109=, 8
	i32.ne  	$push9=, $5, $pop109
	br_if   	0, $pop9        # 0: up to label9
# %bb.8:                                # %for.body96.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_9:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push153=, 0
	i64.const	$push152=, 7016996765293437281
	i64.store	u+23($pop153):p2align=0, $pop152
	i32.const	$push151=, 0
	i64.const	$push150=, 7016996765293437281
	i64.store	u+16($pop151), $pop150
	i32.const	$push149=, 0
	i64.const	$push148=, 7016996765293437281
	i64.store	u+8($pop149), $pop148
	i32.const	$push147=, 0
	i64.const	$push146=, 7016996765293437281
	i64.store	u($pop147), $pop146
	i32.const	$push145=, u+4
	i32.add 	$2=, $5, $pop145
	i32.const	$push144=, 0
	i32.store8	0($2), $pop144
	i32.const	$push143=, u
	i32.add 	$3=, $5, $pop143
	i32.const	$push142=, 0
	i32.store	0($3):p2align=0, $pop142
	i32.const	$push141=, 5
	i32.const	$push140=, 0
	call    	check@FUNCTION, $5, $pop141, $pop140
	i32.const	$push139=, 0
	i32.load8_u	$0=, A($pop139)
	i32.store8	0($2), $0
	i32.const	$push138=, 16843009
	i32.mul 	$push10=, $0, $pop138
	i32.store	0($3):p2align=0, $pop10
	i32.const	$push137=, 5
	i32.const	$push136=, 65
	call    	check@FUNCTION, $5, $pop137, $pop136
	i32.const	$push135=, 66
	i32.store8	0($2), $pop135
	i32.const	$push134=, 1111638594
	i32.store	0($3):p2align=0, $pop134
	i32.const	$push133=, 5
	i32.const	$push132=, 66
	call    	check@FUNCTION, $5, $pop133, $pop132
	i32.const	$push131=, 1
	i32.add 	$5=, $5, $pop131
	i32.const	$push130=, 8
	i32.ne  	$push11=, $5, $pop130
	br_if   	0, $pop11       # 0: up to label10
# %bb.10:                               # %for.body122.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_11:                               # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push178=, 0
	i64.const	$push177=, 7016996765293437281
	i64.store	u+23($pop178):p2align=0, $pop177
	i32.const	$push176=, 0
	i64.const	$push175=, 7016996765293437281
	i64.store	u+16($pop176), $pop175
	i32.const	$push174=, 0
	i64.const	$push173=, 7016996765293437281
	i64.store	u+8($pop174), $pop173
	i32.const	$push172=, 0
	i64.const	$push171=, 7016996765293437281
	i64.store	u($pop172), $pop171
	i32.const	$push170=, u+4
	i32.add 	$2=, $5, $pop170
	i32.const	$push169=, 0
	i32.store16	0($2):p2align=0, $pop169
	i32.const	$push168=, u
	i32.add 	$3=, $5, $pop168
	i32.const	$push167=, 0
	i32.store	0($3):p2align=0, $pop167
	i32.const	$push166=, 6
	i32.const	$push165=, 0
	call    	check@FUNCTION, $5, $pop166, $pop165
	i32.const	$push164=, 0
	i32.load8_u	$0=, A($pop164)
	i32.const	$push163=, 257
	i32.mul 	$push12=, $0, $pop163
	i32.store16	0($2):p2align=0, $pop12
	i32.const	$push162=, 16843009
	i32.mul 	$push13=, $0, $pop162
	i32.store	0($3):p2align=0, $pop13
	i32.const	$push161=, 6
	i32.const	$push160=, 65
	call    	check@FUNCTION, $5, $pop161, $pop160
	i32.const	$push159=, 16962
	i32.store16	0($2):p2align=0, $pop159
	i32.const	$push158=, 1111638594
	i32.store	0($3):p2align=0, $pop158
	i32.const	$push157=, 6
	i32.const	$push156=, 66
	call    	check@FUNCTION, $5, $pop157, $pop156
	i32.const	$push155=, 1
	i32.add 	$5=, $5, $pop155
	i32.const	$push154=, 8
	i32.ne  	$push14=, $5, $pop154
	br_if   	0, $pop14       # 0: up to label11
# %bb.12:                               # %for.body148.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_13:                               # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	i32.const	$push206=, 0
	i64.const	$push205=, 7016996765293437281
	i64.store	u+23($pop206):p2align=0, $pop205
	i32.const	$push204=, 0
	i64.const	$push203=, 7016996765293437281
	i64.store	u+16($pop204), $pop203
	i32.const	$push202=, 0
	i64.const	$push201=, 7016996765293437281
	i64.store	u+8($pop202), $pop201
	i32.const	$push200=, 0
	i64.const	$push199=, 7016996765293437281
	i64.store	u($pop200), $pop199
	i32.const	$push198=, u+6
	i32.add 	$2=, $5, $pop198
	i32.const	$push197=, 0
	i32.store8	0($2), $pop197
	i32.const	$push196=, u+4
	i32.add 	$3=, $5, $pop196
	i32.const	$push195=, 0
	i32.store16	0($3):p2align=0, $pop195
	i32.const	$push194=, u
	i32.add 	$0=, $5, $pop194
	i32.const	$push193=, 0
	i32.store	0($0):p2align=0, $pop193
	i32.const	$push192=, 7
	i32.const	$push191=, 0
	call    	check@FUNCTION, $5, $pop192, $pop191
	i32.const	$push190=, 0
	i32.load8_u	$1=, A($pop190)
	i32.store8	0($2), $1
	i32.const	$push189=, 257
	i32.mul 	$push15=, $1, $pop189
	i32.store16	0($3):p2align=0, $pop15
	i32.const	$push188=, 16843009
	i32.mul 	$push16=, $1, $pop188
	i32.store	0($0):p2align=0, $pop16
	i32.const	$push187=, 7
	i32.const	$push186=, 65
	call    	check@FUNCTION, $5, $pop187, $pop186
	i32.const	$push185=, 66
	i32.store8	0($2), $pop185
	i32.const	$push184=, 16962
	i32.store16	0($3):p2align=0, $pop184
	i32.const	$push183=, 1111638594
	i32.store	0($0):p2align=0, $pop183
	i32.const	$push182=, 7
	i32.const	$push181=, 66
	call    	check@FUNCTION, $5, $pop182, $pop181
	i32.const	$push180=, 1
	i32.add 	$5=, $5, $pop180
	i32.const	$push179=, 8
	i32.ne  	$push17=, $5, $pop179
	br_if   	0, $pop17       # 0: up to label12
# %bb.14:                               # %for.body174.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_15:                               # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push227=, 0
	i64.const	$push226=, 7016996765293437281
	i64.store	u+23($pop227):p2align=0, $pop226
	i32.const	$push225=, 0
	i64.const	$push224=, 7016996765293437281
	i64.store	u+16($pop225), $pop224
	i32.const	$push223=, 0
	i64.const	$push222=, 7016996765293437281
	i64.store	u+8($pop223), $pop222
	i32.const	$push221=, 0
	i64.const	$push220=, 7016996765293437281
	i64.store	u($pop221), $pop220
	i32.const	$push219=, u
	i32.add 	$2=, $5, $pop219
	i64.const	$push218=, 0
	i64.store	0($2):p2align=0, $pop218
	i32.const	$push217=, 8
	i32.const	$push216=, 0
	call    	check@FUNCTION, $5, $pop217, $pop216
	i32.const	$push215=, 0
	i64.load8_u	$push18=, A($pop215)
	i64.const	$push214=, 72340172838076673
	i64.mul 	$push19=, $pop18, $pop214
	i64.store	0($2):p2align=0, $pop19
	i32.const	$push213=, 8
	i32.const	$push212=, 65
	call    	check@FUNCTION, $5, $pop213, $pop212
	i64.const	$push211=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop211
	i32.const	$push210=, 8
	i32.const	$push209=, 66
	call    	check@FUNCTION, $5, $pop210, $pop209
	i32.const	$push208=, 1
	i32.add 	$5=, $5, $pop208
	i32.const	$push207=, 8
	i32.ne  	$push20=, $5, $pop207
	br_if   	0, $pop20       # 0: up to label13
# %bb.16:                               # %for.body200.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_17:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
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
	i32.const	$push244=, u+8
	i32.add 	$2=, $5, $pop244
	i32.const	$push243=, 0
	i32.store8	0($2), $pop243
	i32.const	$push242=, u
	i32.add 	$3=, $5, $pop242
	i64.const	$push241=, 0
	i64.store	0($3):p2align=0, $pop241
	i32.const	$push240=, 9
	i32.const	$push239=, 0
	call    	check@FUNCTION, $5, $pop240, $pop239
	i32.const	$push238=, 0
	i32.load8_u	$0=, A($pop238)
	i32.store8	0($2), $0
	i64.extend_u/i32	$push21=, $0
	i64.const	$push237=, 255
	i64.and 	$push22=, $pop21, $pop237
	i64.const	$push236=, 72340172838076673
	i64.mul 	$push23=, $pop22, $pop236
	i64.store	0($3):p2align=0, $pop23
	i32.const	$push235=, 9
	i32.const	$push234=, 65
	call    	check@FUNCTION, $5, $pop235, $pop234
	i32.const	$push233=, 66
	i32.store8	0($2), $pop233
	i64.const	$push232=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop232
	i32.const	$push231=, 9
	i32.const	$push230=, 66
	call    	check@FUNCTION, $5, $pop231, $pop230
	i32.const	$push229=, 1
	i32.add 	$5=, $5, $pop229
	i32.const	$push228=, 8
	i32.ne  	$push24=, $5, $pop228
	br_if   	0, $pop24       # 0: up to label14
# %bb.18:                               # %for.body226.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_19:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
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
	i32.const	$push269=, u+8
	i32.add 	$2=, $5, $pop269
	i32.const	$push268=, 0
	i32.store16	0($2):p2align=0, $pop268
	i32.const	$push267=, u
	i32.add 	$3=, $5, $pop267
	i64.const	$push266=, 0
	i64.store	0($3):p2align=0, $pop266
	i32.const	$push265=, 10
	i32.const	$push264=, 0
	call    	check@FUNCTION, $5, $pop265, $pop264
	i32.const	$push263=, 0
	i32.load8_u	$0=, A($pop263)
	i32.const	$push262=, 257
	i32.mul 	$push25=, $0, $pop262
	i32.store16	0($2):p2align=0, $pop25
	i64.extend_u/i32	$push26=, $0
	i64.const	$push261=, 72340172838076673
	i64.mul 	$push27=, $pop26, $pop261
	i64.store	0($3):p2align=0, $pop27
	i32.const	$push260=, 10
	i32.const	$push259=, 65
	call    	check@FUNCTION, $5, $pop260, $pop259
	i32.const	$push258=, 16962
	i32.store16	0($2):p2align=0, $pop258
	i64.const	$push257=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop257
	i32.const	$push256=, 10
	i32.const	$push255=, 66
	call    	check@FUNCTION, $5, $pop256, $pop255
	i32.const	$push254=, 1
	i32.add 	$5=, $5, $pop254
	i32.const	$push253=, 8
	i32.ne  	$push28=, $5, $pop253
	br_if   	0, $pop28       # 0: up to label15
# %bb.20:                               # %for.body252.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_21:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push305=, 0
	i64.const	$push304=, 7016996765293437281
	i64.store	u+23($pop305):p2align=0, $pop304
	i32.const	$push303=, 0
	i64.const	$push302=, 7016996765293437281
	i64.store	u+16($pop303), $pop302
	i32.const	$push301=, 0
	i64.const	$push300=, 7016996765293437281
	i64.store	u+8($pop301), $pop300
	i32.const	$push299=, 0
	i64.const	$push298=, 7016996765293437281
	i64.store	u($pop299), $pop298
	i32.const	$push297=, u+10
	i32.add 	$2=, $5, $pop297
	i32.const	$push296=, 0
	i32.store8	0($2), $pop296
	i32.const	$push295=, u+8
	i32.add 	$3=, $5, $pop295
	i32.const	$push294=, 0
	i32.store16	0($3):p2align=0, $pop294
	i32.const	$push293=, u
	i32.add 	$0=, $5, $pop293
	i64.const	$push292=, 0
	i64.store	0($0):p2align=0, $pop292
	i32.const	$push291=, 11
	i32.const	$push290=, 0
	call    	check@FUNCTION, $5, $pop291, $pop290
	i32.const	$push289=, 0
	i32.load8_u	$1=, A($pop289)
	i32.store8	0($2), $1
	i32.const	$push288=, 257
	i32.mul 	$push29=, $1, $pop288
	i32.store16	0($3):p2align=0, $pop29
	i64.extend_u/i32	$push30=, $1
	i64.const	$push287=, 72340172838076673
	i64.mul 	$push31=, $pop30, $pop287
	i64.store	0($0):p2align=0, $pop31
	i32.const	$push286=, 11
	i32.const	$push285=, 65
	call    	check@FUNCTION, $5, $pop286, $pop285
	i32.const	$push284=, 66
	i32.store8	0($2), $pop284
	i32.const	$push283=, 16962
	i32.store16	0($3):p2align=0, $pop283
	i64.const	$push282=, 4774451407313060418
	i64.store	0($0):p2align=0, $pop282
	i32.const	$push281=, 11
	i32.const	$push280=, 66
	call    	check@FUNCTION, $5, $pop281, $pop280
	i32.const	$push279=, 1
	i32.add 	$5=, $5, $pop279
	i32.const	$push278=, 8
	i32.ne  	$push32=, $5, $pop278
	br_if   	0, $pop32       # 0: up to label16
# %bb.22:                               # %for.body278.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_23:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push330=, 0
	i64.const	$push329=, 7016996765293437281
	i64.store	u+23($pop330):p2align=0, $pop329
	i32.const	$push328=, 0
	i64.const	$push327=, 7016996765293437281
	i64.store	u+16($pop328), $pop327
	i32.const	$push326=, 0
	i64.const	$push325=, 7016996765293437281
	i64.store	u+8($pop326), $pop325
	i32.const	$push324=, 0
	i64.const	$push323=, 7016996765293437281
	i64.store	u($pop324), $pop323
	i32.const	$push322=, u+8
	i32.add 	$2=, $5, $pop322
	i32.const	$push321=, 0
	i32.store	0($2):p2align=0, $pop321
	i32.const	$push320=, u
	i32.add 	$3=, $5, $pop320
	i64.const	$push319=, 0
	i64.store	0($3):p2align=0, $pop319
	i32.const	$push318=, 12
	i32.const	$push317=, 0
	call    	check@FUNCTION, $5, $pop318, $pop317
	i32.const	$push316=, 0
	i32.load8_u	$0=, A($pop316)
	i32.const	$push315=, 16843009
	i32.mul 	$push33=, $0, $pop315
	i32.store	0($2):p2align=0, $pop33
	i64.extend_u/i32	$push34=, $0
	i64.const	$push314=, 72340172838076673
	i64.mul 	$push35=, $pop34, $pop314
	i64.store	0($3):p2align=0, $pop35
	i32.const	$push313=, 12
	i32.const	$push312=, 65
	call    	check@FUNCTION, $5, $pop313, $pop312
	i32.const	$push311=, 1111638594
	i32.store	0($2):p2align=0, $pop311
	i64.const	$push310=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop310
	i32.const	$push309=, 12
	i32.const	$push308=, 66
	call    	check@FUNCTION, $5, $pop309, $pop308
	i32.const	$push307=, 1
	i32.add 	$5=, $5, $pop307
	i32.const	$push306=, 8
	i32.ne  	$push36=, $5, $pop306
	br_if   	0, $pop36       # 0: up to label17
# %bb.24:                               # %for.body304.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_25:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push354=, 0
	i64.const	$push353=, 7016996765293437281
	i64.store	u+23($pop354):p2align=0, $pop353
	i32.const	$push352=, 0
	i64.const	$push351=, 7016996765293437281
	i64.store	u+16($pop352), $pop351
	i32.const	$push350=, 0
	i64.const	$push349=, 7016996765293437281
	i64.store	u+8($pop350), $pop349
	i32.const	$push348=, 0
	i64.const	$push347=, 7016996765293437281
	i64.store	u($pop348), $pop347
	i32.const	$push346=, u+5
	i32.add 	$2=, $5, $pop346
	i64.const	$push345=, 0
	i64.store	0($2):p2align=0, $pop345
	i32.const	$push344=, u
	i32.add 	$3=, $5, $pop344
	i64.const	$push343=, 0
	i64.store	0($3):p2align=0, $pop343
	i32.const	$push342=, 13
	i32.const	$push341=, 0
	call    	check@FUNCTION, $5, $pop342, $pop341
	i32.const	$push340=, 0
	i64.load8_u	$push37=, A($pop340)
	i64.const	$push339=, 72340172838076673
	i64.mul 	$4=, $pop37, $pop339
	i64.store	0($2):p2align=0, $4
	i64.store	0($3):p2align=0, $4
	i32.const	$push338=, 13
	i32.const	$push337=, 65
	call    	check@FUNCTION, $5, $pop338, $pop337
	i64.const	$push336=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop336
	i64.const	$push335=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop335
	i32.const	$push334=, 13
	i32.const	$push333=, 66
	call    	check@FUNCTION, $5, $pop334, $pop333
	i32.const	$push332=, 1
	i32.add 	$5=, $5, $pop332
	i32.const	$push331=, 8
	i32.ne  	$push38=, $5, $pop331
	br_if   	0, $pop38       # 0: up to label18
# %bb.26:                               # %for.body330.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_27:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push378=, 0
	i64.const	$push377=, 7016996765293437281
	i64.store	u+23($pop378):p2align=0, $pop377
	i32.const	$push376=, 0
	i64.const	$push375=, 7016996765293437281
	i64.store	u+16($pop376), $pop375
	i32.const	$push374=, 0
	i64.const	$push373=, 7016996765293437281
	i64.store	u+8($pop374), $pop373
	i32.const	$push372=, 0
	i64.const	$push371=, 7016996765293437281
	i64.store	u($pop372), $pop371
	i32.const	$push370=, u+6
	i32.add 	$2=, $5, $pop370
	i64.const	$push369=, 0
	i64.store	0($2):p2align=0, $pop369
	i32.const	$push368=, u
	i32.add 	$3=, $5, $pop368
	i64.const	$push367=, 0
	i64.store	0($3):p2align=0, $pop367
	i32.const	$push366=, 14
	i32.const	$push365=, 0
	call    	check@FUNCTION, $5, $pop366, $pop365
	i32.const	$push364=, 0
	i64.load8_u	$push39=, A($pop364)
	i64.const	$push363=, 72340172838076673
	i64.mul 	$4=, $pop39, $pop363
	i64.store	0($2):p2align=0, $4
	i64.store	0($3):p2align=0, $4
	i32.const	$push362=, 14
	i32.const	$push361=, 65
	call    	check@FUNCTION, $5, $pop362, $pop361
	i64.const	$push360=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop360
	i64.const	$push359=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop359
	i32.const	$push358=, 14
	i32.const	$push357=, 66
	call    	check@FUNCTION, $5, $pop358, $pop357
	i32.const	$push356=, 1
	i32.add 	$5=, $5, $pop356
	i32.const	$push355=, 8
	i32.ne  	$push40=, $5, $pop355
	br_if   	0, $pop40       # 0: up to label19
# %bb.28:                               # %for.body356.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_29:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push402=, 0
	i64.const	$push401=, 7016996765293437281
	i64.store	u+23($pop402):p2align=0, $pop401
	i32.const	$push400=, 0
	i64.const	$push399=, 7016996765293437281
	i64.store	u+16($pop400), $pop399
	i32.const	$push398=, 0
	i64.const	$push397=, 7016996765293437281
	i64.store	u+8($pop398), $pop397
	i32.const	$push396=, 0
	i64.const	$push395=, 7016996765293437281
	i64.store	u($pop396), $pop395
	i32.const	$push394=, u+7
	i32.add 	$2=, $5, $pop394
	i64.const	$push393=, 0
	i64.store	0($2):p2align=0, $pop393
	i32.const	$push392=, u
	i32.add 	$3=, $5, $pop392
	i64.const	$push391=, 0
	i64.store	0($3):p2align=0, $pop391
	i32.const	$push390=, 15
	i32.const	$push389=, 0
	call    	check@FUNCTION, $5, $pop390, $pop389
	i32.const	$push388=, 0
	i64.load8_u	$push41=, A($pop388)
	i64.const	$push387=, 72340172838076673
	i64.mul 	$4=, $pop41, $pop387
	i64.store	0($2):p2align=0, $4
	i64.store	0($3):p2align=0, $4
	i32.const	$push386=, 15
	i32.const	$push385=, 65
	call    	check@FUNCTION, $5, $pop386, $pop385
	i64.const	$push384=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop384
	i64.const	$push383=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop383
	i32.const	$push382=, 15
	i32.const	$push381=, 66
	call    	check@FUNCTION, $5, $pop382, $pop381
	i32.const	$push380=, 1
	i32.add 	$5=, $5, $pop380
	i32.const	$push379=, 8
	i32.ne  	$push42=, $5, $pop379
	br_if   	0, $pop42       # 0: up to label20
# %bb.30:                               # %for.end378
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
