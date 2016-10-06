	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030914-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i64, i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push117=, 0
	i32.const	$push114=, 0
	i32.load	$push115=, __stack_pointer($pop114)
	i32.const	$push116=, 512
	i32.sub 	$push278=, $pop115, $pop116
	tee_local	$push277=, $5=, $pop278
	i32.store	__stack_pointer($pop117), $pop277
	i32.const	$push121=, 496
	i32.add 	$push122=, $5, $pop121
	i32.load	$push0=, 0($2)
	call    	__floatsitf@FUNCTION, $pop122, $pop0
	i32.const	$push125=, 480
	i32.add 	$push126=, $5, $pop125
	i64.load	$push4=, 496($5)
	i32.const	$push123=, 496
	i32.add 	$push124=, $5, $pop123
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop124, $pop1
	i64.load	$push3=, 0($pop2)
	call    	__addtf3@FUNCTION, $pop126, $pop4, $pop3, $3, $4
	i32.const	$push127=, 464
	i32.add 	$push128=, $5, $pop127
	i32.load	$push5=, 4($2)
	call    	__floatsitf@FUNCTION, $pop128, $pop5
	i32.const	$push133=, 448
	i32.add 	$push134=, $5, $pop133
	i64.load	$push11=, 480($5)
	i32.const	$push131=, 480
	i32.add 	$push132=, $5, $pop131
	i32.const	$push276=, 8
	i32.add 	$push8=, $pop132, $pop276
	i64.load	$push9=, 0($pop8)
	i64.load	$push10=, 464($5)
	i32.const	$push129=, 464
	i32.add 	$push130=, $5, $pop129
	i32.const	$push275=, 8
	i32.add 	$push6=, $pop130, $pop275
	i64.load	$push7=, 0($pop6)
	call    	__addtf3@FUNCTION, $pop134, $pop11, $pop9, $pop10, $pop7
	i32.const	$push135=, 432
	i32.add 	$push136=, $5, $pop135
	i32.load	$push12=, 8($2)
	call    	__floatsitf@FUNCTION, $pop136, $pop12
	i32.const	$push141=, 416
	i32.add 	$push142=, $5, $pop141
	i64.load	$push18=, 448($5)
	i32.const	$push139=, 448
	i32.add 	$push140=, $5, $pop139
	i32.const	$push274=, 8
	i32.add 	$push15=, $pop140, $pop274
	i64.load	$push16=, 0($pop15)
	i64.load	$push17=, 432($5)
	i32.const	$push137=, 432
	i32.add 	$push138=, $5, $pop137
	i32.const	$push273=, 8
	i32.add 	$push13=, $pop138, $pop273
	i64.load	$push14=, 0($pop13)
	call    	__addtf3@FUNCTION, $pop142, $pop18, $pop16, $pop17, $pop14
	i32.const	$push143=, 400
	i32.add 	$push144=, $5, $pop143
	i32.load	$push19=, 12($2)
	call    	__floatsitf@FUNCTION, $pop144, $pop19
	i32.const	$push149=, 384
	i32.add 	$push150=, $5, $pop149
	i64.load	$push25=, 416($5)
	i32.const	$push147=, 416
	i32.add 	$push148=, $5, $pop147
	i32.const	$push272=, 8
	i32.add 	$push22=, $pop148, $pop272
	i64.load	$push23=, 0($pop22)
	i64.load	$push24=, 400($5)
	i32.const	$push145=, 400
	i32.add 	$push146=, $5, $pop145
	i32.const	$push271=, 8
	i32.add 	$push20=, $pop146, $pop271
	i64.load	$push21=, 0($pop20)
	call    	__addtf3@FUNCTION, $pop150, $pop25, $pop23, $pop24, $pop21
	i32.const	$push151=, 368
	i32.add 	$push152=, $5, $pop151
	i32.load	$push26=, 16($2)
	call    	__floatsitf@FUNCTION, $pop152, $pop26
	i32.const	$push157=, 352
	i32.add 	$push158=, $5, $pop157
	i64.load	$push32=, 384($5)
	i32.const	$push155=, 384
	i32.add 	$push156=, $5, $pop155
	i32.const	$push270=, 8
	i32.add 	$push29=, $pop156, $pop270
	i64.load	$push30=, 0($pop29)
	i64.load	$push31=, 368($5)
	i32.const	$push153=, 368
	i32.add 	$push154=, $5, $pop153
	i32.const	$push269=, 8
	i32.add 	$push27=, $pop154, $pop269
	i64.load	$push28=, 0($pop27)
	call    	__addtf3@FUNCTION, $pop158, $pop32, $pop30, $pop31, $pop28
	i32.const	$push159=, 336
	i32.add 	$push160=, $5, $pop159
	i32.load	$push33=, 20($2)
	call    	__floatsitf@FUNCTION, $pop160, $pop33
	i32.const	$push165=, 320
	i32.add 	$push166=, $5, $pop165
	i64.load	$push39=, 352($5)
	i32.const	$push163=, 352
	i32.add 	$push164=, $5, $pop163
	i32.const	$push268=, 8
	i32.add 	$push36=, $pop164, $pop268
	i64.load	$push37=, 0($pop36)
	i64.load	$push38=, 336($5)
	i32.const	$push161=, 336
	i32.add 	$push162=, $5, $pop161
	i32.const	$push267=, 8
	i32.add 	$push34=, $pop162, $pop267
	i64.load	$push35=, 0($pop34)
	call    	__addtf3@FUNCTION, $pop166, $pop39, $pop37, $pop38, $pop35
	i32.const	$push167=, 304
	i32.add 	$push168=, $5, $pop167
	i32.load	$push40=, 24($2)
	call    	__floatsitf@FUNCTION, $pop168, $pop40
	i32.const	$push173=, 288
	i32.add 	$push174=, $5, $pop173
	i64.load	$push46=, 320($5)
	i32.const	$push171=, 320
	i32.add 	$push172=, $5, $pop171
	i32.const	$push266=, 8
	i32.add 	$push43=, $pop172, $pop266
	i64.load	$push44=, 0($pop43)
	i64.load	$push45=, 304($5)
	i32.const	$push169=, 304
	i32.add 	$push170=, $5, $pop169
	i32.const	$push265=, 8
	i32.add 	$push41=, $pop170, $pop265
	i64.load	$push42=, 0($pop41)
	call    	__addtf3@FUNCTION, $pop174, $pop46, $pop44, $pop45, $pop42
	i32.const	$push175=, 272
	i32.add 	$push176=, $5, $pop175
	i32.load	$push47=, 28($2)
	call    	__floatsitf@FUNCTION, $pop176, $pop47
	i32.const	$push181=, 256
	i32.add 	$push182=, $5, $pop181
	i64.load	$push53=, 288($5)
	i32.const	$push179=, 288
	i32.add 	$push180=, $5, $pop179
	i32.const	$push264=, 8
	i32.add 	$push50=, $pop180, $pop264
	i64.load	$push51=, 0($pop50)
	i64.load	$push52=, 272($5)
	i32.const	$push177=, 272
	i32.add 	$push178=, $5, $pop177
	i32.const	$push263=, 8
	i32.add 	$push48=, $pop178, $pop263
	i64.load	$push49=, 0($pop48)
	call    	__addtf3@FUNCTION, $pop182, $pop53, $pop51, $pop52, $pop49
	i32.const	$push183=, 240
	i32.add 	$push184=, $5, $pop183
	i32.load	$push54=, 32($2)
	call    	__floatsitf@FUNCTION, $pop184, $pop54
	i32.const	$push189=, 224
	i32.add 	$push190=, $5, $pop189
	i64.load	$push60=, 256($5)
	i32.const	$push187=, 256
	i32.add 	$push188=, $5, $pop187
	i32.const	$push262=, 8
	i32.add 	$push57=, $pop188, $pop262
	i64.load	$push58=, 0($pop57)
	i64.load	$push59=, 240($5)
	i32.const	$push185=, 240
	i32.add 	$push186=, $5, $pop185
	i32.const	$push261=, 8
	i32.add 	$push55=, $pop186, $pop261
	i64.load	$push56=, 0($pop55)
	call    	__addtf3@FUNCTION, $pop190, $pop60, $pop58, $pop59, $pop56
	i32.const	$push191=, 208
	i32.add 	$push192=, $5, $pop191
	i32.load	$push61=, 36($2)
	call    	__floatsitf@FUNCTION, $pop192, $pop61
	i32.const	$push197=, 192
	i32.add 	$push198=, $5, $pop197
	i64.load	$push67=, 224($5)
	i32.const	$push195=, 224
	i32.add 	$push196=, $5, $pop195
	i32.const	$push260=, 8
	i32.add 	$push64=, $pop196, $pop260
	i64.load	$push65=, 0($pop64)
	i64.load	$push66=, 208($5)
	i32.const	$push193=, 208
	i32.add 	$push194=, $5, $pop193
	i32.const	$push259=, 8
	i32.add 	$push62=, $pop194, $pop259
	i64.load	$push63=, 0($pop62)
	call    	__addtf3@FUNCTION, $pop198, $pop67, $pop65, $pop66, $pop63
	i32.const	$push199=, 176
	i32.add 	$push200=, $5, $pop199
	i32.load	$push68=, 40($2)
	call    	__floatsitf@FUNCTION, $pop200, $pop68
	i32.const	$push205=, 160
	i32.add 	$push206=, $5, $pop205
	i64.load	$push74=, 192($5)
	i32.const	$push203=, 192
	i32.add 	$push204=, $5, $pop203
	i32.const	$push258=, 8
	i32.add 	$push71=, $pop204, $pop258
	i64.load	$push72=, 0($pop71)
	i64.load	$push73=, 176($5)
	i32.const	$push201=, 176
	i32.add 	$push202=, $5, $pop201
	i32.const	$push257=, 8
	i32.add 	$push69=, $pop202, $pop257
	i64.load	$push70=, 0($pop69)
	call    	__addtf3@FUNCTION, $pop206, $pop74, $pop72, $pop73, $pop70
	i32.const	$push207=, 144
	i32.add 	$push208=, $5, $pop207
	i32.load	$push75=, 44($2)
	call    	__floatsitf@FUNCTION, $pop208, $pop75
	i32.const	$push213=, 128
	i32.add 	$push214=, $5, $pop213
	i64.load	$push81=, 160($5)
	i32.const	$push211=, 160
	i32.add 	$push212=, $5, $pop211
	i32.const	$push256=, 8
	i32.add 	$push78=, $pop212, $pop256
	i64.load	$push79=, 0($pop78)
	i64.load	$push80=, 144($5)
	i32.const	$push209=, 144
	i32.add 	$push210=, $5, $pop209
	i32.const	$push255=, 8
	i32.add 	$push76=, $pop210, $pop255
	i64.load	$push77=, 0($pop76)
	call    	__addtf3@FUNCTION, $pop214, $pop81, $pop79, $pop80, $pop77
	i32.const	$push215=, 112
	i32.add 	$push216=, $5, $pop215
	i32.load	$push82=, 48($2)
	call    	__floatsitf@FUNCTION, $pop216, $pop82
	i32.const	$push221=, 96
	i32.add 	$push222=, $5, $pop221
	i64.load	$push88=, 128($5)
	i32.const	$push219=, 128
	i32.add 	$push220=, $5, $pop219
	i32.const	$push254=, 8
	i32.add 	$push85=, $pop220, $pop254
	i64.load	$push86=, 0($pop85)
	i64.load	$push87=, 112($5)
	i32.const	$push217=, 112
	i32.add 	$push218=, $5, $pop217
	i32.const	$push253=, 8
	i32.add 	$push83=, $pop218, $pop253
	i64.load	$push84=, 0($pop83)
	call    	__addtf3@FUNCTION, $pop222, $pop88, $pop86, $pop87, $pop84
	i32.const	$push223=, 80
	i32.add 	$push224=, $5, $pop223
	i32.load	$push89=, 52($2)
	call    	__floatsitf@FUNCTION, $pop224, $pop89
	i32.const	$push229=, 64
	i32.add 	$push230=, $5, $pop229
	i64.load	$push95=, 96($5)
	i32.const	$push227=, 96
	i32.add 	$push228=, $5, $pop227
	i32.const	$push252=, 8
	i32.add 	$push92=, $pop228, $pop252
	i64.load	$push93=, 0($pop92)
	i64.load	$push94=, 80($5)
	i32.const	$push225=, 80
	i32.add 	$push226=, $5, $pop225
	i32.const	$push251=, 8
	i32.add 	$push90=, $pop226, $pop251
	i64.load	$push91=, 0($pop90)
	call    	__addtf3@FUNCTION, $pop230, $pop95, $pop93, $pop94, $pop91
	i32.const	$push231=, 48
	i32.add 	$push232=, $5, $pop231
	i32.load	$push96=, 56($2)
	call    	__floatsitf@FUNCTION, $pop232, $pop96
	i32.const	$push237=, 32
	i32.add 	$push238=, $5, $pop237
	i64.load	$push102=, 64($5)
	i32.const	$push235=, 64
	i32.add 	$push236=, $5, $pop235
	i32.const	$push250=, 8
	i32.add 	$push99=, $pop236, $pop250
	i64.load	$push100=, 0($pop99)
	i64.load	$push101=, 48($5)
	i32.const	$push233=, 48
	i32.add 	$push234=, $5, $pop233
	i32.const	$push249=, 8
	i32.add 	$push97=, $pop234, $pop249
	i64.load	$push98=, 0($pop97)
	call    	__addtf3@FUNCTION, $pop238, $pop102, $pop100, $pop101, $pop98
	i32.const	$push239=, 16
	i32.add 	$push240=, $5, $pop239
	i32.load	$push103=, 60($2)
	call    	__floatsitf@FUNCTION, $pop240, $pop103
	i64.load	$push109=, 32($5)
	i32.const	$push243=, 32
	i32.add 	$push244=, $5, $pop243
	i32.const	$push248=, 8
	i32.add 	$push106=, $pop244, $pop248
	i64.load	$push107=, 0($pop106)
	i64.load	$push108=, 16($5)
	i32.const	$push241=, 16
	i32.add 	$push242=, $5, $pop241
	i32.const	$push247=, 8
	i32.add 	$push104=, $pop242, $pop247
	i64.load	$push105=, 0($pop104)
	call    	__addtf3@FUNCTION, $5, $pop109, $pop107, $pop108, $pop105
	i32.const	$push246=, 8
	i32.add 	$push110=, $0, $pop246
	i32.const	$push245=, 8
	i32.add 	$push111=, $5, $pop245
	i64.load	$push112=, 0($pop111)
	i64.store	0($pop110), $pop112
	i64.load	$push113=, 0($5)
	i64.store	0($0), $pop113
	i32.const	$push120=, 0
	i32.const	$push118=, 512
	i32.add 	$push119=, $5, $pop118
	i32.store	__stack_pointer($pop120), $pop119
                                        # fallthrough-return
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
