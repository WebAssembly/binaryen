	.text
	.file	"va-arg-22.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
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
	i32.store	bar.lastn($pop18), $0
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store	bar.lastc($pop17), $pop16
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
	i32.store	bar.lastc($pop12), $pop11
	return
.LBB0_5:                                # %if.then2
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push471=, 0
	i32.const	$push469=, 0
	i32.load	$push468=, __stack_pointer($pop469)
	i32.const	$push470=, 352
	i32.sub 	$push532=, $pop468, $pop470
	tee_local	$push531=, $9=, $pop532
	i32.store	__stack_pointer($pop471), $pop531
	block   	
	i32.const	$push14=, 21
	i32.ne  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label2
# BB#1:                                 # %if.end
	i32.store	12($9), $1
	i32.const	$push16=, 4
	i32.add 	$push17=, $1, $pop16
	i32.store	12($9), $pop17
	i32.const	$push18=, 0
	i32.load	$0=, bar.lastc($pop18)
	i32.load8_s	$8=, 0($1)
	block   	
	i32.const	$push535=, 0
	i32.load	$push534=, bar.lastn($pop535)
	tee_local	$push533=, $3=, $pop534
	i32.const	$push19=, 1
	i32.eq  	$push20=, $pop533, $pop19
	br_if   	0, $pop20       # 0: down to label3
# BB#2:                                 # %if.then.i
	i32.ne  	$push21=, $0, $3
	br_if   	1, $pop21       # 1: down to label2
# BB#3:                                 # %if.end.i
	i32.const	$0=, 0
	i32.const	$push538=, 0
	i32.const	$push22=, 1
	i32.store	bar.lastn($pop538), $pop22
	i32.const	$push537=, 0
	i32.const	$push536=, 0
	i32.store	bar.lastc($pop537), $pop536
.LBB1_4:                                # %if.end3.i
	end_block                       # label3:
	i32.const	$push23=, 24
	i32.shl 	$push24=, $0, $pop23
	i32.const	$push540=, 24
	i32.shr_s	$push25=, $pop24, $pop540
	i32.const	$push539=, 8
	i32.xor 	$push26=, $pop25, $pop539
	i32.ne  	$push27=, $pop26, $8
	br_if   	0, $pop27       # 0: down to label2
# BB#5:                                 # %if.then.i312
	i32.const	$push544=, 0
	i32.const	$push28=, 1
	i32.add 	$push29=, $0, $pop28
	i32.store	bar.lastc($pop544), $pop29
	i32.const	$push543=, 8
	i32.add 	$push542=, $1, $pop543
	tee_local	$push541=, $8=, $pop542
	i32.store	12($9), $pop541
	br_if   	0, $0           # 0: down to label2
# BB#6:                                 # %if.end3.i319
	i32.const	$push30=, 4
	i32.add 	$push31=, $1, $pop30
	i32.load16_u	$0=, 0($pop31):p2align=0
	i32.const	$push547=, 0
	i32.const	$push32=, 2
	i32.store	bar.lastn($pop547), $pop32
	i32.const	$push546=, 0
	i32.const	$push545=, 0
	i32.store	bar.lastc($pop546), $pop545
	i32.const	$push33=, 255
	i32.and 	$push34=, $0, $pop33
	i32.const	$push35=, 16
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label2
# BB#7:                                 # %if.end3.i319.1
	i32.const	$push548=, 0
	i32.const	$push37=, 1
	i32.store	bar.lastc($pop548), $pop37
	i32.const	$push38=, 65280
	i32.and 	$push39=, $0, $pop38
	i32.const	$push40=, 4352
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label2
# BB#8:                                 # %if.end3.i333
	i32.const	$push551=, 0
	i32.const	$push42=, 3
	i32.store	bar.lastn($pop551), $pop42
	i32.load16_u	$push43=, 0($8):p2align=0
	i32.store16	344($9), $pop43
	i32.const	$push550=, 0
	i32.const	$push549=, 0
	i32.store	bar.lastc($pop550), $pop549
	i32.const	$push44=, 12
	i32.add 	$push45=, $1, $pop44
	i32.store	12($9), $pop45
	i32.const	$push46=, 2
	i32.add 	$push47=, $8, $pop46
	i32.load8_u	$push48=, 0($pop47)
	i32.store8	346($9), $pop48
	i32.load8_u	$push50=, 344($9)
	i32.const	$push49=, 24
	i32.ne  	$push51=, $pop50, $pop49
	br_if   	0, $pop51       # 0: down to label2
# BB#9:                                 # %if.end3.i333.1
	i32.const	$push552=, 0
	i32.const	$push52=, 1
	i32.store	bar.lastc($pop552), $pop52
	i32.load8_u	$push54=, 345($9)
	i32.const	$push53=, 25
	i32.ne  	$push55=, $pop54, $pop53
	br_if   	0, $pop55       # 0: down to label2
# BB#10:                                # %if.end3.i333.2
	i32.const	$push553=, 0
	i32.const	$push56=, 2
	i32.store	bar.lastc($pop553), $pop56
	i32.load8_u	$push58=, 346($9)
	i32.const	$push57=, 26
	i32.ne  	$push59=, $pop58, $pop57
	br_if   	0, $pop59       # 0: down to label2
# BB#11:                                # %if.end3.i347
	i32.const	$push60=, 16
	i32.add 	$push558=, $1, $pop60
	tee_local	$push557=, $8=, $pop558
	i32.store	12($9), $pop557
	i32.const	$push61=, 12
	i32.add 	$push62=, $1, $pop61
	i32.load	$0=, 0($pop62):p2align=0
	i32.const	$push556=, 0
	i32.const	$push63=, 4
	i32.store	bar.lastn($pop556), $pop63
	i32.const	$push555=, 0
	i32.const	$push554=, 0
	i32.store	bar.lastc($pop555), $pop554
	i32.const	$push64=, 255
	i32.and 	$push65=, $0, $pop64
	i32.const	$push66=, 32
	i32.ne  	$push67=, $pop65, $pop66
	br_if   	0, $pop67       # 0: down to label2
# BB#12:                                # %if.end3.i347.1
	i32.const	$push559=, 0
	i32.const	$push68=, 1
	i32.store	bar.lastc($pop559), $pop68
	i32.const	$push69=, 65280
	i32.and 	$push70=, $0, $pop69
	i32.const	$push71=, 8448
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label2
# BB#13:                                # %if.end3.i347.2
	i32.const	$push560=, 0
	i32.const	$push73=, 2
	i32.store	bar.lastc($pop560), $pop73
	i32.const	$push74=, 16711680
	i32.and 	$push75=, $0, $pop74
	i32.const	$push76=, 2228224
	i32.ne  	$push77=, $pop75, $pop76
	br_if   	0, $pop77       # 0: down to label2
# BB#14:                                # %if.end3.i347.3
	i32.const	$push561=, 0
	i32.const	$push78=, 3
	i32.store	bar.lastc($pop561), $pop78
	i32.const	$push79=, -16777216
	i32.and 	$push80=, $0, $pop79
	i32.const	$push81=, 587202560
	i32.ne  	$push82=, $pop80, $pop81
	br_if   	0, $pop82       # 0: down to label2
# BB#15:                                # %if.end3.i361
	i32.const	$push566=, 0
	i32.const	$push83=, 5
	i32.store	bar.lastn($pop566), $pop83
	i32.load	$push84=, 0($8):p2align=0
	i32.store	336($9), $pop84
	i32.const	$push565=, 0
	i32.const	$push564=, 0
	i32.store	bar.lastc($pop565), $pop564
	i32.const	$push85=, 24
	i32.add 	$push563=, $1, $pop85
	tee_local	$push562=, $3=, $pop563
	i32.store	12($9), $pop562
	i32.const	$push86=, 4
	i32.add 	$push87=, $8, $pop86
	i32.load8_u	$push88=, 0($pop87)
	i32.store8	340($9), $pop88
	i32.load8_u	$push90=, 336($9)
	i32.const	$push89=, 40
	i32.ne  	$push91=, $pop90, $pop89
	br_if   	0, $pop91       # 0: down to label2
# BB#16:                                # %if.end3.i361.1
	i32.const	$push567=, 0
	i32.const	$push92=, 1
	i32.store	bar.lastc($pop567), $pop92
	i32.load8_u	$push94=, 337($9)
	i32.const	$push93=, 41
	i32.ne  	$push95=, $pop94, $pop93
	br_if   	0, $pop95       # 0: down to label2
# BB#17:                                # %if.end3.i361.2
	i32.const	$push568=, 0
	i32.const	$push96=, 2
	i32.store	bar.lastc($pop568), $pop96
	i32.load8_u	$push98=, 338($9)
	i32.const	$push97=, 42
	i32.ne  	$push99=, $pop98, $pop97
	br_if   	0, $pop99       # 0: down to label2
# BB#18:                                # %if.end3.i361.3
	i32.const	$push569=, 0
	i32.const	$push100=, 3
	i32.store	bar.lastc($pop569), $pop100
	i32.load8_u	$push102=, 339($9)
	i32.const	$push101=, 43
	i32.ne  	$push103=, $pop102, $pop101
	br_if   	0, $pop103      # 0: down to label2
# BB#19:                                # %if.end3.i361.4
	i32.const	$push571=, 0
	i32.const	$push570=, 4
	i32.store	bar.lastc($pop571), $pop570
	i32.load8_u	$push105=, 340($9)
	i32.const	$push104=, 44
	i32.ne  	$push106=, $pop105, $pop104
	br_if   	0, $pop106      # 0: down to label2
# BB#20:                                # %if.end3.i375
	i32.const	$push577=, 0
	i32.const	$push107=, 6
	i32.store	bar.lastn($pop577), $pop107
	i32.load	$push108=, 0($3):p2align=0
	i32.store	328($9), $pop108
	i32.const	$push576=, 0
	i32.const	$push575=, 0
	i32.store	bar.lastc($pop576), $pop575
	i32.const	$push109=, 32
	i32.add 	$push574=, $1, $pop109
	tee_local	$push573=, $0=, $pop574
	i32.store	12($9), $pop573
	i32.const	$push572=, 4
	i32.add 	$push110=, $3, $pop572
	i32.load16_u	$push111=, 0($pop110):p2align=0
	i32.store16	332($9), $pop111
	i32.load8_u	$push113=, 328($9)
	i32.const	$push112=, 48
	i32.ne  	$push114=, $pop113, $pop112
	br_if   	0, $pop114      # 0: down to label2
# BB#21:                                # %if.end3.i375.1
	i32.const	$push578=, 0
	i32.const	$push115=, 1
	i32.store	bar.lastc($pop578), $pop115
	i32.load8_u	$push117=, 329($9)
	i32.const	$push116=, 49
	i32.ne  	$push118=, $pop117, $pop116
	br_if   	0, $pop118      # 0: down to label2
# BB#22:                                # %if.end3.i375.2
	i32.const	$push579=, 0
	i32.const	$push119=, 2
	i32.store	bar.lastc($pop579), $pop119
	i32.load8_u	$push121=, 330($9)
	i32.const	$push120=, 50
	i32.ne  	$push122=, $pop121, $pop120
	br_if   	0, $pop122      # 0: down to label2
# BB#23:                                # %if.end3.i375.3
	i32.const	$push580=, 0
	i32.const	$push123=, 3
	i32.store	bar.lastc($pop580), $pop123
	i32.load8_u	$push125=, 331($9)
	i32.const	$push124=, 51
	i32.ne  	$push126=, $pop125, $pop124
	br_if   	0, $pop126      # 0: down to label2
# BB#24:                                # %if.end3.i375.4
	i32.const	$push581=, 0
	i32.const	$push127=, 4
	i32.store	bar.lastc($pop581), $pop127
	i32.load8_u	$push129=, 332($9)
	i32.const	$push128=, 52
	i32.ne  	$push130=, $pop129, $pop128
	br_if   	0, $pop130      # 0: down to label2
# BB#25:                                # %if.end3.i375.5
	i32.const	$push582=, 0
	i32.const	$push131=, 5
	i32.store	bar.lastc($pop582), $pop131
	i32.load8_u	$push133=, 333($9)
	i32.const	$push132=, 53
	i32.ne  	$push134=, $pop133, $pop132
	br_if   	0, $pop134      # 0: down to label2
# BB#26:                                # %if.end3.i389
	i32.const	$push585=, 0
	i32.const	$push135=, 7
	i32.store	bar.lastn($pop585), $pop135
	i32.load	$push136=, 0($0):p2align=0
	i32.store	320($9), $pop136
	i32.const	$push584=, 0
	i32.const	$push583=, 0
	i32.store	bar.lastc($pop584), $pop583
	i32.const	$push137=, 40
	i32.add 	$push138=, $1, $pop137
	i32.store	12($9), $pop138
	i32.const	$push139=, 4
	i32.add 	$push140=, $0, $pop139
	i32.load16_u	$push141=, 0($pop140):p2align=0
	i32.store16	324($9), $pop141
	i32.const	$push142=, 6
	i32.add 	$push143=, $0, $pop142
	i32.load8_u	$push144=, 0($pop143)
	i32.store8	326($9), $pop144
	i32.load8_u	$push146=, 320($9)
	i32.const	$push145=, 56
	i32.ne  	$push147=, $pop146, $pop145
	br_if   	0, $pop147      # 0: down to label2
# BB#27:                                # %if.end3.i389.1
	i32.const	$push586=, 0
	i32.const	$push148=, 1
	i32.store	bar.lastc($pop586), $pop148
	i32.load8_u	$push150=, 321($9)
	i32.const	$push149=, 57
	i32.ne  	$push151=, $pop150, $pop149
	br_if   	0, $pop151      # 0: down to label2
# BB#28:                                # %if.end3.i389.2
	i32.const	$push587=, 0
	i32.const	$push152=, 2
	i32.store	bar.lastc($pop587), $pop152
	i32.load8_u	$push154=, 322($9)
	i32.const	$push153=, 58
	i32.ne  	$push155=, $pop154, $pop153
	br_if   	0, $pop155      # 0: down to label2
# BB#29:                                # %if.end3.i389.3
	i32.const	$push588=, 0
	i32.const	$push156=, 3
	i32.store	bar.lastc($pop588), $pop156
	i32.load8_u	$push158=, 323($9)
	i32.const	$push157=, 59
	i32.ne  	$push159=, $pop158, $pop157
	br_if   	0, $pop159      # 0: down to label2
# BB#30:                                # %if.end3.i389.4
	i32.const	$push589=, 0
	i32.const	$push160=, 4
	i32.store	bar.lastc($pop589), $pop160
	i32.load8_u	$push162=, 324($9)
	i32.const	$push161=, 60
	i32.ne  	$push163=, $pop162, $pop161
	br_if   	0, $pop163      # 0: down to label2
# BB#31:                                # %if.end3.i389.5
	i32.const	$push590=, 0
	i32.const	$push164=, 5
	i32.store	bar.lastc($pop590), $pop164
	i32.load8_u	$push166=, 325($9)
	i32.const	$push165=, 61
	i32.ne  	$push167=, $pop166, $pop165
	br_if   	0, $pop167      # 0: down to label2
# BB#32:                                # %if.end3.i389.6
	i32.const	$push591=, 0
	i32.const	$push168=, 6
	i32.store	bar.lastc($pop591), $pop168
	i32.load8_u	$push170=, 326($9)
	i32.const	$push169=, 62
	i32.ne  	$push171=, $pop170, $pop169
	br_if   	0, $pop171      # 0: down to label2
# BB#33:                                # %if.end3.i403
	i32.const	$push598=, 0
	i32.const	$push172=, 8
	i32.store	bar.lastn($pop598), $pop172
	i32.const	$push597=, 0
	i32.const	$push596=, 0
	i32.store	bar.lastc($pop597), $pop596
	i32.const	$push173=, 48
	i32.add 	$push595=, $1, $pop173
	tee_local	$push594=, $0=, $pop595
	i32.store	12($9), $pop594
	i32.const	$push174=, 40
	i32.add 	$push175=, $1, $pop174
	i64.load	$push593=, 0($pop175):p2align=0
	tee_local	$push592=, $2=, $pop593
	i64.const	$push180=, 255
	i64.and 	$push181=, $pop592, $pop180
	i64.const	$push182=, 64
	i64.ne  	$push183=, $pop181, $pop182
	br_if   	0, $pop183      # 0: down to label2
# BB#34:                                # %if.end3.i403.1
	i32.const	$push599=, 0
	i32.const	$push184=, 1
	i32.store	bar.lastc($pop599), $pop184
	i32.wrap/i64	$push185=, $2
	i32.const	$push186=, 16
	i32.shl 	$push187=, $pop185, $pop186
	i32.const	$push188=, -16777216
	i32.and 	$push189=, $pop187, $pop188
	i32.const	$push190=, 1090519040
	i32.ne  	$push191=, $pop189, $pop190
	br_if   	0, $pop191      # 0: down to label2
# BB#35:                                # %if.end3.i403.2
	i32.const	$push600=, 0
	i32.const	$push192=, 2
	i32.store	bar.lastc($pop600), $pop192
	i64.const	$push179=, 16
	i64.shr_u	$push0=, $2, $pop179
	i32.wrap/i64	$push193=, $pop0
	i32.const	$push194=, 24
	i32.shl 	$push195=, $pop193, $pop194
	i32.const	$push196=, 1107296256
	i32.ne  	$push197=, $pop195, $pop196
	br_if   	0, $pop197      # 0: down to label2
# BB#36:                                # %if.end3.i403.3
	i32.const	$push601=, 0
	i32.const	$push198=, 3
	i32.store	bar.lastc($pop601), $pop198
	i64.const	$push199=, 4278190080
	i64.and 	$push200=, $2, $pop199
	i64.const	$push201=, 1124073472
	i64.ne  	$push202=, $pop200, $pop201
	br_if   	0, $pop202      # 0: down to label2
# BB#37:                                # %if.end3.i403.4
	i32.const	$push603=, 0
	i32.const	$push203=, 4
	i32.store	bar.lastc($pop603), $pop203
	i64.const	$push178=, 32
	i64.shr_u	$push1=, $2, $pop178
	i32.wrap/i64	$push204=, $pop1
	i32.const	$push602=, 24
	i32.shl 	$push205=, $pop204, $pop602
	i32.const	$push206=, 1140850688
	i32.ne  	$push207=, $pop205, $pop206
	br_if   	0, $pop207      # 0: down to label2
# BB#38:                                # %if.end3.i403.5
	i32.const	$push605=, 0
	i32.const	$push208=, 5
	i32.store	bar.lastc($pop605), $pop208
	i64.const	$push177=, 40
	i64.shr_u	$push2=, $2, $pop177
	i32.wrap/i64	$push209=, $pop2
	i32.const	$push604=, 24
	i32.shl 	$push210=, $pop209, $pop604
	i32.const	$push211=, 1157627904
	i32.ne  	$push212=, $pop210, $pop211
	br_if   	0, $pop212      # 0: down to label2
# BB#39:                                # %if.end3.i403.6
	i32.const	$push606=, 0
	i32.const	$push213=, 6
	i32.store	bar.lastc($pop606), $pop213
	i64.const	$push176=, 48
	i64.shr_u	$push3=, $2, $pop176
	i32.wrap/i64	$push214=, $pop3
	i32.const	$push215=, 24
	i32.shl 	$push216=, $pop214, $pop215
	i32.const	$push217=, 1174405120
	i32.ne  	$push218=, $pop216, $pop217
	br_if   	0, $pop218      # 0: down to label2
# BB#40:                                # %if.end3.i403.7
	i32.const	$push607=, 0
	i32.const	$push219=, 7
	i32.store	bar.lastc($pop607), $pop219
	i64.const	$push220=, -72057594037927936
	i64.and 	$push221=, $2, $pop220
	i64.const	$push222=, 5116089176692883456
	i64.ne  	$push223=, $pop221, $pop222
	br_if   	0, $pop223      # 0: down to label2
# BB#41:                                # %if.end3.i417
	i32.const	$push613=, 0
	i32.const	$push224=, 9
	i32.store	bar.lastn($pop613), $pop224
	i32.const	$push475=, 304
	i32.add 	$push476=, $9, $pop475
	i32.const	$push225=, 8
	i32.add 	$push228=, $pop476, $pop225
	i32.const	$push612=, 8
	i32.add 	$push226=, $0, $pop612
	i32.load8_u	$push227=, 0($pop226)
	i32.store8	0($pop228), $pop227
	i64.load	$push229=, 0($0):p2align=0
	i64.store	304($9), $pop229
	i32.const	$push611=, 0
	i32.const	$push610=, 0
	i32.store	bar.lastc($pop611), $pop610
	i32.const	$push230=, 60
	i32.add 	$push609=, $1, $pop230
	tee_local	$push608=, $0=, $pop609
	i32.store	12($9), $pop608
	i32.load8_u	$push232=, 304($9)
	i32.const	$push231=, 72
	i32.ne  	$push233=, $pop232, $pop231
	br_if   	0, $pop233      # 0: down to label2
# BB#42:                                # %if.end3.i417.1
	i32.const	$push614=, 0
	i32.const	$push234=, 1
	i32.store	bar.lastc($pop614), $pop234
	i32.load8_u	$push236=, 305($9)
	i32.const	$push235=, 73
	i32.ne  	$push237=, $pop236, $pop235
	br_if   	0, $pop237      # 0: down to label2
# BB#43:                                # %if.end3.i417.2
	i32.const	$push615=, 0
	i32.const	$push238=, 2
	i32.store	bar.lastc($pop615), $pop238
	i32.load8_u	$push240=, 306($9)
	i32.const	$push239=, 74
	i32.ne  	$push241=, $pop240, $pop239
	br_if   	0, $pop241      # 0: down to label2
# BB#44:                                # %if.end3.i417.3
	i32.const	$push616=, 0
	i32.const	$push242=, 3
	i32.store	bar.lastc($pop616), $pop242
	i32.load8_u	$push244=, 307($9)
	i32.const	$push243=, 75
	i32.ne  	$push245=, $pop244, $pop243
	br_if   	0, $pop245      # 0: down to label2
# BB#45:                                # %if.end3.i417.4
	i32.const	$push617=, 0
	i32.const	$push246=, 4
	i32.store	bar.lastc($pop617), $pop246
	i32.load8_u	$push248=, 308($9)
	i32.const	$push247=, 76
	i32.ne  	$push249=, $pop248, $pop247
	br_if   	0, $pop249      # 0: down to label2
# BB#46:                                # %if.end3.i417.5
	i32.const	$push618=, 0
	i32.const	$push250=, 5
	i32.store	bar.lastc($pop618), $pop250
	i32.load8_u	$push252=, 309($9)
	i32.const	$push251=, 77
	i32.ne  	$push253=, $pop252, $pop251
	br_if   	0, $pop253      # 0: down to label2
# BB#47:                                # %if.end3.i417.6
	i32.const	$push619=, 0
	i32.const	$push254=, 6
	i32.store	bar.lastc($pop619), $pop254
	i32.load8_u	$push256=, 310($9)
	i32.const	$push255=, 78
	i32.ne  	$push257=, $pop256, $pop255
	br_if   	0, $pop257      # 0: down to label2
# BB#48:                                # %if.end3.i417.7
	i32.const	$push620=, 0
	i32.const	$push258=, 7
	i32.store	bar.lastc($pop620), $pop258
	i32.load8_u	$push260=, 311($9)
	i32.const	$push259=, 79
	i32.ne  	$push261=, $pop260, $pop259
	br_if   	0, $pop261      # 0: down to label2
# BB#49:                                # %if.end3.i417.8
	i32.const	$push622=, 0
	i32.const	$push621=, 8
	i32.store	bar.lastc($pop622), $pop621
	i32.load8_u	$push263=, 312($9)
	i32.const	$push262=, 64
	i32.ne  	$push264=, $pop263, $pop262
	br_if   	0, $pop264      # 0: down to label2
# BB#50:                                # %bar.exit420.8
	i32.const	$push629=, 0
	i32.const	$push265=, 10
	i32.store	bar.lastn($pop629), $pop265
	i32.const	$push477=, 288
	i32.add 	$push478=, $9, $pop477
	i32.const	$push628=, 8
	i32.add 	$push268=, $pop478, $pop628
	i32.const	$push627=, 8
	i32.add 	$push266=, $0, $pop627
	i32.load16_u	$push267=, 0($pop266):p2align=0
	i32.store16	0($pop268), $pop267
	i64.load	$push269=, 0($0):p2align=0
	i64.store	288($9), $pop269
	i32.const	$push626=, 0
	i32.const	$push625=, 0
	i32.store	bar.lastc($pop626), $pop625
	i32.const	$push270=, 72
	i32.add 	$push624=, $1, $pop270
	tee_local	$push623=, $8=, $pop624
	i32.store	12($9), $pop623
	i32.load8_s	$push272=, 288($9)
	i32.const	$push271=, 80
	i32.ne  	$push273=, $pop272, $pop271
	br_if   	0, $pop273      # 0: down to label2
# BB#51:                                # %bar.exit434
	i32.const	$push631=, 0
	i32.const	$push630=, 1
	i32.store	bar.lastc($pop631), $pop630
	i32.load8_s	$push275=, 289($9)
	i32.const	$push274=, 81
	i32.ne  	$push276=, $pop275, $pop274
	br_if   	0, $pop276      # 0: down to label2
# BB#52:                                # %bar.exit434.1
	i32.const	$push637=, 0
	i32.const	$push636=, 1
	i32.const	$push635=, 1
	i32.add 	$push634=, $pop636, $pop635
	tee_local	$push633=, $0=, $pop634
	i32.store	bar.lastc($pop637), $pop633
	i32.const	$push632=, 80
	i32.or  	$push277=, $0, $pop632
	i32.load8_s	$push278=, 290($9)
	i32.ne  	$push279=, $pop277, $pop278
	br_if   	0, $pop279      # 0: down to label2
# BB#53:                                # %bar.exit434.2
	i32.const	$push644=, 0
	i32.const	$push643=, 1
	i32.add 	$push642=, $0, $pop643
	tee_local	$push641=, $0=, $pop642
	i32.store	bar.lastc($pop644), $pop641
	i32.const	$push640=, 24
	i32.shl 	$push280=, $0, $pop640
	i32.const	$push639=, 24
	i32.shr_s	$push281=, $pop280, $pop639
	i32.const	$push638=, 80
	i32.xor 	$push282=, $pop281, $pop638
	i32.load8_s	$push283=, 291($9)
	i32.ne  	$push284=, $pop282, $pop283
	br_if   	0, $pop284      # 0: down to label2
# BB#54:                                # %bar.exit434.3
	i32.const	$push651=, 0
	i32.const	$push650=, 1
	i32.add 	$push649=, $0, $pop650
	tee_local	$push648=, $0=, $pop649
	i32.store	bar.lastc($pop651), $pop648
	i32.const	$push647=, 24
	i32.shl 	$push285=, $0, $pop647
	i32.const	$push646=, 24
	i32.shr_s	$push286=, $pop285, $pop646
	i32.const	$push645=, 80
	i32.xor 	$push287=, $pop286, $pop645
	i32.load8_s	$push288=, 292($9)
	i32.ne  	$push289=, $pop287, $pop288
	br_if   	0, $pop289      # 0: down to label2
# BB#55:                                # %bar.exit434.4
	i32.const	$push658=, 0
	i32.const	$push657=, 1
	i32.add 	$push656=, $0, $pop657
	tee_local	$push655=, $0=, $pop656
	i32.store	bar.lastc($pop658), $pop655
	i32.const	$push654=, 24
	i32.shl 	$push290=, $0, $pop654
	i32.const	$push653=, 24
	i32.shr_s	$push291=, $pop290, $pop653
	i32.const	$push652=, 80
	i32.xor 	$push292=, $pop291, $pop652
	i32.load8_s	$push293=, 293($9)
	i32.ne  	$push294=, $pop292, $pop293
	br_if   	0, $pop294      # 0: down to label2
# BB#56:                                # %bar.exit434.5
	i32.const	$push665=, 0
	i32.const	$push664=, 1
	i32.add 	$push663=, $0, $pop664
	tee_local	$push662=, $0=, $pop663
	i32.store	bar.lastc($pop665), $pop662
	i32.const	$push661=, 24
	i32.shl 	$push295=, $0, $pop661
	i32.const	$push660=, 24
	i32.shr_s	$push296=, $pop295, $pop660
	i32.const	$push659=, 80
	i32.xor 	$push297=, $pop296, $pop659
	i32.load8_s	$push298=, 294($9)
	i32.ne  	$push299=, $pop297, $pop298
	br_if   	0, $pop299      # 0: down to label2
# BB#57:                                # %bar.exit434.6
	i32.const	$push672=, 0
	i32.const	$push671=, 1
	i32.add 	$push670=, $0, $pop671
	tee_local	$push669=, $0=, $pop670
	i32.store	bar.lastc($pop672), $pop669
	i32.const	$push668=, 24
	i32.shl 	$push300=, $0, $pop668
	i32.const	$push667=, 24
	i32.shr_s	$push301=, $pop300, $pop667
	i32.const	$push666=, 80
	i32.xor 	$push302=, $pop301, $pop666
	i32.load8_s	$push303=, 295($9)
	i32.ne  	$push304=, $pop302, $pop303
	br_if   	0, $pop304      # 0: down to label2
# BB#58:                                # %bar.exit434.7
	i32.const	$push679=, 0
	i32.const	$push678=, 1
	i32.add 	$push677=, $0, $pop678
	tee_local	$push676=, $0=, $pop677
	i32.store	bar.lastc($pop679), $pop676
	i32.const	$push675=, 24
	i32.shl 	$push305=, $0, $pop675
	i32.const	$push674=, 24
	i32.shr_s	$push306=, $pop305, $pop674
	i32.const	$push673=, 80
	i32.xor 	$push307=, $pop306, $pop673
	i32.load8_s	$push308=, 296($9)
	i32.ne  	$push309=, $pop307, $pop308
	br_if   	0, $pop309      # 0: down to label2
# BB#59:                                # %bar.exit434.8
	i32.const	$push686=, 0
	i32.const	$push685=, 1
	i32.add 	$push684=, $0, $pop685
	tee_local	$push683=, $0=, $pop684
	i32.store	bar.lastc($pop686), $pop683
	i32.const	$push682=, 24
	i32.shl 	$push310=, $0, $pop682
	i32.const	$push681=, 24
	i32.shr_s	$push311=, $pop310, $pop681
	i32.const	$push680=, 80
	i32.xor 	$push312=, $pop311, $pop680
	i32.load8_s	$push313=, 297($9)
	i32.ne  	$push314=, $pop312, $pop313
	br_if   	0, $pop314      # 0: down to label2
# BB#60:                                # %bar.exit434.9
	i32.const	$push695=, 0
	i32.const	$push694=, 1
	i32.add 	$push693=, $0, $pop694
	tee_local	$push692=, $0=, $pop693
	i32.store	bar.lastc($pop695), $pop692
	i32.const	$push479=, 272
	i32.add 	$push480=, $9, $pop479
	i32.const	$push315=, 8
	i32.add 	$push318=, $pop480, $pop315
	i32.const	$push691=, 8
	i32.add 	$push316=, $8, $pop691
	i32.load16_u	$push317=, 0($pop316):p2align=0
	i32.store16	0($pop318), $pop317
	i32.const	$push481=, 272
	i32.add 	$push482=, $9, $pop481
	i32.const	$push690=, 10
	i32.add 	$push321=, $pop482, $pop690
	i32.const	$push689=, 10
	i32.add 	$push319=, $8, $pop689
	i32.load8_u	$push320=, 0($pop319)
	i32.store8	0($pop321), $pop320
	i32.const	$push322=, 84
	i32.add 	$push688=, $1, $pop322
	tee_local	$push687=, $6=, $pop688
	i32.store	12($9), $pop687
	i64.load	$push323=, 0($8):p2align=0
	i64.store	272($9), $pop323
	i32.const	$8=, 10
	i32.const	$7=, 10
	i32.const	$3=, 0
.LBB1_61:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push483=, 272
	i32.add 	$push484=, $9, $pop483
	i32.add 	$push325=, $pop484, $3
	i32.load8_s	$4=, 0($pop325)
	block   	
	i32.const	$push696=, 11
	i32.eq  	$push324=, $7, $pop696
	br_if   	0, $pop324      # 0: down to label5
# BB#62:                                # %if.then.i438
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.ne  	$push326=, $0, $7
	br_if   	2, $pop326      # 2: down to label2
# BB#63:                                # %if.end.i440
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.const	$8=, 11
	i32.const	$0=, 0
	i32.const	$push700=, 0
	i32.const	$push699=, 11
	i32.store	bar.lastn($pop700), $pop699
	i32.const	$push698=, 0
	i32.const	$push697=, 0
	i32.store	bar.lastc($pop698), $pop697
.LBB1_64:                               # %if.end3.i445
                                        #   in Loop: Header=BB1_61 Depth=1
	end_block                       # label5:
	i32.const	$push703=, 24
	i32.shl 	$push327=, $0, $pop703
	i32.const	$push702=, 24
	i32.shr_s	$push328=, $pop327, $pop702
	i32.const	$push701=, 88
	i32.xor 	$push329=, $pop328, $pop701
	i32.ne  	$push330=, $pop329, $4
	br_if   	1, $pop330      # 1: down to label2
# BB#65:                                # %bar.exit448
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.const	$push709=, 0
	i32.const	$push708=, 1
	i32.add 	$push707=, $0, $pop708
	tee_local	$push706=, $0=, $pop707
	i32.store	bar.lastc($pop709), $pop706
	i32.const	$push705=, 10
	i32.lt_u	$4=, $3, $pop705
	i32.const	$7=, 11
	i32.const	$push704=, 1
	i32.add 	$push4=, $3, $pop704
	copy_local	$3=, $pop4
	br_if   	0, $4           # 0: up to label4
# BB#66:                                # %for.end134
	end_loop
	i32.const	$push485=, 256
	i32.add 	$push486=, $9, $pop485
	i32.const	$push331=, 8
	i32.add 	$push334=, $pop486, $pop331
	i32.const	$push713=, 8
	i32.add 	$push332=, $6, $pop713
	i32.load	$push333=, 0($pop332):p2align=0
	i32.store	0($pop334), $pop333
	i64.load	$push335=, 0($6):p2align=0
	i64.store	256($9), $pop335
	i32.const	$push712=, 96
	i32.add 	$push711=, $1, $pop712
	tee_local	$push710=, $6=, $pop711
	i32.store	12($9), $pop710
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_67:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push487=, 256
	i32.add 	$push488=, $9, $pop487
	i32.add 	$push337=, $pop488, $3
	i32.load8_s	$4=, 0($pop337)
	block   	
	i32.const	$push714=, 12
	i32.eq  	$push336=, $7, $pop714
	br_if   	0, $pop336      # 0: down to label7
# BB#68:                                # %if.then.i452
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.ne  	$push338=, $0, $7
	br_if   	2, $pop338      # 2: down to label2
# BB#69:                                # %if.end.i454
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$8=, 12
	i32.const	$0=, 0
	i32.const	$push718=, 0
	i32.const	$push717=, 12
	i32.store	bar.lastn($pop718), $pop717
	i32.const	$push716=, 0
	i32.const	$push715=, 0
	i32.store	bar.lastc($pop716), $pop715
.LBB1_70:                               # %if.end3.i459
                                        #   in Loop: Header=BB1_67 Depth=1
	end_block                       # label7:
	i32.const	$push721=, 24
	i32.shl 	$push339=, $0, $pop721
	i32.const	$push720=, 24
	i32.shr_s	$push340=, $pop339, $pop720
	i32.const	$push719=, 96
	i32.xor 	$push341=, $pop340, $pop719
	i32.ne  	$push342=, $pop341, $4
	br_if   	1, $pop342      # 1: down to label2
# BB#71:                                # %bar.exit462
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$push727=, 0
	i32.const	$push726=, 1
	i32.add 	$push725=, $0, $pop726
	tee_local	$push724=, $0=, $pop725
	i32.store	bar.lastc($pop727), $pop724
	i32.const	$push723=, 11
	i32.lt_u	$4=, $3, $pop723
	i32.const	$7=, 12
	i32.const	$push722=, 1
	i32.add 	$push5=, $3, $pop722
	copy_local	$3=, $pop5
	br_if   	0, $4           # 0: up to label6
# BB#72:                                # %for.end146
	end_loop
	i64.load	$push343=, 0($6):p2align=0
	i64.store	240($9), $pop343
	i32.const	$push344=, 112
	i32.add 	$push729=, $1, $pop344
	tee_local	$push728=, $5=, $pop729
	i32.store	12($9), $pop728
	i32.const	$push345=, 5
	i32.add 	$push346=, $6, $pop345
	i64.load	$push347=, 0($pop346):p2align=0
	i64.store	245($9):p2align=0, $pop347
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_73:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push489=, 240
	i32.add 	$push490=, $9, $pop489
	i32.add 	$push349=, $pop490, $3
	i32.load8_s	$4=, 0($pop349)
	block   	
	i32.const	$push730=, 13
	i32.eq  	$push348=, $7, $pop730
	br_if   	0, $pop348      # 0: down to label9
# BB#74:                                # %if.then.i466
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.ne  	$push350=, $0, $7
	br_if   	2, $pop350      # 2: down to label2
# BB#75:                                # %if.end.i468
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$8=, 13
	i32.const	$0=, 0
	i32.const	$push734=, 0
	i32.const	$push733=, 13
	i32.store	bar.lastn($pop734), $pop733
	i32.const	$push732=, 0
	i32.const	$push731=, 0
	i32.store	bar.lastc($pop732), $pop731
.LBB1_76:                               # %if.end3.i473
                                        #   in Loop: Header=BB1_73 Depth=1
	end_block                       # label9:
	i32.const	$push737=, 24
	i32.shl 	$push351=, $0, $pop737
	i32.const	$push736=, 24
	i32.shr_s	$push352=, $pop351, $pop736
	i32.const	$push735=, 104
	i32.xor 	$push353=, $pop352, $pop735
	i32.ne  	$push354=, $pop353, $4
	br_if   	1, $pop354      # 1: down to label2
# BB#77:                                # %bar.exit476
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$push743=, 0
	i32.const	$push742=, 1
	i32.add 	$push741=, $0, $pop742
	tee_local	$push740=, $0=, $pop741
	i32.store	bar.lastc($pop743), $pop740
	i32.const	$push739=, 12
	i32.lt_u	$4=, $3, $pop739
	i32.const	$7=, 13
	i32.const	$push738=, 1
	i32.add 	$push6=, $3, $pop738
	copy_local	$3=, $pop6
	br_if   	0, $4           # 0: up to label8
# BB#78:                                # %for.end158
	end_loop
	i64.load	$push355=, 0($5):p2align=0
	i64.store	224($9), $pop355
	i32.const	$push356=, 128
	i32.add 	$push745=, $1, $pop356
	tee_local	$push744=, $6=, $pop745
	i32.store	12($9), $pop744
	i32.const	$push357=, 6
	i32.add 	$push358=, $5, $pop357
	i64.load	$push359=, 0($pop358):p2align=0
	i64.store	230($9):p2align=1, $pop359
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_79:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push491=, 224
	i32.add 	$push492=, $9, $pop491
	i32.add 	$push361=, $pop492, $3
	i32.load8_s	$4=, 0($pop361)
	block   	
	i32.const	$push746=, 14
	i32.eq  	$push360=, $7, $pop746
	br_if   	0, $pop360      # 0: down to label11
# BB#80:                                # %if.then.i480
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.ne  	$push362=, $0, $7
	br_if   	2, $pop362      # 2: down to label2
# BB#81:                                # %if.end.i482
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$8=, 14
	i32.const	$0=, 0
	i32.const	$push750=, 0
	i32.const	$push749=, 14
	i32.store	bar.lastn($pop750), $pop749
	i32.const	$push748=, 0
	i32.const	$push747=, 0
	i32.store	bar.lastc($pop748), $pop747
.LBB1_82:                               # %if.end3.i487
                                        #   in Loop: Header=BB1_79 Depth=1
	end_block                       # label11:
	i32.const	$push753=, 24
	i32.shl 	$push363=, $0, $pop753
	i32.const	$push752=, 24
	i32.shr_s	$push364=, $pop363, $pop752
	i32.const	$push751=, 112
	i32.xor 	$push365=, $pop364, $pop751
	i32.ne  	$push366=, $pop365, $4
	br_if   	1, $pop366      # 1: down to label2
# BB#83:                                # %bar.exit490
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$push759=, 0
	i32.const	$push758=, 1
	i32.add 	$push757=, $0, $pop758
	tee_local	$push756=, $0=, $pop757
	i32.store	bar.lastc($pop759), $pop756
	i32.const	$push755=, 13
	i32.lt_u	$4=, $3, $pop755
	i32.const	$7=, 14
	i32.const	$push754=, 1
	i32.add 	$push7=, $3, $pop754
	copy_local	$3=, $pop7
	br_if   	0, $4           # 0: up to label10
# BB#84:                                # %for.end170
	end_loop
	i64.load	$push367=, 0($6):p2align=0
	i64.store	208($9), $pop367
	i32.const	$push368=, 144
	i32.add 	$push761=, $1, $pop368
	tee_local	$push760=, $5=, $pop761
	i32.store	12($9), $pop760
	i32.const	$push369=, 7
	i32.add 	$push370=, $6, $pop369
	i64.load	$push371=, 0($pop370):p2align=0
	i64.store	215($9):p2align=0, $pop371
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_85:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	i32.const	$push493=, 208
	i32.add 	$push494=, $9, $pop493
	i32.add 	$push373=, $pop494, $3
	i32.load8_s	$4=, 0($pop373)
	block   	
	i32.const	$push762=, 15
	i32.eq  	$push372=, $7, $pop762
	br_if   	0, $pop372      # 0: down to label13
# BB#86:                                # %if.then.i494
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.ne  	$push374=, $0, $7
	br_if   	2, $pop374      # 2: down to label2
# BB#87:                                # %if.end.i496
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$8=, 15
	i32.const	$0=, 0
	i32.const	$push766=, 0
	i32.const	$push765=, 15
	i32.store	bar.lastn($pop766), $pop765
	i32.const	$push764=, 0
	i32.const	$push763=, 0
	i32.store	bar.lastc($pop764), $pop763
.LBB1_88:                               # %if.end3.i501
                                        #   in Loop: Header=BB1_85 Depth=1
	end_block                       # label13:
	i32.const	$push769=, 24
	i32.shl 	$push375=, $0, $pop769
	i32.const	$push768=, 24
	i32.shr_s	$push376=, $pop375, $pop768
	i32.const	$push767=, 120
	i32.xor 	$push377=, $pop376, $pop767
	i32.ne  	$push378=, $pop377, $4
	br_if   	1, $pop378      # 1: down to label2
# BB#89:                                # %bar.exit504
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$push775=, 0
	i32.const	$push774=, 1
	i32.add 	$push773=, $0, $pop774
	tee_local	$push772=, $0=, $pop773
	i32.store	bar.lastc($pop775), $pop772
	i32.const	$push771=, 14
	i32.lt_u	$4=, $3, $pop771
	i32.const	$7=, 15
	i32.const	$push770=, 1
	i32.add 	$push8=, $3, $pop770
	copy_local	$3=, $pop8
	br_if   	0, $4           # 0: up to label12
# BB#90:                                # %for.end182
	end_loop
	i32.const	$push495=, 192
	i32.add 	$push496=, $9, $pop495
	i32.const	$push379=, 8
	i32.add 	$push382=, $pop496, $pop379
	i32.const	$push778=, 8
	i32.add 	$push380=, $5, $pop778
	i64.load	$push381=, 0($pop380):p2align=0
	i64.store	0($pop382), $pop381
	i64.load	$push383=, 0($5):p2align=0
	i64.store	192($9), $pop383
	i32.const	$push384=, 160
	i32.add 	$push777=, $1, $pop384
	tee_local	$push776=, $6=, $pop777
	i32.store	12($9), $pop776
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_91:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push497=, 192
	i32.add 	$push498=, $9, $pop497
	i32.add 	$push386=, $pop498, $3
	i32.load8_s	$4=, 0($pop386)
	block   	
	i32.const	$push779=, 16
	i32.eq  	$push385=, $7, $pop779
	br_if   	0, $pop385      # 0: down to label15
# BB#92:                                # %if.then.i508
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.ne  	$push387=, $0, $7
	br_if   	2, $pop387      # 2: down to label2
# BB#93:                                # %if.end.i510
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$8=, 16
	i32.const	$0=, 0
	i32.const	$push783=, 0
	i32.const	$push782=, 16
	i32.store	bar.lastn($pop783), $pop782
	i32.const	$push781=, 0
	i32.const	$push780=, 0
	i32.store	bar.lastc($pop781), $pop780
.LBB1_94:                               # %if.end3.i515
                                        #   in Loop: Header=BB1_91 Depth=1
	end_block                       # label15:
	i32.const	$push786=, 24
	i32.shl 	$push388=, $0, $pop786
	i32.const	$push785=, -2147483648
	i32.xor 	$push389=, $pop388, $pop785
	i32.const	$push784=, 24
	i32.shr_s	$push390=, $pop389, $pop784
	i32.ne  	$push391=, $pop390, $4
	br_if   	1, $pop391      # 1: down to label2
# BB#95:                                # %bar.exit518
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$push792=, 0
	i32.const	$push791=, 1
	i32.add 	$push790=, $0, $pop791
	tee_local	$push789=, $0=, $pop790
	i32.store	bar.lastc($pop792), $pop789
	i32.const	$push788=, 15
	i32.lt_u	$4=, $3, $pop788
	i32.const	$7=, 16
	i32.const	$push787=, 1
	i32.add 	$push9=, $3, $pop787
	copy_local	$3=, $pop9
	br_if   	0, $4           # 0: up to label14
# BB#96:                                # %for.end194
	end_loop
	i32.const	$push499=, 160
	i32.add 	$push500=, $9, $pop499
	i32.const	$push392=, 8
	i32.add 	$push395=, $pop500, $pop392
	i32.const	$push797=, 8
	i32.add 	$push393=, $6, $pop797
	i64.load	$push394=, 0($pop393):p2align=0
	i64.store	0($pop395), $pop394
	i32.const	$push501=, 160
	i32.add 	$push502=, $9, $pop501
	i32.const	$push396=, 16
	i32.add 	$push399=, $pop502, $pop396
	i32.const	$push796=, 16
	i32.add 	$push397=, $6, $pop796
	i64.load	$push398=, 0($pop397):p2align=0
	i64.store	0($pop399), $pop398
	i32.const	$push503=, 160
	i32.add 	$push504=, $9, $pop503
	i32.const	$push400=, 23
	i32.add 	$push403=, $pop504, $pop400
	i32.const	$push795=, 23
	i32.add 	$push401=, $6, $pop795
	i64.load	$push402=, 0($pop401):p2align=0
	i64.store	0($pop403):p2align=0, $pop402
	i64.load	$push404=, 0($6):p2align=0
	i64.store	160($9), $pop404
	i32.const	$push405=, 192
	i32.add 	$push794=, $1, $pop405
	tee_local	$push793=, $6=, $pop794
	i32.store	12($9), $pop793
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_97:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push505=, 160
	i32.add 	$push506=, $9, $pop505
	i32.add 	$push407=, $pop506, $3
	i32.load8_s	$4=, 0($pop407)
	block   	
	i32.const	$push798=, 31
	i32.eq  	$push406=, $7, $pop798
	br_if   	0, $pop406      # 0: down to label17
# BB#98:                                # %if.then.i522
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.ne  	$push408=, $0, $7
	br_if   	2, $pop408      # 2: down to label2
# BB#99:                                # %if.end.i524
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$8=, 31
	i32.const	$0=, 0
	i32.const	$push802=, 0
	i32.const	$push801=, 31
	i32.store	bar.lastn($pop802), $pop801
	i32.const	$push800=, 0
	i32.const	$push799=, 0
	i32.store	bar.lastc($pop800), $pop799
.LBB1_100:                              # %if.end3.i529
                                        #   in Loop: Header=BB1_97 Depth=1
	end_block                       # label17:
	i32.const	$push805=, 24
	i32.shl 	$push409=, $0, $pop805
	i32.const	$push804=, -134217728
	i32.xor 	$push410=, $pop409, $pop804
	i32.const	$push803=, 24
	i32.shr_s	$push411=, $pop410, $pop803
	i32.ne  	$push412=, $pop411, $4
	br_if   	1, $pop412      # 1: down to label2
# BB#101:                               # %bar.exit532
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$push811=, 0
	i32.const	$push810=, 1
	i32.add 	$push809=, $0, $pop810
	tee_local	$push808=, $0=, $pop809
	i32.store	bar.lastc($pop811), $pop808
	i32.const	$push807=, 30
	i32.lt_u	$4=, $3, $pop807
	i32.const	$7=, 31
	i32.const	$push806=, 1
	i32.add 	$push10=, $3, $pop806
	copy_local	$3=, $pop10
	br_if   	0, $4           # 0: up to label16
# BB#102:                               # %for.end206
	end_loop
	i32.const	$push507=, 128
	i32.add 	$push508=, $9, $pop507
	i32.const	$push413=, 8
	i32.add 	$push416=, $pop508, $pop413
	i32.const	$push817=, 8
	i32.add 	$push414=, $6, $pop817
	i64.load	$push415=, 0($pop414):p2align=0
	i64.store	0($pop416), $pop415
	i32.const	$push509=, 128
	i32.add 	$push510=, $9, $pop509
	i32.const	$push417=, 16
	i32.add 	$push420=, $pop510, $pop417
	i32.const	$push816=, 16
	i32.add 	$push418=, $6, $pop816
	i64.load	$push419=, 0($pop418):p2align=0
	i64.store	0($pop420), $pop419
	i32.const	$push511=, 128
	i32.add 	$push512=, $9, $pop511
	i32.const	$push815=, 24
	i32.add 	$push423=, $pop512, $pop815
	i32.const	$push814=, 24
	i32.add 	$push421=, $6, $pop814
	i64.load	$push422=, 0($pop421):p2align=0
	i64.store	0($pop423), $pop422
	i64.load	$push424=, 0($6):p2align=0
	i64.store	128($9), $pop424
	i32.const	$push425=, 224
	i32.add 	$push813=, $1, $pop425
	tee_local	$push812=, $6=, $pop813
	i32.store	12($9), $pop812
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_103:                              # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push513=, 128
	i32.add 	$push514=, $9, $pop513
	i32.add 	$push427=, $pop514, $3
	i32.load8_s	$4=, 0($pop427)
	block   	
	i32.const	$push818=, 32
	i32.eq  	$push426=, $7, $pop818
	br_if   	0, $pop426      # 0: down to label19
# BB#104:                               # %if.then.i536
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.ne  	$push428=, $0, $7
	br_if   	2, $pop428      # 2: down to label2
# BB#105:                               # %if.end.i538
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$8=, 32
	i32.const	$0=, 0
	i32.const	$push822=, 0
	i32.const	$push821=, 32
	i32.store	bar.lastn($pop822), $pop821
	i32.const	$push820=, 0
	i32.const	$push819=, 0
	i32.store	bar.lastc($pop820), $pop819
.LBB1_106:                              # %if.end3.i543
                                        #   in Loop: Header=BB1_103 Depth=1
	end_block                       # label19:
	i32.const	$push824=, 24
	i32.shl 	$push429=, $0, $pop824
	i32.const	$push823=, 24
	i32.shr_s	$push430=, $pop429, $pop823
	i32.ne  	$push431=, $pop430, $4
	br_if   	1, $pop431      # 1: down to label2
# BB#107:                               # %bar.exit546
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$push830=, 0
	i32.const	$push829=, 1
	i32.add 	$push828=, $0, $pop829
	tee_local	$push827=, $0=, $pop828
	i32.store	bar.lastc($pop830), $pop827
	i32.const	$push826=, 31
	i32.lt_u	$4=, $3, $pop826
	i32.const	$7=, 32
	i32.const	$push825=, 1
	i32.add 	$push11=, $3, $pop825
	copy_local	$3=, $pop11
	br_if   	0, $4           # 0: up to label18
# BB#108:                               # %for.end218
	end_loop
	i32.const	$push515=, 88
	i32.add 	$push516=, $9, $pop515
	i32.const	$push432=, 8
	i32.add 	$push435=, $pop516, $pop432
	i32.const	$push839=, 8
	i32.add 	$push433=, $6, $pop839
	i64.load	$push434=, 0($pop433):p2align=0
	i64.store	0($pop435), $pop434
	i32.const	$push517=, 88
	i32.add 	$push518=, $9, $pop517
	i32.const	$push436=, 16
	i32.add 	$push439=, $pop518, $pop436
	i32.const	$push838=, 16
	i32.add 	$push437=, $6, $pop838
	i64.load	$push438=, 0($pop437):p2align=0
	i64.store	0($pop439), $pop438
	i32.const	$push519=, 88
	i32.add 	$push520=, $9, $pop519
	i32.const	$push837=, 24
	i32.add 	$push442=, $pop520, $pop837
	i32.const	$push836=, 24
	i32.add 	$push440=, $6, $pop836
	i64.load	$push441=, 0($pop440):p2align=0
	i64.store	0($pop442), $pop441
	i32.const	$push521=, 88
	i32.add 	$push522=, $9, $pop521
	i32.const	$push443=, 32
	i32.add 	$push446=, $pop522, $pop443
	i32.const	$push835=, 32
	i32.add 	$push444=, $6, $pop835
	i32.load16_u	$push445=, 0($pop444):p2align=0
	i32.store16	0($pop446), $pop445
	i32.const	$push523=, 88
	i32.add 	$push524=, $9, $pop523
	i32.const	$push834=, 34
	i32.add 	$push449=, $pop524, $pop834
	i32.const	$push833=, 34
	i32.add 	$push447=, $6, $pop833
	i32.load8_u	$push448=, 0($pop447)
	i32.store8	0($pop449), $pop448
	i64.load	$push450=, 0($6):p2align=0
	i64.store	88($9), $pop450
	i32.const	$push451=, 260
	i32.add 	$push832=, $1, $pop451
	tee_local	$push831=, $6=, $pop832
	i32.store	12($9), $pop831
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_109:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push525=, 88
	i32.add 	$push526=, $9, $pop525
	i32.add 	$push453=, $pop526, $3
	i32.load8_s	$4=, 0($pop453)
	block   	
	i32.const	$push840=, 35
	i32.eq  	$push452=, $7, $pop840
	br_if   	0, $pop452      # 0: down to label21
# BB#110:                               # %if.then.i550
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.ne  	$push454=, $0, $7
	br_if   	2, $pop454      # 2: down to label2
# BB#111:                               # %if.end.i552
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$8=, 35
	i32.const	$0=, 0
	i32.const	$push844=, 0
	i32.const	$push843=, 35
	i32.store	bar.lastn($pop844), $pop843
	i32.const	$push842=, 0
	i32.const	$push841=, 0
	i32.store	bar.lastc($pop842), $pop841
.LBB1_112:                              # %if.end3.i557
                                        #   in Loop: Header=BB1_109 Depth=1
	end_block                       # label21:
	i32.const	$push847=, 24
	i32.shl 	$push455=, $0, $pop847
	i32.const	$push846=, 24
	i32.shr_s	$push456=, $pop455, $pop846
	i32.const	$push845=, 24
	i32.xor 	$push457=, $pop456, $pop845
	i32.ne  	$push458=, $pop457, $4
	br_if   	1, $pop458      # 1: down to label2
# BB#113:                               # %bar.exit560
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$push853=, 0
	i32.const	$push852=, 1
	i32.add 	$push851=, $0, $pop852
	tee_local	$push850=, $0=, $pop851
	i32.store	bar.lastc($pop853), $pop850
	i32.const	$push849=, 34
	i32.lt_u	$4=, $3, $pop849
	i32.const	$7=, 35
	i32.const	$push848=, 1
	i32.add 	$push12=, $3, $pop848
	copy_local	$3=, $pop12
	br_if   	0, $4           # 0: up to label20
# BB#114:                               # %for.end230
	end_loop
	i32.const	$push459=, 332
	i32.add 	$push460=, $1, $pop459
	i32.store	12($9), $pop460
	i32.const	$push527=, 16
	i32.add 	$push528=, $9, $pop527
	i32.const	$push854=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop528, $6, $pop854
	i32.const	$3=, 0
.LBB1_115:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label22:
	i32.const	$push529=, 16
	i32.add 	$push530=, $9, $pop529
	i32.add 	$push462=, $pop530, $3
	i32.load8_s	$7=, 0($pop462)
	block   	
	i32.const	$push855=, 72
	i32.eq  	$push461=, $8, $pop855
	br_if   	0, $pop461      # 0: down to label23
# BB#116:                               # %if.then.i564
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.ne  	$push463=, $0, $8
	br_if   	2, $pop463      # 2: down to label2
# BB#117:                               # %if.end.i566
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$0=, 0
	i32.const	$push859=, 0
	i32.const	$push858=, 72
	i32.store	bar.lastn($pop859), $pop858
	i32.const	$push857=, 0
	i32.const	$push856=, 0
	i32.store	bar.lastc($pop857), $pop856
.LBB1_118:                              # %if.end3.i571
                                        #   in Loop: Header=BB1_115 Depth=1
	end_block                       # label23:
	i32.const	$push862=, 24
	i32.shl 	$push464=, $0, $pop862
	i32.const	$push861=, 24
	i32.shr_s	$push465=, $pop464, $pop861
	i32.const	$push860=, 64
	i32.xor 	$push466=, $pop465, $pop860
	i32.ne  	$push467=, $pop466, $7
	br_if   	1, $pop467      # 1: down to label2
# BB#119:                               # %bar.exit574
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$push868=, 0
	i32.const	$push867=, 1
	i32.add 	$push866=, $0, $pop867
	tee_local	$push865=, $0=, $pop866
	i32.store	bar.lastc($pop868), $pop865
	i32.const	$push864=, 71
	i32.lt_u	$7=, $3, $pop864
	i32.const	$8=, 72
	i32.const	$push863=, 1
	i32.add 	$push13=, $3, $pop863
	copy_local	$3=, $pop13
	br_if   	0, $7           # 0: up to label22
# BB#120:                               # %for.end242
	end_loop
	i32.const	$push474=, 0
	i32.const	$push472=, 352
	i32.add 	$push473=, $9, $pop472
	i32.store	__stack_pointer($pop474), $pop473
	return
.LBB1_121:                              # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push218=, 0
	i32.const	$push216=, 0
	i32.load	$push215=, __stack_pointer($pop216)
	i32.const	$push217=, 800
	i32.sub 	$push366=, $pop215, $pop217
	tee_local	$push365=, $1=, $pop366
	i32.store	__stack_pointer($pop218), $pop365
	i32.const	$push0=, 4368
	i32.store16	792($1), $pop0
	i32.const	$push1=, 6424
	i32.store16	784($1), $pop1
	i32.const	$push2=, 26
	i32.store8	786($1), $pop2
	i32.const	$push3=, 589439264
	i32.store	776($1), $pop3
	i32.const	$push4=, 724183336
	i32.store	768($1), $pop4
	i32.const	$push5=, 44
	i32.store8	772($1), $pop5
	i32.const	$push6=, 858927408
	i32.store	760($1), $pop6
	i32.const	$push7=, 13620
	i32.store16	764($1), $pop7
	i32.const	$push8=, 993671480
	i32.store	752($1), $pop8
	i32.const	$push9=, 15676
	i32.store16	756($1), $pop9
	i32.const	$push10=, 62
	i32.store8	758($1), $pop10
	i64.const	$push11=, 5135868584551137600
	i64.store	744($1), $pop11
	i64.const	$push12=, 5714589967255750984
	i64.store	728($1), $pop12
	i32.const	$push13=, 64
	i32.store8	736($1), $pop13
	i32.const	$push14=, 1397903696
	i32.store	712($1), $pop14
	i32.const	$push15=, 21844
	i32.store16	716($1), $pop15
	i32.const	$push16=, 86
	i32.store8	718($1), $pop16
	i32.const	$push17=, 88
	i32.store8	720($1), $pop17
	i32.const	$push18=, 87
	i32.store8	719($1), $pop18
	i32.const	$push19=, 89
	i32.store8	721($1), $pop19
	i32.const	$push364=, 88
	i32.store8	696($1), $pop364
	i32.const	$push363=, 89
	i32.store8	697($1), $pop363
	i32.const	$push20=, 90
	i32.store8	698($1), $pop20
	i32.const	$push21=, 91
	i32.store8	699($1), $pop21
	i32.const	$push22=, 92
	i32.store8	700($1), $pop22
	i32.const	$push23=, 93
	i32.store8	701($1), $pop23
	i32.const	$push24=, 94
	i32.store8	702($1), $pop24
	i32.const	$push25=, 95
	i32.store8	703($1), $pop25
	i32.const	$push26=, 80
	i32.store8	704($1), $pop26
	i32.const	$push27=, 81
	i32.store8	705($1), $pop27
	i32.const	$push28=, 82
	i32.store8	706($1), $pop28
	i32.const	$push29=, 96
	i32.store8	680($1), $pop29
	i32.const	$push30=, 97
	i32.store8	681($1), $pop30
	i32.const	$push31=, 98
	i32.store8	682($1), $pop31
	i32.const	$push32=, 99
	i32.store8	683($1), $pop32
	i32.const	$push33=, 100
	i32.store8	684($1), $pop33
	i32.const	$push34=, 102
	i32.store8	686($1), $pop34
	i32.const	$push35=, 101
	i32.store8	685($1), $pop35
	i32.const	$push36=, 103
	i32.store8	687($1), $pop36
	i32.const	$push37=, 104
	i32.store8	688($1), $pop37
	i32.const	$push38=, 105
	i32.store8	689($1), $pop38
	i32.const	$push39=, 106
	i32.store8	690($1), $pop39
	i32.const	$push40=, 107
	i32.store8	691($1), $pop40
	i32.const	$push362=, 104
	i32.store8	664($1), $pop362
	i32.const	$push361=, 105
	i32.store8	665($1), $pop361
	i32.const	$push360=, 106
	i32.store8	666($1), $pop360
	i32.const	$push359=, 107
	i32.store8	667($1), $pop359
	i32.const	$push41=, 108
	i32.store8	668($1), $pop41
	i32.const	$push42=, 109
	i32.store8	669($1), $pop42
	i32.const	$push43=, 110
	i32.store8	670($1), $pop43
	i32.const	$push44=, 111
	i32.store8	671($1), $pop44
	i32.const	$push358=, 96
	i32.store8	672($1), $pop358
	i32.const	$push357=, 97
	i32.store8	673($1), $pop357
	i32.const	$push356=, 98
	i32.store8	674($1), $pop356
	i32.const	$push355=, 99
	i32.store8	675($1), $pop355
	i32.const	$push354=, 100
	i32.store8	676($1), $pop354
	i32.const	$push45=, 112
	i32.store8	648($1), $pop45
	i32.const	$push46=, 113
	i32.store8	649($1), $pop46
	i32.const	$push47=, 114
	i32.store8	650($1), $pop47
	i32.const	$push48=, 115
	i32.store8	651($1), $pop48
	i32.const	$push49=, 116
	i32.store8	652($1), $pop49
	i32.const	$push50=, 117
	i32.store8	653($1), $pop50
	i32.const	$push51=, 118
	i32.store8	654($1), $pop51
	i32.const	$push52=, 119
	i32.store8	655($1), $pop52
	i32.const	$push53=, 120
	i32.store8	656($1), $pop53
	i32.const	$push54=, 121
	i32.store8	657($1), $pop54
	i32.const	$push55=, 122
	i32.store8	658($1), $pop55
	i32.const	$push56=, 123
	i32.store8	659($1), $pop56
	i32.const	$push57=, 124
	i32.store8	660($1), $pop57
	i32.const	$push58=, 125
	i32.store8	661($1), $pop58
	i32.const	$push353=, 120
	i32.store8	632($1), $pop353
	i32.const	$push352=, 121
	i32.store8	633($1), $pop352
	i32.const	$push351=, 122
	i32.store8	634($1), $pop351
	i32.const	$push350=, 123
	i32.store8	635($1), $pop350
	i32.const	$push349=, 124
	i32.store8	636($1), $pop349
	i32.const	$push348=, 125
	i32.store8	637($1), $pop348
	i32.const	$push59=, 126
	i32.store8	638($1), $pop59
	i32.const	$push60=, 127
	i32.store8	639($1), $pop60
	i32.const	$push347=, 112
	i32.store8	640($1), $pop347
	i32.const	$push346=, 113
	i32.store8	641($1), $pop346
	i32.const	$push345=, 114
	i32.store8	642($1), $pop345
	i32.const	$push344=, 115
	i32.store8	643($1), $pop344
	i32.const	$push343=, 116
	i32.store8	644($1), $pop343
	i32.const	$push342=, 117
	i32.store8	645($1), $pop342
	i32.const	$push341=, 118
	i32.store8	646($1), $pop341
	i32.const	$push61=, 128
	i32.store8	616($1), $pop61
	i32.const	$push62=, 129
	i32.store8	617($1), $pop62
	i32.const	$push63=, 130
	i32.store8	618($1), $pop63
	i32.const	$push64=, 131
	i32.store8	619($1), $pop64
	i32.const	$push65=, 132
	i32.store8	620($1), $pop65
	i32.const	$push66=, 133
	i32.store8	621($1), $pop66
	i32.const	$push67=, 134
	i32.store8	622($1), $pop67
	i32.const	$push68=, 135
	i32.store8	623($1), $pop68
	i32.const	$push69=, 136
	i32.store8	624($1), $pop69
	i32.const	$push70=, 137
	i32.store8	625($1), $pop70
	i32.const	$push71=, 138
	i32.store8	626($1), $pop71
	i32.const	$push72=, 139
	i32.store8	627($1), $pop72
	i32.const	$push73=, 140
	i32.store8	628($1), $pop73
	i32.const	$push74=, 141
	i32.store8	629($1), $pop74
	i32.const	$push75=, 142
	i32.store8	630($1), $pop75
	i32.const	$push76=, 143
	i32.store8	631($1), $pop76
	i32.const	$0=, 0
.LBB2_1:                                # %for.body180
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label24:
	i32.const	$push219=, 584
	i32.add 	$push220=, $1, $pop219
	i32.add 	$push78=, $pop220, $0
	i32.const	$push371=, 248
	i32.xor 	$push77=, $0, $pop371
	i32.store8	0($pop78), $pop77
	i32.const	$push370=, 1
	i32.add 	$push369=, $0, $pop370
	tee_local	$push368=, $0=, $pop369
	i32.const	$push367=, 31
	i32.ne  	$push79=, $pop368, $pop367
	br_if   	0, $pop79       # 0: up to label24
# BB#2:                                 # %for.end187
	end_loop
	i64.const	$push80=, 506097522914230528
	i64.store	552($1), $pop80
	i64.const	$push81=, 1084818905618843912
	i64.store	560($1), $pop81
	i32.const	$push82=, 4368
	i32.store16	568($1), $pop82
	i64.const	$push83=, 1808220633999610642
	i64.store	570($1):p2align=1, $pop83
	i32.const	$push84=, 488381210
	i32.store	578($1):p2align=1, $pop84
	i32.const	$push85=, 7966
	i32.store16	582($1), $pop85
	i32.const	$0=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label25:
	i32.const	$push221=, 512
	i32.add 	$push222=, $1, $pop221
	i32.add 	$push87=, $pop222, $0
	i32.const	$push376=, 24
	i32.xor 	$push86=, $0, $pop376
	i32.store8	0($pop87), $pop86
	i32.const	$push375=, 1
	i32.add 	$push374=, $0, $pop375
	tee_local	$push373=, $0=, $pop374
	i32.const	$push372=, 35
	i32.ne  	$push88=, $pop373, $pop372
	br_if   	0, $pop88       # 0: up to label25
# BB#4:                                 # %for.body213.preheader
	end_loop
	i32.const	$0=, 0
.LBB2_5:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label26:
	i32.const	$push223=, 440
	i32.add 	$push224=, $1, $pop223
	i32.add 	$push90=, $pop224, $0
	i32.const	$push381=, 64
	i32.xor 	$push89=, $0, $pop381
	i32.store8	0($pop90), $pop89
	i32.const	$push380=, 1
	i32.add 	$push379=, $0, $pop380
	tee_local	$push378=, $0=, $pop379
	i32.const	$push377=, 72
	i32.ne  	$push91=, $pop378, $pop377
	br_if   	0, $pop91       # 0: up to label26
# BB#6:                                 # %for.end220
	end_loop
	i32.const	$push92=, 436
	i32.add 	$push93=, $1, $pop92
	i32.load8_u	$push94=, 786($1)
	i32.store8	0($pop93), $pop94
	i32.const	$push225=, 420
	i32.add 	$push226=, $1, $pop225
	i32.const	$push95=, 4
	i32.add 	$push96=, $pop226, $pop95
	i32.load8_u	$push97=, 772($1)
	i32.store8	0($pop96), $pop97
	i32.const	$push227=, 412
	i32.add 	$push228=, $1, $pop227
	i32.const	$push415=, 4
	i32.add 	$push98=, $pop228, $pop415
	i32.load16_u	$push99=, 764($1)
	i32.store16	0($pop98), $pop99
	i32.const	$push100=, 410
	i32.add 	$push101=, $1, $pop100
	i32.load8_u	$push102=, 758($1)
	i32.store8	0($pop101), $pop102
	i32.const	$push229=, 404
	i32.add 	$push230=, $1, $pop229
	i32.const	$push414=, 4
	i32.add 	$push103=, $pop230, $pop414
	i32.load16_u	$push104=, 756($1)
	i32.store16	0($pop103), $pop104
	i32.load16_u	$push105=, 792($1)
	i32.store16	438($1), $pop105
	i32.load16_u	$push106=, 784($1)
	i32.store16	434($1), $pop106
	i32.load	$push107=, 776($1)
	i32.store	428($1), $pop107
	i32.load	$push108=, 768($1)
	i32.store	420($1), $pop108
	i32.load	$push109=, 760($1)
	i32.store	412($1), $pop109
	i32.load	$push110=, 752($1)
	i32.store	404($1), $pop110
	i32.const	$push231=, 376
	i32.add 	$push232=, $1, $pop231
	i32.const	$push111=, 8
	i32.add 	$push112=, $pop232, $pop111
	i32.const	$push233=, 728
	i32.add 	$push234=, $1, $pop233
	i32.const	$push413=, 8
	i32.add 	$push113=, $pop234, $pop413
	i32.load8_u	$push114=, 0($pop113)
	i32.store8	0($pop112), $pop114
	i32.const	$push235=, 360
	i32.add 	$push236=, $1, $pop235
	i32.const	$push412=, 8
	i32.add 	$push115=, $pop236, $pop412
	i32.const	$push237=, 712
	i32.add 	$push238=, $1, $pop237
	i32.const	$push411=, 8
	i32.add 	$push116=, $pop238, $pop411
	i32.load16_u	$push117=, 0($pop116)
	i32.store16	0($pop115), $pop117
	i32.const	$push239=, 344
	i32.add 	$push240=, $1, $pop239
	i32.const	$push118=, 10
	i32.add 	$push119=, $pop240, $pop118
	i32.const	$push241=, 696
	i32.add 	$push242=, $1, $pop241
	i32.const	$push410=, 10
	i32.add 	$push120=, $pop242, $pop410
	i32.load8_u	$push121=, 0($pop120)
	i32.store8	0($pop119), $pop121
	i32.const	$push243=, 344
	i32.add 	$push244=, $1, $pop243
	i32.const	$push409=, 8
	i32.add 	$push122=, $pop244, $pop409
	i32.const	$push245=, 696
	i32.add 	$push246=, $1, $pop245
	i32.const	$push408=, 8
	i32.add 	$push123=, $pop246, $pop408
	i32.load16_u	$push124=, 0($pop123)
	i32.store16	0($pop122), $pop124
	i32.const	$push247=, 328
	i32.add 	$push248=, $1, $pop247
	i32.const	$push407=, 8
	i32.add 	$push125=, $pop248, $pop407
	i32.const	$push249=, 680
	i32.add 	$push250=, $1, $pop249
	i32.const	$push406=, 8
	i32.add 	$push126=, $pop250, $pop406
	i32.load	$push127=, 0($pop126)
	i32.store	0($pop125), $pop127
	i64.load	$push128=, 744($1)
	i64.store	392($1), $pop128
	i64.load	$push129=, 728($1)
	i64.store	376($1), $pop129
	i64.load	$push130=, 712($1)
	i64.store	360($1), $pop130
	i64.load	$push131=, 696($1)
	i64.store	344($1), $pop131
	i64.load	$push132=, 680($1)
	i64.store	328($1), $pop132
	i64.load	$push133=, 669($1):p2align=0
	i64.store	317($1):p2align=0, $pop133
	i64.load	$push134=, 664($1)
	i64.store	312($1), $pop134
	i64.load	$push135=, 654($1):p2align=1
	i64.store	302($1):p2align=1, $pop135
	i64.load	$push136=, 648($1)
	i64.store	296($1), $pop136
	i64.load	$push137=, 639($1):p2align=0
	i64.store	287($1):p2align=0, $pop137
	i64.load	$push138=, 632($1)
	i64.store	280($1), $pop138
	i32.const	$push251=, 264
	i32.add 	$push252=, $1, $pop251
	i32.const	$push405=, 8
	i32.add 	$push139=, $pop252, $pop405
	i32.const	$push253=, 616
	i32.add 	$push254=, $1, $pop253
	i32.const	$push404=, 8
	i32.add 	$push140=, $pop254, $pop404
	i64.load	$push141=, 0($pop140)
	i64.store	0($pop139), $pop141
	i64.load	$push142=, 616($1)
	i64.store	264($1), $pop142
	i32.const	$push255=, 232
	i32.add 	$push256=, $1, $pop255
	i32.const	$push143=, 23
	i32.add 	$push144=, $pop256, $pop143
	i32.const	$push257=, 584
	i32.add 	$push258=, $1, $pop257
	i32.const	$push403=, 23
	i32.add 	$push145=, $pop258, $pop403
	i64.load	$push146=, 0($pop145):p2align=0
	i64.store	0($pop144):p2align=0, $pop146
	i32.const	$push259=, 232
	i32.add 	$push260=, $1, $pop259
	i32.const	$push147=, 16
	i32.add 	$push148=, $pop260, $pop147
	i32.const	$push261=, 584
	i32.add 	$push262=, $1, $pop261
	i32.const	$push402=, 16
	i32.add 	$push149=, $pop262, $pop402
	i64.load	$push150=, 0($pop149)
	i64.store	0($pop148), $pop150
	i32.const	$push263=, 232
	i32.add 	$push264=, $1, $pop263
	i32.const	$push401=, 8
	i32.add 	$push151=, $pop264, $pop401
	i32.const	$push265=, 584
	i32.add 	$push266=, $1, $pop265
	i32.const	$push400=, 8
	i32.add 	$push152=, $pop266, $pop400
	i64.load	$push153=, 0($pop152)
	i64.store	0($pop151), $pop153
	i64.load	$push154=, 584($1)
	i64.store	232($1), $pop154
	i32.const	$push267=, 200
	i32.add 	$push268=, $1, $pop267
	i32.const	$push155=, 24
	i32.add 	$push156=, $pop268, $pop155
	i32.const	$push269=, 552
	i32.add 	$push270=, $1, $pop269
	i32.const	$push399=, 24
	i32.add 	$push157=, $pop270, $pop399
	i64.load	$push158=, 0($pop157)
	i64.store	0($pop156), $pop158
	i32.const	$push271=, 200
	i32.add 	$push272=, $1, $pop271
	i32.const	$push398=, 16
	i32.add 	$push159=, $pop272, $pop398
	i32.const	$push273=, 552
	i32.add 	$push274=, $1, $pop273
	i32.const	$push397=, 16
	i32.add 	$push160=, $pop274, $pop397
	i64.load	$push161=, 0($pop160)
	i64.store	0($pop159), $pop161
	i32.const	$push275=, 200
	i32.add 	$push276=, $1, $pop275
	i32.const	$push396=, 8
	i32.add 	$push162=, $pop276, $pop396
	i32.const	$push277=, 552
	i32.add 	$push278=, $1, $pop277
	i32.const	$push395=, 8
	i32.add 	$push163=, $pop278, $pop395
	i64.load	$push164=, 0($pop163)
	i64.store	0($pop162), $pop164
	i64.load	$push165=, 552($1)
	i64.store	200($1), $pop165
	i32.const	$push279=, 160
	i32.add 	$push280=, $1, $pop279
	i32.const	$push166=, 34
	i32.add 	$push167=, $pop280, $pop166
	i32.const	$push281=, 512
	i32.add 	$push282=, $1, $pop281
	i32.const	$push394=, 34
	i32.add 	$push168=, $pop282, $pop394
	i32.load8_u	$push169=, 0($pop168)
	i32.store8	0($pop167), $pop169
	i32.const	$push283=, 160
	i32.add 	$push284=, $1, $pop283
	i32.const	$push170=, 32
	i32.add 	$push171=, $pop284, $pop170
	i32.const	$push285=, 512
	i32.add 	$push286=, $1, $pop285
	i32.const	$push393=, 32
	i32.add 	$push172=, $pop286, $pop393
	i32.load16_u	$push173=, 0($pop172)
	i32.store16	0($pop171), $pop173
	i32.const	$push287=, 160
	i32.add 	$push288=, $1, $pop287
	i32.const	$push392=, 24
	i32.add 	$push174=, $pop288, $pop392
	i32.const	$push289=, 512
	i32.add 	$push290=, $1, $pop289
	i32.const	$push391=, 24
	i32.add 	$push175=, $pop290, $pop391
	i64.load	$push176=, 0($pop175)
	i64.store	0($pop174), $pop176
	i32.const	$push291=, 160
	i32.add 	$push292=, $1, $pop291
	i32.const	$push390=, 16
	i32.add 	$push177=, $pop292, $pop390
	i32.const	$push293=, 512
	i32.add 	$push294=, $1, $pop293
	i32.const	$push389=, 16
	i32.add 	$push178=, $pop294, $pop389
	i64.load	$push179=, 0($pop178)
	i64.store	0($pop177), $pop179
	i32.const	$push295=, 160
	i32.add 	$push296=, $1, $pop295
	i32.const	$push388=, 8
	i32.add 	$push180=, $pop296, $pop388
	i32.const	$push297=, 512
	i32.add 	$push298=, $1, $pop297
	i32.const	$push387=, 8
	i32.add 	$push181=, $pop298, $pop387
	i64.load	$push182=, 0($pop181)
	i64.store	0($pop180), $pop182
	i64.load	$push183=, 512($1)
	i64.store	160($1), $pop183
	i32.const	$push299=, 88
	i32.add 	$push300=, $1, $pop299
	i32.const	$push301=, 440
	i32.add 	$push302=, $1, $pop301
	i32.const	$push184=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop300, $pop302, $pop184
	i32.const	$push185=, 76
	i32.add 	$push186=, $1, $pop185
	i32.const	$push303=, 88
	i32.add 	$push304=, $1, $pop303
	i32.store	0($pop186), $pop304
	i32.const	$push187=, 68
	i32.add 	$push188=, $1, $pop187
	i32.const	$push305=, 200
	i32.add 	$push306=, $1, $pop305
	i32.store	0($pop188), $pop306
	i32.const	$push189=, 64
	i32.add 	$push190=, $1, $pop189
	i32.const	$push307=, 232
	i32.add 	$push308=, $1, $pop307
	i32.store	0($pop190), $pop308
	i32.const	$push191=, 60
	i32.add 	$push192=, $1, $pop191
	i32.const	$push309=, 264
	i32.add 	$push310=, $1, $pop309
	i32.store	0($pop192), $pop310
	i32.const	$push193=, 56
	i32.add 	$push194=, $1, $pop193
	i32.const	$push311=, 280
	i32.add 	$push312=, $1, $pop311
	i32.store	0($pop194), $pop312
	i32.const	$push195=, 52
	i32.add 	$push196=, $1, $pop195
	i32.const	$push313=, 296
	i32.add 	$push314=, $1, $pop313
	i32.store	0($pop196), $pop314
	i32.const	$push197=, 48
	i32.add 	$push198=, $1, $pop197
	i32.const	$push315=, 312
	i32.add 	$push316=, $1, $pop315
	i32.store	0($pop198), $pop316
	i32.const	$push199=, 44
	i32.add 	$push200=, $1, $pop199
	i32.const	$push317=, 328
	i32.add 	$push318=, $1, $pop317
	i32.store	0($pop200), $pop318
	i32.const	$push201=, 40
	i32.add 	$push202=, $1, $pop201
	i32.const	$push319=, 344
	i32.add 	$push320=, $1, $pop319
	i32.store	0($pop202), $pop320
	i32.const	$push203=, 36
	i32.add 	$push204=, $1, $pop203
	i32.const	$push321=, 360
	i32.add 	$push322=, $1, $pop321
	i32.store	0($pop204), $pop322
	i32.const	$push386=, 32
	i32.add 	$push205=, $1, $pop386
	i32.const	$push323=, 376
	i32.add 	$push324=, $1, $pop323
	i32.store	0($pop205), $pop324
	i32.const	$push206=, 28
	i32.add 	$push207=, $1, $pop206
	i32.const	$push325=, 392
	i32.add 	$push326=, $1, $pop325
	i32.store	0($pop207), $pop326
	i32.const	$push385=, 24
	i32.add 	$push208=, $1, $pop385
	i32.const	$push327=, 404
	i32.add 	$push328=, $1, $pop327
	i32.store	0($pop208), $pop328
	i32.const	$push209=, 20
	i32.add 	$push210=, $1, $pop209
	i32.const	$push329=, 412
	i32.add 	$push330=, $1, $pop329
	i32.store	0($pop210), $pop330
	i32.const	$push384=, 16
	i32.add 	$push211=, $1, $pop384
	i32.const	$push331=, 420
	i32.add 	$push332=, $1, $pop331
	i32.store	0($pop211), $pop332
	i32.const	$push383=, 8
	i32.store	0($1), $pop383
	i32.const	$push382=, 72
	i32.add 	$push212=, $1, $pop382
	i32.const	$push333=, 160
	i32.add 	$push334=, $1, $pop333
	i32.store	0($pop212), $pop334
	i32.const	$push335=, 428
	i32.add 	$push336=, $1, $pop335
	i32.store	12($1), $pop336
	i32.const	$push337=, 434
	i32.add 	$push338=, $1, $pop337
	i32.store	8($1), $pop338
	i32.const	$push339=, 438
	i32.add 	$push340=, $1, $pop339
	i32.store	4($1), $pop340
	i32.const	$push213=, 21
	call    	foo@FUNCTION, $pop213, $1
	i32.const	$push214=, 0
	call    	exit@FUNCTION, $pop214
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
