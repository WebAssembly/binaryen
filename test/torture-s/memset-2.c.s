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
	i32.const	$push29=, 0
	i32.le_s	$push0=, $0, $pop29
	br_if   	0, $pop0        # 0: down to label0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$push1=, u($5)
	i32.const	$push2=, 97
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	1, $pop3        # 1: down to label2
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, u+1
	i32.add 	$3=, $5, $pop6
	i32.const	$push4=, 1
	i32.add 	$4=, $5, $pop4
	copy_local	$5=, $4
	i32.lt_s	$push5=, $4, $0
	br_if   	0, $pop5        # 0: up to label1
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
	br_if   	0, $pop7        # 0: down to label3
.LBB1_5:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.add 	$push8=, $3, $5
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop9, $2
	br_if   	1, $pop10       # 1: down to label5
# BB#6:                                 # %for.inc12
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push11=, 1
	i32.add 	$5=, $5, $pop11
	i32.add 	$4=, $3, $5
	i32.lt_s	$push12=, $5, $1
	br_if   	0, $pop12       # 0: up to label4
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
	br_if   	0, $pop14       # 0: down to label6
# BB#9:                                 # %for.inc25
	i32.load8_u	$push15=, 1($4)
	i32.const	$push32=, 97
	i32.ne  	$push16=, $pop15, $pop32
	br_if   	0, $pop16       # 0: down to label6
# BB#10:                                # %for.inc25.1
	i32.load8_u	$push17=, 2($4)
	i32.const	$push33=, 97
	i32.ne  	$push18=, $pop17, $pop33
	br_if   	0, $pop18       # 0: down to label6
# BB#11:                                # %for.inc25.2
	i32.load8_u	$push19=, 3($4)
	i32.const	$push34=, 97
	i32.ne  	$push20=, $pop19, $pop34
	br_if   	0, $pop20       # 0: down to label6
# BB#12:                                # %for.inc25.3
	i32.load8_u	$push21=, 4($4)
	i32.const	$push35=, 97
	i32.ne  	$push22=, $pop21, $pop35
	br_if   	0, $pop22       # 0: down to label6
# BB#13:                                # %for.inc25.4
	i32.load8_u	$push23=, 5($4)
	i32.const	$push36=, 97
	i32.ne  	$push24=, $pop23, $pop36
	br_if   	0, $pop24       # 0: down to label6
# BB#14:                                # %for.inc25.5
	i32.load8_u	$push25=, 6($4)
	i32.const	$push37=, 97
	i32.ne  	$push26=, $pop25, $pop37
	br_if   	0, $pop26       # 0: down to label6
# BB#15:                                # %for.inc25.6
	i32.load8_u	$push27=, 7($4)
	i32.const	$push38=, 97
	i32.ne  	$push28=, $pop27, $pop38
	br_if   	0, $pop28       # 0: down to label6
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
	.local  	i32, i32, i64, i32, i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push154=, u
	i32.const	$push153=, 97
	i32.const	$push152=, 31
	i32.call	$discard=, memset@FUNCTION, $pop154, $pop153, $pop152
	i32.const	$push151=, 1
	i32.const	$push150=, 0
	i32.store8	$push136=, u($6), $pop150
	tee_local	$push149=, $5=, $pop136
	call    	check@FUNCTION, $6, $pop151, $pop149
	i32.load8_u	$push0=, A($5)
	i32.store8	$discard=, u($6), $pop0
	i32.const	$push148=, 1
	i32.const	$push147=, 65
	call    	check@FUNCTION, $6, $pop148, $pop147
	i32.const	$push146=, 1
	i32.const	$push145=, 66
	i32.store8	$push1=, u($6), $pop145
	call    	check@FUNCTION, $6, $pop146, $pop1
	i32.const	$push144=, 1
	i32.add 	$6=, $6, $pop144
	i32.const	$push143=, 8
	i32.ne  	$push2=, $6, $pop143
	br_if   	0, $pop2        # 0: up to label7
.LBB2_2:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label8:
	loop                            # label9:
	i32.const	$push4=, u
	i32.const	$push164=, 97
	i32.const	$push163=, 31
	i32.call	$1=, memset@FUNCTION, $pop4, $pop164, $pop163
	i32.const	$push6=, 2
	i32.const	$push3=, 0
	i32.store16	$push5=, u($5):p2align=0, $pop3
	tee_local	$push162=, $8=, $pop5
	call    	check@FUNCTION, $5, $pop6, $pop162
	i32.load8_u	$push7=, A($8)
	i32.const	$push161=, 257
	i32.mul 	$push8=, $pop7, $pop161
	i32.store16	$discard=, u($5):p2align=0, $pop8
	i32.const	$push160=, 2
	i32.const	$push159=, 65
	call    	check@FUNCTION, $5, $pop160, $pop159
	i32.const	$push9=, 16962
	i32.store16	$3=, u($5):p2align=0, $pop9
	i32.const	$push158=, 2
	i32.const	$push157=, 66
	call    	check@FUNCTION, $5, $pop158, $pop157
	i32.const	$push156=, 1
	i32.add 	$5=, $5, $pop156
	copy_local	$6=, $8
	i32.const	$push155=, 8
	i32.ne  	$push10=, $5, $pop155
	br_if   	0, $pop10       # 0: up to label9
.LBB2_3:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label10:
	loop                            # label11:
	i32.const	$push174=, 97
	i32.const	$push173=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop174, $pop173
	i32.const	$push12=, 3
	i32.store8	$push11=, u+2($6), $8
	i32.store16	$push137=, u($6):p2align=0, $pop11
	tee_local	$push172=, $5=, $pop137
	call    	check@FUNCTION, $6, $pop12, $pop172
	i32.load8_u	$push13=, A($5)
	i32.store8	$push14=, u+2($6), $pop13
	i32.const	$push171=, 257
	i32.mul 	$push15=, $pop14, $pop171
	i32.store16	$discard=, u($6):p2align=0, $pop15
	i32.const	$push170=, 3
	i32.const	$push169=, 65
	call    	check@FUNCTION, $6, $pop170, $pop169
	i32.const	$push168=, 66
	i32.store8	$0=, u+2($6), $pop168
	i32.store16	$discard=, u($6):p2align=0, $3
	i32.const	$push167=, 3
	call    	check@FUNCTION, $6, $pop167, $0
	i32.const	$push166=, 1
	i32.add 	$6=, $6, $pop166
	i32.const	$push165=, 8
	i32.ne  	$push16=, $6, $pop165
	br_if   	0, $pop16       # 0: up to label11
.LBB2_4:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label12:
	loop                            # label13:
	i32.const	$push18=, u
	i32.const	$push184=, 97
	i32.const	$push183=, 31
	i32.call	$1=, memset@FUNCTION, $pop18, $pop184, $pop183
	i32.const	$push20=, 4
	i32.const	$push17=, 0
	i32.store	$push19=, u($5):p2align=0, $pop17
	tee_local	$push182=, $8=, $pop19
	call    	check@FUNCTION, $5, $pop20, $pop182
	i32.load8_u	$push21=, A($8)
	i32.const	$push181=, 16843009
	i32.mul 	$push22=, $pop21, $pop181
	i32.store	$discard=, u($5):p2align=0, $pop22
	i32.const	$push180=, 4
	i32.const	$push179=, 65
	call    	check@FUNCTION, $5, $pop180, $pop179
	i32.const	$push23=, 1111638594
	i32.store	$3=, u($5):p2align=0, $pop23
	i32.const	$push178=, 4
	i32.const	$push177=, 66
	call    	check@FUNCTION, $5, $pop178, $pop177
	i32.const	$push176=, 1
	i32.add 	$5=, $5, $pop176
	copy_local	$6=, $8
	i32.const	$push175=, 8
	i32.ne  	$push24=, $5, $pop175
	br_if   	0, $pop24       # 0: up to label13
.LBB2_5:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label14:
	loop                            # label15:
	i32.const	$push194=, 97
	i32.const	$push193=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop194, $pop193
	i32.const	$push26=, 5
	i32.store8	$push25=, u+4($6), $8
	i32.store	$push138=, u($6):p2align=0, $pop25
	tee_local	$push192=, $5=, $pop138
	call    	check@FUNCTION, $6, $pop26, $pop192
	i32.load8_u	$push27=, A($5)
	i32.store8	$push28=, u+4($6), $pop27
	i32.const	$push191=, 16843009
	i32.mul 	$push29=, $pop28, $pop191
	i32.store	$discard=, u($6):p2align=0, $pop29
	i32.const	$push190=, 5
	i32.const	$push189=, 65
	call    	check@FUNCTION, $6, $pop190, $pop189
	i32.const	$push188=, 66
	i32.store8	$0=, u+4($6), $pop188
	i32.store	$discard=, u($6):p2align=0, $3
	i32.const	$push187=, 5
	call    	check@FUNCTION, $6, $pop187, $0
	i32.const	$push186=, 1
	i32.add 	$6=, $6, $pop186
	i32.const	$push185=, 8
	i32.ne  	$push30=, $6, $pop185
	br_if   	0, $pop30       # 0: up to label15
.LBB2_6:                                # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label16:
	loop                            # label17:
	i32.const	$push32=, u
	i32.const	$push206=, 97
	i32.const	$push205=, 31
	i32.call	$1=, memset@FUNCTION, $pop32, $pop206, $pop205
	i32.const	$push35=, 6
	i32.const	$push31=, 0
	i32.store16	$push33=, u+4($5):p2align=0, $pop31
	i32.store	$push34=, u($5):p2align=0, $pop33
	tee_local	$push204=, $8=, $pop34
	call    	check@FUNCTION, $5, $pop35, $pop204
	i32.load8_u	$push36=, A($8)
	tee_local	$push203=, $6=, $pop36
	i32.const	$push202=, 257
	i32.mul 	$push37=, $pop203, $pop202
	i32.store16	$discard=, u+4($5):p2align=0, $pop37
	i32.const	$push201=, 16843009
	i32.mul 	$push38=, $6, $pop201
	i32.store	$discard=, u($5):p2align=0, $pop38
	i32.const	$push200=, 6
	i32.const	$push199=, 65
	call    	check@FUNCTION, $5, $pop200, $pop199
	i32.const	$push39=, 16962
	i32.store16	$3=, u+4($5):p2align=0, $pop39
	i32.const	$push40=, 1111638594
	i32.store	$0=, u($5):p2align=0, $pop40
	i32.const	$push198=, 6
	i32.const	$push197=, 66
	call    	check@FUNCTION, $5, $pop198, $pop197
	i32.const	$push196=, 1
	i32.add 	$5=, $5, $pop196
	copy_local	$6=, $8
	i32.const	$push195=, 8
	i32.ne  	$push41=, $5, $pop195
	br_if   	0, $pop41       # 0: up to label17
.LBB2_7:                                # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label18:
	loop                            # label19:
	i32.const	$push218=, 97
	i32.const	$push217=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop218, $pop217
	i32.const	$push44=, 7
	i32.store8	$push42=, u+6($6), $8
	i32.store16	$push43=, u+4($6):p2align=0, $pop42
	i32.store	$push139=, u($6):p2align=0, $pop43
	tee_local	$push216=, $5=, $pop139
	call    	check@FUNCTION, $6, $pop44, $pop216
	i32.load8_u	$push45=, A($5)
	i32.store8	$push46=, u+6($6), $pop45
	tee_local	$push215=, $7=, $pop46
	i32.const	$push214=, 257
	i32.mul 	$push47=, $pop215, $pop214
	i32.store16	$discard=, u+4($6):p2align=0, $pop47
	i32.const	$push213=, 16843009
	i32.mul 	$push48=, $7, $pop213
	i32.store	$discard=, u($6):p2align=0, $pop48
	i32.const	$push212=, 7
	i32.const	$push211=, 65
	call    	check@FUNCTION, $6, $pop212, $pop211
	i32.const	$push210=, 66
	i32.store8	$7=, u+6($6), $pop210
	i32.store16	$discard=, u+4($6):p2align=0, $3
	i32.store	$discard=, u($6):p2align=0, $0
	i32.const	$push209=, 7
	call    	check@FUNCTION, $6, $pop209, $7
	i32.const	$push208=, 1
	i32.add 	$6=, $6, $pop208
	i32.const	$push207=, 8
	i32.ne  	$push49=, $6, $pop207
	br_if   	0, $pop49       # 0: up to label19
.LBB2_8:                                # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label20:
	loop                            # label21:
	i32.const	$push50=, u
	i32.const	$push230=, 97
	i32.const	$push229=, 31
	i32.call	$8=, memset@FUNCTION, $pop50, $pop230, $pop229
	i64.const	$push51=, 0
	i64.store	$discard=, u($5):p2align=0, $pop51
	i32.const	$push228=, 8
	i32.const	$push227=, 0
	call    	check@FUNCTION, $5, $pop228, $pop227
	i32.const	$push226=, 0
	i32.load8_u	$push52=, A($pop226)
	i32.const	$push225=, 16843009
	i32.mul 	$push53=, $pop52, $pop225
	i32.store	$push54=, u+4($5):p2align=0, $pop53
	i32.store	$discard=, u($5):p2align=0, $pop54
	i32.const	$push224=, 8
	i32.const	$push223=, 65
	call    	check@FUNCTION, $5, $pop224, $pop223
	i64.const	$push55=, 4774451407313060418
	i64.store	$discard=, u($5):p2align=0, $pop55
	i32.const	$push222=, 8
	i32.const	$push221=, 66
	call    	check@FUNCTION, $5, $pop222, $pop221
	i32.const	$push220=, 1
	i32.add 	$5=, $5, $pop220
	i32.const	$6=, 0
	i32.const	$push219=, 8
	i32.ne  	$push56=, $5, $pop219
	br_if   	0, $pop56       # 0: up to label21
.LBB2_9:                                # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label22:
	loop                            # label23:
	i32.const	$push241=, 97
	i32.const	$push240=, 31
	i32.call	$discard=, memset@FUNCTION, $8, $pop241, $pop240
	i32.const	$push59=, 9
	i32.const	$push239=, 0
	i32.store8	$push57=, u+8($6), $pop239
	i32.store	$push58=, u+4($6):p2align=0, $pop57
	i32.store	$push140=, u($6):p2align=0, $pop58
	tee_local	$push238=, $5=, $pop140
	call    	check@FUNCTION, $6, $pop59, $pop238
	i32.load8_u	$push60=, A($5)
	i32.store8	$push61=, u+8($6), $pop60
	i32.const	$push237=, 16843009
	i32.mul 	$push62=, $pop61, $pop237
	i32.store	$push63=, u+4($6):p2align=0, $pop62
	i32.store	$discard=, u($6):p2align=0, $pop63
	i32.const	$push236=, 9
	i32.const	$push235=, 65
	call    	check@FUNCTION, $6, $pop236, $pop235
	i32.const	$push234=, 66
	i32.store8	$1=, u+8($6), $pop234
	i32.const	$push64=, 1111638594
	i32.store	$push65=, u+4($6):p2align=0, $pop64
	i32.store	$3=, u($6):p2align=0, $pop65
	i32.const	$push233=, 9
	call    	check@FUNCTION, $6, $pop233, $1
	i32.const	$push232=, 1
	i32.add 	$6=, $6, $pop232
	i32.const	$push231=, 8
	i32.ne  	$push66=, $6, $pop231
	br_if   	0, $pop66       # 0: up to label23
.LBB2_10:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label24:
	loop                            # label25:
	i32.const	$push68=, u
	i32.const	$push253=, 97
	i32.const	$push252=, 31
	i32.call	$1=, memset@FUNCTION, $pop68, $pop253, $pop252
	i32.const	$push72=, 10
	i32.const	$push67=, 0
	i32.store16	$push69=, u+8($5):p2align=0, $pop67
	i32.store	$push70=, u+4($5):p2align=0, $pop69
	i32.store	$push71=, u($5):p2align=0, $pop70
	tee_local	$push251=, $8=, $pop71
	call    	check@FUNCTION, $5, $pop72, $pop251
	i32.load8_u	$push73=, A($8)
	tee_local	$push250=, $6=, $pop73
	i32.const	$push249=, 257
	i32.mul 	$push74=, $pop250, $pop249
	i32.store16	$discard=, u+8($5):p2align=0, $pop74
	i32.const	$push248=, 16843009
	i32.mul 	$push75=, $6, $pop248
	i32.store	$push76=, u+4($5):p2align=0, $pop75
	i32.store	$discard=, u($5):p2align=0, $pop76
	i32.const	$push247=, 10
	i32.const	$push246=, 65
	call    	check@FUNCTION, $5, $pop247, $pop246
	i32.const	$push77=, 16962
	i32.store16	$0=, u+8($5):p2align=0, $pop77
	i32.store	$push78=, u+4($5):p2align=0, $3
	i32.store	$discard=, u($5):p2align=0, $pop78
	i32.const	$push245=, 10
	i32.const	$push244=, 66
	call    	check@FUNCTION, $5, $pop245, $pop244
	i32.const	$push243=, 1
	i32.add 	$5=, $5, $pop243
	copy_local	$6=, $8
	i32.const	$push242=, 8
	i32.ne  	$push79=, $5, $pop242
	br_if   	0, $pop79       # 0: up to label25
.LBB2_11:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label26:
	loop                            # label27:
	i32.const	$push265=, 97
	i32.const	$push264=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop265, $pop264
	i32.const	$push83=, 11
	i32.store8	$push80=, u+10($6), $8
	i32.store16	$push81=, u+8($6):p2align=0, $pop80
	i32.store	$push82=, u+4($6):p2align=0, $pop81
	i32.store	$push141=, u($6):p2align=0, $pop82
	tee_local	$push263=, $5=, $pop141
	call    	check@FUNCTION, $6, $pop83, $pop263
	i32.load8_u	$push84=, A($5)
	i32.store8	$push85=, u+10($6), $pop84
	tee_local	$push262=, $3=, $pop85
	i32.const	$push261=, 257
	i32.mul 	$push86=, $pop262, $pop261
	i32.store16	$discard=, u+8($6):p2align=0, $pop86
	i32.const	$push260=, 16843009
	i32.mul 	$push87=, $3, $pop260
	i32.store	$push88=, u+4($6):p2align=0, $pop87
	i32.store	$discard=, u($6):p2align=0, $pop88
	i32.const	$push259=, 11
	i32.const	$push258=, 65
	call    	check@FUNCTION, $6, $pop259, $pop258
	i32.const	$push257=, 66
	i32.store8	$3=, u+10($6), $pop257
	i32.store16	$discard=, u+8($6):p2align=0, $0
	i32.const	$push89=, 1111638594
	i32.store	$push90=, u+4($6):p2align=0, $pop89
	i32.store	$7=, u($6):p2align=0, $pop90
	i32.const	$push256=, 11
	call    	check@FUNCTION, $6, $pop256, $3
	i32.const	$push255=, 1
	i32.add 	$6=, $6, $pop255
	i32.const	$push254=, 8
	i32.ne  	$push91=, $6, $pop254
	br_if   	0, $pop91       # 0: up to label27
.LBB2_12:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label28:
	loop                            # label29:
	i32.const	$push93=, u
	i32.const	$push275=, 97
	i32.const	$push274=, 31
	i32.call	$1=, memset@FUNCTION, $pop93, $pop275, $pop274
	i64.const	$push94=, 0
	i64.store	$2=, u+4($5):p2align=0, $pop94
	i32.const	$push96=, 12
	i32.const	$push92=, 0
	i32.store	$push95=, u($5):p2align=0, $pop92
	tee_local	$push273=, $8=, $pop95
	call    	check@FUNCTION, $5, $pop96, $pop273
	i32.load8_u	$push97=, A($8)
	i32.const	$push272=, 16843009
	i32.mul 	$push98=, $pop97, $pop272
	i32.store	$push99=, u+8($5):p2align=0, $pop98
	i32.store	$push100=, u+4($5):p2align=0, $pop99
	i32.store	$discard=, u($5):p2align=0, $pop100
	i32.const	$push271=, 12
	i32.const	$push270=, 65
	call    	check@FUNCTION, $5, $pop271, $pop270
	i64.const	$push101=, 4774451407313060418
	i64.store	$4=, u+4($5):p2align=0, $pop101
	i32.store	$discard=, u($5):p2align=0, $7
	i32.const	$push269=, 12
	i32.const	$push268=, 66
	call    	check@FUNCTION, $5, $pop269, $pop268
	i32.const	$push267=, 1
	i32.add 	$5=, $5, $pop267
	copy_local	$6=, $8
	i32.const	$push266=, 8
	i32.ne  	$push102=, $5, $pop266
	br_if   	0, $pop102      # 0: up to label29
.LBB2_13:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label30:
	loop                            # label31:
	i32.const	$push285=, 97
	i32.const	$push284=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop285, $pop284
	i32.store8	$5=, u+12($6), $8
	i64.store	$discard=, u+4($6):p2align=0, $2
	i32.const	$push103=, 13
	i32.store	$push142=, u($6):p2align=0, $5
	tee_local	$push283=, $5=, $pop142
	call    	check@FUNCTION, $6, $pop103, $pop283
	i32.load8_u	$push104=, A($5)
	i32.store8	$push105=, u+12($6), $pop104
	i32.const	$push282=, 16843009
	i32.mul 	$push106=, $pop105, $pop282
	i32.store	$push107=, u+8($6):p2align=0, $pop106
	i32.store	$push108=, u+4($6):p2align=0, $pop107
	i32.store	$discard=, u($6):p2align=0, $pop108
	i32.const	$push281=, 13
	i32.const	$push280=, 65
	call    	check@FUNCTION, $6, $pop281, $pop280
	i32.const	$push279=, 66
	i32.store8	$3=, u+12($6), $pop279
	i64.store	$discard=, u+4($6):p2align=0, $4
	i32.const	$push109=, 1111638594
	i32.store	$0=, u($6):p2align=0, $pop109
	i32.const	$push278=, 13
	call    	check@FUNCTION, $6, $pop278, $3
	i32.const	$push277=, 1
	i32.add 	$6=, $6, $pop277
	i32.const	$push276=, 8
	i32.ne  	$push110=, $6, $pop276
	br_if   	0, $pop110      # 0: up to label31
.LBB2_14:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label32:
	loop                            # label33:
	i32.const	$push112=, u
	i32.const	$push297=, 97
	i32.const	$push296=, 31
	i32.call	$1=, memset@FUNCTION, $pop112, $pop297, $pop296
	i32.const	$push111=, 0
	i32.store16	$6=, u+12($5):p2align=0, $pop111
	i64.const	$push113=, 0
	i64.store	$2=, u+4($5):p2align=0, $pop113
	i32.const	$push115=, 14
	i32.store	$push114=, u($5):p2align=0, $6
	tee_local	$push295=, $8=, $pop114
	call    	check@FUNCTION, $5, $pop115, $pop295
	i32.load8_u	$push116=, A($8)
	tee_local	$push294=, $6=, $pop116
	i32.const	$push293=, 257
	i32.mul 	$push117=, $pop294, $pop293
	i32.store16	$discard=, u+12($5):p2align=0, $pop117
	i32.const	$push292=, 16843009
	i32.mul 	$push118=, $6, $pop292
	i32.store	$push119=, u+8($5):p2align=0, $pop118
	i32.store	$push120=, u+4($5):p2align=0, $pop119
	i32.store	$discard=, u($5):p2align=0, $pop120
	i32.const	$push291=, 14
	i32.const	$push290=, 65
	call    	check@FUNCTION, $5, $pop291, $pop290
	i32.const	$push121=, 16962
	i32.store16	$3=, u+12($5):p2align=0, $pop121
	i64.const	$push122=, 4774451407313060418
	i64.store	$4=, u+4($5):p2align=0, $pop122
	i32.store	$discard=, u($5):p2align=0, $0
	i32.const	$push289=, 14
	i32.const	$push288=, 66
	call    	check@FUNCTION, $5, $pop289, $pop288
	i32.const	$push287=, 1
	i32.add 	$5=, $5, $pop287
	copy_local	$6=, $8
	i32.const	$push286=, 8
	i32.ne  	$push123=, $5, $pop286
	br_if   	0, $pop123      # 0: up to label33
.LBB2_15:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label34:
	loop                            # label35:
	i32.const	$push309=, 97
	i32.const	$push308=, 31
	i32.call	$discard=, memset@FUNCTION, $1, $pop309, $pop308
	i32.store8	$push124=, u+14($6), $8
	i32.store16	$5=, u+12($6):p2align=0, $pop124
	i64.store	$discard=, u+4($6):p2align=0, $2
	i32.const	$push126=, 15
	i32.store	$push125=, u($6):p2align=0, $5
	tee_local	$push307=, $5=, $pop125
	call    	check@FUNCTION, $6, $pop126, $pop307
	i32.load8_u	$push127=, A($5)
	i32.store8	$push128=, u+14($6), $pop127
	tee_local	$push306=, $5=, $pop128
	i32.const	$push305=, 257
	i32.mul 	$push129=, $pop306, $pop305
	i32.store16	$discard=, u+12($6):p2align=0, $pop129
	i32.const	$push304=, 16843009
	i32.mul 	$push130=, $5, $pop304
	i32.store	$push131=, u+8($6):p2align=0, $pop130
	i32.store	$push132=, u+4($6):p2align=0, $pop131
	i32.store	$discard=, u($6):p2align=0, $pop132
	i32.const	$push303=, 15
	i32.const	$push302=, 65
	call    	check@FUNCTION, $6, $pop303, $pop302
	i32.const	$push301=, 66
	i32.store8	$5=, u+14($6), $pop301
	i32.store16	$discard=, u+12($6):p2align=0, $3
	i64.store	$discard=, u+4($6):p2align=0, $4
	i32.const	$push133=, 1111638594
	i32.store	$discard=, u($6):p2align=0, $pop133
	i32.const	$push300=, 15
	call    	check@FUNCTION, $6, $pop300, $5
	i32.const	$push299=, 1
	i32.add 	$6=, $6, $pop299
	i32.const	$push298=, 8
	i32.ne  	$push134=, $6, $pop298
	br_if   	0, $pop134      # 0: up to label35
# BB#16:                                # %for.end378
	end_loop                        # label36:
	i32.const	$push135=, 0
	call    	exit@FUNCTION, $pop135
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
