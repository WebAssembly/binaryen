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
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i64, i64, i64, i32, i32, i64, i32, i32, i64, i64, i64, i32, i32, i64, i64, i64, i32, i32, i64, i32, i32, i64, i32, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i32, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	i32.const	$179=, __stack_pointer
	i32.load	$179=, 0($179)
	i32.const	$180=, 1024
	i32.sub 	$310=, $179, $180
	i32.const	$180=, __stack_pointer
	i32.store	$310=, 0($180), $310
	i64.const	$push0=, 896
	i64.sub 	$push1=, $pop0, $17
	i32.const	$182=, 480
	i32.add 	$182=, $310, $182
	call    	__lshrti3@FUNCTION, $182, $1, $2, $pop1
	i64.const	$push2=, -768
	i64.add 	$33=, $17, $pop2
	i32.const	$183=, 464
	i32.add 	$183=, $310, $183
	call    	__ashlti3@FUNCTION, $183, $3, $4, $33
	i64.const	$push3=, -896
	i64.add 	$push4=, $17, $pop3
	i32.const	$184=, 496
	i32.add 	$184=, $310, $184
	call    	__ashlti3@FUNCTION, $184, $1, $2, $pop4
	i64.const	$push5=, 640
	i64.sub 	$34=, $pop5, $17
	i32.const	$185=, 352
	i32.add 	$185=, $310, $185
	call    	__lshrti3@FUNCTION, $185, $5, $6, $34
	i64.const	$push6=, -512
	i64.add 	$35=, $17, $pop6
	i32.const	$186=, 336
	i32.add 	$186=, $310, $186
	call    	__ashlti3@FUNCTION, $186, $7, $8, $35
	i64.const	$push7=, -640
	i64.add 	$36=, $17, $pop7
	i32.const	$187=, 368
	i32.add 	$187=, $310, $187
	call    	__ashlti3@FUNCTION, $187, $5, $6, $36
	i64.const	$push8=, 768
	i64.sub 	$37=, $pop8, $17
	i32.const	$188=, 432
	i32.add 	$188=, $310, $188
	call    	__lshrti3@FUNCTION, $188, $3, $4, $37
	i64.const	$push9=, 384
	i64.sub 	$38=, $pop9, $17
	i32.const	$189=, 864
	i32.add 	$189=, $310, $189
	call    	__lshrti3@FUNCTION, $189, $9, $10, $38
	i64.const	$push10=, -256
	i64.add 	$39=, $17, $pop10
	i32.const	$190=, 848
	i32.add 	$190=, $310, $190
	call    	__ashlti3@FUNCTION, $190, $11, $12, $39
	i64.const	$push11=, -384
	i64.add 	$40=, $17, $pop11
	i32.const	$191=, 880
	i32.add 	$191=, $310, $191
	call    	__ashlti3@FUNCTION, $191, $9, $10, $40
	i32.const	$192=, 1008
	i32.add 	$192=, $310, $192
	call    	__ashlti3@FUNCTION, $192, $15, $16, $17
	i64.const	$push12=, 128
	i64.sub 	$41=, $pop12, $17
	i32.const	$193=, 960
	i32.add 	$193=, $310, $193
	call    	__lshrti3@FUNCTION, $193, $13, $14, $41
	i64.const	$push13=, -128
	i64.add 	$42=, $17, $pop13
	i32.const	$194=, 976
	i32.add 	$194=, $310, $194
	call    	__ashlti3@FUNCTION, $194, $13, $14, $42
	i64.const	$push14=, 256
	i64.sub 	$43=, $pop14, $17
	i32.const	$195=, 816
	i32.add 	$195=, $310, $195
	call    	__lshrti3@FUNCTION, $195, $11, $12, $43
	i64.const	$push15=, 512
	i64.sub 	$44=, $pop15, $17
	i32.const	$196=, 240
	i32.add 	$196=, $310, $196
	call    	__lshrti3@FUNCTION, $196, $7, $8, $44
	i32.const	$197=, 912
	i32.add 	$197=, $310, $197
	call    	__ashlti3@FUNCTION, $197, $11, $12, $17
	i32.const	$198=, 928
	i32.add 	$198=, $310, $198
	call    	__lshrti3@FUNCTION, $198, $9, $10, $41
	i32.const	$199=, 944
	i32.add 	$199=, $310, $199
	call    	__ashlti3@FUNCTION, $199, $9, $10, $42
	i64.const	$push483=, 256
	i64.sub 	$45=, $pop483, $44
	i32.const	$200=, 80
	i32.add 	$200=, $310, $200
	call    	__ashlti3@FUNCTION, $200, $7, $8, $45
	i64.const	$push482=, 128
	i64.sub 	$push16=, $pop482, $45
	i32.const	$201=, 96
	i32.add 	$201=, $310, $201
	call    	__lshrti3@FUNCTION, $201, $5, $6, $pop16
	i64.const	$push481=, 128
	i64.sub 	$46=, $pop481, $44
	i32.const	$202=, 112
	i32.add 	$202=, $310, $202
	call    	__ashlti3@FUNCTION, $202, $5, $6, $46
	i32.const	$203=, 48
	i32.add 	$203=, $310, $203
	call    	__lshrti3@FUNCTION, $203, $3, $4, $44
	i32.const	$204=, 176
	i32.add 	$204=, $310, $204
	call    	__lshrti3@FUNCTION, $204, $7, $8, $43
	i32.const	$205=, 288
	i32.add 	$205=, $310, $205
	call    	__lshrti3@FUNCTION, $205, $1, $2, $34
	i32.const	$206=, 272
	i32.add 	$206=, $310, $206
	call    	__ashlti3@FUNCTION, $206, $3, $4, $35
	i32.const	$207=, 304
	i32.add 	$207=, $310, $207
	call    	__ashlti3@FUNCTION, $207, $1, $2, $36
	i32.const	$208=, 128
	i32.add 	$208=, $310, $208
	call    	__lshrti3@FUNCTION, $208, $5, $6, $43
	i64.const	$push480=, 384
	i64.sub 	$push17=, $pop480, $44
	i32.const	$209=, 144
	i32.add 	$209=, $310, $209
	call    	__ashlti3@FUNCTION, $209, $7, $8, $pop17
	i32.const	$210=, 160
	i32.add 	$210=, $310, $210
	call    	__lshrti3@FUNCTION, $210, $7, $8, $41
	i32.const	$211=, 0
	i32.add 	$211=, $310, $211
	call    	__lshrti3@FUNCTION, $211, $1, $2, $44
	i32.const	$212=, 16
	i32.add 	$212=, $310, $212
	call    	__ashlti3@FUNCTION, $212, $3, $4, $46
	i32.const	$213=, 32
	i32.add 	$213=, $310, $213
	call    	__lshrti3@FUNCTION, $213, $3, $4, $38
	i32.const	$214=, 64
	i32.add 	$214=, $310, $214
	call    	__ashlti3@FUNCTION, $214, $5, $6, $45
	i32.const	$215=, 896
	i32.add 	$215=, $310, $215
	call    	__ashlti3@FUNCTION, $215, $9, $10, $17
	i32.const	$216=, 256
	i32.add 	$216=, $310, $216
	call    	__ashlti3@FUNCTION, $216, $1, $2, $35
	i32.const	$217=, 192
	i32.add 	$217=, $310, $217
	call    	__lshrti3@FUNCTION, $217, $5, $6, $44
	i32.const	$218=, 208
	i32.add 	$218=, $310, $218
	call    	__ashlti3@FUNCTION, $218, $7, $8, $46
	i32.const	$219=, 224
	i32.add 	$219=, $310, $219
	call    	__lshrti3@FUNCTION, $219, $7, $8, $38
	i32.const	$220=, 768
	i32.add 	$220=, $310, $220
	call    	__lshrti3@FUNCTION, $220, $9, $10, $43
	i64.const	$push479=, 128
	i64.sub 	$46=, $pop479, $43
	i32.const	$221=, 784
	i32.add 	$221=, $310, $221
	call    	__ashlti3@FUNCTION, $221, $11, $12, $46
	i32.const	$222=, 800
	i32.add 	$222=, $310, $222
	call    	__lshrti3@FUNCTION, $222, $11, $12, $41
	i32.const	$223=, 992
	i32.add 	$223=, $310, $223
	call    	__ashlti3@FUNCTION, $223, $13, $14, $17
	i32.const	$224=, 832
	i32.add 	$224=, $310, $224
	call    	__ashlti3@FUNCTION, $224, $9, $10, $39
	i32.const	$225=, 384
	i32.add 	$225=, $310, $225
	call    	__lshrti3@FUNCTION, $225, $1, $2, $37
	i64.const	$push478=, 128
	i64.sub 	$push18=, $pop478, $37
	i32.const	$226=, 400
	i32.add 	$226=, $310, $226
	call    	__ashlti3@FUNCTION, $226, $3, $4, $pop18
	i32.const	$227=, 416
	i32.add 	$227=, $310, $227
	call    	__lshrti3@FUNCTION, $227, $3, $4, $34
	i32.const	$228=, 320
	i32.add 	$228=, $310, $228
	call    	__ashlti3@FUNCTION, $228, $5, $6, $35
	i32.const	$229=, 448
	i32.add 	$229=, $310, $229
	call    	__ashlti3@FUNCTION, $229, $1, $2, $33
	i32.const	$230=, 736
	i32.add 	$230=, $310, $230
	call    	__lshrti3@FUNCTION, $230, $1, $2, $38
	i32.const	$231=, 720
	i32.add 	$231=, $310, $231
	call    	__ashlti3@FUNCTION, $231, $3, $4, $39
	i32.const	$232=, 752
	i32.add 	$232=, $310, $232
	call    	__ashlti3@FUNCTION, $232, $1, $2, $40
	i32.const	$233=, 592
	i32.add 	$233=, $310, $233
	call    	__ashlti3@FUNCTION, $233, $7, $8, $17
	i32.const	$234=, 608
	i32.add 	$234=, $310, $234
	call    	__lshrti3@FUNCTION, $234, $5, $6, $41
	i32.const	$235=, 624
	i32.add 	$235=, $310, $235
	call    	__ashlti3@FUNCTION, $235, $5, $6, $42
	i32.const	$236=, 688
	i32.add 	$236=, $310, $236
	call    	__lshrti3@FUNCTION, $236, $3, $4, $43
	i32.const	$237=, 640
	i32.add 	$237=, $310, $237
	call    	__lshrti3@FUNCTION, $237, $1, $2, $43
	i32.const	$238=, 656
	i32.add 	$238=, $310, $238
	call    	__ashlti3@FUNCTION, $238, $3, $4, $46
	i32.const	$239=, 672
	i32.add 	$239=, $310, $239
	call    	__lshrti3@FUNCTION, $239, $3, $4, $41
	i32.const	$240=, 576
	i32.add 	$240=, $310, $240
	call    	__ashlti3@FUNCTION, $240, $5, $6, $17
	i32.const	$241=, 704
	i32.add 	$241=, $310, $241
	call    	__ashlti3@FUNCTION, $241, $1, $2, $39
	i32.const	$242=, 528
	i32.add 	$242=, $310, $242
	call    	__ashlti3@FUNCTION, $242, $3, $4, $17
	i32.const	$243=, 544
	i32.add 	$243=, $310, $243
	call    	__lshrti3@FUNCTION, $243, $1, $2, $41
	i32.const	$244=, 560
	i32.add 	$244=, $310, $244
	call    	__ashlti3@FUNCTION, $244, $1, $2, $42
	i32.const	$245=, 512
	i32.add 	$245=, $310, $245
	call    	__ashlti3@FUNCTION, $245, $1, $2, $17
	i32.const	$push45=, 8
	i32.const	$246=, 480
	i32.add 	$246=, $310, $246
	i32.add 	$push46=, $246, $pop45
	i64.load	$41=, 0($pop46)
	i32.const	$push477=, 8
	i32.const	$247=, 464
	i32.add 	$247=, $310, $247
	i32.add 	$push47=, $247, $pop477
	i64.load	$38=, 0($pop47)
	i64.load	$42=, 480($310)
	i64.load	$34=, 464($310)
	i64.load	$46=, 496($310)
	i32.const	$push476=, 8
	i32.const	$248=, 496
	i32.add 	$248=, $310, $248
	i32.add 	$push49=, $248, $pop476
	i64.load	$36=, 0($pop49)
	i64.const	$push475=, 128
	i64.lt_u	$47=, $33, $pop475
	i64.const	$push21=, 0
	i64.eq  	$48=, $33, $pop21
	i32.const	$push474=, 8
	i32.const	$249=, 352
	i32.add 	$249=, $310, $249
	i32.add 	$push52=, $249, $pop474
	i64.load	$33=, 0($pop52)
	i32.const	$push473=, 8
	i32.const	$250=, 336
	i32.add 	$250=, $310, $250
	i32.add 	$push53=, $250, $pop473
	i64.load	$40=, 0($pop53)
	i32.const	$push472=, 8
	i32.const	$251=, 368
	i32.add 	$251=, $310, $251
	i32.add 	$push55=, $251, $pop472
	i64.load	$74=, 0($pop55)
	i32.const	$push471=, 8
	i32.const	$252=, 432
	i32.add 	$252=, $310, $252
	i32.add 	$push58=, $252, $pop471
	i64.load	$75=, 0($pop58)
	i32.const	$push470=, 8
	i32.const	$253=, 864
	i32.add 	$253=, $310, $253
	i32.add 	$push63=, $253, $pop470
	i64.load	$76=, 0($pop63)
	i32.const	$push469=, 8
	i32.const	$254=, 848
	i32.add 	$254=, $310, $254
	i32.add 	$push64=, $254, $pop469
	i64.load	$77=, 0($pop64)
	i32.const	$push468=, 8
	i32.const	$255=, 880
	i32.add 	$255=, $310, $255
	i32.add 	$push66=, $255, $pop468
	i64.load	$78=, 0($pop66)
	i32.const	$push467=, 8
	i32.const	$256=, 1008
	i32.add 	$256=, $310, $256
	i32.add 	$push69=, $256, $pop467
	i64.load	$79=, 0($pop69)
	i32.const	$push466=, 8
	i32.const	$257=, 960
	i32.add 	$257=, $310, $257
	i32.add 	$push70=, $257, $pop466
	i64.load	$80=, 0($pop70)
	i32.const	$push465=, 8
	i32.const	$258=, 976
	i32.add 	$258=, $310, $258
	i32.add 	$push72=, $258, $pop465
	i64.load	$81=, 0($pop72)
	i32.const	$push464=, 8
	i32.const	$259=, 816
	i32.add 	$259=, $310, $259
	i32.add 	$push75=, $259, $pop464
	i64.load	$82=, 0($pop75)
	i32.const	$push463=, 8
	i32.const	$260=, 240
	i32.add 	$260=, $310, $260
	i32.add 	$push80=, $260, $pop463
	i64.load	$83=, 0($pop80)
	i32.const	$push462=, 8
	i32.const	$261=, 912
	i32.add 	$261=, $310, $261
	i32.add 	$push105=, $261, $pop462
	i64.load	$97=, 0($pop105)
	i32.const	$push461=, 8
	i32.const	$262=, 928
	i32.add 	$262=, $310, $262
	i32.add 	$push106=, $262, $pop461
	i64.load	$98=, 0($pop106)
	i32.const	$push460=, 8
	i32.const	$263=, 944
	i32.add 	$263=, $310, $263
	i32.add 	$push108=, $263, $pop460
	i64.load	$99=, 0($pop108)
	i32.const	$push459=, 8
	i32.const	$264=, 80
	i32.add 	$264=, $310, $264
	i32.add 	$push112=, $264, $pop459
	i64.load	$100=, 0($pop112)
	i32.const	$push458=, 8
	i32.const	$265=, 96
	i32.add 	$265=, $310, $265
	i32.add 	$push113=, $265, $pop458
	i64.load	$101=, 0($pop113)
	i64.load	$87=, 80($310)
	i64.load	$88=, 96($310)
	i64.load	$89=, 112($310)
	i32.const	$push457=, 8
	i32.const	$266=, 112
	i32.add 	$266=, $310, $266
	i32.add 	$push115=, $266, $pop457
	i64.load	$102=, 0($pop115)
	i64.const	$push456=, 128
	i64.lt_u	$86=, $45, $pop456
	i64.const	$push455=, 0
	i64.eq  	$90=, $45, $pop455
	i32.const	$push454=, 8
	i32.const	$267=, 48
	i32.add 	$267=, $310, $267
	i32.add 	$push118=, $267, $pop454
	i64.load	$45=, 0($pop118)
	i32.const	$push453=, 8
	i32.const	$268=, 176
	i32.add 	$268=, $310, $268
	i32.add 	$push121=, $268, $pop453
	i64.load	$103=, 0($pop121)
	i32.const	$push452=, 8
	i32.const	$269=, 288
	i32.add 	$269=, $310, $269
	i32.add 	$push126=, $269, $pop452
	i64.load	$104=, 0($pop126)
	i32.const	$push451=, 8
	i32.const	$270=, 272
	i32.add 	$270=, $310, $270
	i32.add 	$push127=, $270, $pop451
	i64.load	$105=, 0($pop127)
	i32.const	$push450=, 8
	i32.const	$271=, 304
	i32.add 	$271=, $310, $271
	i32.add 	$push129=, $271, $pop450
	i64.load	$106=, 0($pop129)
	i32.const	$push449=, 8
	i32.const	$272=, 128
	i32.add 	$272=, $310, $272
	i32.add 	$push152=, $272, $pop449
	i64.load	$117=, 0($pop152)
	i32.const	$push448=, 8
	i32.const	$273=, 144
	i32.add 	$273=, $310, $273
	i32.add 	$push153=, $273, $pop448
	i64.load	$118=, 0($pop153)
	i32.const	$push447=, 8
	i32.const	$274=, 160
	i32.add 	$274=, $310, $274
	i32.add 	$push155=, $274, $pop447
	i64.load	$119=, 0($pop155)
	i32.const	$push446=, 8
	i32.const	$275=, 0
	i32.add 	$275=, $310, $275
	i32.add 	$push158=, $275, $pop446
	i64.load	$120=, 0($pop158)
	i32.const	$push445=, 8
	i32.const	$276=, 16
	i32.add 	$276=, $310, $276
	i32.add 	$push159=, $276, $pop445
	i64.load	$121=, 0($pop159)
	i64.load	$114=, 64($310)
	i32.const	$push444=, 8
	i32.const	$277=, 64
	i32.add 	$277=, $310, $277
	i32.add 	$push164=, $277, $pop444
	i64.load	$123=, 0($pop164)
	i32.const	$push443=, 8
	i32.const	$278=, 32
	i32.add 	$278=, $310, $278
	i32.add 	$push161=, $278, $pop443
	i64.load	$122=, 0($pop161)
	i32.const	$push442=, 8
	i32.const	$279=, 896
	i32.add 	$279=, $310, $279
	i32.add 	$push169=, $279, $pop442
	i64.load	$124=, 0($pop169)
	i32.const	$push441=, 8
	i32.const	$280=, 256
	i32.add 	$280=, $310, $280
	i32.add 	$push173=, $280, $pop441
	i64.load	$125=, 0($pop173)
	i32.const	$push440=, 8
	i32.const	$281=, 192
	i32.add 	$281=, $310, $281
	i32.add 	$push201=, $281, $pop440
	i64.load	$140=, 0($pop201)
	i32.const	$push439=, 8
	i32.const	$282=, 208
	i32.add 	$282=, $310, $282
	i32.add 	$push202=, $282, $pop439
	i64.load	$141=, 0($pop202)
	i64.load	$111=, 0($310)
	i64.load	$112=, 16($310)
	i64.load	$113=, 32($310)
	i32.const	$push438=, 8
	i32.const	$283=, 224
	i32.add 	$283=, $310, $283
	i32.add 	$push204=, $283, $pop438
	i64.load	$142=, 0($pop204)
	i64.const	$push437=, 128
	i64.lt_u	$70=, $44, $pop437
	i64.load	$126=, 192($310)
	i64.load	$127=, 208($310)
	i64.load	$128=, 224($310)
	i64.load	$71=, 240($310)
	i64.load	$91=, 48($310)
	i64.load	$92=, 176($310)
	i64.const	$push436=, 128
	i64.lt_u	$67=, $43, $pop436
	i64.const	$push435=, 256
	i64.lt_u	$72=, $44, $pop435
	i64.load	$107=, 128($310)
	i64.load	$108=, 144($310)
	i64.load	$109=, 160($310)
	i64.const	$push434=, 0
	i64.eq  	$93=, $44, $pop434
	i64.const	$push433=, 0
	i64.eq  	$110=, $43, $pop433
	i32.const	$push432=, 8
	i32.const	$284=, 768
	i32.add 	$284=, $310, $284
	i32.add 	$push208=, $284, $pop432
	i64.load	$44=, 0($pop208)
	i32.const	$push431=, 8
	i32.const	$285=, 784
	i32.add 	$285=, $310, $285
	i32.add 	$push209=, $285, $pop431
	i64.load	$43=, 0($pop209)
	i32.const	$push430=, 8
	i32.const	$286=, 800
	i32.add 	$286=, $310, $286
	i32.add 	$push211=, $286, $pop430
	i64.load	$143=, 0($pop211)
	i32.const	$push429=, 8
	i32.const	$287=, 992
	i32.add 	$287=, $310, $287
	i32.add 	$push214=, $287, $pop429
	i64.load	$144=, 0($pop214)
	i32.const	$push428=, 8
	i32.const	$288=, 832
	i32.add 	$288=, $310, $288
	i32.add 	$push217=, $288, $pop428
	i64.load	$145=, 0($pop217)
	i32.const	$push427=, 8
	i32.const	$289=, 384
	i32.add 	$289=, $310, $289
	i32.add 	$push222=, $289, $pop427
	i64.load	$146=, 0($pop222)
	i32.const	$push426=, 8
	i32.const	$290=, 400
	i32.add 	$290=, $310, $290
	i32.add 	$push223=, $290, $pop426
	i64.load	$147=, 0($pop223)
	i64.load	$134=, 384($310)
	i64.load	$135=, 400($310)
	i32.const	$push425=, 8
	i32.const	$291=, 416
	i32.add 	$291=, $310, $291
	i32.add 	$push225=, $291, $pop425
	i64.load	$148=, 0($pop225)
	i64.load	$136=, 416($310)
	i64.load	$55=, 432($310)
	i64.const	$push424=, 128
	i64.lt_u	$54=, $37, $pop424
	i64.const	$push423=, 0
	i64.eq  	$137=, $37, $pop423
	i32.const	$push422=, 8
	i32.const	$292=, 320
	i32.add 	$292=, $310, $292
	i32.add 	$push228=, $292, $pop422
	i64.load	$37=, 0($pop228)
	i64.load	$50=, 352($310)
	i64.load	$51=, 336($310)
	i64.load	$52=, 368($310)
	i32.const	$push421=, 8
	i32.const	$293=, 448
	i32.add 	$293=, $310, $293
	i32.add 	$push231=, $293, $pop421
	i64.load	$149=, 0($pop231)
	i64.const	$push420=, 128
	i64.lt_u	$49=, $35, $pop420
	i64.load	$94=, 288($310)
	i64.load	$95=, 272($310)
	i64.load	$96=, 304($310)
	i64.load	$116=, 256($310)
	i64.load	$138=, 320($310)
	i64.load	$139=, 448($310)
	i64.const	$push419=, 0
	i64.eq  	$53=, $35, $pop419
	i64.const	$push418=, 256
	i64.lt_u	$56=, $35, $pop418
	i32.const	$push417=, 8
	i32.const	$294=, 736
	i32.add 	$294=, $310, $294
	i32.add 	$push248=, $294, $pop417
	i64.load	$35=, 0($pop248)
	i32.const	$push416=, 8
	i32.const	$295=, 720
	i32.add 	$295=, $310, $295
	i32.add 	$push249=, $295, $pop416
	i64.load	$157=, 0($pop249)
	i64.load	$58=, 864($310)
	i64.load	$59=, 848($310)
	i64.load	$60=, 880($310)
	i32.const	$push415=, 8
	i32.const	$296=, 752
	i32.add 	$296=, $310, $296
	i32.add 	$push251=, $296, $pop415
	i64.load	$158=, 0($pop251)
	i64.const	$push414=, 128
	i64.lt_u	$57=, $39, $pop414
	i64.load	$150=, 736($310)
	i64.load	$151=, 720($310)
	i64.load	$152=, 752($310)
	i64.const	$push413=, 0
	i64.eq  	$61=, $39, $pop413
	i32.const	$push412=, 8
	i32.const	$297=, 592
	i32.add 	$297=, $310, $297
	i32.add 	$push254=, $297, $pop412
	i64.load	$39=, 0($pop254)
	i32.const	$push411=, 8
	i32.const	$298=, 608
	i32.add 	$298=, $310, $298
	i32.add 	$push255=, $298, $pop411
	i64.load	$159=, 0($pop255)
	i32.const	$push410=, 8
	i32.const	$299=, 624
	i32.add 	$299=, $310, $299
	i32.add 	$push257=, $299, $pop410
	i64.load	$160=, 0($pop257)
	i32.const	$push409=, 8
	i32.const	$300=, 688
	i32.add 	$300=, $310, $300
	i32.add 	$push260=, $300, $pop409
	i64.load	$161=, 0($pop260)
	i32.const	$push408=, 8
	i32.const	$301=, 640
	i32.add 	$301=, $310, $301
	i32.add 	$push275=, $301, $pop408
	i64.load	$167=, 0($pop275)
	i32.const	$push407=, 8
	i32.const	$302=, 656
	i32.add 	$302=, $310, $302
	i32.add 	$push276=, $302, $pop407
	i64.load	$168=, 0($pop276)
	i64.load	$129=, 768($310)
	i64.load	$130=, 784($310)
	i64.load	$131=, 800($310)
	i32.const	$push406=, 8
	i32.const	$303=, 672
	i32.add 	$303=, $310, $303
	i32.add 	$push278=, $303, $pop406
	i64.load	$169=, 0($pop278)
	i64.load	$162=, 640($310)
	i64.load	$163=, 656($310)
	i64.load	$164=, 672($310)
	i64.load	$68=, 816($310)
	i64.load	$156=, 688($310)
	i32.const	$push405=, 8
	i32.const	$304=, 576
	i32.add 	$304=, $310, $304
	i32.add 	$push281=, $304, $pop405
	i64.load	$170=, 0($pop281)
	i64.load	$133=, 832($310)
	i64.load	$166=, 704($310)
	i32.const	$push404=, 8
	i32.const	$305=, 704
	i32.add 	$305=, $310, $305
	i32.add 	$push284=, $305, $pop404
	i64.load	$171=, 0($pop284)
	i32.const	$push403=, 8
	i32.const	$306=, 528
	i32.add 	$306=, $310, $306
	i32.add 	$push294=, $306, $pop403
	i64.load	$175=, 0($pop294)
	i32.const	$push402=, 8
	i32.const	$307=, 544
	i32.add 	$307=, $310, $307
	i32.add 	$push295=, $307, $pop402
	i64.load	$176=, 0($pop295)
	i32.const	$push401=, 8
	i32.const	$308=, 560
	i32.add 	$308=, $310, $308
	i32.add 	$push297=, $308, $pop401
	i64.load	$177=, 0($pop297)
	i64.load	$63=, 1008($310)
	i64.load	$64=, 960($310)
	i64.load	$65=, 976($310)
	i64.const	$push400=, 128
	i64.lt_u	$62=, $17, $pop400
	i64.const	$push399=, 0
	i64.eq  	$66=, $17, $pop399
	i64.const	$push398=, 256
	i64.lt_u	$69=, $17, $pop398
	i64.const	$push397=, 512
	i64.lt_u	$73=, $17, $pop397
	i64.load	$17=, 912($310)
	i64.load	$84=, 928($310)
	i64.load	$85=, 944($310)
	i64.load	$115=, 896($310)
	i64.load	$132=, 992($310)
	i64.load	$153=, 592($310)
	i64.load	$154=, 608($310)
	i64.load	$155=, 624($310)
	i64.load	$165=, 576($310)
	i64.load	$172=, 528($310)
	i64.load	$173=, 544($310)
	i64.load	$174=, 560($310)
	i64.load	$178=, 512($310)
	i32.const	$push396=, 8
	i32.add 	$push310=, $0, $pop396
	i32.const	$push395=, 8
	i32.const	$309=, 512
	i32.add 	$309=, $310, $309
	i32.add 	$push305=, $309, $pop395
	i64.load	$push306=, 0($pop305)
	i64.const	$push394=, 0
	i64.select	$push307=, $62, $pop306, $pop394
	i64.const	$push393=, 0
	i64.select	$push308=, $69, $pop307, $pop393
	i64.const	$push392=, 0
	i64.select	$push309=, $73, $pop308, $pop392
	i64.store	$discard=, 0($pop310), $pop309
	i64.const	$push391=, 0
	i64.select	$push302=, $62, $178, $pop391
	i64.const	$push390=, 0
	i64.select	$push303=, $69, $pop302, $pop390
	i64.const	$push389=, 0
	i64.select	$push304=, $73, $pop303, $pop389
	i64.store	$discard=, 0($0), $pop304
	i32.const	$push311=, 24
	i32.add 	$push312=, $0, $pop311
	i64.or  	$push296=, $175, $176
	i64.select	$push298=, $62, $pop296, $177
	i64.select	$push299=, $66, $4, $pop298
	i64.const	$push388=, 0
	i64.select	$push300=, $69, $pop299, $pop388
	i64.const	$push387=, 0
	i64.select	$push301=, $73, $pop300, $pop387
	i64.store	$discard=, 0($pop312), $pop301
	i32.const	$push313=, 16
	i32.add 	$push314=, $0, $pop313
	i64.or  	$push289=, $172, $173
	i64.select	$push290=, $62, $pop289, $174
	i64.select	$push291=, $66, $3, $pop290
	i64.const	$push386=, 0
	i64.select	$push292=, $69, $pop291, $pop386
	i64.const	$push385=, 0
	i64.select	$push293=, $73, $pop292, $pop385
	i64.store	$discard=, 0($pop314), $pop293
	i32.const	$push315=, 56
	i32.add 	$push316=, $0, $pop315
	i64.or  	$push256=, $39, $159
	i64.select	$push258=, $62, $pop256, $160
	i64.select	$push259=, $66, $8, $pop258
	i64.const	$push384=, 0
	i64.select	$push261=, $67, $161, $pop384
	i64.or  	$push262=, $pop259, $pop261
	i64.or  	$push250=, $157, $35
	i64.select	$push252=, $57, $pop250, $158
	i64.select	$push253=, $61, $4, $pop252
	i64.select	$push263=, $69, $pop262, $pop253
	i64.select	$push264=, $66, $8, $pop263
	i64.const	$push383=, 0
	i64.select	$push265=, $73, $pop264, $pop383
	i64.store	$discard=, 0($pop316), $pop265
	i32.const	$push317=, 48
	i32.add 	$push318=, $0, $pop317
	i64.or  	$push240=, $153, $154
	i64.select	$push241=, $62, $pop240, $155
	i64.select	$push242=, $66, $7, $pop241
	i64.const	$push382=, 0
	i64.select	$push243=, $67, $156, $pop382
	i64.or  	$push244=, $pop242, $pop243
	i64.or  	$push237=, $151, $150
	i64.select	$push238=, $57, $pop237, $152
	i64.select	$push239=, $61, $3, $pop238
	i64.select	$push245=, $69, $pop244, $pop239
	i64.select	$push246=, $66, $7, $pop245
	i64.const	$push381=, 0
	i64.select	$push247=, $73, $pop246, $pop381
	i64.store	$discard=, 0($pop318), $pop247
	i32.const	$push319=, 40
	i32.add 	$push320=, $0, $pop319
	i64.const	$push380=, 0
	i64.select	$push282=, $62, $170, $pop380
	i64.or  	$push277=, $167, $168
	i64.select	$push279=, $67, $pop277, $169
	i64.select	$push280=, $110, $2, $pop279
	i64.or  	$push283=, $pop282, $pop280
	i64.const	$push379=, 0
	i64.select	$push285=, $57, $171, $pop379
	i64.select	$push286=, $69, $pop283, $pop285
	i64.select	$push287=, $66, $6, $pop286
	i64.const	$push378=, 0
	i64.select	$push288=, $73, $pop287, $pop378
	i64.store	$discard=, 0($pop320), $pop288
	i32.const	$push321=, 32
	i32.add 	$push322=, $0, $pop321
	i64.const	$push377=, 0
	i64.select	$push269=, $62, $165, $pop377
	i64.or  	$push266=, $162, $163
	i64.select	$push267=, $67, $pop266, $164
	i64.select	$push268=, $110, $1, $pop267
	i64.or  	$push270=, $pop269, $pop268
	i64.const	$push376=, 0
	i64.select	$push271=, $57, $166, $pop376
	i64.select	$push272=, $69, $pop270, $pop271
	i64.select	$push273=, $66, $5, $pop272
	i64.const	$push375=, 0
	i64.select	$push274=, $73, $pop273, $pop375
	i64.store	$discard=, 0($pop322), $pop274
	i32.const	$push323=, 120
	i32.add 	$push324=, $0, $pop323
	i64.or  	$push71=, $79, $80
	i64.select	$push73=, $62, $pop71, $81
	i64.select	$push74=, $66, $16, $pop73
	i64.const	$push374=, 0
	i64.select	$push76=, $67, $82, $pop374
	i64.or  	$push77=, $pop74, $pop76
	i64.or  	$push65=, $77, $76
	i64.select	$push67=, $57, $pop65, $78
	i64.select	$push68=, $61, $12, $pop67
	i64.select	$push78=, $69, $pop77, $pop68
	i64.select	$push79=, $66, $16, $pop78
	i64.const	$push373=, 0
	i64.select	$push81=, $70, $83, $pop373
	i64.const	$push372=, 0
	i64.select	$push82=, $72, $pop81, $pop372
	i64.or  	$push83=, $pop79, $pop82
	i64.or  	$push54=, $40, $33
	i64.select	$push56=, $49, $pop54, $74
	i64.select	$push57=, $53, $8, $pop56
	i64.const	$push371=, 0
	i64.select	$push59=, $54, $75, $pop371
	i64.or  	$push60=, $pop57, $pop59
	i64.or  	$push48=, $38, $41
	i64.select	$push50=, $47, $pop48, $36
	i64.select	$push51=, $48, $4, $pop50
	i64.select	$push61=, $56, $pop60, $pop51
	i64.select	$push62=, $53, $8, $pop61
	i64.select	$push84=, $73, $pop83, $pop62
	i64.select	$push85=, $66, $16, $pop84
	i64.store	$discard=, 0($pop324), $pop85
	i32.const	$push325=, 112
	i32.add 	$push326=, $0, $pop325
	i64.or  	$push33=, $63, $64
	i64.select	$push34=, $62, $pop33, $65
	i64.select	$push35=, $66, $15, $pop34
	i64.const	$push370=, 0
	i64.select	$push36=, $67, $68, $pop370
	i64.or  	$push37=, $pop35, $pop36
	i64.or  	$push30=, $59, $58
	i64.select	$push31=, $57, $pop30, $60
	i64.select	$push32=, $61, $11, $pop31
	i64.select	$push38=, $69, $pop37, $pop32
	i64.select	$push39=, $66, $15, $pop38
	i64.const	$push369=, 0
	i64.select	$push40=, $70, $71, $pop369
	i64.const	$push368=, 0
	i64.select	$push41=, $72, $pop40, $pop368
	i64.or  	$push42=, $pop39, $pop41
	i64.or  	$push23=, $51, $50
	i64.select	$push24=, $49, $pop23, $52
	i64.select	$push25=, $53, $7, $pop24
	i64.const	$push367=, 0
	i64.select	$push26=, $54, $55, $pop367
	i64.or  	$push27=, $pop25, $pop26
	i64.or  	$push19=, $34, $42
	i64.select	$push20=, $47, $pop19, $46
	i64.select	$push22=, $48, $3, $pop20
	i64.select	$push28=, $56, $pop27, $pop22
	i64.select	$push29=, $53, $7, $pop28
	i64.select	$push43=, $73, $pop42, $pop29
	i64.select	$push44=, $66, $15, $pop43
	i64.store	$discard=, 0($pop326), $pop44
	i32.const	$push327=, 104
	i32.add 	$push328=, $0, $pop327
	i64.const	$push366=, 0
	i64.select	$push215=, $62, $144, $pop366
	i64.or  	$push210=, $44, $43
	i64.select	$push212=, $67, $pop210, $143
	i64.select	$push213=, $110, $10, $pop212
	i64.or  	$push216=, $pop215, $pop213
	i64.const	$push365=, 0
	i64.select	$push218=, $57, $145, $pop365
	i64.select	$push219=, $69, $pop216, $pop218
	i64.select	$push220=, $66, $14, $pop219
	i64.or  	$push203=, $140, $141
	i64.select	$push205=, $70, $pop203, $142
	i64.select	$push206=, $93, $6, $pop205
	i64.const	$push364=, 0
	i64.select	$push207=, $72, $pop206, $pop364
	i64.or  	$push221=, $pop220, $pop207
	i64.const	$push363=, 0
	i64.select	$push229=, $49, $37, $pop363
	i64.or  	$push224=, $146, $147
	i64.select	$push226=, $54, $pop224, $148
	i64.select	$push227=, $137, $2, $pop226
	i64.or  	$push230=, $pop229, $pop227
	i64.const	$push362=, 0
	i64.select	$push232=, $47, $149, $pop362
	i64.select	$push233=, $56, $pop230, $pop232
	i64.select	$push234=, $53, $6, $pop233
	i64.select	$push235=, $73, $pop221, $pop234
	i64.select	$push236=, $66, $14, $pop235
	i64.store	$discard=, 0($pop328), $pop236
	i32.const	$push329=, 96
	i32.add 	$push330=, $0, $pop329
	i64.const	$push361=, 0
	i64.select	$push185=, $62, $132, $pop361
	i64.or  	$push182=, $129, $130
	i64.select	$push183=, $67, $pop182, $131
	i64.select	$push184=, $110, $9, $pop183
	i64.or  	$push186=, $pop185, $pop184
	i64.const	$push360=, 0
	i64.select	$push187=, $57, $133, $pop360
	i64.select	$push188=, $69, $pop186, $pop187
	i64.select	$push189=, $66, $13, $pop188
	i64.or  	$push178=, $126, $127
	i64.select	$push179=, $70, $pop178, $128
	i64.select	$push180=, $93, $5, $pop179
	i64.const	$push359=, 0
	i64.select	$push181=, $72, $pop180, $pop359
	i64.or  	$push190=, $pop189, $pop181
	i64.const	$push358=, 0
	i64.select	$push194=, $49, $138, $pop358
	i64.or  	$push191=, $134, $135
	i64.select	$push192=, $54, $pop191, $136
	i64.select	$push193=, $137, $1, $pop192
	i64.or  	$push195=, $pop194, $pop193
	i64.const	$push357=, 0
	i64.select	$push196=, $47, $139, $pop357
	i64.select	$push197=, $56, $pop195, $pop196
	i64.select	$push198=, $53, $5, $pop197
	i64.select	$push199=, $73, $pop190, $pop198
	i64.select	$push200=, $66, $13, $pop199
	i64.store	$discard=, 0($pop330), $pop200
	i32.const	$push331=, 72
	i32.add 	$push332=, $0, $pop331
	i64.const	$push356=, 0
	i64.select	$push170=, $62, $124, $pop356
	i64.const	$push355=, 0
	i64.select	$push171=, $69, $pop170, $pop355
	i64.or  	$push160=, $120, $121
	i64.select	$push162=, $70, $pop160, $122
	i64.select	$push163=, $93, $2, $pop162
	i64.const	$push354=, 0
	i64.select	$push165=, $86, $123, $pop354
	i64.or  	$push166=, $pop163, $pop165
	i64.or  	$push154=, $117, $118
	i64.select	$push156=, $67, $pop154, $119
	i64.select	$push157=, $110, $6, $pop156
	i64.select	$push167=, $72, $pop166, $pop157
	i64.select	$push168=, $93, $2, $pop167
	i64.or  	$push172=, $pop171, $pop168
	i64.const	$push353=, 0
	i64.select	$push174=, $49, $125, $pop353
	i64.const	$push352=, 0
	i64.select	$push175=, $56, $pop174, $pop352
	i64.select	$push176=, $73, $pop172, $pop175
	i64.select	$push177=, $66, $10, $pop176
	i64.store	$discard=, 0($pop332), $pop177
	i32.const	$push333=, 64
	i32.add 	$push334=, $0, $pop333
	i64.const	$push351=, 0
	i64.select	$push145=, $62, $115, $pop351
	i64.const	$push350=, 0
	i64.select	$push146=, $69, $pop145, $pop350
	i64.or  	$push138=, $111, $112
	i64.select	$push139=, $70, $pop138, $113
	i64.select	$push140=, $93, $1, $pop139
	i64.const	$push349=, 0
	i64.select	$push141=, $86, $114, $pop349
	i64.or  	$push142=, $pop140, $pop141
	i64.or  	$push135=, $107, $108
	i64.select	$push136=, $67, $pop135, $109
	i64.select	$push137=, $110, $5, $pop136
	i64.select	$push143=, $72, $pop142, $pop137
	i64.select	$push144=, $93, $1, $pop143
	i64.or  	$push147=, $pop146, $pop144
	i64.const	$push348=, 0
	i64.select	$push148=, $49, $116, $pop348
	i64.const	$push347=, 0
	i64.select	$push149=, $56, $pop148, $pop347
	i64.select	$push150=, $73, $pop147, $pop149
	i64.select	$push151=, $66, $9, $pop150
	i64.store	$discard=, 0($pop334), $pop151
	i32.const	$push335=, 88
	i32.add 	$push336=, $0, $pop335
	i64.or  	$push107=, $97, $98
	i64.select	$push109=, $62, $pop107, $99
	i64.select	$push110=, $66, $12, $pop109
	i64.const	$push346=, 0
	i64.select	$push111=, $69, $pop110, $pop346
	i64.const	$push345=, 0
	i64.select	$push119=, $70, $45, $pop345
	i64.or  	$push114=, $100, $101
	i64.select	$push116=, $86, $pop114, $102
	i64.select	$push117=, $90, $8, $pop116
	i64.or  	$push120=, $pop119, $pop117
	i64.const	$push344=, 0
	i64.select	$push122=, $67, $103, $pop344
	i64.select	$push123=, $72, $pop120, $pop122
	i64.select	$push124=, $93, $4, $pop123
	i64.or  	$push125=, $pop111, $pop124
	i64.or  	$push128=, $105, $104
	i64.select	$push130=, $49, $pop128, $106
	i64.select	$push131=, $53, $4, $pop130
	i64.const	$push343=, 0
	i64.select	$push132=, $56, $pop131, $pop343
	i64.select	$push133=, $73, $pop125, $pop132
	i64.select	$push134=, $66, $12, $pop133
	i64.store	$discard=, 0($pop336), $pop134
	i32.const	$push337=, 80
	i32.add 	$push338=, $0, $pop337
	i64.or  	$push86=, $17, $84
	i64.select	$push87=, $62, $pop86, $85
	i64.select	$push88=, $66, $11, $pop87
	i64.const	$push342=, 0
	i64.select	$push89=, $69, $pop88, $pop342
	i64.const	$push341=, 0
	i64.select	$push93=, $70, $91, $pop341
	i64.or  	$push90=, $87, $88
	i64.select	$push91=, $86, $pop90, $89
	i64.select	$push92=, $90, $7, $pop91
	i64.or  	$push94=, $pop93, $pop92
	i64.const	$push340=, 0
	i64.select	$push95=, $67, $92, $pop340
	i64.select	$push96=, $72, $pop94, $pop95
	i64.select	$push97=, $93, $3, $pop96
	i64.or  	$push98=, $pop89, $pop97
	i64.or  	$push99=, $95, $94
	i64.select	$push100=, $49, $pop99, $96
	i64.select	$push101=, $53, $3, $pop100
	i64.const	$push339=, 0
	i64.select	$push102=, $56, $pop101, $pop339
	i64.select	$push103=, $73, $pop98, $pop102
	i64.select	$push104=, $66, $11, $pop103
	i64.store	$discard=, 0($pop338), $pop104
	i32.const	$181=, 1024
	i32.add 	$310=, $310, $181
	i32.const	$181=, __stack_pointer
	i32.store	$310=, 0($181), $310
	return
	.endfunc
.Lfunc_end5:
	.size	bigshift, .Lfunc_end5-bigshift


