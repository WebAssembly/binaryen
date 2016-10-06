	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-2.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.ne  	$push0=, $0, $4
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	0, $pop2        # 0: down to label0
# BB#3:                                 # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	0, $pop3        # 0: down to label0
# BB#4:                                 # %if.end
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	verify, .Lfunc_end0-verify

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push656=, 0
	i32.load16_u	$push2=, j+14($pop656)
	i32.const	$push655=, 0
	i32.load16_u	$push1=, i+14($pop655)
	i32.add 	$push654=, $pop2, $pop1
	tee_local	$push653=, $0=, $pop654
	i32.store16	k+14($pop0), $pop653
	i32.const	$push652=, 0
	i32.const	$push651=, 0
	i32.load16_u	$push4=, j+12($pop651)
	i32.const	$push650=, 0
	i32.load16_u	$push3=, i+12($pop650)
	i32.add 	$push649=, $pop4, $pop3
	tee_local	$push648=, $1=, $pop649
	i32.store16	k+12($pop652), $pop648
	i32.const	$push647=, 0
	i32.const	$push646=, 0
	i32.load16_u	$push6=, j+10($pop646)
	i32.const	$push645=, 0
	i32.load16_u	$push5=, i+10($pop645)
	i32.add 	$push644=, $pop6, $pop5
	tee_local	$push643=, $2=, $pop644
	i32.store16	k+10($pop647), $pop643
	i32.const	$push642=, 0
	i32.const	$push641=, 0
	i32.load16_u	$push8=, j+8($pop641)
	i32.const	$push640=, 0
	i32.load16_u	$push7=, i+8($pop640)
	i32.add 	$push639=, $pop8, $pop7
	tee_local	$push638=, $3=, $pop639
	i32.store16	k+8($pop642), $pop638
	i32.const	$push637=, 0
	i32.const	$push636=, 0
	i32.load16_u	$push10=, j+6($pop636)
	i32.const	$push635=, 0
	i32.load16_u	$push9=, i+6($pop635)
	i32.add 	$push634=, $pop10, $pop9
	tee_local	$push633=, $4=, $pop634
	i32.store16	k+6($pop637), $pop633
	i32.const	$push632=, 0
	i32.const	$push631=, 0
	i32.load16_u	$push12=, j+4($pop631)
	i32.const	$push630=, 0
	i32.load16_u	$push11=, i+4($pop630)
	i32.add 	$push629=, $pop12, $pop11
	tee_local	$push628=, $5=, $pop629
	i32.store16	k+4($pop632), $pop628
	i32.const	$push627=, 0
	i32.const	$push626=, 0
	i32.load16_u	$push14=, j+2($pop626)
	i32.const	$push625=, 0
	i32.load16_u	$push13=, i+2($pop625)
	i32.add 	$push624=, $pop14, $pop13
	tee_local	$push623=, $6=, $pop624
	i32.store16	k+2($pop627), $pop623
	i32.const	$push622=, 0
	i32.const	$push621=, 0
	i32.load16_u	$push16=, j($pop621)
	i32.const	$push620=, 0
	i32.load16_u	$push15=, i($pop620)
	i32.add 	$push619=, $pop16, $pop15
	tee_local	$push618=, $7=, $pop619
	i32.store16	k($pop622), $pop618
	i32.const	$push617=, 0
	i32.store16	res+14($pop617), $0
	i32.const	$push616=, 0
	i32.store16	res+12($pop616), $1
	i32.const	$push615=, 0
	i32.store16	res+10($pop615), $2
	i32.const	$push614=, 0
	i32.store16	res+8($pop614), $3
	i32.const	$push613=, 0
	i32.store16	res+6($pop613), $4
	i32.const	$push612=, 0
	i32.store16	res+4($pop612), $5
	i32.const	$push611=, 0
	i32.store16	res+2($pop611), $6
	i32.const	$push610=, 0
	i32.store16	res($pop610), $7
	i32.const	$push17=, 16
	i32.shl 	$push24=, $7, $pop17
	i32.const	$push609=, 16
	i32.shr_s	$push25=, $pop24, $pop609
	i32.const	$push608=, 16
	i32.shl 	$push22=, $6, $pop608
	i32.const	$push607=, 16
	i32.shr_s	$push23=, $pop22, $pop607
	i32.const	$push606=, 16
	i32.shl 	$push20=, $5, $pop606
	i32.const	$push605=, 16
	i32.shr_s	$push21=, $pop20, $pop605
	i32.const	$push604=, 16
	i32.shl 	$push18=, $4, $pop604
	i32.const	$push603=, 16
	i32.shr_s	$push19=, $pop18, $pop603
	i32.const	$push29=, 160
	i32.const	$push28=, 113
	i32.const	$push27=, 170
	i32.const	$push26=, 230
	call    	verify@FUNCTION, $pop25, $pop23, $pop21, $pop19, $pop29, $pop28, $pop27, $pop26
	i32.const	$push602=, 0
	i32.const	$push601=, 0
	i32.load16_u	$push31=, j+14($pop601)
	i32.const	$push600=, 0
	i32.load16_u	$push30=, i+14($pop600)
	i32.mul 	$push599=, $pop31, $pop30
	tee_local	$push598=, $0=, $pop599
	i32.store16	k+14($pop602), $pop598
	i32.const	$push597=, 0
	i32.const	$push596=, 0
	i32.load16_u	$push33=, j+12($pop596)
	i32.const	$push595=, 0
	i32.load16_u	$push32=, i+12($pop595)
	i32.mul 	$push594=, $pop33, $pop32
	tee_local	$push593=, $1=, $pop594
	i32.store16	k+12($pop597), $pop593
	i32.const	$push592=, 0
	i32.const	$push591=, 0
	i32.load16_u	$push35=, j+10($pop591)
	i32.const	$push590=, 0
	i32.load16_u	$push34=, i+10($pop590)
	i32.mul 	$push589=, $pop35, $pop34
	tee_local	$push588=, $2=, $pop589
	i32.store16	k+10($pop592), $pop588
	i32.const	$push587=, 0
	i32.const	$push586=, 0
	i32.load16_u	$push37=, j+8($pop586)
	i32.const	$push585=, 0
	i32.load16_u	$push36=, i+8($pop585)
	i32.mul 	$push584=, $pop37, $pop36
	tee_local	$push583=, $3=, $pop584
	i32.store16	k+8($pop587), $pop583
	i32.const	$push582=, 0
	i32.const	$push581=, 0
	i32.load16_u	$push39=, j+6($pop581)
	i32.const	$push580=, 0
	i32.load16_u	$push38=, i+6($pop580)
	i32.mul 	$push579=, $pop39, $pop38
	tee_local	$push578=, $4=, $pop579
	i32.store16	k+6($pop582), $pop578
	i32.const	$push577=, 0
	i32.const	$push576=, 0
	i32.load16_u	$push41=, j+4($pop576)
	i32.const	$push575=, 0
	i32.load16_u	$push40=, i+4($pop575)
	i32.mul 	$push574=, $pop41, $pop40
	tee_local	$push573=, $5=, $pop574
	i32.store16	k+4($pop577), $pop573
	i32.const	$push572=, 0
	i32.const	$push571=, 0
	i32.load16_u	$push43=, j+2($pop571)
	i32.const	$push570=, 0
	i32.load16_u	$push42=, i+2($pop570)
	i32.mul 	$push569=, $pop43, $pop42
	tee_local	$push568=, $6=, $pop569
	i32.store16	k+2($pop572), $pop568
	i32.const	$push567=, 0
	i32.const	$push566=, 0
	i32.load16_u	$push45=, j($pop566)
	i32.const	$push565=, 0
	i32.load16_u	$push44=, i($pop565)
	i32.mul 	$push564=, $pop45, $pop44
	tee_local	$push563=, $7=, $pop564
	i32.store16	k($pop567), $pop563
	i32.const	$push562=, 0
	i32.store16	res+14($pop562), $0
	i32.const	$push561=, 0
	i32.store16	res+12($pop561), $1
	i32.const	$push560=, 0
	i32.store16	res+10($pop560), $2
	i32.const	$push559=, 0
	i32.store16	res+8($pop559), $3
	i32.const	$push558=, 0
	i32.store16	res+6($pop558), $4
	i32.const	$push557=, 0
	i32.store16	res+4($pop557), $5
	i32.const	$push556=, 0
	i32.store16	res+2($pop556), $6
	i32.const	$push555=, 0
	i32.store16	res($pop555), $7
	i32.const	$push554=, 16
	i32.shl 	$push52=, $7, $pop554
	i32.const	$push553=, 16
	i32.shr_s	$push53=, $pop52, $pop553
	i32.const	$push552=, 16
	i32.shl 	$push50=, $6, $pop552
	i32.const	$push551=, 16
	i32.shr_s	$push51=, $pop50, $pop551
	i32.const	$push550=, 16
	i32.shl 	$push48=, $5, $pop550
	i32.const	$push549=, 16
	i32.shr_s	$push49=, $pop48, $pop549
	i32.const	$push548=, 16
	i32.shl 	$push46=, $4, $pop548
	i32.const	$push547=, 16
	i32.shr_s	$push47=, $pop46, $pop547
	i32.const	$push57=, 1500
	i32.const	$push56=, 1300
	i32.const	$push55=, 3000
	i32.const	$push54=, 6000
	call    	verify@FUNCTION, $pop53, $pop51, $pop49, $pop47, $pop57, $pop56, $pop55, $pop54
	i32.const	$push546=, 0
	i32.const	$push545=, 0
	i32.load16_s	$push59=, i+14($pop545)
	i32.const	$push544=, 0
	i32.load16_s	$push58=, j+14($pop544)
	i32.div_s	$push543=, $pop59, $pop58
	tee_local	$push542=, $0=, $pop543
	i32.store16	k+14($pop546), $pop542
	i32.const	$push541=, 0
	i32.const	$push540=, 0
	i32.load16_s	$push61=, i+12($pop540)
	i32.const	$push539=, 0
	i32.load16_s	$push60=, j+12($pop539)
	i32.div_s	$push538=, $pop61, $pop60
	tee_local	$push537=, $1=, $pop538
	i32.store16	k+12($pop541), $pop537
	i32.const	$push536=, 0
	i32.const	$push535=, 0
	i32.load16_s	$push63=, i+10($pop535)
	i32.const	$push534=, 0
	i32.load16_s	$push62=, j+10($pop534)
	i32.div_s	$push533=, $pop63, $pop62
	tee_local	$push532=, $2=, $pop533
	i32.store16	k+10($pop536), $pop532
	i32.const	$push531=, 0
	i32.const	$push530=, 0
	i32.load16_s	$push65=, i+8($pop530)
	i32.const	$push529=, 0
	i32.load16_s	$push64=, j+8($pop529)
	i32.div_s	$push528=, $pop65, $pop64
	tee_local	$push527=, $3=, $pop528
	i32.store16	k+8($pop531), $pop527
	i32.const	$push526=, 0
	i32.const	$push525=, 0
	i32.load16_s	$push67=, i+6($pop525)
	i32.const	$push524=, 0
	i32.load16_s	$push66=, j+6($pop524)
	i32.div_s	$push523=, $pop67, $pop66
	tee_local	$push522=, $4=, $pop523
	i32.store16	k+6($pop526), $pop522
	i32.const	$push521=, 0
	i32.const	$push520=, 0
	i32.load16_s	$push69=, i+4($pop520)
	i32.const	$push519=, 0
	i32.load16_s	$push68=, j+4($pop519)
	i32.div_s	$push518=, $pop69, $pop68
	tee_local	$push517=, $5=, $pop518
	i32.store16	k+4($pop521), $pop517
	i32.const	$push516=, 0
	i32.const	$push515=, 0
	i32.load16_s	$push71=, i+2($pop515)
	i32.const	$push514=, 0
	i32.load16_s	$push70=, j+2($pop514)
	i32.div_s	$push513=, $pop71, $pop70
	tee_local	$push512=, $6=, $pop513
	i32.store16	k+2($pop516), $pop512
	i32.const	$push511=, 0
	i32.const	$push510=, 0
	i32.load16_s	$push73=, i($pop510)
	i32.const	$push509=, 0
	i32.load16_s	$push72=, j($pop509)
	i32.div_s	$push508=, $pop73, $pop72
	tee_local	$push507=, $7=, $pop508
	i32.store16	k($pop511), $pop507
	i32.const	$push506=, 0
	i32.store16	res+14($pop506), $0
	i32.const	$push505=, 0
	i32.store16	res+12($pop505), $1
	i32.const	$push504=, 0
	i32.store16	res+10($pop504), $2
	i32.const	$push503=, 0
	i32.store16	res+8($pop503), $3
	i32.const	$push502=, 0
	i32.store16	res+6($pop502), $4
	i32.const	$push501=, 0
	i32.store16	res+4($pop501), $5
	i32.const	$push500=, 0
	i32.store16	res+2($pop500), $6
	i32.const	$push499=, 0
	i32.store16	res($pop499), $7
	i32.const	$push498=, 16
	i32.shl 	$push80=, $7, $pop498
	i32.const	$push497=, 16
	i32.shr_s	$push81=, $pop80, $pop497
	i32.const	$push496=, 16
	i32.shl 	$push78=, $6, $pop496
	i32.const	$push495=, 16
	i32.shr_s	$push79=, $pop78, $pop495
	i32.const	$push494=, 16
	i32.shl 	$push76=, $5, $pop494
	i32.const	$push493=, 16
	i32.shr_s	$push77=, $pop76, $pop493
	i32.const	$push492=, 16
	i32.shl 	$push74=, $4, $pop492
	i32.const	$push491=, 16
	i32.shr_s	$push75=, $pop74, $pop491
	i32.const	$push84=, 15
	i32.const	$push83=, 7
	i32.const	$push490=, 7
	i32.const	$push82=, 6
	call    	verify@FUNCTION, $pop81, $pop79, $pop77, $pop75, $pop84, $pop83, $pop490, $pop82
	i32.const	$push489=, 0
	i32.const	$push488=, 0
	i32.load16_u	$push86=, j+14($pop488)
	i32.const	$push487=, 0
	i32.load16_u	$push85=, i+14($pop487)
	i32.and 	$push486=, $pop86, $pop85
	tee_local	$push485=, $0=, $pop486
	i32.store16	k+14($pop489), $pop485
	i32.const	$push484=, 0
	i32.const	$push483=, 0
	i32.load16_u	$push88=, j+12($pop483)
	i32.const	$push482=, 0
	i32.load16_u	$push87=, i+12($pop482)
	i32.and 	$push481=, $pop88, $pop87
	tee_local	$push480=, $1=, $pop481
	i32.store16	k+12($pop484), $pop480
	i32.const	$push479=, 0
	i32.const	$push478=, 0
	i32.load16_u	$push90=, j+10($pop478)
	i32.const	$push477=, 0
	i32.load16_u	$push89=, i+10($pop477)
	i32.and 	$push476=, $pop90, $pop89
	tee_local	$push475=, $2=, $pop476
	i32.store16	k+10($pop479), $pop475
	i32.const	$push474=, 0
	i32.const	$push473=, 0
	i32.load16_u	$push92=, j+8($pop473)
	i32.const	$push472=, 0
	i32.load16_u	$push91=, i+8($pop472)
	i32.and 	$push471=, $pop92, $pop91
	tee_local	$push470=, $3=, $pop471
	i32.store16	k+8($pop474), $pop470
	i32.const	$push469=, 0
	i32.const	$push468=, 0
	i32.load16_u	$push94=, j+6($pop468)
	i32.const	$push467=, 0
	i32.load16_u	$push93=, i+6($pop467)
	i32.and 	$push466=, $pop94, $pop93
	tee_local	$push465=, $4=, $pop466
	i32.store16	k+6($pop469), $pop465
	i32.const	$push464=, 0
	i32.const	$push463=, 0
	i32.load16_u	$push96=, j+4($pop463)
	i32.const	$push462=, 0
	i32.load16_u	$push95=, i+4($pop462)
	i32.and 	$push461=, $pop96, $pop95
	tee_local	$push460=, $5=, $pop461
	i32.store16	k+4($pop464), $pop460
	i32.const	$push459=, 0
	i32.const	$push458=, 0
	i32.load16_u	$push98=, j+2($pop458)
	i32.const	$push457=, 0
	i32.load16_u	$push97=, i+2($pop457)
	i32.and 	$push456=, $pop98, $pop97
	tee_local	$push455=, $6=, $pop456
	i32.store16	k+2($pop459), $pop455
	i32.const	$push454=, 0
	i32.const	$push453=, 0
	i32.load16_u	$push100=, j($pop453)
	i32.const	$push452=, 0
	i32.load16_u	$push99=, i($pop452)
	i32.and 	$push451=, $pop100, $pop99
	tee_local	$push450=, $7=, $pop451
	i32.store16	k($pop454), $pop450
	i32.const	$push449=, 0
	i32.store16	res+14($pop449), $0
	i32.const	$push448=, 0
	i32.store16	res+12($pop448), $1
	i32.const	$push447=, 0
	i32.store16	res+10($pop447), $2
	i32.const	$push446=, 0
	i32.store16	res+8($pop446), $3
	i32.const	$push445=, 0
	i32.store16	res+6($pop445), $4
	i32.const	$push444=, 0
	i32.store16	res+4($pop444), $5
	i32.const	$push443=, 0
	i32.store16	res+2($pop443), $6
	i32.const	$push442=, 0
	i32.store16	res($pop442), $7
	i32.const	$push441=, 16
	i32.shl 	$push107=, $7, $pop441
	i32.const	$push440=, 16
	i32.shr_s	$push108=, $pop107, $pop440
	i32.const	$push439=, 16
	i32.shl 	$push105=, $6, $pop439
	i32.const	$push438=, 16
	i32.shr_s	$push106=, $pop105, $pop438
	i32.const	$push437=, 16
	i32.shl 	$push103=, $5, $pop437
	i32.const	$push436=, 16
	i32.shr_s	$push104=, $pop103, $pop436
	i32.const	$push435=, 16
	i32.shl 	$push101=, $4, $pop435
	i32.const	$push434=, 16
	i32.shr_s	$push102=, $pop101, $pop434
	i32.const	$push112=, 2
	i32.const	$push111=, 4
	i32.const	$push110=, 20
	i32.const	$push109=, 8
	call    	verify@FUNCTION, $pop108, $pop106, $pop104, $pop102, $pop112, $pop111, $pop110, $pop109
	i32.const	$push433=, 0
	i32.const	$push432=, 0
	i32.load16_u	$push114=, j+14($pop432)
	i32.const	$push431=, 0
	i32.load16_u	$push113=, i+14($pop431)
	i32.or  	$push430=, $pop114, $pop113
	tee_local	$push429=, $0=, $pop430
	i32.store16	k+14($pop433), $pop429
	i32.const	$push428=, 0
	i32.const	$push427=, 0
	i32.load16_u	$push116=, j+12($pop427)
	i32.const	$push426=, 0
	i32.load16_u	$push115=, i+12($pop426)
	i32.or  	$push425=, $pop116, $pop115
	tee_local	$push424=, $1=, $pop425
	i32.store16	k+12($pop428), $pop424
	i32.const	$push423=, 0
	i32.const	$push422=, 0
	i32.load16_u	$push118=, j+10($pop422)
	i32.const	$push421=, 0
	i32.load16_u	$push117=, i+10($pop421)
	i32.or  	$push420=, $pop118, $pop117
	tee_local	$push419=, $2=, $pop420
	i32.store16	k+10($pop423), $pop419
	i32.const	$push418=, 0
	i32.const	$push417=, 0
	i32.load16_u	$push120=, j+8($pop417)
	i32.const	$push416=, 0
	i32.load16_u	$push119=, i+8($pop416)
	i32.or  	$push415=, $pop120, $pop119
	tee_local	$push414=, $3=, $pop415
	i32.store16	k+8($pop418), $pop414
	i32.const	$push413=, 0
	i32.const	$push412=, 0
	i32.load16_u	$push122=, j+6($pop412)
	i32.const	$push411=, 0
	i32.load16_u	$push121=, i+6($pop411)
	i32.or  	$push410=, $pop122, $pop121
	tee_local	$push409=, $4=, $pop410
	i32.store16	k+6($pop413), $pop409
	i32.const	$push408=, 0
	i32.const	$push407=, 0
	i32.load16_u	$push124=, j+4($pop407)
	i32.const	$push406=, 0
	i32.load16_u	$push123=, i+4($pop406)
	i32.or  	$push405=, $pop124, $pop123
	tee_local	$push404=, $5=, $pop405
	i32.store16	k+4($pop408), $pop404
	i32.const	$push403=, 0
	i32.const	$push402=, 0
	i32.load16_u	$push126=, j+2($pop402)
	i32.const	$push401=, 0
	i32.load16_u	$push125=, i+2($pop401)
	i32.or  	$push400=, $pop126, $pop125
	tee_local	$push399=, $6=, $pop400
	i32.store16	k+2($pop403), $pop399
	i32.const	$push398=, 0
	i32.const	$push397=, 0
	i32.load16_u	$push128=, j($pop397)
	i32.const	$push396=, 0
	i32.load16_u	$push127=, i($pop396)
	i32.or  	$push395=, $pop128, $pop127
	tee_local	$push394=, $7=, $pop395
	i32.store16	k($pop398), $pop394
	i32.const	$push393=, 0
	i32.store16	res+14($pop393), $0
	i32.const	$push392=, 0
	i32.store16	res+12($pop392), $1
	i32.const	$push391=, 0
	i32.store16	res+10($pop391), $2
	i32.const	$push390=, 0
	i32.store16	res+8($pop390), $3
	i32.const	$push389=, 0
	i32.store16	res+6($pop389), $4
	i32.const	$push388=, 0
	i32.store16	res+4($pop388), $5
	i32.const	$push387=, 0
	i32.store16	res+2($pop387), $6
	i32.const	$push386=, 0
	i32.store16	res($pop386), $7
	i32.const	$push385=, 16
	i32.shl 	$push135=, $7, $pop385
	i32.const	$push384=, 16
	i32.shr_s	$push136=, $pop135, $pop384
	i32.const	$push383=, 16
	i32.shl 	$push133=, $6, $pop383
	i32.const	$push382=, 16
	i32.shr_s	$push134=, $pop133, $pop382
	i32.const	$push381=, 16
	i32.shl 	$push131=, $5, $pop381
	i32.const	$push380=, 16
	i32.shr_s	$push132=, $pop131, $pop380
	i32.const	$push379=, 16
	i32.shl 	$push129=, $4, $pop379
	i32.const	$push378=, 16
	i32.shr_s	$push130=, $pop129, $pop378
	i32.const	$push140=, 158
	i32.const	$push139=, 109
	i32.const	$push138=, 150
	i32.const	$push137=, 222
	call    	verify@FUNCTION, $pop136, $pop134, $pop132, $pop130, $pop140, $pop139, $pop138, $pop137
	i32.const	$push377=, 0
	i32.const	$push376=, 0
	i32.load16_u	$push142=, i+14($pop376)
	i32.const	$push375=, 0
	i32.load16_u	$push141=, j+14($pop375)
	i32.xor 	$push374=, $pop142, $pop141
	tee_local	$push373=, $0=, $pop374
	i32.store16	k+14($pop377), $pop373
	i32.const	$push372=, 0
	i32.const	$push371=, 0
	i32.load16_u	$push144=, i+12($pop371)
	i32.const	$push370=, 0
	i32.load16_u	$push143=, j+12($pop370)
	i32.xor 	$push369=, $pop144, $pop143
	tee_local	$push368=, $1=, $pop369
	i32.store16	k+12($pop372), $pop368
	i32.const	$push367=, 0
	i32.const	$push366=, 0
	i32.load16_u	$push146=, i+10($pop366)
	i32.const	$push365=, 0
	i32.load16_u	$push145=, j+10($pop365)
	i32.xor 	$push364=, $pop146, $pop145
	tee_local	$push363=, $2=, $pop364
	i32.store16	k+10($pop367), $pop363
	i32.const	$push362=, 0
	i32.const	$push361=, 0
	i32.load16_u	$push148=, i+8($pop361)
	i32.const	$push360=, 0
	i32.load16_u	$push147=, j+8($pop360)
	i32.xor 	$push359=, $pop148, $pop147
	tee_local	$push358=, $3=, $pop359
	i32.store16	k+8($pop362), $pop358
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i32.load16_u	$push150=, i+6($pop356)
	i32.const	$push355=, 0
	i32.load16_u	$push149=, j+6($pop355)
	i32.xor 	$push354=, $pop150, $pop149
	tee_local	$push353=, $4=, $pop354
	i32.store16	k+6($pop357), $pop353
	i32.const	$push352=, 0
	i32.const	$push351=, 0
	i32.load16_u	$push152=, i+4($pop351)
	i32.const	$push350=, 0
	i32.load16_u	$push151=, j+4($pop350)
	i32.xor 	$push349=, $pop152, $pop151
	tee_local	$push348=, $5=, $pop349
	i32.store16	k+4($pop352), $pop348
	i32.const	$push347=, 0
	i32.const	$push346=, 0
	i32.load16_u	$push154=, i+2($pop346)
	i32.const	$push345=, 0
	i32.load16_u	$push153=, j+2($pop345)
	i32.xor 	$push344=, $pop154, $pop153
	tee_local	$push343=, $6=, $pop344
	i32.store16	k+2($pop347), $pop343
	i32.const	$push342=, 0
	i32.const	$push341=, 0
	i32.load16_u	$push156=, i($pop341)
	i32.const	$push340=, 0
	i32.load16_u	$push155=, j($pop340)
	i32.xor 	$push339=, $pop156, $pop155
	tee_local	$push338=, $7=, $pop339
	i32.store16	k($pop342), $pop338
	i32.const	$push337=, 0
	i32.store16	res+14($pop337), $0
	i32.const	$push336=, 0
	i32.store16	res+12($pop336), $1
	i32.const	$push335=, 0
	i32.store16	res+10($pop335), $2
	i32.const	$push334=, 0
	i32.store16	res+8($pop334), $3
	i32.const	$push333=, 0
	i32.store16	res+6($pop333), $4
	i32.const	$push332=, 0
	i32.store16	res+4($pop332), $5
	i32.const	$push331=, 0
	i32.store16	res+2($pop331), $6
	i32.const	$push330=, 0
	i32.store16	res($pop330), $7
	i32.const	$push329=, 16
	i32.shl 	$push163=, $7, $pop329
	i32.const	$push328=, 16
	i32.shr_s	$push164=, $pop163, $pop328
	i32.const	$push327=, 16
	i32.shl 	$push161=, $6, $pop327
	i32.const	$push326=, 16
	i32.shr_s	$push162=, $pop161, $pop326
	i32.const	$push325=, 16
	i32.shl 	$push159=, $5, $pop325
	i32.const	$push324=, 16
	i32.shr_s	$push160=, $pop159, $pop324
	i32.const	$push323=, 16
	i32.shl 	$push157=, $4, $pop323
	i32.const	$push322=, 16
	i32.shr_s	$push158=, $pop157, $pop322
	i32.const	$push168=, 156
	i32.const	$push167=, 105
	i32.const	$push166=, 130
	i32.const	$push165=, 214
	call    	verify@FUNCTION, $pop164, $pop162, $pop160, $pop158, $pop168, $pop167, $pop166, $pop165
	i32.const	$push321=, 0
	i32.const	$push320=, 0
	i32.const	$push319=, 0
	i32.load16_u	$push169=, i+14($pop319)
	i32.sub 	$push318=, $pop320, $pop169
	tee_local	$push317=, $0=, $pop318
	i32.store16	k+14($pop321), $pop317
	i32.const	$push316=, 0
	i32.const	$push315=, 0
	i32.const	$push314=, 0
	i32.load16_u	$push170=, i+12($pop314)
	i32.sub 	$push313=, $pop315, $pop170
	tee_local	$push312=, $1=, $pop313
	i32.store16	k+12($pop316), $pop312
	i32.const	$push311=, 0
	i32.const	$push310=, 0
	i32.const	$push309=, 0
	i32.load16_u	$push171=, i+10($pop309)
	i32.sub 	$push308=, $pop310, $pop171
	tee_local	$push307=, $2=, $pop308
	i32.store16	k+10($pop311), $pop307
	i32.const	$push306=, 0
	i32.const	$push305=, 0
	i32.const	$push304=, 0
	i32.load16_u	$push172=, i+8($pop304)
	i32.sub 	$push303=, $pop305, $pop172
	tee_local	$push302=, $3=, $pop303
	i32.store16	k+8($pop306), $pop302
	i32.const	$push301=, 0
	i32.const	$push300=, 0
	i32.const	$push299=, 0
	i32.load16_u	$push173=, i+6($pop299)
	i32.sub 	$push298=, $pop300, $pop173
	tee_local	$push297=, $4=, $pop298
	i32.store16	k+6($pop301), $pop297
	i32.const	$push296=, 0
	i32.const	$push295=, 0
	i32.const	$push294=, 0
	i32.load16_u	$push174=, i+4($pop294)
	i32.sub 	$push293=, $pop295, $pop174
	tee_local	$push292=, $5=, $pop293
	i32.store16	k+4($pop296), $pop292
	i32.const	$push291=, 0
	i32.const	$push290=, 0
	i32.const	$push289=, 0
	i32.load16_u	$push175=, i+2($pop289)
	i32.sub 	$push288=, $pop290, $pop175
	tee_local	$push287=, $6=, $pop288
	i32.store16	k+2($pop291), $pop287
	i32.const	$push286=, 0
	i32.const	$push285=, 0
	i32.const	$push284=, 0
	i32.load16_u	$push176=, i($pop284)
	i32.sub 	$push283=, $pop285, $pop176
	tee_local	$push282=, $7=, $pop283
	i32.store16	k($pop286), $pop282
	i32.const	$push281=, 0
	i32.store16	res+14($pop281), $0
	i32.const	$push280=, 0
	i32.store16	res+12($pop280), $1
	i32.const	$push279=, 0
	i32.store16	res+10($pop279), $2
	i32.const	$push278=, 0
	i32.store16	res+8($pop278), $3
	i32.const	$push277=, 0
	i32.store16	res+6($pop277), $4
	i32.const	$push276=, 0
	i32.store16	res+4($pop276), $5
	i32.const	$push275=, 0
	i32.store16	res+2($pop275), $6
	i32.const	$push274=, 0
	i32.store16	res($pop274), $7
	i32.const	$push273=, 16
	i32.shl 	$push183=, $7, $pop273
	i32.const	$push272=, 16
	i32.shr_s	$push184=, $pop183, $pop272
	i32.const	$push271=, 16
	i32.shl 	$push181=, $6, $pop271
	i32.const	$push270=, 16
	i32.shr_s	$push182=, $pop181, $pop270
	i32.const	$push269=, 16
	i32.shl 	$push179=, $5, $pop269
	i32.const	$push268=, 16
	i32.shr_s	$push180=, $pop179, $pop268
	i32.const	$push267=, 16
	i32.shl 	$push177=, $4, $pop267
	i32.const	$push266=, 16
	i32.shr_s	$push178=, $pop177, $pop266
	i32.const	$push187=, -150
	i32.const	$push186=, -100
	i32.const	$push265=, -150
	i32.const	$push185=, -200
	call    	verify@FUNCTION, $pop184, $pop182, $pop180, $pop178, $pop187, $pop186, $pop265, $pop185
	i32.const	$push264=, 0
	i32.const	$push263=, 0
	i32.load16_u	$push188=, i+14($pop263)
	i32.const	$push189=, -1
	i32.xor 	$push262=, $pop188, $pop189
	tee_local	$push261=, $0=, $pop262
	i32.store16	k+14($pop264), $pop261
	i32.const	$push260=, 0
	i32.const	$push259=, 0
	i32.load16_u	$push190=, i+12($pop259)
	i32.const	$push258=, -1
	i32.xor 	$push257=, $pop190, $pop258
	tee_local	$push256=, $1=, $pop257
	i32.store16	k+12($pop260), $pop256
	i32.const	$push255=, 0
	i32.const	$push254=, 0
	i32.load16_u	$push191=, i+10($pop254)
	i32.const	$push253=, -1
	i32.xor 	$push252=, $pop191, $pop253
	tee_local	$push251=, $2=, $pop252
	i32.store16	k+10($pop255), $pop251
	i32.const	$push250=, 0
	i32.const	$push249=, 0
	i32.load16_u	$push192=, i+8($pop249)
	i32.const	$push248=, -1
	i32.xor 	$push247=, $pop192, $pop248
	tee_local	$push246=, $3=, $pop247
	i32.store16	k+8($pop250), $pop246
	i32.const	$push245=, 0
	i32.const	$push244=, 0
	i32.load16_u	$push193=, i+6($pop244)
	i32.const	$push243=, -1
	i32.xor 	$push242=, $pop193, $pop243
	tee_local	$push241=, $4=, $pop242
	i32.store16	k+6($pop245), $pop241
	i32.const	$push240=, 0
	i32.const	$push239=, 0
	i32.load16_u	$push194=, i+4($pop239)
	i32.const	$push238=, -1
	i32.xor 	$push237=, $pop194, $pop238
	tee_local	$push236=, $5=, $pop237
	i32.store16	k+4($pop240), $pop236
	i32.const	$push235=, 0
	i32.const	$push234=, 0
	i32.load16_u	$push195=, i+2($pop234)
	i32.const	$push233=, -1
	i32.xor 	$push232=, $pop195, $pop233
	tee_local	$push231=, $6=, $pop232
	i32.store16	k+2($pop235), $pop231
	i32.const	$push230=, 0
	i32.const	$push229=, 0
	i32.load16_u	$push196=, i($pop229)
	i32.const	$push228=, -1
	i32.xor 	$push227=, $pop196, $pop228
	tee_local	$push226=, $7=, $pop227
	i32.store16	k($pop230), $pop226
	i32.const	$push225=, 0
	i32.store16	res+14($pop225), $0
	i32.const	$push224=, 0
	i32.store16	res+12($pop224), $1
	i32.const	$push223=, 0
	i32.store16	res+10($pop223), $2
	i32.const	$push222=, 0
	i32.store16	res+8($pop222), $3
	i32.const	$push221=, 0
	i32.store16	res+6($pop221), $4
	i32.const	$push220=, 0
	i32.store16	res+4($pop220), $5
	i32.const	$push219=, 0
	i32.store16	res+2($pop219), $6
	i32.const	$push218=, 0
	i32.store16	res($pop218), $7
	i32.const	$push217=, 16
	i32.shl 	$push203=, $7, $pop217
	i32.const	$push216=, 16
	i32.shr_s	$push204=, $pop203, $pop216
	i32.const	$push215=, 16
	i32.shl 	$push201=, $6, $pop215
	i32.const	$push214=, 16
	i32.shr_s	$push202=, $pop201, $pop214
	i32.const	$push213=, 16
	i32.shl 	$push199=, $5, $pop213
	i32.const	$push212=, 16
	i32.shr_s	$push200=, $pop199, $pop212
	i32.const	$push211=, 16
	i32.shl 	$push197=, $4, $pop211
	i32.const	$push210=, 16
	i32.shr_s	$push198=, $pop197, $pop210
	i32.const	$push207=, -151
	i32.const	$push206=, -101
	i32.const	$push209=, -151
	i32.const	$push205=, -201
	call    	verify@FUNCTION, $pop204, $pop202, $pop200, $pop198, $pop207, $pop206, $pop209, $pop205
	i32.const	$push208=, 0
	call    	exit@FUNCTION, $pop208
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	4
i:
	.int16	150                     # 0x96
	.int16	100                     # 0x64
	.int16	150                     # 0x96
	.int16	200                     # 0xc8
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	i, 16

	.hidden	j                       # @j
	.type	j,@object
	.section	.data.j,"aw",@progbits
	.globl	j
	.p2align	4
j:
	.int16	10                      # 0xa
	.int16	13                      # 0xd
	.int16	20                      # 0x14
	.int16	30                      # 0x1e
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.size	j, 16

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	4
k:
	.skip	16
	.size	k, 16

	.hidden	res                     # @res
	.type	res,@object
	.section	.bss.res,"aw",@nobits
	.globl	res
	.p2align	4
res:
	.skip	16
	.size	res, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
