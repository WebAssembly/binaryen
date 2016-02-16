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
	.local  	i32, i32, i64, i32, i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label9:
	i32.const	$push135=, u
	i32.const	$push134=, 97
	i32.const	$push133=, 31
	i32.call	$discard=, memset@FUNCTION, $pop135, $pop134, $pop133
	i32.const	$push132=, 1
	i32.const	$push131=, 0
	i32.store8	$push130=, u($6), $pop131
	tee_local	$push129=, $5=, $pop130
	call    	check@FUNCTION, $6, $pop132, $pop129
	i32.load8_u	$push0=, A($5)
	i32.store8	$discard=, u($6), $pop0
	i32.const	$push128=, 1
	i32.const	$push127=, 65
	call    	check@FUNCTION, $6, $pop128, $pop127
	i32.const	$push126=, 1
	i32.const	$push125=, 66
	i32.store8	$push1=, u($6), $pop125
	call    	check@FUNCTION, $6, $pop126, $pop1
	i32.const	$push124=, 1
	i32.add 	$6=, $6, $pop124
	i32.const	$push123=, 8
	i32.ne  	$push2=, $6, $pop123
	br_if   	0, $pop2        # 0: up to label9
.LBB2_2:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label10:
	loop                            # label11:
	i32.const	$push4=, u
	i32.const	$push146=, 97
	i32.const	$push145=, 31
	i32.call	$1=, memset@FUNCTION, $pop4, $pop146, $pop145
	i32.const	$push5=, 2
	i32.const	$push3=, 0
	i32.store16	$push144=, u($5):p2align=0, $pop3
	tee_local	$push143=, $8=, $pop144
	call    	check@FUNCTION, $5, $pop5, $pop143
	i32.load8_u	$push6=, A($8)
	i32.const	$push142=, 257
	i32.mul 	$push7=, $pop6, $pop142
	i32.store16	$discard=, u($5):p2align=0, $pop7
	i32.const	$push141=, 2
	i32.const	$push140=, 65
	call    	check@FUNCTION, $5, $pop141, $pop140
	i32.const	$push8=, 16962
	i32.store16	$3=, u($5):p2align=0, $pop8
	i32.const	$push139=, 2
	i32.const	$push138=, 66
	call    	check@FUNCTION, $5, $pop139, $pop138
	i32.const	$push137=, 1
	i32.add 	$5=, $5, $pop137
	copy_local	$6=, $8
	i32.const	$push136=, 8
	i32.ne  	$push9=, $5, $pop136
	br_if   	0, $pop9        # 0: up to label11
.LBB2_3:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label12:
	loop                            # label13:
	i32.const	$push157=, 97
	i32.const	$push156=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop157, $pop156
	i32.const	$push11=, 3
	i32.store8	$push10=, u+2($6), $8
	i32.store16	$push155=, u($6):p2align=0, $pop10
	tee_local	$push154=, $5=, $pop155
	call    	check@FUNCTION, $6, $pop11, $pop154
	i32.load8_u	$push12=, A($5)
	i32.store8	$push13=, u+2($6), $pop12
	i32.const	$push153=, 257
	i32.mul 	$push14=, $pop13, $pop153
	i32.store16	$discard=, u($6):p2align=0, $pop14
	i32.const	$push152=, 3
	i32.const	$push151=, 65
	call    	check@FUNCTION, $6, $pop152, $pop151
	i32.const	$push150=, 66
	i32.store8	$0=, u+2($6), $pop150
	i32.store16	$discard=, u($6):p2align=0, $3
	i32.const	$push149=, 3
	call    	check@FUNCTION, $6, $pop149, $0
	i32.const	$push148=, 1
	i32.add 	$6=, $6, $pop148
	i32.const	$push147=, 8
	i32.ne  	$push15=, $6, $pop147
	br_if   	0, $pop15       # 0: up to label13
.LBB2_4:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label14:
	loop                            # label15:
	i32.const	$push17=, u
	i32.const	$push168=, 97
	i32.const	$push167=, 31
	i32.call	$1=, memset@FUNCTION, $pop17, $pop168, $pop167
	i32.const	$push18=, 4
	i32.const	$push16=, 0
	i32.store	$push166=, u($5):p2align=0, $pop16
	tee_local	$push165=, $8=, $pop166
	call    	check@FUNCTION, $5, $pop18, $pop165
	i32.load8_u	$push19=, A($8)
	i32.const	$push164=, 16843009
	i32.mul 	$push20=, $pop19, $pop164
	i32.store	$discard=, u($5):p2align=0, $pop20
	i32.const	$push163=, 4
	i32.const	$push162=, 65
	call    	check@FUNCTION, $5, $pop163, $pop162
	i32.const	$push21=, 1111638594
	i32.store	$3=, u($5):p2align=0, $pop21
	i32.const	$push161=, 4
	i32.const	$push160=, 66
	call    	check@FUNCTION, $5, $pop161, $pop160
	i32.const	$push159=, 1
	i32.add 	$5=, $5, $pop159
	copy_local	$6=, $8
	i32.const	$push158=, 8
	i32.ne  	$push22=, $5, $pop158
	br_if   	0, $pop22       # 0: up to label15
.LBB2_5:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label16:
	loop                            # label17:
	i32.const	$push179=, 97
	i32.const	$push178=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop179, $pop178
	i32.const	$push24=, 5
	i32.store8	$push23=, u+4($6), $8
	i32.store	$push177=, u($6):p2align=0, $pop23
	tee_local	$push176=, $5=, $pop177
	call    	check@FUNCTION, $6, $pop24, $pop176
	i32.load8_u	$push25=, A($5)
	i32.store8	$push26=, u+4($6), $pop25
	i32.const	$push175=, 16843009
	i32.mul 	$push27=, $pop26, $pop175
	i32.store	$discard=, u($6):p2align=0, $pop27
	i32.const	$push174=, 5
	i32.const	$push173=, 65
	call    	check@FUNCTION, $6, $pop174, $pop173
	i32.const	$push172=, 66
	i32.store8	$0=, u+4($6), $pop172
	i32.store	$discard=, u($6):p2align=0, $3
	i32.const	$push171=, 5
	call    	check@FUNCTION, $6, $pop171, $0
	i32.const	$push170=, 1
	i32.add 	$6=, $6, $pop170
	i32.const	$push169=, 8
	i32.ne  	$push28=, $6, $pop169
	br_if   	0, $pop28       # 0: up to label17
.LBB2_6:                                # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label18:
	loop                            # label19:
	i32.const	$push30=, u
	i32.const	$push193=, 97
	i32.const	$push192=, 31
	i32.call	$1=, memset@FUNCTION, $pop30, $pop193, $pop192
	i32.const	$push32=, 6
	i32.const	$push29=, 0
	i32.store16	$push31=, u+4($5):p2align=0, $pop29
	i32.store	$push191=, u($5):p2align=0, $pop31
	tee_local	$push190=, $8=, $pop191
	call    	check@FUNCTION, $5, $pop32, $pop190
	i32.load8_u	$push189=, A($8)
	tee_local	$push188=, $6=, $pop189
	i32.const	$push187=, 257
	i32.mul 	$push33=, $pop188, $pop187
	i32.store16	$discard=, u+4($5):p2align=0, $pop33
	i32.const	$push186=, 16843009
	i32.mul 	$push34=, $6, $pop186
	i32.store	$discard=, u($5):p2align=0, $pop34
	i32.const	$push185=, 6
	i32.const	$push184=, 65
	call    	check@FUNCTION, $5, $pop185, $pop184
	i32.const	$push35=, 16962
	i32.store16	$3=, u+4($5):p2align=0, $pop35
	i32.const	$push36=, 1111638594
	i32.store	$0=, u($5):p2align=0, $pop36
	i32.const	$push183=, 6
	i32.const	$push182=, 66
	call    	check@FUNCTION, $5, $pop183, $pop182
	i32.const	$push181=, 1
	i32.add 	$5=, $5, $pop181
	copy_local	$6=, $8
	i32.const	$push180=, 8
	i32.ne  	$push37=, $5, $pop180
	br_if   	0, $pop37       # 0: up to label19
.LBB2_7:                                # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label20:
	loop                            # label21:
	i32.const	$push207=, 97
	i32.const	$push206=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop207, $pop206
	i32.const	$push40=, 7
	i32.store8	$push38=, u+6($6), $8
	i32.store16	$push39=, u+4($6):p2align=0, $pop38
	i32.store	$push205=, u($6):p2align=0, $pop39
	tee_local	$push204=, $5=, $pop205
	call    	check@FUNCTION, $6, $pop40, $pop204
	i32.load8_u	$push41=, A($5)
	i32.store8	$push203=, u+6($6), $pop41
	tee_local	$push202=, $7=, $pop203
	i32.const	$push201=, 257
	i32.mul 	$push42=, $pop202, $pop201
	i32.store16	$discard=, u+4($6):p2align=0, $pop42
	i32.const	$push200=, 16843009
	i32.mul 	$push43=, $7, $pop200
	i32.store	$discard=, u($6):p2align=0, $pop43
	i32.const	$push199=, 7
	i32.const	$push198=, 65
	call    	check@FUNCTION, $6, $pop199, $pop198
	i32.const	$push197=, 66
	i32.store8	$7=, u+6($6), $pop197
	i32.store16	$discard=, u+4($6):p2align=0, $3
	i32.store	$discard=, u($6):p2align=0, $0
	i32.const	$push196=, 7
	call    	check@FUNCTION, $6, $pop196, $7
	i32.const	$push195=, 1
	i32.add 	$6=, $6, $pop195
	i32.const	$push194=, 8
	i32.ne  	$push44=, $6, $pop194
	br_if   	0, $pop44       # 0: up to label21
.LBB2_8:                                # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label22:
	loop                            # label23:
	i32.const	$push45=, u
	i32.const	$push219=, 97
	i32.const	$push218=, 31
	i32.call	$8=, memset@FUNCTION, $pop45, $pop219, $pop218
	i64.const	$push46=, 0
	i64.store	$discard=, u($5):p2align=0, $pop46
	i32.const	$push217=, 8
	i32.const	$push216=, 0
	call    	check@FUNCTION, $5, $pop217, $pop216
	i32.const	$push215=, 0
	i32.load8_u	$push47=, A($pop215)
	i32.const	$push214=, 16843009
	i32.mul 	$push48=, $pop47, $pop214
	i32.store	$push49=, u+4($5):p2align=0, $pop48
	i32.store	$discard=, u($5):p2align=0, $pop49
	i32.const	$push213=, 8
	i32.const	$push212=, 65
	call    	check@FUNCTION, $5, $pop213, $pop212
	i64.const	$push50=, 4774451407313060418
	i64.store	$discard=, u($5):p2align=0, $pop50
	i32.const	$push211=, 8
	i32.const	$push210=, 66
	call    	check@FUNCTION, $5, $pop211, $pop210
	i32.const	$push209=, 1
	i32.add 	$5=, $5, $pop209
	i32.const	$6=, 0
	i32.const	$push208=, 8
	i32.ne  	$push51=, $5, $pop208
	br_if   	0, $pop51       # 0: up to label23
.LBB2_9:                                # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label24:
	loop                            # label25:
	i32.const	$push231=, 97
	i32.const	$push230=, 31
	i32.call	$discard=, memset@FUNCTION, $8, $pop231, $pop230
	i32.const	$push54=, 9
	i32.const	$push229=, 0
	i32.store8	$push52=, u+8($6), $pop229
	i32.store	$push53=, u+4($6):p2align=0, $pop52
	i32.store	$push228=, u($6):p2align=0, $pop53
	tee_local	$push227=, $5=, $pop228
	call    	check@FUNCTION, $6, $pop54, $pop227
	i32.load8_u	$push55=, A($5)
	i32.store8	$push56=, u+8($6), $pop55
	i32.const	$push226=, 16843009
	i32.mul 	$push57=, $pop56, $pop226
	i32.store	$push58=, u+4($6):p2align=0, $pop57
	i32.store	$discard=, u($6):p2align=0, $pop58
	i32.const	$push225=, 9
	i32.const	$push224=, 65
	call    	check@FUNCTION, $6, $pop225, $pop224
	i32.const	$push223=, 66
	i32.store8	$1=, u+8($6), $pop223
	i32.const	$push59=, 1111638594
	i32.store	$push60=, u+4($6):p2align=0, $pop59
	i32.store	$3=, u($6):p2align=0, $pop60
	i32.const	$push222=, 9
	call    	check@FUNCTION, $6, $pop222, $1
	i32.const	$push221=, 1
	i32.add 	$6=, $6, $pop221
	i32.const	$push220=, 8
	i32.ne  	$push61=, $6, $pop220
	br_if   	0, $pop61       # 0: up to label25
.LBB2_10:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label26:
	loop                            # label27:
	i32.const	$push63=, u
	i32.const	$push245=, 97
	i32.const	$push244=, 31
	i32.call	$1=, memset@FUNCTION, $pop63, $pop245, $pop244
	i32.const	$push66=, 10
	i32.const	$push62=, 0
	i32.store16	$push64=, u+8($5):p2align=0, $pop62
	i32.store	$push65=, u+4($5):p2align=0, $pop64
	i32.store	$push243=, u($5):p2align=0, $pop65
	tee_local	$push242=, $8=, $pop243
	call    	check@FUNCTION, $5, $pop66, $pop242
	i32.load8_u	$push241=, A($8)
	tee_local	$push240=, $6=, $pop241
	i32.const	$push239=, 257
	i32.mul 	$push67=, $pop240, $pop239
	i32.store16	$discard=, u+8($5):p2align=0, $pop67
	i32.const	$push238=, 16843009
	i32.mul 	$push68=, $6, $pop238
	i32.store	$push69=, u+4($5):p2align=0, $pop68
	i32.store	$discard=, u($5):p2align=0, $pop69
	i32.const	$push237=, 10
	i32.const	$push236=, 65
	call    	check@FUNCTION, $5, $pop237, $pop236
	i32.const	$push70=, 16962
	i32.store16	$0=, u+8($5):p2align=0, $pop70
	i32.store	$push71=, u+4($5):p2align=0, $3
	i32.store	$discard=, u($5):p2align=0, $pop71
	i32.const	$push235=, 10
	i32.const	$push234=, 66
	call    	check@FUNCTION, $5, $pop235, $pop234
	i32.const	$push233=, 1
	i32.add 	$5=, $5, $pop233
	copy_local	$6=, $8
	i32.const	$push232=, 8
	i32.ne  	$push72=, $5, $pop232
	br_if   	0, $pop72       # 0: up to label27
.LBB2_11:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label28:
	loop                            # label29:
	i32.const	$push259=, 97
	i32.const	$push258=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop259, $pop258
	i32.const	$push76=, 11
	i32.store8	$push73=, u+10($6), $8
	i32.store16	$push74=, u+8($6):p2align=0, $pop73
	i32.store	$push75=, u+4($6):p2align=0, $pop74
	i32.store	$push257=, u($6):p2align=0, $pop75
	tee_local	$push256=, $5=, $pop257
	call    	check@FUNCTION, $6, $pop76, $pop256
	i32.load8_u	$push77=, A($5)
	i32.store8	$push255=, u+10($6), $pop77
	tee_local	$push254=, $3=, $pop255
	i32.const	$push253=, 257
	i32.mul 	$push78=, $pop254, $pop253
	i32.store16	$discard=, u+8($6):p2align=0, $pop78
	i32.const	$push252=, 16843009
	i32.mul 	$push79=, $3, $pop252
	i32.store	$push80=, u+4($6):p2align=0, $pop79
	i32.store	$discard=, u($6):p2align=0, $pop80
	i32.const	$push251=, 11
	i32.const	$push250=, 65
	call    	check@FUNCTION, $6, $pop251, $pop250
	i32.const	$push249=, 66
	i32.store8	$3=, u+10($6), $pop249
	i32.store16	$discard=, u+8($6):p2align=0, $0
	i32.const	$push81=, 1111638594
	i32.store	$push82=, u+4($6):p2align=0, $pop81
	i32.store	$7=, u($6):p2align=0, $pop82
	i32.const	$push248=, 11
	call    	check@FUNCTION, $6, $pop248, $3
	i32.const	$push247=, 1
	i32.add 	$6=, $6, $pop247
	i32.const	$push246=, 8
	i32.ne  	$push83=, $6, $pop246
	br_if   	0, $pop83       # 0: up to label29
.LBB2_12:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label30:
	loop                            # label31:
	i32.const	$push85=, u
	i32.const	$push270=, 97
	i32.const	$push269=, 31
	i32.call	$1=, memset@FUNCTION, $pop85, $pop270, $pop269
	i64.const	$push86=, 0
	i64.store	$2=, u+4($5):p2align=0, $pop86
	i32.const	$push87=, 12
	i32.const	$push84=, 0
	i32.store	$push268=, u($5):p2align=0, $pop84
	tee_local	$push267=, $8=, $pop268
	call    	check@FUNCTION, $5, $pop87, $pop267
	i32.load8_u	$push88=, A($8)
	i32.const	$push266=, 16843009
	i32.mul 	$push89=, $pop88, $pop266
	i32.store	$push90=, u+8($5):p2align=0, $pop89
	i32.store	$push91=, u+4($5):p2align=0, $pop90
	i32.store	$discard=, u($5):p2align=0, $pop91
	i32.const	$push265=, 12
	i32.const	$push264=, 65
	call    	check@FUNCTION, $5, $pop265, $pop264
	i64.const	$push92=, 4774451407313060418
	i64.store	$4=, u+4($5):p2align=0, $pop92
	i32.store	$discard=, u($5):p2align=0, $7
	i32.const	$push263=, 12
	i32.const	$push262=, 66
	call    	check@FUNCTION, $5, $pop263, $pop262
	i32.const	$push261=, 1
	i32.add 	$5=, $5, $pop261
	copy_local	$6=, $8
	i32.const	$push260=, 8
	i32.ne  	$push93=, $5, $pop260
	br_if   	0, $pop93       # 0: up to label31
.LBB2_13:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label32:
	loop                            # label33:
	i32.const	$push281=, 97
	i32.const	$push280=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop281, $pop280
	i32.store8	$5=, u+12($6), $8
	i64.store	$discard=, u+4($6):p2align=0, $2
	i32.const	$push94=, 13
	i32.store	$push279=, u($6):p2align=0, $5
	tee_local	$push278=, $5=, $pop279
	call    	check@FUNCTION, $6, $pop94, $pop278
	i32.load8_u	$push95=, A($5)
	i32.store8	$push96=, u+12($6), $pop95
	i32.const	$push277=, 16843009
	i32.mul 	$push97=, $pop96, $pop277
	i32.store	$push98=, u+8($6):p2align=0, $pop97
	i32.store	$push99=, u+4($6):p2align=0, $pop98
	i32.store	$discard=, u($6):p2align=0, $pop99
	i32.const	$push276=, 13
	i32.const	$push275=, 65
	call    	check@FUNCTION, $6, $pop276, $pop275
	i32.const	$push274=, 66
	i32.store8	$3=, u+12($6), $pop274
	i64.store	$discard=, u+4($6):p2align=0, $4
	i32.const	$push100=, 1111638594
	i32.store	$0=, u($6):p2align=0, $pop100
	i32.const	$push273=, 13
	call    	check@FUNCTION, $6, $pop273, $3
	i32.const	$push272=, 1
	i32.add 	$6=, $6, $pop272
	i32.const	$push271=, 8
	i32.ne  	$push101=, $6, $pop271
	br_if   	0, $pop101      # 0: up to label33
.LBB2_14:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label34:
	loop                            # label35:
	i32.const	$push103=, u
	i32.const	$push295=, 97
	i32.const	$push294=, 31
	i32.call	$1=, memset@FUNCTION, $pop103, $pop295, $pop294
	i32.const	$push102=, 0
	i32.store16	$6=, u+12($5):p2align=0, $pop102
	i64.const	$push104=, 0
	i64.store	$2=, u+4($5):p2align=0, $pop104
	i32.const	$push105=, 14
	i32.store	$push293=, u($5):p2align=0, $6
	tee_local	$push292=, $8=, $pop293
	call    	check@FUNCTION, $5, $pop105, $pop292
	i32.load8_u	$push291=, A($8)
	tee_local	$push290=, $6=, $pop291
	i32.const	$push289=, 257
	i32.mul 	$push106=, $pop290, $pop289
	i32.store16	$discard=, u+12($5):p2align=0, $pop106
	i32.const	$push288=, 16843009
	i32.mul 	$push107=, $6, $pop288
	i32.store	$push108=, u+8($5):p2align=0, $pop107
	i32.store	$push109=, u+4($5):p2align=0, $pop108
	i32.store	$discard=, u($5):p2align=0, $pop109
	i32.const	$push287=, 14
	i32.const	$push286=, 65
	call    	check@FUNCTION, $5, $pop287, $pop286
	i32.const	$push110=, 16962
	i32.store16	$3=, u+12($5):p2align=0, $pop110
	i64.const	$push111=, 4774451407313060418
	i64.store	$4=, u+4($5):p2align=0, $pop111
	i32.store	$discard=, u($5):p2align=0, $0
	i32.const	$push285=, 14
	i32.const	$push284=, 66
	call    	check@FUNCTION, $5, $pop285, $pop284
	i32.const	$push283=, 1
	i32.add 	$5=, $5, $pop283
	copy_local	$6=, $8
	i32.const	$push282=, 8
	i32.ne  	$push112=, $5, $pop282
	br_if   	0, $pop112      # 0: up to label35
.LBB2_15:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label36:
	loop                            # label37:
	i32.const	$push309=, 97
	i32.const	$push308=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop309, $pop308
	i32.store8	$push113=, u+14($6), $8
	i32.store16	$5=, u+12($6):p2align=0, $pop113
	i64.store	$discard=, u+4($6):p2align=0, $2
	i32.const	$push114=, 15
	i32.store	$push307=, u($6):p2align=0, $5
	tee_local	$push306=, $5=, $pop307
	call    	check@FUNCTION, $6, $pop114, $pop306
	i32.load8_u	$push115=, A($5)
	i32.store8	$push305=, u+14($6), $pop115
	tee_local	$push304=, $5=, $pop305
	i32.const	$push303=, 257
	i32.mul 	$push116=, $pop304, $pop303
	i32.store16	$discard=, u+12($6):p2align=0, $pop116
	i32.const	$push302=, 16843009
	i32.mul 	$push117=, $5, $pop302
	i32.store	$push118=, u+8($6):p2align=0, $pop117
	i32.store	$push119=, u+4($6):p2align=0, $pop118
	i32.store	$discard=, u($6):p2align=0, $pop119
	i32.const	$push301=, 15
	i32.const	$push300=, 65
	call    	check@FUNCTION, $6, $pop301, $pop300
	i32.const	$push299=, 66
	i32.store8	$5=, u+14($6), $pop299
	i32.store16	$discard=, u+12($6):p2align=0, $3
	i64.store	$discard=, u+4($6):p2align=0, $4
	i32.const	$push120=, 1111638594
	i32.store	$discard=, u($6):p2align=0, $pop120
	i32.const	$push298=, 15
	call    	check@FUNCTION, $6, $pop298, $5
	i32.const	$push297=, 1
	i32.add 	$6=, $6, $pop297
	i32.const	$push296=, 8
	i32.ne  	$push121=, $6, $pop296
	br_if   	0, $pop121      # 0: up to label37
# BB#16:                                # %for.end378
	end_loop                        # label38:
	i32.const	$push122=, 0
	call    	exit@FUNCTION, $pop122
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
