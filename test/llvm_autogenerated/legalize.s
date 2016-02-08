	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/legalize.ll"
	.globl	shl_i3
	.type	shl_i3,@function
shl_i3:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 7
	i32.and 	$push1=, $1, $pop0
	i32.shl 	$push2=, $0, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	shl_i3, .Lfunc_end0-shl_i3

	.globl	shl_i53
	.type	shl_i53,@function
shl_i53:
	.param  	i64, i64, i32
	.result 	i64
	i64.const	$push0=, 9007199254740991
	i64.and 	$push1=, $1, $pop0
	i64.shl 	$push2=, $0, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	shl_i53, .Lfunc_end1-shl_i53

	.globl	sext_in_reg_i32_i64
	.type	sext_in_reg_i32_i64,@function
sext_in_reg_i32_i64:
	.param  	i64
	.result 	i64
	i64.const	$push0=, 32
	i64.shl 	$push1=, $0, $pop0
	i64.const	$push3=, 32
	i64.shr_s	$push2=, $pop1, $pop3
	return  	$pop2
	.endfunc
.Lfunc_end2:
	.size	sext_in_reg_i32_i64, .Lfunc_end2-sext_in_reg_i32_i64

	.globl	fpext_f32_f64
	.type	fpext_f32_f64,@function
fpext_f32_f64:
	.param  	i32
	.result 	f64
	f32.load	$push0=, 0($0)
	f64.promote/f32	$push1=, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end3:
	.size	fpext_f32_f64, .Lfunc_end3-fpext_f32_f64

	.globl	fpconv_f64_f32
	.type	fpconv_f64_f32,@function
fpconv_f64_f32:
	.param  	i32
	.result 	f32
	f64.load	$push0=, 0($0)
	f32.demote/f64	$push1=, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end4:
	.size	fpconv_f64_f32, .Lfunc_end4-fpconv_f64_f32

	.globl	bigshift
	.type	bigshift,@function
bigshift:
	.param  	i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	i32.const	$183=, __stack_pointer
	i32.load	$183=, 0($183)
	i32.const	$184=, 1024
	i32.sub 	$312=, $183, $184
	i32.const	$184=, __stack_pointer
	i32.store	$312=, 0($184), $312
	i64.const	$push0=, 896
	i64.sub 	$push1=, $pop0, $17
	i32.const	$186=, 480
	i32.add 	$186=, $312, $186
	call    	__lshrti3@FUNCTION, $186, $1, $2, $pop1
	i64.const	$push2=, -768
	i64.add 	$push3=, $17, $pop2
	tee_local	$push553=, $182=, $pop3
	i32.const	$187=, 464
	i32.add 	$187=, $312, $187
	call    	__ashlti3@FUNCTION, $187, $3, $4, $pop553
	i64.const	$push4=, -896
	i64.add 	$push5=, $17, $pop4
	i32.const	$188=, 496
	i32.add 	$188=, $312, $188
	call    	__ashlti3@FUNCTION, $188, $1, $2, $pop5
	i64.const	$push6=, 640
	i64.sub 	$push7=, $pop6, $17
	tee_local	$push552=, $181=, $pop7
	i32.const	$189=, 352
	i32.add 	$189=, $312, $189
	call    	__lshrti3@FUNCTION, $189, $5, $6, $pop552
	i64.const	$push8=, -512
	i64.add 	$push9=, $17, $pop8
	tee_local	$push551=, $180=, $pop9
	i32.const	$190=, 336
	i32.add 	$190=, $312, $190
	call    	__ashlti3@FUNCTION, $190, $7, $8, $pop551
	i64.const	$push10=, -640
	i64.add 	$push11=, $17, $pop10
	tee_local	$push550=, $179=, $pop11
	i32.const	$191=, 368
	i32.add 	$191=, $312, $191
	call    	__ashlti3@FUNCTION, $191, $5, $6, $pop550
	i64.const	$push12=, 768
	i64.sub 	$push13=, $pop12, $17
	tee_local	$push549=, $178=, $pop13
	i32.const	$192=, 432
	i32.add 	$192=, $312, $192
	call    	__lshrti3@FUNCTION, $192, $3, $4, $pop549
	i64.const	$push14=, 384
	i64.sub 	$push15=, $pop14, $17
	tee_local	$push548=, $177=, $pop15
	i32.const	$193=, 864
	i32.add 	$193=, $312, $193
	call    	__lshrti3@FUNCTION, $193, $9, $10, $pop548
	i64.const	$push16=, -256
	i64.add 	$push17=, $17, $pop16
	tee_local	$push547=, $176=, $pop17
	i32.const	$194=, 848
	i32.add 	$194=, $312, $194
	call    	__ashlti3@FUNCTION, $194, $11, $12, $pop547
	i64.const	$push18=, -384
	i64.add 	$push19=, $17, $pop18
	tee_local	$push546=, $175=, $pop19
	i32.const	$195=, 880
	i32.add 	$195=, $312, $195
	call    	__ashlti3@FUNCTION, $195, $9, $10, $pop546
	i32.const	$196=, 1008
	i32.add 	$196=, $312, $196
	call    	__ashlti3@FUNCTION, $196, $15, $16, $17
	i64.const	$push20=, 128
	i64.sub 	$push21=, $pop20, $17
	tee_local	$push545=, $174=, $pop21
	i32.const	$197=, 960
	i32.add 	$197=, $312, $197
	call    	__lshrti3@FUNCTION, $197, $13, $14, $pop545
	i64.const	$push22=, -128
	i64.add 	$push23=, $17, $pop22
	tee_local	$push544=, $173=, $pop23
	i32.const	$198=, 976
	i32.add 	$198=, $312, $198
	call    	__ashlti3@FUNCTION, $198, $13, $14, $pop544
	i64.const	$push24=, 256
	i64.sub 	$push25=, $pop24, $17
	tee_local	$push543=, $172=, $pop25
	i32.const	$199=, 816
	i32.add 	$199=, $312, $199
	call    	__lshrti3@FUNCTION, $199, $11, $12, $pop543
	i64.const	$push26=, 512
	i64.sub 	$push27=, $pop26, $17
	tee_local	$push542=, $171=, $pop27
	i32.const	$200=, 240
	i32.add 	$200=, $312, $200
	call    	__lshrti3@FUNCTION, $200, $7, $8, $pop542
	i32.const	$201=, 912
	i32.add 	$201=, $312, $201
	call    	__ashlti3@FUNCTION, $201, $11, $12, $17
	i32.const	$202=, 928
	i32.add 	$202=, $312, $202
	call    	__lshrti3@FUNCTION, $202, $9, $10, $174
	i32.const	$203=, 944
	i32.add 	$203=, $312, $203
	call    	__ashlti3@FUNCTION, $203, $9, $10, $173
	i64.const	$push541=, 256
	i64.sub 	$push28=, $pop541, $171
	tee_local	$push540=, $170=, $pop28
	i32.const	$204=, 80
	i32.add 	$204=, $312, $204
	call    	__ashlti3@FUNCTION, $204, $7, $8, $pop540
	i64.const	$push539=, 128
	i64.sub 	$push29=, $pop539, $170
	i32.const	$205=, 96
	i32.add 	$205=, $312, $205
	call    	__lshrti3@FUNCTION, $205, $5, $6, $pop29
	i64.const	$push538=, 128
	i64.sub 	$push30=, $pop538, $171
	tee_local	$push537=, $169=, $pop30
	i32.const	$206=, 112
	i32.add 	$206=, $312, $206
	call    	__ashlti3@FUNCTION, $206, $5, $6, $pop537
	i32.const	$207=, 48
	i32.add 	$207=, $312, $207
	call    	__lshrti3@FUNCTION, $207, $3, $4, $171
	i32.const	$208=, 176
	i32.add 	$208=, $312, $208
	call    	__lshrti3@FUNCTION, $208, $7, $8, $172
	i32.const	$209=, 288
	i32.add 	$209=, $312, $209
	call    	__lshrti3@FUNCTION, $209, $1, $2, $181
	i32.const	$210=, 272
	i32.add 	$210=, $312, $210
	call    	__ashlti3@FUNCTION, $210, $3, $4, $180
	i32.const	$211=, 304
	i32.add 	$211=, $312, $211
	call    	__ashlti3@FUNCTION, $211, $1, $2, $179
	i32.const	$212=, 128
	i32.add 	$212=, $312, $212
	call    	__lshrti3@FUNCTION, $212, $5, $6, $172
	i64.const	$push536=, 384
	i64.sub 	$push31=, $pop536, $171
	i32.const	$213=, 144
	i32.add 	$213=, $312, $213
	call    	__ashlti3@FUNCTION, $213, $7, $8, $pop31
	i32.const	$214=, 160
	i32.add 	$214=, $312, $214
	call    	__lshrti3@FUNCTION, $214, $7, $8, $174
	call    	__lshrti3@FUNCTION, $312, $1, $2, $171
	i32.const	$215=, 16
	i32.add 	$215=, $312, $215
	call    	__ashlti3@FUNCTION, $215, $3, $4, $169
	i32.const	$216=, 32
	i32.add 	$216=, $312, $216
	call    	__lshrti3@FUNCTION, $216, $3, $4, $177
	i32.const	$217=, 64
	i32.add 	$217=, $312, $217
	call    	__ashlti3@FUNCTION, $217, $5, $6, $170
	i32.const	$218=, 896
	i32.add 	$218=, $312, $218
	call    	__ashlti3@FUNCTION, $218, $9, $10, $17
	i32.const	$219=, 256
	i32.add 	$219=, $312, $219
	call    	__ashlti3@FUNCTION, $219, $1, $2, $180
	i32.const	$220=, 192
	i32.add 	$220=, $312, $220
	call    	__lshrti3@FUNCTION, $220, $5, $6, $171
	i32.const	$221=, 208
	i32.add 	$221=, $312, $221
	call    	__ashlti3@FUNCTION, $221, $7, $8, $169
	i32.const	$222=, 224
	i32.add 	$222=, $312, $222
	call    	__lshrti3@FUNCTION, $222, $7, $8, $177
	i32.const	$223=, 768
	i32.add 	$223=, $312, $223
	call    	__lshrti3@FUNCTION, $223, $9, $10, $172
	i64.const	$push535=, 128
	i64.sub 	$push32=, $pop535, $172
	tee_local	$push534=, $169=, $pop32
	i32.const	$224=, 784
	i32.add 	$224=, $312, $224
	call    	__ashlti3@FUNCTION, $224, $11, $12, $pop534
	i32.const	$225=, 800
	i32.add 	$225=, $312, $225
	call    	__lshrti3@FUNCTION, $225, $11, $12, $174
	i32.const	$226=, 992
	i32.add 	$226=, $312, $226
	call    	__ashlti3@FUNCTION, $226, $13, $14, $17
	i32.const	$227=, 832
	i32.add 	$227=, $312, $227
	call    	__ashlti3@FUNCTION, $227, $9, $10, $176
	i32.const	$228=, 384
	i32.add 	$228=, $312, $228
	call    	__lshrti3@FUNCTION, $228, $1, $2, $178
	i64.const	$push533=, 128
	i64.sub 	$push33=, $pop533, $178
	i32.const	$229=, 400
	i32.add 	$229=, $312, $229
	call    	__ashlti3@FUNCTION, $229, $3, $4, $pop33
	i32.const	$230=, 416
	i32.add 	$230=, $312, $230
	call    	__lshrti3@FUNCTION, $230, $3, $4, $181
	i32.const	$231=, 320
	i32.add 	$231=, $312, $231
	call    	__ashlti3@FUNCTION, $231, $5, $6, $180
	i32.const	$232=, 448
	i32.add 	$232=, $312, $232
	call    	__ashlti3@FUNCTION, $232, $1, $2, $182
	i32.const	$233=, 736
	i32.add 	$233=, $312, $233
	call    	__lshrti3@FUNCTION, $233, $1, $2, $177
	i32.const	$234=, 720
	i32.add 	$234=, $312, $234
	call    	__ashlti3@FUNCTION, $234, $3, $4, $176
	i32.const	$235=, 752
	i32.add 	$235=, $312, $235
	call    	__ashlti3@FUNCTION, $235, $1, $2, $175
	i32.const	$236=, 592
	i32.add 	$236=, $312, $236
	call    	__ashlti3@FUNCTION, $236, $7, $8, $17
	i32.const	$237=, 608
	i32.add 	$237=, $312, $237
	call    	__lshrti3@FUNCTION, $237, $5, $6, $174
	i32.const	$238=, 624
	i32.add 	$238=, $312, $238
	call    	__ashlti3@FUNCTION, $238, $5, $6, $173
	i32.const	$239=, 688
	i32.add 	$239=, $312, $239
	call    	__lshrti3@FUNCTION, $239, $3, $4, $172
	i32.const	$240=, 640
	i32.add 	$240=, $312, $240
	call    	__lshrti3@FUNCTION, $240, $1, $2, $172
	i32.const	$241=, 656
	i32.add 	$241=, $312, $241
	call    	__ashlti3@FUNCTION, $241, $3, $4, $169
	i32.const	$242=, 672
	i32.add 	$242=, $312, $242
	call    	__lshrti3@FUNCTION, $242, $3, $4, $174
	i32.const	$243=, 576
	i32.add 	$243=, $312, $243
	call    	__ashlti3@FUNCTION, $243, $5, $6, $17
	i32.const	$244=, 704
	i32.add 	$244=, $312, $244
	call    	__ashlti3@FUNCTION, $244, $1, $2, $176
	i32.const	$245=, 528
	i32.add 	$245=, $312, $245
	call    	__ashlti3@FUNCTION, $245, $3, $4, $17
	i32.const	$246=, 544
	i32.add 	$246=, $312, $246
	call    	__lshrti3@FUNCTION, $246, $1, $2, $174
	i32.const	$247=, 560
	i32.add 	$247=, $312, $247
	call    	__ashlti3@FUNCTION, $247, $1, $2, $173
	i32.const	$248=, 512
	i32.add 	$248=, $312, $248
	call    	__ashlti3@FUNCTION, $248, $1, $2, $17
	i32.const	$push75=, 8
	i32.const	$249=, 480
	i32.add 	$249=, $312, $249
	i32.add 	$push76=, $249, $pop75
	i64.load	$174=, 0($pop76)
	i32.const	$push532=, 8
	i32.const	$250=, 464
	i32.add 	$250=, $312, $250
	i32.add 	$push77=, $250, $pop532
	i64.load	$177=, 0($pop77)
	i64.load	$173=, 480($312)
	i64.load	$181=, 464($312)
	i64.load	$169=, 496($312)
	i32.const	$push531=, 8
	i32.const	$251=, 496
	i32.add 	$251=, $312, $251
	i32.add 	$push79=, $251, $pop531
	i64.load	$179=, 0($pop79)
	i32.const	$push530=, 8
	i32.const	$252=, 352
	i32.add 	$252=, $312, $252
	i32.add 	$push82=, $252, $pop530
	i64.load	$175=, 0($pop82)
	i32.const	$push529=, 8
	i32.const	$253=, 336
	i32.add 	$253=, $312, $253
	i32.add 	$push83=, $253, $pop529
	i64.load	$45=, 0($pop83)
	i32.const	$push528=, 8
	i32.const	$254=, 368
	i32.add 	$254=, $312, $254
	i32.add 	$push85=, $254, $pop528
	i64.load	$46=, 0($pop85)
	i32.const	$push527=, 8
	i32.const	$255=, 432
	i32.add 	$255=, $312, $255
	i32.add 	$push88=, $255, $pop527
	i64.load	$47=, 0($pop88)
	i32.const	$push526=, 8
	i32.const	$256=, 864
	i32.add 	$256=, $312, $256
	i32.add 	$push93=, $256, $pop526
	i64.load	$48=, 0($pop93)
	i32.const	$push525=, 8
	i32.const	$257=, 848
	i32.add 	$257=, $312, $257
	i32.add 	$push94=, $257, $pop525
	i64.load	$49=, 0($pop94)
	i32.const	$push524=, 8
	i32.const	$258=, 880
	i32.add 	$258=, $312, $258
	i32.add 	$push96=, $258, $pop524
	i64.load	$50=, 0($pop96)
	i32.const	$push523=, 8
	i32.const	$259=, 1008
	i32.add 	$259=, $312, $259
	i32.add 	$push99=, $259, $pop523
	i64.load	$51=, 0($pop99)
	i32.const	$push522=, 8
	i32.const	$260=, 960
	i32.add 	$260=, $312, $260
	i32.add 	$push100=, $260, $pop522
	i64.load	$52=, 0($pop100)
	i32.const	$push521=, 8
	i32.const	$261=, 976
	i32.add 	$261=, $312, $261
	i32.add 	$push102=, $261, $pop521
	i64.load	$53=, 0($pop102)
	i32.const	$push520=, 8
	i32.const	$262=, 816
	i32.add 	$262=, $312, $262
	i32.add 	$push105=, $262, $pop520
	i64.load	$54=, 0($pop105)
	i32.const	$push519=, 8
	i32.const	$263=, 240
	i32.add 	$263=, $312, $263
	i32.add 	$push110=, $263, $pop519
	i64.load	$55=, 0($pop110)
	i32.const	$push518=, 8
	i32.const	$264=, 912
	i32.add 	$264=, $312, $264
	i32.add 	$push138=, $264, $pop518
	i64.load	$67=, 0($pop138)
	i32.const	$push517=, 8
	i32.const	$265=, 928
	i32.add 	$265=, $312, $265
	i32.add 	$push139=, $265, $pop517
	i64.load	$68=, 0($pop139)
	i32.const	$push516=, 8
	i32.const	$266=, 944
	i32.add 	$266=, $312, $266
	i32.add 	$push141=, $266, $pop516
	i64.load	$69=, 0($pop141)
	i32.const	$push515=, 8
	i32.const	$267=, 80
	i32.add 	$267=, $312, $267
	i32.add 	$push145=, $267, $pop515
	i64.load	$70=, 0($pop145)
	i32.const	$push514=, 8
	i32.const	$268=, 96
	i32.add 	$268=, $312, $268
	i32.add 	$push146=, $268, $pop514
	i64.load	$71=, 0($pop146)
	i64.load	$59=, 80($312)
	i64.load	$60=, 96($312)
	i64.load	$61=, 112($312)
	i32.const	$push513=, 8
	i32.const	$269=, 112
	i32.add 	$269=, $312, $269
	i32.add 	$push148=, $269, $pop513
	i64.load	$72=, 0($pop148)
	i32.const	$push512=, 8
	i32.const	$270=, 48
	i32.add 	$270=, $312, $270
	i32.add 	$push151=, $270, $pop512
	i64.load	$73=, 0($pop151)
	i32.const	$push511=, 8
	i32.const	$271=, 176
	i32.add 	$271=, $312, $271
	i32.add 	$push154=, $271, $pop511
	i64.load	$74=, 0($pop154)
	i32.const	$push510=, 8
	i32.const	$272=, 288
	i32.add 	$272=, $312, $272
	i32.add 	$push159=, $272, $pop510
	i64.load	$75=, 0($pop159)
	i32.const	$push509=, 8
	i32.const	$273=, 272
	i32.add 	$273=, $312, $273
	i32.add 	$push160=, $273, $pop509
	i64.load	$76=, 0($pop160)
	i32.const	$push508=, 8
	i32.const	$274=, 304
	i32.add 	$274=, $312, $274
	i32.add 	$push162=, $274, $pop508
	i64.load	$77=, 0($pop162)
	i32.const	$push507=, 8
	i32.const	$275=, 128
	i32.add 	$275=, $312, $275
	i32.add 	$push186=, $275, $pop507
	i64.load	$87=, 0($pop186)
	i32.const	$push506=, 8
	i32.const	$276=, 144
	i32.add 	$276=, $312, $276
	i32.add 	$push187=, $276, $pop506
	i64.load	$88=, 0($pop187)
	i32.const	$push505=, 8
	i32.const	$277=, 160
	i32.add 	$277=, $312, $277
	i32.add 	$push189=, $277, $pop505
	i64.load	$89=, 0($pop189)
	i32.const	$push504=, 8
	i32.add 	$push192=, $312, $pop504
	i64.load	$90=, 0($pop192)
	i32.const	$push503=, 8
	i32.const	$278=, 16
	i32.add 	$278=, $312, $278
	i32.add 	$push193=, $278, $pop503
	i64.load	$91=, 0($pop193)
	i64.load	$84=, 64($312)
	i32.const	$push502=, 8
	i32.const	$279=, 64
	i32.add 	$279=, $312, $279
	i32.add 	$push198=, $279, $pop502
	i64.load	$93=, 0($pop198)
	i32.const	$push501=, 8
	i32.const	$280=, 32
	i32.add 	$280=, $312, $280
	i32.add 	$push195=, $280, $pop501
	i64.load	$92=, 0($pop195)
	i32.const	$push500=, 8
	i32.const	$281=, 896
	i32.add 	$281=, $312, $281
	i32.add 	$push203=, $281, $pop500
	i64.load	$94=, 0($pop203)
	i32.const	$push499=, 8
	i32.const	$282=, 256
	i32.add 	$282=, $312, $282
	i32.add 	$push207=, $282, $pop499
	i64.load	$95=, 0($pop207)
	i32.const	$push498=, 8
	i32.const	$283=, 192
	i32.add 	$283=, $312, $283
	i32.add 	$push236=, $283, $pop498
	i64.load	$109=, 0($pop236)
	i32.const	$push497=, 8
	i32.const	$284=, 208
	i32.add 	$284=, $312, $284
	i32.add 	$push237=, $284, $pop497
	i64.load	$110=, 0($pop237)
	i64.load	$81=, 0($312)
	i64.load	$82=, 16($312)
	i64.load	$83=, 32($312)
	i32.const	$push496=, 8
	i32.const	$285=, 224
	i32.add 	$285=, $312, $285
	i32.add 	$push239=, $285, $pop496
	i64.load	$111=, 0($pop239)
	i64.load	$96=, 192($312)
	i64.load	$97=, 208($312)
	i64.load	$98=, 224($312)
	i64.load	$44=, 240($312)
	i64.load	$62=, 48($312)
	i64.load	$63=, 176($312)
	i64.load	$78=, 128($312)
	i64.load	$79=, 144($312)
	i64.load	$80=, 160($312)
	i32.const	$push495=, 8
	i32.const	$286=, 768
	i32.add 	$286=, $312, $286
	i32.add 	$push243=, $286, $pop495
	i64.load	$112=, 0($pop243)
	i32.const	$push494=, 8
	i32.const	$287=, 784
	i32.add 	$287=, $312, $287
	i32.add 	$push244=, $287, $pop494
	i64.load	$113=, 0($pop244)
	i32.const	$push493=, 8
	i32.const	$288=, 800
	i32.add 	$288=, $312, $288
	i32.add 	$push246=, $288, $pop493
	i64.load	$114=, 0($pop246)
	i32.const	$push492=, 8
	i32.const	$289=, 992
	i32.add 	$289=, $312, $289
	i32.add 	$push249=, $289, $pop492
	i64.load	$115=, 0($pop249)
	i32.const	$push491=, 8
	i32.const	$290=, 832
	i32.add 	$290=, $312, $290
	i32.add 	$push252=, $290, $pop491
	i64.load	$116=, 0($pop252)
	i32.const	$push490=, 8
	i32.const	$291=, 384
	i32.add 	$291=, $312, $291
	i32.add 	$push257=, $291, $pop490
	i64.load	$117=, 0($pop257)
	i32.const	$push489=, 8
	i32.const	$292=, 400
	i32.add 	$292=, $312, $292
	i32.add 	$push258=, $292, $pop489
	i64.load	$118=, 0($pop258)
	i64.load	$104=, 384($312)
	i64.load	$105=, 400($312)
	i32.const	$push488=, 8
	i32.const	$293=, 416
	i32.add 	$293=, $312, $293
	i32.add 	$push260=, $293, $pop488
	i64.load	$119=, 0($pop260)
	i64.load	$106=, 416($312)
	i64.load	$36=, 432($312)
	i32.const	$push487=, 8
	i32.const	$294=, 320
	i32.add 	$294=, $312, $294
	i32.add 	$push263=, $294, $pop487
	i64.load	$120=, 0($pop263)
	i64.load	$33=, 352($312)
	i64.load	$34=, 336($312)
	i64.load	$35=, 368($312)
	i32.const	$push486=, 8
	i32.const	$295=, 448
	i32.add 	$295=, $312, $295
	i32.add 	$push266=, $295, $pop486
	i64.load	$121=, 0($pop266)
	i64.load	$64=, 288($312)
	i64.load	$65=, 272($312)
	i64.load	$66=, 304($312)
	i64.load	$86=, 256($312)
	i64.load	$107=, 320($312)
	i64.load	$108=, 448($312)
	i32.const	$push485=, 8
	i32.const	$296=, 736
	i32.add 	$296=, $312, $296
	i32.add 	$push283=, $296, $pop485
	i64.load	$129=, 0($pop283)
	i32.const	$push484=, 8
	i32.const	$297=, 720
	i32.add 	$297=, $312, $297
	i32.add 	$push284=, $297, $pop484
	i64.load	$130=, 0($pop284)
	i64.load	$37=, 864($312)
	i64.load	$38=, 848($312)
	i64.load	$39=, 880($312)
	i32.const	$push483=, 8
	i32.const	$298=, 752
	i32.add 	$298=, $312, $298
	i32.add 	$push286=, $298, $pop483
	i64.load	$131=, 0($pop286)
	i64.load	$122=, 736($312)
	i64.load	$123=, 720($312)
	i64.load	$124=, 752($312)
	i32.const	$push482=, 8
	i32.const	$299=, 592
	i32.add 	$299=, $312, $299
	i32.add 	$push289=, $299, $pop482
	i64.load	$132=, 0($pop289)
	i32.const	$push481=, 8
	i32.const	$300=, 608
	i32.add 	$300=, $312, $300
	i32.add 	$push290=, $300, $pop481
	i64.load	$133=, 0($pop290)
	i32.const	$push480=, 8
	i32.const	$301=, 624
	i32.add 	$301=, $312, $301
	i32.add 	$push292=, $301, $pop480
	i64.load	$134=, 0($pop292)
	i32.const	$push479=, 8
	i32.const	$302=, 688
	i32.add 	$302=, $312, $302
	i32.add 	$push295=, $302, $pop479
	i64.load	$135=, 0($pop295)
	i32.const	$push478=, 8
	i32.const	$303=, 640
	i32.add 	$303=, $312, $303
	i32.add 	$push310=, $303, $pop478
	i64.load	$141=, 0($pop310)
	i32.const	$push477=, 8
	i32.const	$304=, 656
	i32.add 	$304=, $312, $304
	i32.add 	$push311=, $304, $pop477
	i64.load	$142=, 0($pop311)
	i64.load	$99=, 768($312)
	i64.load	$100=, 784($312)
	i64.load	$101=, 800($312)
	i32.const	$push476=, 8
	i32.const	$305=, 672
	i32.add 	$305=, $312, $305
	i32.add 	$push313=, $305, $pop476
	i64.load	$143=, 0($pop313)
	i64.load	$136=, 640($312)
	i64.load	$137=, 656($312)
	i64.load	$138=, 672($312)
	i64.load	$43=, 816($312)
	i64.load	$128=, 688($312)
	i32.const	$push475=, 8
	i32.const	$306=, 576
	i32.add 	$306=, $312, $306
	i32.add 	$push316=, $306, $pop475
	i64.load	$144=, 0($pop316)
	i64.load	$103=, 832($312)
	i64.load	$140=, 704($312)
	i32.const	$push474=, 8
	i32.const	$307=, 704
	i32.add 	$307=, $312, $307
	i32.add 	$push319=, $307, $pop474
	i64.load	$145=, 0($pop319)
	i32.const	$push473=, 8
	i32.const	$308=, 528
	i32.add 	$308=, $312, $308
	i32.add 	$push329=, $308, $pop473
	i64.load	$149=, 0($pop329)
	i32.const	$push472=, 8
	i32.const	$309=, 544
	i32.add 	$309=, $312, $309
	i32.add 	$push330=, $309, $pop472
	i64.load	$150=, 0($pop330)
	i32.const	$push471=, 8
	i32.const	$310=, 560
	i32.add 	$310=, $312, $310
	i32.add 	$push332=, $310, $pop471
	i64.load	$151=, 0($pop332)
	i64.load	$40=, 1008($312)
	i64.load	$41=, 960($312)
	i64.load	$42=, 976($312)
	i64.load	$56=, 912($312)
	i64.load	$57=, 928($312)
	i64.load	$58=, 944($312)
	i64.load	$85=, 896($312)
	i64.load	$102=, 992($312)
	i64.load	$125=, 592($312)
	i64.load	$126=, 608($312)
	i64.load	$127=, 624($312)
	i64.load	$139=, 576($312)
	i64.load	$146=, 528($312)
	i64.load	$147=, 544($312)
	i64.load	$148=, 560($312)
	i64.load	$152=, 512($312)
	i32.const	$push470=, 8
	i32.add 	$push345=, $0, $pop470
	i32.const	$push469=, 8
	i32.const	$311=, 512
	i32.add 	$311=, $312, $311
	i32.add 	$push340=, $311, $pop469
	i64.load	$push341=, 0($pop340)
	i64.const	$push37=, 0
	i64.const	$push468=, 128
	i64.lt_u	$push56=, $17, $pop468
	tee_local	$push467=, $168=, $pop56
	i64.select	$push342=, $pop341, $pop37, $pop467
	i64.const	$push466=, 0
	i64.const	$push465=, 256
	i64.lt_u	$push64=, $17, $pop465
	tee_local	$push464=, $167=, $pop64
	i64.select	$push343=, $pop342, $pop466, $pop464
	i64.const	$push463=, 0
	i64.const	$push462=, 512
	i64.lt_u	$push72=, $17, $pop462
	tee_local	$push461=, $166=, $pop72
	i64.select	$push344=, $pop343, $pop463, $pop461
	i64.store	$discard=, 0($pop345), $pop344
	i64.const	$push460=, 0
	i64.select	$push337=, $152, $pop460, $168
	i64.const	$push459=, 0
	i64.select	$push338=, $pop337, $pop459, $167
	i64.const	$push458=, 0
	i64.select	$push339=, $pop338, $pop458, $166
	i64.store	$discard=, 0($0), $pop339
	i32.const	$push346=, 24
	i32.add 	$push347=, $0, $pop346
	i64.or  	$push331=, $149, $150
	i64.select	$push333=, $pop331, $151, $168
	i64.const	$push457=, 0
	i64.eq  	$push59=, $17, $pop457
	tee_local	$push456=, $165=, $pop59
	i64.select	$push334=, $4, $pop333, $pop456
	i64.const	$push455=, 0
	i64.select	$push335=, $pop334, $pop455, $167
	i64.const	$push454=, 0
	i64.select	$push336=, $pop335, $pop454, $166
	i64.store	$discard=, 0($pop347), $pop336
	i32.const	$push348=, 16
	i32.add 	$push349=, $0, $pop348
	i64.or  	$push324=, $146, $147
	i64.select	$push325=, $pop324, $148, $168
	i64.select	$push326=, $3, $pop325, $165
	i64.const	$push453=, 0
	i64.select	$push327=, $pop326, $pop453, $167
	i64.const	$push452=, 0
	i64.select	$push328=, $pop327, $pop452, $166
	i64.store	$discard=, 0($pop349), $pop328
	i32.const	$push350=, 56
	i32.add 	$push351=, $0, $pop350
	i64.or  	$push291=, $132, $133
	i64.select	$push293=, $pop291, $134, $168
	i64.select	$push294=, $8, $pop293, $165
	i64.const	$push451=, 0
	i64.const	$push450=, 128
	i64.lt_u	$push61=, $172, $pop450
	tee_local	$push449=, $164=, $pop61
	i64.select	$push296=, $135, $pop451, $pop449
	i64.or  	$push297=, $pop294, $pop296
	i64.or  	$push285=, $130, $129
	i64.const	$push448=, 128
	i64.lt_u	$push51=, $176, $pop448
	tee_local	$push447=, $163=, $pop51
	i64.select	$push287=, $pop285, $131, $pop447
	i64.const	$push446=, 0
	i64.eq  	$push54=, $176, $pop446
	tee_local	$push445=, $153=, $pop54
	i64.select	$push288=, $4, $pop287, $pop445
	i64.select	$push298=, $pop297, $pop288, $167
	i64.select	$push299=, $8, $pop298, $165
	i64.const	$push444=, 0
	i64.select	$push300=, $pop299, $pop444, $166
	i64.store	$discard=, 0($pop351), $pop300
	i32.const	$push352=, 48
	i32.add 	$push353=, $0, $pop352
	i64.or  	$push275=, $125, $126
	i64.select	$push276=, $pop275, $127, $168
	i64.select	$push277=, $7, $pop276, $165
	i64.const	$push443=, 0
	i64.select	$push278=, $128, $pop443, $164
	i64.or  	$push279=, $pop277, $pop278
	i64.or  	$push272=, $123, $122
	i64.select	$push273=, $pop272, $124, $163
	i64.select	$push274=, $3, $pop273, $153
	i64.select	$push280=, $pop279, $pop274, $167
	i64.select	$push281=, $7, $pop280, $165
	i64.const	$push442=, 0
	i64.select	$push282=, $pop281, $pop442, $166
	i64.store	$discard=, 0($pop353), $pop282
	i32.const	$push354=, 40
	i32.add 	$push355=, $0, $pop354
	i64.const	$push441=, 0
	i64.select	$push317=, $144, $pop441, $168
	i64.or  	$push312=, $141, $142
	i64.select	$push314=, $pop312, $143, $164
	i64.const	$push440=, 0
	i64.eq  	$push170=, $172, $pop440
	tee_local	$push439=, $162=, $pop170
	i64.select	$push315=, $2, $pop314, $pop439
	i64.or  	$push318=, $pop317, $pop315
	i64.const	$push438=, 0
	i64.select	$push320=, $145, $pop438, $163
	i64.select	$push321=, $pop318, $pop320, $167
	i64.select	$push322=, $6, $pop321, $165
	i64.const	$push437=, 0
	i64.select	$push323=, $pop322, $pop437, $166
	i64.store	$discard=, 0($pop355), $pop323
	i32.const	$push356=, 32
	i32.add 	$push357=, $0, $pop356
	i64.const	$push436=, 0
	i64.select	$push304=, $139, $pop436, $168
	i64.or  	$push301=, $136, $137
	i64.select	$push302=, $pop301, $138, $164
	i64.select	$push303=, $1, $pop302, $162
	i64.or  	$push305=, $pop304, $pop303
	i64.const	$push435=, 0
	i64.select	$push306=, $140, $pop435, $163
	i64.select	$push307=, $pop305, $pop306, $167
	i64.select	$push308=, $5, $pop307, $165
	i64.const	$push434=, 0
	i64.select	$push309=, $pop308, $pop434, $166
	i64.store	$discard=, 0($pop357), $pop309
	i32.const	$push358=, 120
	i32.add 	$push359=, $0, $pop358
	i64.or  	$push101=, $51, $52
	i64.select	$push103=, $pop101, $53, $168
	i64.select	$push104=, $16, $pop103, $165
	i64.const	$push433=, 0
	i64.select	$push106=, $54, $pop433, $164
	i64.or  	$push107=, $pop104, $pop106
	i64.or  	$push95=, $49, $48
	i64.select	$push97=, $pop95, $50, $163
	i64.select	$push98=, $12, $pop97, $153
	i64.select	$push108=, $pop107, $pop98, $167
	i64.select	$push109=, $16, $pop108, $165
	i64.const	$push432=, 0
	i64.const	$push431=, 128
	i64.lt_u	$push67=, $171, $pop431
	tee_local	$push430=, $161=, $pop67
	i64.select	$push111=, $55, $pop432, $pop430
	i64.const	$push429=, 0
	i64.const	$push428=, 256
	i64.lt_u	$push69=, $171, $pop428
	tee_local	$push427=, $160=, $pop69
	i64.select	$push112=, $pop111, $pop429, $pop427
	i64.or  	$push113=, $pop109, $pop112
	i64.or  	$push84=, $45, $175
	i64.const	$push426=, 128
	i64.lt_u	$push40=, $180, $pop426
	tee_local	$push425=, $159=, $pop40
	i64.select	$push86=, $pop84, $46, $pop425
	i64.const	$push424=, 0
	i64.eq  	$push43=, $180, $pop424
	tee_local	$push423=, $158=, $pop43
	i64.select	$push87=, $8, $pop86, $pop423
	i64.const	$push422=, 0
	i64.const	$push421=, 128
	i64.lt_u	$push45=, $178, $pop421
	tee_local	$push420=, $157=, $pop45
	i64.select	$push89=, $47, $pop422, $pop420
	i64.or  	$push90=, $pop87, $pop89
	i64.or  	$push78=, $177, $174
	i64.const	$push419=, 128
	i64.lt_u	$push34=, $182, $pop419
	tee_local	$push418=, $156=, $pop34
	i64.select	$push80=, $pop78, $179, $pop418
	i64.const	$push417=, 0
	i64.eq  	$push38=, $182, $pop417
	tee_local	$push416=, $155=, $pop38
	i64.select	$push81=, $4, $pop80, $pop416
	i64.const	$push415=, 256
	i64.lt_u	$push48=, $180, $pop415
	tee_local	$push414=, $154=, $pop48
	i64.select	$push91=, $pop90, $pop81, $pop414
	i64.select	$push92=, $8, $pop91, $158
	i64.select	$push114=, $pop113, $pop92, $166
	i64.select	$push115=, $16, $pop114, $165
	i64.store	$discard=, 0($pop359), $pop115
	i32.const	$push360=, 112
	i32.add 	$push361=, $0, $pop360
	i64.or  	$push57=, $40, $41
	i64.select	$push58=, $pop57, $42, $168
	i64.select	$push60=, $15, $pop58, $165
	i64.const	$push413=, 0
	i64.select	$push62=, $43, $pop413, $164
	i64.or  	$push63=, $pop60, $pop62
	i64.or  	$push52=, $38, $37
	i64.select	$push53=, $pop52, $39, $163
	i64.select	$push55=, $11, $pop53, $153
	i64.select	$push65=, $pop63, $pop55, $167
	i64.select	$push66=, $15, $pop65, $165
	i64.const	$push412=, 0
	i64.select	$push68=, $44, $pop412, $161
	i64.const	$push411=, 0
	i64.select	$push70=, $pop68, $pop411, $160
	i64.or  	$push71=, $pop66, $pop70
	i64.or  	$push41=, $34, $33
	i64.select	$push42=, $pop41, $35, $159
	i64.select	$push44=, $7, $pop42, $158
	i64.const	$push410=, 0
	i64.select	$push46=, $36, $pop410, $157
	i64.or  	$push47=, $pop44, $pop46
	i64.or  	$push35=, $181, $173
	i64.select	$push36=, $pop35, $169, $156
	i64.select	$push39=, $3, $pop36, $155
	i64.select	$push49=, $pop47, $pop39, $154
	i64.select	$push50=, $7, $pop49, $158
	i64.select	$push73=, $pop71, $pop50, $166
	i64.select	$push74=, $15, $pop73, $165
	i64.store	$discard=, 0($pop361), $pop74
	i32.const	$push362=, 104
	i32.add 	$push363=, $0, $pop362
	i64.const	$push409=, 0
	i64.select	$push250=, $115, $pop409, $168
	i64.or  	$push245=, $112, $113
	i64.select	$push247=, $pop245, $114, $164
	i64.select	$push248=, $10, $pop247, $162
	i64.or  	$push251=, $pop250, $pop248
	i64.const	$push408=, 0
	i64.select	$push253=, $116, $pop408, $163
	i64.select	$push254=, $pop251, $pop253, $167
	i64.select	$push255=, $14, $pop254, $165
	i64.or  	$push238=, $109, $110
	i64.select	$push240=, $pop238, $111, $161
	i64.const	$push407=, 0
	i64.eq  	$push129=, $171, $pop407
	tee_local	$push406=, $153=, $pop129
	i64.select	$push241=, $6, $pop240, $pop406
	i64.const	$push405=, 0
	i64.select	$push242=, $pop241, $pop405, $160
	i64.or  	$push256=, $pop255, $pop242
	i64.const	$push404=, 0
	i64.select	$push264=, $120, $pop404, $159
	i64.or  	$push259=, $117, $118
	i64.select	$push261=, $pop259, $119, $157
	i64.const	$push403=, 0
	i64.eq  	$push227=, $178, $pop403
	tee_local	$push402=, $155=, $pop227
	i64.select	$push262=, $2, $pop261, $pop402
	i64.or  	$push265=, $pop264, $pop262
	i64.const	$push401=, 0
	i64.select	$push267=, $121, $pop401, $156
	i64.select	$push268=, $pop265, $pop267, $154
	i64.select	$push269=, $6, $pop268, $158
	i64.select	$push270=, $pop256, $pop269, $166
	i64.select	$push271=, $14, $pop270, $165
	i64.store	$discard=, 0($pop363), $pop271
	i32.const	$push364=, 96
	i32.add 	$push365=, $0, $pop364
	i64.const	$push400=, 0
	i64.select	$push219=, $102, $pop400, $168
	i64.or  	$push216=, $99, $100
	i64.select	$push217=, $pop216, $101, $164
	i64.select	$push218=, $9, $pop217, $162
	i64.or  	$push220=, $pop219, $pop218
	i64.const	$push399=, 0
	i64.select	$push221=, $103, $pop399, $163
	i64.select	$push222=, $pop220, $pop221, $167
	i64.select	$push223=, $13, $pop222, $165
	i64.or  	$push212=, $96, $97
	i64.select	$push213=, $pop212, $98, $161
	i64.select	$push214=, $5, $pop213, $153
	i64.const	$push398=, 0
	i64.select	$push215=, $pop214, $pop398, $160
	i64.or  	$push224=, $pop223, $pop215
	i64.const	$push397=, 0
	i64.select	$push229=, $107, $pop397, $159
	i64.or  	$push225=, $104, $105
	i64.select	$push226=, $pop225, $106, $157
	i64.select	$push228=, $1, $pop226, $155
	i64.or  	$push230=, $pop229, $pop228
	i64.const	$push396=, 0
	i64.select	$push231=, $108, $pop396, $156
	i64.select	$push232=, $pop230, $pop231, $154
	i64.select	$push233=, $5, $pop232, $158
	i64.select	$push234=, $pop224, $pop233, $166
	i64.select	$push235=, $13, $pop234, $165
	i64.store	$discard=, 0($pop365), $pop235
	i32.const	$push366=, 72
	i32.add 	$push367=, $0, $pop366
	i64.const	$push395=, 0
	i64.select	$push204=, $94, $pop395, $168
	i64.const	$push394=, 0
	i64.select	$push205=, $pop204, $pop394, $167
	i64.or  	$push194=, $90, $91
	i64.select	$push196=, $pop194, $92, $161
	i64.select	$push197=, $2, $pop196, $153
	i64.const	$push393=, 0
	i64.const	$push392=, 128
	i64.lt_u	$push120=, $170, $pop392
	tee_local	$push391=, $163=, $pop120
	i64.select	$push199=, $93, $pop393, $pop391
	i64.or  	$push200=, $pop197, $pop199
	i64.or  	$push188=, $87, $88
	i64.select	$push190=, $pop188, $89, $164
	i64.select	$push191=, $6, $pop190, $162
	i64.select	$push201=, $pop200, $pop191, $160
	i64.select	$push202=, $2, $pop201, $153
	i64.or  	$push206=, $pop205, $pop202
	i64.const	$push390=, 0
	i64.select	$push208=, $95, $pop390, $159
	i64.const	$push389=, 0
	i64.select	$push209=, $pop208, $pop389, $154
	i64.select	$push210=, $pop206, $pop209, $166
	i64.select	$push211=, $10, $pop210, $165
	i64.store	$discard=, 0($pop367), $pop211
	i32.const	$push368=, 64
	i32.add 	$push369=, $0, $pop368
	i64.const	$push388=, 0
	i64.select	$push179=, $85, $pop388, $168
	i64.const	$push387=, 0
	i64.select	$push180=, $pop179, $pop387, $167
	i64.or  	$push172=, $81, $82
	i64.select	$push173=, $pop172, $83, $161
	i64.select	$push174=, $1, $pop173, $153
	i64.const	$push386=, 0
	i64.select	$push175=, $84, $pop386, $163
	i64.or  	$push176=, $pop174, $pop175
	i64.or  	$push168=, $78, $79
	i64.select	$push169=, $pop168, $80, $164
	i64.select	$push171=, $5, $pop169, $162
	i64.select	$push177=, $pop176, $pop171, $160
	i64.select	$push178=, $1, $pop177, $153
	i64.or  	$push181=, $pop180, $pop178
	i64.const	$push385=, 0
	i64.select	$push182=, $86, $pop385, $159
	i64.const	$push384=, 0
	i64.select	$push183=, $pop182, $pop384, $154
	i64.select	$push184=, $pop181, $pop183, $166
	i64.select	$push185=, $9, $pop184, $165
	i64.store	$discard=, 0($pop369), $pop185
	i32.const	$push370=, 88
	i32.add 	$push371=, $0, $pop370
	i64.or  	$push140=, $67, $68
	i64.select	$push142=, $pop140, $69, $168
	i64.select	$push143=, $12, $pop142, $165
	i64.const	$push383=, 0
	i64.select	$push144=, $pop143, $pop383, $167
	i64.const	$push382=, 0
	i64.select	$push152=, $73, $pop382, $161
	i64.or  	$push147=, $70, $71
	i64.select	$push149=, $pop147, $72, $163
	i64.const	$push381=, 0
	i64.eq  	$push123=, $170, $pop381
	tee_local	$push380=, $162=, $pop123
	i64.select	$push150=, $8, $pop149, $pop380
	i64.or  	$push153=, $pop152, $pop150
	i64.const	$push379=, 0
	i64.select	$push155=, $74, $pop379, $164
	i64.select	$push156=, $pop153, $pop155, $160
	i64.select	$push157=, $4, $pop156, $153
	i64.or  	$push158=, $pop144, $pop157
	i64.or  	$push161=, $76, $75
	i64.select	$push163=, $pop161, $77, $159
	i64.select	$push164=, $4, $pop163, $158
	i64.const	$push378=, 0
	i64.select	$push165=, $pop164, $pop378, $154
	i64.select	$push166=, $pop158, $pop165, $166
	i64.select	$push167=, $12, $pop166, $165
	i64.store	$discard=, 0($pop371), $pop167
	i32.const	$push372=, 80
	i32.add 	$push373=, $0, $pop372
	i64.or  	$push116=, $56, $57
	i64.select	$push117=, $pop116, $58, $168
	i64.select	$push118=, $11, $pop117, $165
	i64.const	$push377=, 0
	i64.select	$push119=, $pop118, $pop377, $167
	i64.const	$push376=, 0
	i64.select	$push125=, $62, $pop376, $161
	i64.or  	$push121=, $59, $60
	i64.select	$push122=, $pop121, $61, $163
	i64.select	$push124=, $7, $pop122, $162
	i64.or  	$push126=, $pop125, $pop124
	i64.const	$push375=, 0
	i64.select	$push127=, $63, $pop375, $164
	i64.select	$push128=, $pop126, $pop127, $160
	i64.select	$push130=, $3, $pop128, $153
	i64.or  	$push131=, $pop119, $pop130
	i64.or  	$push132=, $65, $64
	i64.select	$push133=, $pop132, $66, $159
	i64.select	$push134=, $3, $pop133, $158
	i64.const	$push374=, 0
	i64.select	$push135=, $pop134, $pop374, $154
	i64.select	$push136=, $pop131, $pop135, $166
	i64.select	$push137=, $11, $pop136, $165
	i64.store	$discard=, 0($pop373), $pop137
	i32.const	$185=, 1024
	i32.add 	$312=, $312, $185
	i32.const	$185=, __stack_pointer
	i32.store	$312=, 0($185), $312
	return
	.endfunc
.Lfunc_end5:
	.size	bigshift, .Lfunc_end5-bigshift


