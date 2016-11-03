	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-2.c"
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
	i32.ge_s	$push6=, $1, $pop34
	br_if   	1, $pop6        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_5:
	end_block                       # label3:
	i32.const	$0=, u
	i32.const	$push35=, 1
	i32.lt_s	$push7=, $1, $pop35
	br_if   	1, $pop7        # 1: down to label1
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push59=, u
	i32.const	$push58=, 97
	i32.const	$push57=, 31
	i32.call	$push0=, memset@FUNCTION, $pop59, $pop58, $pop57
	i32.add 	$push56=, $5, $pop0
	tee_local	$push55=, $0=, $pop56
	i32.const	$push54=, 0
	i32.store8	0($pop55), $pop54
	i32.const	$push53=, 1
	i32.const	$push52=, 0
	call    	check@FUNCTION, $5, $pop53, $pop52
	i32.const	$push51=, 0
	i32.load8_u	$push4=, A($pop51)
	i32.store8	0($0), $pop4
	i32.const	$push50=, 1
	i32.const	$push49=, 65
	call    	check@FUNCTION, $5, $pop50, $pop49
	i32.const	$push48=, 66
	i32.store8	0($0), $pop48
	i32.const	$push47=, 1
	i32.const	$push46=, 66
	call    	check@FUNCTION, $5, $pop47, $pop46
	i32.const	$push45=, 1
	i32.add 	$push44=, $5, $pop45
	tee_local	$push43=, $5=, $pop44
	i32.const	$push42=, 8
	i32.ne  	$push5=, $pop43, $pop42
	br_if   	0, $pop5        # 0: up to label6
# BB#2:                                 # %for.body18.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_3:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push78=, u
	i32.const	$push77=, 97
	i32.const	$push76=, 31
	i32.call	$push1=, memset@FUNCTION, $pop78, $pop77, $pop76
	i32.add 	$push75=, $5, $pop1
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 0
	i32.store16	0($pop74):p2align=0, $pop73
	i32.const	$push72=, 2
	i32.const	$push71=, 0
	call    	check@FUNCTION, $5, $pop72, $pop71
	i32.const	$push70=, 0
	i32.load8_u	$push6=, A($pop70)
	i32.const	$push69=, 257
	i32.mul 	$push7=, $pop6, $pop69
	i32.store16	0($0):p2align=0, $pop7
	i32.const	$push68=, 2
	i32.const	$push67=, 65
	call    	check@FUNCTION, $5, $pop68, $pop67
	i32.const	$push66=, 16962
	i32.store16	0($0):p2align=0, $pop66
	i32.const	$push65=, 2
	i32.const	$push64=, 66
	call    	check@FUNCTION, $5, $pop65, $pop64
	i32.const	$push63=, 1
	i32.add 	$push62=, $5, $pop63
	tee_local	$push61=, $5=, $pop62
	i32.const	$push60=, 8
	i32.ne  	$push8=, $pop61, $pop60
	br_if   	0, $pop8        # 0: up to label7
# BB#4:                                 # %for.body44.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_5:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push104=, u
	i32.const	$push103=, 97
	i32.const	$push102=, 31
	i32.call	$1=, memset@FUNCTION, $pop104, $pop103, $pop102
	i32.const	$push101=, u+2
	i32.add 	$push100=, $5, $pop101
	tee_local	$push99=, $0=, $pop100
	i32.const	$push98=, 0
	i32.store8	0($pop99), $pop98
	i32.add 	$push97=, $5, $1
	tee_local	$push96=, $1=, $pop97
	i32.const	$push95=, 0
	i32.store16	0($pop96):p2align=0, $pop95
	i32.const	$push94=, 3
	i32.const	$push93=, 0
	call    	check@FUNCTION, $5, $pop94, $pop93
	i32.const	$push92=, 0
	i32.load8_u	$push91=, A($pop92)
	tee_local	$push90=, $2=, $pop91
	i32.store8	0($0), $pop90
	i32.const	$push89=, 257
	i32.mul 	$push9=, $2, $pop89
	i32.store16	0($1):p2align=0, $pop9
	i32.const	$push88=, 3
	i32.const	$push87=, 65
	call    	check@FUNCTION, $5, $pop88, $pop87
	i32.const	$push86=, 66
	i32.store8	0($0), $pop86
	i32.const	$push85=, 16962
	i32.store16	0($1):p2align=0, $pop85
	i32.const	$push84=, 3
	i32.const	$push83=, 66
	call    	check@FUNCTION, $5, $pop84, $pop83
	i32.const	$push82=, 1
	i32.add 	$push81=, $5, $pop82
	tee_local	$push80=, $5=, $pop81
	i32.const	$push79=, 8
	i32.ne  	$push10=, $pop80, $pop79
	br_if   	0, $pop10       # 0: up to label8
# BB#6:                                 # %for.body70.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_7:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push123=, u
	i32.const	$push122=, 97
	i32.const	$push121=, 31
	i32.call	$push2=, memset@FUNCTION, $pop123, $pop122, $pop121
	i32.add 	$push120=, $5, $pop2
	tee_local	$push119=, $0=, $pop120
	i32.const	$push118=, 0
	i32.store	0($pop119):p2align=0, $pop118
	i32.const	$push117=, 4
	i32.const	$push116=, 0
	call    	check@FUNCTION, $5, $pop117, $pop116
	i32.const	$push115=, 0
	i32.load8_u	$push11=, A($pop115)
	i32.const	$push114=, 16843009
	i32.mul 	$push12=, $pop11, $pop114
	i32.store	0($0):p2align=0, $pop12
	i32.const	$push113=, 4
	i32.const	$push112=, 65
	call    	check@FUNCTION, $5, $pop113, $pop112
	i32.const	$push111=, 1111638594
	i32.store	0($0):p2align=0, $pop111
	i32.const	$push110=, 4
	i32.const	$push109=, 66
	call    	check@FUNCTION, $5, $pop110, $pop109
	i32.const	$push108=, 1
	i32.add 	$push107=, $5, $pop108
	tee_local	$push106=, $5=, $pop107
	i32.const	$push105=, 8
	i32.ne  	$push13=, $pop106, $pop105
	br_if   	0, $pop13       # 0: up to label9
# BB#8:                                 # %for.body96.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_9:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push149=, u
	i32.const	$push148=, 97
	i32.const	$push147=, 31
	i32.call	$1=, memset@FUNCTION, $pop149, $pop148, $pop147
	i32.const	$push146=, u+4
	i32.add 	$push145=, $5, $pop146
	tee_local	$push144=, $0=, $pop145
	i32.const	$push143=, 0
	i32.store8	0($pop144), $pop143
	i32.add 	$push142=, $5, $1
	tee_local	$push141=, $1=, $pop142
	i32.const	$push140=, 0
	i32.store	0($pop141):p2align=0, $pop140
	i32.const	$push139=, 5
	i32.const	$push138=, 0
	call    	check@FUNCTION, $5, $pop139, $pop138
	i32.const	$push137=, 0
	i32.load8_u	$push136=, A($pop137)
	tee_local	$push135=, $2=, $pop136
	i32.store8	0($0), $pop135
	i32.const	$push134=, 16843009
	i32.mul 	$push14=, $2, $pop134
	i32.store	0($1):p2align=0, $pop14
	i32.const	$push133=, 5
	i32.const	$push132=, 65
	call    	check@FUNCTION, $5, $pop133, $pop132
	i32.const	$push131=, 66
	i32.store8	0($0), $pop131
	i32.const	$push130=, 1111638594
	i32.store	0($1):p2align=0, $pop130
	i32.const	$push129=, 5
	i32.const	$push128=, 66
	call    	check@FUNCTION, $5, $pop129, $pop128
	i32.const	$push127=, 1
	i32.add 	$push126=, $5, $pop127
	tee_local	$push125=, $5=, $pop126
	i32.const	$push124=, 8
	i32.ne  	$push15=, $pop125, $pop124
	br_if   	0, $pop15       # 0: up to label10
# BB#10:                                # %for.body122.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_11:                               # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push176=, u
	i32.const	$push175=, 97
	i32.const	$push174=, 31
	i32.call	$1=, memset@FUNCTION, $pop176, $pop175, $pop174
	i32.const	$push173=, u+4
	i32.add 	$push172=, $5, $pop173
	tee_local	$push171=, $0=, $pop172
	i32.const	$push170=, 0
	i32.store16	0($pop171):p2align=0, $pop170
	i32.add 	$push169=, $5, $1
	tee_local	$push168=, $1=, $pop169
	i32.const	$push167=, 0
	i32.store	0($pop168):p2align=0, $pop167
	i32.const	$push166=, 6
	i32.const	$push165=, 0
	call    	check@FUNCTION, $5, $pop166, $pop165
	i32.const	$push164=, 0
	i32.load8_u	$push163=, A($pop164)
	tee_local	$push162=, $2=, $pop163
	i32.const	$push161=, 257
	i32.mul 	$push16=, $pop162, $pop161
	i32.store16	0($0):p2align=0, $pop16
	i32.const	$push160=, 16843009
	i32.mul 	$push17=, $2, $pop160
	i32.store	0($1):p2align=0, $pop17
	i32.const	$push159=, 6
	i32.const	$push158=, 65
	call    	check@FUNCTION, $5, $pop159, $pop158
	i32.const	$push157=, 16962
	i32.store16	0($0):p2align=0, $pop157
	i32.const	$push156=, 1111638594
	i32.store	0($1):p2align=0, $pop156
	i32.const	$push155=, 6
	i32.const	$push154=, 66
	call    	check@FUNCTION, $5, $pop155, $pop154
	i32.const	$push153=, 1
	i32.add 	$push152=, $5, $pop153
	tee_local	$push151=, $5=, $pop152
	i32.const	$push150=, 8
	i32.ne  	$push18=, $pop151, $pop150
	br_if   	0, $pop18       # 0: up to label11
# BB#12:                                # %for.body148.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_13:                               # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	i32.const	$push208=, u
	i32.const	$push207=, 97
	i32.const	$push206=, 31
	i32.call	$2=, memset@FUNCTION, $pop208, $pop207, $pop206
	i32.const	$push205=, u+6
	i32.add 	$push204=, $5, $pop205
	tee_local	$push203=, $0=, $pop204
	i32.const	$push202=, 0
	i32.store8	0($pop203), $pop202
	i32.const	$push201=, u+4
	i32.add 	$push200=, $5, $pop201
	tee_local	$push199=, $1=, $pop200
	i32.const	$push198=, 0
	i32.store16	0($pop199):p2align=0, $pop198
	i32.add 	$push197=, $5, $2
	tee_local	$push196=, $2=, $pop197
	i32.const	$push195=, 0
	i32.store	0($pop196):p2align=0, $pop195
	i32.const	$push194=, 7
	i32.const	$push193=, 0
	call    	check@FUNCTION, $5, $pop194, $pop193
	i32.const	$push192=, 0
	i32.load8_u	$push191=, A($pop192)
	tee_local	$push190=, $3=, $pop191
	i32.store8	0($0), $pop190
	i32.const	$push189=, 257
	i32.mul 	$push19=, $3, $pop189
	i32.store16	0($1):p2align=0, $pop19
	i32.const	$push188=, 16843009
	i32.mul 	$push20=, $3, $pop188
	i32.store	0($2):p2align=0, $pop20
	i32.const	$push187=, 7
	i32.const	$push186=, 65
	call    	check@FUNCTION, $5, $pop187, $pop186
	i32.const	$push185=, 66
	i32.store8	0($0), $pop185
	i32.const	$push184=, 16962
	i32.store16	0($1):p2align=0, $pop184
	i32.const	$push183=, 1111638594
	i32.store	0($2):p2align=0, $pop183
	i32.const	$push182=, 7
	i32.const	$push181=, 66
	call    	check@FUNCTION, $5, $pop182, $pop181
	i32.const	$push180=, 1
	i32.add 	$push179=, $5, $pop180
	tee_local	$push178=, $5=, $pop179
	i32.const	$push177=, 8
	i32.ne  	$push21=, $pop178, $pop177
	br_if   	0, $pop21       # 0: up to label12
# BB#14:                                # %for.body174.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_15:                               # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push230=, u
	i32.const	$push229=, 97
	i32.const	$push228=, 31
	i32.call	$push3=, memset@FUNCTION, $pop230, $pop229, $pop228
	i32.add 	$push227=, $5, $pop3
	tee_local	$push226=, $0=, $pop227
	i64.const	$push225=, 0
	i64.store	0($pop226):p2align=0, $pop225
	i32.const	$push224=, 8
	i32.const	$push223=, 0
	call    	check@FUNCTION, $5, $pop224, $pop223
	i32.const	$push222=, u+4
	i32.add 	$push22=, $5, $pop222
	i32.const	$push221=, 0
	i32.load8_u	$push23=, A($pop221)
	i32.const	$push220=, 16843009
	i32.mul 	$push219=, $pop23, $pop220
	tee_local	$push218=, $1=, $pop219
	i32.store	0($pop22):p2align=0, $pop218
	i32.store	0($0):p2align=0, $1
	i32.const	$push217=, 8
	i32.const	$push216=, 65
	call    	check@FUNCTION, $5, $pop217, $pop216
	i64.const	$push215=, 4774451407313060418
	i64.store	0($0):p2align=0, $pop215
	i32.const	$push214=, 8
	i32.const	$push213=, 66
	call    	check@FUNCTION, $5, $pop214, $pop213
	i32.const	$push212=, 1
	i32.add 	$push211=, $5, $pop212
	tee_local	$push210=, $5=, $pop211
	i32.const	$push209=, 8
	i32.ne  	$push24=, $pop210, $pop209
	br_if   	0, $pop24       # 0: up to label13
# BB#16:                                # %for.body200.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_17:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push263=, u
	i32.const	$push262=, 97
	i32.const	$push261=, 31
	i32.call	$2=, memset@FUNCTION, $pop263, $pop262, $pop261
	i32.const	$push260=, u+8
	i32.add 	$push259=, $5, $pop260
	tee_local	$push258=, $0=, $pop259
	i32.const	$push257=, 0
	i32.store8	0($pop258), $pop257
	i32.const	$push256=, u+4
	i32.add 	$push255=, $5, $pop256
	tee_local	$push254=, $1=, $pop255
	i32.const	$push253=, 0
	i32.store	0($pop254):p2align=0, $pop253
	i32.add 	$push252=, $5, $2
	tee_local	$push251=, $2=, $pop252
	i32.const	$push250=, 0
	i32.store	0($pop251):p2align=0, $pop250
	i32.const	$push249=, 9
	i32.const	$push248=, 0
	call    	check@FUNCTION, $5, $pop249, $pop248
	i32.const	$push247=, 0
	i32.load8_u	$push246=, A($pop247)
	tee_local	$push245=, $3=, $pop246
	i32.store8	0($0), $pop245
	i32.const	$push244=, 16843009
	i32.mul 	$push243=, $3, $pop244
	tee_local	$push242=, $3=, $pop243
	i32.store	0($1):p2align=0, $pop242
	i32.store	0($2):p2align=0, $3
	i32.const	$push241=, 9
	i32.const	$push240=, 65
	call    	check@FUNCTION, $5, $pop241, $pop240
	i32.const	$push239=, 66
	i32.store8	0($0), $pop239
	i32.const	$push238=, 1111638594
	i32.store	0($1):p2align=0, $pop238
	i32.const	$push237=, 1111638594
	i32.store	0($2):p2align=0, $pop237
	i32.const	$push236=, 9
	i32.const	$push235=, 66
	call    	check@FUNCTION, $5, $pop236, $pop235
	i32.const	$push234=, 1
	i32.add 	$push233=, $5, $pop234
	tee_local	$push232=, $5=, $pop233
	i32.const	$push231=, 8
	i32.ne  	$push25=, $pop232, $pop231
	br_if   	0, $pop25       # 0: up to label14
# BB#18:                                # %for.body226.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_19:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push297=, u
	i32.const	$push296=, 97
	i32.const	$push295=, 31
	i32.call	$2=, memset@FUNCTION, $pop297, $pop296, $pop295
	i32.const	$push294=, u+8
	i32.add 	$push293=, $5, $pop294
	tee_local	$push292=, $0=, $pop293
	i32.const	$push291=, 0
	i32.store16	0($pop292):p2align=0, $pop291
	i32.const	$push290=, u+4
	i32.add 	$push289=, $5, $pop290
	tee_local	$push288=, $1=, $pop289
	i32.const	$push287=, 0
	i32.store	0($pop288):p2align=0, $pop287
	i32.add 	$push286=, $5, $2
	tee_local	$push285=, $2=, $pop286
	i32.const	$push284=, 0
	i32.store	0($pop285):p2align=0, $pop284
	i32.const	$push283=, 10
	i32.const	$push282=, 0
	call    	check@FUNCTION, $5, $pop283, $pop282
	i32.const	$push281=, 0
	i32.load8_u	$push280=, A($pop281)
	tee_local	$push279=, $3=, $pop280
	i32.const	$push278=, 257
	i32.mul 	$push26=, $pop279, $pop278
	i32.store16	0($0):p2align=0, $pop26
	i32.const	$push277=, 16843009
	i32.mul 	$push276=, $3, $pop277
	tee_local	$push275=, $3=, $pop276
	i32.store	0($1):p2align=0, $pop275
	i32.store	0($2):p2align=0, $3
	i32.const	$push274=, 10
	i32.const	$push273=, 65
	call    	check@FUNCTION, $5, $pop274, $pop273
	i32.const	$push272=, 16962
	i32.store16	0($0):p2align=0, $pop272
	i32.const	$push271=, 1111638594
	i32.store	0($1):p2align=0, $pop271
	i32.const	$push270=, 1111638594
	i32.store	0($2):p2align=0, $pop270
	i32.const	$push269=, 10
	i32.const	$push268=, 66
	call    	check@FUNCTION, $5, $pop269, $pop268
	i32.const	$push267=, 1
	i32.add 	$push266=, $5, $pop267
	tee_local	$push265=, $5=, $pop266
	i32.const	$push264=, 8
	i32.ne  	$push27=, $pop265, $pop264
	br_if   	0, $pop27       # 0: up to label15
# BB#20:                                # %for.body252.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_21:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push336=, u
	i32.const	$push335=, 97
	i32.const	$push334=, 31
	i32.call	$3=, memset@FUNCTION, $pop336, $pop335, $pop334
	i32.const	$push333=, u+10
	i32.add 	$push332=, $5, $pop333
	tee_local	$push331=, $0=, $pop332
	i32.const	$push330=, 0
	i32.store8	0($pop331), $pop330
	i32.const	$push329=, u+8
	i32.add 	$push328=, $5, $pop329
	tee_local	$push327=, $1=, $pop328
	i32.const	$push326=, 0
	i32.store16	0($pop327):p2align=0, $pop326
	i32.const	$push325=, u+4
	i32.add 	$push324=, $5, $pop325
	tee_local	$push323=, $2=, $pop324
	i32.const	$push322=, 0
	i32.store	0($pop323):p2align=0, $pop322
	i32.add 	$push321=, $5, $3
	tee_local	$push320=, $3=, $pop321
	i32.const	$push319=, 0
	i32.store	0($pop320):p2align=0, $pop319
	i32.const	$push318=, 11
	i32.const	$push317=, 0
	call    	check@FUNCTION, $5, $pop318, $pop317
	i32.const	$push316=, 0
	i32.load8_u	$push315=, A($pop316)
	tee_local	$push314=, $4=, $pop315
	i32.store8	0($0), $pop314
	i32.const	$push313=, 257
	i32.mul 	$push28=, $4, $pop313
	i32.store16	0($1):p2align=0, $pop28
	i32.const	$push312=, 16843009
	i32.mul 	$push311=, $4, $pop312
	tee_local	$push310=, $4=, $pop311
	i32.store	0($2):p2align=0, $pop310
	i32.store	0($3):p2align=0, $4
	i32.const	$push309=, 11
	i32.const	$push308=, 65
	call    	check@FUNCTION, $5, $pop309, $pop308
	i32.const	$push307=, 66
	i32.store8	0($0), $pop307
	i32.const	$push306=, 16962
	i32.store16	0($1):p2align=0, $pop306
	i32.const	$push305=, 1111638594
	i32.store	0($2):p2align=0, $pop305
	i32.const	$push304=, 1111638594
	i32.store	0($3):p2align=0, $pop304
	i32.const	$push303=, 11
	i32.const	$push302=, 66
	call    	check@FUNCTION, $5, $pop303, $pop302
	i32.const	$push301=, 1
	i32.add 	$push300=, $5, $pop301
	tee_local	$push299=, $5=, $pop300
	i32.const	$push298=, 8
	i32.ne  	$push29=, $pop299, $pop298
	br_if   	0, $pop29       # 0: up to label16
# BB#22:                                # %for.body278.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_23:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push363=, u
	i32.const	$push362=, 97
	i32.const	$push361=, 31
	i32.call	$1=, memset@FUNCTION, $pop363, $pop362, $pop361
	i32.const	$push360=, u+4
	i32.add 	$push359=, $5, $pop360
	tee_local	$push358=, $0=, $pop359
	i64.const	$push357=, 0
	i64.store	0($pop358):p2align=0, $pop357
	i32.add 	$push356=, $5, $1
	tee_local	$push355=, $1=, $pop356
	i32.const	$push354=, 0
	i32.store	0($pop355):p2align=0, $pop354
	i32.const	$push353=, 12
	i32.const	$push352=, 0
	call    	check@FUNCTION, $5, $pop353, $pop352
	i32.const	$push351=, u+8
	i32.add 	$push30=, $5, $pop351
	i32.const	$push350=, 0
	i32.load8_u	$push31=, A($pop350)
	i32.const	$push349=, 16843009
	i32.mul 	$push348=, $pop31, $pop349
	tee_local	$push347=, $2=, $pop348
	i32.store	0($pop30):p2align=0, $pop347
	i32.store	0($0):p2align=0, $2
	i32.store	0($1):p2align=0, $2
	i32.const	$push346=, 12
	i32.const	$push345=, 65
	call    	check@FUNCTION, $5, $pop346, $pop345
	i64.const	$push344=, 4774451407313060418
	i64.store	0($0):p2align=0, $pop344
	i32.const	$push343=, 1111638594
	i32.store	0($1):p2align=0, $pop343
	i32.const	$push342=, 12
	i32.const	$push341=, 66
	call    	check@FUNCTION, $5, $pop342, $pop341
	i32.const	$push340=, 1
	i32.add 	$push339=, $5, $pop340
	tee_local	$push338=, $5=, $pop339
	i32.const	$push337=, 8
	i32.ne  	$push32=, $pop338, $pop337
	br_if   	0, $pop32       # 0: up to label17
# BB#24:                                # %for.body304.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_25:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push397=, u
	i32.const	$push396=, 97
	i32.const	$push395=, 31
	i32.call	$2=, memset@FUNCTION, $pop397, $pop396, $pop395
	i32.const	$push394=, u+12
	i32.add 	$push393=, $5, $pop394
	tee_local	$push392=, $0=, $pop393
	i32.const	$push391=, 0
	i32.store8	0($pop392), $pop391
	i32.const	$push390=, u+4
	i32.add 	$push389=, $5, $pop390
	tee_local	$push388=, $1=, $pop389
	i64.const	$push387=, 0
	i64.store	0($pop388):p2align=0, $pop387
	i32.add 	$push386=, $5, $2
	tee_local	$push385=, $2=, $pop386
	i32.const	$push384=, 0
	i32.store	0($pop385):p2align=0, $pop384
	i32.const	$push383=, 13
	i32.const	$push382=, 0
	call    	check@FUNCTION, $5, $pop383, $pop382
	i32.const	$push381=, 0
	i32.load8_u	$push380=, A($pop381)
	tee_local	$push379=, $3=, $pop380
	i32.store8	0($0), $pop379
	i32.const	$push378=, u+8
	i32.add 	$push33=, $5, $pop378
	i32.const	$push377=, 16843009
	i32.mul 	$push376=, $3, $pop377
	tee_local	$push375=, $3=, $pop376
	i32.store	0($pop33):p2align=0, $pop375
	i32.store	0($1):p2align=0, $3
	i32.store	0($2):p2align=0, $3
	i32.const	$push374=, 13
	i32.const	$push373=, 65
	call    	check@FUNCTION, $5, $pop374, $pop373
	i32.const	$push372=, 66
	i32.store8	0($0), $pop372
	i64.const	$push371=, 4774451407313060418
	i64.store	0($1):p2align=0, $pop371
	i32.const	$push370=, 1111638594
	i32.store	0($2):p2align=0, $pop370
	i32.const	$push369=, 13
	i32.const	$push368=, 66
	call    	check@FUNCTION, $5, $pop369, $pop368
	i32.const	$push367=, 1
	i32.add 	$push366=, $5, $pop367
	tee_local	$push365=, $5=, $pop366
	i32.const	$push364=, 8
	i32.ne  	$push34=, $pop365, $pop364
	br_if   	0, $pop34       # 0: up to label18
# BB#26:                                # %for.body330.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_27:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push432=, u
	i32.const	$push431=, 97
	i32.const	$push430=, 31
	i32.call	$2=, memset@FUNCTION, $pop432, $pop431, $pop430
	i32.const	$push429=, u+12
	i32.add 	$push428=, $5, $pop429
	tee_local	$push427=, $0=, $pop428
	i32.const	$push426=, 0
	i32.store16	0($pop427):p2align=0, $pop426
	i32.const	$push425=, u+4
	i32.add 	$push424=, $5, $pop425
	tee_local	$push423=, $1=, $pop424
	i64.const	$push422=, 0
	i64.store	0($pop423):p2align=0, $pop422
	i32.add 	$push421=, $5, $2
	tee_local	$push420=, $2=, $pop421
	i32.const	$push419=, 0
	i32.store	0($pop420):p2align=0, $pop419
	i32.const	$push418=, 14
	i32.const	$push417=, 0
	call    	check@FUNCTION, $5, $pop418, $pop417
	i32.const	$push416=, 0
	i32.load8_u	$push415=, A($pop416)
	tee_local	$push414=, $3=, $pop415
	i32.const	$push413=, 257
	i32.mul 	$push35=, $pop414, $pop413
	i32.store16	0($0):p2align=0, $pop35
	i32.const	$push412=, u+8
	i32.add 	$push36=, $5, $pop412
	i32.const	$push411=, 16843009
	i32.mul 	$push410=, $3, $pop411
	tee_local	$push409=, $3=, $pop410
	i32.store	0($pop36):p2align=0, $pop409
	i32.store	0($1):p2align=0, $3
	i32.store	0($2):p2align=0, $3
	i32.const	$push408=, 14
	i32.const	$push407=, 65
	call    	check@FUNCTION, $5, $pop408, $pop407
	i32.const	$push406=, 16962
	i32.store16	0($0):p2align=0, $pop406
	i64.const	$push405=, 4774451407313060418
	i64.store	0($1):p2align=0, $pop405
	i32.const	$push404=, 1111638594
	i32.store	0($2):p2align=0, $pop404
	i32.const	$push403=, 14
	i32.const	$push402=, 66
	call    	check@FUNCTION, $5, $pop403, $pop402
	i32.const	$push401=, 1
	i32.add 	$push400=, $5, $pop401
	tee_local	$push399=, $5=, $pop400
	i32.const	$push398=, 8
	i32.ne  	$push37=, $pop399, $pop398
	br_if   	0, $pop37       # 0: up to label19
# BB#28:                                # %for.body356.preheader
	end_loop
	i32.const	$5=, 0
.LBB2_29:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push472=, u
	i32.const	$push471=, 97
	i32.const	$push470=, 31
	i32.call	$3=, memset@FUNCTION, $pop472, $pop471, $pop470
	i32.const	$push469=, u+14
	i32.add 	$push468=, $5, $pop469
	tee_local	$push467=, $0=, $pop468
	i32.const	$push466=, 0
	i32.store8	0($pop467), $pop466
	i32.const	$push465=, u+12
	i32.add 	$push464=, $5, $pop465
	tee_local	$push463=, $1=, $pop464
	i32.const	$push462=, 0
	i32.store16	0($pop463):p2align=0, $pop462
	i32.const	$push461=, u+4
	i32.add 	$push460=, $5, $pop461
	tee_local	$push459=, $2=, $pop460
	i64.const	$push458=, 0
	i64.store	0($pop459):p2align=0, $pop458
	i32.add 	$push457=, $5, $3
	tee_local	$push456=, $3=, $pop457
	i32.const	$push455=, 0
	i32.store	0($pop456):p2align=0, $pop455
	i32.const	$push454=, 15
	i32.const	$push453=, 0
	call    	check@FUNCTION, $5, $pop454, $pop453
	i32.const	$push452=, 0
	i32.load8_u	$push451=, A($pop452)
	tee_local	$push450=, $4=, $pop451
	i32.store8	0($0), $pop450
	i32.const	$push449=, 257
	i32.mul 	$push38=, $4, $pop449
	i32.store16	0($1):p2align=0, $pop38
	i32.const	$push448=, u+8
	i32.add 	$push39=, $5, $pop448
	i32.const	$push447=, 16843009
	i32.mul 	$push446=, $4, $pop447
	tee_local	$push445=, $4=, $pop446
	i32.store	0($pop39):p2align=0, $pop445
	i32.store	0($2):p2align=0, $4
	i32.store	0($3):p2align=0, $4
	i32.const	$push444=, 15
	i32.const	$push443=, 65
	call    	check@FUNCTION, $5, $pop444, $pop443
	i32.const	$push442=, 66
	i32.store8	0($0), $pop442
	i32.const	$push441=, 16962
	i32.store16	0($1):p2align=0, $pop441
	i64.const	$push440=, 4774451407313060418
	i64.store	0($2):p2align=0, $pop440
	i32.const	$push439=, 1111638594
	i32.store	0($3):p2align=0, $pop439
	i32.const	$push438=, 15
	i32.const	$push437=, 66
	call    	check@FUNCTION, $5, $pop438, $pop437
	i32.const	$push436=, 1
	i32.add 	$push435=, $5, $pop436
	tee_local	$push434=, $5=, $pop435
	i32.const	$push433=, 8
	i32.ne  	$push40=, $pop434, $pop433
	br_if   	0, $pop40       # 0: up to label20
# BB#30:                                # %for.end378
	end_loop
	i32.const	$push41=, 0
	call    	exit@FUNCTION, $pop41
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
