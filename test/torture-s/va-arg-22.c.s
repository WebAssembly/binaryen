	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-22.c"
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
	i32.const	$push504=, 0
	i32.const	$push501=, 0
	i32.load	$push502=, __stack_pointer($pop501)
	i32.const	$push503=, 352
	i32.sub 	$push575=, $pop502, $pop503
	tee_local	$push574=, $9=, $pop575
	i32.store	__stack_pointer($pop504), $pop574
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 21
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label10
# BB#1:                                 # %if.end
	i32.store	4($9), $1
	i32.const	$push2=, 4
	i32.add 	$push3=, $1, $pop2
	i32.store	4($9), $pop3
	i32.const	$push4=, 0
	i32.load	$0=, bar.lastc($pop4)
	i32.load8_s	$8=, 0($1)
	block   	
	i32.const	$push578=, 0
	i32.load	$push577=, bar.lastn($pop578)
	tee_local	$push576=, $2=, $pop577
	i32.const	$push5=, 1
	i32.eq  	$push6=, $pop576, $pop5
	br_if   	0, $pop6        # 0: down to label11
# BB#2:                                 # %if.then.i
	i32.ne  	$push7=, $0, $2
	br_if   	1, $pop7        # 1: down to label10
# BB#3:                                 # %if.end.i
	i32.const	$0=, 0
	i32.const	$push581=, 0
	i32.const	$push8=, 1
	i32.store	bar.lastn($pop581), $pop8
	i32.const	$push580=, 0
	i32.const	$push579=, 0
	i32.store	bar.lastc($pop580), $pop579
.LBB1_4:                                # %if.end3.i
	end_block                       # label11:
	i32.const	$push9=, 24
	i32.shl 	$push10=, $0, $pop9
	i32.const	$push583=, 24
	i32.shr_s	$push11=, $pop10, $pop583
	i32.const	$push582=, 8
	i32.xor 	$push12=, $pop11, $pop582
	i32.ne  	$push13=, $pop12, $8
	br_if   	0, $pop13       # 0: down to label10
# BB#5:                                 # %if.then.i312
	i32.const	$push587=, 0
	i32.const	$push14=, 1
	i32.add 	$push15=, $0, $pop14
	i32.store	bar.lastc($pop587), $pop15
	i32.const	$push586=, 8
	i32.add 	$push585=, $1, $pop586
	tee_local	$push584=, $8=, $pop585
	i32.store	4($9), $pop584
	br_if   	0, $0           # 0: down to label10
# BB#6:                                 # %if.end3.i319
	i32.const	$push16=, 4
	i32.add 	$push17=, $1, $pop16
	i32.load16_u	$0=, 0($pop17):p2align=0
	i32.const	$push590=, 0
	i32.const	$push18=, 2
	i32.store	bar.lastn($pop590), $pop18
	i32.const	$push589=, 0
	i32.const	$push588=, 0
	i32.store	bar.lastc($pop589), $pop588
	i32.const	$push19=, 255
	i32.and 	$push20=, $0, $pop19
	i32.const	$push21=, 16
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label10
# BB#7:                                 # %if.end3.i319.1
	i32.const	$push591=, 0
	i32.const	$push23=, 1
	i32.store	bar.lastc($pop591), $pop23
	i32.const	$push24=, 65280
	i32.and 	$push25=, $0, $pop24
	i32.const	$push26=, 4352
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label10
# BB#8:                                 # %if.end3.i333
	i32.const	$push28=, 12
	i32.add 	$push29=, $1, $pop28
	i32.store	4($9), $pop29
	i32.load16_u	$push30=, 0($8):p2align=0
	i32.store16	344($9), $pop30
	i32.const	$push31=, 2
	i32.add 	$push32=, $8, $pop31
	i32.load8_u	$push33=, 0($pop32)
	i32.store8	346($9), $pop33
	i32.load8_u	$0=, 344($9)
	i32.const	$push594=, 0
	i32.const	$push593=, 0
	i32.store	bar.lastc($pop594), $pop593
	i32.const	$push592=, 0
	i32.const	$push34=, 3
	i32.store	bar.lastn($pop592), $pop34
	i32.const	$push35=, 24
	i32.ne  	$push36=, $0, $pop35
	br_if   	8, $pop36       # 8: down to label2
# BB#9:                                 # %if.end3.i333.1
	i32.const	$push595=, 0
	i32.const	$push37=, 1
	i32.store	bar.lastc($pop595), $pop37
	i32.load8_u	$push39=, 345($9)
	i32.const	$push38=, 25
	i32.ne  	$push40=, $pop39, $pop38
	br_if   	8, $pop40       # 8: down to label2
# BB#10:                                # %if.end3.i333.2
	i32.const	$push596=, 0
	i32.const	$push41=, 2
	i32.store	bar.lastc($pop596), $pop41
	i32.load8_u	$push43=, 346($9)
	i32.const	$push42=, 26
	i32.ne  	$push44=, $pop43, $pop42
	br_if   	8, $pop44       # 8: down to label2
# BB#11:                                # %if.end3.i347
	i32.const	$push45=, 16
	i32.add 	$push601=, $1, $pop45
	tee_local	$push600=, $8=, $pop601
	i32.store	4($9), $pop600
	i32.const	$push46=, 12
	i32.add 	$push47=, $1, $pop46
	i32.load	$0=, 0($pop47):p2align=0
	i32.const	$push599=, 0
	i32.const	$push48=, 4
	i32.store	bar.lastn($pop599), $pop48
	i32.const	$push598=, 0
	i32.const	$push597=, 0
	i32.store	bar.lastc($pop598), $pop597
	i32.const	$push49=, 255
	i32.and 	$push50=, $0, $pop49
	i32.const	$push51=, 32
	i32.ne  	$push52=, $pop50, $pop51
	br_if   	7, $pop52       # 7: down to label3
# BB#12:                                # %if.end3.i347.1
	i32.const	$push602=, 0
	i32.const	$push53=, 1
	i32.store	bar.lastc($pop602), $pop53
	i32.const	$push54=, 65280
	i32.and 	$push55=, $0, $pop54
	i32.const	$push56=, 8448
	i32.ne  	$push57=, $pop55, $pop56
	br_if   	7, $pop57       # 7: down to label3
# BB#13:                                # %if.end3.i347.2
	i32.const	$push603=, 0
	i32.const	$push58=, 2
	i32.store	bar.lastc($pop603), $pop58
	i32.const	$push59=, 16711680
	i32.and 	$push60=, $0, $pop59
	i32.const	$push61=, 2228224
	i32.ne  	$push62=, $pop60, $pop61
	br_if   	7, $pop62       # 7: down to label3
# BB#14:                                # %if.end3.i347.3
	i32.const	$push604=, 0
	i32.const	$push63=, 3
	i32.store	bar.lastc($pop604), $pop63
	i32.const	$push64=, -16777216
	i32.and 	$push65=, $0, $pop64
	i32.const	$push66=, 587202560
	i32.ne  	$push67=, $pop65, $pop66
	br_if   	7, $pop67       # 7: down to label3
# BB#15:                                # %if.end3.i361
	i32.const	$push68=, 24
	i32.add 	$push609=, $1, $pop68
	tee_local	$push608=, $2=, $pop609
	i32.store	4($9), $pop608
	i32.load	$push69=, 0($8):p2align=0
	i32.store	336($9), $pop69
	i32.const	$push70=, 4
	i32.add 	$push71=, $8, $pop70
	i32.load8_u	$push72=, 0($pop71)
	i32.store8	340($9), $pop72
	i32.load8_u	$0=, 336($9)
	i32.const	$push607=, 0
	i32.const	$push606=, 0
	i32.store	bar.lastc($pop607), $pop606
	i32.const	$push605=, 0
	i32.const	$push73=, 5
	i32.store	bar.lastn($pop605), $pop73
	i32.const	$push74=, 40
	i32.ne  	$push75=, $0, $pop74
	br_if   	6, $pop75       # 6: down to label4
# BB#16:                                # %if.end3.i361.1
	i32.const	$push610=, 0
	i32.const	$push76=, 1
	i32.store	bar.lastc($pop610), $pop76
	i32.load8_u	$push78=, 337($9)
	i32.const	$push77=, 41
	i32.ne  	$push79=, $pop78, $pop77
	br_if   	6, $pop79       # 6: down to label4
# BB#17:                                # %if.end3.i361.2
	i32.const	$push611=, 0
	i32.const	$push80=, 2
	i32.store	bar.lastc($pop611), $pop80
	i32.load8_u	$push82=, 338($9)
	i32.const	$push81=, 42
	i32.ne  	$push83=, $pop82, $pop81
	br_if   	6, $pop83       # 6: down to label4
# BB#18:                                # %if.end3.i361.3
	i32.const	$push612=, 0
	i32.const	$push84=, 3
	i32.store	bar.lastc($pop612), $pop84
	i32.load8_u	$push86=, 339($9)
	i32.const	$push85=, 43
	i32.ne  	$push87=, $pop86, $pop85
	br_if   	6, $pop87       # 6: down to label4
# BB#19:                                # %if.end3.i361.4
	i32.const	$push614=, 0
	i32.const	$push613=, 4
	i32.store	bar.lastc($pop614), $pop613
	i32.load8_u	$push89=, 340($9)
	i32.const	$push88=, 44
	i32.ne  	$push90=, $pop89, $pop88
	br_if   	6, $pop90       # 6: down to label4
# BB#20:                                # %if.end3.i375
	i32.const	$push91=, 32
	i32.add 	$push620=, $1, $pop91
	tee_local	$push619=, $0=, $pop620
	i32.store	4($9), $pop619
	i32.load	$push92=, 0($2):p2align=0
	i32.store	328($9), $pop92
	i32.const	$push618=, 4
	i32.add 	$push93=, $2, $pop618
	i32.load16_u	$push94=, 0($pop93):p2align=0
	i32.store16	332($9), $pop94
	i32.load8_u	$8=, 328($9)
	i32.const	$push617=, 0
	i32.const	$push616=, 0
	i32.store	bar.lastc($pop617), $pop616
	i32.const	$push615=, 0
	i32.const	$push95=, 6
	i32.store	bar.lastn($pop615), $pop95
	i32.const	$push96=, 48
	i32.ne  	$push97=, $8, $pop96
	br_if   	5, $pop97       # 5: down to label5
# BB#21:                                # %if.end3.i375.1
	i32.const	$push621=, 0
	i32.const	$push98=, 1
	i32.store	bar.lastc($pop621), $pop98
	i32.load8_u	$push100=, 329($9)
	i32.const	$push99=, 49
	i32.ne  	$push101=, $pop100, $pop99
	br_if   	5, $pop101      # 5: down to label5
# BB#22:                                # %if.end3.i375.2
	i32.const	$push622=, 0
	i32.const	$push102=, 2
	i32.store	bar.lastc($pop622), $pop102
	i32.load8_u	$push104=, 330($9)
	i32.const	$push103=, 50
	i32.ne  	$push105=, $pop104, $pop103
	br_if   	5, $pop105      # 5: down to label5
# BB#23:                                # %if.end3.i375.3
	i32.const	$push623=, 0
	i32.const	$push106=, 3
	i32.store	bar.lastc($pop623), $pop106
	i32.load8_u	$push108=, 331($9)
	i32.const	$push107=, 51
	i32.ne  	$push109=, $pop108, $pop107
	br_if   	5, $pop109      # 5: down to label5
# BB#24:                                # %if.end3.i375.4
	i32.const	$push624=, 0
	i32.const	$push110=, 4
	i32.store	bar.lastc($pop624), $pop110
	i32.load8_u	$push112=, 332($9)
	i32.const	$push111=, 52
	i32.ne  	$push113=, $pop112, $pop111
	br_if   	5, $pop113      # 5: down to label5
# BB#25:                                # %if.end3.i375.5
	i32.const	$push625=, 0
	i32.const	$push114=, 5
	i32.store	bar.lastc($pop625), $pop114
	i32.load8_u	$push116=, 333($9)
	i32.const	$push115=, 53
	i32.ne  	$push117=, $pop116, $pop115
	br_if   	5, $pop117      # 5: down to label5
# BB#26:                                # %if.end3.i389
	i32.const	$push118=, 40
	i32.add 	$push119=, $1, $pop118
	i32.store	4($9), $pop119
	i32.load	$push120=, 0($0):p2align=0
	i32.store	320($9), $pop120
	i32.const	$push121=, 6
	i32.add 	$push122=, $0, $pop121
	i32.load8_u	$push123=, 0($pop122)
	i32.store8	326($9), $pop123
	i32.const	$push124=, 4
	i32.add 	$push125=, $0, $pop124
	i32.load16_u	$push126=, 0($pop125):p2align=0
	i32.store16	324($9), $pop126
	i32.load8_u	$0=, 320($9)
	i32.const	$push628=, 0
	i32.const	$push627=, 0
	i32.store	bar.lastc($pop628), $pop627
	i32.const	$push626=, 0
	i32.const	$push127=, 7
	i32.store	bar.lastn($pop626), $pop127
	i32.const	$push128=, 56
	i32.ne  	$push129=, $0, $pop128
	br_if   	4, $pop129      # 4: down to label6
# BB#27:                                # %if.end3.i389.1
	i32.const	$push629=, 0
	i32.const	$push130=, 1
	i32.store	bar.lastc($pop629), $pop130
	i32.load8_u	$push132=, 321($9)
	i32.const	$push131=, 57
	i32.ne  	$push133=, $pop132, $pop131
	br_if   	4, $pop133      # 4: down to label6
# BB#28:                                # %if.end3.i389.2
	i32.const	$push630=, 0
	i32.const	$push134=, 2
	i32.store	bar.lastc($pop630), $pop134
	i32.load8_u	$push136=, 322($9)
	i32.const	$push135=, 58
	i32.ne  	$push137=, $pop136, $pop135
	br_if   	4, $pop137      # 4: down to label6
# BB#29:                                # %if.end3.i389.3
	i32.const	$push631=, 0
	i32.const	$push138=, 3
	i32.store	bar.lastc($pop631), $pop138
	i32.load8_u	$push140=, 323($9)
	i32.const	$push139=, 59
	i32.ne  	$push141=, $pop140, $pop139
	br_if   	4, $pop141      # 4: down to label6
# BB#30:                                # %if.end3.i389.4
	i32.const	$push632=, 0
	i32.const	$push142=, 4
	i32.store	bar.lastc($pop632), $pop142
	i32.load8_u	$push144=, 324($9)
	i32.const	$push143=, 60
	i32.ne  	$push145=, $pop144, $pop143
	br_if   	4, $pop145      # 4: down to label6
# BB#31:                                # %if.end3.i389.5
	i32.const	$push633=, 0
	i32.const	$push146=, 5
	i32.store	bar.lastc($pop633), $pop146
	i32.load8_u	$push148=, 325($9)
	i32.const	$push147=, 61
	i32.ne  	$push149=, $pop148, $pop147
	br_if   	4, $pop149      # 4: down to label6
# BB#32:                                # %if.end3.i389.6
	i32.const	$push634=, 0
	i32.const	$push150=, 6
	i32.store	bar.lastc($pop634), $pop150
	i32.load8_u	$push152=, 326($9)
	i32.const	$push151=, 62
	i32.ne  	$push153=, $pop152, $pop151
	br_if   	4, $pop153      # 4: down to label6
# BB#33:                                # %if.end3.i403
	i32.const	$push640=, 0
	i32.const	$push154=, 7
	i32.store	bar.lastc($pop640), $pop154
	i32.const	$push639=, 0
	i32.const	$push155=, 8
	i32.store	bar.lastn($pop639), $pop155
	i32.const	$push156=, 48
	i32.add 	$push638=, $1, $pop156
	tee_local	$push637=, $0=, $pop638
	i32.store	4($9), $pop637
	i32.const	$push157=, 40
	i32.add 	$push158=, $1, $pop157
	i64.load	$push159=, 0($pop158):p2align=0
	i64.store	312($9), $pop159
	i32.const	$push636=, 0
	i32.const	$push635=, 0
	i32.store	bar.lastc($pop636), $pop635
	i32.load8_s	$push161=, 312($9)
	i32.const	$push160=, 64
	i32.ne  	$push162=, $pop161, $pop160
	br_if   	3, $pop162      # 3: down to label7
# BB#34:                                # %if.end3.i403.1
	i32.const	$push642=, 0
	i32.const	$push641=, 1
	i32.store	bar.lastc($pop642), $pop641
	i32.load8_s	$push164=, 313($9)
	i32.const	$push163=, 65
	i32.ne  	$push165=, $pop164, $pop163
	br_if   	3, $pop165      # 3: down to label7
# BB#35:                                # %if.end3.i403.2
	i32.const	$push648=, 0
	i32.const	$push647=, 1
	i32.const	$push646=, 1
	i32.add 	$push645=, $pop647, $pop646
	tee_local	$push644=, $8=, $pop645
	i32.store	bar.lastc($pop648), $pop644
	i32.const	$push643=, 64
	i32.or  	$push166=, $8, $pop643
	i32.load8_s	$push167=, 314($9)
	i32.ne  	$push168=, $pop166, $pop167
	br_if   	3, $pop168      # 3: down to label7
# BB#36:                                # %if.end3.i403.3
	i32.const	$push655=, 0
	i32.const	$push654=, 1
	i32.add 	$push653=, $8, $pop654
	tee_local	$push652=, $8=, $pop653
	i32.store	bar.lastc($pop655), $pop652
	i32.const	$push651=, 24
	i32.shl 	$push169=, $8, $pop651
	i32.const	$push650=, 24
	i32.shr_s	$push170=, $pop169, $pop650
	i32.const	$push649=, 64
	i32.xor 	$push171=, $pop170, $pop649
	i32.load8_s	$push172=, 315($9)
	i32.ne  	$push173=, $pop171, $pop172
	br_if   	3, $pop173      # 3: down to label7
# BB#37:                                # %if.end3.i403.4
	i32.const	$push662=, 0
	i32.const	$push661=, 1
	i32.add 	$push660=, $8, $pop661
	tee_local	$push659=, $8=, $pop660
	i32.store	bar.lastc($pop662), $pop659
	i32.const	$push658=, 24
	i32.shl 	$push174=, $8, $pop658
	i32.const	$push657=, 24
	i32.shr_s	$push175=, $pop174, $pop657
	i32.const	$push656=, 64
	i32.xor 	$push176=, $pop175, $pop656
	i32.load8_s	$push177=, 316($9)
	i32.ne  	$push178=, $pop176, $pop177
	br_if   	3, $pop178      # 3: down to label7
# BB#38:                                # %if.end3.i403.5
	i32.const	$push669=, 0
	i32.const	$push668=, 1
	i32.add 	$push667=, $8, $pop668
	tee_local	$push666=, $8=, $pop667
	i32.store	bar.lastc($pop669), $pop666
	i32.const	$push665=, 24
	i32.shl 	$push179=, $8, $pop665
	i32.const	$push664=, 24
	i32.shr_s	$push180=, $pop179, $pop664
	i32.const	$push663=, 64
	i32.xor 	$push181=, $pop180, $pop663
	i32.load8_s	$push182=, 317($9)
	i32.ne  	$push183=, $pop181, $pop182
	br_if   	3, $pop183      # 3: down to label7
# BB#39:                                # %if.end3.i403.6
	i32.const	$push676=, 0
	i32.const	$push675=, 1
	i32.add 	$push674=, $8, $pop675
	tee_local	$push673=, $8=, $pop674
	i32.store	bar.lastc($pop676), $pop673
	i32.const	$push672=, 24
	i32.shl 	$push184=, $8, $pop672
	i32.const	$push671=, 24
	i32.shr_s	$push185=, $pop184, $pop671
	i32.const	$push670=, 64
	i32.xor 	$push186=, $pop185, $pop670
	i32.load8_s	$push187=, 318($9)
	i32.ne  	$push188=, $pop186, $pop187
	br_if   	3, $pop188      # 3: down to label7
# BB#40:                                # %if.end3.i403.7
	i32.const	$push682=, 0
	i32.const	$push681=, 1
	i32.add 	$push680=, $8, $pop681
	tee_local	$push679=, $8=, $pop680
	i32.store	bar.lastc($pop682), $pop679
	i32.const	$push189=, 24
	i32.shl 	$push190=, $8, $pop189
	i32.const	$push678=, 24
	i32.shr_s	$push191=, $pop190, $pop678
	i32.const	$push677=, 64
	i32.xor 	$push192=, $pop191, $pop677
	i32.load8_s	$push193=, 319($9)
	i32.ne  	$push194=, $pop192, $pop193
	br_if   	3, $pop194      # 3: down to label7
# BB#41:                                # %for.body104
	i32.const	$push195=, 0
	i32.const	$push690=, 1
	i32.add 	$push689=, $8, $pop690
	tee_local	$push688=, $2=, $pop689
	i32.store	bar.lastc($pop195), $pop688
	i32.const	$8=, 8
	i32.const	$push508=, 296
	i32.add 	$push509=, $9, $pop508
	i32.const	$push687=, 8
	i32.add 	$push198=, $pop509, $pop687
	i32.const	$push686=, 8
	i32.add 	$push196=, $0, $pop686
	i32.load8_u	$push197=, 0($pop196)
	i32.store8	0($pop198), $pop197
	i32.const	$push199=, 60
	i32.add 	$push685=, $1, $pop199
	tee_local	$push684=, $7=, $pop685
	i32.store	4($9), $pop684
	i32.load	$push200=, 0($0):p2align=0
	i32.store	296($9), $pop200
	i32.const	$push201=, 4
	i32.add 	$push202=, $0, $pop201
	i32.load	$push203=, 0($pop202):p2align=0
	i32.store	300($9), $pop203
	i32.load8_s	$0=, 296($9)
	block   	
	i32.const	$push683=, 0
	br_if   	0, $pop683      # 0: down to label12
# BB#42:                                # %if.then.i410
	i32.const	$push204=, 8
	i32.ne  	$push205=, $2, $pop204
	br_if   	1, $pop205      # 1: down to label10
# BB#43:                                # %if.end.i412
	i32.const	$8=, 9
	i32.const	$2=, 0
	i32.const	$push694=, 0
	i32.const	$push693=, 9
	i32.store	bar.lastn($pop694), $pop693
	i32.const	$push692=, 0
	i32.const	$push691=, 0
	i32.store	bar.lastc($pop692), $pop691
.LBB1_44:                               # %if.end3.i417
	end_block                       # label12:
	i32.const	$push697=, 24
	i32.shl 	$push206=, $2, $pop697
	i32.const	$push696=, 24
	i32.shr_s	$push207=, $pop206, $pop696
	i32.const	$push695=, 72
	i32.xor 	$push208=, $pop207, $pop695
	i32.ne  	$push209=, $pop208, $0
	br_if   	2, $pop209      # 2: down to label8
# BB#45:                                # %if.end3.i417.1
	i32.const	$push704=, 0
	i32.const	$push703=, 1
	i32.add 	$push702=, $2, $pop703
	tee_local	$push701=, $0=, $pop702
	i32.store	bar.lastc($pop704), $pop701
	i32.const	$push700=, 24
	i32.shl 	$push210=, $0, $pop700
	i32.const	$push699=, 24
	i32.shr_s	$push211=, $pop210, $pop699
	i32.const	$push698=, 72
	i32.xor 	$push212=, $pop211, $pop698
	i32.load8_s	$push213=, 297($9)
	i32.ne  	$push214=, $pop212, $pop213
	br_if   	2, $pop214      # 2: down to label8
# BB#46:                                # %if.end3.i417.2
	i32.const	$push711=, 0
	i32.const	$push710=, 1
	i32.add 	$push709=, $0, $pop710
	tee_local	$push708=, $0=, $pop709
	i32.store	bar.lastc($pop711), $pop708
	i32.const	$push707=, 24
	i32.shl 	$push215=, $0, $pop707
	i32.const	$push706=, 24
	i32.shr_s	$push216=, $pop215, $pop706
	i32.const	$push705=, 72
	i32.xor 	$push217=, $pop216, $pop705
	i32.load8_s	$push218=, 298($9)
	i32.ne  	$push219=, $pop217, $pop218
	br_if   	2, $pop219      # 2: down to label8
# BB#47:                                # %if.end3.i417.3
	i32.const	$push718=, 0
	i32.const	$push717=, 1
	i32.add 	$push716=, $0, $pop717
	tee_local	$push715=, $0=, $pop716
	i32.store	bar.lastc($pop718), $pop715
	i32.const	$push714=, 24
	i32.shl 	$push220=, $0, $pop714
	i32.const	$push713=, 24
	i32.shr_s	$push221=, $pop220, $pop713
	i32.const	$push712=, 72
	i32.xor 	$push222=, $pop221, $pop712
	i32.load8_s	$push223=, 299($9)
	i32.ne  	$push224=, $pop222, $pop223
	br_if   	2, $pop224      # 2: down to label8
# BB#48:                                # %if.end3.i417.4
	i32.const	$push725=, 0
	i32.const	$push724=, 1
	i32.add 	$push723=, $0, $pop724
	tee_local	$push722=, $0=, $pop723
	i32.store	bar.lastc($pop725), $pop722
	i32.const	$push721=, 24
	i32.shl 	$push225=, $0, $pop721
	i32.const	$push720=, 24
	i32.shr_s	$push226=, $pop225, $pop720
	i32.const	$push719=, 72
	i32.xor 	$push227=, $pop226, $pop719
	i32.load8_s	$push228=, 300($9)
	i32.ne  	$push229=, $pop227, $pop228
	br_if   	2, $pop229      # 2: down to label8
# BB#49:                                # %if.end3.i417.5
	i32.const	$push732=, 0
	i32.const	$push731=, 1
	i32.add 	$push730=, $0, $pop731
	tee_local	$push729=, $0=, $pop730
	i32.store	bar.lastc($pop732), $pop729
	i32.const	$push728=, 24
	i32.shl 	$push230=, $0, $pop728
	i32.const	$push727=, 24
	i32.shr_s	$push231=, $pop230, $pop727
	i32.const	$push726=, 72
	i32.xor 	$push232=, $pop231, $pop726
	i32.load8_s	$push233=, 301($9)
	i32.ne  	$push234=, $pop232, $pop233
	br_if   	2, $pop234      # 2: down to label8
# BB#50:                                # %if.end3.i417.6
	i32.const	$push739=, 0
	i32.const	$push738=, 1
	i32.add 	$push737=, $0, $pop738
	tee_local	$push736=, $0=, $pop737
	i32.store	bar.lastc($pop739), $pop736
	i32.const	$push735=, 24
	i32.shl 	$push235=, $0, $pop735
	i32.const	$push734=, 24
	i32.shr_s	$push236=, $pop235, $pop734
	i32.const	$push733=, 72
	i32.xor 	$push237=, $pop236, $pop733
	i32.load8_s	$push238=, 302($9)
	i32.ne  	$push239=, $pop237, $pop238
	br_if   	2, $pop239      # 2: down to label8
# BB#51:                                # %if.end3.i417.7
	i32.const	$push746=, 0
	i32.const	$push745=, 1
	i32.add 	$push744=, $0, $pop745
	tee_local	$push743=, $0=, $pop744
	i32.store	bar.lastc($pop746), $pop743
	i32.const	$push742=, 24
	i32.shl 	$push240=, $0, $pop742
	i32.const	$push741=, 24
	i32.shr_s	$push241=, $pop240, $pop741
	i32.const	$push740=, 72
	i32.xor 	$push242=, $pop241, $pop740
	i32.load8_s	$push243=, 303($9)
	i32.ne  	$push244=, $pop242, $pop243
	br_if   	2, $pop244      # 2: down to label8
# BB#52:                                # %if.end3.i417.8
	i32.const	$push752=, 0
	i32.const	$push751=, 1
	i32.add 	$push750=, $0, $pop751
	tee_local	$push749=, $0=, $pop750
	i32.store	bar.lastc($pop752), $pop749
	i32.const	$push245=, 24
	i32.shl 	$push246=, $0, $pop245
	i32.const	$push748=, 24
	i32.shr_s	$push247=, $pop246, $pop748
	i32.const	$push747=, 72
	i32.xor 	$push248=, $pop247, $pop747
	i32.load8_s	$push249=, 304($9)
	i32.ne  	$push250=, $pop248, $pop249
	br_if   	2, $pop250      # 2: down to label8
# BB#53:                                # %for.body116
	i32.const	$push252=, 0
	i32.const	$push251=, 1
	i32.add 	$push758=, $0, $pop251
	tee_local	$push757=, $0=, $pop758
	i32.store	bar.lastc($pop252), $pop757
	i32.const	$push510=, 280
	i32.add 	$push511=, $9, $pop510
	i32.const	$push253=, 8
	i32.add 	$push256=, $pop511, $pop253
	i32.const	$push756=, 8
	i32.add 	$push254=, $7, $pop756
	i32.load16_u	$push255=, 0($pop254):p2align=0
	i32.store16	0($pop256), $pop255
	i32.const	$push755=, 72
	i32.add 	$push754=, $1, $pop755
	tee_local	$push753=, $2=, $pop754
	i32.store	4($9), $pop753
	i32.load	$push257=, 0($7):p2align=0
	i32.store	280($9), $pop257
	i32.const	$push258=, 4
	i32.add 	$push259=, $7, $pop258
	i32.load	$push260=, 0($pop259):p2align=0
	i32.store	284($9), $pop260
	i32.load8_s	$7=, 280($9)
	block   	
	i32.const	$push261=, 10
	i32.eq  	$push262=, $8, $pop261
	br_if   	0, $pop262      # 0: down to label13
# BB#54:                                # %if.then.i424
	i32.ne  	$push263=, $0, $8
	br_if   	1, $pop263      # 1: down to label10
# BB#55:                                # %if.end.i426
	i32.const	$8=, 10
	i32.const	$0=, 0
	i32.const	$push762=, 0
	i32.const	$push761=, 10
	i32.store	bar.lastn($pop762), $pop761
	i32.const	$push760=, 0
	i32.const	$push759=, 0
	i32.store	bar.lastc($pop760), $pop759
.LBB1_56:                               # %if.end3.i431
	end_block                       # label13:
	i32.const	$push765=, 24
	i32.shl 	$push264=, $0, $pop765
	i32.const	$push764=, 24
	i32.shr_s	$push265=, $pop264, $pop764
	i32.const	$push763=, 80
	i32.xor 	$push266=, $pop265, $pop763
	i32.ne  	$push267=, $pop266, $7
	br_if   	1, $pop267      # 1: down to label9
# BB#57:                                # %if.end3.i431.1
	i32.const	$push772=, 0
	i32.const	$push771=, 1
	i32.add 	$push770=, $0, $pop771
	tee_local	$push769=, $0=, $pop770
	i32.store	bar.lastc($pop772), $pop769
	i32.const	$push768=, 24
	i32.shl 	$push268=, $0, $pop768
	i32.const	$push767=, 24
	i32.shr_s	$push269=, $pop268, $pop767
	i32.const	$push766=, 80
	i32.xor 	$push270=, $pop269, $pop766
	i32.load8_s	$push271=, 281($9)
	i32.ne  	$push272=, $pop270, $pop271
	br_if   	1, $pop272      # 1: down to label9
# BB#58:                                # %if.end3.i431.2
	i32.const	$push779=, 0
	i32.const	$push778=, 1
	i32.add 	$push777=, $0, $pop778
	tee_local	$push776=, $0=, $pop777
	i32.store	bar.lastc($pop779), $pop776
	i32.const	$push775=, 24
	i32.shl 	$push273=, $0, $pop775
	i32.const	$push774=, 24
	i32.shr_s	$push274=, $pop273, $pop774
	i32.const	$push773=, 80
	i32.xor 	$push275=, $pop274, $pop773
	i32.load8_s	$push276=, 282($9)
	i32.ne  	$push277=, $pop275, $pop276
	br_if   	1, $pop277      # 1: down to label9
# BB#59:                                # %if.end3.i431.3
	i32.const	$push786=, 0
	i32.const	$push785=, 1
	i32.add 	$push784=, $0, $pop785
	tee_local	$push783=, $0=, $pop784
	i32.store	bar.lastc($pop786), $pop783
	i32.const	$push782=, 24
	i32.shl 	$push278=, $0, $pop782
	i32.const	$push781=, 24
	i32.shr_s	$push279=, $pop278, $pop781
	i32.const	$push780=, 80
	i32.xor 	$push280=, $pop279, $pop780
	i32.load8_s	$push281=, 283($9)
	i32.ne  	$push282=, $pop280, $pop281
	br_if   	1, $pop282      # 1: down to label9
# BB#60:                                # %if.end3.i431.4
	i32.const	$push793=, 0
	i32.const	$push792=, 1
	i32.add 	$push791=, $0, $pop792
	tee_local	$push790=, $0=, $pop791
	i32.store	bar.lastc($pop793), $pop790
	i32.const	$push789=, 24
	i32.shl 	$push283=, $0, $pop789
	i32.const	$push788=, 24
	i32.shr_s	$push284=, $pop283, $pop788
	i32.const	$push787=, 80
	i32.xor 	$push285=, $pop284, $pop787
	i32.load8_s	$push286=, 284($9)
	i32.ne  	$push287=, $pop285, $pop286
	br_if   	1, $pop287      # 1: down to label9
# BB#61:                                # %if.end3.i431.5
	i32.const	$push800=, 0
	i32.const	$push799=, 1
	i32.add 	$push798=, $0, $pop799
	tee_local	$push797=, $0=, $pop798
	i32.store	bar.lastc($pop800), $pop797
	i32.const	$push796=, 24
	i32.shl 	$push288=, $0, $pop796
	i32.const	$push795=, 24
	i32.shr_s	$push289=, $pop288, $pop795
	i32.const	$push794=, 80
	i32.xor 	$push290=, $pop289, $pop794
	i32.load8_s	$push291=, 285($9)
	i32.ne  	$push292=, $pop290, $pop291
	br_if   	1, $pop292      # 1: down to label9
# BB#62:                                # %if.end3.i431.6
	i32.const	$push807=, 0
	i32.const	$push806=, 1
	i32.add 	$push805=, $0, $pop806
	tee_local	$push804=, $0=, $pop805
	i32.store	bar.lastc($pop807), $pop804
	i32.const	$push803=, 24
	i32.shl 	$push293=, $0, $pop803
	i32.const	$push802=, 24
	i32.shr_s	$push294=, $pop293, $pop802
	i32.const	$push801=, 80
	i32.xor 	$push295=, $pop294, $pop801
	i32.load8_s	$push296=, 286($9)
	i32.ne  	$push297=, $pop295, $pop296
	br_if   	1, $pop297      # 1: down to label9
# BB#63:                                # %if.end3.i431.7
	i32.const	$push814=, 0
	i32.const	$push813=, 1
	i32.add 	$push812=, $0, $pop813
	tee_local	$push811=, $0=, $pop812
	i32.store	bar.lastc($pop814), $pop811
	i32.const	$push810=, 24
	i32.shl 	$push298=, $0, $pop810
	i32.const	$push809=, 24
	i32.shr_s	$push299=, $pop298, $pop809
	i32.const	$push808=, 80
	i32.xor 	$push300=, $pop299, $pop808
	i32.load8_s	$push301=, 287($9)
	i32.ne  	$push302=, $pop300, $pop301
	br_if   	1, $pop302      # 1: down to label9
# BB#64:                                # %if.end3.i431.8
	i32.const	$push821=, 0
	i32.const	$push820=, 1
	i32.add 	$push819=, $0, $pop820
	tee_local	$push818=, $0=, $pop819
	i32.store	bar.lastc($pop821), $pop818
	i32.const	$push817=, 24
	i32.shl 	$push303=, $0, $pop817
	i32.const	$push816=, 24
	i32.shr_s	$push304=, $pop303, $pop816
	i32.const	$push815=, 80
	i32.xor 	$push305=, $pop304, $pop815
	i32.load8_s	$push306=, 288($9)
	i32.ne  	$push307=, $pop305, $pop306
	br_if   	1, $pop307      # 1: down to label9
# BB#65:                                # %if.end3.i431.9
	i32.const	$push828=, 0
	i32.const	$push827=, 1
	i32.add 	$push826=, $0, $pop827
	tee_local	$push825=, $0=, $pop826
	i32.store	bar.lastc($pop828), $pop825
	i32.const	$push824=, 24
	i32.shl 	$push308=, $0, $pop824
	i32.const	$push823=, 24
	i32.shr_s	$push309=, $pop308, $pop823
	i32.const	$push822=, 80
	i32.xor 	$push310=, $pop309, $pop822
	i32.load8_s	$push311=, 289($9)
	i32.ne  	$push312=, $pop310, $pop311
	br_if   	1, $pop312      # 1: down to label9
# BB#66:                                # %bar.exit434.9
	i32.const	$push836=, 0
	i32.const	$push835=, 1
	i32.add 	$push834=, $0, $pop835
	tee_local	$push833=, $0=, $pop834
	i32.store	bar.lastc($pop836), $pop833
	i32.const	$push512=, 264
	i32.add 	$push513=, $9, $pop512
	i32.const	$push313=, 10
	i32.add 	$push316=, $pop513, $pop313
	i32.const	$push832=, 10
	i32.add 	$push314=, $2, $pop832
	i32.load8_u	$push315=, 0($pop314)
	i32.store8	0($pop316), $pop315
	i32.const	$push514=, 264
	i32.add 	$push515=, $9, $pop514
	i32.const	$push317=, 8
	i32.add 	$push320=, $pop515, $pop317
	i32.const	$push831=, 8
	i32.add 	$push318=, $2, $pop831
	i32.load16_u	$push319=, 0($pop318):p2align=0
	i32.store16	0($pop320), $pop319
	i32.const	$push321=, 84
	i32.add 	$push830=, $1, $pop321
	tee_local	$push829=, $4=, $pop830
	i32.store	4($9), $pop829
	i32.const	$push322=, 4
	i32.add 	$push323=, $2, $pop322
	i32.load	$push324=, 0($pop323):p2align=0
	i32.store	268($9), $pop324
	i32.load	$push325=, 0($2):p2align=0
	i32.store	264($9), $pop325
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_67:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push516=, 264
	i32.add 	$push517=, $9, $pop516
	i32.add 	$push327=, $pop517, $2
	i32.load8_s	$3=, 0($pop327)
	block   	
	i32.const	$push837=, 11
	i32.eq  	$push326=, $7, $pop837
	br_if   	0, $pop326      # 0: down to label15
# BB#68:                                # %if.then.i438
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.ne  	$push328=, $0, $7
	br_if   	2, $pop328      # 2: down to label10
# BB#69:                                # %if.end.i440
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$8=, 11
	i32.const	$0=, 0
	i32.const	$push841=, 0
	i32.const	$push840=, 11
	i32.store	bar.lastn($pop841), $pop840
	i32.const	$push839=, 0
	i32.const	$push838=, 0
	i32.store	bar.lastc($pop839), $pop838
.LBB1_70:                               # %if.end3.i445
                                        #   in Loop: Header=BB1_67 Depth=1
	end_block                       # label15:
	i32.const	$push844=, 24
	i32.shl 	$push329=, $0, $pop844
	i32.const	$push843=, 24
	i32.shr_s	$push330=, $pop329, $pop843
	i32.const	$push842=, 88
	i32.xor 	$push331=, $pop330, $pop842
	i32.ne  	$push332=, $pop331, $3
	br_if   	1, $pop332      # 1: down to label10
# BB#71:                                # %bar.exit448
                                        #   in Loop: Header=BB1_67 Depth=1
	i32.const	$push852=, 0
	i32.const	$push851=, 1
	i32.add 	$push850=, $0, $pop851
	tee_local	$push849=, $0=, $pop850
	i32.store	bar.lastc($pop852), $pop849
	i32.const	$7=, 11
	i32.const	$push848=, 1
	i32.add 	$push847=, $2, $pop848
	tee_local	$push846=, $2=, $pop847
	i32.const	$push845=, 11
	i32.lt_s	$push333=, $pop846, $pop845
	br_if   	0, $pop333      # 0: up to label14
# BB#72:                                # %for.end134
	end_loop
	i32.const	$push518=, 248
	i32.add 	$push519=, $9, $pop518
	i32.const	$push334=, 8
	i32.add 	$push337=, $pop519, $pop334
	i32.const	$push856=, 8
	i32.add 	$push335=, $4, $pop856
	i32.load	$push336=, 0($pop335):p2align=0
	i32.store	0($pop337), $pop336
	i32.const	$push855=, 96
	i32.add 	$push854=, $1, $pop855
	tee_local	$push853=, $6=, $pop854
	i32.store	4($9), $pop853
	i32.const	$push338=, 4
	i32.add 	$push339=, $4, $pop338
	i32.load	$push340=, 0($pop339):p2align=0
	i32.store	252($9), $pop340
	i32.load	$push341=, 0($4):p2align=0
	i32.store	248($9), $pop341
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_73:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push520=, 248
	i32.add 	$push521=, $9, $pop520
	i32.add 	$push343=, $pop521, $2
	i32.load8_s	$3=, 0($pop343)
	block   	
	i32.const	$push857=, 12
	i32.eq  	$push342=, $7, $pop857
	br_if   	0, $pop342      # 0: down to label17
# BB#74:                                # %if.then.i452
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.ne  	$push344=, $0, $7
	br_if   	2, $pop344      # 2: down to label10
# BB#75:                                # %if.end.i454
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$8=, 12
	i32.const	$0=, 0
	i32.const	$push861=, 0
	i32.const	$push860=, 12
	i32.store	bar.lastn($pop861), $pop860
	i32.const	$push859=, 0
	i32.const	$push858=, 0
	i32.store	bar.lastc($pop859), $pop858
.LBB1_76:                               # %if.end3.i459
                                        #   in Loop: Header=BB1_73 Depth=1
	end_block                       # label17:
	i32.const	$push864=, 24
	i32.shl 	$push345=, $0, $pop864
	i32.const	$push863=, 24
	i32.shr_s	$push346=, $pop345, $pop863
	i32.const	$push862=, 96
	i32.xor 	$push347=, $pop346, $pop862
	i32.ne  	$push348=, $pop347, $3
	br_if   	1, $pop348      # 1: down to label10
# BB#77:                                # %bar.exit462
                                        #   in Loop: Header=BB1_73 Depth=1
	i32.const	$push872=, 0
	i32.const	$push871=, 1
	i32.add 	$push870=, $0, $pop871
	tee_local	$push869=, $0=, $pop870
	i32.store	bar.lastc($pop872), $pop869
	i32.const	$7=, 12
	i32.const	$push868=, 1
	i32.add 	$push867=, $2, $pop868
	tee_local	$push866=, $2=, $pop867
	i32.const	$push865=, 12
	i32.lt_s	$push349=, $pop866, $pop865
	br_if   	0, $pop349      # 0: up to label16
# BB#78:                                # %for.end146
	end_loop
	i32.const	$push522=, 232
	i32.add 	$push523=, $9, $pop522
	i32.const	$push350=, 12
	i32.add 	$push353=, $pop523, $pop350
	i32.const	$push876=, 12
	i32.add 	$push351=, $6, $pop876
	i32.load8_u	$push352=, 0($pop351)
	i32.store8	0($pop353), $pop352
	i32.const	$push524=, 232
	i32.add 	$push525=, $9, $pop524
	i32.const	$push354=, 8
	i32.add 	$push357=, $pop525, $pop354
	i32.const	$push875=, 8
	i32.add 	$push355=, $6, $pop875
	i32.load	$push356=, 0($pop355):p2align=0
	i32.store	0($pop357), $pop356
	i32.const	$push358=, 112
	i32.add 	$push874=, $1, $pop358
	tee_local	$push873=, $4=, $pop874
	i32.store	4($9), $pop873
	i32.const	$push359=, 4
	i32.add 	$push360=, $6, $pop359
	i32.load	$push361=, 0($pop360):p2align=0
	i32.store	236($9), $pop361
	i32.load	$push362=, 0($6):p2align=0
	i32.store	232($9), $pop362
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_79:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push526=, 232
	i32.add 	$push527=, $9, $pop526
	i32.add 	$push364=, $pop527, $2
	i32.load8_s	$3=, 0($pop364)
	block   	
	i32.const	$push877=, 13
	i32.eq  	$push363=, $7, $pop877
	br_if   	0, $pop363      # 0: down to label19
# BB#80:                                # %if.then.i466
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.ne  	$push365=, $0, $7
	br_if   	2, $pop365      # 2: down to label10
# BB#81:                                # %if.end.i468
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$8=, 13
	i32.const	$0=, 0
	i32.const	$push881=, 0
	i32.const	$push880=, 13
	i32.store	bar.lastn($pop881), $pop880
	i32.const	$push879=, 0
	i32.const	$push878=, 0
	i32.store	bar.lastc($pop879), $pop878
.LBB1_82:                               # %if.end3.i473
                                        #   in Loop: Header=BB1_79 Depth=1
	end_block                       # label19:
	i32.const	$push884=, 24
	i32.shl 	$push366=, $0, $pop884
	i32.const	$push883=, 24
	i32.shr_s	$push367=, $pop366, $pop883
	i32.const	$push882=, 104
	i32.xor 	$push368=, $pop367, $pop882
	i32.ne  	$push369=, $pop368, $3
	br_if   	1, $pop369      # 1: down to label10
# BB#83:                                # %bar.exit476
                                        #   in Loop: Header=BB1_79 Depth=1
	i32.const	$push892=, 0
	i32.const	$push891=, 1
	i32.add 	$push890=, $0, $pop891
	tee_local	$push889=, $0=, $pop890
	i32.store	bar.lastc($pop892), $pop889
	i32.const	$7=, 13
	i32.const	$push888=, 1
	i32.add 	$push887=, $2, $pop888
	tee_local	$push886=, $2=, $pop887
	i32.const	$push885=, 13
	i32.lt_s	$push370=, $pop886, $pop885
	br_if   	0, $pop370      # 0: up to label18
# BB#84:                                # %for.end158
	end_loop
	i32.const	$push528=, 216
	i32.add 	$push529=, $9, $pop528
	i32.const	$push371=, 12
	i32.add 	$push374=, $pop529, $pop371
	i32.const	$push896=, 12
	i32.add 	$push372=, $4, $pop896
	i32.load16_u	$push373=, 0($pop372):p2align=0
	i32.store16	0($pop374), $pop373
	i32.const	$push530=, 216
	i32.add 	$push531=, $9, $pop530
	i32.const	$push375=, 8
	i32.add 	$push378=, $pop531, $pop375
	i32.const	$push895=, 8
	i32.add 	$push376=, $4, $pop895
	i32.load	$push377=, 0($pop376):p2align=0
	i32.store	0($pop378), $pop377
	i32.const	$push379=, 128
	i32.add 	$push894=, $1, $pop379
	tee_local	$push893=, $6=, $pop894
	i32.store	4($9), $pop893
	i32.const	$push380=, 4
	i32.add 	$push381=, $4, $pop380
	i32.load	$push382=, 0($pop381):p2align=0
	i32.store	220($9), $pop382
	i32.load	$push383=, 0($4):p2align=0
	i32.store	216($9), $pop383
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_85:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push532=, 216
	i32.add 	$push533=, $9, $pop532
	i32.add 	$push385=, $pop533, $2
	i32.load8_s	$3=, 0($pop385)
	block   	
	i32.const	$push897=, 14
	i32.eq  	$push384=, $7, $pop897
	br_if   	0, $pop384      # 0: down to label21
# BB#86:                                # %if.then.i480
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.ne  	$push386=, $0, $7
	br_if   	2, $pop386      # 2: down to label10
# BB#87:                                # %if.end.i482
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$8=, 14
	i32.const	$0=, 0
	i32.const	$push901=, 0
	i32.const	$push900=, 14
	i32.store	bar.lastn($pop901), $pop900
	i32.const	$push899=, 0
	i32.const	$push898=, 0
	i32.store	bar.lastc($pop899), $pop898
.LBB1_88:                               # %if.end3.i487
                                        #   in Loop: Header=BB1_85 Depth=1
	end_block                       # label21:
	i32.const	$push904=, 24
	i32.shl 	$push387=, $0, $pop904
	i32.const	$push903=, 24
	i32.shr_s	$push388=, $pop387, $pop903
	i32.const	$push902=, 112
	i32.xor 	$push389=, $pop388, $pop902
	i32.ne  	$push390=, $pop389, $3
	br_if   	1, $pop390      # 1: down to label10
# BB#89:                                # %bar.exit490
                                        #   in Loop: Header=BB1_85 Depth=1
	i32.const	$push912=, 0
	i32.const	$push911=, 1
	i32.add 	$push910=, $0, $pop911
	tee_local	$push909=, $0=, $pop910
	i32.store	bar.lastc($pop912), $pop909
	i32.const	$7=, 14
	i32.const	$push908=, 1
	i32.add 	$push907=, $2, $pop908
	tee_local	$push906=, $2=, $pop907
	i32.const	$push905=, 14
	i32.lt_s	$push391=, $pop906, $pop905
	br_if   	0, $pop391      # 0: up to label20
# BB#90:                                # %for.end170
	end_loop
	i32.const	$push534=, 200
	i32.add 	$push535=, $9, $pop534
	i32.const	$push392=, 14
	i32.add 	$push395=, $pop535, $pop392
	i32.const	$push917=, 14
	i32.add 	$push393=, $6, $pop917
	i32.load8_u	$push394=, 0($pop393)
	i32.store8	0($pop395), $pop394
	i32.const	$push536=, 200
	i32.add 	$push537=, $9, $pop536
	i32.const	$push396=, 12
	i32.add 	$push399=, $pop537, $pop396
	i32.const	$push916=, 12
	i32.add 	$push397=, $6, $pop916
	i32.load16_u	$push398=, 0($pop397):p2align=0
	i32.store16	0($pop399), $pop398
	i32.const	$push538=, 200
	i32.add 	$push539=, $9, $pop538
	i32.const	$push400=, 8
	i32.add 	$push403=, $pop539, $pop400
	i32.const	$push915=, 8
	i32.add 	$push401=, $6, $pop915
	i32.load	$push402=, 0($pop401):p2align=0
	i32.store	0($pop403), $pop402
	i32.const	$push404=, 144
	i32.add 	$push914=, $1, $pop404
	tee_local	$push913=, $4=, $pop914
	i32.store	4($9), $pop913
	i32.const	$push405=, 4
	i32.add 	$push406=, $6, $pop405
	i32.load	$push407=, 0($pop406):p2align=0
	i32.store	204($9), $pop407
	i32.load	$push408=, 0($6):p2align=0
	i32.store	200($9), $pop408
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_91:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label22:
	i32.const	$push540=, 200
	i32.add 	$push541=, $9, $pop540
	i32.add 	$push410=, $pop541, $2
	i32.load8_s	$3=, 0($pop410)
	block   	
	i32.const	$push918=, 15
	i32.eq  	$push409=, $7, $pop918
	br_if   	0, $pop409      # 0: down to label23
# BB#92:                                # %if.then.i494
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.ne  	$push411=, $0, $7
	br_if   	2, $pop411      # 2: down to label10
# BB#93:                                # %if.end.i496
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$8=, 15
	i32.const	$0=, 0
	i32.const	$push922=, 0
	i32.const	$push921=, 15
	i32.store	bar.lastn($pop922), $pop921
	i32.const	$push920=, 0
	i32.const	$push919=, 0
	i32.store	bar.lastc($pop920), $pop919
.LBB1_94:                               # %if.end3.i501
                                        #   in Loop: Header=BB1_91 Depth=1
	end_block                       # label23:
	i32.const	$push925=, 24
	i32.shl 	$push412=, $0, $pop925
	i32.const	$push924=, 24
	i32.shr_s	$push413=, $pop412, $pop924
	i32.const	$push923=, 120
	i32.xor 	$push414=, $pop413, $pop923
	i32.ne  	$push415=, $pop414, $3
	br_if   	1, $pop415      # 1: down to label10
# BB#95:                                # %bar.exit504
                                        #   in Loop: Header=BB1_91 Depth=1
	i32.const	$push933=, 0
	i32.const	$push932=, 1
	i32.add 	$push931=, $0, $pop932
	tee_local	$push930=, $0=, $pop931
	i32.store	bar.lastc($pop933), $pop930
	i32.const	$7=, 15
	i32.const	$push929=, 1
	i32.add 	$push928=, $2, $pop929
	tee_local	$push927=, $2=, $pop928
	i32.const	$push926=, 15
	i32.lt_s	$push416=, $pop927, $pop926
	br_if   	0, $pop416      # 0: up to label22
# BB#96:                                # %for.end182
	end_loop
	i32.const	$push542=, 184
	i32.add 	$push543=, $9, $pop542
	i32.const	$push417=, 12
	i32.add 	$push420=, $pop543, $pop417
	i32.const	$push937=, 12
	i32.add 	$push418=, $4, $pop937
	i32.load	$push419=, 0($pop418):p2align=0
	i32.store	0($pop420), $pop419
	i32.const	$push544=, 184
	i32.add 	$push545=, $9, $pop544
	i32.const	$push421=, 8
	i32.add 	$push424=, $pop545, $pop421
	i32.const	$push936=, 8
	i32.add 	$push422=, $4, $pop936
	i32.load	$push423=, 0($pop422):p2align=0
	i32.store	0($pop424), $pop423
	i32.const	$push425=, 160
	i32.add 	$push935=, $1, $pop425
	tee_local	$push934=, $5=, $pop935
	i32.store	4($9), $pop934
	i32.const	$push426=, 4
	i32.add 	$push427=, $4, $pop426
	i32.load	$push428=, 0($pop427):p2align=0
	i32.store	188($9), $pop428
	i32.load	$push429=, 0($4):p2align=0
	i32.store	184($9), $pop429
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_97:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label24:
	i32.const	$push546=, 184
	i32.add 	$push547=, $9, $pop546
	i32.add 	$push431=, $pop547, $2
	i32.load8_s	$3=, 0($pop431)
	block   	
	i32.const	$push938=, 16
	i32.eq  	$push430=, $7, $pop938
	br_if   	0, $pop430      # 0: down to label25
# BB#98:                                # %if.then.i508
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.ne  	$push432=, $0, $7
	br_if   	2, $pop432      # 2: down to label10
# BB#99:                                # %if.end.i510
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$8=, 16
	i32.const	$0=, 0
	i32.const	$push942=, 0
	i32.const	$push941=, 16
	i32.store	bar.lastn($pop942), $pop941
	i32.const	$push940=, 0
	i32.const	$push939=, 0
	i32.store	bar.lastc($pop940), $pop939
.LBB1_100:                              # %if.end3.i515
                                        #   in Loop: Header=BB1_97 Depth=1
	end_block                       # label25:
	i32.const	$push945=, 24
	i32.shl 	$push433=, $0, $pop945
	i32.const	$push944=, -2147483648
	i32.xor 	$push434=, $pop433, $pop944
	i32.const	$push943=, 24
	i32.shr_s	$push435=, $pop434, $pop943
	i32.ne  	$push436=, $pop435, $3
	br_if   	1, $pop436      # 1: down to label10
# BB#101:                               # %bar.exit518
                                        #   in Loop: Header=BB1_97 Depth=1
	i32.const	$push953=, 0
	i32.const	$push952=, 1
	i32.add 	$push951=, $0, $pop952
	tee_local	$push950=, $0=, $pop951
	i32.store	bar.lastc($pop953), $pop950
	i32.const	$7=, 16
	i32.const	$push949=, 1
	i32.add 	$push948=, $2, $pop949
	tee_local	$push947=, $2=, $pop948
	i32.const	$push946=, 16
	i32.lt_s	$push437=, $pop947, $pop946
	br_if   	0, $pop437      # 0: up to label24
# BB#102:                               # %for.end194
	end_loop
	i32.const	$push438=, 192
	i32.add 	$push956=, $1, $pop438
	tee_local	$push955=, $6=, $pop956
	i32.store	4($9), $pop955
	i32.const	$push548=, 152
	i32.add 	$push549=, $9, $pop548
	i32.const	$push954=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop549, $5, $pop954
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_103:                              # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label26:
	i32.const	$push550=, 152
	i32.add 	$push551=, $9, $pop550
	i32.add 	$push440=, $pop551, $2
	i32.load8_s	$3=, 0($pop440)
	block   	
	i32.const	$push957=, 31
	i32.eq  	$push439=, $7, $pop957
	br_if   	0, $pop439      # 0: down to label27
# BB#104:                               # %if.then.i522
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.ne  	$push441=, $0, $7
	br_if   	2, $pop441      # 2: down to label10
# BB#105:                               # %if.end.i524
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$8=, 31
	i32.const	$0=, 0
	i32.const	$push961=, 0
	i32.const	$push960=, 31
	i32.store	bar.lastn($pop961), $pop960
	i32.const	$push959=, 0
	i32.const	$push958=, 0
	i32.store	bar.lastc($pop959), $pop958
.LBB1_106:                              # %if.end3.i529
                                        #   in Loop: Header=BB1_103 Depth=1
	end_block                       # label27:
	i32.const	$push964=, 24
	i32.shl 	$push442=, $0, $pop964
	i32.const	$push963=, -134217728
	i32.xor 	$push443=, $pop442, $pop963
	i32.const	$push962=, 24
	i32.shr_s	$push444=, $pop443, $pop962
	i32.ne  	$push445=, $pop444, $3
	br_if   	1, $pop445      # 1: down to label10
# BB#107:                               # %bar.exit532
                                        #   in Loop: Header=BB1_103 Depth=1
	i32.const	$push972=, 0
	i32.const	$push971=, 1
	i32.add 	$push970=, $0, $pop971
	tee_local	$push969=, $0=, $pop970
	i32.store	bar.lastc($pop972), $pop969
	i32.const	$7=, 31
	i32.const	$push968=, 1
	i32.add 	$push967=, $2, $pop968
	tee_local	$push966=, $2=, $pop967
	i32.const	$push965=, 31
	i32.lt_s	$push446=, $pop966, $pop965
	br_if   	0, $pop446      # 0: up to label26
# BB#108:                               # %for.end206
	end_loop
	i32.const	$push552=, 120
	i32.add 	$push553=, $9, $pop552
	i32.const	$push447=, 28
	i32.add 	$push450=, $pop553, $pop447
	i32.const	$push981=, 28
	i32.add 	$push448=, $6, $pop981
	i32.load	$push449=, 0($pop448):p2align=0
	i32.store	0($pop450), $pop449
	i32.const	$push554=, 120
	i32.add 	$push555=, $9, $pop554
	i32.const	$push980=, 24
	i32.add 	$push453=, $pop555, $pop980
	i32.const	$push979=, 24
	i32.add 	$push451=, $6, $pop979
	i32.load	$push452=, 0($pop451):p2align=0
	i32.store	0($pop453), $pop452
	i32.const	$push556=, 120
	i32.add 	$push557=, $9, $pop556
	i32.const	$push454=, 20
	i32.add 	$push457=, $pop557, $pop454
	i32.const	$push978=, 20
	i32.add 	$push455=, $6, $pop978
	i32.load	$push456=, 0($pop455):p2align=0
	i32.store	0($pop457), $pop456
	i32.const	$push558=, 120
	i32.add 	$push559=, $9, $pop558
	i32.const	$push458=, 16
	i32.add 	$push461=, $pop559, $pop458
	i32.const	$push977=, 16
	i32.add 	$push459=, $6, $pop977
	i32.load	$push460=, 0($pop459):p2align=0
	i32.store	0($pop461), $pop460
	i32.const	$push560=, 120
	i32.add 	$push561=, $9, $pop560
	i32.const	$push462=, 12
	i32.add 	$push465=, $pop561, $pop462
	i32.const	$push976=, 12
	i32.add 	$push463=, $6, $pop976
	i32.load	$push464=, 0($pop463):p2align=0
	i32.store	0($pop465), $pop464
	i32.const	$push562=, 120
	i32.add 	$push563=, $9, $pop562
	i32.const	$push466=, 8
	i32.add 	$push469=, $pop563, $pop466
	i32.const	$push975=, 8
	i32.add 	$push467=, $6, $pop975
	i32.load	$push468=, 0($pop467):p2align=0
	i32.store	0($pop469), $pop468
	i32.const	$push470=, 224
	i32.add 	$push974=, $1, $pop470
	tee_local	$push973=, $4=, $pop974
	i32.store	4($9), $pop973
	i32.const	$push471=, 4
	i32.add 	$push472=, $6, $pop471
	i32.load	$push473=, 0($pop472):p2align=0
	i32.store	124($9), $pop473
	i32.load	$push474=, 0($6):p2align=0
	i32.store	120($9), $pop474
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_109:                              # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label28:
	i32.const	$push564=, 120
	i32.add 	$push565=, $9, $pop564
	i32.add 	$push476=, $pop565, $2
	i32.load8_s	$3=, 0($pop476)
	block   	
	i32.const	$push982=, 32
	i32.eq  	$push475=, $7, $pop982
	br_if   	0, $pop475      # 0: down to label29
# BB#110:                               # %if.then.i536
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.ne  	$push477=, $0, $7
	br_if   	2, $pop477      # 2: down to label10
# BB#111:                               # %if.end.i538
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$8=, 32
	i32.const	$0=, 0
	i32.const	$push986=, 0
	i32.const	$push985=, 32
	i32.store	bar.lastn($pop986), $pop985
	i32.const	$push984=, 0
	i32.const	$push983=, 0
	i32.store	bar.lastc($pop984), $pop983
.LBB1_112:                              # %if.end3.i543
                                        #   in Loop: Header=BB1_109 Depth=1
	end_block                       # label29:
	i32.const	$push988=, 24
	i32.shl 	$push478=, $0, $pop988
	i32.const	$push987=, 24
	i32.shr_s	$push479=, $pop478, $pop987
	i32.ne  	$push480=, $pop479, $3
	br_if   	1, $pop480      # 1: down to label10
# BB#113:                               # %bar.exit546
                                        #   in Loop: Header=BB1_109 Depth=1
	i32.const	$push996=, 0
	i32.const	$push995=, 1
	i32.add 	$push994=, $0, $pop995
	tee_local	$push993=, $0=, $pop994
	i32.store	bar.lastc($pop996), $pop993
	i32.const	$7=, 32
	i32.const	$push992=, 1
	i32.add 	$push991=, $2, $pop992
	tee_local	$push990=, $2=, $pop991
	i32.const	$push989=, 32
	i32.lt_s	$push481=, $pop990, $pop989
	br_if   	0, $pop481      # 0: up to label28
# BB#114:                               # %for.end218
	end_loop
	i32.const	$push482=, 260
	i32.add 	$push999=, $1, $pop482
	tee_local	$push998=, $6=, $pop999
	i32.store	4($9), $pop998
	i32.const	$push566=, 80
	i32.add 	$push567=, $9, $pop566
	i32.const	$push997=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop567, $4, $pop997
	copy_local	$7=, $8
	i32.const	$2=, 0
.LBB1_115:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label30:
	i32.const	$push568=, 80
	i32.add 	$push569=, $9, $pop568
	i32.add 	$push484=, $pop569, $2
	i32.load8_s	$3=, 0($pop484)
	block   	
	i32.const	$push1000=, 35
	i32.eq  	$push483=, $7, $pop1000
	br_if   	0, $pop483      # 0: down to label31
# BB#116:                               # %if.then.i550
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.ne  	$push485=, $0, $7
	br_if   	2, $pop485      # 2: down to label10
# BB#117:                               # %if.end.i552
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$8=, 35
	i32.const	$0=, 0
	i32.const	$push1004=, 0
	i32.const	$push1003=, 35
	i32.store	bar.lastn($pop1004), $pop1003
	i32.const	$push1002=, 0
	i32.const	$push1001=, 0
	i32.store	bar.lastc($pop1002), $pop1001
.LBB1_118:                              # %if.end3.i557
                                        #   in Loop: Header=BB1_115 Depth=1
	end_block                       # label31:
	i32.const	$push1007=, 24
	i32.shl 	$push486=, $0, $pop1007
	i32.const	$push1006=, 24
	i32.shr_s	$push487=, $pop486, $pop1006
	i32.const	$push1005=, 24
	i32.xor 	$push488=, $pop487, $pop1005
	i32.ne  	$push489=, $pop488, $3
	br_if   	1, $pop489      # 1: down to label10
# BB#119:                               # %bar.exit560
                                        #   in Loop: Header=BB1_115 Depth=1
	i32.const	$push1015=, 0
	i32.const	$push1014=, 1
	i32.add 	$push1013=, $0, $pop1014
	tee_local	$push1012=, $0=, $pop1013
	i32.store	bar.lastc($pop1015), $pop1012
	i32.const	$7=, 35
	i32.const	$push1011=, 1
	i32.add 	$push1010=, $2, $pop1011
	tee_local	$push1009=, $2=, $pop1010
	i32.const	$push1008=, 35
	i32.lt_s	$push490=, $pop1009, $pop1008
	br_if   	0, $pop490      # 0: up to label30
# BB#120:                               # %for.end230
	end_loop
	i32.const	$push491=, 332
	i32.add 	$push492=, $1, $pop491
	i32.store	4($9), $pop492
	i32.const	$push570=, 8
	i32.add 	$push571=, $9, $pop570
	i32.const	$push1016=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop571, $6, $pop1016
	i32.const	$2=, 0
.LBB1_121:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label32:
	i32.const	$push572=, 8
	i32.add 	$push573=, $9, $pop572
	i32.add 	$push494=, $pop573, $2
	i32.load8_s	$7=, 0($pop494)
	block   	
	i32.const	$push1017=, 72
	i32.eq  	$push493=, $8, $pop1017
	br_if   	0, $pop493      # 0: down to label33
# BB#122:                               # %if.then.i564
                                        #   in Loop: Header=BB1_121 Depth=1
	i32.ne  	$push495=, $0, $8
	br_if   	2, $pop495      # 2: down to label10
# BB#123:                               # %if.end.i566
                                        #   in Loop: Header=BB1_121 Depth=1
	i32.const	$0=, 0
	i32.const	$push1021=, 0
	i32.const	$push1020=, 72
	i32.store	bar.lastn($pop1021), $pop1020
	i32.const	$push1019=, 0
	i32.const	$push1018=, 0
	i32.store	bar.lastc($pop1019), $pop1018
.LBB1_124:                              # %if.end3.i571
                                        #   in Loop: Header=BB1_121 Depth=1
	end_block                       # label33:
	i32.const	$push1024=, 24
	i32.shl 	$push496=, $0, $pop1024
	i32.const	$push1023=, 24
	i32.shr_s	$push497=, $pop496, $pop1023
	i32.const	$push1022=, 64
	i32.xor 	$push498=, $pop497, $pop1022
	i32.ne  	$push499=, $pop498, $7
	br_if   	1, $pop499      # 1: down to label10
# BB#125:                               # %bar.exit574
                                        #   in Loop: Header=BB1_121 Depth=1
	i32.const	$push1032=, 0
	i32.const	$push1031=, 1
	i32.add 	$push1030=, $0, $pop1031
	tee_local	$push1029=, $0=, $pop1030
	i32.store	bar.lastc($pop1032), $pop1029
	i32.const	$8=, 72
	i32.const	$push1028=, 1
	i32.add 	$push1027=, $2, $pop1028
	tee_local	$push1026=, $2=, $pop1027
	i32.const	$push1025=, 72
	i32.lt_s	$push500=, $pop1026, $pop1025
	br_if   	0, $pop500      # 0: up to label32
# BB#126:                               # %for.end242
	end_loop
	i32.const	$push507=, 0
	i32.const	$push505=, 352
	i32.add 	$push506=, $9, $pop505
	i32.store	__stack_pointer($pop507), $pop506
	return
.LBB1_127:                              # %if.then7.i320
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_128:                              # %if.then7.i432
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_129:                              # %if.then7.i418
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_130:                              # %if.then7.i404
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_131:                              # %if.then7.i390
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_132:                              # %if.then7.i376
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_133:                              # %if.then7.i362
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_134:                              # %if.then7.i348
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_135:                              # %if.then7.i334
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
	i32.const	$push257=, 0
	i32.const	$push254=, 0
	i32.load	$push255=, __stack_pointer($pop254)
	i32.const	$push256=, 768
	i32.sub 	$push413=, $pop255, $pop256
	tee_local	$push412=, $1=, $pop413
	i32.store	__stack_pointer($pop257), $pop412
	i32.const	$push0=, 4368
	i32.store16	760($1), $pop0
	i32.const	$push1=, 24
	i32.store8	752($1), $pop1
	i32.const	$push2=, 25
	i32.store8	753($1), $pop2
	i32.const	$push3=, 26
	i32.store8	754($1), $pop3
	i32.const	$push4=, 32
	i32.store8	744($1), $pop4
	i32.const	$push5=, 33
	i32.store8	745($1), $pop5
	i32.const	$push6=, 34
	i32.store8	746($1), $pop6
	i32.const	$push7=, 40
	i32.store8	736($1), $pop7
	i32.const	$push8=, 35
	i32.store8	747($1), $pop8
	i32.const	$push9=, 41
	i32.store8	737($1), $pop9
	i32.const	$push10=, 42
	i32.store8	738($1), $pop10
	i32.const	$push11=, 43
	i32.store8	739($1), $pop11
	i32.const	$push12=, 48
	i32.store8	728($1), $pop12
	i32.const	$push13=, 44
	i32.store8	740($1), $pop13
	i32.const	$push14=, 49
	i32.store8	729($1), $pop14
	i32.const	$push15=, 50
	i32.store8	730($1), $pop15
	i32.const	$push16=, 51
	i32.store8	731($1), $pop16
	i32.const	$push17=, 52
	i32.store8	732($1), $pop17
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
	i32.const	$push25=, 62
	i32.store8	726($1), $pop25
	i32.const	$push26=, 64
	i32.store8	712($1), $pop26
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
	i32.const	$push33=, 71
	i32.store8	719($1), $pop33
	i32.const	$push34=, 72
	i32.store8	696($1), $pop34
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
	i32.const	$push411=, 64
	i32.store8	704($1), $pop411
	i32.const	$push42=, 80
	i32.store8	680($1), $pop42
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
	i32.const	$push51=, 89
	i32.store8	689($1), $pop51
	i32.const	$push410=, 88
	i32.store8	664($1), $pop410
	i32.const	$push409=, 89
	i32.store8	665($1), $pop409
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
	i32.const	$push408=, 80
	i32.store8	672($1), $pop408
	i32.const	$push407=, 81
	i32.store8	673($1), $pop407
	i32.const	$push406=, 82
	i32.store8	674($1), $pop406
	i32.const	$push58=, 96
	i32.store8	648($1), $pop58
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
	i32.const	$push69=, 107
	i32.store8	659($1), $pop69
	i32.const	$push405=, 104
	i32.store8	632($1), $pop405
	i32.const	$push404=, 105
	i32.store8	633($1), $pop404
	i32.const	$push403=, 106
	i32.store8	634($1), $pop403
	i32.const	$push402=, 107
	i32.store8	635($1), $pop402
	i32.const	$push70=, 108
	i32.store8	636($1), $pop70
	i32.const	$push71=, 109
	i32.store8	637($1), $pop71
	i32.const	$push72=, 110
	i32.store8	638($1), $pop72
	i32.const	$push73=, 111
	i32.store8	639($1), $pop73
	i32.const	$push401=, 96
	i32.store8	640($1), $pop401
	i32.const	$push400=, 97
	i32.store8	641($1), $pop400
	i32.const	$push399=, 98
	i32.store8	642($1), $pop399
	i32.const	$push398=, 99
	i32.store8	643($1), $pop398
	i32.const	$push397=, 100
	i32.store8	644($1), $pop397
	i32.const	$push74=, 112
	i32.store8	616($1), $pop74
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
	i32.const	$push87=, 125
	i32.store8	629($1), $pop87
	i32.const	$push396=, 120
	i32.store8	600($1), $pop396
	i32.const	$push395=, 121
	i32.store8	601($1), $pop395
	i32.const	$push394=, 122
	i32.store8	602($1), $pop394
	i32.const	$push393=, 123
	i32.store8	603($1), $pop393
	i32.const	$push392=, 124
	i32.store8	604($1), $pop392
	i32.const	$push391=, 125
	i32.store8	605($1), $pop391
	i32.const	$push88=, 126
	i32.store8	606($1), $pop88
	i32.const	$push89=, 127
	i32.store8	607($1), $pop89
	i32.const	$push390=, 112
	i32.store8	608($1), $pop390
	i32.const	$push389=, 113
	i32.store8	609($1), $pop389
	i32.const	$push388=, 114
	i32.store8	610($1), $pop388
	i32.const	$push387=, 115
	i32.store8	611($1), $pop387
	i32.const	$push386=, 116
	i32.store8	612($1), $pop386
	i32.const	$push385=, 117
	i32.store8	613($1), $pop385
	i32.const	$push384=, 118
	i32.store8	614($1), $pop384
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
	loop    	                # label34:
	i32.const	$push258=, 552
	i32.add 	$push259=, $1, $pop258
	i32.add 	$push107=, $pop259, $0
	i32.const	$push418=, 248
	i32.xor 	$push106=, $0, $pop418
	i32.store8	0($pop107), $pop106
	i32.const	$push417=, 1
	i32.add 	$push416=, $0, $pop417
	tee_local	$push415=, $0=, $pop416
	i32.const	$push414=, 31
	i32.ne  	$push108=, $pop415, $pop414
	br_if   	0, $pop108      # 0: up to label34
# BB#2:                                 # %for.body191.preheader
	end_loop
	i32.const	$push109=, 50462976
	i32.store	520($1), $pop109
	i32.const	$push110=, 1284
	i32.store16	524($1), $pop110
	i32.const	$push111=, 151521030
	i32.store	526($1):p2align=1, $pop111
	i32.const	$push112=, 2826
	i32.store16	530($1), $pop112
	i32.const	$push113=, 3340
	i32.store16	532($1), $pop113
	i32.const	$push114=, 14
	i32.store8	534($1), $pop114
	i32.const	$push115=, 15
	i32.store8	535($1), $pop115
	i32.const	$push116=, 16
	i32.store8	536($1), $pop116
	i32.const	$push117=, 17
	i32.store8	537($1), $pop117
	i32.const	$push118=, 18
	i32.store8	538($1), $pop118
	i32.const	$push119=, 19
	i32.store8	539($1), $pop119
	i32.const	$push120=, 20
	i32.store8	540($1), $pop120
	i32.const	$push121=, 21
	i32.store8	541($1), $pop121
	i32.const	$push122=, 22
	i32.store8	542($1), $pop122
	i32.const	$push123=, 23
	i32.store8	543($1), $pop123
	i32.const	$push419=, 24
	i32.store8	544($1), $pop419
	i32.const	$push124=, 25
	i32.store8	545($1), $pop124
	i32.const	$push125=, 26
	i32.store8	546($1), $pop125
	i32.const	$push126=, 27
	i32.store8	547($1), $pop126
	i32.const	$push127=, 28
	i32.store8	548($1), $pop127
	i32.const	$push128=, 29
	i32.store8	549($1), $pop128
	i32.const	$push129=, 30
	i32.store8	550($1), $pop129
	i32.const	$push130=, 31
	i32.store8	551($1), $pop130
	i32.const	$0=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label35:
	i32.const	$push260=, 480
	i32.add 	$push261=, $1, $pop260
	i32.add 	$push132=, $pop261, $0
	i32.const	$push424=, 24
	i32.xor 	$push131=, $0, $pop424
	i32.store8	0($pop132), $pop131
	i32.const	$push423=, 1
	i32.add 	$push422=, $0, $pop423
	tee_local	$push421=, $0=, $pop422
	i32.const	$push420=, 35
	i32.ne  	$push133=, $pop421, $pop420
	br_if   	0, $pop133      # 0: up to label35
# BB#4:                                 # %for.body213.preheader
	end_loop
	i32.const	$0=, 0
.LBB2_5:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label36:
	i32.const	$push262=, 408
	i32.add 	$push263=, $1, $pop262
	i32.add 	$push135=, $pop263, $0
	i32.const	$push429=, 64
	i32.xor 	$push134=, $0, $pop429
	i32.store8	0($pop135), $pop134
	i32.const	$push428=, 1
	i32.add 	$push427=, $0, $pop428
	tee_local	$push426=, $0=, $pop427
	i32.const	$push425=, 72
	i32.ne  	$push136=, $pop426, $pop425
	br_if   	0, $pop136      # 0: up to label36
# BB#6:                                 # %for.end220
	end_loop
	i32.const	$push137=, 404
	i32.add 	$push138=, $1, $pop137
	i32.load8_u	$push139=, 754($1)
	i32.store8	0($pop138), $pop139
	i32.load16_u	$push140=, 760($1)
	i32.store16	406($1), $pop140
	i32.load16_u	$push141=, 752($1)
	i32.store16	402($1), $pop141
	i32.load	$push142=, 744($1)
	i32.store	396($1), $pop142
	i32.const	$push264=, 388
	i32.add 	$push265=, $1, $pop264
	i32.const	$push143=, 4
	i32.add 	$push144=, $pop265, $pop143
	i32.load8_u	$push145=, 740($1)
	i32.store8	0($pop144), $pop145
	i32.load	$push146=, 736($1)
	i32.store	388($1), $pop146
	i32.const	$push266=, 380
	i32.add 	$push267=, $1, $pop266
	i32.const	$push461=, 4
	i32.add 	$push147=, $pop267, $pop461
	i32.load16_u	$push148=, 732($1)
	i32.store16	0($pop147), $pop148
	i32.load	$push149=, 728($1)
	i32.store	380($1), $pop149
	i32.const	$push150=, 378
	i32.add 	$push151=, $1, $pop150
	i32.load8_u	$push152=, 726($1)
	i32.store8	0($pop151), $pop152
	i32.const	$push268=, 372
	i32.add 	$push269=, $1, $pop268
	i32.const	$push460=, 4
	i32.add 	$push153=, $pop269, $pop460
	i32.load16_u	$push154=, 724($1)
	i32.store16	0($pop153), $pop154
	i32.load	$push155=, 720($1)
	i32.store	372($1), $pop155
	i64.load	$push156=, 712($1)
	i64.store	364($1):p2align=2, $pop156
	i32.const	$push270=, 352
	i32.add 	$push271=, $1, $pop270
	i32.const	$push157=, 8
	i32.add 	$push158=, $pop271, $pop157
	i32.const	$push272=, 696
	i32.add 	$push273=, $1, $pop272
	i32.const	$push459=, 8
	i32.add 	$push159=, $pop273, $pop459
	i32.load8_u	$push160=, 0($pop159)
	i32.store8	0($pop158), $pop160
	i64.load	$push161=, 696($1)
	i64.store	352($1):p2align=2, $pop161
	i32.const	$push274=, 340
	i32.add 	$push275=, $1, $pop274
	i32.const	$push458=, 8
	i32.add 	$push162=, $pop275, $pop458
	i32.const	$push276=, 680
	i32.add 	$push277=, $1, $pop276
	i32.const	$push457=, 8
	i32.add 	$push163=, $pop277, $pop457
	i32.load16_u	$push164=, 0($pop163)
	i32.store16	0($pop162), $pop164
	i64.load	$push165=, 680($1)
	i64.store	340($1):p2align=2, $pop165
	i32.const	$push278=, 328
	i32.add 	$push279=, $1, $pop278
	i32.const	$push166=, 10
	i32.add 	$push167=, $pop279, $pop166
	i32.const	$push280=, 664
	i32.add 	$push281=, $1, $pop280
	i32.const	$push456=, 10
	i32.add 	$push168=, $pop281, $pop456
	i32.load8_u	$push169=, 0($pop168)
	i32.store8	0($pop167), $pop169
	i32.const	$push282=, 328
	i32.add 	$push283=, $1, $pop282
	i32.const	$push455=, 8
	i32.add 	$push170=, $pop283, $pop455
	i32.const	$push284=, 664
	i32.add 	$push285=, $1, $pop284
	i32.const	$push454=, 8
	i32.add 	$push171=, $pop285, $pop454
	i32.load16_u	$push172=, 0($pop171)
	i32.store16	0($pop170), $pop172
	i64.load	$push173=, 664($1)
	i64.store	328($1):p2align=2, $pop173
	i32.const	$push286=, 316
	i32.add 	$push287=, $1, $pop286
	i32.const	$push453=, 8
	i32.add 	$push174=, $pop287, $pop453
	i32.const	$push288=, 648
	i32.add 	$push289=, $1, $pop288
	i32.const	$push452=, 8
	i32.add 	$push175=, $pop289, $pop452
	i32.load	$push176=, 0($pop175)
	i32.store	0($pop174), $pop176
	i64.load	$push177=, 648($1)
	i64.store	316($1):p2align=2, $pop177
	i32.const	$push290=, 300
	i32.add 	$push291=, $1, $pop290
	i32.const	$push178=, 12
	i32.add 	$push179=, $pop291, $pop178
	i32.const	$push292=, 632
	i32.add 	$push293=, $1, $pop292
	i32.const	$push451=, 12
	i32.add 	$push180=, $pop293, $pop451
	i32.load8_u	$push181=, 0($pop180)
	i32.store8	0($pop179), $pop181
	i32.const	$push294=, 300
	i32.add 	$push295=, $1, $pop294
	i32.const	$push450=, 8
	i32.add 	$push182=, $pop295, $pop450
	i32.const	$push296=, 632
	i32.add 	$push297=, $1, $pop296
	i32.const	$push449=, 8
	i32.add 	$push183=, $pop297, $pop449
	i32.load	$push184=, 0($pop183)
	i32.store	0($pop182), $pop184
	i64.load	$push185=, 632($1)
	i64.store	300($1):p2align=2, $pop185
	i32.const	$push298=, 284
	i32.add 	$push299=, $1, $pop298
	i32.const	$push448=, 12
	i32.add 	$push186=, $pop299, $pop448
	i32.const	$push300=, 616
	i32.add 	$push301=, $1, $pop300
	i32.const	$push447=, 12
	i32.add 	$push187=, $pop301, $pop447
	i32.load16_u	$push188=, 0($pop187)
	i32.store16	0($pop186), $pop188
	i32.const	$push302=, 284
	i32.add 	$push303=, $1, $pop302
	i32.const	$push446=, 8
	i32.add 	$push189=, $pop303, $pop446
	i32.const	$push304=, 616
	i32.add 	$push305=, $1, $pop304
	i32.const	$push445=, 8
	i32.add 	$push190=, $pop305, $pop445
	i32.load	$push191=, 0($pop190)
	i32.store	0($pop189), $pop191
	i64.load	$push192=, 616($1)
	i64.store	284($1):p2align=2, $pop192
	i32.const	$push306=, 268
	i32.add 	$push307=, $1, $pop306
	i32.const	$push193=, 14
	i32.add 	$push194=, $pop307, $pop193
	i32.const	$push308=, 600
	i32.add 	$push309=, $1, $pop308
	i32.const	$push444=, 14
	i32.add 	$push195=, $pop309, $pop444
	i32.load8_u	$push196=, 0($pop195)
	i32.store8	0($pop194), $pop196
	i32.const	$push310=, 268
	i32.add 	$push311=, $1, $pop310
	i32.const	$push443=, 12
	i32.add 	$push197=, $pop311, $pop443
	i32.const	$push312=, 600
	i32.add 	$push313=, $1, $pop312
	i32.const	$push442=, 12
	i32.add 	$push198=, $pop313, $pop442
	i32.load16_u	$push199=, 0($pop198)
	i32.store16	0($pop197), $pop199
	i32.const	$push314=, 268
	i32.add 	$push315=, $1, $pop314
	i32.const	$push441=, 8
	i32.add 	$push200=, $pop315, $pop441
	i32.const	$push316=, 600
	i32.add 	$push317=, $1, $pop316
	i32.const	$push440=, 8
	i32.add 	$push201=, $pop317, $pop440
	i32.load	$push202=, 0($pop201)
	i32.store	0($pop200), $pop202
	i64.load	$push203=, 600($1)
	i64.store	268($1):p2align=2, $pop203
	i32.const	$push318=, 252
	i32.add 	$push319=, $1, $pop318
	i32.const	$push439=, 8
	i32.add 	$push204=, $pop319, $pop439
	i32.const	$push320=, 584
	i32.add 	$push321=, $1, $pop320
	i32.const	$push438=, 8
	i32.add 	$push205=, $pop321, $pop438
	i64.load	$push206=, 0($pop205)
	i64.store	0($pop204):p2align=2, $pop206
	i64.load	$push207=, 584($1)
	i64.store	252($1):p2align=2, $pop207
	i32.const	$push322=, 221
	i32.add 	$push323=, $1, $pop322
	i32.const	$push324=, 552
	i32.add 	$push325=, $1, $pop324
	i32.const	$push208=, 31
	i32.call	$drop=, memcpy@FUNCTION, $pop323, $pop325, $pop208
	i32.const	$push326=, 188
	i32.add 	$push327=, $1, $pop326
	i32.const	$push209=, 24
	i32.add 	$push210=, $pop327, $pop209
	i32.const	$push328=, 520
	i32.add 	$push329=, $1, $pop328
	i32.const	$push437=, 24
	i32.add 	$push211=, $pop329, $pop437
	i64.load	$push212=, 0($pop211)
	i64.store	0($pop210):p2align=2, $pop212
	i32.const	$push330=, 188
	i32.add 	$push331=, $1, $pop330
	i32.const	$push213=, 16
	i32.add 	$push214=, $pop331, $pop213
	i32.const	$push332=, 520
	i32.add 	$push333=, $1, $pop332
	i32.const	$push436=, 16
	i32.add 	$push215=, $pop333, $pop436
	i64.load	$push216=, 0($pop215)
	i64.store	0($pop214):p2align=2, $pop216
	i32.const	$push334=, 188
	i32.add 	$push335=, $1, $pop334
	i32.const	$push435=, 8
	i32.add 	$push217=, $pop335, $pop435
	i32.const	$push336=, 520
	i32.add 	$push337=, $1, $pop336
	i32.const	$push434=, 8
	i32.add 	$push218=, $pop337, $pop434
	i64.load	$push219=, 0($pop218)
	i64.store	0($pop217):p2align=2, $pop219
	i64.load	$push220=, 520($1)
	i64.store	188($1):p2align=2, $pop220
	i32.const	$push338=, 153
	i32.add 	$push339=, $1, $pop338
	i32.const	$push340=, 480
	i32.add 	$push341=, $1, $pop340
	i32.const	$push221=, 35
	i32.call	$drop=, memcpy@FUNCTION, $pop339, $pop341, $pop221
	i32.const	$push342=, 81
	i32.add 	$push343=, $1, $pop342
	i32.const	$push344=, 408
	i32.add 	$push345=, $1, $pop344
	i32.const	$push222=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop343, $pop345, $pop222
	i32.const	$push223=, 76
	i32.add 	$push224=, $1, $pop223
	i32.const	$push346=, 81
	i32.add 	$push347=, $1, $pop346
	i32.store	0($pop224), $pop347
	i32.const	$push225=, 68
	i32.add 	$push226=, $1, $pop225
	i32.const	$push348=, 188
	i32.add 	$push349=, $1, $pop348
	i32.store	0($pop226), $pop349
	i32.const	$push227=, 64
	i32.add 	$push228=, $1, $pop227
	i32.const	$push350=, 221
	i32.add 	$push351=, $1, $pop350
	i32.store	0($pop228), $pop351
	i32.const	$push229=, 60
	i32.add 	$push230=, $1, $pop229
	i32.const	$push352=, 252
	i32.add 	$push353=, $1, $pop352
	i32.store	0($pop230), $pop353
	i32.const	$push231=, 56
	i32.add 	$push232=, $1, $pop231
	i32.const	$push354=, 268
	i32.add 	$push355=, $1, $pop354
	i32.store	0($pop232), $pop355
	i32.const	$push233=, 52
	i32.add 	$push234=, $1, $pop233
	i32.const	$push356=, 284
	i32.add 	$push357=, $1, $pop356
	i32.store	0($pop234), $pop357
	i32.const	$push235=, 48
	i32.add 	$push236=, $1, $pop235
	i32.const	$push358=, 300
	i32.add 	$push359=, $1, $pop358
	i32.store	0($pop236), $pop359
	i32.const	$push237=, 44
	i32.add 	$push238=, $1, $pop237
	i32.const	$push360=, 316
	i32.add 	$push361=, $1, $pop360
	i32.store	0($pop238), $pop361
	i32.const	$push239=, 40
	i32.add 	$push240=, $1, $pop239
	i32.const	$push362=, 328
	i32.add 	$push363=, $1, $pop362
	i32.store	0($pop240), $pop363
	i32.const	$push241=, 36
	i32.add 	$push242=, $1, $pop241
	i32.const	$push364=, 340
	i32.add 	$push365=, $1, $pop364
	i32.store	0($pop242), $pop365
	i32.const	$push243=, 32
	i32.add 	$push244=, $1, $pop243
	i32.const	$push366=, 352
	i32.add 	$push367=, $1, $pop366
	i32.store	0($pop244), $pop367
	i32.const	$push245=, 28
	i32.add 	$push246=, $1, $pop245
	i32.const	$push368=, 364
	i32.add 	$push369=, $1, $pop368
	i32.store	0($pop246), $pop369
	i32.const	$push433=, 24
	i32.add 	$push247=, $1, $pop433
	i32.const	$push370=, 372
	i32.add 	$push371=, $1, $pop370
	i32.store	0($pop247), $pop371
	i32.const	$push248=, 20
	i32.add 	$push249=, $1, $pop248
	i32.const	$push372=, 380
	i32.add 	$push373=, $1, $pop372
	i32.store	0($pop249), $pop373
	i32.const	$push432=, 16
	i32.add 	$push250=, $1, $pop432
	i32.const	$push374=, 388
	i32.add 	$push375=, $1, $pop374
	i32.store	0($pop250), $pop375
	i32.const	$push431=, 8
	i32.store	0($1), $pop431
	i32.const	$push430=, 72
	i32.add 	$push251=, $1, $pop430
	i32.const	$push376=, 153
	i32.add 	$push377=, $1, $pop376
	i32.store	0($pop251), $pop377
	i32.const	$push378=, 396
	i32.add 	$push379=, $1, $pop378
	i32.store	12($1), $pop379
	i32.const	$push380=, 402
	i32.add 	$push381=, $1, $pop380
	i32.store	8($1), $pop381
	i32.const	$push382=, 406
	i32.add 	$push383=, $1, $pop382
	i32.store	4($1), $pop383
	i32.const	$push252=, 21
	call    	foo@FUNCTION, $pop252, $1
	i32.const	$push253=, 0
	call    	exit@FUNCTION, $pop253
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
