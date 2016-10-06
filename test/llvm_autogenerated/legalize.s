	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/legalize.ll"
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	i32.const	$push469=, 0
	i32.const	$push466=, 0
	i32.load	$push467=, __stack_pointer($pop466)
	i32.const	$push468=, 1024
	i32.sub 	$push919=, $pop467, $pop468
	tee_local	$push918=, $52=, $pop919
	i32.store	__stack_pointer($pop469), $pop918
	i32.const	$push473=, 512
	i32.add 	$push474=, $52, $pop473
	i32.wrap/i64	$push917=, $17
	tee_local	$push916=, $33=, $pop917
	call    	__ashlti3@FUNCTION, $pop474, $1, $2, $pop916
	i32.const	$push475=, 528
	i32.add 	$push476=, $52, $pop475
	call    	__ashlti3@FUNCTION, $pop476, $3, $4, $33
	i32.const	$push477=, 544
	i32.add 	$push478=, $52, $pop477
	i32.const	$push0=, 128
	i32.sub 	$push915=, $pop0, $33
	tee_local	$push914=, $41=, $pop915
	call    	__lshrti3@FUNCTION, $pop478, $1, $2, $pop914
	i32.const	$push479=, 560
	i32.add 	$push480=, $52, $pop479
	i32.const	$push1=, -128
	i32.add 	$push913=, $33, $pop1
	tee_local	$push912=, $42=, $pop913
	call    	__ashlti3@FUNCTION, $pop480, $1, $2, $pop912
	i32.const	$push481=, 736
	i32.add 	$push482=, $52, $pop481
	i32.const	$push2=, 384
	i32.sub 	$push911=, $pop2, $33
	tee_local	$push910=, $43=, $pop911
	call    	__lshrti3@FUNCTION, $pop482, $1, $2, $pop910
	i32.const	$push483=, 720
	i32.add 	$push484=, $52, $pop483
	i32.const	$push3=, -256
	i32.add 	$push909=, $33, $pop3
	tee_local	$push908=, $34=, $pop909
	call    	__ashlti3@FUNCTION, $pop484, $3, $4, $pop908
	i32.const	$push485=, 752
	i32.add 	$push486=, $52, $pop485
	i32.const	$push4=, -384
	i32.add 	$push907=, $33, $pop4
	tee_local	$push906=, $39=, $pop907
	call    	__ashlti3@FUNCTION, $pop486, $1, $2, $pop906
	i32.const	$push487=, 592
	i32.add 	$push488=, $52, $pop487
	call    	__ashlti3@FUNCTION, $pop488, $7, $8, $33
	i32.const	$push489=, 608
	i32.add 	$push490=, $52, $pop489
	call    	__lshrti3@FUNCTION, $pop490, $5, $6, $41
	i32.const	$push491=, 624
	i32.add 	$push492=, $52, $pop491
	call    	__ashlti3@FUNCTION, $pop492, $5, $6, $42
	i32.const	$push493=, 688
	i32.add 	$push494=, $52, $pop493
	i32.const	$push5=, 256
	i32.sub 	$push905=, $pop5, $33
	tee_local	$push904=, $35=, $pop905
	call    	__lshrti3@FUNCTION, $pop494, $3, $4, $pop904
	i32.const	$push495=, 640
	i32.add 	$push496=, $52, $pop495
	call    	__lshrti3@FUNCTION, $pop496, $1, $2, $35
	i32.const	$push497=, 656
	i32.add 	$push498=, $52, $pop497
	i32.const	$push903=, 128
	i32.sub 	$push902=, $pop903, $35
	tee_local	$push901=, $50=, $pop902
	call    	__ashlti3@FUNCTION, $pop498, $3, $4, $pop901
	i32.const	$push499=, 672
	i32.add 	$push500=, $52, $pop499
	call    	__lshrti3@FUNCTION, $pop500, $3, $4, $41
	i32.const	$push501=, 576
	i32.add 	$push502=, $52, $pop501
	call    	__ashlti3@FUNCTION, $pop502, $5, $6, $33
	i32.const	$push503=, 704
	i32.add 	$push504=, $52, $pop503
	call    	__ashlti3@FUNCTION, $pop504, $1, $2, $34
	i32.const	$push505=, 480
	i32.add 	$push506=, $52, $pop505
	i32.const	$push6=, 896
	i32.sub 	$push7=, $pop6, $33
	call    	__lshrti3@FUNCTION, $pop506, $1, $2, $pop7
	i32.const	$push507=, 464
	i32.add 	$push508=, $52, $pop507
	i32.const	$push8=, -768
	i32.add 	$push900=, $33, $pop8
	tee_local	$push899=, $36=, $pop900
	call    	__ashlti3@FUNCTION, $pop508, $3, $4, $pop899
	i32.const	$push509=, 496
	i32.add 	$push510=, $52, $pop509
	i32.const	$push9=, -896
	i32.add 	$push10=, $33, $pop9
	call    	__ashlti3@FUNCTION, $pop510, $1, $2, $pop10
	i32.const	$push511=, 352
	i32.add 	$push512=, $52, $pop511
	i32.const	$push11=, 640
	i32.sub 	$push898=, $pop11, $33
	tee_local	$push897=, $45=, $pop898
	call    	__lshrti3@FUNCTION, $pop512, $5, $6, $pop897
	i32.const	$push513=, 336
	i32.add 	$push514=, $52, $pop513
	i32.const	$push12=, -512
	i32.add 	$push896=, $33, $pop12
	tee_local	$push895=, $37=, $pop896
	call    	__ashlti3@FUNCTION, $pop514, $7, $8, $pop895
	i32.const	$push515=, 368
	i32.add 	$push516=, $52, $pop515
	i32.const	$push13=, -640
	i32.add 	$push894=, $33, $pop13
	tee_local	$push893=, $51=, $pop894
	call    	__ashlti3@FUNCTION, $pop516, $5, $6, $pop893
	i32.const	$push517=, 432
	i32.add 	$push518=, $52, $pop517
	i32.const	$push14=, 768
	i32.sub 	$push892=, $pop14, $33
	tee_local	$push891=, $38=, $pop892
	call    	__lshrti3@FUNCTION, $pop518, $3, $4, $pop891
	i32.const	$push519=, 864
	i32.add 	$push520=, $52, $pop519
	call    	__lshrti3@FUNCTION, $pop520, $9, $10, $43
	i32.const	$push521=, 848
	i32.add 	$push522=, $52, $pop521
	call    	__ashlti3@FUNCTION, $pop522, $11, $12, $34
	i32.const	$push523=, 880
	i32.add 	$push524=, $52, $pop523
	call    	__ashlti3@FUNCTION, $pop524, $9, $10, $39
	i32.const	$push525=, 1008
	i32.add 	$push526=, $52, $pop525
	call    	__ashlti3@FUNCTION, $pop526, $15, $16, $33
	i32.const	$push527=, 960
	i32.add 	$push528=, $52, $pop527
	call    	__lshrti3@FUNCTION, $pop528, $13, $14, $41
	i32.const	$push529=, 976
	i32.add 	$push530=, $52, $pop529
	call    	__ashlti3@FUNCTION, $pop530, $13, $14, $42
	i32.const	$push531=, 816
	i32.add 	$push532=, $52, $pop531
	call    	__lshrti3@FUNCTION, $pop532, $11, $12, $35
	i32.const	$push533=, 240
	i32.add 	$push534=, $52, $pop533
	i32.const	$push15=, 512
	i32.sub 	$push890=, $pop15, $33
	tee_local	$push889=, $39=, $pop890
	call    	__lshrti3@FUNCTION, $pop534, $7, $8, $pop889
	i32.const	$push535=, 192
	i32.add 	$push536=, $52, $pop535
	call    	__lshrti3@FUNCTION, $pop536, $5, $6, $39
	i32.const	$push537=, 208
	i32.add 	$push538=, $52, $pop537
	i32.const	$push888=, 128
	i32.sub 	$push887=, $pop888, $39
	tee_local	$push886=, $44=, $pop887
	call    	__ashlti3@FUNCTION, $pop538, $7, $8, $pop886
	i32.const	$push539=, 224
	i32.add 	$push540=, $52, $pop539
	call    	__lshrti3@FUNCTION, $pop540, $7, $8, $43
	i32.const	$push541=, 768
	i32.add 	$push542=, $52, $pop541
	call    	__lshrti3@FUNCTION, $pop542, $9, $10, $35
	i32.const	$push543=, 784
	i32.add 	$push544=, $52, $pop543
	call    	__ashlti3@FUNCTION, $pop544, $11, $12, $50
	i32.const	$push545=, 800
	i32.add 	$push546=, $52, $pop545
	call    	__lshrti3@FUNCTION, $pop546, $11, $12, $41
	i32.const	$push547=, 992
	i32.add 	$push548=, $52, $pop547
	call    	__ashlti3@FUNCTION, $pop548, $13, $14, $33
	i32.const	$push549=, 832
	i32.add 	$push550=, $52, $pop549
	call    	__ashlti3@FUNCTION, $pop550, $9, $10, $34
	i32.const	$push551=, 384
	i32.add 	$push552=, $52, $pop551
	call    	__lshrti3@FUNCTION, $pop552, $1, $2, $38
	i32.const	$push553=, 400
	i32.add 	$push554=, $52, $pop553
	i32.const	$push885=, 128
	i32.sub 	$push16=, $pop885, $38
	call    	__ashlti3@FUNCTION, $pop554, $3, $4, $pop16
	i32.const	$push555=, 416
	i32.add 	$push556=, $52, $pop555
	call    	__lshrti3@FUNCTION, $pop556, $3, $4, $45
	i32.const	$push557=, 320
	i32.add 	$push558=, $52, $pop557
	call    	__ashlti3@FUNCTION, $pop558, $5, $6, $37
	i32.const	$push559=, 448
	i32.add 	$push560=, $52, $pop559
	call    	__ashlti3@FUNCTION, $pop560, $1, $2, $36
	i32.const	$push561=, 128
	i32.add 	$push562=, $52, $pop561
	call    	__lshrti3@FUNCTION, $pop562, $5, $6, $35
	i32.const	$push563=, 144
	i32.add 	$push564=, $52, $pop563
	i32.const	$push884=, 384
	i32.sub 	$push17=, $pop884, $39
	call    	__ashlti3@FUNCTION, $pop564, $7, $8, $pop17
	i32.const	$push565=, 160
	i32.add 	$push566=, $52, $pop565
	call    	__lshrti3@FUNCTION, $pop566, $7, $8, $41
	call    	__lshrti3@FUNCTION, $52, $1, $2, $39
	i32.const	$push567=, 16
	i32.add 	$push568=, $52, $pop567
	call    	__ashlti3@FUNCTION, $pop568, $3, $4, $44
	i32.const	$push569=, 32
	i32.add 	$push570=, $52, $pop569
	call    	__lshrti3@FUNCTION, $pop570, $3, $4, $43
	i32.const	$push571=, 64
	i32.add 	$push572=, $52, $pop571
	i32.const	$push883=, 256
	i32.sub 	$push882=, $pop883, $39
	tee_local	$push881=, $40=, $pop882
	call    	__ashlti3@FUNCTION, $pop572, $5, $6, $pop881
	i32.const	$push573=, 896
	i32.add 	$push574=, $52, $pop573
	call    	__ashlti3@FUNCTION, $pop574, $9, $10, $33
	i32.const	$push575=, 256
	i32.add 	$push576=, $52, $pop575
	call    	__ashlti3@FUNCTION, $pop576, $1, $2, $37
	i32.const	$push577=, 912
	i32.add 	$push578=, $52, $pop577
	call    	__ashlti3@FUNCTION, $pop578, $11, $12, $33
	i32.const	$push579=, 928
	i32.add 	$push580=, $52, $pop579
	call    	__lshrti3@FUNCTION, $pop580, $9, $10, $41
	i32.const	$push581=, 944
	i32.add 	$push582=, $52, $pop581
	call    	__ashlti3@FUNCTION, $pop582, $9, $10, $42
	i32.const	$push583=, 80
	i32.add 	$push584=, $52, $pop583
	call    	__ashlti3@FUNCTION, $pop584, $7, $8, $40
	i32.const	$push585=, 96
	i32.add 	$push586=, $52, $pop585
	i32.const	$push880=, 128
	i32.sub 	$push18=, $pop880, $40
	call    	__lshrti3@FUNCTION, $pop586, $5, $6, $pop18
	i32.const	$push587=, 112
	i32.add 	$push588=, $52, $pop587
	call    	__ashlti3@FUNCTION, $pop588, $5, $6, $44
	i32.const	$push589=, 48
	i32.add 	$push590=, $52, $pop589
	call    	__lshrti3@FUNCTION, $pop590, $3, $4, $39
	i32.const	$push591=, 176
	i32.add 	$push592=, $52, $pop591
	call    	__lshrti3@FUNCTION, $pop592, $7, $8, $35
	i32.const	$push593=, 288
	i32.add 	$push594=, $52, $pop593
	call    	__lshrti3@FUNCTION, $pop594, $1, $2, $45
	i32.const	$push595=, 272
	i32.add 	$push596=, $52, $pop595
	call    	__ashlti3@FUNCTION, $pop596, $3, $4, $37
	i32.const	$push597=, 304
	i32.add 	$push598=, $52, $pop597
	call    	__ashlti3@FUNCTION, $pop598, $1, $2, $51
	i32.const	$push19=, 8
	i32.add 	$push26=, $0, $pop19
	i32.const	$push599=, 512
	i32.add 	$push600=, $52, $pop599
	i32.const	$push879=, 8
	i32.add 	$push20=, $pop600, $pop879
	i64.load	$push21=, 0($pop20)
	i64.const	$push22=, 0
	i32.const	$push878=, 128
	i32.lt_u	$push877=, $33, $pop878
	tee_local	$push876=, $41=, $pop877
	i64.select	$push23=, $pop21, $pop22, $pop876
	i64.const	$push875=, 0
	i32.const	$push874=, 256
	i32.lt_u	$push873=, $33, $pop874
	tee_local	$push872=, $42=, $pop873
	i64.select	$push24=, $pop23, $pop875, $pop872
	i64.const	$push871=, 0
	i32.const	$push870=, 512
	i32.lt_u	$push869=, $33, $pop870
	tee_local	$push868=, $43=, $pop869
	i64.select	$push25=, $pop24, $pop871, $pop868
	i64.store	0($pop26), $pop25
	i64.load	$push27=, 512($52)
	i64.const	$push867=, 0
	i64.select	$push28=, $pop27, $pop867, $41
	i64.const	$push866=, 0
	i64.select	$push29=, $pop28, $pop866, $42
	i64.const	$push865=, 0
	i64.select	$push30=, $pop29, $pop865, $43
	i64.store	0($0), $pop30
	i32.const	$push42=, 24
	i32.add 	$push43=, $0, $pop42
	i32.const	$push601=, 528
	i32.add 	$push602=, $52, $pop601
	i32.const	$push864=, 8
	i32.add 	$push31=, $pop602, $pop864
	i64.load	$push32=, 0($pop31)
	i32.const	$push603=, 544
	i32.add 	$push604=, $52, $pop603
	i32.const	$push863=, 8
	i32.add 	$push33=, $pop604, $pop863
	i64.load	$push34=, 0($pop33)
	i64.or  	$push35=, $pop32, $pop34
	i32.const	$push605=, 560
	i32.add 	$push606=, $52, $pop605
	i32.const	$push862=, 8
	i32.add 	$push36=, $pop606, $pop862
	i64.load	$push37=, 0($pop36)
	i64.select	$push38=, $pop35, $pop37, $41
	i64.select	$push39=, $pop38, $4, $33
	i64.const	$push861=, 0
	i64.select	$push40=, $pop39, $pop861, $42
	i64.const	$push860=, 0
	i64.select	$push41=, $pop40, $pop860, $43
	i64.store	0($pop43), $pop41
	i32.const	$push52=, 16
	i32.add 	$push53=, $0, $pop52
	i64.load	$push44=, 528($52)
	i64.load	$push45=, 544($52)
	i64.or  	$push46=, $pop44, $pop45
	i64.load	$push47=, 560($52)
	i64.select	$push48=, $pop46, $pop47, $41
	i64.select	$push49=, $pop48, $3, $33
	i64.const	$push859=, 0
	i64.select	$push50=, $pop49, $pop859, $42
	i64.const	$push858=, 0
	i64.select	$push51=, $pop50, $pop858, $43
	i64.store	0($pop53), $pop51
	i32.const	$push79=, 56
	i32.add 	$push80=, $0, $pop79
	i32.const	$push613=, 592
	i32.add 	$push614=, $52, $pop613
	i32.const	$push857=, 8
	i32.add 	$push63=, $pop614, $pop857
	i64.load	$push64=, 0($pop63)
	i32.const	$push615=, 608
	i32.add 	$push616=, $52, $pop615
	i32.const	$push856=, 8
	i32.add 	$push65=, $pop616, $pop856
	i64.load	$push66=, 0($pop65)
	i64.or  	$push67=, $pop64, $pop66
	i32.const	$push617=, 624
	i32.add 	$push618=, $52, $pop617
	i32.const	$push855=, 8
	i32.add 	$push68=, $pop618, $pop855
	i64.load	$push69=, 0($pop68)
	i64.select	$push70=, $pop67, $pop69, $41
	i64.select	$push71=, $pop70, $8, $33
	i32.const	$push619=, 688
	i32.add 	$push620=, $52, $pop619
	i32.const	$push854=, 8
	i32.add 	$push72=, $pop620, $pop854
	i64.load	$push73=, 0($pop72)
	i64.const	$push853=, 0
	i32.const	$push852=, 128
	i32.lt_u	$push851=, $35, $pop852
	tee_local	$push850=, $45=, $pop851
	i64.select	$push74=, $pop73, $pop853, $pop850
	i64.or  	$push75=, $pop71, $pop74
	i32.const	$push609=, 720
	i32.add 	$push610=, $52, $pop609
	i32.const	$push849=, 8
	i32.add 	$push56=, $pop610, $pop849
	i64.load	$push57=, 0($pop56)
	i32.const	$push607=, 736
	i32.add 	$push608=, $52, $pop607
	i32.const	$push848=, 8
	i32.add 	$push54=, $pop608, $pop848
	i64.load	$push55=, 0($pop54)
	i64.or  	$push58=, $pop57, $pop55
	i32.const	$push611=, 752
	i32.add 	$push612=, $52, $pop611
	i32.const	$push847=, 8
	i32.add 	$push59=, $pop612, $pop847
	i64.load	$push60=, 0($pop59)
	i32.const	$push846=, 128
	i32.lt_u	$push845=, $34, $pop846
	tee_local	$push844=, $44=, $pop845
	i64.select	$push61=, $pop58, $pop60, $pop844
	i64.select	$push62=, $pop61, $4, $34
	i64.select	$push76=, $pop75, $pop62, $42
	i64.select	$push77=, $pop76, $8, $33
	i64.const	$push843=, 0
	i64.select	$push78=, $pop77, $pop843, $43
	i64.store	0($pop80), $pop78
	i32.const	$push99=, 48
	i32.add 	$push100=, $0, $pop99
	i64.load	$push87=, 592($52)
	i64.load	$push88=, 608($52)
	i64.or  	$push89=, $pop87, $pop88
	i64.load	$push90=, 624($52)
	i64.select	$push91=, $pop89, $pop90, $41
	i64.select	$push92=, $pop91, $7, $33
	i64.load	$push93=, 688($52)
	i64.const	$push842=, 0
	i64.select	$push94=, $pop93, $pop842, $45
	i64.or  	$push95=, $pop92, $pop94
	i64.load	$push82=, 720($52)
	i64.load	$push81=, 736($52)
	i64.or  	$push83=, $pop82, $pop81
	i64.load	$push84=, 752($52)
	i64.select	$push85=, $pop83, $pop84, $44
	i64.select	$push86=, $pop85, $3, $34
	i64.select	$push96=, $pop95, $pop86, $42
	i64.select	$push97=, $pop96, $7, $33
	i64.const	$push841=, 0
	i64.select	$push98=, $pop97, $pop841, $43
	i64.store	0($pop100), $pop98
	i32.const	$push120=, 40
	i32.add 	$push121=, $0, $pop120
	i32.const	$push627=, 576
	i32.add 	$push628=, $52, $pop627
	i32.const	$push840=, 8
	i32.add 	$push110=, $pop628, $pop840
	i64.load	$push111=, 0($pop110)
	i64.const	$push839=, 0
	i64.select	$push112=, $pop111, $pop839, $41
	i32.const	$push621=, 640
	i32.add 	$push622=, $52, $pop621
	i32.const	$push838=, 8
	i32.add 	$push101=, $pop622, $pop838
	i64.load	$push102=, 0($pop101)
	i32.const	$push623=, 656
	i32.add 	$push624=, $52, $pop623
	i32.const	$push837=, 8
	i32.add 	$push103=, $pop624, $pop837
	i64.load	$push104=, 0($pop103)
	i64.or  	$push105=, $pop102, $pop104
	i32.const	$push625=, 672
	i32.add 	$push626=, $52, $pop625
	i32.const	$push836=, 8
	i32.add 	$push106=, $pop626, $pop836
	i64.load	$push107=, 0($pop106)
	i64.select	$push108=, $pop105, $pop107, $45
	i64.select	$push109=, $pop108, $2, $35
	i64.or  	$push113=, $pop112, $pop109
	i32.const	$push629=, 704
	i32.add 	$push630=, $52, $pop629
	i32.const	$push835=, 8
	i32.add 	$push114=, $pop630, $pop835
	i64.load	$push115=, 0($pop114)
	i64.const	$push834=, 0
	i64.select	$push116=, $pop115, $pop834, $44
	i64.select	$push117=, $pop113, $pop116, $42
	i64.select	$push118=, $pop117, $6, $33
	i64.const	$push833=, 0
	i64.select	$push119=, $pop118, $pop833, $43
	i64.store	0($pop121), $pop119
	i32.const	$push136=, 32
	i32.add 	$push137=, $0, $pop136
	i64.load	$push128=, 576($52)
	i64.const	$push832=, 0
	i64.select	$push129=, $pop128, $pop832, $41
	i64.load	$push122=, 640($52)
	i64.load	$push123=, 656($52)
	i64.or  	$push124=, $pop122, $pop123
	i64.load	$push125=, 672($52)
	i64.select	$push126=, $pop124, $pop125, $45
	i64.select	$push127=, $pop126, $1, $35
	i64.or  	$push130=, $pop129, $pop127
	i64.load	$push131=, 704($52)
	i64.const	$push831=, 0
	i64.select	$push132=, $pop131, $pop831, $44
	i64.select	$push133=, $pop130, $pop132, $42
	i64.select	$push134=, $pop133, $5, $33
	i64.const	$push830=, 0
	i64.select	$push135=, $pop134, $pop830, $43
	i64.store	0($pop137), $pop135
	i32.const	$push193=, 120
	i32.add 	$push194=, $0, $pop193
	i32.const	$push651=, 1008
	i32.add 	$push652=, $52, $pop651
	i32.const	$push829=, 8
	i32.add 	$push171=, $pop652, $pop829
	i64.load	$push172=, 0($pop171)
	i32.const	$push653=, 960
	i32.add 	$push654=, $52, $pop653
	i32.const	$push828=, 8
	i32.add 	$push173=, $pop654, $pop828
	i64.load	$push174=, 0($pop173)
	i64.or  	$push175=, $pop172, $pop174
	i32.const	$push655=, 976
	i32.add 	$push656=, $52, $pop655
	i32.const	$push827=, 8
	i32.add 	$push176=, $pop656, $pop827
	i64.load	$push177=, 0($pop176)
	i64.select	$push178=, $pop175, $pop177, $41
	i64.select	$push179=, $pop178, $16, $33
	i32.const	$push657=, 816
	i32.add 	$push658=, $52, $pop657
	i32.const	$push826=, 8
	i32.add 	$push180=, $pop658, $pop826
	i64.load	$push181=, 0($pop180)
	i64.const	$push825=, 0
	i64.select	$push182=, $pop181, $pop825, $45
	i64.or  	$push183=, $pop179, $pop182
	i32.const	$push647=, 848
	i32.add 	$push648=, $52, $pop647
	i32.const	$push824=, 8
	i32.add 	$push164=, $pop648, $pop824
	i64.load	$push165=, 0($pop164)
	i32.const	$push645=, 864
	i32.add 	$push646=, $52, $pop645
	i32.const	$push823=, 8
	i32.add 	$push162=, $pop646, $pop823
	i64.load	$push163=, 0($pop162)
	i64.or  	$push166=, $pop165, $pop163
	i32.const	$push649=, 880
	i32.add 	$push650=, $52, $pop649
	i32.const	$push822=, 8
	i32.add 	$push167=, $pop650, $pop822
	i64.load	$push168=, 0($pop167)
	i64.select	$push169=, $pop166, $pop168, $44
	i64.select	$push170=, $pop169, $12, $34
	i64.select	$push184=, $pop183, $pop170, $42
	i64.select	$push185=, $pop184, $16, $33
	i32.const	$push659=, 240
	i32.add 	$push660=, $52, $pop659
	i32.const	$push821=, 8
	i32.add 	$push186=, $pop660, $pop821
	i64.load	$push187=, 0($pop186)
	i64.const	$push820=, 0
	i32.const	$push819=, 128
	i32.lt_u	$push818=, $39, $pop819
	tee_local	$push817=, $50=, $pop818
	i64.select	$push188=, $pop187, $pop820, $pop817
	i64.const	$push816=, 0
	i32.const	$push815=, 256
	i32.lt_u	$push814=, $39, $pop815
	tee_local	$push813=, $51=, $pop814
	i64.select	$push189=, $pop188, $pop816, $pop813
	i64.or  	$push190=, $pop185, $pop189
	i32.const	$push639=, 336
	i32.add 	$push640=, $52, $pop639
	i32.const	$push812=, 8
	i32.add 	$push149=, $pop640, $pop812
	i64.load	$push150=, 0($pop149)
	i32.const	$push637=, 352
	i32.add 	$push638=, $52, $pop637
	i32.const	$push811=, 8
	i32.add 	$push147=, $pop638, $pop811
	i64.load	$push148=, 0($pop147)
	i64.or  	$push151=, $pop150, $pop148
	i32.const	$push641=, 368
	i32.add 	$push642=, $52, $pop641
	i32.const	$push810=, 8
	i32.add 	$push152=, $pop642, $pop810
	i64.load	$push153=, 0($pop152)
	i32.const	$push809=, 128
	i32.lt_u	$push808=, $37, $pop809
	tee_local	$push807=, $47=, $pop808
	i64.select	$push154=, $pop151, $pop153, $pop807
	i64.select	$push155=, $pop154, $8, $37
	i32.const	$push643=, 432
	i32.add 	$push644=, $52, $pop643
	i32.const	$push806=, 8
	i32.add 	$push156=, $pop644, $pop806
	i64.load	$push157=, 0($pop156)
	i64.const	$push805=, 0
	i32.const	$push804=, 128
	i32.lt_u	$push803=, $38, $pop804
	tee_local	$push802=, $48=, $pop803
	i64.select	$push158=, $pop157, $pop805, $pop802
	i64.or  	$push159=, $pop155, $pop158
	i32.const	$push633=, 464
	i32.add 	$push634=, $52, $pop633
	i32.const	$push801=, 8
	i32.add 	$push140=, $pop634, $pop801
	i64.load	$push141=, 0($pop140)
	i32.const	$push631=, 480
	i32.add 	$push632=, $52, $pop631
	i32.const	$push800=, 8
	i32.add 	$push138=, $pop632, $pop800
	i64.load	$push139=, 0($pop138)
	i64.or  	$push142=, $pop141, $pop139
	i32.const	$push635=, 496
	i32.add 	$push636=, $52, $pop635
	i32.const	$push799=, 8
	i32.add 	$push143=, $pop636, $pop799
	i64.load	$push144=, 0($pop143)
	i32.const	$push798=, 128
	i32.lt_u	$push797=, $36, $pop798
	tee_local	$push796=, $46=, $pop797
	i64.select	$push145=, $pop142, $pop144, $pop796
	i64.select	$push146=, $pop145, $4, $36
	i32.const	$push795=, 256
	i32.lt_u	$push794=, $37, $pop795
	tee_local	$push793=, $49=, $pop794
	i64.select	$push160=, $pop159, $pop146, $pop793
	i64.select	$push161=, $pop160, $8, $37
	i64.select	$push191=, $pop190, $pop161, $43
	i64.select	$push192=, $pop191, $16, $33
	i64.store	0($pop194), $pop192
	i32.const	$push235=, 112
	i32.add 	$push236=, $0, $pop235
	i64.load	$push218=, 1008($52)
	i64.load	$push219=, 960($52)
	i64.or  	$push220=, $pop218, $pop219
	i64.load	$push221=, 976($52)
	i64.select	$push222=, $pop220, $pop221, $41
	i64.select	$push223=, $pop222, $15, $33
	i64.load	$push224=, 816($52)
	i64.const	$push792=, 0
	i64.select	$push225=, $pop224, $pop792, $45
	i64.or  	$push226=, $pop223, $pop225
	i64.load	$push213=, 848($52)
	i64.load	$push212=, 864($52)
	i64.or  	$push214=, $pop213, $pop212
	i64.load	$push215=, 880($52)
	i64.select	$push216=, $pop214, $pop215, $44
	i64.select	$push217=, $pop216, $11, $34
	i64.select	$push227=, $pop226, $pop217, $42
	i64.select	$push228=, $pop227, $15, $33
	i64.load	$push229=, 240($52)
	i64.const	$push791=, 0
	i64.select	$push230=, $pop229, $pop791, $50
	i64.const	$push790=, 0
	i64.select	$push231=, $pop230, $pop790, $51
	i64.or  	$push232=, $pop228, $pop231
	i64.load	$push202=, 336($52)
	i64.load	$push201=, 352($52)
	i64.or  	$push203=, $pop202, $pop201
	i64.load	$push204=, 368($52)
	i64.select	$push205=, $pop203, $pop204, $47
	i64.select	$push206=, $pop205, $7, $37
	i64.load	$push207=, 432($52)
	i64.const	$push789=, 0
	i64.select	$push208=, $pop207, $pop789, $48
	i64.or  	$push209=, $pop206, $pop208
	i64.load	$push196=, 464($52)
	i64.load	$push195=, 480($52)
	i64.or  	$push197=, $pop196, $pop195
	i64.load	$push198=, 496($52)
	i64.select	$push199=, $pop197, $pop198, $46
	i64.select	$push200=, $pop199, $3, $36
	i64.select	$push210=, $pop209, $pop200, $49
	i64.select	$push211=, $pop210, $7, $37
	i64.select	$push233=, $pop232, $pop211, $43
	i64.select	$push234=, $pop233, $15, $33
	i64.store	0($pop236), $pop234
	i32.const	$push286=, 104
	i32.add 	$push287=, $0, $pop286
	i32.const	$push673=, 992
	i32.add 	$push674=, $52, $pop673
	i32.const	$push788=, 8
	i32.add 	$push256=, $pop674, $pop788
	i64.load	$push257=, 0($pop256)
	i64.const	$push787=, 0
	i64.select	$push258=, $pop257, $pop787, $41
	i32.const	$push667=, 768
	i32.add 	$push668=, $52, $pop667
	i32.const	$push786=, 8
	i32.add 	$push247=, $pop668, $pop786
	i64.load	$push248=, 0($pop247)
	i32.const	$push669=, 784
	i32.add 	$push670=, $52, $pop669
	i32.const	$push785=, 8
	i32.add 	$push249=, $pop670, $pop785
	i64.load	$push250=, 0($pop249)
	i64.or  	$push251=, $pop248, $pop250
	i32.const	$push671=, 800
	i32.add 	$push672=, $52, $pop671
	i32.const	$push784=, 8
	i32.add 	$push252=, $pop672, $pop784
	i64.load	$push253=, 0($pop252)
	i64.select	$push254=, $pop251, $pop253, $45
	i64.select	$push255=, $pop254, $10, $35
	i64.or  	$push259=, $pop258, $pop255
	i32.const	$push675=, 832
	i32.add 	$push676=, $52, $pop675
	i32.const	$push783=, 8
	i32.add 	$push260=, $pop676, $pop783
	i64.load	$push261=, 0($pop260)
	i64.const	$push782=, 0
	i64.select	$push262=, $pop261, $pop782, $44
	i64.select	$push263=, $pop259, $pop262, $42
	i64.select	$push264=, $pop263, $14, $33
	i32.const	$push661=, 192
	i32.add 	$push662=, $52, $pop661
	i32.const	$push781=, 8
	i32.add 	$push237=, $pop662, $pop781
	i64.load	$push238=, 0($pop237)
	i32.const	$push663=, 208
	i32.add 	$push664=, $52, $pop663
	i32.const	$push780=, 8
	i32.add 	$push239=, $pop664, $pop780
	i64.load	$push240=, 0($pop239)
	i64.or  	$push241=, $pop238, $pop240
	i32.const	$push665=, 224
	i32.add 	$push666=, $52, $pop665
	i32.const	$push779=, 8
	i32.add 	$push242=, $pop666, $pop779
	i64.load	$push243=, 0($pop242)
	i64.select	$push244=, $pop241, $pop243, $50
	i64.select	$push245=, $pop244, $6, $39
	i64.const	$push778=, 0
	i64.select	$push246=, $pop245, $pop778, $51
	i64.or  	$push265=, $pop264, $pop246
	i32.const	$push683=, 320
	i32.add 	$push684=, $52, $pop683
	i32.const	$push777=, 8
	i32.add 	$push275=, $pop684, $pop777
	i64.load	$push276=, 0($pop275)
	i64.const	$push776=, 0
	i64.select	$push277=, $pop276, $pop776, $47
	i32.const	$push677=, 384
	i32.add 	$push678=, $52, $pop677
	i32.const	$push775=, 8
	i32.add 	$push266=, $pop678, $pop775
	i64.load	$push267=, 0($pop266)
	i32.const	$push679=, 400
	i32.add 	$push680=, $52, $pop679
	i32.const	$push774=, 8
	i32.add 	$push268=, $pop680, $pop774
	i64.load	$push269=, 0($pop268)
	i64.or  	$push270=, $pop267, $pop269
	i32.const	$push681=, 416
	i32.add 	$push682=, $52, $pop681
	i32.const	$push773=, 8
	i32.add 	$push271=, $pop682, $pop773
	i64.load	$push272=, 0($pop271)
	i64.select	$push273=, $pop270, $pop272, $48
	i64.select	$push274=, $pop273, $2, $38
	i64.or  	$push278=, $pop277, $pop274
	i32.const	$push685=, 448
	i32.add 	$push686=, $52, $pop685
	i32.const	$push772=, 8
	i32.add 	$push279=, $pop686, $pop772
	i64.load	$push280=, 0($pop279)
	i64.const	$push771=, 0
	i64.select	$push281=, $pop280, $pop771, $46
	i64.select	$push282=, $pop278, $pop281, $49
	i64.select	$push283=, $pop282, $6, $37
	i64.select	$push284=, $pop265, $pop283, $43
	i64.select	$push285=, $pop284, $14, $33
	i64.store	0($pop287), $pop285
	i32.const	$push324=, 96
	i32.add 	$push325=, $0, $pop324
	i64.load	$push301=, 992($52)
	i64.const	$push770=, 0
	i64.select	$push302=, $pop301, $pop770, $41
	i64.load	$push295=, 768($52)
	i64.load	$push296=, 784($52)
	i64.or  	$push297=, $pop295, $pop296
	i64.load	$push298=, 800($52)
	i64.select	$push299=, $pop297, $pop298, $45
	i64.select	$push300=, $pop299, $9, $35
	i64.or  	$push303=, $pop302, $pop300
	i64.load	$push304=, 832($52)
	i64.const	$push769=, 0
	i64.select	$push305=, $pop304, $pop769, $44
	i64.select	$push306=, $pop303, $pop305, $42
	i64.select	$push307=, $pop306, $13, $33
	i64.load	$push288=, 192($52)
	i64.load	$push289=, 208($52)
	i64.or  	$push290=, $pop288, $pop289
	i64.load	$push291=, 224($52)
	i64.select	$push292=, $pop290, $pop291, $50
	i64.select	$push293=, $pop292, $5, $39
	i64.const	$push768=, 0
	i64.select	$push294=, $pop293, $pop768, $51
	i64.or  	$push308=, $pop307, $pop294
	i64.load	$push315=, 320($52)
	i64.const	$push767=, 0
	i64.select	$push316=, $pop315, $pop767, $47
	i64.load	$push309=, 384($52)
	i64.load	$push310=, 400($52)
	i64.or  	$push311=, $pop309, $pop310
	i64.load	$push312=, 416($52)
	i64.select	$push313=, $pop311, $pop312, $48
	i64.select	$push314=, $pop313, $1, $38
	i64.or  	$push317=, $pop316, $pop314
	i64.load	$push318=, 448($52)
	i64.const	$push766=, 0
	i64.select	$push319=, $pop318, $pop766, $46
	i64.select	$push320=, $pop317, $pop319, $49
	i64.select	$push321=, $pop320, $5, $37
	i64.select	$push322=, $pop308, $pop321, $43
	i64.select	$push323=, $pop322, $13, $33
	i64.store	0($pop325), $pop323
	i32.const	$push361=, 72
	i32.add 	$push362=, $0, $pop361
	i32.const	$push699=, 896
	i32.add 	$push700=, $52, $pop699
	i32.const	$push765=, 8
	i32.add 	$push350=, $pop700, $pop765
	i64.load	$push351=, 0($pop350)
	i64.const	$push764=, 0
	i64.select	$push352=, $pop351, $pop764, $41
	i64.const	$push763=, 0
	i64.select	$push353=, $pop352, $pop763, $42
	i32.const	$push762=, 8
	i32.add 	$push335=, $52, $pop762
	i64.load	$push336=, 0($pop335)
	i32.const	$push693=, 16
	i32.add 	$push694=, $52, $pop693
	i32.const	$push761=, 8
	i32.add 	$push337=, $pop694, $pop761
	i64.load	$push338=, 0($pop337)
	i64.or  	$push339=, $pop336, $pop338
	i32.const	$push695=, 32
	i32.add 	$push696=, $52, $pop695
	i32.const	$push760=, 8
	i32.add 	$push340=, $pop696, $pop760
	i64.load	$push341=, 0($pop340)
	i64.select	$push342=, $pop339, $pop341, $50
	i64.select	$push343=, $pop342, $2, $39
	i32.const	$push697=, 64
	i32.add 	$push698=, $52, $pop697
	i32.const	$push759=, 8
	i32.add 	$push344=, $pop698, $pop759
	i64.load	$push345=, 0($pop344)
	i64.const	$push758=, 0
	i32.const	$push757=, 128
	i32.lt_u	$push756=, $40, $pop757
	tee_local	$push755=, $34=, $pop756
	i64.select	$push346=, $pop345, $pop758, $pop755
	i64.or  	$push347=, $pop343, $pop346
	i32.const	$push687=, 128
	i32.add 	$push688=, $52, $pop687
	i32.const	$push754=, 8
	i32.add 	$push326=, $pop688, $pop754
	i64.load	$push327=, 0($pop326)
	i32.const	$push689=, 144
	i32.add 	$push690=, $52, $pop689
	i32.const	$push753=, 8
	i32.add 	$push328=, $pop690, $pop753
	i64.load	$push329=, 0($pop328)
	i64.or  	$push330=, $pop327, $pop329
	i32.const	$push691=, 160
	i32.add 	$push692=, $52, $pop691
	i32.const	$push752=, 8
	i32.add 	$push331=, $pop692, $pop752
	i64.load	$push332=, 0($pop331)
	i64.select	$push333=, $pop330, $pop332, $45
	i64.select	$push334=, $pop333, $6, $35
	i64.select	$push348=, $pop347, $pop334, $51
	i64.select	$push349=, $pop348, $2, $39
	i64.or  	$push354=, $pop353, $pop349
	i32.const	$push701=, 256
	i32.add 	$push702=, $52, $pop701
	i32.const	$push751=, 8
	i32.add 	$push355=, $pop702, $pop751
	i64.load	$push356=, 0($pop355)
	i64.const	$push750=, 0
	i64.select	$push357=, $pop356, $pop750, $47
	i64.const	$push749=, 0
	i64.select	$push358=, $pop357, $pop749, $49
	i64.select	$push359=, $pop354, $pop358, $43
	i64.select	$push360=, $pop359, $10, $33
	i64.store	0($pop362), $pop360
	i32.const	$push389=, 64
	i32.add 	$push390=, $0, $pop389
	i64.load	$push380=, 896($52)
	i64.const	$push748=, 0
	i64.select	$push381=, $pop380, $pop748, $41
	i64.const	$push747=, 0
	i64.select	$push382=, $pop381, $pop747, $42
	i64.load	$push369=, 0($52)
	i64.load	$push370=, 16($52)
	i64.or  	$push371=, $pop369, $pop370
	i64.load	$push372=, 32($52)
	i64.select	$push373=, $pop371, $pop372, $50
	i64.select	$push374=, $pop373, $1, $39
	i64.load	$push375=, 64($52)
	i64.const	$push746=, 0
	i64.select	$push376=, $pop375, $pop746, $34
	i64.or  	$push377=, $pop374, $pop376
	i64.load	$push363=, 128($52)
	i64.load	$push364=, 144($52)
	i64.or  	$push365=, $pop363, $pop364
	i64.load	$push366=, 160($52)
	i64.select	$push367=, $pop365, $pop366, $45
	i64.select	$push368=, $pop367, $5, $35
	i64.select	$push378=, $pop377, $pop368, $51
	i64.select	$push379=, $pop378, $1, $39
	i64.or  	$push383=, $pop382, $pop379
	i64.load	$push384=, 256($52)
	i64.const	$push745=, 0
	i64.select	$push385=, $pop384, $pop745, $47
	i64.const	$push744=, 0
	i64.select	$push386=, $pop385, $pop744, $49
	i64.select	$push387=, $pop383, $pop386, $43
	i64.select	$push388=, $pop387, $9, $33
	i64.store	0($pop390), $pop388
	i32.const	$push432=, 88
	i32.add 	$push433=, $0, $pop432
	i32.const	$push703=, 912
	i32.add 	$push704=, $52, $pop703
	i32.const	$push743=, 8
	i32.add 	$push391=, $pop704, $pop743
	i64.load	$push392=, 0($pop391)
	i32.const	$push705=, 928
	i32.add 	$push706=, $52, $pop705
	i32.const	$push742=, 8
	i32.add 	$push393=, $pop706, $pop742
	i64.load	$push394=, 0($pop393)
	i64.or  	$push395=, $pop392, $pop394
	i32.const	$push707=, 944
	i32.add 	$push708=, $52, $pop707
	i32.const	$push741=, 8
	i32.add 	$push396=, $pop708, $pop741
	i64.load	$push397=, 0($pop396)
	i64.select	$push398=, $pop395, $pop397, $41
	i64.select	$push399=, $pop398, $12, $33
	i64.const	$push740=, 0
	i64.select	$push400=, $pop399, $pop740, $42
	i32.const	$push715=, 48
	i32.add 	$push716=, $52, $pop715
	i32.const	$push739=, 8
	i32.add 	$push410=, $pop716, $pop739
	i64.load	$push411=, 0($pop410)
	i64.const	$push738=, 0
	i64.select	$push412=, $pop411, $pop738, $50
	i32.const	$push709=, 80
	i32.add 	$push710=, $52, $pop709
	i32.const	$push737=, 8
	i32.add 	$push401=, $pop710, $pop737
	i64.load	$push402=, 0($pop401)
	i32.const	$push711=, 96
	i32.add 	$push712=, $52, $pop711
	i32.const	$push736=, 8
	i32.add 	$push403=, $pop712, $pop736
	i64.load	$push404=, 0($pop403)
	i64.or  	$push405=, $pop402, $pop404
	i32.const	$push713=, 112
	i32.add 	$push714=, $52, $pop713
	i32.const	$push735=, 8
	i32.add 	$push406=, $pop714, $pop735
	i64.load	$push407=, 0($pop406)
	i64.select	$push408=, $pop405, $pop407, $34
	i64.select	$push409=, $pop408, $8, $40
	i64.or  	$push413=, $pop412, $pop409
	i32.const	$push717=, 176
	i32.add 	$push718=, $52, $pop717
	i32.const	$push734=, 8
	i32.add 	$push414=, $pop718, $pop734
	i64.load	$push415=, 0($pop414)
	i64.const	$push733=, 0
	i64.select	$push416=, $pop415, $pop733, $45
	i64.select	$push417=, $pop413, $pop416, $51
	i64.select	$push418=, $pop417, $4, $39
	i64.or  	$push419=, $pop400, $pop418
	i32.const	$push721=, 272
	i32.add 	$push722=, $52, $pop721
	i32.const	$push732=, 8
	i32.add 	$push422=, $pop722, $pop732
	i64.load	$push423=, 0($pop422)
	i32.const	$push719=, 288
	i32.add 	$push720=, $52, $pop719
	i32.const	$push731=, 8
	i32.add 	$push420=, $pop720, $pop731
	i64.load	$push421=, 0($pop420)
	i64.or  	$push424=, $pop423, $pop421
	i32.const	$push723=, 304
	i32.add 	$push724=, $52, $pop723
	i32.const	$push730=, 8
	i32.add 	$push425=, $pop724, $pop730
	i64.load	$push426=, 0($pop425)
	i64.select	$push427=, $pop424, $pop426, $47
	i64.select	$push428=, $pop427, $4, $37
	i64.const	$push729=, 0
	i64.select	$push429=, $pop428, $pop729, $49
	i64.select	$push430=, $pop419, $pop429, $43
	i64.select	$push431=, $pop430, $12, $33
	i64.store	0($pop433), $pop431
	i32.const	$push464=, 80
	i32.add 	$push465=, $0, $pop464
	i64.load	$push434=, 912($52)
	i64.load	$push435=, 928($52)
	i64.or  	$push436=, $pop434, $pop435
	i64.load	$push437=, 944($52)
	i64.select	$push438=, $pop436, $pop437, $41
	i64.select	$push439=, $pop438, $11, $33
	i64.const	$push728=, 0
	i64.select	$push440=, $pop439, $pop728, $42
	i64.load	$push447=, 48($52)
	i64.const	$push727=, 0
	i64.select	$push448=, $pop447, $pop727, $50
	i64.load	$push441=, 80($52)
	i64.load	$push442=, 96($52)
	i64.or  	$push443=, $pop441, $pop442
	i64.load	$push444=, 112($52)
	i64.select	$push445=, $pop443, $pop444, $34
	i64.select	$push446=, $pop445, $7, $40
	i64.or  	$push449=, $pop448, $pop446
	i64.load	$push450=, 176($52)
	i64.const	$push726=, 0
	i64.select	$push451=, $pop450, $pop726, $45
	i64.select	$push452=, $pop449, $pop451, $51
	i64.select	$push453=, $pop452, $3, $39
	i64.or  	$push454=, $pop440, $pop453
	i64.load	$push456=, 272($52)
	i64.load	$push455=, 288($52)
	i64.or  	$push457=, $pop456, $pop455
	i64.load	$push458=, 304($52)
	i64.select	$push459=, $pop457, $pop458, $47
	i64.select	$push460=, $pop459, $3, $37
	i64.const	$push725=, 0
	i64.select	$push461=, $pop460, $pop725, $49
	i64.select	$push462=, $pop454, $pop461, $43
	i64.select	$push463=, $pop462, $11, $33
	i64.store	0($pop465), $pop463
	i32.const	$push472=, 0
	i32.const	$push470=, 1024
	i32.add 	$push471=, $52, $pop470
	i32.store	__stack_pointer($pop472), $pop471
	return
	.endfunc
.Lfunc_end5:
	.size	bigshift, .Lfunc_end5-bigshift


