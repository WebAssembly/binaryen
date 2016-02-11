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
	i32.const	$push94=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, should_optimize($pop94), $pop0
	i32.const	$push93=, 0
	i32.load	$push1=, stdout($pop93)
	i32.const	$push92=, .L.str
	i32.const	$push91=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop1, $0, $pop92, $pop91
	block
	i32.const	$push90=, 0
	i32.load	$push2=, should_optimize($pop90)
	i32.const	$push178=, 0
	i32.eq  	$push179=, $pop2, $pop178
	br_if   	0, $pop179      # 0: down to label1
# BB#1:                                 # %if.end
	block
	i32.const	$push98=, 0
	i32.const	$push97=, 0
	i32.store	$push3=, should_optimize($pop98), $pop97
	tee_local	$push96=, $0=, $pop3
	i32.load	$push4=, stdout($pop96)
	i32.const	$push95=, .L.str
	i32.call	$push5=, __fprintf_chk@FUNCTION, $pop4, $0, $pop95, $0
	i32.const	$push6=, 5
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %if.end3
	block
	i32.const	$push99=, 0
	i32.load	$push8=, should_optimize($pop99)
	i32.const	$push180=, 0
	i32.eq  	$push181=, $pop8, $pop180
	br_if   	0, $pop181      # 0: down to label3
# BB#3:                                 # %if.end6
	i32.const	$push104=, 0
	i32.const	$push9=, 1
	i32.store	$discard=, should_optimize($pop104), $pop9
	i32.const	$push103=, 0
	i32.load	$push10=, stdout($pop103)
	i32.const	$push102=, .L.str.1
	i32.const	$push101=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop10, $0, $pop102, $pop101
	block
	i32.const	$push100=, 0
	i32.load	$push11=, should_optimize($pop100)
	i32.const	$push182=, 0
	i32.eq  	$push183=, $pop11, $pop182
	br_if   	0, $pop183      # 0: down to label4
# BB#4:                                 # %if.end10
	block
	i32.const	$push12=, 0
	i32.const	$push107=, 0
	i32.store	$push13=, should_optimize($pop12), $pop107
	tee_local	$push106=, $0=, $pop13
	i32.load	$push14=, stdout($pop106)
	i32.const	$push105=, .L.str.1
	i32.call	$push15=, __fprintf_chk@FUNCTION, $pop14, $0, $pop105, $0
	i32.const	$push16=, 6
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label5
# BB#5:                                 # %if.end14
	block
	i32.load	$push18=, should_optimize($0)
	i32.const	$push184=, 0
	i32.eq  	$push185=, $pop18, $pop184
	br_if   	0, $pop185      # 0: down to label6
# BB#6:                                 # %if.end17
	i32.const	$push112=, 0
	i32.const	$push19=, 1
	i32.store	$0=, should_optimize($pop112), $pop19
	i32.const	$push111=, 0
	i32.load	$push20=, stdout($pop111)
	i32.const	$push110=, .L.str.2
	i32.const	$push109=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop20, $0, $pop110, $pop109
	block
	i32.const	$push108=, 0
	i32.load	$push21=, should_optimize($pop108)
	i32.const	$push186=, 0
	i32.eq  	$push187=, $pop21, $pop186
	br_if   	0, $pop187      # 0: down to label7
# BB#7:                                 # %if.end21
	block
	i32.const	$push116=, 0
	i32.const	$push115=, 0
	i32.store	$push22=, should_optimize($pop116), $pop115
	tee_local	$push114=, $1=, $pop22
	i32.load	$push23=, stdout($pop114)
	i32.const	$push113=, .L.str.2
	i32.call	$push24=, __fprintf_chk@FUNCTION, $pop23, $0, $pop113, $1
	i32.ne  	$push25=, $pop24, $0
	br_if   	0, $pop25       # 0: down to label8
# BB#8:                                 # %if.end25
	block
	i32.const	$push117=, 0
	i32.load	$push26=, should_optimize($pop117)
	i32.const	$push188=, 0
	i32.eq  	$push189=, $pop26, $pop188
	br_if   	0, $pop189      # 0: down to label9
# BB#9:                                 # %if.end28
	i32.const	$push122=, 0
	i32.const	$push27=, 1
	i32.store	$discard=, should_optimize($pop122), $pop27
	i32.const	$push121=, 0
	i32.load	$push28=, stdout($pop121)
	i32.const	$push120=, .L.str.3
	i32.const	$push119=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop28, $0, $pop120, $pop119
	block
	i32.const	$push118=, 0
	i32.load	$push29=, should_optimize($pop118)
	i32.const	$push190=, 0
	i32.eq  	$push191=, $pop29, $pop190
	br_if   	0, $pop191      # 0: down to label10
# BB#10:                                # %if.end32
	block
	i32.const	$push30=, 0
	i32.const	$push125=, 0
	i32.store	$push31=, should_optimize($pop30), $pop125
	tee_local	$push124=, $0=, $pop31
	i32.load	$push32=, stdout($pop124)
	i32.const	$push123=, .L.str.3
	i32.call	$push33=, __fprintf_chk@FUNCTION, $pop32, $0, $pop123, $0
	br_if   	0, $pop33       # 0: down to label11
# BB#11:                                # %if.end36
	block
	i32.load	$push34=, should_optimize($0)
	i32.const	$push192=, 0
	i32.eq  	$push193=, $pop34, $pop192
	br_if   	0, $pop193      # 0: down to label12
# BB#12:                                # %if.end39
	i32.const	$push129=, 0
	i32.const	$push35=, 1
	i32.store	$discard=, should_optimize($pop129), $pop35
	i32.const	$push128=, 0
	i32.load	$0=, stdout($pop128)
	i32.const	$push36=, .L.str
	i32.store	$1=, 208($19):p2align=4, $pop36
	i32.const	$push127=, .L.str.4
	i32.const	$6=, 208
	i32.add 	$6=, $19, $6
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop127, $6
	block
	i32.const	$push126=, 0
	i32.load	$push37=, should_optimize($pop126)
	i32.const	$push194=, 0
	i32.eq  	$push195=, $pop37, $pop194
	br_if   	0, $pop195      # 0: down to label13
# BB#13:                                # %if.end43
	i32.const	$push132=, 0
	i32.const	$push131=, 0
	i32.store	$push38=, should_optimize($pop132), $pop131
	i32.load	$0=, stdout($pop38)
	i32.store	$discard=, 192($19):p2align=4, $1
	i32.const	$push130=, .L.str.4
	i32.const	$7=, 192
	i32.add 	$7=, $19, $7
	block
	i32.call	$push39=, __fprintf_chk@FUNCTION, $0, $0, $pop130, $7
	i32.const	$push40=, 5
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label14
# BB#14:                                # %if.end47
	block
	i32.const	$push133=, 0
	i32.load	$push42=, should_optimize($pop133)
	i32.const	$push196=, 0
	i32.eq  	$push197=, $pop42, $pop196
	br_if   	0, $pop197      # 0: down to label15
# BB#15:                                # %if.end50
	i32.const	$push137=, 0
	i32.const	$push43=, 1
	i32.store	$discard=, should_optimize($pop137), $pop43
	i32.const	$push136=, 0
	i32.load	$0=, stdout($pop136)
	i32.const	$push44=, .L.str.1
	i32.store	$1=, 176($19):p2align=4, $pop44
	i32.const	$push135=, .L.str.4
	i32.const	$8=, 176
	i32.add 	$8=, $19, $8
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop135, $8
	block
	i32.const	$push134=, 0
	i32.load	$push45=, should_optimize($pop134)
	i32.const	$push198=, 0
	i32.eq  	$push199=, $pop45, $pop198
	br_if   	0, $pop199      # 0: down to label16
# BB#16:                                # %if.end54
	i32.const	$push46=, 0
	i32.const	$push140=, 0
	i32.store	$push47=, should_optimize($pop46), $pop140
	tee_local	$push139=, $2=, $pop47
	i32.load	$0=, stdout($pop139)
	i32.store	$discard=, 160($19):p2align=4, $1
	i32.const	$push138=, .L.str.4
	i32.const	$9=, 160
	i32.add 	$9=, $19, $9
	block
	i32.call	$push48=, __fprintf_chk@FUNCTION, $0, $0, $pop138, $9
	i32.const	$push49=, 6
	i32.ne  	$push50=, $pop48, $pop49
	br_if   	0, $pop50       # 0: down to label17
# BB#17:                                # %if.end58
	block
	i32.load	$push51=, should_optimize($2)
	i32.const	$push200=, 0
	i32.eq  	$push201=, $pop51, $pop200
	br_if   	0, $pop201      # 0: down to label18
# BB#18:                                # %if.end61
	i32.const	$push144=, 0
	i32.const	$push52=, 1
	i32.store	$1=, should_optimize($pop144), $pop52
	i32.const	$push143=, 0
	i32.load	$0=, stdout($pop143)
	i32.const	$push53=, .L.str.2
	i32.store	$2=, 144($19):p2align=4, $pop53
	i32.const	$push142=, .L.str.4
	i32.const	$10=, 144
	i32.add 	$10=, $19, $10
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop142, $10
	block
	i32.const	$push141=, 0
	i32.load	$push54=, should_optimize($pop141)
	i32.const	$push202=, 0
	i32.eq  	$push203=, $pop54, $pop202
	br_if   	0, $pop203      # 0: down to label19
# BB#19:                                # %if.end65
	i32.const	$push147=, 0
	i32.const	$push146=, 0
	i32.store	$push55=, should_optimize($pop147), $pop146
	i32.load	$0=, stdout($pop55)
	i32.store	$discard=, 128($19):p2align=4, $2
	i32.const	$push145=, .L.str.4
	i32.const	$11=, 128
	i32.add 	$11=, $19, $11
	block
	i32.call	$push56=, __fprintf_chk@FUNCTION, $0, $0, $pop145, $11
	i32.ne  	$push57=, $pop56, $1
	br_if   	0, $pop57       # 0: down to label20
# BB#20:                                # %if.end69
	block
	i32.const	$push148=, 0
	i32.load	$push58=, should_optimize($pop148)
	i32.const	$push204=, 0
	i32.eq  	$push205=, $pop58, $pop204
	br_if   	0, $pop205      # 0: down to label21
# BB#21:                                # %if.end72
	i32.const	$push152=, 0
	i32.const	$push59=, 1
	i32.store	$discard=, should_optimize($pop152), $pop59
	i32.const	$push151=, 0
	i32.load	$0=, stdout($pop151)
	i32.const	$push60=, .L.str.3
	i32.store	$1=, 112($19):p2align=4, $pop60
	i32.const	$push150=, .L.str.4
	i32.const	$12=, 112
	i32.add 	$12=, $19, $12
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop150, $12
	block
	i32.const	$push149=, 0
	i32.load	$push61=, should_optimize($pop149)
	i32.const	$push206=, 0
	i32.eq  	$push207=, $pop61, $pop206
	br_if   	0, $pop207      # 0: down to label22
# BB#22:                                # %if.end76
	i32.const	$push62=, 0
	i32.const	$push155=, 0
	i32.store	$push63=, should_optimize($pop62), $pop155
	tee_local	$push154=, $2=, $pop63
	i32.load	$0=, stdout($pop154)
	i32.store	$discard=, 96($19):p2align=4, $1
	i32.const	$push153=, .L.str.4
	i32.const	$13=, 96
	i32.add 	$13=, $19, $13
	block
	i32.call	$push64=, __fprintf_chk@FUNCTION, $0, $0, $pop153, $13
	br_if   	0, $pop64       # 0: down to label23
# BB#23:                                # %if.end80
	block
	i32.load	$push65=, should_optimize($2)
	i32.const	$push208=, 0
	i32.eq  	$push209=, $pop65, $pop208
	br_if   	0, $pop209      # 0: down to label24
# BB#24:                                # %if.end83
	i32.const	$push159=, 0
	i32.const	$push66=, 1
	i32.store	$1=, should_optimize($pop159), $pop66
	i32.const	$push158=, 0
	i32.load	$0=, stdout($pop158)
	i32.const	$push67=, 120
	i32.store	$2=, 80($19):p2align=4, $pop67
	i32.const	$push157=, .L.str.5
	i32.const	$14=, 80
	i32.add 	$14=, $19, $14
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop157, $14
	block
	i32.const	$push156=, 0
	i32.load	$push68=, should_optimize($pop156)
	i32.const	$push210=, 0
	i32.eq  	$push211=, $pop68, $pop210
	br_if   	0, $pop211      # 0: down to label25
# BB#25:                                # %if.end87
	i32.const	$push162=, 0
	i32.const	$push161=, 0
	i32.store	$push69=, should_optimize($pop162), $pop161
	i32.load	$0=, stdout($pop69)
	i32.store	$discard=, 64($19):p2align=4, $2
	i32.const	$push160=, .L.str.5
	i32.const	$15=, 64
	i32.add 	$15=, $19, $15
	block
	i32.call	$push70=, __fprintf_chk@FUNCTION, $0, $0, $pop160, $15
	i32.ne  	$push71=, $pop70, $1
	br_if   	0, $pop71       # 0: down to label26
# BB#26:                                # %if.end91
	block
	i32.const	$push163=, 0
	i32.load	$push72=, should_optimize($pop163)
	i32.const	$push212=, 0
	i32.eq  	$push213=, $pop72, $pop212
	br_if   	0, $pop213      # 0: down to label27
# BB#27:                                # %if.end94
	i32.const	$push167=, 0
	i32.const	$push166=, 0
	i32.store	$push73=, should_optimize($pop167), $pop166
	tee_local	$push165=, $0=, $pop73
	i32.load	$1=, stdout($pop165)
	i32.const	$push74=, .L.str.1
	i32.store	$2=, 48($19):p2align=4, $pop74
	i32.const	$push164=, .L.str.6
	i32.const	$16=, 48
	i32.add 	$16=, $19, $16
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop164, $16
	block
	i32.load	$push75=, should_optimize($0)
	i32.const	$push214=, 0
	i32.eq  	$push215=, $pop75, $pop214
	br_if   	0, $pop215      # 0: down to label28
# BB#28:                                # %if.end98
	i32.const	$push76=, 0
	i32.const	$push170=, 0
	i32.store	$push77=, should_optimize($pop76), $pop170
	tee_local	$push169=, $1=, $pop77
	i32.load	$0=, stdout($pop169)
	i32.store	$discard=, 32($19):p2align=4, $2
	i32.const	$push168=, .L.str.6
	i32.const	$17=, 32
	i32.add 	$17=, $19, $17
	block
	i32.call	$push78=, __fprintf_chk@FUNCTION, $0, $0, $pop168, $17
	i32.const	$push79=, 7
	i32.ne  	$push80=, $pop78, $pop79
	br_if   	0, $pop80       # 0: down to label29
# BB#29:                                # %if.end102
	block
	i32.load	$push81=, should_optimize($1)
	i32.const	$push216=, 0
	i32.eq  	$push217=, $pop81, $pop216
	br_if   	0, $pop217      # 0: down to label30
# BB#30:                                # %if.end105
	i32.const	$push82=, 0
	i32.const	$push173=, 0
	i32.store	$push83=, should_optimize($pop82), $pop173
	tee_local	$push172=, $0=, $pop83
	i32.load	$1=, stdout($pop172)
	i32.store	$discard=, 16($19):p2align=4, $0
	i32.const	$push171=, .L.str.7
	i32.const	$18=, 16
	i32.add 	$18=, $19, $18
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop171, $18
	block
	i32.load	$push84=, should_optimize($0)
	i32.const	$push218=, 0
	i32.eq  	$push219=, $pop84, $pop218
	br_if   	0, $pop219      # 0: down to label31
# BB#31:                                # %if.end109
	i32.store	$push85=, should_optimize($0), $0
	tee_local	$push175=, $0=, $pop85
	i32.load	$1=, stdout($pop175)
	i32.store	$discard=, 0($19):p2align=4, $0
	block
	i32.const	$push174=, .L.str.7
	i32.call	$push86=, __fprintf_chk@FUNCTION, $1, $0, $pop174, $19
	i32.const	$push87=, 2
	i32.ne  	$push88=, $pop86, $pop87
	br_if   	0, $pop88       # 0: down to label32
# BB#32:                                # %if.end113
	block
	i32.const	$push176=, 0
	i32.load	$push89=, should_optimize($pop176)
	i32.const	$push220=, 0
	i32.eq  	$push221=, $pop89, $pop220
	br_if   	0, $pop221      # 0: down to label33
# BB#33:                                # %if.end116
	i32.const	$push177=, 0
	i32.const	$5=, 224
	i32.add 	$19=, $19, $5
	i32.const	$5=, __stack_pointer
	i32.store	$19=, 0($5), $19
	return  	$pop177
.LBB1_34:                               # %if.then115
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then112
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then108
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then104
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then101
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then97
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then93
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_41:                               # %if.then90
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %if.then86
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_43:                               # %if.then82
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_44:                               # %if.then79
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_45:                               # %if.then75
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_46:                               # %if.then71
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_47:                               # %if.then68
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_48:                               # %if.then64
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_49:                               # %if.then60
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_50:                               # %if.then57
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_51:                               # %if.then53
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_52:                               # %if.then49
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_53:                               # %if.then46
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_54:                               # %if.then42
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_55:                               # %if.then38
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_56:                               # %if.then35
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_57:                               # %if.then31
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_58:                               # %if.then27
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_59:                               # %if.then24
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_60:                               # %if.then20
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_61:                               # %if.then16
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_62:                               # %if.then13
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_63:                               # %if.then9
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_64:                               # %if.then5
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_65:                               # %if.then2
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_66:                               # %if.then
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
