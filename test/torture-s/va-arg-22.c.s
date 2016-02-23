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
	.local  	i32, i32, i64, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push623=, __stack_pointer
	i32.load	$push624=, 0($pop623)
	i32.const	$push625=, 352
	i32.sub 	$43=, $pop624, $pop625
	i32.const	$push626=, __stack_pointer
	i32.store	$discard=, 0($pop626), $43
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
	i32.store	$push414=, 4($43), $1
	tee_local	$push413=, $9=, $pop414
	i32.const	$push38=, 4
	i32.add 	$push39=, $pop413, $pop38
	i32.store	$discard=, 4($43), $pop39
	i32.const	$push40=, 0
	i32.load	$0=, bar.lastc($pop40)
	i32.load8_s	$1=, 0($9)
	block
	i32.const	$push412=, 0
	i32.load	$push411=, bar.lastn($pop412)
	tee_local	$push410=, $2=, $pop411
	i32.const	$push41=, 1
	i32.eq  	$push42=, $pop410, $pop41
	br_if   	0, $pop42       # 0: down to label9
# BB#2:                                 # %if.then.i
	i32.ne  	$push43=, $0, $2
	br_if   	1, $pop43       # 1: down to label8
# BB#3:                                 # %if.end.i
	i32.const	$push44=, 0
	i32.const	$push415=, 0
	i32.store	$0=, bar.lastc($pop44), $pop415
	i32.const	$push45=, 1
	i32.store	$discard=, bar.lastn($0), $pop45
.LBB1_4:                                # %if.end3.i
	end_block                       # label9:
	i32.const	$push46=, 24
	i32.shl 	$push47=, $0, $pop46
	i32.const	$push417=, 24
	i32.shr_s	$push48=, $pop47, $pop417
	i32.const	$push416=, 8
	i32.xor 	$push49=, $pop48, $pop416
	i32.ne  	$push50=, $pop49, $1
	br_if   	0, $pop50       # 0: down to label8
# BB#5:                                 # %if.then.i314
	i32.const	$push419=, 0
	i32.const	$push51=, 1
	i32.add 	$push52=, $0, $pop51
	i32.store	$discard=, bar.lastc($pop419), $pop52
	i32.const	$push418=, 8
	i32.add 	$push0=, $9, $pop418
	i32.store	$1=, 4($43), $pop0
	br_if   	0, $0           # 0: down to label8
# BB#6:                                 # %if.end3.i321
	i32.const	$push53=, 4
	i32.add 	$push54=, $9, $pop53
	i32.load16_u	$0=, 0($pop54):p2align=0
	i32.const	$push421=, 0
	i32.const	$push420=, 0
	i32.store	$push55=, bar.lastc($pop421), $pop420
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
	i32.const	$push68=, 12
	i32.add 	$push69=, $9, $pop68
	i32.store	$discard=, 4($43), $pop69
	i32.const	$push424=, 0
	i32.const	$push67=, 2
	i32.store	$0=, bar.lastc($pop424), $pop67
	i32.load16_u	$2=, 0($1):p2align=0
	i32.add 	$push70=, $1, $0
	i32.load8_u	$push71=, 0($pop70)
	i32.store8	$discard=, 346($43):p2align=1, $pop71
	i32.store16	$discard=, 344($43):p2align=3, $2
	i32.const	$push423=, 0
	i32.const	$push422=, 0
	i32.store	$0=, bar.lastc($pop423), $pop422
	i32.load8_u	$1=, 344($43):p2align=3
	i32.const	$push72=, 3
	i32.store	$discard=, bar.lastn($0), $pop72
	i32.const	$push73=, 24
	i32.ne  	$push74=, $1, $pop73
	br_if   	6, $pop74       # 6: down to label2
# BB#9:                                 # %if.end3.i335.1
	i32.load8_u	$0=, 345($43)
	i32.const	$push580=, 0
	i32.const	$push75=, 1
	i32.store	$discard=, bar.lastc($pop580), $pop75
	i32.const	$push76=, 25
	i32.ne  	$push77=, $0, $pop76
	br_if   	6, $pop77       # 6: down to label2
# BB#10:                                # %if.end3.i335.2
	i32.load8_u	$0=, 346($43):p2align=1
	i32.const	$push581=, 0
	i32.const	$push78=, 2
	i32.store	$discard=, bar.lastc($pop581), $pop78
	i32.const	$push79=, 26
	i32.ne  	$push80=, $0, $pop79
	br_if   	6, $pop80       # 6: down to label2
# BB#11:                                # %if.end3.i349
	i32.const	$push82=, 0
	i32.const	$push81=, 3
	i32.store	$discard=, bar.lastc($pop82), $pop81
	i32.const	$push83=, 16
	i32.add 	$push1=, $9, $pop83
	i32.store	$1=, 4($43), $pop1
	i32.const	$push84=, 12
	i32.add 	$push85=, $9, $pop84
	i32.load	$0=, 0($pop85):p2align=0
	i32.const	$push428=, 0
	i32.const	$push427=, 0
	i32.store	$push426=, bar.lastc($pop428), $pop427
	tee_local	$push425=, $2=, $pop426
	i32.const	$push86=, 4
	i32.store	$discard=, bar.lastn($pop425), $pop86
	i32.const	$push87=, 255
	i32.and 	$push88=, $0, $pop87
	i32.const	$push89=, 32
	i32.ne  	$push90=, $pop88, $pop89
	br_if   	5, $pop90       # 5: down to label3
# BB#12:                                # %if.end3.i349.1
	i32.const	$push91=, 1
	i32.store	$discard=, bar.lastc($2), $pop91
	i32.const	$push92=, 65280
	i32.and 	$push93=, $0, $pop92
	i32.const	$push94=, 8448
	i32.ne  	$push95=, $pop93, $pop94
	br_if   	5, $pop95       # 5: down to label3
# BB#13:                                # %if.end3.i349.2
	i32.const	$push578=, 0
	i32.const	$push96=, 2
	i32.store	$discard=, bar.lastc($pop578), $pop96
	i32.const	$push97=, 16711680
	i32.and 	$push98=, $0, $pop97
	i32.const	$push99=, 2228224
	i32.ne  	$push100=, $pop98, $pop99
	br_if   	5, $pop100      # 5: down to label3
# BB#14:                                # %if.end3.i349.3
	i32.const	$push579=, 0
	i32.const	$push101=, 3
	i32.store	$discard=, bar.lastc($pop579), $pop101
	i32.const	$push102=, -16777216
	i32.and 	$push103=, $0, $pop102
	i32.const	$push104=, 587202560
	i32.ne  	$push105=, $pop103, $pop104
	br_if   	5, $pop105      # 5: down to label3
# BB#15:                                # %if.end3.i363
	i32.const	$push106=, 24
	i32.add 	$push2=, $9, $pop106
	i32.store	$2=, 4($43), $pop2
	i32.load	$0=, 0($1):p2align=0
	i32.const	$push107=, 4
	i32.add 	$push108=, $1, $pop107
	i32.load8_u	$push109=, 0($pop108)
	i32.store8	$discard=, 340($43):p2align=2, $pop109
	i32.store	$discard=, 336($43):p2align=3, $0
	i32.const	$push110=, 0
	i32.const	$push429=, 0
	i32.store	$0=, bar.lastc($pop110), $pop429
	i32.load8_u	$1=, 336($43):p2align=3
	i32.const	$push111=, 5
	i32.store	$discard=, bar.lastn($0), $pop111
	i32.const	$push112=, 40
	i32.ne  	$push113=, $1, $pop112
	br_if   	4, $pop113      # 4: down to label4
# BB#16:                                # %if.end3.i363.1
	i32.load8_u	$1=, 337($43)
	i32.const	$push114=, 1
	i32.store	$discard=, bar.lastc($0), $pop114
	i32.const	$push115=, 41
	i32.ne  	$push116=, $1, $pop115
	br_if   	4, $pop116      # 4: down to label4
# BB#17:                                # %if.end3.i363.2
	i32.load8_u	$0=, 338($43):p2align=1
	i32.const	$push576=, 0
	i32.const	$push117=, 2
	i32.store	$discard=, bar.lastc($pop576), $pop117
	i32.const	$push118=, 42
	i32.ne  	$push119=, $0, $pop118
	br_if   	4, $pop119      # 4: down to label4
# BB#18:                                # %if.end3.i363.3
	i32.load8_u	$0=, 339($43)
	i32.const	$push577=, 0
	i32.const	$push120=, 3
	i32.store	$discard=, bar.lastc($pop577), $pop120
	i32.const	$push121=, 43
	i32.ne  	$push122=, $0, $pop121
	br_if   	4, $pop122      # 4: down to label4
# BB#19:                                # %if.end3.i363.4
	i32.load8_u	$0=, 340($43):p2align=2
	i32.const	$push123=, 0
	i32.const	$push124=, 4
	i32.store	$1=, bar.lastc($pop123), $pop124
	i32.const	$push125=, 44
	i32.ne  	$push126=, $0, $pop125
	br_if   	4, $pop126      # 4: down to label4
# BB#20:                                # %if.end3.i377
	i32.const	$push127=, 32
	i32.add 	$push3=, $9, $pop127
	i32.store	$0=, 4($43), $pop3
	i32.load	$8=, 0($2):p2align=0
	i32.add 	$push128=, $2, $1
	i32.load16_u	$push129=, 0($pop128):p2align=0
	i32.store16	$discard=, 332($43):p2align=2, $pop129
	i32.store	$discard=, 328($43):p2align=3, $8
	i32.const	$push431=, 0
	i32.const	$push430=, 0
	i32.store	$1=, bar.lastc($pop431), $pop430
	i32.load8_u	$2=, 328($43):p2align=3
	i32.const	$push130=, 6
	i32.store	$discard=, bar.lastn($1), $pop130
	i32.const	$push131=, 48
	i32.ne  	$push132=, $2, $pop131
	br_if   	3, $pop132      # 3: down to label5
# BB#21:                                # %if.end3.i377.1
	i32.load8_u	$1=, 329($43)
	i32.const	$push572=, 0
	i32.const	$push133=, 1
	i32.store	$discard=, bar.lastc($pop572), $pop133
	i32.const	$push134=, 49
	i32.ne  	$push135=, $1, $pop134
	br_if   	3, $pop135      # 3: down to label5
# BB#22:                                # %if.end3.i377.2
	i32.load8_u	$1=, 330($43):p2align=1
	i32.const	$push573=, 0
	i32.const	$push136=, 2
	i32.store	$discard=, bar.lastc($pop573), $pop136
	i32.const	$push137=, 50
	i32.ne  	$push138=, $1, $pop137
	br_if   	3, $pop138      # 3: down to label5
# BB#23:                                # %if.end3.i377.3
	i32.load8_u	$1=, 331($43)
	i32.const	$push574=, 0
	i32.const	$push139=, 3
	i32.store	$discard=, bar.lastc($pop574), $pop139
	i32.const	$push140=, 51
	i32.ne  	$push141=, $1, $pop140
	br_if   	3, $pop141      # 3: down to label5
# BB#24:                                # %if.end3.i377.4
	i32.load8_u	$1=, 332($43):p2align=2
	i32.const	$push575=, 0
	i32.const	$push142=, 4
	i32.store	$discard=, bar.lastc($pop575), $pop142
	i32.const	$push143=, 52
	i32.ne  	$push144=, $1, $pop143
	br_if   	3, $pop144      # 3: down to label5
# BB#25:                                # %if.end3.i377.5
	i32.load8_u	$1=, 333($43)
	i32.const	$push145=, 0
	i32.const	$push146=, 5
	i32.store	$discard=, bar.lastc($pop145), $pop146
	i32.const	$push147=, 53
	i32.ne  	$push148=, $1, $pop147
	br_if   	3, $pop148      # 3: down to label5
# BB#26:                                # %if.end3.i391
	i32.const	$push149=, 40
	i32.add 	$push150=, $9, $pop149
	i32.store	$discard=, 4($43), $pop150
	i32.const	$push154=, 4
	i32.add 	$push155=, $0, $pop154
	i32.load16_u	$1=, 0($pop155):p2align=0
	i32.load	$2=, 0($0):p2align=0
	i32.const	$push151=, 6
	i32.add 	$push152=, $0, $pop151
	i32.load8_u	$push153=, 0($pop152)
	i32.store8	$discard=, 326($43):p2align=1, $pop153
	i32.store16	$discard=, 324($43):p2align=2, $1
	i32.store	$discard=, 320($43):p2align=3, $2
	i32.const	$push433=, 0
	i32.const	$push432=, 0
	i32.store	$0=, bar.lastc($pop433), $pop432
	i32.load8_u	$1=, 320($43):p2align=3
	i32.const	$push156=, 7
	i32.store	$discard=, bar.lastn($0), $pop156
	i32.const	$push157=, 56
	i32.ne  	$push158=, $1, $pop157
	br_if   	2, $pop158      # 2: down to label6
# BB#27:                                # %if.end3.i391.1
	i32.load8_u	$0=, 321($43)
	i32.const	$push566=, 0
	i32.const	$push159=, 1
	i32.store	$discard=, bar.lastc($pop566), $pop159
	i32.const	$push160=, 57
	i32.ne  	$push161=, $0, $pop160
	br_if   	2, $pop161      # 2: down to label6
# BB#28:                                # %if.end3.i391.2
	i32.load8_u	$0=, 322($43):p2align=1
	i32.const	$push567=, 0
	i32.const	$push162=, 2
	i32.store	$discard=, bar.lastc($pop567), $pop162
	i32.const	$push163=, 58
	i32.ne  	$push164=, $0, $pop163
	br_if   	2, $pop164      # 2: down to label6
# BB#29:                                # %if.end3.i391.3
	i32.load8_u	$0=, 323($43)
	i32.const	$push568=, 0
	i32.const	$push165=, 3
	i32.store	$discard=, bar.lastc($pop568), $pop165
	i32.const	$push166=, 59
	i32.ne  	$push167=, $0, $pop166
	br_if   	2, $pop167      # 2: down to label6
# BB#30:                                # %if.end3.i391.4
	i32.load8_u	$0=, 324($43):p2align=2
	i32.const	$push569=, 0
	i32.const	$push168=, 4
	i32.store	$discard=, bar.lastc($pop569), $pop168
	i32.const	$push169=, 60
	i32.ne  	$push170=, $0, $pop169
	br_if   	2, $pop170      # 2: down to label6
# BB#31:                                # %if.end3.i391.5
	i32.load8_u	$0=, 325($43)
	i32.const	$push570=, 0
	i32.const	$push171=, 5
	i32.store	$discard=, bar.lastc($pop570), $pop171
	i32.const	$push172=, 61
	i32.ne  	$push173=, $0, $pop172
	br_if   	2, $pop173      # 2: down to label6
# BB#32:                                # %if.end3.i391.6
	i32.load8_u	$0=, 326($43):p2align=1
	i32.const	$push571=, 0
	i32.const	$push174=, 6
	i32.store	$discard=, bar.lastc($pop571), $pop174
	i32.const	$push175=, 62
	i32.ne  	$push176=, $0, $pop175
	br_if   	2, $pop176      # 2: down to label6
# BB#33:                                # %if.end3.i405
	i32.const	$push180=, 40
	i32.add 	$push181=, $9, $pop180
	i64.load	$4=, 0($pop181):p2align=0
	i32.const	$push178=, 0
	i32.const	$push177=, 7
	i32.store	$discard=, bar.lastc($pop178), $pop177
	i64.store	$discard=, 312($43), $4
	i32.const	$push435=, 0
	i32.const	$push434=, 0
	i32.store	$0=, bar.lastc($pop435), $pop434
	i32.load8_s	$1=, 312($43):p2align=3
	i32.const	$push182=, 8
	i32.store	$discard=, bar.lastn($0), $pop182
	i32.const	$push179=, 48
	i32.add 	$push4=, $9, $pop179
	i32.store	$2=, 4($43), $pop4
	i32.const	$push183=, 64
	i32.ne  	$push184=, $1, $pop183
	br_if   	1, $pop184      # 1: down to label7
# BB#34:                                # %if.end3.i405.1
	i32.load8_s	$1=, 313($43)
	i32.const	$push27=, 1
	i32.store	$0=, bar.lastc($0), $pop27
	i32.const	$push185=, 65
	i32.ne  	$push186=, $1, $pop185
	br_if   	1, $pop186      # 1: down to label7
# BB#35:                                # %if.end3.i405.2
	i32.load8_s	$push187=, 314($43):p2align=1
	i32.const	$push585=, 0
	i32.add 	$push28=, $0, $0
	i32.store	$push584=, bar.lastc($pop585), $pop28
	tee_local	$push583=, $0=, $pop584
	i32.const	$push582=, 64
	i32.or  	$push188=, $pop583, $pop582
	i32.ne  	$push189=, $pop187, $pop188
	br_if   	1, $pop189      # 1: down to label7
# BB#36:                                # %if.end3.i405.3
	i32.const	$push592=, 0
	i32.const	$push591=, 1
	i32.add 	$push29=, $0, $pop591
	i32.store	$push590=, bar.lastc($pop592), $pop29
	tee_local	$push589=, $0=, $pop590
	i32.const	$push588=, 24
	i32.shl 	$push191=, $pop589, $pop588
	i32.const	$push587=, 24
	i32.shr_s	$push192=, $pop191, $pop587
	i32.const	$push586=, 64
	i32.xor 	$push193=, $pop192, $pop586
	i32.load8_s	$push190=, 315($43)
	i32.ne  	$push194=, $pop193, $pop190
	br_if   	1, $pop194      # 1: down to label7
# BB#37:                                # %if.end3.i405.4
	i32.const	$push599=, 0
	i32.const	$push598=, 1
	i32.add 	$push30=, $0, $pop598
	i32.store	$push597=, bar.lastc($pop599), $pop30
	tee_local	$push596=, $0=, $pop597
	i32.const	$push595=, 24
	i32.shl 	$push196=, $pop596, $pop595
	i32.const	$push594=, 24
	i32.shr_s	$push197=, $pop196, $pop594
	i32.const	$push593=, 64
	i32.xor 	$push198=, $pop197, $pop593
	i32.load8_s	$push195=, 316($43):p2align=2
	i32.ne  	$push199=, $pop198, $pop195
	br_if   	1, $pop199      # 1: down to label7
# BB#38:                                # %if.end3.i405.5
	i32.const	$push606=, 0
	i32.const	$push605=, 1
	i32.add 	$push31=, $0, $pop605
	i32.store	$push604=, bar.lastc($pop606), $pop31
	tee_local	$push603=, $0=, $pop604
	i32.const	$push602=, 24
	i32.shl 	$push201=, $pop603, $pop602
	i32.const	$push601=, 24
	i32.shr_s	$push202=, $pop201, $pop601
	i32.const	$push600=, 64
	i32.xor 	$push203=, $pop202, $pop600
	i32.load8_s	$push200=, 317($43)
	i32.ne  	$push204=, $pop203, $pop200
	br_if   	1, $pop204      # 1: down to label7
# BB#39:                                # %if.end3.i405.6
	i32.const	$push613=, 0
	i32.const	$push612=, 1
	i32.add 	$push32=, $0, $pop612
	i32.store	$push611=, bar.lastc($pop613), $pop32
	tee_local	$push610=, $0=, $pop611
	i32.const	$push609=, 24
	i32.shl 	$push206=, $pop610, $pop609
	i32.const	$push608=, 24
	i32.shr_s	$push207=, $pop206, $pop608
	i32.const	$push607=, 64
	i32.xor 	$push208=, $pop207, $pop607
	i32.load8_s	$push205=, 318($43):p2align=1
	i32.ne  	$push209=, $pop208, $pop205
	br_if   	1, $pop209      # 1: down to label7
# BB#40:                                # %if.end3.i405.7
	i32.const	$push619=, 0
	i32.const	$push618=, 1
	i32.add 	$push33=, $0, $pop618
	i32.store	$push617=, bar.lastc($pop619), $pop33
	tee_local	$push616=, $0=, $pop617
	i32.const	$push211=, 24
	i32.shl 	$push212=, $pop616, $pop211
	i32.const	$push615=, 24
	i32.shr_s	$push213=, $pop212, $pop615
	i32.const	$push614=, 64
	i32.xor 	$push214=, $pop213, $pop614
	i32.load8_s	$push210=, 319($43)
	i32.ne  	$push215=, $pop214, $pop210
	br_if   	1, $pop215      # 1: down to label7
# BB#41:                                # %bar.exit408.7
	i32.const	$1=, 8
	i64.load	$4=, 0($2):p2align=0
	i32.const	$push622=, 8
	i32.const	$10=, 296
	i32.add 	$10=, $43, $10
	i32.add 	$push220=, $10, $pop622
	i32.const	$push621=, 8
	i32.add 	$push218=, $2, $pop621
	i32.load8_u	$push219=, 0($pop218)
	i32.store8	$discard=, 0($pop220):p2align=3, $pop219
	i64.store	$discard=, 296($43), $4
	i32.const	$push216=, 0
	i32.const	$push620=, 1
	i32.add 	$push34=, $0, $pop620
	i32.store	$0=, bar.lastc($pop216), $pop34
	i32.const	$push217=, 60
	i32.add 	$push35=, $9, $pop217
	i32.store	$6=, 4($43), $pop35
	i32.const	$8=, 8
	i32.const	$2=, 0
.LBB1_42:                               # %for.body104
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.const	$11=, 296
	i32.add 	$11=, $43, $11
	i32.add 	$push221=, $11, $2
	i32.load8_s	$3=, 0($pop221)
	block
	i32.const	$push436=, 9
	i32.eq  	$push222=, $8, $pop436
	br_if   	0, $pop222      # 0: down to label12
# BB#43:                                # %if.then.i412
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.ne  	$push223=, $0, $8
	br_if   	3, $pop223      # 3: down to label8
# BB#44:                                # %if.end.i414
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.const	$push225=, 0
	i32.const	$push437=, 0
	i32.store	$0=, bar.lastc($pop225), $pop437
	i32.const	$push224=, 9
	i32.store	$1=, bar.lastn($0), $pop224
.LBB1_45:                               # %if.end3.i419
                                        #   in Loop: Header=BB1_42 Depth=1
	end_block                       # label12:
	i32.const	$push440=, 24
	i32.shl 	$push226=, $0, $pop440
	i32.const	$push439=, 24
	i32.shr_s	$push227=, $pop226, $pop439
	i32.const	$push438=, 72
	i32.xor 	$push228=, $pop227, $pop438
	i32.ne  	$push229=, $pop228, $3
	br_if   	2, $pop229      # 2: down to label8
# BB#46:                                # %bar.exit422
                                        #   in Loop: Header=BB1_42 Depth=1
	i32.const	$push444=, 0
	i32.const	$push443=, 1
	i32.add 	$push5=, $0, $pop443
	i32.store	$0=, bar.lastc($pop444), $pop5
	i32.const	$push442=, 1
	i32.add 	$2=, $2, $pop442
	i32.const	$8=, 9
	i32.const	$push441=, 9
	i32.lt_s	$push230=, $2, $pop441
	br_if   	0, $pop230      # 0: up to label10
# BB#47:                                # %for.end110
	end_loop                        # label11:
	i64.load	$4=, 0($6):p2align=0
	i32.const	$push232=, 8
	i32.const	$12=, 280
	i32.add 	$12=, $43, $12
	i32.add 	$push235=, $12, $pop232
	i32.const	$push445=, 8
	i32.add 	$push233=, $6, $pop445
	i32.load16_u	$push234=, 0($pop233):p2align=0
	i32.store16	$discard=, 0($pop235):p2align=3, $pop234
	i64.store	$discard=, 280($43), $4
	i32.const	$push231=, 72
	i32.add 	$push6=, $9, $pop231
	i32.store	$6=, 4($43), $pop6
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_48:                               # %for.body116
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$13=, 280
	i32.add 	$13=, $43, $13
	i32.add 	$push236=, $13, $2
	i32.load8_s	$3=, 0($pop236)
	block
	i32.const	$push446=, 10
	i32.eq  	$push237=, $8, $pop446
	br_if   	0, $pop237      # 0: down to label15
# BB#49:                                # %if.then.i426
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.ne  	$push238=, $0, $8
	br_if   	3, $pop238      # 3: down to label8
# BB#50:                                # %if.end.i428
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.const	$push240=, 0
	i32.const	$push447=, 0
	i32.store	$0=, bar.lastc($pop240), $pop447
	i32.const	$push239=, 10
	i32.store	$1=, bar.lastn($0), $pop239
.LBB1_51:                               # %if.end3.i433
                                        #   in Loop: Header=BB1_48 Depth=1
	end_block                       # label15:
	i32.const	$push450=, 24
	i32.shl 	$push241=, $0, $pop450
	i32.const	$push449=, 24
	i32.shr_s	$push242=, $pop241, $pop449
	i32.const	$push448=, 80
	i32.xor 	$push243=, $pop242, $pop448
	i32.ne  	$push244=, $pop243, $3
	br_if   	2, $pop244      # 2: down to label8
# BB#52:                                # %bar.exit436
                                        #   in Loop: Header=BB1_48 Depth=1
	i32.const	$push454=, 0
	i32.const	$push453=, 1
	i32.add 	$push7=, $0, $pop453
	i32.store	$0=, bar.lastc($pop454), $pop7
	i32.const	$push452=, 1
	i32.add 	$2=, $2, $pop452
	i32.const	$8=, 10
	i32.const	$push451=, 10
	i32.lt_s	$push245=, $2, $pop451
	br_if   	0, $pop245      # 0: up to label13
# BB#53:                                # %for.end122
	end_loop                        # label14:
	i64.load	$4=, 0($6):p2align=0
	i32.const	$push251=, 8
	i32.add 	$push252=, $6, $pop251
	i32.load16_u	$2=, 0($pop252):p2align=0
	i32.const	$push247=, 10
	i32.const	$14=, 264
	i32.add 	$14=, $43, $14
	i32.add 	$push250=, $14, $pop247
	i32.const	$push456=, 10
	i32.add 	$push248=, $6, $pop456
	i32.load8_u	$push249=, 0($pop248)
	i32.store8	$discard=, 0($pop250):p2align=1, $pop249
	i32.const	$push455=, 8
	i32.const	$15=, 264
	i32.add 	$15=, $43, $15
	i32.add 	$push253=, $15, $pop455
	i32.store16	$discard=, 0($pop253):p2align=3, $2
	i64.store	$discard=, 264($43), $4
	i32.const	$push246=, 84
	i32.add 	$push8=, $9, $pop246
	i32.store	$6=, 4($43), $pop8
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_54:                               # %for.body128
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$16=, 264
	i32.add 	$16=, $43, $16
	i32.add 	$push254=, $16, $2
	i32.load8_s	$3=, 0($pop254)
	block
	i32.const	$push457=, 11
	i32.eq  	$push255=, $8, $pop457
	br_if   	0, $pop255      # 0: down to label18
# BB#55:                                # %if.then.i440
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.ne  	$push256=, $0, $8
	br_if   	3, $pop256      # 3: down to label8
# BB#56:                                # %if.end.i442
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.const	$push258=, 0
	i32.const	$push458=, 0
	i32.store	$0=, bar.lastc($pop258), $pop458
	i32.const	$push257=, 11
	i32.store	$1=, bar.lastn($0), $pop257
.LBB1_57:                               # %if.end3.i447
                                        #   in Loop: Header=BB1_54 Depth=1
	end_block                       # label18:
	i32.const	$push461=, 24
	i32.shl 	$push259=, $0, $pop461
	i32.const	$push460=, 24
	i32.shr_s	$push260=, $pop259, $pop460
	i32.const	$push459=, 88
	i32.xor 	$push261=, $pop260, $pop459
	i32.ne  	$push262=, $pop261, $3
	br_if   	2, $pop262      # 2: down to label8
# BB#58:                                # %bar.exit450
                                        #   in Loop: Header=BB1_54 Depth=1
	i32.const	$push465=, 0
	i32.const	$push464=, 1
	i32.add 	$push9=, $0, $pop464
	i32.store	$0=, bar.lastc($pop465), $pop9
	i32.const	$push463=, 1
	i32.add 	$2=, $2, $pop463
	i32.const	$8=, 11
	i32.const	$push462=, 11
	i32.lt_s	$push263=, $2, $pop462
	br_if   	0, $pop263      # 0: up to label16
# BB#59:                                # %for.end134
	end_loop                        # label17:
	i64.load	$4=, 0($6):p2align=0
	i32.const	$push264=, 8
	i32.const	$17=, 248
	i32.add 	$17=, $43, $17
	i32.add 	$push267=, $17, $pop264
	i32.const	$push467=, 8
	i32.add 	$push265=, $6, $pop467
	i32.load	$push266=, 0($pop265):p2align=0
	i32.store	$discard=, 0($pop267):p2align=3, $pop266
	i64.store	$discard=, 248($43), $4
	i32.const	$push466=, 96
	i32.add 	$push10=, $9, $pop466
	i32.store	$6=, 4($43), $pop10
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_60:                               # %for.body140
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$18=, 248
	i32.add 	$18=, $43, $18
	i32.add 	$push268=, $18, $2
	i32.load8_s	$3=, 0($pop268)
	block
	i32.const	$push468=, 12
	i32.eq  	$push269=, $8, $pop468
	br_if   	0, $pop269      # 0: down to label21
# BB#61:                                # %if.then.i454
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.ne  	$push270=, $0, $8
	br_if   	3, $pop270      # 3: down to label8
# BB#62:                                # %if.end.i456
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.const	$push272=, 0
	i32.const	$push469=, 0
	i32.store	$0=, bar.lastc($pop272), $pop469
	i32.const	$push271=, 12
	i32.store	$1=, bar.lastn($0), $pop271
.LBB1_63:                               # %if.end3.i461
                                        #   in Loop: Header=BB1_60 Depth=1
	end_block                       # label21:
	i32.const	$push472=, 24
	i32.shl 	$push273=, $0, $pop472
	i32.const	$push471=, 24
	i32.shr_s	$push274=, $pop273, $pop471
	i32.const	$push470=, 96
	i32.xor 	$push275=, $pop274, $pop470
	i32.ne  	$push276=, $pop275, $3
	br_if   	2, $pop276      # 2: down to label8
# BB#64:                                # %bar.exit464
                                        #   in Loop: Header=BB1_60 Depth=1
	i32.const	$push476=, 0
	i32.const	$push475=, 1
	i32.add 	$push11=, $0, $pop475
	i32.store	$0=, bar.lastc($pop476), $pop11
	i32.const	$push474=, 1
	i32.add 	$2=, $2, $pop474
	i32.const	$8=, 12
	i32.const	$push473=, 12
	i32.lt_s	$push277=, $2, $pop473
	br_if   	0, $pop277      # 0: up to label19
# BB#65:                                # %for.end146
	end_loop                        # label20:
	i64.load	$4=, 0($6):p2align=0
	i32.const	$push283=, 8
	i32.add 	$push284=, $6, $pop283
	i32.load	$2=, 0($pop284):p2align=0
	i32.const	$push279=, 12
	i32.const	$19=, 232
	i32.add 	$19=, $43, $19
	i32.add 	$push282=, $19, $pop279
	i32.const	$push478=, 12
	i32.add 	$push280=, $6, $pop478
	i32.load8_u	$push281=, 0($pop280)
	i32.store8	$discard=, 0($pop282):p2align=2, $pop281
	i32.const	$push477=, 8
	i32.const	$20=, 232
	i32.add 	$20=, $43, $20
	i32.add 	$push285=, $20, $pop477
	i32.store	$discard=, 0($pop285):p2align=3, $2
	i64.store	$discard=, 232($43), $4
	i32.const	$push278=, 112
	i32.add 	$push12=, $9, $pop278
	i32.store	$6=, 4($43), $pop12
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_66:                               # %for.body152
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.const	$21=, 232
	i32.add 	$21=, $43, $21
	i32.add 	$push286=, $21, $2
	i32.load8_s	$3=, 0($pop286)
	block
	i32.const	$push479=, 13
	i32.eq  	$push287=, $8, $pop479
	br_if   	0, $pop287      # 0: down to label24
# BB#67:                                # %if.then.i468
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.ne  	$push288=, $0, $8
	br_if   	3, $pop288      # 3: down to label8
# BB#68:                                # %if.end.i470
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.const	$push290=, 0
	i32.const	$push480=, 0
	i32.store	$0=, bar.lastc($pop290), $pop480
	i32.const	$push289=, 13
	i32.store	$1=, bar.lastn($0), $pop289
.LBB1_69:                               # %if.end3.i475
                                        #   in Loop: Header=BB1_66 Depth=1
	end_block                       # label24:
	i32.const	$push483=, 24
	i32.shl 	$push291=, $0, $pop483
	i32.const	$push482=, 24
	i32.shr_s	$push292=, $pop291, $pop482
	i32.const	$push481=, 104
	i32.xor 	$push293=, $pop292, $pop481
	i32.ne  	$push294=, $pop293, $3
	br_if   	2, $pop294      # 2: down to label8
# BB#70:                                # %bar.exit478
                                        #   in Loop: Header=BB1_66 Depth=1
	i32.const	$push487=, 0
	i32.const	$push486=, 1
	i32.add 	$push13=, $0, $pop486
	i32.store	$0=, bar.lastc($pop487), $pop13
	i32.const	$push485=, 1
	i32.add 	$2=, $2, $pop485
	i32.const	$8=, 13
	i32.const	$push484=, 13
	i32.lt_s	$push295=, $2, $pop484
	br_if   	0, $pop295      # 0: up to label22
# BB#71:                                # %for.end158
	end_loop                        # label23:
	i64.load	$4=, 0($6):p2align=0
	i32.const	$push301=, 8
	i32.add 	$push302=, $6, $pop301
	i32.load	$2=, 0($pop302):p2align=0
	i32.const	$push297=, 12
	i32.const	$22=, 216
	i32.add 	$22=, $43, $22
	i32.add 	$push300=, $22, $pop297
	i32.const	$push489=, 12
	i32.add 	$push298=, $6, $pop489
	i32.load16_u	$push299=, 0($pop298):p2align=0
	i32.store16	$discard=, 0($pop300):p2align=2, $pop299
	i32.const	$push488=, 8
	i32.const	$23=, 216
	i32.add 	$23=, $43, $23
	i32.add 	$push303=, $23, $pop488
	i32.store	$discard=, 0($pop303):p2align=3, $2
	i64.store	$discard=, 216($43), $4
	i32.const	$push296=, 128
	i32.add 	$push14=, $9, $pop296
	i32.store	$6=, 4($43), $pop14
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_72:                               # %for.body164
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$24=, 216
	i32.add 	$24=, $43, $24
	i32.add 	$push304=, $24, $2
	i32.load8_s	$3=, 0($pop304)
	block
	i32.const	$push490=, 14
	i32.eq  	$push305=, $8, $pop490
	br_if   	0, $pop305      # 0: down to label27
# BB#73:                                # %if.then.i482
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.ne  	$push306=, $0, $8
	br_if   	3, $pop306      # 3: down to label8
# BB#74:                                # %if.end.i484
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.const	$push308=, 0
	i32.const	$push491=, 0
	i32.store	$0=, bar.lastc($pop308), $pop491
	i32.const	$push307=, 14
	i32.store	$1=, bar.lastn($0), $pop307
.LBB1_75:                               # %if.end3.i489
                                        #   in Loop: Header=BB1_72 Depth=1
	end_block                       # label27:
	i32.const	$push494=, 24
	i32.shl 	$push309=, $0, $pop494
	i32.const	$push493=, 24
	i32.shr_s	$push310=, $pop309, $pop493
	i32.const	$push492=, 112
	i32.xor 	$push311=, $pop310, $pop492
	i32.ne  	$push312=, $pop311, $3
	br_if   	2, $pop312      # 2: down to label8
# BB#76:                                # %bar.exit492
                                        #   in Loop: Header=BB1_72 Depth=1
	i32.const	$push498=, 0
	i32.const	$push497=, 1
	i32.add 	$push15=, $0, $pop497
	i32.store	$0=, bar.lastc($pop498), $pop15
	i32.const	$push496=, 1
	i32.add 	$2=, $2, $pop496
	i32.const	$8=, 14
	i32.const	$push495=, 14
	i32.lt_s	$push313=, $2, $pop495
	br_if   	0, $pop313      # 0: up to label25
# BB#77:                                # %for.end170
	end_loop                        # label26:
	i32.const	$push315=, 14
	i32.const	$25=, 200
	i32.add 	$25=, $43, $25
	i32.add 	$push318=, $25, $pop315
	i32.const	$push501=, 14
	i32.add 	$push316=, $6, $pop501
	i32.load8_u	$push317=, 0($pop316)
	i32.store8	$discard=, 0($pop318):p2align=1, $pop317
	i64.load	$4=, 0($6):p2align=0
	i32.const	$push323=, 8
	i32.add 	$push324=, $6, $pop323
	i32.load	$2=, 0($pop324):p2align=0
	i32.const	$push319=, 12
	i32.const	$26=, 200
	i32.add 	$26=, $43, $26
	i32.add 	$push322=, $26, $pop319
	i32.const	$push500=, 12
	i32.add 	$push320=, $6, $pop500
	i32.load16_u	$push321=, 0($pop320):p2align=0
	i32.store16	$discard=, 0($pop322):p2align=2, $pop321
	i32.const	$push499=, 8
	i32.const	$27=, 200
	i32.add 	$27=, $43, $27
	i32.add 	$push325=, $27, $pop499
	i32.store	$discard=, 0($pop325):p2align=3, $2
	i64.store	$discard=, 200($43), $4
	i32.const	$push314=, 144
	i32.add 	$push16=, $9, $pop314
	i32.store	$6=, 4($43), $pop16
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_78:                               # %for.body176
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	i32.const	$28=, 200
	i32.add 	$28=, $43, $28
	i32.add 	$push326=, $28, $2
	i32.load8_s	$3=, 0($pop326)
	block
	i32.const	$push502=, 15
	i32.eq  	$push327=, $8, $pop502
	br_if   	0, $pop327      # 0: down to label30
# BB#79:                                # %if.then.i496
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.ne  	$push328=, $0, $8
	br_if   	3, $pop328      # 3: down to label8
# BB#80:                                # %if.end.i498
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.const	$push330=, 0
	i32.const	$push503=, 0
	i32.store	$0=, bar.lastc($pop330), $pop503
	i32.const	$push329=, 15
	i32.store	$1=, bar.lastn($0), $pop329
.LBB1_81:                               # %if.end3.i503
                                        #   in Loop: Header=BB1_78 Depth=1
	end_block                       # label30:
	i32.const	$push506=, 24
	i32.shl 	$push331=, $0, $pop506
	i32.const	$push505=, 24
	i32.shr_s	$push332=, $pop331, $pop505
	i32.const	$push504=, 120
	i32.xor 	$push333=, $pop332, $pop504
	i32.ne  	$push334=, $pop333, $3
	br_if   	2, $pop334      # 2: down to label8
# BB#82:                                # %bar.exit506
                                        #   in Loop: Header=BB1_78 Depth=1
	i32.const	$push510=, 0
	i32.const	$push509=, 1
	i32.add 	$push17=, $0, $pop509
	i32.store	$0=, bar.lastc($pop510), $pop17
	i32.const	$push508=, 1
	i32.add 	$2=, $2, $pop508
	i32.const	$8=, 15
	i32.const	$push507=, 15
	i32.lt_s	$push335=, $2, $pop507
	br_if   	0, $pop335      # 0: up to label28
# BB#83:                                # %for.end182
	end_loop                        # label29:
	i64.load	$4=, 0($6):p2align=0
	i32.const	$push341=, 8
	i32.add 	$push342=, $6, $pop341
	i32.load	$2=, 0($pop342):p2align=0
	i32.const	$push337=, 12
	i32.const	$29=, 184
	i32.add 	$29=, $43, $29
	i32.add 	$push340=, $29, $pop337
	i32.const	$push512=, 12
	i32.add 	$push338=, $6, $pop512
	i32.load	$push339=, 0($pop338):p2align=0
	i32.store	$discard=, 0($pop340), $pop339
	i32.const	$push511=, 8
	i32.const	$30=, 184
	i32.add 	$30=, $43, $30
	i32.add 	$push343=, $30, $pop511
	i32.store	$discard=, 0($pop343):p2align=3, $2
	i64.store	$discard=, 184($43), $4
	i32.const	$push336=, 160
	i32.add 	$push18=, $9, $pop336
	i32.store	$5=, 4($43), $pop18
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_84:                               # %for.body188
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$31=, 184
	i32.add 	$31=, $43, $31
	i32.add 	$push344=, $31, $2
	i32.load8_s	$3=, 0($pop344)
	block
	i32.const	$push513=, 16
	i32.eq  	$push345=, $8, $pop513
	br_if   	0, $pop345      # 0: down to label33
# BB#85:                                # %if.then.i510
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.ne  	$push346=, $0, $8
	br_if   	3, $pop346      # 3: down to label8
# BB#86:                                # %if.end.i512
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.const	$push348=, 0
	i32.const	$push514=, 0
	i32.store	$0=, bar.lastc($pop348), $pop514
	i32.const	$push347=, 16
	i32.store	$1=, bar.lastn($0), $pop347
.LBB1_87:                               # %if.end3.i517
                                        #   in Loop: Header=BB1_84 Depth=1
	end_block                       # label33:
	i32.const	$push517=, 24
	i32.shl 	$push349=, $0, $pop517
	i32.const	$push516=, -2147483648
	i32.xor 	$push350=, $pop349, $pop516
	i32.const	$push515=, 24
	i32.shr_s	$push351=, $pop350, $pop515
	i32.ne  	$push352=, $pop351, $3
	br_if   	2, $pop352      # 2: down to label8
# BB#88:                                # %bar.exit520
                                        #   in Loop: Header=BB1_84 Depth=1
	i32.const	$push521=, 0
	i32.const	$push520=, 1
	i32.add 	$push19=, $0, $pop520
	i32.store	$0=, bar.lastc($pop521), $pop19
	i32.const	$push519=, 1
	i32.add 	$2=, $2, $pop519
	i32.const	$8=, 16
	i32.const	$push518=, 16
	i32.lt_s	$push353=, $2, $pop518
	br_if   	0, $pop353      # 0: up to label31
# BB#89:                                # %for.end194
	end_loop                        # label32:
	i32.const	$push354=, 192
	i32.add 	$push20=, $9, $pop354
	i32.store	$6=, 4($43), $pop20
	i32.const	$push522=, 31
	i32.const	$32=, 152
	i32.add 	$32=, $43, $32
	i32.call	$discard=, memcpy@FUNCTION, $32, $5, $pop522
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_90:                               # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label34:
	i32.const	$33=, 152
	i32.add 	$33=, $43, $33
	i32.add 	$push355=, $33, $2
	i32.load8_s	$3=, 0($pop355)
	block
	i32.const	$push523=, 31
	i32.eq  	$push356=, $8, $pop523
	br_if   	0, $pop356      # 0: down to label36
# BB#91:                                # %if.then.i524
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.ne  	$push357=, $0, $8
	br_if   	3, $pop357      # 3: down to label8
# BB#92:                                # %if.end.i526
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.const	$push359=, 0
	i32.const	$push524=, 0
	i32.store	$0=, bar.lastc($pop359), $pop524
	i32.const	$push358=, 31
	i32.store	$1=, bar.lastn($0), $pop358
.LBB1_93:                               # %if.end3.i531
                                        #   in Loop: Header=BB1_90 Depth=1
	end_block                       # label36:
	i32.const	$push527=, 24
	i32.shl 	$push360=, $0, $pop527
	i32.const	$push526=, -134217728
	i32.xor 	$push361=, $pop360, $pop526
	i32.const	$push525=, 24
	i32.shr_s	$push362=, $pop361, $pop525
	i32.ne  	$push363=, $pop362, $3
	br_if   	2, $pop363      # 2: down to label8
# BB#94:                                # %bar.exit534
                                        #   in Loop: Header=BB1_90 Depth=1
	i32.const	$push531=, 0
	i32.const	$push530=, 1
	i32.add 	$push21=, $0, $pop530
	i32.store	$0=, bar.lastc($pop531), $pop21
	i32.const	$push529=, 1
	i32.add 	$2=, $2, $pop529
	i32.const	$8=, 31
	i32.const	$push528=, 31
	i32.lt_s	$push364=, $2, $pop528
	br_if   	0, $pop364      # 0: up to label34
# BB#95:                                # %for.end206
	end_loop                        # label35:
	i32.const	$push536=, 24
	i32.add 	$push370=, $6, $pop536
	i32.load	$2=, 0($pop370):p2align=0
	i32.const	$push366=, 28
	i32.const	$34=, 120
	i32.add 	$34=, $43, $34
	i32.add 	$push369=, $34, $pop366
	i32.const	$push535=, 28
	i32.add 	$push367=, $6, $pop535
	i32.load	$push368=, 0($pop367):p2align=0
	i32.store	$discard=, 0($pop369), $pop368
	i32.const	$push534=, 24
	i32.const	$35=, 120
	i32.add 	$35=, $43, $35
	i32.add 	$push371=, $35, $pop534
	i32.store	$discard=, 0($pop371):p2align=3, $2
	i32.const	$push376=, 8
	i32.add 	$push377=, $6, $pop376
	i64.load	$4=, 0($pop377):p2align=0
	i64.load	$7=, 0($6):p2align=0
	i32.const	$push372=, 16
	i32.const	$36=, 120
	i32.add 	$36=, $43, $36
	i32.add 	$push375=, $36, $pop372
	i32.const	$push533=, 16
	i32.add 	$push373=, $6, $pop533
	i64.load	$push374=, 0($pop373):p2align=0
	i64.store	$discard=, 0($pop375), $pop374
	i32.const	$push532=, 8
	i32.const	$37=, 120
	i32.add 	$37=, $43, $37
	i32.add 	$push378=, $37, $pop532
	i64.store	$discard=, 0($pop378), $4
	i64.store	$discard=, 120($43), $7
	i32.const	$push365=, 224
	i32.add 	$push22=, $9, $pop365
	i32.store	$6=, 4($43), $pop22
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_96:                               # %for.body212
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label37:
	i32.const	$38=, 120
	i32.add 	$38=, $43, $38
	i32.add 	$push379=, $38, $2
	i32.load8_s	$3=, 0($pop379)
	block
	i32.const	$push537=, 32
	i32.eq  	$push380=, $8, $pop537
	br_if   	0, $pop380      # 0: down to label39
# BB#97:                                # %if.then.i538
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.ne  	$push381=, $0, $8
	br_if   	3, $pop381      # 3: down to label8
# BB#98:                                # %if.end.i540
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.const	$push383=, 0
	i32.const	$push538=, 0
	i32.store	$0=, bar.lastc($pop383), $pop538
	i32.const	$push382=, 32
	i32.store	$1=, bar.lastn($0), $pop382
.LBB1_99:                               # %if.end3.i545
                                        #   in Loop: Header=BB1_96 Depth=1
	end_block                       # label39:
	i32.const	$push540=, 24
	i32.shl 	$push384=, $0, $pop540
	i32.const	$push539=, 24
	i32.shr_s	$push385=, $pop384, $pop539
	i32.ne  	$push386=, $pop385, $3
	br_if   	2, $pop386      # 2: down to label8
# BB#100:                               # %bar.exit548
                                        #   in Loop: Header=BB1_96 Depth=1
	i32.const	$push544=, 0
	i32.const	$push543=, 1
	i32.add 	$push23=, $0, $pop543
	i32.store	$0=, bar.lastc($pop544), $pop23
	i32.const	$push542=, 1
	i32.add 	$2=, $2, $pop542
	i32.const	$8=, 32
	i32.const	$push541=, 32
	i32.lt_s	$push387=, $2, $pop541
	br_if   	0, $pop387      # 0: up to label37
# BB#101:                               # %for.end218
	end_loop                        # label38:
	i32.const	$push388=, 260
	i32.add 	$push24=, $9, $pop388
	i32.store	$5=, 4($43), $pop24
	i32.const	$push545=, 35
	i32.const	$39=, 80
	i32.add 	$39=, $43, $39
	i32.call	$discard=, memcpy@FUNCTION, $39, $6, $pop545
	copy_local	$8=, $1
	i32.const	$2=, 0
.LBB1_102:                              # %for.body224
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label40:
	i32.const	$40=, 80
	i32.add 	$40=, $43, $40
	i32.add 	$push389=, $40, $2
	i32.load8_s	$3=, 0($pop389)
	block
	i32.const	$push546=, 35
	i32.eq  	$push390=, $8, $pop546
	br_if   	0, $pop390      # 0: down to label42
# BB#103:                               # %if.then.i552
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.ne  	$push391=, $0, $8
	br_if   	3, $pop391      # 3: down to label8
# BB#104:                               # %if.end.i554
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.const	$push393=, 0
	i32.const	$push547=, 0
	i32.store	$0=, bar.lastc($pop393), $pop547
	i32.const	$push392=, 35
	i32.store	$1=, bar.lastn($0), $pop392
.LBB1_105:                              # %if.end3.i559
                                        #   in Loop: Header=BB1_102 Depth=1
	end_block                       # label42:
	i32.const	$push550=, 24
	i32.shl 	$push394=, $0, $pop550
	i32.const	$push549=, 24
	i32.shr_s	$push395=, $pop394, $pop549
	i32.const	$push548=, 24
	i32.xor 	$push396=, $pop395, $pop548
	i32.ne  	$push397=, $pop396, $3
	br_if   	2, $pop397      # 2: down to label8
# BB#106:                               # %bar.exit562
                                        #   in Loop: Header=BB1_102 Depth=1
	i32.const	$push554=, 0
	i32.const	$push553=, 1
	i32.add 	$push25=, $0, $pop553
	i32.store	$0=, bar.lastc($pop554), $pop25
	i32.const	$push552=, 1
	i32.add 	$2=, $2, $pop552
	i32.const	$8=, 35
	i32.const	$push551=, 35
	i32.lt_s	$push398=, $2, $pop551
	br_if   	0, $pop398      # 0: up to label40
# BB#107:                               # %for.end230
	end_loop                        # label41:
	i32.const	$push399=, 332
	i32.add 	$push400=, $9, $pop399
	i32.store	$discard=, 4($43), $pop400
	i32.const	$push555=, 72
	i32.const	$41=, 8
	i32.add 	$41=, $43, $41
	i32.call	$discard=, memcpy@FUNCTION, $41, $5, $pop555
	i32.const	$2=, 0
.LBB1_108:                              # %for.body236
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label43:
	i32.const	$42=, 8
	i32.add 	$42=, $43, $42
	i32.add 	$push401=, $42, $2
	i32.load8_s	$8=, 0($pop401)
	block
	i32.const	$push556=, 72
	i32.eq  	$push402=, $1, $pop556
	br_if   	0, $pop402      # 0: down to label45
# BB#109:                               # %if.then.i566
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.ne  	$push403=, $0, $1
	br_if   	3, $pop403      # 3: down to label8
# BB#110:                               # %if.end.i568
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.const	$push404=, 0
	i32.const	$push558=, 0
	i32.store	$0=, bar.lastc($pop404), $pop558
	i32.const	$push557=, 72
	i32.store	$discard=, bar.lastn($0), $pop557
.LBB1_111:                              # %if.end3.i573
                                        #   in Loop: Header=BB1_108 Depth=1
	end_block                       # label45:
	i32.const	$push561=, 24
	i32.shl 	$push405=, $0, $pop561
	i32.const	$push560=, 24
	i32.shr_s	$push406=, $pop405, $pop560
	i32.const	$push559=, 64
	i32.xor 	$push407=, $pop406, $pop559
	i32.ne  	$push408=, $pop407, $8
	br_if   	2, $pop408      # 2: down to label8
# BB#112:                               # %bar.exit576
                                        #   in Loop: Header=BB1_108 Depth=1
	i32.const	$push565=, 0
	i32.const	$push564=, 1
	i32.add 	$push26=, $0, $pop564
	i32.store	$0=, bar.lastc($pop565), $pop26
	i32.const	$push563=, 1
	i32.add 	$2=, $2, $pop563
	i32.const	$1=, 72
	i32.const	$push562=, 72
	i32.lt_s	$push409=, $2, $pop562
	br_if   	0, $pop409      # 0: up to label43
# BB#113:                               # %for.end242
	end_loop                        # label44:
	i32.const	$push627=, 352
	i32.add 	$43=, $43, $pop627
	i32.const	$push628=, __stack_pointer
	i32.store	$discard=, 0($pop628), $43
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push324=, __stack_pointer
	i32.load	$push325=, 0($pop324)
	i32.const	$push326=, 768
	i32.sub 	$68=, $pop325, $pop326
	i32.const	$push327=, __stack_pointer
	i32.store	$discard=, 0($pop327), $68
	i32.const	$push0=, 16
	i32.store8	$discard=, 760($68):p2align=3, $pop0
	i32.const	$push1=, 17
	i32.store8	$discard=, 761($68), $pop1
	i32.const	$push2=, 24
	i32.store8	$discard=, 752($68):p2align=3, $pop2
	i32.const	$push3=, 25
	i32.store8	$discard=, 753($68), $pop3
	i32.const	$push4=, 26
	i32.store8	$discard=, 754($68):p2align=1, $pop4
	i32.const	$push5=, 32
	i32.store8	$discard=, 744($68):p2align=3, $pop5
	i32.const	$push6=, 33
	i32.store8	$discard=, 745($68), $pop6
	i32.const	$push7=, 34
	i32.store8	$discard=, 746($68):p2align=1, $pop7
	i32.const	$push8=, 35
	i32.store8	$discard=, 747($68), $pop8
	i32.const	$push9=, 40
	i32.store8	$discard=, 736($68):p2align=3, $pop9
	i32.const	$push10=, 41
	i32.store8	$discard=, 737($68), $pop10
	i32.const	$push11=, 42
	i32.store8	$discard=, 738($68):p2align=1, $pop11
	i32.const	$push12=, 43
	i32.store8	$discard=, 739($68), $pop12
	i32.const	$push13=, 44
	i32.store8	$discard=, 740($68):p2align=2, $pop13
	i32.const	$push14=, 48
	i32.store8	$discard=, 728($68):p2align=3, $pop14
	i32.const	$push15=, 49
	i32.store8	$discard=, 729($68), $pop15
	i32.const	$push16=, 50
	i32.store8	$discard=, 730($68):p2align=1, $pop16
	i32.const	$push17=, 51
	i32.store8	$discard=, 731($68), $pop17
	i32.const	$push18=, 52
	i32.store8	$discard=, 732($68):p2align=2, $pop18
	i32.const	$push19=, 53
	i32.store8	$discard=, 733($68), $pop19
	i32.const	$push20=, 56
	i32.store8	$discard=, 720($68):p2align=3, $pop20
	i32.const	$push21=, 57
	i32.store8	$discard=, 721($68), $pop21
	i32.const	$push22=, 58
	i32.store8	$discard=, 722($68):p2align=1, $pop22
	i32.const	$push23=, 59
	i32.store8	$discard=, 723($68), $pop23
	i32.const	$push24=, 60
	i32.store8	$discard=, 724($68):p2align=2, $pop24
	i32.const	$push25=, 61
	i32.store8	$discard=, 725($68), $pop25
	i32.const	$push26=, 62
	i32.store8	$discard=, 726($68):p2align=1, $pop26
	i32.const	$push29=, 65
	i32.store8	$discard=, 713($68), $pop29
	i32.const	$push30=, 66
	i32.store8	$discard=, 714($68):p2align=1, $pop30
	i32.const	$push31=, 67
	i32.store8	$discard=, 715($68), $pop31
	i32.const	$push32=, 68
	i32.store8	$discard=, 716($68):p2align=2, $pop32
	i32.const	$push33=, 69
	i32.store8	$discard=, 717($68), $pop33
	i32.const	$push34=, 70
	i32.store8	$discard=, 718($68):p2align=1, $pop34
	i32.const	$push35=, 71
	i32.store8	$discard=, 719($68), $pop35
	i32.const	$push36=, 72
	i32.store8	$discard=, 696($68):p2align=3, $pop36
	i32.const	$push37=, 73
	i32.store8	$discard=, 697($68), $pop37
	i32.const	$push38=, 74
	i32.store8	$discard=, 698($68):p2align=1, $pop38
	i32.const	$push39=, 75
	i32.store8	$discard=, 699($68), $pop39
	i32.const	$push40=, 76
	i32.store8	$discard=, 700($68):p2align=2, $pop40
	i32.const	$push41=, 77
	i32.store8	$discard=, 701($68), $pop41
	i32.const	$push42=, 78
	i32.store8	$discard=, 702($68):p2align=1, $pop42
	i32.const	$push43=, 79
	i32.store8	$discard=, 703($68), $pop43
	i32.const	$push27=, 64
	i32.store8	$push28=, 712($68):p2align=3, $pop27
	i32.store8	$discard=, 704($68):p2align=3, $pop28
	i32.const	$push50=, 83
	i32.store8	$discard=, 683($68), $pop50
	i32.const	$push51=, 84
	i32.store8	$discard=, 684($68):p2align=2, $pop51
	i32.const	$push52=, 85
	i32.store8	$discard=, 685($68), $pop52
	i32.const	$push53=, 86
	i32.store8	$discard=, 686($68):p2align=1, $pop53
	i32.const	$push54=, 87
	i32.store8	$discard=, 687($68), $pop54
	i32.const	$push55=, 88
	i32.store8	$push56=, 688($68):p2align=3, $pop55
	i32.store8	$discard=, 664($68):p2align=3, $pop56
	i32.const	$push57=, 89
	i32.store8	$push58=, 689($68), $pop57
	i32.store8	$discard=, 665($68), $pop58
	i32.const	$push59=, 90
	i32.store8	$discard=, 666($68):p2align=1, $pop59
	i32.const	$push60=, 91
	i32.store8	$discard=, 667($68), $pop60
	i32.const	$push61=, 92
	i32.store8	$discard=, 668($68):p2align=2, $pop61
	i32.const	$push62=, 93
	i32.store8	$discard=, 669($68), $pop62
	i32.const	$push63=, 94
	i32.store8	$discard=, 670($68):p2align=1, $pop63
	i32.const	$push64=, 95
	i32.store8	$discard=, 671($68), $pop64
	i32.const	$push44=, 80
	i32.store8	$push45=, 680($68):p2align=3, $pop44
	i32.store8	$discard=, 672($68):p2align=3, $pop45
	i32.const	$push46=, 81
	i32.store8	$push47=, 681($68), $pop46
	i32.store8	$discard=, 673($68), $pop47
	i32.const	$push48=, 82
	i32.store8	$push49=, 682($68):p2align=1, $pop48
	i32.store8	$discard=, 674($68):p2align=1, $pop49
	i32.const	$push75=, 101
	i32.store8	$discard=, 653($68), $pop75
	i32.const	$push76=, 102
	i32.store8	$discard=, 654($68):p2align=1, $pop76
	i32.const	$push77=, 103
	i32.store8	$discard=, 655($68), $pop77
	i32.const	$push78=, 104
	i32.store8	$push79=, 656($68):p2align=3, $pop78
	i32.store8	$discard=, 632($68):p2align=3, $pop79
	i32.const	$push80=, 105
	i32.store8	$push81=, 657($68), $pop80
	i32.store8	$discard=, 633($68), $pop81
	i32.const	$push82=, 106
	i32.store8	$push83=, 658($68):p2align=1, $pop82
	i32.store8	$discard=, 634($68):p2align=1, $pop83
	i32.const	$push84=, 107
	i32.store8	$push85=, 659($68), $pop84
	i32.store8	$discard=, 635($68), $pop85
	i32.const	$push86=, 108
	i32.store8	$discard=, 636($68):p2align=2, $pop86
	i32.const	$push87=, 109
	i32.store8	$discard=, 637($68), $pop87
	i32.const	$push88=, 110
	i32.store8	$discard=, 638($68):p2align=1, $pop88
	i32.const	$push89=, 111
	i32.store8	$discard=, 639($68), $pop89
	i32.const	$push65=, 96
	i32.store8	$push66=, 648($68):p2align=3, $pop65
	i32.store8	$discard=, 640($68):p2align=3, $pop66
	i32.const	$push67=, 97
	i32.store8	$push68=, 649($68), $pop67
	i32.store8	$discard=, 641($68), $pop68
	i32.const	$push69=, 98
	i32.store8	$push70=, 650($68):p2align=1, $pop69
	i32.store8	$discard=, 642($68):p2align=1, $pop70
	i32.const	$push71=, 99
	i32.store8	$push72=, 651($68), $pop71
	i32.store8	$discard=, 643($68), $pop72
	i32.const	$push73=, 100
	i32.store8	$push74=, 652($68):p2align=2, $pop73
	i32.store8	$discard=, 644($68):p2align=2, $pop74
	i32.const	$push104=, 119
	i32.store8	$discard=, 623($68), $pop104
	i32.const	$push105=, 120
	i32.store8	$push106=, 624($68):p2align=3, $pop105
	i32.store8	$discard=, 600($68):p2align=3, $pop106
	i32.const	$push107=, 121
	i32.store8	$push108=, 625($68), $pop107
	i32.store8	$discard=, 601($68), $pop108
	i32.const	$push109=, 122
	i32.store8	$push110=, 626($68):p2align=1, $pop109
	i32.store8	$discard=, 602($68):p2align=1, $pop110
	i32.const	$push111=, 123
	i32.store8	$push112=, 627($68), $pop111
	i32.store8	$discard=, 603($68), $pop112
	i32.const	$push113=, 124
	i32.store8	$push114=, 628($68):p2align=2, $pop113
	i32.store8	$discard=, 604($68):p2align=2, $pop114
	i32.const	$push115=, 125
	i32.store8	$push116=, 629($68), $pop115
	i32.store8	$discard=, 605($68), $pop116
	i32.const	$push117=, 126
	i32.store8	$discard=, 606($68):p2align=1, $pop117
	i32.const	$push118=, 127
	i32.store8	$discard=, 607($68), $pop118
	i32.const	$push90=, 112
	i32.store8	$push91=, 616($68):p2align=3, $pop90
	i32.store8	$discard=, 608($68):p2align=3, $pop91
	i32.const	$push92=, 113
	i32.store8	$push93=, 617($68), $pop92
	i32.store8	$discard=, 609($68), $pop93
	i32.const	$push94=, 114
	i32.store8	$push95=, 618($68):p2align=1, $pop94
	i32.store8	$discard=, 610($68):p2align=1, $pop95
	i32.const	$push96=, 115
	i32.store8	$push97=, 619($68), $pop96
	i32.store8	$discard=, 611($68), $pop97
	i32.const	$push98=, 116
	i32.store8	$push99=, 620($68):p2align=2, $pop98
	i32.store8	$discard=, 612($68):p2align=2, $pop99
	i32.const	$push100=, 117
	i32.store8	$push101=, 621($68), $pop100
	i32.store8	$discard=, 613($68), $pop101
	i32.const	$push102=, 118
	i32.store8	$push103=, 622($68):p2align=1, $pop102
	i32.store8	$discard=, 614($68):p2align=1, $pop103
	i32.const	$push119=, 128
	i32.store8	$discard=, 584($68):p2align=3, $pop119
	i32.const	$push120=, 129
	i32.store8	$discard=, 585($68), $pop120
	i32.const	$push121=, 130
	i32.store8	$discard=, 586($68):p2align=1, $pop121
	i32.const	$push122=, 131
	i32.store8	$discard=, 587($68), $pop122
	i32.const	$push123=, 132
	i32.store8	$discard=, 588($68):p2align=2, $pop123
	i32.const	$push124=, 133
	i32.store8	$discard=, 589($68), $pop124
	i32.const	$push125=, 134
	i32.store8	$discard=, 590($68):p2align=1, $pop125
	i32.const	$push126=, 135
	i32.store8	$discard=, 591($68), $pop126
	i32.const	$push127=, 136
	i32.store8	$discard=, 592($68):p2align=3, $pop127
	i32.const	$push128=, 137
	i32.store8	$discard=, 593($68), $pop128
	i32.const	$push129=, 138
	i32.store8	$discard=, 594($68):p2align=1, $pop129
	i32.const	$push130=, 139
	i32.store8	$discard=, 595($68), $pop130
	i32.const	$push131=, 140
	i32.store8	$discard=, 596($68):p2align=2, $pop131
	i32.const	$push132=, 141
	i32.store8	$discard=, 597($68), $pop132
	i32.const	$push133=, 142
	i32.store8	$discard=, 598($68):p2align=1, $pop133
	i32.const	$push134=, 143
	i32.store8	$discard=, 599($68), $pop134
	i32.const	$2=, 0
.LBB2_1:                                # %for.body180
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label46:
	i32.const	$3=, 552
	i32.add 	$3=, $68, $3
	i32.add 	$push136=, $3, $2
	i32.const	$push286=, 248
	i32.xor 	$push135=, $2, $pop286
	i32.store8	$discard=, 0($pop136), $pop135
	i32.const	$push285=, 1
	i32.add 	$2=, $2, $pop285
	i32.const	$push284=, 31
	i32.ne  	$push137=, $2, $pop284
	br_if   	0, $pop137      # 0: up to label46
# BB#2:                                 # %for.body191.preheader
	end_loop                        # label47:
	i32.const	$push138=, 50462976
	i32.store	$discard=, 520($68):p2align=3, $pop138
	i32.const	$push139=, 1284
	i32.store16	$discard=, 524($68):p2align=2, $pop139
	i32.const	$push140=, 151521030
	i32.store	$discard=, 526($68):p2align=1, $pop140
	i32.const	$push141=, 2826
	i32.store16	$discard=, 530($68), $pop141
	i32.const	$push142=, 3340
	i32.store16	$discard=, 532($68):p2align=2, $pop142
	i32.const	$push143=, 14
	i32.store8	$discard=, 534($68):p2align=1, $pop143
	i32.const	$push144=, 15
	i32.store8	$discard=, 535($68), $pop144
	i32.const	$push145=, 16
	i32.store8	$discard=, 536($68):p2align=3, $pop145
	i32.const	$push146=, 17
	i32.store8	$discard=, 537($68), $pop146
	i32.const	$push147=, 18
	i32.store8	$discard=, 538($68):p2align=1, $pop147
	i32.const	$push148=, 19
	i32.store8	$discard=, 539($68), $pop148
	i32.const	$push149=, 20
	i32.store8	$discard=, 540($68):p2align=2, $pop149
	i32.const	$push150=, 21
	i32.store8	$discard=, 541($68), $pop150
	i32.const	$push151=, 22
	i32.store8	$discard=, 542($68):p2align=1, $pop151
	i32.const	$push152=, 23
	i32.store8	$discard=, 543($68), $pop152
	i32.const	$push154=, 25
	i32.store8	$discard=, 545($68), $pop154
	i32.const	$push155=, 26
	i32.store8	$discard=, 546($68):p2align=1, $pop155
	i32.const	$push156=, 27
	i32.store8	$discard=, 547($68), $pop156
	i32.const	$push157=, 28
	i32.store8	$discard=, 548($68):p2align=2, $pop157
	i32.const	$push158=, 29
	i32.store8	$discard=, 549($68), $pop158
	i32.const	$push159=, 30
	i32.store8	$discard=, 550($68):p2align=1, $pop159
	i32.const	$push160=, 31
	i32.store8	$discard=, 551($68), $pop160
	i32.const	$push153=, 24
	i32.store8	$0=, 544($68):p2align=3, $pop153
	i32.const	$2=, 0
	i32.const	$1=, 0
.LBB2_3:                                # %for.body202
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label48:
	i32.const	$4=, 480
	i32.add 	$4=, $68, $4
	i32.add 	$push162=, $4, $1
	i32.xor 	$push161=, $1, $0
	i32.store8	$discard=, 0($pop162), $pop161
	i32.const	$push288=, 1
	i32.add 	$1=, $1, $pop288
	i32.const	$push287=, 35
	i32.ne  	$push163=, $1, $pop287
	br_if   	0, $pop163      # 0: up to label48
.LBB2_4:                                # %for.body213
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label49:
	loop                            # label50:
	i32.const	$5=, 408
	i32.add 	$5=, $68, $5
	i32.add 	$push165=, $5, $2
	i32.const	$push291=, 64
	i32.xor 	$push164=, $2, $pop291
	i32.store8	$discard=, 0($pop165), $pop164
	i32.const	$push290=, 1
	i32.add 	$2=, $2, $pop290
	i32.const	$push289=, 72
	i32.ne  	$push166=, $2, $pop289
	br_if   	0, $pop166      # 0: up to label50
# BB#5:                                 # %for.end220
	end_loop                        # label51:
	i32.load16_u	$push167=, 760($68):p2align=3
	i32.store16	$discard=, 406($68), $pop167
	i32.const	$push168=, 2
	i32.const	$6=, 402
	i32.add 	$6=, $68, $6
	i32.add 	$push169=, $6, $pop168
	i32.load8_u	$push170=, 754($68):p2align=1
	i32.store8	$discard=, 0($pop169):p2align=1, $pop170
	i32.load16_u	$push171=, 752($68):p2align=3
	i32.store16	$discard=, 402($68), $pop171
	i32.load	$push172=, 744($68):p2align=3
	i32.store	$discard=, 396($68), $pop172
	i32.const	$push173=, 4
	i32.const	$7=, 388
	i32.add 	$7=, $68, $7
	i32.add 	$push174=, $7, $pop173
	i32.load8_u	$push175=, 740($68):p2align=2
	i32.store8	$discard=, 0($pop174):p2align=2, $pop175
	i32.load	$push176=, 736($68):p2align=3
	i32.store	$discard=, 388($68), $pop176
	i32.const	$push323=, 4
	i32.const	$8=, 380
	i32.add 	$8=, $68, $8
	i32.add 	$push177=, $8, $pop323
	i32.load16_u	$push178=, 732($68):p2align=2
	i32.store16	$discard=, 0($pop177):p2align=2, $pop178
	i32.load	$push179=, 728($68):p2align=3
	i32.store	$discard=, 380($68), $pop179
	i32.const	$push180=, 6
	i32.const	$9=, 372
	i32.add 	$9=, $68, $9
	i32.add 	$push181=, $9, $pop180
	i32.load8_u	$push182=, 726($68):p2align=1
	i32.store8	$discard=, 0($pop181):p2align=1, $pop182
	i32.const	$push322=, 4
	i32.const	$10=, 372
	i32.add 	$10=, $68, $10
	i32.add 	$push183=, $10, $pop322
	i32.load16_u	$push184=, 724($68):p2align=2
	i32.store16	$discard=, 0($pop183):p2align=2, $pop184
	i32.load	$push185=, 720($68):p2align=3
	i32.store	$discard=, 372($68), $pop185
	i64.load	$push186=, 712($68)
	i64.store	$discard=, 364($68):p2align=2, $pop186
	i32.const	$push187=, 8
	i32.const	$11=, 352
	i32.add 	$11=, $68, $11
	i32.add 	$push188=, $11, $pop187
	i32.const	$push321=, 8
	i32.const	$12=, 696
	i32.add 	$12=, $68, $12
	i32.add 	$push189=, $12, $pop321
	i32.load8_u	$push190=, 0($pop189):p2align=3
	i32.store8	$discard=, 0($pop188):p2align=2, $pop190
	i64.load	$push191=, 696($68)
	i64.store	$discard=, 352($68):p2align=2, $pop191
	i32.const	$push320=, 8
	i32.const	$13=, 340
	i32.add 	$13=, $68, $13
	i32.add 	$push192=, $13, $pop320
	i32.const	$push319=, 8
	i32.const	$14=, 680
	i32.add 	$14=, $68, $14
	i32.add 	$push193=, $14, $pop319
	i32.load16_u	$push194=, 0($pop193):p2align=3
	i32.store16	$discard=, 0($pop192):p2align=2, $pop194
	i64.load	$push195=, 680($68)
	i64.store	$discard=, 340($68):p2align=2, $pop195
	i32.const	$push196=, 10
	i32.const	$15=, 328
	i32.add 	$15=, $68, $15
	i32.add 	$push197=, $15, $pop196
	i32.const	$push318=, 10
	i32.const	$16=, 664
	i32.add 	$16=, $68, $16
	i32.add 	$push198=, $16, $pop318
	i32.load8_u	$push199=, 0($pop198):p2align=1
	i32.store8	$discard=, 0($pop197):p2align=1, $pop199
	i32.const	$push317=, 8
	i32.const	$17=, 328
	i32.add 	$17=, $68, $17
	i32.add 	$push200=, $17, $pop317
	i32.const	$push316=, 8
	i32.const	$18=, 664
	i32.add 	$18=, $68, $18
	i32.add 	$push201=, $18, $pop316
	i32.load16_u	$push202=, 0($pop201):p2align=3
	i32.store16	$discard=, 0($pop200):p2align=2, $pop202
	i64.load	$push203=, 664($68)
	i64.store	$discard=, 328($68):p2align=2, $pop203
	i32.const	$push315=, 8
	i32.const	$19=, 316
	i32.add 	$19=, $68, $19
	i32.add 	$push204=, $19, $pop315
	i32.const	$push314=, 8
	i32.const	$20=, 648
	i32.add 	$20=, $68, $20
	i32.add 	$push205=, $20, $pop314
	i32.load	$push206=, 0($pop205):p2align=3
	i32.store	$discard=, 0($pop204), $pop206
	i64.load	$push207=, 648($68)
	i64.store	$discard=, 316($68):p2align=2, $pop207
	i32.const	$push208=, 12
	i32.const	$21=, 300
	i32.add 	$21=, $68, $21
	i32.add 	$push209=, $21, $pop208
	i32.const	$push313=, 12
	i32.const	$22=, 632
	i32.add 	$22=, $68, $22
	i32.add 	$push210=, $22, $pop313
	i32.load8_u	$push211=, 0($pop210):p2align=2
	i32.store8	$discard=, 0($pop209):p2align=2, $pop211
	i32.const	$push312=, 8
	i32.const	$23=, 300
	i32.add 	$23=, $68, $23
	i32.add 	$push212=, $23, $pop312
	i32.const	$push311=, 8
	i32.const	$24=, 632
	i32.add 	$24=, $68, $24
	i32.add 	$push213=, $24, $pop311
	i32.load	$push214=, 0($pop213):p2align=3
	i32.store	$discard=, 0($pop212), $pop214
	i64.load	$push215=, 632($68)
	i64.store	$discard=, 300($68):p2align=2, $pop215
	i32.const	$push310=, 12
	i32.const	$25=, 284
	i32.add 	$25=, $68, $25
	i32.add 	$push216=, $25, $pop310
	i32.const	$push309=, 12
	i32.const	$26=, 616
	i32.add 	$26=, $68, $26
	i32.add 	$push217=, $26, $pop309
	i32.load16_u	$push218=, 0($pop217):p2align=2
	i32.store16	$discard=, 0($pop216):p2align=2, $pop218
	i32.const	$push308=, 8
	i32.const	$27=, 284
	i32.add 	$27=, $68, $27
	i32.add 	$push219=, $27, $pop308
	i32.const	$push307=, 8
	i32.const	$28=, 616
	i32.add 	$28=, $68, $28
	i32.add 	$push220=, $28, $pop307
	i32.load	$push221=, 0($pop220):p2align=3
	i32.store	$discard=, 0($pop219), $pop221
	i64.load	$push222=, 616($68)
	i64.store	$discard=, 284($68):p2align=2, $pop222
	i32.const	$push223=, 14
	i32.const	$29=, 268
	i32.add 	$29=, $68, $29
	i32.add 	$push224=, $29, $pop223
	i32.const	$push306=, 14
	i32.const	$30=, 600
	i32.add 	$30=, $68, $30
	i32.add 	$push225=, $30, $pop306
	i32.load8_u	$push226=, 0($pop225):p2align=1
	i32.store8	$discard=, 0($pop224):p2align=1, $pop226
	i32.const	$push305=, 12
	i32.const	$31=, 268
	i32.add 	$31=, $68, $31
	i32.add 	$push227=, $31, $pop305
	i32.const	$push304=, 12
	i32.const	$32=, 600
	i32.add 	$32=, $68, $32
	i32.add 	$push228=, $32, $pop304
	i32.load16_u	$push229=, 0($pop228):p2align=2
	i32.store16	$discard=, 0($pop227):p2align=2, $pop229
	i32.const	$push303=, 8
	i32.const	$33=, 268
	i32.add 	$33=, $68, $33
	i32.add 	$push230=, $33, $pop303
	i32.const	$push302=, 8
	i32.const	$34=, 600
	i32.add 	$34=, $68, $34
	i32.add 	$push231=, $34, $pop302
	i32.load	$push232=, 0($pop231):p2align=3
	i32.store	$discard=, 0($pop230), $pop232
	i64.load	$push233=, 600($68)
	i64.store	$discard=, 268($68):p2align=2, $pop233
	i32.const	$push301=, 8
	i32.const	$35=, 252
	i32.add 	$35=, $68, $35
	i32.add 	$push234=, $35, $pop301
	i32.const	$push300=, 8
	i32.const	$36=, 584
	i32.add 	$36=, $68, $36
	i32.add 	$push235=, $36, $pop300
	i64.load	$push236=, 0($pop235)
	i64.store	$discard=, 0($pop234):p2align=2, $pop236
	i64.load	$push237=, 584($68)
	i64.store	$discard=, 252($68):p2align=2, $pop237
	i32.const	$push238=, 31
	i32.const	$37=, 221
	i32.add 	$37=, $68, $37
	i32.const	$38=, 552
	i32.add 	$38=, $68, $38
	i32.call	$discard=, memcpy@FUNCTION, $37, $38, $pop238
	i32.const	$push239=, 24
	i32.const	$39=, 188
	i32.add 	$39=, $68, $39
	i32.add 	$push240=, $39, $pop239
	i32.const	$push299=, 24
	i32.const	$40=, 520
	i32.add 	$40=, $68, $40
	i32.add 	$push241=, $40, $pop299
	i64.load	$push242=, 0($pop241)
	i64.store	$discard=, 0($pop240):p2align=2, $pop242
	i32.const	$push243=, 16
	i32.const	$41=, 188
	i32.add 	$41=, $68, $41
	i32.add 	$push244=, $41, $pop243
	i32.const	$push298=, 16
	i32.const	$42=, 520
	i32.add 	$42=, $68, $42
	i32.add 	$push245=, $42, $pop298
	i64.load	$push246=, 0($pop245)
	i64.store	$discard=, 0($pop244):p2align=2, $pop246
	i32.const	$push297=, 8
	i32.const	$43=, 188
	i32.add 	$43=, $68, $43
	i32.add 	$push247=, $43, $pop297
	i32.const	$push296=, 8
	i32.const	$44=, 520
	i32.add 	$44=, $68, $44
	i32.add 	$push248=, $44, $pop296
	i64.load	$push249=, 0($pop248)
	i64.store	$discard=, 0($pop247):p2align=2, $pop249
	i64.load	$push250=, 520($68)
	i64.store	$discard=, 188($68):p2align=2, $pop250
	i32.const	$push251=, 35
	i32.const	$45=, 153
	i32.add 	$45=, $68, $45
	i32.const	$46=, 480
	i32.add 	$46=, $68, $46
	i32.call	$discard=, memcpy@FUNCTION, $45, $46, $pop251
	i32.const	$push252=, 72
	i32.const	$47=, 81
	i32.add 	$47=, $68, $47
	i32.const	$48=, 408
	i32.add 	$48=, $68, $48
	i32.call	$discard=, memcpy@FUNCTION, $47, $48, $pop252
	i32.const	$push253=, 76
	i32.add 	$push254=, $68, $pop253
	i32.const	$49=, 81
	i32.add 	$49=, $68, $49
	i32.store	$discard=, 0($pop254), $49
	i32.const	$push295=, 72
	i32.add 	$push255=, $68, $pop295
	i32.const	$50=, 153
	i32.add 	$50=, $68, $50
	i32.store	$discard=, 0($pop255):p2align=3, $50
	i32.const	$push256=, 68
	i32.add 	$push257=, $68, $pop256
	i32.const	$51=, 188
	i32.add 	$51=, $68, $51
	i32.store	$discard=, 0($pop257), $51
	i32.const	$push258=, 64
	i32.add 	$push259=, $68, $pop258
	i32.const	$52=, 221
	i32.add 	$52=, $68, $52
	i32.store	$discard=, 0($pop259):p2align=4, $52
	i32.const	$push260=, 60
	i32.add 	$push261=, $68, $pop260
	i32.const	$53=, 252
	i32.add 	$53=, $68, $53
	i32.store	$discard=, 0($pop261), $53
	i32.const	$push262=, 56
	i32.add 	$push263=, $68, $pop262
	i32.const	$54=, 268
	i32.add 	$54=, $68, $54
	i32.store	$discard=, 0($pop263):p2align=3, $54
	i32.const	$push264=, 52
	i32.add 	$push265=, $68, $pop264
	i32.const	$55=, 284
	i32.add 	$55=, $68, $55
	i32.store	$discard=, 0($pop265), $55
	i32.const	$push266=, 48
	i32.add 	$push267=, $68, $pop266
	i32.const	$56=, 300
	i32.add 	$56=, $68, $56
	i32.store	$discard=, 0($pop267):p2align=4, $56
	i32.const	$push268=, 44
	i32.add 	$push269=, $68, $pop268
	i32.const	$57=, 316
	i32.add 	$57=, $68, $57
	i32.store	$discard=, 0($pop269), $57
	i32.const	$push270=, 40
	i32.add 	$push271=, $68, $pop270
	i32.const	$58=, 328
	i32.add 	$58=, $68, $58
	i32.store	$discard=, 0($pop271):p2align=3, $58
	i32.const	$push272=, 36
	i32.add 	$push273=, $68, $pop272
	i32.const	$59=, 340
	i32.add 	$59=, $68, $59
	i32.store	$discard=, 0($pop273), $59
	i32.const	$push274=, 32
	i32.add 	$push275=, $68, $pop274
	i32.const	$60=, 352
	i32.add 	$60=, $68, $60
	i32.store	$discard=, 0($pop275):p2align=4, $60
	i32.const	$push276=, 28
	i32.add 	$push277=, $68, $pop276
	i32.const	$61=, 364
	i32.add 	$61=, $68, $61
	i32.store	$discard=, 0($pop277), $61
	i32.const	$push294=, 24
	i32.add 	$push278=, $68, $pop294
	i32.const	$62=, 372
	i32.add 	$62=, $68, $62
	i32.store	$discard=, 0($pop278):p2align=3, $62
	i32.const	$push279=, 20
	i32.add 	$push280=, $68, $pop279
	i32.const	$63=, 380
	i32.add 	$63=, $68, $63
	i32.store	$discard=, 0($pop280), $63
	i32.const	$push293=, 16
	i32.add 	$push281=, $68, $pop293
	i32.const	$64=, 388
	i32.add 	$64=, $68, $64
	i32.store	$discard=, 0($pop281):p2align=4, $64
	i32.const	$push292=, 8
	i32.store	$discard=, 0($68):p2align=4, $pop292
	i32.const	$65=, 396
	i32.add 	$65=, $68, $65
	i32.store	$discard=, 12($68), $65
	i32.const	$66=, 402
	i32.add 	$66=, $68, $66
	i32.store	$discard=, 8($68):p2align=3, $66
	i32.const	$67=, 406
	i32.add 	$67=, $68, $67
	i32.store	$discard=, 4($68), $67
	i32.const	$push282=, 21
	call    	foo@FUNCTION, $pop282, $68
	i32.const	$push283=, 0
	call    	exit@FUNCTION, $pop283
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
