	.text
	.file	"20030914-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i64, i64
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push114=, 0
	i32.load	$push113=, __stack_pointer($pop114)
	i32.const	$push115=, 512
	i32.sub 	$5=, $pop113, $pop115
	i32.const	$push116=, 0
	i32.store	__stack_pointer($pop116), $5
	i32.const	$push120=, 496
	i32.add 	$push121=, $5, $pop120
	i32.load	$push0=, 0($2)
	call    	__floatsitf@FUNCTION, $pop121, $pop0
	i32.const	$push124=, 480
	i32.add 	$push125=, $5, $pop124
	i64.load	$push4=, 496($5)
	i32.const	$push122=, 496
	i32.add 	$push123=, $5, $pop122
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop123, $pop1
	i64.load	$push3=, 0($pop2)
	call    	__addtf3@FUNCTION, $pop125, $pop4, $pop3, $3, $4
	i32.const	$push126=, 464
	i32.add 	$push127=, $5, $pop126
	i32.load	$push5=, 4($2)
	call    	__floatsitf@FUNCTION, $pop127, $pop5
	i32.const	$push132=, 448
	i32.add 	$push133=, $5, $pop132
	i64.load	$push11=, 480($5)
	i32.const	$push130=, 480
	i32.add 	$push131=, $5, $pop130
	i32.const	$push274=, 8
	i32.add 	$push8=, $pop131, $pop274
	i64.load	$push9=, 0($pop8)
	i64.load	$push10=, 464($5)
	i32.const	$push128=, 464
	i32.add 	$push129=, $5, $pop128
	i32.const	$push273=, 8
	i32.add 	$push6=, $pop129, $pop273
	i64.load	$push7=, 0($pop6)
	call    	__addtf3@FUNCTION, $pop133, $pop11, $pop9, $pop10, $pop7
	i32.const	$push134=, 432
	i32.add 	$push135=, $5, $pop134
	i32.load	$push12=, 8($2)
	call    	__floatsitf@FUNCTION, $pop135, $pop12
	i32.const	$push140=, 416
	i32.add 	$push141=, $5, $pop140
	i64.load	$push18=, 448($5)
	i32.const	$push138=, 448
	i32.add 	$push139=, $5, $pop138
	i32.const	$push272=, 8
	i32.add 	$push15=, $pop139, $pop272
	i64.load	$push16=, 0($pop15)
	i64.load	$push17=, 432($5)
	i32.const	$push136=, 432
	i32.add 	$push137=, $5, $pop136
	i32.const	$push271=, 8
	i32.add 	$push13=, $pop137, $pop271
	i64.load	$push14=, 0($pop13)
	call    	__addtf3@FUNCTION, $pop141, $pop18, $pop16, $pop17, $pop14
	i32.const	$push142=, 400
	i32.add 	$push143=, $5, $pop142
	i32.load	$push19=, 12($2)
	call    	__floatsitf@FUNCTION, $pop143, $pop19
	i32.const	$push148=, 384
	i32.add 	$push149=, $5, $pop148
	i64.load	$push25=, 416($5)
	i32.const	$push146=, 416
	i32.add 	$push147=, $5, $pop146
	i32.const	$push270=, 8
	i32.add 	$push22=, $pop147, $pop270
	i64.load	$push23=, 0($pop22)
	i64.load	$push24=, 400($5)
	i32.const	$push144=, 400
	i32.add 	$push145=, $5, $pop144
	i32.const	$push269=, 8
	i32.add 	$push20=, $pop145, $pop269
	i64.load	$push21=, 0($pop20)
	call    	__addtf3@FUNCTION, $pop149, $pop25, $pop23, $pop24, $pop21
	i32.const	$push150=, 368
	i32.add 	$push151=, $5, $pop150
	i32.load	$push26=, 16($2)
	call    	__floatsitf@FUNCTION, $pop151, $pop26
	i32.const	$push156=, 352
	i32.add 	$push157=, $5, $pop156
	i64.load	$push32=, 384($5)
	i32.const	$push154=, 384
	i32.add 	$push155=, $5, $pop154
	i32.const	$push268=, 8
	i32.add 	$push29=, $pop155, $pop268
	i64.load	$push30=, 0($pop29)
	i64.load	$push31=, 368($5)
	i32.const	$push152=, 368
	i32.add 	$push153=, $5, $pop152
	i32.const	$push267=, 8
	i32.add 	$push27=, $pop153, $pop267
	i64.load	$push28=, 0($pop27)
	call    	__addtf3@FUNCTION, $pop157, $pop32, $pop30, $pop31, $pop28
	i32.const	$push158=, 336
	i32.add 	$push159=, $5, $pop158
	i32.load	$push33=, 20($2)
	call    	__floatsitf@FUNCTION, $pop159, $pop33
	i32.const	$push164=, 320
	i32.add 	$push165=, $5, $pop164
	i64.load	$push39=, 352($5)
	i32.const	$push162=, 352
	i32.add 	$push163=, $5, $pop162
	i32.const	$push266=, 8
	i32.add 	$push36=, $pop163, $pop266
	i64.load	$push37=, 0($pop36)
	i64.load	$push38=, 336($5)
	i32.const	$push160=, 336
	i32.add 	$push161=, $5, $pop160
	i32.const	$push265=, 8
	i32.add 	$push34=, $pop161, $pop265
	i64.load	$push35=, 0($pop34)
	call    	__addtf3@FUNCTION, $pop165, $pop39, $pop37, $pop38, $pop35
	i32.const	$push166=, 304
	i32.add 	$push167=, $5, $pop166
	i32.load	$push40=, 24($2)
	call    	__floatsitf@FUNCTION, $pop167, $pop40
	i32.const	$push172=, 288
	i32.add 	$push173=, $5, $pop172
	i64.load	$push46=, 320($5)
	i32.const	$push170=, 320
	i32.add 	$push171=, $5, $pop170
	i32.const	$push264=, 8
	i32.add 	$push43=, $pop171, $pop264
	i64.load	$push44=, 0($pop43)
	i64.load	$push45=, 304($5)
	i32.const	$push168=, 304
	i32.add 	$push169=, $5, $pop168
	i32.const	$push263=, 8
	i32.add 	$push41=, $pop169, $pop263
	i64.load	$push42=, 0($pop41)
	call    	__addtf3@FUNCTION, $pop173, $pop46, $pop44, $pop45, $pop42
	i32.const	$push174=, 272
	i32.add 	$push175=, $5, $pop174
	i32.load	$push47=, 28($2)
	call    	__floatsitf@FUNCTION, $pop175, $pop47
	i32.const	$push180=, 256
	i32.add 	$push181=, $5, $pop180
	i64.load	$push53=, 288($5)
	i32.const	$push178=, 288
	i32.add 	$push179=, $5, $pop178
	i32.const	$push262=, 8
	i32.add 	$push50=, $pop179, $pop262
	i64.load	$push51=, 0($pop50)
	i64.load	$push52=, 272($5)
	i32.const	$push176=, 272
	i32.add 	$push177=, $5, $pop176
	i32.const	$push261=, 8
	i32.add 	$push48=, $pop177, $pop261
	i64.load	$push49=, 0($pop48)
	call    	__addtf3@FUNCTION, $pop181, $pop53, $pop51, $pop52, $pop49
	i32.const	$push182=, 240
	i32.add 	$push183=, $5, $pop182
	i32.load	$push54=, 32($2)
	call    	__floatsitf@FUNCTION, $pop183, $pop54
	i32.const	$push188=, 224
	i32.add 	$push189=, $5, $pop188
	i64.load	$push60=, 256($5)
	i32.const	$push186=, 256
	i32.add 	$push187=, $5, $pop186
	i32.const	$push260=, 8
	i32.add 	$push57=, $pop187, $pop260
	i64.load	$push58=, 0($pop57)
	i64.load	$push59=, 240($5)
	i32.const	$push184=, 240
	i32.add 	$push185=, $5, $pop184
	i32.const	$push259=, 8
	i32.add 	$push55=, $pop185, $pop259
	i64.load	$push56=, 0($pop55)
	call    	__addtf3@FUNCTION, $pop189, $pop60, $pop58, $pop59, $pop56
	i32.const	$push190=, 208
	i32.add 	$push191=, $5, $pop190
	i32.load	$push61=, 36($2)
	call    	__floatsitf@FUNCTION, $pop191, $pop61
	i32.const	$push196=, 192
	i32.add 	$push197=, $5, $pop196
	i64.load	$push67=, 224($5)
	i32.const	$push194=, 224
	i32.add 	$push195=, $5, $pop194
	i32.const	$push258=, 8
	i32.add 	$push64=, $pop195, $pop258
	i64.load	$push65=, 0($pop64)
	i64.load	$push66=, 208($5)
	i32.const	$push192=, 208
	i32.add 	$push193=, $5, $pop192
	i32.const	$push257=, 8
	i32.add 	$push62=, $pop193, $pop257
	i64.load	$push63=, 0($pop62)
	call    	__addtf3@FUNCTION, $pop197, $pop67, $pop65, $pop66, $pop63
	i32.const	$push198=, 176
	i32.add 	$push199=, $5, $pop198
	i32.load	$push68=, 40($2)
	call    	__floatsitf@FUNCTION, $pop199, $pop68
	i32.const	$push204=, 160
	i32.add 	$push205=, $5, $pop204
	i64.load	$push74=, 192($5)
	i32.const	$push202=, 192
	i32.add 	$push203=, $5, $pop202
	i32.const	$push256=, 8
	i32.add 	$push71=, $pop203, $pop256
	i64.load	$push72=, 0($pop71)
	i64.load	$push73=, 176($5)
	i32.const	$push200=, 176
	i32.add 	$push201=, $5, $pop200
	i32.const	$push255=, 8
	i32.add 	$push69=, $pop201, $pop255
	i64.load	$push70=, 0($pop69)
	call    	__addtf3@FUNCTION, $pop205, $pop74, $pop72, $pop73, $pop70
	i32.const	$push206=, 144
	i32.add 	$push207=, $5, $pop206
	i32.load	$push75=, 44($2)
	call    	__floatsitf@FUNCTION, $pop207, $pop75
	i32.const	$push212=, 128
	i32.add 	$push213=, $5, $pop212
	i64.load	$push81=, 160($5)
	i32.const	$push210=, 160
	i32.add 	$push211=, $5, $pop210
	i32.const	$push254=, 8
	i32.add 	$push78=, $pop211, $pop254
	i64.load	$push79=, 0($pop78)
	i64.load	$push80=, 144($5)
	i32.const	$push208=, 144
	i32.add 	$push209=, $5, $pop208
	i32.const	$push253=, 8
	i32.add 	$push76=, $pop209, $pop253
	i64.load	$push77=, 0($pop76)
	call    	__addtf3@FUNCTION, $pop213, $pop81, $pop79, $pop80, $pop77
	i32.const	$push214=, 112
	i32.add 	$push215=, $5, $pop214
	i32.load	$push82=, 48($2)
	call    	__floatsitf@FUNCTION, $pop215, $pop82
	i32.const	$push220=, 96
	i32.add 	$push221=, $5, $pop220
	i64.load	$push88=, 128($5)
	i32.const	$push218=, 128
	i32.add 	$push219=, $5, $pop218
	i32.const	$push252=, 8
	i32.add 	$push85=, $pop219, $pop252
	i64.load	$push86=, 0($pop85)
	i64.load	$push87=, 112($5)
	i32.const	$push216=, 112
	i32.add 	$push217=, $5, $pop216
	i32.const	$push251=, 8
	i32.add 	$push83=, $pop217, $pop251
	i64.load	$push84=, 0($pop83)
	call    	__addtf3@FUNCTION, $pop221, $pop88, $pop86, $pop87, $pop84
	i32.const	$push222=, 80
	i32.add 	$push223=, $5, $pop222
	i32.load	$push89=, 52($2)
	call    	__floatsitf@FUNCTION, $pop223, $pop89
	i32.const	$push228=, 64
	i32.add 	$push229=, $5, $pop228
	i64.load	$push95=, 96($5)
	i32.const	$push226=, 96
	i32.add 	$push227=, $5, $pop226
	i32.const	$push250=, 8
	i32.add 	$push92=, $pop227, $pop250
	i64.load	$push93=, 0($pop92)
	i64.load	$push94=, 80($5)
	i32.const	$push224=, 80
	i32.add 	$push225=, $5, $pop224
	i32.const	$push249=, 8
	i32.add 	$push90=, $pop225, $pop249
	i64.load	$push91=, 0($pop90)
	call    	__addtf3@FUNCTION, $pop229, $pop95, $pop93, $pop94, $pop91
	i32.const	$push230=, 48
	i32.add 	$push231=, $5, $pop230
	i32.load	$push96=, 56($2)
	call    	__floatsitf@FUNCTION, $pop231, $pop96
	i32.const	$push236=, 32
	i32.add 	$push237=, $5, $pop236
	i64.load	$push102=, 64($5)
	i32.const	$push234=, 64
	i32.add 	$push235=, $5, $pop234
	i32.const	$push248=, 8
	i32.add 	$push99=, $pop235, $pop248
	i64.load	$push100=, 0($pop99)
	i64.load	$push101=, 48($5)
	i32.const	$push232=, 48
	i32.add 	$push233=, $5, $pop232
	i32.const	$push247=, 8
	i32.add 	$push97=, $pop233, $pop247
	i64.load	$push98=, 0($pop97)
	call    	__addtf3@FUNCTION, $pop237, $pop102, $pop100, $pop101, $pop98
	i32.const	$push238=, 16
	i32.add 	$push239=, $5, $pop238
	i32.load	$push103=, 60($2)
	call    	__floatsitf@FUNCTION, $pop239, $pop103
	i64.load	$push109=, 32($5)
	i32.const	$push242=, 32
	i32.add 	$push243=, $5, $pop242
	i32.const	$push246=, 8
	i32.add 	$push106=, $pop243, $pop246
	i64.load	$push107=, 0($pop106)
	i64.load	$push108=, 16($5)
	i32.const	$push240=, 16
	i32.add 	$push241=, $5, $pop240
	i32.const	$push245=, 8
	i32.add 	$push104=, $pop241, $pop245
	i64.load	$push105=, 0($pop104)
	call    	__addtf3@FUNCTION, $5, $pop109, $pop107, $pop108, $pop105
	i32.const	$push244=, 8
	i32.add 	$push110=, $5, $pop244
	i64.load	$push111=, 0($pop110)
	i64.store	8($0), $pop111
	i64.load	$push112=, 0($5)
	i64.store	0($0), $pop112
	i32.const	$push119=, 0
	i32.const	$push117=, 512
	i32.add 	$push118=, $5, $pop117
	i32.store	__stack_pointer($pop119), $pop118
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push37=, 0
	i32.load	$push36=, __stack_pointer($pop37)
	i32.const	$push38=, 144
	i32.sub 	$0=, $pop36, $pop38
	i32.const	$push39=, 0
	i32.store	__stack_pointer($pop39), $0
	i32.const	$push0=, 3
	i32.store	88($0), $pop0
	i64.const	$push1=, 21474836484
	i64.store	92($0):p2align=2, $pop1
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i64.load	$push4=, 88($0)
	i64.store	0($pop3), $pop4
	i64.const	$push5=, 30064771078
	i64.store	100($0):p2align=2, $pop5
	i32.const	$push6=, 16
	i32.store	140($0), $pop6
	i32.const	$push44=, 16
	i32.add 	$push7=, $0, $pop44
	i64.load	$push8=, 96($0)
	i64.store	0($pop7), $pop8
	i64.const	$push9=, 38654705672
	i64.store	108($0):p2align=2, $pop9
	i32.const	$push10=, 24
	i32.add 	$push11=, $0, $pop10
	i64.load	$push12=, 104($0)
	i64.store	0($pop11), $pop12
	i64.const	$push13=, 47244640266
	i64.store	116($0):p2align=2, $pop13
	i32.const	$push14=, 32
	i32.add 	$push15=, $0, $pop14
	i64.load	$push16=, 112($0)
	i64.store	0($pop15), $pop16
	i64.const	$push17=, 55834574860
	i64.store	124($0):p2align=2, $pop17
	i32.const	$push18=, 40
	i32.add 	$push19=, $0, $pop18
	i64.load	$push20=, 120($0)
	i64.store	0($pop19), $pop20
	i64.const	$push21=, 64424509454
	i64.store	132($0):p2align=2, $pop21
	i32.const	$push22=, 56
	i32.add 	$push23=, $0, $pop22
	i64.load	$push24=, 136($0)
	i64.store	0($pop23), $pop24
	i32.const	$push25=, 48
	i32.add 	$push26=, $0, $pop25
	i64.load	$push27=, 128($0)
	i64.store	0($pop26), $pop27
	i64.const	$push28=, 8589934593
	i64.store	80($0), $pop28
	i64.const	$push43=, 8589934593
	i64.store	0($0), $pop43
	i32.const	$push40=, 64
	i32.add 	$push41=, $0, $pop40
	i64.const	$push30=, 0
	i64.const	$push29=, 4615125840554885120
	call    	f@FUNCTION, $pop41, $0, $0, $pop30, $pop29
	block   	
	i64.load	$push33=, 64($0)
	i64.load	$push32=, 72($0)
	i64.const	$push42=, 0
	i64.const	$push31=, 4615130513479303168
	i32.call	$push34=, __eqtf2@FUNCTION, $pop33, $pop32, $pop42, $pop31
	i32.eqz 	$push45=, $pop34
	br_if   	0, $pop45       # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
