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
	i32.const	$push115=, __stack_pointer
	i32.load	$push116=, 0($pop115)
	i32.const	$push117=, 512
	i32.sub 	$5=, $pop116, $pop117
	i32.const	$push118=, __stack_pointer
	i32.store	$discard=, 0($pop118), $5
	i32.const	$push122=, 496
	i32.add 	$push123=, $5, $pop122
	i32.load	$push0=, 0($2)
	call    	__floatsitf@FUNCTION, $pop123, $pop0
	i32.const	$push126=, 480
	i32.add 	$push127=, $5, $pop126
	i64.load	$push4=, 496($5)
	i32.const	$push124=, 496
	i32.add 	$push125=, $5, $pop124
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop125, $pop1
	i64.load	$push3=, 0($pop2)
	call    	__addtf3@FUNCTION, $pop127, $pop4, $pop3, $3, $4
	i32.const	$push128=, 480
	i32.add 	$push129=, $5, $pop128
	i32.const	$push114=, 8
	i32.add 	$push5=, $pop129, $pop114
	i64.load	$4=, 0($pop5)
	i64.load	$3=, 480($5)
	i32.const	$push130=, 464
	i32.add 	$push131=, $5, $pop130
	i32.load	$push6=, 4($2)
	call    	__floatsitf@FUNCTION, $pop131, $pop6
	i32.const	$push134=, 448
	i32.add 	$push135=, $5, $pop134
	i64.load	$push9=, 464($5)
	i32.const	$push132=, 464
	i32.add 	$push133=, $5, $pop132
	i32.const	$push113=, 8
	i32.add 	$push7=, $pop133, $pop113
	i64.load	$push8=, 0($pop7)
	call    	__addtf3@FUNCTION, $pop135, $3, $4, $pop9, $pop8
	i32.const	$push136=, 448
	i32.add 	$push137=, $5, $pop136
	i32.const	$push112=, 8
	i32.add 	$push10=, $pop137, $pop112
	i64.load	$4=, 0($pop10)
	i64.load	$3=, 448($5)
	i32.const	$push138=, 432
	i32.add 	$push139=, $5, $pop138
	i32.load	$push11=, 8($2)
	call    	__floatsitf@FUNCTION, $pop139, $pop11
	i32.const	$push142=, 416
	i32.add 	$push143=, $5, $pop142
	i64.load	$push14=, 432($5)
	i32.const	$push140=, 432
	i32.add 	$push141=, $5, $pop140
	i32.const	$push111=, 8
	i32.add 	$push12=, $pop141, $pop111
	i64.load	$push13=, 0($pop12)
	call    	__addtf3@FUNCTION, $pop143, $3, $4, $pop14, $pop13
	i32.const	$push144=, 416
	i32.add 	$push145=, $5, $pop144
	i32.const	$push110=, 8
	i32.add 	$push15=, $pop145, $pop110
	i64.load	$4=, 0($pop15)
	i64.load	$3=, 416($5)
	i32.const	$push146=, 400
	i32.add 	$push147=, $5, $pop146
	i32.load	$push16=, 12($2)
	call    	__floatsitf@FUNCTION, $pop147, $pop16
	i32.const	$push150=, 384
	i32.add 	$push151=, $5, $pop150
	i64.load	$push19=, 400($5)
	i32.const	$push148=, 400
	i32.add 	$push149=, $5, $pop148
	i32.const	$push109=, 8
	i32.add 	$push17=, $pop149, $pop109
	i64.load	$push18=, 0($pop17)
	call    	__addtf3@FUNCTION, $pop151, $3, $4, $pop19, $pop18
	i32.const	$push152=, 384
	i32.add 	$push153=, $5, $pop152
	i32.const	$push108=, 8
	i32.add 	$push20=, $pop153, $pop108
	i64.load	$4=, 0($pop20)
	i64.load	$3=, 384($5)
	i32.const	$push154=, 368
	i32.add 	$push155=, $5, $pop154
	i32.load	$push21=, 16($2)
	call    	__floatsitf@FUNCTION, $pop155, $pop21
	i32.const	$push158=, 352
	i32.add 	$push159=, $5, $pop158
	i64.load	$push24=, 368($5)
	i32.const	$push156=, 368
	i32.add 	$push157=, $5, $pop156
	i32.const	$push107=, 8
	i32.add 	$push22=, $pop157, $pop107
	i64.load	$push23=, 0($pop22)
	call    	__addtf3@FUNCTION, $pop159, $3, $4, $pop24, $pop23
	i32.const	$push160=, 352
	i32.add 	$push161=, $5, $pop160
	i32.const	$push106=, 8
	i32.add 	$push25=, $pop161, $pop106
	i64.load	$4=, 0($pop25)
	i64.load	$3=, 352($5)
	i32.const	$push162=, 336
	i32.add 	$push163=, $5, $pop162
	i32.load	$push26=, 20($2)
	call    	__floatsitf@FUNCTION, $pop163, $pop26
	i32.const	$push166=, 320
	i32.add 	$push167=, $5, $pop166
	i64.load	$push29=, 336($5)
	i32.const	$push164=, 336
	i32.add 	$push165=, $5, $pop164
	i32.const	$push105=, 8
	i32.add 	$push27=, $pop165, $pop105
	i64.load	$push28=, 0($pop27)
	call    	__addtf3@FUNCTION, $pop167, $3, $4, $pop29, $pop28
	i32.const	$push168=, 320
	i32.add 	$push169=, $5, $pop168
	i32.const	$push104=, 8
	i32.add 	$push30=, $pop169, $pop104
	i64.load	$4=, 0($pop30)
	i64.load	$3=, 320($5)
	i32.const	$push170=, 304
	i32.add 	$push171=, $5, $pop170
	i32.load	$push31=, 24($2)
	call    	__floatsitf@FUNCTION, $pop171, $pop31
	i32.const	$push174=, 288
	i32.add 	$push175=, $5, $pop174
	i64.load	$push34=, 304($5)
	i32.const	$push172=, 304
	i32.add 	$push173=, $5, $pop172
	i32.const	$push103=, 8
	i32.add 	$push32=, $pop173, $pop103
	i64.load	$push33=, 0($pop32)
	call    	__addtf3@FUNCTION, $pop175, $3, $4, $pop34, $pop33
	i32.const	$push176=, 288
	i32.add 	$push177=, $5, $pop176
	i32.const	$push102=, 8
	i32.add 	$push35=, $pop177, $pop102
	i64.load	$4=, 0($pop35)
	i64.load	$3=, 288($5)
	i32.const	$push178=, 272
	i32.add 	$push179=, $5, $pop178
	i32.load	$push36=, 28($2)
	call    	__floatsitf@FUNCTION, $pop179, $pop36
	i32.const	$push182=, 256
	i32.add 	$push183=, $5, $pop182
	i64.load	$push39=, 272($5)
	i32.const	$push180=, 272
	i32.add 	$push181=, $5, $pop180
	i32.const	$push101=, 8
	i32.add 	$push37=, $pop181, $pop101
	i64.load	$push38=, 0($pop37)
	call    	__addtf3@FUNCTION, $pop183, $3, $4, $pop39, $pop38
	i32.const	$push184=, 256
	i32.add 	$push185=, $5, $pop184
	i32.const	$push100=, 8
	i32.add 	$push40=, $pop185, $pop100
	i64.load	$4=, 0($pop40)
	i64.load	$3=, 256($5)
	i32.const	$push186=, 240
	i32.add 	$push187=, $5, $pop186
	i32.load	$push41=, 32($2)
	call    	__floatsitf@FUNCTION, $pop187, $pop41
	i32.const	$push190=, 224
	i32.add 	$push191=, $5, $pop190
	i64.load	$push44=, 240($5)
	i32.const	$push188=, 240
	i32.add 	$push189=, $5, $pop188
	i32.const	$push99=, 8
	i32.add 	$push42=, $pop189, $pop99
	i64.load	$push43=, 0($pop42)
	call    	__addtf3@FUNCTION, $pop191, $3, $4, $pop44, $pop43
	i32.const	$push192=, 224
	i32.add 	$push193=, $5, $pop192
	i32.const	$push98=, 8
	i32.add 	$push45=, $pop193, $pop98
	i64.load	$4=, 0($pop45)
	i64.load	$3=, 224($5)
	i32.const	$push194=, 208
	i32.add 	$push195=, $5, $pop194
	i32.load	$push46=, 36($2)
	call    	__floatsitf@FUNCTION, $pop195, $pop46
	i32.const	$push198=, 192
	i32.add 	$push199=, $5, $pop198
	i64.load	$push49=, 208($5)
	i32.const	$push196=, 208
	i32.add 	$push197=, $5, $pop196
	i32.const	$push97=, 8
	i32.add 	$push47=, $pop197, $pop97
	i64.load	$push48=, 0($pop47)
	call    	__addtf3@FUNCTION, $pop199, $3, $4, $pop49, $pop48
	i32.const	$push200=, 192
	i32.add 	$push201=, $5, $pop200
	i32.const	$push96=, 8
	i32.add 	$push50=, $pop201, $pop96
	i64.load	$4=, 0($pop50)
	i64.load	$3=, 192($5)
	i32.const	$push202=, 176
	i32.add 	$push203=, $5, $pop202
	i32.load	$push51=, 40($2)
	call    	__floatsitf@FUNCTION, $pop203, $pop51
	i32.const	$push206=, 160
	i32.add 	$push207=, $5, $pop206
	i64.load	$push54=, 176($5)
	i32.const	$push204=, 176
	i32.add 	$push205=, $5, $pop204
	i32.const	$push95=, 8
	i32.add 	$push52=, $pop205, $pop95
	i64.load	$push53=, 0($pop52)
	call    	__addtf3@FUNCTION, $pop207, $3, $4, $pop54, $pop53
	i32.const	$push208=, 160
	i32.add 	$push209=, $5, $pop208
	i32.const	$push94=, 8
	i32.add 	$push55=, $pop209, $pop94
	i64.load	$4=, 0($pop55)
	i64.load	$3=, 160($5)
	i32.const	$push210=, 144
	i32.add 	$push211=, $5, $pop210
	i32.load	$push56=, 44($2)
	call    	__floatsitf@FUNCTION, $pop211, $pop56
	i32.const	$push214=, 128
	i32.add 	$push215=, $5, $pop214
	i64.load	$push59=, 144($5)
	i32.const	$push212=, 144
	i32.add 	$push213=, $5, $pop212
	i32.const	$push93=, 8
	i32.add 	$push57=, $pop213, $pop93
	i64.load	$push58=, 0($pop57)
	call    	__addtf3@FUNCTION, $pop215, $3, $4, $pop59, $pop58
	i32.const	$push216=, 128
	i32.add 	$push217=, $5, $pop216
	i32.const	$push92=, 8
	i32.add 	$push60=, $pop217, $pop92
	i64.load	$4=, 0($pop60)
	i64.load	$3=, 128($5)
	i32.const	$push218=, 112
	i32.add 	$push219=, $5, $pop218
	i32.load	$push61=, 48($2)
	call    	__floatsitf@FUNCTION, $pop219, $pop61
	i32.const	$push222=, 96
	i32.add 	$push223=, $5, $pop222
	i64.load	$push64=, 112($5)
	i32.const	$push220=, 112
	i32.add 	$push221=, $5, $pop220
	i32.const	$push91=, 8
	i32.add 	$push62=, $pop221, $pop91
	i64.load	$push63=, 0($pop62)
	call    	__addtf3@FUNCTION, $pop223, $3, $4, $pop64, $pop63
	i32.const	$push224=, 96
	i32.add 	$push225=, $5, $pop224
	i32.const	$push90=, 8
	i32.add 	$push65=, $pop225, $pop90
	i64.load	$4=, 0($pop65)
	i64.load	$3=, 96($5)
	i32.const	$push226=, 80
	i32.add 	$push227=, $5, $pop226
	i32.load	$push66=, 52($2)
	call    	__floatsitf@FUNCTION, $pop227, $pop66
	i32.const	$push230=, 64
	i32.add 	$push231=, $5, $pop230
	i64.load	$push69=, 80($5)
	i32.const	$push228=, 80
	i32.add 	$push229=, $5, $pop228
	i32.const	$push89=, 8
	i32.add 	$push67=, $pop229, $pop89
	i64.load	$push68=, 0($pop67)
	call    	__addtf3@FUNCTION, $pop231, $3, $4, $pop69, $pop68
	i32.const	$push232=, 64
	i32.add 	$push233=, $5, $pop232
	i32.const	$push88=, 8
	i32.add 	$push70=, $pop233, $pop88
	i64.load	$4=, 0($pop70)
	i64.load	$3=, 64($5)
	i32.const	$push234=, 48
	i32.add 	$push235=, $5, $pop234
	i32.load	$push71=, 56($2)
	call    	__floatsitf@FUNCTION, $pop235, $pop71
	i32.const	$push238=, 32
	i32.add 	$push239=, $5, $pop238
	i64.load	$push74=, 48($5)
	i32.const	$push236=, 48
	i32.add 	$push237=, $5, $pop236
	i32.const	$push87=, 8
	i32.add 	$push72=, $pop237, $pop87
	i64.load	$push73=, 0($pop72)
	call    	__addtf3@FUNCTION, $pop239, $3, $4, $pop74, $pop73
	i32.const	$push240=, 32
	i32.add 	$push241=, $5, $pop240
	i32.const	$push86=, 8
	i32.add 	$push75=, $pop241, $pop86
	i64.load	$4=, 0($pop75)
	i64.load	$3=, 32($5)
	i32.const	$push242=, 16
	i32.add 	$push243=, $5, $pop242
	i32.load	$push76=, 60($2)
	call    	__floatsitf@FUNCTION, $pop243, $pop76
	i64.load	$push79=, 16($5)
	i32.const	$push244=, 16
	i32.add 	$push245=, $5, $pop244
	i32.const	$push85=, 8
	i32.add 	$push77=, $pop245, $pop85
	i64.load	$push78=, 0($pop77)
	call    	__addtf3@FUNCTION, $5, $3, $4, $pop79, $pop78
	i64.load	$4=, 0($5)
	i32.const	$push84=, 8
	i32.add 	$push82=, $0, $pop84
	i32.const	$push83=, 8
	i32.add 	$push80=, $5, $pop83
	i64.load	$push81=, 0($pop80)
	i64.store	$discard=, 0($pop82), $pop81
	i64.store	$discard=, 0($0), $4
	i32.const	$push121=, __stack_pointer
	i32.const	$push119=, 512
	i32.add 	$push120=, $5, $pop119
	i32.store	$discard=, 0($pop121), $pop120
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
