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
	i32.const	$push1=, 0
	i32.load	$2=, bar.lastc($pop1)
	block
	block
	i32.const	$push16=, 0
	i32.load	$push15=, bar.lastn($pop16)
	tee_local	$push14=, $3=, $pop15
	i32.eq  	$push2=, $pop14, $0
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %if.then
	i32.ne  	$push3=, $2, $3
	br_if   	1, $pop3        # 1: down to label0
# BB#2:                                 # %if.end
	i32.const	$2=, 0
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.store	$push0=, bar.lastc($pop18), $pop17
	i32.store	$drop=, bar.lastn($pop0), $0
.LBB0_3:                                # %if.end3
	end_block                       # label1:
	i32.const	$push4=, 3
	i32.shl 	$push5=, $0, $pop4
	i32.xor 	$push6=, $2, $pop5
	i32.const	$push7=, 24
	i32.shl 	$push8=, $pop6, $pop7
	i32.const	$push19=, 24
	i32.shr_s	$push9=, $pop8, $pop19
	i32.ne  	$push10=, $pop9, $1
	br_if   	0, $pop10       # 0: down to label0
# BB#4:                                 # %if.end8
	i32.const	$push13=, 0
	i32.const	$push11=, 1
	i32.add 	$push12=, $2, $pop11
	i32.store	$drop=, bar.lastc($pop13), $pop12
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
	.local  	i32, i32, i32, i32, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push407=, __stack_pointer
	i32.const	$push404=, __stack_pointer
	i32.load	$push405=, 0($pop404)
	i32.const	$push406=, 352
	i32.sub 	$push481=, $pop405, $pop406
	i32.store	$5=, 0($pop407), $pop481
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push33=, 21
	i32.ne  	$push34=, $0, $pop33
	br_if   	0, $pop34       # 0: down to label8
# BB#1:                                 # %if.end
	i32.store	$push486=, 4($5), $1
	tee_local	$push485=, $10=, $pop486
	i32.const	$push35=, 4
	i32.add 	$push36=, $pop485, $pop35
	i32.store	$drop=, 4($5), $pop36
	i32.const	$push37=, 0
	i32.load	$0=, bar.lastc($pop37)
	i32.load8_s	$1=, 0($10)
	block
	i32.const	$push484=, 0
	i32.load	$push483=, bar.lastn($pop484)
	tee_local	$push482=, $6=, $pop483
	i32.const	$push38=, 1
	i32.eq  	$push39=, $pop482, $pop38
	br_if   	0, $pop39       # 0: down to label9
# BB#2:                                 # %if.then.i
	i32.ne  	$push40=, $0, $6
	br_if   	1, $pop40       # 1: down to label8
# BB#3:                                 # %if.end.i
	i32.const	$0=, 0
	i32.const	$push489=, 0
	i32.const	$push41=, 1
	i32.store	$drop=, bar.lastn($pop489), $pop41
	i32.const	$push488=, 0
	i32.const	$push487=, 0
	i32.store	$drop=, bar.lastc($pop488), $pop487
.LBB1_4:                                # %if.end3.i
	end_block                       # label9:
	i32.const	$push42=, 24
	i32.shl 	$push43=, $0, $pop42
	i32.const	$push491=, 24
	i32.shr_s	$push44=, $pop43, $pop491
	i32.const	$push490=, 8
	i32.xor 	$push45=, $pop44, $pop490
	i32.ne  	$push46=, $pop45, $1
	br_if   	0, $pop46       # 0: down to label8
# BB#5:                                 # %if.then.i314
	i32.const	$push493=, 0
	i32.const	$push47=, 1
	i32.add 	$push48=, $0, $pop47
	i32.store	$drop=, bar.lastc($pop493), $pop48
	i32.const	$push492=, 8
	i32.add 	$push13=, $10, $pop492
	i32.store	$1=, 4($5), $pop13
	br_if   	0, $0           # 0: down to label8
# BB#6:                                 # %if.end3.i321
	i32.const	$push49=, 4
	i32.add 	$push50=, $10, $pop49
	i32.load16_u	$0=, 0($pop50):p2align=0
	i32.const	$push496=, 0
	i32.const	$push51=, 2
	i32.store	$drop=, bar.lastn($pop496), $pop51
	i32.const	$push495=, 0
	i32.const	$push494=, 0
	i32.store	$drop=, bar.lastc($pop495), $pop494
	i32.const	$push52=, 255
	i32.and 	$push53=, $0, $pop52
	i32.const	$push54=, 16
	i32.ne  	$push55=, $pop53, $pop54
	br_if   	0, $pop55       # 0: down to label8
# BB#7:                                 # %if.end3.i321.1
	i32.const	$push497=, 0
	i32.const	$push56=, 1
	i32.store	$drop=, bar.lastc($pop497), $pop56
	i32.const	$push57=, 65280
	i32.and 	$push58=, $0, $pop57
	i32.const	$push59=, 4352
	i32.ne  	$push60=, $pop58, $pop59
	br_if   	0, $pop60       # 0: down to label8
# BB#8:                                 # %if.end3.i335
	i32.const	$push62=, 12
	i32.add 	$push63=, $10, $pop62
	i32.store	$drop=, 4($5), $pop63
	i32.const	$push501=, 0
	i32.const	$push61=, 2
	i32.store	$push0=, bar.lastc($pop501), $pop61
	i32.add 	$push65=, $1, $pop0
	i32.load8_u	$0=, 0($pop65)
	i32.load16_u	$push64=, 0($1):p2align=0
	i32.store16	$drop=, 344($5), $pop64
	i32.store8	$drop=, 346($5), $0
	i32.load8_u	$0=, 344($5)
	i32.const	$push500=, 0
	i32.const	$push66=, 3
	i32.store	$drop=, bar.lastn($pop500), $pop66
	i32.const	$push499=, 0
	i32.const	$push498=, 0
	i32.store	$drop=, bar.lastc($pop499), $pop498
	i32.const	$push67=, 24
	i32.ne  	$push68=, $0, $pop67
	br_if   	6, $pop68       # 6: down to label2
# BB#9:                                 # %if.end3.i335.1
	i32.load8_u	$0=, 345($5)
	i32.const	$push502=, 0
	i32.const	$push69=, 1
	i32.store	$drop=, bar.lastc($pop502), $pop69
	i32.const	$push70=, 25
	i32.ne  	$push71=, $0, $pop70
	br_if   	6, $pop71       # 6: down to label2
# BB#10:                                # %if.end3.i335.2
	i32.load8_u	$0=, 346($5)
	i32.const	$push503=, 0
	i32.const	$push72=, 2
	i32.store	$drop=, bar.lastc($pop503), $pop72
	i32.const	$push73=, 26
	i32.ne  	$push74=, $0, $pop73
	br_if   	6, $pop74       # 6: down to label2
# BB#11:                                # %if.end3.i349
	i32.const	$push76=, 0
	i32.const	$push75=, 3
	i32.store	$drop=, bar.lastc($pop76), $pop75
	i32.const	$push77=, 16
	i32.add 	$push14=, $10, $pop77
	i32.store	$1=, 4($5), $pop14
	i32.const	$push78=, 12
	i32.add 	$push79=, $10, $pop78
	i32.load	$0=, 0($pop79):p2align=0
	i32.const	$push506=, 0
	i32.const	$push80=, 4
	i32.store	$drop=, bar.lastn($pop506), $pop80
	i32.const	$push505=, 0
	i32.const	$push504=, 0
	i32.store	$6=, bar.lastc($pop505), $pop504
	i32.const	$push81=, 255
	i32.and 	$push82=, $0, $pop81
	i32.const	$push83=, 32
	i32.ne  	$push84=, $pop82, $pop83
	br_if   	5, $pop84       # 5: down to label3
# BB#12:                                # %if.end3.i349.1
	i32.const	$push85=, 1
	i32.store	$drop=, bar.lastc($6), $pop85
	i32.const	$push86=, 65280
	i32.and 	$push87=, $0, $pop86
	i32.const	$push88=, 8448
	i32.ne  	$push89=, $pop87, $pop88
	br_if   	5, $pop89       # 5: down to label3
# BB#13:                                # %if.end3.i349.2
	i32.const	$push507=, 0
	i32.const	$push90=, 2
	i32.store	$drop=, bar.lastc($pop507), $pop90
	i32.const	$push91=, 16711680
	i32.and 	$push92=, $0, $pop91
	i32.const	$push93=, 2228224
	i32.ne  	$push94=, $pop92, $pop93
	br_if   	5, $pop94       # 5: down to label3
# BB#14:                                # %if.end3.i349.3
	i32.const	$push508=, 0
	i32.const	$push95=, 3
	i32.store	$drop=, bar.lastc($pop508), $pop95
	i32.const	$push96=, -16777216
	i32.and 	$push97=, $0, $pop96
	i32.const	$push98=, 587202560
	i32.ne  	$push99=, $pop97, $pop98
	br_if   	5, $pop99       # 5: down to label3
# BB#15:                                # %if.end3.i363
	i32.const	$push100=, 24
	i32.add 	$push15=, $10, $pop100
	i32.store	$6=, 4($5), $pop15
	i32.const	$push102=, 4
	i32.add 	$push103=, $1, $pop102
	i32.load8_u	$0=, 0($pop103)
	i32.load	$push101=, 0($1):p2align=0
	i32.store	$drop=, 336($5), $pop101
	i32.store8	$drop=, 340($5), $0
	i32.load8_u	$0=, 336($5)
	i32.const	$push104=, 0
	i32.const	$push105=, 5
	i32.store	$drop=, bar.lastn($pop104), $pop105
	i32.const	$push510=, 0
	i32.const	$push509=, 0
	i32.store	$1=, bar.lastc($pop510), $pop509
	i32.const	$push106=, 40
	i32.ne  	$push107=, $0, $pop106
	br_if   	4, $pop107      # 4: down to label4
# BB#16:                                # %if.end3.i363.1
	i32.load8_u	$0=, 337($5)
	i32.const	$push108=, 1
	i32.store	$drop=, bar.lastc($1), $pop108
	i32.const	$push109=, 41
	i32.ne  	$push110=, $0, $pop109
	br_if   	4, $pop110      # 4: down to label4
# BB#17:                                # %if.end3.i363.2
	i32.load8_u	$0=, 338($5)
	i32.const	$push511=, 0
	i32.const	$push111=, 2
	i32.store	$drop=, bar.lastc($pop511), $pop111
	i32.const	$push112=, 42
	i32.ne  	$push113=, $0, $pop112
	br_if   	4, $pop113      # 4: down to label4
# BB#18:                                # %if.end3.i363.3
	i32.load8_u	$0=, 339($5)
	i32.const	$push512=, 0
	i32.const	$push114=, 3
	i32.store	$drop=, bar.lastc($pop512), $pop114
	i32.const	$push115=, 43
	i32.ne  	$push116=, $0, $pop115
	br_if   	4, $pop116      # 4: down to label4
# BB#19:                                # %if.end3.i363.4
	i32.load8_u	$0=, 340($5)
	i32.const	$push513=, 0
	i32.const	$push117=, 4
	i32.store	$1=, bar.lastc($pop513), $pop117
	i32.const	$push118=, 44
	i32.ne  	$push119=, $0, $pop118
	br_if   	4, $pop119      # 4: down to label4
# BB#20:                                # %if.end3.i377
	i32.const	$push120=, 32
	i32.add 	$push16=, $10, $pop120
	i32.store	$0=, 4($5), $pop16
	i32.add 	$push122=, $6, $1
	i32.load16_u	$1=, 0($pop122):p2align=0
	i32.load	$push121=, 0($6):p2align=0
	i32.store	$drop=, 328($5), $pop121
	i32.store16	$drop=, 332($5), $1
	i32.load8_u	$1=, 328($5)
	i32.const	$push516=, 0
	i32.const	$push123=, 6
	i32.store	$drop=, bar.lastn($pop516), $pop123
	i32.const	$push515=, 0
	i32.const	$push514=, 0
	i32.store	$drop=, bar.lastc($pop515), $pop514
	i32.const	$push124=, 48
	i32.ne  	$push125=, $1, $pop124
	br_if   	3, $pop125      # 3: down to label5
# BB#21:                                # %if.end3.i377.1
	i32.load8_u	$1=, 329($5)
	i32.const	$push517=, 0
	i32.const	$push126=, 1
	i32.store	$drop=, bar.lastc($pop517), $pop126
	i32.const	$push127=, 49
	i32.ne  	$push128=, $1, $pop127
	br_if   	3, $pop128      # 3: down to label5
# BB#22:                                # %if.end3.i377.2
	i32.load8_u	$1=, 330($5)
	i32.const	$push518=, 0
	i32.const	$push129=, 2
	i32.store	$drop=, bar.lastc($pop518), $pop129
	i32.const	$push130=, 50
	i32.ne  	$push131=, $1, $pop130
	br_if   	3, $pop131      # 3: down to label5
# BB#23:                                # %if.end3.i377.3
	i32.load8_u	$1=, 331($5)
	i32.const	$push519=, 0
	i32.const	$push132=, 3
	i32.store	$drop=, bar.lastc($pop519), $pop132
	i32.const	$push133=, 51
	i32.ne  	$push134=, $1, $pop133
	br_if   	3, $pop134      # 3: down to label5
# BB#24:                                # %if.end3.i377.4
	i32.load8_u	$1=, 332($5)
	i32.const	$push520=, 0
	i32.const	$push135=, 4
	i32.store	$drop=, bar.lastc($pop520), $pop135
	i32.const	$push136=, 52
	i32.ne  	$push137=, $1, $pop136
	br_if   	3, $pop137      # 3: down to label5
# BB#25:                                # %if.end3.i377.5
	i32.load8_u	$1=, 333($5)
	i32.const	$push521=, 0
	i32.const	$push138=, 5
	i32.store	$drop=, bar.lastc($pop521), $pop138
	i32.const	$push139=, 53
	i32.ne  	$push140=, $1, $pop139
	br_if   	3, $pop140      # 3: down to label5
# BB#26:                                # %if.end3.i391
	i32.const	$push141=, 40
	i32.add 	$push142=, $10, $pop141
	i32.store	$drop=, 4($5), $pop142
	i32.const	$push144=, 6
	i32.add 	$push145=, $0, $pop144
	i32.load8_u	$1=, 0($pop145)
	i32.const	$push146=, 4
	i32.add 	$push147=, $0, $pop146
	i32.load16_u	$6=, 0($pop147):p2align=0
	i32.load	$push143=, 0($0):p2align=0
	i32.store	$drop=, 320($5), $pop143
	i32.store8	$drop=, 326($5), $1
	i32.store16	$drop=, 324($5), $6
	i32.load8_u	$0=, 320($5)
	i32.const	$push524=, 0
	i32.const	$push148=, 7
	i32.store	$drop=, bar.lastn($pop524), $pop148
	i32.const	$push523=, 0
	i32.const	$push522=, 0
	i32.store	$drop=, bar.lastc($pop523), $pop522
	i32.const	$push149=, 56
	i32.ne  	$push150=, $0, $pop149
	br_if   	2, $pop150      # 2: down to label6
# BB#27:                                # %if.end3.i391.1
	i32.load8_u	$0=, 321($5)
	i32.const	$push525=, 0
	i32.const	$push151=, 1
	i32.store	$drop=, bar.lastc($pop525), $pop151
	i32.const	$push152=, 57
	i32.ne  	$push153=, $0, $pop152
	br_if   	2, $pop153      # 2: down to label6
# BB#28:                                # %if.end3.i391.2
	i32.load8_u	$0=, 322($5)
	i32.const	$push526=, 0
	i32.const	$push154=, 2
	i32.store	$drop=, bar.lastc($pop526), $pop154
	i32.const	$push155=, 58
	i32.ne  	$push156=, $0, $pop155
	br_if   	2, $pop156      # 2: down to label6
# BB#29:                                # %if.end3.i391.3
	i32.load8_u	$0=, 323($5)
	i32.const	$push527=, 0
	i32.const	$push157=, 3
	i32.store	$drop=, bar.lastc($pop527), $pop157
	i32.const	$push158=, 59
	i32.ne  	$push159=, $0, $pop158
	br_if   	2, $pop159      # 2: down to label6
# BB#30:                                # %if.end3.i391.4
	i32.load8_u	$0=, 324($5)
	i32.const	$push528=, 0
	i32.const	$push160=, 4
	i32.store	$drop=, bar.lastc($pop528), $pop160
	i32.const	$push161=, 60
	i32.ne  	$push162=, $0, $pop161
	br_if   	2, $pop162      # 2: down to label6
# BB#31:                                # %if.end3.i391.5
	i32.load8_u	$0=, 325($5)
	i32.const	$push529=, 0
	i32.const	$push163=, 5
	i32.store	$drop=, bar.lastc($pop529), $pop163
	i32.const	$push164=, 61
	i32.ne  	$push165=, $0, $pop164
	br_if   	2, $pop165      # 2: down to label6
# BB#32:                                # %if.end3.i391.6
	i32.load8_u	$0=, 326($5)
	i32.const	$push530=, 0
	i32.const	$push166=, 6
	i32.store	$drop=, bar.lastc($pop530), $pop166
	i32.const	$push167=, 62
	i32.ne  	$push168=, $0, $pop167
	br_if   	2, $pop168      # 2: down to label6
# BB#33:                                # %if.end3.i405
	i32.const	$push172=, 40
	i32.add 	$push173=, $10, $pop172
	i64.load	$8=, 0($pop173):p2align=0
	i32.const	$push170=, 0
	i32.const	$push169=, 7
	i32.store	$drop=, bar.lastc($pop170), $pop169
	i64.store	$drop=, 312($5), $8
	i32.load8_s	$0=, 312($5)
	i32.const	$push533=, 0
	i32.const	$push174=, 8
	i32.store	$drop=, bar.lastn($pop533), $pop174
	i32.const	$push171=, 48
	i32.add 	$push17=, $10, $pop171
	i32.store	$6=, 4($5), $pop17
	i32.const	$push532=, 0
	i32.const	$push531=, 0
	i32.store	$1=, bar.lastc($pop532), $pop531
	i32.const	$push175=, 64
	i32.ne  	$push176=, $0, $pop175
	br_if   	1, $pop176      # 1: down to label7
# BB#34:                                # %if.end3.i405.1
	i32.load8_s	$9=, 313($5)
	i32.const	$push28=, 1
	i32.store	$0=, bar.lastc($1), $pop28
	i32.const	$push177=, 65
	i32.ne  	$push178=, $9, $pop177
	br_if   	1, $pop178      # 1: down to label7
# BB#35:                                # %if.end3.i405.2
	i32.load8_s	$1=, 314($5)
	i32.const	$push537=, 0
	i32.add 	$push536=, $0, $0
	tee_local	$push535=, $0=, $pop536
	i32.store	$9=, bar.lastc($pop537), $pop535
	i32.const	$push534=, 64
	i32.or  	$push179=, $0, $pop534
	i32.ne  	$push180=, $1, $pop179
	br_if   	1, $pop180      # 1: down to label7
# BB#36:                                # %if.end3.i405.3
	i32.const	$push544=, 0
	i32.const	$push543=, 1
	i32.add 	$push29=, $9, $pop543
	i32.store	$push542=, bar.lastc($pop544), $pop29
	tee_local	$push541=, $0=, $pop542
	i32.const	$push540=, 24
	i32.shl 	$push182=, $pop541, $pop540
	i32.const	$push539=, 24
	i32.shr_s	$push183=, $pop182, $pop539
	i32.const	$push538=, 64
	i32.xor 	$push184=, $pop183, $pop538
	i32.load8_s	$push181=, 315($5)
	i32.ne  	$push185=, $pop184, $pop181
	br_if   	1, $pop185      # 1: down to label7
# BB#37:                                # %if.end3.i405.4
	i32.load8_s	$1=, 316($5)
	i32.const	$push551=, 0
	i32.const	$push550=, 1
	i32.add 	$push549=, $0, $pop550
	tee_local	$push548=, $0=, $pop549
	i32.store	$9=, bar.lastc($pop551), $pop548
	i32.const	$push547=, 24
	i32.shl 	$push186=, $0, $pop547
	i32.const	$push546=, 24
	i32.shr_s	$push187=, $pop186, $pop546
	i32.const	$push545=, 64
	i32.xor 	$push188=, $pop187, $pop545
	i32.ne  	$push189=, $1, $pop188
	br_if   	1, $pop189      # 1: down to label7
# BB#38:                                # %if.end3.i405.5
	i32.const	$push558=, 0
	i32.const	$push557=, 1
	i32.add 	$push30=, $9, $pop557
	i32.store	$push556=, bar.lastc($pop558), $pop30
	tee_local	$push555=, $0=, $pop556
	i32.const	$push554=, 24
	i32.shl 	$push191=, $pop555, $pop554
	i32.const	$push553=, 24
	i32.shr_s	$push192=, $pop191, $pop553
	i32.const	$push552=, 64
	i32.xor 	$push193=, $pop192, $pop552
	i32.load8_s	$push190=, 317($5)
	i32.ne  	$push194=, $pop193, $pop190
	br_if   	1, $pop194      # 1: down to label7
# BB#39:                                # %if.end3.i405.6
	i32.load8_s	$1=, 318($5)
	i32.const	$push565=, 0
	i32.const	$push564=, 1
	i32.add 	$push563=, $0, $pop564
	tee_local	$push562=, $0=, $pop563
	i32.store	$9=, bar.lastc($pop565), $pop562
	i32.const	$push561=, 24
	i32.shl 	$push195=, $0, $pop561
	i32.const	$push560=, 24
	i32.shr_s	$push196=, $pop195, $pop560
	i32.const	$push559=, 64
	i32.xor 	$push197=, $pop196, $pop559
	i32.ne  	$push198=, $1, $pop197
	br_if   	1, $pop198      # 1: down to label7
# BB#40:                                # %if.end3.i405.7
	i32.const	$push572=, 0
	i32.const	$push571=, 1
	i32.add 	$push31=, $9, $pop571
	i32.store	$push570=, bar.lastc($pop572), $pop31
	tee_local	$push569=, $0=, $pop570
	i32.const	$push568=, 24
	i32.shl 	$push200=, $pop569, $pop568
	i32.const	$push567=, 24
	i32.shr_s	$push201=, $pop200, $pop567
	i32.const	$push566=, 64
	i32.xor 	$push202=, $pop201, $pop566
	i32.load8_s	$push199=, 319($5)
	i32.ne  	$push203=, $pop202, $pop199
	br_if   	1, $pop203      # 1: down to label7
# BB#41:                                # %bar.exit408.7
	i32.const	$push578=, 0
	i32.const	$push577=, 1
	i32.add 	$push576=, $0, $pop577
	tee_local	$push575=, $0=, $pop576
	i32.store	$drop=, bar.lastc($pop578), $pop575
	i32.const	$push204=, 60
	i32.add 	$push32=, $10, $pop204
	i32.store	$2=, 4($5), $pop32
	i32.const	$1=, 8
	i32.const	$push208=, 4
	i32.add 	$push209=, $6, $pop208
	i32.load	$9=, 0($pop209):p2align=0
	i32.load	$7=, 0($6):p2align=0
	i32.const	$push411=, 296
	i32.add 	$push412=, $5, $pop411
	i32.const	$push574=, 8
	i32.add 	$push207=, $pop412, $pop574
	i32.const	$push573=, 8
	i32.add 	$push205=, $6, $pop573
	i32.load8_u	$push206=, 0($pop205)
	i32.store8	$drop=, 0($pop207), $pop206
	i32.store	$drop=, 300($5), $9
	i32.store	$drop=, 296($5), $7
	i32.const	$9=, 8
	i32.const	$6=, 0
.LBB1_42:                               # %for.body104
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.const	$push413=, 296
	i32.add 	$push414=, $5, $pop413
	i32.add 	$push210=, $pop414, $6
	i32.load8_s	$7=, 0($pop210)
	block
	i32.const	$push579=, 9
	i32.eq  	$push211=, $9, $pop579
	br_if   	0, $pop211      # 0: down to label12
# BB#43:                                # %if.then.i412
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.ne  	$push212=, $0, $9
	br_if   	3, $pop212      # 3: down to label8
# BB#44:                                # %if.end.i414
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 9
	i32.const	$push582=, 0
	i32.const	$push581=, 0
	i32.store	$push1=, bar.lastc($pop582), $pop581
	i32.const	$push580=, 9
	i32.store	$drop=, bar.lastn($pop1), $pop580
.LBB1_45:                               # %if.end3.i419
                                        #   in Loop: Header=BB1_42 Depth=1
	end_block                       # label12:
	i32.const	$push585=, 24
	i32.shl 	$push213=, $0, $pop585
	i32.const	$push584=, 24
	i32.shr_s	$push214=, $pop213, $pop584
	i32.const	$push583=, 72
	i32.xor 	$push215=, $pop214, $pop583
	i32.ne  	$push216=, $pop215, $7
	br_if   	2, $pop216      # 2: down to label8
# BB#46:                                # %bar.exit422
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.const	$push589=, 1
	i32.add 	$0=, $0, $pop589
	i32.const	$push588=, 0
	i32.store	$drop=, bar.lastc($pop588), $0
	i32.const	$push587=, 1
	i32.add 	$6=, $6, $pop587
	i32.const	$9=, 9
	i32.const	$push586=, 9
	i32.lt_s	$push217=, $6, $pop586
	br_if   	0, $pop217      # 0: up to label10
# BB#47:                                # %for.end110
	end_loop                        # label11:
	i32.const	$push218=, 72
	i32.add 	$push18=, $10, $pop218
	i32.store	$4=, 4($5), $pop18
	i32.const	$push223=, 4
	i32.add 	$push224=, $2, $pop223
	i32.load	$6=, 0($pop224):p2align=0
	i32.load	$9=, 0($2):p2align=0
	i32.const	$push415=, 280
	i32.add 	$push416=, $5, $pop415
	i32.const	$push219=, 8
	i32.add 	$push222=, $pop416, $pop219
	i32.const	$push590=, 8
	i32.add 	$push220=, $2, $pop590
	i32.load16_u	$push221=, 0($pop220):p2align=0
	i32.store16	$drop=, 0($pop222), $pop221
	i32.store	$drop=, 284($5), $6
	i32.store	$drop=, 280($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_48:                               # %for.body116
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$push417=, 280
	i32.add 	$push418=, $5, $pop417
	i32.add 	$push225=, $pop418, $6
	i32.load8_s	$7=, 0($pop225)
	block
	i32.const	$push591=, 10
	i32.eq  	$push226=, $9, $pop591
	br_if   	0, $pop226      # 0: down to label15
# BB#49:                                # %if.then.i426
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.ne  	$push227=, $0, $9
	br_if   	3, $pop227      # 3: down to label8
# BB#50:                                # %if.end.i428
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 10
	i32.const	$push594=, 0
	i32.const	$push593=, 0
	i32.store	$push2=, bar.lastc($pop594), $pop593
	i32.const	$push592=, 10
	i32.store	$drop=, bar.lastn($pop2), $pop592
.LBB1_51:                               # %if.end3.i433
                                        #   in Loop: Header=BB1_48 Depth=1
	end_block                       # label15:
	i32.const	$push597=, 24
	i32.shl 	$push228=, $0, $pop597
	i32.const	$push596=, 24
	i32.shr_s	$push229=, $pop228, $pop596
	i32.const	$push595=, 80
	i32.xor 	$push230=, $pop229, $pop595
	i32.ne  	$push231=, $pop230, $7
	br_if   	2, $pop231      # 2: down to label8
# BB#52:                                # %bar.exit436
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.const	$push601=, 1
	i32.add 	$0=, $0, $pop601
	i32.const	$push600=, 0
	i32.store	$drop=, bar.lastc($pop600), $0
	i32.const	$push599=, 1
	i32.add 	$6=, $6, $pop599
	i32.const	$9=, 10
	i32.const	$push598=, 10
	i32.lt_s	$push232=, $6, $pop598
	br_if   	0, $pop232      # 0: up to label13
# BB#53:                                # %for.end122
	end_loop                        # label14:
	i32.const	$push419=, 264
	i32.add 	$push420=, $5, $pop419
	i32.const	$push234=, 10
	i32.add 	$push237=, $pop420, $pop234
	i32.const	$push603=, 10
	i32.add 	$push235=, $4, $pop603
	i32.load8_u	$push236=, 0($pop235)
	i32.store8	$drop=, 0($pop237), $pop236
	i32.const	$push233=, 84
	i32.add 	$push19=, $10, $pop233
	i32.store	$2=, 4($5), $pop19
	i32.const	$push242=, 4
	i32.add 	$push243=, $4, $pop242
	i32.load	$6=, 0($pop243):p2align=0
	i32.load	$9=, 0($4):p2align=0
	i32.const	$push421=, 264
	i32.add 	$push422=, $5, $pop421
	i32.const	$push238=, 8
	i32.add 	$push241=, $pop422, $pop238
	i32.const	$push602=, 8
	i32.add 	$push239=, $4, $pop602
	i32.load16_u	$push240=, 0($pop239):p2align=0
	i32.store16	$drop=, 0($pop241), $pop240
	i32.store	$drop=, 268($5), $6
	i32.store	$drop=, 264($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_54:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$push423=, 264
	i32.add 	$push424=, $5, $pop423
	i32.add 	$push244=, $pop424, $6
	i32.load8_s	$7=, 0($pop244)
	block
	i32.const	$push604=, 11
	i32.eq  	$push245=, $9, $pop604
	br_if   	0, $pop245      # 0: down to label18
# BB#55:                                # %if.then.i440
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.ne  	$push246=, $0, $9
	br_if   	3, $pop246      # 3: down to label8
# BB#56:                                # %if.end.i442
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 11
	i32.const	$push607=, 0
	i32.const	$push606=, 0
	i32.store	$push3=, bar.lastc($pop607), $pop606
	i32.const	$push605=, 11
	i32.store	$drop=, bar.lastn($pop3), $pop605
.LBB1_57:                               # %if.end3.i447
                                        #   in Loop: Header=BB1_54 Depth=1
	end_block                       # label18:
	i32.const	$push610=, 24
	i32.shl 	$push247=, $0, $pop610
	i32.const	$push609=, 24
	i32.shr_s	$push248=, $pop247, $pop609
	i32.const	$push608=, 88
	i32.xor 	$push249=, $pop248, $pop608
	i32.ne  	$push250=, $pop249, $7
	br_if   	2, $pop250      # 2: down to label8
# BB#58:                                # %bar.exit450
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.const	$push614=, 1
	i32.add 	$0=, $0, $pop614
	i32.const	$push613=, 0
	i32.store	$drop=, bar.lastc($pop613), $0
	i32.const	$push612=, 1
	i32.add 	$6=, $6, $pop612
	i32.const	$9=, 11
	i32.const	$push611=, 11
	i32.lt_s	$push251=, $6, $pop611
	br_if   	0, $pop251      # 0: up to label16
# BB#59:                                # %for.end134
	end_loop                        # label17:
	i32.const	$push616=, 96
	i32.add 	$push20=, $10, $pop616
	i32.store	$4=, 4($5), $pop20
	i32.const	$push256=, 4
	i32.add 	$push257=, $2, $pop256
	i32.load	$6=, 0($pop257):p2align=0
	i32.load	$9=, 0($2):p2align=0
	i32.const	$push425=, 248
	i32.add 	$push426=, $5, $pop425
	i32.const	$push252=, 8
	i32.add 	$push255=, $pop426, $pop252
	i32.const	$push615=, 8
	i32.add 	$push253=, $2, $pop615
	i32.load	$push254=, 0($pop253):p2align=0
	i32.store	$drop=, 0($pop255), $pop254
	i32.store	$drop=, 252($5), $6
	i32.store	$drop=, 248($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_60:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push427=, 248
	i32.add 	$push428=, $5, $pop427
	i32.add 	$push258=, $pop428, $6
	i32.load8_s	$7=, 0($pop258)
	block
	i32.const	$push617=, 12
	i32.eq  	$push259=, $9, $pop617
	br_if   	0, $pop259      # 0: down to label21
# BB#61:                                # %if.then.i454
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.ne  	$push260=, $0, $9
	br_if   	3, $pop260      # 3: down to label8
# BB#62:                                # %if.end.i456
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 12
	i32.const	$push620=, 0
	i32.const	$push619=, 0
	i32.store	$push4=, bar.lastc($pop620), $pop619
	i32.const	$push618=, 12
	i32.store	$drop=, bar.lastn($pop4), $pop618
.LBB1_63:                               # %if.end3.i461
                                        #   in Loop: Header=BB1_60 Depth=1
	end_block                       # label21:
	i32.const	$push623=, 24
	i32.shl 	$push261=, $0, $pop623
	i32.const	$push622=, 24
	i32.shr_s	$push262=, $pop261, $pop622
	i32.const	$push621=, 96
	i32.xor 	$push263=, $pop262, $pop621
	i32.ne  	$push264=, $pop263, $7
	br_if   	2, $pop264      # 2: down to label8
# BB#64:                                # %bar.exit464
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.const	$push627=, 1
	i32.add 	$0=, $0, $pop627
	i32.const	$push626=, 0
	i32.store	$drop=, bar.lastc($pop626), $0
	i32.const	$push625=, 1
	i32.add 	$6=, $6, $pop625
	i32.const	$9=, 12
	i32.const	$push624=, 12
	i32.lt_s	$push265=, $6, $pop624
	br_if   	0, $pop265      # 0: up to label19
# BB#65:                                # %for.end146
	end_loop                        # label20:
	i32.const	$push429=, 232
	i32.add 	$push430=, $5, $pop429
	i32.const	$push267=, 12
	i32.add 	$push270=, $pop430, $pop267
	i32.const	$push629=, 12
	i32.add 	$push268=, $4, $pop629
	i32.load8_u	$push269=, 0($pop268)
	i32.store8	$drop=, 0($pop270), $pop269
	i32.const	$push266=, 112
	i32.add 	$push21=, $10, $pop266
	i32.store	$2=, 4($5), $pop21
	i32.const	$push275=, 4
	i32.add 	$push276=, $4, $pop275
	i32.load	$6=, 0($pop276):p2align=0
	i32.load	$9=, 0($4):p2align=0
	i32.const	$push431=, 232
	i32.add 	$push432=, $5, $pop431
	i32.const	$push271=, 8
	i32.add 	$push274=, $pop432, $pop271
	i32.const	$push628=, 8
	i32.add 	$push272=, $4, $pop628
	i32.load	$push273=, 0($pop272):p2align=0
	i32.store	$drop=, 0($pop274), $pop273
	i32.store	$drop=, 236($5), $6
	i32.store	$drop=, 232($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_66:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.const	$push433=, 232
	i32.add 	$push434=, $5, $pop433
	i32.add 	$push277=, $pop434, $6
	i32.load8_s	$7=, 0($pop277)
	block
	i32.const	$push630=, 13
	i32.eq  	$push278=, $9, $pop630
	br_if   	0, $pop278      # 0: down to label24
# BB#67:                                # %if.then.i468
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.ne  	$push279=, $0, $9
	br_if   	3, $pop279      # 3: down to label8
# BB#68:                                # %if.end.i470
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 13
	i32.const	$push633=, 0
	i32.const	$push632=, 0
	i32.store	$push5=, bar.lastc($pop633), $pop632
	i32.const	$push631=, 13
	i32.store	$drop=, bar.lastn($pop5), $pop631
.LBB1_69:                               # %if.end3.i475
                                        #   in Loop: Header=BB1_66 Depth=1
	end_block                       # label24:
	i32.const	$push636=, 24
	i32.shl 	$push280=, $0, $pop636
	i32.const	$push635=, 24
	i32.shr_s	$push281=, $pop280, $pop635
	i32.const	$push634=, 104
	i32.xor 	$push282=, $pop281, $pop634
	i32.ne  	$push283=, $pop282, $7
	br_if   	2, $pop283      # 2: down to label8
# BB#70:                                # %bar.exit478
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.const	$push640=, 1
	i32.add 	$0=, $0, $pop640
	i32.const	$push639=, 0
	i32.store	$drop=, bar.lastc($pop639), $0
	i32.const	$push638=, 1
	i32.add 	$6=, $6, $pop638
	i32.const	$9=, 13
	i32.const	$push637=, 13
	i32.lt_s	$push284=, $6, $pop637
	br_if   	0, $pop284      # 0: up to label22
# BB#71:                                # %for.end158
	end_loop                        # label23:
	i32.const	$push435=, 216
	i32.add 	$push436=, $5, $pop435
	i32.const	$push286=, 12
	i32.add 	$push289=, $pop436, $pop286
	i32.const	$push642=, 12
	i32.add 	$push287=, $2, $pop642
	i32.load16_u	$push288=, 0($pop287):p2align=0
	i32.store16	$drop=, 0($pop289), $pop288
	i32.const	$push285=, 128
	i32.add 	$push22=, $10, $pop285
	i32.store	$4=, 4($5), $pop22
	i32.const	$push294=, 4
	i32.add 	$push295=, $2, $pop294
	i32.load	$6=, 0($pop295):p2align=0
	i32.load	$9=, 0($2):p2align=0
	i32.const	$push437=, 216
	i32.add 	$push438=, $5, $pop437
	i32.const	$push290=, 8
	i32.add 	$push293=, $pop438, $pop290
	i32.const	$push641=, 8
	i32.add 	$push291=, $2, $pop641
	i32.load	$push292=, 0($pop291):p2align=0
	i32.store	$drop=, 0($pop293), $pop292
	i32.store	$drop=, 220($5), $6
	i32.store	$drop=, 216($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_72:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$push439=, 216
	i32.add 	$push440=, $5, $pop439
	i32.add 	$push296=, $pop440, $6
	i32.load8_s	$7=, 0($pop296)
	block
	i32.const	$push643=, 14
	i32.eq  	$push297=, $9, $pop643
	br_if   	0, $pop297      # 0: down to label27
# BB#73:                                # %if.then.i482
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.ne  	$push298=, $0, $9
	br_if   	3, $pop298      # 3: down to label8
# BB#74:                                # %if.end.i484
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 14
	i32.const	$push646=, 0
	i32.const	$push645=, 0
	i32.store	$push6=, bar.lastc($pop646), $pop645
	i32.const	$push644=, 14
	i32.store	$drop=, bar.lastn($pop6), $pop644
.LBB1_75:                               # %if.end3.i489
                                        #   in Loop: Header=BB1_72 Depth=1
	end_block                       # label27:
	i32.const	$push649=, 24
	i32.shl 	$push299=, $0, $pop649
	i32.const	$push648=, 24
	i32.shr_s	$push300=, $pop299, $pop648
	i32.const	$push647=, 112
	i32.xor 	$push301=, $pop300, $pop647
	i32.ne  	$push302=, $pop301, $7
	br_if   	2, $pop302      # 2: down to label8
# BB#76:                                # %bar.exit492
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.const	$push653=, 1
	i32.add 	$0=, $0, $pop653
	i32.const	$push652=, 0
	i32.store	$drop=, bar.lastc($pop652), $0
	i32.const	$push651=, 1
	i32.add 	$6=, $6, $pop651
	i32.const	$9=, 14
	i32.const	$push650=, 14
	i32.lt_s	$push303=, $6, $pop650
	br_if   	0, $pop303      # 0: up to label25
# BB#77:                                # %for.end170
	end_loop                        # label26:
	i32.const	$push309=, 12
	i32.add 	$push310=, $4, $pop309
	i32.load16_u	$6=, 0($pop310):p2align=0
	i32.const	$push441=, 200
	i32.add 	$push442=, $5, $pop441
	i32.const	$push305=, 14
	i32.add 	$push308=, $pop442, $pop305
	i32.const	$push656=, 14
	i32.add 	$push306=, $4, $pop656
	i32.load8_u	$push307=, 0($pop306)
	i32.store8	$drop=, 0($pop308), $pop307
	i32.const	$push443=, 200
	i32.add 	$push444=, $5, $pop443
	i32.const	$push655=, 12
	i32.add 	$push311=, $pop444, $pop655
	i32.store16	$drop=, 0($pop311), $6
	i32.const	$push304=, 144
	i32.add 	$push23=, $10, $pop304
	i32.store	$2=, 4($5), $pop23
	i32.const	$push316=, 4
	i32.add 	$push317=, $4, $pop316
	i32.load	$6=, 0($pop317):p2align=0
	i32.load	$9=, 0($4):p2align=0
	i32.const	$push445=, 200
	i32.add 	$push446=, $5, $pop445
	i32.const	$push312=, 8
	i32.add 	$push315=, $pop446, $pop312
	i32.const	$push654=, 8
	i32.add 	$push313=, $4, $pop654
	i32.load	$push314=, 0($pop313):p2align=0
	i32.store	$drop=, 0($pop315), $pop314
	i32.store	$drop=, 204($5), $6
	i32.store	$drop=, 200($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_78:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	i32.const	$push447=, 200
	i32.add 	$push448=, $5, $pop447
	i32.add 	$push318=, $pop448, $6
	i32.load8_s	$7=, 0($pop318)
	block
	i32.const	$push657=, 15
	i32.eq  	$push319=, $9, $pop657
	br_if   	0, $pop319      # 0: down to label30
# BB#79:                                # %if.then.i496
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.ne  	$push320=, $0, $9
	br_if   	3, $pop320      # 3: down to label8
# BB#80:                                # %if.end.i498
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 15
	i32.const	$push660=, 0
	i32.const	$push659=, 0
	i32.store	$push7=, bar.lastc($pop660), $pop659
	i32.const	$push658=, 15
	i32.store	$drop=, bar.lastn($pop7), $pop658
.LBB1_81:                               # %if.end3.i503
                                        #   in Loop: Header=BB1_78 Depth=1
	end_block                       # label30:
	i32.const	$push663=, 24
	i32.shl 	$push321=, $0, $pop663
	i32.const	$push662=, 24
	i32.shr_s	$push322=, $pop321, $pop662
	i32.const	$push661=, 120
	i32.xor 	$push323=, $pop322, $pop661
	i32.ne  	$push324=, $pop323, $7
	br_if   	2, $pop324      # 2: down to label8
# BB#82:                                # %bar.exit506
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.const	$push667=, 1
	i32.add 	$0=, $0, $pop667
	i32.const	$push666=, 0
	i32.store	$drop=, bar.lastc($pop666), $0
	i32.const	$push665=, 1
	i32.add 	$6=, $6, $pop665
	i32.const	$9=, 15
	i32.const	$push664=, 15
	i32.lt_s	$push325=, $6, $pop664
	br_if   	0, $pop325      # 0: up to label28
# BB#83:                                # %for.end182
	end_loop                        # label29:
	i32.const	$push449=, 184
	i32.add 	$push450=, $5, $pop449
	i32.const	$push327=, 12
	i32.add 	$push330=, $pop450, $pop327
	i32.const	$push669=, 12
	i32.add 	$push328=, $2, $pop669
	i32.load	$push329=, 0($pop328):p2align=0
	i32.store	$drop=, 0($pop330), $pop329
	i32.const	$push326=, 160
	i32.add 	$push24=, $10, $pop326
	i32.store	$3=, 4($5), $pop24
	i32.const	$push335=, 4
	i32.add 	$push336=, $2, $pop335
	i32.load	$6=, 0($pop336):p2align=0
	i32.load	$9=, 0($2):p2align=0
	i32.const	$push451=, 184
	i32.add 	$push452=, $5, $pop451
	i32.const	$push331=, 8
	i32.add 	$push334=, $pop452, $pop331
	i32.const	$push668=, 8
	i32.add 	$push332=, $2, $pop668
	i32.load	$push333=, 0($pop332):p2align=0
	i32.store	$drop=, 0($pop334), $pop333
	i32.store	$drop=, 188($5), $6
	i32.store	$drop=, 184($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_84:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push453=, 184
	i32.add 	$push454=, $5, $pop453
	i32.add 	$push337=, $pop454, $6
	i32.load8_s	$7=, 0($pop337)
	block
	i32.const	$push670=, 16
	i32.eq  	$push338=, $9, $pop670
	br_if   	0, $pop338      # 0: down to label33
# BB#85:                                # %if.then.i510
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.ne  	$push339=, $0, $9
	br_if   	3, $pop339      # 3: down to label8
# BB#86:                                # %if.end.i512
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 16
	i32.const	$push673=, 0
	i32.const	$push672=, 0
	i32.store	$push8=, bar.lastc($pop673), $pop672
	i32.const	$push671=, 16
	i32.store	$drop=, bar.lastn($pop8), $pop671
.LBB1_87:                               # %if.end3.i517
                                        #   in Loop: Header=BB1_84 Depth=1
	end_block                       # label33:
	i32.const	$push676=, 24
	i32.shl 	$push340=, $0, $pop676
	i32.const	$push675=, -2147483648
	i32.xor 	$push341=, $pop340, $pop675
	i32.const	$push674=, 24
	i32.shr_s	$push342=, $pop341, $pop674
	i32.ne  	$push343=, $pop342, $7
	br_if   	2, $pop343      # 2: down to label8
# BB#88:                                # %bar.exit520
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.const	$push680=, 1
	i32.add 	$0=, $0, $pop680
	i32.const	$push679=, 0
	i32.store	$drop=, bar.lastc($pop679), $0
	i32.const	$push678=, 1
	i32.add 	$6=, $6, $pop678
	i32.const	$9=, 16
	i32.const	$push677=, 16
	i32.lt_s	$push344=, $6, $pop677
	br_if   	0, $pop344      # 0: up to label31
# BB#89:                                # %for.end194
	end_loop                        # label32:
	i32.const	$push345=, 192
	i32.add 	$push25=, $10, $pop345
	i32.store	$4=, 4($5), $pop25
	i32.const	$push455=, 152
	i32.add 	$push456=, $5, $pop455
	i32.const	$push681=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop456, $3, $pop681
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_90:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label34:
	i32.const	$push457=, 152
	i32.add 	$push458=, $5, $pop457
	i32.add 	$push346=, $pop458, $6
	i32.load8_s	$7=, 0($pop346)
	block
	i32.const	$push682=, 31
	i32.eq  	$push347=, $9, $pop682
	br_if   	0, $pop347      # 0: down to label36
# BB#91:                                # %if.then.i524
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.ne  	$push348=, $0, $9
	br_if   	3, $pop348      # 3: down to label8
# BB#92:                                # %if.end.i526
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 31
	i32.const	$push685=, 0
	i32.const	$push684=, 0
	i32.store	$push9=, bar.lastc($pop685), $pop684
	i32.const	$push683=, 31
	i32.store	$drop=, bar.lastn($pop9), $pop683
.LBB1_93:                               # %if.end3.i531
                                        #   in Loop: Header=BB1_90 Depth=1
	end_block                       # label36:
	i32.const	$push688=, 24
	i32.shl 	$push349=, $0, $pop688
	i32.const	$push687=, -134217728
	i32.xor 	$push350=, $pop349, $pop687
	i32.const	$push686=, 24
	i32.shr_s	$push351=, $pop350, $pop686
	i32.ne  	$push352=, $pop351, $7
	br_if   	2, $pop352      # 2: down to label8
# BB#94:                                # %bar.exit534
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.const	$push692=, 1
	i32.add 	$0=, $0, $pop692
	i32.const	$push691=, 0
	i32.store	$drop=, bar.lastc($pop691), $0
	i32.const	$push690=, 1
	i32.add 	$6=, $6, $pop690
	i32.const	$9=, 31
	i32.const	$push689=, 31
	i32.lt_s	$push353=, $6, $pop689
	br_if   	0, $pop353      # 0: up to label34
# BB#95:                                # %for.end206
	end_loop                        # label35:
	i32.const	$push459=, 120
	i32.add 	$push460=, $5, $pop459
	i32.const	$push355=, 28
	i32.add 	$push358=, $pop460, $pop355
	i32.const	$push699=, 28
	i32.add 	$push356=, $4, $pop699
	i32.load	$push357=, 0($pop356):p2align=0
	i32.store	$drop=, 0($pop358), $pop357
	i32.const	$push362=, 20
	i32.add 	$push363=, $4, $pop362
	i32.load	$6=, 0($pop363):p2align=0
	i32.const	$push461=, 120
	i32.add 	$push462=, $5, $pop461
	i32.const	$push698=, 24
	i32.add 	$push361=, $pop462, $pop698
	i32.const	$push697=, 24
	i32.add 	$push359=, $4, $pop697
	i32.load	$push360=, 0($pop359):p2align=0
	i32.store	$drop=, 0($pop361), $pop360
	i32.const	$push463=, 120
	i32.add 	$push464=, $5, $pop463
	i32.const	$push696=, 20
	i32.add 	$push364=, $pop464, $pop696
	i32.store	$drop=, 0($pop364), $6
	i32.const	$push369=, 12
	i32.add 	$push370=, $4, $pop369
	i32.load	$6=, 0($pop370):p2align=0
	i32.const	$push465=, 120
	i32.add 	$push466=, $5, $pop465
	i32.const	$push365=, 16
	i32.add 	$push368=, $pop466, $pop365
	i32.const	$push695=, 16
	i32.add 	$push366=, $4, $pop695
	i32.load	$push367=, 0($pop366):p2align=0
	i32.store	$drop=, 0($pop368), $pop367
	i32.const	$push467=, 120
	i32.add 	$push468=, $5, $pop467
	i32.const	$push694=, 12
	i32.add 	$push371=, $pop468, $pop694
	i32.store	$drop=, 0($pop371), $6
	i32.const	$push354=, 224
	i32.add 	$push26=, $10, $pop354
	i32.store	$2=, 4($5), $pop26
	i32.const	$push376=, 4
	i32.add 	$push377=, $4, $pop376
	i32.load	$6=, 0($pop377):p2align=0
	i32.load	$9=, 0($4):p2align=0
	i32.const	$push469=, 120
	i32.add 	$push470=, $5, $pop469
	i32.const	$push372=, 8
	i32.add 	$push375=, $pop470, $pop372
	i32.const	$push693=, 8
	i32.add 	$push373=, $4, $pop693
	i32.load	$push374=, 0($pop373):p2align=0
	i32.store	$drop=, 0($pop375), $pop374
	i32.store	$drop=, 124($5), $6
	i32.store	$drop=, 120($5), $9
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_96:                               # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label37:
	i32.const	$push471=, 120
	i32.add 	$push472=, $5, $pop471
	i32.add 	$push378=, $pop472, $6
	i32.load8_s	$7=, 0($pop378)
	block
	i32.const	$push700=, 32
	i32.eq  	$push379=, $9, $pop700
	br_if   	0, $pop379      # 0: down to label39
# BB#97:                                # %if.then.i538
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.ne  	$push380=, $0, $9
	br_if   	3, $pop380      # 3: down to label8
# BB#98:                                # %if.end.i540
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 32
	i32.const	$push703=, 0
	i32.const	$push702=, 0
	i32.store	$push10=, bar.lastc($pop703), $pop702
	i32.const	$push701=, 32
	i32.store	$drop=, bar.lastn($pop10), $pop701
.LBB1_99:                               # %if.end3.i545
                                        #   in Loop: Header=BB1_96 Depth=1
	end_block                       # label39:
	i32.const	$push705=, 24
	i32.shl 	$push381=, $0, $pop705
	i32.const	$push704=, 24
	i32.shr_s	$push382=, $pop381, $pop704
	i32.ne  	$push383=, $pop382, $7
	br_if   	2, $pop383      # 2: down to label8
# BB#100:                               # %bar.exit548
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.const	$push709=, 1
	i32.add 	$0=, $0, $pop709
	i32.const	$push708=, 0
	i32.store	$drop=, bar.lastc($pop708), $0
	i32.const	$push707=, 1
	i32.add 	$6=, $6, $pop707
	i32.const	$9=, 32
	i32.const	$push706=, 32
	i32.lt_s	$push384=, $6, $pop706
	br_if   	0, $pop384      # 0: up to label37
# BB#101:                               # %for.end218
	end_loop                        # label38:
	i32.const	$push385=, 260
	i32.add 	$push27=, $10, $pop385
	i32.store	$4=, 4($5), $pop27
	i32.const	$push473=, 80
	i32.add 	$push474=, $5, $pop473
	i32.const	$push710=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop474, $2, $pop710
	copy_local	$9=, $1
	i32.const	$6=, 0
.LBB1_102:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label40:
	i32.const	$push475=, 80
	i32.add 	$push476=, $5, $pop475
	i32.add 	$push386=, $pop476, $6
	i32.load8_s	$7=, 0($pop386)
	block
	i32.const	$push711=, 35
	i32.eq  	$push387=, $9, $pop711
	br_if   	0, $pop387      # 0: down to label42
# BB#103:                               # %if.then.i552
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.ne  	$push388=, $0, $9
	br_if   	3, $pop388      # 3: down to label8
# BB#104:                               # %if.end.i554
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.const	$0=, 0
	i32.const	$1=, 35
	i32.const	$push714=, 0
	i32.const	$push713=, 0
	i32.store	$push11=, bar.lastc($pop714), $pop713
	i32.const	$push712=, 35
	i32.store	$drop=, bar.lastn($pop11), $pop712
.LBB1_105:                              # %if.end3.i559
                                        #   in Loop: Header=BB1_102 Depth=1
	end_block                       # label42:
	i32.const	$push717=, 24
	i32.shl 	$push389=, $0, $pop717
	i32.const	$push716=, 24
	i32.shr_s	$push390=, $pop389, $pop716
	i32.const	$push715=, 24
	i32.xor 	$push391=, $pop390, $pop715
	i32.ne  	$push392=, $pop391, $7
	br_if   	2, $pop392      # 2: down to label8
# BB#106:                               # %bar.exit562
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.const	$push721=, 1
	i32.add 	$0=, $0, $pop721
	i32.const	$push720=, 0
	i32.store	$drop=, bar.lastc($pop720), $0
	i32.const	$push719=, 1
	i32.add 	$6=, $6, $pop719
	i32.const	$9=, 35
	i32.const	$push718=, 35
	i32.lt_s	$push393=, $6, $pop718
	br_if   	0, $pop393      # 0: up to label40
# BB#107:                               # %for.end230
	end_loop                        # label41:
	i32.const	$push394=, 332
	i32.add 	$push395=, $10, $pop394
	i32.store	$drop=, 4($5), $pop395
	i32.const	$push477=, 8
	i32.add 	$push478=, $5, $pop477
	i32.const	$push722=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop478, $4, $pop722
	i32.const	$6=, 0
.LBB1_108:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label43:
	i32.const	$push479=, 8
	i32.add 	$push480=, $5, $pop479
	i32.add 	$push396=, $pop480, $6
	i32.load8_s	$9=, 0($pop396)
	block
	i32.const	$push723=, 72
	i32.eq  	$push397=, $1, $pop723
	br_if   	0, $pop397      # 0: down to label45
# BB#109:                               # %if.then.i566
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.ne  	$push398=, $0, $1
	br_if   	3, $pop398      # 3: down to label8
# BB#110:                               # %if.end.i568
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.const	$0=, 0
	i32.const	$push726=, 0
	i32.const	$push725=, 0
	i32.store	$push12=, bar.lastc($pop726), $pop725
	i32.const	$push724=, 72
	i32.store	$drop=, bar.lastn($pop12), $pop724
.LBB1_111:                              # %if.end3.i573
                                        #   in Loop: Header=BB1_108 Depth=1
	end_block                       # label45:
	i32.const	$push729=, 24
	i32.shl 	$push399=, $0, $pop729
	i32.const	$push728=, 24
	i32.shr_s	$push400=, $pop399, $pop728
	i32.const	$push727=, 64
	i32.xor 	$push401=, $pop400, $pop727
	i32.ne  	$push402=, $pop401, $9
	br_if   	2, $pop402      # 2: down to label8
# BB#112:                               # %bar.exit576
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.const	$push733=, 1
	i32.add 	$0=, $0, $pop733
	i32.const	$push732=, 0
	i32.store	$drop=, bar.lastc($pop732), $0
	i32.const	$push731=, 1
	i32.add 	$6=, $6, $pop731
	i32.const	$1=, 72
	i32.const	$push730=, 72
	i32.lt_s	$push403=, $6, $pop730
	br_if   	0, $pop403      # 0: up to label43
# BB#113:                               # %for.end242
	end_loop                        # label44:
	i32.const	$push410=, __stack_pointer
	i32.const	$push408=, 352
	i32.add 	$push409=, $5, $pop408
	i32.store	$drop=, 0($pop410), $pop409
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
	i32.const	$push286=, __stack_pointer
	i32.const	$push283=, __stack_pointer
	i32.load	$push284=, 0($pop283)
	i32.const	$push285=, 768
	i32.sub 	$push413=, $pop284, $pop285
	i32.store	$push415=, 0($pop286), $pop413
	tee_local	$push414=, $2=, $pop415
	i32.const	$push28=, 4368
	i32.store16	$drop=, 760($pop414), $pop28
	i32.const	$push29=, 24
	i32.store8	$drop=, 752($2), $pop29
	i32.const	$push30=, 25
	i32.store8	$drop=, 753($2), $pop30
	i32.const	$push31=, 26
	i32.store8	$drop=, 754($2), $pop31
	i32.const	$push32=, 32
	i32.store8	$drop=, 744($2), $pop32
	i32.const	$push33=, 33
	i32.store8	$drop=, 745($2), $pop33
	i32.const	$push34=, 34
	i32.store8	$drop=, 746($2), $pop34
	i32.const	$push35=, 35
	i32.store8	$drop=, 747($2), $pop35
	i32.const	$push36=, 40
	i32.store8	$drop=, 736($2), $pop36
	i32.const	$push37=, 41
	i32.store8	$drop=, 737($2), $pop37
	i32.const	$push38=, 42
	i32.store8	$drop=, 738($2), $pop38
	i32.const	$push39=, 43
	i32.store8	$drop=, 739($2), $pop39
	i32.const	$push40=, 44
	i32.store8	$drop=, 740($2), $pop40
	i32.const	$push41=, 48
	i32.store8	$drop=, 728($2), $pop41
	i32.const	$push42=, 49
	i32.store8	$drop=, 729($2), $pop42
	i32.const	$push43=, 50
	i32.store8	$drop=, 730($2), $pop43
	i32.const	$push44=, 51
	i32.store8	$drop=, 731($2), $pop44
	i32.const	$push45=, 52
	i32.store8	$drop=, 732($2), $pop45
	i32.const	$push46=, 53
	i32.store8	$drop=, 733($2), $pop46
	i32.const	$push47=, 56
	i32.store8	$drop=, 720($2), $pop47
	i32.const	$push48=, 57
	i32.store8	$drop=, 721($2), $pop48
	i32.const	$push49=, 58
	i32.store8	$drop=, 722($2), $pop49
	i32.const	$push50=, 59
	i32.store8	$drop=, 723($2), $pop50
	i32.const	$push51=, 60
	i32.store8	$drop=, 724($2), $pop51
	i32.const	$push52=, 61
	i32.store8	$drop=, 725($2), $pop52
	i32.const	$push53=, 62
	i32.store8	$drop=, 726($2), $pop53
	i32.const	$push55=, 65
	i32.store8	$drop=, 713($2), $pop55
	i32.const	$push56=, 66
	i32.store8	$drop=, 714($2), $pop56
	i32.const	$push57=, 67
	i32.store8	$drop=, 715($2), $pop57
	i32.const	$push58=, 68
	i32.store8	$drop=, 716($2), $pop58
	i32.const	$push59=, 69
	i32.store8	$drop=, 717($2), $pop59
	i32.const	$push60=, 70
	i32.store8	$drop=, 718($2), $pop60
	i32.const	$push61=, 71
	i32.store8	$drop=, 719($2), $pop61
	i32.const	$push62=, 72
	i32.store8	$drop=, 696($2), $pop62
	i32.const	$push63=, 73
	i32.store8	$drop=, 697($2), $pop63
	i32.const	$push64=, 74
	i32.store8	$drop=, 698($2), $pop64
	i32.const	$push65=, 75
	i32.store8	$drop=, 699($2), $pop65
	i32.const	$push66=, 76
	i32.store8	$drop=, 700($2), $pop66
	i32.const	$push67=, 77
	i32.store8	$drop=, 701($2), $pop67
	i32.const	$push68=, 78
	i32.store8	$drop=, 702($2), $pop68
	i32.const	$push69=, 79
	i32.store8	$drop=, 703($2), $pop69
	i32.const	$push54=, 64
	i32.store8	$push0=, 712($2), $pop54
	i32.store8	$drop=, 704($2), $pop0
	i32.const	$push73=, 83
	i32.store8	$drop=, 683($2), $pop73
	i32.const	$push74=, 84
	i32.store8	$drop=, 684($2), $pop74
	i32.const	$push75=, 85
	i32.store8	$drop=, 685($2), $pop75
	i32.const	$push76=, 86
	i32.store8	$drop=, 686($2), $pop76
	i32.const	$push77=, 87
	i32.store8	$drop=, 687($2), $pop77
	i32.const	$push78=, 88
	i32.store8	$push4=, 688($2), $pop78
	i32.store8	$drop=, 664($2), $pop4
	i32.const	$push79=, 89
	i32.store8	$push5=, 689($2), $pop79
	i32.store8	$drop=, 665($2), $pop5
	i32.const	$push80=, 90
	i32.store8	$drop=, 666($2), $pop80
	i32.const	$push81=, 91
	i32.store8	$drop=, 667($2), $pop81
	i32.const	$push82=, 92
	i32.store8	$drop=, 668($2), $pop82
	i32.const	$push83=, 93
	i32.store8	$drop=, 669($2), $pop83
	i32.const	$push84=, 94
	i32.store8	$drop=, 670($2), $pop84
	i32.const	$push85=, 95
	i32.store8	$drop=, 671($2), $pop85
	i32.const	$push70=, 80
	i32.store8	$push1=, 680($2), $pop70
	i32.store8	$drop=, 672($2), $pop1
	i32.const	$push71=, 81
	i32.store8	$push2=, 681($2), $pop71
	i32.store8	$drop=, 673($2), $pop2
	i32.const	$push72=, 82
	i32.store8	$push3=, 682($2), $pop72
	i32.store8	$drop=, 674($2), $pop3
	i32.const	$push91=, 101
	i32.store8	$drop=, 653($2), $pop91
	i32.const	$push92=, 102
	i32.store8	$drop=, 654($2), $pop92
	i32.const	$push93=, 103
	i32.store8	$drop=, 655($2), $pop93
	i32.const	$push94=, 104
	i32.store8	$push11=, 656($2), $pop94
	i32.store8	$drop=, 632($2), $pop11
	i32.const	$push95=, 105
	i32.store8	$push12=, 657($2), $pop95
	i32.store8	$drop=, 633($2), $pop12
	i32.const	$push96=, 106
	i32.store8	$push13=, 658($2), $pop96
	i32.store8	$drop=, 634($2), $pop13
	i32.const	$push97=, 107
	i32.store8	$push14=, 659($2), $pop97
	i32.store8	$drop=, 635($2), $pop14
	i32.const	$push98=, 108
	i32.store8	$drop=, 636($2), $pop98
	i32.const	$push99=, 109
	i32.store8	$drop=, 637($2), $pop99
	i32.const	$push100=, 110
	i32.store8	$drop=, 638($2), $pop100
	i32.const	$push101=, 111
	i32.store8	$drop=, 639($2), $pop101
	i32.const	$push86=, 96
	i32.store8	$push6=, 648($2), $pop86
	i32.store8	$drop=, 640($2), $pop6
	i32.const	$push87=, 97
	i32.store8	$push7=, 649($2), $pop87
	i32.store8	$drop=, 641($2), $pop7
	i32.const	$push88=, 98
	i32.store8	$push8=, 650($2), $pop88
	i32.store8	$drop=, 642($2), $pop8
	i32.const	$push89=, 99
	i32.store8	$push9=, 651($2), $pop89
	i32.store8	$drop=, 643($2), $pop9
	i32.const	$push90=, 100
	i32.store8	$push10=, 652($2), $pop90
	i32.store8	$drop=, 644($2), $pop10
	i32.const	$push109=, 119
	i32.store8	$drop=, 623($2), $pop109
	i32.const	$push110=, 120
	i32.store8	$push22=, 624($2), $pop110
	i32.store8	$drop=, 600($2), $pop22
	i32.const	$push111=, 121
	i32.store8	$push23=, 625($2), $pop111
	i32.store8	$drop=, 601($2), $pop23
	i32.const	$push112=, 122
	i32.store8	$push24=, 626($2), $pop112
	i32.store8	$drop=, 602($2), $pop24
	i32.const	$push113=, 123
	i32.store8	$push25=, 627($2), $pop113
	i32.store8	$drop=, 603($2), $pop25
	i32.const	$push114=, 124
	i32.store8	$push26=, 628($2), $pop114
	i32.store8	$drop=, 604($2), $pop26
	i32.const	$push115=, 125
	i32.store8	$push27=, 629($2), $pop115
	i32.store8	$drop=, 605($2), $pop27
	i32.const	$push116=, 126
	i32.store8	$drop=, 606($2), $pop116
	i32.const	$push117=, 127
	i32.store8	$drop=, 607($2), $pop117
	i32.const	$push102=, 112
	i32.store8	$push15=, 616($2), $pop102
	i32.store8	$drop=, 608($2), $pop15
	i32.const	$push103=, 113
	i32.store8	$push16=, 617($2), $pop103
	i32.store8	$drop=, 609($2), $pop16
	i32.const	$push104=, 114
	i32.store8	$push17=, 618($2), $pop104
	i32.store8	$drop=, 610($2), $pop17
	i32.const	$push105=, 115
	i32.store8	$push18=, 619($2), $pop105
	i32.store8	$drop=, 611($2), $pop18
	i32.const	$push106=, 116
	i32.store8	$push19=, 620($2), $pop106
	i32.store8	$drop=, 612($2), $pop19
	i32.const	$push107=, 117
	i32.store8	$push20=, 621($2), $pop107
	i32.store8	$drop=, 613($2), $pop20
	i32.const	$push108=, 118
	i32.store8	$push21=, 622($2), $pop108
	i32.store8	$drop=, 614($2), $pop21
	i32.const	$push118=, 128
	i32.store8	$drop=, 584($2), $pop118
	i32.const	$push119=, 129
	i32.store8	$drop=, 585($2), $pop119
	i32.const	$push120=, 130
	i32.store8	$drop=, 586($2), $pop120
	i32.const	$push121=, 131
	i32.store8	$drop=, 587($2), $pop121
	i32.const	$push122=, 132
	i32.store8	$drop=, 588($2), $pop122
	i32.const	$push123=, 133
	i32.store8	$drop=, 589($2), $pop123
	i32.const	$push124=, 134
	i32.store8	$drop=, 590($2), $pop124
	i32.const	$push125=, 135
	i32.store8	$drop=, 591($2), $pop125
	i32.const	$push126=, 136
	i32.store8	$drop=, 592($2), $pop126
	i32.const	$push127=, 137
	i32.store8	$drop=, 593($2), $pop127
	i32.const	$push128=, 138
	i32.store8	$drop=, 594($2), $pop128
	i32.const	$push129=, 139
	i32.store8	$drop=, 595($2), $pop129
	i32.const	$push130=, 140
	i32.store8	$drop=, 596($2), $pop130
	i32.const	$push131=, 141
	i32.store8	$drop=, 597($2), $pop131
	i32.const	$push132=, 142
	i32.store8	$drop=, 598($2), $pop132
	i32.const	$push133=, 143
	i32.store8	$drop=, 599($2), $pop133
	i32.const	$1=, 0
.LBB2_1:                                # %for.body180
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label46:
	i32.const	$push287=, 552
	i32.add 	$push288=, $2, $pop287
	i32.add 	$push135=, $pop288, $1
	i32.const	$push418=, 248
	i32.xor 	$push134=, $1, $pop418
	i32.store8	$drop=, 0($pop135), $pop134
	i32.const	$push417=, 1
	i32.add 	$1=, $1, $pop417
	i32.const	$push416=, 31
	i32.ne  	$push136=, $1, $pop416
	br_if   	0, $pop136      # 0: up to label46
# BB#2:                                 # %for.body191.preheader
	end_loop                        # label47:
	i32.const	$push137=, 50462976
	i32.store	$drop=, 520($2), $pop137
	i32.const	$push138=, 1284
	i32.store16	$drop=, 524($2), $pop138
	i32.const	$push139=, 151521030
	i32.store	$drop=, 526($2):p2align=1, $pop139
	i32.const	$push140=, 2826
	i32.store16	$drop=, 530($2), $pop140
	i32.const	$push141=, 3340
	i32.store16	$drop=, 532($2), $pop141
	i32.const	$push142=, 14
	i32.store8	$drop=, 534($2), $pop142
	i32.const	$push143=, 15
	i32.store8	$drop=, 535($2), $pop143
	i32.const	$push144=, 16
	i32.store8	$drop=, 536($2), $pop144
	i32.const	$push145=, 17
	i32.store8	$drop=, 537($2), $pop145
	i32.const	$push146=, 18
	i32.store8	$drop=, 538($2), $pop146
	i32.const	$push147=, 19
	i32.store8	$drop=, 539($2), $pop147
	i32.const	$push148=, 20
	i32.store8	$drop=, 540($2), $pop148
	i32.const	$push149=, 21
	i32.store8	$drop=, 541($2), $pop149
	i32.const	$push150=, 22
	i32.store8	$drop=, 542($2), $pop150
	i32.const	$push151=, 23
	i32.store8	$drop=, 543($2), $pop151
	i32.const	$push153=, 25
	i32.store8	$drop=, 545($2), $pop153
	i32.const	$push154=, 26
	i32.store8	$drop=, 546($2), $pop154
	i32.const	$push155=, 27
	i32.store8	$drop=, 547($2), $pop155
	i32.const	$push156=, 28
	i32.store8	$drop=, 548($2), $pop156
	i32.const	$push157=, 29
	i32.store8	$drop=, 549($2), $pop157
	i32.const	$push158=, 30
	i32.store8	$drop=, 550($2), $pop158
	i32.const	$push159=, 31
	i32.store8	$drop=, 551($2), $pop159
	i32.const	$push152=, 24
	i32.store8	$0=, 544($2), $pop152
	i32.const	$1=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label48:
	i32.const	$push289=, 480
	i32.add 	$push290=, $2, $pop289
	i32.add 	$push161=, $pop290, $1
	i32.xor 	$push160=, $1, $0
	i32.store8	$drop=, 0($pop161), $pop160
	i32.const	$push420=, 1
	i32.add 	$1=, $1, $pop420
	i32.const	$push419=, 35
	i32.ne  	$push162=, $1, $pop419
	br_if   	0, $pop162      # 0: up to label48
# BB#4:                                 # %for.body213.preheader
	end_loop                        # label49:
	i32.const	$1=, 0
.LBB2_5:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label50:
	i32.const	$push291=, 408
	i32.add 	$push292=, $2, $pop291
	i32.add 	$push164=, $pop292, $1
	i32.const	$push423=, 64
	i32.xor 	$push163=, $1, $pop423
	i32.store8	$drop=, 0($pop164), $pop163
	i32.const	$push422=, 1
	i32.add 	$1=, $1, $pop422
	i32.const	$push421=, 72
	i32.ne  	$push165=, $1, $pop421
	br_if   	0, $pop165      # 0: up to label50
# BB#6:                                 # %for.end220
	end_loop                        # label51:
	i32.const	$push166=, 404
	i32.add 	$push167=, $2, $pop166
	i32.load8_u	$push168=, 754($2)
	i32.store8	$drop=, 0($pop167), $pop168
	i32.load16_u	$push169=, 760($2)
	i32.store16	$drop=, 406($2), $pop169
	i32.load16_u	$push170=, 752($2)
	i32.store16	$drop=, 402($2), $pop170
	i32.load	$push171=, 744($2)
	i32.store	$drop=, 396($2), $pop171
	i32.const	$push293=, 388
	i32.add 	$push294=, $2, $pop293
	i32.const	$push172=, 4
	i32.add 	$push173=, $pop294, $pop172
	i32.load8_u	$push174=, 740($2)
	i32.store8	$drop=, 0($pop173), $pop174
	i32.load	$push175=, 736($2)
	i32.store	$drop=, 388($2), $pop175
	i32.const	$push295=, 380
	i32.add 	$push296=, $2, $pop295
	i32.const	$push455=, 4
	i32.add 	$push176=, $pop296, $pop455
	i32.load16_u	$push177=, 732($2)
	i32.store16	$drop=, 0($pop176), $pop177
	i32.load	$push178=, 728($2)
	i32.store	$drop=, 380($2), $pop178
	i32.const	$push179=, 378
	i32.add 	$push180=, $2, $pop179
	i32.load8_u	$push181=, 726($2)
	i32.store8	$drop=, 0($pop180), $pop181
	i32.const	$push297=, 372
	i32.add 	$push298=, $2, $pop297
	i32.const	$push454=, 4
	i32.add 	$push182=, $pop298, $pop454
	i32.load16_u	$push183=, 724($2)
	i32.store16	$drop=, 0($pop182), $pop183
	i32.load	$push184=, 720($2)
	i32.store	$drop=, 372($2), $pop184
	i64.load	$push185=, 712($2)
	i64.store	$drop=, 364($2):p2align=2, $pop185
	i32.const	$push301=, 352
	i32.add 	$push302=, $2, $pop301
	i32.const	$push186=, 8
	i32.add 	$push187=, $pop302, $pop186
	i32.const	$push299=, 696
	i32.add 	$push300=, $2, $pop299
	i32.const	$push453=, 8
	i32.add 	$push188=, $pop300, $pop453
	i32.load8_u	$push189=, 0($pop188)
	i32.store8	$drop=, 0($pop187), $pop189
	i64.load	$push190=, 696($2)
	i64.store	$drop=, 352($2):p2align=2, $pop190
	i32.const	$push305=, 340
	i32.add 	$push306=, $2, $pop305
	i32.const	$push452=, 8
	i32.add 	$push191=, $pop306, $pop452
	i32.const	$push303=, 680
	i32.add 	$push304=, $2, $pop303
	i32.const	$push451=, 8
	i32.add 	$push192=, $pop304, $pop451
	i32.load16_u	$push193=, 0($pop192)
	i32.store16	$drop=, 0($pop191), $pop193
	i64.load	$push194=, 680($2)
	i64.store	$drop=, 340($2):p2align=2, $pop194
	i32.const	$push309=, 328
	i32.add 	$push310=, $2, $pop309
	i32.const	$push195=, 10
	i32.add 	$push196=, $pop310, $pop195
	i32.const	$push307=, 664
	i32.add 	$push308=, $2, $pop307
	i32.const	$push450=, 10
	i32.add 	$push197=, $pop308, $pop450
	i32.load8_u	$push198=, 0($pop197)
	i32.store8	$drop=, 0($pop196), $pop198
	i32.const	$push313=, 328
	i32.add 	$push314=, $2, $pop313
	i32.const	$push449=, 8
	i32.add 	$push199=, $pop314, $pop449
	i32.const	$push311=, 664
	i32.add 	$push312=, $2, $pop311
	i32.const	$push448=, 8
	i32.add 	$push200=, $pop312, $pop448
	i32.load16_u	$push201=, 0($pop200)
	i32.store16	$drop=, 0($pop199), $pop201
	i64.load	$push202=, 664($2)
	i64.store	$drop=, 328($2):p2align=2, $pop202
	i32.const	$push317=, 316
	i32.add 	$push318=, $2, $pop317
	i32.const	$push447=, 8
	i32.add 	$push203=, $pop318, $pop447
	i32.const	$push315=, 648
	i32.add 	$push316=, $2, $pop315
	i32.const	$push446=, 8
	i32.add 	$push204=, $pop316, $pop446
	i32.load	$push205=, 0($pop204)
	i32.store	$drop=, 0($pop203), $pop205
	i64.load	$push206=, 648($2)
	i64.store	$drop=, 316($2):p2align=2, $pop206
	i32.const	$push321=, 300
	i32.add 	$push322=, $2, $pop321
	i32.const	$push207=, 12
	i32.add 	$push208=, $pop322, $pop207
	i32.const	$push319=, 632
	i32.add 	$push320=, $2, $pop319
	i32.const	$push445=, 12
	i32.add 	$push209=, $pop320, $pop445
	i32.load8_u	$push210=, 0($pop209)
	i32.store8	$drop=, 0($pop208), $pop210
	i32.const	$push325=, 300
	i32.add 	$push326=, $2, $pop325
	i32.const	$push444=, 8
	i32.add 	$push211=, $pop326, $pop444
	i32.const	$push323=, 632
	i32.add 	$push324=, $2, $pop323
	i32.const	$push443=, 8
	i32.add 	$push212=, $pop324, $pop443
	i32.load	$push213=, 0($pop212)
	i32.store	$drop=, 0($pop211), $pop213
	i64.load	$push214=, 632($2)
	i64.store	$drop=, 300($2):p2align=2, $pop214
	i32.const	$push329=, 284
	i32.add 	$push330=, $2, $pop329
	i32.const	$push442=, 12
	i32.add 	$push215=, $pop330, $pop442
	i32.const	$push327=, 616
	i32.add 	$push328=, $2, $pop327
	i32.const	$push441=, 12
	i32.add 	$push216=, $pop328, $pop441
	i32.load16_u	$push217=, 0($pop216)
	i32.store16	$drop=, 0($pop215), $pop217
	i32.const	$push333=, 284
	i32.add 	$push334=, $2, $pop333
	i32.const	$push440=, 8
	i32.add 	$push218=, $pop334, $pop440
	i32.const	$push331=, 616
	i32.add 	$push332=, $2, $pop331
	i32.const	$push439=, 8
	i32.add 	$push219=, $pop332, $pop439
	i32.load	$push220=, 0($pop219)
	i32.store	$drop=, 0($pop218), $pop220
	i64.load	$push221=, 616($2)
	i64.store	$drop=, 284($2):p2align=2, $pop221
	i32.const	$push337=, 268
	i32.add 	$push338=, $2, $pop337
	i32.const	$push222=, 14
	i32.add 	$push223=, $pop338, $pop222
	i32.const	$push335=, 600
	i32.add 	$push336=, $2, $pop335
	i32.const	$push438=, 14
	i32.add 	$push224=, $pop336, $pop438
	i32.load8_u	$push225=, 0($pop224)
	i32.store8	$drop=, 0($pop223), $pop225
	i32.const	$push341=, 268
	i32.add 	$push342=, $2, $pop341
	i32.const	$push437=, 12
	i32.add 	$push226=, $pop342, $pop437
	i32.const	$push339=, 600
	i32.add 	$push340=, $2, $pop339
	i32.const	$push436=, 12
	i32.add 	$push227=, $pop340, $pop436
	i32.load16_u	$push228=, 0($pop227)
	i32.store16	$drop=, 0($pop226), $pop228
	i32.const	$push345=, 268
	i32.add 	$push346=, $2, $pop345
	i32.const	$push435=, 8
	i32.add 	$push229=, $pop346, $pop435
	i32.const	$push343=, 600
	i32.add 	$push344=, $2, $pop343
	i32.const	$push434=, 8
	i32.add 	$push230=, $pop344, $pop434
	i32.load	$push231=, 0($pop230)
	i32.store	$drop=, 0($pop229), $pop231
	i64.load	$push232=, 600($2)
	i64.store	$drop=, 268($2):p2align=2, $pop232
	i32.const	$push349=, 252
	i32.add 	$push350=, $2, $pop349
	i32.const	$push433=, 8
	i32.add 	$push233=, $pop350, $pop433
	i32.const	$push347=, 584
	i32.add 	$push348=, $2, $pop347
	i32.const	$push432=, 8
	i32.add 	$push234=, $pop348, $pop432
	i64.load	$push235=, 0($pop234)
	i64.store	$drop=, 0($pop233):p2align=2, $pop235
	i64.load	$push236=, 584($2)
	i64.store	$drop=, 252($2):p2align=2, $pop236
	i32.const	$push351=, 221
	i32.add 	$push352=, $2, $pop351
	i32.const	$push353=, 552
	i32.add 	$push354=, $2, $pop353
	i32.const	$push237=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop352, $pop354, $pop237
	i32.const	$push357=, 188
	i32.add 	$push358=, $2, $pop357
	i32.const	$push238=, 24
	i32.add 	$push239=, $pop358, $pop238
	i32.const	$push355=, 520
	i32.add 	$push356=, $2, $pop355
	i32.const	$push431=, 24
	i32.add 	$push240=, $pop356, $pop431
	i64.load	$push241=, 0($pop240)
	i64.store	$drop=, 0($pop239):p2align=2, $pop241
	i32.const	$push361=, 188
	i32.add 	$push362=, $2, $pop361
	i32.const	$push242=, 16
	i32.add 	$push243=, $pop362, $pop242
	i32.const	$push359=, 520
	i32.add 	$push360=, $2, $pop359
	i32.const	$push430=, 16
	i32.add 	$push244=, $pop360, $pop430
	i64.load	$push245=, 0($pop244)
	i64.store	$drop=, 0($pop243):p2align=2, $pop245
	i32.const	$push365=, 188
	i32.add 	$push366=, $2, $pop365
	i32.const	$push429=, 8
	i32.add 	$push246=, $pop366, $pop429
	i32.const	$push363=, 520
	i32.add 	$push364=, $2, $pop363
	i32.const	$push428=, 8
	i32.add 	$push247=, $pop364, $pop428
	i64.load	$push248=, 0($pop247)
	i64.store	$drop=, 0($pop246):p2align=2, $pop248
	i64.load	$push249=, 520($2)
	i64.store	$drop=, 188($2):p2align=2, $pop249
	i32.const	$push367=, 153
	i32.add 	$push368=, $2, $pop367
	i32.const	$push369=, 480
	i32.add 	$push370=, $2, $pop369
	i32.const	$push250=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop368, $pop370, $pop250
	i32.const	$push371=, 81
	i32.add 	$push372=, $2, $pop371
	i32.const	$push373=, 408
	i32.add 	$push374=, $2, $pop373
	i32.const	$push251=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop372, $pop374, $pop251
	i32.const	$push252=, 76
	i32.add 	$push253=, $2, $pop252
	i32.const	$push375=, 81
	i32.add 	$push376=, $2, $pop375
	i32.store	$drop=, 0($pop253), $pop376
	i32.const	$push427=, 72
	i32.add 	$push254=, $2, $pop427
	i32.const	$push377=, 153
	i32.add 	$push378=, $2, $pop377
	i32.store	$drop=, 0($pop254), $pop378
	i32.const	$push255=, 68
	i32.add 	$push256=, $2, $pop255
	i32.const	$push379=, 188
	i32.add 	$push380=, $2, $pop379
	i32.store	$drop=, 0($pop256), $pop380
	i32.const	$push257=, 64
	i32.add 	$push258=, $2, $pop257
	i32.const	$push381=, 221
	i32.add 	$push382=, $2, $pop381
	i32.store	$drop=, 0($pop258), $pop382
	i32.const	$push259=, 60
	i32.add 	$push260=, $2, $pop259
	i32.const	$push383=, 252
	i32.add 	$push384=, $2, $pop383
	i32.store	$drop=, 0($pop260), $pop384
	i32.const	$push261=, 56
	i32.add 	$push262=, $2, $pop261
	i32.const	$push385=, 268
	i32.add 	$push386=, $2, $pop385
	i32.store	$drop=, 0($pop262), $pop386
	i32.const	$push263=, 52
	i32.add 	$push264=, $2, $pop263
	i32.const	$push387=, 284
	i32.add 	$push388=, $2, $pop387
	i32.store	$drop=, 0($pop264), $pop388
	i32.const	$push265=, 48
	i32.add 	$push266=, $2, $pop265
	i32.const	$push389=, 300
	i32.add 	$push390=, $2, $pop389
	i32.store	$drop=, 0($pop266), $pop390
	i32.const	$push267=, 44
	i32.add 	$push268=, $2, $pop267
	i32.const	$push391=, 316
	i32.add 	$push392=, $2, $pop391
	i32.store	$drop=, 0($pop268), $pop392
	i32.const	$push269=, 40
	i32.add 	$push270=, $2, $pop269
	i32.const	$push393=, 328
	i32.add 	$push394=, $2, $pop393
	i32.store	$drop=, 0($pop270), $pop394
	i32.const	$push271=, 36
	i32.add 	$push272=, $2, $pop271
	i32.const	$push395=, 340
	i32.add 	$push396=, $2, $pop395
	i32.store	$drop=, 0($pop272), $pop396
	i32.const	$push273=, 32
	i32.add 	$push274=, $2, $pop273
	i32.const	$push397=, 352
	i32.add 	$push398=, $2, $pop397
	i32.store	$drop=, 0($pop274), $pop398
	i32.const	$push275=, 28
	i32.add 	$push276=, $2, $pop275
	i32.const	$push399=, 364
	i32.add 	$push400=, $2, $pop399
	i32.store	$drop=, 0($pop276), $pop400
	i32.const	$push426=, 24
	i32.add 	$push277=, $2, $pop426
	i32.const	$push401=, 372
	i32.add 	$push402=, $2, $pop401
	i32.store	$drop=, 0($pop277), $pop402
	i32.const	$push278=, 20
	i32.add 	$push279=, $2, $pop278
	i32.const	$push403=, 380
	i32.add 	$push404=, $2, $pop403
	i32.store	$drop=, 0($pop279), $pop404
	i32.const	$push425=, 16
	i32.add 	$push280=, $2, $pop425
	i32.const	$push405=, 388
	i32.add 	$push406=, $2, $pop405
	i32.store	$drop=, 0($pop280), $pop406
	i32.const	$push424=, 8
	i32.store	$drop=, 0($2), $pop424
	i32.const	$push407=, 396
	i32.add 	$push408=, $2, $pop407
	i32.store	$drop=, 12($2), $pop408
	i32.const	$push409=, 402
	i32.add 	$push410=, $2, $pop409
	i32.store	$drop=, 8($2), $pop410
	i32.const	$push411=, 406
	i32.add 	$push412=, $2, $pop411
	i32.store	$drop=, 4($2), $pop412
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
