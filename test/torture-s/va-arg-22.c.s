	.text
	.file	"va-arg-22.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$2=, bar.lastn($pop0)
	i32.const	$push13=, 0
	i32.load	$3=, bar.lastc($pop13)
	block   	
	block   	
	i32.eq  	$push1=, $2, $0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.then
	i32.ne  	$push2=, $3, $2
	br_if   	1, $pop2        # 1: down to label0
# %bb.2:                                # %if.end
	i32.const	$3=, 0
	i32.const	$push16=, 0
	i32.store	bar.lastn($pop16), $0
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.store	bar.lastc($pop15), $pop14
.LBB0_3:                                # %if.end3
	end_block                       # label1:
	i32.const	$push3=, 3
	i32.shl 	$push4=, $0, $pop3
	i32.xor 	$push5=, $3, $pop4
	i32.const	$push6=, 24
	i32.shl 	$push7=, $pop5, $pop6
	i32.const	$push17=, 24
	i32.shr_s	$push8=, $pop7, $pop17
	i32.ne  	$push9=, $pop8, $1
	br_if   	0, $pop9        # 0: down to label0
# %bb.4:                                # %if.end8
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
# %bb.0:                                # %entry
	i32.const	$push470=, 0
	i32.load	$push469=, __stack_pointer($pop470)
	i32.const	$push471=, 352
	i32.sub 	$9=, $pop469, $pop471
	i32.const	$push472=, 0
	i32.store	__stack_pointer($pop472), $9
	block   	
	i32.const	$push4=, 21
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label2
# %bb.1:                                # %if.end
	i32.store	12($9), $1
	i32.const	$push6=, 4
	i32.add 	$push7=, $1, $pop6
	i32.store	12($9), $pop7
	i32.const	$push8=, 0
	i32.load	$8=, bar.lastn($pop8)
	i32.const	$push532=, 0
	i32.load	$0=, bar.lastc($pop532)
	i32.load8_s	$3=, 0($1)
	block   	
	i32.const	$push9=, 1
	i32.eq  	$push10=, $8, $pop9
	br_if   	0, $pop10       # 0: down to label3
# %bb.2:                                # %if.then.i
	i32.ne  	$push11=, $0, $8
	br_if   	1, $pop11       # 1: down to label2
# %bb.3:                                # %if.end.i
	i32.const	$0=, 0
	i32.const	$push535=, 0
	i32.const	$push12=, 1
	i32.store	bar.lastn($pop535), $pop12
	i32.const	$push534=, 0
	i32.const	$push533=, 0
	i32.store	bar.lastc($pop534), $pop533
.LBB1_4:                                # %if.end3.i
	end_block                       # label3:
	i32.const	$push13=, 24
	i32.shl 	$push14=, $0, $pop13
	i32.const	$push537=, 24
	i32.shr_s	$push15=, $pop14, $pop537
	i32.const	$push536=, 8
	i32.xor 	$push16=, $pop15, $pop536
	i32.ne  	$push17=, $pop16, $3
	br_if   	0, $pop17       # 0: down to label2
# %bb.5:                                # %if.then.i312
	i32.const	$push539=, 0
	i32.const	$push18=, 1
	i32.add 	$push19=, $0, $pop18
	i32.store	bar.lastc($pop539), $pop19
	i32.const	$push538=, 8
	i32.add 	$8=, $1, $pop538
	i32.store	12($9), $8
	br_if   	0, $0           # 0: down to label2
# %bb.6:                                # %if.end3.i319
	i32.const	$push20=, 4
	i32.add 	$push21=, $1, $pop20
	i32.load16_u	$0=, 0($pop21):p2align=0
	i32.const	$push542=, 0
	i32.const	$push22=, 2
	i32.store	bar.lastn($pop542), $pop22
	i32.const	$push541=, 0
	i32.const	$push540=, 0
	i32.store	bar.lastc($pop541), $pop540
	i32.const	$push23=, 255
	i32.and 	$push24=, $0, $pop23
	i32.const	$push25=, 16
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label2
# %bb.7:                                # %if.end3.i319.1
	i32.const	$push543=, 0
	i32.const	$push27=, 1
	i32.store	bar.lastc($pop543), $pop27
	i32.const	$push28=, 65280
	i32.and 	$push29=, $0, $pop28
	i32.const	$push30=, 4352
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label2
# %bb.8:                                # %if.end3.i333
	i32.const	$push546=, 0
	i32.const	$push32=, 3
	i32.store	bar.lastn($pop546), $pop32
	i32.load16_u	$push33=, 0($8):p2align=0
	i32.store16	344($9), $pop33
	i32.const	$push545=, 0
	i32.const	$push544=, 0
	i32.store	bar.lastc($pop545), $pop544
	i32.const	$push34=, 12
	i32.add 	$push35=, $1, $pop34
	i32.store	12($9), $pop35
	i32.const	$push36=, 2
	i32.add 	$push37=, $8, $pop36
	i32.load8_u	$push38=, 0($pop37)
	i32.store8	346($9), $pop38
	i32.load8_u	$push40=, 344($9)
	i32.const	$push39=, 24
	i32.ne  	$push41=, $pop40, $pop39
	br_if   	0, $pop41       # 0: down to label2
# %bb.9:                                # %if.end3.i333.1
	i32.const	$push547=, 0
	i32.const	$push42=, 1
	i32.store	bar.lastc($pop547), $pop42
	i32.load8_u	$push44=, 345($9)
	i32.const	$push43=, 25
	i32.ne  	$push45=, $pop44, $pop43
	br_if   	0, $pop45       # 0: down to label2
# %bb.10:                               # %if.end3.i333.2
	i32.const	$push548=, 0
	i32.const	$push46=, 2
	i32.store	bar.lastc($pop548), $pop46
	i32.load8_u	$push48=, 346($9)
	i32.const	$push47=, 26
	i32.ne  	$push49=, $pop48, $pop47
	br_if   	0, $pop49       # 0: down to label2
# %bb.11:                               # %if.end3.i347
	i32.const	$push50=, 16
	i32.add 	$8=, $1, $pop50
	i32.store	12($9), $8
	i32.const	$push51=, 12
	i32.add 	$push52=, $1, $pop51
	i32.load	$0=, 0($pop52):p2align=0
	i32.const	$push551=, 0
	i32.const	$push53=, 4
	i32.store	bar.lastn($pop551), $pop53
	i32.const	$push550=, 0
	i32.const	$push549=, 0
	i32.store	bar.lastc($pop550), $pop549
	i32.const	$push54=, 255
	i32.and 	$push55=, $0, $pop54
	i32.const	$push56=, 32
	i32.ne  	$push57=, $pop55, $pop56
	br_if   	0, $pop57       # 0: down to label2
# %bb.12:                               # %if.end3.i347.1
	i32.const	$push552=, 0
	i32.const	$push58=, 1
	i32.store	bar.lastc($pop552), $pop58
	i32.const	$push59=, 65280
	i32.and 	$push60=, $0, $pop59
	i32.const	$push61=, 8448
	i32.ne  	$push62=, $pop60, $pop61
	br_if   	0, $pop62       # 0: down to label2
# %bb.13:                               # %if.end3.i347.2
	i32.const	$push553=, 0
	i32.const	$push63=, 2
	i32.store	bar.lastc($pop553), $pop63
	i32.const	$push64=, 16711680
	i32.and 	$push65=, $0, $pop64
	i32.const	$push66=, 2228224
	i32.ne  	$push67=, $pop65, $pop66
	br_if   	0, $pop67       # 0: down to label2
# %bb.14:                               # %if.end3.i347.3
	i32.const	$push554=, 0
	i32.const	$push68=, 3
	i32.store	bar.lastc($pop554), $pop68
	i32.const	$push69=, -16777216
	i32.and 	$push70=, $0, $pop69
	i32.const	$push71=, 587202560
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label2
# %bb.15:                               # %if.end3.i361
	i32.const	$push557=, 0
	i32.const	$push73=, 5
	i32.store	bar.lastn($pop557), $pop73
	i32.load	$push74=, 0($8):p2align=0
	i32.store	336($9), $pop74
	i32.const	$push556=, 0
	i32.const	$push555=, 0
	i32.store	bar.lastc($pop556), $pop555
	i32.const	$push75=, 24
	i32.add 	$3=, $1, $pop75
	i32.store	12($9), $3
	i32.const	$push76=, 4
	i32.add 	$push77=, $8, $pop76
	i32.load8_u	$push78=, 0($pop77)
	i32.store8	340($9), $pop78
	i32.load8_u	$push80=, 336($9)
	i32.const	$push79=, 40
	i32.ne  	$push81=, $pop80, $pop79
	br_if   	0, $pop81       # 0: down to label2
# %bb.16:                               # %if.end3.i361.1
	i32.const	$push558=, 0
	i32.const	$push82=, 1
	i32.store	bar.lastc($pop558), $pop82
	i32.load8_u	$push84=, 337($9)
	i32.const	$push83=, 41
	i32.ne  	$push85=, $pop84, $pop83
	br_if   	0, $pop85       # 0: down to label2
# %bb.17:                               # %if.end3.i361.2
	i32.const	$push559=, 0
	i32.const	$push86=, 2
	i32.store	bar.lastc($pop559), $pop86
	i32.load8_u	$push88=, 338($9)
	i32.const	$push87=, 42
	i32.ne  	$push89=, $pop88, $pop87
	br_if   	0, $pop89       # 0: down to label2
# %bb.18:                               # %if.end3.i361.3
	i32.const	$push560=, 0
	i32.const	$push90=, 3
	i32.store	bar.lastc($pop560), $pop90
	i32.load8_u	$push92=, 339($9)
	i32.const	$push91=, 43
	i32.ne  	$push93=, $pop92, $pop91
	br_if   	0, $pop93       # 0: down to label2
# %bb.19:                               # %if.end3.i361.4
	i32.const	$push562=, 0
	i32.const	$push561=, 4
	i32.store	bar.lastc($pop562), $pop561
	i32.load8_u	$push95=, 340($9)
	i32.const	$push94=, 44
	i32.ne  	$push96=, $pop95, $pop94
	br_if   	0, $pop96       # 0: down to label2
# %bb.20:                               # %if.end3.i375
	i32.const	$push566=, 0
	i32.const	$push97=, 6
	i32.store	bar.lastn($pop566), $pop97
	i32.load	$push98=, 0($3):p2align=0
	i32.store	328($9), $pop98
	i32.const	$push565=, 0
	i32.const	$push564=, 0
	i32.store	bar.lastc($pop565), $pop564
	i32.const	$push99=, 32
	i32.add 	$0=, $1, $pop99
	i32.store	12($9), $0
	i32.const	$push563=, 4
	i32.add 	$push100=, $3, $pop563
	i32.load16_u	$push101=, 0($pop100):p2align=0
	i32.store16	332($9), $pop101
	i32.load8_u	$push103=, 328($9)
	i32.const	$push102=, 48
	i32.ne  	$push104=, $pop103, $pop102
	br_if   	0, $pop104      # 0: down to label2
# %bb.21:                               # %if.end3.i375.1
	i32.const	$push567=, 0
	i32.const	$push105=, 1
	i32.store	bar.lastc($pop567), $pop105
	i32.load8_u	$push107=, 329($9)
	i32.const	$push106=, 49
	i32.ne  	$push108=, $pop107, $pop106
	br_if   	0, $pop108      # 0: down to label2
# %bb.22:                               # %if.end3.i375.2
	i32.const	$push568=, 0
	i32.const	$push109=, 2
	i32.store	bar.lastc($pop568), $pop109
	i32.load8_u	$push111=, 330($9)
	i32.const	$push110=, 50
	i32.ne  	$push112=, $pop111, $pop110
	br_if   	0, $pop112      # 0: down to label2
# %bb.23:                               # %if.end3.i375.3
	i32.const	$push569=, 0
	i32.const	$push113=, 3
	i32.store	bar.lastc($pop569), $pop113
	i32.load8_u	$push115=, 331($9)
	i32.const	$push114=, 51
	i32.ne  	$push116=, $pop115, $pop114
	br_if   	0, $pop116      # 0: down to label2
# %bb.24:                               # %if.end3.i375.4
	i32.const	$push570=, 0
	i32.const	$push117=, 4
	i32.store	bar.lastc($pop570), $pop117
	i32.load8_u	$push119=, 332($9)
	i32.const	$push118=, 52
	i32.ne  	$push120=, $pop119, $pop118
	br_if   	0, $pop120      # 0: down to label2
# %bb.25:                               # %if.end3.i375.5
	i32.const	$push571=, 0
	i32.const	$push121=, 5
	i32.store	bar.lastc($pop571), $pop121
	i32.load8_u	$push123=, 333($9)
	i32.const	$push122=, 53
	i32.ne  	$push124=, $pop123, $pop122
	br_if   	0, $pop124      # 0: down to label2
# %bb.26:                               # %if.end3.i389
	i32.const	$push574=, 0
	i32.const	$push125=, 7
	i32.store	bar.lastn($pop574), $pop125
	i32.load	$push126=, 0($0):p2align=0
	i32.store	320($9), $pop126
	i32.const	$push573=, 0
	i32.const	$push572=, 0
	i32.store	bar.lastc($pop573), $pop572
	i32.const	$push127=, 40
	i32.add 	$push128=, $1, $pop127
	i32.store	12($9), $pop128
	i32.const	$push129=, 4
	i32.add 	$push130=, $0, $pop129
	i32.load16_u	$push131=, 0($pop130):p2align=0
	i32.store16	324($9), $pop131
	i32.const	$push132=, 6
	i32.add 	$push133=, $0, $pop132
	i32.load8_u	$push134=, 0($pop133)
	i32.store8	326($9), $pop134
	i32.load8_u	$push136=, 320($9)
	i32.const	$push135=, 56
	i32.ne  	$push137=, $pop136, $pop135
	br_if   	0, $pop137      # 0: down to label2
# %bb.27:                               # %if.end3.i389.1
	i32.const	$push575=, 0
	i32.const	$push138=, 1
	i32.store	bar.lastc($pop575), $pop138
	i32.load8_u	$push140=, 321($9)
	i32.const	$push139=, 57
	i32.ne  	$push141=, $pop140, $pop139
	br_if   	0, $pop141      # 0: down to label2
# %bb.28:                               # %if.end3.i389.2
	i32.const	$push576=, 0
	i32.const	$push142=, 2
	i32.store	bar.lastc($pop576), $pop142
	i32.load8_u	$push144=, 322($9)
	i32.const	$push143=, 58
	i32.ne  	$push145=, $pop144, $pop143
	br_if   	0, $pop145      # 0: down to label2
# %bb.29:                               # %if.end3.i389.3
	i32.const	$push577=, 0
	i32.const	$push146=, 3
	i32.store	bar.lastc($pop577), $pop146
	i32.load8_u	$push148=, 323($9)
	i32.const	$push147=, 59
	i32.ne  	$push149=, $pop148, $pop147
	br_if   	0, $pop149      # 0: down to label2
# %bb.30:                               # %if.end3.i389.4
	i32.const	$push578=, 0
	i32.const	$push150=, 4
	i32.store	bar.lastc($pop578), $pop150
	i32.load8_u	$push152=, 324($9)
	i32.const	$push151=, 60
	i32.ne  	$push153=, $pop152, $pop151
	br_if   	0, $pop153      # 0: down to label2
# %bb.31:                               # %if.end3.i389.5
	i32.const	$push579=, 0
	i32.const	$push154=, 5
	i32.store	bar.lastc($pop579), $pop154
	i32.load8_u	$push156=, 325($9)
	i32.const	$push155=, 61
	i32.ne  	$push157=, $pop156, $pop155
	br_if   	0, $pop157      # 0: down to label2
# %bb.32:                               # %if.end3.i389.6
	i32.const	$push580=, 0
	i32.const	$push158=, 6
	i32.store	bar.lastc($pop580), $pop158
	i32.load8_u	$push160=, 326($9)
	i32.const	$push159=, 62
	i32.ne  	$push161=, $pop160, $pop159
	br_if   	0, $pop161      # 0: down to label2
# %bb.33:                               # %if.end3.i403
	i32.const	$push583=, 0
	i32.const	$push162=, 8
	i32.store	bar.lastn($pop583), $pop162
	i32.const	$push582=, 0
	i32.const	$push581=, 0
	i32.store	bar.lastc($pop582), $pop581
	i32.const	$push163=, 48
	i32.add 	$0=, $1, $pop163
	i32.store	12($9), $0
	i32.const	$push164=, 40
	i32.add 	$push165=, $1, $pop164
	i64.load	$2=, 0($pop165):p2align=0
	i64.const	$push170=, 255
	i64.and 	$push171=, $2, $pop170
	i64.const	$push172=, 64
	i64.ne  	$push173=, $pop171, $pop172
	br_if   	0, $pop173      # 0: down to label2
# %bb.34:                               # %if.end3.i403.1
	i32.const	$push584=, 0
	i32.const	$push174=, 1
	i32.store	bar.lastc($pop584), $pop174
	i32.wrap/i64	$push175=, $2
	i32.const	$push176=, 16
	i32.shl 	$push177=, $pop175, $pop176
	i32.const	$push178=, -16777216
	i32.and 	$push179=, $pop177, $pop178
	i32.const	$push180=, 1090519040
	i32.ne  	$push181=, $pop179, $pop180
	br_if   	0, $pop181      # 0: down to label2
# %bb.35:                               # %if.end3.i403.2
	i32.const	$push585=, 0
	i32.const	$push182=, 2
	i32.store	bar.lastc($pop585), $pop182
	i64.const	$push169=, 16
	i64.shr_u	$push0=, $2, $pop169
	i32.wrap/i64	$push183=, $pop0
	i32.const	$push184=, 24
	i32.shl 	$push185=, $pop183, $pop184
	i32.const	$push186=, 1107296256
	i32.ne  	$push187=, $pop185, $pop186
	br_if   	0, $pop187      # 0: down to label2
# %bb.36:                               # %if.end3.i403.3
	i32.const	$push586=, 0
	i32.const	$push188=, 3
	i32.store	bar.lastc($pop586), $pop188
	i64.const	$push189=, 4278190080
	i64.and 	$push190=, $2, $pop189
	i64.const	$push191=, 1124073472
	i64.ne  	$push192=, $pop190, $pop191
	br_if   	0, $pop192      # 0: down to label2
# %bb.37:                               # %if.end3.i403.4
	i32.const	$push588=, 0
	i32.const	$push193=, 4
	i32.store	bar.lastc($pop588), $pop193
	i64.const	$push168=, 32
	i64.shr_u	$push1=, $2, $pop168
	i32.wrap/i64	$push194=, $pop1
	i32.const	$push587=, 24
	i32.shl 	$push195=, $pop194, $pop587
	i32.const	$push196=, 1140850688
	i32.ne  	$push197=, $pop195, $pop196
	br_if   	0, $pop197      # 0: down to label2
# %bb.38:                               # %if.end3.i403.5
	i32.const	$push590=, 0
	i32.const	$push198=, 5
	i32.store	bar.lastc($pop590), $pop198
	i64.const	$push167=, 40
	i64.shr_u	$push2=, $2, $pop167
	i32.wrap/i64	$push199=, $pop2
	i32.const	$push589=, 24
	i32.shl 	$push200=, $pop199, $pop589
	i32.const	$push201=, 1157627904
	i32.ne  	$push202=, $pop200, $pop201
	br_if   	0, $pop202      # 0: down to label2
# %bb.39:                               # %if.end3.i403.6
	i32.const	$push591=, 0
	i32.const	$push203=, 6
	i32.store	bar.lastc($pop591), $pop203
	i64.const	$push166=, 48
	i64.shr_u	$push3=, $2, $pop166
	i32.wrap/i64	$push204=, $pop3
	i32.const	$push205=, 24
	i32.shl 	$push206=, $pop204, $pop205
	i32.const	$push207=, 1174405120
	i32.ne  	$push208=, $pop206, $pop207
	br_if   	0, $pop208      # 0: down to label2
# %bb.40:                               # %if.end3.i403.7
	i32.const	$push592=, 0
	i32.const	$push209=, 7
	i32.store	bar.lastc($pop592), $pop209
	i64.const	$push210=, -72057594037927936
	i64.and 	$push211=, $2, $pop210
	i64.const	$push212=, 5116089176692883456
	i64.ne  	$push213=, $pop211, $pop212
	br_if   	0, $pop213      # 0: down to label2
# %bb.41:                               # %if.end3.i417
	i32.const	$push596=, 0
	i32.const	$push214=, 9
	i32.store	bar.lastn($pop596), $pop214
	i32.const	$push476=, 304
	i32.add 	$push477=, $9, $pop476
	i32.const	$push215=, 8
	i32.add 	$push218=, $pop477, $pop215
	i32.const	$push595=, 8
	i32.add 	$push216=, $0, $pop595
	i32.load8_u	$push217=, 0($pop216)
	i32.store8	0($pop218), $pop217
	i64.load	$push219=, 0($0):p2align=0
	i64.store	304($9), $pop219
	i32.const	$push594=, 0
	i32.const	$push593=, 0
	i32.store	bar.lastc($pop594), $pop593
	i32.const	$push220=, 60
	i32.add 	$0=, $1, $pop220
	i32.store	12($9), $0
	i32.load8_u	$push222=, 304($9)
	i32.const	$push221=, 72
	i32.ne  	$push223=, $pop222, $pop221
	br_if   	0, $pop223      # 0: down to label2
# %bb.42:                               # %if.end3.i417.1
	i32.const	$push597=, 0
	i32.const	$push224=, 1
	i32.store	bar.lastc($pop597), $pop224
	i32.load8_u	$push226=, 305($9)
	i32.const	$push225=, 73
	i32.ne  	$push227=, $pop226, $pop225
	br_if   	0, $pop227      # 0: down to label2
# %bb.43:                               # %if.end3.i417.2
	i32.const	$push598=, 0
	i32.const	$push228=, 2
	i32.store	bar.lastc($pop598), $pop228
	i32.load8_u	$push230=, 306($9)
	i32.const	$push229=, 74
	i32.ne  	$push231=, $pop230, $pop229
	br_if   	0, $pop231      # 0: down to label2
# %bb.44:                               # %if.end3.i417.3
	i32.const	$push599=, 0
	i32.const	$push232=, 3
	i32.store	bar.lastc($pop599), $pop232
	i32.load8_u	$push234=, 307($9)
	i32.const	$push233=, 75
	i32.ne  	$push235=, $pop234, $pop233
	br_if   	0, $pop235      # 0: down to label2
# %bb.45:                               # %if.end3.i417.4
	i32.const	$push600=, 0
	i32.const	$push236=, 4
	i32.store	bar.lastc($pop600), $pop236
	i32.load8_u	$push238=, 308($9)
	i32.const	$push237=, 76
	i32.ne  	$push239=, $pop238, $pop237
	br_if   	0, $pop239      # 0: down to label2
# %bb.46:                               # %if.end3.i417.5
	i32.const	$push601=, 0
	i32.const	$push240=, 5
	i32.store	bar.lastc($pop601), $pop240
	i32.load8_u	$push242=, 309($9)
	i32.const	$push241=, 77
	i32.ne  	$push243=, $pop242, $pop241
	br_if   	0, $pop243      # 0: down to label2
# %bb.47:                               # %if.end3.i417.6
	i32.const	$push602=, 0
	i32.const	$push244=, 6
	i32.store	bar.lastc($pop602), $pop244
	i32.load8_u	$push246=, 310($9)
	i32.const	$push245=, 78
	i32.ne  	$push247=, $pop246, $pop245
	br_if   	0, $pop247      # 0: down to label2
# %bb.48:                               # %if.end3.i417.7
	i32.const	$push603=, 0
	i32.const	$push248=, 7
	i32.store	bar.lastc($pop603), $pop248
	i32.load8_u	$push250=, 311($9)
	i32.const	$push249=, 79
	i32.ne  	$push251=, $pop250, $pop249
	br_if   	0, $pop251      # 0: down to label2
# %bb.49:                               # %if.end3.i417.8
	i32.const	$push605=, 0
	i32.const	$push604=, 8
	i32.store	bar.lastc($pop605), $pop604
	i32.load8_u	$push253=, 312($9)
	i32.const	$push252=, 64
	i32.ne  	$push254=, $pop253, $pop252
	br_if   	0, $pop254      # 0: down to label2
# %bb.50:                               # %bar.exit420.8
	i32.const	$push610=, 0
	i32.const	$push255=, 10
	i32.store	bar.lastn($pop610), $pop255
	i32.const	$push478=, 288
	i32.add 	$push479=, $9, $pop478
	i32.const	$push609=, 8
	i32.add 	$push258=, $pop479, $pop609
	i32.const	$push608=, 8
	i32.add 	$push256=, $0, $pop608
	i32.load16_u	$push257=, 0($pop256):p2align=0
	i32.store16	0($pop258), $pop257
	i64.load	$push259=, 0($0):p2align=0
	i64.store	288($9), $pop259
	i32.const	$push607=, 0
	i32.const	$push606=, 0
	i32.store	bar.lastc($pop607), $pop606
	i32.const	$push260=, 72
	i32.add 	$3=, $1, $pop260
	i32.store	12($9), $3
	i32.load8_s	$push262=, 288($9)
	i32.const	$push261=, 80
	i32.ne  	$push263=, $pop262, $pop261
	br_if   	0, $pop263      # 0: down to label2
# %bb.51:                               # %bar.exit434
	i32.const	$push612=, 0
	i32.const	$push611=, 1
	i32.store	bar.lastc($pop612), $pop611
	i32.load8_s	$push265=, 289($9)
	i32.const	$push264=, 81
	i32.ne  	$push266=, $pop265, $pop264
	br_if   	0, $pop266      # 0: down to label2
# %bb.52:                               # %bar.exit434.1
	i32.const	$push616=, 1
	i32.const	$push615=, 1
	i32.add 	$0=, $pop616, $pop615
	i32.const	$push614=, 0
	i32.store	bar.lastc($pop614), $0
	i32.const	$push613=, 80
	i32.or  	$push267=, $0, $pop613
	i32.load8_s	$push268=, 290($9)
	i32.ne  	$push269=, $pop267, $pop268
	br_if   	0, $pop269      # 0: down to label2
# %bb.53:                               # %bar.exit434.2
	i32.const	$push621=, 1
	i32.add 	$0=, $0, $pop621
	i32.const	$push620=, 0
	i32.store	bar.lastc($pop620), $0
	i32.const	$push619=, 24
	i32.shl 	$push270=, $0, $pop619
	i32.const	$push618=, 24
	i32.shr_s	$push271=, $pop270, $pop618
	i32.const	$push617=, 80
	i32.xor 	$push272=, $pop271, $pop617
	i32.load8_s	$push273=, 291($9)
	i32.ne  	$push274=, $pop272, $pop273
	br_if   	0, $pop274      # 0: down to label2
# %bb.54:                               # %bar.exit434.3
	i32.const	$push626=, 1
	i32.add 	$0=, $0, $pop626
	i32.const	$push625=, 0
	i32.store	bar.lastc($pop625), $0
	i32.const	$push624=, 24
	i32.shl 	$push275=, $0, $pop624
	i32.const	$push623=, 24
	i32.shr_s	$push276=, $pop275, $pop623
	i32.const	$push622=, 80
	i32.xor 	$push277=, $pop276, $pop622
	i32.load8_s	$push278=, 292($9)
	i32.ne  	$push279=, $pop277, $pop278
	br_if   	0, $pop279      # 0: down to label2
# %bb.55:                               # %bar.exit434.4
	i32.const	$push631=, 1
	i32.add 	$0=, $0, $pop631
	i32.const	$push630=, 0
	i32.store	bar.lastc($pop630), $0
	i32.const	$push629=, 24
	i32.shl 	$push280=, $0, $pop629
	i32.const	$push628=, 24
	i32.shr_s	$push281=, $pop280, $pop628
	i32.const	$push627=, 80
	i32.xor 	$push282=, $pop281, $pop627
	i32.load8_s	$push283=, 293($9)
	i32.ne  	$push284=, $pop282, $pop283
	br_if   	0, $pop284      # 0: down to label2
# %bb.56:                               # %bar.exit434.5
	i32.const	$push636=, 1
	i32.add 	$0=, $0, $pop636
	i32.const	$push635=, 0
	i32.store	bar.lastc($pop635), $0
	i32.const	$push634=, 24
	i32.shl 	$push285=, $0, $pop634
	i32.const	$push633=, 24
	i32.shr_s	$push286=, $pop285, $pop633
	i32.const	$push632=, 80
	i32.xor 	$push287=, $pop286, $pop632
	i32.load8_s	$push288=, 294($9)
	i32.ne  	$push289=, $pop287, $pop288
	br_if   	0, $pop289      # 0: down to label2
# %bb.57:                               # %bar.exit434.6
	i32.const	$push641=, 1
	i32.add 	$0=, $0, $pop641
	i32.const	$push640=, 0
	i32.store	bar.lastc($pop640), $0
	i32.const	$push639=, 24
	i32.shl 	$push290=, $0, $pop639
	i32.const	$push638=, 24
	i32.shr_s	$push291=, $pop290, $pop638
	i32.const	$push637=, 80
	i32.xor 	$push292=, $pop291, $pop637
	i32.load8_s	$push293=, 295($9)
	i32.ne  	$push294=, $pop292, $pop293
	br_if   	0, $pop294      # 0: down to label2
# %bb.58:                               # %bar.exit434.7
	i32.const	$push646=, 1
	i32.add 	$0=, $0, $pop646
	i32.const	$push645=, 0
	i32.store	bar.lastc($pop645), $0
	i32.const	$push644=, 24
	i32.shl 	$push295=, $0, $pop644
	i32.const	$push643=, 24
	i32.shr_s	$push296=, $pop295, $pop643
	i32.const	$push642=, 80
	i32.xor 	$push297=, $pop296, $pop642
	i32.load8_s	$push298=, 296($9)
	i32.ne  	$push299=, $pop297, $pop298
	br_if   	0, $pop299      # 0: down to label2
# %bb.59:                               # %bar.exit434.8
	i32.const	$push651=, 1
	i32.add 	$0=, $0, $pop651
	i32.const	$push650=, 0
	i32.store	bar.lastc($pop650), $0
	i32.const	$push649=, 24
	i32.shl 	$push300=, $0, $pop649
	i32.const	$push648=, 24
	i32.shr_s	$push301=, $pop300, $pop648
	i32.const	$push647=, 80
	i32.xor 	$push302=, $pop301, $pop647
	i32.load8_s	$push303=, 297($9)
	i32.ne  	$push304=, $pop302, $pop303
	br_if   	0, $pop304      # 0: down to label2
# %bb.60:                               # %bar.exit434.9
	i32.const	$push656=, 1
	i32.add 	$0=, $0, $pop656
	i32.const	$push655=, 0
	i32.store	bar.lastc($pop655), $0
	i32.const	$push480=, 272
	i32.add 	$push481=, $9, $pop480
	i32.const	$push305=, 8
	i32.add 	$push308=, $pop481, $pop305
	i32.const	$push654=, 8
	i32.add 	$push306=, $3, $pop654
	i32.load16_u	$push307=, 0($pop306):p2align=0
	i32.store16	0($pop308), $pop307
	i32.const	$8=, 10
	i32.const	$push482=, 272
	i32.add 	$push483=, $9, $pop482
	i32.const	$push653=, 10
	i32.add 	$push311=, $pop483, $pop653
	i32.const	$push652=, 10
	i32.add 	$push309=, $3, $pop652
	i32.load8_u	$push310=, 0($pop309)
	i32.store8	0($pop311), $pop310
	i32.const	$push312=, 84
	i32.add 	$6=, $1, $pop312
	i32.store	12($9), $6
	i64.load	$push313=, 0($3):p2align=0
	i64.store	272($9), $pop313
	i32.const	$7=, 10
	i32.const	$3=, 0
.LBB1_61:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push484=, 272
	i32.add 	$push485=, $9, $pop484
	i32.add 	$push315=, $pop485, $3
	i32.load8_s	$4=, 0($pop315)
	block   	
	i32.const	$push657=, 11
	i32.eq  	$push314=, $7, $pop657
	br_if   	0, $pop314      # 0: down to label5
# %bb.62:                               # %if.then.i438
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.ne  	$push316=, $0, $7
	br_if   	2, $pop316      # 2: down to label2
# %bb.63:                               # %if.end.i440
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.const	$8=, 11
	i32.const	$0=, 0
	i32.const	$push661=, 0
	i32.const	$push660=, 11
	i32.store	bar.lastn($pop661), $pop660
	i32.const	$push659=, 0
	i32.const	$push658=, 0
	i32.store	bar.lastc($pop659), $pop658
.LBB1_64:                               # %if.end3.i445
                                        #   in Loop: Header=BB1_61 Depth=1
	end_block                       # label5:
	i32.const	$push664=, 24
	i32.shl 	$push317=, $0, $pop664
	i32.const	$push663=, 24
	i32.shr_s	$push318=, $pop317, $pop663
	i32.const	$push662=, 88
	i32.xor 	$push319=, $pop318, $pop662
	i32.ne  	$push320=, $pop319, $4
	br_if   	1, $pop320      # 1: down to label2
# %bb.65:                               # %bar.exit448
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.const	$push668=, 1
	i32.add 	$0=, $0, $pop668
	i32.const	$push667=, 0
	i32.store	bar.lastc($pop667), $0
	i32.const	$push666=, 1
	i32.add 	$3=, $3, $pop666
	i32.const	$7=, 11
	i32.const	$push665=, 11
	i32.lt_u	$push321=, $3, $pop665
	br_if   	0, $pop321      # 0: up to label4
# %bb.66:                               # %for.end134
	end_loop
	i32.const	$push486=, 256
	i32.add 	$push487=, $9, $pop486
	i32.const	$push322=, 8
	i32.add 	$push325=, $pop487, $pop322
	i32.const	$push670=, 8
	i32.add 	$push323=, $6, $pop670
	i32.load	$push324=, 0($pop323):p2align=0
	i32.store	0($pop325), $pop324
	i64.load	$push326=, 0($6):p2align=0
	i64.store	256($9), $pop326
	i32.const	$push669=, 96
	i32.add 	$6=, $1, $pop669
	i32.store	12($9), $6
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_67:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push488=, 256
	i32.add 	$push489=, $9, $pop488
	i32.add 	$push328=, $pop489, $3
	i32.load8_s	$4=, 0($pop328)
	block   	
	i32.const	$push671=, 12
	i32.eq  	$push327=, $7, $pop671
	br_if   	0, $pop327      # 0: down to label7
# %bb.68:                               # %if.then.i452
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.ne  	$push329=, $0, $7
	br_if   	2, $pop329      # 2: down to label2
# %bb.69:                               # %if.end.i454
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$8=, 12
	i32.const	$0=, 0
	i32.const	$push675=, 0
	i32.const	$push674=, 12
	i32.store	bar.lastn($pop675), $pop674
	i32.const	$push673=, 0
	i32.const	$push672=, 0
	i32.store	bar.lastc($pop673), $pop672
.LBB1_70:                               # %if.end3.i459
                                        #   in Loop: Header=BB1_67 Depth=1
	end_block                       # label7:
	i32.const	$push678=, 24
	i32.shl 	$push330=, $0, $pop678
	i32.const	$push677=, 24
	i32.shr_s	$push331=, $pop330, $pop677
	i32.const	$push676=, 96
	i32.xor 	$push332=, $pop331, $pop676
	i32.ne  	$push333=, $pop332, $4
	br_if   	1, $pop333      # 1: down to label2
# %bb.71:                               # %bar.exit462
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$push682=, 1
	i32.add 	$0=, $0, $pop682
	i32.const	$push681=, 0
	i32.store	bar.lastc($pop681), $0
	i32.const	$push680=, 1
	i32.add 	$3=, $3, $pop680
	i32.const	$7=, 12
	i32.const	$push679=, 12
	i32.lt_u	$push334=, $3, $pop679
	br_if   	0, $pop334      # 0: up to label6
# %bb.72:                               # %for.end146
	end_loop
	i64.load	$push335=, 0($6):p2align=0
	i64.store	240($9), $pop335
	i32.const	$push336=, 112
	i32.add 	$5=, $1, $pop336
	i32.store	12($9), $5
	i32.const	$push337=, 5
	i32.add 	$push338=, $6, $pop337
	i64.load	$push339=, 0($pop338):p2align=0
	i64.store	245($9):p2align=0, $pop339
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_73:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push490=, 240
	i32.add 	$push491=, $9, $pop490
	i32.add 	$push341=, $pop491, $3
	i32.load8_s	$4=, 0($pop341)
	block   	
	i32.const	$push683=, 13
	i32.eq  	$push340=, $7, $pop683
	br_if   	0, $pop340      # 0: down to label9
# %bb.74:                               # %if.then.i466
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.ne  	$push342=, $0, $7
	br_if   	2, $pop342      # 2: down to label2
# %bb.75:                               # %if.end.i468
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$8=, 13
	i32.const	$0=, 0
	i32.const	$push687=, 0
	i32.const	$push686=, 13
	i32.store	bar.lastn($pop687), $pop686
	i32.const	$push685=, 0
	i32.const	$push684=, 0
	i32.store	bar.lastc($pop685), $pop684
.LBB1_76:                               # %if.end3.i473
                                        #   in Loop: Header=BB1_73 Depth=1
	end_block                       # label9:
	i32.const	$push690=, 24
	i32.shl 	$push343=, $0, $pop690
	i32.const	$push689=, 24
	i32.shr_s	$push344=, $pop343, $pop689
	i32.const	$push688=, 104
	i32.xor 	$push345=, $pop344, $pop688
	i32.ne  	$push346=, $pop345, $4
	br_if   	1, $pop346      # 1: down to label2
# %bb.77:                               # %bar.exit476
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$push694=, 1
	i32.add 	$0=, $0, $pop694
	i32.const	$push693=, 0
	i32.store	bar.lastc($pop693), $0
	i32.const	$push692=, 1
	i32.add 	$3=, $3, $pop692
	i32.const	$7=, 13
	i32.const	$push691=, 13
	i32.lt_u	$push347=, $3, $pop691
	br_if   	0, $pop347      # 0: up to label8
# %bb.78:                               # %for.end158
	end_loop
	i64.load	$push348=, 0($5):p2align=0
	i64.store	224($9), $pop348
	i32.const	$push349=, 128
	i32.add 	$6=, $1, $pop349
	i32.store	12($9), $6
	i32.const	$push350=, 6
	i32.add 	$push351=, $5, $pop350
	i64.load	$push352=, 0($pop351):p2align=0
	i64.store	230($9):p2align=1, $pop352
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_79:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push492=, 224
	i32.add 	$push493=, $9, $pop492
	i32.add 	$push354=, $pop493, $3
	i32.load8_s	$4=, 0($pop354)
	block   	
	i32.const	$push695=, 14
	i32.eq  	$push353=, $7, $pop695
	br_if   	0, $pop353      # 0: down to label11
# %bb.80:                               # %if.then.i480
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.ne  	$push355=, $0, $7
	br_if   	2, $pop355      # 2: down to label2
# %bb.81:                               # %if.end.i482
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$8=, 14
	i32.const	$0=, 0
	i32.const	$push699=, 0
	i32.const	$push698=, 14
	i32.store	bar.lastn($pop699), $pop698
	i32.const	$push697=, 0
	i32.const	$push696=, 0
	i32.store	bar.lastc($pop697), $pop696
.LBB1_82:                               # %if.end3.i487
                                        #   in Loop: Header=BB1_79 Depth=1
	end_block                       # label11:
	i32.const	$push702=, 24
	i32.shl 	$push356=, $0, $pop702
	i32.const	$push701=, 24
	i32.shr_s	$push357=, $pop356, $pop701
	i32.const	$push700=, 112
	i32.xor 	$push358=, $pop357, $pop700
	i32.ne  	$push359=, $pop358, $4
	br_if   	1, $pop359      # 1: down to label2
# %bb.83:                               # %bar.exit490
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$push706=, 1
	i32.add 	$0=, $0, $pop706
	i32.const	$push705=, 0
	i32.store	bar.lastc($pop705), $0
	i32.const	$push704=, 1
	i32.add 	$3=, $3, $pop704
	i32.const	$7=, 14
	i32.const	$push703=, 14
	i32.lt_u	$push360=, $3, $pop703
	br_if   	0, $pop360      # 0: up to label10
# %bb.84:                               # %for.end170
	end_loop
	i64.load	$push361=, 0($6):p2align=0
	i64.store	208($9), $pop361
	i32.const	$push362=, 144
	i32.add 	$5=, $1, $pop362
	i32.store	12($9), $5
	i32.const	$push363=, 7
	i32.add 	$push364=, $6, $pop363
	i64.load	$push365=, 0($pop364):p2align=0
	i64.store	215($9):p2align=0, $pop365
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_85:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	i32.const	$push494=, 208
	i32.add 	$push495=, $9, $pop494
	i32.add 	$push367=, $pop495, $3
	i32.load8_s	$4=, 0($pop367)
	block   	
	i32.const	$push707=, 15
	i32.eq  	$push366=, $7, $pop707
	br_if   	0, $pop366      # 0: down to label13
# %bb.86:                               # %if.then.i494
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.ne  	$push368=, $0, $7
	br_if   	2, $pop368      # 2: down to label2
# %bb.87:                               # %if.end.i496
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$8=, 15
	i32.const	$0=, 0
	i32.const	$push711=, 0
	i32.const	$push710=, 15
	i32.store	bar.lastn($pop711), $pop710
	i32.const	$push709=, 0
	i32.const	$push708=, 0
	i32.store	bar.lastc($pop709), $pop708
.LBB1_88:                               # %if.end3.i501
                                        #   in Loop: Header=BB1_85 Depth=1
	end_block                       # label13:
	i32.const	$push714=, 24
	i32.shl 	$push369=, $0, $pop714
	i32.const	$push713=, 24
	i32.shr_s	$push370=, $pop369, $pop713
	i32.const	$push712=, 120
	i32.xor 	$push371=, $pop370, $pop712
	i32.ne  	$push372=, $pop371, $4
	br_if   	1, $pop372      # 1: down to label2
# %bb.89:                               # %bar.exit504
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$push718=, 1
	i32.add 	$0=, $0, $pop718
	i32.const	$push717=, 0
	i32.store	bar.lastc($pop717), $0
	i32.const	$push716=, 1
	i32.add 	$3=, $3, $pop716
	i32.const	$7=, 15
	i32.const	$push715=, 15
	i32.lt_u	$push373=, $3, $pop715
	br_if   	0, $pop373      # 0: up to label12
# %bb.90:                               # %for.end182
	end_loop
	i32.const	$push496=, 192
	i32.add 	$push497=, $9, $pop496
	i32.const	$push374=, 8
	i32.add 	$push377=, $pop497, $pop374
	i32.const	$push719=, 8
	i32.add 	$push375=, $5, $pop719
	i64.load	$push376=, 0($pop375):p2align=0
	i64.store	0($pop377), $pop376
	i64.load	$push378=, 0($5):p2align=0
	i64.store	192($9), $pop378
	i32.const	$push379=, 160
	i32.add 	$6=, $1, $pop379
	i32.store	12($9), $6
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_91:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push498=, 192
	i32.add 	$push499=, $9, $pop498
	i32.add 	$push381=, $pop499, $3
	i32.load8_s	$4=, 0($pop381)
	block   	
	i32.const	$push720=, 16
	i32.eq  	$push380=, $7, $pop720
	br_if   	0, $pop380      # 0: down to label15
# %bb.92:                               # %if.then.i508
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.ne  	$push382=, $0, $7
	br_if   	2, $pop382      # 2: down to label2
# %bb.93:                               # %if.end.i510
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$8=, 16
	i32.const	$0=, 0
	i32.const	$push724=, 0
	i32.const	$push723=, 16
	i32.store	bar.lastn($pop724), $pop723
	i32.const	$push722=, 0
	i32.const	$push721=, 0
	i32.store	bar.lastc($pop722), $pop721
.LBB1_94:                               # %if.end3.i515
                                        #   in Loop: Header=BB1_91 Depth=1
	end_block                       # label15:
	i32.const	$push727=, 24
	i32.shl 	$push383=, $0, $pop727
	i32.const	$push726=, -2147483648
	i32.xor 	$push384=, $pop383, $pop726
	i32.const	$push725=, 24
	i32.shr_s	$push385=, $pop384, $pop725
	i32.ne  	$push386=, $pop385, $4
	br_if   	1, $pop386      # 1: down to label2
# %bb.95:                               # %bar.exit518
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$push731=, 1
	i32.add 	$0=, $0, $pop731
	i32.const	$push730=, 0
	i32.store	bar.lastc($pop730), $0
	i32.const	$push729=, 1
	i32.add 	$3=, $3, $pop729
	i32.const	$7=, 16
	i32.const	$push728=, 16
	i32.lt_u	$push387=, $3, $pop728
	br_if   	0, $pop387      # 0: up to label14
# %bb.96:                               # %for.end194
	end_loop
	i32.const	$push500=, 160
	i32.add 	$push501=, $9, $pop500
	i32.const	$push388=, 8
	i32.add 	$push391=, $pop501, $pop388
	i32.const	$push734=, 8
	i32.add 	$push389=, $6, $pop734
	i64.load	$push390=, 0($pop389):p2align=0
	i64.store	0($pop391), $pop390
	i32.const	$push502=, 160
	i32.add 	$push503=, $9, $pop502
	i32.const	$push392=, 16
	i32.add 	$push395=, $pop503, $pop392
	i32.const	$push733=, 16
	i32.add 	$push393=, $6, $pop733
	i64.load	$push394=, 0($pop393):p2align=0
	i64.store	0($pop395), $pop394
	i32.const	$push504=, 160
	i32.add 	$push505=, $9, $pop504
	i32.const	$push396=, 23
	i32.add 	$push399=, $pop505, $pop396
	i32.const	$push732=, 23
	i32.add 	$push397=, $6, $pop732
	i64.load	$push398=, 0($pop397):p2align=0
	i64.store	0($pop399):p2align=0, $pop398
	i64.load	$push400=, 0($6):p2align=0
	i64.store	160($9), $pop400
	i32.const	$push401=, 192
	i32.add 	$6=, $1, $pop401
	i32.store	12($9), $6
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_97:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push506=, 160
	i32.add 	$push507=, $9, $pop506
	i32.add 	$push403=, $pop507, $3
	i32.load8_s	$4=, 0($pop403)
	block   	
	i32.const	$push735=, 31
	i32.eq  	$push402=, $7, $pop735
	br_if   	0, $pop402      # 0: down to label17
# %bb.98:                               # %if.then.i522
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.ne  	$push404=, $0, $7
	br_if   	2, $pop404      # 2: down to label2
# %bb.99:                               # %if.end.i524
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$8=, 31
	i32.const	$0=, 0
	i32.const	$push739=, 0
	i32.const	$push738=, 31
	i32.store	bar.lastn($pop739), $pop738
	i32.const	$push737=, 0
	i32.const	$push736=, 0
	i32.store	bar.lastc($pop737), $pop736
.LBB1_100:                              # %if.end3.i529
                                        #   in Loop: Header=BB1_97 Depth=1
	end_block                       # label17:
	i32.const	$push742=, 24
	i32.shl 	$push405=, $0, $pop742
	i32.const	$push741=, -134217728
	i32.xor 	$push406=, $pop405, $pop741
	i32.const	$push740=, 24
	i32.shr_s	$push407=, $pop406, $pop740
	i32.ne  	$push408=, $pop407, $4
	br_if   	1, $pop408      # 1: down to label2
# %bb.101:                              # %bar.exit532
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$push746=, 1
	i32.add 	$0=, $0, $pop746
	i32.const	$push745=, 0
	i32.store	bar.lastc($pop745), $0
	i32.const	$push744=, 1
	i32.add 	$3=, $3, $pop744
	i32.const	$7=, 31
	i32.const	$push743=, 31
	i32.lt_u	$push409=, $3, $pop743
	br_if   	0, $pop409      # 0: up to label16
# %bb.102:                              # %for.end206
	end_loop
	i32.const	$push508=, 128
	i32.add 	$push509=, $9, $pop508
	i32.const	$push410=, 8
	i32.add 	$push413=, $pop509, $pop410
	i32.const	$push750=, 8
	i32.add 	$push411=, $6, $pop750
	i64.load	$push412=, 0($pop411):p2align=0
	i64.store	0($pop413), $pop412
	i32.const	$push510=, 128
	i32.add 	$push511=, $9, $pop510
	i32.const	$push414=, 16
	i32.add 	$push417=, $pop511, $pop414
	i32.const	$push749=, 16
	i32.add 	$push415=, $6, $pop749
	i64.load	$push416=, 0($pop415):p2align=0
	i64.store	0($pop417), $pop416
	i32.const	$push512=, 128
	i32.add 	$push513=, $9, $pop512
	i32.const	$push748=, 24
	i32.add 	$push420=, $pop513, $pop748
	i32.const	$push747=, 24
	i32.add 	$push418=, $6, $pop747
	i64.load	$push419=, 0($pop418):p2align=0
	i64.store	0($pop420), $pop419
	i64.load	$push421=, 0($6):p2align=0
	i64.store	128($9), $pop421
	i32.const	$push422=, 224
	i32.add 	$6=, $1, $pop422
	i32.store	12($9), $6
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_103:                              # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push514=, 128
	i32.add 	$push515=, $9, $pop514
	i32.add 	$push424=, $pop515, $3
	i32.load8_s	$4=, 0($pop424)
	block   	
	i32.const	$push751=, 32
	i32.eq  	$push423=, $7, $pop751
	br_if   	0, $pop423      # 0: down to label19
# %bb.104:                              # %if.then.i536
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.ne  	$push425=, $0, $7
	br_if   	2, $pop425      # 2: down to label2
# %bb.105:                              # %if.end.i538
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$8=, 32
	i32.const	$0=, 0
	i32.const	$push755=, 0
	i32.const	$push754=, 32
	i32.store	bar.lastn($pop755), $pop754
	i32.const	$push753=, 0
	i32.const	$push752=, 0
	i32.store	bar.lastc($pop753), $pop752
.LBB1_106:                              # %if.end3.i543
                                        #   in Loop: Header=BB1_103 Depth=1
	end_block                       # label19:
	i32.const	$push757=, 24
	i32.shl 	$push426=, $0, $pop757
	i32.const	$push756=, 24
	i32.shr_s	$push427=, $pop426, $pop756
	i32.ne  	$push428=, $pop427, $4
	br_if   	1, $pop428      # 1: down to label2
# %bb.107:                              # %bar.exit546
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$push761=, 1
	i32.add 	$0=, $0, $pop761
	i32.const	$push760=, 0
	i32.store	bar.lastc($pop760), $0
	i32.const	$push759=, 1
	i32.add 	$3=, $3, $pop759
	i32.const	$7=, 32
	i32.const	$push758=, 32
	i32.lt_u	$push429=, $3, $pop758
	br_if   	0, $pop429      # 0: up to label18
# %bb.108:                              # %for.end218
	end_loop
	i32.const	$push516=, 88
	i32.add 	$push517=, $9, $pop516
	i32.const	$push430=, 8
	i32.add 	$push433=, $pop517, $pop430
	i32.const	$push767=, 8
	i32.add 	$push431=, $6, $pop767
	i64.load	$push432=, 0($pop431):p2align=0
	i64.store	0($pop433), $pop432
	i32.const	$push518=, 88
	i32.add 	$push519=, $9, $pop518
	i32.const	$push434=, 16
	i32.add 	$push437=, $pop519, $pop434
	i32.const	$push766=, 16
	i32.add 	$push435=, $6, $pop766
	i64.load	$push436=, 0($pop435):p2align=0
	i64.store	0($pop437), $pop436
	i32.const	$push520=, 88
	i32.add 	$push521=, $9, $pop520
	i32.const	$push765=, 24
	i32.add 	$push440=, $pop521, $pop765
	i32.const	$push764=, 24
	i32.add 	$push438=, $6, $pop764
	i64.load	$push439=, 0($pop438):p2align=0
	i64.store	0($pop440), $pop439
	i32.const	$push522=, 88
	i32.add 	$push523=, $9, $pop522
	i32.const	$push441=, 32
	i32.add 	$push444=, $pop523, $pop441
	i32.const	$push763=, 32
	i32.add 	$push442=, $6, $pop763
	i32.load16_u	$push443=, 0($pop442):p2align=0
	i32.store16	0($pop444), $pop443
	i32.const	$push524=, 88
	i32.add 	$push525=, $9, $pop524
	i32.const	$push445=, 34
	i32.add 	$push448=, $pop525, $pop445
	i32.const	$push762=, 34
	i32.add 	$push446=, $6, $pop762
	i32.load8_u	$push447=, 0($pop446)
	i32.store8	0($pop448), $pop447
	i64.load	$push449=, 0($6):p2align=0
	i64.store	88($9), $pop449
	i32.const	$push450=, 260
	i32.add 	$6=, $1, $pop450
	i32.store	12($9), $6
	copy_local	$7=, $8
	i32.const	$3=, 0
.LBB1_109:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push526=, 88
	i32.add 	$push527=, $9, $pop526
	i32.add 	$push452=, $pop527, $3
	i32.load8_s	$4=, 0($pop452)
	block   	
	i32.const	$push768=, 35
	i32.eq  	$push451=, $7, $pop768
	br_if   	0, $pop451      # 0: down to label21
# %bb.110:                              # %if.then.i550
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.ne  	$push453=, $0, $7
	br_if   	2, $pop453      # 2: down to label2
# %bb.111:                              # %if.end.i552
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$8=, 35
	i32.const	$0=, 0
	i32.const	$push772=, 0
	i32.const	$push771=, 35
	i32.store	bar.lastn($pop772), $pop771
	i32.const	$push770=, 0
	i32.const	$push769=, 0
	i32.store	bar.lastc($pop770), $pop769
.LBB1_112:                              # %if.end3.i557
                                        #   in Loop: Header=BB1_109 Depth=1
	end_block                       # label21:
	i32.const	$push775=, 24
	i32.shl 	$push454=, $0, $pop775
	i32.const	$push774=, 24
	i32.shr_s	$push455=, $pop454, $pop774
	i32.const	$push773=, 24
	i32.xor 	$push456=, $pop455, $pop773
	i32.ne  	$push457=, $pop456, $4
	br_if   	1, $pop457      # 1: down to label2
# %bb.113:                              # %bar.exit560
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$push779=, 1
	i32.add 	$0=, $0, $pop779
	i32.const	$push778=, 0
	i32.store	bar.lastc($pop778), $0
	i32.const	$push777=, 1
	i32.add 	$3=, $3, $pop777
	i32.const	$7=, 35
	i32.const	$push776=, 35
	i32.lt_u	$push458=, $3, $pop776
	br_if   	0, $pop458      # 0: up to label20
# %bb.114:                              # %for.end230
	end_loop
	i32.const	$push459=, 332
	i32.add 	$push460=, $1, $pop459
	i32.store	12($9), $pop460
	i32.const	$push528=, 16
	i32.add 	$push529=, $9, $pop528
	i32.const	$push780=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop529, $6, $pop780
	i32.const	$3=, 0
.LBB1_115:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label22:
	i32.const	$push530=, 16
	i32.add 	$push531=, $9, $pop530
	i32.add 	$push462=, $pop531, $3
	i32.load8_s	$7=, 0($pop462)
	block   	
	i32.const	$push781=, 72
	i32.eq  	$push461=, $8, $pop781
	br_if   	0, $pop461      # 0: down to label23
# %bb.116:                              # %if.then.i564
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.ne  	$push463=, $0, $8
	br_if   	2, $pop463      # 2: down to label2
# %bb.117:                              # %if.end.i566
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$0=, 0
	i32.const	$push785=, 0
	i32.const	$push784=, 72
	i32.store	bar.lastn($pop785), $pop784
	i32.const	$push783=, 0
	i32.const	$push782=, 0
	i32.store	bar.lastc($pop783), $pop782
.LBB1_118:                              # %if.end3.i571
                                        #   in Loop: Header=BB1_115 Depth=1
	end_block                       # label23:
	i32.const	$push788=, 24
	i32.shl 	$push464=, $0, $pop788
	i32.const	$push787=, 24
	i32.shr_s	$push465=, $pop464, $pop787
	i32.const	$push786=, 64
	i32.xor 	$push466=, $pop465, $pop786
	i32.ne  	$push467=, $pop466, $7
	br_if   	1, $pop467      # 1: down to label2
# %bb.119:                              # %bar.exit574
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$push792=, 1
	i32.add 	$0=, $0, $pop792
	i32.const	$push791=, 0
	i32.store	bar.lastc($pop791), $0
	i32.const	$push790=, 1
	i32.add 	$3=, $3, $pop790
	i32.const	$8=, 72
	i32.const	$push789=, 72
	i32.lt_u	$push468=, $3, $pop789
	br_if   	0, $pop468      # 0: up to label22
# %bb.120:                              # %for.end242
	end_loop
	i32.const	$push475=, 0
	i32.const	$push473=, 352
	i32.add 	$push474=, $9, $pop473
	i32.store	__stack_pointer($pop475), $pop474
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
# %bb.0:                                # %entry
	i32.const	$push174=, 0
	i32.load	$push173=, __stack_pointer($pop174)
	i32.const	$push175=, 800
	i32.sub 	$1=, $pop173, $pop175
	i32.const	$push176=, 0
	i32.store	__stack_pointer($pop176), $1
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
	i32.const	$push17=, 89
	i32.store8	721($1), $pop17
	i32.const	$push18=, 22615
	i32.store16	719($1):p2align=0, $pop18
	i64.const	$push19=, 6872032732664977752
	i64.store	696($1), $pop19
	i32.const	$push20=, 20816
	i32.store16	704($1), $pop20
	i32.const	$push21=, 82
	i32.store8	706($1), $pop21
	i64.const	$push22=, 7450754115369591136
	i64.store	680($1), $pop22
	i32.const	$push23=, 1802135912
	i32.store	688($1), $pop23
	i32.const	$push299=, 1802135912
	i32.store	664($1), $pop299
	i64.const	$push24=, 7161393424286772588
	i64.store	668($1):p2align=2, $pop24
	i32.const	$push25=, 100
	i32.store8	676($1), $pop25
	i64.const	$push26=, 8608196880778817904
	i64.store	648($1), $pop26
	i32.const	$push27=, 2071624056
	i32.store	656($1), $pop27
	i32.const	$push28=, 32124
	i32.store16	660($1), $pop28
	i64.const	$push29=, 9186918263483431288
	i64.store	632($1), $pop29
	i32.const	$push30=, 1936879984
	i32.store	640($1), $pop30
	i32.const	$push31=, 30068
	i32.store16	644($1), $pop31
	i32.const	$push32=, 118
	i32.store8	646($1), $pop32
	i64.const	$push33=, -8681104427521506944
	i64.store	616($1), $pop33
	i64.const	$push34=, -8102383044816893560
	i64.store	624($1), $pop34
	i32.const	$0=, 0
.LBB2_1:                                # %for.body180
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label24:
	i32.const	$push177=, 584
	i32.add 	$push178=, $1, $pop177
	i32.add 	$push36=, $pop178, $0
	i32.const	$push302=, 248
	i32.xor 	$push35=, $0, $pop302
	i32.store8	0($pop36), $pop35
	i32.const	$push301=, 1
	i32.add 	$0=, $0, $pop301
	i32.const	$push300=, 31
	i32.ne  	$push37=, $0, $pop300
	br_if   	0, $pop37       # 0: up to label24
# %bb.2:                                # %for.end187
	end_loop
	i64.const	$push38=, 506097522914230528
	i64.store	552($1), $pop38
	i64.const	$push39=, 1084818905618843912
	i64.store	560($1), $pop39
	i32.const	$push40=, 4368
	i32.store16	568($1), $pop40
	i64.const	$push41=, 1808220633999610642
	i64.store	570($1):p2align=1, $pop41
	i32.const	$push42=, 488381210
	i32.store	578($1):p2align=1, $pop42
	i32.const	$push43=, 7966
	i32.store16	582($1), $pop43
	i32.const	$0=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label25:
	i32.const	$push179=, 512
	i32.add 	$push180=, $1, $pop179
	i32.add 	$push45=, $pop180, $0
	i32.const	$push305=, 24
	i32.xor 	$push44=, $0, $pop305
	i32.store8	0($pop45), $pop44
	i32.const	$push304=, 1
	i32.add 	$0=, $0, $pop304
	i32.const	$push303=, 35
	i32.ne  	$push46=, $0, $pop303
	br_if   	0, $pop46       # 0: up to label25
# %bb.4:                                # %for.body213.preheader
	end_loop
	i32.const	$0=, 0
.LBB2_5:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label26:
	i32.const	$push181=, 440
	i32.add 	$push182=, $1, $pop181
	i32.add 	$push48=, $pop182, $0
	i32.const	$push308=, 64
	i32.xor 	$push47=, $0, $pop308
	i32.store8	0($pop48), $pop47
	i32.const	$push307=, 1
	i32.add 	$0=, $0, $pop307
	i32.const	$push306=, 72
	i32.ne  	$push49=, $0, $pop306
	br_if   	0, $pop49       # 0: up to label26
# %bb.6:                                # %for.end220
	end_loop
	i32.const	$push50=, 436
	i32.add 	$push51=, $1, $pop50
	i32.load8_u	$push52=, 786($1)
	i32.store8	0($pop51), $pop52
	i32.const	$push183=, 420
	i32.add 	$push184=, $1, $pop183
	i32.const	$push53=, 4
	i32.add 	$push54=, $pop184, $pop53
	i32.load8_u	$push55=, 772($1)
	i32.store8	0($pop54), $pop55
	i32.const	$push185=, 412
	i32.add 	$push186=, $1, $pop185
	i32.const	$push342=, 4
	i32.add 	$push56=, $pop186, $pop342
	i32.load16_u	$push57=, 764($1)
	i32.store16	0($pop56), $pop57
	i32.const	$push58=, 410
	i32.add 	$push59=, $1, $pop58
	i32.load8_u	$push60=, 758($1)
	i32.store8	0($pop59), $pop60
	i32.const	$push187=, 404
	i32.add 	$push188=, $1, $pop187
	i32.const	$push341=, 4
	i32.add 	$push61=, $pop188, $pop341
	i32.load16_u	$push62=, 756($1)
	i32.store16	0($pop61), $pop62
	i32.load16_u	$push63=, 792($1)
	i32.store16	438($1), $pop63
	i32.load16_u	$push64=, 784($1)
	i32.store16	434($1), $pop64
	i32.load	$push65=, 776($1)
	i32.store	428($1), $pop65
	i32.load	$push66=, 768($1)
	i32.store	420($1), $pop66
	i32.load	$push67=, 760($1)
	i32.store	412($1), $pop67
	i32.load	$push68=, 752($1)
	i32.store	404($1), $pop68
	i32.const	$push189=, 376
	i32.add 	$push190=, $1, $pop189
	i32.const	$push69=, 8
	i32.add 	$push70=, $pop190, $pop69
	i32.const	$push191=, 728
	i32.add 	$push192=, $1, $pop191
	i32.const	$push340=, 8
	i32.add 	$push71=, $pop192, $pop340
	i32.load8_u	$push72=, 0($pop71)
	i32.store8	0($pop70), $pop72
	i32.const	$push193=, 360
	i32.add 	$push194=, $1, $pop193
	i32.const	$push339=, 8
	i32.add 	$push73=, $pop194, $pop339
	i32.const	$push195=, 712
	i32.add 	$push196=, $1, $pop195
	i32.const	$push338=, 8
	i32.add 	$push74=, $pop196, $pop338
	i32.load16_u	$push75=, 0($pop74)
	i32.store16	0($pop73), $pop75
	i32.const	$push197=, 344
	i32.add 	$push198=, $1, $pop197
	i32.const	$push76=, 10
	i32.add 	$push77=, $pop198, $pop76
	i32.const	$push199=, 696
	i32.add 	$push200=, $1, $pop199
	i32.const	$push337=, 10
	i32.add 	$push78=, $pop200, $pop337
	i32.load8_u	$push79=, 0($pop78)
	i32.store8	0($pop77), $pop79
	i32.const	$push201=, 344
	i32.add 	$push202=, $1, $pop201
	i32.const	$push336=, 8
	i32.add 	$push80=, $pop202, $pop336
	i32.const	$push203=, 696
	i32.add 	$push204=, $1, $pop203
	i32.const	$push335=, 8
	i32.add 	$push81=, $pop204, $pop335
	i32.load16_u	$push82=, 0($pop81)
	i32.store16	0($pop80), $pop82
	i32.const	$push205=, 328
	i32.add 	$push206=, $1, $pop205
	i32.const	$push334=, 8
	i32.add 	$push83=, $pop206, $pop334
	i32.const	$push207=, 680
	i32.add 	$push208=, $1, $pop207
	i32.const	$push333=, 8
	i32.add 	$push84=, $pop208, $pop333
	i32.load	$push85=, 0($pop84)
	i32.store	0($pop83), $pop85
	i64.load	$push86=, 744($1)
	i64.store	392($1), $pop86
	i64.load	$push87=, 728($1)
	i64.store	376($1), $pop87
	i64.load	$push88=, 712($1)
	i64.store	360($1), $pop88
	i64.load	$push89=, 696($1)
	i64.store	344($1), $pop89
	i64.load	$push90=, 680($1)
	i64.store	328($1), $pop90
	i64.load	$push91=, 669($1):p2align=0
	i64.store	317($1):p2align=0, $pop91
	i64.load	$push92=, 664($1)
	i64.store	312($1), $pop92
	i64.load	$push93=, 654($1):p2align=1
	i64.store	302($1):p2align=1, $pop93
	i64.load	$push94=, 648($1)
	i64.store	296($1), $pop94
	i64.load	$push95=, 639($1):p2align=0
	i64.store	287($1):p2align=0, $pop95
	i64.load	$push96=, 632($1)
	i64.store	280($1), $pop96
	i32.const	$push209=, 264
	i32.add 	$push210=, $1, $pop209
	i32.const	$push332=, 8
	i32.add 	$push97=, $pop210, $pop332
	i32.const	$push211=, 616
	i32.add 	$push212=, $1, $pop211
	i32.const	$push331=, 8
	i32.add 	$push98=, $pop212, $pop331
	i64.load	$push99=, 0($pop98)
	i64.store	0($pop97), $pop99
	i64.load	$push100=, 616($1)
	i64.store	264($1), $pop100
	i32.const	$push213=, 232
	i32.add 	$push214=, $1, $pop213
	i32.const	$push101=, 23
	i32.add 	$push102=, $pop214, $pop101
	i32.const	$push215=, 584
	i32.add 	$push216=, $1, $pop215
	i32.const	$push330=, 23
	i32.add 	$push103=, $pop216, $pop330
	i64.load	$push104=, 0($pop103):p2align=0
	i64.store	0($pop102):p2align=0, $pop104
	i32.const	$push217=, 232
	i32.add 	$push218=, $1, $pop217
	i32.const	$push105=, 16
	i32.add 	$push106=, $pop218, $pop105
	i32.const	$push219=, 584
	i32.add 	$push220=, $1, $pop219
	i32.const	$push329=, 16
	i32.add 	$push107=, $pop220, $pop329
	i64.load	$push108=, 0($pop107)
	i64.store	0($pop106), $pop108
	i32.const	$push221=, 232
	i32.add 	$push222=, $1, $pop221
	i32.const	$push328=, 8
	i32.add 	$push109=, $pop222, $pop328
	i32.const	$push223=, 584
	i32.add 	$push224=, $1, $pop223
	i32.const	$push327=, 8
	i32.add 	$push110=, $pop224, $pop327
	i64.load	$push111=, 0($pop110)
	i64.store	0($pop109), $pop111
	i64.load	$push112=, 584($1)
	i64.store	232($1), $pop112
	i32.const	$push225=, 200
	i32.add 	$push226=, $1, $pop225
	i32.const	$push113=, 24
	i32.add 	$push114=, $pop226, $pop113
	i32.const	$push227=, 552
	i32.add 	$push228=, $1, $pop227
	i32.const	$push326=, 24
	i32.add 	$push115=, $pop228, $pop326
	i64.load	$push116=, 0($pop115)
	i64.store	0($pop114), $pop116
	i32.const	$push229=, 200
	i32.add 	$push230=, $1, $pop229
	i32.const	$push325=, 16
	i32.add 	$push117=, $pop230, $pop325
	i32.const	$push231=, 552
	i32.add 	$push232=, $1, $pop231
	i32.const	$push324=, 16
	i32.add 	$push118=, $pop232, $pop324
	i64.load	$push119=, 0($pop118)
	i64.store	0($pop117), $pop119
	i32.const	$push233=, 200
	i32.add 	$push234=, $1, $pop233
	i32.const	$push323=, 8
	i32.add 	$push120=, $pop234, $pop323
	i32.const	$push235=, 552
	i32.add 	$push236=, $1, $pop235
	i32.const	$push322=, 8
	i32.add 	$push121=, $pop236, $pop322
	i64.load	$push122=, 0($pop121)
	i64.store	0($pop120), $pop122
	i64.load	$push123=, 552($1)
	i64.store	200($1), $pop123
	i32.const	$push237=, 160
	i32.add 	$push238=, $1, $pop237
	i32.const	$push124=, 34
	i32.add 	$push125=, $pop238, $pop124
	i32.const	$push239=, 512
	i32.add 	$push240=, $1, $pop239
	i32.const	$push321=, 34
	i32.add 	$push126=, $pop240, $pop321
	i32.load8_u	$push127=, 0($pop126)
	i32.store8	0($pop125), $pop127
	i32.const	$push241=, 160
	i32.add 	$push242=, $1, $pop241
	i32.const	$push128=, 32
	i32.add 	$push129=, $pop242, $pop128
	i32.const	$push243=, 512
	i32.add 	$push244=, $1, $pop243
	i32.const	$push320=, 32
	i32.add 	$push130=, $pop244, $pop320
	i32.load16_u	$push131=, 0($pop130)
	i32.store16	0($pop129), $pop131
	i32.const	$push245=, 160
	i32.add 	$push246=, $1, $pop245
	i32.const	$push319=, 24
	i32.add 	$push132=, $pop246, $pop319
	i32.const	$push247=, 512
	i32.add 	$push248=, $1, $pop247
	i32.const	$push318=, 24
	i32.add 	$push133=, $pop248, $pop318
	i64.load	$push134=, 0($pop133)
	i64.store	0($pop132), $pop134
	i32.const	$push249=, 160
	i32.add 	$push250=, $1, $pop249
	i32.const	$push317=, 16
	i32.add 	$push135=, $pop250, $pop317
	i32.const	$push251=, 512
	i32.add 	$push252=, $1, $pop251
	i32.const	$push316=, 16
	i32.add 	$push136=, $pop252, $pop316
	i64.load	$push137=, 0($pop136)
	i64.store	0($pop135), $pop137
	i32.const	$push253=, 160
	i32.add 	$push254=, $1, $pop253
	i32.const	$push315=, 8
	i32.add 	$push138=, $pop254, $pop315
	i32.const	$push255=, 512
	i32.add 	$push256=, $1, $pop255
	i32.const	$push314=, 8
	i32.add 	$push139=, $pop256, $pop314
	i64.load	$push140=, 0($pop139)
	i64.store	0($pop138), $pop140
	i64.load	$push141=, 512($1)
	i64.store	160($1), $pop141
	i32.const	$push257=, 88
	i32.add 	$push258=, $1, $pop257
	i32.const	$push259=, 440
	i32.add 	$push260=, $1, $pop259
	i32.const	$push142=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop258, $pop260, $pop142
	i32.const	$push143=, 76
	i32.add 	$push144=, $1, $pop143
	i32.const	$push261=, 88
	i32.add 	$push262=, $1, $pop261
	i32.store	0($pop144), $pop262
	i32.const	$push145=, 68
	i32.add 	$push146=, $1, $pop145
	i32.const	$push263=, 200
	i32.add 	$push264=, $1, $pop263
	i32.store	0($pop146), $pop264
	i32.const	$push147=, 64
	i32.add 	$push148=, $1, $pop147
	i32.const	$push265=, 232
	i32.add 	$push266=, $1, $pop265
	i32.store	0($pop148), $pop266
	i32.const	$push149=, 60
	i32.add 	$push150=, $1, $pop149
	i32.const	$push267=, 264
	i32.add 	$push268=, $1, $pop267
	i32.store	0($pop150), $pop268
	i32.const	$push151=, 56
	i32.add 	$push152=, $1, $pop151
	i32.const	$push269=, 280
	i32.add 	$push270=, $1, $pop269
	i32.store	0($pop152), $pop270
	i32.const	$push153=, 52
	i32.add 	$push154=, $1, $pop153
	i32.const	$push271=, 296
	i32.add 	$push272=, $1, $pop271
	i32.store	0($pop154), $pop272
	i32.const	$push155=, 48
	i32.add 	$push156=, $1, $pop155
	i32.const	$push273=, 312
	i32.add 	$push274=, $1, $pop273
	i32.store	0($pop156), $pop274
	i32.const	$push157=, 44
	i32.add 	$push158=, $1, $pop157
	i32.const	$push275=, 328
	i32.add 	$push276=, $1, $pop275
	i32.store	0($pop158), $pop276
	i32.const	$push159=, 40
	i32.add 	$push160=, $1, $pop159
	i32.const	$push277=, 344
	i32.add 	$push278=, $1, $pop277
	i32.store	0($pop160), $pop278
	i32.const	$push161=, 36
	i32.add 	$push162=, $1, $pop161
	i32.const	$push279=, 360
	i32.add 	$push280=, $1, $pop279
	i32.store	0($pop162), $pop280
	i32.const	$push313=, 32
	i32.add 	$push163=, $1, $pop313
	i32.const	$push281=, 376
	i32.add 	$push282=, $1, $pop281
	i32.store	0($pop163), $pop282
	i32.const	$push164=, 28
	i32.add 	$push165=, $1, $pop164
	i32.const	$push283=, 392
	i32.add 	$push284=, $1, $pop283
	i32.store	0($pop165), $pop284
	i32.const	$push312=, 24
	i32.add 	$push166=, $1, $pop312
	i32.const	$push285=, 404
	i32.add 	$push286=, $1, $pop285
	i32.store	0($pop166), $pop286
	i32.const	$push167=, 20
	i32.add 	$push168=, $1, $pop167
	i32.const	$push287=, 412
	i32.add 	$push288=, $1, $pop287
	i32.store	0($pop168), $pop288
	i32.const	$push311=, 16
	i32.add 	$push169=, $1, $pop311
	i32.const	$push289=, 420
	i32.add 	$push290=, $1, $pop289
	i32.store	0($pop169), $pop290
	i32.const	$push310=, 8
	i32.store	0($1), $pop310
	i32.const	$push309=, 72
	i32.add 	$push170=, $1, $pop309
	i32.const	$push291=, 160
	i32.add 	$push292=, $1, $pop291
	i32.store	0($pop170), $pop292
	i32.const	$push293=, 428
	i32.add 	$push294=, $1, $pop293
	i32.store	12($1), $pop294
	i32.const	$push295=, 434
	i32.add 	$push296=, $1, $pop295
	i32.store	8($1), $pop296
	i32.const	$push297=, 438
	i32.add 	$push298=, $1, $pop297
	i32.store	4($1), $pop298
	i32.const	$push171=, 21
	call    	foo@FUNCTION, $pop171, $1
	i32.const	$push172=, 0
	call    	exit@FUNCTION, $pop172
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
