	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-2.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_5
	i32.ne  	$push0=, $0, $4
	br_if   	$pop0, .LBB0_5
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	$pop1, .LBB0_5
# BB#2:                                 # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	$pop2, .LBB0_5
# BB#3:                                 # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	$pop3, .LBB0_5
# BB#4:                                 # %if.end
	return
.LBB0_5:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	verify, .Lfunc_end0-verify

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$16=, 0
	i32.load16_u	$7=, i+14($16)
	i32.load16_u	$15=, j+14($16)
	i32.add 	$push7=, $15, $7
	i32.store16	$23=, k+14($16), $pop7
	i32.load16_u	$6=, i+12($16)
	i32.load16_u	$14=, j+12($16)
	i32.store16	$discard=, res+14($16), $23
	i32.load16_u	$5=, i+10($16)
	i32.load16_u	$13=, j+10($16)
	i32.add 	$push6=, $14, $6
	i32.store16	$push8=, k+12($16), $pop6
	i32.store16	$discard=, res+12($16), $pop8
	i32.add 	$push5=, $13, $5
	i32.store16	$23=, k+10($16), $pop5
	i32.load16_u	$4=, i+8($16)
	i32.load16_u	$12=, j+8($16)
	i32.store16	$discard=, res+10($16), $23
	i32.load16_u	$3=, i+6($16)
	i32.load16_u	$11=, j+6($16)
	i32.add 	$push4=, $12, $4
	i32.store16	$push9=, k+8($16), $pop4
	i32.store16	$discard=, res+8($16), $pop9
	i32.add 	$push2=, $11, $3
	i32.store16	$23=, k+6($16), $pop2
	i32.load16_u	$2=, i+4($16)
	i32.load16_u	$1=, i+2($16)
	i32.load16_u	$10=, j+4($16)
	i32.load16_u	$0=, i($16)
	i32.load16_u	$9=, j+2($16)
	i32.load16_u	$8=, j($16)
	i32.store16	$17=, res+6($16), $23
	i32.add 	$push1=, $10, $2
	i32.store16	$push10=, k+4($16), $pop1
	i32.store16	$18=, res+4($16), $pop10
	i32.add 	$push0=, $9, $1
	i32.store16	$push11=, k+2($16), $pop0
	i32.store16	$19=, res+2($16), $pop11
	i32.add 	$push3=, $8, $0
	i32.store16	$push12=, k($16), $pop3
	i32.store16	$23=, res($16), $pop12
	i32.const	$20=, 65535
	block   	.LBB1_40
	i32.and 	$push13=, $23, $20
	i32.const	$push14=, 160
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, .LBB1_40
# BB#1:                                 # %entry
	i32.and 	$push16=, $19, $20
	i32.const	$push17=, 113
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	$pop18, .LBB1_40
# BB#2:                                 # %entry
	i32.and 	$push19=, $18, $20
	i32.const	$push20=, 170
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	$pop21, .LBB1_40
# BB#3:                                 # %entry
	i32.and 	$push22=, $17, $20
	i32.const	$push23=, 230
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	$pop24, .LBB1_40
# BB#4:                                 # %verify.exit
	block   	.LBB1_39
	i32.mul 	$push32=, $8, $0
	i32.store16	$push33=, k($16), $pop32
	i32.store16	$23=, res($16), $pop33
	i32.mul 	$push25=, $9, $1
	i32.store16	$push34=, k+2($16), $pop25
	i32.store16	$19=, res+2($16), $pop34
	i32.mul 	$push26=, $10, $2
	i32.store16	$push35=, k+4($16), $pop26
	i32.store16	$18=, res+4($16), $pop35
	i32.mul 	$push27=, $11, $3
	i32.store16	$push36=, k+6($16), $pop27
	i32.store16	$17=, res+6($16), $pop36
	i32.mul 	$push31=, $12, $4
	i32.store16	$push37=, k+8($16), $pop31
	i32.store16	$discard=, res+8($16), $pop37
	i32.mul 	$push30=, $13, $5
	i32.store16	$push38=, k+10($16), $pop30
	i32.store16	$discard=, res+10($16), $pop38
	i32.mul 	$push29=, $14, $6
	i32.store16	$push39=, k+12($16), $pop29
	i32.store16	$discard=, res+12($16), $pop39
	i32.mul 	$push28=, $15, $7
	i32.store16	$push40=, k+14($16), $pop28
	i32.store16	$discard=, res+14($16), $pop40
	i32.and 	$push41=, $23, $20
	i32.const	$push42=, 1500
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	$pop43, .LBB1_39
# BB#5:                                 # %verify.exit
	i32.and 	$push44=, $19, $20
	i32.const	$push45=, 1300
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	$pop46, .LBB1_39
# BB#6:                                 # %verify.exit
	i32.and 	$push47=, $18, $20
	i32.const	$push48=, 3000
	i32.ne  	$push49=, $pop47, $pop48
	br_if   	$pop49, .LBB1_39
# BB#7:                                 # %verify.exit
	i32.and 	$push50=, $17, $20
	i32.const	$push51=, 6000
	i32.ne  	$push52=, $pop50, $pop51
	br_if   	$pop52, .LBB1_39
# BB#8:                                 # %verify.exit40
	i32.const	$23=, 16
	block   	.LBB1_38
	i32.shl 	$push56=, $7, $23
	i32.shr_s	$push57=, $pop56, $23
	i32.shl 	$push54=, $15, $23
	i32.shr_s	$push55=, $pop54, $23
	i32.div_s	$19=, $pop57, $pop55
	i32.shl 	$push60=, $6, $23
	i32.shr_s	$push61=, $pop60, $23
	i32.shl 	$push58=, $14, $23
	i32.shr_s	$push59=, $pop58, $23
	i32.div_s	$18=, $pop61, $pop59
	i32.shl 	$push64=, $5, $23
	i32.shr_s	$push65=, $pop64, $23
	i32.shl 	$push62=, $13, $23
	i32.shr_s	$push63=, $pop62, $23
	i32.div_s	$17=, $pop65, $pop63
	i32.shl 	$push68=, $4, $23
	i32.shr_s	$push69=, $pop68, $23
	i32.shl 	$push66=, $12, $23
	i32.shr_s	$push67=, $pop66, $23
	i32.div_s	$24=, $pop69, $pop67
	i32.shl 	$push72=, $3, $23
	i32.shr_s	$push73=, $pop72, $23
	i32.shl 	$push70=, $11, $23
	i32.shr_s	$push71=, $pop70, $23
	i32.div_s	$22=, $pop73, $pop71
	i32.shl 	$push76=, $2, $23
	i32.shr_s	$push77=, $pop76, $23
	i32.shl 	$push74=, $10, $23
	i32.shr_s	$push75=, $pop74, $23
	i32.div_s	$21=, $pop77, $pop75
	i32.shl 	$push80=, $1, $23
	i32.shr_s	$push81=, $pop80, $23
	i32.shl 	$push78=, $9, $23
	i32.shr_s	$push79=, $pop78, $23
	i32.div_s	$push53=, $pop81, $pop79
	i32.store16	$push88=, k+2($16), $pop53
	i32.store16	$25=, res+2($16), $pop88
	i32.store16	$push89=, k+4($16), $21
	i32.store16	$21=, res+4($16), $pop89
	i32.store16	$push90=, k+6($16), $22
	i32.store16	$22=, res+6($16), $pop90
	i32.store16	$push91=, k+8($16), $24
	i32.store16	$discard=, res+8($16), $pop91
	i32.store16	$push92=, k+10($16), $17
	i32.store16	$discard=, res+10($16), $pop92
	i32.store16	$push93=, k+12($16), $18
	i32.store16	$discard=, res+12($16), $pop93
	i32.store16	$push94=, k+14($16), $19
	i32.store16	$discard=, res+14($16), $pop94
	i32.shl 	$push84=, $0, $23
	i32.shr_s	$push85=, $pop84, $23
	i32.shl 	$push82=, $8, $23
	i32.shr_s	$push83=, $pop82, $23
	i32.div_s	$push86=, $pop85, $pop83
	i32.store16	$push87=, k($16), $pop86
	i32.store16	$push95=, res($16), $pop87
	i32.and 	$push96=, $pop95, $20
	i32.const	$push97=, 15
	i32.ne  	$push98=, $pop96, $pop97
	br_if   	$pop98, .LBB1_38
# BB#9:                                 # %verify.exit40
	i32.const	$23=, 7
	i32.and 	$push99=, $25, $20
	i32.ne  	$push100=, $pop99, $23
	br_if   	$pop100, .LBB1_38
# BB#10:                                # %verify.exit40
	i32.and 	$push101=, $21, $20
	i32.ne  	$push102=, $pop101, $23
	br_if   	$pop102, .LBB1_38
# BB#11:                                # %verify.exit40
	i32.and 	$push103=, $22, $20
	i32.const	$push104=, 6
	i32.ne  	$push105=, $pop103, $pop104
	br_if   	$pop105, .LBB1_38
# BB#12:                                # %verify.exit49
	block   	.LBB1_37
	i32.and 	$push113=, $8, $0
	i32.store16	$push114=, k($16), $pop113
	i32.store16	$23=, res($16), $pop114
	i32.and 	$push106=, $9, $1
	i32.store16	$push115=, k+2($16), $pop106
	i32.store16	$19=, res+2($16), $pop115
	i32.and 	$push107=, $10, $2
	i32.store16	$push116=, k+4($16), $pop107
	i32.store16	$18=, res+4($16), $pop116
	i32.and 	$push108=, $11, $3
	i32.store16	$push117=, k+6($16), $pop108
	i32.store16	$17=, res+6($16), $pop117
	i32.and 	$push112=, $12, $4
	i32.store16	$push118=, k+8($16), $pop112
	i32.store16	$discard=, res+8($16), $pop118
	i32.and 	$push111=, $13, $5
	i32.store16	$push119=, k+10($16), $pop111
	i32.store16	$discard=, res+10($16), $pop119
	i32.and 	$push110=, $14, $6
	i32.store16	$push120=, k+12($16), $pop110
	i32.store16	$discard=, res+12($16), $pop120
	i32.and 	$push109=, $15, $7
	i32.store16	$push121=, k+14($16), $pop109
	i32.store16	$discard=, res+14($16), $pop121
	i32.and 	$push122=, $23, $20
	i32.const	$push123=, 2
	i32.ne  	$push124=, $pop122, $pop123
	br_if   	$pop124, .LBB1_37
# BB#13:                                # %verify.exit49
	i32.and 	$push125=, $19, $20
	i32.const	$push126=, 4
	i32.ne  	$push127=, $pop125, $pop126
	br_if   	$pop127, .LBB1_37
# BB#14:                                # %verify.exit49
	i32.and 	$push128=, $18, $20
	i32.const	$push129=, 20
	i32.ne  	$push130=, $pop128, $pop129
	br_if   	$pop130, .LBB1_37
# BB#15:                                # %verify.exit49
	i32.and 	$push131=, $17, $20
	i32.const	$push132=, 8
	i32.ne  	$push133=, $pop131, $pop132
	br_if   	$pop133, .LBB1_37
# BB#16:                                # %verify.exit58
	block   	.LBB1_36
	i32.or  	$push141=, $8, $0
	i32.store16	$push142=, k($16), $pop141
	i32.store16	$23=, res($16), $pop142
	i32.or  	$push134=, $9, $1
	i32.store16	$push143=, k+2($16), $pop134
	i32.store16	$19=, res+2($16), $pop143
	i32.or  	$push135=, $10, $2
	i32.store16	$push144=, k+4($16), $pop135
	i32.store16	$18=, res+4($16), $pop144
	i32.or  	$push136=, $11, $3
	i32.store16	$push145=, k+6($16), $pop136
	i32.store16	$17=, res+6($16), $pop145
	i32.or  	$push140=, $12, $4
	i32.store16	$push146=, k+8($16), $pop140
	i32.store16	$discard=, res+8($16), $pop146
	i32.or  	$push139=, $13, $5
	i32.store16	$push147=, k+10($16), $pop139
	i32.store16	$discard=, res+10($16), $pop147
	i32.or  	$push138=, $14, $6
	i32.store16	$push148=, k+12($16), $pop138
	i32.store16	$discard=, res+12($16), $pop148
	i32.or  	$push137=, $15, $7
	i32.store16	$push149=, k+14($16), $pop137
	i32.store16	$discard=, res+14($16), $pop149
	i32.and 	$push150=, $23, $20
	i32.const	$push151=, 158
	i32.ne  	$push152=, $pop150, $pop151
	br_if   	$pop152, .LBB1_36
# BB#17:                                # %verify.exit58
	i32.and 	$push153=, $19, $20
	i32.const	$push154=, 109
	i32.ne  	$push155=, $pop153, $pop154
	br_if   	$pop155, .LBB1_36
# BB#18:                                # %verify.exit58
	i32.and 	$push156=, $18, $20
	i32.const	$push157=, 150
	i32.ne  	$push158=, $pop156, $pop157
	br_if   	$pop158, .LBB1_36
# BB#19:                                # %verify.exit58
	i32.and 	$push159=, $17, $20
	i32.const	$push160=, 222
	i32.ne  	$push161=, $pop159, $pop160
	br_if   	$pop161, .LBB1_36
# BB#20:                                # %verify.exit67
	block   	.LBB1_35
	i32.xor 	$push169=, $0, $8
	i32.store16	$push170=, k($16), $pop169
	i32.store16	$23=, res($16), $pop170
	i32.xor 	$push162=, $1, $9
	i32.store16	$push171=, k+2($16), $pop162
	i32.store16	$9=, res+2($16), $pop171
	i32.xor 	$push163=, $2, $10
	i32.store16	$push172=, k+4($16), $pop163
	i32.store16	$10=, res+4($16), $pop172
	i32.xor 	$push164=, $3, $11
	i32.store16	$push173=, k+6($16), $pop164
	i32.store16	$11=, res+6($16), $pop173
	i32.xor 	$push168=, $4, $12
	i32.store16	$push174=, k+8($16), $pop168
	i32.store16	$discard=, res+8($16), $pop174
	i32.xor 	$push167=, $5, $13
	i32.store16	$push175=, k+10($16), $pop167
	i32.store16	$discard=, res+10($16), $pop175
	i32.xor 	$push166=, $6, $14
	i32.store16	$push176=, k+12($16), $pop166
	i32.store16	$discard=, res+12($16), $pop176
	i32.xor 	$push165=, $7, $15
	i32.store16	$push177=, k+14($16), $pop165
	i32.store16	$discard=, res+14($16), $pop177
	i32.and 	$push178=, $23, $20
	i32.const	$push179=, 156
	i32.ne  	$push180=, $pop178, $pop179
	br_if   	$pop180, .LBB1_35
# BB#21:                                # %verify.exit67
	i32.and 	$push181=, $9, $20
	i32.const	$push182=, 105
	i32.ne  	$push183=, $pop181, $pop182
	br_if   	$pop183, .LBB1_35
# BB#22:                                # %verify.exit67
	i32.and 	$push184=, $10, $20
	i32.const	$push185=, 130
	i32.ne  	$push186=, $pop184, $pop185
	br_if   	$pop186, .LBB1_35
# BB#23:                                # %verify.exit67
	i32.and 	$push187=, $11, $20
	i32.const	$push188=, 214
	i32.ne  	$push189=, $pop187, $pop188
	br_if   	$pop189, .LBB1_35
# BB#24:                                # %verify.exit76
	i32.sub 	$push197=, $16, $0
	i32.store16	$push198=, k($16), $pop197
	i32.store16	$15=, res($16), $pop198
	i32.sub 	$push190=, $16, $1
	i32.store16	$push199=, k+2($16), $pop190
	i32.store16	$14=, res+2($16), $pop199
	i32.sub 	$push191=, $16, $2
	i32.store16	$push200=, k+4($16), $pop191
	i32.store16	$13=, res+4($16), $pop200
	i32.sub 	$push192=, $16, $3
	i32.store16	$push201=, k+6($16), $pop192
	i32.store16	$12=, res+6($16), $pop201
	i32.sub 	$push196=, $16, $4
	i32.store16	$push202=, k+8($16), $pop196
	i32.store16	$discard=, res+8($16), $pop202
	i32.sub 	$push195=, $16, $5
	i32.store16	$push203=, k+10($16), $pop195
	i32.store16	$discard=, res+10($16), $pop203
	i32.sub 	$push194=, $16, $6
	i32.store16	$push204=, k+12($16), $pop194
	i32.store16	$discard=, res+12($16), $pop204
	i32.sub 	$push193=, $16, $7
	i32.store16	$push205=, k+14($16), $pop193
	i32.store16	$discard=, res+14($16), $pop205
	i32.const	$23=, 65386
	block   	.LBB1_34
	i32.and 	$push206=, $15, $20
	i32.ne  	$push207=, $pop206, $23
	br_if   	$pop207, .LBB1_34
# BB#25:                                # %verify.exit76
	i32.and 	$push208=, $14, $20
	i32.const	$push209=, 65436
	i32.ne  	$push210=, $pop208, $pop209
	br_if   	$pop210, .LBB1_34
# BB#26:                                # %verify.exit76
	i32.and 	$push211=, $13, $20
	i32.ne  	$push212=, $pop211, $23
	br_if   	$pop212, .LBB1_34
# BB#27:                                # %verify.exit76
	i32.and 	$push213=, $12, $20
	i32.const	$push214=, 65336
	i32.ne  	$push215=, $pop213, $pop214
	br_if   	$pop215, .LBB1_34
# BB#28:                                # %verify.exit85
	i32.const	$23=, -1
	i32.xor 	$push223=, $0, $23
	i32.store16	$push224=, k($16), $pop223
	i32.store16	$0=, res($16), $pop224
	i32.xor 	$push216=, $1, $23
	i32.store16	$push225=, k+2($16), $pop216
	i32.store16	$1=, res+2($16), $pop225
	i32.xor 	$push217=, $2, $23
	i32.store16	$push226=, k+4($16), $pop217
	i32.store16	$2=, res+4($16), $pop226
	i32.xor 	$push218=, $3, $23
	i32.store16	$push227=, k+6($16), $pop218
	i32.store16	$3=, res+6($16), $pop227
	i32.xor 	$push222=, $4, $23
	i32.store16	$push228=, k+8($16), $pop222
	i32.store16	$discard=, res+8($16), $pop228
	i32.xor 	$push221=, $5, $23
	i32.store16	$push229=, k+10($16), $pop221
	i32.store16	$discard=, res+10($16), $pop229
	i32.xor 	$push220=, $6, $23
	i32.store16	$push230=, k+12($16), $pop220
	i32.store16	$discard=, res+12($16), $pop230
	i32.xor 	$push219=, $7, $23
	i32.store16	$push231=, k+14($16), $pop219
	i32.store16	$discard=, res+14($16), $pop231
	i32.const	$23=, 65385
	block   	.LBB1_33
	i32.and 	$push232=, $0, $20
	i32.ne  	$push233=, $pop232, $23
	br_if   	$pop233, .LBB1_33
# BB#29:                                # %verify.exit85
	i32.and 	$push234=, $1, $20
	i32.const	$push235=, 65435
	i32.ne  	$push236=, $pop234, $pop235
	br_if   	$pop236, .LBB1_33
# BB#30:                                # %verify.exit85
	i32.and 	$push237=, $2, $20
	i32.ne  	$push238=, $pop237, $23
	br_if   	$pop238, .LBB1_33
# BB#31:                                # %verify.exit85
	i32.and 	$push239=, $3, $20
	i32.const	$push240=, 65335
	i32.ne  	$push241=, $pop239, $pop240
	br_if   	$pop241, .LBB1_33
# BB#32:                                # %verify.exit94
	call    	exit@FUNCTION, $16
	unreachable
.LBB1_33:                               # %if.then.i93
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %if.then.i84
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then.i75
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then.i66
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then.i57
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then.i48
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then.i39
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then.i
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.align	4
i:
	.int16	150                     # 0x96
	.int16	100                     # 0x64
	.int16	150                     # 0x96
	.int16	200                     # 0xc8
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	i, 16

	.hidden	j                       # @j
	.type	j,@object
	.section	.data.j,"aw",@progbits
	.globl	j
	.align	4
j:
	.int16	10                      # 0xa
	.int16	13                      # 0xd
	.int16	20                      # 0x14
	.int16	30                      # 0x1e
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.size	j, 16

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.align	4
k:
	.skip	16
	.size	k, 16

	.hidden	res                     # @res
	.type	res,@object
	.section	.bss.res,"aw",@nobits
	.globl	res
	.align	4
res:
	.skip	16
	.size	res, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
