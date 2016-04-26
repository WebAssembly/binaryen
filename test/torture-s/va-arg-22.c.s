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
	i32.load	$2=, bar.lastc($pop0)
	block
	block
	i32.const	$push16=, 0
	i32.load	$push15=, bar.lastn($pop16)
	tee_local	$push14=, $3=, $pop15
	i32.eq  	$push1=, $pop14, $0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then
	i32.ne  	$push2=, $2, $3
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %if.end
	i32.const	$push3=, 0
	i32.const	$push17=, 0
	i32.store	$2=, bar.lastc($pop3), $pop17
	i32.store	$discard=, bar.lastn($2), $0
.LBB0_3:                                # %if.end3
	end_block                       # label1:
	i32.const	$push4=, 3
	i32.shl 	$push5=, $0, $pop4
	i32.xor 	$push6=, $2, $pop5
	i32.const	$push7=, 24
	i32.shl 	$push8=, $pop6, $pop7
	i32.const	$push18=, 24
	i32.shr_s	$push9=, $pop8, $pop18
	i32.ne  	$push10=, $pop9, $1
	br_if   	0, $pop10       # 0: down to label0
# BB#4:                                 # %if.end8
	i32.const	$push13=, 0
	i32.const	$push11=, 1
	i32.add 	$push12=, $2, $pop11
	i32.store	$discard=, bar.lastc($pop13), $pop12
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
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push656=, __stack_pointer
	i32.load	$push657=, 0($pop656)
	i32.const	$push658=, 352
	i32.sub 	$10=, $pop657, $pop658
	i32.const	$push659=, __stack_pointer
	i32.store	$discard=, 0($pop659), $10
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push36=, 21
	i32.ne  	$push37=, $0, $pop36
	br_if   	0, $pop37       # 0: down to label8
# BB#1:                                 # %if.end
	i32.store	$push445=, 4($10), $1
	tee_local	$push444=, $9=, $pop445
	i32.const	$push38=, 4
	i32.add 	$push39=, $pop444, $pop38
	i32.store	$discard=, 4($10), $pop39
	i32.const	$push40=, 0
	i32.load	$0=, bar.lastc($pop40)
	i32.load8_s	$1=, 0($9)
	block
	i32.const	$push443=, 0
	i32.load	$push442=, bar.lastn($pop443)
	tee_local	$push441=, $2=, $pop442
	i32.const	$push41=, 1
	i32.eq  	$push42=, $pop441, $pop41
	br_if   	0, $pop42       # 0: down to label9
# BB#2:                                 # %if.then.i
	i32.ne  	$push43=, $0, $2
	br_if   	1, $pop43       # 1: down to label8
# BB#3:                                 # %if.end.i
	i32.const	$push44=, 0
	i32.const	$push446=, 0
	i32.store	$0=, bar.lastc($pop44), $pop446
	i32.const	$push45=, 1
	i32.store	$discard=, bar.lastn($0), $pop45
.LBB1_4:                                # %if.end3.i
	end_block                       # label9:
	i32.const	$push46=, 24
	i32.shl 	$push47=, $0, $pop46
	i32.const	$push448=, 24
	i32.shr_s	$push48=, $pop47, $pop448
	i32.const	$push447=, 8
	i32.xor 	$push49=, $pop48, $pop447
	i32.ne  	$push50=, $pop49, $1
	br_if   	0, $pop50       # 0: down to label8
# BB#5:                                 # %if.then.i314
	i32.const	$push450=, 0
	i32.const	$push51=, 1
	i32.add 	$push52=, $0, $pop51
	i32.store	$discard=, bar.lastc($pop450), $pop52
	i32.const	$push449=, 8
	i32.add 	$push0=, $9, $pop449
	i32.store	$1=, 4($10), $pop0
	br_if   	0, $0           # 0: down to label8
# BB#6:                                 # %if.end3.i321
	i32.const	$push53=, 4
	i32.add 	$push54=, $9, $pop53
	i32.load16_u	$0=, 0($pop54):p2align=0
	i32.const	$push452=, 0
	i32.const	$push451=, 0
	i32.store	$push55=, bar.lastc($pop452), $pop451
	i32.const	$push56=, 2
	i32.store	$discard=, bar.lastn($pop55), $pop56
	i32.const	$push57=, 255
	i32.and 	$push58=, $0, $pop57
	i32.const	$push59=, 16
	i32.ne  	$push60=, $pop58, $pop59
	br_if   	0, $pop60       # 0: down to label8
# BB#7:                                 # %if.end3.i321.1
	i32.const	$push61=, 0
	i32.const	$push62=, 1
	i32.store	$discard=, bar.lastc($pop61), $pop62
	i32.const	$push63=, 65280
	i32.and 	$push64=, $0, $pop63
	i32.const	$push65=, 4352
	i32.ne  	$push66=, $pop64, $pop65
	br_if   	0, $pop66       # 0: down to label8
# BB#8:                                 # %if.end3.i335
	i32.const	$push69=, 12
	i32.add 	$push70=, $9, $pop69
	i32.store	$discard=, 4($10), $pop70
	i32.const	$push455=, 0
	i32.const	$push67=, 2
	i32.store	$push68=, bar.lastc($pop455), $pop67
	i32.add 	$push72=, $1, $pop68
	i32.load8_u	$0=, 0($pop72)
	i32.load16_u	$push71=, 0($1):p2align=0
	i32.store16	$discard=, 344($10), $pop71
	i32.store8	$discard=, 346($10), $0
	i32.const	$push454=, 0
	i32.const	$push453=, 0
	i32.store	$0=, bar.lastc($pop454), $pop453
	i32.load8_u	$1=, 344($10)
	i32.const	$push73=, 3
	i32.store	$discard=, bar.lastn($0), $pop73
	i32.const	$push74=, 24
	i32.ne  	$push75=, $1, $pop74
	br_if   	6, $pop75       # 6: down to label2
# BB#9:                                 # %if.end3.i335.1
	i32.load8_u	$0=, 345($10)
	i32.const	$push613=, 0
	i32.const	$push76=, 1
	i32.store	$discard=, bar.lastc($pop613), $pop76
	i32.const	$push77=, 25
	i32.ne  	$push78=, $0, $pop77
	br_if   	6, $pop78       # 6: down to label2
# BB#10:                                # %if.end3.i335.2
	i32.load8_u	$0=, 346($10)
	i32.const	$push614=, 0
	i32.const	$push79=, 2
	i32.store	$discard=, bar.lastc($pop614), $pop79
	i32.const	$push80=, 26
	i32.ne  	$push81=, $0, $pop80
	br_if   	6, $pop81       # 6: down to label2
# BB#11:                                # %if.end3.i349
	i32.const	$push83=, 0
	i32.const	$push82=, 3
	i32.store	$discard=, bar.lastc($pop83), $pop82
	i32.const	$push84=, 16
	i32.add 	$push1=, $9, $pop84
	i32.store	$1=, 4($10), $pop1
	i32.const	$push85=, 12
	i32.add 	$push86=, $9, $pop85
	i32.load	$0=, 0($pop86):p2align=0
	i32.const	$push459=, 0
	i32.const	$push458=, 0
	i32.store	$push457=, bar.lastc($pop459), $pop458
	tee_local	$push456=, $2=, $pop457
	i32.const	$push87=, 4
	i32.store	$discard=, bar.lastn($pop456), $pop87
	i32.const	$push88=, 255
	i32.and 	$push89=, $0, $pop88
	i32.const	$push90=, 32
	i32.ne  	$push91=, $pop89, $pop90
	br_if   	5, $pop91       # 5: down to label3
# BB#12:                                # %if.end3.i349.1
	i32.const	$push92=, 1
	i32.store	$discard=, bar.lastc($2), $pop92
	i32.const	$push93=, 65280
	i32.and 	$push94=, $0, $pop93
	i32.const	$push95=, 8448
	i32.ne  	$push96=, $pop94, $pop95
	br_if   	5, $pop96       # 5: down to label3
# BB#13:                                # %if.end3.i349.2
	i32.const	$push611=, 0
	i32.const	$push97=, 2
	i32.store	$discard=, bar.lastc($pop611), $pop97
	i32.const	$push98=, 16711680
	i32.and 	$push99=, $0, $pop98
	i32.const	$push100=, 2228224
	i32.ne  	$push101=, $pop99, $pop100
	br_if   	5, $pop101      # 5: down to label3
# BB#14:                                # %if.end3.i349.3
	i32.const	$push612=, 0
	i32.const	$push102=, 3
	i32.store	$discard=, bar.lastc($pop612), $pop102
	i32.const	$push103=, -16777216
	i32.and 	$push104=, $0, $pop103
	i32.const	$push105=, 587202560
	i32.ne  	$push106=, $pop104, $pop105
	br_if   	5, $pop106      # 5: down to label3
# BB#15:                                # %if.end3.i363
	i32.const	$push107=, 24
	i32.add 	$push2=, $9, $pop107
	i32.store	$2=, 4($10), $pop2
	i32.const	$push109=, 4
	i32.add 	$push110=, $1, $pop109
	i32.load8_u	$0=, 0($pop110)
	i32.load	$push108=, 0($1):p2align=0
	i32.store	$discard=, 336($10), $pop108
	i32.store8	$discard=, 340($10), $0
	i32.const	$push111=, 0
	i32.const	$push460=, 0
	i32.store	$0=, bar.lastc($pop111), $pop460
	i32.load8_u	$1=, 336($10)
	i32.const	$push112=, 5
	i32.store	$discard=, bar.lastn($0), $pop112
	i32.const	$push113=, 40
	i32.ne  	$push114=, $1, $pop113
	br_if   	4, $pop114      # 4: down to label4
# BB#16:                                # %if.end3.i363.1
	i32.load8_u	$1=, 337($10)
	i32.const	$push115=, 1
	i32.store	$discard=, bar.lastc($0), $pop115
	i32.const	$push116=, 41
	i32.ne  	$push117=, $1, $pop116
	br_if   	4, $pop117      # 4: down to label4
# BB#17:                                # %if.end3.i363.2
	i32.load8_u	$0=, 338($10)
	i32.const	$push609=, 0
	i32.const	$push118=, 2
	i32.store	$discard=, bar.lastc($pop609), $pop118
	i32.const	$push119=, 42
	i32.ne  	$push120=, $0, $pop119
	br_if   	4, $pop120      # 4: down to label4
# BB#18:                                # %if.end3.i363.3
	i32.load8_u	$0=, 339($10)
	i32.const	$push610=, 0
	i32.const	$push121=, 3
	i32.store	$discard=, bar.lastc($pop610), $pop121
	i32.const	$push122=, 43
	i32.ne  	$push123=, $0, $pop122
	br_if   	4, $pop123      # 4: down to label4
# BB#19:                                # %if.end3.i363.4
	i32.load8_u	$0=, 340($10)
	i32.const	$push124=, 0
	i32.const	$push125=, 4
	i32.store	$1=, bar.lastc($pop124), $pop125
	i32.const	$push126=, 44
	i32.ne  	$push127=, $0, $pop126
	br_if   	4, $pop127      # 4: down to label4
# BB#20:                                # %if.end3.i377
	i32.const	$push128=, 32
	i32.add 	$push3=, $9, $pop128
	i32.store	$0=, 4($10), $pop3
	i32.add 	$push130=, $2, $1
	i32.load16_u	$1=, 0($pop130):p2align=0
	i32.load	$push129=, 0($2):p2align=0
	i32.store	$discard=, 328($10), $pop129
	i32.store16	$discard=, 332($10), $1
	i32.const	$push462=, 0
	i32.const	$push461=, 0
	i32.store	$1=, bar.lastc($pop462), $pop461
	i32.load8_u	$2=, 328($10)
	i32.const	$push131=, 6
	i32.store	$discard=, bar.lastn($1), $pop131
	i32.const	$push132=, 48
	i32.ne  	$push133=, $2, $pop132
	br_if   	3, $pop133      # 3: down to label5
# BB#21:                                # %if.end3.i377.1
	i32.load8_u	$1=, 329($10)
	i32.const	$push605=, 0
	i32.const	$push134=, 1
	i32.store	$discard=, bar.lastc($pop605), $pop134
	i32.const	$push135=, 49
	i32.ne  	$push136=, $1, $pop135
	br_if   	3, $pop136      # 3: down to label5
# BB#22:                                # %if.end3.i377.2
	i32.load8_u	$1=, 330($10)
	i32.const	$push606=, 0
	i32.const	$push137=, 2
	i32.store	$discard=, bar.lastc($pop606), $pop137
	i32.const	$push138=, 50
	i32.ne  	$push139=, $1, $pop138
	br_if   	3, $pop139      # 3: down to label5
# BB#23:                                # %if.end3.i377.3
	i32.load8_u	$1=, 331($10)
	i32.const	$push607=, 0
	i32.const	$push140=, 3
	i32.store	$discard=, bar.lastc($pop607), $pop140
	i32.const	$push141=, 51
	i32.ne  	$push142=, $1, $pop141
	br_if   	3, $pop142      # 3: down to label5
# BB#24:                                # %if.end3.i377.4
	i32.load8_u	$1=, 332($10)
	i32.const	$push608=, 0
	i32.const	$push143=, 4
	i32.store	$discard=, bar.lastc($pop608), $pop143
	i32.const	$push144=, 52
	i32.ne  	$push145=, $1, $pop144
	br_if   	3, $pop145      # 3: down to label5
# BB#25:                                # %if.end3.i377.5
	i32.load8_u	$1=, 333($10)
	i32.const	$push146=, 0
	i32.const	$push147=, 5
	i32.store	$discard=, bar.lastc($pop146), $pop147
	i32.const	$push148=, 53
	i32.ne  	$push149=, $1, $pop148
	br_if   	3, $pop149      # 3: down to label5
# BB#26:                                # %if.end3.i391
	i32.const	$push150=, 40
	i32.add 	$push151=, $9, $pop150
	i32.store	$discard=, 4($10), $pop151
	i32.const	$push153=, 6
	i32.add 	$push154=, $0, $pop153
	i32.load8_u	$1=, 0($pop154)
	i32.const	$push155=, 4
	i32.add 	$push156=, $0, $pop155
	i32.load16_u	$2=, 0($pop156):p2align=0
	i32.load	$push152=, 0($0):p2align=0
	i32.store	$discard=, 320($10), $pop152
	i32.store8	$discard=, 326($10), $1
	i32.store16	$discard=, 324($10), $2
	i32.const	$push464=, 0
	i32.const	$push463=, 0
	i32.store	$0=, bar.lastc($pop464), $pop463
	i32.load8_u	$1=, 320($10)
	i32.const	$push157=, 7
	i32.store	$discard=, bar.lastn($0), $pop157
	i32.const	$push158=, 56
	i32.ne  	$push159=, $1, $pop158
	br_if   	2, $pop159      # 2: down to label6
# BB#27:                                # %if.end3.i391.1
	i32.load8_u	$0=, 321($10)
	i32.const	$push599=, 0
	i32.const	$push160=, 1
	i32.store	$discard=, bar.lastc($pop599), $pop160
	i32.const	$push161=, 57
	i32.ne  	$push162=, $0, $pop161
	br_if   	2, $pop162      # 2: down to label6
# BB#28:                                # %if.end3.i391.2
	i32.load8_u	$0=, 322($10)
	i32.const	$push600=, 0
	i32.const	$push163=, 2
	i32.store	$discard=, bar.lastc($pop600), $pop163
	i32.const	$push164=, 58
	i32.ne  	$push165=, $0, $pop164
	br_if   	2, $pop165      # 2: down to label6
# BB#29:                                # %if.end3.i391.3
	i32.load8_u	$0=, 323($10)
	i32.const	$push601=, 0
	i32.const	$push166=, 3
	i32.store	$discard=, bar.lastc($pop601), $pop166
	i32.const	$push167=, 59
	i32.ne  	$push168=, $0, $pop167
	br_if   	2, $pop168      # 2: down to label6
# BB#30:                                # %if.end3.i391.4
	i32.load8_u	$0=, 324($10)
	i32.const	$push602=, 0
	i32.const	$push169=, 4
	i32.store	$discard=, bar.lastc($pop602), $pop169
	i32.const	$push170=, 60
	i32.ne  	$push171=, $0, $pop170
	br_if   	2, $pop171      # 2: down to label6
# BB#31:                                # %if.end3.i391.5
	i32.load8_u	$0=, 325($10)
	i32.const	$push603=, 0
	i32.const	$push172=, 5
	i32.store	$discard=, bar.lastc($pop603), $pop172
	i32.const	$push173=, 61
	i32.ne  	$push174=, $0, $pop173
	br_if   	2, $pop174      # 2: down to label6
# BB#32:                                # %if.end3.i391.6
	i32.load8_u	$0=, 326($10)
	i32.const	$push604=, 0
	i32.const	$push175=, 6
	i32.store	$discard=, bar.lastc($pop604), $pop175
	i32.const	$push176=, 62
	i32.ne  	$push177=, $0, $pop176
	br_if   	2, $pop177      # 2: down to label6
# BB#33:                                # %if.end3.i405
	i32.const	$push181=, 40
	i32.add 	$push182=, $9, $pop181
	i64.load	$4=, 0($pop182):p2align=0
	i32.const	$push179=, 0
	i32.const	$push178=, 7
	i32.store	$discard=, bar.lastc($pop179), $pop178
	i64.store	$discard=, 312($10), $4
	i32.const	$push466=, 0
	i32.const	$push465=, 0
	i32.store	$0=, bar.lastc($pop466), $pop465
	i32.load8_s	$1=, 312($10)
	i32.const	$push183=, 8
	i32.store	$discard=, bar.lastn($0), $pop183
	i32.const	$push180=, 48
	i32.add 	$push4=, $9, $pop180
	i32.store	$2=, 4($10), $pop4
	i32.const	$push184=, 64
	i32.ne  	$push185=, $1, $pop184
	br_if   	1, $pop185      # 1: down to label7
# BB#34:                                # %if.end3.i405.1
	i32.load8_s	$1=, 313($10)
	i32.const	$push27=, 1
	i32.store	$0=, bar.lastc($0), $pop27
	i32.const	$push186=, 65
	i32.ne  	$push187=, $1, $pop186
	br_if   	1, $pop187      # 1: down to label7
# BB#35:                                # %if.end3.i405.2
	i32.load8_s	$push188=, 314($10)
	i32.const	$push618=, 0
	i32.add 	$push28=, $0, $0
	i32.store	$push617=, bar.lastc($pop618), $pop28
	tee_local	$push616=, $0=, $pop617
	i32.const	$push615=, 64
	i32.or  	$push189=, $pop616, $pop615
	i32.ne  	$push190=, $pop188, $pop189
	br_if   	1, $pop190      # 1: down to label7
# BB#36:                                # %if.end3.i405.3
	i32.const	$push625=, 0
	i32.const	$push624=, 1
	i32.add 	$push29=, $0, $pop624
	i32.store	$push623=, bar.lastc($pop625), $pop29
	tee_local	$push622=, $0=, $pop623
	i32.const	$push621=, 24
	i32.shl 	$push192=, $pop622, $pop621
	i32.const	$push620=, 24
	i32.shr_s	$push193=, $pop192, $pop620
	i32.const	$push619=, 64
	i32.xor 	$push194=, $pop193, $pop619
	i32.load8_s	$push191=, 315($10)
	i32.ne  	$push195=, $pop194, $pop191
	br_if   	1, $pop195      # 1: down to label7
# BB#37:                                # %if.end3.i405.4
	i32.const	$push632=, 0
	i32.const	$push631=, 1
	i32.add 	$push30=, $0, $pop631
	i32.store	$push630=, bar.lastc($pop632), $pop30
	tee_local	$push629=, $0=, $pop630
	i32.const	$push628=, 24
	i32.shl 	$push197=, $pop629, $pop628
	i32.const	$push627=, 24
	i32.shr_s	$push198=, $pop197, $pop627
	i32.const	$push626=, 64
	i32.xor 	$push199=, $pop198, $pop626
	i32.load8_s	$push196=, 316($10)
	i32.ne  	$push200=, $pop199, $pop196
	br_if   	1, $pop200      # 1: down to label7
# BB#38:                                # %if.end3.i405.5
	i32.const	$push639=, 0
	i32.const	$push638=, 1
	i32.add 	$push31=, $0, $pop638
	i32.store	$push637=, bar.lastc($pop639), $pop31
	tee_local	$push636=, $0=, $pop637
	i32.const	$push635=, 24
	i32.shl 	$push202=, $pop636, $pop635
	i32.const	$push634=, 24
	i32.shr_s	$push203=, $pop202, $pop634
	i32.const	$push633=, 64
	i32.xor 	$push204=, $pop203, $pop633
	i32.load8_s	$push201=, 317($10)
	i32.ne  	$push205=, $pop204, $pop201
	br_if   	1, $pop205      # 1: down to label7
# BB#39:                                # %if.end3.i405.6
	i32.const	$push646=, 0
	i32.const	$push645=, 1
	i32.add 	$push32=, $0, $pop645
	i32.store	$push644=, bar.lastc($pop646), $pop32
	tee_local	$push643=, $0=, $pop644
	i32.const	$push642=, 24
	i32.shl 	$push207=, $pop643, $pop642
	i32.const	$push641=, 24
	i32.shr_s	$push208=, $pop207, $pop641
	i32.const	$push640=, 64
	i32.xor 	$push209=, $pop208, $pop640
	i32.load8_s	$push206=, 318($10)
	i32.ne  	$push210=, $pop209, $pop206
	br_if   	1, $pop210      # 1: down to label7
# BB#40:                                # %if.end3.i405.7
	i32.const	$push652=, 0
	i32.const	$push651=, 1
	i32.add 	$push33=, $0, $pop651
	i32.store	$push650=, bar.lastc($pop652), $pop33
	tee_local	$push649=, $0=, $pop650
	i32.const	$push212=, 24
	i32.shl 	$push213=, $pop649, $pop212
	i32.const	$push648=, 24
	i32.shr_s	$push214=, $pop213, $pop648
	i32.const	$push647=, 64
	i32.xor 	$push215=, $pop214, $pop647
	i32.load8_s	$push211=, 319($10)
	i32.ne  	$push216=, $pop215, $pop211
	br_if   	1, $pop216      # 1: down to label7
# BB#41:                                # %bar.exit408.7
	i32.const	$push217=, 0
	i32.const	$push655=, 1
	i32.add 	$push34=, $0, $pop655
	i32.store	$0=, bar.lastc($pop217), $pop34
	i32.const	$push218=, 60
	i32.add 	$push35=, $9, $pop218
	i32.store	$5=, 4($10), $pop35
	i32.const	$1=, 8
	i32.const	$push222=, 4
	i32.add 	$push223=, $2, $pop222
	i32.load	$8=, 0($pop223):p2align=0
	i32.load	$3=, 0($2):p2align=0
	i32.const	$push663=, 296
	i32.add 	$push664=, $10, $pop663
	i32.const	$push654=, 8
	i32.add 	$push221=, $pop664, $pop654
	i32.const	$push653=, 8
	i32.add 	$push219=, $2, $pop653
	i32.load8_u	$push220=, 0($pop219)
	i32.store8	$discard=, 0($pop221), $pop220
	i32.store	$discard=, 300($10), $8
	i32.store	$discard=, 296($10), $3
	i32.const	$8=, 8
	i32.const	$2=, 0
.LBB1_42:                               # %for.body104
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.const	$push665=, 296
	i32.add 	$push666=, $10, $pop665
	i32.add 	$push224=, $pop666, $2
	i32.load8_s	$3=, 0($pop224)
	block
	i32.const	$push467=, 9
	i32.eq  	$push225=, $8, $pop467
	br_if   	0, $pop225      # 0: down to label12
# BB#43:                                # %if.then.i412
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.ne  	$push226=, $0, $8
	br_if   	3, $pop226      # 3: down to label8
# BB#44:                                # %if.end.i414
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.const	$push228=, 0
	i32.const	$push468=, 0
	i32.store	$0=, bar.lastc($pop228), $pop468
	i32.const	$push227=, 9
	i32.store	$1=, bar.lastn($0), $pop227
.LBB1_45:                               # %if.end3.i419
                                        #   in Loop: Header=BB1_42 Depth=1
	end_block                       # label12:
	i32.const	$push471=, 24
	i32.shl 	$push229=, $0, $pop471
	i32.const	$push470=, 24
	i32.shr_s	$push230=, $pop229, $pop470
	i32.const	$push469=, 72
	i32.xor 	$push231=, $pop230, $pop469
	i32.ne  	$push232=, $pop231, $3
	br_if   	2, $pop232      # 2: down to label8
# BB#46:                                # %bar.exit422
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.const	$push475=, 0
	i32.const	$push474=, 1
	i32.add 	$push5=, $0, $pop474
	i32.store	$0=, bar.lastc($pop475), $pop5
	i32.const	$push473=, 1
	i32.add 	$2=, $2, $pop473
	i32.const	$8=, 9
	i32.const	$push472=, 9
	i32.lt_s	$push233=, $2, $pop472
	br_if   	0, $pop233      # 0: up to label10
# BB#47:                                # %for.end110
	end_loop                        # label11:
	i32.const	$push234=, 72
	i32.add 	$push6=, $9, $pop234
	i32.store	$7=, 4($10), $pop6
	i32.const	$push239=, 4
	i32.add 	$push240=, $5, $pop239
	i32.load	$2=, 0($pop240):p2align=0
	i32.load	$8=, 0($5):p2align=0
	i32.const	$push667=, 280
	i32.add 	$push668=, $10, $pop667
	i32.const	$push235=, 8
	i32.add 	$push238=, $pop668, $pop235
	i32.const	$push476=, 8
	i32.add 	$push236=, $5, $pop476
	i32.load16_u	$push237=, 0($pop236):p2align=0
	i32.store16	$discard=, 0($pop238), $pop237
	i32.store	$discard=, 284($10), $2
	i32.store	$discard=, 280($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_48:                               # %for.body116
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$push669=, 280
	i32.add 	$push670=, $10, $pop669
	i32.add 	$push241=, $pop670, $2
	i32.load8_s	$3=, 0($pop241)
	block
	i32.const	$push477=, 10
	i32.eq  	$push242=, $8, $pop477
	br_if   	0, $pop242      # 0: down to label15
# BB#49:                                # %if.then.i426
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.ne  	$push243=, $0, $8
	br_if   	3, $pop243      # 3: down to label8
# BB#50:                                # %if.end.i428
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.const	$push245=, 0
	i32.const	$push478=, 0
	i32.store	$0=, bar.lastc($pop245), $pop478
	i32.const	$push244=, 10
	i32.store	$1=, bar.lastn($0), $pop244
.LBB1_51:                               # %if.end3.i433
                                        #   in Loop: Header=BB1_48 Depth=1
	end_block                       # label15:
	i32.const	$push481=, 24
	i32.shl 	$push246=, $0, $pop481
	i32.const	$push480=, 24
	i32.shr_s	$push247=, $pop246, $pop480
	i32.const	$push479=, 80
	i32.xor 	$push248=, $pop247, $pop479
	i32.ne  	$push249=, $pop248, $3
	br_if   	2, $pop249      # 2: down to label8
# BB#52:                                # %bar.exit436
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.const	$push485=, 0
	i32.const	$push484=, 1
	i32.add 	$push7=, $0, $pop484
	i32.store	$0=, bar.lastc($pop485), $pop7
	i32.const	$push483=, 1
	i32.add 	$2=, $2, $pop483
	i32.const	$8=, 10
	i32.const	$push482=, 10
	i32.lt_s	$push250=, $2, $pop482
	br_if   	0, $pop250      # 0: up to label13
# BB#53:                                # %for.end122
	end_loop                        # label14:
	i32.const	$push671=, 264
	i32.add 	$push672=, $10, $pop671
	i32.const	$push252=, 10
	i32.add 	$push255=, $pop672, $pop252
	i32.const	$push487=, 10
	i32.add 	$push253=, $7, $pop487
	i32.load8_u	$push254=, 0($pop253)
	i32.store8	$discard=, 0($pop255), $pop254
	i32.const	$push251=, 84
	i32.add 	$push8=, $9, $pop251
	i32.store	$5=, 4($10), $pop8
	i32.const	$push260=, 4
	i32.add 	$push261=, $7, $pop260
	i32.load	$2=, 0($pop261):p2align=0
	i32.load	$8=, 0($7):p2align=0
	i32.const	$push673=, 264
	i32.add 	$push674=, $10, $pop673
	i32.const	$push256=, 8
	i32.add 	$push259=, $pop674, $pop256
	i32.const	$push486=, 8
	i32.add 	$push257=, $7, $pop486
	i32.load16_u	$push258=, 0($pop257):p2align=0
	i32.store16	$discard=, 0($pop259), $pop258
	i32.store	$discard=, 268($10), $2
	i32.store	$discard=, 264($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_54:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$push675=, 264
	i32.add 	$push676=, $10, $pop675
	i32.add 	$push262=, $pop676, $2
	i32.load8_s	$3=, 0($pop262)
	block
	i32.const	$push488=, 11
	i32.eq  	$push263=, $8, $pop488
	br_if   	0, $pop263      # 0: down to label18
# BB#55:                                # %if.then.i440
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.ne  	$push264=, $0, $8
	br_if   	3, $pop264      # 3: down to label8
# BB#56:                                # %if.end.i442
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.const	$push266=, 0
	i32.const	$push489=, 0
	i32.store	$0=, bar.lastc($pop266), $pop489
	i32.const	$push265=, 11
	i32.store	$1=, bar.lastn($0), $pop265
.LBB1_57:                               # %if.end3.i447
                                        #   in Loop: Header=BB1_54 Depth=1
	end_block                       # label18:
	i32.const	$push492=, 24
	i32.shl 	$push267=, $0, $pop492
	i32.const	$push491=, 24
	i32.shr_s	$push268=, $pop267, $pop491
	i32.const	$push490=, 88
	i32.xor 	$push269=, $pop268, $pop490
	i32.ne  	$push270=, $pop269, $3
	br_if   	2, $pop270      # 2: down to label8
# BB#58:                                # %bar.exit450
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.const	$push496=, 0
	i32.const	$push495=, 1
	i32.add 	$push9=, $0, $pop495
	i32.store	$0=, bar.lastc($pop496), $pop9
	i32.const	$push494=, 1
	i32.add 	$2=, $2, $pop494
	i32.const	$8=, 11
	i32.const	$push493=, 11
	i32.lt_s	$push271=, $2, $pop493
	br_if   	0, $pop271      # 0: up to label16
# BB#59:                                # %for.end134
	end_loop                        # label17:
	i32.const	$push498=, 96
	i32.add 	$push10=, $9, $pop498
	i32.store	$7=, 4($10), $pop10
	i32.const	$push276=, 4
	i32.add 	$push277=, $5, $pop276
	i32.load	$2=, 0($pop277):p2align=0
	i32.load	$8=, 0($5):p2align=0
	i32.const	$push677=, 248
	i32.add 	$push678=, $10, $pop677
	i32.const	$push272=, 8
	i32.add 	$push275=, $pop678, $pop272
	i32.const	$push497=, 8
	i32.add 	$push273=, $5, $pop497
	i32.load	$push274=, 0($pop273):p2align=0
	i32.store	$discard=, 0($pop275), $pop274
	i32.store	$discard=, 252($10), $2
	i32.store	$discard=, 248($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_60:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push679=, 248
	i32.add 	$push680=, $10, $pop679
	i32.add 	$push278=, $pop680, $2
	i32.load8_s	$3=, 0($pop278)
	block
	i32.const	$push499=, 12
	i32.eq  	$push279=, $8, $pop499
	br_if   	0, $pop279      # 0: down to label21
# BB#61:                                # %if.then.i454
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.ne  	$push280=, $0, $8
	br_if   	3, $pop280      # 3: down to label8
# BB#62:                                # %if.end.i456
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.const	$push282=, 0
	i32.const	$push500=, 0
	i32.store	$0=, bar.lastc($pop282), $pop500
	i32.const	$push281=, 12
	i32.store	$1=, bar.lastn($0), $pop281
.LBB1_63:                               # %if.end3.i461
                                        #   in Loop: Header=BB1_60 Depth=1
	end_block                       # label21:
	i32.const	$push503=, 24
	i32.shl 	$push283=, $0, $pop503
	i32.const	$push502=, 24
	i32.shr_s	$push284=, $pop283, $pop502
	i32.const	$push501=, 96
	i32.xor 	$push285=, $pop284, $pop501
	i32.ne  	$push286=, $pop285, $3
	br_if   	2, $pop286      # 2: down to label8
# BB#64:                                # %bar.exit464
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.const	$push507=, 0
	i32.const	$push506=, 1
	i32.add 	$push11=, $0, $pop506
	i32.store	$0=, bar.lastc($pop507), $pop11
	i32.const	$push505=, 1
	i32.add 	$2=, $2, $pop505
	i32.const	$8=, 12
	i32.const	$push504=, 12
	i32.lt_s	$push287=, $2, $pop504
	br_if   	0, $pop287      # 0: up to label19
# BB#65:                                # %for.end146
	end_loop                        # label20:
	i32.const	$push681=, 232
	i32.add 	$push682=, $10, $pop681
	i32.const	$push289=, 12
	i32.add 	$push292=, $pop682, $pop289
	i32.const	$push509=, 12
	i32.add 	$push290=, $7, $pop509
	i32.load8_u	$push291=, 0($pop290)
	i32.store8	$discard=, 0($pop292), $pop291
	i32.const	$push288=, 112
	i32.add 	$push12=, $9, $pop288
	i32.store	$5=, 4($10), $pop12
	i32.const	$push297=, 4
	i32.add 	$push298=, $7, $pop297
	i32.load	$2=, 0($pop298):p2align=0
	i32.load	$8=, 0($7):p2align=0
	i32.const	$push683=, 232
	i32.add 	$push684=, $10, $pop683
	i32.const	$push293=, 8
	i32.add 	$push296=, $pop684, $pop293
	i32.const	$push508=, 8
	i32.add 	$push294=, $7, $pop508
	i32.load	$push295=, 0($pop294):p2align=0
	i32.store	$discard=, 0($pop296), $pop295
	i32.store	$discard=, 236($10), $2
	i32.store	$discard=, 232($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_66:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.const	$push685=, 232
	i32.add 	$push686=, $10, $pop685
	i32.add 	$push299=, $pop686, $2
	i32.load8_s	$3=, 0($pop299)
	block
	i32.const	$push510=, 13
	i32.eq  	$push300=, $8, $pop510
	br_if   	0, $pop300      # 0: down to label24
# BB#67:                                # %if.then.i468
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.ne  	$push301=, $0, $8
	br_if   	3, $pop301      # 3: down to label8
# BB#68:                                # %if.end.i470
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.const	$push303=, 0
	i32.const	$push511=, 0
	i32.store	$0=, bar.lastc($pop303), $pop511
	i32.const	$push302=, 13
	i32.store	$1=, bar.lastn($0), $pop302
.LBB1_69:                               # %if.end3.i475
                                        #   in Loop: Header=BB1_66 Depth=1
	end_block                       # label24:
	i32.const	$push514=, 24
	i32.shl 	$push304=, $0, $pop514
	i32.const	$push513=, 24
	i32.shr_s	$push305=, $pop304, $pop513
	i32.const	$push512=, 104
	i32.xor 	$push306=, $pop305, $pop512
	i32.ne  	$push307=, $pop306, $3
	br_if   	2, $pop307      # 2: down to label8
# BB#70:                                # %bar.exit478
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.const	$push518=, 0
	i32.const	$push517=, 1
	i32.add 	$push13=, $0, $pop517
	i32.store	$0=, bar.lastc($pop518), $pop13
	i32.const	$push516=, 1
	i32.add 	$2=, $2, $pop516
	i32.const	$8=, 13
	i32.const	$push515=, 13
	i32.lt_s	$push308=, $2, $pop515
	br_if   	0, $pop308      # 0: up to label22
# BB#71:                                # %for.end158
	end_loop                        # label23:
	i32.const	$push687=, 216
	i32.add 	$push688=, $10, $pop687
	i32.const	$push310=, 12
	i32.add 	$push313=, $pop688, $pop310
	i32.const	$push520=, 12
	i32.add 	$push311=, $5, $pop520
	i32.load16_u	$push312=, 0($pop311):p2align=0
	i32.store16	$discard=, 0($pop313), $pop312
	i32.const	$push309=, 128
	i32.add 	$push14=, $9, $pop309
	i32.store	$7=, 4($10), $pop14
	i32.const	$push318=, 4
	i32.add 	$push319=, $5, $pop318
	i32.load	$2=, 0($pop319):p2align=0
	i32.load	$8=, 0($5):p2align=0
	i32.const	$push689=, 216
	i32.add 	$push690=, $10, $pop689
	i32.const	$push314=, 8
	i32.add 	$push317=, $pop690, $pop314
	i32.const	$push519=, 8
	i32.add 	$push315=, $5, $pop519
	i32.load	$push316=, 0($pop315):p2align=0
	i32.store	$discard=, 0($pop317), $pop316
	i32.store	$discard=, 220($10), $2
	i32.store	$discard=, 216($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_72:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$push691=, 216
	i32.add 	$push692=, $10, $pop691
	i32.add 	$push320=, $pop692, $2
	i32.load8_s	$3=, 0($pop320)
	block
	i32.const	$push521=, 14
	i32.eq  	$push321=, $8, $pop521
	br_if   	0, $pop321      # 0: down to label27
# BB#73:                                # %if.then.i482
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.ne  	$push322=, $0, $8
	br_if   	3, $pop322      # 3: down to label8
# BB#74:                                # %if.end.i484
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.const	$push324=, 0
	i32.const	$push522=, 0
	i32.store	$0=, bar.lastc($pop324), $pop522
	i32.const	$push323=, 14
	i32.store	$1=, bar.lastn($0), $pop323
.LBB1_75:                               # %if.end3.i489
                                        #   in Loop: Header=BB1_72 Depth=1
	end_block                       # label27:
	i32.const	$push525=, 24
	i32.shl 	$push325=, $0, $pop525
	i32.const	$push524=, 24
	i32.shr_s	$push326=, $pop325, $pop524
	i32.const	$push523=, 112
	i32.xor 	$push327=, $pop326, $pop523
	i32.ne  	$push328=, $pop327, $3
	br_if   	2, $pop328      # 2: down to label8
# BB#76:                                # %bar.exit492
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.const	$push529=, 0
	i32.const	$push528=, 1
	i32.add 	$push15=, $0, $pop528
	i32.store	$0=, bar.lastc($pop529), $pop15
	i32.const	$push527=, 1
	i32.add 	$2=, $2, $pop527
	i32.const	$8=, 14
	i32.const	$push526=, 14
	i32.lt_s	$push329=, $2, $pop526
	br_if   	0, $pop329      # 0: up to label25
# BB#77:                                # %for.end170
	end_loop                        # label26:
	i32.const	$push335=, 12
	i32.add 	$push336=, $7, $pop335
	i32.load16_u	$2=, 0($pop336):p2align=0
	i32.const	$push693=, 200
	i32.add 	$push694=, $10, $pop693
	i32.const	$push331=, 14
	i32.add 	$push334=, $pop694, $pop331
	i32.const	$push532=, 14
	i32.add 	$push332=, $7, $pop532
	i32.load8_u	$push333=, 0($pop332)
	i32.store8	$discard=, 0($pop334), $pop333
	i32.const	$push695=, 200
	i32.add 	$push696=, $10, $pop695
	i32.const	$push531=, 12
	i32.add 	$push337=, $pop696, $pop531
	i32.store16	$discard=, 0($pop337), $2
	i32.const	$push330=, 144
	i32.add 	$push16=, $9, $pop330
	i32.store	$5=, 4($10), $pop16
	i32.const	$push342=, 4
	i32.add 	$push343=, $7, $pop342
	i32.load	$2=, 0($pop343):p2align=0
	i32.load	$8=, 0($7):p2align=0
	i32.const	$push697=, 200
	i32.add 	$push698=, $10, $pop697
	i32.const	$push338=, 8
	i32.add 	$push341=, $pop698, $pop338
	i32.const	$push530=, 8
	i32.add 	$push339=, $7, $pop530
	i32.load	$push340=, 0($pop339):p2align=0
	i32.store	$discard=, 0($pop341), $pop340
	i32.store	$discard=, 204($10), $2
	i32.store	$discard=, 200($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_78:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	i32.const	$push699=, 200
	i32.add 	$push700=, $10, $pop699
	i32.add 	$push344=, $pop700, $2
	i32.load8_s	$3=, 0($pop344)
	block
	i32.const	$push533=, 15
	i32.eq  	$push345=, $8, $pop533
	br_if   	0, $pop345      # 0: down to label30
# BB#79:                                # %if.then.i496
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.ne  	$push346=, $0, $8
	br_if   	3, $pop346      # 3: down to label8
# BB#80:                                # %if.end.i498
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.const	$push348=, 0
	i32.const	$push534=, 0
	i32.store	$0=, bar.lastc($pop348), $pop534
	i32.const	$push347=, 15
	i32.store	$1=, bar.lastn($0), $pop347
.LBB1_81:                               # %if.end3.i503
                                        #   in Loop: Header=BB1_78 Depth=1
	end_block                       # label30:
	i32.const	$push537=, 24
	i32.shl 	$push349=, $0, $pop537
	i32.const	$push536=, 24
	i32.shr_s	$push350=, $pop349, $pop536
	i32.const	$push535=, 120
	i32.xor 	$push351=, $pop350, $pop535
	i32.ne  	$push352=, $pop351, $3
	br_if   	2, $pop352      # 2: down to label8
# BB#82:                                # %bar.exit506
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.const	$push541=, 0
	i32.const	$push540=, 1
	i32.add 	$push17=, $0, $pop540
	i32.store	$0=, bar.lastc($pop541), $pop17
	i32.const	$push539=, 1
	i32.add 	$2=, $2, $pop539
	i32.const	$8=, 15
	i32.const	$push538=, 15
	i32.lt_s	$push353=, $2, $pop538
	br_if   	0, $pop353      # 0: up to label28
# BB#83:                                # %for.end182
	end_loop                        # label29:
	i32.const	$push701=, 184
	i32.add 	$push702=, $10, $pop701
	i32.const	$push355=, 12
	i32.add 	$push358=, $pop702, $pop355
	i32.const	$push543=, 12
	i32.add 	$push356=, $5, $pop543
	i32.load	$push357=, 0($pop356):p2align=0
	i32.store	$discard=, 0($pop358), $pop357
	i32.const	$push354=, 160
	i32.add 	$push18=, $9, $pop354
	i32.store	$6=, 4($10), $pop18
	i32.const	$push363=, 4
	i32.add 	$push364=, $5, $pop363
	i32.load	$2=, 0($pop364):p2align=0
	i32.load	$8=, 0($5):p2align=0
	i32.const	$push703=, 184
	i32.add 	$push704=, $10, $pop703
	i32.const	$push359=, 8
	i32.add 	$push362=, $pop704, $pop359
	i32.const	$push542=, 8
	i32.add 	$push360=, $5, $pop542
	i32.load	$push361=, 0($pop360):p2align=0
	i32.store	$discard=, 0($pop362), $pop361
	i32.store	$discard=, 188($10), $2
	i32.store	$discard=, 184($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_84:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push705=, 184
	i32.add 	$push706=, $10, $pop705
	i32.add 	$push365=, $pop706, $2
	i32.load8_s	$3=, 0($pop365)
	block
	i32.const	$push544=, 16
	i32.eq  	$push366=, $8, $pop544
	br_if   	0, $pop366      # 0: down to label33
# BB#85:                                # %if.then.i510
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.ne  	$push367=, $0, $8
	br_if   	3, $pop367      # 3: down to label8
# BB#86:                                # %if.end.i512
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.const	$push369=, 0
	i32.const	$push545=, 0
	i32.store	$0=, bar.lastc($pop369), $pop545
	i32.const	$push368=, 16
	i32.store	$1=, bar.lastn($0), $pop368
.LBB1_87:                               # %if.end3.i517
                                        #   in Loop: Header=BB1_84 Depth=1
	end_block                       # label33:
	i32.const	$push548=, 24
	i32.shl 	$push370=, $0, $pop548
	i32.const	$push547=, -2147483648
	i32.xor 	$push371=, $pop370, $pop547
	i32.const	$push546=, 24
	i32.shr_s	$push372=, $pop371, $pop546
	i32.ne  	$push373=, $pop372, $3
	br_if   	2, $pop373      # 2: down to label8
# BB#88:                                # %bar.exit520
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.const	$push552=, 0
	i32.const	$push551=, 1
	i32.add 	$push19=, $0, $pop551
	i32.store	$0=, bar.lastc($pop552), $pop19
	i32.const	$push550=, 1
	i32.add 	$2=, $2, $pop550
	i32.const	$8=, 16
	i32.const	$push549=, 16
	i32.lt_s	$push374=, $2, $pop549
	br_if   	0, $pop374      # 0: up to label31
# BB#89:                                # %for.end194
	end_loop                        # label32:
	i32.const	$push375=, 192
	i32.add 	$push20=, $9, $pop375
	i32.store	$7=, 4($10), $pop20
	i32.const	$push707=, 152
	i32.add 	$push708=, $10, $pop707
	i32.const	$push553=, 31
	i32.call	$discard=, memcpy@FUNCTION, $pop708, $6, $pop553
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_90:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label34:
	i32.const	$push709=, 152
	i32.add 	$push710=, $10, $pop709
	i32.add 	$push376=, $pop710, $2
	i32.load8_s	$3=, 0($pop376)
	block
	i32.const	$push554=, 31
	i32.eq  	$push377=, $8, $pop554
	br_if   	0, $pop377      # 0: down to label36
# BB#91:                                # %if.then.i524
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.ne  	$push378=, $0, $8
	br_if   	3, $pop378      # 3: down to label8
# BB#92:                                # %if.end.i526
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.const	$push380=, 0
	i32.const	$push555=, 0
	i32.store	$0=, bar.lastc($pop380), $pop555
	i32.const	$push379=, 31
	i32.store	$1=, bar.lastn($0), $pop379
.LBB1_93:                               # %if.end3.i531
                                        #   in Loop: Header=BB1_90 Depth=1
	end_block                       # label36:
	i32.const	$push558=, 24
	i32.shl 	$push381=, $0, $pop558
	i32.const	$push557=, -134217728
	i32.xor 	$push382=, $pop381, $pop557
	i32.const	$push556=, 24
	i32.shr_s	$push383=, $pop382, $pop556
	i32.ne  	$push384=, $pop383, $3
	br_if   	2, $pop384      # 2: down to label8
# BB#94:                                # %bar.exit534
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.const	$push562=, 0
	i32.const	$push561=, 1
	i32.add 	$push21=, $0, $pop561
	i32.store	$0=, bar.lastc($pop562), $pop21
	i32.const	$push560=, 1
	i32.add 	$2=, $2, $pop560
	i32.const	$8=, 31
	i32.const	$push559=, 31
	i32.lt_s	$push385=, $2, $pop559
	br_if   	0, $pop385      # 0: up to label34
# BB#95:                                # %for.end206
	end_loop                        # label35:
	i32.const	$push711=, 120
	i32.add 	$push712=, $10, $pop711
	i32.const	$push387=, 28
	i32.add 	$push390=, $pop712, $pop387
	i32.const	$push569=, 28
	i32.add 	$push388=, $7, $pop569
	i32.load	$push389=, 0($pop388):p2align=0
	i32.store	$discard=, 0($pop390), $pop389
	i32.const	$push394=, 20
	i32.add 	$push395=, $7, $pop394
	i32.load	$2=, 0($pop395):p2align=0
	i32.const	$push713=, 120
	i32.add 	$push714=, $10, $pop713
	i32.const	$push568=, 24
	i32.add 	$push393=, $pop714, $pop568
	i32.const	$push567=, 24
	i32.add 	$push391=, $7, $pop567
	i32.load	$push392=, 0($pop391):p2align=0
	i32.store	$discard=, 0($pop393), $pop392
	i32.const	$push715=, 120
	i32.add 	$push716=, $10, $pop715
	i32.const	$push566=, 20
	i32.add 	$push396=, $pop716, $pop566
	i32.store	$discard=, 0($pop396), $2
	i32.const	$push401=, 12
	i32.add 	$push402=, $7, $pop401
	i32.load	$2=, 0($pop402):p2align=0
	i32.const	$push717=, 120
	i32.add 	$push718=, $10, $pop717
	i32.const	$push397=, 16
	i32.add 	$push400=, $pop718, $pop397
	i32.const	$push565=, 16
	i32.add 	$push398=, $7, $pop565
	i32.load	$push399=, 0($pop398):p2align=0
	i32.store	$discard=, 0($pop400), $pop399
	i32.const	$push719=, 120
	i32.add 	$push720=, $10, $pop719
	i32.const	$push564=, 12
	i32.add 	$push403=, $pop720, $pop564
	i32.store	$discard=, 0($pop403), $2
	i32.const	$push386=, 224
	i32.add 	$push22=, $9, $pop386
	i32.store	$5=, 4($10), $pop22
	i32.const	$push408=, 4
	i32.add 	$push409=, $7, $pop408
	i32.load	$2=, 0($pop409):p2align=0
	i32.load	$8=, 0($7):p2align=0
	i32.const	$push721=, 120
	i32.add 	$push722=, $10, $pop721
	i32.const	$push404=, 8
	i32.add 	$push407=, $pop722, $pop404
	i32.const	$push563=, 8
	i32.add 	$push405=, $7, $pop563
	i32.load	$push406=, 0($pop405):p2align=0
	i32.store	$discard=, 0($pop407), $pop406
	i32.store	$discard=, 124($10), $2
	i32.store	$discard=, 120($10), $8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_96:                               # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label37:
	i32.const	$push723=, 120
	i32.add 	$push724=, $10, $pop723
	i32.add 	$push410=, $pop724, $2
	i32.load8_s	$3=, 0($pop410)
	block
	i32.const	$push570=, 32
	i32.eq  	$push411=, $8, $pop570
	br_if   	0, $pop411      # 0: down to label39
# BB#97:                                # %if.then.i538
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.ne  	$push412=, $0, $8
	br_if   	3, $pop412      # 3: down to label8
# BB#98:                                # %if.end.i540
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.const	$push414=, 0
	i32.const	$push571=, 0
	i32.store	$0=, bar.lastc($pop414), $pop571
	i32.const	$push413=, 32
	i32.store	$1=, bar.lastn($0), $pop413
.LBB1_99:                               # %if.end3.i545
                                        #   in Loop: Header=BB1_96 Depth=1
	end_block                       # label39:
	i32.const	$push573=, 24
	i32.shl 	$push415=, $0, $pop573
	i32.const	$push572=, 24
	i32.shr_s	$push416=, $pop415, $pop572
	i32.ne  	$push417=, $pop416, $3
	br_if   	2, $pop417      # 2: down to label8
# BB#100:                               # %bar.exit548
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.const	$push577=, 0
	i32.const	$push576=, 1
	i32.add 	$push23=, $0, $pop576
	i32.store	$0=, bar.lastc($pop577), $pop23
	i32.const	$push575=, 1
	i32.add 	$2=, $2, $pop575
	i32.const	$8=, 32
	i32.const	$push574=, 32
	i32.lt_s	$push418=, $2, $pop574
	br_if   	0, $pop418      # 0: up to label37
# BB#101:                               # %for.end218
	end_loop                        # label38:
	i32.const	$push419=, 260
	i32.add 	$push24=, $9, $pop419
	i32.store	$7=, 4($10), $pop24
	i32.const	$push725=, 80
	i32.add 	$push726=, $10, $pop725
	i32.const	$push578=, 35
	i32.call	$discard=, memcpy@FUNCTION, $pop726, $5, $pop578
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_102:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label40:
	i32.const	$push727=, 80
	i32.add 	$push728=, $10, $pop727
	i32.add 	$push420=, $pop728, $2
	i32.load8_s	$3=, 0($pop420)
	block
	i32.const	$push579=, 35
	i32.eq  	$push421=, $8, $pop579
	br_if   	0, $pop421      # 0: down to label42
# BB#103:                               # %if.then.i552
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.ne  	$push422=, $0, $8
	br_if   	3, $pop422      # 3: down to label8
# BB#104:                               # %if.end.i554
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.const	$push424=, 0
	i32.const	$push580=, 0
	i32.store	$0=, bar.lastc($pop424), $pop580
	i32.const	$push423=, 35
	i32.store	$1=, bar.lastn($0), $pop423
.LBB1_105:                              # %if.end3.i559
                                        #   in Loop: Header=BB1_102 Depth=1
	end_block                       # label42:
	i32.const	$push583=, 24
	i32.shl 	$push425=, $0, $pop583
	i32.const	$push582=, 24
	i32.shr_s	$push426=, $pop425, $pop582
	i32.const	$push581=, 24
	i32.xor 	$push427=, $pop426, $pop581
	i32.ne  	$push428=, $pop427, $3
	br_if   	2, $pop428      # 2: down to label8
# BB#106:                               # %bar.exit562
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.const	$push587=, 0
	i32.const	$push586=, 1
	i32.add 	$push25=, $0, $pop586
	i32.store	$0=, bar.lastc($pop587), $pop25
	i32.const	$push585=, 1
	i32.add 	$2=, $2, $pop585
	i32.const	$8=, 35
	i32.const	$push584=, 35
	i32.lt_s	$push429=, $2, $pop584
	br_if   	0, $pop429      # 0: up to label40
# BB#107:                               # %for.end230
	end_loop                        # label41:
	i32.const	$push430=, 332
	i32.add 	$push431=, $9, $pop430
	i32.store	$discard=, 4($10), $pop431
	i32.const	$push729=, 8
	i32.add 	$push730=, $10, $pop729
	i32.const	$push588=, 72
	i32.call	$discard=, memcpy@FUNCTION, $pop730, $7, $pop588
	i32.const	$2=, 0
.LBB1_108:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label43:
	i32.const	$push731=, 8
	i32.add 	$push732=, $10, $pop731
	i32.add 	$push432=, $pop732, $2
	i32.load8_s	$8=, 0($pop432)
	block
	i32.const	$push589=, 72
	i32.eq  	$push433=, $1, $pop589
	br_if   	0, $pop433      # 0: down to label45
# BB#109:                               # %if.then.i566
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.ne  	$push434=, $0, $1
	br_if   	3, $pop434      # 3: down to label8
# BB#110:                               # %if.end.i568
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.const	$push435=, 0
	i32.const	$push591=, 0
	i32.store	$0=, bar.lastc($pop435), $pop591
	i32.const	$push590=, 72
	i32.store	$discard=, bar.lastn($0), $pop590
.LBB1_111:                              # %if.end3.i573
                                        #   in Loop: Header=BB1_108 Depth=1
	end_block                       # label45:
	i32.const	$push594=, 24
	i32.shl 	$push436=, $0, $pop594
	i32.const	$push593=, 24
	i32.shr_s	$push437=, $pop436, $pop593
	i32.const	$push592=, 64
	i32.xor 	$push438=, $pop437, $pop592
	i32.ne  	$push439=, $pop438, $8
	br_if   	2, $pop439      # 2: down to label8
# BB#112:                               # %bar.exit576
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.const	$push598=, 0
	i32.const	$push597=, 1
	i32.add 	$push26=, $0, $pop597
	i32.store	$0=, bar.lastc($pop598), $pop26
	i32.const	$push596=, 1
	i32.add 	$2=, $2, $pop596
	i32.const	$1=, 72
	i32.const	$push595=, 72
	i32.lt_s	$push440=, $2, $pop595
	br_if   	0, $pop440      # 0: up to label43
# BB#113:                               # %for.end242
	end_loop                        # label44:
	i32.const	$push662=, __stack_pointer
	i32.const	$push660=, 352
	i32.add 	$push661=, $10, $pop660
	i32.store	$discard=, 0($pop662), $pop661
	return
.LBB1_114:                              # %if.then7.i322
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_115:                              # %if.then7.i406
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_116:                              # %if.then7.i392
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_117:                              # %if.then7.i378
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_118:                              # %if.then7.i364
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_119:                              # %if.then7.i350
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_120:                              # %if.then7.i336
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push323=, __stack_pointer
	i32.load	$push324=, 0($pop323)
	i32.const	$push325=, 768
	i32.sub 	$2=, $pop324, $pop325
	i32.const	$push326=, __stack_pointer
	i32.store	$discard=, 0($pop326), $2
	i32.const	$push0=, 4368
	i32.store16	$discard=, 760($2), $pop0
	i32.const	$push1=, 24
	i32.store8	$discard=, 752($2), $pop1
	i32.const	$push2=, 25
	i32.store8	$discard=, 753($2), $pop2
	i32.const	$push3=, 26
	i32.store8	$discard=, 754($2), $pop3
	i32.const	$push4=, 32
	i32.store8	$discard=, 744($2), $pop4
	i32.const	$push5=, 33
	i32.store8	$discard=, 745($2), $pop5
	i32.const	$push6=, 34
	i32.store8	$discard=, 746($2), $pop6
	i32.const	$push7=, 35
	i32.store8	$discard=, 747($2), $pop7
	i32.const	$push8=, 40
	i32.store8	$discard=, 736($2), $pop8
	i32.const	$push9=, 41
	i32.store8	$discard=, 737($2), $pop9
	i32.const	$push10=, 42
	i32.store8	$discard=, 738($2), $pop10
	i32.const	$push11=, 43
	i32.store8	$discard=, 739($2), $pop11
	i32.const	$push12=, 44
	i32.store8	$discard=, 740($2), $pop12
	i32.const	$push13=, 48
	i32.store8	$discard=, 728($2), $pop13
	i32.const	$push14=, 49
	i32.store8	$discard=, 729($2), $pop14
	i32.const	$push15=, 50
	i32.store8	$discard=, 730($2), $pop15
	i32.const	$push16=, 51
	i32.store8	$discard=, 731($2), $pop16
	i32.const	$push17=, 52
	i32.store8	$discard=, 732($2), $pop17
	i32.const	$push18=, 53
	i32.store8	$discard=, 733($2), $pop18
	i32.const	$push19=, 56
	i32.store8	$discard=, 720($2), $pop19
	i32.const	$push20=, 57
	i32.store8	$discard=, 721($2), $pop20
	i32.const	$push21=, 58
	i32.store8	$discard=, 722($2), $pop21
	i32.const	$push22=, 59
	i32.store8	$discard=, 723($2), $pop22
	i32.const	$push23=, 60
	i32.store8	$discard=, 724($2), $pop23
	i32.const	$push24=, 61
	i32.store8	$discard=, 725($2), $pop24
	i32.const	$push25=, 62
	i32.store8	$discard=, 726($2), $pop25
	i32.const	$push28=, 65
	i32.store8	$discard=, 713($2), $pop28
	i32.const	$push29=, 66
	i32.store8	$discard=, 714($2), $pop29
	i32.const	$push30=, 67
	i32.store8	$discard=, 715($2), $pop30
	i32.const	$push31=, 68
	i32.store8	$discard=, 716($2), $pop31
	i32.const	$push32=, 69
	i32.store8	$discard=, 717($2), $pop32
	i32.const	$push33=, 70
	i32.store8	$discard=, 718($2), $pop33
	i32.const	$push34=, 71
	i32.store8	$discard=, 719($2), $pop34
	i32.const	$push35=, 72
	i32.store8	$discard=, 696($2), $pop35
	i32.const	$push36=, 73
	i32.store8	$discard=, 697($2), $pop36
	i32.const	$push37=, 74
	i32.store8	$discard=, 698($2), $pop37
	i32.const	$push38=, 75
	i32.store8	$discard=, 699($2), $pop38
	i32.const	$push39=, 76
	i32.store8	$discard=, 700($2), $pop39
	i32.const	$push40=, 77
	i32.store8	$discard=, 701($2), $pop40
	i32.const	$push41=, 78
	i32.store8	$discard=, 702($2), $pop41
	i32.const	$push42=, 79
	i32.store8	$discard=, 703($2), $pop42
	i32.const	$push26=, 64
	i32.store8	$push27=, 712($2), $pop26
	i32.store8	$discard=, 704($2), $pop27
	i32.const	$push49=, 83
	i32.store8	$discard=, 683($2), $pop49
	i32.const	$push50=, 84
	i32.store8	$discard=, 684($2), $pop50
	i32.const	$push51=, 85
	i32.store8	$discard=, 685($2), $pop51
	i32.const	$push52=, 86
	i32.store8	$discard=, 686($2), $pop52
	i32.const	$push53=, 87
	i32.store8	$discard=, 687($2), $pop53
	i32.const	$push54=, 88
	i32.store8	$push55=, 688($2), $pop54
	i32.store8	$discard=, 664($2), $pop55
	i32.const	$push56=, 89
	i32.store8	$push57=, 689($2), $pop56
	i32.store8	$discard=, 665($2), $pop57
	i32.const	$push58=, 90
	i32.store8	$discard=, 666($2), $pop58
	i32.const	$push59=, 91
	i32.store8	$discard=, 667($2), $pop59
	i32.const	$push60=, 92
	i32.store8	$discard=, 668($2), $pop60
	i32.const	$push61=, 93
	i32.store8	$discard=, 669($2), $pop61
	i32.const	$push62=, 94
	i32.store8	$discard=, 670($2), $pop62
	i32.const	$push63=, 95
	i32.store8	$discard=, 671($2), $pop63
	i32.const	$push43=, 80
	i32.store8	$push44=, 680($2), $pop43
	i32.store8	$discard=, 672($2), $pop44
	i32.const	$push45=, 81
	i32.store8	$push46=, 681($2), $pop45
	i32.store8	$discard=, 673($2), $pop46
	i32.const	$push47=, 82
	i32.store8	$push48=, 682($2), $pop47
	i32.store8	$discard=, 674($2), $pop48
	i32.const	$push74=, 101
	i32.store8	$discard=, 653($2), $pop74
	i32.const	$push75=, 102
	i32.store8	$discard=, 654($2), $pop75
	i32.const	$push76=, 103
	i32.store8	$discard=, 655($2), $pop76
	i32.const	$push77=, 104
	i32.store8	$push78=, 656($2), $pop77
	i32.store8	$discard=, 632($2), $pop78
	i32.const	$push79=, 105
	i32.store8	$push80=, 657($2), $pop79
	i32.store8	$discard=, 633($2), $pop80
	i32.const	$push81=, 106
	i32.store8	$push82=, 658($2), $pop81
	i32.store8	$discard=, 634($2), $pop82
	i32.const	$push83=, 107
	i32.store8	$push84=, 659($2), $pop83
	i32.store8	$discard=, 635($2), $pop84
	i32.const	$push85=, 108
	i32.store8	$discard=, 636($2), $pop85
	i32.const	$push86=, 109
	i32.store8	$discard=, 637($2), $pop86
	i32.const	$push87=, 110
	i32.store8	$discard=, 638($2), $pop87
	i32.const	$push88=, 111
	i32.store8	$discard=, 639($2), $pop88
	i32.const	$push64=, 96
	i32.store8	$push65=, 648($2), $pop64
	i32.store8	$discard=, 640($2), $pop65
	i32.const	$push66=, 97
	i32.store8	$push67=, 649($2), $pop66
	i32.store8	$discard=, 641($2), $pop67
	i32.const	$push68=, 98
	i32.store8	$push69=, 650($2), $pop68
	i32.store8	$discard=, 642($2), $pop69
	i32.const	$push70=, 99
	i32.store8	$push71=, 651($2), $pop70
	i32.store8	$discard=, 643($2), $pop71
	i32.const	$push72=, 100
	i32.store8	$push73=, 652($2), $pop72
	i32.store8	$discard=, 644($2), $pop73
	i32.const	$push103=, 119
	i32.store8	$discard=, 623($2), $pop103
	i32.const	$push104=, 120
	i32.store8	$push105=, 624($2), $pop104
	i32.store8	$discard=, 600($2), $pop105
	i32.const	$push106=, 121
	i32.store8	$push107=, 625($2), $pop106
	i32.store8	$discard=, 601($2), $pop107
	i32.const	$push108=, 122
	i32.store8	$push109=, 626($2), $pop108
	i32.store8	$discard=, 602($2), $pop109
	i32.const	$push110=, 123
	i32.store8	$push111=, 627($2), $pop110
	i32.store8	$discard=, 603($2), $pop111
	i32.const	$push112=, 124
	i32.store8	$push113=, 628($2), $pop112
	i32.store8	$discard=, 604($2), $pop113
	i32.const	$push114=, 125
	i32.store8	$push115=, 629($2), $pop114
	i32.store8	$discard=, 605($2), $pop115
	i32.const	$push116=, 126
	i32.store8	$discard=, 606($2), $pop116
	i32.const	$push117=, 127
	i32.store8	$discard=, 607($2), $pop117
	i32.const	$push89=, 112
	i32.store8	$push90=, 616($2), $pop89
	i32.store8	$discard=, 608($2), $pop90
	i32.const	$push91=, 113
	i32.store8	$push92=, 617($2), $pop91
	i32.store8	$discard=, 609($2), $pop92
	i32.const	$push93=, 114
	i32.store8	$push94=, 618($2), $pop93
	i32.store8	$discard=, 610($2), $pop94
	i32.const	$push95=, 115
	i32.store8	$push96=, 619($2), $pop95
	i32.store8	$discard=, 611($2), $pop96
	i32.const	$push97=, 116
	i32.store8	$push98=, 620($2), $pop97
	i32.store8	$discard=, 612($2), $pop98
	i32.const	$push99=, 117
	i32.store8	$push100=, 621($2), $pop99
	i32.store8	$discard=, 613($2), $pop100
	i32.const	$push101=, 118
	i32.store8	$push102=, 622($2), $pop101
	i32.store8	$discard=, 614($2), $pop102
	i32.const	$push118=, 128
	i32.store8	$discard=, 584($2), $pop118
	i32.const	$push119=, 129
	i32.store8	$discard=, 585($2), $pop119
	i32.const	$push120=, 130
	i32.store8	$discard=, 586($2), $pop120
	i32.const	$push121=, 131
	i32.store8	$discard=, 587($2), $pop121
	i32.const	$push122=, 132
	i32.store8	$discard=, 588($2), $pop122
	i32.const	$push123=, 133
	i32.store8	$discard=, 589($2), $pop123
	i32.const	$push124=, 134
	i32.store8	$discard=, 590($2), $pop124
	i32.const	$push125=, 135
	i32.store8	$discard=, 591($2), $pop125
	i32.const	$push126=, 136
	i32.store8	$discard=, 592($2), $pop126
	i32.const	$push127=, 137
	i32.store8	$discard=, 593($2), $pop127
	i32.const	$push128=, 138
	i32.store8	$discard=, 594($2), $pop128
	i32.const	$push129=, 139
	i32.store8	$discard=, 595($2), $pop129
	i32.const	$push130=, 140
	i32.store8	$discard=, 596($2), $pop130
	i32.const	$push131=, 141
	i32.store8	$discard=, 597($2), $pop131
	i32.const	$push132=, 142
	i32.store8	$discard=, 598($2), $pop132
	i32.const	$push133=, 143
	i32.store8	$discard=, 599($2), $pop133
	i32.const	$1=, 0
.LBB2_1:                                # %for.body180
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label46:
	i32.const	$push327=, 552
	i32.add 	$push328=, $2, $pop327
	i32.add 	$push135=, $pop328, $1
	i32.const	$push285=, 248
	i32.xor 	$push134=, $1, $pop285
	i32.store8	$discard=, 0($pop135), $pop134
	i32.const	$push284=, 1
	i32.add 	$1=, $1, $pop284
	i32.const	$push283=, 31
	i32.ne  	$push136=, $1, $pop283
	br_if   	0, $pop136      # 0: up to label46
# BB#2:                                 # %for.body191.preheader
	end_loop                        # label47:
	i32.const	$push137=, 50462976
	i32.store	$discard=, 520($2), $pop137
	i32.const	$push138=, 1284
	i32.store16	$discard=, 524($2), $pop138
	i32.const	$push139=, 151521030
	i32.store	$discard=, 526($2):p2align=1, $pop139
	i32.const	$push140=, 2826
	i32.store16	$discard=, 530($2), $pop140
	i32.const	$push141=, 3340
	i32.store16	$discard=, 532($2), $pop141
	i32.const	$push142=, 14
	i32.store8	$discard=, 534($2), $pop142
	i32.const	$push143=, 15
	i32.store8	$discard=, 535($2), $pop143
	i32.const	$push144=, 16
	i32.store8	$discard=, 536($2), $pop144
	i32.const	$push145=, 17
	i32.store8	$discard=, 537($2), $pop145
	i32.const	$push146=, 18
	i32.store8	$discard=, 538($2), $pop146
	i32.const	$push147=, 19
	i32.store8	$discard=, 539($2), $pop147
	i32.const	$push148=, 20
	i32.store8	$discard=, 540($2), $pop148
	i32.const	$push149=, 21
	i32.store8	$discard=, 541($2), $pop149
	i32.const	$push150=, 22
	i32.store8	$discard=, 542($2), $pop150
	i32.const	$push151=, 23
	i32.store8	$discard=, 543($2), $pop151
	i32.const	$push153=, 25
	i32.store8	$discard=, 545($2), $pop153
	i32.const	$push154=, 26
	i32.store8	$discard=, 546($2), $pop154
	i32.const	$push155=, 27
	i32.store8	$discard=, 547($2), $pop155
	i32.const	$push156=, 28
	i32.store8	$discard=, 548($2), $pop156
	i32.const	$push157=, 29
	i32.store8	$discard=, 549($2), $pop157
	i32.const	$push158=, 30
	i32.store8	$discard=, 550($2), $pop158
	i32.const	$push159=, 31
	i32.store8	$discard=, 551($2), $pop159
	i32.const	$push152=, 24
	i32.store8	$0=, 544($2), $pop152
	i32.const	$1=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label48:
	i32.const	$push329=, 480
	i32.add 	$push330=, $2, $pop329
	i32.add 	$push161=, $pop330, $1
	i32.xor 	$push160=, $1, $0
	i32.store8	$discard=, 0($pop161), $pop160
	i32.const	$push287=, 1
	i32.add 	$1=, $1, $pop287
	i32.const	$push286=, 35
	i32.ne  	$push162=, $1, $pop286
	br_if   	0, $pop162      # 0: up to label48
# BB#4:                                 # %for.body213.preheader
	end_loop                        # label49:
	i32.const	$1=, 0
.LBB2_5:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label50:
	i32.const	$push331=, 408
	i32.add 	$push332=, $2, $pop331
	i32.add 	$push164=, $pop332, $1
	i32.const	$push290=, 64
	i32.xor 	$push163=, $1, $pop290
	i32.store8	$discard=, 0($pop164), $pop163
	i32.const	$push289=, 1
	i32.add 	$1=, $1, $pop289
	i32.const	$push288=, 72
	i32.ne  	$push165=, $1, $pop288
	br_if   	0, $pop165      # 0: up to label50
# BB#6:                                 # %for.end220
	end_loop                        # label51:
	i32.const	$push333=, 402
	i32.add 	$push334=, $2, $pop333
	i32.const	$push166=, 2
	i32.add 	$push167=, $pop334, $pop166
	i32.load8_u	$push168=, 754($2)
	i32.store8	$discard=, 0($pop167), $pop168
	i32.load16_u	$push169=, 760($2)
	i32.store16	$discard=, 406($2), $pop169
	i32.load16_u	$push170=, 752($2)
	i32.store16	$discard=, 402($2), $pop170
	i32.load	$push171=, 744($2)
	i32.store	$discard=, 396($2), $pop171
	i32.const	$push335=, 388
	i32.add 	$push336=, $2, $pop335
	i32.const	$push172=, 4
	i32.add 	$push173=, $pop336, $pop172
	i32.load8_u	$push174=, 740($2)
	i32.store8	$discard=, 0($pop173), $pop174
	i32.load	$push175=, 736($2)
	i32.store	$discard=, 388($2), $pop175
	i32.const	$push337=, 380
	i32.add 	$push338=, $2, $pop337
	i32.const	$push322=, 4
	i32.add 	$push176=, $pop338, $pop322
	i32.load16_u	$push177=, 732($2)
	i32.store16	$discard=, 0($pop176), $pop177
	i32.load	$push178=, 728($2)
	i32.store	$discard=, 380($2), $pop178
	i32.const	$push339=, 372
	i32.add 	$push340=, $2, $pop339
	i32.const	$push179=, 6
	i32.add 	$push180=, $pop340, $pop179
	i32.load8_u	$push181=, 726($2)
	i32.store8	$discard=, 0($pop180), $pop181
	i32.const	$push341=, 372
	i32.add 	$push342=, $2, $pop341
	i32.const	$push321=, 4
	i32.add 	$push182=, $pop342, $pop321
	i32.load16_u	$push183=, 724($2)
	i32.store16	$discard=, 0($pop182), $pop183
	i32.load	$push184=, 720($2)
	i32.store	$discard=, 372($2), $pop184
	i64.load	$push185=, 712($2)
	i64.store	$discard=, 364($2):p2align=2, $pop185
	i32.const	$push343=, 352
	i32.add 	$push344=, $2, $pop343
	i32.const	$push186=, 8
	i32.add 	$push187=, $pop344, $pop186
	i32.const	$push345=, 696
	i32.add 	$push346=, $2, $pop345
	i32.const	$push320=, 8
	i32.add 	$push188=, $pop346, $pop320
	i32.load8_u	$push189=, 0($pop188)
	i32.store8	$discard=, 0($pop187), $pop189
	i64.load	$push190=, 696($2)
	i64.store	$discard=, 352($2):p2align=2, $pop190
	i32.const	$push347=, 340
	i32.add 	$push348=, $2, $pop347
	i32.const	$push319=, 8
	i32.add 	$push191=, $pop348, $pop319
	i32.const	$push349=, 680
	i32.add 	$push350=, $2, $pop349
	i32.const	$push318=, 8
	i32.add 	$push192=, $pop350, $pop318
	i32.load16_u	$push193=, 0($pop192)
	i32.store16	$discard=, 0($pop191), $pop193
	i64.load	$push194=, 680($2)
	i64.store	$discard=, 340($2):p2align=2, $pop194
	i32.const	$push351=, 328
	i32.add 	$push352=, $2, $pop351
	i32.const	$push195=, 10
	i32.add 	$push196=, $pop352, $pop195
	i32.const	$push353=, 664
	i32.add 	$push354=, $2, $pop353
	i32.const	$push317=, 10
	i32.add 	$push197=, $pop354, $pop317
	i32.load8_u	$push198=, 0($pop197)
	i32.store8	$discard=, 0($pop196), $pop198
	i32.const	$push355=, 328
	i32.add 	$push356=, $2, $pop355
	i32.const	$push316=, 8
	i32.add 	$push199=, $pop356, $pop316
	i32.const	$push357=, 664
	i32.add 	$push358=, $2, $pop357
	i32.const	$push315=, 8
	i32.add 	$push200=, $pop358, $pop315
	i32.load16_u	$push201=, 0($pop200)
	i32.store16	$discard=, 0($pop199), $pop201
	i64.load	$push202=, 664($2)
	i64.store	$discard=, 328($2):p2align=2, $pop202
	i32.const	$push359=, 316
	i32.add 	$push360=, $2, $pop359
	i32.const	$push314=, 8
	i32.add 	$push203=, $pop360, $pop314
	i32.const	$push361=, 648
	i32.add 	$push362=, $2, $pop361
	i32.const	$push313=, 8
	i32.add 	$push204=, $pop362, $pop313
	i32.load	$push205=, 0($pop204)
	i32.store	$discard=, 0($pop203), $pop205
	i64.load	$push206=, 648($2)
	i64.store	$discard=, 316($2):p2align=2, $pop206
	i32.const	$push363=, 300
	i32.add 	$push364=, $2, $pop363
	i32.const	$push207=, 12
	i32.add 	$push208=, $pop364, $pop207
	i32.const	$push365=, 632
	i32.add 	$push366=, $2, $pop365
	i32.const	$push312=, 12
	i32.add 	$push209=, $pop366, $pop312
	i32.load8_u	$push210=, 0($pop209)
	i32.store8	$discard=, 0($pop208), $pop210
	i32.const	$push367=, 300
	i32.add 	$push368=, $2, $pop367
	i32.const	$push311=, 8
	i32.add 	$push211=, $pop368, $pop311
	i32.const	$push369=, 632
	i32.add 	$push370=, $2, $pop369
	i32.const	$push310=, 8
	i32.add 	$push212=, $pop370, $pop310
	i32.load	$push213=, 0($pop212)
	i32.store	$discard=, 0($pop211), $pop213
	i64.load	$push214=, 632($2)
	i64.store	$discard=, 300($2):p2align=2, $pop214
	i32.const	$push371=, 284
	i32.add 	$push372=, $2, $pop371
	i32.const	$push309=, 12
	i32.add 	$push215=, $pop372, $pop309
	i32.const	$push373=, 616
	i32.add 	$push374=, $2, $pop373
	i32.const	$push308=, 12
	i32.add 	$push216=, $pop374, $pop308
	i32.load16_u	$push217=, 0($pop216)
	i32.store16	$discard=, 0($pop215), $pop217
	i32.const	$push375=, 284
	i32.add 	$push376=, $2, $pop375
	i32.const	$push307=, 8
	i32.add 	$push218=, $pop376, $pop307
	i32.const	$push377=, 616
	i32.add 	$push378=, $2, $pop377
	i32.const	$push306=, 8
	i32.add 	$push219=, $pop378, $pop306
	i32.load	$push220=, 0($pop219)
	i32.store	$discard=, 0($pop218), $pop220
	i64.load	$push221=, 616($2)
	i64.store	$discard=, 284($2):p2align=2, $pop221
	i32.const	$push379=, 268
	i32.add 	$push380=, $2, $pop379
	i32.const	$push222=, 14
	i32.add 	$push223=, $pop380, $pop222
	i32.const	$push381=, 600
	i32.add 	$push382=, $2, $pop381
	i32.const	$push305=, 14
	i32.add 	$push224=, $pop382, $pop305
	i32.load8_u	$push225=, 0($pop224)
	i32.store8	$discard=, 0($pop223), $pop225
	i32.const	$push383=, 268
	i32.add 	$push384=, $2, $pop383
	i32.const	$push304=, 12
	i32.add 	$push226=, $pop384, $pop304
	i32.const	$push385=, 600
	i32.add 	$push386=, $2, $pop385
	i32.const	$push303=, 12
	i32.add 	$push227=, $pop386, $pop303
	i32.load16_u	$push228=, 0($pop227)
	i32.store16	$discard=, 0($pop226), $pop228
	i32.const	$push387=, 268
	i32.add 	$push388=, $2, $pop387
	i32.const	$push302=, 8
	i32.add 	$push229=, $pop388, $pop302
	i32.const	$push389=, 600
	i32.add 	$push390=, $2, $pop389
	i32.const	$push301=, 8
	i32.add 	$push230=, $pop390, $pop301
	i32.load	$push231=, 0($pop230)
	i32.store	$discard=, 0($pop229), $pop231
	i64.load	$push232=, 600($2)
	i64.store	$discard=, 268($2):p2align=2, $pop232
	i32.const	$push391=, 252
	i32.add 	$push392=, $2, $pop391
	i32.const	$push300=, 8
	i32.add 	$push233=, $pop392, $pop300
	i32.const	$push393=, 584
	i32.add 	$push394=, $2, $pop393
	i32.const	$push299=, 8
	i32.add 	$push234=, $pop394, $pop299
	i64.load	$push235=, 0($pop234)
	i64.store	$discard=, 0($pop233):p2align=2, $pop235
	i64.load	$push236=, 584($2)
	i64.store	$discard=, 252($2):p2align=2, $pop236
	i32.const	$push395=, 221
	i32.add 	$push396=, $2, $pop395
	i32.const	$push397=, 552
	i32.add 	$push398=, $2, $pop397
	i32.const	$push237=, 31
	i32.call	$discard=, memcpy@FUNCTION, $pop396, $pop398, $pop237
	i32.const	$push399=, 188
	i32.add 	$push400=, $2, $pop399
	i32.const	$push238=, 24
	i32.add 	$push239=, $pop400, $pop238
	i32.const	$push401=, 520
	i32.add 	$push402=, $2, $pop401
	i32.const	$push298=, 24
	i32.add 	$push240=, $pop402, $pop298
	i64.load	$push241=, 0($pop240)
	i64.store	$discard=, 0($pop239):p2align=2, $pop241
	i32.const	$push403=, 188
	i32.add 	$push404=, $2, $pop403
	i32.const	$push242=, 16
	i32.add 	$push243=, $pop404, $pop242
	i32.const	$push405=, 520
	i32.add 	$push406=, $2, $pop405
	i32.const	$push297=, 16
	i32.add 	$push244=, $pop406, $pop297
	i64.load	$push245=, 0($pop244)
	i64.store	$discard=, 0($pop243):p2align=2, $pop245
	i32.const	$push407=, 188
	i32.add 	$push408=, $2, $pop407
	i32.const	$push296=, 8
	i32.add 	$push246=, $pop408, $pop296
	i32.const	$push409=, 520
	i32.add 	$push410=, $2, $pop409
	i32.const	$push295=, 8
	i32.add 	$push247=, $pop410, $pop295
	i64.load	$push248=, 0($pop247)
	i64.store	$discard=, 0($pop246):p2align=2, $pop248
	i64.load	$push249=, 520($2)
	i64.store	$discard=, 188($2):p2align=2, $pop249
	i32.const	$push411=, 153
	i32.add 	$push412=, $2, $pop411
	i32.const	$push413=, 480
	i32.add 	$push414=, $2, $pop413
	i32.const	$push250=, 35
	i32.call	$discard=, memcpy@FUNCTION, $pop412, $pop414, $pop250
	i32.const	$push415=, 81
	i32.add 	$push416=, $2, $pop415
	i32.const	$push417=, 408
	i32.add 	$push418=, $2, $pop417
	i32.const	$push251=, 72
	i32.call	$discard=, memcpy@FUNCTION, $pop416, $pop418, $pop251
	i32.const	$push252=, 76
	i32.add 	$push253=, $2, $pop252
	i32.const	$push419=, 81
	i32.add 	$push420=, $2, $pop419
	i32.store	$discard=, 0($pop253), $pop420
	i32.const	$push294=, 72
	i32.add 	$push254=, $2, $pop294
	i32.const	$push421=, 153
	i32.add 	$push422=, $2, $pop421
	i32.store	$discard=, 0($pop254), $pop422
	i32.const	$push255=, 68
	i32.add 	$push256=, $2, $pop255
	i32.const	$push423=, 188
	i32.add 	$push424=, $2, $pop423
	i32.store	$discard=, 0($pop256), $pop424
	i32.const	$push257=, 64
	i32.add 	$push258=, $2, $pop257
	i32.const	$push425=, 221
	i32.add 	$push426=, $2, $pop425
	i32.store	$discard=, 0($pop258), $pop426
	i32.const	$push259=, 60
	i32.add 	$push260=, $2, $pop259
	i32.const	$push427=, 252
	i32.add 	$push428=, $2, $pop427
	i32.store	$discard=, 0($pop260), $pop428
	i32.const	$push261=, 56
	i32.add 	$push262=, $2, $pop261
	i32.const	$push429=, 268
	i32.add 	$push430=, $2, $pop429
	i32.store	$discard=, 0($pop262), $pop430
	i32.const	$push263=, 52
	i32.add 	$push264=, $2, $pop263
	i32.const	$push431=, 284
	i32.add 	$push432=, $2, $pop431
	i32.store	$discard=, 0($pop264), $pop432
	i32.const	$push265=, 48
	i32.add 	$push266=, $2, $pop265
	i32.const	$push433=, 300
	i32.add 	$push434=, $2, $pop433
	i32.store	$discard=, 0($pop266), $pop434
	i32.const	$push267=, 44
	i32.add 	$push268=, $2, $pop267
	i32.const	$push435=, 316
	i32.add 	$push436=, $2, $pop435
	i32.store	$discard=, 0($pop268), $pop436
	i32.const	$push269=, 40
	i32.add 	$push270=, $2, $pop269
	i32.const	$push437=, 328
	i32.add 	$push438=, $2, $pop437
	i32.store	$discard=, 0($pop270), $pop438
	i32.const	$push271=, 36
	i32.add 	$push272=, $2, $pop271
	i32.const	$push439=, 340
	i32.add 	$push440=, $2, $pop439
	i32.store	$discard=, 0($pop272), $pop440
	i32.const	$push273=, 32
	i32.add 	$push274=, $2, $pop273
	i32.const	$push441=, 352
	i32.add 	$push442=, $2, $pop441
	i32.store	$discard=, 0($pop274), $pop442
	i32.const	$push275=, 28
	i32.add 	$push276=, $2, $pop275
	i32.const	$push443=, 364
	i32.add 	$push444=, $2, $pop443
	i32.store	$discard=, 0($pop276), $pop444
	i32.const	$push293=, 24
	i32.add 	$push277=, $2, $pop293
	i32.const	$push445=, 372
	i32.add 	$push446=, $2, $pop445
	i32.store	$discard=, 0($pop277), $pop446
	i32.const	$push278=, 20
	i32.add 	$push279=, $2, $pop278
	i32.const	$push447=, 380
	i32.add 	$push448=, $2, $pop447
	i32.store	$discard=, 0($pop279), $pop448
	i32.const	$push292=, 16
	i32.add 	$push280=, $2, $pop292
	i32.const	$push449=, 388
	i32.add 	$push450=, $2, $pop449
	i32.store	$discard=, 0($pop280), $pop450
	i32.const	$push291=, 8
	i32.store	$discard=, 0($2), $pop291
	i32.const	$push451=, 396
	i32.add 	$push452=, $2, $pop451
	i32.store	$discard=, 12($2), $pop452
	i32.const	$push453=, 402
	i32.add 	$push454=, $2, $pop453
	i32.store	$discard=, 8($2), $pop454
	i32.const	$push455=, 406
	i32.add 	$push456=, $2, $pop455
	i32.store	$discard=, 4($2), $pop456
	i32.const	$push281=, 21
	call    	foo@FUNCTION, $pop281, $2
	i32.const	$push282=, 0
	call    	exit@FUNCTION, $pop282
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
