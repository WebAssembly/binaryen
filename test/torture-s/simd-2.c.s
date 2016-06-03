	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-2.c"
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
	i32.const	$push8=, 0
	i32.const	$push600=, 0
	i32.load16_u	$push10=, j+14($pop600)
	i32.const	$push599=, 0
	i32.load16_u	$push9=, i+14($pop599)
	i32.add 	$push11=, $pop10, $pop9
	i32.store16	$0=, k+14($pop8), $pop11
	i32.const	$push598=, 0
	i32.const	$push597=, 0
	i32.load16_u	$push13=, j+12($pop597)
	i32.const	$push596=, 0
	i32.load16_u	$push12=, i+12($pop596)
	i32.add 	$push14=, $pop13, $pop12
	i32.store16	$1=, k+12($pop598), $pop14
	i32.const	$push595=, 0
	i32.const	$push594=, 0
	i32.load16_u	$push16=, j+10($pop594)
	i32.const	$push593=, 0
	i32.load16_u	$push15=, i+10($pop593)
	i32.add 	$push17=, $pop16, $pop15
	i32.store16	$2=, k+10($pop595), $pop17
	i32.const	$push592=, 0
	i32.const	$push591=, 0
	i32.load16_u	$push19=, j+8($pop591)
	i32.const	$push590=, 0
	i32.load16_u	$push18=, i+8($pop590)
	i32.add 	$push20=, $pop19, $pop18
	i32.store16	$3=, k+8($pop592), $pop20
	i32.const	$push589=, 0
	i32.const	$push588=, 0
	i32.load16_u	$push22=, j+6($pop588)
	i32.const	$push587=, 0
	i32.load16_u	$push21=, i+6($pop587)
	i32.add 	$push23=, $pop22, $pop21
	i32.store16	$4=, k+6($pop589), $pop23
	i32.const	$push586=, 0
	i32.const	$push585=, 0
	i32.load16_u	$push25=, j+4($pop585)
	i32.const	$push584=, 0
	i32.load16_u	$push24=, i+4($pop584)
	i32.add 	$push26=, $pop25, $pop24
	i32.store16	$5=, k+4($pop586), $pop26
	i32.const	$push583=, 0
	i32.const	$push582=, 0
	i32.load16_u	$push28=, j+2($pop582)
	i32.const	$push581=, 0
	i32.load16_u	$push27=, i+2($pop581)
	i32.add 	$push29=, $pop28, $pop27
	i32.store16	$6=, k+2($pop583), $pop29
	i32.const	$push580=, 0
	i32.const	$push579=, 0
	i32.load16_u	$push31=, j($pop579)
	i32.const	$push578=, 0
	i32.load16_u	$push30=, i($pop578)
	i32.add 	$push32=, $pop31, $pop30
	i32.store16	$7=, k($pop580), $pop32
	i32.const	$push577=, 0
	i32.store16	$drop=, res+14($pop577), $0
	i32.const	$push576=, 0
	i32.store16	$drop=, res+12($pop576), $1
	i32.const	$push575=, 0
	i32.store16	$drop=, res+10($pop575), $2
	i32.const	$push574=, 0
	i32.store16	$drop=, res+8($pop574), $3
	i32.const	$push573=, 0
	i32.store16	$0=, res+6($pop573), $4
	i32.const	$push572=, 0
	i32.store16	$1=, res+4($pop572), $5
	i32.const	$push571=, 0
	i32.store16	$2=, res+2($pop571), $6
	i32.const	$push570=, 0
	i32.store16	$push0=, res($pop570), $7
	i32.const	$push33=, 16
	i32.shl 	$push40=, $pop0, $pop33
	i32.const	$push569=, 16
	i32.shr_s	$push41=, $pop40, $pop569
	i32.const	$push568=, 16
	i32.shl 	$push38=, $2, $pop568
	i32.const	$push567=, 16
	i32.shr_s	$push39=, $pop38, $pop567
	i32.const	$push566=, 16
	i32.shl 	$push36=, $1, $pop566
	i32.const	$push565=, 16
	i32.shr_s	$push37=, $pop36, $pop565
	i32.const	$push564=, 16
	i32.shl 	$push34=, $0, $pop564
	i32.const	$push563=, 16
	i32.shr_s	$push35=, $pop34, $pop563
	i32.const	$push45=, 160
	i32.const	$push44=, 113
	i32.const	$push43=, 170
	i32.const	$push42=, 230
	call    	verify@FUNCTION, $pop41, $pop39, $pop37, $pop35, $pop45, $pop44, $pop43, $pop42
	i32.const	$push562=, 0
	i32.const	$push561=, 0
	i32.load16_u	$push47=, j+14($pop561)
	i32.const	$push560=, 0
	i32.load16_u	$push46=, i+14($pop560)
	i32.mul 	$push48=, $pop47, $pop46
	i32.store16	$0=, k+14($pop562), $pop48
	i32.const	$push559=, 0
	i32.const	$push558=, 0
	i32.load16_u	$push50=, j+12($pop558)
	i32.const	$push557=, 0
	i32.load16_u	$push49=, i+12($pop557)
	i32.mul 	$push51=, $pop50, $pop49
	i32.store16	$1=, k+12($pop559), $pop51
	i32.const	$push556=, 0
	i32.const	$push555=, 0
	i32.load16_u	$push53=, j+10($pop555)
	i32.const	$push554=, 0
	i32.load16_u	$push52=, i+10($pop554)
	i32.mul 	$push54=, $pop53, $pop52
	i32.store16	$2=, k+10($pop556), $pop54
	i32.const	$push553=, 0
	i32.const	$push552=, 0
	i32.load16_u	$push56=, j+8($pop552)
	i32.const	$push551=, 0
	i32.load16_u	$push55=, i+8($pop551)
	i32.mul 	$push57=, $pop56, $pop55
	i32.store16	$3=, k+8($pop553), $pop57
	i32.const	$push550=, 0
	i32.const	$push549=, 0
	i32.load16_u	$push59=, j+6($pop549)
	i32.const	$push548=, 0
	i32.load16_u	$push58=, i+6($pop548)
	i32.mul 	$push60=, $pop59, $pop58
	i32.store16	$4=, k+6($pop550), $pop60
	i32.const	$push547=, 0
	i32.const	$push546=, 0
	i32.load16_u	$push62=, j+4($pop546)
	i32.const	$push545=, 0
	i32.load16_u	$push61=, i+4($pop545)
	i32.mul 	$push63=, $pop62, $pop61
	i32.store16	$5=, k+4($pop547), $pop63
	i32.const	$push544=, 0
	i32.const	$push543=, 0
	i32.load16_u	$push65=, j+2($pop543)
	i32.const	$push542=, 0
	i32.load16_u	$push64=, i+2($pop542)
	i32.mul 	$push66=, $pop65, $pop64
	i32.store16	$6=, k+2($pop544), $pop66
	i32.const	$push541=, 0
	i32.const	$push540=, 0
	i32.load16_u	$push68=, j($pop540)
	i32.const	$push539=, 0
	i32.load16_u	$push67=, i($pop539)
	i32.mul 	$push69=, $pop68, $pop67
	i32.store16	$7=, k($pop541), $pop69
	i32.const	$push538=, 0
	i32.store16	$drop=, res+14($pop538), $0
	i32.const	$push537=, 0
	i32.store16	$drop=, res+12($pop537), $1
	i32.const	$push536=, 0
	i32.store16	$drop=, res+10($pop536), $2
	i32.const	$push535=, 0
	i32.store16	$drop=, res+8($pop535), $3
	i32.const	$push534=, 0
	i32.store16	$0=, res+6($pop534), $4
	i32.const	$push533=, 0
	i32.store16	$1=, res+4($pop533), $5
	i32.const	$push532=, 0
	i32.store16	$2=, res+2($pop532), $6
	i32.const	$push531=, 0
	i32.store16	$push1=, res($pop531), $7
	i32.const	$push530=, 16
	i32.shl 	$push76=, $pop1, $pop530
	i32.const	$push529=, 16
	i32.shr_s	$push77=, $pop76, $pop529
	i32.const	$push528=, 16
	i32.shl 	$push74=, $2, $pop528
	i32.const	$push527=, 16
	i32.shr_s	$push75=, $pop74, $pop527
	i32.const	$push526=, 16
	i32.shl 	$push72=, $1, $pop526
	i32.const	$push525=, 16
	i32.shr_s	$push73=, $pop72, $pop525
	i32.const	$push524=, 16
	i32.shl 	$push70=, $0, $pop524
	i32.const	$push523=, 16
	i32.shr_s	$push71=, $pop70, $pop523
	i32.const	$push81=, 1500
	i32.const	$push80=, 1300
	i32.const	$push79=, 3000
	i32.const	$push78=, 6000
	call    	verify@FUNCTION, $pop77, $pop75, $pop73, $pop71, $pop81, $pop80, $pop79, $pop78
	i32.const	$push522=, 0
	i32.const	$push521=, 0
	i32.load16_s	$push83=, i+14($pop521)
	i32.const	$push520=, 0
	i32.load16_s	$push82=, j+14($pop520)
	i32.div_s	$push84=, $pop83, $pop82
	i32.store16	$0=, k+14($pop522), $pop84
	i32.const	$push519=, 0
	i32.const	$push518=, 0
	i32.load16_s	$push86=, i+12($pop518)
	i32.const	$push517=, 0
	i32.load16_s	$push85=, j+12($pop517)
	i32.div_s	$push87=, $pop86, $pop85
	i32.store16	$1=, k+12($pop519), $pop87
	i32.const	$push516=, 0
	i32.const	$push515=, 0
	i32.load16_s	$push89=, i+10($pop515)
	i32.const	$push514=, 0
	i32.load16_s	$push88=, j+10($pop514)
	i32.div_s	$push90=, $pop89, $pop88
	i32.store16	$2=, k+10($pop516), $pop90
	i32.const	$push513=, 0
	i32.const	$push512=, 0
	i32.load16_s	$push92=, i+8($pop512)
	i32.const	$push511=, 0
	i32.load16_s	$push91=, j+8($pop511)
	i32.div_s	$push93=, $pop92, $pop91
	i32.store16	$3=, k+8($pop513), $pop93
	i32.const	$push510=, 0
	i32.const	$push509=, 0
	i32.load16_s	$push95=, i+6($pop509)
	i32.const	$push508=, 0
	i32.load16_s	$push94=, j+6($pop508)
	i32.div_s	$push96=, $pop95, $pop94
	i32.store16	$4=, k+6($pop510), $pop96
	i32.const	$push507=, 0
	i32.const	$push506=, 0
	i32.load16_s	$push98=, i+4($pop506)
	i32.const	$push505=, 0
	i32.load16_s	$push97=, j+4($pop505)
	i32.div_s	$push99=, $pop98, $pop97
	i32.store16	$5=, k+4($pop507), $pop99
	i32.const	$push504=, 0
	i32.const	$push503=, 0
	i32.load16_s	$push101=, i+2($pop503)
	i32.const	$push502=, 0
	i32.load16_s	$push100=, j+2($pop502)
	i32.div_s	$push102=, $pop101, $pop100
	i32.store16	$6=, k+2($pop504), $pop102
	i32.const	$push501=, 0
	i32.const	$push500=, 0
	i32.load16_s	$push104=, i($pop500)
	i32.const	$push499=, 0
	i32.load16_s	$push103=, j($pop499)
	i32.div_s	$push105=, $pop104, $pop103
	i32.store16	$7=, k($pop501), $pop105
	i32.const	$push498=, 0
	i32.store16	$drop=, res+14($pop498), $0
	i32.const	$push497=, 0
	i32.store16	$drop=, res+12($pop497), $1
	i32.const	$push496=, 0
	i32.store16	$drop=, res+10($pop496), $2
	i32.const	$push495=, 0
	i32.store16	$drop=, res+8($pop495), $3
	i32.const	$push494=, 0
	i32.store16	$0=, res+6($pop494), $4
	i32.const	$push493=, 0
	i32.store16	$1=, res+4($pop493), $5
	i32.const	$push492=, 0
	i32.store16	$2=, res+2($pop492), $6
	i32.const	$push491=, 0
	i32.store16	$push2=, res($pop491), $7
	i32.const	$push490=, 16
	i32.shl 	$push112=, $pop2, $pop490
	i32.const	$push489=, 16
	i32.shr_s	$push113=, $pop112, $pop489
	i32.const	$push488=, 16
	i32.shl 	$push110=, $2, $pop488
	i32.const	$push487=, 16
	i32.shr_s	$push111=, $pop110, $pop487
	i32.const	$push486=, 16
	i32.shl 	$push108=, $1, $pop486
	i32.const	$push485=, 16
	i32.shr_s	$push109=, $pop108, $pop485
	i32.const	$push484=, 16
	i32.shl 	$push106=, $0, $pop484
	i32.const	$push483=, 16
	i32.shr_s	$push107=, $pop106, $pop483
	i32.const	$push116=, 15
	i32.const	$push115=, 7
	i32.const	$push482=, 7
	i32.const	$push114=, 6
	call    	verify@FUNCTION, $pop113, $pop111, $pop109, $pop107, $pop116, $pop115, $pop482, $pop114
	i32.const	$push481=, 0
	i32.const	$push480=, 0
	i32.load16_u	$push118=, j+14($pop480)
	i32.const	$push479=, 0
	i32.load16_u	$push117=, i+14($pop479)
	i32.and 	$push119=, $pop118, $pop117
	i32.store16	$0=, k+14($pop481), $pop119
	i32.const	$push478=, 0
	i32.const	$push477=, 0
	i32.load16_u	$push121=, j+12($pop477)
	i32.const	$push476=, 0
	i32.load16_u	$push120=, i+12($pop476)
	i32.and 	$push122=, $pop121, $pop120
	i32.store16	$1=, k+12($pop478), $pop122
	i32.const	$push475=, 0
	i32.const	$push474=, 0
	i32.load16_u	$push124=, j+10($pop474)
	i32.const	$push473=, 0
	i32.load16_u	$push123=, i+10($pop473)
	i32.and 	$push125=, $pop124, $pop123
	i32.store16	$2=, k+10($pop475), $pop125
	i32.const	$push472=, 0
	i32.const	$push471=, 0
	i32.load16_u	$push127=, j+8($pop471)
	i32.const	$push470=, 0
	i32.load16_u	$push126=, i+8($pop470)
	i32.and 	$push128=, $pop127, $pop126
	i32.store16	$3=, k+8($pop472), $pop128
	i32.const	$push469=, 0
	i32.const	$push468=, 0
	i32.load16_u	$push130=, j+6($pop468)
	i32.const	$push467=, 0
	i32.load16_u	$push129=, i+6($pop467)
	i32.and 	$push131=, $pop130, $pop129
	i32.store16	$4=, k+6($pop469), $pop131
	i32.const	$push466=, 0
	i32.const	$push465=, 0
	i32.load16_u	$push133=, j+4($pop465)
	i32.const	$push464=, 0
	i32.load16_u	$push132=, i+4($pop464)
	i32.and 	$push134=, $pop133, $pop132
	i32.store16	$5=, k+4($pop466), $pop134
	i32.const	$push463=, 0
	i32.const	$push462=, 0
	i32.load16_u	$push136=, j+2($pop462)
	i32.const	$push461=, 0
	i32.load16_u	$push135=, i+2($pop461)
	i32.and 	$push137=, $pop136, $pop135
	i32.store16	$6=, k+2($pop463), $pop137
	i32.const	$push460=, 0
	i32.const	$push459=, 0
	i32.load16_u	$push139=, j($pop459)
	i32.const	$push458=, 0
	i32.load16_u	$push138=, i($pop458)
	i32.and 	$push140=, $pop139, $pop138
	i32.store16	$7=, k($pop460), $pop140
	i32.const	$push457=, 0
	i32.store16	$drop=, res+14($pop457), $0
	i32.const	$push456=, 0
	i32.store16	$drop=, res+12($pop456), $1
	i32.const	$push455=, 0
	i32.store16	$drop=, res+10($pop455), $2
	i32.const	$push454=, 0
	i32.store16	$drop=, res+8($pop454), $3
	i32.const	$push453=, 0
	i32.store16	$0=, res+6($pop453), $4
	i32.const	$push452=, 0
	i32.store16	$1=, res+4($pop452), $5
	i32.const	$push451=, 0
	i32.store16	$2=, res+2($pop451), $6
	i32.const	$push450=, 0
	i32.store16	$push3=, res($pop450), $7
	i32.const	$push449=, 16
	i32.shl 	$push147=, $pop3, $pop449
	i32.const	$push448=, 16
	i32.shr_s	$push148=, $pop147, $pop448
	i32.const	$push447=, 16
	i32.shl 	$push145=, $2, $pop447
	i32.const	$push446=, 16
	i32.shr_s	$push146=, $pop145, $pop446
	i32.const	$push445=, 16
	i32.shl 	$push143=, $1, $pop445
	i32.const	$push444=, 16
	i32.shr_s	$push144=, $pop143, $pop444
	i32.const	$push443=, 16
	i32.shl 	$push141=, $0, $pop443
	i32.const	$push442=, 16
	i32.shr_s	$push142=, $pop141, $pop442
	i32.const	$push152=, 2
	i32.const	$push151=, 4
	i32.const	$push150=, 20
	i32.const	$push149=, 8
	call    	verify@FUNCTION, $pop148, $pop146, $pop144, $pop142, $pop152, $pop151, $pop150, $pop149
	i32.const	$push441=, 0
	i32.const	$push440=, 0
	i32.load16_u	$push154=, j+14($pop440)
	i32.const	$push439=, 0
	i32.load16_u	$push153=, i+14($pop439)
	i32.or  	$push155=, $pop154, $pop153
	i32.store16	$0=, k+14($pop441), $pop155
	i32.const	$push438=, 0
	i32.const	$push437=, 0
	i32.load16_u	$push157=, j+12($pop437)
	i32.const	$push436=, 0
	i32.load16_u	$push156=, i+12($pop436)
	i32.or  	$push158=, $pop157, $pop156
	i32.store16	$1=, k+12($pop438), $pop158
	i32.const	$push435=, 0
	i32.const	$push434=, 0
	i32.load16_u	$push160=, j+10($pop434)
	i32.const	$push433=, 0
	i32.load16_u	$push159=, i+10($pop433)
	i32.or  	$push161=, $pop160, $pop159
	i32.store16	$2=, k+10($pop435), $pop161
	i32.const	$push432=, 0
	i32.const	$push431=, 0
	i32.load16_u	$push163=, j+8($pop431)
	i32.const	$push430=, 0
	i32.load16_u	$push162=, i+8($pop430)
	i32.or  	$push164=, $pop163, $pop162
	i32.store16	$3=, k+8($pop432), $pop164
	i32.const	$push429=, 0
	i32.const	$push428=, 0
	i32.load16_u	$push166=, j+6($pop428)
	i32.const	$push427=, 0
	i32.load16_u	$push165=, i+6($pop427)
	i32.or  	$push167=, $pop166, $pop165
	i32.store16	$4=, k+6($pop429), $pop167
	i32.const	$push426=, 0
	i32.const	$push425=, 0
	i32.load16_u	$push169=, j+4($pop425)
	i32.const	$push424=, 0
	i32.load16_u	$push168=, i+4($pop424)
	i32.or  	$push170=, $pop169, $pop168
	i32.store16	$5=, k+4($pop426), $pop170
	i32.const	$push423=, 0
	i32.const	$push422=, 0
	i32.load16_u	$push172=, j+2($pop422)
	i32.const	$push421=, 0
	i32.load16_u	$push171=, i+2($pop421)
	i32.or  	$push173=, $pop172, $pop171
	i32.store16	$6=, k+2($pop423), $pop173
	i32.const	$push420=, 0
	i32.const	$push419=, 0
	i32.load16_u	$push175=, j($pop419)
	i32.const	$push418=, 0
	i32.load16_u	$push174=, i($pop418)
	i32.or  	$push176=, $pop175, $pop174
	i32.store16	$7=, k($pop420), $pop176
	i32.const	$push417=, 0
	i32.store16	$drop=, res+14($pop417), $0
	i32.const	$push416=, 0
	i32.store16	$drop=, res+12($pop416), $1
	i32.const	$push415=, 0
	i32.store16	$drop=, res+10($pop415), $2
	i32.const	$push414=, 0
	i32.store16	$drop=, res+8($pop414), $3
	i32.const	$push413=, 0
	i32.store16	$0=, res+6($pop413), $4
	i32.const	$push412=, 0
	i32.store16	$1=, res+4($pop412), $5
	i32.const	$push411=, 0
	i32.store16	$2=, res+2($pop411), $6
	i32.const	$push410=, 0
	i32.store16	$push4=, res($pop410), $7
	i32.const	$push409=, 16
	i32.shl 	$push183=, $pop4, $pop409
	i32.const	$push408=, 16
	i32.shr_s	$push184=, $pop183, $pop408
	i32.const	$push407=, 16
	i32.shl 	$push181=, $2, $pop407
	i32.const	$push406=, 16
	i32.shr_s	$push182=, $pop181, $pop406
	i32.const	$push405=, 16
	i32.shl 	$push179=, $1, $pop405
	i32.const	$push404=, 16
	i32.shr_s	$push180=, $pop179, $pop404
	i32.const	$push403=, 16
	i32.shl 	$push177=, $0, $pop403
	i32.const	$push402=, 16
	i32.shr_s	$push178=, $pop177, $pop402
	i32.const	$push188=, 158
	i32.const	$push187=, 109
	i32.const	$push186=, 150
	i32.const	$push185=, 222
	call    	verify@FUNCTION, $pop184, $pop182, $pop180, $pop178, $pop188, $pop187, $pop186, $pop185
	i32.const	$push401=, 0
	i32.const	$push400=, 0
	i32.load16_u	$push190=, i+14($pop400)
	i32.const	$push399=, 0
	i32.load16_u	$push189=, j+14($pop399)
	i32.xor 	$push191=, $pop190, $pop189
	i32.store16	$0=, k+14($pop401), $pop191
	i32.const	$push398=, 0
	i32.const	$push397=, 0
	i32.load16_u	$push193=, i+12($pop397)
	i32.const	$push396=, 0
	i32.load16_u	$push192=, j+12($pop396)
	i32.xor 	$push194=, $pop193, $pop192
	i32.store16	$1=, k+12($pop398), $pop194
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i32.load16_u	$push196=, i+10($pop394)
	i32.const	$push393=, 0
	i32.load16_u	$push195=, j+10($pop393)
	i32.xor 	$push197=, $pop196, $pop195
	i32.store16	$2=, k+10($pop395), $pop197
	i32.const	$push392=, 0
	i32.const	$push391=, 0
	i32.load16_u	$push199=, i+8($pop391)
	i32.const	$push390=, 0
	i32.load16_u	$push198=, j+8($pop390)
	i32.xor 	$push200=, $pop199, $pop198
	i32.store16	$3=, k+8($pop392), $pop200
	i32.const	$push389=, 0
	i32.const	$push388=, 0
	i32.load16_u	$push202=, i+6($pop388)
	i32.const	$push387=, 0
	i32.load16_u	$push201=, j+6($pop387)
	i32.xor 	$push203=, $pop202, $pop201
	i32.store16	$4=, k+6($pop389), $pop203
	i32.const	$push386=, 0
	i32.const	$push385=, 0
	i32.load16_u	$push205=, i+4($pop385)
	i32.const	$push384=, 0
	i32.load16_u	$push204=, j+4($pop384)
	i32.xor 	$push206=, $pop205, $pop204
	i32.store16	$5=, k+4($pop386), $pop206
	i32.const	$push383=, 0
	i32.const	$push382=, 0
	i32.load16_u	$push208=, i+2($pop382)
	i32.const	$push381=, 0
	i32.load16_u	$push207=, j+2($pop381)
	i32.xor 	$push209=, $pop208, $pop207
	i32.store16	$6=, k+2($pop383), $pop209
	i32.const	$push380=, 0
	i32.const	$push379=, 0
	i32.load16_u	$push211=, i($pop379)
	i32.const	$push378=, 0
	i32.load16_u	$push210=, j($pop378)
	i32.xor 	$push212=, $pop211, $pop210
	i32.store16	$7=, k($pop380), $pop212
	i32.const	$push377=, 0
	i32.store16	$drop=, res+14($pop377), $0
	i32.const	$push376=, 0
	i32.store16	$drop=, res+12($pop376), $1
	i32.const	$push375=, 0
	i32.store16	$drop=, res+10($pop375), $2
	i32.const	$push374=, 0
	i32.store16	$drop=, res+8($pop374), $3
	i32.const	$push373=, 0
	i32.store16	$0=, res+6($pop373), $4
	i32.const	$push372=, 0
	i32.store16	$1=, res+4($pop372), $5
	i32.const	$push371=, 0
	i32.store16	$2=, res+2($pop371), $6
	i32.const	$push370=, 0
	i32.store16	$push5=, res($pop370), $7
	i32.const	$push369=, 16
	i32.shl 	$push219=, $pop5, $pop369
	i32.const	$push368=, 16
	i32.shr_s	$push220=, $pop219, $pop368
	i32.const	$push367=, 16
	i32.shl 	$push217=, $2, $pop367
	i32.const	$push366=, 16
	i32.shr_s	$push218=, $pop217, $pop366
	i32.const	$push365=, 16
	i32.shl 	$push215=, $1, $pop365
	i32.const	$push364=, 16
	i32.shr_s	$push216=, $pop215, $pop364
	i32.const	$push363=, 16
	i32.shl 	$push213=, $0, $pop363
	i32.const	$push362=, 16
	i32.shr_s	$push214=, $pop213, $pop362
	i32.const	$push224=, 156
	i32.const	$push223=, 105
	i32.const	$push222=, 130
	i32.const	$push221=, 214
	call    	verify@FUNCTION, $pop220, $pop218, $pop216, $pop214, $pop224, $pop223, $pop222, $pop221
	i32.const	$push361=, 0
	i32.const	$push360=, 0
	i32.const	$push359=, 0
	i32.load16_u	$push225=, i+14($pop359)
	i32.sub 	$push226=, $pop360, $pop225
	i32.store16	$0=, k+14($pop361), $pop226
	i32.const	$push358=, 0
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i32.load16_u	$push227=, i+12($pop356)
	i32.sub 	$push228=, $pop357, $pop227
	i32.store16	$1=, k+12($pop358), $pop228
	i32.const	$push355=, 0
	i32.const	$push354=, 0
	i32.const	$push353=, 0
	i32.load16_u	$push229=, i+10($pop353)
	i32.sub 	$push230=, $pop354, $pop229
	i32.store16	$2=, k+10($pop355), $pop230
	i32.const	$push352=, 0
	i32.const	$push351=, 0
	i32.const	$push350=, 0
	i32.load16_u	$push231=, i+8($pop350)
	i32.sub 	$push232=, $pop351, $pop231
	i32.store16	$3=, k+8($pop352), $pop232
	i32.const	$push349=, 0
	i32.const	$push348=, 0
	i32.const	$push347=, 0
	i32.load16_u	$push233=, i+6($pop347)
	i32.sub 	$push234=, $pop348, $pop233
	i32.store16	$4=, k+6($pop349), $pop234
	i32.const	$push346=, 0
	i32.const	$push345=, 0
	i32.const	$push344=, 0
	i32.load16_u	$push235=, i+4($pop344)
	i32.sub 	$push236=, $pop345, $pop235
	i32.store16	$5=, k+4($pop346), $pop236
	i32.const	$push343=, 0
	i32.const	$push342=, 0
	i32.const	$push341=, 0
	i32.load16_u	$push237=, i+2($pop341)
	i32.sub 	$push238=, $pop342, $pop237
	i32.store16	$6=, k+2($pop343), $pop238
	i32.const	$push340=, 0
	i32.const	$push339=, 0
	i32.const	$push338=, 0
	i32.load16_u	$push239=, i($pop338)
	i32.sub 	$push240=, $pop339, $pop239
	i32.store16	$7=, k($pop340), $pop240
	i32.const	$push337=, 0
	i32.store16	$drop=, res+14($pop337), $0
	i32.const	$push336=, 0
	i32.store16	$drop=, res+12($pop336), $1
	i32.const	$push335=, 0
	i32.store16	$drop=, res+10($pop335), $2
	i32.const	$push334=, 0
	i32.store16	$drop=, res+8($pop334), $3
	i32.const	$push333=, 0
	i32.store16	$0=, res+6($pop333), $4
	i32.const	$push332=, 0
	i32.store16	$1=, res+4($pop332), $5
	i32.const	$push331=, 0
	i32.store16	$2=, res+2($pop331), $6
	i32.const	$push330=, 0
	i32.store16	$push6=, res($pop330), $7
	i32.const	$push329=, 16
	i32.shl 	$push247=, $pop6, $pop329
	i32.const	$push328=, 16
	i32.shr_s	$push248=, $pop247, $pop328
	i32.const	$push327=, 16
	i32.shl 	$push245=, $2, $pop327
	i32.const	$push326=, 16
	i32.shr_s	$push246=, $pop245, $pop326
	i32.const	$push325=, 16
	i32.shl 	$push243=, $1, $pop325
	i32.const	$push324=, 16
	i32.shr_s	$push244=, $pop243, $pop324
	i32.const	$push323=, 16
	i32.shl 	$push241=, $0, $pop323
	i32.const	$push322=, 16
	i32.shr_s	$push242=, $pop241, $pop322
	i32.const	$push251=, -150
	i32.const	$push250=, -100
	i32.const	$push321=, -150
	i32.const	$push249=, -200
	call    	verify@FUNCTION, $pop248, $pop246, $pop244, $pop242, $pop251, $pop250, $pop321, $pop249
	i32.const	$push320=, 0
	i32.const	$push319=, 0
	i32.load16_u	$push252=, i+14($pop319)
	i32.const	$push253=, -1
	i32.xor 	$push254=, $pop252, $pop253
	i32.store16	$0=, k+14($pop320), $pop254
	i32.const	$push318=, 0
	i32.const	$push317=, 0
	i32.load16_u	$push255=, i+12($pop317)
	i32.const	$push316=, -1
	i32.xor 	$push256=, $pop255, $pop316
	i32.store16	$1=, k+12($pop318), $pop256
	i32.const	$push315=, 0
	i32.const	$push314=, 0
	i32.load16_u	$push257=, i+10($pop314)
	i32.const	$push313=, -1
	i32.xor 	$push258=, $pop257, $pop313
	i32.store16	$2=, k+10($pop315), $pop258
	i32.const	$push312=, 0
	i32.const	$push311=, 0
	i32.load16_u	$push259=, i+8($pop311)
	i32.const	$push310=, -1
	i32.xor 	$push260=, $pop259, $pop310
	i32.store16	$3=, k+8($pop312), $pop260
	i32.const	$push309=, 0
	i32.const	$push308=, 0
	i32.load16_u	$push261=, i+6($pop308)
	i32.const	$push307=, -1
	i32.xor 	$push262=, $pop261, $pop307
	i32.store16	$4=, k+6($pop309), $pop262
	i32.const	$push306=, 0
	i32.const	$push305=, 0
	i32.load16_u	$push263=, i+4($pop305)
	i32.const	$push304=, -1
	i32.xor 	$push264=, $pop263, $pop304
	i32.store16	$5=, k+4($pop306), $pop264
	i32.const	$push303=, 0
	i32.const	$push302=, 0
	i32.load16_u	$push265=, i+2($pop302)
	i32.const	$push301=, -1
	i32.xor 	$push266=, $pop265, $pop301
	i32.store16	$6=, k+2($pop303), $pop266
	i32.const	$push300=, 0
	i32.const	$push299=, 0
	i32.load16_u	$push267=, i($pop299)
	i32.const	$push298=, -1
	i32.xor 	$push268=, $pop267, $pop298
	i32.store16	$7=, k($pop300), $pop268
	i32.const	$push297=, 0
	i32.store16	$drop=, res+14($pop297), $0
	i32.const	$push296=, 0
	i32.store16	$drop=, res+12($pop296), $1
	i32.const	$push295=, 0
	i32.store16	$drop=, res+10($pop295), $2
	i32.const	$push294=, 0
	i32.store16	$drop=, res+8($pop294), $3
	i32.const	$push293=, 0
	i32.store16	$0=, res+6($pop293), $4
	i32.const	$push292=, 0
	i32.store16	$1=, res+4($pop292), $5
	i32.const	$push291=, 0
	i32.store16	$2=, res+2($pop291), $6
	i32.const	$push290=, 0
	i32.store16	$push7=, res($pop290), $7
	i32.const	$push289=, 16
	i32.shl 	$push275=, $pop7, $pop289
	i32.const	$push288=, 16
	i32.shr_s	$push276=, $pop275, $pop288
	i32.const	$push287=, 16
	i32.shl 	$push273=, $2, $pop287
	i32.const	$push286=, 16
	i32.shr_s	$push274=, $pop273, $pop286
	i32.const	$push285=, 16
	i32.shl 	$push271=, $1, $pop285
	i32.const	$push284=, 16
	i32.shr_s	$push272=, $pop271, $pop284
	i32.const	$push283=, 16
	i32.shl 	$push269=, $0, $pop283
	i32.const	$push282=, 16
	i32.shr_s	$push270=, $pop269, $pop282
	i32.const	$push279=, -151
	i32.const	$push278=, -101
	i32.const	$push281=, -151
	i32.const	$push277=, -201
	call    	verify@FUNCTION, $pop276, $pop274, $pop272, $pop270, $pop279, $pop278, $pop281, $pop277
	i32.const	$push280=, 0
	call    	exit@FUNCTION, $pop280
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
