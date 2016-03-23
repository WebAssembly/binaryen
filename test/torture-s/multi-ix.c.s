	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/multi-ix.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push342=, __stack_pointer
	i32.load	$push343=, 0($pop342)
	i32.const	$push344=, 80480
	i32.sub 	$41=, $pop343, $pop344
	i32.const	$push345=, __stack_pointer
	i32.store	$discard=, 0($pop345), $41
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push349=, 320
	i32.add 	$push350=, $41, $pop349
	i32.const	$push341=, 156
	i32.add 	$push2=, $pop350, $pop341
	i32.const	$push351=, 480
	i32.add 	$push352=, $41, $pop351
	i32.store	$discard=, 0($pop2), $pop352
	i32.const	$push353=, 320
	i32.add 	$push354=, $41, $pop353
	i32.const	$push340=, 152
	i32.add 	$push3=, $pop354, $pop340
	i32.const	$push355=, 2480
	i32.add 	$push356=, $41, $pop355
	i32.store	$discard=, 0($pop3):p2align=3, $pop356
	i32.const	$push357=, 320
	i32.add 	$push358=, $41, $pop357
	i32.const	$push339=, 148
	i32.add 	$push4=, $pop358, $pop339
	i32.const	$push359=, 4480
	i32.add 	$push360=, $41, $pop359
	i32.store	$discard=, 0($pop4), $pop360
	i32.const	$push361=, 320
	i32.add 	$push362=, $41, $pop361
	i32.const	$push338=, 144
	i32.add 	$push5=, $pop362, $pop338
	i32.const	$push363=, 6480
	i32.add 	$push364=, $41, $pop363
	i32.store	$discard=, 0($pop5):p2align=4, $pop364
	i32.const	$push365=, 320
	i32.add 	$push366=, $41, $pop365
	i32.const	$push337=, 140
	i32.add 	$push6=, $pop366, $pop337
	i32.const	$push367=, 8480
	i32.add 	$push368=, $41, $pop367
	i32.store	$discard=, 0($pop6), $pop368
	i32.const	$push369=, 320
	i32.add 	$push370=, $41, $pop369
	i32.const	$push336=, 136
	i32.add 	$push7=, $pop370, $pop336
	i32.const	$push371=, 10480
	i32.add 	$push372=, $41, $pop371
	i32.store	$discard=, 0($pop7):p2align=3, $pop372
	i32.const	$push373=, 320
	i32.add 	$push374=, $41, $pop373
	i32.const	$push335=, 132
	i32.add 	$push8=, $pop374, $pop335
	i32.const	$push375=, 12480
	i32.add 	$push376=, $41, $pop375
	i32.store	$discard=, 0($pop8), $pop376
	i32.const	$push377=, 320
	i32.add 	$push378=, $41, $pop377
	i32.const	$push334=, 128
	i32.add 	$push9=, $pop378, $pop334
	i32.const	$push379=, 14480
	i32.add 	$push380=, $41, $pop379
	i32.store	$discard=, 0($pop9):p2align=4, $pop380
	i32.const	$push381=, 320
	i32.add 	$push382=, $41, $pop381
	i32.const	$push333=, 124
	i32.add 	$push10=, $pop382, $pop333
	i32.const	$push383=, 16480
	i32.add 	$push384=, $41, $pop383
	i32.store	$discard=, 0($pop10), $pop384
	i32.const	$push385=, 320
	i32.add 	$push386=, $41, $pop385
	i32.const	$push332=, 120
	i32.add 	$push11=, $pop386, $pop332
	i32.const	$push387=, 18480
	i32.add 	$push388=, $41, $pop387
	i32.store	$discard=, 0($pop11):p2align=3, $pop388
	i32.const	$push389=, 320
	i32.add 	$push390=, $41, $pop389
	i32.const	$push331=, 116
	i32.add 	$push12=, $pop390, $pop331
	i32.const	$push391=, 20480
	i32.add 	$push392=, $41, $pop391
	i32.store	$discard=, 0($pop12), $pop392
	i32.const	$push393=, 320
	i32.add 	$push394=, $41, $pop393
	i32.const	$push330=, 112
	i32.add 	$push13=, $pop394, $pop330
	i32.const	$push395=, 22480
	i32.add 	$push396=, $41, $pop395
	i32.store	$discard=, 0($pop13):p2align=4, $pop396
	i32.const	$push397=, 320
	i32.add 	$push398=, $41, $pop397
	i32.const	$push329=, 108
	i32.add 	$push14=, $pop398, $pop329
	i32.const	$push399=, 24480
	i32.add 	$push400=, $41, $pop399
	i32.store	$discard=, 0($pop14), $pop400
	i32.const	$push401=, 320
	i32.add 	$push402=, $41, $pop401
	i32.const	$push328=, 104
	i32.add 	$push15=, $pop402, $pop328
	i32.const	$push403=, 26480
	i32.add 	$push404=, $41, $pop403
	i32.store	$discard=, 0($pop15):p2align=3, $pop404
	i32.const	$push405=, 320
	i32.add 	$push406=, $41, $pop405
	i32.const	$push327=, 100
	i32.add 	$push16=, $pop406, $pop327
	i32.const	$push407=, 28480
	i32.add 	$push408=, $41, $pop407
	i32.store	$discard=, 0($pop16), $pop408
	i32.const	$push409=, 320
	i32.add 	$push410=, $41, $pop409
	i32.const	$push326=, 96
	i32.add 	$push17=, $pop410, $pop326
	i32.const	$push411=, 30480
	i32.add 	$push412=, $41, $pop411
	i32.store	$discard=, 0($pop17):p2align=4, $pop412
	i32.const	$push413=, 320
	i32.add 	$push414=, $41, $pop413
	i32.const	$push325=, 92
	i32.add 	$push18=, $pop414, $pop325
	i32.const	$push415=, 32480
	i32.add 	$push416=, $41, $pop415
	i32.store	$discard=, 0($pop18), $pop416
	i32.const	$push417=, 320
	i32.add 	$push418=, $41, $pop417
	i32.const	$push324=, 88
	i32.add 	$push19=, $pop418, $pop324
	i32.const	$push419=, 34480
	i32.add 	$push420=, $41, $pop419
	i32.store	$discard=, 0($pop19):p2align=3, $pop420
	i32.const	$push421=, 320
	i32.add 	$push422=, $41, $pop421
	i32.const	$push323=, 84
	i32.add 	$push20=, $pop422, $pop323
	i32.const	$push423=, 36480
	i32.add 	$push424=, $41, $pop423
	i32.store	$discard=, 0($pop20), $pop424
	i32.const	$push425=, 320
	i32.add 	$push426=, $41, $pop425
	i32.const	$push322=, 80
	i32.add 	$push21=, $pop426, $pop322
	i32.const	$push427=, 38480
	i32.add 	$push428=, $41, $pop427
	i32.store	$discard=, 0($pop21):p2align=4, $pop428
	i32.const	$push429=, 320
	i32.add 	$push430=, $41, $pop429
	i32.const	$push321=, 76
	i32.add 	$push22=, $pop430, $pop321
	i32.const	$push431=, 40480
	i32.add 	$push432=, $41, $pop431
	i32.store	$discard=, 0($pop22), $pop432
	i32.const	$push433=, 320
	i32.add 	$push434=, $41, $pop433
	i32.const	$push320=, 72
	i32.add 	$push23=, $pop434, $pop320
	i32.const	$push435=, 42480
	i32.add 	$push436=, $41, $pop435
	i32.store	$discard=, 0($pop23):p2align=3, $pop436
	i32.const	$push437=, 320
	i32.add 	$push438=, $41, $pop437
	i32.const	$push319=, 68
	i32.add 	$push24=, $pop438, $pop319
	i32.const	$push439=, 44480
	i32.add 	$push440=, $41, $pop439
	i32.store	$discard=, 0($pop24), $pop440
	i32.const	$push441=, 320
	i32.add 	$push442=, $41, $pop441
	i32.const	$push318=, 64
	i32.add 	$push25=, $pop442, $pop318
	i32.const	$push443=, 46480
	i32.add 	$push444=, $41, $pop443
	i32.store	$discard=, 0($pop25):p2align=4, $pop444
	i32.const	$push445=, 320
	i32.add 	$push446=, $41, $pop445
	i32.const	$push317=, 60
	i32.add 	$push26=, $pop446, $pop317
	i32.const	$push447=, 48480
	i32.add 	$push448=, $41, $pop447
	i32.store	$discard=, 0($pop26), $pop448
	i32.const	$push449=, 320
	i32.add 	$push450=, $41, $pop449
	i32.const	$push316=, 56
	i32.add 	$push27=, $pop450, $pop316
	i32.const	$push451=, 50480
	i32.add 	$push452=, $41, $pop451
	i32.store	$discard=, 0($pop27):p2align=3, $pop452
	i32.const	$push453=, 320
	i32.add 	$push454=, $41, $pop453
	i32.const	$push315=, 52
	i32.add 	$push28=, $pop454, $pop315
	i32.const	$push455=, 52480
	i32.add 	$push456=, $41, $pop455
	i32.store	$discard=, 0($pop28), $pop456
	i32.const	$push457=, 320
	i32.add 	$push458=, $41, $pop457
	i32.const	$push314=, 48
	i32.add 	$push29=, $pop458, $pop314
	i32.const	$push459=, 54480
	i32.add 	$push460=, $41, $pop459
	i32.store	$discard=, 0($pop29):p2align=4, $pop460
	i32.const	$push461=, 320
	i32.add 	$push462=, $41, $pop461
	i32.const	$push313=, 44
	i32.add 	$push30=, $pop462, $pop313
	i32.const	$push463=, 56480
	i32.add 	$push464=, $41, $pop463
	i32.store	$discard=, 0($pop30), $pop464
	i32.const	$push465=, 320
	i32.add 	$push466=, $41, $pop465
	i32.const	$push312=, 40
	i32.add 	$push31=, $pop466, $pop312
	i32.const	$push467=, 58480
	i32.add 	$push468=, $41, $pop467
	i32.store	$discard=, 0($pop31):p2align=3, $pop468
	i32.const	$push469=, 320
	i32.add 	$push470=, $41, $pop469
	i32.const	$push311=, 36
	i32.add 	$push32=, $pop470, $pop311
	i32.const	$push471=, 60480
	i32.add 	$push472=, $41, $pop471
	i32.store	$discard=, 0($pop32), $pop472
	i32.const	$push473=, 320
	i32.add 	$push474=, $41, $pop473
	i32.const	$push310=, 32
	i32.add 	$push33=, $pop474, $pop310
	i32.const	$push475=, 62480
	i32.add 	$push476=, $41, $pop475
	i32.store	$discard=, 0($pop33):p2align=4, $pop476
	i32.const	$push477=, 320
	i32.add 	$push478=, $41, $pop477
	i32.const	$push309=, 28
	i32.add 	$push34=, $pop478, $pop309
	i32.const	$push479=, 64480
	i32.add 	$push480=, $41, $pop479
	i32.store	$discard=, 0($pop34), $pop480
	i32.const	$push481=, 320
	i32.add 	$push482=, $41, $pop481
	i32.const	$push308=, 24
	i32.add 	$push35=, $pop482, $pop308
	i32.const	$push483=, 66480
	i32.add 	$push484=, $41, $pop483
	i32.store	$discard=, 0($pop35):p2align=3, $pop484
	i32.const	$push485=, 320
	i32.add 	$push486=, $41, $pop485
	i32.const	$push307=, 20
	i32.add 	$push36=, $pop486, $pop307
	i32.const	$push487=, 68480
	i32.add 	$push488=, $41, $pop487
	i32.store	$discard=, 0($pop36), $pop488
	i32.const	$push489=, 320
	i32.add 	$push490=, $41, $pop489
	i32.const	$push306=, 16
	i32.add 	$push37=, $pop490, $pop306
	i32.const	$push491=, 70480
	i32.add 	$push492=, $41, $pop491
	i32.store	$discard=, 0($pop37):p2align=4, $pop492
	i32.const	$push493=, 72480
	i32.add 	$push494=, $41, $pop493
	i32.store	$discard=, 332($41), $pop494
	i32.const	$push495=, 74480
	i32.add 	$push496=, $41, $pop495
	i32.store	$discard=, 328($41):p2align=3, $pop496
	i32.const	$push497=, 76480
	i32.add 	$push498=, $41, $pop497
	i32.store	$discard=, 324($41), $pop498
	i32.const	$push499=, 78480
	i32.add 	$push500=, $41, $pop499
	i32.store	$discard=, 320($41):p2align=4, $pop500
	i32.const	$push305=, 40
	i32.const	$push501=, 320
	i32.add 	$push502=, $41, $pop501
	call    	s@FUNCTION, $pop305, $pop502
	i32.load	$1=, 78480($41):p2align=4
	i32.load	$2=, 76480($41):p2align=4
	i32.load	$3=, 74480($41):p2align=4
	i32.load	$4=, 72480($41):p2align=4
	i32.load	$5=, 70480($41):p2align=4
	i32.load	$6=, 68480($41):p2align=4
	i32.load	$7=, 66480($41):p2align=4
	i32.load	$8=, 64480($41):p2align=4
	i32.load	$9=, 62480($41):p2align=4
	i32.load	$10=, 60480($41):p2align=4
	i32.load	$11=, 58480($41):p2align=4
	i32.load	$12=, 56480($41):p2align=4
	i32.load	$13=, 54480($41):p2align=4
	i32.load	$14=, 52480($41):p2align=4
	i32.load	$15=, 50480($41):p2align=4
	i32.load	$16=, 48480($41):p2align=4
	i32.load	$17=, 46480($41):p2align=4
	i32.load	$18=, 44480($41):p2align=4
	i32.load	$19=, 42480($41):p2align=4
	i32.load	$20=, 40480($41):p2align=4
	i32.load	$21=, 38480($41):p2align=4
	i32.load	$22=, 36480($41):p2align=4
	i32.load	$23=, 34480($41):p2align=4
	i32.load	$24=, 32480($41):p2align=4
	i32.load	$25=, 30480($41):p2align=4
	i32.load	$26=, 28480($41):p2align=4
	i32.load	$27=, 26480($41):p2align=4
	i32.load	$28=, 24480($41):p2align=4
	i32.load	$29=, 22480($41):p2align=4
	i32.load	$30=, 20480($41):p2align=4
	i32.load	$31=, 18480($41):p2align=4
	i32.load	$32=, 16480($41):p2align=4
	i32.load	$33=, 14480($41):p2align=4
	i32.load	$34=, 12480($41):p2align=4
	i32.load	$35=, 10480($41):p2align=4
	i32.load	$36=, 8480($41):p2align=4
	i32.load	$37=, 6480($41):p2align=4
	i32.load	$38=, 4480($41):p2align=4
	i32.load	$39=, 2480($41):p2align=4
	i32.load	$40=, 480($41):p2align=4
	i32.const	$push503=, 160
	i32.add 	$push504=, $41, $pop503
	i32.const	$push304=, 156
	i32.add 	$push38=, $pop504, $pop304
	i32.const	$push505=, 480
	i32.add 	$push506=, $41, $pop505
	i32.store	$discard=, 0($pop38), $pop506
	i32.const	$push507=, 160
	i32.add 	$push508=, $41, $pop507
	i32.const	$push303=, 152
	i32.add 	$push39=, $pop508, $pop303
	i32.const	$push509=, 2480
	i32.add 	$push510=, $41, $pop509
	i32.store	$discard=, 0($pop39):p2align=3, $pop510
	i32.const	$push511=, 160
	i32.add 	$push512=, $41, $pop511
	i32.const	$push302=, 148
	i32.add 	$push40=, $pop512, $pop302
	i32.const	$push513=, 4480
	i32.add 	$push514=, $41, $pop513
	i32.store	$discard=, 0($pop40), $pop514
	i32.const	$push515=, 160
	i32.add 	$push516=, $41, $pop515
	i32.const	$push301=, 144
	i32.add 	$push41=, $pop516, $pop301
	i32.const	$push517=, 6480
	i32.add 	$push518=, $41, $pop517
	i32.store	$discard=, 0($pop41):p2align=4, $pop518
	i32.const	$push519=, 160
	i32.add 	$push520=, $41, $pop519
	i32.const	$push300=, 140
	i32.add 	$push42=, $pop520, $pop300
	i32.const	$push521=, 8480
	i32.add 	$push522=, $41, $pop521
	i32.store	$discard=, 0($pop42), $pop522
	i32.const	$push523=, 160
	i32.add 	$push524=, $41, $pop523
	i32.const	$push299=, 136
	i32.add 	$push43=, $pop524, $pop299
	i32.const	$push525=, 10480
	i32.add 	$push526=, $41, $pop525
	i32.store	$discard=, 0($pop43):p2align=3, $pop526
	i32.const	$push527=, 160
	i32.add 	$push528=, $41, $pop527
	i32.const	$push298=, 132
	i32.add 	$push44=, $pop528, $pop298
	i32.const	$push529=, 12480
	i32.add 	$push530=, $41, $pop529
	i32.store	$discard=, 0($pop44), $pop530
	i32.const	$push531=, 160
	i32.add 	$push532=, $41, $pop531
	i32.const	$push297=, 128
	i32.add 	$push45=, $pop532, $pop297
	i32.const	$push533=, 14480
	i32.add 	$push534=, $41, $pop533
	i32.store	$discard=, 0($pop45):p2align=4, $pop534
	i32.const	$push535=, 160
	i32.add 	$push536=, $41, $pop535
	i32.const	$push296=, 124
	i32.add 	$push46=, $pop536, $pop296
	i32.const	$push537=, 16480
	i32.add 	$push538=, $41, $pop537
	i32.store	$discard=, 0($pop46), $pop538
	i32.const	$push539=, 160
	i32.add 	$push540=, $41, $pop539
	i32.const	$push295=, 120
	i32.add 	$push47=, $pop540, $pop295
	i32.const	$push541=, 18480
	i32.add 	$push542=, $41, $pop541
	i32.store	$discard=, 0($pop47):p2align=3, $pop542
	i32.const	$push543=, 160
	i32.add 	$push544=, $41, $pop543
	i32.const	$push294=, 116
	i32.add 	$push48=, $pop544, $pop294
	i32.const	$push545=, 20480
	i32.add 	$push546=, $41, $pop545
	i32.store	$discard=, 0($pop48), $pop546
	i32.const	$push547=, 160
	i32.add 	$push548=, $41, $pop547
	i32.const	$push293=, 112
	i32.add 	$push49=, $pop548, $pop293
	i32.const	$push549=, 22480
	i32.add 	$push550=, $41, $pop549
	i32.store	$discard=, 0($pop49):p2align=4, $pop550
	i32.const	$push551=, 160
	i32.add 	$push552=, $41, $pop551
	i32.const	$push292=, 108
	i32.add 	$push50=, $pop552, $pop292
	i32.const	$push553=, 24480
	i32.add 	$push554=, $41, $pop553
	i32.store	$discard=, 0($pop50), $pop554
	i32.const	$push555=, 160
	i32.add 	$push556=, $41, $pop555
	i32.const	$push291=, 104
	i32.add 	$push51=, $pop556, $pop291
	i32.const	$push557=, 26480
	i32.add 	$push558=, $41, $pop557
	i32.store	$discard=, 0($pop51):p2align=3, $pop558
	i32.const	$push559=, 160
	i32.add 	$push560=, $41, $pop559
	i32.const	$push290=, 100
	i32.add 	$push52=, $pop560, $pop290
	i32.const	$push561=, 28480
	i32.add 	$push562=, $41, $pop561
	i32.store	$discard=, 0($pop52), $pop562
	i32.const	$push563=, 160
	i32.add 	$push564=, $41, $pop563
	i32.const	$push289=, 96
	i32.add 	$push53=, $pop564, $pop289
	i32.const	$push565=, 30480
	i32.add 	$push566=, $41, $pop565
	i32.store	$discard=, 0($pop53):p2align=4, $pop566
	i32.const	$push567=, 160
	i32.add 	$push568=, $41, $pop567
	i32.const	$push288=, 92
	i32.add 	$push54=, $pop568, $pop288
	i32.const	$push569=, 32480
	i32.add 	$push570=, $41, $pop569
	i32.store	$discard=, 0($pop54), $pop570
	i32.const	$push571=, 160
	i32.add 	$push572=, $41, $pop571
	i32.const	$push287=, 88
	i32.add 	$push55=, $pop572, $pop287
	i32.const	$push573=, 34480
	i32.add 	$push574=, $41, $pop573
	i32.store	$discard=, 0($pop55):p2align=3, $pop574
	i32.const	$push575=, 160
	i32.add 	$push576=, $41, $pop575
	i32.const	$push286=, 84
	i32.add 	$push56=, $pop576, $pop286
	i32.const	$push577=, 36480
	i32.add 	$push578=, $41, $pop577
	i32.store	$discard=, 0($pop56), $pop578
	i32.const	$push579=, 160
	i32.add 	$push580=, $41, $pop579
	i32.const	$push285=, 80
	i32.add 	$push57=, $pop580, $pop285
	i32.const	$push581=, 38480
	i32.add 	$push582=, $41, $pop581
	i32.store	$discard=, 0($pop57):p2align=4, $pop582
	i32.const	$push583=, 160
	i32.add 	$push584=, $41, $pop583
	i32.const	$push284=, 76
	i32.add 	$push58=, $pop584, $pop284
	i32.const	$push585=, 40480
	i32.add 	$push586=, $41, $pop585
	i32.store	$discard=, 0($pop58), $pop586
	i32.const	$push587=, 160
	i32.add 	$push588=, $41, $pop587
	i32.const	$push283=, 72
	i32.add 	$push59=, $pop588, $pop283
	i32.const	$push589=, 42480
	i32.add 	$push590=, $41, $pop589
	i32.store	$discard=, 0($pop59):p2align=3, $pop590
	i32.const	$push591=, 160
	i32.add 	$push592=, $41, $pop591
	i32.const	$push282=, 68
	i32.add 	$push60=, $pop592, $pop282
	i32.const	$push593=, 44480
	i32.add 	$push594=, $41, $pop593
	i32.store	$discard=, 0($pop60), $pop594
	i32.const	$push595=, 160
	i32.add 	$push596=, $41, $pop595
	i32.const	$push281=, 64
	i32.add 	$push61=, $pop596, $pop281
	i32.const	$push597=, 46480
	i32.add 	$push598=, $41, $pop597
	i32.store	$discard=, 0($pop61):p2align=4, $pop598
	i32.const	$push599=, 160
	i32.add 	$push600=, $41, $pop599
	i32.const	$push280=, 60
	i32.add 	$push62=, $pop600, $pop280
	i32.const	$push601=, 48480
	i32.add 	$push602=, $41, $pop601
	i32.store	$discard=, 0($pop62), $pop602
	i32.const	$push603=, 160
	i32.add 	$push604=, $41, $pop603
	i32.const	$push279=, 56
	i32.add 	$push63=, $pop604, $pop279
	i32.const	$push605=, 50480
	i32.add 	$push606=, $41, $pop605
	i32.store	$discard=, 0($pop63):p2align=3, $pop606
	i32.const	$push607=, 160
	i32.add 	$push608=, $41, $pop607
	i32.const	$push278=, 52
	i32.add 	$push64=, $pop608, $pop278
	i32.const	$push609=, 52480
	i32.add 	$push610=, $41, $pop609
	i32.store	$discard=, 0($pop64), $pop610
	i32.const	$push611=, 160
	i32.add 	$push612=, $41, $pop611
	i32.const	$push277=, 48
	i32.add 	$push65=, $pop612, $pop277
	i32.const	$push613=, 54480
	i32.add 	$push614=, $41, $pop613
	i32.store	$discard=, 0($pop65):p2align=4, $pop614
	i32.const	$push615=, 160
	i32.add 	$push616=, $41, $pop615
	i32.const	$push276=, 44
	i32.add 	$push66=, $pop616, $pop276
	i32.const	$push617=, 56480
	i32.add 	$push618=, $41, $pop617
	i32.store	$discard=, 0($pop66), $pop618
	i32.const	$push619=, 160
	i32.add 	$push620=, $41, $pop619
	i32.const	$push275=, 40
	i32.add 	$push67=, $pop620, $pop275
	i32.const	$push621=, 58480
	i32.add 	$push622=, $41, $pop621
	i32.store	$discard=, 0($pop67):p2align=3, $pop622
	i32.const	$push623=, 160
	i32.add 	$push624=, $41, $pop623
	i32.const	$push274=, 36
	i32.add 	$push68=, $pop624, $pop274
	i32.const	$push625=, 60480
	i32.add 	$push626=, $41, $pop625
	i32.store	$discard=, 0($pop68), $pop626
	i32.const	$push627=, 160
	i32.add 	$push628=, $41, $pop627
	i32.const	$push273=, 32
	i32.add 	$push69=, $pop628, $pop273
	i32.const	$push629=, 62480
	i32.add 	$push630=, $41, $pop629
	i32.store	$discard=, 0($pop69):p2align=4, $pop630
	i32.const	$push631=, 160
	i32.add 	$push632=, $41, $pop631
	i32.const	$push272=, 28
	i32.add 	$push70=, $pop632, $pop272
	i32.const	$push633=, 64480
	i32.add 	$push634=, $41, $pop633
	i32.store	$discard=, 0($pop70), $pop634
	i32.const	$push635=, 160
	i32.add 	$push636=, $41, $pop635
	i32.const	$push271=, 24
	i32.add 	$push71=, $pop636, $pop271
	i32.const	$push637=, 66480
	i32.add 	$push638=, $41, $pop637
	i32.store	$discard=, 0($pop71):p2align=3, $pop638
	i32.const	$push639=, 160
	i32.add 	$push640=, $41, $pop639
	i32.const	$push270=, 20
	i32.add 	$push72=, $pop640, $pop270
	i32.const	$push641=, 68480
	i32.add 	$push642=, $41, $pop641
	i32.store	$discard=, 0($pop72), $pop642
	i32.const	$push643=, 160
	i32.add 	$push644=, $41, $pop643
	i32.const	$push269=, 16
	i32.add 	$push73=, $pop644, $pop269
	i32.const	$push645=, 70480
	i32.add 	$push646=, $41, $pop645
	i32.store	$discard=, 0($pop73):p2align=4, $pop646
	i32.const	$push647=, 72480
	i32.add 	$push648=, $41, $pop647
	i32.store	$discard=, 172($41), $pop648
	i32.const	$push649=, 74480
	i32.add 	$push650=, $41, $pop649
	i32.store	$discard=, 168($41):p2align=3, $pop650
	i32.const	$push651=, 76480
	i32.add 	$push652=, $41, $pop651
	i32.store	$discard=, 164($41), $pop652
	i32.const	$push653=, 78480
	i32.add 	$push654=, $41, $pop653
	i32.store	$discard=, 160($41):p2align=4, $pop654
	i32.const	$push268=, 40
	i32.const	$push655=, 160
	i32.add 	$push656=, $41, $pop655
	call    	z@FUNCTION, $pop268, $pop656
	i32.const	$push657=, 78480
	i32.add 	$push658=, $41, $pop657
	i32.const	$push267=, 2
	i32.shl 	$push74=, $1, $pop267
	i32.add 	$push75=, $pop658, $pop74
	i32.store	$discard=, 0($pop75), $1
	i32.const	$push659=, 76480
	i32.add 	$push660=, $41, $pop659
	i32.const	$push266=, 2
	i32.shl 	$push76=, $2, $pop266
	i32.add 	$push77=, $pop660, $pop76
	i32.store	$discard=, 0($pop77), $2
	i32.const	$push661=, 74480
	i32.add 	$push662=, $41, $pop661
	i32.const	$push265=, 2
	i32.shl 	$push78=, $3, $pop265
	i32.add 	$push79=, $pop662, $pop78
	i32.store	$discard=, 0($pop79), $3
	i32.const	$push663=, 72480
	i32.add 	$push664=, $41, $pop663
	i32.const	$push264=, 2
	i32.shl 	$push80=, $4, $pop264
	i32.add 	$push81=, $pop664, $pop80
	i32.store	$discard=, 0($pop81), $4
	i32.const	$push665=, 70480
	i32.add 	$push666=, $41, $pop665
	i32.const	$push263=, 2
	i32.shl 	$push82=, $5, $pop263
	i32.add 	$push83=, $pop666, $pop82
	i32.store	$discard=, 0($pop83), $5
	i32.const	$push667=, 68480
	i32.add 	$push668=, $41, $pop667
	i32.const	$push262=, 2
	i32.shl 	$push84=, $6, $pop262
	i32.add 	$push85=, $pop668, $pop84
	i32.store	$discard=, 0($pop85), $6
	i32.const	$push669=, 66480
	i32.add 	$push670=, $41, $pop669
	i32.const	$push261=, 2
	i32.shl 	$push86=, $7, $pop261
	i32.add 	$push87=, $pop670, $pop86
	i32.store	$discard=, 0($pop87), $7
	i32.const	$push671=, 64480
	i32.add 	$push672=, $41, $pop671
	i32.const	$push260=, 2
	i32.shl 	$push88=, $8, $pop260
	i32.add 	$push89=, $pop672, $pop88
	i32.store	$discard=, 0($pop89), $8
	i32.const	$push673=, 62480
	i32.add 	$push674=, $41, $pop673
	i32.const	$push259=, 2
	i32.shl 	$push90=, $9, $pop259
	i32.add 	$push91=, $pop674, $pop90
	i32.store	$discard=, 0($pop91), $9
	i32.const	$push675=, 60480
	i32.add 	$push676=, $41, $pop675
	i32.const	$push258=, 2
	i32.shl 	$push92=, $10, $pop258
	i32.add 	$push93=, $pop676, $pop92
	i32.store	$discard=, 0($pop93), $10
	i32.const	$push677=, 58480
	i32.add 	$push678=, $41, $pop677
	i32.const	$push257=, 2
	i32.shl 	$push94=, $11, $pop257
	i32.add 	$push95=, $pop678, $pop94
	i32.store	$discard=, 0($pop95), $11
	i32.const	$push679=, 56480
	i32.add 	$push680=, $41, $pop679
	i32.const	$push256=, 2
	i32.shl 	$push96=, $12, $pop256
	i32.add 	$push97=, $pop680, $pop96
	i32.store	$discard=, 0($pop97), $12
	i32.const	$push681=, 54480
	i32.add 	$push682=, $41, $pop681
	i32.const	$push255=, 2
	i32.shl 	$push98=, $13, $pop255
	i32.add 	$push99=, $pop682, $pop98
	i32.store	$discard=, 0($pop99), $13
	i32.const	$push683=, 52480
	i32.add 	$push684=, $41, $pop683
	i32.const	$push254=, 2
	i32.shl 	$push100=, $14, $pop254
	i32.add 	$push101=, $pop684, $pop100
	i32.store	$discard=, 0($pop101), $14
	i32.const	$push685=, 50480
	i32.add 	$push686=, $41, $pop685
	i32.const	$push253=, 2
	i32.shl 	$push102=, $15, $pop253
	i32.add 	$push103=, $pop686, $pop102
	i32.store	$discard=, 0($pop103), $15
	i32.const	$push687=, 48480
	i32.add 	$push688=, $41, $pop687
	i32.const	$push252=, 2
	i32.shl 	$push104=, $16, $pop252
	i32.add 	$push105=, $pop688, $pop104
	i32.store	$discard=, 0($pop105), $16
	i32.const	$push689=, 46480
	i32.add 	$push690=, $41, $pop689
	i32.const	$push251=, 2
	i32.shl 	$push106=, $17, $pop251
	i32.add 	$push107=, $pop690, $pop106
	i32.store	$discard=, 0($pop107), $17
	i32.const	$push691=, 44480
	i32.add 	$push692=, $41, $pop691
	i32.const	$push250=, 2
	i32.shl 	$push108=, $18, $pop250
	i32.add 	$push109=, $pop692, $pop108
	i32.store	$discard=, 0($pop109), $18
	i32.const	$push693=, 42480
	i32.add 	$push694=, $41, $pop693
	i32.const	$push249=, 2
	i32.shl 	$push110=, $19, $pop249
	i32.add 	$push111=, $pop694, $pop110
	i32.store	$discard=, 0($pop111), $19
	i32.const	$push695=, 40480
	i32.add 	$push696=, $41, $pop695
	i32.const	$push248=, 2
	i32.shl 	$push112=, $20, $pop248
	i32.add 	$push113=, $pop696, $pop112
	i32.store	$discard=, 0($pop113), $20
	i32.const	$push697=, 38480
	i32.add 	$push698=, $41, $pop697
	i32.const	$push247=, 2
	i32.shl 	$push114=, $21, $pop247
	i32.add 	$push115=, $pop698, $pop114
	i32.store	$discard=, 0($pop115), $21
	i32.const	$push699=, 36480
	i32.add 	$push700=, $41, $pop699
	i32.const	$push246=, 2
	i32.shl 	$push116=, $22, $pop246
	i32.add 	$push117=, $pop700, $pop116
	i32.store	$discard=, 0($pop117), $22
	i32.const	$push701=, 34480
	i32.add 	$push702=, $41, $pop701
	i32.const	$push245=, 2
	i32.shl 	$push118=, $23, $pop245
	i32.add 	$push119=, $pop702, $pop118
	i32.store	$discard=, 0($pop119), $23
	i32.const	$push703=, 32480
	i32.add 	$push704=, $41, $pop703
	i32.const	$push244=, 2
	i32.shl 	$push120=, $24, $pop244
	i32.add 	$push121=, $pop704, $pop120
	i32.store	$discard=, 0($pop121), $24
	i32.const	$push705=, 30480
	i32.add 	$push706=, $41, $pop705
	i32.const	$push243=, 2
	i32.shl 	$push122=, $25, $pop243
	i32.add 	$push123=, $pop706, $pop122
	i32.store	$discard=, 0($pop123), $25
	i32.const	$push707=, 28480
	i32.add 	$push708=, $41, $pop707
	i32.const	$push242=, 2
	i32.shl 	$push124=, $26, $pop242
	i32.add 	$push125=, $pop708, $pop124
	i32.store	$discard=, 0($pop125), $26
	i32.const	$push709=, 26480
	i32.add 	$push710=, $41, $pop709
	i32.const	$push241=, 2
	i32.shl 	$push126=, $27, $pop241
	i32.add 	$push127=, $pop710, $pop126
	i32.store	$discard=, 0($pop127), $27
	i32.const	$push711=, 24480
	i32.add 	$push712=, $41, $pop711
	i32.const	$push240=, 2
	i32.shl 	$push128=, $28, $pop240
	i32.add 	$push129=, $pop712, $pop128
	i32.store	$discard=, 0($pop129), $28
	i32.const	$push713=, 22480
	i32.add 	$push714=, $41, $pop713
	i32.const	$push239=, 2
	i32.shl 	$push130=, $29, $pop239
	i32.add 	$push131=, $pop714, $pop130
	i32.store	$discard=, 0($pop131), $29
	i32.const	$push715=, 20480
	i32.add 	$push716=, $41, $pop715
	i32.const	$push238=, 2
	i32.shl 	$push132=, $30, $pop238
	i32.add 	$push133=, $pop716, $pop132
	i32.store	$discard=, 0($pop133), $30
	i32.const	$push717=, 18480
	i32.add 	$push718=, $41, $pop717
	i32.const	$push237=, 2
	i32.shl 	$push134=, $31, $pop237
	i32.add 	$push135=, $pop718, $pop134
	i32.store	$discard=, 0($pop135), $31
	i32.const	$push719=, 16480
	i32.add 	$push720=, $41, $pop719
	i32.const	$push236=, 2
	i32.shl 	$push136=, $32, $pop236
	i32.add 	$push137=, $pop720, $pop136
	i32.store	$discard=, 0($pop137), $32
	i32.const	$push721=, 14480
	i32.add 	$push722=, $41, $pop721
	i32.const	$push235=, 2
	i32.shl 	$push138=, $33, $pop235
	i32.add 	$push139=, $pop722, $pop138
	i32.store	$discard=, 0($pop139), $33
	i32.const	$push723=, 12480
	i32.add 	$push724=, $41, $pop723
	i32.const	$push234=, 2
	i32.shl 	$push140=, $34, $pop234
	i32.add 	$push141=, $pop724, $pop140
	i32.store	$discard=, 0($pop141), $34
	i32.const	$push725=, 10480
	i32.add 	$push726=, $41, $pop725
	i32.const	$push233=, 2
	i32.shl 	$push142=, $35, $pop233
	i32.add 	$push143=, $pop726, $pop142
	i32.store	$discard=, 0($pop143), $35
	i32.const	$push727=, 8480
	i32.add 	$push728=, $41, $pop727
	i32.const	$push232=, 2
	i32.shl 	$push144=, $36, $pop232
	i32.add 	$push145=, $pop728, $pop144
	i32.store	$discard=, 0($pop145), $36
	i32.const	$push729=, 6480
	i32.add 	$push730=, $41, $pop729
	i32.const	$push231=, 2
	i32.shl 	$push146=, $37, $pop231
	i32.add 	$push147=, $pop730, $pop146
	i32.store	$discard=, 0($pop147), $37
	i32.const	$push731=, 4480
	i32.add 	$push732=, $41, $pop731
	i32.const	$push230=, 2
	i32.shl 	$push148=, $38, $pop230
	i32.add 	$push149=, $pop732, $pop148
	i32.store	$discard=, 0($pop149), $38
	i32.const	$push733=, 2480
	i32.add 	$push734=, $41, $pop733
	i32.const	$push229=, 2
	i32.shl 	$push150=, $39, $pop229
	i32.add 	$push151=, $pop734, $pop150
	i32.store	$discard=, 0($pop151), $39
	i32.const	$push735=, 480
	i32.add 	$push736=, $41, $pop735
	i32.const	$push228=, 2
	i32.shl 	$push152=, $40, $pop228
	i32.add 	$push153=, $pop736, $pop152
	i32.store	$discard=, 0($pop153), $40
	i32.const	$push227=, 156
	i32.add 	$push154=, $41, $pop227
	i32.const	$push737=, 480
	i32.add 	$push738=, $41, $pop737
	i32.store	$discard=, 0($pop154), $pop738
	i32.const	$push226=, 152
	i32.add 	$push155=, $41, $pop226
	i32.const	$push739=, 2480
	i32.add 	$push740=, $41, $pop739
	i32.store	$discard=, 0($pop155):p2align=3, $pop740
	i32.const	$push225=, 148
	i32.add 	$push156=, $41, $pop225
	i32.const	$push741=, 4480
	i32.add 	$push742=, $41, $pop741
	i32.store	$discard=, 0($pop156), $pop742
	i32.const	$push224=, 144
	i32.add 	$push157=, $41, $pop224
	i32.const	$push743=, 6480
	i32.add 	$push744=, $41, $pop743
	i32.store	$discard=, 0($pop157):p2align=4, $pop744
	i32.const	$push223=, 140
	i32.add 	$push158=, $41, $pop223
	i32.const	$push745=, 8480
	i32.add 	$push746=, $41, $pop745
	i32.store	$discard=, 0($pop158), $pop746
	i32.const	$push222=, 136
	i32.add 	$push159=, $41, $pop222
	i32.const	$push747=, 10480
	i32.add 	$push748=, $41, $pop747
	i32.store	$discard=, 0($pop159):p2align=3, $pop748
	i32.const	$push221=, 132
	i32.add 	$push160=, $41, $pop221
	i32.const	$push749=, 12480
	i32.add 	$push750=, $41, $pop749
	i32.store	$discard=, 0($pop160), $pop750
	i32.const	$push220=, 128
	i32.add 	$push161=, $41, $pop220
	i32.const	$push751=, 14480
	i32.add 	$push752=, $41, $pop751
	i32.store	$discard=, 0($pop161):p2align=4, $pop752
	i32.const	$push219=, 124
	i32.add 	$push162=, $41, $pop219
	i32.const	$push753=, 16480
	i32.add 	$push754=, $41, $pop753
	i32.store	$discard=, 0($pop162), $pop754
	i32.const	$push218=, 120
	i32.add 	$push163=, $41, $pop218
	i32.const	$push755=, 18480
	i32.add 	$push756=, $41, $pop755
	i32.store	$discard=, 0($pop163):p2align=3, $pop756
	i32.const	$push217=, 116
	i32.add 	$push164=, $41, $pop217
	i32.const	$push757=, 20480
	i32.add 	$push758=, $41, $pop757
	i32.store	$discard=, 0($pop164), $pop758
	i32.const	$push216=, 112
	i32.add 	$push165=, $41, $pop216
	i32.const	$push759=, 22480
	i32.add 	$push760=, $41, $pop759
	i32.store	$discard=, 0($pop165):p2align=4, $pop760
	i32.const	$push215=, 108
	i32.add 	$push166=, $41, $pop215
	i32.const	$push761=, 24480
	i32.add 	$push762=, $41, $pop761
	i32.store	$discard=, 0($pop166), $pop762
	i32.const	$push214=, 104
	i32.add 	$push167=, $41, $pop214
	i32.const	$push763=, 26480
	i32.add 	$push764=, $41, $pop763
	i32.store	$discard=, 0($pop167):p2align=3, $pop764
	i32.const	$push213=, 100
	i32.add 	$push168=, $41, $pop213
	i32.const	$push765=, 28480
	i32.add 	$push766=, $41, $pop765
	i32.store	$discard=, 0($pop168), $pop766
	i32.const	$push212=, 96
	i32.add 	$push169=, $41, $pop212
	i32.const	$push767=, 30480
	i32.add 	$push768=, $41, $pop767
	i32.store	$discard=, 0($pop169):p2align=4, $pop768
	i32.const	$push211=, 92
	i32.add 	$push170=, $41, $pop211
	i32.const	$push769=, 32480
	i32.add 	$push770=, $41, $pop769
	i32.store	$discard=, 0($pop170), $pop770
	i32.const	$push210=, 88
	i32.add 	$push171=, $41, $pop210
	i32.const	$push771=, 34480
	i32.add 	$push772=, $41, $pop771
	i32.store	$discard=, 0($pop171):p2align=3, $pop772
	i32.const	$push209=, 84
	i32.add 	$push172=, $41, $pop209
	i32.const	$push773=, 36480
	i32.add 	$push774=, $41, $pop773
	i32.store	$discard=, 0($pop172), $pop774
	i32.const	$push208=, 80
	i32.add 	$push173=, $41, $pop208
	i32.const	$push775=, 38480
	i32.add 	$push776=, $41, $pop775
	i32.store	$discard=, 0($pop173):p2align=4, $pop776
	i32.const	$push207=, 76
	i32.add 	$push174=, $41, $pop207
	i32.const	$push777=, 40480
	i32.add 	$push778=, $41, $pop777
	i32.store	$discard=, 0($pop174), $pop778
	i32.const	$push206=, 72
	i32.add 	$push175=, $41, $pop206
	i32.const	$push779=, 42480
	i32.add 	$push780=, $41, $pop779
	i32.store	$discard=, 0($pop175):p2align=3, $pop780
	i32.const	$push205=, 68
	i32.add 	$push176=, $41, $pop205
	i32.const	$push781=, 44480
	i32.add 	$push782=, $41, $pop781
	i32.store	$discard=, 0($pop176), $pop782
	i32.const	$push204=, 64
	i32.add 	$push177=, $41, $pop204
	i32.const	$push783=, 46480
	i32.add 	$push784=, $41, $pop783
	i32.store	$discard=, 0($pop177):p2align=4, $pop784
	i32.const	$push203=, 60
	i32.add 	$push178=, $41, $pop203
	i32.const	$push785=, 48480
	i32.add 	$push786=, $41, $pop785
	i32.store	$discard=, 0($pop178), $pop786
	i32.const	$push202=, 56
	i32.add 	$push179=, $41, $pop202
	i32.const	$push787=, 50480
	i32.add 	$push788=, $41, $pop787
	i32.store	$discard=, 0($pop179):p2align=3, $pop788
	i32.const	$push201=, 52
	i32.add 	$push180=, $41, $pop201
	i32.const	$push789=, 52480
	i32.add 	$push790=, $41, $pop789
	i32.store	$discard=, 0($pop180), $pop790
	i32.const	$push200=, 48
	i32.add 	$push181=, $41, $pop200
	i32.const	$push791=, 54480
	i32.add 	$push792=, $41, $pop791
	i32.store	$discard=, 0($pop181):p2align=4, $pop792
	i32.const	$push199=, 44
	i32.add 	$push182=, $41, $pop199
	i32.const	$push793=, 56480
	i32.add 	$push794=, $41, $pop793
	i32.store	$discard=, 0($pop182), $pop794
	i32.const	$push198=, 40
	i32.add 	$push183=, $41, $pop198
	i32.const	$push795=, 58480
	i32.add 	$push796=, $41, $pop795
	i32.store	$discard=, 0($pop183):p2align=3, $pop796
	i32.const	$push197=, 36
	i32.add 	$push184=, $41, $pop197
	i32.const	$push797=, 60480
	i32.add 	$push798=, $41, $pop797
	i32.store	$discard=, 0($pop184), $pop798
	i32.const	$push196=, 32
	i32.add 	$push185=, $41, $pop196
	i32.const	$push799=, 62480
	i32.add 	$push800=, $41, $pop799
	i32.store	$discard=, 0($pop185):p2align=4, $pop800
	i32.const	$push195=, 28
	i32.add 	$push186=, $41, $pop195
	i32.const	$push801=, 64480
	i32.add 	$push802=, $41, $pop801
	i32.store	$discard=, 0($pop186), $pop802
	i32.const	$push194=, 24
	i32.add 	$push187=, $41, $pop194
	i32.const	$push803=, 66480
	i32.add 	$push804=, $41, $pop803
	i32.store	$discard=, 0($pop187):p2align=3, $pop804
	i32.const	$push193=, 20
	i32.add 	$push188=, $41, $pop193
	i32.const	$push805=, 68480
	i32.add 	$push806=, $41, $pop805
	i32.store	$discard=, 0($pop188), $pop806
	i32.const	$push192=, 16
	i32.add 	$push189=, $41, $pop192
	i32.const	$push807=, 70480
	i32.add 	$push808=, $41, $pop807
	i32.store	$discard=, 0($pop189):p2align=4, $pop808
	i32.const	$push809=, 72480
	i32.add 	$push810=, $41, $pop809
	i32.store	$discard=, 12($41), $pop810
	i32.const	$push811=, 74480
	i32.add 	$push812=, $41, $pop811
	i32.store	$discard=, 8($41):p2align=3, $pop812
	i32.const	$push813=, 76480
	i32.add 	$push814=, $41, $pop813
	i32.store	$discard=, 4($41), $pop814
	i32.const	$push815=, 78480
	i32.add 	$push816=, $41, $pop815
	i32.store	$discard=, 0($41):p2align=4, $pop816
	i32.const	$push191=, 40
	call    	c@FUNCTION, $pop191, $41
	i32.const	$push190=, -1
	i32.add 	$0=, $0, $pop190
	br_if   	0, $0           # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push348=, __stack_pointer
	i32.const	$push346=, 80480
	i32.add 	$push347=, $41, $pop346
	i32.store	$discard=, 0($pop348), $pop347
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.s,"ax",@progbits
	.hidden	s
	.globl	s
	.type	s,@function
s:                                      # @s
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$2=, $pop11, $pop12
	i32.store	$discard=, 12($2), $1
	block
	i32.const	$push13=, 0
	i32.eq  	$push14=, $0, $pop13
	br_if   	0, $pop14       # 0: down to label3
# BB#1:                                 # %while.body.preheader
	i32.const	$push4=, -1
	i32.add 	$0=, $0, $pop4
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push9=, 12($2)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 4
	i32.add 	$push0=, $pop8, $pop7
	i32.store	$discard=, 12($2), $pop0
	i32.load	$push1=, 0($1)
	i32.store	$push2=, 0($pop1), $0
	i32.const	$push6=, -1
	i32.add 	$0=, $pop2, $pop6
	i32.const	$push5=, -1
	i32.ne  	$push3=, $0, $pop5
	br_if   	0, $pop3        # 0: up to label4
.LBB1_3:                                # %while.end
	end_loop                        # label5:
	end_block                       # label3:
	return
	.endfunc
.Lfunc_end1:
	.size	s, .Lfunc_end1-s

	.section	.text.z,"ax",@progbits
	.hidden	z
	.globl	z
	.type	z,@function
z:                                      # @z
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$3=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $3
	i32.store	$discard=, 12($3), $1
	block
	i32.const	$push13=, 0
	i32.eq  	$push14=, $0, $pop13
	br_if   	0, $pop14       # 0: down to label6
# BB#1:                                 # %while.body.preheader
	i32.load	$1=, 12($3)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push5=, 4
	i32.add 	$push0=, $1, $pop5
	i32.store	$2=, 12($3), $pop0
	i32.const	$push4=, -1
	i32.add 	$0=, $0, $pop4
	i32.load	$push1=, 0($1)
	i32.const	$push3=, 0
	i32.const	$push2=, 2000
	i32.call	$discard=, memset@FUNCTION, $pop1, $pop3, $pop2
	copy_local	$1=, $2
	br_if   	0, $0           # 0: up to label7
.LBB2_3:                                # %while.end
	end_loop                        # label8:
	end_block                       # label6:
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $3, $pop10
	i32.store	$discard=, 0($pop12), $pop11
	return
	.endfunc
.Lfunc_end2:
	.size	z, .Lfunc_end2-z

	.section	.text.c,"ax",@progbits
	.hidden	c
	.globl	c
	.type	c,@function
c:                                      # @c
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 16
	i32.sub 	$3=, $pop13, $pop14
	i32.const	$push15=, __stack_pointer
	i32.store	$discard=, 0($pop15), $3
	i32.store	$discard=, 12($3), $1
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push6=, -4
	i32.add 	$1=, $pop1, $pop6
.LBB3_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label10:
	i32.const	$push19=, 0
	i32.eq  	$push20=, $0, $pop19
	br_if   	2, $pop20       # 2: down to label9
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$push11=, 12($3)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 4
	i32.add 	$push2=, $pop10, $pop9
	i32.store	$discard=, 12($3), $pop2
	i32.load	$push3=, 0($2)
	i32.add 	$2=, $pop3, $1
	i32.const	$push8=, -1
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, -4
	i32.add 	$1=, $1, $pop7
	i32.load	$push4=, 0($2)
	i32.eq  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: up to label10
# BB#3:                                 # %if.then
	end_loop                        # label11:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %while.end
	end_block                       # label9:
	i32.const	$push18=, __stack_pointer
	i32.const	$push16=, 16
	i32.add 	$push17=, $3, $pop16
	i32.store	$discard=, 0($pop18), $pop17
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
