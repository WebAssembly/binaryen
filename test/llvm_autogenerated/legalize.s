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
.Lfunc_end1:
	.size	shl_i53, .Lfunc_end1-shl_i53

	.globl	sext_in_reg_i32_i64
	.type	sext_in_reg_i32_i64,@function
sext_in_reg_i32_i64:
	.param  	i64
	.result 	i64
	.local  	i64
	i64.const	$1=, 32
	i64.shl 	$push0=, $0, $1
	i64.shr_s	$push1=, $pop0, $1
	return  	$pop1
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
.Lfunc_end4:
	.size	fpconv_f64_f32, .Lfunc_end4-fpconv_f64_f32

	.globl	bigshift
	.type	bigshift,@function
bigshift:
	.param  	i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i32, i32, i64, i64, i64, i32, i32, i64, i32, i32, i64, i64, i64, i32, i32, i64, i64, i64, i32, i32, i64, i32, i32, i64, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i32, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	i32.const	$181=, __stack_pointer
	i32.load	$181=, 0($181)
	i32.const	$182=, 1024
	i32.sub 	$279=, $181, $182
	i32.const	$182=, __stack_pointer
	i32.store	$279=, 0($182), $279
	i64.const	$push0=, 896
	i64.sub 	$push1=, $pop0, $17
	i32.const	$184=, 480
	i32.add 	$184=, $279, $184
	call    	__lshrti3, $184, $1, $2, $pop1
	i64.const	$push2=, -768
	i64.add 	$33=, $17, $pop2
	i32.const	$185=, 464
	i32.add 	$185=, $279, $185
	call    	__ashlti3, $185, $3, $4, $33
	i64.const	$push3=, -896
	i64.add 	$push4=, $17, $pop3
	i32.const	$186=, 496
	i32.add 	$186=, $279, $186
	call    	__ashlti3, $186, $1, $2, $pop4
	i64.const	$push5=, 640
	i64.sub 	$34=, $pop5, $17
	i32.const	$187=, 352
	i32.add 	$187=, $279, $187
	call    	__lshrti3, $187, $5, $6, $34
	i64.const	$push6=, -512
	i64.add 	$35=, $17, $pop6
	i32.const	$188=, 336
	i32.add 	$188=, $279, $188
	call    	__ashlti3, $188, $7, $8, $35
	i64.const	$push7=, -640
	i64.add 	$36=, $17, $pop7
	i32.const	$189=, 368
	i32.add 	$189=, $279, $189
	call    	__ashlti3, $189, $5, $6, $36
	i64.const	$push8=, 768
	i64.sub 	$37=, $pop8, $17
	i32.const	$190=, 432
	i32.add 	$190=, $279, $190
	call    	__lshrti3, $190, $3, $4, $37
	i64.const	$38=, 384
	i64.sub 	$39=, $38, $17
	i32.const	$191=, 864
	i32.add 	$191=, $279, $191
	call    	__lshrti3, $191, $9, $10, $39
	i64.const	$push9=, -256
	i64.add 	$40=, $17, $pop9
	i32.const	$192=, 848
	i32.add 	$192=, $279, $192
	call    	__ashlti3, $192, $11, $12, $40
	i64.const	$push10=, -384
	i64.add 	$41=, $17, $pop10
	i32.const	$193=, 880
	i32.add 	$193=, $279, $193
	call    	__ashlti3, $193, $9, $10, $41
	i32.const	$194=, 1008
	i32.add 	$194=, $279, $194
	call    	__ashlti3, $194, $15, $16, $17
	i64.const	$42=, 128
	i64.sub 	$51=, $42, $17
	i32.const	$195=, 960
	i32.add 	$195=, $279, $195
	call    	__lshrti3, $195, $13, $14, $51
	i64.const	$push11=, -128
	i64.add 	$43=, $17, $pop11
	i32.const	$196=, 976
	i32.add 	$196=, $279, $196
	call    	__ashlti3, $196, $13, $14, $43
	i64.const	$44=, 256
	i64.sub 	$45=, $44, $17
	i32.const	$197=, 816
	i32.add 	$197=, $279, $197
	call    	__lshrti3, $197, $11, $12, $45
	i64.const	$46=, 512
	i64.sub 	$47=, $46, $17
	i32.const	$198=, 240
	i32.add 	$198=, $279, $198
	call    	__lshrti3, $198, $7, $8, $47
	i32.const	$199=, 912
	i32.add 	$199=, $279, $199
	call    	__ashlti3, $199, $11, $12, $17
	i32.const	$200=, 928
	i32.add 	$200=, $279, $200
	call    	__lshrti3, $200, $9, $10, $51
	i32.const	$201=, 944
	i32.add 	$201=, $279, $201
	call    	__ashlti3, $201, $9, $10, $43
	i64.sub 	$48=, $44, $47
	i32.const	$202=, 80
	i32.add 	$202=, $279, $202
	call    	__ashlti3, $202, $7, $8, $48
	i64.sub 	$push12=, $42, $48
	i32.const	$203=, 96
	i32.add 	$203=, $279, $203
	call    	__lshrti3, $203, $5, $6, $pop12
	i64.sub 	$49=, $42, $47
	i32.const	$204=, 112
	i32.add 	$204=, $279, $204
	call    	__ashlti3, $204, $5, $6, $49
	i32.const	$205=, 48
	i32.add 	$205=, $279, $205
	call    	__lshrti3, $205, $3, $4, $47
	i32.const	$206=, 176
	i32.add 	$206=, $279, $206
	call    	__lshrti3, $206, $7, $8, $45
	i32.const	$207=, 288
	i32.add 	$207=, $279, $207
	call    	__lshrti3, $207, $1, $2, $34
	i32.const	$208=, 272
	i32.add 	$208=, $279, $208
	call    	__ashlti3, $208, $3, $4, $35
	i32.const	$209=, 304
	i32.add 	$209=, $279, $209
	call    	__ashlti3, $209, $1, $2, $36
	i32.const	$210=, 128
	i32.add 	$210=, $279, $210
	call    	__lshrti3, $210, $5, $6, $45
	i64.sub 	$push13=, $38, $47
	i32.const	$211=, 144
	i32.add 	$211=, $279, $211
	call    	__ashlti3, $211, $7, $8, $pop13
	i32.const	$212=, 160
	i32.add 	$212=, $279, $212
	call    	__lshrti3, $212, $7, $8, $51
	i32.const	$213=, 0
	i32.add 	$213=, $279, $213
	call    	__lshrti3, $213, $1, $2, $47
	i32.const	$214=, 16
	i32.add 	$214=, $279, $214
	call    	__ashlti3, $214, $3, $4, $49
	i32.const	$215=, 32
	i32.add 	$215=, $279, $215
	call    	__lshrti3, $215, $3, $4, $39
	i32.const	$216=, 64
	i32.add 	$216=, $279, $216
	call    	__ashlti3, $216, $5, $6, $48
	i32.const	$217=, 896
	i32.add 	$217=, $279, $217
	call    	__ashlti3, $217, $9, $10, $17
	i32.const	$218=, 256
	i32.add 	$218=, $279, $218
	call    	__ashlti3, $218, $1, $2, $35
	i32.const	$219=, 192
	i32.add 	$219=, $279, $219
	call    	__lshrti3, $219, $5, $6, $47
	i32.const	$220=, 208
	i32.add 	$220=, $279, $220
	call    	__ashlti3, $220, $7, $8, $49
	i32.const	$221=, 224
	i32.add 	$221=, $279, $221
	call    	__lshrti3, $221, $7, $8, $39
	i32.const	$222=, 768
	i32.add 	$222=, $279, $222
	call    	__lshrti3, $222, $9, $10, $45
	i64.sub 	$49=, $42, $45
	i32.const	$223=, 784
	i32.add 	$223=, $279, $223
	call    	__ashlti3, $223, $11, $12, $49
	i32.const	$224=, 800
	i32.add 	$224=, $279, $224
	call    	__lshrti3, $224, $11, $12, $51
	i32.const	$225=, 992
	i32.add 	$225=, $279, $225
	call    	__ashlti3, $225, $13, $14, $17
	i32.const	$226=, 832
	i32.add 	$226=, $279, $226
	call    	__ashlti3, $226, $9, $10, $40
	i32.const	$227=, 384
	i32.add 	$227=, $279, $227
	call    	__lshrti3, $227, $1, $2, $37
	i64.sub 	$push14=, $42, $37
	i32.const	$228=, 400
	i32.add 	$228=, $279, $228
	call    	__ashlti3, $228, $3, $4, $pop14
	i32.const	$229=, 416
	i32.add 	$229=, $279, $229
	call    	__lshrti3, $229, $3, $4, $34
	i32.const	$230=, 320
	i32.add 	$230=, $279, $230
	call    	__ashlti3, $230, $5, $6, $35
	i32.const	$231=, 448
	i32.add 	$231=, $279, $231
	call    	__ashlti3, $231, $1, $2, $33
	i32.const	$232=, 736
	i32.add 	$232=, $279, $232
	call    	__lshrti3, $232, $1, $2, $39
	i32.const	$233=, 720
	i32.add 	$233=, $279, $233
	call    	__ashlti3, $233, $3, $4, $40
	i32.const	$234=, 752
	i32.add 	$234=, $279, $234
	call    	__ashlti3, $234, $1, $2, $41
	i32.const	$235=, 592
	i32.add 	$235=, $279, $235
	call    	__ashlti3, $235, $7, $8, $17
	i32.const	$236=, 608
	i32.add 	$236=, $279, $236
	call    	__lshrti3, $236, $5, $6, $51
	i32.const	$237=, 624
	i32.add 	$237=, $279, $237
	call    	__ashlti3, $237, $5, $6, $43
	i32.const	$238=, 688
	i32.add 	$238=, $279, $238
	call    	__lshrti3, $238, $3, $4, $45
	i32.const	$239=, 640
	i32.add 	$239=, $279, $239
	call    	__lshrti3, $239, $1, $2, $45
	i32.const	$240=, 656
	i32.add 	$240=, $279, $240
	call    	__ashlti3, $240, $3, $4, $49
	i32.const	$241=, 672
	i32.add 	$241=, $279, $241
	call    	__lshrti3, $241, $3, $4, $51
	i32.const	$242=, 576
	i32.add 	$242=, $279, $242
	call    	__ashlti3, $242, $5, $6, $17
	i32.const	$243=, 704
	i32.add 	$243=, $279, $243
	call    	__ashlti3, $243, $1, $2, $40
	i32.const	$244=, 528
	i32.add 	$244=, $279, $244
	call    	__ashlti3, $244, $3, $4, $17
	i32.const	$245=, 544
	i32.add 	$245=, $279, $245
	call    	__lshrti3, $245, $1, $2, $51
	i32.const	$246=, 560
	i32.add 	$246=, $279, $246
	call    	__ashlti3, $246, $1, $2, $43
	i32.const	$247=, 512
	i32.add 	$247=, $279, $247
	call    	__ashlti3, $247, $1, $2, $17
	i32.const	$78=, 8
	i32.const	$248=, 480
	i32.add 	$248=, $279, $248
	i32.add 	$push40=, $248, $78
	i64.load	$39=, 0($pop40)
	i32.const	$249=, 464
	i32.add 	$249=, $279, $249
	i32.add 	$push41=, $249, $78
	i64.load	$43=, 0($pop41)
	i64.load	$34=, 480($279)
	i64.load	$49=, 464($279)
	i64.load	$36=, 496($279)
	i32.const	$250=, 496
	i32.add 	$250=, $279, $250
	i32.add 	$push43=, $250, $78
	i64.load	$38=, 0($pop43)
	i64.lt_u	$50=, $33, $42
	i64.const	$51=, 0
	i64.eq  	$52=, $33, $51
	i32.const	$251=, 352
	i32.add 	$251=, $279, $251
	i32.add 	$push46=, $251, $78
	i64.load	$33=, 0($pop46)
	i32.const	$252=, 336
	i32.add 	$252=, $279, $252
	i32.add 	$push47=, $252, $78
	i64.load	$41=, 0($pop47)
	i32.const	$253=, 368
	i32.add 	$253=, $279, $253
	i32.add 	$push49=, $253, $78
	i64.load	$79=, 0($pop49)
	i32.const	$254=, 432
	i32.add 	$254=, $279, $254
	i32.add 	$push52=, $254, $78
	i64.load	$80=, 0($pop52)
	i32.const	$255=, 864
	i32.add 	$255=, $279, $255
	i32.add 	$push57=, $255, $78
	i64.load	$81=, 0($pop57)
	i32.const	$256=, 848
	i32.add 	$256=, $279, $256
	i32.add 	$push58=, $256, $78
	i64.load	$82=, 0($pop58)
	i32.const	$257=, 880
	i32.add 	$257=, $279, $257
	i32.add 	$push60=, $257, $78
	i64.load	$83=, 0($pop60)
	i32.const	$258=, 1008
	i32.add 	$258=, $279, $258
	i32.add 	$push63=, $258, $78
	i64.load	$84=, 0($pop63)
	i32.const	$259=, 960
	i32.add 	$259=, $279, $259
	i32.add 	$push64=, $259, $78
	i64.load	$85=, 0($pop64)
	i32.const	$260=, 976
	i32.add 	$260=, $279, $260
	i32.add 	$push66=, $260, $78
	i64.load	$86=, 0($pop66)
	i32.const	$261=, 816
	i32.add 	$261=, $279, $261
	i32.add 	$push69=, $261, $78
	i64.load	$87=, 0($pop69)
	i32.const	$262=, 240
	i32.add 	$262=, $279, $262
	i32.add 	$push74=, $262, $78
	i64.load	$88=, 0($pop74)
	i32.const	$263=, 912
	i32.add 	$263=, $279, $263
	i32.add 	$push99=, $263, $78
	i64.load	$100=, 0($pop99)
	i32.const	$264=, 928
	i32.add 	$264=, $279, $264
	i32.add 	$push100=, $264, $78
	i64.load	$101=, 0($pop100)
	i32.const	$265=, 944
	i32.add 	$265=, $279, $265
	i32.add 	$push102=, $265, $78
	i64.load	$102=, 0($pop102)
	i32.const	$266=, 80
	i32.add 	$266=, $279, $266
	i32.add 	$push106=, $266, $78
	i64.load	$103=, 0($pop106)
	i32.const	$267=, 96
	i32.add 	$267=, $279, $267
	i32.add 	$push107=, $267, $78
	i64.load	$104=, 0($pop107)
	i64.load	$90=, 80($279)
	i64.load	$91=, 96($279)
	i64.load	$92=, 112($279)
	i32.const	$268=, 112
	i32.add 	$268=, $279, $268
	i32.add 	$push109=, $268, $78
	i64.load	$105=, 0($pop109)
	i64.lt_u	$89=, $48, $42
	i64.eq  	$93=, $48, $51
	i32.const	$269=, 48
	i32.add 	$269=, $279, $269
	i32.add 	$push112=, $269, $78
	i64.load	$48=, 0($pop112)
	i32.const	$270=, 176
	i32.add 	$270=, $279, $270
	i32.add 	$push115=, $270, $78
	i64.load	$106=, 0($pop115)
	i32.const	$271=, 288
	i32.add 	$271=, $279, $271
	i32.add 	$push120=, $271, $78
	i64.load	$107=, 0($pop120)
	i32.const	$272=, 272
	i32.add 	$272=, $279, $272
	i32.add 	$push121=, $272, $78
	i64.load	$108=, 0($pop121)
	i32.const	$273=, 304
	i32.add 	$273=, $279, $273
	i32.add 	$push123=, $273, $78
	i64.load	$109=, 0($pop123)
	i32.const	$274=, 128
	i32.add 	$274=, $279, $274
	i32.add 	$push146=, $274, $78
	i64.load	$119=, 0($pop146)
	i32.const	$275=, 144
	i32.add 	$275=, $279, $275
	i32.add 	$push147=, $275, $78
	i64.load	$120=, 0($pop147)
	i32.const	$276=, 160
	i32.add 	$276=, $279, $276
	i32.add 	$push149=, $276, $78
	i64.load	$121=, 0($pop149)
	i32.const	$277=, 0
	i32.add 	$277=, $279, $277
	i32.add 	$push152=, $277, $78
	i64.load	$122=, 0($pop152)
	i32.const	$278=, 16
	i32.add 	$278=, $279, $278
	i32.add 	$push153=, $278, $78
	i64.load	$123=, 0($pop153)
	i64.load	$117=, 64($279)
	i32.const	$279=, 64
	i32.add 	$279=, $279, $279
	i32.add 	$push158=, $279, $78
	i64.load	$125=, 0($pop158)
	i32.const	$280=, 32
	i32.add 	$280=, $279, $280
	i32.add 	$push155=, $280, $78
	i64.load	$124=, 0($pop155)
	i32.const	$281=, 896
	i32.add 	$281=, $279, $281
	i32.add 	$push163=, $281, $78
	i64.load	$126=, 0($pop163)
	i32.const	$282=, 256
	i32.add 	$282=, $279, $282
	i32.add 	$push167=, $282, $78
	i64.load	$127=, 0($pop167)
	i32.const	$283=, 192
	i32.add 	$283=, $279, $283
	i32.add 	$push195=, $283, $78
	i64.load	$142=, 0($pop195)
	i32.const	$284=, 208
	i32.add 	$284=, $279, $284
	i32.add 	$push196=, $284, $78
	i64.load	$143=, 0($pop196)
	i64.load	$114=, 0($279)
	i64.load	$115=, 16($279)
	i64.load	$116=, 32($279)
	i32.const	$285=, 224
	i32.add 	$285=, $279, $285
	i32.add 	$push198=, $285, $78
	i64.load	$144=, 0($pop198)
	i64.lt_u	$74=, $47, $42
	i64.load	$128=, 192($279)
	i64.load	$129=, 208($279)
	i64.load	$130=, 224($279)
	i64.load	$75=, 240($279)
	i64.load	$94=, 48($279)
	i64.load	$95=, 176($279)
	i64.lt_u	$71=, $45, $42
	i64.lt_u	$76=, $47, $44
	i64.load	$110=, 128($279)
	i64.load	$111=, 144($279)
	i64.load	$112=, 160($279)
	i64.eq  	$96=, $47, $51
	i64.eq  	$113=, $45, $51
	i32.const	$286=, 768
	i32.add 	$286=, $279, $286
	i32.add 	$push202=, $286, $78
	i64.load	$47=, 0($pop202)
	i32.const	$287=, 784
	i32.add 	$287=, $279, $287
	i32.add 	$push203=, $287, $78
	i64.load	$45=, 0($pop203)
	i32.const	$288=, 800
	i32.add 	$288=, $279, $288
	i32.add 	$push205=, $288, $78
	i64.load	$145=, 0($pop205)
	i32.const	$289=, 992
	i32.add 	$289=, $279, $289
	i32.add 	$push208=, $289, $78
	i64.load	$146=, 0($pop208)
	i32.const	$290=, 832
	i32.add 	$290=, $279, $290
	i32.add 	$push211=, $290, $78
	i64.load	$147=, 0($pop211)
	i32.const	$291=, 384
	i32.add 	$291=, $279, $291
	i32.add 	$push216=, $291, $78
	i64.load	$148=, 0($pop216)
	i32.const	$292=, 400
	i32.add 	$292=, $279, $292
	i32.add 	$push217=, $292, $78
	i64.load	$149=, 0($pop217)
	i64.load	$136=, 384($279)
	i64.load	$137=, 400($279)
	i32.const	$293=, 416
	i32.add 	$293=, $279, $293
	i32.add 	$push219=, $293, $78
	i64.load	$150=, 0($pop219)
	i64.load	$138=, 416($279)
	i64.load	$59=, 432($279)
	i64.lt_u	$58=, $37, $42
	i64.eq  	$139=, $37, $51
	i32.const	$294=, 320
	i32.add 	$294=, $279, $294
	i32.add 	$push222=, $294, $78
	i64.load	$37=, 0($pop222)
	i64.load	$54=, 352($279)
	i64.load	$55=, 336($279)
	i64.load	$56=, 368($279)
	i32.const	$295=, 448
	i32.add 	$295=, $279, $295
	i32.add 	$push225=, $295, $78
	i64.load	$151=, 0($pop225)
	i64.lt_u	$53=, $35, $42
	i64.load	$97=, 288($279)
	i64.load	$98=, 272($279)
	i64.load	$99=, 304($279)
	i64.load	$118=, 256($279)
	i64.load	$140=, 320($279)
	i64.load	$141=, 448($279)
	i64.eq  	$57=, $35, $51
	i64.lt_u	$60=, $35, $44
	i32.const	$296=, 736
	i32.add 	$296=, $279, $296
	i32.add 	$push242=, $296, $78
	i64.load	$35=, 0($pop242)
	i32.const	$297=, 720
	i32.add 	$297=, $279, $297
	i32.add 	$push243=, $297, $78
	i64.load	$159=, 0($pop243)
	i64.load	$62=, 864($279)
	i64.load	$63=, 848($279)
	i64.load	$64=, 880($279)
	i32.const	$298=, 752
	i32.add 	$298=, $279, $298
	i32.add 	$push245=, $298, $78
	i64.load	$160=, 0($pop245)
	i64.lt_u	$61=, $40, $42
	i64.load	$152=, 736($279)
	i64.load	$153=, 720($279)
	i64.load	$154=, 752($279)
	i64.eq  	$65=, $40, $51
	i32.const	$299=, 592
	i32.add 	$299=, $279, $299
	i32.add 	$push248=, $299, $78
	i64.load	$40=, 0($pop248)
	i32.const	$300=, 608
	i32.add 	$300=, $279, $300
	i32.add 	$push249=, $300, $78
	i64.load	$161=, 0($pop249)
	i32.const	$301=, 624
	i32.add 	$301=, $279, $301
	i32.add 	$push251=, $301, $78
	i64.load	$162=, 0($pop251)
	i32.const	$302=, 688
	i32.add 	$302=, $279, $302
	i32.add 	$push254=, $302, $78
	i64.load	$163=, 0($pop254)
	i32.const	$303=, 640
	i32.add 	$303=, $279, $303
	i32.add 	$push269=, $303, $78
	i64.load	$169=, 0($pop269)
	i32.const	$304=, 656
	i32.add 	$304=, $279, $304
	i32.add 	$push270=, $304, $78
	i64.load	$170=, 0($pop270)
	i64.load	$131=, 768($279)
	i64.load	$132=, 784($279)
	i64.load	$133=, 800($279)
	i32.const	$305=, 672
	i32.add 	$305=, $279, $305
	i32.add 	$push272=, $305, $78
	i64.load	$171=, 0($pop272)
	i64.load	$164=, 640($279)
	i64.load	$165=, 656($279)
	i64.load	$166=, 672($279)
	i64.load	$72=, 816($279)
	i64.load	$158=, 688($279)
	i32.const	$306=, 576
	i32.add 	$306=, $279, $306
	i32.add 	$push275=, $306, $78
	i64.load	$172=, 0($pop275)
	i64.load	$135=, 832($279)
	i64.load	$168=, 704($279)
	i32.const	$307=, 704
	i32.add 	$307=, $279, $307
	i32.add 	$push278=, $307, $78
	i64.load	$173=, 0($pop278)
	i32.const	$308=, 528
	i32.add 	$308=, $279, $308
	i32.add 	$push288=, $308, $78
	i64.load	$177=, 0($pop288)
	i32.const	$309=, 544
	i32.add 	$309=, $279, $309
	i32.add 	$push289=, $309, $78
	i64.load	$178=, 0($pop289)
	i32.const	$310=, 560
	i32.add 	$310=, $279, $310
	i32.add 	$push291=, $310, $78
	i64.load	$179=, 0($pop291)
	i64.load	$67=, 1008($279)
	i64.load	$68=, 960($279)
	i64.load	$69=, 976($279)
	i64.lt_u	$66=, $17, $42
	i64.eq  	$70=, $17, $51
	i64.lt_u	$73=, $17, $44
	i64.lt_u	$77=, $17, $46
	i64.load	$17=, 912($279)
	i64.load	$42=, 928($279)
	i64.load	$44=, 944($279)
	i64.load	$46=, 896($279)
	i64.load	$134=, 992($279)
	i64.load	$155=, 592($279)
	i64.load	$156=, 608($279)
	i64.load	$157=, 624($279)
	i64.load	$167=, 576($279)
	i64.load	$174=, 528($279)
	i64.load	$175=, 544($279)
	i64.load	$176=, 560($279)
	i64.load	$180=, 512($279)
	i32.add 	$push304=, $0, $78
	i32.const	$311=, 512
	i32.add 	$311=, $279, $311
	i32.add 	$push299=, $311, $78
	i64.load	$push300=, 0($pop299)
	i64.select	$push301=, $66, $pop300, $51
	i64.select	$push302=, $73, $pop301, $51
	i64.select	$push303=, $77, $pop302, $51
	i64.store	$discard=, 0($pop304), $pop303
	i64.select	$push296=, $66, $180, $51
	i64.select	$push297=, $73, $pop296, $51
	i64.select	$push298=, $77, $pop297, $51
	i64.store	$discard=, 0($0), $pop298
	i32.const	$push305=, 24
	i32.add 	$push306=, $0, $pop305
	i64.or  	$push290=, $177, $178
	i64.select	$push292=, $66, $pop290, $179
	i64.select	$push293=, $70, $4, $pop292
	i64.select	$push294=, $73, $pop293, $51
	i64.select	$push295=, $77, $pop294, $51
	i64.store	$discard=, 0($pop306), $pop295
	i32.const	$push307=, 16
	i32.add 	$push308=, $0, $pop307
	i64.or  	$push283=, $174, $175
	i64.select	$push284=, $66, $pop283, $176
	i64.select	$push285=, $70, $3, $pop284
	i64.select	$push286=, $73, $pop285, $51
	i64.select	$push287=, $77, $pop286, $51
	i64.store	$discard=, 0($pop308), $pop287
	i32.const	$push309=, 56
	i32.add 	$push310=, $0, $pop309
	i64.or  	$push250=, $40, $161
	i64.select	$push252=, $66, $pop250, $162
	i64.select	$push253=, $70, $8, $pop252
	i64.select	$push255=, $71, $163, $51
	i64.or  	$push256=, $pop253, $pop255
	i64.or  	$push244=, $159, $35
	i64.select	$push246=, $61, $pop244, $160
	i64.select	$push247=, $65, $4, $pop246
	i64.select	$push257=, $73, $pop256, $pop247
	i64.select	$push258=, $70, $8, $pop257
	i64.select	$push259=, $77, $pop258, $51
	i64.store	$discard=, 0($pop310), $pop259
	i32.const	$push311=, 48
	i32.add 	$push312=, $0, $pop311
	i64.or  	$push234=, $155, $156
	i64.select	$push235=, $66, $pop234, $157
	i64.select	$push236=, $70, $7, $pop235
	i64.select	$push237=, $71, $158, $51
	i64.or  	$push238=, $pop236, $pop237
	i64.or  	$push231=, $153, $152
	i64.select	$push232=, $61, $pop231, $154
	i64.select	$push233=, $65, $3, $pop232
	i64.select	$push239=, $73, $pop238, $pop233
	i64.select	$push240=, $70, $7, $pop239
	i64.select	$push241=, $77, $pop240, $51
	i64.store	$discard=, 0($pop312), $pop241
	i32.const	$push313=, 40
	i32.add 	$push314=, $0, $pop313
	i64.select	$push276=, $66, $172, $51
	i64.or  	$push271=, $169, $170
	i64.select	$push273=, $71, $pop271, $171
	i64.select	$push274=, $113, $2, $pop273
	i64.or  	$push277=, $pop276, $pop274
	i64.select	$push279=, $61, $173, $51
	i64.select	$push280=, $73, $pop277, $pop279
	i64.select	$push281=, $70, $6, $pop280
	i64.select	$push282=, $77, $pop281, $51
	i64.store	$discard=, 0($pop314), $pop282
	i32.const	$push315=, 32
	i32.add 	$push316=, $0, $pop315
	i64.select	$push263=, $66, $167, $51
	i64.or  	$push260=, $164, $165
	i64.select	$push261=, $71, $pop260, $166
	i64.select	$push262=, $113, $1, $pop261
	i64.or  	$push264=, $pop263, $pop262
	i64.select	$push265=, $61, $168, $51
	i64.select	$push266=, $73, $pop264, $pop265
	i64.select	$push267=, $70, $5, $pop266
	i64.select	$push268=, $77, $pop267, $51
	i64.store	$discard=, 0($pop316), $pop268
	i32.const	$push317=, 120
	i32.add 	$push318=, $0, $pop317
	i64.or  	$push65=, $84, $85
	i64.select	$push67=, $66, $pop65, $86
	i64.select	$push68=, $70, $16, $pop67
	i64.select	$push70=, $71, $87, $51
	i64.or  	$push71=, $pop68, $pop70
	i64.or  	$push59=, $82, $81
	i64.select	$push61=, $61, $pop59, $83
	i64.select	$push62=, $65, $12, $pop61
	i64.select	$push72=, $73, $pop71, $pop62
	i64.select	$push73=, $70, $16, $pop72
	i64.select	$push75=, $74, $88, $51
	i64.select	$push76=, $76, $pop75, $51
	i64.or  	$push77=, $pop73, $pop76
	i64.or  	$push48=, $41, $33
	i64.select	$push50=, $53, $pop48, $79
	i64.select	$push51=, $57, $8, $pop50
	i64.select	$push53=, $58, $80, $51
	i64.or  	$push54=, $pop51, $pop53
	i64.or  	$push42=, $43, $39
	i64.select	$push44=, $50, $pop42, $38
	i64.select	$push45=, $52, $4, $pop44
	i64.select	$push55=, $60, $pop54, $pop45
	i64.select	$push56=, $57, $8, $pop55
	i64.select	$push78=, $77, $pop77, $pop56
	i64.select	$push79=, $70, $16, $pop78
	i64.store	$discard=, 0($pop318), $pop79
	i32.const	$push319=, 112
	i32.add 	$push320=, $0, $pop319
	i64.or  	$push28=, $67, $68
	i64.select	$push29=, $66, $pop28, $69
	i64.select	$push30=, $70, $15, $pop29
	i64.select	$push31=, $71, $72, $51
	i64.or  	$push32=, $pop30, $pop31
	i64.or  	$push25=, $63, $62
	i64.select	$push26=, $61, $pop25, $64
	i64.select	$push27=, $65, $11, $pop26
	i64.select	$push33=, $73, $pop32, $pop27
	i64.select	$push34=, $70, $15, $pop33
	i64.select	$push35=, $74, $75, $51
	i64.select	$push36=, $76, $pop35, $51
	i64.or  	$push37=, $pop34, $pop36
	i64.or  	$push18=, $55, $54
	i64.select	$push19=, $53, $pop18, $56
	i64.select	$push20=, $57, $7, $pop19
	i64.select	$push21=, $58, $59, $51
	i64.or  	$push22=, $pop20, $pop21
	i64.or  	$push15=, $49, $34
	i64.select	$push16=, $50, $pop15, $36
	i64.select	$push17=, $52, $3, $pop16
	i64.select	$push23=, $60, $pop22, $pop17
	i64.select	$push24=, $57, $7, $pop23
	i64.select	$push38=, $77, $pop37, $pop24
	i64.select	$push39=, $70, $15, $pop38
	i64.store	$discard=, 0($pop320), $pop39
	i32.const	$push321=, 104
	i32.add 	$push322=, $0, $pop321
	i64.select	$push209=, $66, $146, $51
	i64.or  	$push204=, $47, $45
	i64.select	$push206=, $71, $pop204, $145
	i64.select	$push207=, $113, $10, $pop206
	i64.or  	$push210=, $pop209, $pop207
	i64.select	$push212=, $61, $147, $51
	i64.select	$push213=, $73, $pop210, $pop212
	i64.select	$push214=, $70, $14, $pop213
	i64.or  	$push197=, $142, $143
	i64.select	$push199=, $74, $pop197, $144
	i64.select	$push200=, $96, $6, $pop199
	i64.select	$push201=, $76, $pop200, $51
	i64.or  	$push215=, $pop214, $pop201
	i64.select	$push223=, $53, $37, $51
	i64.or  	$push218=, $148, $149
	i64.select	$push220=, $58, $pop218, $150
	i64.select	$push221=, $139, $2, $pop220
	i64.or  	$push224=, $pop223, $pop221
	i64.select	$push226=, $50, $151, $51
	i64.select	$push227=, $60, $pop224, $pop226
	i64.select	$push228=, $57, $6, $pop227
	i64.select	$push229=, $77, $pop215, $pop228
	i64.select	$push230=, $70, $14, $pop229
	i64.store	$discard=, 0($pop322), $pop230
	i32.const	$push323=, 96
	i32.add 	$push324=, $0, $pop323
	i64.select	$push179=, $66, $134, $51
	i64.or  	$push176=, $131, $132
	i64.select	$push177=, $71, $pop176, $133
	i64.select	$push178=, $113, $9, $pop177
	i64.or  	$push180=, $pop179, $pop178
	i64.select	$push181=, $61, $135, $51
	i64.select	$push182=, $73, $pop180, $pop181
	i64.select	$push183=, $70, $13, $pop182
	i64.or  	$push172=, $128, $129
	i64.select	$push173=, $74, $pop172, $130
	i64.select	$push174=, $96, $5, $pop173
	i64.select	$push175=, $76, $pop174, $51
	i64.or  	$push184=, $pop183, $pop175
	i64.select	$push188=, $53, $140, $51
	i64.or  	$push185=, $136, $137
	i64.select	$push186=, $58, $pop185, $138
	i64.select	$push187=, $139, $1, $pop186
	i64.or  	$push189=, $pop188, $pop187
	i64.select	$push190=, $50, $141, $51
	i64.select	$push191=, $60, $pop189, $pop190
	i64.select	$push192=, $57, $5, $pop191
	i64.select	$push193=, $77, $pop184, $pop192
	i64.select	$push194=, $70, $13, $pop193
	i64.store	$discard=, 0($pop324), $pop194
	i32.const	$push325=, 72
	i32.add 	$push326=, $0, $pop325
	i64.select	$push164=, $66, $126, $51
	i64.select	$push165=, $73, $pop164, $51
	i64.or  	$push154=, $122, $123
	i64.select	$push156=, $74, $pop154, $124
	i64.select	$push157=, $96, $2, $pop156
	i64.select	$push159=, $89, $125, $51
	i64.or  	$push160=, $pop157, $pop159
	i64.or  	$push148=, $119, $120
	i64.select	$push150=, $71, $pop148, $121
	i64.select	$push151=, $113, $6, $pop150
	i64.select	$push161=, $76, $pop160, $pop151
	i64.select	$push162=, $96, $2, $pop161
	i64.or  	$push166=, $pop165, $pop162
	i64.select	$push168=, $53, $127, $51
	i64.select	$push169=, $60, $pop168, $51
	i64.select	$push170=, $77, $pop166, $pop169
	i64.select	$push171=, $70, $10, $pop170
	i64.store	$discard=, 0($pop326), $pop171
	i32.const	$push327=, 64
	i32.add 	$push328=, $0, $pop327
	i64.select	$push139=, $66, $46, $51
	i64.select	$push140=, $73, $pop139, $51
	i64.or  	$push132=, $114, $115
	i64.select	$push133=, $74, $pop132, $116
	i64.select	$push134=, $96, $1, $pop133
	i64.select	$push135=, $89, $117, $51
	i64.or  	$push136=, $pop134, $pop135
	i64.or  	$push129=, $110, $111
	i64.select	$push130=, $71, $pop129, $112
	i64.select	$push131=, $113, $5, $pop130
	i64.select	$push137=, $76, $pop136, $pop131
	i64.select	$push138=, $96, $1, $pop137
	i64.or  	$push141=, $pop140, $pop138
	i64.select	$push142=, $53, $118, $51
	i64.select	$push143=, $60, $pop142, $51
	i64.select	$push144=, $77, $pop141, $pop143
	i64.select	$push145=, $70, $9, $pop144
	i64.store	$discard=, 0($pop328), $pop145
	i32.const	$push329=, 88
	i32.add 	$push330=, $0, $pop329
	i64.or  	$push101=, $100, $101
	i64.select	$push103=, $66, $pop101, $102
	i64.select	$push104=, $70, $12, $pop103
	i64.select	$push105=, $73, $pop104, $51
	i64.select	$push113=, $74, $48, $51
	i64.or  	$push108=, $103, $104
	i64.select	$push110=, $89, $pop108, $105
	i64.select	$push111=, $93, $8, $pop110
	i64.or  	$push114=, $pop113, $pop111
	i64.select	$push116=, $71, $106, $51
	i64.select	$push117=, $76, $pop114, $pop116
	i64.select	$push118=, $96, $4, $pop117
	i64.or  	$push119=, $pop105, $pop118
	i64.or  	$push122=, $108, $107
	i64.select	$push124=, $53, $pop122, $109
	i64.select	$push125=, $57, $4, $pop124
	i64.select	$push126=, $60, $pop125, $51
	i64.select	$push127=, $77, $pop119, $pop126
	i64.select	$push128=, $70, $12, $pop127
	i64.store	$discard=, 0($pop330), $pop128
	i32.const	$push331=, 80
	i32.add 	$push332=, $0, $pop331
	i64.or  	$push80=, $17, $42
	i64.select	$push81=, $66, $pop80, $44
	i64.select	$push82=, $70, $11, $pop81
	i64.select	$push83=, $73, $pop82, $51
	i64.select	$push87=, $74, $94, $51
	i64.or  	$push84=, $90, $91
	i64.select	$push85=, $89, $pop84, $92
	i64.select	$push86=, $93, $7, $pop85
	i64.or  	$push88=, $pop87, $pop86
	i64.select	$push89=, $71, $95, $51
	i64.select	$push90=, $76, $pop88, $pop89
	i64.select	$push91=, $96, $3, $pop90
	i64.or  	$push92=, $pop83, $pop91
	i64.or  	$push93=, $98, $97
	i64.select	$push94=, $53, $pop93, $99
	i64.select	$push95=, $57, $3, $pop94
	i64.select	$push96=, $60, $pop95, $51
	i64.select	$push97=, $77, $pop92, $pop96
	i64.select	$push98=, $70, $11, $pop97
	i64.store	$discard=, 0($pop332), $pop98
	i32.const	$183=, 1024
	i32.add 	$279=, $279, $183
	i32.const	$183=, __stack_pointer
	i32.store	$279=, 0($183), $279
	return
.Lfunc_end5:
	.size	bigshift, .Lfunc_end5-bigshift


	.section	".note.GNU-stack","",@progbits
