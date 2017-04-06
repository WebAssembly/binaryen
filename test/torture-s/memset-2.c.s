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
# BB#4:                                 # %for.cond3.preheader.loopexit
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
# BB#9:                                 # %for.body19.preheader.loopexit
	end_loop
	i32.add 	$0=, $0, $3
.LBB1_10:                               # %for.body19.preheader
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push62=, u
	i32.const	$push61=, 97
	i32.const	$push60=, 31
	i32.call	$push0=, memset@FUNCTION, $pop62, $pop61, $pop60
	i32.add 	$push59=, $5, $pop0
	tee_local	$push58=, $0=, $pop59
	i32.const	$push57=, 0
	i32.store8	0($pop58), $pop57
	i32.const	$push56=, 1
	i32.const	$push55=, 0
	call    	check@FUNCTION, $5, $pop56, $pop55
	i32.const	$push54=, 0
	i32.load8_u	$push4=, A($pop54)
	i32.store8	0($0), $pop4
	i32.const	$push53=, 1
	i32.const	$push52=, 65
	call    	check@FUNCTION, $5, $pop53, $pop52
	i32.const	$push51=, 66
	i32.store8	0($0), $pop51
	i32.const	$push50=, 1
	i32.const	$push49=, 66
	call    	check@FUNCTION, $5, $pop50, $pop49
	i32.const	$push48=, 1
	i32.add 	$push47=, $5, $pop48
	tee_local	$push46=, $5=, $pop47
	i32.const	$push45=, 8
	i32.ne  	$push5=, $pop46, $pop45
	br_if   	0, $pop5        # 0: up to label6
# BB#2:                                 # %for.body18.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_3:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push81=, u
	i32.const	$push80=, 97
	i32.const	$push79=, 31
	i32.call	$push1=, memset@FUNCTION, $pop81, $pop80, $pop79
	i32.add 	$push78=, $5, $pop1
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 0
	i32.store16	0($pop77):p2align=0, $pop76
	i32.const	$push75=, 2
	i32.const	$push74=, 0
	call    	check@FUNCTION, $5, $pop75, $pop74
	i32.const	$push73=, 0
	i32.load8_u	$push6=, A($pop73)
	i32.const	$push72=, 257
	i32.mul 	$push7=, $pop6, $pop72
	i32.store16	0($0):p2align=0, $pop7
	i32.const	$push71=, 2
	i32.const	$push70=, 65
	call    	check@FUNCTION, $5, $pop71, $pop70
	i32.const	$push69=, 16962
	i32.store16	0($0):p2align=0, $pop69
	i32.const	$push68=, 2
	i32.const	$push67=, 66
	call    	check@FUNCTION, $5, $pop68, $pop67
	i32.const	$push66=, 1
	i32.add 	$push65=, $5, $pop66
	tee_local	$push64=, $5=, $pop65
	i32.const	$push63=, 8
	i32.ne  	$push8=, $pop64, $pop63
	br_if   	0, $pop8        # 0: up to label7
# BB#4:                                 # %for.body44.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_5:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push107=, u
	i32.const	$push106=, 97
	i32.const	$push105=, 31
	i32.call	$1=, memset@FUNCTION, $pop107, $pop106, $pop105
	i32.const	$push104=, u+2
	i32.add 	$push103=, $5, $pop104
	tee_local	$push102=, $0=, $pop103
	i32.const	$push101=, 0
	i32.store8	0($pop102), $pop101
	i32.add 	$push100=, $5, $1
	tee_local	$push99=, $1=, $pop100
	i32.const	$push98=, 0
	i32.store16	0($pop99):p2align=0, $pop98
	i32.const	$push97=, 3
	i32.const	$push96=, 0
	call    	check@FUNCTION, $5, $pop97, $pop96
	i32.const	$push95=, 0
	i32.load8_u	$push94=, A($pop95)
	tee_local	$push93=, $2=, $pop94
	i32.store8	0($0), $pop93
	i32.const	$push92=, 257
	i32.mul 	$push9=, $2, $pop92
	i32.store16	0($1):p2align=0, $pop9
	i32.const	$push91=, 3
	i32.const	$push90=, 65
	call    	check@FUNCTION, $5, $pop91, $pop90
	i32.const	$push89=, 66
	i32.store8	0($0), $pop89
	i32.const	$push88=, 16962
	i32.store16	0($1):p2align=0, $pop88
	i32.const	$push87=, 3
	i32.const	$push86=, 66
	call    	check@FUNCTION, $5, $pop87, $pop86
	i32.const	$push85=, 1
	i32.add 	$push84=, $5, $pop85
	tee_local	$push83=, $5=, $pop84
	i32.const	$push82=, 8
	i32.ne  	$push10=, $pop83, $pop82
	br_if   	0, $pop10       # 0: up to label8
# BB#6:                                 # %for.body70.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_7:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push126=, u
	i32.const	$push125=, 97
	i32.const	$push124=, 31
	i32.call	$push2=, memset@FUNCTION, $pop126, $pop125, $pop124
	i32.add 	$push123=, $5, $pop2
	tee_local	$push122=, $0=, $pop123
	i32.const	$push121=, 0
	i32.store	0($pop122):p2align=0, $pop121
	i32.const	$push120=, 4
	i32.const	$push119=, 0
	call    	check@FUNCTION, $5, $pop120, $pop119
	i32.const	$push118=, 0
	i32.load8_u	$push11=, A($pop118)
	i32.const	$push117=, 16843009
	i32.mul 	$push12=, $pop11, $pop117
	i32.store	0($0):p2align=0, $pop12
	i32.const	$push116=, 4
	i32.const	$push115=, 65
	call    	check@FUNCTION, $5, $pop116, $pop115
	i32.const	$push114=, 1111638594
	i32.store	0($0):p2align=0, $pop114
	i32.const	$push113=, 4
	i32.const	$push112=, 66
	call    	check@FUNCTION, $5, $pop113, $pop112
	i32.const	$push111=, 1
	i32.add 	$push110=, $5, $pop111
	tee_local	$push109=, $5=, $pop110
	i32.const	$push108=, 8
	i32.ne  	$push13=, $pop109, $pop108
	br_if   	0, $pop13       # 0: up to label9
# BB#8:                                 # %for.body96.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_9:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push152=, u
	i32.const	$push151=, 97
	i32.const	$push150=, 31
	i32.call	$1=, memset@FUNCTION, $pop152, $pop151, $pop150
	i32.const	$push149=, u+4
	i32.add 	$push148=, $5, $pop149
	tee_local	$push147=, $0=, $pop148
	i32.const	$push146=, 0
	i32.store8	0($pop147), $pop146
	i32.add 	$push145=, $5, $1
	tee_local	$push144=, $1=, $pop145
	i32.const	$push143=, 0
	i32.store	0($pop144):p2align=0, $pop143
	i32.const	$push142=, 5
	i32.const	$push141=, 0
	call    	check@FUNCTION, $5, $pop142, $pop141
	i32.const	$push140=, 0
	i32.load8_u	$push139=, A($pop140)
	tee_local	$push138=, $2=, $pop139
	i32.store8	0($0), $pop138
	i32.const	$push137=, 16843009
	i32.mul 	$push14=, $2, $pop137
	i32.store	0($1):p2align=0, $pop14
	i32.const	$push136=, 5
	i32.const	$push135=, 65
	call    	check@FUNCTION, $5, $pop136, $pop135
	i32.const	$push134=, 66
	i32.store8	0($0), $pop134
	i32.const	$push133=, 1111638594
	i32.store	0($1):p2align=0, $pop133
	i32.const	$push132=, 5
	i32.const	$push131=, 66
	call    	check@FUNCTION, $5, $pop132, $pop131
	i32.const	$push130=, 1
	i32.add 	$push129=, $5, $pop130
	tee_local	$push128=, $5=, $pop129
	i32.const	$push127=, 8
	i32.ne  	$push15=, $pop128, $pop127
	br_if   	0, $pop15       # 0: up to label10
# BB#10:                                # %for.body122.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_11:                               # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push179=, u
	i32.const	$push178=, 97
	i32.const	$push177=, 31
	i32.call	$1=, memset@FUNCTION, $pop179, $pop178, $pop177
	i32.const	$push176=, u+4
	i32.add 	$push175=, $5, $pop176
	tee_local	$push174=, $0=, $pop175
	i32.const	$push173=, 0
	i32.store16	0($pop174):p2align=0, $pop173
	i32.add 	$push172=, $5, $1
	tee_local	$push171=, $1=, $pop172
	i32.const	$push170=, 0
	i32.store	0($pop171):p2align=0, $pop170
	i32.const	$push169=, 6
	i32.const	$push168=, 0
	call    	check@FUNCTION, $5, $pop169, $pop168
	i32.const	$push167=, 0
	i32.load8_u	$push166=, A($pop167)
	tee_local	$push165=, $2=, $pop166
	i32.const	$push164=, 257
	i32.mul 	$push16=, $pop165, $pop164
	i32.store16	0($0):p2align=0, $pop16
	i32.const	$push163=, 16843009
	i32.mul 	$push17=, $2, $pop163
	i32.store	0($1):p2align=0, $pop17
	i32.const	$push162=, 6
	i32.const	$push161=, 65
	call    	check@FUNCTION, $5, $pop162, $pop161
	i32.const	$push160=, 16962
	i32.store16	0($0):p2align=0, $pop160
	i32.const	$push159=, 1111638594
	i32.store	0($1):p2align=0, $pop159
	i32.const	$push158=, 6
	i32.const	$push157=, 66
	call    	check@FUNCTION, $5, $pop158, $pop157
	i32.const	$push156=, 1
	i32.add 	$push155=, $5, $pop156
	tee_local	$push154=, $5=, $pop155
	i32.const	$push153=, 8
	i32.ne  	$push18=, $pop154, $pop153
	br_if   	0, $pop18       # 0: up to label11
# BB#12:                                # %for.body148.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_13:                               # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	i32.const	$push211=, u
	i32.const	$push210=, 97
	i32.const	$push209=, 31
	i32.call	$2=, memset@FUNCTION, $pop211, $pop210, $pop209
	i32.const	$push208=, u+6
	i32.add 	$push207=, $5, $pop208
	tee_local	$push206=, $0=, $pop207
	i32.const	$push205=, 0
	i32.store8	0($pop206), $pop205
	i32.const	$push204=, u+4
	i32.add 	$push203=, $5, $pop204
	tee_local	$push202=, $1=, $pop203
	i32.const	$push201=, 0
	i32.store16	0($pop202):p2align=0, $pop201
	i32.add 	$push200=, $5, $2
	tee_local	$push199=, $2=, $pop200
	i32.const	$push198=, 0
	i32.store	0($pop199):p2align=0, $pop198
	i32.const	$push197=, 7
	i32.const	$push196=, 0
	call    	check@FUNCTION, $5, $pop197, $pop196
	i32.const	$push195=, 0
	i32.load8_u	$push194=, A($pop195)
	tee_local	$push193=, $3=, $pop194
	i32.store8	0($0), $pop193
	i32.const	$push192=, 257
	i32.mul 	$push19=, $3, $pop192
	i32.store16	0($1):p2align=0, $pop19
	i32.const	$push191=, 16843009
	i32.mul 	$push20=, $3, $pop191
	i32.store	0($2):p2align=0, $pop20
	i32.const	$push190=, 7
	i32.const	$push189=, 65
	call    	check@FUNCTION, $5, $pop190, $pop189
	i32.const	$push188=, 66
	i32.store8	0($0), $pop188
	i32.const	$push187=, 16962
	i32.store16	0($1):p2align=0, $pop187
	i32.const	$push186=, 1111638594
	i32.store	0($2):p2align=0, $pop186
	i32.const	$push185=, 7
	i32.const	$push184=, 66
	call    	check@FUNCTION, $5, $pop185, $pop184
	i32.const	$push183=, 1
	i32.add 	$push182=, $5, $pop183
	tee_local	$push181=, $5=, $pop182
	i32.const	$push180=, 8
	i32.ne  	$push21=, $pop181, $pop180
	br_if   	0, $pop21       # 0: up to label12
# BB#14:                                # %for.body174.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_15:                               # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push233=, u
	i32.const	$push232=, 97
	i32.const	$push231=, 31
	i32.call	$push3=, memset@FUNCTION, $pop233, $pop232, $pop231
	i32.add 	$push230=, $5, $pop3
	tee_local	$push229=, $0=, $pop230
	i64.const	$push228=, 0
	i64.store	0($pop229):p2align=0, $pop228
	i32.const	$push227=, 8
	i32.const	$push226=, 0
	call    	check@FUNCTION, $5, $pop227, $pop226
	i32.const	$push225=, u+4
	i32.add 	$push22=, $5, $pop225
	i32.const	$push224=, 0
	i32.load8_u	$push23=, A($pop224)
	i32.const	$push223=, 16843009
	i32.mul 	$push222=, $pop23, $pop223
	tee_local	$push221=, $1=, $pop222
	i32.store	0($pop22):p2align=0, $pop221
	i32.store	0($0):p2align=0, $1
	i32.const	$push220=, 8
	i32.const	$push219=, 65
	call    	check@FUNCTION, $5, $pop220, $pop219
	i64.const	$push218=, 4774451407313060418
	i64.store	0($0):p2align=0, $pop218
	i32.const	$push217=, 8
	i32.const	$push216=, 66
	call    	check@FUNCTION, $5, $pop217, $pop216
	i32.const	$push215=, 1
	i32.add 	$push214=, $5, $pop215
	tee_local	$push213=, $5=, $pop214
	i32.const	$push212=, 8
	i32.ne  	$push24=, $pop213, $pop212
	br_if   	0, $pop24       # 0: up to label13
# BB#16:                                # %for.body200.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_17:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push262=, u
	i32.const	$push261=, 97
	i32.const	$push260=, 31
	i32.call	$1=, memset@FUNCTION, $pop262, $pop261, $pop260
	i32.const	$push259=, u+8
	i32.add 	$push258=, $5, $pop259
	tee_local	$push257=, $0=, $pop258
	i32.const	$push256=, 0
	i32.store8	0($pop257), $pop256
	i32.add 	$push255=, $5, $1
	tee_local	$push254=, $1=, $pop255
	i64.const	$push253=, 0
	i64.store	0($pop254):p2align=0, $pop253
	i32.const	$push252=, 9
	i32.const	$push251=, 0
	call    	check@FUNCTION, $5, $pop252, $pop251
	i32.const	$push250=, 0
	i32.load8_u	$push249=, A($pop250)
	tee_local	$push248=, $2=, $pop249
	i32.store8	0($0), $pop248
	i32.const	$push247=, u+4
	i32.add 	$push25=, $5, $pop247
	i32.const	$push246=, 16843009
	i32.mul 	$push245=, $2, $pop246
	tee_local	$push244=, $2=, $pop245
	i32.store	0($pop25):p2align=0, $pop244
	i32.store	0($1):p2align=0, $2
	i32.const	$push243=, 9
	i32.const	$push242=, 65
	call    	check@FUNCTION, $5, $pop243, $pop242
	i32.const	$push241=, 66
	i32.store8	0($0), $pop241
	i64.const	$push240=, 4774451407313060418
	i64.store	0($1):p2align=0, $pop240
	i32.const	$push239=, 9
	i32.const	$push238=, 66
	call    	check@FUNCTION, $5, $pop239, $pop238
	i32.const	$push237=, 1
	i32.add 	$push236=, $5, $pop237
	tee_local	$push235=, $5=, $pop236
	i32.const	$push234=, 8
	i32.ne  	$push26=, $pop235, $pop234
	br_if   	0, $pop26       # 0: up to label14
# BB#18:                                # %for.body226.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_19:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push292=, u
	i32.const	$push291=, 97
	i32.const	$push290=, 31
	i32.call	$1=, memset@FUNCTION, $pop292, $pop291, $pop290
	i32.const	$push289=, u+8
	i32.add 	$push288=, $5, $pop289
	tee_local	$push287=, $0=, $pop288
	i32.const	$push286=, 0
	i32.store16	0($pop287):p2align=0, $pop286
	i32.add 	$push285=, $5, $1
	tee_local	$push284=, $1=, $pop285
	i64.const	$push283=, 0
	i64.store	0($pop284):p2align=0, $pop283
	i32.const	$push282=, 10
	i32.const	$push281=, 0
	call    	check@FUNCTION, $5, $pop282, $pop281
	i32.const	$push280=, 0
	i32.load8_u	$push279=, A($pop280)
	tee_local	$push278=, $2=, $pop279
	i32.const	$push277=, 257
	i32.mul 	$push27=, $pop278, $pop277
	i32.store16	0($0):p2align=0, $pop27
	i32.const	$push276=, u+4
	i32.add 	$push28=, $5, $pop276
	i32.const	$push275=, 16843009
	i32.mul 	$push274=, $2, $pop275
	tee_local	$push273=, $2=, $pop274
	i32.store	0($pop28):p2align=0, $pop273
	i32.store	0($1):p2align=0, $2
	i32.const	$push272=, 10
	i32.const	$push271=, 65
	call    	check@FUNCTION, $5, $pop272, $pop271
	i32.const	$push270=, 16962
	i32.store16	0($0):p2align=0, $pop270
	i64.const	$push269=, 4774451407313060418
	i64.store	0($1):p2align=0, $pop269
	i32.const	$push268=, 10
	i32.const	$push267=, 66
	call    	check@FUNCTION, $5, $pop268, $pop267
	i32.const	$push266=, 1
	i32.add 	$push265=, $5, $pop266
	tee_local	$push264=, $5=, $pop265
	i32.const	$push263=, 8
	i32.ne  	$push29=, $pop264, $pop263
	br_if   	0, $pop29       # 0: up to label15
# BB#20:                                # %for.body252.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_21:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push327=, u
	i32.const	$push326=, 97
	i32.const	$push325=, 31
	i32.call	$2=, memset@FUNCTION, $pop327, $pop326, $pop325
	i32.const	$push324=, u+10
	i32.add 	$push323=, $5, $pop324
	tee_local	$push322=, $0=, $pop323
	i32.const	$push321=, 0
	i32.store8	0($pop322), $pop321
	i32.const	$push320=, u+8
	i32.add 	$push319=, $5, $pop320
	tee_local	$push318=, $1=, $pop319
	i32.const	$push317=, 0
	i32.store16	0($pop318):p2align=0, $pop317
	i32.add 	$push316=, $5, $2
	tee_local	$push315=, $2=, $pop316
	i64.const	$push314=, 0
	i64.store	0($pop315):p2align=0, $pop314
	i32.const	$push313=, 11
	i32.const	$push312=, 0
	call    	check@FUNCTION, $5, $pop313, $pop312
	i32.const	$push311=, 0
	i32.load8_u	$push310=, A($pop311)
	tee_local	$push309=, $3=, $pop310
	i32.store8	0($0), $pop309
	i32.const	$push308=, 257
	i32.mul 	$push30=, $3, $pop308
	i32.store16	0($1):p2align=0, $pop30
	i32.const	$push307=, u+4
	i32.add 	$push31=, $5, $pop307
	i32.const	$push306=, 16843009
	i32.mul 	$push305=, $3, $pop306
	tee_local	$push304=, $3=, $pop305
	i32.store	0($pop31):p2align=0, $pop304
	i32.store	0($2):p2align=0, $3
	i32.const	$push303=, 11
	i32.const	$push302=, 65
	call    	check@FUNCTION, $5, $pop303, $pop302
	i32.const	$push301=, 66
	i32.store8	0($0), $pop301
	i32.const	$push300=, 16962
	i32.store16	0($1):p2align=0, $pop300
	i64.const	$push299=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop299
	i32.const	$push298=, 11
	i32.const	$push297=, 66
	call    	check@FUNCTION, $5, $pop298, $pop297
	i32.const	$push296=, 1
	i32.add 	$push295=, $5, $pop296
	tee_local	$push294=, $5=, $pop295
	i32.const	$push293=, 8
	i32.ne  	$push32=, $pop294, $pop293
	br_if   	0, $pop32       # 0: up to label16
# BB#22:                                # %for.body278.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_23:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push354=, u
	i32.const	$push353=, 97
	i32.const	$push352=, 31
	i32.call	$1=, memset@FUNCTION, $pop354, $pop353, $pop352
	i32.const	$push351=, u+8
	i32.add 	$push350=, $5, $pop351
	tee_local	$push349=, $0=, $pop350
	i32.const	$push348=, 0
	i32.store	0($pop349):p2align=0, $pop348
	i32.add 	$push347=, $5, $1
	tee_local	$push346=, $1=, $pop347
	i64.const	$push345=, 0
	i64.store	0($pop346):p2align=0, $pop345
	i32.const	$push344=, 12
	i32.const	$push343=, 0
	call    	check@FUNCTION, $5, $pop344, $pop343
	i32.const	$push342=, 0
	i32.load8_u	$push33=, A($pop342)
	i32.const	$push341=, 16843009
	i32.mul 	$push340=, $pop33, $pop341
	tee_local	$push339=, $2=, $pop340
	i32.store	0($0):p2align=0, $pop339
	i32.const	$push338=, u+4
	i32.add 	$push34=, $5, $pop338
	i32.store	0($pop34):p2align=0, $2
	i32.store	0($1):p2align=0, $2
	i32.const	$push337=, 12
	i32.const	$push336=, 65
	call    	check@FUNCTION, $5, $pop337, $pop336
	i32.const	$push335=, 1111638594
	i32.store	0($0):p2align=0, $pop335
	i64.const	$push334=, 4774451407313060418
	i64.store	0($1):p2align=0, $pop334
	i32.const	$push333=, 12
	i32.const	$push332=, 66
	call    	check@FUNCTION, $5, $pop333, $pop332
	i32.const	$push331=, 1
	i32.add 	$push330=, $5, $pop331
	tee_local	$push329=, $5=, $pop330
	i32.const	$push328=, 8
	i32.ne  	$push35=, $pop329, $pop328
	br_if   	0, $pop35       # 0: up to label17
# BB#24:                                # %for.body304.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_25:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push388=, u
	i32.const	$push387=, 97
	i32.const	$push386=, 31
	i32.call	$2=, memset@FUNCTION, $pop388, $pop387, $pop386
	i32.const	$push385=, u+12
	i32.add 	$push384=, $5, $pop385
	tee_local	$push383=, $0=, $pop384
	i32.const	$push382=, 0
	i32.store8	0($pop383), $pop382
	i32.const	$push381=, u+8
	i32.add 	$push380=, $5, $pop381
	tee_local	$push379=, $1=, $pop380
	i32.const	$push378=, 0
	i32.store	0($pop379):p2align=0, $pop378
	i32.add 	$push377=, $5, $2
	tee_local	$push376=, $2=, $pop377
	i64.const	$push375=, 0
	i64.store	0($pop376):p2align=0, $pop375
	i32.const	$push374=, 13
	i32.const	$push373=, 0
	call    	check@FUNCTION, $5, $pop374, $pop373
	i32.const	$push372=, 0
	i32.load8_u	$push371=, A($pop372)
	tee_local	$push370=, $3=, $pop371
	i32.store8	0($0), $pop370
	i32.const	$push369=, 16843009
	i32.mul 	$push368=, $3, $pop369
	tee_local	$push367=, $3=, $pop368
	i32.store	0($1):p2align=0, $pop367
	i32.const	$push366=, u+4
	i32.add 	$push36=, $5, $pop366
	i32.store	0($pop36):p2align=0, $3
	i32.store	0($2):p2align=0, $3
	i32.const	$push365=, 13
	i32.const	$push364=, 65
	call    	check@FUNCTION, $5, $pop365, $pop364
	i32.const	$push363=, 66
	i32.store8	0($0), $pop363
	i32.const	$push362=, 1111638594
	i32.store	0($1):p2align=0, $pop362
	i64.const	$push361=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop361
	i32.const	$push360=, 13
	i32.const	$push359=, 66
	call    	check@FUNCTION, $5, $pop360, $pop359
	i32.const	$push358=, 1
	i32.add 	$push357=, $5, $pop358
	tee_local	$push356=, $5=, $pop357
	i32.const	$push355=, 8
	i32.ne  	$push37=, $pop356, $pop355
	br_if   	0, $pop37       # 0: up to label18
# BB#26:                                # %for.body330.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_27:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push423=, u
	i32.const	$push422=, 97
	i32.const	$push421=, 31
	i32.call	$2=, memset@FUNCTION, $pop423, $pop422, $pop421
	i32.const	$push420=, u+12
	i32.add 	$push419=, $5, $pop420
	tee_local	$push418=, $0=, $pop419
	i32.const	$push417=, 0
	i32.store16	0($pop418):p2align=0, $pop417
	i32.const	$push416=, u+8
	i32.add 	$push415=, $5, $pop416
	tee_local	$push414=, $1=, $pop415
	i32.const	$push413=, 0
	i32.store	0($pop414):p2align=0, $pop413
	i32.add 	$push412=, $5, $2
	tee_local	$push411=, $2=, $pop412
	i64.const	$push410=, 0
	i64.store	0($pop411):p2align=0, $pop410
	i32.const	$push409=, 14
	i32.const	$push408=, 0
	call    	check@FUNCTION, $5, $pop409, $pop408
	i32.const	$push407=, 0
	i32.load8_u	$push406=, A($pop407)
	tee_local	$push405=, $3=, $pop406
	i32.const	$push404=, 257
	i32.mul 	$push38=, $pop405, $pop404
	i32.store16	0($0):p2align=0, $pop38
	i32.const	$push403=, 16843009
	i32.mul 	$push402=, $3, $pop403
	tee_local	$push401=, $3=, $pop402
	i32.store	0($1):p2align=0, $pop401
	i32.const	$push400=, u+4
	i32.add 	$push39=, $5, $pop400
	i32.store	0($pop39):p2align=0, $3
	i32.store	0($2):p2align=0, $3
	i32.const	$push399=, 14
	i32.const	$push398=, 65
	call    	check@FUNCTION, $5, $pop399, $pop398
	i32.const	$push397=, 16962
	i32.store16	0($0):p2align=0, $pop397
	i32.const	$push396=, 1111638594
	i32.store	0($1):p2align=0, $pop396
	i64.const	$push395=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop395
	i32.const	$push394=, 14
	i32.const	$push393=, 66
	call    	check@FUNCTION, $5, $pop394, $pop393
	i32.const	$push392=, 1
	i32.add 	$push391=, $5, $pop392
	tee_local	$push390=, $5=, $pop391
	i32.const	$push389=, 8
	i32.ne  	$push40=, $pop390, $pop389
	br_if   	0, $pop40       # 0: up to label19
# BB#28:                                # %for.body356.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_29:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push463=, u
	i32.const	$push462=, 97
	i32.const	$push461=, 31
	i32.call	$3=, memset@FUNCTION, $pop463, $pop462, $pop461
	i32.const	$push460=, u+14
	i32.add 	$push459=, $5, $pop460
	tee_local	$push458=, $0=, $pop459
	i32.const	$push457=, 0
	i32.store8	0($pop458), $pop457
	i32.const	$push456=, u+12
	i32.add 	$push455=, $5, $pop456
	tee_local	$push454=, $1=, $pop455
	i32.const	$push453=, 0
	i32.store16	0($pop454):p2align=0, $pop453
	i32.const	$push452=, u+8
	i32.add 	$push451=, $5, $pop452
	tee_local	$push450=, $2=, $pop451
	i32.const	$push449=, 0
	i32.store	0($pop450):p2align=0, $pop449
	i32.add 	$push448=, $5, $3
	tee_local	$push447=, $3=, $pop448
	i64.const	$push446=, 0
	i64.store	0($pop447):p2align=0, $pop446
	i32.const	$push445=, 15
	i32.const	$push444=, 0
	call    	check@FUNCTION, $5, $pop445, $pop444
	i32.const	$push443=, 0
	i32.load8_u	$push442=, A($pop443)
	tee_local	$push441=, $4=, $pop442
	i32.store8	0($0), $pop441
	i32.const	$push440=, 257
	i32.mul 	$push41=, $4, $pop440
	i32.store16	0($1):p2align=0, $pop41
	i32.const	$push439=, 16843009
	i32.mul 	$push438=, $4, $pop439
	tee_local	$push437=, $4=, $pop438
	i32.store	0($2):p2align=0, $pop437
	i32.const	$push436=, u+4
	i32.add 	$push42=, $5, $pop436
	i32.store	0($pop42):p2align=0, $4
	i32.store	0($3):p2align=0, $4
	i32.const	$push435=, 15
	i32.const	$push434=, 65
	call    	check@FUNCTION, $5, $pop435, $pop434
	i32.const	$push433=, 66
	i32.store8	0($0), $pop433
	i32.const	$push432=, 16962
	i32.store16	0($1):p2align=0, $pop432
	i32.const	$push431=, 1111638594
	i32.store	0($2):p2align=0, $pop431
	i64.const	$push430=, 4774451407313060418
	i64.store	0($3):p2align=0, $pop430
	i32.const	$push429=, 15
	i32.const	$push428=, 66
	call    	check@FUNCTION, $5, $pop429, $pop428
	i32.const	$push427=, 1
	i32.add 	$push426=, $5, $pop427
	tee_local	$push425=, $5=, $pop426
	i32.const	$push424=, 8
	i32.ne  	$push43=, $pop425, $pop424
	br_if   	0, $pop43       # 0: up to label20
# BB#30:                                # %for.end378
	end_loop
	i32.const	$push44=, 0
	call    	exit@FUNCTION, $pop44
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
	.section	.bss.u,"aw",@nobits
	.p2align	4
u:
	.skip	32
	.size	u, 32


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
