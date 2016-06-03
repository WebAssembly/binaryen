	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-22.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$3=, bar.lastc($pop0)
	block
	block
	i32.const	$push15=, 0
	i32.load	$push14=, bar.lastn($pop15)
	tee_local	$push13=, $2=, $pop14
	i32.eq  	$push1=, $pop13, $0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then
	i32.ne  	$push2=, $3, $2
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %if.end
	i32.const	$3=, 0
	i32.const	$push18=, 0
	i32.store	$drop=, bar.lastn($pop18), $0
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store	$drop=, bar.lastc($pop17), $pop16
.LBB0_3:                                # %if.end3
	end_block                       # label1:
	i32.const	$push3=, 3
	i32.shl 	$push4=, $0, $pop3
	i32.xor 	$push5=, $3, $pop4
	i32.const	$push6=, 24
	i32.shl 	$push7=, $pop5, $pop6
	i32.const	$push19=, 24
	i32.shr_s	$push8=, $pop7, $pop19
	i32.ne  	$push9=, $pop8, $1
	br_if   	0, $pop9        # 0: down to label0
# BB#4:                                 # %if.end8
	i32.const	$push12=, 0
	i32.const	$push10=, 1
	i32.add 	$push11=, $3, $pop10
	i32.store	$drop=, bar.lastc($pop12), $pop11
	return
.LBB0_5:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push551=, 0
	i32.const	$push548=, 0
	i32.load	$push549=, __stack_pointer($pop548)
	i32.const	$push550=, 352
	i32.sub 	$push621=, $pop549, $pop550
	i32.store	$6=, __stack_pointer($pop551), $pop621
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push43=, 21
	i32.ne  	$push44=, $0, $pop43
	br_if   	0, $pop44       # 0: down to label10
# BB#1:                                 # %if.end
	i32.store	$push626=, 4($6), $1
	tee_local	$push625=, $2=, $pop626
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop625, $pop45
	i32.store	$drop=, 4($6), $pop46
	i32.const	$push47=, 0
	i32.load	$0=, bar.lastc($pop47)
	i32.load8_s	$1=, 0($2)
	block
	i32.const	$push624=, 0
	i32.load	$push623=, bar.lastn($pop624)
	tee_local	$push622=, $7=, $pop623
	i32.const	$push48=, 1
	i32.eq  	$push49=, $pop622, $pop48
	br_if   	0, $pop49       # 0: down to label11
# BB#2:                                 # %if.then.i
	i32.ne  	$push50=, $0, $7
	br_if   	1, $pop50       # 1: down to label10
# BB#3:                                 # %if.end.i
	i32.const	$0=, 0
	i32.const	$push629=, 0
	i32.const	$push51=, 1
	i32.store	$drop=, bar.lastn($pop629), $pop51
	i32.const	$push628=, 0
	i32.const	$push627=, 0
	i32.store	$drop=, bar.lastc($pop628), $pop627
.LBB1_4:                                # %if.end3.i
	end_block                       # label11:
	i32.const	$push52=, 24
	i32.shl 	$push53=, $0, $pop52
	i32.const	$push631=, 24
	i32.shr_s	$push54=, $pop53, $pop631
	i32.const	$push630=, 8
	i32.xor 	$push55=, $pop54, $pop630
	i32.ne  	$push56=, $pop55, $1
	br_if   	0, $pop56       # 0: down to label10
# BB#5:                                 # %if.then.i314
	i32.const	$push633=, 0
	i32.const	$push57=, 1
	i32.add 	$push58=, $0, $pop57
	i32.store	$drop=, bar.lastc($pop633), $pop58
	i32.const	$push632=, 8
	i32.add 	$push3=, $2, $pop632
	i32.store	$1=, 4($6), $pop3
	br_if   	0, $0           # 0: down to label10
# BB#6:                                 # %if.end3.i321
	i32.const	$push59=, 4
	i32.add 	$push60=, $2, $pop59
	i32.load16_u	$0=, 0($pop60):p2align=0
	i32.const	$push636=, 0
	i32.const	$push61=, 2
	i32.store	$drop=, bar.lastn($pop636), $pop61
	i32.const	$push635=, 0
	i32.const	$push634=, 0
	i32.store	$drop=, bar.lastc($pop635), $pop634
	i32.const	$push62=, 255
	i32.and 	$push63=, $0, $pop62
	i32.const	$push64=, 16
	i32.ne  	$push65=, $pop63, $pop64
	br_if   	0, $pop65       # 0: down to label10
# BB#7:                                 # %if.end3.i321.1
	i32.const	$push637=, 0
	i32.const	$push66=, 1
	i32.store	$drop=, bar.lastc($pop637), $pop66
	i32.const	$push67=, 65280
	i32.and 	$push68=, $0, $pop67
	i32.const	$push69=, 4352
	i32.ne  	$push70=, $pop68, $pop69
	br_if   	0, $pop70       # 0: down to label10
# BB#8:                                 # %if.end3.i335
	i32.const	$push71=, 12
	i32.add 	$push72=, $2, $pop71
	i32.store	$drop=, 4($6), $pop72
	i32.load16_u	$push73=, 0($1):p2align=0
	i32.store16	$drop=, 344($6), $pop73
	i32.const	$push74=, 2
	i32.add 	$push75=, $1, $pop74
	i32.load8_u	$push76=, 0($pop75)
	i32.store8	$drop=, 346($6), $pop76
	i32.load8_u	$0=, 344($6)
	i32.const	$push639=, 0
	i32.const	$push638=, 0
	i32.store	$push0=, bar.lastc($pop639), $pop638
	i32.const	$push77=, 3
	i32.store	$drop=, bar.lastn($pop0), $pop77
	i32.const	$push78=, 24
	i32.ne  	$push79=, $0, $pop78
	br_if   	8, $pop79       # 8: down to label2
# BB#9:                                 # %if.end3.i335.1
	i32.const	$push640=, 0
	i32.const	$push80=, 1
	i32.store	$drop=, bar.lastc($pop640), $pop80
	i32.load8_u	$push82=, 345($6)
	i32.const	$push81=, 25
	i32.ne  	$push83=, $pop82, $pop81
	br_if   	8, $pop83       # 8: down to label2
# BB#10:                                # %if.end3.i335.2
	i32.const	$push641=, 0
	i32.const	$push84=, 2
	i32.store	$drop=, bar.lastc($pop641), $pop84
	i32.load8_u	$push86=, 346($6)
	i32.const	$push85=, 26
	i32.ne  	$push87=, $pop86, $pop85
	br_if   	8, $pop87       # 8: down to label2
# BB#11:                                # %if.end3.i349
	i32.const	$push88=, 16
	i32.add 	$push4=, $2, $pop88
	i32.store	$1=, 4($6), $pop4
	i32.const	$push89=, 12
	i32.add 	$push90=, $2, $pop89
	i32.load	$0=, 0($pop90):p2align=0
	i32.const	$push92=, 0
	i32.const	$push91=, 4
	i32.store	$drop=, bar.lastn($pop92), $pop91
	i32.const	$push643=, 0
	i32.const	$push642=, 0
	i32.store	$7=, bar.lastc($pop643), $pop642
	i32.const	$push93=, 255
	i32.and 	$push94=, $0, $pop93
	i32.const	$push95=, 32
	i32.ne  	$push96=, $pop94, $pop95
	br_if   	7, $pop96       # 7: down to label3
# BB#12:                                # %if.end3.i349.1
	i32.const	$push97=, 1
	i32.store	$drop=, bar.lastc($7), $pop97
	i32.const	$push98=, 65280
	i32.and 	$push99=, $0, $pop98
	i32.const	$push100=, 8448
	i32.ne  	$push101=, $pop99, $pop100
	br_if   	7, $pop101      # 7: down to label3
# BB#13:                                # %if.end3.i349.2
	i32.const	$push644=, 0
	i32.const	$push102=, 2
	i32.store	$drop=, bar.lastc($pop644), $pop102
	i32.const	$push103=, 16711680
	i32.and 	$push104=, $0, $pop103
	i32.const	$push105=, 2228224
	i32.ne  	$push106=, $pop104, $pop105
	br_if   	7, $pop106      # 7: down to label3
# BB#14:                                # %if.end3.i349.3
	i32.const	$push645=, 0
	i32.const	$push107=, 3
	i32.store	$drop=, bar.lastc($pop645), $pop107
	i32.const	$push108=, -16777216
	i32.and 	$push109=, $0, $pop108
	i32.const	$push110=, 587202560
	i32.ne  	$push111=, $pop109, $pop110
	br_if   	7, $pop111      # 7: down to label3
# BB#15:                                # %if.end3.i363
	i32.const	$push112=, 24
	i32.add 	$push5=, $2, $pop112
	i32.store	$7=, 4($6), $pop5
	i32.load	$push113=, 0($1):p2align=0
	i32.store	$drop=, 336($6), $pop113
	i32.const	$push114=, 4
	i32.add 	$push115=, $1, $pop114
	i32.load8_u	$push116=, 0($pop115)
	i32.store8	$drop=, 340($6), $pop116
	i32.load8_u	$0=, 336($6)
	i32.const	$push117=, 0
	i32.const	$push648=, 0
	i32.store	$push647=, bar.lastc($pop117), $pop648
	tee_local	$push646=, $1=, $pop647
	i32.const	$push118=, 5
	i32.store	$drop=, bar.lastn($pop646), $pop118
	i32.const	$push119=, 40
	i32.ne  	$push120=, $0, $pop119
	br_if   	6, $pop120      # 6: down to label4
# BB#16:                                # %if.end3.i363.1
	i32.const	$push121=, 1
	i32.store	$drop=, bar.lastc($1), $pop121
	i32.load8_u	$push123=, 337($6)
	i32.const	$push122=, 41
	i32.ne  	$push124=, $pop123, $pop122
	br_if   	6, $pop124      # 6: down to label4
# BB#17:                                # %if.end3.i363.2
	i32.const	$push649=, 0
	i32.const	$push125=, 2
	i32.store	$drop=, bar.lastc($pop649), $pop125
	i32.load8_u	$push127=, 338($6)
	i32.const	$push126=, 42
	i32.ne  	$push128=, $pop127, $pop126
	br_if   	6, $pop128      # 6: down to label4
# BB#18:                                # %if.end3.i363.3
	i32.const	$push650=, 0
	i32.const	$push129=, 3
	i32.store	$drop=, bar.lastc($pop650), $pop129
	i32.load8_u	$push131=, 339($6)
	i32.const	$push130=, 43
	i32.ne  	$push132=, $pop131, $pop130
	br_if   	6, $pop132      # 6: down to label4
# BB#19:                                # %if.end3.i363.4
	i32.const	$push651=, 0
	i32.const	$push133=, 4
	i32.store	$1=, bar.lastc($pop651), $pop133
	i32.load8_u	$push135=, 340($6)
	i32.const	$push134=, 44
	i32.ne  	$push136=, $pop135, $pop134
	br_if   	6, $pop136      # 6: down to label4
# BB#20:                                # %if.end3.i377
	i32.const	$push137=, 32
	i32.add 	$push6=, $2, $pop137
	i32.store	$0=, 4($6), $pop6
	i32.load	$push138=, 0($7):p2align=0
	i32.store	$drop=, 328($6), $pop138
	i32.add 	$push139=, $7, $1
	i32.load16_u	$push140=, 0($pop139):p2align=0
	i32.store16	$drop=, 332($6), $pop140
	i32.load8_u	$1=, 328($6)
	i32.const	$push653=, 0
	i32.const	$push652=, 0
	i32.store	$push1=, bar.lastc($pop653), $pop652
	i32.const	$push141=, 6
	i32.store	$drop=, bar.lastn($pop1), $pop141
	i32.const	$push142=, 48
	i32.ne  	$push143=, $1, $pop142
	br_if   	5, $pop143      # 5: down to label5
# BB#21:                                # %if.end3.i377.1
	i32.const	$push654=, 0
	i32.const	$push144=, 1
	i32.store	$drop=, bar.lastc($pop654), $pop144
	i32.load8_u	$push146=, 329($6)
	i32.const	$push145=, 49
	i32.ne  	$push147=, $pop146, $pop145
	br_if   	5, $pop147      # 5: down to label5
# BB#22:                                # %if.end3.i377.2
	i32.const	$push655=, 0
	i32.const	$push148=, 2
	i32.store	$drop=, bar.lastc($pop655), $pop148
	i32.load8_u	$push150=, 330($6)
	i32.const	$push149=, 50
	i32.ne  	$push151=, $pop150, $pop149
	br_if   	5, $pop151      # 5: down to label5
# BB#23:                                # %if.end3.i377.3
	i32.const	$push656=, 0
	i32.const	$push152=, 3
	i32.store	$drop=, bar.lastc($pop656), $pop152
	i32.load8_u	$push154=, 331($6)
	i32.const	$push153=, 51
	i32.ne  	$push155=, $pop154, $pop153
	br_if   	5, $pop155      # 5: down to label5
# BB#24:                                # %if.end3.i377.4
	i32.const	$push657=, 0
	i32.const	$push156=, 4
	i32.store	$drop=, bar.lastc($pop657), $pop156
	i32.load8_u	$push158=, 332($6)
	i32.const	$push157=, 52
	i32.ne  	$push159=, $pop158, $pop157
	br_if   	5, $pop159      # 5: down to label5
# BB#25:                                # %if.end3.i377.5
	i32.const	$push658=, 0
	i32.const	$push160=, 5
	i32.store	$drop=, bar.lastc($pop658), $pop160
	i32.load8_u	$push162=, 333($6)
	i32.const	$push161=, 53
	i32.ne  	$push163=, $pop162, $pop161
	br_if   	5, $pop163      # 5: down to label5
# BB#26:                                # %if.end3.i391
	i32.const	$push164=, 40
	i32.add 	$push165=, $2, $pop164
	i32.store	$drop=, 4($6), $pop165
	i32.load	$push166=, 0($0):p2align=0
	i32.store	$drop=, 320($6), $pop166
	i32.const	$push167=, 6
	i32.add 	$push168=, $0, $pop167
	i32.load8_u	$push169=, 0($pop168)
	i32.store8	$drop=, 326($6), $pop169
	i32.const	$push170=, 4
	i32.add 	$push171=, $0, $pop170
	i32.load16_u	$push172=, 0($pop171):p2align=0
	i32.store16	$drop=, 324($6), $pop172
	i32.load8_u	$0=, 320($6)
	i32.const	$push660=, 0
	i32.const	$push659=, 0
	i32.store	$push2=, bar.lastc($pop660), $pop659
	i32.const	$push173=, 7
	i32.store	$drop=, bar.lastn($pop2), $pop173
	i32.const	$push174=, 56
	i32.ne  	$push175=, $0, $pop174
	br_if   	4, $pop175      # 4: down to label6
# BB#27:                                # %if.end3.i391.1
	i32.const	$push661=, 0
	i32.const	$push176=, 1
	i32.store	$drop=, bar.lastc($pop661), $pop176
	i32.load8_u	$push178=, 321($6)
	i32.const	$push177=, 57
	i32.ne  	$push179=, $pop178, $pop177
	br_if   	4, $pop179      # 4: down to label6
# BB#28:                                # %if.end3.i391.2
	i32.const	$push662=, 0
	i32.const	$push180=, 2
	i32.store	$drop=, bar.lastc($pop662), $pop180
	i32.load8_u	$push182=, 322($6)
	i32.const	$push181=, 58
	i32.ne  	$push183=, $pop182, $pop181
	br_if   	4, $pop183      # 4: down to label6
# BB#29:                                # %if.end3.i391.3
	i32.const	$push663=, 0
	i32.const	$push184=, 3
	i32.store	$drop=, bar.lastc($pop663), $pop184
	i32.load8_u	$push186=, 323($6)
	i32.const	$push185=, 59
	i32.ne  	$push187=, $pop186, $pop185
	br_if   	4, $pop187      # 4: down to label6
# BB#30:                                # %if.end3.i391.4
	i32.const	$push664=, 0
	i32.const	$push188=, 4
	i32.store	$drop=, bar.lastc($pop664), $pop188
	i32.load8_u	$push190=, 324($6)
	i32.const	$push189=, 60
	i32.ne  	$push191=, $pop190, $pop189
	br_if   	4, $pop191      # 4: down to label6
# BB#31:                                # %if.end3.i391.5
	i32.const	$push665=, 0
	i32.const	$push192=, 5
	i32.store	$drop=, bar.lastc($pop665), $pop192
	i32.load8_u	$push194=, 325($6)
	i32.const	$push193=, 61
	i32.ne  	$push195=, $pop194, $pop193
	br_if   	4, $pop195      # 4: down to label6
# BB#32:                                # %if.end3.i391.6
	i32.const	$push666=, 0
	i32.const	$push196=, 6
	i32.store	$drop=, bar.lastc($pop666), $pop196
	i32.load8_u	$push198=, 326($6)
	i32.const	$push197=, 62
	i32.ne  	$push199=, $pop198, $pop197
	br_if   	4, $pop199      # 4: down to label6
# BB#33:                                # %if.end3.i405
	i32.const	$push201=, 0
	i32.const	$push200=, 7
	i32.store	$drop=, bar.lastc($pop201), $pop200
	i32.const	$push669=, 0
	i32.const	$push202=, 8
	i32.store	$drop=, bar.lastn($pop669), $pop202
	i32.const	$push203=, 48
	i32.add 	$push7=, $2, $pop203
	i32.store	$0=, 4($6), $pop7
	i32.const	$push204=, 40
	i32.add 	$push205=, $2, $pop204
	i64.load	$push206=, 0($pop205):p2align=0
	i64.store	$drop=, 312($6), $pop206
	i32.const	$push668=, 0
	i32.const	$push667=, 0
	i32.store	$1=, bar.lastc($pop668), $pop667
	i32.load8_s	$push208=, 312($6)
	i32.const	$push207=, 64
	i32.ne  	$push209=, $pop208, $pop207
	br_if   	3, $pop209      # 3: down to label7
# BB#34:                                # %if.end3.i405.1
	i32.const	$push36=, 1
	i32.store	$1=, bar.lastc($1), $pop36
	i32.load8_s	$push211=, 313($6)
	i32.const	$push210=, 65
	i32.ne  	$push212=, $pop211, $pop210
	br_if   	3, $pop212      # 3: down to label7
# BB#35:                                # %if.end3.i405.2
	i32.const	$push673=, 0
	i32.add 	$push37=, $1, $1
	i32.store	$push672=, bar.lastc($pop673), $pop37
	tee_local	$push671=, $1=, $pop672
	i32.const	$push670=, 64
	i32.or  	$push213=, $pop671, $pop670
	i32.load8_s	$push214=, 314($6)
	i32.ne  	$push215=, $pop213, $pop214
	br_if   	3, $pop215      # 3: down to label7
# BB#36:                                # %if.end3.i405.3
	i32.const	$push680=, 0
	i32.const	$push679=, 1
	i32.add 	$push38=, $1, $pop679
	i32.store	$push678=, bar.lastc($pop680), $pop38
	tee_local	$push677=, $1=, $pop678
	i32.const	$push676=, 24
	i32.shl 	$push216=, $pop677, $pop676
	i32.const	$push675=, 24
	i32.shr_s	$push217=, $pop216, $pop675
	i32.const	$push674=, 64
	i32.xor 	$push218=, $pop217, $pop674
	i32.load8_s	$push219=, 315($6)
	i32.ne  	$push220=, $pop218, $pop219
	br_if   	3, $pop220      # 3: down to label7
# BB#37:                                # %if.end3.i405.4
	i32.const	$push687=, 0
	i32.const	$push686=, 1
	i32.add 	$push39=, $1, $pop686
	i32.store	$push685=, bar.lastc($pop687), $pop39
	tee_local	$push684=, $1=, $pop685
	i32.const	$push683=, 24
	i32.shl 	$push221=, $pop684, $pop683
	i32.const	$push682=, 24
	i32.shr_s	$push222=, $pop221, $pop682
	i32.const	$push681=, 64
	i32.xor 	$push223=, $pop222, $pop681
	i32.load8_s	$push224=, 316($6)
	i32.ne  	$push225=, $pop223, $pop224
	br_if   	3, $pop225      # 3: down to label7
# BB#38:                                # %if.end3.i405.5
	i32.const	$push694=, 0
	i32.const	$push693=, 1
	i32.add 	$push40=, $1, $pop693
	i32.store	$push692=, bar.lastc($pop694), $pop40
	tee_local	$push691=, $1=, $pop692
	i32.const	$push690=, 24
	i32.shl 	$push226=, $pop691, $pop690
	i32.const	$push689=, 24
	i32.shr_s	$push227=, $pop226, $pop689
	i32.const	$push688=, 64
	i32.xor 	$push228=, $pop227, $pop688
	i32.load8_s	$push229=, 317($6)
	i32.ne  	$push230=, $pop228, $pop229
	br_if   	3, $pop230      # 3: down to label7
# BB#39:                                # %if.end3.i405.6
	i32.const	$push701=, 0
	i32.const	$push700=, 1
	i32.add 	$push41=, $1, $pop700
	i32.store	$push699=, bar.lastc($pop701), $pop41
	tee_local	$push698=, $1=, $pop699
	i32.const	$push697=, 24
	i32.shl 	$push231=, $pop698, $pop697
	i32.const	$push696=, 24
	i32.shr_s	$push232=, $pop231, $pop696
	i32.const	$push695=, 64
	i32.xor 	$push233=, $pop232, $pop695
	i32.load8_s	$push234=, 318($6)
	i32.ne  	$push235=, $pop233, $pop234
	br_if   	3, $pop235      # 3: down to label7
# BB#40:                                # %if.end3.i405.7
	i32.const	$push707=, 0
	i32.const	$push706=, 1
	i32.add 	$push42=, $1, $pop706
	i32.store	$push705=, bar.lastc($pop707), $pop42
	tee_local	$push704=, $1=, $pop705
	i32.const	$push236=, 24
	i32.shl 	$push237=, $pop704, $pop236
	i32.const	$push703=, 24
	i32.shr_s	$push238=, $pop237, $pop703
	i32.const	$push702=, 64
	i32.xor 	$push239=, $pop238, $pop702
	i32.load8_s	$push240=, 319($6)
	i32.ne  	$push241=, $pop239, $pop240
	br_if   	3, $pop241      # 3: down to label7
# BB#41:                                # %for.body104
	i32.const	$push242=, 0
	i32.const	$push713=, 1
	i32.add 	$push712=, $1, $pop713
	tee_local	$push711=, $7=, $pop712
	i32.store	$8=, bar.lastc($pop242), $pop711
	i32.const	$1=, 8
	i32.const	$push555=, 296
	i32.add 	$push556=, $6, $pop555
	i32.const	$push710=, 8
	i32.add 	$push245=, $pop556, $pop710
	i32.const	$push709=, 8
	i32.add 	$push243=, $0, $pop709
	i32.load8_u	$push244=, 0($pop243)
	i32.store8	$drop=, 0($pop245), $pop244
	i32.const	$push246=, 60
	i32.add 	$push8=, $2, $pop246
	i32.store	$9=, 4($6), $pop8
	i32.load	$push247=, 0($0):p2align=0
	i32.store	$drop=, 296($6), $pop247
	i32.const	$push248=, 4
	i32.add 	$push249=, $0, $pop248
	i32.load	$push250=, 0($pop249):p2align=0
	i32.store	$drop=, 300($6), $pop250
	i32.load8_s	$0=, 296($6)
	block
	i32.const	$push708=, 0
	br_if   	0, $pop708      # 0: down to label12
# BB#42:                                # %if.then.i412
	i32.const	$push251=, 8
	i32.ne  	$push252=, $8, $pop251
	br_if   	1, $pop252      # 1: down to label10
# BB#43:                                # %if.end.i414
	i32.const	$1=, 9
	i32.const	$7=, 0
	i32.const	$push717=, 0
	i32.const	$push716=, 9
	i32.store	$drop=, bar.lastn($pop717), $pop716
	i32.const	$push715=, 0
	i32.const	$push714=, 0
	i32.store	$drop=, bar.lastc($pop715), $pop714
.LBB1_44:                               # %if.end3.i419
	end_block                       # label12:
	i32.const	$push720=, 24
	i32.shl 	$push253=, $7, $pop720
	i32.const	$push719=, 24
	i32.shr_s	$push254=, $pop253, $pop719
	i32.const	$push718=, 72
	i32.xor 	$push255=, $pop254, $pop718
	i32.ne  	$push256=, $pop255, $0
	br_if   	2, $pop256      # 2: down to label8
# BB#45:                                # %if.end3.i419.1
	i32.const	$push727=, 0
	i32.const	$push726=, 1
	i32.add 	$push28=, $7, $pop726
	i32.store	$push725=, bar.lastc($pop727), $pop28
	tee_local	$push724=, $0=, $pop725
	i32.const	$push723=, 24
	i32.shl 	$push257=, $pop724, $pop723
	i32.const	$push722=, 24
	i32.shr_s	$push258=, $pop257, $pop722
	i32.const	$push721=, 72
	i32.xor 	$push259=, $pop258, $pop721
	i32.load8_s	$push260=, 297($6)
	i32.ne  	$push261=, $pop259, $pop260
	br_if   	2, $pop261      # 2: down to label8
# BB#46:                                # %if.end3.i419.2
	i32.const	$push734=, 0
	i32.const	$push733=, 1
	i32.add 	$push29=, $0, $pop733
	i32.store	$push732=, bar.lastc($pop734), $pop29
	tee_local	$push731=, $0=, $pop732
	i32.const	$push730=, 24
	i32.shl 	$push262=, $pop731, $pop730
	i32.const	$push729=, 24
	i32.shr_s	$push263=, $pop262, $pop729
	i32.const	$push728=, 72
	i32.xor 	$push264=, $pop263, $pop728
	i32.load8_s	$push265=, 298($6)
	i32.ne  	$push266=, $pop264, $pop265
	br_if   	2, $pop266      # 2: down to label8
# BB#47:                                # %if.end3.i419.3
	i32.const	$push741=, 0
	i32.const	$push740=, 1
	i32.add 	$push30=, $0, $pop740
	i32.store	$push739=, bar.lastc($pop741), $pop30
	tee_local	$push738=, $0=, $pop739
	i32.const	$push737=, 24
	i32.shl 	$push267=, $pop738, $pop737
	i32.const	$push736=, 24
	i32.shr_s	$push268=, $pop267, $pop736
	i32.const	$push735=, 72
	i32.xor 	$push269=, $pop268, $pop735
	i32.load8_s	$push270=, 299($6)
	i32.ne  	$push271=, $pop269, $pop270
	br_if   	2, $pop271      # 2: down to label8
# BB#48:                                # %if.end3.i419.4
	i32.const	$push748=, 0
	i32.const	$push747=, 1
	i32.add 	$push31=, $0, $pop747
	i32.store	$push746=, bar.lastc($pop748), $pop31
	tee_local	$push745=, $0=, $pop746
	i32.const	$push744=, 24
	i32.shl 	$push272=, $pop745, $pop744
	i32.const	$push743=, 24
	i32.shr_s	$push273=, $pop272, $pop743
	i32.const	$push742=, 72
	i32.xor 	$push274=, $pop273, $pop742
	i32.load8_s	$push275=, 300($6)
	i32.ne  	$push276=, $pop274, $pop275
	br_if   	2, $pop276      # 2: down to label8
# BB#49:                                # %if.end3.i419.5
	i32.const	$push755=, 0
	i32.const	$push754=, 1
	i32.add 	$push32=, $0, $pop754
	i32.store	$push753=, bar.lastc($pop755), $pop32
	tee_local	$push752=, $0=, $pop753
	i32.const	$push751=, 24
	i32.shl 	$push277=, $pop752, $pop751
	i32.const	$push750=, 24
	i32.shr_s	$push278=, $pop277, $pop750
	i32.const	$push749=, 72
	i32.xor 	$push279=, $pop278, $pop749
	i32.load8_s	$push280=, 301($6)
	i32.ne  	$push281=, $pop279, $pop280
	br_if   	2, $pop281      # 2: down to label8
# BB#50:                                # %if.end3.i419.6
	i32.const	$push762=, 0
	i32.const	$push761=, 1
	i32.add 	$push33=, $0, $pop761
	i32.store	$push760=, bar.lastc($pop762), $pop33
	tee_local	$push759=, $0=, $pop760
	i32.const	$push758=, 24
	i32.shl 	$push282=, $pop759, $pop758
	i32.const	$push757=, 24
	i32.shr_s	$push283=, $pop282, $pop757
	i32.const	$push756=, 72
	i32.xor 	$push284=, $pop283, $pop756
	i32.load8_s	$push285=, 302($6)
	i32.ne  	$push286=, $pop284, $pop285
	br_if   	2, $pop286      # 2: down to label8
# BB#51:                                # %if.end3.i419.7
	i32.const	$push769=, 0
	i32.const	$push768=, 1
	i32.add 	$push34=, $0, $pop768
	i32.store	$push767=, bar.lastc($pop769), $pop34
	tee_local	$push766=, $0=, $pop767
	i32.const	$push765=, 24
	i32.shl 	$push287=, $pop766, $pop765
	i32.const	$push764=, 24
	i32.shr_s	$push288=, $pop287, $pop764
	i32.const	$push763=, 72
	i32.xor 	$push289=, $pop288, $pop763
	i32.load8_s	$push290=, 303($6)
	i32.ne  	$push291=, $pop289, $pop290
	br_if   	2, $pop291      # 2: down to label8
# BB#52:                                # %if.end3.i419.8
	i32.const	$push775=, 0
	i32.const	$push774=, 1
	i32.add 	$push35=, $0, $pop774
	i32.store	$push773=, bar.lastc($pop775), $pop35
	tee_local	$push772=, $0=, $pop773
	i32.const	$push292=, 24
	i32.shl 	$push293=, $pop772, $pop292
	i32.const	$push771=, 24
	i32.shr_s	$push294=, $pop293, $pop771
	i32.const	$push770=, 72
	i32.xor 	$push295=, $pop294, $pop770
	i32.load8_s	$push296=, 304($6)
	i32.ne  	$push297=, $pop295, $pop296
	br_if   	2, $pop297      # 2: down to label8
# BB#53:                                # %for.body116
	i32.const	$push299=, 0
	i32.const	$push298=, 1
	i32.add 	$push779=, $0, $pop298
	tee_local	$push778=, $0=, $pop779
	i32.store	$8=, bar.lastc($pop299), $pop778
	i32.const	$push557=, 280
	i32.add 	$push558=, $6, $pop557
	i32.const	$push300=, 8
	i32.add 	$push303=, $pop558, $pop300
	i32.const	$push777=, 8
	i32.add 	$push301=, $9, $pop777
	i32.load16_u	$push302=, 0($pop301):p2align=0
	i32.store16	$drop=, 0($pop303), $pop302
	i32.const	$push776=, 72
	i32.add 	$push9=, $2, $pop776
	i32.store	$7=, 4($6), $pop9
	i32.load	$push304=, 0($9):p2align=0
	i32.store	$drop=, 280($6), $pop304
	i32.const	$push305=, 4
	i32.add 	$push306=, $9, $pop305
	i32.load	$push307=, 0($pop306):p2align=0
	i32.store	$drop=, 284($6), $pop307
	i32.load8_s	$9=, 280($6)
	block
	i32.const	$push308=, 10
	i32.eq  	$push309=, $1, $pop308
	br_if   	0, $pop309      # 0: down to label13
# BB#54:                                # %if.then.i426
	i32.ne  	$push310=, $8, $1
	br_if   	1, $pop310      # 1: down to label10
# BB#55:                                # %if.end.i428
	i32.const	$1=, 10
	i32.const	$0=, 0
	i32.const	$push783=, 0
	i32.const	$push782=, 10
	i32.store	$drop=, bar.lastn($pop783), $pop782
	i32.const	$push781=, 0
	i32.const	$push780=, 0
	i32.store	$drop=, bar.lastc($pop781), $pop780
.LBB1_56:                               # %if.end3.i433
	end_block                       # label13:
	i32.const	$push786=, 24
	i32.shl 	$push311=, $0, $pop786
	i32.const	$push785=, 24
	i32.shr_s	$push312=, $pop311, $pop785
	i32.const	$push784=, 80
	i32.xor 	$push313=, $pop312, $pop784
	i32.ne  	$push314=, $pop313, $9
	br_if   	1, $pop314      # 1: down to label9
# BB#57:                                # %if.end3.i433.1
	i32.const	$push793=, 0
	i32.const	$push792=, 1
	i32.add 	$push18=, $0, $pop792
	i32.store	$push791=, bar.lastc($pop793), $pop18
	tee_local	$push790=, $0=, $pop791
	i32.const	$push789=, 24
	i32.shl 	$push315=, $pop790, $pop789
	i32.const	$push788=, 24
	i32.shr_s	$push316=, $pop315, $pop788
	i32.const	$push787=, 80
	i32.xor 	$push317=, $pop316, $pop787
	i32.load8_s	$push318=, 281($6)
	i32.ne  	$push319=, $pop317, $pop318
	br_if   	1, $pop319      # 1: down to label9
# BB#58:                                # %if.end3.i433.2
	i32.const	$push800=, 0
	i32.const	$push799=, 1
	i32.add 	$push19=, $0, $pop799
	i32.store	$push798=, bar.lastc($pop800), $pop19
	tee_local	$push797=, $0=, $pop798
	i32.const	$push796=, 24
	i32.shl 	$push320=, $pop797, $pop796
	i32.const	$push795=, 24
	i32.shr_s	$push321=, $pop320, $pop795
	i32.const	$push794=, 80
	i32.xor 	$push322=, $pop321, $pop794
	i32.load8_s	$push323=, 282($6)
	i32.ne  	$push324=, $pop322, $pop323
	br_if   	1, $pop324      # 1: down to label9
# BB#59:                                # %if.end3.i433.3
	i32.const	$push807=, 0
	i32.const	$push806=, 1
	i32.add 	$push20=, $0, $pop806
	i32.store	$push805=, bar.lastc($pop807), $pop20
	tee_local	$push804=, $0=, $pop805
	i32.const	$push803=, 24
	i32.shl 	$push325=, $pop804, $pop803
	i32.const	$push802=, 24
	i32.shr_s	$push326=, $pop325, $pop802
	i32.const	$push801=, 80
	i32.xor 	$push327=, $pop326, $pop801
	i32.load8_s	$push328=, 283($6)
	i32.ne  	$push329=, $pop327, $pop328
	br_if   	1, $pop329      # 1: down to label9
# BB#60:                                # %if.end3.i433.4
	i32.const	$push814=, 0
	i32.const	$push813=, 1
	i32.add 	$push21=, $0, $pop813
	i32.store	$push812=, bar.lastc($pop814), $pop21
	tee_local	$push811=, $0=, $pop812
	i32.const	$push810=, 24
	i32.shl 	$push330=, $pop811, $pop810
	i32.const	$push809=, 24
	i32.shr_s	$push331=, $pop330, $pop809
	i32.const	$push808=, 80
	i32.xor 	$push332=, $pop331, $pop808
	i32.load8_s	$push333=, 284($6)
	i32.ne  	$push334=, $pop332, $pop333
	br_if   	1, $pop334      # 1: down to label9
# BB#61:                                # %if.end3.i433.5
	i32.const	$push821=, 0
	i32.const	$push820=, 1
	i32.add 	$push22=, $0, $pop820
	i32.store	$push819=, bar.lastc($pop821), $pop22
	tee_local	$push818=, $0=, $pop819
	i32.const	$push817=, 24
	i32.shl 	$push335=, $pop818, $pop817
	i32.const	$push816=, 24
	i32.shr_s	$push336=, $pop335, $pop816
	i32.const	$push815=, 80
	i32.xor 	$push337=, $pop336, $pop815
	i32.load8_s	$push338=, 285($6)
	i32.ne  	$push339=, $pop337, $pop338
	br_if   	1, $pop339      # 1: down to label9
# BB#62:                                # %if.end3.i433.6
	i32.const	$push828=, 0
	i32.const	$push827=, 1
	i32.add 	$push23=, $0, $pop827
	i32.store	$push826=, bar.lastc($pop828), $pop23
	tee_local	$push825=, $0=, $pop826
	i32.const	$push824=, 24
	i32.shl 	$push340=, $pop825, $pop824
	i32.const	$push823=, 24
	i32.shr_s	$push341=, $pop340, $pop823
	i32.const	$push822=, 80
	i32.xor 	$push342=, $pop341, $pop822
	i32.load8_s	$push343=, 286($6)
	i32.ne  	$push344=, $pop342, $pop343
	br_if   	1, $pop344      # 1: down to label9
# BB#63:                                # %if.end3.i433.7
	i32.const	$push835=, 0
	i32.const	$push834=, 1
	i32.add 	$push24=, $0, $pop834
	i32.store	$push833=, bar.lastc($pop835), $pop24
	tee_local	$push832=, $0=, $pop833
	i32.const	$push831=, 24
	i32.shl 	$push345=, $pop832, $pop831
	i32.const	$push830=, 24
	i32.shr_s	$push346=, $pop345, $pop830
	i32.const	$push829=, 80
	i32.xor 	$push347=, $pop346, $pop829
	i32.load8_s	$push348=, 287($6)
	i32.ne  	$push349=, $pop347, $pop348
	br_if   	1, $pop349      # 1: down to label9
# BB#64:                                # %if.end3.i433.8
	i32.const	$push842=, 0
	i32.const	$push841=, 1
	i32.add 	$push25=, $0, $pop841
	i32.store	$push840=, bar.lastc($pop842), $pop25
	tee_local	$push839=, $0=, $pop840
	i32.const	$push838=, 24
	i32.shl 	$push350=, $pop839, $pop838
	i32.const	$push837=, 24
	i32.shr_s	$push351=, $pop350, $pop837
	i32.const	$push836=, 80
	i32.xor 	$push352=, $pop351, $pop836
	i32.load8_s	$push353=, 288($6)
	i32.ne  	$push354=, $pop352, $pop353
	br_if   	1, $pop354      # 1: down to label9
# BB#65:                                # %if.end3.i433.9
	i32.const	$push849=, 0
	i32.const	$push848=, 1
	i32.add 	$push26=, $0, $pop848
	i32.store	$push847=, bar.lastc($pop849), $pop26
	tee_local	$push846=, $0=, $pop847
	i32.const	$push845=, 24
	i32.shl 	$push355=, $pop846, $pop845
	i32.const	$push844=, 24
	i32.shr_s	$push356=, $pop355, $pop844
	i32.const	$push843=, 80
	i32.xor 	$push357=, $pop356, $pop843
	i32.load8_s	$push358=, 289($6)
	i32.ne  	$push359=, $pop357, $pop358
	br_if   	1, $pop359      # 1: down to label9
# BB#66:                                # %bar.exit436.9
	i32.const	$push855=, 0
	i32.const	$push854=, 1
	i32.add 	$push853=, $0, $pop854
	tee_local	$push852=, $0=, $pop853
	i32.store	$drop=, bar.lastc($pop855), $pop852
	i32.const	$push559=, 264
	i32.add 	$push560=, $6, $pop559
	i32.const	$push360=, 10
	i32.add 	$push363=, $pop560, $pop360
	i32.const	$push851=, 10
	i32.add 	$push361=, $7, $pop851
	i32.load8_u	$push362=, 0($pop361)
	i32.store8	$drop=, 0($pop363), $pop362
	i32.const	$push561=, 264
	i32.add 	$push562=, $6, $pop561
	i32.const	$push364=, 8
	i32.add 	$push367=, $pop562, $pop364
	i32.const	$push850=, 8
	i32.add 	$push365=, $7, $pop850
	i32.load16_u	$push366=, 0($pop365):p2align=0
	i32.store16	$drop=, 0($pop367), $pop366
	i32.const	$push368=, 84
	i32.add 	$push27=, $2, $pop368
	i32.store	$3=, 4($6), $pop27
	i32.const	$push369=, 4
	i32.add 	$push370=, $7, $pop369
	i32.load	$push371=, 0($pop370):p2align=0
	i32.store	$drop=, 268($6), $pop371
	i32.load	$push372=, 0($7):p2align=0
	i32.store	$drop=, 264($6), $pop372
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_67:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.const	$push563=, 264
	i32.add 	$push564=, $6, $pop563
	i32.add 	$push374=, $pop564, $7
	i32.load8_s	$8=, 0($pop374)
	block
	i32.const	$push856=, 11
	i32.eq  	$push373=, $9, $pop856
	br_if   	0, $pop373      # 0: down to label16
# BB#68:                                # %if.then.i440
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.ne  	$push375=, $0, $9
	br_if   	3, $pop375      # 3: down to label10
# BB#69:                                # %if.end.i442
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$1=, 11
	i32.const	$0=, 0
	i32.const	$push860=, 0
	i32.const	$push859=, 11
	i32.store	$drop=, bar.lastn($pop860), $pop859
	i32.const	$push858=, 0
	i32.const	$push857=, 0
	i32.store	$drop=, bar.lastc($pop858), $pop857
.LBB1_70:                               # %if.end3.i447
                                        #   in Loop: Header=BB1_67 Depth=1
	end_block                       # label16:
	i32.const	$push863=, 24
	i32.shl 	$push376=, $0, $pop863
	i32.const	$push862=, 24
	i32.shr_s	$push377=, $pop376, $pop862
	i32.const	$push861=, 88
	i32.xor 	$push378=, $pop377, $pop861
	i32.ne  	$push379=, $pop378, $8
	br_if   	2, $pop379      # 2: down to label10
# BB#71:                                # %bar.exit450
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$push871=, 0
	i32.const	$push870=, 1
	i32.add 	$push869=, $0, $pop870
	tee_local	$push868=, $0=, $pop869
	i32.store	$drop=, bar.lastc($pop871), $pop868
	i32.const	$9=, 11
	i32.const	$push867=, 1
	i32.add 	$push866=, $7, $pop867
	tee_local	$push865=, $7=, $pop866
	i32.const	$push864=, 11
	i32.lt_s	$push380=, $pop865, $pop864
	br_if   	0, $pop380      # 0: up to label14
# BB#72:                                # %for.end134
	end_loop                        # label15:
	i32.const	$push565=, 248
	i32.add 	$push566=, $6, $pop565
	i32.const	$push381=, 8
	i32.add 	$push384=, $pop566, $pop381
	i32.const	$push873=, 8
	i32.add 	$push382=, $3, $pop873
	i32.load	$push383=, 0($pop382):p2align=0
	i32.store	$drop=, 0($pop384), $pop383
	i32.const	$push872=, 96
	i32.add 	$push10=, $2, $pop872
	i32.store	$5=, 4($6), $pop10
	i32.const	$push385=, 4
	i32.add 	$push386=, $3, $pop385
	i32.load	$push387=, 0($pop386):p2align=0
	i32.store	$drop=, 252($6), $pop387
	i32.load	$push388=, 0($3):p2align=0
	i32.store	$drop=, 248($6), $pop388
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_73:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label17:
	i32.const	$push567=, 248
	i32.add 	$push568=, $6, $pop567
	i32.add 	$push390=, $pop568, $7
	i32.load8_s	$8=, 0($pop390)
	block
	i32.const	$push874=, 12
	i32.eq  	$push389=, $9, $pop874
	br_if   	0, $pop389      # 0: down to label19
# BB#74:                                # %if.then.i454
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.ne  	$push391=, $0, $9
	br_if   	3, $pop391      # 3: down to label10
# BB#75:                                # %if.end.i456
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$1=, 12
	i32.const	$0=, 0
	i32.const	$push878=, 0
	i32.const	$push877=, 12
	i32.store	$drop=, bar.lastn($pop878), $pop877
	i32.const	$push876=, 0
	i32.const	$push875=, 0
	i32.store	$drop=, bar.lastc($pop876), $pop875
.LBB1_76:                               # %if.end3.i461
                                        #   in Loop: Header=BB1_73 Depth=1
	end_block                       # label19:
	i32.const	$push881=, 24
	i32.shl 	$push392=, $0, $pop881
	i32.const	$push880=, 24
	i32.shr_s	$push393=, $pop392, $pop880
	i32.const	$push879=, 96
	i32.xor 	$push394=, $pop393, $pop879
	i32.ne  	$push395=, $pop394, $8
	br_if   	2, $pop395      # 2: down to label10
# BB#77:                                # %bar.exit464
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$push889=, 0
	i32.const	$push888=, 1
	i32.add 	$push887=, $0, $pop888
	tee_local	$push886=, $0=, $pop887
	i32.store	$drop=, bar.lastc($pop889), $pop886
	i32.const	$9=, 12
	i32.const	$push885=, 1
	i32.add 	$push884=, $7, $pop885
	tee_local	$push883=, $7=, $pop884
	i32.const	$push882=, 12
	i32.lt_s	$push396=, $pop883, $pop882
	br_if   	0, $pop396      # 0: up to label17
# BB#78:                                # %for.end146
	end_loop                        # label18:
	i32.const	$push569=, 232
	i32.add 	$push570=, $6, $pop569
	i32.const	$push397=, 12
	i32.add 	$push400=, $pop570, $pop397
	i32.const	$push891=, 12
	i32.add 	$push398=, $5, $pop891
	i32.load8_u	$push399=, 0($pop398)
	i32.store8	$drop=, 0($pop400), $pop399
	i32.const	$push571=, 232
	i32.add 	$push572=, $6, $pop571
	i32.const	$push401=, 8
	i32.add 	$push404=, $pop572, $pop401
	i32.const	$push890=, 8
	i32.add 	$push402=, $5, $pop890
	i32.load	$push403=, 0($pop402):p2align=0
	i32.store	$drop=, 0($pop404), $pop403
	i32.const	$push405=, 112
	i32.add 	$push11=, $2, $pop405
	i32.store	$3=, 4($6), $pop11
	i32.const	$push406=, 4
	i32.add 	$push407=, $5, $pop406
	i32.load	$push408=, 0($pop407):p2align=0
	i32.store	$drop=, 236($6), $pop408
	i32.load	$push409=, 0($5):p2align=0
	i32.store	$drop=, 232($6), $pop409
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_79:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label20:
	i32.const	$push573=, 232
	i32.add 	$push574=, $6, $pop573
	i32.add 	$push411=, $pop574, $7
	i32.load8_s	$8=, 0($pop411)
	block
	i32.const	$push892=, 13
	i32.eq  	$push410=, $9, $pop892
	br_if   	0, $pop410      # 0: down to label22
# BB#80:                                # %if.then.i468
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.ne  	$push412=, $0, $9
	br_if   	3, $pop412      # 3: down to label10
# BB#81:                                # %if.end.i470
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$1=, 13
	i32.const	$0=, 0
	i32.const	$push896=, 0
	i32.const	$push895=, 13
	i32.store	$drop=, bar.lastn($pop896), $pop895
	i32.const	$push894=, 0
	i32.const	$push893=, 0
	i32.store	$drop=, bar.lastc($pop894), $pop893
.LBB1_82:                               # %if.end3.i475
                                        #   in Loop: Header=BB1_79 Depth=1
	end_block                       # label22:
	i32.const	$push899=, 24
	i32.shl 	$push413=, $0, $pop899
	i32.const	$push898=, 24
	i32.shr_s	$push414=, $pop413, $pop898
	i32.const	$push897=, 104
	i32.xor 	$push415=, $pop414, $pop897
	i32.ne  	$push416=, $pop415, $8
	br_if   	2, $pop416      # 2: down to label10
# BB#83:                                # %bar.exit478
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$push907=, 0
	i32.const	$push906=, 1
	i32.add 	$push905=, $0, $pop906
	tee_local	$push904=, $0=, $pop905
	i32.store	$drop=, bar.lastc($pop907), $pop904
	i32.const	$9=, 13
	i32.const	$push903=, 1
	i32.add 	$push902=, $7, $pop903
	tee_local	$push901=, $7=, $pop902
	i32.const	$push900=, 13
	i32.lt_s	$push417=, $pop901, $pop900
	br_if   	0, $pop417      # 0: up to label20
# BB#84:                                # %for.end158
	end_loop                        # label21:
	i32.const	$push575=, 216
	i32.add 	$push576=, $6, $pop575
	i32.const	$push418=, 12
	i32.add 	$push421=, $pop576, $pop418
	i32.const	$push909=, 12
	i32.add 	$push419=, $3, $pop909
	i32.load16_u	$push420=, 0($pop419):p2align=0
	i32.store16	$drop=, 0($pop421), $pop420
	i32.const	$push577=, 216
	i32.add 	$push578=, $6, $pop577
	i32.const	$push422=, 8
	i32.add 	$push425=, $pop578, $pop422
	i32.const	$push908=, 8
	i32.add 	$push423=, $3, $pop908
	i32.load	$push424=, 0($pop423):p2align=0
	i32.store	$drop=, 0($pop425), $pop424
	i32.const	$push426=, 128
	i32.add 	$push12=, $2, $pop426
	i32.store	$5=, 4($6), $pop12
	i32.const	$push427=, 4
	i32.add 	$push428=, $3, $pop427
	i32.load	$push429=, 0($pop428):p2align=0
	i32.store	$drop=, 220($6), $pop429
	i32.load	$push430=, 0($3):p2align=0
	i32.store	$drop=, 216($6), $pop430
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_85:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label23:
	i32.const	$push579=, 216
	i32.add 	$push580=, $6, $pop579
	i32.add 	$push432=, $pop580, $7
	i32.load8_s	$8=, 0($pop432)
	block
	i32.const	$push910=, 14
	i32.eq  	$push431=, $9, $pop910
	br_if   	0, $pop431      # 0: down to label25
# BB#86:                                # %if.then.i482
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.ne  	$push433=, $0, $9
	br_if   	3, $pop433      # 3: down to label10
# BB#87:                                # %if.end.i484
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$1=, 14
	i32.const	$0=, 0
	i32.const	$push914=, 0
	i32.const	$push913=, 14
	i32.store	$drop=, bar.lastn($pop914), $pop913
	i32.const	$push912=, 0
	i32.const	$push911=, 0
	i32.store	$drop=, bar.lastc($pop912), $pop911
.LBB1_88:                               # %if.end3.i489
                                        #   in Loop: Header=BB1_85 Depth=1
	end_block                       # label25:
	i32.const	$push917=, 24
	i32.shl 	$push434=, $0, $pop917
	i32.const	$push916=, 24
	i32.shr_s	$push435=, $pop434, $pop916
	i32.const	$push915=, 112
	i32.xor 	$push436=, $pop435, $pop915
	i32.ne  	$push437=, $pop436, $8
	br_if   	2, $pop437      # 2: down to label10
# BB#89:                                # %bar.exit492
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$push925=, 0
	i32.const	$push924=, 1
	i32.add 	$push923=, $0, $pop924
	tee_local	$push922=, $0=, $pop923
	i32.store	$drop=, bar.lastc($pop925), $pop922
	i32.const	$9=, 14
	i32.const	$push921=, 1
	i32.add 	$push920=, $7, $pop921
	tee_local	$push919=, $7=, $pop920
	i32.const	$push918=, 14
	i32.lt_s	$push438=, $pop919, $pop918
	br_if   	0, $pop438      # 0: up to label23
# BB#90:                                # %for.end170
	end_loop                        # label24:
	i32.const	$push581=, 200
	i32.add 	$push582=, $6, $pop581
	i32.const	$push439=, 14
	i32.add 	$push442=, $pop582, $pop439
	i32.const	$push928=, 14
	i32.add 	$push440=, $5, $pop928
	i32.load8_u	$push441=, 0($pop440)
	i32.store8	$drop=, 0($pop442), $pop441
	i32.const	$push583=, 200
	i32.add 	$push584=, $6, $pop583
	i32.const	$push443=, 12
	i32.add 	$push446=, $pop584, $pop443
	i32.const	$push927=, 12
	i32.add 	$push444=, $5, $pop927
	i32.load16_u	$push445=, 0($pop444):p2align=0
	i32.store16	$drop=, 0($pop446), $pop445
	i32.const	$push585=, 200
	i32.add 	$push586=, $6, $pop585
	i32.const	$push447=, 8
	i32.add 	$push450=, $pop586, $pop447
	i32.const	$push926=, 8
	i32.add 	$push448=, $5, $pop926
	i32.load	$push449=, 0($pop448):p2align=0
	i32.store	$drop=, 0($pop450), $pop449
	i32.const	$push451=, 144
	i32.add 	$push13=, $2, $pop451
	i32.store	$3=, 4($6), $pop13
	i32.const	$push452=, 4
	i32.add 	$push453=, $5, $pop452
	i32.load	$push454=, 0($pop453):p2align=0
	i32.store	$drop=, 204($6), $pop454
	i32.load	$push455=, 0($5):p2align=0
	i32.store	$drop=, 200($6), $pop455
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_91:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label26:
	i32.const	$push587=, 200
	i32.add 	$push588=, $6, $pop587
	i32.add 	$push457=, $pop588, $7
	i32.load8_s	$8=, 0($pop457)
	block
	i32.const	$push929=, 15
	i32.eq  	$push456=, $9, $pop929
	br_if   	0, $pop456      # 0: down to label28
# BB#92:                                # %if.then.i496
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.ne  	$push458=, $0, $9
	br_if   	3, $pop458      # 3: down to label10
# BB#93:                                # %if.end.i498
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$1=, 15
	i32.const	$0=, 0
	i32.const	$push933=, 0
	i32.const	$push932=, 15
	i32.store	$drop=, bar.lastn($pop933), $pop932
	i32.const	$push931=, 0
	i32.const	$push930=, 0
	i32.store	$drop=, bar.lastc($pop931), $pop930
.LBB1_94:                               # %if.end3.i503
                                        #   in Loop: Header=BB1_91 Depth=1
	end_block                       # label28:
	i32.const	$push936=, 24
	i32.shl 	$push459=, $0, $pop936
	i32.const	$push935=, 24
	i32.shr_s	$push460=, $pop459, $pop935
	i32.const	$push934=, 120
	i32.xor 	$push461=, $pop460, $pop934
	i32.ne  	$push462=, $pop461, $8
	br_if   	2, $pop462      # 2: down to label10
# BB#95:                                # %bar.exit506
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$push944=, 0
	i32.const	$push943=, 1
	i32.add 	$push942=, $0, $pop943
	tee_local	$push941=, $0=, $pop942
	i32.store	$drop=, bar.lastc($pop944), $pop941
	i32.const	$9=, 15
	i32.const	$push940=, 1
	i32.add 	$push939=, $7, $pop940
	tee_local	$push938=, $7=, $pop939
	i32.const	$push937=, 15
	i32.lt_s	$push463=, $pop938, $pop937
	br_if   	0, $pop463      # 0: up to label26
# BB#96:                                # %for.end182
	end_loop                        # label27:
	i32.const	$push589=, 184
	i32.add 	$push590=, $6, $pop589
	i32.const	$push464=, 12
	i32.add 	$push467=, $pop590, $pop464
	i32.const	$push946=, 12
	i32.add 	$push465=, $3, $pop946
	i32.load	$push466=, 0($pop465):p2align=0
	i32.store	$drop=, 0($pop467), $pop466
	i32.const	$push591=, 184
	i32.add 	$push592=, $6, $pop591
	i32.const	$push468=, 8
	i32.add 	$push471=, $pop592, $pop468
	i32.const	$push945=, 8
	i32.add 	$push469=, $3, $pop945
	i32.load	$push470=, 0($pop469):p2align=0
	i32.store	$drop=, 0($pop471), $pop470
	i32.const	$push472=, 160
	i32.add 	$push14=, $2, $pop472
	i32.store	$4=, 4($6), $pop14
	i32.const	$push473=, 4
	i32.add 	$push474=, $3, $pop473
	i32.load	$push475=, 0($pop474):p2align=0
	i32.store	$drop=, 188($6), $pop475
	i32.load	$push476=, 0($3):p2align=0
	i32.store	$drop=, 184($6), $pop476
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_97:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label29:
	i32.const	$push593=, 184
	i32.add 	$push594=, $6, $pop593
	i32.add 	$push478=, $pop594, $7
	i32.load8_s	$8=, 0($pop478)
	block
	i32.const	$push947=, 16
	i32.eq  	$push477=, $9, $pop947
	br_if   	0, $pop477      # 0: down to label31
# BB#98:                                # %if.then.i510
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.ne  	$push479=, $0, $9
	br_if   	3, $pop479      # 3: down to label10
# BB#99:                                # %if.end.i512
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$1=, 16
	i32.const	$0=, 0
	i32.const	$push951=, 0
	i32.const	$push950=, 16
	i32.store	$drop=, bar.lastn($pop951), $pop950
	i32.const	$push949=, 0
	i32.const	$push948=, 0
	i32.store	$drop=, bar.lastc($pop949), $pop948
.LBB1_100:                              # %if.end3.i517
                                        #   in Loop: Header=BB1_97 Depth=1
	end_block                       # label31:
	i32.const	$push954=, 24
	i32.shl 	$push480=, $0, $pop954
	i32.const	$push953=, -2147483648
	i32.xor 	$push481=, $pop480, $pop953
	i32.const	$push952=, 24
	i32.shr_s	$push482=, $pop481, $pop952
	i32.ne  	$push483=, $pop482, $8
	br_if   	2, $pop483      # 2: down to label10
# BB#101:                               # %bar.exit520
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$push962=, 0
	i32.const	$push961=, 1
	i32.add 	$push960=, $0, $pop961
	tee_local	$push959=, $0=, $pop960
	i32.store	$drop=, bar.lastc($pop962), $pop959
	i32.const	$9=, 16
	i32.const	$push958=, 1
	i32.add 	$push957=, $7, $pop958
	tee_local	$push956=, $7=, $pop957
	i32.const	$push955=, 16
	i32.lt_s	$push484=, $pop956, $pop955
	br_if   	0, $pop484      # 0: up to label29
# BB#102:                               # %for.end194
	end_loop                        # label30:
	i32.const	$push485=, 192
	i32.add 	$push15=, $2, $pop485
	i32.store	$5=, 4($6), $pop15
	i32.const	$push595=, 152
	i32.add 	$push596=, $6, $pop595
	i32.const	$push963=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop596, $4, $pop963
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_103:                              # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label32:
	i32.const	$push597=, 152
	i32.add 	$push598=, $6, $pop597
	i32.add 	$push487=, $pop598, $7
	i32.load8_s	$8=, 0($pop487)
	block
	i32.const	$push964=, 31
	i32.eq  	$push486=, $9, $pop964
	br_if   	0, $pop486      # 0: down to label34
# BB#104:                               # %if.then.i524
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.ne  	$push488=, $0, $9
	br_if   	3, $pop488      # 3: down to label10
# BB#105:                               # %if.end.i526
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$1=, 31
	i32.const	$0=, 0
	i32.const	$push968=, 0
	i32.const	$push967=, 31
	i32.store	$drop=, bar.lastn($pop968), $pop967
	i32.const	$push966=, 0
	i32.const	$push965=, 0
	i32.store	$drop=, bar.lastc($pop966), $pop965
.LBB1_106:                              # %if.end3.i531
                                        #   in Loop: Header=BB1_103 Depth=1
	end_block                       # label34:
	i32.const	$push971=, 24
	i32.shl 	$push489=, $0, $pop971
	i32.const	$push970=, -134217728
	i32.xor 	$push490=, $pop489, $pop970
	i32.const	$push969=, 24
	i32.shr_s	$push491=, $pop490, $pop969
	i32.ne  	$push492=, $pop491, $8
	br_if   	2, $pop492      # 2: down to label10
# BB#107:                               # %bar.exit534
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$push979=, 0
	i32.const	$push978=, 1
	i32.add 	$push977=, $0, $pop978
	tee_local	$push976=, $0=, $pop977
	i32.store	$drop=, bar.lastc($pop979), $pop976
	i32.const	$9=, 31
	i32.const	$push975=, 1
	i32.add 	$push974=, $7, $pop975
	tee_local	$push973=, $7=, $pop974
	i32.const	$push972=, 31
	i32.lt_s	$push493=, $pop973, $pop972
	br_if   	0, $pop493      # 0: up to label32
# BB#108:                               # %for.end206
	end_loop                        # label33:
	i32.const	$push599=, 120
	i32.add 	$push600=, $6, $pop599
	i32.const	$push494=, 28
	i32.add 	$push497=, $pop600, $pop494
	i32.const	$push986=, 28
	i32.add 	$push495=, $5, $pop986
	i32.load	$push496=, 0($pop495):p2align=0
	i32.store	$drop=, 0($pop497), $pop496
	i32.const	$push601=, 120
	i32.add 	$push602=, $6, $pop601
	i32.const	$push985=, 24
	i32.add 	$push500=, $pop602, $pop985
	i32.const	$push984=, 24
	i32.add 	$push498=, $5, $pop984
	i32.load	$push499=, 0($pop498):p2align=0
	i32.store	$drop=, 0($pop500), $pop499
	i32.const	$push603=, 120
	i32.add 	$push604=, $6, $pop603
	i32.const	$push501=, 20
	i32.add 	$push504=, $pop604, $pop501
	i32.const	$push983=, 20
	i32.add 	$push502=, $5, $pop983
	i32.load	$push503=, 0($pop502):p2align=0
	i32.store	$drop=, 0($pop504), $pop503
	i32.const	$push605=, 120
	i32.add 	$push606=, $6, $pop605
	i32.const	$push505=, 16
	i32.add 	$push508=, $pop606, $pop505
	i32.const	$push982=, 16
	i32.add 	$push506=, $5, $pop982
	i32.load	$push507=, 0($pop506):p2align=0
	i32.store	$drop=, 0($pop508), $pop507
	i32.const	$push607=, 120
	i32.add 	$push608=, $6, $pop607
	i32.const	$push509=, 12
	i32.add 	$push512=, $pop608, $pop509
	i32.const	$push981=, 12
	i32.add 	$push510=, $5, $pop981
	i32.load	$push511=, 0($pop510):p2align=0
	i32.store	$drop=, 0($pop512), $pop511
	i32.const	$push609=, 120
	i32.add 	$push610=, $6, $pop609
	i32.const	$push513=, 8
	i32.add 	$push516=, $pop610, $pop513
	i32.const	$push980=, 8
	i32.add 	$push514=, $5, $pop980
	i32.load	$push515=, 0($pop514):p2align=0
	i32.store	$drop=, 0($pop516), $pop515
	i32.const	$push517=, 224
	i32.add 	$push16=, $2, $pop517
	i32.store	$3=, 4($6), $pop16
	i32.const	$push518=, 4
	i32.add 	$push519=, $5, $pop518
	i32.load	$push520=, 0($pop519):p2align=0
	i32.store	$drop=, 124($6), $pop520
	i32.load	$push521=, 0($5):p2align=0
	i32.store	$drop=, 120($6), $pop521
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_109:                              # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label35:
	i32.const	$push611=, 120
	i32.add 	$push612=, $6, $pop611
	i32.add 	$push523=, $pop612, $7
	i32.load8_s	$8=, 0($pop523)
	block
	i32.const	$push987=, 32
	i32.eq  	$push522=, $9, $pop987
	br_if   	0, $pop522      # 0: down to label37
# BB#110:                               # %if.then.i538
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.ne  	$push524=, $0, $9
	br_if   	3, $pop524      # 3: down to label10
# BB#111:                               # %if.end.i540
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$1=, 32
	i32.const	$0=, 0
	i32.const	$push991=, 0
	i32.const	$push990=, 32
	i32.store	$drop=, bar.lastn($pop991), $pop990
	i32.const	$push989=, 0
	i32.const	$push988=, 0
	i32.store	$drop=, bar.lastc($pop989), $pop988
.LBB1_112:                              # %if.end3.i545
                                        #   in Loop: Header=BB1_109 Depth=1
	end_block                       # label37:
	i32.const	$push993=, 24
	i32.shl 	$push525=, $0, $pop993
	i32.const	$push992=, 24
	i32.shr_s	$push526=, $pop525, $pop992
	i32.ne  	$push527=, $pop526, $8
	br_if   	2, $pop527      # 2: down to label10
# BB#113:                               # %bar.exit548
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$push1001=, 0
	i32.const	$push1000=, 1
	i32.add 	$push999=, $0, $pop1000
	tee_local	$push998=, $0=, $pop999
	i32.store	$drop=, bar.lastc($pop1001), $pop998
	i32.const	$9=, 32
	i32.const	$push997=, 1
	i32.add 	$push996=, $7, $pop997
	tee_local	$push995=, $7=, $pop996
	i32.const	$push994=, 32
	i32.lt_s	$push528=, $pop995, $pop994
	br_if   	0, $pop528      # 0: up to label35
# BB#114:                               # %for.end218
	end_loop                        # label36:
	i32.const	$push529=, 260
	i32.add 	$push17=, $2, $pop529
	i32.store	$5=, 4($6), $pop17
	i32.const	$push613=, 80
	i32.add 	$push614=, $6, $pop613
	i32.const	$push1002=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop614, $3, $pop1002
	copy_local	$9=, $1
	i32.const	$7=, 0
.LBB1_115:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label38:
	i32.const	$push615=, 80
	i32.add 	$push616=, $6, $pop615
	i32.add 	$push531=, $pop616, $7
	i32.load8_s	$8=, 0($pop531)
	block
	i32.const	$push1003=, 35
	i32.eq  	$push530=, $9, $pop1003
	br_if   	0, $pop530      # 0: down to label40
# BB#116:                               # %if.then.i552
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.ne  	$push532=, $0, $9
	br_if   	3, $pop532      # 3: down to label10
# BB#117:                               # %if.end.i554
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$1=, 35
	i32.const	$0=, 0
	i32.const	$push1007=, 0
	i32.const	$push1006=, 35
	i32.store	$drop=, bar.lastn($pop1007), $pop1006
	i32.const	$push1005=, 0
	i32.const	$push1004=, 0
	i32.store	$drop=, bar.lastc($pop1005), $pop1004
.LBB1_118:                              # %if.end3.i559
                                        #   in Loop: Header=BB1_115 Depth=1
	end_block                       # label40:
	i32.const	$push1010=, 24
	i32.shl 	$push533=, $0, $pop1010
	i32.const	$push1009=, 24
	i32.shr_s	$push534=, $pop533, $pop1009
	i32.const	$push1008=, 24
	i32.xor 	$push535=, $pop534, $pop1008
	i32.ne  	$push536=, $pop535, $8
	br_if   	2, $pop536      # 2: down to label10
# BB#119:                               # %bar.exit562
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$push1018=, 0
	i32.const	$push1017=, 1
	i32.add 	$push1016=, $0, $pop1017
	tee_local	$push1015=, $0=, $pop1016
	i32.store	$drop=, bar.lastc($pop1018), $pop1015
	i32.const	$9=, 35
	i32.const	$push1014=, 1
	i32.add 	$push1013=, $7, $pop1014
	tee_local	$push1012=, $7=, $pop1013
	i32.const	$push1011=, 35
	i32.lt_s	$push537=, $pop1012, $pop1011
	br_if   	0, $pop537      # 0: up to label38
# BB#120:                               # %for.end230
	end_loop                        # label39:
	i32.const	$push538=, 332
	i32.add 	$push539=, $2, $pop538
	i32.store	$drop=, 4($6), $pop539
	i32.const	$push617=, 8
	i32.add 	$push618=, $6, $pop617
	i32.const	$push1019=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop618, $5, $pop1019
	i32.const	$7=, 0
.LBB1_121:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label41:
	i32.const	$push619=, 8
	i32.add 	$push620=, $6, $pop619
	i32.add 	$push541=, $pop620, $7
	i32.load8_s	$9=, 0($pop541)
	block
	i32.const	$push1020=, 72
	i32.eq  	$push540=, $1, $pop1020
	br_if   	0, $pop540      # 0: down to label43
# BB#122:                               # %if.then.i566
                                        #   in Loop: Header=BB1_121 Depth=1
	i32.ne  	$push542=, $0, $1
	br_if   	3, $pop542      # 3: down to label10
# BB#123:                               # %if.end.i568
                                        #   in Loop: Header=BB1_121 Depth=1
	i32.const	$0=, 0
	i32.const	$push1024=, 0
	i32.const	$push1023=, 72
	i32.store	$drop=, bar.lastn($pop1024), $pop1023
	i32.const	$push1022=, 0
	i32.const	$push1021=, 0
	i32.store	$drop=, bar.lastc($pop1022), $pop1021
.LBB1_124:                              # %if.end3.i573
                                        #   in Loop: Header=BB1_121 Depth=1
	end_block                       # label43:
	i32.const	$push1027=, 24
	i32.shl 	$push543=, $0, $pop1027
	i32.const	$push1026=, 24
	i32.shr_s	$push544=, $pop543, $pop1026
	i32.const	$push1025=, 64
	i32.xor 	$push545=, $pop544, $pop1025
	i32.ne  	$push546=, $pop545, $9
	br_if   	2, $pop546      # 2: down to label10
# BB#125:                               # %bar.exit576
                                        #   in Loop: Header=BB1_121 Depth=1
	i32.const	$push1035=, 0
	i32.const	$push1034=, 1
	i32.add 	$push1033=, $0, $pop1034
	tee_local	$push1032=, $0=, $pop1033
	i32.store	$drop=, bar.lastc($pop1035), $pop1032
	i32.const	$1=, 72
	i32.const	$push1031=, 1
	i32.add 	$push1030=, $7, $pop1031
	tee_local	$push1029=, $7=, $pop1030
	i32.const	$push1028=, 72
	i32.lt_s	$push547=, $pop1029, $pop1028
	br_if   	0, $pop547      # 0: up to label41
# BB#126:                               # %for.end242
	end_loop                        # label42:
	i32.const	$push554=, 0
	i32.const	$push552=, 352
	i32.add 	$push553=, $6, $pop552
	i32.store	$drop=, __stack_pointer($pop554), $pop553
	return
.LBB1_127:                              # %if.then7.i322
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_128:                              # %if.then7.i434
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_129:                              # %if.then7.i420
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_130:                              # %if.then7.i406
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_131:                              # %if.then7.i392
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_132:                              # %if.then7.i378
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_133:                              # %if.then7.i364
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_134:                              # %if.then7.i350
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_135:                              # %if.then7.i336
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push258=, 0
	i32.const	$push255=, 0
	i32.load	$push256=, __stack_pointer($pop255)
	i32.const	$push257=, 768
	i32.sub 	$push385=, $pop256, $pop257
	i32.store	$push387=, __stack_pointer($pop258), $pop385
	tee_local	$push386=, $12=, $pop387
	i32.const	$push0=, 4368
	i32.store16	$drop=, 760($pop386), $pop0
	i32.const	$push1=, 24
	i32.store8	$drop=, 752($12), $pop1
	i32.const	$push2=, 25
	i32.store8	$drop=, 753($12), $pop2
	i32.const	$push3=, 26
	i32.store8	$drop=, 754($12), $pop3
	i32.const	$push4=, 32
	i32.store8	$drop=, 744($12), $pop4
	i32.const	$push5=, 33
	i32.store8	$drop=, 745($12), $pop5
	i32.const	$push6=, 34
	i32.store8	$drop=, 746($12), $pop6
	i32.const	$push7=, 40
	i32.store8	$drop=, 736($12), $pop7
	i32.const	$push8=, 35
	i32.store8	$drop=, 747($12), $pop8
	i32.const	$push9=, 41
	i32.store8	$drop=, 737($12), $pop9
	i32.const	$push10=, 42
	i32.store8	$drop=, 738($12), $pop10
	i32.const	$push11=, 43
	i32.store8	$drop=, 739($12), $pop11
	i32.const	$push12=, 48
	i32.store8	$drop=, 728($12), $pop12
	i32.const	$push13=, 44
	i32.store8	$drop=, 740($12), $pop13
	i32.const	$push14=, 49
	i32.store8	$drop=, 729($12), $pop14
	i32.const	$push15=, 50
	i32.store8	$drop=, 730($12), $pop15
	i32.const	$push16=, 51
	i32.store8	$drop=, 731($12), $pop16
	i32.const	$push17=, 52
	i32.store8	$drop=, 732($12), $pop17
	i32.const	$push18=, 56
	i32.store8	$drop=, 720($12), $pop18
	i32.const	$push19=, 53
	i32.store8	$drop=, 733($12), $pop19
	i32.const	$push20=, 57
	i32.store8	$drop=, 721($12), $pop20
	i32.const	$push21=, 58
	i32.store8	$drop=, 722($12), $pop21
	i32.const	$push22=, 59
	i32.store8	$drop=, 723($12), $pop22
	i32.const	$push23=, 60
	i32.store8	$drop=, 724($12), $pop23
	i32.const	$push24=, 61
	i32.store8	$drop=, 725($12), $pop24
	i32.const	$push25=, 62
	i32.store8	$drop=, 726($12), $pop25
	i32.const	$push26=, 64
	i32.store8	$13=, 712($12), $pop26
	i32.const	$push27=, 65
	i32.store8	$drop=, 713($12), $pop27
	i32.const	$push28=, 66
	i32.store8	$drop=, 714($12), $pop28
	i32.const	$push29=, 67
	i32.store8	$drop=, 715($12), $pop29
	i32.const	$push30=, 68
	i32.store8	$drop=, 716($12), $pop30
	i32.const	$push31=, 69
	i32.store8	$drop=, 717($12), $pop31
	i32.const	$push32=, 70
	i32.store8	$drop=, 718($12), $pop32
	i32.const	$push33=, 71
	i32.store8	$drop=, 719($12), $pop33
	i32.const	$push34=, 72
	i32.store8	$drop=, 696($12), $pop34
	i32.const	$push35=, 73
	i32.store8	$drop=, 697($12), $pop35
	i32.const	$push36=, 74
	i32.store8	$drop=, 698($12), $pop36
	i32.const	$push37=, 75
	i32.store8	$drop=, 699($12), $pop37
	i32.const	$push38=, 76
	i32.store8	$drop=, 700($12), $pop38
	i32.const	$push39=, 77
	i32.store8	$drop=, 701($12), $pop39
	i32.const	$push40=, 78
	i32.store8	$drop=, 702($12), $pop40
	i32.const	$push41=, 79
	i32.store8	$drop=, 703($12), $pop41
	i32.store8	$drop=, 704($12), $13
	i32.const	$push42=, 80
	i32.store8	$13=, 680($12), $pop42
	i32.const	$push43=, 81
	i32.store8	$11=, 681($12), $pop43
	i32.const	$push44=, 82
	i32.store8	$0=, 682($12), $pop44
	i32.const	$push45=, 83
	i32.store8	$drop=, 683($12), $pop45
	i32.const	$push46=, 84
	i32.store8	$drop=, 684($12), $pop46
	i32.const	$push47=, 85
	i32.store8	$drop=, 685($12), $pop47
	i32.const	$push48=, 86
	i32.store8	$drop=, 686($12), $pop48
	i32.const	$push49=, 87
	i32.store8	$drop=, 687($12), $pop49
	i32.const	$push50=, 88
	i32.store8	$1=, 688($12), $pop50
	i32.const	$push51=, 89
	i32.store8	$2=, 689($12), $pop51
	i32.store8	$drop=, 664($12), $1
	i32.store8	$drop=, 665($12), $2
	i32.const	$push52=, 90
	i32.store8	$drop=, 666($12), $pop52
	i32.const	$push53=, 91
	i32.store8	$drop=, 667($12), $pop53
	i32.const	$push54=, 92
	i32.store8	$drop=, 668($12), $pop54
	i32.const	$push55=, 93
	i32.store8	$drop=, 669($12), $pop55
	i32.const	$push56=, 94
	i32.store8	$drop=, 670($12), $pop56
	i32.const	$push57=, 95
	i32.store8	$drop=, 671($12), $pop57
	i32.store8	$drop=, 672($12), $13
	i32.store8	$drop=, 673($12), $11
	i32.store8	$drop=, 674($12), $0
	i32.const	$push58=, 96
	i32.store8	$13=, 648($12), $pop58
	i32.const	$push59=, 97
	i32.store8	$11=, 649($12), $pop59
	i32.const	$push60=, 98
	i32.store8	$0=, 650($12), $pop60
	i32.const	$push61=, 99
	i32.store8	$1=, 651($12), $pop61
	i32.const	$push62=, 100
	i32.store8	$2=, 652($12), $pop62
	i32.const	$push63=, 101
	i32.store8	$drop=, 653($12), $pop63
	i32.const	$push64=, 102
	i32.store8	$drop=, 654($12), $pop64
	i32.const	$push65=, 103
	i32.store8	$drop=, 655($12), $pop65
	i32.const	$push66=, 104
	i32.store8	$3=, 656($12), $pop66
	i32.const	$push67=, 105
	i32.store8	$4=, 657($12), $pop67
	i32.const	$push68=, 106
	i32.store8	$5=, 658($12), $pop68
	i32.const	$push69=, 107
	i32.store8	$6=, 659($12), $pop69
	i32.store8	$drop=, 632($12), $3
	i32.store8	$drop=, 633($12), $4
	i32.store8	$drop=, 634($12), $5
	i32.store8	$drop=, 635($12), $6
	i32.const	$push70=, 108
	i32.store8	$drop=, 636($12), $pop70
	i32.const	$push71=, 109
	i32.store8	$drop=, 637($12), $pop71
	i32.const	$push72=, 110
	i32.store8	$drop=, 638($12), $pop72
	i32.const	$push73=, 111
	i32.store8	$drop=, 639($12), $pop73
	i32.store8	$drop=, 640($12), $13
	i32.store8	$drop=, 641($12), $11
	i32.store8	$drop=, 642($12), $0
	i32.store8	$drop=, 643($12), $1
	i32.store8	$drop=, 644($12), $2
	i32.const	$push74=, 112
	i32.store8	$13=, 616($12), $pop74
	i32.const	$push75=, 113
	i32.store8	$11=, 617($12), $pop75
	i32.const	$push76=, 114
	i32.store8	$0=, 618($12), $pop76
	i32.const	$push77=, 115
	i32.store8	$1=, 619($12), $pop77
	i32.const	$push78=, 116
	i32.store8	$2=, 620($12), $pop78
	i32.const	$push79=, 117
	i32.store8	$3=, 621($12), $pop79
	i32.const	$push80=, 118
	i32.store8	$4=, 622($12), $pop80
	i32.const	$push81=, 119
	i32.store8	$drop=, 623($12), $pop81
	i32.const	$push82=, 120
	i32.store8	$5=, 624($12), $pop82
	i32.const	$push83=, 121
	i32.store8	$6=, 625($12), $pop83
	i32.const	$push84=, 122
	i32.store8	$7=, 626($12), $pop84
	i32.const	$push85=, 123
	i32.store8	$8=, 627($12), $pop85
	i32.const	$push86=, 124
	i32.store8	$9=, 628($12), $pop86
	i32.const	$push87=, 125
	i32.store8	$10=, 629($12), $pop87
	i32.store8	$drop=, 600($12), $5
	i32.store8	$drop=, 601($12), $6
	i32.store8	$drop=, 602($12), $7
	i32.store8	$drop=, 603($12), $8
	i32.store8	$drop=, 604($12), $9
	i32.store8	$drop=, 605($12), $10
	i32.const	$push88=, 126
	i32.store8	$drop=, 606($12), $pop88
	i32.const	$push89=, 127
	i32.store8	$drop=, 607($12), $pop89
	i32.store8	$drop=, 608($12), $13
	i32.store8	$drop=, 609($12), $11
	i32.store8	$drop=, 610($12), $0
	i32.store8	$drop=, 611($12), $1
	i32.store8	$drop=, 612($12), $2
	i32.store8	$drop=, 613($12), $3
	i32.store8	$drop=, 614($12), $4
	i32.const	$push90=, 128
	i32.store8	$drop=, 584($12), $pop90
	i32.const	$push91=, 129
	i32.store8	$drop=, 585($12), $pop91
	i32.const	$push92=, 130
	i32.store8	$drop=, 586($12), $pop92
	i32.const	$push93=, 131
	i32.store8	$drop=, 587($12), $pop93
	i32.const	$push94=, 132
	i32.store8	$drop=, 588($12), $pop94
	i32.const	$push95=, 133
	i32.store8	$drop=, 589($12), $pop95
	i32.const	$push96=, 134
	i32.store8	$drop=, 590($12), $pop96
	i32.const	$push97=, 135
	i32.store8	$drop=, 591($12), $pop97
	i32.const	$push98=, 136
	i32.store8	$drop=, 592($12), $pop98
	i32.const	$push99=, 137
	i32.store8	$drop=, 593($12), $pop99
	i32.const	$push100=, 138
	i32.store8	$drop=, 594($12), $pop100
	i32.const	$push101=, 139
	i32.store8	$drop=, 595($12), $pop101
	i32.const	$push102=, 140
	i32.store8	$drop=, 596($12), $pop102
	i32.const	$push103=, 141
	i32.store8	$drop=, 597($12), $pop103
	i32.const	$push104=, 142
	i32.store8	$drop=, 598($12), $pop104
	i32.const	$push105=, 143
	i32.store8	$drop=, 599($12), $pop105
	i32.const	$13=, 0
.LBB2_1:                                # %for.body180
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label44:
	i32.const	$push259=, 552
	i32.add 	$push260=, $12, $pop259
	i32.add 	$push107=, $pop260, $13
	i32.const	$push392=, 248
	i32.xor 	$push106=, $13, $pop392
	i32.store8	$drop=, 0($pop107), $pop106
	i32.const	$push391=, 1
	i32.add 	$push390=, $13, $pop391
	tee_local	$push389=, $13=, $pop390
	i32.const	$push388=, 31
	i32.ne  	$push108=, $pop389, $pop388
	br_if   	0, $pop108      # 0: up to label44
# BB#2:                                 # %for.body191.preheader
	end_loop                        # label45:
	i32.const	$push109=, 50462976
	i32.store	$drop=, 520($12), $pop109
	i32.const	$push110=, 1284
	i32.store16	$drop=, 524($12), $pop110
	i32.const	$push111=, 151521030
	i32.store	$drop=, 526($12):p2align=1, $pop111
	i32.const	$push112=, 2826
	i32.store16	$drop=, 530($12), $pop112
	i32.const	$push113=, 3340
	i32.store16	$drop=, 532($12), $pop113
	i32.const	$push114=, 14
	i32.store8	$drop=, 534($12), $pop114
	i32.const	$push115=, 15
	i32.store8	$drop=, 535($12), $pop115
	i32.const	$push116=, 16
	i32.store8	$drop=, 536($12), $pop116
	i32.const	$push117=, 17
	i32.store8	$drop=, 537($12), $pop117
	i32.const	$push118=, 18
	i32.store8	$drop=, 538($12), $pop118
	i32.const	$push119=, 19
	i32.store8	$drop=, 539($12), $pop119
	i32.const	$push120=, 20
	i32.store8	$drop=, 540($12), $pop120
	i32.const	$push121=, 21
	i32.store8	$drop=, 541($12), $pop121
	i32.const	$push122=, 22
	i32.store8	$drop=, 542($12), $pop122
	i32.const	$push123=, 23
	i32.store8	$drop=, 543($12), $pop123
	i32.const	$push124=, 24
	i32.store8	$11=, 544($12), $pop124
	i32.const	$push125=, 25
	i32.store8	$drop=, 545($12), $pop125
	i32.const	$push126=, 26
	i32.store8	$drop=, 546($12), $pop126
	i32.const	$push127=, 27
	i32.store8	$drop=, 547($12), $pop127
	i32.const	$push128=, 28
	i32.store8	$drop=, 548($12), $pop128
	i32.const	$push129=, 29
	i32.store8	$drop=, 549($12), $pop129
	i32.const	$push130=, 30
	i32.store8	$drop=, 550($12), $pop130
	i32.const	$push131=, 31
	i32.store8	$drop=, 551($12), $pop131
	i32.const	$13=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label46:
	i32.const	$push261=, 480
	i32.add 	$push262=, $12, $pop261
	i32.add 	$push133=, $pop262, $13
	i32.xor 	$push132=, $13, $11
	i32.store8	$drop=, 0($pop133), $pop132
	i32.const	$push396=, 1
	i32.add 	$push395=, $13, $pop396
	tee_local	$push394=, $13=, $pop395
	i32.const	$push393=, 35
	i32.ne  	$push134=, $pop394, $pop393
	br_if   	0, $pop134      # 0: up to label46
# BB#4:                                 # %for.body213.preheader
	end_loop                        # label47:
	i32.const	$13=, 0
.LBB2_5:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label48:
	i32.const	$push263=, 408
	i32.add 	$push264=, $12, $pop263
	i32.add 	$push136=, $pop264, $13
	i32.const	$push401=, 64
	i32.xor 	$push135=, $13, $pop401
	i32.store8	$drop=, 0($pop136), $pop135
	i32.const	$push400=, 1
	i32.add 	$push399=, $13, $pop400
	tee_local	$push398=, $13=, $pop399
	i32.const	$push397=, 72
	i32.ne  	$push137=, $pop398, $pop397
	br_if   	0, $pop137      # 0: up to label48
# BB#6:                                 # %for.end220
	end_loop                        # label49:
	i32.const	$push138=, 404
	i32.add 	$push139=, $12, $pop138
	i32.load8_u	$push140=, 754($12)
	i32.store8	$drop=, 0($pop139), $pop140
	i32.load16_u	$push141=, 760($12)
	i32.store16	$drop=, 406($12), $pop141
	i32.load16_u	$push142=, 752($12)
	i32.store16	$drop=, 402($12), $pop142
	i32.load	$push143=, 744($12)
	i32.store	$drop=, 396($12), $pop143
	i32.const	$push265=, 388
	i32.add 	$push266=, $12, $pop265
	i32.const	$push144=, 4
	i32.add 	$push145=, $pop266, $pop144
	i32.load8_u	$push146=, 740($12)
	i32.store8	$drop=, 0($pop145), $pop146
	i32.load	$push147=, 736($12)
	i32.store	$drop=, 388($12), $pop147
	i32.const	$push267=, 380
	i32.add 	$push268=, $12, $pop267
	i32.const	$push433=, 4
	i32.add 	$push148=, $pop268, $pop433
	i32.load16_u	$push149=, 732($12)
	i32.store16	$drop=, 0($pop148), $pop149
	i32.load	$push150=, 728($12)
	i32.store	$drop=, 380($12), $pop150
	i32.const	$push151=, 378
	i32.add 	$push152=, $12, $pop151
	i32.load8_u	$push153=, 726($12)
	i32.store8	$drop=, 0($pop152), $pop153
	i32.const	$push269=, 372
	i32.add 	$push270=, $12, $pop269
	i32.const	$push432=, 4
	i32.add 	$push154=, $pop270, $pop432
	i32.load16_u	$push155=, 724($12)
	i32.store16	$drop=, 0($pop154), $pop155
	i32.load	$push156=, 720($12)
	i32.store	$drop=, 372($12), $pop156
	i64.load	$push157=, 712($12)
	i64.store	$drop=, 364($12):p2align=2, $pop157
	i32.const	$push271=, 352
	i32.add 	$push272=, $12, $pop271
	i32.const	$push158=, 8
	i32.add 	$push159=, $pop272, $pop158
	i32.const	$push273=, 696
	i32.add 	$push274=, $12, $pop273
	i32.const	$push431=, 8
	i32.add 	$push160=, $pop274, $pop431
	i32.load8_u	$push161=, 0($pop160)
	i32.store8	$drop=, 0($pop159), $pop161
	i64.load	$push162=, 696($12)
	i64.store	$drop=, 352($12):p2align=2, $pop162
	i32.const	$push275=, 340
	i32.add 	$push276=, $12, $pop275
	i32.const	$push430=, 8
	i32.add 	$push163=, $pop276, $pop430
	i32.const	$push277=, 680
	i32.add 	$push278=, $12, $pop277
	i32.const	$push429=, 8
	i32.add 	$push164=, $pop278, $pop429
	i32.load16_u	$push165=, 0($pop164)
	i32.store16	$drop=, 0($pop163), $pop165
	i64.load	$push166=, 680($12)
	i64.store	$drop=, 340($12):p2align=2, $pop166
	i32.const	$push279=, 328
	i32.add 	$push280=, $12, $pop279
	i32.const	$push167=, 10
	i32.add 	$push168=, $pop280, $pop167
	i32.const	$push281=, 664
	i32.add 	$push282=, $12, $pop281
	i32.const	$push428=, 10
	i32.add 	$push169=, $pop282, $pop428
	i32.load8_u	$push170=, 0($pop169)
	i32.store8	$drop=, 0($pop168), $pop170
	i32.const	$push283=, 328
	i32.add 	$push284=, $12, $pop283
	i32.const	$push427=, 8
	i32.add 	$push171=, $pop284, $pop427
	i32.const	$push285=, 664
	i32.add 	$push286=, $12, $pop285
	i32.const	$push426=, 8
	i32.add 	$push172=, $pop286, $pop426
	i32.load16_u	$push173=, 0($pop172)
	i32.store16	$drop=, 0($pop171), $pop173
	i64.load	$push174=, 664($12)
	i64.store	$drop=, 328($12):p2align=2, $pop174
	i32.const	$push287=, 316
	i32.add 	$push288=, $12, $pop287
	i32.const	$push425=, 8
	i32.add 	$push175=, $pop288, $pop425
	i32.const	$push289=, 648
	i32.add 	$push290=, $12, $pop289
	i32.const	$push424=, 8
	i32.add 	$push176=, $pop290, $pop424
	i32.load	$push177=, 0($pop176)
	i32.store	$drop=, 0($pop175), $pop177
	i64.load	$push178=, 648($12)
	i64.store	$drop=, 316($12):p2align=2, $pop178
	i32.const	$push291=, 300
	i32.add 	$push292=, $12, $pop291
	i32.const	$push179=, 12
	i32.add 	$push180=, $pop292, $pop179
	i32.const	$push293=, 632
	i32.add 	$push294=, $12, $pop293
	i32.const	$push423=, 12
	i32.add 	$push181=, $pop294, $pop423
	i32.load8_u	$push182=, 0($pop181)
	i32.store8	$drop=, 0($pop180), $pop182
	i32.const	$push295=, 300
	i32.add 	$push296=, $12, $pop295
	i32.const	$push422=, 8
	i32.add 	$push183=, $pop296, $pop422
	i32.const	$push297=, 632
	i32.add 	$push298=, $12, $pop297
	i32.const	$push421=, 8
	i32.add 	$push184=, $pop298, $pop421
	i32.load	$push185=, 0($pop184)
	i32.store	$drop=, 0($pop183), $pop185
	i64.load	$push186=, 632($12)
	i64.store	$drop=, 300($12):p2align=2, $pop186
	i32.const	$push299=, 284
	i32.add 	$push300=, $12, $pop299
	i32.const	$push420=, 12
	i32.add 	$push187=, $pop300, $pop420
	i32.const	$push301=, 616
	i32.add 	$push302=, $12, $pop301
	i32.const	$push419=, 12
	i32.add 	$push188=, $pop302, $pop419
	i32.load16_u	$push189=, 0($pop188)
	i32.store16	$drop=, 0($pop187), $pop189
	i32.const	$push303=, 284
	i32.add 	$push304=, $12, $pop303
	i32.const	$push418=, 8
	i32.add 	$push190=, $pop304, $pop418
	i32.const	$push305=, 616
	i32.add 	$push306=, $12, $pop305
	i32.const	$push417=, 8
	i32.add 	$push191=, $pop306, $pop417
	i32.load	$push192=, 0($pop191)
	i32.store	$drop=, 0($pop190), $pop192
	i64.load	$push193=, 616($12)
	i64.store	$drop=, 284($12):p2align=2, $pop193
	i32.const	$push307=, 268
	i32.add 	$push308=, $12, $pop307
	i32.const	$push194=, 14
	i32.add 	$push195=, $pop308, $pop194
	i32.const	$push309=, 600
	i32.add 	$push310=, $12, $pop309
	i32.const	$push416=, 14
	i32.add 	$push196=, $pop310, $pop416
	i32.load8_u	$push197=, 0($pop196)
	i32.store8	$drop=, 0($pop195), $pop197
	i32.const	$push311=, 268
	i32.add 	$push312=, $12, $pop311
	i32.const	$push415=, 12
	i32.add 	$push198=, $pop312, $pop415
	i32.const	$push313=, 600
	i32.add 	$push314=, $12, $pop313
	i32.const	$push414=, 12
	i32.add 	$push199=, $pop314, $pop414
	i32.load16_u	$push200=, 0($pop199)
	i32.store16	$drop=, 0($pop198), $pop200
	i32.const	$push315=, 268
	i32.add 	$push316=, $12, $pop315
	i32.const	$push413=, 8
	i32.add 	$push201=, $pop316, $pop413
	i32.const	$push317=, 600
	i32.add 	$push318=, $12, $pop317
	i32.const	$push412=, 8
	i32.add 	$push202=, $pop318, $pop412
	i32.load	$push203=, 0($pop202)
	i32.store	$drop=, 0($pop201), $pop203
	i64.load	$push204=, 600($12)
	i64.store	$drop=, 268($12):p2align=2, $pop204
	i32.const	$push319=, 252
	i32.add 	$push320=, $12, $pop319
	i32.const	$push411=, 8
	i32.add 	$push205=, $pop320, $pop411
	i32.const	$push321=, 584
	i32.add 	$push322=, $12, $pop321
	i32.const	$push410=, 8
	i32.add 	$push206=, $pop322, $pop410
	i64.load	$push207=, 0($pop206)
	i64.store	$drop=, 0($pop205):p2align=2, $pop207
	i64.load	$push208=, 584($12)
	i64.store	$drop=, 252($12):p2align=2, $pop208
	i32.const	$push323=, 221
	i32.add 	$push324=, $12, $pop323
	i32.const	$push325=, 552
	i32.add 	$push326=, $12, $pop325
	i32.const	$push209=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop324, $pop326, $pop209
	i32.const	$push327=, 188
	i32.add 	$push328=, $12, $pop327
	i32.const	$push210=, 24
	i32.add 	$push211=, $pop328, $pop210
	i32.const	$push329=, 520
	i32.add 	$push330=, $12, $pop329
	i32.const	$push409=, 24
	i32.add 	$push212=, $pop330, $pop409
	i64.load	$push213=, 0($pop212)
	i64.store	$drop=, 0($pop211):p2align=2, $pop213
	i32.const	$push331=, 188
	i32.add 	$push332=, $12, $pop331
	i32.const	$push214=, 16
	i32.add 	$push215=, $pop332, $pop214
	i32.const	$push333=, 520
	i32.add 	$push334=, $12, $pop333
	i32.const	$push408=, 16
	i32.add 	$push216=, $pop334, $pop408
	i64.load	$push217=, 0($pop216)
	i64.store	$drop=, 0($pop215):p2align=2, $pop217
	i32.const	$push335=, 188
	i32.add 	$push336=, $12, $pop335
	i32.const	$push407=, 8
	i32.add 	$push218=, $pop336, $pop407
	i32.const	$push337=, 520
	i32.add 	$push338=, $12, $pop337
	i32.const	$push406=, 8
	i32.add 	$push219=, $pop338, $pop406
	i64.load	$push220=, 0($pop219)
	i64.store	$drop=, 0($pop218):p2align=2, $pop220
	i64.load	$push221=, 520($12)
	i64.store	$drop=, 188($12):p2align=2, $pop221
	i32.const	$push339=, 153
	i32.add 	$push340=, $12, $pop339
	i32.const	$push341=, 480
	i32.add 	$push342=, $12, $pop341
	i32.const	$push222=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop340, $pop342, $pop222
	i32.const	$push343=, 81
	i32.add 	$push344=, $12, $pop343
	i32.const	$push345=, 408
	i32.add 	$push346=, $12, $pop345
	i32.const	$push223=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop344, $pop346, $pop223
	i32.const	$push224=, 76
	i32.add 	$push225=, $12, $pop224
	i32.const	$push347=, 81
	i32.add 	$push348=, $12, $pop347
	i32.store	$drop=, 0($pop225), $pop348
	i32.const	$push226=, 68
	i32.add 	$push227=, $12, $pop226
	i32.const	$push349=, 188
	i32.add 	$push350=, $12, $pop349
	i32.store	$drop=, 0($pop227), $pop350
	i32.const	$push228=, 64
	i32.add 	$push229=, $12, $pop228
	i32.const	$push351=, 221
	i32.add 	$push352=, $12, $pop351
	i32.store	$drop=, 0($pop229), $pop352
	i32.const	$push230=, 60
	i32.add 	$push231=, $12, $pop230
	i32.const	$push353=, 252
	i32.add 	$push354=, $12, $pop353
	i32.store	$drop=, 0($pop231), $pop354
	i32.const	$push232=, 56
	i32.add 	$push233=, $12, $pop232
	i32.const	$push355=, 268
	i32.add 	$push356=, $12, $pop355
	i32.store	$drop=, 0($pop233), $pop356
	i32.const	$push234=, 52
	i32.add 	$push235=, $12, $pop234
	i32.const	$push357=, 284
	i32.add 	$push358=, $12, $pop357
	i32.store	$drop=, 0($pop235), $pop358
	i32.const	$push236=, 48
	i32.add 	$push237=, $12, $pop236
	i32.const	$push359=, 300
	i32.add 	$push360=, $12, $pop359
	i32.store	$drop=, 0($pop237), $pop360
	i32.const	$push238=, 44
	i32.add 	$push239=, $12, $pop238
	i32.const	$push361=, 316
	i32.add 	$push362=, $12, $pop361
	i32.store	$drop=, 0($pop239), $pop362
	i32.const	$push240=, 40
	i32.add 	$push241=, $12, $pop240
	i32.const	$push363=, 328
	i32.add 	$push364=, $12, $pop363
	i32.store	$drop=, 0($pop241), $pop364
	i32.const	$push242=, 36
	i32.add 	$push243=, $12, $pop242
	i32.const	$push365=, 340
	i32.add 	$push366=, $12, $pop365
	i32.store	$drop=, 0($pop243), $pop366
	i32.const	$push244=, 32
	i32.add 	$push245=, $12, $pop244
	i32.const	$push367=, 352
	i32.add 	$push368=, $12, $pop367
	i32.store	$drop=, 0($pop245), $pop368
	i32.const	$push246=, 28
	i32.add 	$push247=, $12, $pop246
	i32.const	$push369=, 364
	i32.add 	$push370=, $12, $pop369
	i32.store	$drop=, 0($pop247), $pop370
	i32.const	$push405=, 24
	i32.add 	$push248=, $12, $pop405
	i32.const	$push371=, 372
	i32.add 	$push372=, $12, $pop371
	i32.store	$drop=, 0($pop248), $pop372
	i32.const	$push249=, 20
	i32.add 	$push250=, $12, $pop249
	i32.const	$push373=, 380
	i32.add 	$push374=, $12, $pop373
	i32.store	$drop=, 0($pop250), $pop374
	i32.const	$push404=, 16
	i32.add 	$push251=, $12, $pop404
	i32.const	$push375=, 388
	i32.add 	$push376=, $12, $pop375
	i32.store	$drop=, 0($pop251), $pop376
	i32.const	$push403=, 8
	i32.store	$drop=, 0($12), $pop403
	i32.const	$push402=, 72
	i32.add 	$push252=, $12, $pop402
	i32.const	$push377=, 153
	i32.add 	$push378=, $12, $pop377
	i32.store	$drop=, 0($pop252), $pop378
	i32.const	$push379=, 396
	i32.add 	$push380=, $12, $pop379
	i32.store	$drop=, 12($12), $pop380
	i32.const	$push381=, 402
	i32.add 	$push382=, $12, $pop381
	i32.store	$drop=, 8($12), $pop382
	i32.const	$push383=, 406
	i32.add 	$push384=, $12, $pop383
	i32.store	$drop=, 4($12), $pop384
	i32.const	$push253=, 21
	call    	foo@FUNCTION, $pop253, $12
	i32.const	$push254=, 0
	call    	exit@FUNCTION, $pop254
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	bar.lastn,@object       # @bar.lastn
	.section	.data.bar.lastn,"aw",@progbits
	.p2align	2
bar.lastn:
	.int32	4294967295              # 0xffffffff
	.size	bar.lastn, 4

	.type	bar.lastc,@object       # @bar.lastc
	.section	.data.bar.lastc,"aw",@progbits
	.p2align	2
bar.lastc:
	.int32	4294967295              # 0xffffffff
	.size	bar.lastc, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
