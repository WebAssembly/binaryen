	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/multi-ix.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$54=, __stack_pointer
	i32.load	$54=, 0($54)
	i32.const	$55=, 80160
	i32.sub 	$217=, $54, $55
	i32.const	$55=, __stack_pointer
	i32.store	$217=, 0($55), $217
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$42=, __stack_pointer
	i32.load	$42=, 0($42)
	i32.const	$43=, 160
	i32.sub 	$217=, $42, $43
	i32.const	$43=, __stack_pointer
	i32.store	$217=, 0($43), $217
	i32.const	$57=, 78160
	i32.add 	$57=, $217, $57
	i32.store	$discard=, 0($217), $57
	i32.const	$push242=, 156
	i32.add 	$1=, $217, $pop242
	i32.const	$58=, 160
	i32.add 	$58=, $217, $58
	i32.store	$discard=, 0($1), $58
	i32.const	$push241=, 152
	i32.add 	$1=, $217, $pop241
	i32.const	$59=, 2160
	i32.add 	$59=, $217, $59
	i32.store	$discard=, 0($1), $59
	i32.const	$push240=, 148
	i32.add 	$1=, $217, $pop240
	i32.const	$60=, 4160
	i32.add 	$60=, $217, $60
	i32.store	$discard=, 0($1), $60
	i32.const	$push239=, 144
	i32.add 	$1=, $217, $pop239
	i32.const	$61=, 6160
	i32.add 	$61=, $217, $61
	i32.store	$discard=, 0($1), $61
	i32.const	$push238=, 140
	i32.add 	$1=, $217, $pop238
	i32.const	$62=, 8160
	i32.add 	$62=, $217, $62
	i32.store	$discard=, 0($1), $62
	i32.const	$push237=, 136
	i32.add 	$1=, $217, $pop237
	i32.const	$63=, 10160
	i32.add 	$63=, $217, $63
	i32.store	$discard=, 0($1), $63
	i32.const	$push236=, 132
	i32.add 	$1=, $217, $pop236
	i32.const	$64=, 12160
	i32.add 	$64=, $217, $64
	i32.store	$discard=, 0($1), $64
	i32.const	$push235=, 128
	i32.add 	$1=, $217, $pop235
	i32.const	$65=, 14160
	i32.add 	$65=, $217, $65
	i32.store	$discard=, 0($1), $65
	i32.const	$push234=, 124
	i32.add 	$1=, $217, $pop234
	i32.const	$66=, 16160
	i32.add 	$66=, $217, $66
	i32.store	$discard=, 0($1), $66
	i32.const	$push233=, 120
	i32.add 	$1=, $217, $pop233
	i32.const	$67=, 18160
	i32.add 	$67=, $217, $67
	i32.store	$discard=, 0($1), $67
	i32.const	$push232=, 116
	i32.add 	$1=, $217, $pop232
	i32.const	$68=, 20160
	i32.add 	$68=, $217, $68
	i32.store	$discard=, 0($1), $68
	i32.const	$push231=, 112
	i32.add 	$1=, $217, $pop231
	i32.const	$69=, 22160
	i32.add 	$69=, $217, $69
	i32.store	$discard=, 0($1), $69
	i32.const	$push230=, 108
	i32.add 	$1=, $217, $pop230
	i32.const	$70=, 24160
	i32.add 	$70=, $217, $70
	i32.store	$discard=, 0($1), $70
	i32.const	$push229=, 104
	i32.add 	$1=, $217, $pop229
	i32.const	$71=, 26160
	i32.add 	$71=, $217, $71
	i32.store	$discard=, 0($1), $71
	i32.const	$push228=, 100
	i32.add 	$1=, $217, $pop228
	i32.const	$72=, 28160
	i32.add 	$72=, $217, $72
	i32.store	$discard=, 0($1), $72
	i32.const	$push227=, 96
	i32.add 	$1=, $217, $pop227
	i32.const	$73=, 30160
	i32.add 	$73=, $217, $73
	i32.store	$discard=, 0($1), $73
	i32.const	$push226=, 92
	i32.add 	$1=, $217, $pop226
	i32.const	$74=, 32160
	i32.add 	$74=, $217, $74
	i32.store	$discard=, 0($1), $74
	i32.const	$push225=, 88
	i32.add 	$1=, $217, $pop225
	i32.const	$75=, 34160
	i32.add 	$75=, $217, $75
	i32.store	$discard=, 0($1), $75
	i32.const	$push224=, 84
	i32.add 	$1=, $217, $pop224
	i32.const	$76=, 36160
	i32.add 	$76=, $217, $76
	i32.store	$discard=, 0($1), $76
	i32.const	$push223=, 80
	i32.add 	$1=, $217, $pop223
	i32.const	$77=, 38160
	i32.add 	$77=, $217, $77
	i32.store	$discard=, 0($1), $77
	i32.const	$push222=, 76
	i32.add 	$1=, $217, $pop222
	i32.const	$78=, 40160
	i32.add 	$78=, $217, $78
	i32.store	$discard=, 0($1), $78
	i32.const	$push221=, 72
	i32.add 	$1=, $217, $pop221
	i32.const	$79=, 42160
	i32.add 	$79=, $217, $79
	i32.store	$discard=, 0($1), $79
	i32.const	$push220=, 68
	i32.add 	$1=, $217, $pop220
	i32.const	$80=, 44160
	i32.add 	$80=, $217, $80
	i32.store	$discard=, 0($1), $80
	i32.const	$push219=, 64
	i32.add 	$1=, $217, $pop219
	i32.const	$81=, 46160
	i32.add 	$81=, $217, $81
	i32.store	$discard=, 0($1), $81
	i32.const	$push218=, 60
	i32.add 	$1=, $217, $pop218
	i32.const	$82=, 48160
	i32.add 	$82=, $217, $82
	i32.store	$discard=, 0($1), $82
	i32.const	$push217=, 56
	i32.add 	$1=, $217, $pop217
	i32.const	$83=, 50160
	i32.add 	$83=, $217, $83
	i32.store	$discard=, 0($1), $83
	i32.const	$push216=, 52
	i32.add 	$1=, $217, $pop216
	i32.const	$84=, 52160
	i32.add 	$84=, $217, $84
	i32.store	$discard=, 0($1), $84
	i32.const	$push215=, 48
	i32.add 	$1=, $217, $pop215
	i32.const	$85=, 54160
	i32.add 	$85=, $217, $85
	i32.store	$discard=, 0($1), $85
	i32.const	$push214=, 44
	i32.add 	$1=, $217, $pop214
	i32.const	$86=, 56160
	i32.add 	$86=, $217, $86
	i32.store	$discard=, 0($1), $86
	i32.const	$push213=, 40
	i32.add 	$1=, $217, $pop213
	i32.const	$87=, 58160
	i32.add 	$87=, $217, $87
	i32.store	$discard=, 0($1), $87
	i32.const	$push212=, 36
	i32.add 	$1=, $217, $pop212
	i32.const	$88=, 60160
	i32.add 	$88=, $217, $88
	i32.store	$discard=, 0($1), $88
	i32.const	$push211=, 32
	i32.add 	$1=, $217, $pop211
	i32.const	$89=, 62160
	i32.add 	$89=, $217, $89
	i32.store	$discard=, 0($1), $89
	i32.const	$push210=, 28
	i32.add 	$1=, $217, $pop210
	i32.const	$90=, 64160
	i32.add 	$90=, $217, $90
	i32.store	$discard=, 0($1), $90
	i32.const	$push209=, 24
	i32.add 	$1=, $217, $pop209
	i32.const	$91=, 66160
	i32.add 	$91=, $217, $91
	i32.store	$discard=, 0($1), $91
	i32.const	$push208=, 20
	i32.add 	$1=, $217, $pop208
	i32.const	$92=, 68160
	i32.add 	$92=, $217, $92
	i32.store	$discard=, 0($1), $92
	i32.const	$push207=, 16
	i32.add 	$1=, $217, $pop207
	i32.const	$93=, 70160
	i32.add 	$93=, $217, $93
	i32.store	$discard=, 0($1), $93
	i32.const	$push206=, 12
	i32.add 	$1=, $217, $pop206
	i32.const	$94=, 72160
	i32.add 	$94=, $217, $94
	i32.store	$discard=, 0($1), $94
	i32.const	$push205=, 8
	i32.add 	$1=, $217, $pop205
	i32.const	$95=, 74160
	i32.add 	$95=, $217, $95
	i32.store	$discard=, 0($1), $95
	i32.const	$push204=, 4
	i32.add 	$1=, $217, $pop204
	i32.const	$96=, 76160
	i32.add 	$96=, $217, $96
	i32.store	$discard=, 0($1), $96
	i32.const	$push203=, 40
	call    	s@FUNCTION, $pop203
	i32.const	$44=, __stack_pointer
	i32.load	$44=, 0($44)
	i32.const	$45=, 160
	i32.add 	$217=, $44, $45
	i32.const	$45=, __stack_pointer
	i32.store	$217=, 0($45), $217
	i32.load	$1=, 78160($217):p2align=4
	i32.load	$2=, 76160($217):p2align=4
	i32.load	$3=, 74160($217):p2align=4
	i32.load	$4=, 72160($217):p2align=4
	i32.load	$5=, 70160($217):p2align=4
	i32.load	$6=, 68160($217):p2align=4
	i32.load	$7=, 66160($217):p2align=4
	i32.load	$8=, 64160($217):p2align=4
	i32.load	$9=, 62160($217):p2align=4
	i32.load	$10=, 60160($217):p2align=4
	i32.load	$11=, 58160($217):p2align=4
	i32.load	$12=, 56160($217):p2align=4
	i32.load	$13=, 54160($217):p2align=4
	i32.load	$14=, 52160($217):p2align=4
	i32.load	$15=, 50160($217):p2align=4
	i32.load	$16=, 48160($217):p2align=4
	i32.load	$17=, 46160($217):p2align=4
	i32.load	$18=, 44160($217):p2align=4
	i32.load	$19=, 42160($217):p2align=4
	i32.load	$20=, 40160($217):p2align=4
	i32.load	$21=, 38160($217):p2align=4
	i32.load	$22=, 36160($217):p2align=4
	i32.load	$23=, 34160($217):p2align=4
	i32.load	$24=, 32160($217):p2align=4
	i32.load	$25=, 30160($217):p2align=4
	i32.load	$26=, 28160($217):p2align=4
	i32.load	$27=, 26160($217):p2align=4
	i32.load	$28=, 24160($217):p2align=4
	i32.load	$29=, 22160($217):p2align=4
	i32.load	$30=, 20160($217):p2align=4
	i32.load	$31=, 18160($217):p2align=4
	i32.load	$32=, 16160($217):p2align=4
	i32.load	$33=, 14160($217):p2align=4
	i32.load	$34=, 12160($217):p2align=4
	i32.load	$35=, 10160($217):p2align=4
	i32.load	$36=, 8160($217):p2align=4
	i32.load	$37=, 6160($217):p2align=4
	i32.load	$38=, 4160($217):p2align=4
	i32.load	$39=, 2160($217):p2align=4
	i32.load	$40=, 160($217):p2align=4
	i32.const	$46=, __stack_pointer
	i32.load	$46=, 0($46)
	i32.const	$47=, 160
	i32.sub 	$217=, $46, $47
	i32.const	$47=, __stack_pointer
	i32.store	$217=, 0($47), $217
	i32.const	$97=, 78160
	i32.add 	$97=, $217, $97
	i32.store	$discard=, 0($217), $97
	i32.const	$push202=, 156
	i32.add 	$41=, $217, $pop202
	i32.const	$98=, 160
	i32.add 	$98=, $217, $98
	i32.store	$discard=, 0($41), $98
	i32.const	$push201=, 152
	i32.add 	$41=, $217, $pop201
	i32.const	$99=, 2160
	i32.add 	$99=, $217, $99
	i32.store	$discard=, 0($41), $99
	i32.const	$push200=, 148
	i32.add 	$41=, $217, $pop200
	i32.const	$100=, 4160
	i32.add 	$100=, $217, $100
	i32.store	$discard=, 0($41), $100
	i32.const	$push199=, 144
	i32.add 	$41=, $217, $pop199
	i32.const	$101=, 6160
	i32.add 	$101=, $217, $101
	i32.store	$discard=, 0($41), $101
	i32.const	$push198=, 140
	i32.add 	$41=, $217, $pop198
	i32.const	$102=, 8160
	i32.add 	$102=, $217, $102
	i32.store	$discard=, 0($41), $102
	i32.const	$push197=, 136
	i32.add 	$41=, $217, $pop197
	i32.const	$103=, 10160
	i32.add 	$103=, $217, $103
	i32.store	$discard=, 0($41), $103
	i32.const	$push196=, 132
	i32.add 	$41=, $217, $pop196
	i32.const	$104=, 12160
	i32.add 	$104=, $217, $104
	i32.store	$discard=, 0($41), $104
	i32.const	$push195=, 128
	i32.add 	$41=, $217, $pop195
	i32.const	$105=, 14160
	i32.add 	$105=, $217, $105
	i32.store	$discard=, 0($41), $105
	i32.const	$push194=, 124
	i32.add 	$41=, $217, $pop194
	i32.const	$106=, 16160
	i32.add 	$106=, $217, $106
	i32.store	$discard=, 0($41), $106
	i32.const	$push193=, 120
	i32.add 	$41=, $217, $pop193
	i32.const	$107=, 18160
	i32.add 	$107=, $217, $107
	i32.store	$discard=, 0($41), $107
	i32.const	$push192=, 116
	i32.add 	$41=, $217, $pop192
	i32.const	$108=, 20160
	i32.add 	$108=, $217, $108
	i32.store	$discard=, 0($41), $108
	i32.const	$push191=, 112
	i32.add 	$41=, $217, $pop191
	i32.const	$109=, 22160
	i32.add 	$109=, $217, $109
	i32.store	$discard=, 0($41), $109
	i32.const	$push190=, 108
	i32.add 	$41=, $217, $pop190
	i32.const	$110=, 24160
	i32.add 	$110=, $217, $110
	i32.store	$discard=, 0($41), $110
	i32.const	$push189=, 104
	i32.add 	$41=, $217, $pop189
	i32.const	$111=, 26160
	i32.add 	$111=, $217, $111
	i32.store	$discard=, 0($41), $111
	i32.const	$push188=, 100
	i32.add 	$41=, $217, $pop188
	i32.const	$112=, 28160
	i32.add 	$112=, $217, $112
	i32.store	$discard=, 0($41), $112
	i32.const	$push187=, 96
	i32.add 	$41=, $217, $pop187
	i32.const	$113=, 30160
	i32.add 	$113=, $217, $113
	i32.store	$discard=, 0($41), $113
	i32.const	$push186=, 92
	i32.add 	$41=, $217, $pop186
	i32.const	$114=, 32160
	i32.add 	$114=, $217, $114
	i32.store	$discard=, 0($41), $114
	i32.const	$push185=, 88
	i32.add 	$41=, $217, $pop185
	i32.const	$115=, 34160
	i32.add 	$115=, $217, $115
	i32.store	$discard=, 0($41), $115
	i32.const	$push184=, 84
	i32.add 	$41=, $217, $pop184
	i32.const	$116=, 36160
	i32.add 	$116=, $217, $116
	i32.store	$discard=, 0($41), $116
	i32.const	$push183=, 80
	i32.add 	$41=, $217, $pop183
	i32.const	$117=, 38160
	i32.add 	$117=, $217, $117
	i32.store	$discard=, 0($41), $117
	i32.const	$push182=, 76
	i32.add 	$41=, $217, $pop182
	i32.const	$118=, 40160
	i32.add 	$118=, $217, $118
	i32.store	$discard=, 0($41), $118
	i32.const	$push181=, 72
	i32.add 	$41=, $217, $pop181
	i32.const	$119=, 42160
	i32.add 	$119=, $217, $119
	i32.store	$discard=, 0($41), $119
	i32.const	$push180=, 68
	i32.add 	$41=, $217, $pop180
	i32.const	$120=, 44160
	i32.add 	$120=, $217, $120
	i32.store	$discard=, 0($41), $120
	i32.const	$push179=, 64
	i32.add 	$41=, $217, $pop179
	i32.const	$121=, 46160
	i32.add 	$121=, $217, $121
	i32.store	$discard=, 0($41), $121
	i32.const	$push178=, 60
	i32.add 	$41=, $217, $pop178
	i32.const	$122=, 48160
	i32.add 	$122=, $217, $122
	i32.store	$discard=, 0($41), $122
	i32.const	$push177=, 56
	i32.add 	$41=, $217, $pop177
	i32.const	$123=, 50160
	i32.add 	$123=, $217, $123
	i32.store	$discard=, 0($41), $123
	i32.const	$push176=, 52
	i32.add 	$41=, $217, $pop176
	i32.const	$124=, 52160
	i32.add 	$124=, $217, $124
	i32.store	$discard=, 0($41), $124
	i32.const	$push175=, 48
	i32.add 	$41=, $217, $pop175
	i32.const	$125=, 54160
	i32.add 	$125=, $217, $125
	i32.store	$discard=, 0($41), $125
	i32.const	$push174=, 44
	i32.add 	$41=, $217, $pop174
	i32.const	$126=, 56160
	i32.add 	$126=, $217, $126
	i32.store	$discard=, 0($41), $126
	i32.const	$push173=, 40
	i32.add 	$41=, $217, $pop173
	i32.const	$127=, 58160
	i32.add 	$127=, $217, $127
	i32.store	$discard=, 0($41), $127
	i32.const	$push172=, 36
	i32.add 	$41=, $217, $pop172
	i32.const	$128=, 60160
	i32.add 	$128=, $217, $128
	i32.store	$discard=, 0($41), $128
	i32.const	$push171=, 32
	i32.add 	$41=, $217, $pop171
	i32.const	$129=, 62160
	i32.add 	$129=, $217, $129
	i32.store	$discard=, 0($41), $129
	i32.const	$push170=, 28
	i32.add 	$41=, $217, $pop170
	i32.const	$130=, 64160
	i32.add 	$130=, $217, $130
	i32.store	$discard=, 0($41), $130
	i32.const	$push169=, 24
	i32.add 	$41=, $217, $pop169
	i32.const	$131=, 66160
	i32.add 	$131=, $217, $131
	i32.store	$discard=, 0($41), $131
	i32.const	$push168=, 20
	i32.add 	$41=, $217, $pop168
	i32.const	$132=, 68160
	i32.add 	$132=, $217, $132
	i32.store	$discard=, 0($41), $132
	i32.const	$push167=, 16
	i32.add 	$41=, $217, $pop167
	i32.const	$133=, 70160
	i32.add 	$133=, $217, $133
	i32.store	$discard=, 0($41), $133
	i32.const	$push166=, 12
	i32.add 	$41=, $217, $pop166
	i32.const	$134=, 72160
	i32.add 	$134=, $217, $134
	i32.store	$discard=, 0($41), $134
	i32.const	$push165=, 8
	i32.add 	$41=, $217, $pop165
	i32.const	$135=, 74160
	i32.add 	$135=, $217, $135
	i32.store	$discard=, 0($41), $135
	i32.const	$push164=, 4
	i32.add 	$41=, $217, $pop164
	i32.const	$136=, 76160
	i32.add 	$136=, $217, $136
	i32.store	$discard=, 0($41), $136
	i32.const	$push163=, 40
	call    	z@FUNCTION, $pop163
	i32.const	$48=, __stack_pointer
	i32.load	$48=, 0($48)
	i32.const	$49=, 160
	i32.add 	$217=, $48, $49
	i32.const	$49=, __stack_pointer
	i32.store	$217=, 0($49), $217
	i32.const	$push162=, 2
	i32.shl 	$push2=, $1, $pop162
	i32.const	$137=, 78160
	i32.add 	$137=, $217, $137
	i32.add 	$push3=, $137, $pop2
	i32.store	$discard=, 0($pop3), $1
	i32.const	$push161=, 2
	i32.shl 	$push4=, $2, $pop161
	i32.const	$138=, 76160
	i32.add 	$138=, $217, $138
	i32.add 	$push5=, $138, $pop4
	i32.store	$discard=, 0($pop5), $2
	i32.const	$push160=, 2
	i32.shl 	$push6=, $3, $pop160
	i32.const	$139=, 74160
	i32.add 	$139=, $217, $139
	i32.add 	$push7=, $139, $pop6
	i32.store	$discard=, 0($pop7), $3
	i32.const	$push159=, 2
	i32.shl 	$push8=, $4, $pop159
	i32.const	$140=, 72160
	i32.add 	$140=, $217, $140
	i32.add 	$push9=, $140, $pop8
	i32.store	$discard=, 0($pop9), $4
	i32.const	$push158=, 2
	i32.shl 	$push10=, $5, $pop158
	i32.const	$141=, 70160
	i32.add 	$141=, $217, $141
	i32.add 	$push11=, $141, $pop10
	i32.store	$discard=, 0($pop11), $5
	i32.const	$push157=, 2
	i32.shl 	$push12=, $6, $pop157
	i32.const	$142=, 68160
	i32.add 	$142=, $217, $142
	i32.add 	$push13=, $142, $pop12
	i32.store	$discard=, 0($pop13), $6
	i32.const	$push156=, 2
	i32.shl 	$push14=, $7, $pop156
	i32.const	$143=, 66160
	i32.add 	$143=, $217, $143
	i32.add 	$push15=, $143, $pop14
	i32.store	$discard=, 0($pop15), $7
	i32.const	$push155=, 2
	i32.shl 	$push16=, $8, $pop155
	i32.const	$144=, 64160
	i32.add 	$144=, $217, $144
	i32.add 	$push17=, $144, $pop16
	i32.store	$discard=, 0($pop17), $8
	i32.const	$push154=, 2
	i32.shl 	$push18=, $9, $pop154
	i32.const	$145=, 62160
	i32.add 	$145=, $217, $145
	i32.add 	$push19=, $145, $pop18
	i32.store	$discard=, 0($pop19), $9
	i32.const	$push153=, 2
	i32.shl 	$push20=, $10, $pop153
	i32.const	$146=, 60160
	i32.add 	$146=, $217, $146
	i32.add 	$push21=, $146, $pop20
	i32.store	$discard=, 0($pop21), $10
	i32.const	$push152=, 2
	i32.shl 	$push22=, $11, $pop152
	i32.const	$147=, 58160
	i32.add 	$147=, $217, $147
	i32.add 	$push23=, $147, $pop22
	i32.store	$discard=, 0($pop23), $11
	i32.const	$push151=, 2
	i32.shl 	$push24=, $12, $pop151
	i32.const	$148=, 56160
	i32.add 	$148=, $217, $148
	i32.add 	$push25=, $148, $pop24
	i32.store	$discard=, 0($pop25), $12
	i32.const	$push150=, 2
	i32.shl 	$push26=, $13, $pop150
	i32.const	$149=, 54160
	i32.add 	$149=, $217, $149
	i32.add 	$push27=, $149, $pop26
	i32.store	$discard=, 0($pop27), $13
	i32.const	$push149=, 2
	i32.shl 	$push28=, $14, $pop149
	i32.const	$150=, 52160
	i32.add 	$150=, $217, $150
	i32.add 	$push29=, $150, $pop28
	i32.store	$discard=, 0($pop29), $14
	i32.const	$push148=, 2
	i32.shl 	$push30=, $15, $pop148
	i32.const	$151=, 50160
	i32.add 	$151=, $217, $151
	i32.add 	$push31=, $151, $pop30
	i32.store	$discard=, 0($pop31), $15
	i32.const	$push147=, 2
	i32.shl 	$push32=, $16, $pop147
	i32.const	$152=, 48160
	i32.add 	$152=, $217, $152
	i32.add 	$push33=, $152, $pop32
	i32.store	$discard=, 0($pop33), $16
	i32.const	$push146=, 2
	i32.shl 	$push34=, $17, $pop146
	i32.const	$153=, 46160
	i32.add 	$153=, $217, $153
	i32.add 	$push35=, $153, $pop34
	i32.store	$discard=, 0($pop35), $17
	i32.const	$push145=, 2
	i32.shl 	$push36=, $18, $pop145
	i32.const	$154=, 44160
	i32.add 	$154=, $217, $154
	i32.add 	$push37=, $154, $pop36
	i32.store	$discard=, 0($pop37), $18
	i32.const	$push144=, 2
	i32.shl 	$push38=, $19, $pop144
	i32.const	$155=, 42160
	i32.add 	$155=, $217, $155
	i32.add 	$push39=, $155, $pop38
	i32.store	$discard=, 0($pop39), $19
	i32.const	$push143=, 2
	i32.shl 	$push40=, $20, $pop143
	i32.const	$156=, 40160
	i32.add 	$156=, $217, $156
	i32.add 	$push41=, $156, $pop40
	i32.store	$discard=, 0($pop41), $20
	i32.const	$push142=, 2
	i32.shl 	$push42=, $21, $pop142
	i32.const	$157=, 38160
	i32.add 	$157=, $217, $157
	i32.add 	$push43=, $157, $pop42
	i32.store	$discard=, 0($pop43), $21
	i32.const	$push141=, 2
	i32.shl 	$push44=, $22, $pop141
	i32.const	$158=, 36160
	i32.add 	$158=, $217, $158
	i32.add 	$push45=, $158, $pop44
	i32.store	$discard=, 0($pop45), $22
	i32.const	$push140=, 2
	i32.shl 	$push46=, $23, $pop140
	i32.const	$159=, 34160
	i32.add 	$159=, $217, $159
	i32.add 	$push47=, $159, $pop46
	i32.store	$discard=, 0($pop47), $23
	i32.const	$push139=, 2
	i32.shl 	$push48=, $24, $pop139
	i32.const	$160=, 32160
	i32.add 	$160=, $217, $160
	i32.add 	$push49=, $160, $pop48
	i32.store	$discard=, 0($pop49), $24
	i32.const	$push138=, 2
	i32.shl 	$push50=, $25, $pop138
	i32.const	$161=, 30160
	i32.add 	$161=, $217, $161
	i32.add 	$push51=, $161, $pop50
	i32.store	$discard=, 0($pop51), $25
	i32.const	$push137=, 2
	i32.shl 	$push52=, $26, $pop137
	i32.const	$162=, 28160
	i32.add 	$162=, $217, $162
	i32.add 	$push53=, $162, $pop52
	i32.store	$discard=, 0($pop53), $26
	i32.const	$push136=, 2
	i32.shl 	$push54=, $27, $pop136
	i32.const	$163=, 26160
	i32.add 	$163=, $217, $163
	i32.add 	$push55=, $163, $pop54
	i32.store	$discard=, 0($pop55), $27
	i32.const	$push135=, 2
	i32.shl 	$push56=, $28, $pop135
	i32.const	$164=, 24160
	i32.add 	$164=, $217, $164
	i32.add 	$push57=, $164, $pop56
	i32.store	$discard=, 0($pop57), $28
	i32.const	$push134=, 2
	i32.shl 	$push58=, $29, $pop134
	i32.const	$165=, 22160
	i32.add 	$165=, $217, $165
	i32.add 	$push59=, $165, $pop58
	i32.store	$discard=, 0($pop59), $29
	i32.const	$push133=, 2
	i32.shl 	$push60=, $30, $pop133
	i32.const	$166=, 20160
	i32.add 	$166=, $217, $166
	i32.add 	$push61=, $166, $pop60
	i32.store	$discard=, 0($pop61), $30
	i32.const	$push132=, 2
	i32.shl 	$push62=, $31, $pop132
	i32.const	$167=, 18160
	i32.add 	$167=, $217, $167
	i32.add 	$push63=, $167, $pop62
	i32.store	$discard=, 0($pop63), $31
	i32.const	$push131=, 2
	i32.shl 	$push64=, $32, $pop131
	i32.const	$168=, 16160
	i32.add 	$168=, $217, $168
	i32.add 	$push65=, $168, $pop64
	i32.store	$discard=, 0($pop65), $32
	i32.const	$push130=, 2
	i32.shl 	$push66=, $33, $pop130
	i32.const	$169=, 14160
	i32.add 	$169=, $217, $169
	i32.add 	$push67=, $169, $pop66
	i32.store	$discard=, 0($pop67), $33
	i32.const	$push129=, 2
	i32.shl 	$push68=, $34, $pop129
	i32.const	$170=, 12160
	i32.add 	$170=, $217, $170
	i32.add 	$push69=, $170, $pop68
	i32.store	$discard=, 0($pop69), $34
	i32.const	$push128=, 2
	i32.shl 	$push70=, $35, $pop128
	i32.const	$171=, 10160
	i32.add 	$171=, $217, $171
	i32.add 	$push71=, $171, $pop70
	i32.store	$discard=, 0($pop71), $35
	i32.const	$push127=, 2
	i32.shl 	$push72=, $36, $pop127
	i32.const	$172=, 8160
	i32.add 	$172=, $217, $172
	i32.add 	$push73=, $172, $pop72
	i32.store	$discard=, 0($pop73), $36
	i32.const	$push126=, 2
	i32.shl 	$push74=, $37, $pop126
	i32.const	$173=, 6160
	i32.add 	$173=, $217, $173
	i32.add 	$push75=, $173, $pop74
	i32.store	$discard=, 0($pop75), $37
	i32.const	$push125=, 2
	i32.shl 	$push76=, $38, $pop125
	i32.const	$174=, 4160
	i32.add 	$174=, $217, $174
	i32.add 	$push77=, $174, $pop76
	i32.store	$discard=, 0($pop77), $38
	i32.const	$push124=, 2
	i32.shl 	$push78=, $39, $pop124
	i32.const	$175=, 2160
	i32.add 	$175=, $217, $175
	i32.add 	$push79=, $175, $pop78
	i32.store	$discard=, 0($pop79), $39
	i32.const	$push123=, 2
	i32.shl 	$push80=, $40, $pop123
	i32.const	$176=, 160
	i32.add 	$176=, $217, $176
	i32.add 	$push81=, $176, $pop80
	i32.store	$discard=, 0($pop81), $40
	i32.const	$50=, __stack_pointer
	i32.load	$50=, 0($50)
	i32.const	$51=, 160
	i32.sub 	$217=, $50, $51
	i32.const	$51=, __stack_pointer
	i32.store	$217=, 0($51), $217
	i32.const	$177=, 78160
	i32.add 	$177=, $217, $177
	i32.store	$discard=, 0($217), $177
	i32.const	$push122=, 156
	i32.add 	$1=, $217, $pop122
	i32.const	$178=, 160
	i32.add 	$178=, $217, $178
	i32.store	$discard=, 0($1), $178
	i32.const	$push121=, 152
	i32.add 	$1=, $217, $pop121
	i32.const	$179=, 2160
	i32.add 	$179=, $217, $179
	i32.store	$discard=, 0($1), $179
	i32.const	$push120=, 148
	i32.add 	$1=, $217, $pop120
	i32.const	$180=, 4160
	i32.add 	$180=, $217, $180
	i32.store	$discard=, 0($1), $180
	i32.const	$push119=, 144
	i32.add 	$1=, $217, $pop119
	i32.const	$181=, 6160
	i32.add 	$181=, $217, $181
	i32.store	$discard=, 0($1), $181
	i32.const	$push118=, 140
	i32.add 	$1=, $217, $pop118
	i32.const	$182=, 8160
	i32.add 	$182=, $217, $182
	i32.store	$discard=, 0($1), $182
	i32.const	$push117=, 136
	i32.add 	$1=, $217, $pop117
	i32.const	$183=, 10160
	i32.add 	$183=, $217, $183
	i32.store	$discard=, 0($1), $183
	i32.const	$push116=, 132
	i32.add 	$1=, $217, $pop116
	i32.const	$184=, 12160
	i32.add 	$184=, $217, $184
	i32.store	$discard=, 0($1), $184
	i32.const	$push115=, 128
	i32.add 	$1=, $217, $pop115
	i32.const	$185=, 14160
	i32.add 	$185=, $217, $185
	i32.store	$discard=, 0($1), $185
	i32.const	$push114=, 124
	i32.add 	$1=, $217, $pop114
	i32.const	$186=, 16160
	i32.add 	$186=, $217, $186
	i32.store	$discard=, 0($1), $186
	i32.const	$push113=, 120
	i32.add 	$1=, $217, $pop113
	i32.const	$187=, 18160
	i32.add 	$187=, $217, $187
	i32.store	$discard=, 0($1), $187
	i32.const	$push112=, 116
	i32.add 	$1=, $217, $pop112
	i32.const	$188=, 20160
	i32.add 	$188=, $217, $188
	i32.store	$discard=, 0($1), $188
	i32.const	$push111=, 112
	i32.add 	$1=, $217, $pop111
	i32.const	$189=, 22160
	i32.add 	$189=, $217, $189
	i32.store	$discard=, 0($1), $189
	i32.const	$push110=, 108
	i32.add 	$1=, $217, $pop110
	i32.const	$190=, 24160
	i32.add 	$190=, $217, $190
	i32.store	$discard=, 0($1), $190
	i32.const	$push109=, 104
	i32.add 	$1=, $217, $pop109
	i32.const	$191=, 26160
	i32.add 	$191=, $217, $191
	i32.store	$discard=, 0($1), $191
	i32.const	$push108=, 100
	i32.add 	$1=, $217, $pop108
	i32.const	$192=, 28160
	i32.add 	$192=, $217, $192
	i32.store	$discard=, 0($1), $192
	i32.const	$push107=, 96
	i32.add 	$1=, $217, $pop107
	i32.const	$193=, 30160
	i32.add 	$193=, $217, $193
	i32.store	$discard=, 0($1), $193
	i32.const	$push106=, 92
	i32.add 	$1=, $217, $pop106
	i32.const	$194=, 32160
	i32.add 	$194=, $217, $194
	i32.store	$discard=, 0($1), $194
	i32.const	$push105=, 88
	i32.add 	$1=, $217, $pop105
	i32.const	$195=, 34160
	i32.add 	$195=, $217, $195
	i32.store	$discard=, 0($1), $195
	i32.const	$push104=, 84
	i32.add 	$1=, $217, $pop104
	i32.const	$196=, 36160
	i32.add 	$196=, $217, $196
	i32.store	$discard=, 0($1), $196
	i32.const	$push103=, 80
	i32.add 	$1=, $217, $pop103
	i32.const	$197=, 38160
	i32.add 	$197=, $217, $197
	i32.store	$discard=, 0($1), $197
	i32.const	$push102=, 76
	i32.add 	$1=, $217, $pop102
	i32.const	$198=, 40160
	i32.add 	$198=, $217, $198
	i32.store	$discard=, 0($1), $198
	i32.const	$push101=, 72
	i32.add 	$1=, $217, $pop101
	i32.const	$199=, 42160
	i32.add 	$199=, $217, $199
	i32.store	$discard=, 0($1), $199
	i32.const	$push100=, 68
	i32.add 	$1=, $217, $pop100
	i32.const	$200=, 44160
	i32.add 	$200=, $217, $200
	i32.store	$discard=, 0($1), $200
	i32.const	$push99=, 64
	i32.add 	$1=, $217, $pop99
	i32.const	$201=, 46160
	i32.add 	$201=, $217, $201
	i32.store	$discard=, 0($1), $201
	i32.const	$push98=, 60
	i32.add 	$1=, $217, $pop98
	i32.const	$202=, 48160
	i32.add 	$202=, $217, $202
	i32.store	$discard=, 0($1), $202
	i32.const	$push97=, 56
	i32.add 	$1=, $217, $pop97
	i32.const	$203=, 50160
	i32.add 	$203=, $217, $203
	i32.store	$discard=, 0($1), $203
	i32.const	$push96=, 52
	i32.add 	$1=, $217, $pop96
	i32.const	$204=, 52160
	i32.add 	$204=, $217, $204
	i32.store	$discard=, 0($1), $204
	i32.const	$push95=, 48
	i32.add 	$1=, $217, $pop95
	i32.const	$205=, 54160
	i32.add 	$205=, $217, $205
	i32.store	$discard=, 0($1), $205
	i32.const	$push94=, 44
	i32.add 	$1=, $217, $pop94
	i32.const	$206=, 56160
	i32.add 	$206=, $217, $206
	i32.store	$discard=, 0($1), $206
	i32.const	$push93=, 40
	i32.add 	$1=, $217, $pop93
	i32.const	$207=, 58160
	i32.add 	$207=, $217, $207
	i32.store	$discard=, 0($1), $207
	i32.const	$push92=, 36
	i32.add 	$1=, $217, $pop92
	i32.const	$208=, 60160
	i32.add 	$208=, $217, $208
	i32.store	$discard=, 0($1), $208
	i32.const	$push91=, 32
	i32.add 	$1=, $217, $pop91
	i32.const	$209=, 62160
	i32.add 	$209=, $217, $209
	i32.store	$discard=, 0($1), $209
	i32.const	$push90=, 28
	i32.add 	$1=, $217, $pop90
	i32.const	$210=, 64160
	i32.add 	$210=, $217, $210
	i32.store	$discard=, 0($1), $210
	i32.const	$push89=, 24
	i32.add 	$1=, $217, $pop89
	i32.const	$211=, 66160
	i32.add 	$211=, $217, $211
	i32.store	$discard=, 0($1), $211
	i32.const	$push88=, 20
	i32.add 	$1=, $217, $pop88
	i32.const	$212=, 68160
	i32.add 	$212=, $217, $212
	i32.store	$discard=, 0($1), $212
	i32.const	$push87=, 16
	i32.add 	$1=, $217, $pop87
	i32.const	$213=, 70160
	i32.add 	$213=, $217, $213
	i32.store	$discard=, 0($1), $213
	i32.const	$push86=, 12
	i32.add 	$1=, $217, $pop86
	i32.const	$214=, 72160
	i32.add 	$214=, $217, $214
	i32.store	$discard=, 0($1), $214
	i32.const	$push85=, 8
	i32.add 	$1=, $217, $pop85
	i32.const	$215=, 74160
	i32.add 	$215=, $217, $215
	i32.store	$discard=, 0($1), $215
	i32.const	$push84=, 4
	i32.add 	$1=, $217, $pop84
	i32.const	$216=, 76160
	i32.add 	$216=, $217, $216
	i32.store	$discard=, 0($1), $216
	i32.const	$push83=, 40
	call    	c@FUNCTION, $pop83
	i32.const	$52=, __stack_pointer
	i32.load	$52=, 0($52)
	i32.const	$53=, 160
	i32.add 	$217=, $52, $53
	i32.const	$53=, __stack_pointer
	i32.store	$217=, 0($53), $217
	i32.const	$push82=, -1
	i32.add 	$0=, $0, $pop82
	br_if   	$0, 0           # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$56=, 80160
	i32.add 	$217=, $217, $56
	i32.const	$56=, __stack_pointer
	i32.store	$217=, 0($56), $217
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.s,"ax",@progbits
	.hidden	s
	.globl	s
	.type	s,@function
s:                                      # @s
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $6
	block
	i32.const	$push14=, 0
	i32.eq  	$push15=, $0, $pop14
	br_if   	$pop15, 0       # 0: down to label3
# BB#1:                                 # %while.body.preheader
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push0=, 12($5)
	i32.const	$push13=, 3
	i32.add 	$push1=, $pop0, $pop13
	i32.const	$push12=, -4
	i32.and 	$push2=, $pop1, $pop12
	tee_local	$push11=, $1=, $pop2
	i32.const	$push10=, 4
	i32.add 	$push3=, $pop11, $pop10
	i32.store	$discard=, 12($5), $pop3
	i32.load	$push4=, 0($1)
	i32.store	$push5=, 0($pop4), $0
	i32.const	$push9=, -1
	i32.add 	$0=, $pop5, $pop9
	i32.const	$push8=, -1
	i32.ne  	$push6=, $0, $pop8
	br_if   	$pop6, 0        # 0: up to label4
.LBB1_3:                                # %while.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
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
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $6
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $0, $pop12
	br_if   	$pop13, 0       # 0: down to label6
.LBB2_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.load	$push1=, 12($5)
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push11=, $1=, $pop5
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop11, $pop6
	i32.store	$discard=, 12($5), $pop7
	i32.const	$push0=, -1
	i32.add 	$0=, $0, $pop0
	i32.load	$push8=, 0($1)
	i32.const	$push10=, 0
	i32.const	$push9=, 2000
	i32.call	$discard=, memset@FUNCTION, $pop8, $pop10, $pop9
	br_if   	$0, 0           # 0: up to label7
.LBB2_2:                                # %while.end
	end_loop                        # label8:
	end_block                       # label6:
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
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
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	copy_local	$7=, $6
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $7
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push9=, -4
	i32.add 	$1=, $pop1, $pop9
.LBB3_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label10:
	i32.const	$push16=, 0
	i32.eq  	$push17=, $0, $pop16
	br_if   	$pop17, 2       # 2: down to label9
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$push2=, 12($6)
	i32.const	$push15=, 3
	i32.add 	$push3=, $pop2, $pop15
	i32.const	$push14=, -4
	i32.and 	$push4=, $pop3, $pop14
	tee_local	$push13=, $2=, $pop4
	i32.const	$push12=, 4
	i32.add 	$push5=, $pop13, $pop12
	i32.store	$discard=, 12($6), $pop5
	i32.load	$push6=, 0($2)
	i32.add 	$2=, $pop6, $1
	i32.const	$push11=, -1
	i32.add 	$0=, $0, $pop11
	i32.const	$push10=, -4
	i32.add 	$1=, $1, $pop10
	i32.load	$push7=, 0($2)
	i32.eq  	$push8=, $0, $pop7
	br_if   	$pop8, 0        # 0: up to label10
# BB#3:                                 # %if.then
	end_loop                        # label11:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %while.end
	end_block                       # label9:
	i32.const	$5=, 16
	i32.add 	$6=, $7, $5
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
