	.text
	.file	"pr58277-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store8	u($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push334=, 0
	i32.const	$push332=, 0
	i32.load	$push331=, __stack_pointer($pop332)
	i32.const	$push333=, 32
	i32.sub 	$push345=, $pop331, $pop333
	tee_local	$push344=, $2=, $pop345
	i32.store	__stack_pointer($pop334), $pop344
	i32.const	$push343=, 0
	i32.const	$push342=, 1
	i32.store	n($pop343), $pop342
	i32.const	$push341=, 0
	i32.const	$push340=, 1
	i32.store	a($pop341), $pop340
	i32.const	$push339=, 0
	i32.const	$push338=, 0
	i32.store8	u($pop339), $pop338
	i32.const	$0=, 1
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_6 Depth 3
	loop    	                # label0:
	i32.const	$push348=, 0
	i32.const	$push347=, 0
	i32.store	g($pop348), $pop347
	block   	
	block   	
	i32.const	$push346=, 0
	i32.load	$push0=, l($pop346)
	i32.eqz 	$push612=, $pop0
	br_if   	0, $pop612      # 0: down to label2
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push361=, 0
	i32.load	$push1=, j($pop361)
	i32.const	$push360=, 0
	i32.store	0($pop1), $pop360
	i32.const	$push359=, 0
	i32.load	$push2=, i($pop359)
	i32.const	$push358=, 0
	i32.load	$push3=, j($pop358)
	i32.load	$push4=, 0($pop3)
	i32.store	0($pop2), $pop4
	i32.const	$push357=, 0
	i32.load	$push5=, i($pop357)
	i32.const	$push356=, 0
	i32.store	0($pop5), $pop356
	i32.const	$push355=, 0
	i32.const	$push354=, 1
	i32.store8	u($pop355), $pop354
	i32.const	$push353=, 0
	i32.load	$push6=, i($pop353)
	i32.const	$push352=, 0
	i32.store	0($pop6), $pop352
	i32.const	$push351=, 0
	i32.const	$push350=, 0
	i32.store	d($pop351), $pop350
	i32.const	$push349=, 0
	i32.load	$push7=, i($pop349)
	i32.store	0($pop7), $2
	br      	1               # 1: down to label1
.LBB2_3:                                # %if.else.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push368=, 0
	i32.load	$push8=, i($pop368)
	i32.const	$push367=, 0
	i32.store	0($pop8), $pop367
	i32.const	$push366=, 0
	i32.load	$push9=, e($pop366)
	i32.const	$push365=, 0
	i32.store	0($pop9), $pop365
	i32.const	$push364=, 0
	i32.const	$push363=, 0
	i32.store	o($pop364), $pop363
	block   	
	i32.const	$push362=, 0
	i32.load	$push10=, p($pop362)
	br_if   	0, $pop10       # 0: down to label3
.LBB2_4:                                # %if.end.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_6 Depth 3
	loop    	                # label4:
	i32.const	$push373=, 0
	i32.load	$push372=, i($pop373)
	tee_local	$push371=, $1=, $pop372
	i32.load	$push11=, 0($pop371)
	i32.const	$push370=, 0
	i32.store	0($pop11), $pop370
	block   	
	i32.const	$push369=, 0
	i32.load	$push12=, j($pop369)
	i32.load	$push13=, 0($pop12)
	i32.load	$push14=, 0($pop13)
	br_if   	0, $pop14       # 0: down to label5
# BB#5:                                 # %if.end110.lr.ph.i
                                        #   in Loop: Header=BB2_4 Depth=2
	i32.const	$push376=, 0
	i32.load	$push375=, i($pop376)
	tee_local	$push374=, $1=, $pop375
	i32.load	$0=, 0($pop374)
.LBB2_6:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label6:
	i32.const	$push383=, 0
	i32.const	$push382=, 0
	i32.load	$push15=, k($pop382)
	i32.const	$push381=, 1
	i32.add 	$push16=, $pop15, $pop381
	i32.store	k($pop383), $pop16
	i32.const	$push380=, 0
	i32.store	0($0), $pop380
	i32.const	$push379=, 0
	i32.const	$push378=, 0
	i32.store8	u($pop379), $pop378
	i32.const	$push377=, 0
	i32.load	$push17=, j($pop377)
	i32.load	$push18=, 0($pop17)
	i32.load	$push19=, 0($pop18)
	i32.eqz 	$push613=, $pop19
	br_if   	0, $pop613      # 0: up to label6
.LBB2_7:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop
	end_block                       # label5:
	i32.const	$push404=, 0
	i32.load	$push20=, j($pop404)
	i32.load	$push21=, 0($pop20)
	i32.store	0($1), $pop21
	i32.const	$push403=, 0
	i32.load	$push22=, i($pop403)
	i32.const	$push402=, 0
	i32.load	$push23=, j($pop402)
	i32.load	$push24=, 0($pop23)
	i32.store	0($pop22), $pop24
	i32.const	$push401=, 0
	i32.load	$push25=, i($pop401)
	i32.const	$push400=, 0
	i32.load	$push26=, j($pop400)
	i32.load	$push27=, 0($pop26)
	i32.store	0($pop25), $pop27
	i32.const	$push399=, 0
	i32.load	$push28=, i($pop399)
	i32.const	$push398=, 0
	i32.load	$push29=, j($pop398)
	i32.load	$push30=, 0($pop29)
	i32.store	0($pop28), $pop30
	i32.const	$push397=, 0
	i32.load	$push31=, i($pop397)
	i32.const	$push396=, 0
	i32.load	$push32=, j($pop396)
	i32.load	$push33=, 0($pop32)
	i32.store	0($pop31), $pop33
	i32.const	$push395=, 0
	i32.load	$push34=, i($pop395)
	i32.const	$push394=, 0
	i32.load	$push35=, j($pop394)
	i32.load	$push36=, 0($pop35)
	i32.store	0($pop34), $pop36
	i32.const	$push393=, 0
	i32.load	$push37=, i($pop393)
	i32.const	$push392=, 0
	i32.store	0($pop37), $pop392
	i32.const	$push391=, 0
	i32.const	$push390=, 0
	i32.load	$push38=, h($pop390)
	i32.const	$push389=, 1
	i32.add 	$push39=, $pop38, $pop389
	i32.store	h($pop391), $pop39
	i32.const	$push388=, 0
	i32.load	$push40=, e($pop388)
	i32.const	$push387=, 0
	i32.store	0($pop40), $pop387
	i32.const	$push386=, 0
	i32.const	$push385=, 0
	i32.store	o($pop386), $pop385
	i32.const	$push384=, 0
	i32.load	$push41=, p($pop384)
	i32.eqz 	$push614=, $pop41
	br_if   	0, $pop614      # 0: up to label4
.LBB2_8:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label3:
	i32.const	$push407=, 0
	i32.const	$push406=, 0
	i32.store	f($pop407), $pop406
	i32.const	$push405=, 0
	i32.load	$0=, n($pop405)
.LBB2_9:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label1:
	i32.const	$push413=, 0
	i32.const	$push412=, -1
	i32.add 	$push411=, $0, $pop412
	tee_local	$push410=, $0=, $pop411
	i32.store	n($pop413), $pop410
	i32.const	$push409=, 0
	i32.const	$push408=, 0
	i32.store8	u($pop409), $pop408
	br_if   	0, $0           # 0: up to label0
# BB#10:                                # %for.end8
	end_loop
	block   	
	i32.const	$push416=, 0
	i32.load	$push415=, b($pop416)
	tee_local	$push414=, $1=, $pop415
	i32.eqz 	$push615=, $pop414
	br_if   	0, $pop615      # 0: down to label7
# BB#11:                                # %for.body11.lr.ph
	i32.const	$push417=, 0
	i32.load	$0=, c($pop417)
.LBB2_12:                               # %for.body11
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push580=, 2
	i32.shl 	$push42=, $0, $pop580
	i32.const	$push579=, a
	i32.add 	$push43=, $pop42, $pop579
	i32.load	$push44=, 0($pop43)
	i32.const	$push578=, 2
	i32.shl 	$push45=, $pop44, $pop578
	i32.const	$push577=, a
	i32.add 	$push46=, $pop45, $pop577
	i32.load	$push47=, 0($pop46)
	i32.const	$push576=, 2
	i32.shl 	$push48=, $pop47, $pop576
	i32.const	$push575=, a
	i32.add 	$push49=, $pop48, $pop575
	i32.load	$push50=, 0($pop49)
	i32.const	$push574=, 2
	i32.shl 	$push51=, $pop50, $pop574
	i32.const	$push573=, a
	i32.add 	$push52=, $pop51, $pop573
	i32.load	$push53=, 0($pop52)
	i32.const	$push572=, 2
	i32.shl 	$push54=, $pop53, $pop572
	i32.const	$push571=, a
	i32.add 	$push55=, $pop54, $pop571
	i32.load	$push56=, 0($pop55)
	i32.const	$push570=, 2
	i32.shl 	$push57=, $pop56, $pop570
	i32.const	$push569=, a
	i32.add 	$push58=, $pop57, $pop569
	i32.load	$push59=, 0($pop58)
	i32.const	$push568=, 2
	i32.shl 	$push60=, $pop59, $pop568
	i32.const	$push567=, a
	i32.add 	$push61=, $pop60, $pop567
	i32.load	$push62=, 0($pop61)
	i32.const	$push566=, 2
	i32.shl 	$push63=, $pop62, $pop566
	i32.const	$push565=, a
	i32.add 	$push64=, $pop63, $pop565
	i32.load	$push65=, 0($pop64)
	i32.const	$push564=, 2
	i32.shl 	$push66=, $pop65, $pop564
	i32.const	$push563=, a
	i32.add 	$push67=, $pop66, $pop563
	i32.load	$push68=, 0($pop67)
	i32.const	$push562=, 2
	i32.shl 	$push69=, $pop68, $pop562
	i32.const	$push561=, a
	i32.add 	$push70=, $pop69, $pop561
	i32.load	$push71=, 0($pop70)
	i32.const	$push560=, 2
	i32.shl 	$push72=, $pop71, $pop560
	i32.const	$push559=, a
	i32.add 	$push73=, $pop72, $pop559
	i32.load	$push74=, 0($pop73)
	i32.const	$push558=, 2
	i32.shl 	$push75=, $pop74, $pop558
	i32.const	$push557=, a
	i32.add 	$push76=, $pop75, $pop557
	i32.load	$push77=, 0($pop76)
	i32.const	$push556=, 2
	i32.shl 	$push78=, $pop77, $pop556
	i32.const	$push555=, a
	i32.add 	$push79=, $pop78, $pop555
	i32.load	$push80=, 0($pop79)
	i32.const	$push554=, 2
	i32.shl 	$push81=, $pop80, $pop554
	i32.const	$push553=, a
	i32.add 	$push82=, $pop81, $pop553
	i32.load	$push83=, 0($pop82)
	i32.const	$push552=, 2
	i32.shl 	$push84=, $pop83, $pop552
	i32.const	$push551=, a
	i32.add 	$push85=, $pop84, $pop551
	i32.load	$push86=, 0($pop85)
	i32.const	$push550=, 2
	i32.shl 	$push87=, $pop86, $pop550
	i32.const	$push549=, a
	i32.add 	$push88=, $pop87, $pop549
	i32.load	$push89=, 0($pop88)
	i32.const	$push548=, 2
	i32.shl 	$push90=, $pop89, $pop548
	i32.const	$push547=, a
	i32.add 	$push91=, $pop90, $pop547
	i32.load	$push92=, 0($pop91)
	i32.const	$push546=, 2
	i32.shl 	$push93=, $pop92, $pop546
	i32.const	$push545=, a
	i32.add 	$push94=, $pop93, $pop545
	i32.load	$push95=, 0($pop94)
	i32.const	$push544=, 2
	i32.shl 	$push96=, $pop95, $pop544
	i32.const	$push543=, a
	i32.add 	$push97=, $pop96, $pop543
	i32.load	$push98=, 0($pop97)
	i32.const	$push542=, 2
	i32.shl 	$push99=, $pop98, $pop542
	i32.const	$push541=, a
	i32.add 	$push100=, $pop99, $pop541
	i32.load	$push101=, 0($pop100)
	i32.const	$push540=, 2
	i32.shl 	$push102=, $pop101, $pop540
	i32.const	$push539=, a
	i32.add 	$push103=, $pop102, $pop539
	i32.load	$push104=, 0($pop103)
	i32.const	$push538=, 2
	i32.shl 	$push105=, $pop104, $pop538
	i32.const	$push537=, a
	i32.add 	$push106=, $pop105, $pop537
	i32.load	$push107=, 0($pop106)
	i32.const	$push536=, 2
	i32.shl 	$push108=, $pop107, $pop536
	i32.const	$push535=, a
	i32.add 	$push109=, $pop108, $pop535
	i32.load	$push110=, 0($pop109)
	i32.const	$push534=, 2
	i32.shl 	$push111=, $pop110, $pop534
	i32.const	$push533=, a
	i32.add 	$push112=, $pop111, $pop533
	i32.load	$push113=, 0($pop112)
	i32.const	$push532=, 2
	i32.shl 	$push114=, $pop113, $pop532
	i32.const	$push531=, a
	i32.add 	$push115=, $pop114, $pop531
	i32.load	$push116=, 0($pop115)
	i32.const	$push530=, 2
	i32.shl 	$push117=, $pop116, $pop530
	i32.const	$push529=, a
	i32.add 	$push118=, $pop117, $pop529
	i32.load	$push119=, 0($pop118)
	i32.const	$push528=, 2
	i32.shl 	$push120=, $pop119, $pop528
	i32.const	$push527=, a
	i32.add 	$push121=, $pop120, $pop527
	i32.load	$push122=, 0($pop121)
	i32.const	$push526=, 2
	i32.shl 	$push123=, $pop122, $pop526
	i32.const	$push525=, a
	i32.add 	$push124=, $pop123, $pop525
	i32.load	$push125=, 0($pop124)
	i32.const	$push524=, 2
	i32.shl 	$push126=, $pop125, $pop524
	i32.const	$push523=, a
	i32.add 	$push127=, $pop126, $pop523
	i32.load	$push128=, 0($pop127)
	i32.const	$push522=, 2
	i32.shl 	$push129=, $pop128, $pop522
	i32.const	$push521=, a
	i32.add 	$push130=, $pop129, $pop521
	i32.load	$push131=, 0($pop130)
	i32.const	$push520=, 2
	i32.shl 	$push132=, $pop131, $pop520
	i32.const	$push519=, a
	i32.add 	$push133=, $pop132, $pop519
	i32.load	$push134=, 0($pop133)
	i32.const	$push518=, 2
	i32.shl 	$push135=, $pop134, $pop518
	i32.const	$push517=, a
	i32.add 	$push136=, $pop135, $pop517
	i32.load	$push137=, 0($pop136)
	i32.const	$push516=, 2
	i32.shl 	$push138=, $pop137, $pop516
	i32.const	$push515=, a
	i32.add 	$push139=, $pop138, $pop515
	i32.load	$push140=, 0($pop139)
	i32.const	$push514=, 2
	i32.shl 	$push141=, $pop140, $pop514
	i32.const	$push513=, a
	i32.add 	$push142=, $pop141, $pop513
	i32.load	$push143=, 0($pop142)
	i32.const	$push512=, 2
	i32.shl 	$push144=, $pop143, $pop512
	i32.const	$push511=, a
	i32.add 	$push145=, $pop144, $pop511
	i32.load	$push146=, 0($pop145)
	i32.const	$push510=, 2
	i32.shl 	$push147=, $pop146, $pop510
	i32.const	$push509=, a
	i32.add 	$push148=, $pop147, $pop509
	i32.load	$push149=, 0($pop148)
	i32.const	$push508=, 2
	i32.shl 	$push150=, $pop149, $pop508
	i32.const	$push507=, a
	i32.add 	$push151=, $pop150, $pop507
	i32.load	$push152=, 0($pop151)
	i32.const	$push506=, 2
	i32.shl 	$push153=, $pop152, $pop506
	i32.const	$push505=, a
	i32.add 	$push154=, $pop153, $pop505
	i32.load	$push155=, 0($pop154)
	i32.const	$push504=, 2
	i32.shl 	$push156=, $pop155, $pop504
	i32.const	$push503=, a
	i32.add 	$push157=, $pop156, $pop503
	i32.load	$push158=, 0($pop157)
	i32.const	$push502=, 2
	i32.shl 	$push159=, $pop158, $pop502
	i32.const	$push501=, a
	i32.add 	$push160=, $pop159, $pop501
	i32.load	$push161=, 0($pop160)
	i32.const	$push500=, 2
	i32.shl 	$push162=, $pop161, $pop500
	i32.const	$push499=, a
	i32.add 	$push163=, $pop162, $pop499
	i32.load	$push164=, 0($pop163)
	i32.const	$push498=, 2
	i32.shl 	$push165=, $pop164, $pop498
	i32.const	$push497=, a
	i32.add 	$push166=, $pop165, $pop497
	i32.load	$push167=, 0($pop166)
	i32.const	$push496=, 2
	i32.shl 	$push168=, $pop167, $pop496
	i32.const	$push495=, a
	i32.add 	$push169=, $pop168, $pop495
	i32.load	$push170=, 0($pop169)
	i32.const	$push494=, 2
	i32.shl 	$push171=, $pop170, $pop494
	i32.const	$push493=, a
	i32.add 	$push172=, $pop171, $pop493
	i32.load	$push173=, 0($pop172)
	i32.const	$push492=, 2
	i32.shl 	$push174=, $pop173, $pop492
	i32.const	$push491=, a
	i32.add 	$push175=, $pop174, $pop491
	i32.load	$push176=, 0($pop175)
	i32.const	$push490=, 2
	i32.shl 	$push177=, $pop176, $pop490
	i32.const	$push489=, a
	i32.add 	$push178=, $pop177, $pop489
	i32.load	$push179=, 0($pop178)
	i32.const	$push488=, 2
	i32.shl 	$push180=, $pop179, $pop488
	i32.const	$push487=, a
	i32.add 	$push181=, $pop180, $pop487
	i32.load	$push182=, 0($pop181)
	i32.const	$push486=, 2
	i32.shl 	$push183=, $pop182, $pop486
	i32.const	$push485=, a
	i32.add 	$push184=, $pop183, $pop485
	i32.load	$push185=, 0($pop184)
	i32.const	$push484=, 2
	i32.shl 	$push186=, $pop185, $pop484
	i32.const	$push483=, a
	i32.add 	$push187=, $pop186, $pop483
	i32.load	$push188=, 0($pop187)
	i32.const	$push482=, 2
	i32.shl 	$push189=, $pop188, $pop482
	i32.const	$push481=, a
	i32.add 	$push190=, $pop189, $pop481
	i32.load	$push191=, 0($pop190)
	i32.const	$push480=, 2
	i32.shl 	$push192=, $pop191, $pop480
	i32.const	$push479=, a
	i32.add 	$push193=, $pop192, $pop479
	i32.load	$push194=, 0($pop193)
	i32.const	$push478=, 2
	i32.shl 	$push195=, $pop194, $pop478
	i32.const	$push477=, a
	i32.add 	$push196=, $pop195, $pop477
	i32.load	$push197=, 0($pop196)
	i32.const	$push476=, 2
	i32.shl 	$push198=, $pop197, $pop476
	i32.const	$push475=, a
	i32.add 	$push199=, $pop198, $pop475
	i32.load	$push200=, 0($pop199)
	i32.const	$push474=, 2
	i32.shl 	$push201=, $pop200, $pop474
	i32.const	$push473=, a
	i32.add 	$push202=, $pop201, $pop473
	i32.load	$push203=, 0($pop202)
	i32.const	$push472=, 2
	i32.shl 	$push204=, $pop203, $pop472
	i32.const	$push471=, a
	i32.add 	$push205=, $pop204, $pop471
	i32.load	$push206=, 0($pop205)
	i32.const	$push470=, 2
	i32.shl 	$push207=, $pop206, $pop470
	i32.const	$push469=, a
	i32.add 	$push208=, $pop207, $pop469
	i32.load	$push209=, 0($pop208)
	i32.const	$push468=, 2
	i32.shl 	$push210=, $pop209, $pop468
	i32.const	$push467=, a
	i32.add 	$push211=, $pop210, $pop467
	i32.load	$push212=, 0($pop211)
	i32.const	$push466=, 2
	i32.shl 	$push213=, $pop212, $pop466
	i32.const	$push465=, a
	i32.add 	$push214=, $pop213, $pop465
	i32.load	$push215=, 0($pop214)
	i32.const	$push464=, 2
	i32.shl 	$push216=, $pop215, $pop464
	i32.const	$push463=, a
	i32.add 	$push217=, $pop216, $pop463
	i32.load	$push218=, 0($pop217)
	i32.const	$push462=, 2
	i32.shl 	$push219=, $pop218, $pop462
	i32.const	$push461=, a
	i32.add 	$push220=, $pop219, $pop461
	i32.load	$push221=, 0($pop220)
	i32.const	$push460=, 2
	i32.shl 	$push222=, $pop221, $pop460
	i32.const	$push459=, a
	i32.add 	$push223=, $pop222, $pop459
	i32.load	$push224=, 0($pop223)
	i32.const	$push458=, 2
	i32.shl 	$push225=, $pop224, $pop458
	i32.const	$push457=, a
	i32.add 	$push226=, $pop225, $pop457
	i32.load	$push227=, 0($pop226)
	i32.const	$push456=, 2
	i32.shl 	$push228=, $pop227, $pop456
	i32.const	$push455=, a
	i32.add 	$push229=, $pop228, $pop455
	i32.load	$push230=, 0($pop229)
	i32.const	$push454=, 2
	i32.shl 	$push231=, $pop230, $pop454
	i32.const	$push453=, a
	i32.add 	$push232=, $pop231, $pop453
	i32.load	$push233=, 0($pop232)
	i32.const	$push452=, 2
	i32.shl 	$push234=, $pop233, $pop452
	i32.const	$push451=, a
	i32.add 	$push235=, $pop234, $pop451
	i32.load	$push236=, 0($pop235)
	i32.const	$push450=, 2
	i32.shl 	$push237=, $pop236, $pop450
	i32.const	$push449=, a
	i32.add 	$push238=, $pop237, $pop449
	i32.load	$push239=, 0($pop238)
	i32.const	$push448=, 2
	i32.shl 	$push240=, $pop239, $pop448
	i32.const	$push447=, a
	i32.add 	$push241=, $pop240, $pop447
	i32.load	$push242=, 0($pop241)
	i32.const	$push446=, 2
	i32.shl 	$push243=, $pop242, $pop446
	i32.const	$push445=, a
	i32.add 	$push244=, $pop243, $pop445
	i32.load	$push245=, 0($pop244)
	i32.const	$push444=, 2
	i32.shl 	$push246=, $pop245, $pop444
	i32.const	$push443=, a
	i32.add 	$push247=, $pop246, $pop443
	i32.load	$push248=, 0($pop247)
	i32.const	$push442=, 2
	i32.shl 	$push249=, $pop248, $pop442
	i32.const	$push441=, a
	i32.add 	$push250=, $pop249, $pop441
	i32.load	$push251=, 0($pop250)
	i32.const	$push440=, 2
	i32.shl 	$push252=, $pop251, $pop440
	i32.const	$push439=, a
	i32.add 	$push253=, $pop252, $pop439
	i32.load	$push254=, 0($pop253)
	i32.const	$push438=, 2
	i32.shl 	$push255=, $pop254, $pop438
	i32.const	$push437=, a
	i32.add 	$push256=, $pop255, $pop437
	i32.load	$push257=, 0($pop256)
	i32.const	$push436=, 2
	i32.shl 	$push258=, $pop257, $pop436
	i32.const	$push435=, a
	i32.add 	$push259=, $pop258, $pop435
	i32.load	$push260=, 0($pop259)
	i32.const	$push434=, 2
	i32.shl 	$push261=, $pop260, $pop434
	i32.const	$push433=, a
	i32.add 	$push262=, $pop261, $pop433
	i32.load	$push263=, 0($pop262)
	i32.const	$push432=, 2
	i32.shl 	$push264=, $pop263, $pop432
	i32.const	$push431=, a
	i32.add 	$push265=, $pop264, $pop431
	i32.load	$push266=, 0($pop265)
	i32.const	$push430=, 2
	i32.shl 	$push267=, $pop266, $pop430
	i32.const	$push429=, a
	i32.add 	$push268=, $pop267, $pop429
	i32.load	$push269=, 0($pop268)
	i32.const	$push428=, 2
	i32.shl 	$push270=, $pop269, $pop428
	i32.const	$push427=, a
	i32.add 	$push271=, $pop270, $pop427
	i32.load	$push272=, 0($pop271)
	i32.const	$push426=, 2
	i32.shl 	$push273=, $pop272, $pop426
	i32.const	$push425=, a
	i32.add 	$push274=, $pop273, $pop425
	i32.load	$push275=, 0($pop274)
	i32.const	$push424=, 2
	i32.shl 	$push276=, $pop275, $pop424
	i32.const	$push423=, a
	i32.add 	$push277=, $pop276, $pop423
	i32.load	$push278=, 0($pop277)
	i32.const	$push422=, 2
	i32.shl 	$push279=, $pop278, $pop422
	i32.const	$push421=, a
	i32.add 	$push280=, $pop279, $pop421
	i32.load	$0=, 0($pop280)
	i32.const	$push420=, 1
	i32.add 	$push419=, $1, $pop420
	tee_local	$push418=, $1=, $pop419
	br_if   	0, $pop418      # 0: up to label8
# BB#13:                                # %for.cond9.for.end29_crit_edge
	end_loop
	i32.const	$push281=, 0
	i32.store	c($pop281), $0
	i32.const	$push582=, 0
	i32.const	$push581=, 0
	i32.store	b($pop582), $pop581
.LBB2_14:                               # %for.end29
	end_block                       # label7:
	call    	baz@FUNCTION
	block   	
	i32.const	$push611=, 0
	i32.load8_s	$push282=, u($pop611)
	i32.const	$push283=, 2
	i32.shl 	$push284=, $pop282, $pop283
	i32.const	$push285=, a
	i32.add 	$push286=, $pop284, $pop285
	i32.load	$push287=, 0($pop286)
	i32.const	$push610=, 2
	i32.shl 	$push288=, $pop287, $pop610
	i32.const	$push609=, a
	i32.add 	$push289=, $pop288, $pop609
	i32.load	$push290=, 0($pop289)
	i32.const	$push608=, 2
	i32.shl 	$push291=, $pop290, $pop608
	i32.const	$push607=, a
	i32.add 	$push292=, $pop291, $pop607
	i32.load	$push293=, 0($pop292)
	i32.const	$push606=, 2
	i32.shl 	$push294=, $pop293, $pop606
	i32.const	$push605=, a
	i32.add 	$push295=, $pop294, $pop605
	i32.load	$push296=, 0($pop295)
	i32.const	$push604=, 2
	i32.shl 	$push297=, $pop296, $pop604
	i32.const	$push603=, a
	i32.add 	$push298=, $pop297, $pop603
	i32.load	$push299=, 0($pop298)
	i32.const	$push602=, 2
	i32.shl 	$push300=, $pop299, $pop602
	i32.const	$push601=, a
	i32.add 	$push301=, $pop300, $pop601
	i32.load	$push302=, 0($pop301)
	i32.const	$push600=, 2
	i32.shl 	$push303=, $pop302, $pop600
	i32.const	$push599=, a
	i32.add 	$push304=, $pop303, $pop599
	i32.load	$push305=, 0($pop304)
	i32.const	$push598=, 2
	i32.shl 	$push306=, $pop305, $pop598
	i32.const	$push597=, a
	i32.add 	$push307=, $pop306, $pop597
	i32.load	$push308=, 0($pop307)
	i32.const	$push596=, 2
	i32.shl 	$push309=, $pop308, $pop596
	i32.const	$push595=, a
	i32.add 	$push310=, $pop309, $pop595
	i32.load	$push311=, 0($pop310)
	i32.const	$push594=, 2
	i32.shl 	$push312=, $pop311, $pop594
	i32.const	$push593=, a
	i32.add 	$push313=, $pop312, $pop593
	i32.load	$push314=, 0($pop313)
	i32.const	$push592=, 2
	i32.shl 	$push315=, $pop314, $pop592
	i32.const	$push591=, a
	i32.add 	$push316=, $pop315, $pop591
	i32.load	$push317=, 0($pop316)
	i32.const	$push590=, 2
	i32.shl 	$push318=, $pop317, $pop590
	i32.const	$push589=, a
	i32.add 	$push319=, $pop318, $pop589
	i32.load	$push320=, 0($pop319)
	i32.const	$push588=, 2
	i32.shl 	$push321=, $pop320, $pop588
	i32.const	$push587=, a
	i32.add 	$push322=, $pop321, $pop587
	i32.load	$push323=, 0($pop322)
	i32.const	$push586=, 2
	i32.shl 	$push324=, $pop323, $pop586
	i32.const	$push585=, a
	i32.add 	$push325=, $pop324, $pop585
	i32.load	$push326=, 0($pop325)
	i32.const	$push584=, 2
	i32.shl 	$push327=, $pop326, $pop584
	i32.const	$push583=, a
	i32.add 	$push328=, $pop327, $pop583
	i32.load	$push329=, 0($pop328)
	i32.eqz 	$push616=, $pop329
	br_if   	0, $pop616      # 0: down to label9
# BB#15:                                # %if.end47
	i32.const	$push337=, 0
	i32.const	$push335=, 32
	i32.add 	$push336=, $2, $pop335
	i32.store	__stack_pointer($pop337), $pop336
	i32.const	$push330=, 0
	return  	$pop330
.LBB2_16:                               # %if.then46
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0
	.size	e, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	2
i:
	.int32	e
	.size	i, 4

	.hidden	l                       # @l
	.type	l,@object
	.section	.data.l,"aw",@progbits
	.globl	l
	.p2align	2
l:
	.int32	1                       # 0x1
	.size	l, 4

	.hidden	u                       # @u
	.type	u,@object
	.section	.bss.u,"aw",@nobits
	.globl	u
u:
	.int8	0                       # 0x0
	.size	u, 1

	.hidden	m                       # @m
	.type	m,@object
	.section	.rodata.m,"a",@progbits
	.globl	m
	.p2align	2
m:
	.int32	0                       # 0x0
	.size	m, 4

	.type	a,@object               # @a
	.section	.bss.a,"aw",@nobits
	.p2align	2
a:
	.skip	8
	.size	a, 8

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.type	j,@object               # @j
	.section	.data.j,"aw",@progbits
	.p2align	2
j:
	.int32	e
	.size	j, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.p2align	2
o:
	.int32	0                       # 0x0
	.size	o, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0                       # 0x0
	.size	p, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
