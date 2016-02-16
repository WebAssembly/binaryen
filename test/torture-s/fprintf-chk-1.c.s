	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-chk-1.c"
	.section	.text.__fprintf_chk,"ax",@progbits
	.hidden	__fprintf_chk
	.globl	__fprintf_chk
	.type	__fprintf_chk,@function
__fprintf_chk:                          # @__fprintf_chk
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	block
	i32.const	$push4=, 0
	i32.load	$push0=, should_optimize($pop4)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, should_optimize($pop5), $pop1
	i32.store	$push2=, 12($7), $3
	i32.call	$push3=, vfprintf@FUNCTION, $0, $2, $pop2
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$pop3
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__fprintf_chk, .Lfunc_end0-__fprintf_chk

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 224
	i32.sub 	$19=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$19=, 0($4), $19
	i32.const	$push84=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, should_optimize($pop84), $pop0
	i32.const	$push83=, 0
	i32.load	$push1=, stdout($pop83)
	i32.const	$push82=, .L.str
	i32.const	$push81=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop1, $0, $pop82, $pop81
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push80=, 0
	i32.load	$push2=, should_optimize($pop80)
	i32.const	$push178=, 0
	i32.eq  	$push179=, $pop2, $pop178
	br_if   	0, $pop179      # 0: down to label33
# BB#1:                                 # %if.end
	i32.const	$push89=, 0
	i32.const	$push88=, 0
	i32.store	$push87=, should_optimize($pop89), $pop88
	tee_local	$push86=, $0=, $pop87
	i32.load	$push3=, stdout($pop86)
	i32.const	$push85=, .L.str
	i32.call	$push4=, __fprintf_chk@FUNCTION, $pop3, $0, $pop85, $0
	i32.const	$push5=, 5
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label32
# BB#2:                                 # %if.end3
	i32.const	$push90=, 0
	i32.load	$push7=, should_optimize($pop90)
	i32.const	$push180=, 0
	i32.eq  	$push181=, $pop7, $pop180
	br_if   	2, $pop181      # 2: down to label31
# BB#3:                                 # %if.end6
	i32.const	$push95=, 0
	i32.const	$push8=, 1
	i32.store	$discard=, should_optimize($pop95), $pop8
	i32.const	$push94=, 0
	i32.load	$push9=, stdout($pop94)
	i32.const	$push93=, .L.str.1
	i32.const	$push92=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop9, $0, $pop93, $pop92
	i32.const	$push91=, 0
	i32.load	$push10=, should_optimize($pop91)
	i32.const	$push182=, 0
	i32.eq  	$push183=, $pop10, $pop182
	br_if   	3, $pop183      # 3: down to label30
# BB#4:                                 # %if.end10
	i32.const	$push11=, 0
	i32.const	$push99=, 0
	i32.store	$push98=, should_optimize($pop11), $pop99
	tee_local	$push97=, $0=, $pop98
	i32.load	$push12=, stdout($pop97)
	i32.const	$push96=, .L.str.1
	i32.call	$push13=, __fprintf_chk@FUNCTION, $pop12, $0, $pop96, $0
	i32.const	$push14=, 6
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	4, $pop15       # 4: down to label29
# BB#5:                                 # %if.end14
	i32.load	$push16=, should_optimize($0)
	i32.const	$push184=, 0
	i32.eq  	$push185=, $pop16, $pop184
	br_if   	5, $pop185      # 5: down to label28
# BB#6:                                 # %if.end17
	i32.const	$push104=, 0
	i32.const	$push17=, 1
	i32.store	$0=, should_optimize($pop104), $pop17
	i32.const	$push103=, 0
	i32.load	$push18=, stdout($pop103)
	i32.const	$push102=, .L.str.2
	i32.const	$push101=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop18, $0, $pop102, $pop101
	i32.const	$push100=, 0
	i32.load	$push19=, should_optimize($pop100)
	i32.const	$push186=, 0
	i32.eq  	$push187=, $pop19, $pop186
	br_if   	6, $pop187      # 6: down to label27
# BB#7:                                 # %if.end21
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.store	$push107=, should_optimize($pop109), $pop108
	tee_local	$push106=, $1=, $pop107
	i32.load	$push20=, stdout($pop106)
	i32.const	$push105=, .L.str.2
	i32.call	$push21=, __fprintf_chk@FUNCTION, $pop20, $0, $pop105, $1
	i32.ne  	$push22=, $pop21, $0
	br_if   	7, $pop22       # 7: down to label26
# BB#8:                                 # %if.end25
	i32.const	$push110=, 0
	i32.load	$push23=, should_optimize($pop110)
	i32.const	$push188=, 0
	i32.eq  	$push189=, $pop23, $pop188
	br_if   	8, $pop189      # 8: down to label25
# BB#9:                                 # %if.end28
	i32.const	$push115=, 0
	i32.const	$push24=, 1
	i32.store	$discard=, should_optimize($pop115), $pop24
	i32.const	$push114=, 0
	i32.load	$push25=, stdout($pop114)
	i32.const	$push113=, .L.str.3
	i32.const	$push112=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop25, $0, $pop113, $pop112
	i32.const	$push111=, 0
	i32.load	$push26=, should_optimize($pop111)
	i32.const	$push190=, 0
	i32.eq  	$push191=, $pop26, $pop190
	br_if   	9, $pop191      # 9: down to label24
# BB#10:                                # %if.end32
	i32.const	$push27=, 0
	i32.const	$push119=, 0
	i32.store	$push118=, should_optimize($pop27), $pop119
	tee_local	$push117=, $0=, $pop118
	i32.load	$push28=, stdout($pop117)
	i32.const	$push116=, .L.str.3
	i32.call	$push29=, __fprintf_chk@FUNCTION, $pop28, $0, $pop116, $0
	br_if   	10, $pop29      # 10: down to label23
# BB#11:                                # %if.end36
	i32.load	$push30=, should_optimize($0)
	i32.const	$push192=, 0
	i32.eq  	$push193=, $pop30, $pop192
	br_if   	11, $pop193     # 11: down to label22
# BB#12:                                # %if.end39
	i32.const	$push123=, 0
	i32.const	$push31=, 1
	i32.store	$discard=, should_optimize($pop123), $pop31
	i32.const	$push122=, 0
	i32.load	$0=, stdout($pop122)
	i32.const	$push32=, .L.str
	i32.store	$1=, 208($19):p2align=4, $pop32
	i32.const	$push121=, .L.str.4
	i32.const	$6=, 208
	i32.add 	$6=, $19, $6
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop121, $6
	i32.const	$push120=, 0
	i32.load	$push33=, should_optimize($pop120)
	i32.const	$push194=, 0
	i32.eq  	$push195=, $pop33, $pop194
	br_if   	12, $pop195     # 12: down to label21
# BB#13:                                # %if.end43
	i32.const	$push126=, 0
	i32.const	$push125=, 0
	i32.store	$push34=, should_optimize($pop126), $pop125
	i32.load	$0=, stdout($pop34)
	i32.store	$discard=, 192($19):p2align=4, $1
	i32.const	$push124=, .L.str.4
	i32.const	$7=, 192
	i32.add 	$7=, $19, $7
	i32.call	$push35=, __fprintf_chk@FUNCTION, $0, $0, $pop124, $7
	i32.const	$push36=, 5
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	13, $pop37      # 13: down to label20
# BB#14:                                # %if.end47
	i32.const	$push127=, 0
	i32.load	$push38=, should_optimize($pop127)
	i32.const	$push196=, 0
	i32.eq  	$push197=, $pop38, $pop196
	br_if   	14, $pop197     # 14: down to label19
# BB#15:                                # %if.end50
	i32.const	$push131=, 0
	i32.const	$push39=, 1
	i32.store	$discard=, should_optimize($pop131), $pop39
	i32.const	$push130=, 0
	i32.load	$0=, stdout($pop130)
	i32.const	$push40=, .L.str.1
	i32.store	$1=, 176($19):p2align=4, $pop40
	i32.const	$push129=, .L.str.4
	i32.const	$8=, 176
	i32.add 	$8=, $19, $8
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop129, $8
	i32.const	$push128=, 0
	i32.load	$push41=, should_optimize($pop128)
	i32.const	$push198=, 0
	i32.eq  	$push199=, $pop41, $pop198
	br_if   	15, $pop199     # 15: down to label18
# BB#16:                                # %if.end54
	i32.const	$push42=, 0
	i32.const	$push135=, 0
	i32.store	$push134=, should_optimize($pop42), $pop135
	tee_local	$push133=, $2=, $pop134
	i32.load	$0=, stdout($pop133)
	i32.store	$discard=, 160($19):p2align=4, $1
	i32.const	$push132=, .L.str.4
	i32.const	$9=, 160
	i32.add 	$9=, $19, $9
	i32.call	$push43=, __fprintf_chk@FUNCTION, $0, $0, $pop132, $9
	i32.const	$push44=, 6
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	16, $pop45      # 16: down to label17
# BB#17:                                # %if.end58
	i32.load	$push46=, should_optimize($2)
	i32.const	$push200=, 0
	i32.eq  	$push201=, $pop46, $pop200
	br_if   	17, $pop201     # 17: down to label16
# BB#18:                                # %if.end61
	i32.const	$push139=, 0
	i32.const	$push47=, 1
	i32.store	$1=, should_optimize($pop139), $pop47
	i32.const	$push138=, 0
	i32.load	$0=, stdout($pop138)
	i32.const	$push48=, .L.str.2
	i32.store	$2=, 144($19):p2align=4, $pop48
	i32.const	$push137=, .L.str.4
	i32.const	$10=, 144
	i32.add 	$10=, $19, $10
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop137, $10
	i32.const	$push136=, 0
	i32.load	$push49=, should_optimize($pop136)
	i32.const	$push202=, 0
	i32.eq  	$push203=, $pop49, $pop202
	br_if   	18, $pop203     # 18: down to label15
# BB#19:                                # %if.end65
	i32.const	$push142=, 0
	i32.const	$push141=, 0
	i32.store	$push50=, should_optimize($pop142), $pop141
	i32.load	$0=, stdout($pop50)
	i32.store	$discard=, 128($19):p2align=4, $2
	i32.const	$push140=, .L.str.4
	i32.const	$11=, 128
	i32.add 	$11=, $19, $11
	i32.call	$push51=, __fprintf_chk@FUNCTION, $0, $0, $pop140, $11
	i32.ne  	$push52=, $pop51, $1
	br_if   	19, $pop52      # 19: down to label14
# BB#20:                                # %if.end69
	i32.const	$push143=, 0
	i32.load	$push53=, should_optimize($pop143)
	i32.const	$push204=, 0
	i32.eq  	$push205=, $pop53, $pop204
	br_if   	20, $pop205     # 20: down to label13
# BB#21:                                # %if.end72
	i32.const	$push147=, 0
	i32.const	$push54=, 1
	i32.store	$discard=, should_optimize($pop147), $pop54
	i32.const	$push146=, 0
	i32.load	$0=, stdout($pop146)
	i32.const	$push55=, .L.str.3
	i32.store	$1=, 112($19):p2align=4, $pop55
	i32.const	$push145=, .L.str.4
	i32.const	$12=, 112
	i32.add 	$12=, $19, $12
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop145, $12
	i32.const	$push144=, 0
	i32.load	$push56=, should_optimize($pop144)
	i32.const	$push206=, 0
	i32.eq  	$push207=, $pop56, $pop206
	br_if   	21, $pop207     # 21: down to label12
# BB#22:                                # %if.end76
	i32.const	$push57=, 0
	i32.const	$push151=, 0
	i32.store	$push150=, should_optimize($pop57), $pop151
	tee_local	$push149=, $2=, $pop150
	i32.load	$0=, stdout($pop149)
	i32.store	$discard=, 96($19):p2align=4, $1
	i32.const	$push148=, .L.str.4
	i32.const	$13=, 96
	i32.add 	$13=, $19, $13
	i32.call	$push58=, __fprintf_chk@FUNCTION, $0, $0, $pop148, $13
	br_if   	22, $pop58      # 22: down to label11
# BB#23:                                # %if.end80
	i32.load	$push59=, should_optimize($2)
	i32.const	$push208=, 0
	i32.eq  	$push209=, $pop59, $pop208
	br_if   	23, $pop209     # 23: down to label10
# BB#24:                                # %if.end83
	i32.const	$push155=, 0
	i32.const	$push60=, 1
	i32.store	$1=, should_optimize($pop155), $pop60
	i32.const	$push154=, 0
	i32.load	$0=, stdout($pop154)
	i32.const	$push61=, 120
	i32.store	$2=, 80($19):p2align=4, $pop61
	i32.const	$push153=, .L.str.5
	i32.const	$14=, 80
	i32.add 	$14=, $19, $14
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop153, $14
	i32.const	$push152=, 0
	i32.load	$push62=, should_optimize($pop152)
	i32.const	$push210=, 0
	i32.eq  	$push211=, $pop62, $pop210
	br_if   	24, $pop211     # 24: down to label9
# BB#25:                                # %if.end87
	i32.const	$push158=, 0
	i32.const	$push157=, 0
	i32.store	$push63=, should_optimize($pop158), $pop157
	i32.load	$0=, stdout($pop63)
	i32.store	$discard=, 64($19):p2align=4, $2
	i32.const	$push156=, .L.str.5
	i32.const	$15=, 64
	i32.add 	$15=, $19, $15
	i32.call	$push64=, __fprintf_chk@FUNCTION, $0, $0, $pop156, $15
	i32.ne  	$push65=, $pop64, $1
	br_if   	25, $pop65      # 25: down to label8
# BB#26:                                # %if.end91
	i32.const	$push159=, 0
	i32.load	$push66=, should_optimize($pop159)
	i32.const	$push212=, 0
	i32.eq  	$push213=, $pop66, $pop212
	br_if   	26, $pop213     # 26: down to label7
# BB#27:                                # %if.end94
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.store	$push162=, should_optimize($pop164), $pop163
	tee_local	$push161=, $0=, $pop162
	i32.load	$1=, stdout($pop161)
	i32.const	$push67=, .L.str.1
	i32.store	$2=, 48($19):p2align=4, $pop67
	i32.const	$push160=, .L.str.6
	i32.const	$16=, 48
	i32.add 	$16=, $19, $16
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop160, $16
	i32.load	$push68=, should_optimize($0)
	i32.const	$push214=, 0
	i32.eq  	$push215=, $pop68, $pop214
	br_if   	27, $pop215     # 27: down to label6
# BB#28:                                # %if.end98
	i32.const	$push69=, 0
	i32.const	$push168=, 0
	i32.store	$push167=, should_optimize($pop69), $pop168
	tee_local	$push166=, $1=, $pop167
	i32.load	$0=, stdout($pop166)
	i32.store	$discard=, 32($19):p2align=4, $2
	i32.const	$push165=, .L.str.6
	i32.const	$17=, 32
	i32.add 	$17=, $19, $17
	i32.call	$push70=, __fprintf_chk@FUNCTION, $0, $0, $pop165, $17
	i32.const	$push71=, 7
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	28, $pop72      # 28: down to label5
# BB#29:                                # %if.end102
	i32.load	$push73=, should_optimize($1)
	i32.const	$push216=, 0
	i32.eq  	$push217=, $pop73, $pop216
	br_if   	29, $pop217     # 29: down to label4
# BB#30:                                # %if.end105
	i32.const	$push74=, 0
	i32.const	$push172=, 0
	i32.store	$push171=, should_optimize($pop74), $pop172
	tee_local	$push170=, $0=, $pop171
	i32.load	$1=, stdout($pop170)
	i32.store	$discard=, 16($19):p2align=4, $0
	i32.const	$push169=, .L.str.7
	i32.const	$18=, 16
	i32.add 	$18=, $19, $18
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop169, $18
	i32.load	$push75=, should_optimize($0)
	i32.const	$push218=, 0
	i32.eq  	$push219=, $pop75, $pop218
	br_if   	30, $pop219     # 30: down to label3
# BB#31:                                # %if.end109
	i32.store	$push175=, should_optimize($0), $0
	tee_local	$push174=, $0=, $pop175
	i32.load	$1=, stdout($pop174)
	i32.store	$discard=, 0($19):p2align=4, $0
	i32.const	$push173=, .L.str.7
	i32.call	$push76=, __fprintf_chk@FUNCTION, $1, $0, $pop173, $19
	i32.const	$push77=, 2
	i32.ne  	$push78=, $pop76, $pop77
	br_if   	31, $pop78      # 31: down to label2
# BB#32:                                # %if.end113
	i32.const	$push176=, 0
	i32.load	$push79=, should_optimize($pop176)
	i32.const	$push220=, 0
	i32.eq  	$push221=, $pop79, $pop220
	br_if   	32, $pop221     # 32: down to label1
# BB#33:                                # %if.end116
	i32.const	$push177=, 0
	i32.const	$5=, 224
	i32.add 	$19=, $19, $5
	i32.const	$5=, __stack_pointer
	i32.store	$19=, 0($5), $19
	return  	$pop177
.LBB1_34:                               # %if.then
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then2
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then5
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then9
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then13
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then16
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then20
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_41:                               # %if.then24
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %if.then27
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_43:                               # %if.then31
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_44:                               # %if.then35
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_45:                               # %if.then38
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_46:                               # %if.then42
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_47:                               # %if.then46
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_48:                               # %if.then49
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_49:                               # %if.then53
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_50:                               # %if.then57
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_51:                               # %if.then60
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_52:                               # %if.then64
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_53:                               # %if.then68
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_54:                               # %if.then71
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_55:                               # %if.then75
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_56:                               # %if.then79
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_57:                               # %if.then82
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_58:                               # %if.then86
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_59:                               # %if.then90
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_60:                               # %if.then93
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_61:                               # %if.then97
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_62:                               # %if.then101
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_63:                               # %if.then104
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_64:                               # %if.then108
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_65:                               # %if.then112
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_66:                               # %if.then115
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	should_optimize         # @should_optimize
	.type	should_optimize,@object
	.section	.bss.should_optimize,"aw",@nobits
	.globl	should_optimize
	.p2align	2
should_optimize:
	.int32	0                       # 0x0
	.size	should_optimize, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello\n"
	.size	.L.str.1, 7

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"a"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"%s"
	.size	.L.str.4, 3

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"%c"
	.size	.L.str.5, 3

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"%s\n"
	.size	.L.str.6, 4

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"%d\n"
	.size	.L.str.7, 4


	.ident	"clang version 3.9.0 "
