	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030914-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i64, i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push86=, __stack_pointer
	i32.const	$push83=, __stack_pointer
	i32.load	$push84=, 0($pop83)
	i32.const	$push85=, 512
	i32.sub 	$push214=, $pop84, $pop85
	i32.store	$push248=, 0($pop86), $pop214
	tee_local	$push247=, $5=, $pop248
	i32.const	$push90=, 496
	i32.add 	$push91=, $pop247, $pop90
	i32.load	$push0=, 0($2)
	call    	__floatsitf@FUNCTION, $pop91, $pop0
	i32.const	$push94=, 480
	i32.add 	$push95=, $5, $pop94
	i64.load	$push4=, 496($5)
	i32.const	$push92=, 496
	i32.add 	$push93=, $5, $pop92
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop93, $pop1
	i64.load	$push3=, 0($pop2)
	call    	__addtf3@FUNCTION, $pop95, $pop4, $pop3, $3, $4
	i32.const	$push96=, 480
	i32.add 	$push97=, $5, $pop96
	i32.const	$push246=, 8
	i32.add 	$push5=, $pop97, $pop246
	i64.load	$3=, 0($pop5)
	i64.load	$4=, 480($5)
	i32.const	$push98=, 464
	i32.add 	$push99=, $5, $pop98
	i32.load	$push6=, 4($2)
	call    	__floatsitf@FUNCTION, $pop99, $pop6
	i32.const	$push102=, 448
	i32.add 	$push103=, $5, $pop102
	i64.load	$push9=, 464($5)
	i32.const	$push100=, 464
	i32.add 	$push101=, $5, $pop100
	i32.const	$push245=, 8
	i32.add 	$push7=, $pop101, $pop245
	i64.load	$push8=, 0($pop7)
	call    	__addtf3@FUNCTION, $pop103, $4, $3, $pop9, $pop8
	i32.const	$push104=, 448
	i32.add 	$push105=, $5, $pop104
	i32.const	$push244=, 8
	i32.add 	$push10=, $pop105, $pop244
	i64.load	$3=, 0($pop10)
	i64.load	$4=, 448($5)
	i32.const	$push106=, 432
	i32.add 	$push107=, $5, $pop106
	i32.load	$push11=, 8($2)
	call    	__floatsitf@FUNCTION, $pop107, $pop11
	i32.const	$push110=, 416
	i32.add 	$push111=, $5, $pop110
	i64.load	$push14=, 432($5)
	i32.const	$push108=, 432
	i32.add 	$push109=, $5, $pop108
	i32.const	$push243=, 8
	i32.add 	$push12=, $pop109, $pop243
	i64.load	$push13=, 0($pop12)
	call    	__addtf3@FUNCTION, $pop111, $4, $3, $pop14, $pop13
	i32.const	$push112=, 416
	i32.add 	$push113=, $5, $pop112
	i32.const	$push242=, 8
	i32.add 	$push15=, $pop113, $pop242
	i64.load	$3=, 0($pop15)
	i64.load	$4=, 416($5)
	i32.const	$push114=, 400
	i32.add 	$push115=, $5, $pop114
	i32.load	$push16=, 12($2)
	call    	__floatsitf@FUNCTION, $pop115, $pop16
	i32.const	$push118=, 384
	i32.add 	$push119=, $5, $pop118
	i64.load	$push19=, 400($5)
	i32.const	$push116=, 400
	i32.add 	$push117=, $5, $pop116
	i32.const	$push241=, 8
	i32.add 	$push17=, $pop117, $pop241
	i64.load	$push18=, 0($pop17)
	call    	__addtf3@FUNCTION, $pop119, $4, $3, $pop19, $pop18
	i32.const	$push120=, 384
	i32.add 	$push121=, $5, $pop120
	i32.const	$push240=, 8
	i32.add 	$push20=, $pop121, $pop240
	i64.load	$3=, 0($pop20)
	i64.load	$4=, 384($5)
	i32.const	$push122=, 368
	i32.add 	$push123=, $5, $pop122
	i32.load	$push21=, 16($2)
	call    	__floatsitf@FUNCTION, $pop123, $pop21
	i32.const	$push126=, 352
	i32.add 	$push127=, $5, $pop126
	i64.load	$push24=, 368($5)
	i32.const	$push124=, 368
	i32.add 	$push125=, $5, $pop124
	i32.const	$push239=, 8
	i32.add 	$push22=, $pop125, $pop239
	i64.load	$push23=, 0($pop22)
	call    	__addtf3@FUNCTION, $pop127, $4, $3, $pop24, $pop23
	i32.const	$push128=, 352
	i32.add 	$push129=, $5, $pop128
	i32.const	$push238=, 8
	i32.add 	$push25=, $pop129, $pop238
	i64.load	$3=, 0($pop25)
	i64.load	$4=, 352($5)
	i32.const	$push130=, 336
	i32.add 	$push131=, $5, $pop130
	i32.load	$push26=, 20($2)
	call    	__floatsitf@FUNCTION, $pop131, $pop26
	i32.const	$push134=, 320
	i32.add 	$push135=, $5, $pop134
	i64.load	$push29=, 336($5)
	i32.const	$push132=, 336
	i32.add 	$push133=, $5, $pop132
	i32.const	$push237=, 8
	i32.add 	$push27=, $pop133, $pop237
	i64.load	$push28=, 0($pop27)
	call    	__addtf3@FUNCTION, $pop135, $4, $3, $pop29, $pop28
	i32.const	$push136=, 320
	i32.add 	$push137=, $5, $pop136
	i32.const	$push236=, 8
	i32.add 	$push30=, $pop137, $pop236
	i64.load	$3=, 0($pop30)
	i64.load	$4=, 320($5)
	i32.const	$push138=, 304
	i32.add 	$push139=, $5, $pop138
	i32.load	$push31=, 24($2)
	call    	__floatsitf@FUNCTION, $pop139, $pop31
	i32.const	$push142=, 288
	i32.add 	$push143=, $5, $pop142
	i64.load	$push34=, 304($5)
	i32.const	$push140=, 304
	i32.add 	$push141=, $5, $pop140
	i32.const	$push235=, 8
	i32.add 	$push32=, $pop141, $pop235
	i64.load	$push33=, 0($pop32)
	call    	__addtf3@FUNCTION, $pop143, $4, $3, $pop34, $pop33
	i32.const	$push144=, 288
	i32.add 	$push145=, $5, $pop144
	i32.const	$push234=, 8
	i32.add 	$push35=, $pop145, $pop234
	i64.load	$3=, 0($pop35)
	i64.load	$4=, 288($5)
	i32.const	$push146=, 272
	i32.add 	$push147=, $5, $pop146
	i32.load	$push36=, 28($2)
	call    	__floatsitf@FUNCTION, $pop147, $pop36
	i32.const	$push150=, 256
	i32.add 	$push151=, $5, $pop150
	i64.load	$push39=, 272($5)
	i32.const	$push148=, 272
	i32.add 	$push149=, $5, $pop148
	i32.const	$push233=, 8
	i32.add 	$push37=, $pop149, $pop233
	i64.load	$push38=, 0($pop37)
	call    	__addtf3@FUNCTION, $pop151, $4, $3, $pop39, $pop38
	i32.const	$push152=, 256
	i32.add 	$push153=, $5, $pop152
	i32.const	$push232=, 8
	i32.add 	$push40=, $pop153, $pop232
	i64.load	$3=, 0($pop40)
	i64.load	$4=, 256($5)
	i32.const	$push154=, 240
	i32.add 	$push155=, $5, $pop154
	i32.load	$push41=, 32($2)
	call    	__floatsitf@FUNCTION, $pop155, $pop41
	i32.const	$push158=, 224
	i32.add 	$push159=, $5, $pop158
	i64.load	$push44=, 240($5)
	i32.const	$push156=, 240
	i32.add 	$push157=, $5, $pop156
	i32.const	$push231=, 8
	i32.add 	$push42=, $pop157, $pop231
	i64.load	$push43=, 0($pop42)
	call    	__addtf3@FUNCTION, $pop159, $4, $3, $pop44, $pop43
	i32.const	$push160=, 224
	i32.add 	$push161=, $5, $pop160
	i32.const	$push230=, 8
	i32.add 	$push45=, $pop161, $pop230
	i64.load	$3=, 0($pop45)
	i64.load	$4=, 224($5)
	i32.const	$push162=, 208
	i32.add 	$push163=, $5, $pop162
	i32.load	$push46=, 36($2)
	call    	__floatsitf@FUNCTION, $pop163, $pop46
	i32.const	$push166=, 192
	i32.add 	$push167=, $5, $pop166
	i64.load	$push49=, 208($5)
	i32.const	$push164=, 208
	i32.add 	$push165=, $5, $pop164
	i32.const	$push229=, 8
	i32.add 	$push47=, $pop165, $pop229
	i64.load	$push48=, 0($pop47)
	call    	__addtf3@FUNCTION, $pop167, $4, $3, $pop49, $pop48
	i32.const	$push168=, 192
	i32.add 	$push169=, $5, $pop168
	i32.const	$push228=, 8
	i32.add 	$push50=, $pop169, $pop228
	i64.load	$3=, 0($pop50)
	i64.load	$4=, 192($5)
	i32.const	$push170=, 176
	i32.add 	$push171=, $5, $pop170
	i32.load	$push51=, 40($2)
	call    	__floatsitf@FUNCTION, $pop171, $pop51
	i32.const	$push174=, 160
	i32.add 	$push175=, $5, $pop174
	i64.load	$push54=, 176($5)
	i32.const	$push172=, 176
	i32.add 	$push173=, $5, $pop172
	i32.const	$push227=, 8
	i32.add 	$push52=, $pop173, $pop227
	i64.load	$push53=, 0($pop52)
	call    	__addtf3@FUNCTION, $pop175, $4, $3, $pop54, $pop53
	i32.const	$push176=, 160
	i32.add 	$push177=, $5, $pop176
	i32.const	$push226=, 8
	i32.add 	$push55=, $pop177, $pop226
	i64.load	$3=, 0($pop55)
	i64.load	$4=, 160($5)
	i32.const	$push178=, 144
	i32.add 	$push179=, $5, $pop178
	i32.load	$push56=, 44($2)
	call    	__floatsitf@FUNCTION, $pop179, $pop56
	i32.const	$push182=, 128
	i32.add 	$push183=, $5, $pop182
	i64.load	$push59=, 144($5)
	i32.const	$push180=, 144
	i32.add 	$push181=, $5, $pop180
	i32.const	$push225=, 8
	i32.add 	$push57=, $pop181, $pop225
	i64.load	$push58=, 0($pop57)
	call    	__addtf3@FUNCTION, $pop183, $4, $3, $pop59, $pop58
	i32.const	$push184=, 128
	i32.add 	$push185=, $5, $pop184
	i32.const	$push224=, 8
	i32.add 	$push60=, $pop185, $pop224
	i64.load	$3=, 0($pop60)
	i64.load	$4=, 128($5)
	i32.const	$push186=, 112
	i32.add 	$push187=, $5, $pop186
	i32.load	$push61=, 48($2)
	call    	__floatsitf@FUNCTION, $pop187, $pop61
	i32.const	$push190=, 96
	i32.add 	$push191=, $5, $pop190
	i64.load	$push64=, 112($5)
	i32.const	$push188=, 112
	i32.add 	$push189=, $5, $pop188
	i32.const	$push223=, 8
	i32.add 	$push62=, $pop189, $pop223
	i64.load	$push63=, 0($pop62)
	call    	__addtf3@FUNCTION, $pop191, $4, $3, $pop64, $pop63
	i32.const	$push192=, 96
	i32.add 	$push193=, $5, $pop192
	i32.const	$push222=, 8
	i32.add 	$push65=, $pop193, $pop222
	i64.load	$3=, 0($pop65)
	i64.load	$4=, 96($5)
	i32.const	$push194=, 80
	i32.add 	$push195=, $5, $pop194
	i32.load	$push66=, 52($2)
	call    	__floatsitf@FUNCTION, $pop195, $pop66
	i32.const	$push198=, 64
	i32.add 	$push199=, $5, $pop198
	i64.load	$push69=, 80($5)
	i32.const	$push196=, 80
	i32.add 	$push197=, $5, $pop196
	i32.const	$push221=, 8
	i32.add 	$push67=, $pop197, $pop221
	i64.load	$push68=, 0($pop67)
	call    	__addtf3@FUNCTION, $pop199, $4, $3, $pop69, $pop68
	i32.const	$push200=, 64
	i32.add 	$push201=, $5, $pop200
	i32.const	$push220=, 8
	i32.add 	$push70=, $pop201, $pop220
	i64.load	$3=, 0($pop70)
	i64.load	$4=, 64($5)
	i32.const	$push202=, 48
	i32.add 	$push203=, $5, $pop202
	i32.load	$push71=, 56($2)
	call    	__floatsitf@FUNCTION, $pop203, $pop71
	i32.const	$push206=, 32
	i32.add 	$push207=, $5, $pop206
	i64.load	$push74=, 48($5)
	i32.const	$push204=, 48
	i32.add 	$push205=, $5, $pop204
	i32.const	$push219=, 8
	i32.add 	$push72=, $pop205, $pop219
	i64.load	$push73=, 0($pop72)
	call    	__addtf3@FUNCTION, $pop207, $4, $3, $pop74, $pop73
	i32.const	$push208=, 32
	i32.add 	$push209=, $5, $pop208
	i32.const	$push218=, 8
	i32.add 	$push75=, $pop209, $pop218
	i64.load	$3=, 0($pop75)
	i64.load	$4=, 32($5)
	i32.const	$push210=, 16
	i32.add 	$push211=, $5, $pop210
	i32.load	$push76=, 60($2)
	call    	__floatsitf@FUNCTION, $pop211, $pop76
	i64.load	$push79=, 16($5)
	i32.const	$push212=, 16
	i32.add 	$push213=, $5, $pop212
	i32.const	$push217=, 8
	i32.add 	$push77=, $pop213, $pop217
	i64.load	$push78=, 0($pop77)
	call    	__addtf3@FUNCTION, $5, $4, $3, $pop79, $pop78
	i64.load	$3=, 0($5)
	i32.const	$push216=, 8
	i32.add 	$push82=, $0, $pop216
	i32.const	$push215=, 8
	i32.add 	$push80=, $5, $pop215
	i64.load	$push81=, 0($pop80)
	i64.store	$drop=, 0($pop82), $pop81
	i64.store	$drop=, 0($0), $3
	i32.const	$push89=, __stack_pointer
	i32.const	$push87=, 512
	i32.add 	$push88=, $5, $pop87
	i32.store	$drop=, 0($pop89), $pop88
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
