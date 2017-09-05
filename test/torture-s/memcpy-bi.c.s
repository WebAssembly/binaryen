	.text
	.file	"memcpy-bi.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.call	$push0=, memcmp@FUNCTION, $0, $1, $2
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push469=, src
	i32.add 	$push8=, $0, $pop469
	i32.const	$push468=, 26
	i32.rem_u	$push9=, $0, $pop468
	i32.const	$push467=, 97
	i32.add 	$push10=, $pop9, $pop467
	i32.store8	0($pop8), $pop10
	i32.const	$push466=, 1
	i32.add 	$push465=, $0, $pop466
	tee_local	$push464=, $0=, $pop465
	i32.const	$push463=, 80
	i32.ne  	$push11=, $pop464, $pop463
	br_if   	0, $pop11       # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop
	i32.const	$push473=, 0
	i32.const	$push472=, 0
	i32.load16_u	$push471=, src($pop472)
	tee_local	$push470=, $0=, $pop471
	i32.store16	dst($pop473), $pop470
	block   	
	i32.ne  	$push12=, $0, $0
	br_if   	0, $pop12       # 0: down to label2
# BB#3:                                 # %check.exit13
	i32.const	$push479=, 0
	i32.const	$push478=, 0
	i32.load8_u	$push13=, src+2($pop478)
	i32.store8	dst+2($pop479), $pop13
	i32.const	$push477=, 0
	i32.const	$push476=, 0
	i32.load16_u	$push14=, src($pop476)
	i32.store16	dst($pop477), $pop14
	i32.const	$push475=, dst
	i32.const	$push474=, src
	i32.const	$push15=, 3
	i32.call	$push16=, memcmp@FUNCTION, $pop475, $pop474, $pop15
	br_if   	0, $pop16       # 0: down to label2
# BB#4:                                 # %check.exit17
	i32.const	$push485=, 0
	i32.const	$push484=, 0
	i32.load8_u	$push17=, src+4($pop484)
	i32.store8	dst+4($pop485), $pop17
	i32.const	$push483=, 0
	i32.const	$push482=, 0
	i32.load	$push18=, src($pop482)
	i32.store	dst($pop483), $pop18
	i32.const	$push481=, dst
	i32.const	$push480=, src
	i32.const	$push19=, 5
	i32.call	$push20=, memcmp@FUNCTION, $pop481, $pop480, $pop19
	br_if   	0, $pop20       # 0: down to label2
# BB#5:                                 # %check.exit25
	i32.const	$push491=, 0
	i32.const	$push490=, 0
	i32.load16_u	$push21=, src+4($pop490)
	i32.store16	dst+4($pop491), $pop21
	i32.const	$push489=, 0
	i32.const	$push488=, 0
	i32.load	$push22=, src($pop488)
	i32.store	dst($pop489), $pop22
	i32.const	$push487=, dst
	i32.const	$push486=, src
	i32.const	$push23=, 6
	i32.call	$push24=, memcmp@FUNCTION, $pop487, $pop486, $pop23
	br_if   	0, $pop24       # 0: down to label2
# BB#6:                                 # %check.exit29
	i32.const	$push499=, 0
	i32.const	$push498=, 0
	i32.load8_u	$push25=, src+6($pop498)
	i32.store8	dst+6($pop499), $pop25
	i32.const	$push497=, 0
	i32.const	$push496=, 0
	i32.load16_u	$push26=, src+4($pop496)
	i32.store16	dst+4($pop497), $pop26
	i32.const	$push495=, 0
	i32.const	$push494=, 0
	i32.load	$push27=, src($pop494)
	i32.store	dst($pop495), $pop27
	i32.const	$push493=, dst
	i32.const	$push492=, src
	i32.const	$push28=, 7
	i32.call	$push29=, memcmp@FUNCTION, $pop493, $pop492, $pop28
	br_if   	0, $pop29       # 0: down to label2
# BB#7:                                 # %check.exit33
	i32.const	$push505=, 0
	i32.const	$push504=, 0
	i32.load8_u	$push30=, src+8($pop504)
	i32.store8	dst+8($pop505), $pop30
	i32.const	$push503=, 0
	i32.const	$push502=, 0
	i64.load	$push31=, src($pop502)
	i64.store	dst($pop503), $pop31
	i32.const	$push501=, dst
	i32.const	$push500=, src
	i32.const	$push32=, 9
	i32.call	$push33=, memcmp@FUNCTION, $pop501, $pop500, $pop32
	br_if   	0, $pop33       # 0: down to label2
# BB#8:                                 # %check.exit41
	i32.const	$push511=, 0
	i32.const	$push510=, 0
	i32.load16_u	$push34=, src+8($pop510)
	i32.store16	dst+8($pop511), $pop34
	i32.const	$push509=, 0
	i32.const	$push508=, 0
	i64.load	$push35=, src($pop508)
	i64.store	dst($pop509), $pop35
	i32.const	$push507=, dst
	i32.const	$push506=, src
	i32.const	$push36=, 10
	i32.call	$push37=, memcmp@FUNCTION, $pop507, $pop506, $pop36
	br_if   	0, $pop37       # 0: down to label2
# BB#9:                                 # %check.exit45
	i32.const	$push519=, 0
	i32.const	$push518=, 0
	i32.load8_u	$push38=, src+10($pop518)
	i32.store8	dst+10($pop519), $pop38
	i32.const	$push517=, 0
	i32.const	$push516=, 0
	i32.load16_u	$push39=, src+8($pop516)
	i32.store16	dst+8($pop517), $pop39
	i32.const	$push515=, 0
	i32.const	$push514=, 0
	i64.load	$push40=, src($pop514)
	i64.store	dst($pop515), $pop40
	i32.const	$push513=, dst
	i32.const	$push512=, src
	i32.const	$push41=, 11
	i32.call	$push42=, memcmp@FUNCTION, $pop513, $pop512, $pop41
	br_if   	0, $pop42       # 0: down to label2
# BB#10:                                # %check.exit49
	i32.const	$push525=, 0
	i32.const	$push524=, 0
	i32.load	$push43=, src+8($pop524)
	i32.store	dst+8($pop525), $pop43
	i32.const	$push523=, 0
	i32.const	$push522=, 0
	i64.load	$push44=, src($pop522)
	i64.store	dst($pop523), $pop44
	i32.const	$push521=, dst
	i32.const	$push520=, src
	i32.const	$push45=, 12
	i32.call	$push46=, memcmp@FUNCTION, $pop521, $pop520, $pop45
	br_if   	0, $pop46       # 0: down to label2
# BB#11:                                # %check.exit53
	i32.const	$push531=, 0
	i32.const	$push530=, 0
	i64.load	$push47=, src+5($pop530):p2align=0
	i64.store	dst+5($pop531):p2align=0, $pop47
	i32.const	$push529=, 0
	i32.const	$push528=, 0
	i64.load	$push48=, src($pop528)
	i64.store	dst($pop529), $pop48
	i32.const	$push527=, dst
	i32.const	$push526=, src
	i32.const	$push49=, 13
	i32.call	$push50=, memcmp@FUNCTION, $pop527, $pop526, $pop49
	br_if   	0, $pop50       # 0: down to label2
# BB#12:                                # %check.exit57
	i32.const	$push537=, 0
	i32.const	$push536=, 0
	i64.load	$push51=, src+6($pop536):p2align=1
	i64.store	dst+6($pop537):p2align=1, $pop51
	i32.const	$push535=, 0
	i32.const	$push534=, 0
	i64.load	$push52=, src($pop534)
	i64.store	dst($pop535), $pop52
	i32.const	$push533=, dst
	i32.const	$push532=, src
	i32.const	$push53=, 14
	i32.call	$push54=, memcmp@FUNCTION, $pop533, $pop532, $pop53
	br_if   	0, $pop54       # 0: down to label2
# BB#13:                                # %check.exit61
	i32.const	$push543=, 0
	i32.const	$push542=, 0
	i64.load	$push55=, src+7($pop542):p2align=0
	i64.store	dst+7($pop543):p2align=0, $pop55
	i32.const	$push541=, 0
	i32.const	$push540=, 0
	i64.load	$push56=, src($pop540)
	i64.store	dst($pop541), $pop56
	i32.const	$push539=, dst
	i32.const	$push538=, src
	i32.const	$push57=, 15
	i32.call	$push58=, memcmp@FUNCTION, $pop539, $pop538, $pop57
	br_if   	0, $pop58       # 0: down to label2
# BB#14:                                # %check.exit65
	i32.const	$push549=, 0
	i32.const	$push548=, 0
	i64.load	$push59=, src+8($pop548)
	i64.store	dst+8($pop549), $pop59
	i32.const	$push547=, 0
	i32.const	$push546=, 0
	i64.load	$push60=, src($pop546)
	i64.store	dst($pop547), $pop60
	i32.const	$push545=, dst
	i32.const	$push544=, src
	i32.const	$push61=, 16
	i32.call	$push62=, memcmp@FUNCTION, $pop545, $pop544, $pop61
	br_if   	0, $pop62       # 0: down to label2
# BB#15:                                # %check.exit69
	i32.const	$push557=, 0
	i32.const	$push556=, 0
	i32.load8_u	$push63=, src+16($pop556)
	i32.store8	dst+16($pop557), $pop63
	i32.const	$push555=, 0
	i32.const	$push554=, 0
	i64.load	$push64=, src+8($pop554)
	i64.store	dst+8($pop555), $pop64
	i32.const	$push553=, 0
	i32.const	$push552=, 0
	i64.load	$push65=, src($pop552)
	i64.store	dst($pop553), $pop65
	i32.const	$push551=, dst
	i32.const	$push550=, src
	i32.const	$push66=, 17
	i32.call	$push67=, memcmp@FUNCTION, $pop551, $pop550, $pop66
	br_if   	0, $pop67       # 0: down to label2
# BB#16:                                # %check.exit73
	i32.const	$push565=, 0
	i32.const	$push564=, 0
	i32.load16_u	$push68=, src+16($pop564)
	i32.store16	dst+16($pop565), $pop68
	i32.const	$push563=, 0
	i32.const	$push562=, 0
	i64.load	$push69=, src+8($pop562)
	i64.store	dst+8($pop563), $pop69
	i32.const	$push561=, 0
	i32.const	$push560=, 0
	i64.load	$push70=, src($pop560)
	i64.store	dst($pop561), $pop70
	i32.const	$push559=, dst
	i32.const	$push558=, src
	i32.const	$push71=, 18
	i32.call	$push72=, memcmp@FUNCTION, $pop559, $pop558, $pop71
	br_if   	0, $pop72       # 0: down to label2
# BB#17:                                # %check.exit77
	i32.const	$push575=, 0
	i32.const	$push574=, 0
	i32.load8_u	$push73=, src+18($pop574)
	i32.store8	dst+18($pop575), $pop73
	i32.const	$push573=, 0
	i32.const	$push572=, 0
	i32.load16_u	$push74=, src+16($pop572)
	i32.store16	dst+16($pop573), $pop74
	i32.const	$push571=, 0
	i32.const	$push570=, 0
	i64.load	$push75=, src+8($pop570)
	i64.store	dst+8($pop571), $pop75
	i32.const	$push569=, 0
	i32.const	$push568=, 0
	i64.load	$push76=, src($pop568)
	i64.store	dst($pop569), $pop76
	i32.const	$push567=, dst
	i32.const	$push566=, src
	i32.const	$push77=, 19
	i32.call	$push78=, memcmp@FUNCTION, $pop567, $pop566, $pop77
	br_if   	0, $pop78       # 0: down to label2
# BB#18:                                # %check.exit81
	i32.const	$push583=, 0
	i32.const	$push582=, 0
	i32.load	$push79=, src+16($pop582)
	i32.store	dst+16($pop583), $pop79
	i32.const	$push581=, 0
	i32.const	$push580=, 0
	i64.load	$push80=, src+8($pop580)
	i64.store	dst+8($pop581), $pop80
	i32.const	$push579=, 0
	i32.const	$push578=, 0
	i64.load	$push81=, src($pop578)
	i64.store	dst($pop579), $pop81
	i32.const	$push577=, dst
	i32.const	$push576=, src
	i32.const	$push82=, 20
	i32.call	$push83=, memcmp@FUNCTION, $pop577, $pop576, $pop82
	br_if   	0, $pop83       # 0: down to label2
# BB#19:                                # %check.exit85
	i32.const	$push591=, 0
	i32.const	$push590=, 0
	i64.load	$push84=, src+13($pop590):p2align=0
	i64.store	dst+13($pop591):p2align=0, $pop84
	i32.const	$push589=, 0
	i32.const	$push588=, 0
	i64.load	$push85=, src+8($pop588)
	i64.store	dst+8($pop589), $pop85
	i32.const	$push587=, 0
	i32.const	$push586=, 0
	i64.load	$push86=, src($pop586)
	i64.store	dst($pop587), $pop86
	i32.const	$push585=, dst
	i32.const	$push584=, src
	i32.const	$push87=, 21
	i32.call	$push88=, memcmp@FUNCTION, $pop585, $pop584, $pop87
	br_if   	0, $pop88       # 0: down to label2
# BB#20:                                # %check.exit89
	i32.const	$push599=, 0
	i32.const	$push598=, 0
	i64.load	$push89=, src+14($pop598):p2align=1
	i64.store	dst+14($pop599):p2align=1, $pop89
	i32.const	$push597=, 0
	i32.const	$push596=, 0
	i64.load	$push90=, src+8($pop596)
	i64.store	dst+8($pop597), $pop90
	i32.const	$push595=, 0
	i32.const	$push594=, 0
	i64.load	$push91=, src($pop594)
	i64.store	dst($pop595), $pop91
	i32.const	$push593=, dst
	i32.const	$push592=, src
	i32.const	$push92=, 22
	i32.call	$push93=, memcmp@FUNCTION, $pop593, $pop592, $pop92
	br_if   	0, $pop93       # 0: down to label2
# BB#21:                                # %check.exit93
	i32.const	$push607=, 0
	i32.const	$push606=, 0
	i64.load	$push94=, src+15($pop606):p2align=0
	i64.store	dst+15($pop607):p2align=0, $pop94
	i32.const	$push605=, 0
	i32.const	$push604=, 0
	i64.load	$push95=, src+8($pop604)
	i64.store	dst+8($pop605), $pop95
	i32.const	$push603=, 0
	i32.const	$push602=, 0
	i64.load	$push96=, src($pop602)
	i64.store	dst($pop603), $pop96
	i32.const	$push601=, dst
	i32.const	$push600=, src
	i32.const	$push97=, 23
	i32.call	$push98=, memcmp@FUNCTION, $pop601, $pop600, $pop97
	br_if   	0, $pop98       # 0: down to label2
# BB#22:                                # %check.exit97
	i32.const	$push615=, 0
	i32.const	$push614=, 0
	i64.load	$push99=, src+16($pop614)
	i64.store	dst+16($pop615), $pop99
	i32.const	$push613=, 0
	i32.const	$push612=, 0
	i64.load	$push100=, src+8($pop612)
	i64.store	dst+8($pop613), $pop100
	i32.const	$push611=, 0
	i32.const	$push610=, 0
	i64.load	$push101=, src($pop610)
	i64.store	dst($pop611), $pop101
	i32.const	$push609=, dst
	i32.const	$push608=, src
	i32.const	$push102=, 24
	i32.call	$push103=, memcmp@FUNCTION, $pop609, $pop608, $pop102
	br_if   	0, $pop103      # 0: down to label2
# BB#23:                                # %check.exit101
	i32.const	$push625=, 0
	i32.const	$push624=, 0
	i32.load8_u	$push104=, src+24($pop624)
	i32.store8	dst+24($pop625), $pop104
	i32.const	$push623=, 0
	i32.const	$push622=, 0
	i64.load	$push105=, src+16($pop622)
	i64.store	dst+16($pop623), $pop105
	i32.const	$push621=, 0
	i32.const	$push620=, 0
	i64.load	$push106=, src+8($pop620)
	i64.store	dst+8($pop621), $pop106
	i32.const	$push619=, 0
	i32.const	$push618=, 0
	i64.load	$push107=, src($pop618)
	i64.store	dst($pop619), $pop107
	i32.const	$push617=, dst
	i32.const	$push616=, src
	i32.const	$push108=, 25
	i32.call	$push109=, memcmp@FUNCTION, $pop617, $pop616, $pop108
	br_if   	0, $pop109      # 0: down to label2
# BB#24:                                # %check.exit105
	i32.const	$push635=, 0
	i32.const	$push634=, 0
	i32.load16_u	$push110=, src+24($pop634)
	i32.store16	dst+24($pop635), $pop110
	i32.const	$push633=, 0
	i32.const	$push632=, 0
	i64.load	$push111=, src+16($pop632)
	i64.store	dst+16($pop633), $pop111
	i32.const	$push631=, 0
	i32.const	$push630=, 0
	i64.load	$push112=, src+8($pop630)
	i64.store	dst+8($pop631), $pop112
	i32.const	$push629=, 0
	i32.const	$push628=, 0
	i64.load	$push113=, src($pop628)
	i64.store	dst($pop629), $pop113
	i32.const	$push627=, dst
	i32.const	$push626=, src
	i32.const	$push114=, 26
	i32.call	$push115=, memcmp@FUNCTION, $pop627, $pop626, $pop114
	br_if   	0, $pop115      # 0: down to label2
# BB#25:                                # %check.exit109
	i32.const	$push647=, 0
	i32.const	$push646=, 0
	i32.load8_u	$push116=, src+26($pop646)
	i32.store8	dst+26($pop647), $pop116
	i32.const	$push645=, 0
	i32.const	$push644=, 0
	i32.load16_u	$push117=, src+24($pop644)
	i32.store16	dst+24($pop645), $pop117
	i32.const	$push643=, 0
	i32.const	$push642=, 0
	i64.load	$push118=, src+16($pop642)
	i64.store	dst+16($pop643), $pop118
	i32.const	$push641=, 0
	i32.const	$push640=, 0
	i64.load	$push119=, src+8($pop640)
	i64.store	dst+8($pop641), $pop119
	i32.const	$push639=, 0
	i32.const	$push638=, 0
	i64.load	$push120=, src($pop638)
	i64.store	dst($pop639), $pop120
	i32.const	$push637=, dst
	i32.const	$push636=, src
	i32.const	$push121=, 27
	i32.call	$push122=, memcmp@FUNCTION, $pop637, $pop636, $pop121
	br_if   	0, $pop122      # 0: down to label2
# BB#26:                                # %check.exit113
	i32.const	$push657=, 0
	i32.const	$push656=, 0
	i32.load	$push123=, src+24($pop656)
	i32.store	dst+24($pop657), $pop123
	i32.const	$push655=, 0
	i32.const	$push654=, 0
	i64.load	$push124=, src+16($pop654)
	i64.store	dst+16($pop655), $pop124
	i32.const	$push653=, 0
	i32.const	$push652=, 0
	i64.load	$push125=, src+8($pop652)
	i64.store	dst+8($pop653), $pop125
	i32.const	$push651=, 0
	i32.const	$push650=, 0
	i64.load	$push126=, src($pop650)
	i64.store	dst($pop651), $pop126
	i32.const	$push649=, dst
	i32.const	$push648=, src
	i32.const	$push127=, 28
	i32.call	$push128=, memcmp@FUNCTION, $pop649, $pop648, $pop127
	br_if   	0, $pop128      # 0: down to label2
# BB#27:                                # %check.exit117
	i32.const	$push667=, 0
	i32.const	$push666=, 0
	i64.load	$push129=, src+21($pop666):p2align=0
	i64.store	dst+21($pop667):p2align=0, $pop129
	i32.const	$push665=, 0
	i32.const	$push664=, 0
	i64.load	$push130=, src+16($pop664)
	i64.store	dst+16($pop665), $pop130
	i32.const	$push663=, 0
	i32.const	$push662=, 0
	i64.load	$push131=, src+8($pop662)
	i64.store	dst+8($pop663), $pop131
	i32.const	$push661=, 0
	i32.const	$push660=, 0
	i64.load	$push132=, src($pop660)
	i64.store	dst($pop661), $pop132
	i32.const	$push659=, dst
	i32.const	$push658=, src
	i32.const	$push133=, 29
	i32.call	$push134=, memcmp@FUNCTION, $pop659, $pop658, $pop133
	br_if   	0, $pop134      # 0: down to label2
# BB#28:                                # %check.exit121
	i32.const	$push677=, 0
	i32.const	$push676=, 0
	i64.load	$push135=, src+22($pop676):p2align=1
	i64.store	dst+22($pop677):p2align=1, $pop135
	i32.const	$push675=, 0
	i32.const	$push674=, 0
	i64.load	$push136=, src+16($pop674)
	i64.store	dst+16($pop675), $pop136
	i32.const	$push673=, 0
	i32.const	$push672=, 0
	i64.load	$push137=, src+8($pop672)
	i64.store	dst+8($pop673), $pop137
	i32.const	$push671=, 0
	i32.const	$push670=, 0
	i64.load	$push138=, src($pop670)
	i64.store	dst($pop671), $pop138
	i32.const	$push669=, dst
	i32.const	$push668=, src
	i32.const	$push139=, 30
	i32.call	$push140=, memcmp@FUNCTION, $pop669, $pop668, $pop139
	br_if   	0, $pop140      # 0: down to label2
# BB#29:                                # %check.exit125
	i32.const	$push687=, 0
	i32.const	$push686=, 0
	i64.load	$push141=, src+23($pop686):p2align=0
	i64.store	dst+23($pop687):p2align=0, $pop141
	i32.const	$push685=, 0
	i32.const	$push684=, 0
	i64.load	$push142=, src+16($pop684)
	i64.store	dst+16($pop685), $pop142
	i32.const	$push683=, 0
	i32.const	$push682=, 0
	i64.load	$push143=, src+8($pop682)
	i64.store	dst+8($pop683), $pop143
	i32.const	$push681=, 0
	i32.const	$push680=, 0
	i64.load	$push144=, src($pop680)
	i64.store	dst($pop681), $pop144
	i32.const	$push679=, dst
	i32.const	$push678=, src
	i32.const	$push145=, 31
	i32.call	$push146=, memcmp@FUNCTION, $pop679, $pop678, $pop145
	br_if   	0, $pop146      # 0: down to label2
# BB#30:                                # %check.exit129
	i32.const	$push697=, 0
	i32.const	$push696=, 0
	i64.load	$push147=, src+24($pop696)
	i64.store	dst+24($pop697), $pop147
	i32.const	$push695=, 0
	i32.const	$push694=, 0
	i64.load	$push148=, src+16($pop694)
	i64.store	dst+16($pop695), $pop148
	i32.const	$push693=, 0
	i32.const	$push692=, 0
	i64.load	$push149=, src+8($pop692)
	i64.store	dst+8($pop693), $pop149
	i32.const	$push691=, 0
	i32.const	$push690=, 0
	i64.load	$push150=, src($pop690)
	i64.store	dst($pop691), $pop150
	i32.const	$push689=, dst
	i32.const	$push688=, src
	i32.const	$push151=, 32
	i32.call	$push152=, memcmp@FUNCTION, $pop689, $pop688, $pop151
	br_if   	0, $pop152      # 0: down to label2
# BB#31:                                # %check.exit133
	i32.const	$push709=, 0
	i32.const	$push708=, 0
	i32.load8_u	$push153=, src+32($pop708)
	i32.store8	dst+32($pop709), $pop153
	i32.const	$push707=, 0
	i32.const	$push706=, 0
	i64.load	$push154=, src+24($pop706)
	i64.store	dst+24($pop707), $pop154
	i32.const	$push705=, 0
	i32.const	$push704=, 0
	i64.load	$push155=, src+16($pop704)
	i64.store	dst+16($pop705), $pop155
	i32.const	$push703=, 0
	i32.const	$push702=, 0
	i64.load	$push156=, src+8($pop702)
	i64.store	dst+8($pop703), $pop156
	i32.const	$push701=, 0
	i32.const	$push700=, 0
	i64.load	$push157=, src($pop700)
	i64.store	dst($pop701), $pop157
	i32.const	$push699=, dst
	i32.const	$push698=, src
	i32.const	$push158=, 33
	i32.call	$push159=, memcmp@FUNCTION, $pop699, $pop698, $pop158
	br_if   	0, $pop159      # 0: down to label2
# BB#32:                                # %check.exit137
	i32.const	$push721=, 0
	i32.const	$push720=, 0
	i32.load16_u	$push160=, src+32($pop720)
	i32.store16	dst+32($pop721), $pop160
	i32.const	$push719=, 0
	i32.const	$push718=, 0
	i64.load	$push161=, src+24($pop718)
	i64.store	dst+24($pop719), $pop161
	i32.const	$push717=, 0
	i32.const	$push716=, 0
	i64.load	$push162=, src+16($pop716)
	i64.store	dst+16($pop717), $pop162
	i32.const	$push715=, 0
	i32.const	$push714=, 0
	i64.load	$push163=, src+8($pop714)
	i64.store	dst+8($pop715), $pop163
	i32.const	$push713=, 0
	i32.const	$push712=, 0
	i64.load	$push164=, src($pop712)
	i64.store	dst($pop713), $pop164
	i32.const	$push711=, dst
	i32.const	$push710=, src
	i32.const	$push165=, 34
	i32.call	$push166=, memcmp@FUNCTION, $pop711, $pop710, $pop165
	br_if   	0, $pop166      # 0: down to label2
# BB#33:                                # %check.exit141
	i32.const	$push735=, 0
	i32.const	$push734=, 0
	i32.load8_u	$push167=, src+34($pop734)
	i32.store8	dst+34($pop735), $pop167
	i32.const	$push733=, 0
	i32.const	$push732=, 0
	i32.load16_u	$push168=, src+32($pop732)
	i32.store16	dst+32($pop733), $pop168
	i32.const	$push731=, 0
	i32.const	$push730=, 0
	i64.load	$push169=, src+24($pop730)
	i64.store	dst+24($pop731), $pop169
	i32.const	$push729=, 0
	i32.const	$push728=, 0
	i64.load	$push170=, src+16($pop728)
	i64.store	dst+16($pop729), $pop170
	i32.const	$push727=, 0
	i32.const	$push726=, 0
	i64.load	$push171=, src+8($pop726)
	i64.store	dst+8($pop727), $pop171
	i32.const	$push725=, 0
	i32.const	$push724=, 0
	i64.load	$push172=, src($pop724)
	i64.store	dst($pop725), $pop172
	i32.const	$push723=, dst
	i32.const	$push722=, src
	i32.const	$push173=, 35
	i32.call	$push174=, memcmp@FUNCTION, $pop723, $pop722, $pop173
	br_if   	0, $pop174      # 0: down to label2
# BB#34:                                # %check.exit145
	i32.const	$push747=, 0
	i32.const	$push746=, 0
	i32.load	$push175=, src+32($pop746)
	i32.store	dst+32($pop747), $pop175
	i32.const	$push745=, 0
	i32.const	$push744=, 0
	i64.load	$push176=, src+24($pop744)
	i64.store	dst+24($pop745), $pop176
	i32.const	$push743=, 0
	i32.const	$push742=, 0
	i64.load	$push177=, src+16($pop742)
	i64.store	dst+16($pop743), $pop177
	i32.const	$push741=, 0
	i32.const	$push740=, 0
	i64.load	$push178=, src+8($pop740)
	i64.store	dst+8($pop741), $pop178
	i32.const	$push739=, 0
	i32.const	$push738=, 0
	i64.load	$push179=, src($pop738)
	i64.store	dst($pop739), $pop179
	i32.const	$push737=, dst
	i32.const	$push736=, src
	i32.const	$push180=, 36
	i32.call	$push181=, memcmp@FUNCTION, $pop737, $pop736, $pop180
	br_if   	0, $pop181      # 0: down to label2
# BB#35:                                # %check.exit149
	i32.const	$push759=, 0
	i32.const	$push758=, 0
	i64.load	$push182=, src+29($pop758):p2align=0
	i64.store	dst+29($pop759):p2align=0, $pop182
	i32.const	$push757=, 0
	i32.const	$push756=, 0
	i64.load	$push183=, src+24($pop756)
	i64.store	dst+24($pop757), $pop183
	i32.const	$push755=, 0
	i32.const	$push754=, 0
	i64.load	$push184=, src+16($pop754)
	i64.store	dst+16($pop755), $pop184
	i32.const	$push753=, 0
	i32.const	$push752=, 0
	i64.load	$push185=, src+8($pop752)
	i64.store	dst+8($pop753), $pop185
	i32.const	$push751=, 0
	i32.const	$push750=, 0
	i64.load	$push186=, src($pop750)
	i64.store	dst($pop751), $pop186
	i32.const	$push749=, dst
	i32.const	$push748=, src
	i32.const	$push187=, 37
	i32.call	$push188=, memcmp@FUNCTION, $pop749, $pop748, $pop187
	br_if   	0, $pop188      # 0: down to label2
# BB#36:                                # %check.exit153
	i32.const	$push771=, 0
	i32.const	$push770=, 0
	i64.load	$push189=, src+30($pop770):p2align=1
	i64.store	dst+30($pop771):p2align=1, $pop189
	i32.const	$push769=, 0
	i32.const	$push768=, 0
	i64.load	$push190=, src+24($pop768)
	i64.store	dst+24($pop769), $pop190
	i32.const	$push767=, 0
	i32.const	$push766=, 0
	i64.load	$push191=, src+16($pop766)
	i64.store	dst+16($pop767), $pop191
	i32.const	$push765=, 0
	i32.const	$push764=, 0
	i64.load	$push192=, src+8($pop764)
	i64.store	dst+8($pop765), $pop192
	i32.const	$push763=, 0
	i32.const	$push762=, 0
	i64.load	$push193=, src($pop762)
	i64.store	dst($pop763), $pop193
	i32.const	$push761=, dst
	i32.const	$push760=, src
	i32.const	$push194=, 38
	i32.call	$push195=, memcmp@FUNCTION, $pop761, $pop760, $pop194
	br_if   	0, $pop195      # 0: down to label2
# BB#37:                                # %check.exit157
	i32.const	$push783=, 0
	i32.const	$push782=, 0
	i64.load	$push196=, src+31($pop782):p2align=0
	i64.store	dst+31($pop783):p2align=0, $pop196
	i32.const	$push781=, 0
	i32.const	$push780=, 0
	i64.load	$push197=, src+24($pop780)
	i64.store	dst+24($pop781), $pop197
	i32.const	$push779=, 0
	i32.const	$push778=, 0
	i64.load	$push198=, src+16($pop778)
	i64.store	dst+16($pop779), $pop198
	i32.const	$push777=, 0
	i32.const	$push776=, 0
	i64.load	$push199=, src+8($pop776)
	i64.store	dst+8($pop777), $pop199
	i32.const	$push775=, 0
	i32.const	$push774=, 0
	i64.load	$push200=, src($pop774)
	i64.store	dst($pop775), $pop200
	i32.const	$push773=, dst
	i32.const	$push772=, src
	i32.const	$push201=, 39
	i32.call	$push202=, memcmp@FUNCTION, $pop773, $pop772, $pop201
	br_if   	0, $pop202      # 0: down to label2
# BB#38:                                # %check.exit161
	i32.const	$push795=, 0
	i32.const	$push794=, 0
	i64.load	$push203=, src+32($pop794)
	i64.store	dst+32($pop795), $pop203
	i32.const	$push793=, 0
	i32.const	$push792=, 0
	i64.load	$push204=, src+24($pop792)
	i64.store	dst+24($pop793), $pop204
	i32.const	$push791=, 0
	i32.const	$push790=, 0
	i64.load	$push205=, src+16($pop790)
	i64.store	dst+16($pop791), $pop205
	i32.const	$push789=, 0
	i32.const	$push788=, 0
	i64.load	$push206=, src+8($pop788)
	i64.store	dst+8($pop789), $pop206
	i32.const	$push787=, 0
	i32.const	$push786=, 0
	i64.load	$push207=, src($pop786)
	i64.store	dst($pop787), $pop207
	i32.const	$push785=, dst
	i32.const	$push784=, src
	i32.const	$push208=, 40
	i32.call	$push209=, memcmp@FUNCTION, $pop785, $pop784, $pop208
	br_if   	0, $pop209      # 0: down to label2
# BB#39:                                # %check.exit165
	i32.const	$push809=, 0
	i32.const	$push808=, 0
	i32.load8_u	$push210=, src+40($pop808)
	i32.store8	dst+40($pop809), $pop210
	i32.const	$push807=, 0
	i32.const	$push806=, 0
	i64.load	$push211=, src+32($pop806)
	i64.store	dst+32($pop807), $pop211
	i32.const	$push805=, 0
	i32.const	$push804=, 0
	i64.load	$push212=, src+24($pop804)
	i64.store	dst+24($pop805), $pop212
	i32.const	$push803=, 0
	i32.const	$push802=, 0
	i64.load	$push213=, src+16($pop802)
	i64.store	dst+16($pop803), $pop213
	i32.const	$push801=, 0
	i32.const	$push800=, 0
	i64.load	$push214=, src+8($pop800)
	i64.store	dst+8($pop801), $pop214
	i32.const	$push799=, 0
	i32.const	$push798=, 0
	i64.load	$push215=, src($pop798)
	i64.store	dst($pop799), $pop215
	i32.const	$push797=, dst
	i32.const	$push796=, src
	i32.const	$push216=, 41
	i32.call	$push217=, memcmp@FUNCTION, $pop797, $pop796, $pop216
	br_if   	0, $pop217      # 0: down to label2
# BB#40:                                # %check.exit169
	i32.const	$push823=, 0
	i32.const	$push822=, 0
	i32.load16_u	$push218=, src+40($pop822)
	i32.store16	dst+40($pop823), $pop218
	i32.const	$push821=, 0
	i32.const	$push820=, 0
	i64.load	$push219=, src+32($pop820)
	i64.store	dst+32($pop821), $pop219
	i32.const	$push819=, 0
	i32.const	$push818=, 0
	i64.load	$push220=, src+24($pop818)
	i64.store	dst+24($pop819), $pop220
	i32.const	$push817=, 0
	i32.const	$push816=, 0
	i64.load	$push221=, src+16($pop816)
	i64.store	dst+16($pop817), $pop221
	i32.const	$push815=, 0
	i32.const	$push814=, 0
	i64.load	$push222=, src+8($pop814)
	i64.store	dst+8($pop815), $pop222
	i32.const	$push813=, 0
	i32.const	$push812=, 0
	i64.load	$push223=, src($pop812)
	i64.store	dst($pop813), $pop223
	i32.const	$push811=, dst
	i32.const	$push810=, src
	i32.const	$push224=, 42
	i32.call	$push225=, memcmp@FUNCTION, $pop811, $pop810, $pop224
	br_if   	0, $pop225      # 0: down to label2
# BB#41:                                # %check.exit173
	i32.const	$push839=, 0
	i32.const	$push838=, 0
	i32.load8_u	$push226=, src+42($pop838)
	i32.store8	dst+42($pop839), $pop226
	i32.const	$push837=, 0
	i32.const	$push836=, 0
	i32.load16_u	$push227=, src+40($pop836)
	i32.store16	dst+40($pop837), $pop227
	i32.const	$push835=, 0
	i32.const	$push834=, 0
	i64.load	$push228=, src+32($pop834)
	i64.store	dst+32($pop835), $pop228
	i32.const	$push833=, 0
	i32.const	$push832=, 0
	i64.load	$push229=, src+24($pop832)
	i64.store	dst+24($pop833), $pop229
	i32.const	$push831=, 0
	i32.const	$push830=, 0
	i64.load	$push230=, src+16($pop830)
	i64.store	dst+16($pop831), $pop230
	i32.const	$push829=, 0
	i32.const	$push828=, 0
	i64.load	$push231=, src+8($pop828)
	i64.store	dst+8($pop829), $pop231
	i32.const	$push827=, 0
	i32.const	$push826=, 0
	i64.load	$push232=, src($pop826)
	i64.store	dst($pop827), $pop232
	i32.const	$push825=, dst
	i32.const	$push824=, src
	i32.const	$push233=, 43
	i32.call	$push234=, memcmp@FUNCTION, $pop825, $pop824, $pop233
	br_if   	0, $pop234      # 0: down to label2
# BB#42:                                # %check.exit177
	i32.const	$push853=, 0
	i32.const	$push852=, 0
	i32.load	$push235=, src+40($pop852)
	i32.store	dst+40($pop853), $pop235
	i32.const	$push851=, 0
	i32.const	$push850=, 0
	i64.load	$push236=, src+32($pop850)
	i64.store	dst+32($pop851), $pop236
	i32.const	$push849=, 0
	i32.const	$push848=, 0
	i64.load	$push237=, src+24($pop848)
	i64.store	dst+24($pop849), $pop237
	i32.const	$push847=, 0
	i32.const	$push846=, 0
	i64.load	$push238=, src+16($pop846)
	i64.store	dst+16($pop847), $pop238
	i32.const	$push845=, 0
	i32.const	$push844=, 0
	i64.load	$push239=, src+8($pop844)
	i64.store	dst+8($pop845), $pop239
	i32.const	$push843=, 0
	i32.const	$push842=, 0
	i64.load	$push240=, src($pop842)
	i64.store	dst($pop843), $pop240
	i32.const	$push841=, dst
	i32.const	$push840=, src
	i32.const	$push241=, 44
	i32.call	$push242=, memcmp@FUNCTION, $pop841, $pop840, $pop241
	br_if   	0, $pop242      # 0: down to label2
# BB#43:                                # %check.exit181
	i32.const	$push867=, 0
	i32.const	$push866=, 0
	i64.load	$push243=, src+37($pop866):p2align=0
	i64.store	dst+37($pop867):p2align=0, $pop243
	i32.const	$push865=, 0
	i32.const	$push864=, 0
	i64.load	$push244=, src+32($pop864)
	i64.store	dst+32($pop865), $pop244
	i32.const	$push863=, 0
	i32.const	$push862=, 0
	i64.load	$push245=, src+24($pop862)
	i64.store	dst+24($pop863), $pop245
	i32.const	$push861=, 0
	i32.const	$push860=, 0
	i64.load	$push246=, src+16($pop860)
	i64.store	dst+16($pop861), $pop246
	i32.const	$push859=, 0
	i32.const	$push858=, 0
	i64.load	$push247=, src+8($pop858)
	i64.store	dst+8($pop859), $pop247
	i32.const	$push857=, 0
	i32.const	$push856=, 0
	i64.load	$push248=, src($pop856)
	i64.store	dst($pop857), $pop248
	i32.const	$push855=, dst
	i32.const	$push854=, src
	i32.const	$push249=, 45
	i32.call	$push250=, memcmp@FUNCTION, $pop855, $pop854, $pop249
	br_if   	0, $pop250      # 0: down to label2
# BB#44:                                # %check.exit185
	i32.const	$push881=, 0
	i32.const	$push880=, 0
	i64.load	$push251=, src+38($pop880):p2align=1
	i64.store	dst+38($pop881):p2align=1, $pop251
	i32.const	$push879=, 0
	i32.const	$push878=, 0
	i64.load	$push252=, src+32($pop878)
	i64.store	dst+32($pop879), $pop252
	i32.const	$push877=, 0
	i32.const	$push876=, 0
	i64.load	$push253=, src+24($pop876)
	i64.store	dst+24($pop877), $pop253
	i32.const	$push875=, 0
	i32.const	$push874=, 0
	i64.load	$push254=, src+16($pop874)
	i64.store	dst+16($pop875), $pop254
	i32.const	$push873=, 0
	i32.const	$push872=, 0
	i64.load	$push255=, src+8($pop872)
	i64.store	dst+8($pop873), $pop255
	i32.const	$push871=, 0
	i32.const	$push870=, 0
	i64.load	$push256=, src($pop870)
	i64.store	dst($pop871), $pop256
	i32.const	$push869=, dst
	i32.const	$push868=, src
	i32.const	$push257=, 46
	i32.call	$push258=, memcmp@FUNCTION, $pop869, $pop868, $pop257
	br_if   	0, $pop258      # 0: down to label2
# BB#45:                                # %check.exit189
	i32.const	$push895=, 0
	i32.const	$push894=, 0
	i64.load	$push259=, src+39($pop894):p2align=0
	i64.store	dst+39($pop895):p2align=0, $pop259
	i32.const	$push893=, 0
	i32.const	$push892=, 0
	i64.load	$push260=, src+32($pop892)
	i64.store	dst+32($pop893), $pop260
	i32.const	$push891=, 0
	i32.const	$push890=, 0
	i64.load	$push261=, src+24($pop890)
	i64.store	dst+24($pop891), $pop261
	i32.const	$push889=, 0
	i32.const	$push888=, 0
	i64.load	$push262=, src+16($pop888)
	i64.store	dst+16($pop889), $pop262
	i32.const	$push887=, 0
	i32.const	$push886=, 0
	i64.load	$push263=, src+8($pop886)
	i64.store	dst+8($pop887), $pop263
	i32.const	$push885=, 0
	i32.const	$push884=, 0
	i64.load	$push264=, src($pop884)
	i64.store	dst($pop885), $pop264
	i32.const	$push883=, dst
	i32.const	$push882=, src
	i32.const	$push265=, 47
	i32.call	$push266=, memcmp@FUNCTION, $pop883, $pop882, $pop265
	br_if   	0, $pop266      # 0: down to label2
# BB#46:                                # %check.exit193
	i32.const	$push909=, 0
	i32.const	$push908=, 0
	i64.load	$push267=, src+40($pop908)
	i64.store	dst+40($pop909), $pop267
	i32.const	$push907=, 0
	i32.const	$push906=, 0
	i64.load	$push268=, src+32($pop906)
	i64.store	dst+32($pop907), $pop268
	i32.const	$push905=, 0
	i32.const	$push904=, 0
	i64.load	$push269=, src+24($pop904)
	i64.store	dst+24($pop905), $pop269
	i32.const	$push903=, 0
	i32.const	$push902=, 0
	i64.load	$push270=, src+16($pop902)
	i64.store	dst+16($pop903), $pop270
	i32.const	$push901=, 0
	i32.const	$push900=, 0
	i64.load	$push271=, src+8($pop900)
	i64.store	dst+8($pop901), $pop271
	i32.const	$push899=, 0
	i32.const	$push898=, 0
	i64.load	$push272=, src($pop898)
	i64.store	dst($pop899), $pop272
	i32.const	$push897=, dst
	i32.const	$push896=, src
	i32.const	$push273=, 48
	i32.call	$push274=, memcmp@FUNCTION, $pop897, $pop896, $pop273
	br_if   	0, $pop274      # 0: down to label2
# BB#47:                                # %check.exit197
	i32.const	$push925=, 0
	i32.const	$push924=, 0
	i32.load8_u	$push275=, src+48($pop924)
	i32.store8	dst+48($pop925), $pop275
	i32.const	$push923=, 0
	i32.const	$push922=, 0
	i64.load	$push276=, src+40($pop922)
	i64.store	dst+40($pop923), $pop276
	i32.const	$push921=, 0
	i32.const	$push920=, 0
	i64.load	$push277=, src+32($pop920)
	i64.store	dst+32($pop921), $pop277
	i32.const	$push919=, 0
	i32.const	$push918=, 0
	i64.load	$push278=, src+24($pop918)
	i64.store	dst+24($pop919), $pop278
	i32.const	$push917=, 0
	i32.const	$push916=, 0
	i64.load	$push279=, src+16($pop916)
	i64.store	dst+16($pop917), $pop279
	i32.const	$push915=, 0
	i32.const	$push914=, 0
	i64.load	$push280=, src+8($pop914)
	i64.store	dst+8($pop915), $pop280
	i32.const	$push913=, 0
	i32.const	$push912=, 0
	i64.load	$push281=, src($pop912)
	i64.store	dst($pop913), $pop281
	i32.const	$push911=, dst
	i32.const	$push910=, src
	i32.const	$push282=, 49
	i32.call	$push283=, memcmp@FUNCTION, $pop911, $pop910, $pop282
	br_if   	0, $pop283      # 0: down to label2
# BB#48:                                # %check.exit201
	i32.const	$push941=, 0
	i32.const	$push940=, 0
	i32.load16_u	$push284=, src+48($pop940)
	i32.store16	dst+48($pop941), $pop284
	i32.const	$push939=, 0
	i32.const	$push938=, 0
	i64.load	$push285=, src+40($pop938)
	i64.store	dst+40($pop939), $pop285
	i32.const	$push937=, 0
	i32.const	$push936=, 0
	i64.load	$push286=, src+32($pop936)
	i64.store	dst+32($pop937), $pop286
	i32.const	$push935=, 0
	i32.const	$push934=, 0
	i64.load	$push287=, src+24($pop934)
	i64.store	dst+24($pop935), $pop287
	i32.const	$push933=, 0
	i32.const	$push932=, 0
	i64.load	$push288=, src+16($pop932)
	i64.store	dst+16($pop933), $pop288
	i32.const	$push931=, 0
	i32.const	$push930=, 0
	i64.load	$push289=, src+8($pop930)
	i64.store	dst+8($pop931), $pop289
	i32.const	$push929=, 0
	i32.const	$push928=, 0
	i64.load	$push290=, src($pop928)
	i64.store	dst($pop929), $pop290
	i32.const	$push927=, dst
	i32.const	$push926=, src
	i32.const	$push291=, 50
	i32.call	$push292=, memcmp@FUNCTION, $pop927, $pop926, $pop291
	br_if   	0, $pop292      # 0: down to label2
# BB#49:                                # %check.exit205
	i32.const	$push959=, 0
	i32.const	$push958=, 0
	i32.load8_u	$push293=, src+50($pop958)
	i32.store8	dst+50($pop959), $pop293
	i32.const	$push957=, 0
	i32.const	$push956=, 0
	i32.load16_u	$push294=, src+48($pop956)
	i32.store16	dst+48($pop957), $pop294
	i32.const	$push955=, 0
	i32.const	$push954=, 0
	i64.load	$push295=, src+40($pop954)
	i64.store	dst+40($pop955), $pop295
	i32.const	$push953=, 0
	i32.const	$push952=, 0
	i64.load	$push296=, src+32($pop952)
	i64.store	dst+32($pop953), $pop296
	i32.const	$push951=, 0
	i32.const	$push950=, 0
	i64.load	$push297=, src+24($pop950)
	i64.store	dst+24($pop951), $pop297
	i32.const	$push949=, 0
	i32.const	$push948=, 0
	i64.load	$push298=, src+16($pop948)
	i64.store	dst+16($pop949), $pop298
	i32.const	$push947=, 0
	i32.const	$push946=, 0
	i64.load	$push299=, src+8($pop946)
	i64.store	dst+8($pop947), $pop299
	i32.const	$push945=, 0
	i32.const	$push944=, 0
	i64.load	$push300=, src($pop944)
	i64.store	dst($pop945), $pop300
	i32.const	$push943=, dst
	i32.const	$push942=, src
	i32.const	$push301=, 51
	i32.call	$push302=, memcmp@FUNCTION, $pop943, $pop942, $pop301
	br_if   	0, $pop302      # 0: down to label2
# BB#50:                                # %check.exit209
	i32.const	$push975=, 0
	i32.const	$push974=, 0
	i32.load	$push303=, src+48($pop974)
	i32.store	dst+48($pop975), $pop303
	i32.const	$push973=, 0
	i32.const	$push972=, 0
	i64.load	$push304=, src+40($pop972)
	i64.store	dst+40($pop973), $pop304
	i32.const	$push971=, 0
	i32.const	$push970=, 0
	i64.load	$push305=, src+32($pop970)
	i64.store	dst+32($pop971), $pop305
	i32.const	$push969=, 0
	i32.const	$push968=, 0
	i64.load	$push306=, src+24($pop968)
	i64.store	dst+24($pop969), $pop306
	i32.const	$push967=, 0
	i32.const	$push966=, 0
	i64.load	$push307=, src+16($pop966)
	i64.store	dst+16($pop967), $pop307
	i32.const	$push965=, 0
	i32.const	$push964=, 0
	i64.load	$push308=, src+8($pop964)
	i64.store	dst+8($pop965), $pop308
	i32.const	$push963=, 0
	i32.const	$push962=, 0
	i64.load	$push309=, src($pop962)
	i64.store	dst($pop963), $pop309
	i32.const	$push961=, dst
	i32.const	$push960=, src
	i32.const	$push310=, 52
	i32.call	$push311=, memcmp@FUNCTION, $pop961, $pop960, $pop310
	br_if   	0, $pop311      # 0: down to label2
# BB#51:                                # %check.exit213
	i32.const	$push991=, 0
	i32.const	$push990=, 0
	i64.load	$push312=, src+45($pop990):p2align=0
	i64.store	dst+45($pop991):p2align=0, $pop312
	i32.const	$push989=, 0
	i32.const	$push988=, 0
	i64.load	$push313=, src+40($pop988)
	i64.store	dst+40($pop989), $pop313
	i32.const	$push987=, 0
	i32.const	$push986=, 0
	i64.load	$push314=, src+32($pop986)
	i64.store	dst+32($pop987), $pop314
	i32.const	$push985=, 0
	i32.const	$push984=, 0
	i64.load	$push315=, src+24($pop984)
	i64.store	dst+24($pop985), $pop315
	i32.const	$push983=, 0
	i32.const	$push982=, 0
	i64.load	$push316=, src+16($pop982)
	i64.store	dst+16($pop983), $pop316
	i32.const	$push981=, 0
	i32.const	$push980=, 0
	i64.load	$push317=, src+8($pop980)
	i64.store	dst+8($pop981), $pop317
	i32.const	$push979=, 0
	i32.const	$push978=, 0
	i64.load	$push318=, src($pop978)
	i64.store	dst($pop979), $pop318
	i32.const	$push977=, dst
	i32.const	$push976=, src
	i32.const	$push319=, 53
	i32.call	$push320=, memcmp@FUNCTION, $pop977, $pop976, $pop319
	br_if   	0, $pop320      # 0: down to label2
# BB#52:                                # %check.exit217
	i32.const	$push1007=, 0
	i32.const	$push1006=, 0
	i64.load	$push321=, src+46($pop1006):p2align=1
	i64.store	dst+46($pop1007):p2align=1, $pop321
	i32.const	$push1005=, 0
	i32.const	$push1004=, 0
	i64.load	$push322=, src+40($pop1004)
	i64.store	dst+40($pop1005), $pop322
	i32.const	$push1003=, 0
	i32.const	$push1002=, 0
	i64.load	$push323=, src+32($pop1002)
	i64.store	dst+32($pop1003), $pop323
	i32.const	$push1001=, 0
	i32.const	$push1000=, 0
	i64.load	$push324=, src+24($pop1000)
	i64.store	dst+24($pop1001), $pop324
	i32.const	$push999=, 0
	i32.const	$push998=, 0
	i64.load	$push325=, src+16($pop998)
	i64.store	dst+16($pop999), $pop325
	i32.const	$push997=, 0
	i32.const	$push996=, 0
	i64.load	$push326=, src+8($pop996)
	i64.store	dst+8($pop997), $pop326
	i32.const	$push995=, 0
	i32.const	$push994=, 0
	i64.load	$push327=, src($pop994)
	i64.store	dst($pop995), $pop327
	i32.const	$push993=, dst
	i32.const	$push992=, src
	i32.const	$push328=, 54
	i32.call	$push329=, memcmp@FUNCTION, $pop993, $pop992, $pop328
	br_if   	0, $pop329      # 0: down to label2
# BB#53:                                # %check.exit221
	i32.const	$push1023=, 0
	i32.const	$push1022=, 0
	i64.load	$push330=, src+47($pop1022):p2align=0
	i64.store	dst+47($pop1023):p2align=0, $pop330
	i32.const	$push1021=, 0
	i32.const	$push1020=, 0
	i64.load	$push331=, src+40($pop1020)
	i64.store	dst+40($pop1021), $pop331
	i32.const	$push1019=, 0
	i32.const	$push1018=, 0
	i64.load	$push332=, src+32($pop1018)
	i64.store	dst+32($pop1019), $pop332
	i32.const	$push1017=, 0
	i32.const	$push1016=, 0
	i64.load	$push333=, src+24($pop1016)
	i64.store	dst+24($pop1017), $pop333
	i32.const	$push1015=, 0
	i32.const	$push1014=, 0
	i64.load	$push334=, src+16($pop1014)
	i64.store	dst+16($pop1015), $pop334
	i32.const	$push1013=, 0
	i32.const	$push1012=, 0
	i64.load	$push335=, src+8($pop1012)
	i64.store	dst+8($pop1013), $pop335
	i32.const	$push1011=, 0
	i32.const	$push1010=, 0
	i64.load	$push336=, src($pop1010)
	i64.store	dst($pop1011), $pop336
	i32.const	$push1009=, dst
	i32.const	$push1008=, src
	i32.const	$push337=, 55
	i32.call	$push338=, memcmp@FUNCTION, $pop1009, $pop1008, $pop337
	br_if   	0, $pop338      # 0: down to label2
# BB#54:                                # %check.exit225
	i32.const	$push1039=, 0
	i32.const	$push1038=, 0
	i64.load	$push339=, src+48($pop1038)
	i64.store	dst+48($pop1039), $pop339
	i32.const	$push1037=, 0
	i32.const	$push1036=, 0
	i64.load	$push340=, src+40($pop1036)
	i64.store	dst+40($pop1037), $pop340
	i32.const	$push1035=, 0
	i32.const	$push1034=, 0
	i64.load	$push341=, src+32($pop1034)
	i64.store	dst+32($pop1035), $pop341
	i32.const	$push1033=, 0
	i32.const	$push1032=, 0
	i64.load	$push342=, src+24($pop1032)
	i64.store	dst+24($pop1033), $pop342
	i32.const	$push1031=, 0
	i32.const	$push1030=, 0
	i64.load	$push343=, src+16($pop1030)
	i64.store	dst+16($pop1031), $pop343
	i32.const	$push1029=, 0
	i32.const	$push1028=, 0
	i64.load	$push344=, src+8($pop1028)
	i64.store	dst+8($pop1029), $pop344
	i32.const	$push1027=, 0
	i32.const	$push1026=, 0
	i64.load	$push345=, src($pop1026)
	i64.store	dst($pop1027), $pop345
	i32.const	$push1025=, dst
	i32.const	$push1024=, src
	i32.const	$push346=, 56
	i32.call	$push347=, memcmp@FUNCTION, $pop1025, $pop1024, $pop346
	br_if   	0, $pop347      # 0: down to label2
# BB#55:                                # %check.exit229
	i32.const	$push1057=, 0
	i32.const	$push1056=, 0
	i32.load8_u	$push348=, src+56($pop1056)
	i32.store8	dst+56($pop1057), $pop348
	i32.const	$push1055=, 0
	i32.const	$push1054=, 0
	i64.load	$push349=, src+48($pop1054)
	i64.store	dst+48($pop1055), $pop349
	i32.const	$push1053=, 0
	i32.const	$push1052=, 0
	i64.load	$push350=, src+40($pop1052)
	i64.store	dst+40($pop1053), $pop350
	i32.const	$push1051=, 0
	i32.const	$push1050=, 0
	i64.load	$push351=, src+32($pop1050)
	i64.store	dst+32($pop1051), $pop351
	i32.const	$push1049=, 0
	i32.const	$push1048=, 0
	i64.load	$push352=, src+24($pop1048)
	i64.store	dst+24($pop1049), $pop352
	i32.const	$push1047=, 0
	i32.const	$push1046=, 0
	i64.load	$push353=, src+16($pop1046)
	i64.store	dst+16($pop1047), $pop353
	i32.const	$push1045=, 0
	i32.const	$push1044=, 0
	i64.load	$push354=, src+8($pop1044)
	i64.store	dst+8($pop1045), $pop354
	i32.const	$push1043=, 0
	i32.const	$push1042=, 0
	i64.load	$push355=, src($pop1042)
	i64.store	dst($pop1043), $pop355
	i32.const	$push1041=, dst
	i32.const	$push1040=, src
	i32.const	$push356=, 57
	i32.call	$push357=, memcmp@FUNCTION, $pop1041, $pop1040, $pop356
	br_if   	0, $pop357      # 0: down to label2
# BB#56:                                # %check.exit233
	i32.const	$push358=, 0
	i32.const	$push1074=, 0
	i32.load16_u	$push359=, src+56($pop1074)
	i32.store16	dst+56($pop358), $pop359
	i32.const	$push1073=, 0
	i32.const	$push1072=, 0
	i64.load	$push360=, src+48($pop1072)
	i64.store	dst+48($pop1073), $pop360
	i32.const	$push1071=, 0
	i32.const	$push1070=, 0
	i64.load	$push361=, src+40($pop1070)
	i64.store	dst+40($pop1071), $pop361
	i32.const	$push1069=, 0
	i32.const	$push1068=, 0
	i64.load	$push362=, src+32($pop1068)
	i64.store	dst+32($pop1069), $pop362
	i32.const	$push1067=, 0
	i32.const	$push1066=, 0
	i64.load	$push363=, src+24($pop1066)
	i64.store	dst+24($pop1067), $pop363
	i32.const	$push1065=, 0
	i32.const	$push1064=, 0
	i64.load	$push364=, src+16($pop1064)
	i64.store	dst+16($pop1065), $pop364
	i32.const	$push1063=, 0
	i32.const	$push1062=, 0
	i64.load	$push365=, src+8($pop1062)
	i64.store	dst+8($pop1063), $pop365
	i32.const	$push1061=, 0
	i32.const	$push1060=, 0
	i64.load	$push366=, src($pop1060)
	i64.store	dst($pop1061), $pop366
	i32.const	$push1059=, dst
	i32.const	$push1058=, src
	i32.const	$push367=, 58
	i32.call	$push368=, memcmp@FUNCTION, $pop1059, $pop1058, $pop367
	br_if   	0, $pop368      # 0: down to label2
# BB#57:                                # %check.exit237
	i32.const	$push370=, dst
	i32.const	$push1079=, src
	i32.const	$push369=, 59
	i32.call	$push1078=, memcpy@FUNCTION, $pop370, $pop1079, $pop369
	tee_local	$push1077=, $0=, $pop1078
	i32.const	$push1076=, src
	i32.const	$push1075=, 59
	i32.call	$push371=, memcmp@FUNCTION, $pop1077, $pop1076, $pop1075
	br_if   	0, $pop371      # 0: down to label2
# BB#58:                                # %check.exit241
	i32.const	$push1096=, 0
	i32.const	$push1095=, 0
	i32.load	$push372=, src+56($pop1095)
	i32.store	dst+56($pop1096), $pop372
	i32.const	$push1094=, 0
	i32.const	$push1093=, 0
	i64.load	$push373=, src+48($pop1093)
	i64.store	dst+48($pop1094), $pop373
	i32.const	$push1092=, 0
	i32.const	$push1091=, 0
	i64.load	$push374=, src+40($pop1091)
	i64.store	dst+40($pop1092), $pop374
	i32.const	$push1090=, 0
	i32.const	$push1089=, 0
	i64.load	$push375=, src+32($pop1089)
	i64.store	dst+32($pop1090), $pop375
	i32.const	$push1088=, 0
	i32.const	$push1087=, 0
	i64.load	$push376=, src+24($pop1087)
	i64.store	dst+24($pop1088), $pop376
	i32.const	$push1086=, 0
	i32.const	$push1085=, 0
	i64.load	$push377=, src+16($pop1085)
	i64.store	dst+16($pop1086), $pop377
	i32.const	$push1084=, 0
	i32.const	$push1083=, 0
	i64.load	$push378=, src+8($pop1083)
	i64.store	dst+8($pop1084), $pop378
	i32.const	$push1082=, 0
	i32.const	$push1081=, 0
	i64.load	$push379=, src($pop1081)
	i64.store	dst($pop1082), $pop379
	i32.const	$push1080=, src
	i32.const	$push380=, 60
	i32.call	$push381=, memcmp@FUNCTION, $0, $pop1080, $pop380
	br_if   	0, $pop381      # 0: down to label2
# BB#59:                                # %check.exit245
	i32.const	$push1114=, 0
	i32.const	$push1113=, 0
	i64.load	$push382=, src+53($pop1113):p2align=0
	i64.store	dst+53($pop1114):p2align=0, $pop382
	i32.const	$push1112=, 0
	i32.const	$push1111=, 0
	i64.load	$push383=, src+48($pop1111)
	i64.store	dst+48($pop1112), $pop383
	i32.const	$push1110=, 0
	i32.const	$push1109=, 0
	i64.load	$push384=, src+40($pop1109)
	i64.store	dst+40($pop1110), $pop384
	i32.const	$push1108=, 0
	i32.const	$push1107=, 0
	i64.load	$push385=, src+32($pop1107)
	i64.store	dst+32($pop1108), $pop385
	i32.const	$push1106=, 0
	i32.const	$push1105=, 0
	i64.load	$push386=, src+24($pop1105)
	i64.store	dst+24($pop1106), $pop386
	i32.const	$push1104=, 0
	i32.const	$push1103=, 0
	i64.load	$push387=, src+16($pop1103)
	i64.store	dst+16($pop1104), $pop387
	i32.const	$push1102=, 0
	i32.const	$push1101=, 0
	i64.load	$push388=, src+8($pop1101)
	i64.store	dst+8($pop1102), $pop388
	i32.const	$push1100=, 0
	i32.const	$push1099=, 0
	i64.load	$push389=, src($pop1099)
	i64.store	dst($pop1100), $pop389
	i32.const	$push1098=, dst
	i32.const	$push1097=, src
	i32.const	$push390=, 61
	i32.call	$push391=, memcmp@FUNCTION, $pop1098, $pop1097, $pop390
	br_if   	0, $pop391      # 0: down to label2
# BB#60:                                # %check.exit249
	i32.const	$push1132=, 0
	i32.const	$push1131=, 0
	i64.load	$push392=, src+54($pop1131):p2align=1
	i64.store	dst+54($pop1132):p2align=1, $pop392
	i32.const	$push1130=, 0
	i32.const	$push1129=, 0
	i64.load	$push393=, src+48($pop1129)
	i64.store	dst+48($pop1130), $pop393
	i32.const	$push1128=, 0
	i32.const	$push1127=, 0
	i64.load	$push394=, src+40($pop1127)
	i64.store	dst+40($pop1128), $pop394
	i32.const	$push1126=, 0
	i32.const	$push1125=, 0
	i64.load	$push395=, src+32($pop1125)
	i64.store	dst+32($pop1126), $pop395
	i32.const	$push1124=, 0
	i32.const	$push1123=, 0
	i64.load	$push396=, src+24($pop1123)
	i64.store	dst+24($pop1124), $pop396
	i32.const	$push1122=, 0
	i32.const	$push1121=, 0
	i64.load	$push397=, src+16($pop1121)
	i64.store	dst+16($pop1122), $pop397
	i32.const	$push1120=, 0
	i32.const	$push1119=, 0
	i64.load	$push398=, src+8($pop1119)
	i64.store	dst+8($pop1120), $pop398
	i32.const	$push1118=, 0
	i32.const	$push1117=, 0
	i64.load	$push399=, src($pop1117)
	i64.store	dst($pop1118), $pop399
	i32.const	$push1116=, dst
	i32.const	$push1115=, src
	i32.const	$push400=, 62
	i32.call	$push401=, memcmp@FUNCTION, $pop1116, $pop1115, $pop400
	br_if   	0, $pop401      # 0: down to label2
# BB#61:                                # %check.exit253
	i32.const	$push1150=, 0
	i32.const	$push1149=, 0
	i64.load	$push402=, src+55($pop1149):p2align=0
	i64.store	dst+55($pop1150):p2align=0, $pop402
	i32.const	$push1148=, 0
	i32.const	$push1147=, 0
	i64.load	$push403=, src+48($pop1147)
	i64.store	dst+48($pop1148), $pop403
	i32.const	$push1146=, 0
	i32.const	$push1145=, 0
	i64.load	$push404=, src+40($pop1145)
	i64.store	dst+40($pop1146), $pop404
	i32.const	$push1144=, 0
	i32.const	$push1143=, 0
	i64.load	$push405=, src+32($pop1143)
	i64.store	dst+32($pop1144), $pop405
	i32.const	$push1142=, 0
	i32.const	$push1141=, 0
	i64.load	$push406=, src+24($pop1141)
	i64.store	dst+24($pop1142), $pop406
	i32.const	$push1140=, 0
	i32.const	$push1139=, 0
	i64.load	$push407=, src+16($pop1139)
	i64.store	dst+16($pop1140), $pop407
	i32.const	$push1138=, 0
	i32.const	$push1137=, 0
	i64.load	$push408=, src+8($pop1137)
	i64.store	dst+8($pop1138), $pop408
	i32.const	$push1136=, 0
	i32.const	$push1135=, 0
	i64.load	$push409=, src($pop1135)
	i64.store	dst($pop1136), $pop409
	i32.const	$push1134=, dst
	i32.const	$push1133=, src
	i32.const	$push410=, 63
	i32.call	$push411=, memcmp@FUNCTION, $pop1134, $pop1133, $pop410
	br_if   	0, $pop411      # 0: down to label2
# BB#62:                                # %check.exit257
	i32.const	$push412=, 0
	i32.const	$push1167=, 0
	i64.load	$push413=, src+56($pop1167)
	i64.store	dst+56($pop412), $pop413
	i32.const	$push1166=, 0
	i32.const	$push1165=, 0
	i64.load	$push414=, src+48($pop1165)
	i64.store	dst+48($pop1166), $pop414
	i32.const	$push1164=, 0
	i32.const	$push1163=, 0
	i64.load	$push415=, src+40($pop1163)
	i64.store	dst+40($pop1164), $pop415
	i32.const	$push1162=, 0
	i32.const	$push1161=, 0
	i64.load	$push416=, src+32($pop1161)
	i64.store	dst+32($pop1162), $pop416
	i32.const	$push1160=, 0
	i32.const	$push1159=, 0
	i64.load	$push417=, src+24($pop1159)
	i64.store	dst+24($pop1160), $pop417
	i32.const	$push1158=, 0
	i32.const	$push1157=, 0
	i64.load	$push418=, src+16($pop1157)
	i64.store	dst+16($pop1158), $pop418
	i32.const	$push1156=, 0
	i32.const	$push1155=, 0
	i64.load	$push419=, src+8($pop1155)
	i64.store	dst+8($pop1156), $pop419
	i32.const	$push1154=, 0
	i32.const	$push1153=, 0
	i64.load	$push420=, src($pop1153)
	i64.store	dst($pop1154), $pop420
	i32.const	$push1152=, dst
	i32.const	$push1151=, src
	i32.const	$push421=, 64
	i32.call	$push422=, memcmp@FUNCTION, $pop1152, $pop1151, $pop421
	br_if   	0, $pop422      # 0: down to label2
# BB#63:                                # %check.exit261
	i32.const	$push424=, dst
	i32.const	$push1172=, src
	i32.const	$push423=, 65
	i32.call	$push1171=, memcpy@FUNCTION, $pop424, $pop1172, $pop423
	tee_local	$push1170=, $0=, $pop1171
	i32.const	$push1169=, src
	i32.const	$push1168=, 65
	i32.call	$push425=, memcmp@FUNCTION, $pop1170, $pop1169, $pop1168
	br_if   	0, $pop425      # 0: down to label2
# BB#64:                                # %check.exit265
	i32.const	$push1175=, src
	i32.const	$push426=, 66
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop1175, $pop426
	i32.const	$push1174=, src
	i32.const	$push1173=, 66
	i32.call	$push427=, memcmp@FUNCTION, $pop0, $pop1174, $pop1173
	br_if   	0, $pop427      # 0: down to label2
# BB#65:                                # %check.exit269
	i32.const	$push429=, dst
	i32.const	$push1180=, src
	i32.const	$push428=, 67
	i32.call	$push1179=, memcpy@FUNCTION, $pop429, $pop1180, $pop428
	tee_local	$push1178=, $0=, $pop1179
	i32.const	$push1177=, src
	i32.const	$push1176=, 67
	i32.call	$push430=, memcmp@FUNCTION, $pop1178, $pop1177, $pop1176
	br_if   	0, $pop430      # 0: down to label2
# BB#66:                                # %check.exit273
	i32.const	$push1183=, src
	i32.const	$push431=, 68
	i32.call	$push1=, memcpy@FUNCTION, $0, $pop1183, $pop431
	i32.const	$push1182=, src
	i32.const	$push1181=, 68
	i32.call	$push432=, memcmp@FUNCTION, $pop1, $pop1182, $pop1181
	br_if   	0, $pop432      # 0: down to label2
# BB#67:                                # %check.exit277
	i32.const	$push434=, dst
	i32.const	$push1188=, src
	i32.const	$push433=, 69
	i32.call	$push1187=, memcpy@FUNCTION, $pop434, $pop1188, $pop433
	tee_local	$push1186=, $0=, $pop1187
	i32.const	$push1185=, src
	i32.const	$push1184=, 69
	i32.call	$push435=, memcmp@FUNCTION, $pop1186, $pop1185, $pop1184
	br_if   	0, $pop435      # 0: down to label2
# BB#68:                                # %check.exit281
	i32.const	$push1191=, src
	i32.const	$push436=, 70
	i32.call	$push2=, memcpy@FUNCTION, $0, $pop1191, $pop436
	i32.const	$push1190=, src
	i32.const	$push1189=, 70
	i32.call	$push437=, memcmp@FUNCTION, $pop2, $pop1190, $pop1189
	br_if   	0, $pop437      # 0: down to label2
# BB#69:                                # %check.exit285
	i32.const	$push439=, dst
	i32.const	$push1196=, src
	i32.const	$push438=, 71
	i32.call	$push1195=, memcpy@FUNCTION, $pop439, $pop1196, $pop438
	tee_local	$push1194=, $0=, $pop1195
	i32.const	$push1193=, src
	i32.const	$push1192=, 71
	i32.call	$push440=, memcmp@FUNCTION, $pop1194, $pop1193, $pop1192
	br_if   	0, $pop440      # 0: down to label2
# BB#70:                                # %check.exit289
	i32.const	$push1199=, src
	i32.const	$push441=, 72
	i32.call	$push3=, memcpy@FUNCTION, $0, $pop1199, $pop441
	i32.const	$push1198=, src
	i32.const	$push1197=, 72
	i32.call	$push442=, memcmp@FUNCTION, $pop3, $pop1198, $pop1197
	br_if   	0, $pop442      # 0: down to label2
# BB#71:                                # %check.exit293
	i32.const	$push444=, dst
	i32.const	$push1204=, src
	i32.const	$push443=, 73
	i32.call	$push1203=, memcpy@FUNCTION, $pop444, $pop1204, $pop443
	tee_local	$push1202=, $0=, $pop1203
	i32.const	$push1201=, src
	i32.const	$push1200=, 73
	i32.call	$push445=, memcmp@FUNCTION, $pop1202, $pop1201, $pop1200
	br_if   	0, $pop445      # 0: down to label2
# BB#72:                                # %check.exit297
	i32.const	$push1207=, src
	i32.const	$push446=, 74
	i32.call	$push4=, memcpy@FUNCTION, $0, $pop1207, $pop446
	i32.const	$push1206=, src
	i32.const	$push1205=, 74
	i32.call	$push447=, memcmp@FUNCTION, $pop4, $pop1206, $pop1205
	br_if   	0, $pop447      # 0: down to label2
# BB#73:                                # %check.exit301
	i32.const	$push449=, dst
	i32.const	$push1212=, src
	i32.const	$push448=, 75
	i32.call	$push1211=, memcpy@FUNCTION, $pop449, $pop1212, $pop448
	tee_local	$push1210=, $0=, $pop1211
	i32.const	$push1209=, src
	i32.const	$push1208=, 75
	i32.call	$push450=, memcmp@FUNCTION, $pop1210, $pop1209, $pop1208
	br_if   	0, $pop450      # 0: down to label2
# BB#74:                                # %check.exit305
	i32.const	$push1215=, src
	i32.const	$push451=, 76
	i32.call	$push5=, memcpy@FUNCTION, $0, $pop1215, $pop451
	i32.const	$push1214=, src
	i32.const	$push1213=, 76
	i32.call	$push452=, memcmp@FUNCTION, $pop5, $pop1214, $pop1213
	br_if   	0, $pop452      # 0: down to label2
# BB#75:                                # %check.exit309
	i32.const	$push454=, dst
	i32.const	$push1220=, src
	i32.const	$push453=, 77
	i32.call	$push1219=, memcpy@FUNCTION, $pop454, $pop1220, $pop453
	tee_local	$push1218=, $0=, $pop1219
	i32.const	$push1217=, src
	i32.const	$push1216=, 77
	i32.call	$push455=, memcmp@FUNCTION, $pop1218, $pop1217, $pop1216
	br_if   	0, $pop455      # 0: down to label2
# BB#76:                                # %check.exit313
	i32.const	$push1223=, src
	i32.const	$push456=, 78
	i32.call	$push6=, memcpy@FUNCTION, $0, $pop1223, $pop456
	i32.const	$push1222=, src
	i32.const	$push1221=, 78
	i32.call	$push457=, memcmp@FUNCTION, $pop6, $pop1222, $pop1221
	br_if   	0, $pop457      # 0: down to label2
# BB#77:                                # %check.exit317
	i32.const	$push460=, dst
	i32.const	$push459=, src
	i32.const	$push458=, 79
	i32.call	$push7=, memcpy@FUNCTION, $pop460, $pop459, $pop458
	i32.const	$push1225=, src
	i32.const	$push1224=, 79
	i32.call	$push461=, memcmp@FUNCTION, $pop7, $pop1225, $pop1224
	br_if   	0, $pop461      # 0: down to label2
# BB#78:                                # %check.exit321
	i32.const	$push462=, 0
	return  	$pop462
.LBB1_79:                               # %if.then.i12
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	src                     # @src
	.type	src,@object
	.section	.bss.src,"aw",@nobits
	.globl	src
	.p2align	4
src:
	.skip	80
	.size	src, 80

	.hidden	dst                     # @dst
	.type	dst,@object
	.section	.bss.dst,"aw",@nobits
	.globl	dst
	.p2align	4
dst:
	.skip	80
	.size	dst, 80


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
