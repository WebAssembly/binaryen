	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/multi-ix.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$41=, __stack_pointer
	i32.load	$41=, 0($41)
	i32.const	$42=, 80480
	i32.sub 	$284=, $41, $42
	i32.const	$42=, __stack_pointer
	i32.store	$284=, 0($42), $284
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push359=, 156
	i32.const	$44=, 320
	i32.add 	$44=, $284, $44
	i32.add 	$push2=, $44, $pop359
	i32.const	$45=, 480
	i32.add 	$45=, $284, $45
	i32.store	$discard=, 0($pop2), $45
	i32.const	$push358=, 152
	i32.const	$46=, 320
	i32.add 	$46=, $284, $46
	i32.add 	$push3=, $46, $pop358
	i32.const	$47=, 2480
	i32.add 	$47=, $284, $47
	i32.store	$discard=, 0($pop3):p2align=3, $47
	i32.const	$push357=, 148
	i32.const	$48=, 320
	i32.add 	$48=, $284, $48
	i32.add 	$push4=, $48, $pop357
	i32.const	$49=, 4480
	i32.add 	$49=, $284, $49
	i32.store	$discard=, 0($pop4), $49
	i32.const	$push356=, 144
	i32.const	$50=, 320
	i32.add 	$50=, $284, $50
	i32.add 	$push5=, $50, $pop356
	i32.const	$51=, 6480
	i32.add 	$51=, $284, $51
	i32.store	$discard=, 0($pop5):p2align=4, $51
	i32.const	$push355=, 140
	i32.const	$52=, 320
	i32.add 	$52=, $284, $52
	i32.add 	$push6=, $52, $pop355
	i32.const	$53=, 8480
	i32.add 	$53=, $284, $53
	i32.store	$discard=, 0($pop6), $53
	i32.const	$push354=, 136
	i32.const	$54=, 320
	i32.add 	$54=, $284, $54
	i32.add 	$push7=, $54, $pop354
	i32.const	$55=, 10480
	i32.add 	$55=, $284, $55
	i32.store	$discard=, 0($pop7):p2align=3, $55
	i32.const	$push353=, 132
	i32.const	$56=, 320
	i32.add 	$56=, $284, $56
	i32.add 	$push8=, $56, $pop353
	i32.const	$57=, 12480
	i32.add 	$57=, $284, $57
	i32.store	$discard=, 0($pop8), $57
	i32.const	$push352=, 128
	i32.const	$58=, 320
	i32.add 	$58=, $284, $58
	i32.add 	$push9=, $58, $pop352
	i32.const	$59=, 14480
	i32.add 	$59=, $284, $59
	i32.store	$discard=, 0($pop9):p2align=4, $59
	i32.const	$push351=, 124
	i32.const	$60=, 320
	i32.add 	$60=, $284, $60
	i32.add 	$push10=, $60, $pop351
	i32.const	$61=, 16480
	i32.add 	$61=, $284, $61
	i32.store	$discard=, 0($pop10), $61
	i32.const	$push350=, 120
	i32.const	$62=, 320
	i32.add 	$62=, $284, $62
	i32.add 	$push11=, $62, $pop350
	i32.const	$63=, 18480
	i32.add 	$63=, $284, $63
	i32.store	$discard=, 0($pop11):p2align=3, $63
	i32.const	$push349=, 116
	i32.const	$64=, 320
	i32.add 	$64=, $284, $64
	i32.add 	$push12=, $64, $pop349
	i32.const	$65=, 20480
	i32.add 	$65=, $284, $65
	i32.store	$discard=, 0($pop12), $65
	i32.const	$push348=, 112
	i32.const	$66=, 320
	i32.add 	$66=, $284, $66
	i32.add 	$push13=, $66, $pop348
	i32.const	$67=, 22480
	i32.add 	$67=, $284, $67
	i32.store	$discard=, 0($pop13):p2align=4, $67
	i32.const	$push347=, 108
	i32.const	$68=, 320
	i32.add 	$68=, $284, $68
	i32.add 	$push14=, $68, $pop347
	i32.const	$69=, 24480
	i32.add 	$69=, $284, $69
	i32.store	$discard=, 0($pop14), $69
	i32.const	$push346=, 104
	i32.const	$70=, 320
	i32.add 	$70=, $284, $70
	i32.add 	$push15=, $70, $pop346
	i32.const	$71=, 26480
	i32.add 	$71=, $284, $71
	i32.store	$discard=, 0($pop15):p2align=3, $71
	i32.const	$push345=, 100
	i32.const	$72=, 320
	i32.add 	$72=, $284, $72
	i32.add 	$push16=, $72, $pop345
	i32.const	$73=, 28480
	i32.add 	$73=, $284, $73
	i32.store	$discard=, 0($pop16), $73
	i32.const	$push344=, 96
	i32.const	$74=, 320
	i32.add 	$74=, $284, $74
	i32.add 	$push17=, $74, $pop344
	i32.const	$75=, 30480
	i32.add 	$75=, $284, $75
	i32.store	$discard=, 0($pop17):p2align=4, $75
	i32.const	$push343=, 92
	i32.const	$76=, 320
	i32.add 	$76=, $284, $76
	i32.add 	$push18=, $76, $pop343
	i32.const	$77=, 32480
	i32.add 	$77=, $284, $77
	i32.store	$discard=, 0($pop18), $77
	i32.const	$push342=, 88
	i32.const	$78=, 320
	i32.add 	$78=, $284, $78
	i32.add 	$push19=, $78, $pop342
	i32.const	$79=, 34480
	i32.add 	$79=, $284, $79
	i32.store	$discard=, 0($pop19):p2align=3, $79
	i32.const	$push341=, 84
	i32.const	$80=, 320
	i32.add 	$80=, $284, $80
	i32.add 	$push20=, $80, $pop341
	i32.const	$81=, 36480
	i32.add 	$81=, $284, $81
	i32.store	$discard=, 0($pop20), $81
	i32.const	$push340=, 80
	i32.const	$82=, 320
	i32.add 	$82=, $284, $82
	i32.add 	$push21=, $82, $pop340
	i32.const	$83=, 38480
	i32.add 	$83=, $284, $83
	i32.store	$discard=, 0($pop21):p2align=4, $83
	i32.const	$push339=, 76
	i32.const	$84=, 320
	i32.add 	$84=, $284, $84
	i32.add 	$push22=, $84, $pop339
	i32.const	$85=, 40480
	i32.add 	$85=, $284, $85
	i32.store	$discard=, 0($pop22), $85
	i32.const	$push338=, 72
	i32.const	$86=, 320
	i32.add 	$86=, $284, $86
	i32.add 	$push23=, $86, $pop338
	i32.const	$87=, 42480
	i32.add 	$87=, $284, $87
	i32.store	$discard=, 0($pop23):p2align=3, $87
	i32.const	$push337=, 68
	i32.const	$88=, 320
	i32.add 	$88=, $284, $88
	i32.add 	$push24=, $88, $pop337
	i32.const	$89=, 44480
	i32.add 	$89=, $284, $89
	i32.store	$discard=, 0($pop24), $89
	i32.const	$push336=, 64
	i32.const	$90=, 320
	i32.add 	$90=, $284, $90
	i32.add 	$push25=, $90, $pop336
	i32.const	$91=, 46480
	i32.add 	$91=, $284, $91
	i32.store	$discard=, 0($pop25):p2align=4, $91
	i32.const	$push335=, 60
	i32.const	$92=, 320
	i32.add 	$92=, $284, $92
	i32.add 	$push26=, $92, $pop335
	i32.const	$93=, 48480
	i32.add 	$93=, $284, $93
	i32.store	$discard=, 0($pop26), $93
	i32.const	$push334=, 56
	i32.const	$94=, 320
	i32.add 	$94=, $284, $94
	i32.add 	$push27=, $94, $pop334
	i32.const	$95=, 50480
	i32.add 	$95=, $284, $95
	i32.store	$discard=, 0($pop27):p2align=3, $95
	i32.const	$push333=, 52
	i32.const	$96=, 320
	i32.add 	$96=, $284, $96
	i32.add 	$push28=, $96, $pop333
	i32.const	$97=, 52480
	i32.add 	$97=, $284, $97
	i32.store	$discard=, 0($pop28), $97
	i32.const	$push332=, 48
	i32.const	$98=, 320
	i32.add 	$98=, $284, $98
	i32.add 	$push29=, $98, $pop332
	i32.const	$99=, 54480
	i32.add 	$99=, $284, $99
	i32.store	$discard=, 0($pop29):p2align=4, $99
	i32.const	$push331=, 44
	i32.const	$100=, 320
	i32.add 	$100=, $284, $100
	i32.add 	$push30=, $100, $pop331
	i32.const	$101=, 56480
	i32.add 	$101=, $284, $101
	i32.store	$discard=, 0($pop30), $101
	i32.const	$push330=, 40
	i32.const	$102=, 320
	i32.add 	$102=, $284, $102
	i32.add 	$push31=, $102, $pop330
	i32.const	$103=, 58480
	i32.add 	$103=, $284, $103
	i32.store	$discard=, 0($pop31):p2align=3, $103
	i32.const	$push329=, 36
	i32.const	$104=, 320
	i32.add 	$104=, $284, $104
	i32.add 	$push32=, $104, $pop329
	i32.const	$105=, 60480
	i32.add 	$105=, $284, $105
	i32.store	$discard=, 0($pop32), $105
	i32.const	$push328=, 32
	i32.const	$106=, 320
	i32.add 	$106=, $284, $106
	i32.add 	$push33=, $106, $pop328
	i32.const	$107=, 62480
	i32.add 	$107=, $284, $107
	i32.store	$discard=, 0($pop33):p2align=4, $107
	i32.const	$push327=, 28
	i32.const	$108=, 320
	i32.add 	$108=, $284, $108
	i32.add 	$push34=, $108, $pop327
	i32.const	$109=, 64480
	i32.add 	$109=, $284, $109
	i32.store	$discard=, 0($pop34), $109
	i32.const	$push326=, 24
	i32.const	$110=, 320
	i32.add 	$110=, $284, $110
	i32.add 	$push35=, $110, $pop326
	i32.const	$111=, 66480
	i32.add 	$111=, $284, $111
	i32.store	$discard=, 0($pop35):p2align=3, $111
	i32.const	$push325=, 20
	i32.const	$112=, 320
	i32.add 	$112=, $284, $112
	i32.add 	$push36=, $112, $pop325
	i32.const	$113=, 68480
	i32.add 	$113=, $284, $113
	i32.store	$discard=, 0($pop36), $113
	i32.const	$push324=, 16
	i32.const	$114=, 320
	i32.add 	$114=, $284, $114
	i32.add 	$push37=, $114, $pop324
	i32.const	$115=, 70480
	i32.add 	$115=, $284, $115
	i32.store	$discard=, 0($pop37):p2align=4, $115
	i32.const	$push323=, 12
	i32.const	$116=, 320
	i32.add 	$116=, $284, $116
	i32.or  	$push38=, $116, $pop323
	i32.const	$117=, 72480
	i32.add 	$117=, $284, $117
	i32.store	$discard=, 0($pop38), $117
	i32.const	$push322=, 8
	i32.const	$118=, 320
	i32.add 	$118=, $284, $118
	i32.or  	$push39=, $118, $pop322
	i32.const	$119=, 74480
	i32.add 	$119=, $284, $119
	i32.store	$discard=, 0($pop39):p2align=3, $119
	i32.const	$push321=, 4
	i32.const	$120=, 320
	i32.add 	$120=, $284, $120
	i32.or  	$push40=, $120, $pop321
	i32.const	$121=, 76480
	i32.add 	$121=, $284, $121
	i32.store	$discard=, 0($pop40), $121
	i32.const	$122=, 78480
	i32.add 	$122=, $284, $122
	i32.store	$discard=, 320($284):p2align=4, $122
	i32.const	$push320=, 40
	i32.const	$123=, 320
	i32.add 	$123=, $284, $123
	call    	s@FUNCTION, $pop320, $123
	i32.load	$1=, 78480($284):p2align=4
	i32.load	$2=, 76480($284):p2align=4
	i32.load	$3=, 74480($284):p2align=4
	i32.load	$4=, 72480($284):p2align=4
	i32.load	$5=, 70480($284):p2align=4
	i32.load	$6=, 68480($284):p2align=4
	i32.load	$7=, 66480($284):p2align=4
	i32.load	$8=, 64480($284):p2align=4
	i32.load	$9=, 62480($284):p2align=4
	i32.load	$10=, 60480($284):p2align=4
	i32.load	$11=, 58480($284):p2align=4
	i32.load	$12=, 56480($284):p2align=4
	i32.load	$13=, 54480($284):p2align=4
	i32.load	$14=, 52480($284):p2align=4
	i32.load	$15=, 50480($284):p2align=4
	i32.load	$16=, 48480($284):p2align=4
	i32.load	$17=, 46480($284):p2align=4
	i32.load	$18=, 44480($284):p2align=4
	i32.load	$19=, 42480($284):p2align=4
	i32.load	$20=, 40480($284):p2align=4
	i32.load	$21=, 38480($284):p2align=4
	i32.load	$22=, 36480($284):p2align=4
	i32.load	$23=, 34480($284):p2align=4
	i32.load	$24=, 32480($284):p2align=4
	i32.load	$25=, 30480($284):p2align=4
	i32.load	$26=, 28480($284):p2align=4
	i32.load	$27=, 26480($284):p2align=4
	i32.load	$28=, 24480($284):p2align=4
	i32.load	$29=, 22480($284):p2align=4
	i32.load	$30=, 20480($284):p2align=4
	i32.load	$31=, 18480($284):p2align=4
	i32.load	$32=, 16480($284):p2align=4
	i32.load	$33=, 14480($284):p2align=4
	i32.load	$34=, 12480($284):p2align=4
	i32.load	$35=, 10480($284):p2align=4
	i32.load	$36=, 8480($284):p2align=4
	i32.load	$37=, 6480($284):p2align=4
	i32.load	$38=, 4480($284):p2align=4
	i32.load	$39=, 2480($284):p2align=4
	i32.load	$40=, 480($284):p2align=4
	i32.const	$push319=, 156
	i32.const	$124=, 160
	i32.add 	$124=, $284, $124
	i32.add 	$push41=, $124, $pop319
	i32.const	$125=, 480
	i32.add 	$125=, $284, $125
	i32.store	$discard=, 0($pop41), $125
	i32.const	$push318=, 152
	i32.const	$126=, 160
	i32.add 	$126=, $284, $126
	i32.add 	$push42=, $126, $pop318
	i32.const	$127=, 2480
	i32.add 	$127=, $284, $127
	i32.store	$discard=, 0($pop42):p2align=3, $127
	i32.const	$push317=, 148
	i32.const	$128=, 160
	i32.add 	$128=, $284, $128
	i32.add 	$push43=, $128, $pop317
	i32.const	$129=, 4480
	i32.add 	$129=, $284, $129
	i32.store	$discard=, 0($pop43), $129
	i32.const	$push316=, 144
	i32.const	$130=, 160
	i32.add 	$130=, $284, $130
	i32.add 	$push44=, $130, $pop316
	i32.const	$131=, 6480
	i32.add 	$131=, $284, $131
	i32.store	$discard=, 0($pop44):p2align=4, $131
	i32.const	$push315=, 140
	i32.const	$132=, 160
	i32.add 	$132=, $284, $132
	i32.add 	$push45=, $132, $pop315
	i32.const	$133=, 8480
	i32.add 	$133=, $284, $133
	i32.store	$discard=, 0($pop45), $133
	i32.const	$push314=, 136
	i32.const	$134=, 160
	i32.add 	$134=, $284, $134
	i32.add 	$push46=, $134, $pop314
	i32.const	$135=, 10480
	i32.add 	$135=, $284, $135
	i32.store	$discard=, 0($pop46):p2align=3, $135
	i32.const	$push313=, 132
	i32.const	$136=, 160
	i32.add 	$136=, $284, $136
	i32.add 	$push47=, $136, $pop313
	i32.const	$137=, 12480
	i32.add 	$137=, $284, $137
	i32.store	$discard=, 0($pop47), $137
	i32.const	$push312=, 128
	i32.const	$138=, 160
	i32.add 	$138=, $284, $138
	i32.add 	$push48=, $138, $pop312
	i32.const	$139=, 14480
	i32.add 	$139=, $284, $139
	i32.store	$discard=, 0($pop48):p2align=4, $139
	i32.const	$push311=, 124
	i32.const	$140=, 160
	i32.add 	$140=, $284, $140
	i32.add 	$push49=, $140, $pop311
	i32.const	$141=, 16480
	i32.add 	$141=, $284, $141
	i32.store	$discard=, 0($pop49), $141
	i32.const	$push310=, 120
	i32.const	$142=, 160
	i32.add 	$142=, $284, $142
	i32.add 	$push50=, $142, $pop310
	i32.const	$143=, 18480
	i32.add 	$143=, $284, $143
	i32.store	$discard=, 0($pop50):p2align=3, $143
	i32.const	$push309=, 116
	i32.const	$144=, 160
	i32.add 	$144=, $284, $144
	i32.add 	$push51=, $144, $pop309
	i32.const	$145=, 20480
	i32.add 	$145=, $284, $145
	i32.store	$discard=, 0($pop51), $145
	i32.const	$push308=, 112
	i32.const	$146=, 160
	i32.add 	$146=, $284, $146
	i32.add 	$push52=, $146, $pop308
	i32.const	$147=, 22480
	i32.add 	$147=, $284, $147
	i32.store	$discard=, 0($pop52):p2align=4, $147
	i32.const	$push307=, 108
	i32.const	$148=, 160
	i32.add 	$148=, $284, $148
	i32.add 	$push53=, $148, $pop307
	i32.const	$149=, 24480
	i32.add 	$149=, $284, $149
	i32.store	$discard=, 0($pop53), $149
	i32.const	$push306=, 104
	i32.const	$150=, 160
	i32.add 	$150=, $284, $150
	i32.add 	$push54=, $150, $pop306
	i32.const	$151=, 26480
	i32.add 	$151=, $284, $151
	i32.store	$discard=, 0($pop54):p2align=3, $151
	i32.const	$push305=, 100
	i32.const	$152=, 160
	i32.add 	$152=, $284, $152
	i32.add 	$push55=, $152, $pop305
	i32.const	$153=, 28480
	i32.add 	$153=, $284, $153
	i32.store	$discard=, 0($pop55), $153
	i32.const	$push304=, 96
	i32.const	$154=, 160
	i32.add 	$154=, $284, $154
	i32.add 	$push56=, $154, $pop304
	i32.const	$155=, 30480
	i32.add 	$155=, $284, $155
	i32.store	$discard=, 0($pop56):p2align=4, $155
	i32.const	$push303=, 92
	i32.const	$156=, 160
	i32.add 	$156=, $284, $156
	i32.add 	$push57=, $156, $pop303
	i32.const	$157=, 32480
	i32.add 	$157=, $284, $157
	i32.store	$discard=, 0($pop57), $157
	i32.const	$push302=, 88
	i32.const	$158=, 160
	i32.add 	$158=, $284, $158
	i32.add 	$push58=, $158, $pop302
	i32.const	$159=, 34480
	i32.add 	$159=, $284, $159
	i32.store	$discard=, 0($pop58):p2align=3, $159
	i32.const	$push301=, 84
	i32.const	$160=, 160
	i32.add 	$160=, $284, $160
	i32.add 	$push59=, $160, $pop301
	i32.const	$161=, 36480
	i32.add 	$161=, $284, $161
	i32.store	$discard=, 0($pop59), $161
	i32.const	$push300=, 80
	i32.const	$162=, 160
	i32.add 	$162=, $284, $162
	i32.add 	$push60=, $162, $pop300
	i32.const	$163=, 38480
	i32.add 	$163=, $284, $163
	i32.store	$discard=, 0($pop60):p2align=4, $163
	i32.const	$push299=, 76
	i32.const	$164=, 160
	i32.add 	$164=, $284, $164
	i32.add 	$push61=, $164, $pop299
	i32.const	$165=, 40480
	i32.add 	$165=, $284, $165
	i32.store	$discard=, 0($pop61), $165
	i32.const	$push298=, 72
	i32.const	$166=, 160
	i32.add 	$166=, $284, $166
	i32.add 	$push62=, $166, $pop298
	i32.const	$167=, 42480
	i32.add 	$167=, $284, $167
	i32.store	$discard=, 0($pop62):p2align=3, $167
	i32.const	$push297=, 68
	i32.const	$168=, 160
	i32.add 	$168=, $284, $168
	i32.add 	$push63=, $168, $pop297
	i32.const	$169=, 44480
	i32.add 	$169=, $284, $169
	i32.store	$discard=, 0($pop63), $169
	i32.const	$push296=, 64
	i32.const	$170=, 160
	i32.add 	$170=, $284, $170
	i32.add 	$push64=, $170, $pop296
	i32.const	$171=, 46480
	i32.add 	$171=, $284, $171
	i32.store	$discard=, 0($pop64):p2align=4, $171
	i32.const	$push295=, 60
	i32.const	$172=, 160
	i32.add 	$172=, $284, $172
	i32.add 	$push65=, $172, $pop295
	i32.const	$173=, 48480
	i32.add 	$173=, $284, $173
	i32.store	$discard=, 0($pop65), $173
	i32.const	$push294=, 56
	i32.const	$174=, 160
	i32.add 	$174=, $284, $174
	i32.add 	$push66=, $174, $pop294
	i32.const	$175=, 50480
	i32.add 	$175=, $284, $175
	i32.store	$discard=, 0($pop66):p2align=3, $175
	i32.const	$push293=, 52
	i32.const	$176=, 160
	i32.add 	$176=, $284, $176
	i32.add 	$push67=, $176, $pop293
	i32.const	$177=, 52480
	i32.add 	$177=, $284, $177
	i32.store	$discard=, 0($pop67), $177
	i32.const	$push292=, 48
	i32.const	$178=, 160
	i32.add 	$178=, $284, $178
	i32.add 	$push68=, $178, $pop292
	i32.const	$179=, 54480
	i32.add 	$179=, $284, $179
	i32.store	$discard=, 0($pop68):p2align=4, $179
	i32.const	$push291=, 44
	i32.const	$180=, 160
	i32.add 	$180=, $284, $180
	i32.add 	$push69=, $180, $pop291
	i32.const	$181=, 56480
	i32.add 	$181=, $284, $181
	i32.store	$discard=, 0($pop69), $181
	i32.const	$push290=, 40
	i32.const	$182=, 160
	i32.add 	$182=, $284, $182
	i32.add 	$push70=, $182, $pop290
	i32.const	$183=, 58480
	i32.add 	$183=, $284, $183
	i32.store	$discard=, 0($pop70):p2align=3, $183
	i32.const	$push289=, 36
	i32.const	$184=, 160
	i32.add 	$184=, $284, $184
	i32.add 	$push71=, $184, $pop289
	i32.const	$185=, 60480
	i32.add 	$185=, $284, $185
	i32.store	$discard=, 0($pop71), $185
	i32.const	$push288=, 32
	i32.const	$186=, 160
	i32.add 	$186=, $284, $186
	i32.add 	$push72=, $186, $pop288
	i32.const	$187=, 62480
	i32.add 	$187=, $284, $187
	i32.store	$discard=, 0($pop72):p2align=4, $187
	i32.const	$push287=, 28
	i32.const	$188=, 160
	i32.add 	$188=, $284, $188
	i32.add 	$push73=, $188, $pop287
	i32.const	$189=, 64480
	i32.add 	$189=, $284, $189
	i32.store	$discard=, 0($pop73), $189
	i32.const	$push286=, 24
	i32.const	$190=, 160
	i32.add 	$190=, $284, $190
	i32.add 	$push74=, $190, $pop286
	i32.const	$191=, 66480
	i32.add 	$191=, $284, $191
	i32.store	$discard=, 0($pop74):p2align=3, $191
	i32.const	$push285=, 20
	i32.const	$192=, 160
	i32.add 	$192=, $284, $192
	i32.add 	$push75=, $192, $pop285
	i32.const	$193=, 68480
	i32.add 	$193=, $284, $193
	i32.store	$discard=, 0($pop75), $193
	i32.const	$push284=, 16
	i32.const	$194=, 160
	i32.add 	$194=, $284, $194
	i32.add 	$push76=, $194, $pop284
	i32.const	$195=, 70480
	i32.add 	$195=, $284, $195
	i32.store	$discard=, 0($pop76):p2align=4, $195
	i32.const	$push283=, 12
	i32.const	$196=, 160
	i32.add 	$196=, $284, $196
	i32.or  	$push77=, $196, $pop283
	i32.const	$197=, 72480
	i32.add 	$197=, $284, $197
	i32.store	$discard=, 0($pop77), $197
	i32.const	$push282=, 8
	i32.const	$198=, 160
	i32.add 	$198=, $284, $198
	i32.or  	$push78=, $198, $pop282
	i32.const	$199=, 74480
	i32.add 	$199=, $284, $199
	i32.store	$discard=, 0($pop78):p2align=3, $199
	i32.const	$push281=, 4
	i32.const	$200=, 160
	i32.add 	$200=, $284, $200
	i32.or  	$push79=, $200, $pop281
	i32.const	$201=, 76480
	i32.add 	$201=, $284, $201
	i32.store	$discard=, 0($pop79), $201
	i32.const	$202=, 78480
	i32.add 	$202=, $284, $202
	i32.store	$discard=, 160($284):p2align=4, $202
	i32.const	$push280=, 40
	i32.const	$203=, 160
	i32.add 	$203=, $284, $203
	call    	z@FUNCTION, $pop280, $203
	i32.const	$push279=, 2
	i32.shl 	$push80=, $1, $pop279
	i32.const	$204=, 78480
	i32.add 	$204=, $284, $204
	i32.add 	$push81=, $204, $pop80
	i32.store	$discard=, 0($pop81), $1
	i32.const	$push278=, 2
	i32.shl 	$push82=, $2, $pop278
	i32.const	$205=, 76480
	i32.add 	$205=, $284, $205
	i32.add 	$push83=, $205, $pop82
	i32.store	$discard=, 0($pop83), $2
	i32.const	$push277=, 2
	i32.shl 	$push84=, $3, $pop277
	i32.const	$206=, 74480
	i32.add 	$206=, $284, $206
	i32.add 	$push85=, $206, $pop84
	i32.store	$discard=, 0($pop85), $3
	i32.const	$push276=, 2
	i32.shl 	$push86=, $4, $pop276
	i32.const	$207=, 72480
	i32.add 	$207=, $284, $207
	i32.add 	$push87=, $207, $pop86
	i32.store	$discard=, 0($pop87), $4
	i32.const	$push275=, 2
	i32.shl 	$push88=, $5, $pop275
	i32.const	$208=, 70480
	i32.add 	$208=, $284, $208
	i32.add 	$push89=, $208, $pop88
	i32.store	$discard=, 0($pop89), $5
	i32.const	$push274=, 2
	i32.shl 	$push90=, $6, $pop274
	i32.const	$209=, 68480
	i32.add 	$209=, $284, $209
	i32.add 	$push91=, $209, $pop90
	i32.store	$discard=, 0($pop91), $6
	i32.const	$push273=, 2
	i32.shl 	$push92=, $7, $pop273
	i32.const	$210=, 66480
	i32.add 	$210=, $284, $210
	i32.add 	$push93=, $210, $pop92
	i32.store	$discard=, 0($pop93), $7
	i32.const	$push272=, 2
	i32.shl 	$push94=, $8, $pop272
	i32.const	$211=, 64480
	i32.add 	$211=, $284, $211
	i32.add 	$push95=, $211, $pop94
	i32.store	$discard=, 0($pop95), $8
	i32.const	$push271=, 2
	i32.shl 	$push96=, $9, $pop271
	i32.const	$212=, 62480
	i32.add 	$212=, $284, $212
	i32.add 	$push97=, $212, $pop96
	i32.store	$discard=, 0($pop97), $9
	i32.const	$push270=, 2
	i32.shl 	$push98=, $10, $pop270
	i32.const	$213=, 60480
	i32.add 	$213=, $284, $213
	i32.add 	$push99=, $213, $pop98
	i32.store	$discard=, 0($pop99), $10
	i32.const	$push269=, 2
	i32.shl 	$push100=, $11, $pop269
	i32.const	$214=, 58480
	i32.add 	$214=, $284, $214
	i32.add 	$push101=, $214, $pop100
	i32.store	$discard=, 0($pop101), $11
	i32.const	$push268=, 2
	i32.shl 	$push102=, $12, $pop268
	i32.const	$215=, 56480
	i32.add 	$215=, $284, $215
	i32.add 	$push103=, $215, $pop102
	i32.store	$discard=, 0($pop103), $12
	i32.const	$push267=, 2
	i32.shl 	$push104=, $13, $pop267
	i32.const	$216=, 54480
	i32.add 	$216=, $284, $216
	i32.add 	$push105=, $216, $pop104
	i32.store	$discard=, 0($pop105), $13
	i32.const	$push266=, 2
	i32.shl 	$push106=, $14, $pop266
	i32.const	$217=, 52480
	i32.add 	$217=, $284, $217
	i32.add 	$push107=, $217, $pop106
	i32.store	$discard=, 0($pop107), $14
	i32.const	$push265=, 2
	i32.shl 	$push108=, $15, $pop265
	i32.const	$218=, 50480
	i32.add 	$218=, $284, $218
	i32.add 	$push109=, $218, $pop108
	i32.store	$discard=, 0($pop109), $15
	i32.const	$push264=, 2
	i32.shl 	$push110=, $16, $pop264
	i32.const	$219=, 48480
	i32.add 	$219=, $284, $219
	i32.add 	$push111=, $219, $pop110
	i32.store	$discard=, 0($pop111), $16
	i32.const	$push263=, 2
	i32.shl 	$push112=, $17, $pop263
	i32.const	$220=, 46480
	i32.add 	$220=, $284, $220
	i32.add 	$push113=, $220, $pop112
	i32.store	$discard=, 0($pop113), $17
	i32.const	$push262=, 2
	i32.shl 	$push114=, $18, $pop262
	i32.const	$221=, 44480
	i32.add 	$221=, $284, $221
	i32.add 	$push115=, $221, $pop114
	i32.store	$discard=, 0($pop115), $18
	i32.const	$push261=, 2
	i32.shl 	$push116=, $19, $pop261
	i32.const	$222=, 42480
	i32.add 	$222=, $284, $222
	i32.add 	$push117=, $222, $pop116
	i32.store	$discard=, 0($pop117), $19
	i32.const	$push260=, 2
	i32.shl 	$push118=, $20, $pop260
	i32.const	$223=, 40480
	i32.add 	$223=, $284, $223
	i32.add 	$push119=, $223, $pop118
	i32.store	$discard=, 0($pop119), $20
	i32.const	$push259=, 2
	i32.shl 	$push120=, $21, $pop259
	i32.const	$224=, 38480
	i32.add 	$224=, $284, $224
	i32.add 	$push121=, $224, $pop120
	i32.store	$discard=, 0($pop121), $21
	i32.const	$push258=, 2
	i32.shl 	$push122=, $22, $pop258
	i32.const	$225=, 36480
	i32.add 	$225=, $284, $225
	i32.add 	$push123=, $225, $pop122
	i32.store	$discard=, 0($pop123), $22
	i32.const	$push257=, 2
	i32.shl 	$push124=, $23, $pop257
	i32.const	$226=, 34480
	i32.add 	$226=, $284, $226
	i32.add 	$push125=, $226, $pop124
	i32.store	$discard=, 0($pop125), $23
	i32.const	$push256=, 2
	i32.shl 	$push126=, $24, $pop256
	i32.const	$227=, 32480
	i32.add 	$227=, $284, $227
	i32.add 	$push127=, $227, $pop126
	i32.store	$discard=, 0($pop127), $24
	i32.const	$push255=, 2
	i32.shl 	$push128=, $25, $pop255
	i32.const	$228=, 30480
	i32.add 	$228=, $284, $228
	i32.add 	$push129=, $228, $pop128
	i32.store	$discard=, 0($pop129), $25
	i32.const	$push254=, 2
	i32.shl 	$push130=, $26, $pop254
	i32.const	$229=, 28480
	i32.add 	$229=, $284, $229
	i32.add 	$push131=, $229, $pop130
	i32.store	$discard=, 0($pop131), $26
	i32.const	$push253=, 2
	i32.shl 	$push132=, $27, $pop253
	i32.const	$230=, 26480
	i32.add 	$230=, $284, $230
	i32.add 	$push133=, $230, $pop132
	i32.store	$discard=, 0($pop133), $27
	i32.const	$push252=, 2
	i32.shl 	$push134=, $28, $pop252
	i32.const	$231=, 24480
	i32.add 	$231=, $284, $231
	i32.add 	$push135=, $231, $pop134
	i32.store	$discard=, 0($pop135), $28
	i32.const	$push251=, 2
	i32.shl 	$push136=, $29, $pop251
	i32.const	$232=, 22480
	i32.add 	$232=, $284, $232
	i32.add 	$push137=, $232, $pop136
	i32.store	$discard=, 0($pop137), $29
	i32.const	$push250=, 2
	i32.shl 	$push138=, $30, $pop250
	i32.const	$233=, 20480
	i32.add 	$233=, $284, $233
	i32.add 	$push139=, $233, $pop138
	i32.store	$discard=, 0($pop139), $30
	i32.const	$push249=, 2
	i32.shl 	$push140=, $31, $pop249
	i32.const	$234=, 18480
	i32.add 	$234=, $284, $234
	i32.add 	$push141=, $234, $pop140
	i32.store	$discard=, 0($pop141), $31
	i32.const	$push248=, 2
	i32.shl 	$push142=, $32, $pop248
	i32.const	$235=, 16480
	i32.add 	$235=, $284, $235
	i32.add 	$push143=, $235, $pop142
	i32.store	$discard=, 0($pop143), $32
	i32.const	$push247=, 2
	i32.shl 	$push144=, $33, $pop247
	i32.const	$236=, 14480
	i32.add 	$236=, $284, $236
	i32.add 	$push145=, $236, $pop144
	i32.store	$discard=, 0($pop145), $33
	i32.const	$push246=, 2
	i32.shl 	$push146=, $34, $pop246
	i32.const	$237=, 12480
	i32.add 	$237=, $284, $237
	i32.add 	$push147=, $237, $pop146
	i32.store	$discard=, 0($pop147), $34
	i32.const	$push245=, 2
	i32.shl 	$push148=, $35, $pop245
	i32.const	$238=, 10480
	i32.add 	$238=, $284, $238
	i32.add 	$push149=, $238, $pop148
	i32.store	$discard=, 0($pop149), $35
	i32.const	$push244=, 2
	i32.shl 	$push150=, $36, $pop244
	i32.const	$239=, 8480
	i32.add 	$239=, $284, $239
	i32.add 	$push151=, $239, $pop150
	i32.store	$discard=, 0($pop151), $36
	i32.const	$push243=, 2
	i32.shl 	$push152=, $37, $pop243
	i32.const	$240=, 6480
	i32.add 	$240=, $284, $240
	i32.add 	$push153=, $240, $pop152
	i32.store	$discard=, 0($pop153), $37
	i32.const	$push242=, 2
	i32.shl 	$push154=, $38, $pop242
	i32.const	$241=, 4480
	i32.add 	$241=, $284, $241
	i32.add 	$push155=, $241, $pop154
	i32.store	$discard=, 0($pop155), $38
	i32.const	$push241=, 2
	i32.shl 	$push156=, $39, $pop241
	i32.const	$242=, 2480
	i32.add 	$242=, $284, $242
	i32.add 	$push157=, $242, $pop156
	i32.store	$discard=, 0($pop157), $39
	i32.const	$push240=, 2
	i32.shl 	$push158=, $40, $pop240
	i32.const	$243=, 480
	i32.add 	$243=, $284, $243
	i32.add 	$push159=, $243, $pop158
	i32.store	$discard=, 0($pop159), $40
	i32.const	$push239=, 156
	i32.add 	$push160=, $284, $pop239
	i32.const	$244=, 480
	i32.add 	$244=, $284, $244
	i32.store	$discard=, 0($pop160), $244
	i32.const	$push238=, 152
	i32.add 	$push161=, $284, $pop238
	i32.const	$245=, 2480
	i32.add 	$245=, $284, $245
	i32.store	$discard=, 0($pop161):p2align=3, $245
	i32.const	$push237=, 148
	i32.add 	$push162=, $284, $pop237
	i32.const	$246=, 4480
	i32.add 	$246=, $284, $246
	i32.store	$discard=, 0($pop162), $246
	i32.const	$push236=, 144
	i32.add 	$push163=, $284, $pop236
	i32.const	$247=, 6480
	i32.add 	$247=, $284, $247
	i32.store	$discard=, 0($pop163):p2align=4, $247
	i32.const	$push235=, 140
	i32.add 	$push164=, $284, $pop235
	i32.const	$248=, 8480
	i32.add 	$248=, $284, $248
	i32.store	$discard=, 0($pop164), $248
	i32.const	$push234=, 136
	i32.add 	$push165=, $284, $pop234
	i32.const	$249=, 10480
	i32.add 	$249=, $284, $249
	i32.store	$discard=, 0($pop165):p2align=3, $249
	i32.const	$push233=, 132
	i32.add 	$push166=, $284, $pop233
	i32.const	$250=, 12480
	i32.add 	$250=, $284, $250
	i32.store	$discard=, 0($pop166), $250
	i32.const	$push232=, 128
	i32.add 	$push167=, $284, $pop232
	i32.const	$251=, 14480
	i32.add 	$251=, $284, $251
	i32.store	$discard=, 0($pop167):p2align=4, $251
	i32.const	$push231=, 124
	i32.add 	$push168=, $284, $pop231
	i32.const	$252=, 16480
	i32.add 	$252=, $284, $252
	i32.store	$discard=, 0($pop168), $252
	i32.const	$push230=, 120
	i32.add 	$push169=, $284, $pop230
	i32.const	$253=, 18480
	i32.add 	$253=, $284, $253
	i32.store	$discard=, 0($pop169):p2align=3, $253
	i32.const	$push229=, 116
	i32.add 	$push170=, $284, $pop229
	i32.const	$254=, 20480
	i32.add 	$254=, $284, $254
	i32.store	$discard=, 0($pop170), $254
	i32.const	$push228=, 112
	i32.add 	$push171=, $284, $pop228
	i32.const	$255=, 22480
	i32.add 	$255=, $284, $255
	i32.store	$discard=, 0($pop171):p2align=4, $255
	i32.const	$push227=, 108
	i32.add 	$push172=, $284, $pop227
	i32.const	$256=, 24480
	i32.add 	$256=, $284, $256
	i32.store	$discard=, 0($pop172), $256
	i32.const	$push226=, 104
	i32.add 	$push173=, $284, $pop226
	i32.const	$257=, 26480
	i32.add 	$257=, $284, $257
	i32.store	$discard=, 0($pop173):p2align=3, $257
	i32.const	$push225=, 100
	i32.add 	$push174=, $284, $pop225
	i32.const	$258=, 28480
	i32.add 	$258=, $284, $258
	i32.store	$discard=, 0($pop174), $258
	i32.const	$push224=, 96
	i32.add 	$push175=, $284, $pop224
	i32.const	$259=, 30480
	i32.add 	$259=, $284, $259
	i32.store	$discard=, 0($pop175):p2align=4, $259
	i32.const	$push223=, 92
	i32.add 	$push176=, $284, $pop223
	i32.const	$260=, 32480
	i32.add 	$260=, $284, $260
	i32.store	$discard=, 0($pop176), $260
	i32.const	$push222=, 88
	i32.add 	$push177=, $284, $pop222
	i32.const	$261=, 34480
	i32.add 	$261=, $284, $261
	i32.store	$discard=, 0($pop177):p2align=3, $261
	i32.const	$push221=, 84
	i32.add 	$push178=, $284, $pop221
	i32.const	$262=, 36480
	i32.add 	$262=, $284, $262
	i32.store	$discard=, 0($pop178), $262
	i32.const	$push220=, 80
	i32.add 	$push179=, $284, $pop220
	i32.const	$263=, 38480
	i32.add 	$263=, $284, $263
	i32.store	$discard=, 0($pop179):p2align=4, $263
	i32.const	$push219=, 76
	i32.add 	$push180=, $284, $pop219
	i32.const	$264=, 40480
	i32.add 	$264=, $284, $264
	i32.store	$discard=, 0($pop180), $264
	i32.const	$push218=, 72
	i32.add 	$push181=, $284, $pop218
	i32.const	$265=, 42480
	i32.add 	$265=, $284, $265
	i32.store	$discard=, 0($pop181):p2align=3, $265
	i32.const	$push217=, 68
	i32.add 	$push182=, $284, $pop217
	i32.const	$266=, 44480
	i32.add 	$266=, $284, $266
	i32.store	$discard=, 0($pop182), $266
	i32.const	$push216=, 64
	i32.add 	$push183=, $284, $pop216
	i32.const	$267=, 46480
	i32.add 	$267=, $284, $267
	i32.store	$discard=, 0($pop183):p2align=4, $267
	i32.const	$push215=, 60
	i32.add 	$push184=, $284, $pop215
	i32.const	$268=, 48480
	i32.add 	$268=, $284, $268
	i32.store	$discard=, 0($pop184), $268
	i32.const	$push214=, 56
	i32.add 	$push185=, $284, $pop214
	i32.const	$269=, 50480
	i32.add 	$269=, $284, $269
	i32.store	$discard=, 0($pop185):p2align=3, $269
	i32.const	$push213=, 52
	i32.add 	$push186=, $284, $pop213
	i32.const	$270=, 52480
	i32.add 	$270=, $284, $270
	i32.store	$discard=, 0($pop186), $270
	i32.const	$push212=, 48
	i32.add 	$push187=, $284, $pop212
	i32.const	$271=, 54480
	i32.add 	$271=, $284, $271
	i32.store	$discard=, 0($pop187):p2align=4, $271
	i32.const	$push211=, 44
	i32.add 	$push188=, $284, $pop211
	i32.const	$272=, 56480
	i32.add 	$272=, $284, $272
	i32.store	$discard=, 0($pop188), $272
	i32.const	$push210=, 40
	i32.add 	$push189=, $284, $pop210
	i32.const	$273=, 58480
	i32.add 	$273=, $284, $273
	i32.store	$discard=, 0($pop189):p2align=3, $273
	i32.const	$push209=, 36
	i32.add 	$push190=, $284, $pop209
	i32.const	$274=, 60480
	i32.add 	$274=, $284, $274
	i32.store	$discard=, 0($pop190), $274
	i32.const	$push208=, 32
	i32.add 	$push191=, $284, $pop208
	i32.const	$275=, 62480
	i32.add 	$275=, $284, $275
	i32.store	$discard=, 0($pop191):p2align=4, $275
	i32.const	$push207=, 28
	i32.add 	$push192=, $284, $pop207
	i32.const	$276=, 64480
	i32.add 	$276=, $284, $276
	i32.store	$discard=, 0($pop192), $276
	i32.const	$push206=, 24
	i32.add 	$push193=, $284, $pop206
	i32.const	$277=, 66480
	i32.add 	$277=, $284, $277
	i32.store	$discard=, 0($pop193):p2align=3, $277
	i32.const	$push205=, 20
	i32.add 	$push194=, $284, $pop205
	i32.const	$278=, 68480
	i32.add 	$278=, $284, $278
	i32.store	$discard=, 0($pop194), $278
	i32.const	$push204=, 16
	i32.add 	$push195=, $284, $pop204
	i32.const	$279=, 70480
	i32.add 	$279=, $284, $279
	i32.store	$discard=, 0($pop195):p2align=4, $279
	i32.const	$push203=, 12
	i32.or  	$push196=, $284, $pop203
	i32.const	$280=, 72480
	i32.add 	$280=, $284, $280
	i32.store	$discard=, 0($pop196), $280
	i32.const	$push202=, 8
	i32.or  	$push197=, $284, $pop202
	i32.const	$281=, 74480
	i32.add 	$281=, $284, $281
	i32.store	$discard=, 0($pop197):p2align=3, $281
	i32.const	$push201=, 4
	i32.or  	$push198=, $284, $pop201
	i32.const	$282=, 76480
	i32.add 	$282=, $284, $282
	i32.store	$discard=, 0($pop198), $282
	i32.const	$283=, 78480
	i32.add 	$283=, $284, $283
	i32.store	$discard=, 0($284):p2align=4, $283
	i32.const	$push200=, 40
	call    	c@FUNCTION, $pop200, $284
	i32.const	$push199=, -1
	i32.add 	$0=, $0, $pop199
	br_if   	0, $0           # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$43=, 80480
	i32.add 	$284=, $284, $43
	i32.const	$43=, __stack_pointer
	i32.store	$284=, 0($43), $284
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $1
	block
	i32.const	$push14=, 0
	i32.eq  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#1:                                 # %while.body.preheader
	i32.const	$push6=, -1
	i32.add 	$0=, $0, $pop6
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push0=, 12($5)
	i32.const	$push13=, 3
	i32.add 	$push1=, $pop0, $pop13
	i32.const	$push12=, -4
	i32.and 	$push11=, $pop1, $pop12
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 4
	i32.add 	$push2=, $pop10, $pop9
	i32.store	$discard=, 12($5), $pop2
	i32.load	$push3=, 0($1)
	i32.store	$push4=, 0($pop3), $0
	i32.const	$push8=, -1
	i32.add 	$0=, $pop4, $pop8
	i32.const	$push7=, -1
	i32.ne  	$push5=, $0, $pop7
	br_if   	0, $pop5        # 0: up to label4
.LBB1_3:                                # %while.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $1
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $0, $pop12
	br_if   	0, $pop13       # 0: down to label6
.LBB2_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.load	$push1=, 12($5)
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push11=, $pop3, $pop4
	tee_local	$push10=, $1=, $pop11
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop10, $pop5
	i32.store	$discard=, 12($5), $pop6
	i32.const	$push0=, -1
	i32.add 	$0=, $0, $pop0
	i32.load	$push7=, 0($1)
	i32.const	$push9=, 0
	i32.const	$push8=, 2000
	i32.call	$discard=, memset@FUNCTION, $pop7, $pop9, $pop8
	br_if   	0, $0           # 0: up to label7
.LBB2_2:                                # %while.end
	end_loop                        # label8:
	end_block                       # label6:
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $1
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push8=, -4
	i32.add 	$1=, $pop1, $pop8
.LBB3_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label10:
	i32.const	$push16=, 0
	i32.eq  	$push17=, $0, $pop16
	br_if   	2, $pop17       # 2: down to label9
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$push2=, 12($6)
	i32.const	$push15=, 3
	i32.add 	$push3=, $pop2, $pop15
	i32.const	$push14=, -4
	i32.and 	$push13=, $pop3, $pop14
	tee_local	$push12=, $2=, $pop13
	i32.const	$push11=, 4
	i32.add 	$push4=, $pop12, $pop11
	i32.store	$discard=, 12($6), $pop4
	i32.load	$push5=, 0($2)
	i32.add 	$2=, $pop5, $1
	i32.const	$push10=, -1
	i32.add 	$0=, $0, $pop10
	i32.const	$push9=, -4
	i32.add 	$1=, $1, $pop9
	i32.load	$push6=, 0($2)
	i32.eq  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: up to label10
# BB#3:                                 # %if.then
	end_loop                        # label11:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %while.end
	end_block                       # label9:
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
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
