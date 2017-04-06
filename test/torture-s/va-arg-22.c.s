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

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push510=, 0
	i32.const	$push508=, 0
	i32.load	$push507=, __stack_pointer($pop508)
	i32.const	$push509=, 352
	i32.sub 	$push581=, $pop507, $pop509
	tee_local	$push580=, $10=, $pop581
	i32.store	__stack_pointer($pop510), $pop580
	block   	
	i32.const	$push4=, 21
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %if.end
	i32.store	12($10), $1
	i32.const	$push6=, 4
	i32.add 	$push7=, $1, $pop6
	i32.store	12($10), $pop7
	i32.const	$push8=, 0
	i32.load	$0=, bar.lastc($pop8)
	i32.load8_s	$9=, 0($1)
	block   	
	i32.const	$push584=, 0
	i32.load	$push583=, bar.lastn($pop584)
	tee_local	$push582=, $3=, $pop583
	i32.const	$push9=, 1
	i32.eq  	$push10=, $pop582, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#2:                                 # %if.then.i
	i32.ne  	$push11=, $0, $3
	br_if   	1, $pop11       # 1: down to label2
# BB#3:                                 # %if.end.i
	i32.const	$0=, 0
	i32.const	$push587=, 0
	i32.const	$push12=, 1
	i32.store	bar.lastn($pop587), $pop12
	i32.const	$push586=, 0
	i32.const	$push585=, 0
	i32.store	bar.lastc($pop586), $pop585
.LBB1_4:                                # %if.end3.i
	end_block                       # label3:
	i32.const	$push13=, 24
	i32.shl 	$push14=, $0, $pop13
	i32.const	$push589=, 24
	i32.shr_s	$push15=, $pop14, $pop589
	i32.const	$push588=, 8
	i32.xor 	$push16=, $pop15, $pop588
	i32.ne  	$push17=, $pop16, $9
	br_if   	0, $pop17       # 0: down to label2
# BB#5:                                 # %if.then.i312
	i32.const	$push593=, 0
	i32.const	$push18=, 1
	i32.add 	$push19=, $0, $pop18
	i32.store	bar.lastc($pop593), $pop19
	i32.const	$push592=, 8
	i32.add 	$push591=, $1, $pop592
	tee_local	$push590=, $9=, $pop591
	i32.store	12($10), $pop590
	br_if   	0, $0           # 0: down to label2
# BB#6:                                 # %if.end3.i319
	i32.const	$push20=, 4
	i32.add 	$push21=, $1, $pop20
	i32.load16_u	$0=, 0($pop21):p2align=0
	i32.const	$push596=, 0
	i32.const	$push22=, 2
	i32.store	bar.lastn($pop596), $pop22
	i32.const	$push595=, 0
	i32.const	$push594=, 0
	i32.store	bar.lastc($pop595), $pop594
	i32.const	$push23=, 255
	i32.and 	$push24=, $0, $pop23
	i32.const	$push25=, 16
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label2
# BB#7:                                 # %if.end3.i319.1
	i32.const	$push597=, 0
	i32.const	$push27=, 1
	i32.store	bar.lastc($pop597), $pop27
	i32.const	$push28=, 65280
	i32.and 	$push29=, $0, $pop28
	i32.const	$push30=, 4352
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label2
# BB#8:                                 # %if.end3.i333
	i32.const	$push600=, 0
	i32.const	$push32=, 3
	i32.store	bar.lastn($pop600), $pop32
	i32.const	$push33=, 12
	i32.add 	$push34=, $1, $pop33
	i32.store	12($10), $pop34
	i32.load16_u	$push35=, 0($9):p2align=0
	i32.store16	344($10), $pop35
	i32.const	$push599=, 0
	i32.const	$push598=, 0
	i32.store	bar.lastc($pop599), $pop598
	i32.const	$push36=, 2
	i32.add 	$push37=, $9, $pop36
	i32.load8_u	$push38=, 0($pop37)
	i32.store8	346($10), $pop38
	i32.load8_u	$push40=, 344($10)
	i32.const	$push39=, 24
	i32.ne  	$push41=, $pop40, $pop39
	br_if   	0, $pop41       # 0: down to label2
# BB#9:                                 # %if.end3.i333.1
	i32.const	$push601=, 0
	i32.const	$push42=, 1
	i32.store	bar.lastc($pop601), $pop42
	i32.load8_u	$push44=, 345($10)
	i32.const	$push43=, 25
	i32.ne  	$push45=, $pop44, $pop43
	br_if   	0, $pop45       # 0: down to label2
# BB#10:                                # %if.end3.i333.2
	i32.const	$push602=, 0
	i32.const	$push46=, 2
	i32.store	bar.lastc($pop602), $pop46
	i32.load8_u	$push48=, 346($10)
	i32.const	$push47=, 26
	i32.ne  	$push49=, $pop48, $pop47
	br_if   	0, $pop49       # 0: down to label2
# BB#11:                                # %if.end3.i347
	i32.const	$push50=, 16
	i32.add 	$push607=, $1, $pop50
	tee_local	$push606=, $9=, $pop607
	i32.store	12($10), $pop606
	i32.const	$push51=, 12
	i32.add 	$push52=, $1, $pop51
	i32.load	$0=, 0($pop52):p2align=0
	i32.const	$push605=, 0
	i32.const	$push53=, 4
	i32.store	bar.lastn($pop605), $pop53
	i32.const	$push604=, 0
	i32.const	$push603=, 0
	i32.store	bar.lastc($pop604), $pop603
	i32.const	$push54=, 255
	i32.and 	$push55=, $0, $pop54
	i32.const	$push56=, 32
	i32.ne  	$push57=, $pop55, $pop56
	br_if   	0, $pop57       # 0: down to label2
# BB#12:                                # %if.end3.i347.1
	i32.const	$push608=, 0
	i32.const	$push58=, 1
	i32.store	bar.lastc($pop608), $pop58
	i32.const	$push59=, 65280
	i32.and 	$push60=, $0, $pop59
	i32.const	$push61=, 8448
	i32.ne  	$push62=, $pop60, $pop61
	br_if   	0, $pop62       # 0: down to label2
# BB#13:                                # %if.end3.i347.2
	i32.const	$push609=, 0
	i32.const	$push63=, 2
	i32.store	bar.lastc($pop609), $pop63
	i32.const	$push64=, 16711680
	i32.and 	$push65=, $0, $pop64
	i32.const	$push66=, 2228224
	i32.ne  	$push67=, $pop65, $pop66
	br_if   	0, $pop67       # 0: down to label2
# BB#14:                                # %if.end3.i347.3
	i32.const	$push610=, 0
	i32.const	$push68=, 3
	i32.store	bar.lastc($pop610), $pop68
	i32.const	$push69=, -16777216
	i32.and 	$push70=, $0, $pop69
	i32.const	$push71=, 587202560
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label2
# BB#15:                                # %if.end3.i361
	i32.const	$push615=, 0
	i32.const	$push73=, 5
	i32.store	bar.lastn($pop615), $pop73
	i32.const	$push74=, 24
	i32.add 	$push614=, $1, $pop74
	tee_local	$push613=, $3=, $pop614
	i32.store	12($10), $pop613
	i32.load	$push75=, 0($9):p2align=0
	i32.store	336($10), $pop75
	i32.const	$push612=, 0
	i32.const	$push611=, 0
	i32.store	bar.lastc($pop612), $pop611
	i32.const	$push76=, 4
	i32.add 	$push77=, $9, $pop76
	i32.load8_u	$push78=, 0($pop77)
	i32.store8	340($10), $pop78
	i32.load8_u	$push80=, 336($10)
	i32.const	$push79=, 40
	i32.ne  	$push81=, $pop80, $pop79
	br_if   	0, $pop81       # 0: down to label2
# BB#16:                                # %if.end3.i361.1
	i32.const	$push616=, 0
	i32.const	$push82=, 1
	i32.store	bar.lastc($pop616), $pop82
	i32.load8_u	$push84=, 337($10)
	i32.const	$push83=, 41
	i32.ne  	$push85=, $pop84, $pop83
	br_if   	0, $pop85       # 0: down to label2
# BB#17:                                # %if.end3.i361.2
	i32.const	$push617=, 0
	i32.const	$push86=, 2
	i32.store	bar.lastc($pop617), $pop86
	i32.load8_u	$push88=, 338($10)
	i32.const	$push87=, 42
	i32.ne  	$push89=, $pop88, $pop87
	br_if   	0, $pop89       # 0: down to label2
# BB#18:                                # %if.end3.i361.3
	i32.const	$push618=, 0
	i32.const	$push90=, 3
	i32.store	bar.lastc($pop618), $pop90
	i32.load8_u	$push92=, 339($10)
	i32.const	$push91=, 43
	i32.ne  	$push93=, $pop92, $pop91
	br_if   	0, $pop93       # 0: down to label2
# BB#19:                                # %if.end3.i361.4
	i32.const	$push620=, 0
	i32.const	$push619=, 4
	i32.store	bar.lastc($pop620), $pop619
	i32.load8_u	$push95=, 340($10)
	i32.const	$push94=, 44
	i32.ne  	$push96=, $pop95, $pop94
	br_if   	0, $pop96       # 0: down to label2
# BB#20:                                # %if.end3.i375
	i32.const	$push626=, 0
	i32.const	$push97=, 6
	i32.store	bar.lastn($pop626), $pop97
	i32.const	$push98=, 32
	i32.add 	$push625=, $1, $pop98
	tee_local	$push624=, $0=, $pop625
	i32.store	12($10), $pop624
	i32.load	$push99=, 0($3):p2align=0
	i32.store	328($10), $pop99
	i32.const	$push623=, 0
	i32.const	$push622=, 0
	i32.store	bar.lastc($pop623), $pop622
	i32.const	$push621=, 4
	i32.add 	$push100=, $3, $pop621
	i32.load16_u	$push101=, 0($pop100):p2align=0
	i32.store16	332($10), $pop101
	i32.load8_u	$push103=, 328($10)
	i32.const	$push102=, 48
	i32.ne  	$push104=, $pop103, $pop102
	br_if   	0, $pop104      # 0: down to label2
# BB#21:                                # %if.end3.i375.1
	i32.const	$push627=, 0
	i32.const	$push105=, 1
	i32.store	bar.lastc($pop627), $pop105
	i32.load8_u	$push107=, 329($10)
	i32.const	$push106=, 49
	i32.ne  	$push108=, $pop107, $pop106
	br_if   	0, $pop108      # 0: down to label2
# BB#22:                                # %if.end3.i375.2
	i32.const	$push628=, 0
	i32.const	$push109=, 2
	i32.store	bar.lastc($pop628), $pop109
	i32.load8_u	$push111=, 330($10)
	i32.const	$push110=, 50
	i32.ne  	$push112=, $pop111, $pop110
	br_if   	0, $pop112      # 0: down to label2
# BB#23:                                # %if.end3.i375.3
	i32.const	$push629=, 0
	i32.const	$push113=, 3
	i32.store	bar.lastc($pop629), $pop113
	i32.load8_u	$push115=, 331($10)
	i32.const	$push114=, 51
	i32.ne  	$push116=, $pop115, $pop114
	br_if   	0, $pop116      # 0: down to label2
# BB#24:                                # %if.end3.i375.4
	i32.const	$push630=, 0
	i32.const	$push117=, 4
	i32.store	bar.lastc($pop630), $pop117
	i32.load8_u	$push119=, 332($10)
	i32.const	$push118=, 52
	i32.ne  	$push120=, $pop119, $pop118
	br_if   	0, $pop120      # 0: down to label2
# BB#25:                                # %if.end3.i375.5
	i32.const	$push631=, 0
	i32.const	$push121=, 5
	i32.store	bar.lastc($pop631), $pop121
	i32.load8_u	$push123=, 333($10)
	i32.const	$push122=, 53
	i32.ne  	$push124=, $pop123, $pop122
	br_if   	0, $pop124      # 0: down to label2
# BB#26:                                # %if.end3.i389
	i32.const	$push634=, 0
	i32.const	$push125=, 7
	i32.store	bar.lastn($pop634), $pop125
	i32.const	$push126=, 40
	i32.add 	$push127=, $1, $pop126
	i32.store	12($10), $pop127
	i32.load	$push128=, 0($0):p2align=0
	i32.store	320($10), $pop128
	i32.const	$push633=, 0
	i32.const	$push632=, 0
	i32.store	bar.lastc($pop633), $pop632
	i32.const	$push129=, 6
	i32.add 	$push130=, $0, $pop129
	i32.load8_u	$push131=, 0($pop130)
	i32.store8	326($10), $pop131
	i32.const	$push132=, 4
	i32.add 	$push133=, $0, $pop132
	i32.load16_u	$push134=, 0($pop133):p2align=0
	i32.store16	324($10), $pop134
	i32.load8_u	$push136=, 320($10)
	i32.const	$push135=, 56
	i32.ne  	$push137=, $pop136, $pop135
	br_if   	0, $pop137      # 0: down to label2
# BB#27:                                # %if.end3.i389.1
	i32.const	$push635=, 0
	i32.const	$push138=, 1
	i32.store	bar.lastc($pop635), $pop138
	i32.load8_u	$push140=, 321($10)
	i32.const	$push139=, 57
	i32.ne  	$push141=, $pop140, $pop139
	br_if   	0, $pop141      # 0: down to label2
# BB#28:                                # %if.end3.i389.2
	i32.const	$push636=, 0
	i32.const	$push142=, 2
	i32.store	bar.lastc($pop636), $pop142
	i32.load8_u	$push144=, 322($10)
	i32.const	$push143=, 58
	i32.ne  	$push145=, $pop144, $pop143
	br_if   	0, $pop145      # 0: down to label2
# BB#29:                                # %if.end3.i389.3
	i32.const	$push637=, 0
	i32.const	$push146=, 3
	i32.store	bar.lastc($pop637), $pop146
	i32.load8_u	$push148=, 323($10)
	i32.const	$push147=, 59
	i32.ne  	$push149=, $pop148, $pop147
	br_if   	0, $pop149      # 0: down to label2
# BB#30:                                # %if.end3.i389.4
	i32.const	$push638=, 0
	i32.const	$push150=, 4
	i32.store	bar.lastc($pop638), $pop150
	i32.load8_u	$push152=, 324($10)
	i32.const	$push151=, 60
	i32.ne  	$push153=, $pop152, $pop151
	br_if   	0, $pop153      # 0: down to label2
# BB#31:                                # %if.end3.i389.5
	i32.const	$push639=, 0
	i32.const	$push154=, 5
	i32.store	bar.lastc($pop639), $pop154
	i32.load8_u	$push156=, 325($10)
	i32.const	$push155=, 61
	i32.ne  	$push157=, $pop156, $pop155
	br_if   	0, $pop157      # 0: down to label2
# BB#32:                                # %if.end3.i389.6
	i32.const	$push640=, 0
	i32.const	$push158=, 6
	i32.store	bar.lastc($pop640), $pop158
	i32.load8_u	$push160=, 326($10)
	i32.const	$push159=, 62
	i32.ne  	$push161=, $pop160, $pop159
	br_if   	0, $pop161      # 0: down to label2
# BB#33:                                # %if.end3.i403
	i32.const	$push647=, 0
	i32.const	$push162=, 8
	i32.store	bar.lastn($pop647), $pop162
	i32.const	$push646=, 0
	i32.const	$push645=, 0
	i32.store	bar.lastc($pop646), $pop645
	i32.const	$push163=, 48
	i32.add 	$push644=, $1, $pop163
	tee_local	$push643=, $0=, $pop644
	i32.store	12($10), $pop643
	i32.const	$push164=, 40
	i32.add 	$push165=, $1, $pop164
	i64.load	$push642=, 0($pop165):p2align=0
	tee_local	$push641=, $2=, $pop642
	i64.const	$push170=, 255
	i64.and 	$push171=, $pop641, $pop170
	i64.const	$push172=, 64
	i64.ne  	$push173=, $pop171, $pop172
	br_if   	0, $pop173      # 0: down to label2
# BB#34:                                # %if.end3.i403.1
	i32.const	$push648=, 0
	i32.const	$push174=, 1
	i32.store	bar.lastc($pop648), $pop174
	i32.wrap/i64	$push175=, $2
	i32.const	$push176=, 16
	i32.shl 	$push177=, $pop175, $pop176
	i32.const	$push178=, -16777216
	i32.and 	$push179=, $pop177, $pop178
	i32.const	$push180=, 1090519040
	i32.ne  	$push181=, $pop179, $pop180
	br_if   	0, $pop181      # 0: down to label2
# BB#35:                                # %if.end3.i403.2
	i32.const	$push649=, 0
	i32.const	$push182=, 2
	i32.store	bar.lastc($pop649), $pop182
	i64.const	$push169=, 16
	i64.shr_u	$push0=, $2, $pop169
	i32.wrap/i64	$push183=, $pop0
	i32.const	$push184=, 24
	i32.shl 	$push185=, $pop183, $pop184
	i32.const	$push186=, 1107296256
	i32.ne  	$push187=, $pop185, $pop186
	br_if   	0, $pop187      # 0: down to label2
# BB#36:                                # %if.end3.i403.3
	i32.const	$push650=, 0
	i32.const	$push188=, 3
	i32.store	bar.lastc($pop650), $pop188
	i64.const	$push189=, 4278190080
	i64.and 	$push190=, $2, $pop189
	i64.const	$push191=, 1124073472
	i64.ne  	$push192=, $pop190, $pop191
	br_if   	0, $pop192      # 0: down to label2
# BB#37:                                # %if.end3.i403.4
	i32.const	$push652=, 0
	i32.const	$push193=, 4
	i32.store	bar.lastc($pop652), $pop193
	i64.const	$push168=, 32
	i64.shr_u	$push1=, $2, $pop168
	i32.wrap/i64	$push194=, $pop1
	i32.const	$push651=, 24
	i32.shl 	$push195=, $pop194, $pop651
	i32.const	$push196=, 1140850688
	i32.ne  	$push197=, $pop195, $pop196
	br_if   	0, $pop197      # 0: down to label2
# BB#38:                                # %if.end3.i403.5
	i32.const	$push654=, 0
	i32.const	$push198=, 5
	i32.store	bar.lastc($pop654), $pop198
	i64.const	$push167=, 40
	i64.shr_u	$push2=, $2, $pop167
	i32.wrap/i64	$push199=, $pop2
	i32.const	$push653=, 24
	i32.shl 	$push200=, $pop199, $pop653
	i32.const	$push201=, 1157627904
	i32.ne  	$push202=, $pop200, $pop201
	br_if   	0, $pop202      # 0: down to label2
# BB#39:                                # %if.end3.i403.6
	i32.const	$push655=, 0
	i32.const	$push203=, 6
	i32.store	bar.lastc($pop655), $pop203
	i64.const	$push166=, 48
	i64.shr_u	$push3=, $2, $pop166
	i32.wrap/i64	$push204=, $pop3
	i32.const	$push205=, 24
	i32.shl 	$push206=, $pop204, $pop205
	i32.const	$push207=, 1174405120
	i32.ne  	$push208=, $pop206, $pop207
	br_if   	0, $pop208      # 0: down to label2
# BB#40:                                # %if.end3.i403.7
	i32.const	$push656=, 0
	i32.const	$push209=, 7
	i32.store	bar.lastc($pop656), $pop209
	i64.const	$push210=, -72057594037927936
	i64.and 	$push211=, $2, $pop210
	i64.const	$push212=, 5116089176692883456
	i64.ne  	$push213=, $pop211, $pop212
	br_if   	0, $pop213      # 0: down to label2
# BB#41:                                # %if.end3.i417
	i32.const	$push662=, 0
	i32.const	$push214=, 9
	i32.store	bar.lastn($pop662), $pop214
	i32.const	$push514=, 304
	i32.add 	$push515=, $10, $pop514
	i32.const	$push215=, 8
	i32.add 	$push218=, $pop515, $pop215
	i32.const	$push661=, 8
	i32.add 	$push216=, $0, $pop661
	i32.load8_u	$push217=, 0($pop216)
	i32.store8	0($pop218), $pop217
	i32.const	$push219=, 60
	i32.add 	$push660=, $1, $pop219
	tee_local	$push659=, $3=, $pop660
	i32.store	12($10), $pop659
	i32.load	$push220=, 0($0):p2align=0
	i32.store	304($10), $pop220
	i32.const	$push658=, 0
	i32.const	$push657=, 0
	i32.store	bar.lastc($pop658), $pop657
	i32.const	$push221=, 4
	i32.add 	$push222=, $0, $pop221
	i32.load	$push223=, 0($pop222):p2align=0
	i32.store	308($10), $pop223
	i32.load8_u	$push225=, 304($10)
	i32.const	$push224=, 72
	i32.ne  	$push226=, $pop225, $pop224
	br_if   	0, $pop226      # 0: down to label2
# BB#42:                                # %if.end3.i417.1
	i32.const	$push663=, 0
	i32.const	$push227=, 1
	i32.store	bar.lastc($pop663), $pop227
	i32.load8_u	$push229=, 305($10)
	i32.const	$push228=, 73
	i32.ne  	$push230=, $pop229, $pop228
	br_if   	0, $pop230      # 0: down to label2
# BB#43:                                # %if.end3.i417.2
	i32.const	$push664=, 0
	i32.const	$push231=, 2
	i32.store	bar.lastc($pop664), $pop231
	i32.load8_u	$push233=, 306($10)
	i32.const	$push232=, 74
	i32.ne  	$push234=, $pop233, $pop232
	br_if   	0, $pop234      # 0: down to label2
# BB#44:                                # %if.end3.i417.3
	i32.const	$push665=, 0
	i32.const	$push235=, 3
	i32.store	bar.lastc($pop665), $pop235
	i32.load8_u	$push237=, 307($10)
	i32.const	$push236=, 75
	i32.ne  	$push238=, $pop237, $pop236
	br_if   	0, $pop238      # 0: down to label2
# BB#45:                                # %if.end3.i417.4
	i32.const	$push666=, 0
	i32.const	$push239=, 4
	i32.store	bar.lastc($pop666), $pop239
	i32.load8_u	$push241=, 308($10)
	i32.const	$push240=, 76
	i32.ne  	$push242=, $pop241, $pop240
	br_if   	0, $pop242      # 0: down to label2
# BB#46:                                # %if.end3.i417.5
	i32.const	$push667=, 0
	i32.const	$push243=, 5
	i32.store	bar.lastc($pop667), $pop243
	i32.load8_u	$push245=, 309($10)
	i32.const	$push244=, 77
	i32.ne  	$push246=, $pop245, $pop244
	br_if   	0, $pop246      # 0: down to label2
# BB#47:                                # %if.end3.i417.6
	i32.const	$push668=, 0
	i32.const	$push247=, 6
	i32.store	bar.lastc($pop668), $pop247
	i32.load8_u	$push249=, 310($10)
	i32.const	$push248=, 78
	i32.ne  	$push250=, $pop249, $pop248
	br_if   	0, $pop250      # 0: down to label2
# BB#48:                                # %if.end3.i417.7
	i32.const	$push669=, 0
	i32.const	$push251=, 7
	i32.store	bar.lastc($pop669), $pop251
	i32.load8_u	$push253=, 311($10)
	i32.const	$push252=, 79
	i32.ne  	$push254=, $pop253, $pop252
	br_if   	0, $pop254      # 0: down to label2
# BB#49:                                # %if.end3.i417.8
	i32.const	$push671=, 0
	i32.const	$push670=, 8
	i32.store	bar.lastc($pop671), $pop670
	i32.load8_u	$push256=, 312($10)
	i32.const	$push255=, 64
	i32.ne  	$push257=, $pop256, $pop255
	br_if   	0, $pop257      # 0: down to label2
# BB#50:                                # %if.end3.i431
	i32.const	$push679=, 0
	i32.const	$push258=, 9
	i32.store	bar.lastc($pop679), $pop258
	i32.const	$push678=, 0
	i32.const	$push259=, 10
	i32.store	bar.lastn($pop678), $pop259
	i32.const	$push516=, 288
	i32.add 	$push517=, $10, $pop516
	i32.const	$push677=, 8
	i32.add 	$push262=, $pop517, $pop677
	i32.const	$push676=, 8
	i32.add 	$push260=, $3, $pop676
	i32.load16_u	$push261=, 0($pop260):p2align=0
	i32.store16	0($pop262), $pop261
	i32.const	$push263=, 72
	i32.add 	$push675=, $1, $pop263
	tee_local	$push674=, $9=, $pop675
	i32.store	12($10), $pop674
	i32.load	$push264=, 0($3):p2align=0
	i32.store	288($10), $pop264
	i32.const	$push673=, 0
	i32.const	$push672=, 0
	i32.store	bar.lastc($pop673), $pop672
	i32.const	$push265=, 4
	i32.add 	$push266=, $3, $pop265
	i32.load	$push267=, 0($pop266):p2align=0
	i32.store	292($10), $pop267
	i32.load8_s	$push269=, 288($10)
	i32.const	$push268=, 80
	i32.ne  	$push270=, $pop269, $pop268
	br_if   	0, $pop270      # 0: down to label2
# BB#51:                                # %if.end3.i431.1
	i32.const	$push681=, 0
	i32.const	$push680=, 1
	i32.store	bar.lastc($pop681), $pop680
	i32.load8_s	$push272=, 289($10)
	i32.const	$push271=, 81
	i32.ne  	$push273=, $pop272, $pop271
	br_if   	0, $pop273      # 0: down to label2
# BB#52:                                # %if.end3.i431.2
	i32.const	$push687=, 0
	i32.const	$push686=, 1
	i32.const	$push685=, 1
	i32.add 	$push684=, $pop686, $pop685
	tee_local	$push683=, $0=, $pop684
	i32.store	bar.lastc($pop687), $pop683
	i32.const	$push682=, 80
	i32.or  	$push274=, $0, $pop682
	i32.load8_s	$push275=, 290($10)
	i32.ne  	$push276=, $pop274, $pop275
	br_if   	0, $pop276      # 0: down to label2
# BB#53:                                # %if.end3.i431.3
	i32.const	$push694=, 0
	i32.const	$push693=, 1
	i32.add 	$push692=, $0, $pop693
	tee_local	$push691=, $0=, $pop692
	i32.store	bar.lastc($pop694), $pop691
	i32.const	$push690=, 24
	i32.shl 	$push277=, $0, $pop690
	i32.const	$push689=, 24
	i32.shr_s	$push278=, $pop277, $pop689
	i32.const	$push688=, 80
	i32.xor 	$push279=, $pop278, $pop688
	i32.load8_s	$push280=, 291($10)
	i32.ne  	$push281=, $pop279, $pop280
	br_if   	0, $pop281      # 0: down to label2
# BB#54:                                # %if.end3.i431.4
	i32.const	$push701=, 0
	i32.const	$push700=, 1
	i32.add 	$push699=, $0, $pop700
	tee_local	$push698=, $0=, $pop699
	i32.store	bar.lastc($pop701), $pop698
	i32.const	$push697=, 24
	i32.shl 	$push282=, $0, $pop697
	i32.const	$push696=, 24
	i32.shr_s	$push283=, $pop282, $pop696
	i32.const	$push695=, 80
	i32.xor 	$push284=, $pop283, $pop695
	i32.load8_s	$push285=, 292($10)
	i32.ne  	$push286=, $pop284, $pop285
	br_if   	0, $pop286      # 0: down to label2
# BB#55:                                # %if.end3.i431.5
	i32.const	$push708=, 0
	i32.const	$push707=, 1
	i32.add 	$push706=, $0, $pop707
	tee_local	$push705=, $0=, $pop706
	i32.store	bar.lastc($pop708), $pop705
	i32.const	$push704=, 24
	i32.shl 	$push287=, $0, $pop704
	i32.const	$push703=, 24
	i32.shr_s	$push288=, $pop287, $pop703
	i32.const	$push702=, 80
	i32.xor 	$push289=, $pop288, $pop702
	i32.load8_s	$push290=, 293($10)
	i32.ne  	$push291=, $pop289, $pop290
	br_if   	0, $pop291      # 0: down to label2
# BB#56:                                # %if.end3.i431.6
	i32.const	$push715=, 0
	i32.const	$push714=, 1
	i32.add 	$push713=, $0, $pop714
	tee_local	$push712=, $0=, $pop713
	i32.store	bar.lastc($pop715), $pop712
	i32.const	$push711=, 24
	i32.shl 	$push292=, $0, $pop711
	i32.const	$push710=, 24
	i32.shr_s	$push293=, $pop292, $pop710
	i32.const	$push709=, 80
	i32.xor 	$push294=, $pop293, $pop709
	i32.load8_s	$push295=, 294($10)
	i32.ne  	$push296=, $pop294, $pop295
	br_if   	0, $pop296      # 0: down to label2
# BB#57:                                # %if.end3.i431.7
	i32.const	$push722=, 0
	i32.const	$push721=, 1
	i32.add 	$push720=, $0, $pop721
	tee_local	$push719=, $0=, $pop720
	i32.store	bar.lastc($pop722), $pop719
	i32.const	$push718=, 24
	i32.shl 	$push297=, $0, $pop718
	i32.const	$push717=, 24
	i32.shr_s	$push298=, $pop297, $pop717
	i32.const	$push716=, 80
	i32.xor 	$push299=, $pop298, $pop716
	i32.load8_s	$push300=, 295($10)
	i32.ne  	$push301=, $pop299, $pop300
	br_if   	0, $pop301      # 0: down to label2
# BB#58:                                # %if.end3.i431.8
	i32.const	$push729=, 0
	i32.const	$push728=, 1
	i32.add 	$push727=, $0, $pop728
	tee_local	$push726=, $0=, $pop727
	i32.store	bar.lastc($pop729), $pop726
	i32.const	$push725=, 24
	i32.shl 	$push302=, $0, $pop725
	i32.const	$push724=, 24
	i32.shr_s	$push303=, $pop302, $pop724
	i32.const	$push723=, 80
	i32.xor 	$push304=, $pop303, $pop723
	i32.load8_s	$push305=, 296($10)
	i32.ne  	$push306=, $pop304, $pop305
	br_if   	0, $pop306      # 0: down to label2
# BB#59:                                # %if.end3.i431.9
	i32.const	$push736=, 0
	i32.const	$push735=, 1
	i32.add 	$push734=, $0, $pop735
	tee_local	$push733=, $0=, $pop734
	i32.store	bar.lastc($pop736), $pop733
	i32.const	$push732=, 24
	i32.shl 	$push307=, $0, $pop732
	i32.const	$push731=, 24
	i32.shr_s	$push308=, $pop307, $pop731
	i32.const	$push730=, 80
	i32.xor 	$push309=, $pop308, $pop730
	i32.load8_s	$push310=, 297($10)
	i32.ne  	$push311=, $pop309, $pop310
	br_if   	0, $pop311      # 0: down to label2
# BB#60:                                # %bar.exit434.9
	i32.const	$push745=, 0
	i32.const	$push744=, 1
	i32.add 	$push743=, $0, $pop744
	tee_local	$push742=, $0=, $pop743
	i32.store	bar.lastc($pop745), $pop742
	i32.const	$push518=, 272
	i32.add 	$push519=, $10, $pop518
	i32.const	$push741=, 10
	i32.add 	$push314=, $pop519, $pop741
	i32.const	$push740=, 10
	i32.add 	$push312=, $9, $pop740
	i32.load8_u	$push313=, 0($pop312)
	i32.store8	0($pop314), $pop313
	i32.const	$push520=, 272
	i32.add 	$push521=, $10, $pop520
	i32.const	$push315=, 8
	i32.add 	$push318=, $pop521, $pop315
	i32.const	$push739=, 8
	i32.add 	$push316=, $9, $pop739
	i32.load16_u	$push317=, 0($pop316):p2align=0
	i32.store16	0($pop318), $pop317
	i32.const	$push319=, 84
	i32.add 	$push738=, $1, $pop319
	tee_local	$push737=, $5=, $pop738
	i32.store	12($10), $pop737
	i32.const	$push320=, 4
	i32.add 	$push321=, $9, $pop320
	i32.load	$push322=, 0($pop321):p2align=0
	i32.store	276($10), $pop322
	i32.load	$push323=, 0($9):p2align=0
	i32.store	272($10), $pop323
	i32.const	$3=, -1
	i32.const	$9=, 10
	i32.const	$8=, 10
.LBB1_61:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push522=, 272
	i32.add 	$push523=, $10, $pop522
	i32.add 	$push325=, $pop523, $3
	i32.const	$push747=, 1
	i32.add 	$push326=, $pop325, $pop747
	i32.load8_s	$4=, 0($pop326)
	block   	
	i32.const	$push746=, 11
	i32.eq  	$push324=, $8, $pop746
	br_if   	0, $pop324      # 0: down to label5
# BB#62:                                # %if.then.i438
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.ne  	$push327=, $0, $8
	br_if   	2, $pop327      # 2: down to label2
# BB#63:                                # %if.end.i440
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.const	$9=, 11
	i32.const	$0=, 0
	i32.const	$push751=, 0
	i32.const	$push750=, 11
	i32.store	bar.lastn($pop751), $pop750
	i32.const	$push749=, 0
	i32.const	$push748=, 0
	i32.store	bar.lastc($pop749), $pop748
.LBB1_64:                               # %if.end3.i445
                                        #   in Loop: Header=BB1_61 Depth=1
	end_block                       # label5:
	i32.const	$push754=, 24
	i32.shl 	$push328=, $0, $pop754
	i32.const	$push753=, 24
	i32.shr_s	$push329=, $pop328, $pop753
	i32.const	$push752=, 88
	i32.xor 	$push330=, $pop329, $pop752
	i32.ne  	$push331=, $pop330, $4
	br_if   	1, $pop331      # 1: down to label2
# BB#65:                                # %bar.exit448
                                        #   in Loop: Header=BB1_61 Depth=1
	i32.const	$push762=, 0
	i32.const	$push761=, 1
	i32.add 	$push760=, $0, $pop761
	tee_local	$push759=, $0=, $pop760
	i32.store	bar.lastc($pop762), $pop759
	i32.const	$8=, 11
	i32.const	$push758=, 1
	i32.add 	$push757=, $3, $pop758
	tee_local	$push756=, $3=, $pop757
	i32.const	$push755=, 10
	i32.lt_s	$push332=, $pop756, $pop755
	br_if   	0, $pop332      # 0: up to label4
# BB#66:                                # %for.end134
	end_loop
	i32.const	$push524=, 256
	i32.add 	$push525=, $10, $pop524
	i32.const	$push333=, 8
	i32.add 	$push336=, $pop525, $pop333
	i32.const	$push766=, 8
	i32.add 	$push334=, $5, $pop766
	i32.load	$push335=, 0($pop334):p2align=0
	i32.store	0($pop336), $pop335
	i32.const	$push765=, 96
	i32.add 	$push764=, $1, $pop765
	tee_local	$push763=, $7=, $pop764
	i32.store	12($10), $pop763
	i32.const	$push337=, 4
	i32.add 	$push338=, $5, $pop337
	i32.load	$push339=, 0($pop338):p2align=0
	i32.store	260($10), $pop339
	i32.load	$push340=, 0($5):p2align=0
	i32.store	256($10), $pop340
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_67:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push526=, 256
	i32.add 	$push527=, $10, $pop526
	i32.add 	$push342=, $pop527, $3
	i32.const	$push768=, 1
	i32.add 	$push343=, $pop342, $pop768
	i32.load8_s	$4=, 0($pop343)
	block   	
	i32.const	$push767=, 12
	i32.eq  	$push341=, $8, $pop767
	br_if   	0, $pop341      # 0: down to label7
# BB#68:                                # %if.then.i452
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.ne  	$push344=, $0, $8
	br_if   	2, $pop344      # 2: down to label2
# BB#69:                                # %if.end.i454
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$9=, 12
	i32.const	$0=, 0
	i32.const	$push772=, 0
	i32.const	$push771=, 12
	i32.store	bar.lastn($pop772), $pop771
	i32.const	$push770=, 0
	i32.const	$push769=, 0
	i32.store	bar.lastc($pop770), $pop769
.LBB1_70:                               # %if.end3.i459
                                        #   in Loop: Header=BB1_67 Depth=1
	end_block                       # label7:
	i32.const	$push775=, 24
	i32.shl 	$push345=, $0, $pop775
	i32.const	$push774=, 24
	i32.shr_s	$push346=, $pop345, $pop774
	i32.const	$push773=, 96
	i32.xor 	$push347=, $pop346, $pop773
	i32.ne  	$push348=, $pop347, $4
	br_if   	1, $pop348      # 1: down to label2
# BB#71:                                # %bar.exit462
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$push783=, 0
	i32.const	$push782=, 1
	i32.add 	$push781=, $0, $pop782
	tee_local	$push780=, $0=, $pop781
	i32.store	bar.lastc($pop783), $pop780
	i32.const	$8=, 12
	i32.const	$push779=, 1
	i32.add 	$push778=, $3, $pop779
	tee_local	$push777=, $3=, $pop778
	i32.const	$push776=, 11
	i32.lt_s	$push349=, $pop777, $pop776
	br_if   	0, $pop349      # 0: up to label6
# BB#72:                                # %for.end146
	end_loop
	i32.const	$push528=, 240
	i32.add 	$push529=, $10, $pop528
	i32.const	$push788=, 12
	i32.add 	$push352=, $pop529, $pop788
	i32.const	$push787=, 12
	i32.add 	$push350=, $7, $pop787
	i32.load8_u	$push351=, 0($pop350)
	i32.store8	0($pop352), $pop351
	i32.const	$push530=, 240
	i32.add 	$push531=, $10, $pop530
	i32.const	$push353=, 8
	i32.add 	$push356=, $pop531, $pop353
	i32.const	$push786=, 8
	i32.add 	$push354=, $7, $pop786
	i32.load	$push355=, 0($pop354):p2align=0
	i32.store	0($pop356), $pop355
	i32.const	$push357=, 112
	i32.add 	$push785=, $1, $pop357
	tee_local	$push784=, $5=, $pop785
	i32.store	12($10), $pop784
	i32.const	$push358=, 4
	i32.add 	$push359=, $7, $pop358
	i32.load	$push360=, 0($pop359):p2align=0
	i32.store	244($10), $pop360
	i32.load	$push361=, 0($7):p2align=0
	i32.store	240($10), $pop361
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_73:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push532=, 240
	i32.add 	$push533=, $10, $pop532
	i32.add 	$push363=, $pop533, $3
	i32.const	$push790=, 1
	i32.add 	$push364=, $pop363, $pop790
	i32.load8_s	$4=, 0($pop364)
	block   	
	i32.const	$push789=, 13
	i32.eq  	$push362=, $8, $pop789
	br_if   	0, $pop362      # 0: down to label9
# BB#74:                                # %if.then.i466
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.ne  	$push365=, $0, $8
	br_if   	2, $pop365      # 2: down to label2
# BB#75:                                # %if.end.i468
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$9=, 13
	i32.const	$0=, 0
	i32.const	$push794=, 0
	i32.const	$push793=, 13
	i32.store	bar.lastn($pop794), $pop793
	i32.const	$push792=, 0
	i32.const	$push791=, 0
	i32.store	bar.lastc($pop792), $pop791
.LBB1_76:                               # %if.end3.i473
                                        #   in Loop: Header=BB1_73 Depth=1
	end_block                       # label9:
	i32.const	$push797=, 24
	i32.shl 	$push366=, $0, $pop797
	i32.const	$push796=, 24
	i32.shr_s	$push367=, $pop366, $pop796
	i32.const	$push795=, 104
	i32.xor 	$push368=, $pop367, $pop795
	i32.ne  	$push369=, $pop368, $4
	br_if   	1, $pop369      # 1: down to label2
# BB#77:                                # %bar.exit476
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$push805=, 0
	i32.const	$push804=, 1
	i32.add 	$push803=, $0, $pop804
	tee_local	$push802=, $0=, $pop803
	i32.store	bar.lastc($pop805), $pop802
	i32.const	$8=, 13
	i32.const	$push801=, 1
	i32.add 	$push800=, $3, $pop801
	tee_local	$push799=, $3=, $pop800
	i32.const	$push798=, 12
	i32.lt_s	$push370=, $pop799, $pop798
	br_if   	0, $pop370      # 0: up to label8
# BB#78:                                # %for.end158
	end_loop
	i32.const	$push534=, 224
	i32.add 	$push535=, $10, $pop534
	i32.const	$push371=, 12
	i32.add 	$push374=, $pop535, $pop371
	i32.const	$push809=, 12
	i32.add 	$push372=, $5, $pop809
	i32.load16_u	$push373=, 0($pop372):p2align=0
	i32.store16	0($pop374), $pop373
	i32.const	$push536=, 224
	i32.add 	$push537=, $10, $pop536
	i32.const	$push375=, 8
	i32.add 	$push378=, $pop537, $pop375
	i32.const	$push808=, 8
	i32.add 	$push376=, $5, $pop808
	i32.load	$push377=, 0($pop376):p2align=0
	i32.store	0($pop378), $pop377
	i32.const	$push379=, 128
	i32.add 	$push807=, $1, $pop379
	tee_local	$push806=, $7=, $pop807
	i32.store	12($10), $pop806
	i32.const	$push380=, 4
	i32.add 	$push381=, $5, $pop380
	i32.load	$push382=, 0($pop381):p2align=0
	i32.store	228($10), $pop382
	i32.load	$push383=, 0($5):p2align=0
	i32.store	224($10), $pop383
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_79:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label10:
	i32.const	$push538=, 224
	i32.add 	$push539=, $10, $pop538
	i32.add 	$push385=, $pop539, $3
	i32.const	$push811=, 1
	i32.add 	$push386=, $pop385, $pop811
	i32.load8_s	$4=, 0($pop386)
	block   	
	i32.const	$push810=, 14
	i32.eq  	$push384=, $8, $pop810
	br_if   	0, $pop384      # 0: down to label11
# BB#80:                                # %if.then.i480
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.ne  	$push387=, $0, $8
	br_if   	2, $pop387      # 2: down to label2
# BB#81:                                # %if.end.i482
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$9=, 14
	i32.const	$0=, 0
	i32.const	$push815=, 0
	i32.const	$push814=, 14
	i32.store	bar.lastn($pop815), $pop814
	i32.const	$push813=, 0
	i32.const	$push812=, 0
	i32.store	bar.lastc($pop813), $pop812
.LBB1_82:                               # %if.end3.i487
                                        #   in Loop: Header=BB1_79 Depth=1
	end_block                       # label11:
	i32.const	$push818=, 24
	i32.shl 	$push388=, $0, $pop818
	i32.const	$push817=, 24
	i32.shr_s	$push389=, $pop388, $pop817
	i32.const	$push816=, 112
	i32.xor 	$push390=, $pop389, $pop816
	i32.ne  	$push391=, $pop390, $4
	br_if   	1, $pop391      # 1: down to label2
# BB#83:                                # %bar.exit490
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$push826=, 0
	i32.const	$push825=, 1
	i32.add 	$push824=, $0, $pop825
	tee_local	$push823=, $0=, $pop824
	i32.store	bar.lastc($pop826), $pop823
	i32.const	$8=, 14
	i32.const	$push822=, 1
	i32.add 	$push821=, $3, $pop822
	tee_local	$push820=, $3=, $pop821
	i32.const	$push819=, 13
	i32.lt_s	$push392=, $pop820, $pop819
	br_if   	0, $pop392      # 0: up to label10
# BB#84:                                # %for.end170
	end_loop
	i32.const	$push540=, 208
	i32.add 	$push541=, $10, $pop540
	i32.const	$push832=, 14
	i32.add 	$push395=, $pop541, $pop832
	i32.const	$push831=, 14
	i32.add 	$push393=, $7, $pop831
	i32.load8_u	$push394=, 0($pop393)
	i32.store8	0($pop395), $pop394
	i32.const	$push542=, 208
	i32.add 	$push543=, $10, $pop542
	i32.const	$push396=, 12
	i32.add 	$push399=, $pop543, $pop396
	i32.const	$push830=, 12
	i32.add 	$push397=, $7, $pop830
	i32.load16_u	$push398=, 0($pop397):p2align=0
	i32.store16	0($pop399), $pop398
	i32.const	$push544=, 208
	i32.add 	$push545=, $10, $pop544
	i32.const	$push400=, 8
	i32.add 	$push403=, $pop545, $pop400
	i32.const	$push829=, 8
	i32.add 	$push401=, $7, $pop829
	i32.load	$push402=, 0($pop401):p2align=0
	i32.store	0($pop403), $pop402
	i32.const	$push404=, 144
	i32.add 	$push828=, $1, $pop404
	tee_local	$push827=, $5=, $pop828
	i32.store	12($10), $pop827
	i32.const	$push405=, 4
	i32.add 	$push406=, $7, $pop405
	i32.load	$push407=, 0($pop406):p2align=0
	i32.store	212($10), $pop407
	i32.load	$push408=, 0($7):p2align=0
	i32.store	208($10), $pop408
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_85:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label12:
	i32.const	$push546=, 208
	i32.add 	$push547=, $10, $pop546
	i32.add 	$push410=, $pop547, $3
	i32.const	$push834=, 1
	i32.add 	$push411=, $pop410, $pop834
	i32.load8_s	$4=, 0($pop411)
	block   	
	i32.const	$push833=, 15
	i32.eq  	$push409=, $8, $pop833
	br_if   	0, $pop409      # 0: down to label13
# BB#86:                                # %if.then.i494
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.ne  	$push412=, $0, $8
	br_if   	2, $pop412      # 2: down to label2
# BB#87:                                # %if.end.i496
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$9=, 15
	i32.const	$0=, 0
	i32.const	$push838=, 0
	i32.const	$push837=, 15
	i32.store	bar.lastn($pop838), $pop837
	i32.const	$push836=, 0
	i32.const	$push835=, 0
	i32.store	bar.lastc($pop836), $pop835
.LBB1_88:                               # %if.end3.i501
                                        #   in Loop: Header=BB1_85 Depth=1
	end_block                       # label13:
	i32.const	$push841=, 24
	i32.shl 	$push413=, $0, $pop841
	i32.const	$push840=, 24
	i32.shr_s	$push414=, $pop413, $pop840
	i32.const	$push839=, 120
	i32.xor 	$push415=, $pop414, $pop839
	i32.ne  	$push416=, $pop415, $4
	br_if   	1, $pop416      # 1: down to label2
# BB#89:                                # %bar.exit504
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$push849=, 0
	i32.const	$push848=, 1
	i32.add 	$push847=, $0, $pop848
	tee_local	$push846=, $0=, $pop847
	i32.store	bar.lastc($pop849), $pop846
	i32.const	$8=, 15
	i32.const	$push845=, 1
	i32.add 	$push844=, $3, $pop845
	tee_local	$push843=, $3=, $pop844
	i32.const	$push842=, 14
	i32.lt_s	$push417=, $pop843, $pop842
	br_if   	0, $pop417      # 0: up to label12
# BB#90:                                # %for.end182
	end_loop
	i32.const	$push548=, 192
	i32.add 	$push549=, $10, $pop548
	i32.const	$push418=, 12
	i32.add 	$push421=, $pop549, $pop418
	i32.const	$push853=, 12
	i32.add 	$push419=, $5, $pop853
	i32.load	$push420=, 0($pop419):p2align=0
	i32.store	0($pop421), $pop420
	i32.const	$push550=, 192
	i32.add 	$push551=, $10, $pop550
	i32.const	$push422=, 8
	i32.add 	$push425=, $pop551, $pop422
	i32.const	$push852=, 8
	i32.add 	$push423=, $5, $pop852
	i32.load	$push424=, 0($pop423):p2align=0
	i32.store	0($pop425), $pop424
	i32.const	$push426=, 160
	i32.add 	$push851=, $1, $pop426
	tee_local	$push850=, $6=, $pop851
	i32.store	12($10), $pop850
	i32.const	$push427=, 4
	i32.add 	$push428=, $5, $pop427
	i32.load	$push429=, 0($pop428):p2align=0
	i32.store	196($10), $pop429
	i32.load	$push430=, 0($5):p2align=0
	i32.store	192($10), $pop430
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_91:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push552=, 192
	i32.add 	$push553=, $10, $pop552
	i32.add 	$push432=, $pop553, $3
	i32.const	$push855=, 1
	i32.add 	$push433=, $pop432, $pop855
	i32.load8_s	$4=, 0($pop433)
	block   	
	i32.const	$push854=, 16
	i32.eq  	$push431=, $8, $pop854
	br_if   	0, $pop431      # 0: down to label15
# BB#92:                                # %if.then.i508
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.ne  	$push434=, $0, $8
	br_if   	2, $pop434      # 2: down to label2
# BB#93:                                # %if.end.i510
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$9=, 16
	i32.const	$0=, 0
	i32.const	$push859=, 0
	i32.const	$push858=, 16
	i32.store	bar.lastn($pop859), $pop858
	i32.const	$push857=, 0
	i32.const	$push856=, 0
	i32.store	bar.lastc($pop857), $pop856
.LBB1_94:                               # %if.end3.i515
                                        #   in Loop: Header=BB1_91 Depth=1
	end_block                       # label15:
	i32.const	$push862=, 24
	i32.shl 	$push435=, $0, $pop862
	i32.const	$push861=, -2147483648
	i32.xor 	$push436=, $pop435, $pop861
	i32.const	$push860=, 24
	i32.shr_s	$push437=, $pop436, $pop860
	i32.ne  	$push438=, $pop437, $4
	br_if   	1, $pop438      # 1: down to label2
# BB#95:                                # %bar.exit518
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$push870=, 0
	i32.const	$push869=, 1
	i32.add 	$push868=, $0, $pop869
	tee_local	$push867=, $0=, $pop868
	i32.store	bar.lastc($pop870), $pop867
	i32.const	$8=, 16
	i32.const	$push866=, 1
	i32.add 	$push865=, $3, $pop866
	tee_local	$push864=, $3=, $pop865
	i32.const	$push863=, 15
	i32.lt_s	$push439=, $pop864, $pop863
	br_if   	0, $pop439      # 0: up to label14
# BB#96:                                # %for.end194
	end_loop
	i32.const	$push440=, 192
	i32.add 	$push873=, $1, $pop440
	tee_local	$push872=, $7=, $pop873
	i32.store	12($10), $pop872
	i32.const	$push554=, 160
	i32.add 	$push555=, $10, $pop554
	i32.const	$push871=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop555, $6, $pop871
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_97:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push556=, 160
	i32.add 	$push557=, $10, $pop556
	i32.add 	$push442=, $pop557, $3
	i32.const	$push875=, 1
	i32.add 	$push443=, $pop442, $pop875
	i32.load8_s	$4=, 0($pop443)
	block   	
	i32.const	$push874=, 31
	i32.eq  	$push441=, $8, $pop874
	br_if   	0, $pop441      # 0: down to label17
# BB#98:                                # %if.then.i522
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.ne  	$push444=, $0, $8
	br_if   	2, $pop444      # 2: down to label2
# BB#99:                                # %if.end.i524
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$9=, 31
	i32.const	$0=, 0
	i32.const	$push879=, 0
	i32.const	$push878=, 31
	i32.store	bar.lastn($pop879), $pop878
	i32.const	$push877=, 0
	i32.const	$push876=, 0
	i32.store	bar.lastc($pop877), $pop876
.LBB1_100:                              # %if.end3.i529
                                        #   in Loop: Header=BB1_97 Depth=1
	end_block                       # label17:
	i32.const	$push882=, 24
	i32.shl 	$push445=, $0, $pop882
	i32.const	$push881=, -134217728
	i32.xor 	$push446=, $pop445, $pop881
	i32.const	$push880=, 24
	i32.shr_s	$push447=, $pop446, $pop880
	i32.ne  	$push448=, $pop447, $4
	br_if   	1, $pop448      # 1: down to label2
# BB#101:                               # %bar.exit532
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$push890=, 0
	i32.const	$push889=, 1
	i32.add 	$push888=, $0, $pop889
	tee_local	$push887=, $0=, $pop888
	i32.store	bar.lastc($pop890), $pop887
	i32.const	$8=, 31
	i32.const	$push886=, 1
	i32.add 	$push885=, $3, $pop886
	tee_local	$push884=, $3=, $pop885
	i32.const	$push883=, 30
	i32.lt_s	$push449=, $pop884, $pop883
	br_if   	0, $pop449      # 0: up to label16
# BB#102:                               # %for.end206
	end_loop
	i32.const	$push558=, 128
	i32.add 	$push559=, $10, $pop558
	i32.const	$push450=, 28
	i32.add 	$push453=, $pop559, $pop450
	i32.const	$push899=, 28
	i32.add 	$push451=, $7, $pop899
	i32.load	$push452=, 0($pop451):p2align=0
	i32.store	0($pop453), $pop452
	i32.const	$push560=, 128
	i32.add 	$push561=, $10, $pop560
	i32.const	$push898=, 24
	i32.add 	$push456=, $pop561, $pop898
	i32.const	$push897=, 24
	i32.add 	$push454=, $7, $pop897
	i32.load	$push455=, 0($pop454):p2align=0
	i32.store	0($pop456), $pop455
	i32.const	$push562=, 128
	i32.add 	$push563=, $10, $pop562
	i32.const	$push457=, 20
	i32.add 	$push460=, $pop563, $pop457
	i32.const	$push896=, 20
	i32.add 	$push458=, $7, $pop896
	i32.load	$push459=, 0($pop458):p2align=0
	i32.store	0($pop460), $pop459
	i32.const	$push564=, 128
	i32.add 	$push565=, $10, $pop564
	i32.const	$push461=, 16
	i32.add 	$push464=, $pop565, $pop461
	i32.const	$push895=, 16
	i32.add 	$push462=, $7, $pop895
	i32.load	$push463=, 0($pop462):p2align=0
	i32.store	0($pop464), $pop463
	i32.const	$push566=, 128
	i32.add 	$push567=, $10, $pop566
	i32.const	$push465=, 12
	i32.add 	$push468=, $pop567, $pop465
	i32.const	$push894=, 12
	i32.add 	$push466=, $7, $pop894
	i32.load	$push467=, 0($pop466):p2align=0
	i32.store	0($pop468), $pop467
	i32.const	$push568=, 128
	i32.add 	$push569=, $10, $pop568
	i32.const	$push469=, 8
	i32.add 	$push472=, $pop569, $pop469
	i32.const	$push893=, 8
	i32.add 	$push470=, $7, $pop893
	i32.load	$push471=, 0($pop470):p2align=0
	i32.store	0($pop472), $pop471
	i32.const	$push473=, 224
	i32.add 	$push892=, $1, $pop473
	tee_local	$push891=, $5=, $pop892
	i32.store	12($10), $pop891
	i32.const	$push474=, 4
	i32.add 	$push475=, $7, $pop474
	i32.load	$push476=, 0($pop475):p2align=0
	i32.store	132($10), $pop476
	i32.load	$push477=, 0($7):p2align=0
	i32.store	128($10), $pop477
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_103:                              # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push570=, 128
	i32.add 	$push571=, $10, $pop570
	i32.add 	$push479=, $pop571, $3
	i32.const	$push901=, 1
	i32.add 	$push480=, $pop479, $pop901
	i32.load8_s	$4=, 0($pop480)
	block   	
	i32.const	$push900=, 32
	i32.eq  	$push478=, $8, $pop900
	br_if   	0, $pop478      # 0: down to label19
# BB#104:                               # %if.then.i536
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.ne  	$push481=, $0, $8
	br_if   	2, $pop481      # 2: down to label2
# BB#105:                               # %if.end.i538
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$9=, 32
	i32.const	$0=, 0
	i32.const	$push905=, 0
	i32.const	$push904=, 32
	i32.store	bar.lastn($pop905), $pop904
	i32.const	$push903=, 0
	i32.const	$push902=, 0
	i32.store	bar.lastc($pop903), $pop902
.LBB1_106:                              # %if.end3.i543
                                        #   in Loop: Header=BB1_103 Depth=1
	end_block                       # label19:
	i32.const	$push907=, 24
	i32.shl 	$push482=, $0, $pop907
	i32.const	$push906=, 24
	i32.shr_s	$push483=, $pop482, $pop906
	i32.ne  	$push484=, $pop483, $4
	br_if   	1, $pop484      # 1: down to label2
# BB#107:                               # %bar.exit546
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$push915=, 0
	i32.const	$push914=, 1
	i32.add 	$push913=, $0, $pop914
	tee_local	$push912=, $0=, $pop913
	i32.store	bar.lastc($pop915), $pop912
	i32.const	$8=, 32
	i32.const	$push911=, 1
	i32.add 	$push910=, $3, $pop911
	tee_local	$push909=, $3=, $pop910
	i32.const	$push908=, 31
	i32.lt_s	$push485=, $pop909, $pop908
	br_if   	0, $pop485      # 0: up to label18
# BB#108:                               # %for.end218
	end_loop
	i32.const	$push486=, 260
	i32.add 	$push918=, $1, $pop486
	tee_local	$push917=, $7=, $pop918
	i32.store	12($10), $pop917
	i32.const	$push572=, 88
	i32.add 	$push573=, $10, $pop572
	i32.const	$push916=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop573, $5, $pop916
	i32.const	$3=, -1
	copy_local	$8=, $9
.LBB1_109:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push574=, 88
	i32.add 	$push575=, $10, $pop574
	i32.add 	$push488=, $pop575, $3
	i32.const	$push920=, 1
	i32.add 	$push489=, $pop488, $pop920
	i32.load8_s	$4=, 0($pop489)
	block   	
	i32.const	$push919=, 35
	i32.eq  	$push487=, $8, $pop919
	br_if   	0, $pop487      # 0: down to label21
# BB#110:                               # %if.then.i550
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.ne  	$push490=, $0, $8
	br_if   	2, $pop490      # 2: down to label2
# BB#111:                               # %if.end.i552
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$9=, 35
	i32.const	$0=, 0
	i32.const	$push924=, 0
	i32.const	$push923=, 35
	i32.store	bar.lastn($pop924), $pop923
	i32.const	$push922=, 0
	i32.const	$push921=, 0
	i32.store	bar.lastc($pop922), $pop921
.LBB1_112:                              # %if.end3.i557
                                        #   in Loop: Header=BB1_109 Depth=1
	end_block                       # label21:
	i32.const	$push927=, 24
	i32.shl 	$push491=, $0, $pop927
	i32.const	$push926=, 24
	i32.shr_s	$push492=, $pop491, $pop926
	i32.const	$push925=, 24
	i32.xor 	$push493=, $pop492, $pop925
	i32.ne  	$push494=, $pop493, $4
	br_if   	1, $pop494      # 1: down to label2
# BB#113:                               # %bar.exit560
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$push935=, 0
	i32.const	$push934=, 1
	i32.add 	$push933=, $0, $pop934
	tee_local	$push932=, $0=, $pop933
	i32.store	bar.lastc($pop935), $pop932
	i32.const	$8=, 35
	i32.const	$push931=, 1
	i32.add 	$push930=, $3, $pop931
	tee_local	$push929=, $3=, $pop930
	i32.const	$push928=, 34
	i32.lt_s	$push495=, $pop929, $pop928
	br_if   	0, $pop495      # 0: up to label20
# BB#114:                               # %for.end230
	end_loop
	i32.const	$push496=, 332
	i32.add 	$push497=, $1, $pop496
	i32.store	12($10), $pop497
	i32.const	$push576=, 16
	i32.add 	$push577=, $10, $pop576
	i32.const	$push936=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop577, $7, $pop936
	i32.const	$3=, -1
.LBB1_115:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label22:
	i32.const	$push578=, 16
	i32.add 	$push579=, $10, $pop578
	i32.add 	$push499=, $pop579, $3
	i32.const	$push938=, 1
	i32.add 	$push500=, $pop499, $pop938
	i32.load8_s	$8=, 0($pop500)
	block   	
	i32.const	$push937=, 72
	i32.eq  	$push498=, $9, $pop937
	br_if   	0, $pop498      # 0: down to label23
# BB#116:                               # %if.then.i564
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.ne  	$push501=, $0, $9
	br_if   	2, $pop501      # 2: down to label2
# BB#117:                               # %if.end.i566
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$0=, 0
	i32.const	$push942=, 0
	i32.const	$push941=, 72
	i32.store	bar.lastn($pop942), $pop941
	i32.const	$push940=, 0
	i32.const	$push939=, 0
	i32.store	bar.lastc($pop940), $pop939
.LBB1_118:                              # %if.end3.i571
                                        #   in Loop: Header=BB1_115 Depth=1
	end_block                       # label23:
	i32.const	$push945=, 24
	i32.shl 	$push502=, $0, $pop945
	i32.const	$push944=, 24
	i32.shr_s	$push503=, $pop502, $pop944
	i32.const	$push943=, 64
	i32.xor 	$push504=, $pop503, $pop943
	i32.ne  	$push505=, $pop504, $8
	br_if   	1, $pop505      # 1: down to label2
# BB#119:                               # %bar.exit574
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$push953=, 0
	i32.const	$push952=, 1
	i32.add 	$push951=, $0, $pop952
	tee_local	$push950=, $0=, $pop951
	i32.store	bar.lastc($pop953), $pop950
	i32.const	$9=, 72
	i32.const	$push949=, 1
	i32.add 	$push948=, $3, $pop949
	tee_local	$push947=, $3=, $pop948
	i32.const	$push946=, 71
	i32.lt_s	$push506=, $pop947, $pop946
	br_if   	0, $pop506      # 0: up to label22
# BB#120:                               # %for.end242
	end_loop
	i32.const	$push513=, 0
	i32.const	$push511=, 352
	i32.add 	$push512=, $10, $pop511
	i32.store	__stack_pointer($pop513), $pop512
	return
.LBB1_121:                              # %if.then
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push241=, 0
	i32.const	$push239=, 0
	i32.load	$push238=, __stack_pointer($pop239)
	i32.const	$push240=, 768
	i32.sub 	$push397=, $pop238, $pop240
	tee_local	$push396=, $1=, $pop397
	i32.store	__stack_pointer($pop241), $pop396
	i32.const	$push0=, 4368
	i32.store16	760($1), $pop0
	i32.const	$push1=, 24
	i32.store8	752($1), $pop1
	i32.const	$push2=, 32
	i32.store8	744($1), $pop2
	i32.const	$push3=, 40
	i32.store8	736($1), $pop3
	i32.const	$push4=, 48
	i32.store8	728($1), $pop4
	i32.const	$push5=, 25
	i32.store8	753($1), $pop5
	i32.const	$push6=, 33
	i32.store8	745($1), $pop6
	i32.const	$push7=, 41
	i32.store8	737($1), $pop7
	i32.const	$push8=, 26
	i32.store8	754($1), $pop8
	i32.const	$push9=, 34
	i32.store8	746($1), $pop9
	i32.const	$push10=, 35
	i32.store8	747($1), $pop10
	i32.const	$push11=, 42
	i32.store8	738($1), $pop11
	i32.const	$push12=, 43
	i32.store8	739($1), $pop12
	i32.const	$push13=, 44
	i32.store8	740($1), $pop13
	i32.const	$push14=, 52
	i32.store8	732($1), $pop14
	i32.const	$push15=, 50
	i32.store8	730($1), $pop15
	i32.const	$push16=, 51
	i32.store8	731($1), $pop16
	i32.const	$push17=, 49
	i32.store8	729($1), $pop17
	i32.const	$push18=, 56
	i32.store8	720($1), $pop18
	i32.const	$push19=, 53
	i32.store8	733($1), $pop19
	i32.const	$push20=, 57
	i32.store8	721($1), $pop20
	i32.const	$push21=, 58
	i32.store8	722($1), $pop21
	i32.const	$push22=, 59
	i32.store8	723($1), $pop22
	i32.const	$push23=, 60
	i32.store8	724($1), $pop23
	i32.const	$push24=, 61
	i32.store8	725($1), $pop24
	i32.const	$push25=, 64
	i32.store8	712($1), $pop25
	i32.const	$push26=, 62
	i32.store8	726($1), $pop26
	i32.const	$push27=, 65
	i32.store8	713($1), $pop27
	i32.const	$push28=, 66
	i32.store8	714($1), $pop28
	i32.const	$push29=, 67
	i32.store8	715($1), $pop29
	i32.const	$push30=, 68
	i32.store8	716($1), $pop30
	i32.const	$push31=, 69
	i32.store8	717($1), $pop31
	i32.const	$push32=, 70
	i32.store8	718($1), $pop32
	i32.const	$push33=, 72
	i32.store8	696($1), $pop33
	i32.const	$push34=, 71
	i32.store8	719($1), $pop34
	i32.const	$push35=, 73
	i32.store8	697($1), $pop35
	i32.const	$push36=, 74
	i32.store8	698($1), $pop36
	i32.const	$push37=, 75
	i32.store8	699($1), $pop37
	i32.const	$push38=, 76
	i32.store8	700($1), $pop38
	i32.const	$push39=, 77
	i32.store8	701($1), $pop39
	i32.const	$push40=, 78
	i32.store8	702($1), $pop40
	i32.const	$push41=, 79
	i32.store8	703($1), $pop41
	i32.const	$push42=, 80
	i32.store8	680($1), $pop42
	i32.const	$push395=, 64
	i32.store8	704($1), $pop395
	i32.const	$push43=, 81
	i32.store8	681($1), $pop43
	i32.const	$push44=, 82
	i32.store8	682($1), $pop44
	i32.const	$push45=, 83
	i32.store8	683($1), $pop45
	i32.const	$push46=, 84
	i32.store8	684($1), $pop46
	i32.const	$push47=, 85
	i32.store8	685($1), $pop47
	i32.const	$push48=, 86
	i32.store8	686($1), $pop48
	i32.const	$push49=, 87
	i32.store8	687($1), $pop49
	i32.const	$push50=, 88
	i32.store8	688($1), $pop50
	i32.const	$push394=, 88
	i32.store8	664($1), $pop394
	i32.const	$push51=, 89
	i32.store8	689($1), $pop51
	i32.const	$push393=, 89
	i32.store8	665($1), $pop393
	i32.const	$push52=, 90
	i32.store8	666($1), $pop52
	i32.const	$push53=, 91
	i32.store8	667($1), $pop53
	i32.const	$push54=, 92
	i32.store8	668($1), $pop54
	i32.const	$push55=, 93
	i32.store8	669($1), $pop55
	i32.const	$push56=, 94
	i32.store8	670($1), $pop56
	i32.const	$push57=, 95
	i32.store8	671($1), $pop57
	i32.const	$push392=, 80
	i32.store8	672($1), $pop392
	i32.const	$push391=, 81
	i32.store8	673($1), $pop391
	i32.const	$push58=, 96
	i32.store8	648($1), $pop58
	i32.const	$push390=, 82
	i32.store8	674($1), $pop390
	i32.const	$push59=, 97
	i32.store8	649($1), $pop59
	i32.const	$push60=, 98
	i32.store8	650($1), $pop60
	i32.const	$push61=, 99
	i32.store8	651($1), $pop61
	i32.const	$push62=, 100
	i32.store8	652($1), $pop62
	i32.const	$push63=, 101
	i32.store8	653($1), $pop63
	i32.const	$push64=, 102
	i32.store8	654($1), $pop64
	i32.const	$push65=, 103
	i32.store8	655($1), $pop65
	i32.const	$push66=, 104
	i32.store8	656($1), $pop66
	i32.const	$push67=, 105
	i32.store8	657($1), $pop67
	i32.const	$push68=, 106
	i32.store8	658($1), $pop68
	i32.const	$push389=, 104
	i32.store8	632($1), $pop389
	i32.const	$push69=, 107
	i32.store8	659($1), $pop69
	i32.const	$push388=, 105
	i32.store8	633($1), $pop388
	i32.const	$push387=, 106
	i32.store8	634($1), $pop387
	i32.const	$push386=, 107
	i32.store8	635($1), $pop386
	i32.const	$push70=, 108
	i32.store8	636($1), $pop70
	i32.const	$push71=, 109
	i32.store8	637($1), $pop71
	i32.const	$push72=, 110
	i32.store8	638($1), $pop72
	i32.const	$push73=, 111
	i32.store8	639($1), $pop73
	i32.const	$push385=, 96
	i32.store8	640($1), $pop385
	i32.const	$push384=, 97
	i32.store8	641($1), $pop384
	i32.const	$push383=, 98
	i32.store8	642($1), $pop383
	i32.const	$push382=, 99
	i32.store8	643($1), $pop382
	i32.const	$push74=, 112
	i32.store8	616($1), $pop74
	i32.const	$push381=, 100
	i32.store8	644($1), $pop381
	i32.const	$push75=, 113
	i32.store8	617($1), $pop75
	i32.const	$push76=, 114
	i32.store8	618($1), $pop76
	i32.const	$push77=, 115
	i32.store8	619($1), $pop77
	i32.const	$push78=, 116
	i32.store8	620($1), $pop78
	i32.const	$push79=, 117
	i32.store8	621($1), $pop79
	i32.const	$push80=, 118
	i32.store8	622($1), $pop80
	i32.const	$push81=, 119
	i32.store8	623($1), $pop81
	i32.const	$push82=, 120
	i32.store8	624($1), $pop82
	i32.const	$push83=, 121
	i32.store8	625($1), $pop83
	i32.const	$push84=, 122
	i32.store8	626($1), $pop84
	i32.const	$push85=, 123
	i32.store8	627($1), $pop85
	i32.const	$push86=, 124
	i32.store8	628($1), $pop86
	i32.const	$push380=, 120
	i32.store8	600($1), $pop380
	i32.const	$push87=, 125
	i32.store8	629($1), $pop87
	i32.const	$push379=, 121
	i32.store8	601($1), $pop379
	i32.const	$push378=, 122
	i32.store8	602($1), $pop378
	i32.const	$push377=, 123
	i32.store8	603($1), $pop377
	i32.const	$push376=, 124
	i32.store8	604($1), $pop376
	i32.const	$push375=, 125
	i32.store8	605($1), $pop375
	i32.const	$push88=, 126
	i32.store8	606($1), $pop88
	i32.const	$push89=, 127
	i32.store8	607($1), $pop89
	i32.const	$push374=, 112
	i32.store8	608($1), $pop374
	i32.const	$push373=, 113
	i32.store8	609($1), $pop373
	i32.const	$push372=, 114
	i32.store8	610($1), $pop372
	i32.const	$push371=, 115
	i32.store8	611($1), $pop371
	i32.const	$push370=, 116
	i32.store8	612($1), $pop370
	i32.const	$push369=, 117
	i32.store8	613($1), $pop369
	i32.const	$push368=, 118
	i32.store8	614($1), $pop368
	i32.const	$push90=, 128
	i32.store8	584($1), $pop90
	i32.const	$push91=, 129
	i32.store8	585($1), $pop91
	i32.const	$push92=, 130
	i32.store8	586($1), $pop92
	i32.const	$push93=, 131
	i32.store8	587($1), $pop93
	i32.const	$push94=, 132
	i32.store8	588($1), $pop94
	i32.const	$push95=, 133
	i32.store8	589($1), $pop95
	i32.const	$push96=, 134
	i32.store8	590($1), $pop96
	i32.const	$push97=, 135
	i32.store8	591($1), $pop97
	i32.const	$push98=, 136
	i32.store8	592($1), $pop98
	i32.const	$push99=, 137
	i32.store8	593($1), $pop99
	i32.const	$push100=, 138
	i32.store8	594($1), $pop100
	i32.const	$push101=, 139
	i32.store8	595($1), $pop101
	i32.const	$push102=, 140
	i32.store8	596($1), $pop102
	i32.const	$push103=, 141
	i32.store8	597($1), $pop103
	i32.const	$push104=, 142
	i32.store8	598($1), $pop104
	i32.const	$push105=, 143
	i32.store8	599($1), $pop105
	i32.const	$0=, 0
.LBB2_1:                                # %for.body180
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label24:
	i32.const	$push242=, 552
	i32.add 	$push243=, $1, $pop242
	i32.add 	$push107=, $pop243, $0
	i32.const	$push402=, 248
	i32.xor 	$push106=, $0, $pop402
	i32.store8	0($pop107), $pop106
	i32.const	$push401=, 1
	i32.add 	$push400=, $0, $pop401
	tee_local	$push399=, $0=, $pop400
	i32.const	$push398=, 31
	i32.ne  	$push108=, $pop399, $pop398
	br_if   	0, $pop108      # 0: up to label24
# BB#2:                                 # %for.body191.preheader
	end_loop
	i64.const	$push109=, 506097522914230528
	i64.store	520($1), $pop109
	i64.const	$push110=, 1084818905618843912
	i64.store	528($1), $pop110
	i32.const	$push111=, 4368
	i32.store16	536($1), $pop111
	i64.const	$push112=, 1808220633999610642
	i64.store	538($1):p2align=1, $pop112
	i32.const	$push113=, 488381210
	i32.store	546($1):p2align=1, $pop113
	i32.const	$push114=, 7966
	i32.store16	550($1), $pop114
	i32.const	$0=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label25:
	i32.const	$push244=, 480
	i32.add 	$push245=, $1, $pop244
	i32.add 	$push116=, $pop245, $0
	i32.const	$push407=, 24
	i32.xor 	$push115=, $0, $pop407
	i32.store8	0($pop116), $pop115
	i32.const	$push406=, 1
	i32.add 	$push405=, $0, $pop406
	tee_local	$push404=, $0=, $pop405
	i32.const	$push403=, 35
	i32.ne  	$push117=, $pop404, $pop403
	br_if   	0, $pop117      # 0: up to label25
# BB#4:                                 # %for.body213.preheader
	end_loop
	i32.const	$0=, 0
.LBB2_5:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label26:
	i32.const	$push246=, 408
	i32.add 	$push247=, $1, $pop246
	i32.add 	$push119=, $pop247, $0
	i32.const	$push412=, 64
	i32.xor 	$push118=, $0, $pop412
	i32.store8	0($pop119), $pop118
	i32.const	$push411=, 1
	i32.add 	$push410=, $0, $pop411
	tee_local	$push409=, $0=, $pop410
	i32.const	$push408=, 72
	i32.ne  	$push120=, $pop409, $pop408
	br_if   	0, $pop120      # 0: up to label26
# BB#6:                                 # %for.end220
	end_loop
	i32.const	$push121=, 404
	i32.add 	$push122=, $1, $pop121
	i32.load8_u	$push123=, 754($1)
	i32.store8	0($pop122), $pop123
	i32.const	$push248=, 388
	i32.add 	$push249=, $1, $pop248
	i32.const	$push124=, 4
	i32.add 	$push125=, $pop249, $pop124
	i32.load8_u	$push126=, 740($1)
	i32.store8	0($pop125), $pop126
	i32.load16_u	$push127=, 760($1)
	i32.store16	406($1), $pop127
	i32.load16_u	$push128=, 752($1)
	i32.store16	402($1), $pop128
	i32.load	$push129=, 744($1)
	i32.store	396($1), $pop129
	i32.const	$push250=, 380
	i32.add 	$push251=, $1, $pop250
	i32.const	$push444=, 4
	i32.add 	$push130=, $pop251, $pop444
	i32.load16_u	$push131=, 732($1)
	i32.store16	0($pop130), $pop131
	i32.load	$push132=, 736($1)
	i32.store	388($1), $pop132
	i32.load	$push133=, 728($1)
	i32.store	380($1), $pop133
	i32.const	$push252=, 372
	i32.add 	$push253=, $1, $pop252
	i32.const	$push443=, 4
	i32.add 	$push134=, $pop253, $pop443
	i32.load16_u	$push135=, 724($1)
	i32.store16	0($pop134), $pop135
	i32.const	$push136=, 378
	i32.add 	$push137=, $1, $pop136
	i32.load8_u	$push138=, 726($1)
	i32.store8	0($pop137), $pop138
	i32.load	$push139=, 720($1)
	i32.store	372($1), $pop139
	i64.load	$push140=, 712($1)
	i64.store	364($1):p2align=2, $pop140
	i32.const	$push254=, 352
	i32.add 	$push255=, $1, $pop254
	i32.const	$push141=, 8
	i32.add 	$push142=, $pop255, $pop141
	i32.const	$push256=, 696
	i32.add 	$push257=, $1, $pop256
	i32.const	$push442=, 8
	i32.add 	$push143=, $pop257, $pop442
	i32.load8_u	$push144=, 0($pop143)
	i32.store8	0($pop142), $pop144
	i64.load	$push145=, 696($1)
	i64.store	352($1):p2align=2, $pop145
	i32.const	$push258=, 340
	i32.add 	$push259=, $1, $pop258
	i32.const	$push441=, 8
	i32.add 	$push146=, $pop259, $pop441
	i32.const	$push260=, 680
	i32.add 	$push261=, $1, $pop260
	i32.const	$push440=, 8
	i32.add 	$push147=, $pop261, $pop440
	i32.load16_u	$push148=, 0($pop147)
	i32.store16	0($pop146), $pop148
	i64.load	$push149=, 680($1)
	i64.store	340($1):p2align=2, $pop149
	i32.const	$push262=, 328
	i32.add 	$push263=, $1, $pop262
	i32.const	$push150=, 10
	i32.add 	$push151=, $pop263, $pop150
	i32.const	$push264=, 664
	i32.add 	$push265=, $1, $pop264
	i32.const	$push439=, 10
	i32.add 	$push152=, $pop265, $pop439
	i32.load8_u	$push153=, 0($pop152)
	i32.store8	0($pop151), $pop153
	i32.const	$push266=, 328
	i32.add 	$push267=, $1, $pop266
	i32.const	$push438=, 8
	i32.add 	$push154=, $pop267, $pop438
	i32.const	$push268=, 664
	i32.add 	$push269=, $1, $pop268
	i32.const	$push437=, 8
	i32.add 	$push155=, $pop269, $pop437
	i32.load16_u	$push156=, 0($pop155)
	i32.store16	0($pop154), $pop156
	i64.load	$push157=, 664($1)
	i64.store	328($1):p2align=2, $pop157
	i32.const	$push270=, 316
	i32.add 	$push271=, $1, $pop270
	i32.const	$push436=, 8
	i32.add 	$push158=, $pop271, $pop436
	i32.const	$push272=, 648
	i32.add 	$push273=, $1, $pop272
	i32.const	$push435=, 8
	i32.add 	$push159=, $pop273, $pop435
	i32.load	$push160=, 0($pop159)
	i32.store	0($pop158), $pop160
	i64.load	$push161=, 648($1)
	i64.store	316($1):p2align=2, $pop161
	i32.const	$push274=, 300
	i32.add 	$push275=, $1, $pop274
	i32.const	$push162=, 12
	i32.add 	$push163=, $pop275, $pop162
	i32.const	$push276=, 632
	i32.add 	$push277=, $1, $pop276
	i32.const	$push434=, 12
	i32.add 	$push164=, $pop277, $pop434
	i32.load8_u	$push165=, 0($pop164)
	i32.store8	0($pop163), $pop165
	i32.const	$push278=, 300
	i32.add 	$push279=, $1, $pop278
	i32.const	$push433=, 8
	i32.add 	$push166=, $pop279, $pop433
	i32.const	$push280=, 632
	i32.add 	$push281=, $1, $pop280
	i32.const	$push432=, 8
	i32.add 	$push167=, $pop281, $pop432
	i32.load	$push168=, 0($pop167)
	i32.store	0($pop166), $pop168
	i64.load	$push169=, 632($1)
	i64.store	300($1):p2align=2, $pop169
	i32.const	$push282=, 284
	i32.add 	$push283=, $1, $pop282
	i32.const	$push431=, 12
	i32.add 	$push170=, $pop283, $pop431
	i32.const	$push284=, 616
	i32.add 	$push285=, $1, $pop284
	i32.const	$push430=, 12
	i32.add 	$push171=, $pop285, $pop430
	i32.load16_u	$push172=, 0($pop171)
	i32.store16	0($pop170), $pop172
	i32.const	$push286=, 284
	i32.add 	$push287=, $1, $pop286
	i32.const	$push429=, 8
	i32.add 	$push173=, $pop287, $pop429
	i32.const	$push288=, 616
	i32.add 	$push289=, $1, $pop288
	i32.const	$push428=, 8
	i32.add 	$push174=, $pop289, $pop428
	i32.load	$push175=, 0($pop174)
	i32.store	0($pop173), $pop175
	i64.load	$push176=, 616($1)
	i64.store	284($1):p2align=2, $pop176
	i32.const	$push290=, 268
	i32.add 	$push291=, $1, $pop290
	i32.const	$push177=, 14
	i32.add 	$push178=, $pop291, $pop177
	i32.const	$push292=, 600
	i32.add 	$push293=, $1, $pop292
	i32.const	$push427=, 14
	i32.add 	$push179=, $pop293, $pop427
	i32.load8_u	$push180=, 0($pop179)
	i32.store8	0($pop178), $pop180
	i32.const	$push294=, 268
	i32.add 	$push295=, $1, $pop294
	i32.const	$push426=, 12
	i32.add 	$push181=, $pop295, $pop426
	i32.const	$push296=, 600
	i32.add 	$push297=, $1, $pop296
	i32.const	$push425=, 12
	i32.add 	$push182=, $pop297, $pop425
	i32.load16_u	$push183=, 0($pop182)
	i32.store16	0($pop181), $pop183
	i32.const	$push298=, 268
	i32.add 	$push299=, $1, $pop298
	i32.const	$push424=, 8
	i32.add 	$push184=, $pop299, $pop424
	i32.const	$push300=, 600
	i32.add 	$push301=, $1, $pop300
	i32.const	$push423=, 8
	i32.add 	$push185=, $pop301, $pop423
	i32.load	$push186=, 0($pop185)
	i32.store	0($pop184), $pop186
	i64.load	$push187=, 600($1)
	i64.store	268($1):p2align=2, $pop187
	i32.const	$push302=, 252
	i32.add 	$push303=, $1, $pop302
	i32.const	$push422=, 8
	i32.add 	$push188=, $pop303, $pop422
	i32.const	$push304=, 584
	i32.add 	$push305=, $1, $pop304
	i32.const	$push421=, 8
	i32.add 	$push189=, $pop305, $pop421
	i64.load	$push190=, 0($pop189)
	i64.store	0($pop188):p2align=2, $pop190
	i64.load	$push191=, 584($1)
	i64.store	252($1):p2align=2, $pop191
	i32.const	$push306=, 221
	i32.add 	$push307=, $1, $pop306
	i32.const	$push308=, 552
	i32.add 	$push309=, $1, $pop308
	i32.const	$push192=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop307, $pop309, $pop192
	i32.const	$push310=, 188
	i32.add 	$push311=, $1, $pop310
	i32.const	$push193=, 24
	i32.add 	$push194=, $pop311, $pop193
	i32.const	$push312=, 520
	i32.add 	$push313=, $1, $pop312
	i32.const	$push420=, 24
	i32.add 	$push195=, $pop313, $pop420
	i64.load	$push196=, 0($pop195)
	i64.store	0($pop194):p2align=2, $pop196
	i32.const	$push314=, 188
	i32.add 	$push315=, $1, $pop314
	i32.const	$push197=, 16
	i32.add 	$push198=, $pop315, $pop197
	i32.const	$push316=, 520
	i32.add 	$push317=, $1, $pop316
	i32.const	$push419=, 16
	i32.add 	$push199=, $pop317, $pop419
	i64.load	$push200=, 0($pop199)
	i64.store	0($pop198):p2align=2, $pop200
	i32.const	$push318=, 188
	i32.add 	$push319=, $1, $pop318
	i32.const	$push418=, 8
	i32.add 	$push201=, $pop319, $pop418
	i32.const	$push320=, 520
	i32.add 	$push321=, $1, $pop320
	i32.const	$push417=, 8
	i32.add 	$push202=, $pop321, $pop417
	i64.load	$push203=, 0($pop202)
	i64.store	0($pop201):p2align=2, $pop203
	i64.load	$push204=, 520($1)
	i64.store	188($1):p2align=2, $pop204
	i32.const	$push322=, 153
	i32.add 	$push323=, $1, $pop322
	i32.const	$push324=, 480
	i32.add 	$push325=, $1, $pop324
	i32.const	$push205=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop323, $pop325, $pop205
	i32.const	$push326=, 81
	i32.add 	$push327=, $1, $pop326
	i32.const	$push328=, 408
	i32.add 	$push329=, $1, $pop328
	i32.const	$push206=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop327, $pop329, $pop206
	i32.const	$push207=, 76
	i32.add 	$push208=, $1, $pop207
	i32.const	$push330=, 81
	i32.add 	$push331=, $1, $pop330
	i32.store	0($pop208), $pop331
	i32.const	$push209=, 68
	i32.add 	$push210=, $1, $pop209
	i32.const	$push332=, 188
	i32.add 	$push333=, $1, $pop332
	i32.store	0($pop210), $pop333
	i32.const	$push211=, 64
	i32.add 	$push212=, $1, $pop211
	i32.const	$push334=, 221
	i32.add 	$push335=, $1, $pop334
	i32.store	0($pop212), $pop335
	i32.const	$push213=, 60
	i32.add 	$push214=, $1, $pop213
	i32.const	$push336=, 252
	i32.add 	$push337=, $1, $pop336
	i32.store	0($pop214), $pop337
	i32.const	$push215=, 56
	i32.add 	$push216=, $1, $pop215
	i32.const	$push338=, 268
	i32.add 	$push339=, $1, $pop338
	i32.store	0($pop216), $pop339
	i32.const	$push217=, 52
	i32.add 	$push218=, $1, $pop217
	i32.const	$push340=, 284
	i32.add 	$push341=, $1, $pop340
	i32.store	0($pop218), $pop341
	i32.const	$push219=, 48
	i32.add 	$push220=, $1, $pop219
	i32.const	$push342=, 300
	i32.add 	$push343=, $1, $pop342
	i32.store	0($pop220), $pop343
	i32.const	$push221=, 44
	i32.add 	$push222=, $1, $pop221
	i32.const	$push344=, 316
	i32.add 	$push345=, $1, $pop344
	i32.store	0($pop222), $pop345
	i32.const	$push223=, 40
	i32.add 	$push224=, $1, $pop223
	i32.const	$push346=, 328
	i32.add 	$push347=, $1, $pop346
	i32.store	0($pop224), $pop347
	i32.const	$push225=, 36
	i32.add 	$push226=, $1, $pop225
	i32.const	$push348=, 340
	i32.add 	$push349=, $1, $pop348
	i32.store	0($pop226), $pop349
	i32.const	$push227=, 32
	i32.add 	$push228=, $1, $pop227
	i32.const	$push350=, 352
	i32.add 	$push351=, $1, $pop350
	i32.store	0($pop228), $pop351
	i32.const	$push229=, 28
	i32.add 	$push230=, $1, $pop229
	i32.const	$push352=, 364
	i32.add 	$push353=, $1, $pop352
	i32.store	0($pop230), $pop353
	i32.const	$push416=, 24
	i32.add 	$push231=, $1, $pop416
	i32.const	$push354=, 372
	i32.add 	$push355=, $1, $pop354
	i32.store	0($pop231), $pop355
	i32.const	$push232=, 20
	i32.add 	$push233=, $1, $pop232
	i32.const	$push356=, 380
	i32.add 	$push357=, $1, $pop356
	i32.store	0($pop233), $pop357
	i32.const	$push415=, 16
	i32.add 	$push234=, $1, $pop415
	i32.const	$push358=, 388
	i32.add 	$push359=, $1, $pop358
	i32.store	0($pop234), $pop359
	i32.const	$push414=, 8
	i32.store	0($1), $pop414
	i32.const	$push413=, 72
	i32.add 	$push235=, $1, $pop413
	i32.const	$push360=, 153
	i32.add 	$push361=, $1, $pop360
	i32.store	0($pop235), $pop361
	i32.const	$push362=, 396
	i32.add 	$push363=, $1, $pop362
	i32.store	12($1), $pop363
	i32.const	$push364=, 402
	i32.add 	$push365=, $1, $pop364
	i32.store	8($1), $pop365
	i32.const	$push366=, 406
	i32.add 	$push367=, $1, $pop366
	i32.store	4($1), $pop367
	i32.const	$push236=, 21
	call    	foo@FUNCTION, $pop236, $1
	i32.const	$push237=, 0
	call    	exit@FUNCTION, $pop237
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
