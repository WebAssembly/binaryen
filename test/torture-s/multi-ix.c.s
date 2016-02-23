	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/multi-ix.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push342=, __stack_pointer
	i32.load	$push343=, 0($pop342)
	i32.const	$push344=, 80480
	i32.sub 	$275=, $pop343, $pop344
	i32.const	$push345=, __stack_pointer
	i32.store	$discard=, 0($pop345), $275
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push341=, 156
	i32.const	$41=, 320
	i32.add 	$41=, $275, $41
	i32.add 	$push2=, $41, $pop341
	i32.const	$42=, 480
	i32.add 	$42=, $275, $42
	i32.store	$discard=, 0($pop2), $42
	i32.const	$push340=, 152
	i32.const	$43=, 320
	i32.add 	$43=, $275, $43
	i32.add 	$push3=, $43, $pop340
	i32.const	$44=, 2480
	i32.add 	$44=, $275, $44
	i32.store	$discard=, 0($pop3):p2align=3, $44
	i32.const	$push339=, 148
	i32.const	$45=, 320
	i32.add 	$45=, $275, $45
	i32.add 	$push4=, $45, $pop339
	i32.const	$46=, 4480
	i32.add 	$46=, $275, $46
	i32.store	$discard=, 0($pop4), $46
	i32.const	$push338=, 144
	i32.const	$47=, 320
	i32.add 	$47=, $275, $47
	i32.add 	$push5=, $47, $pop338
	i32.const	$48=, 6480
	i32.add 	$48=, $275, $48
	i32.store	$discard=, 0($pop5):p2align=4, $48
	i32.const	$push337=, 140
	i32.const	$49=, 320
	i32.add 	$49=, $275, $49
	i32.add 	$push6=, $49, $pop337
	i32.const	$50=, 8480
	i32.add 	$50=, $275, $50
	i32.store	$discard=, 0($pop6), $50
	i32.const	$push336=, 136
	i32.const	$51=, 320
	i32.add 	$51=, $275, $51
	i32.add 	$push7=, $51, $pop336
	i32.const	$52=, 10480
	i32.add 	$52=, $275, $52
	i32.store	$discard=, 0($pop7):p2align=3, $52
	i32.const	$push335=, 132
	i32.const	$53=, 320
	i32.add 	$53=, $275, $53
	i32.add 	$push8=, $53, $pop335
	i32.const	$54=, 12480
	i32.add 	$54=, $275, $54
	i32.store	$discard=, 0($pop8), $54
	i32.const	$push334=, 128
	i32.const	$55=, 320
	i32.add 	$55=, $275, $55
	i32.add 	$push9=, $55, $pop334
	i32.const	$56=, 14480
	i32.add 	$56=, $275, $56
	i32.store	$discard=, 0($pop9):p2align=4, $56
	i32.const	$push333=, 124
	i32.const	$57=, 320
	i32.add 	$57=, $275, $57
	i32.add 	$push10=, $57, $pop333
	i32.const	$58=, 16480
	i32.add 	$58=, $275, $58
	i32.store	$discard=, 0($pop10), $58
	i32.const	$push332=, 120
	i32.const	$59=, 320
	i32.add 	$59=, $275, $59
	i32.add 	$push11=, $59, $pop332
	i32.const	$60=, 18480
	i32.add 	$60=, $275, $60
	i32.store	$discard=, 0($pop11):p2align=3, $60
	i32.const	$push331=, 116
	i32.const	$61=, 320
	i32.add 	$61=, $275, $61
	i32.add 	$push12=, $61, $pop331
	i32.const	$62=, 20480
	i32.add 	$62=, $275, $62
	i32.store	$discard=, 0($pop12), $62
	i32.const	$push330=, 112
	i32.const	$63=, 320
	i32.add 	$63=, $275, $63
	i32.add 	$push13=, $63, $pop330
	i32.const	$64=, 22480
	i32.add 	$64=, $275, $64
	i32.store	$discard=, 0($pop13):p2align=4, $64
	i32.const	$push329=, 108
	i32.const	$65=, 320
	i32.add 	$65=, $275, $65
	i32.add 	$push14=, $65, $pop329
	i32.const	$66=, 24480
	i32.add 	$66=, $275, $66
	i32.store	$discard=, 0($pop14), $66
	i32.const	$push328=, 104
	i32.const	$67=, 320
	i32.add 	$67=, $275, $67
	i32.add 	$push15=, $67, $pop328
	i32.const	$68=, 26480
	i32.add 	$68=, $275, $68
	i32.store	$discard=, 0($pop15):p2align=3, $68
	i32.const	$push327=, 100
	i32.const	$69=, 320
	i32.add 	$69=, $275, $69
	i32.add 	$push16=, $69, $pop327
	i32.const	$70=, 28480
	i32.add 	$70=, $275, $70
	i32.store	$discard=, 0($pop16), $70
	i32.const	$push326=, 96
	i32.const	$71=, 320
	i32.add 	$71=, $275, $71
	i32.add 	$push17=, $71, $pop326
	i32.const	$72=, 30480
	i32.add 	$72=, $275, $72
	i32.store	$discard=, 0($pop17):p2align=4, $72
	i32.const	$push325=, 92
	i32.const	$73=, 320
	i32.add 	$73=, $275, $73
	i32.add 	$push18=, $73, $pop325
	i32.const	$74=, 32480
	i32.add 	$74=, $275, $74
	i32.store	$discard=, 0($pop18), $74
	i32.const	$push324=, 88
	i32.const	$75=, 320
	i32.add 	$75=, $275, $75
	i32.add 	$push19=, $75, $pop324
	i32.const	$76=, 34480
	i32.add 	$76=, $275, $76
	i32.store	$discard=, 0($pop19):p2align=3, $76
	i32.const	$push323=, 84
	i32.const	$77=, 320
	i32.add 	$77=, $275, $77
	i32.add 	$push20=, $77, $pop323
	i32.const	$78=, 36480
	i32.add 	$78=, $275, $78
	i32.store	$discard=, 0($pop20), $78
	i32.const	$push322=, 80
	i32.const	$79=, 320
	i32.add 	$79=, $275, $79
	i32.add 	$push21=, $79, $pop322
	i32.const	$80=, 38480
	i32.add 	$80=, $275, $80
	i32.store	$discard=, 0($pop21):p2align=4, $80
	i32.const	$push321=, 76
	i32.const	$81=, 320
	i32.add 	$81=, $275, $81
	i32.add 	$push22=, $81, $pop321
	i32.const	$82=, 40480
	i32.add 	$82=, $275, $82
	i32.store	$discard=, 0($pop22), $82
	i32.const	$push320=, 72
	i32.const	$83=, 320
	i32.add 	$83=, $275, $83
	i32.add 	$push23=, $83, $pop320
	i32.const	$84=, 42480
	i32.add 	$84=, $275, $84
	i32.store	$discard=, 0($pop23):p2align=3, $84
	i32.const	$push319=, 68
	i32.const	$85=, 320
	i32.add 	$85=, $275, $85
	i32.add 	$push24=, $85, $pop319
	i32.const	$86=, 44480
	i32.add 	$86=, $275, $86
	i32.store	$discard=, 0($pop24), $86
	i32.const	$push318=, 64
	i32.const	$87=, 320
	i32.add 	$87=, $275, $87
	i32.add 	$push25=, $87, $pop318
	i32.const	$88=, 46480
	i32.add 	$88=, $275, $88
	i32.store	$discard=, 0($pop25):p2align=4, $88
	i32.const	$push317=, 60
	i32.const	$89=, 320
	i32.add 	$89=, $275, $89
	i32.add 	$push26=, $89, $pop317
	i32.const	$90=, 48480
	i32.add 	$90=, $275, $90
	i32.store	$discard=, 0($pop26), $90
	i32.const	$push316=, 56
	i32.const	$91=, 320
	i32.add 	$91=, $275, $91
	i32.add 	$push27=, $91, $pop316
	i32.const	$92=, 50480
	i32.add 	$92=, $275, $92
	i32.store	$discard=, 0($pop27):p2align=3, $92
	i32.const	$push315=, 52
	i32.const	$93=, 320
	i32.add 	$93=, $275, $93
	i32.add 	$push28=, $93, $pop315
	i32.const	$94=, 52480
	i32.add 	$94=, $275, $94
	i32.store	$discard=, 0($pop28), $94
	i32.const	$push314=, 48
	i32.const	$95=, 320
	i32.add 	$95=, $275, $95
	i32.add 	$push29=, $95, $pop314
	i32.const	$96=, 54480
	i32.add 	$96=, $275, $96
	i32.store	$discard=, 0($pop29):p2align=4, $96
	i32.const	$push313=, 44
	i32.const	$97=, 320
	i32.add 	$97=, $275, $97
	i32.add 	$push30=, $97, $pop313
	i32.const	$98=, 56480
	i32.add 	$98=, $275, $98
	i32.store	$discard=, 0($pop30), $98
	i32.const	$push312=, 40
	i32.const	$99=, 320
	i32.add 	$99=, $275, $99
	i32.add 	$push31=, $99, $pop312
	i32.const	$100=, 58480
	i32.add 	$100=, $275, $100
	i32.store	$discard=, 0($pop31):p2align=3, $100
	i32.const	$push311=, 36
	i32.const	$101=, 320
	i32.add 	$101=, $275, $101
	i32.add 	$push32=, $101, $pop311
	i32.const	$102=, 60480
	i32.add 	$102=, $275, $102
	i32.store	$discard=, 0($pop32), $102
	i32.const	$push310=, 32
	i32.const	$103=, 320
	i32.add 	$103=, $275, $103
	i32.add 	$push33=, $103, $pop310
	i32.const	$104=, 62480
	i32.add 	$104=, $275, $104
	i32.store	$discard=, 0($pop33):p2align=4, $104
	i32.const	$push309=, 28
	i32.const	$105=, 320
	i32.add 	$105=, $275, $105
	i32.add 	$push34=, $105, $pop309
	i32.const	$106=, 64480
	i32.add 	$106=, $275, $106
	i32.store	$discard=, 0($pop34), $106
	i32.const	$push308=, 24
	i32.const	$107=, 320
	i32.add 	$107=, $275, $107
	i32.add 	$push35=, $107, $pop308
	i32.const	$108=, 66480
	i32.add 	$108=, $275, $108
	i32.store	$discard=, 0($pop35):p2align=3, $108
	i32.const	$push307=, 20
	i32.const	$109=, 320
	i32.add 	$109=, $275, $109
	i32.add 	$push36=, $109, $pop307
	i32.const	$110=, 68480
	i32.add 	$110=, $275, $110
	i32.store	$discard=, 0($pop36), $110
	i32.const	$push306=, 16
	i32.const	$111=, 320
	i32.add 	$111=, $275, $111
	i32.add 	$push37=, $111, $pop306
	i32.const	$112=, 70480
	i32.add 	$112=, $275, $112
	i32.store	$discard=, 0($pop37):p2align=4, $112
	i32.const	$113=, 72480
	i32.add 	$113=, $275, $113
	i32.store	$discard=, 332($275), $113
	i32.const	$114=, 74480
	i32.add 	$114=, $275, $114
	i32.store	$discard=, 328($275):p2align=3, $114
	i32.const	$115=, 76480
	i32.add 	$115=, $275, $115
	i32.store	$discard=, 324($275), $115
	i32.const	$116=, 78480
	i32.add 	$116=, $275, $116
	i32.store	$discard=, 320($275):p2align=4, $116
	i32.const	$push305=, 40
	i32.const	$117=, 320
	i32.add 	$117=, $275, $117
	call    	s@FUNCTION, $pop305, $117
	i32.load	$1=, 78480($275):p2align=4
	i32.load	$2=, 76480($275):p2align=4
	i32.load	$3=, 74480($275):p2align=4
	i32.load	$4=, 72480($275):p2align=4
	i32.load	$5=, 70480($275):p2align=4
	i32.load	$6=, 68480($275):p2align=4
	i32.load	$7=, 66480($275):p2align=4
	i32.load	$8=, 64480($275):p2align=4
	i32.load	$9=, 62480($275):p2align=4
	i32.load	$10=, 60480($275):p2align=4
	i32.load	$11=, 58480($275):p2align=4
	i32.load	$12=, 56480($275):p2align=4
	i32.load	$13=, 54480($275):p2align=4
	i32.load	$14=, 52480($275):p2align=4
	i32.load	$15=, 50480($275):p2align=4
	i32.load	$16=, 48480($275):p2align=4
	i32.load	$17=, 46480($275):p2align=4
	i32.load	$18=, 44480($275):p2align=4
	i32.load	$19=, 42480($275):p2align=4
	i32.load	$20=, 40480($275):p2align=4
	i32.load	$21=, 38480($275):p2align=4
	i32.load	$22=, 36480($275):p2align=4
	i32.load	$23=, 34480($275):p2align=4
	i32.load	$24=, 32480($275):p2align=4
	i32.load	$25=, 30480($275):p2align=4
	i32.load	$26=, 28480($275):p2align=4
	i32.load	$27=, 26480($275):p2align=4
	i32.load	$28=, 24480($275):p2align=4
	i32.load	$29=, 22480($275):p2align=4
	i32.load	$30=, 20480($275):p2align=4
	i32.load	$31=, 18480($275):p2align=4
	i32.load	$32=, 16480($275):p2align=4
	i32.load	$33=, 14480($275):p2align=4
	i32.load	$34=, 12480($275):p2align=4
	i32.load	$35=, 10480($275):p2align=4
	i32.load	$36=, 8480($275):p2align=4
	i32.load	$37=, 6480($275):p2align=4
	i32.load	$38=, 4480($275):p2align=4
	i32.load	$39=, 2480($275):p2align=4
	i32.load	$40=, 480($275):p2align=4
	i32.const	$push304=, 156
	i32.const	$118=, 160
	i32.add 	$118=, $275, $118
	i32.add 	$push38=, $118, $pop304
	i32.const	$119=, 480
	i32.add 	$119=, $275, $119
	i32.store	$discard=, 0($pop38), $119
	i32.const	$push303=, 152
	i32.const	$120=, 160
	i32.add 	$120=, $275, $120
	i32.add 	$push39=, $120, $pop303
	i32.const	$121=, 2480
	i32.add 	$121=, $275, $121
	i32.store	$discard=, 0($pop39):p2align=3, $121
	i32.const	$push302=, 148
	i32.const	$122=, 160
	i32.add 	$122=, $275, $122
	i32.add 	$push40=, $122, $pop302
	i32.const	$123=, 4480
	i32.add 	$123=, $275, $123
	i32.store	$discard=, 0($pop40), $123
	i32.const	$push301=, 144
	i32.const	$124=, 160
	i32.add 	$124=, $275, $124
	i32.add 	$push41=, $124, $pop301
	i32.const	$125=, 6480
	i32.add 	$125=, $275, $125
	i32.store	$discard=, 0($pop41):p2align=4, $125
	i32.const	$push300=, 140
	i32.const	$126=, 160
	i32.add 	$126=, $275, $126
	i32.add 	$push42=, $126, $pop300
	i32.const	$127=, 8480
	i32.add 	$127=, $275, $127
	i32.store	$discard=, 0($pop42), $127
	i32.const	$push299=, 136
	i32.const	$128=, 160
	i32.add 	$128=, $275, $128
	i32.add 	$push43=, $128, $pop299
	i32.const	$129=, 10480
	i32.add 	$129=, $275, $129
	i32.store	$discard=, 0($pop43):p2align=3, $129
	i32.const	$push298=, 132
	i32.const	$130=, 160
	i32.add 	$130=, $275, $130
	i32.add 	$push44=, $130, $pop298
	i32.const	$131=, 12480
	i32.add 	$131=, $275, $131
	i32.store	$discard=, 0($pop44), $131
	i32.const	$push297=, 128
	i32.const	$132=, 160
	i32.add 	$132=, $275, $132
	i32.add 	$push45=, $132, $pop297
	i32.const	$133=, 14480
	i32.add 	$133=, $275, $133
	i32.store	$discard=, 0($pop45):p2align=4, $133
	i32.const	$push296=, 124
	i32.const	$134=, 160
	i32.add 	$134=, $275, $134
	i32.add 	$push46=, $134, $pop296
	i32.const	$135=, 16480
	i32.add 	$135=, $275, $135
	i32.store	$discard=, 0($pop46), $135
	i32.const	$push295=, 120
	i32.const	$136=, 160
	i32.add 	$136=, $275, $136
	i32.add 	$push47=, $136, $pop295
	i32.const	$137=, 18480
	i32.add 	$137=, $275, $137
	i32.store	$discard=, 0($pop47):p2align=3, $137
	i32.const	$push294=, 116
	i32.const	$138=, 160
	i32.add 	$138=, $275, $138
	i32.add 	$push48=, $138, $pop294
	i32.const	$139=, 20480
	i32.add 	$139=, $275, $139
	i32.store	$discard=, 0($pop48), $139
	i32.const	$push293=, 112
	i32.const	$140=, 160
	i32.add 	$140=, $275, $140
	i32.add 	$push49=, $140, $pop293
	i32.const	$141=, 22480
	i32.add 	$141=, $275, $141
	i32.store	$discard=, 0($pop49):p2align=4, $141
	i32.const	$push292=, 108
	i32.const	$142=, 160
	i32.add 	$142=, $275, $142
	i32.add 	$push50=, $142, $pop292
	i32.const	$143=, 24480
	i32.add 	$143=, $275, $143
	i32.store	$discard=, 0($pop50), $143
	i32.const	$push291=, 104
	i32.const	$144=, 160
	i32.add 	$144=, $275, $144
	i32.add 	$push51=, $144, $pop291
	i32.const	$145=, 26480
	i32.add 	$145=, $275, $145
	i32.store	$discard=, 0($pop51):p2align=3, $145
	i32.const	$push290=, 100
	i32.const	$146=, 160
	i32.add 	$146=, $275, $146
	i32.add 	$push52=, $146, $pop290
	i32.const	$147=, 28480
	i32.add 	$147=, $275, $147
	i32.store	$discard=, 0($pop52), $147
	i32.const	$push289=, 96
	i32.const	$148=, 160
	i32.add 	$148=, $275, $148
	i32.add 	$push53=, $148, $pop289
	i32.const	$149=, 30480
	i32.add 	$149=, $275, $149
	i32.store	$discard=, 0($pop53):p2align=4, $149
	i32.const	$push288=, 92
	i32.const	$150=, 160
	i32.add 	$150=, $275, $150
	i32.add 	$push54=, $150, $pop288
	i32.const	$151=, 32480
	i32.add 	$151=, $275, $151
	i32.store	$discard=, 0($pop54), $151
	i32.const	$push287=, 88
	i32.const	$152=, 160
	i32.add 	$152=, $275, $152
	i32.add 	$push55=, $152, $pop287
	i32.const	$153=, 34480
	i32.add 	$153=, $275, $153
	i32.store	$discard=, 0($pop55):p2align=3, $153
	i32.const	$push286=, 84
	i32.const	$154=, 160
	i32.add 	$154=, $275, $154
	i32.add 	$push56=, $154, $pop286
	i32.const	$155=, 36480
	i32.add 	$155=, $275, $155
	i32.store	$discard=, 0($pop56), $155
	i32.const	$push285=, 80
	i32.const	$156=, 160
	i32.add 	$156=, $275, $156
	i32.add 	$push57=, $156, $pop285
	i32.const	$157=, 38480
	i32.add 	$157=, $275, $157
	i32.store	$discard=, 0($pop57):p2align=4, $157
	i32.const	$push284=, 76
	i32.const	$158=, 160
	i32.add 	$158=, $275, $158
	i32.add 	$push58=, $158, $pop284
	i32.const	$159=, 40480
	i32.add 	$159=, $275, $159
	i32.store	$discard=, 0($pop58), $159
	i32.const	$push283=, 72
	i32.const	$160=, 160
	i32.add 	$160=, $275, $160
	i32.add 	$push59=, $160, $pop283
	i32.const	$161=, 42480
	i32.add 	$161=, $275, $161
	i32.store	$discard=, 0($pop59):p2align=3, $161
	i32.const	$push282=, 68
	i32.const	$162=, 160
	i32.add 	$162=, $275, $162
	i32.add 	$push60=, $162, $pop282
	i32.const	$163=, 44480
	i32.add 	$163=, $275, $163
	i32.store	$discard=, 0($pop60), $163
	i32.const	$push281=, 64
	i32.const	$164=, 160
	i32.add 	$164=, $275, $164
	i32.add 	$push61=, $164, $pop281
	i32.const	$165=, 46480
	i32.add 	$165=, $275, $165
	i32.store	$discard=, 0($pop61):p2align=4, $165
	i32.const	$push280=, 60
	i32.const	$166=, 160
	i32.add 	$166=, $275, $166
	i32.add 	$push62=, $166, $pop280
	i32.const	$167=, 48480
	i32.add 	$167=, $275, $167
	i32.store	$discard=, 0($pop62), $167
	i32.const	$push279=, 56
	i32.const	$168=, 160
	i32.add 	$168=, $275, $168
	i32.add 	$push63=, $168, $pop279
	i32.const	$169=, 50480
	i32.add 	$169=, $275, $169
	i32.store	$discard=, 0($pop63):p2align=3, $169
	i32.const	$push278=, 52
	i32.const	$170=, 160
	i32.add 	$170=, $275, $170
	i32.add 	$push64=, $170, $pop278
	i32.const	$171=, 52480
	i32.add 	$171=, $275, $171
	i32.store	$discard=, 0($pop64), $171
	i32.const	$push277=, 48
	i32.const	$172=, 160
	i32.add 	$172=, $275, $172
	i32.add 	$push65=, $172, $pop277
	i32.const	$173=, 54480
	i32.add 	$173=, $275, $173
	i32.store	$discard=, 0($pop65):p2align=4, $173
	i32.const	$push276=, 44
	i32.const	$174=, 160
	i32.add 	$174=, $275, $174
	i32.add 	$push66=, $174, $pop276
	i32.const	$175=, 56480
	i32.add 	$175=, $275, $175
	i32.store	$discard=, 0($pop66), $175
	i32.const	$push275=, 40
	i32.const	$176=, 160
	i32.add 	$176=, $275, $176
	i32.add 	$push67=, $176, $pop275
	i32.const	$177=, 58480
	i32.add 	$177=, $275, $177
	i32.store	$discard=, 0($pop67):p2align=3, $177
	i32.const	$push274=, 36
	i32.const	$178=, 160
	i32.add 	$178=, $275, $178
	i32.add 	$push68=, $178, $pop274
	i32.const	$179=, 60480
	i32.add 	$179=, $275, $179
	i32.store	$discard=, 0($pop68), $179
	i32.const	$push273=, 32
	i32.const	$180=, 160
	i32.add 	$180=, $275, $180
	i32.add 	$push69=, $180, $pop273
	i32.const	$181=, 62480
	i32.add 	$181=, $275, $181
	i32.store	$discard=, 0($pop69):p2align=4, $181
	i32.const	$push272=, 28
	i32.const	$182=, 160
	i32.add 	$182=, $275, $182
	i32.add 	$push70=, $182, $pop272
	i32.const	$183=, 64480
	i32.add 	$183=, $275, $183
	i32.store	$discard=, 0($pop70), $183
	i32.const	$push271=, 24
	i32.const	$184=, 160
	i32.add 	$184=, $275, $184
	i32.add 	$push71=, $184, $pop271
	i32.const	$185=, 66480
	i32.add 	$185=, $275, $185
	i32.store	$discard=, 0($pop71):p2align=3, $185
	i32.const	$push270=, 20
	i32.const	$186=, 160
	i32.add 	$186=, $275, $186
	i32.add 	$push72=, $186, $pop270
	i32.const	$187=, 68480
	i32.add 	$187=, $275, $187
	i32.store	$discard=, 0($pop72), $187
	i32.const	$push269=, 16
	i32.const	$188=, 160
	i32.add 	$188=, $275, $188
	i32.add 	$push73=, $188, $pop269
	i32.const	$189=, 70480
	i32.add 	$189=, $275, $189
	i32.store	$discard=, 0($pop73):p2align=4, $189
	i32.const	$190=, 72480
	i32.add 	$190=, $275, $190
	i32.store	$discard=, 172($275), $190
	i32.const	$191=, 74480
	i32.add 	$191=, $275, $191
	i32.store	$discard=, 168($275):p2align=3, $191
	i32.const	$192=, 76480
	i32.add 	$192=, $275, $192
	i32.store	$discard=, 164($275), $192
	i32.const	$193=, 78480
	i32.add 	$193=, $275, $193
	i32.store	$discard=, 160($275):p2align=4, $193
	i32.const	$push268=, 40
	i32.const	$194=, 160
	i32.add 	$194=, $275, $194
	call    	z@FUNCTION, $pop268, $194
	i32.const	$push267=, 2
	i32.shl 	$push74=, $1, $pop267
	i32.const	$195=, 78480
	i32.add 	$195=, $275, $195
	i32.add 	$push75=, $195, $pop74
	i32.store	$discard=, 0($pop75), $1
	i32.const	$push266=, 2
	i32.shl 	$push76=, $2, $pop266
	i32.const	$196=, 76480
	i32.add 	$196=, $275, $196
	i32.add 	$push77=, $196, $pop76
	i32.store	$discard=, 0($pop77), $2
	i32.const	$push265=, 2
	i32.shl 	$push78=, $3, $pop265
	i32.const	$197=, 74480
	i32.add 	$197=, $275, $197
	i32.add 	$push79=, $197, $pop78
	i32.store	$discard=, 0($pop79), $3
	i32.const	$push264=, 2
	i32.shl 	$push80=, $4, $pop264
	i32.const	$198=, 72480
	i32.add 	$198=, $275, $198
	i32.add 	$push81=, $198, $pop80
	i32.store	$discard=, 0($pop81), $4
	i32.const	$push263=, 2
	i32.shl 	$push82=, $5, $pop263
	i32.const	$199=, 70480
	i32.add 	$199=, $275, $199
	i32.add 	$push83=, $199, $pop82
	i32.store	$discard=, 0($pop83), $5
	i32.const	$push262=, 2
	i32.shl 	$push84=, $6, $pop262
	i32.const	$200=, 68480
	i32.add 	$200=, $275, $200
	i32.add 	$push85=, $200, $pop84
	i32.store	$discard=, 0($pop85), $6
	i32.const	$push261=, 2
	i32.shl 	$push86=, $7, $pop261
	i32.const	$201=, 66480
	i32.add 	$201=, $275, $201
	i32.add 	$push87=, $201, $pop86
	i32.store	$discard=, 0($pop87), $7
	i32.const	$push260=, 2
	i32.shl 	$push88=, $8, $pop260
	i32.const	$202=, 64480
	i32.add 	$202=, $275, $202
	i32.add 	$push89=, $202, $pop88
	i32.store	$discard=, 0($pop89), $8
	i32.const	$push259=, 2
	i32.shl 	$push90=, $9, $pop259
	i32.const	$203=, 62480
	i32.add 	$203=, $275, $203
	i32.add 	$push91=, $203, $pop90
	i32.store	$discard=, 0($pop91), $9
	i32.const	$push258=, 2
	i32.shl 	$push92=, $10, $pop258
	i32.const	$204=, 60480
	i32.add 	$204=, $275, $204
	i32.add 	$push93=, $204, $pop92
	i32.store	$discard=, 0($pop93), $10
	i32.const	$push257=, 2
	i32.shl 	$push94=, $11, $pop257
	i32.const	$205=, 58480
	i32.add 	$205=, $275, $205
	i32.add 	$push95=, $205, $pop94
	i32.store	$discard=, 0($pop95), $11
	i32.const	$push256=, 2
	i32.shl 	$push96=, $12, $pop256
	i32.const	$206=, 56480
	i32.add 	$206=, $275, $206
	i32.add 	$push97=, $206, $pop96
	i32.store	$discard=, 0($pop97), $12
	i32.const	$push255=, 2
	i32.shl 	$push98=, $13, $pop255
	i32.const	$207=, 54480
	i32.add 	$207=, $275, $207
	i32.add 	$push99=, $207, $pop98
	i32.store	$discard=, 0($pop99), $13
	i32.const	$push254=, 2
	i32.shl 	$push100=, $14, $pop254
	i32.const	$208=, 52480
	i32.add 	$208=, $275, $208
	i32.add 	$push101=, $208, $pop100
	i32.store	$discard=, 0($pop101), $14
	i32.const	$push253=, 2
	i32.shl 	$push102=, $15, $pop253
	i32.const	$209=, 50480
	i32.add 	$209=, $275, $209
	i32.add 	$push103=, $209, $pop102
	i32.store	$discard=, 0($pop103), $15
	i32.const	$push252=, 2
	i32.shl 	$push104=, $16, $pop252
	i32.const	$210=, 48480
	i32.add 	$210=, $275, $210
	i32.add 	$push105=, $210, $pop104
	i32.store	$discard=, 0($pop105), $16
	i32.const	$push251=, 2
	i32.shl 	$push106=, $17, $pop251
	i32.const	$211=, 46480
	i32.add 	$211=, $275, $211
	i32.add 	$push107=, $211, $pop106
	i32.store	$discard=, 0($pop107), $17
	i32.const	$push250=, 2
	i32.shl 	$push108=, $18, $pop250
	i32.const	$212=, 44480
	i32.add 	$212=, $275, $212
	i32.add 	$push109=, $212, $pop108
	i32.store	$discard=, 0($pop109), $18
	i32.const	$push249=, 2
	i32.shl 	$push110=, $19, $pop249
	i32.const	$213=, 42480
	i32.add 	$213=, $275, $213
	i32.add 	$push111=, $213, $pop110
	i32.store	$discard=, 0($pop111), $19
	i32.const	$push248=, 2
	i32.shl 	$push112=, $20, $pop248
	i32.const	$214=, 40480
	i32.add 	$214=, $275, $214
	i32.add 	$push113=, $214, $pop112
	i32.store	$discard=, 0($pop113), $20
	i32.const	$push247=, 2
	i32.shl 	$push114=, $21, $pop247
	i32.const	$215=, 38480
	i32.add 	$215=, $275, $215
	i32.add 	$push115=, $215, $pop114
	i32.store	$discard=, 0($pop115), $21
	i32.const	$push246=, 2
	i32.shl 	$push116=, $22, $pop246
	i32.const	$216=, 36480
	i32.add 	$216=, $275, $216
	i32.add 	$push117=, $216, $pop116
	i32.store	$discard=, 0($pop117), $22
	i32.const	$push245=, 2
	i32.shl 	$push118=, $23, $pop245
	i32.const	$217=, 34480
	i32.add 	$217=, $275, $217
	i32.add 	$push119=, $217, $pop118
	i32.store	$discard=, 0($pop119), $23
	i32.const	$push244=, 2
	i32.shl 	$push120=, $24, $pop244
	i32.const	$218=, 32480
	i32.add 	$218=, $275, $218
	i32.add 	$push121=, $218, $pop120
	i32.store	$discard=, 0($pop121), $24
	i32.const	$push243=, 2
	i32.shl 	$push122=, $25, $pop243
	i32.const	$219=, 30480
	i32.add 	$219=, $275, $219
	i32.add 	$push123=, $219, $pop122
	i32.store	$discard=, 0($pop123), $25
	i32.const	$push242=, 2
	i32.shl 	$push124=, $26, $pop242
	i32.const	$220=, 28480
	i32.add 	$220=, $275, $220
	i32.add 	$push125=, $220, $pop124
	i32.store	$discard=, 0($pop125), $26
	i32.const	$push241=, 2
	i32.shl 	$push126=, $27, $pop241
	i32.const	$221=, 26480
	i32.add 	$221=, $275, $221
	i32.add 	$push127=, $221, $pop126
	i32.store	$discard=, 0($pop127), $27
	i32.const	$push240=, 2
	i32.shl 	$push128=, $28, $pop240
	i32.const	$222=, 24480
	i32.add 	$222=, $275, $222
	i32.add 	$push129=, $222, $pop128
	i32.store	$discard=, 0($pop129), $28
	i32.const	$push239=, 2
	i32.shl 	$push130=, $29, $pop239
	i32.const	$223=, 22480
	i32.add 	$223=, $275, $223
	i32.add 	$push131=, $223, $pop130
	i32.store	$discard=, 0($pop131), $29
	i32.const	$push238=, 2
	i32.shl 	$push132=, $30, $pop238
	i32.const	$224=, 20480
	i32.add 	$224=, $275, $224
	i32.add 	$push133=, $224, $pop132
	i32.store	$discard=, 0($pop133), $30
	i32.const	$push237=, 2
	i32.shl 	$push134=, $31, $pop237
	i32.const	$225=, 18480
	i32.add 	$225=, $275, $225
	i32.add 	$push135=, $225, $pop134
	i32.store	$discard=, 0($pop135), $31
	i32.const	$push236=, 2
	i32.shl 	$push136=, $32, $pop236
	i32.const	$226=, 16480
	i32.add 	$226=, $275, $226
	i32.add 	$push137=, $226, $pop136
	i32.store	$discard=, 0($pop137), $32
	i32.const	$push235=, 2
	i32.shl 	$push138=, $33, $pop235
	i32.const	$227=, 14480
	i32.add 	$227=, $275, $227
	i32.add 	$push139=, $227, $pop138
	i32.store	$discard=, 0($pop139), $33
	i32.const	$push234=, 2
	i32.shl 	$push140=, $34, $pop234
	i32.const	$228=, 12480
	i32.add 	$228=, $275, $228
	i32.add 	$push141=, $228, $pop140
	i32.store	$discard=, 0($pop141), $34
	i32.const	$push233=, 2
	i32.shl 	$push142=, $35, $pop233
	i32.const	$229=, 10480
	i32.add 	$229=, $275, $229
	i32.add 	$push143=, $229, $pop142
	i32.store	$discard=, 0($pop143), $35
	i32.const	$push232=, 2
	i32.shl 	$push144=, $36, $pop232
	i32.const	$230=, 8480
	i32.add 	$230=, $275, $230
	i32.add 	$push145=, $230, $pop144
	i32.store	$discard=, 0($pop145), $36
	i32.const	$push231=, 2
	i32.shl 	$push146=, $37, $pop231
	i32.const	$231=, 6480
	i32.add 	$231=, $275, $231
	i32.add 	$push147=, $231, $pop146
	i32.store	$discard=, 0($pop147), $37
	i32.const	$push230=, 2
	i32.shl 	$push148=, $38, $pop230
	i32.const	$232=, 4480
	i32.add 	$232=, $275, $232
	i32.add 	$push149=, $232, $pop148
	i32.store	$discard=, 0($pop149), $38
	i32.const	$push229=, 2
	i32.shl 	$push150=, $39, $pop229
	i32.const	$233=, 2480
	i32.add 	$233=, $275, $233
	i32.add 	$push151=, $233, $pop150
	i32.store	$discard=, 0($pop151), $39
	i32.const	$push228=, 2
	i32.shl 	$push152=, $40, $pop228
	i32.const	$234=, 480
	i32.add 	$234=, $275, $234
	i32.add 	$push153=, $234, $pop152
	i32.store	$discard=, 0($pop153), $40
	i32.const	$push227=, 156
	i32.add 	$push154=, $275, $pop227
	i32.const	$235=, 480
	i32.add 	$235=, $275, $235
	i32.store	$discard=, 0($pop154), $235
	i32.const	$push226=, 152
	i32.add 	$push155=, $275, $pop226
	i32.const	$236=, 2480
	i32.add 	$236=, $275, $236
	i32.store	$discard=, 0($pop155):p2align=3, $236
	i32.const	$push225=, 148
	i32.add 	$push156=, $275, $pop225
	i32.const	$237=, 4480
	i32.add 	$237=, $275, $237
	i32.store	$discard=, 0($pop156), $237
	i32.const	$push224=, 144
	i32.add 	$push157=, $275, $pop224
	i32.const	$238=, 6480
	i32.add 	$238=, $275, $238
	i32.store	$discard=, 0($pop157):p2align=4, $238
	i32.const	$push223=, 140
	i32.add 	$push158=, $275, $pop223
	i32.const	$239=, 8480
	i32.add 	$239=, $275, $239
	i32.store	$discard=, 0($pop158), $239
	i32.const	$push222=, 136
	i32.add 	$push159=, $275, $pop222
	i32.const	$240=, 10480
	i32.add 	$240=, $275, $240
	i32.store	$discard=, 0($pop159):p2align=3, $240
	i32.const	$push221=, 132
	i32.add 	$push160=, $275, $pop221
	i32.const	$241=, 12480
	i32.add 	$241=, $275, $241
	i32.store	$discard=, 0($pop160), $241
	i32.const	$push220=, 128
	i32.add 	$push161=, $275, $pop220
	i32.const	$242=, 14480
	i32.add 	$242=, $275, $242
	i32.store	$discard=, 0($pop161):p2align=4, $242
	i32.const	$push219=, 124
	i32.add 	$push162=, $275, $pop219
	i32.const	$243=, 16480
	i32.add 	$243=, $275, $243
	i32.store	$discard=, 0($pop162), $243
	i32.const	$push218=, 120
	i32.add 	$push163=, $275, $pop218
	i32.const	$244=, 18480
	i32.add 	$244=, $275, $244
	i32.store	$discard=, 0($pop163):p2align=3, $244
	i32.const	$push217=, 116
	i32.add 	$push164=, $275, $pop217
	i32.const	$245=, 20480
	i32.add 	$245=, $275, $245
	i32.store	$discard=, 0($pop164), $245
	i32.const	$push216=, 112
	i32.add 	$push165=, $275, $pop216
	i32.const	$246=, 22480
	i32.add 	$246=, $275, $246
	i32.store	$discard=, 0($pop165):p2align=4, $246
	i32.const	$push215=, 108
	i32.add 	$push166=, $275, $pop215
	i32.const	$247=, 24480
	i32.add 	$247=, $275, $247
	i32.store	$discard=, 0($pop166), $247
	i32.const	$push214=, 104
	i32.add 	$push167=, $275, $pop214
	i32.const	$248=, 26480
	i32.add 	$248=, $275, $248
	i32.store	$discard=, 0($pop167):p2align=3, $248
	i32.const	$push213=, 100
	i32.add 	$push168=, $275, $pop213
	i32.const	$249=, 28480
	i32.add 	$249=, $275, $249
	i32.store	$discard=, 0($pop168), $249
	i32.const	$push212=, 96
	i32.add 	$push169=, $275, $pop212
	i32.const	$250=, 30480
	i32.add 	$250=, $275, $250
	i32.store	$discard=, 0($pop169):p2align=4, $250
	i32.const	$push211=, 92
	i32.add 	$push170=, $275, $pop211
	i32.const	$251=, 32480
	i32.add 	$251=, $275, $251
	i32.store	$discard=, 0($pop170), $251
	i32.const	$push210=, 88
	i32.add 	$push171=, $275, $pop210
	i32.const	$252=, 34480
	i32.add 	$252=, $275, $252
	i32.store	$discard=, 0($pop171):p2align=3, $252
	i32.const	$push209=, 84
	i32.add 	$push172=, $275, $pop209
	i32.const	$253=, 36480
	i32.add 	$253=, $275, $253
	i32.store	$discard=, 0($pop172), $253
	i32.const	$push208=, 80
	i32.add 	$push173=, $275, $pop208
	i32.const	$254=, 38480
	i32.add 	$254=, $275, $254
	i32.store	$discard=, 0($pop173):p2align=4, $254
	i32.const	$push207=, 76
	i32.add 	$push174=, $275, $pop207
	i32.const	$255=, 40480
	i32.add 	$255=, $275, $255
	i32.store	$discard=, 0($pop174), $255
	i32.const	$push206=, 72
	i32.add 	$push175=, $275, $pop206
	i32.const	$256=, 42480
	i32.add 	$256=, $275, $256
	i32.store	$discard=, 0($pop175):p2align=3, $256
	i32.const	$push205=, 68
	i32.add 	$push176=, $275, $pop205
	i32.const	$257=, 44480
	i32.add 	$257=, $275, $257
	i32.store	$discard=, 0($pop176), $257
	i32.const	$push204=, 64
	i32.add 	$push177=, $275, $pop204
	i32.const	$258=, 46480
	i32.add 	$258=, $275, $258
	i32.store	$discard=, 0($pop177):p2align=4, $258
	i32.const	$push203=, 60
	i32.add 	$push178=, $275, $pop203
	i32.const	$259=, 48480
	i32.add 	$259=, $275, $259
	i32.store	$discard=, 0($pop178), $259
	i32.const	$push202=, 56
	i32.add 	$push179=, $275, $pop202
	i32.const	$260=, 50480
	i32.add 	$260=, $275, $260
	i32.store	$discard=, 0($pop179):p2align=3, $260
	i32.const	$push201=, 52
	i32.add 	$push180=, $275, $pop201
	i32.const	$261=, 52480
	i32.add 	$261=, $275, $261
	i32.store	$discard=, 0($pop180), $261
	i32.const	$push200=, 48
	i32.add 	$push181=, $275, $pop200
	i32.const	$262=, 54480
	i32.add 	$262=, $275, $262
	i32.store	$discard=, 0($pop181):p2align=4, $262
	i32.const	$push199=, 44
	i32.add 	$push182=, $275, $pop199
	i32.const	$263=, 56480
	i32.add 	$263=, $275, $263
	i32.store	$discard=, 0($pop182), $263
	i32.const	$push198=, 40
	i32.add 	$push183=, $275, $pop198
	i32.const	$264=, 58480
	i32.add 	$264=, $275, $264
	i32.store	$discard=, 0($pop183):p2align=3, $264
	i32.const	$push197=, 36
	i32.add 	$push184=, $275, $pop197
	i32.const	$265=, 60480
	i32.add 	$265=, $275, $265
	i32.store	$discard=, 0($pop184), $265
	i32.const	$push196=, 32
	i32.add 	$push185=, $275, $pop196
	i32.const	$266=, 62480
	i32.add 	$266=, $275, $266
	i32.store	$discard=, 0($pop185):p2align=4, $266
	i32.const	$push195=, 28
	i32.add 	$push186=, $275, $pop195
	i32.const	$267=, 64480
	i32.add 	$267=, $275, $267
	i32.store	$discard=, 0($pop186), $267
	i32.const	$push194=, 24
	i32.add 	$push187=, $275, $pop194
	i32.const	$268=, 66480
	i32.add 	$268=, $275, $268
	i32.store	$discard=, 0($pop187):p2align=3, $268
	i32.const	$push193=, 20
	i32.add 	$push188=, $275, $pop193
	i32.const	$269=, 68480
	i32.add 	$269=, $275, $269
	i32.store	$discard=, 0($pop188), $269
	i32.const	$push192=, 16
	i32.add 	$push189=, $275, $pop192
	i32.const	$270=, 70480
	i32.add 	$270=, $275, $270
	i32.store	$discard=, 0($pop189):p2align=4, $270
	i32.const	$271=, 72480
	i32.add 	$271=, $275, $271
	i32.store	$discard=, 12($275), $271
	i32.const	$272=, 74480
	i32.add 	$272=, $275, $272
	i32.store	$discard=, 8($275):p2align=3, $272
	i32.const	$273=, 76480
	i32.add 	$273=, $275, $273
	i32.store	$discard=, 4($275), $273
	i32.const	$274=, 78480
	i32.add 	$274=, $275, $274
	i32.store	$discard=, 0($275):p2align=4, $274
	i32.const	$push191=, 40
	call    	c@FUNCTION, $pop191, $275
	i32.const	$push190=, -1
	i32.add 	$0=, $0, $pop190
	br_if   	0, $0           # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push346=, 80480
	i32.add 	$275=, $275, $pop346
	i32.const	$push347=, __stack_pointer
	i32.store	$discard=, 0($pop347), $275
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.s,"ax",@progbits
	.hidden	s
	.globl	s
	.type	s,@function
s:                                      # @s
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$2=, $pop11, $pop12
	i32.store	$discard=, 12($2), $1
	block
	i32.const	$push13=, 0
	i32.eq  	$push14=, $0, $pop13
	br_if   	0, $pop14       # 0: down to label3
# BB#1:                                 # %while.body.preheader
	i32.const	$push4=, -1
	i32.add 	$0=, $0, $pop4
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push9=, 12($2)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 4
	i32.add 	$push0=, $pop8, $pop7
	i32.store	$discard=, 12($2), $pop0
	i32.load	$push1=, 0($1)
	i32.store	$push2=, 0($pop1), $0
	i32.const	$push6=, -1
	i32.add 	$0=, $pop2, $pop6
	i32.const	$push5=, -1
	i32.ne  	$push3=, $0, $pop5
	br_if   	0, $pop3        # 0: up to label4
.LBB1_3:                                # %while.end
	end_loop                        # label5:
	end_block                       # label3:
	return
	.endfunc
.Lfunc_end1:
	.size	s, .Lfunc_end1-s

	.section	.text.z,"ax",@progbits
	.hidden	z
	.globl	z
	.type	z,@function
z:                                      # @z
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$3=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $3
	i32.store	$discard=, 12($3), $1
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $0, $pop12
	br_if   	0, $pop13       # 0: down to label6
# BB#1:                                 # %while.body.preheader
	i32.load	$1=, 12($3)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push5=, 4
	i32.add 	$push0=, $1, $pop5
	i32.store	$2=, 12($3), $pop0
	i32.const	$push4=, -1
	i32.add 	$0=, $0, $pop4
	i32.load	$push1=, 0($1)
	i32.const	$push3=, 0
	i32.const	$push2=, 2000
	i32.call	$discard=, memset@FUNCTION, $pop1, $pop3, $pop2
	copy_local	$1=, $2
	br_if   	0, $0           # 0: up to label7
.LBB2_3:                                # %while.end
	end_loop                        # label8:
	end_block                       # label6:
	i32.const	$push10=, 16
	i32.add 	$3=, $3, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $3
	return
	.endfunc
.Lfunc_end2:
	.size	z, .Lfunc_end2-z

	.section	.text.c,"ax",@progbits
	.hidden	c
	.globl	c
	.type	c,@function
c:                                      # @c
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 16
	i32.sub 	$3=, $pop13, $pop14
	i32.const	$push15=, __stack_pointer
	i32.store	$discard=, 0($pop15), $3
	i32.store	$discard=, 12($3), $1
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push6=, -4
	i32.add 	$1=, $pop1, $pop6
.LBB3_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label10:
	i32.const	$push18=, 0
	i32.eq  	$push19=, $0, $pop18
	br_if   	2, $pop19       # 2: down to label9
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$push11=, 12($3)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 4
	i32.add 	$push2=, $pop10, $pop9
	i32.store	$discard=, 12($3), $pop2
	i32.load	$push3=, 0($2)
	i32.add 	$2=, $pop3, $1
	i32.const	$push8=, -1
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, -4
	i32.add 	$1=, $1, $pop7
	i32.load	$push4=, 0($2)
	i32.eq  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: up to label10
# BB#3:                                 # %if.then
	end_loop                        # label11:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %while.end
	end_block                       # label9:
	i32.const	$push16=, 16
	i32.add 	$3=, $3, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $3
	return
	.endfunc
.Lfunc_end3:
	.size	c, .Lfunc_end3-c

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	call    	f@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.9.0 "
