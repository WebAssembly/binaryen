	.text
	.file	"memcpy-bi.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.call	$push0=, memcmp@FUNCTION, $0, $1, $2
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
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
# %bb.0:                                # %entry
	i32.const	$0=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push470=, src
	i32.add 	$push8=, $0, $pop470
	i32.const	$push469=, 97
	i32.const	$push468=, 26
	i32.div_u	$push9=, $0, $pop468
	i32.const	$push467=, 26
	i32.mul 	$push10=, $pop9, $pop467
	i32.sub 	$push11=, $pop469, $pop10
	i32.add 	$push12=, $0, $pop11
	i32.store8	0($pop8), $pop12
	i32.const	$push466=, 1
	i32.add 	$0=, $0, $pop466
	i32.const	$push465=, 80
	i32.ne  	$push13=, $0, $pop465
	br_if   	0, $pop13       # 0: up to label1
# %bb.2:                                # %check.exit
	end_loop
	i32.const	$push472=, 0
	i32.load16_u	$0=, src($pop472)
	i32.const	$push471=, 0
	i32.store16	dst($pop471), $0
	block   	
	i32.ne  	$push14=, $0, $0
	br_if   	0, $pop14       # 0: down to label2
# %bb.3:                                # %check.exit13
	i32.const	$push478=, 0
	i32.const	$push477=, 0
	i32.load8_u	$push15=, src+2($pop477)
	i32.store8	dst+2($pop478), $pop15
	i32.const	$push476=, 0
	i32.const	$push475=, 0
	i32.load16_u	$push16=, src($pop475)
	i32.store16	dst($pop476), $pop16
	i32.const	$push474=, dst
	i32.const	$push473=, src
	i32.const	$push17=, 3
	i32.call	$push18=, memcmp@FUNCTION, $pop474, $pop473, $pop17
	br_if   	0, $pop18       # 0: down to label2
# %bb.4:                                # %check.exit17
	i32.const	$push484=, 0
	i32.const	$push483=, 0
	i32.load8_u	$push19=, src+4($pop483)
	i32.store8	dst+4($pop484), $pop19
	i32.const	$push482=, 0
	i32.const	$push481=, 0
	i32.load	$push20=, src($pop481)
	i32.store	dst($pop482), $pop20
	i32.const	$push480=, dst
	i32.const	$push479=, src
	i32.const	$push21=, 5
	i32.call	$push22=, memcmp@FUNCTION, $pop480, $pop479, $pop21
	br_if   	0, $pop22       # 0: down to label2
# %bb.5:                                # %check.exit25
	i32.const	$push490=, 0
	i32.const	$push489=, 0
	i32.load16_u	$push23=, src+4($pop489)
	i32.store16	dst+4($pop490), $pop23
	i32.const	$push488=, 0
	i32.const	$push487=, 0
	i32.load	$push24=, src($pop487)
	i32.store	dst($pop488), $pop24
	i32.const	$push486=, dst
	i32.const	$push485=, src
	i32.const	$push25=, 6
	i32.call	$push26=, memcmp@FUNCTION, $pop486, $pop485, $pop25
	br_if   	0, $pop26       # 0: down to label2
# %bb.6:                                # %check.exit29
	i32.const	$push498=, 0
	i32.const	$push497=, 0
	i32.load8_u	$push27=, src+6($pop497)
	i32.store8	dst+6($pop498), $pop27
	i32.const	$push496=, 0
	i32.const	$push495=, 0
	i32.load16_u	$push28=, src+4($pop495)
	i32.store16	dst+4($pop496), $pop28
	i32.const	$push494=, 0
	i32.const	$push493=, 0
	i32.load	$push29=, src($pop493)
	i32.store	dst($pop494), $pop29
	i32.const	$push492=, dst
	i32.const	$push491=, src
	i32.const	$push30=, 7
	i32.call	$push31=, memcmp@FUNCTION, $pop492, $pop491, $pop30
	br_if   	0, $pop31       # 0: down to label2
# %bb.7:                                # %check.exit33
	i32.const	$push504=, 0
	i32.const	$push503=, 0
	i32.load8_u	$push32=, src+8($pop503)
	i32.store8	dst+8($pop504), $pop32
	i32.const	$push502=, 0
	i32.const	$push501=, 0
	i64.load	$push33=, src($pop501)
	i64.store	dst($pop502), $pop33
	i32.const	$push500=, dst
	i32.const	$push499=, src
	i32.const	$push34=, 9
	i32.call	$push35=, memcmp@FUNCTION, $pop500, $pop499, $pop34
	br_if   	0, $pop35       # 0: down to label2
# %bb.8:                                # %check.exit41
	i32.const	$push510=, 0
	i32.const	$push509=, 0
	i32.load16_u	$push36=, src+8($pop509)
	i32.store16	dst+8($pop510), $pop36
	i32.const	$push508=, 0
	i32.const	$push507=, 0
	i64.load	$push37=, src($pop507)
	i64.store	dst($pop508), $pop37
	i32.const	$push506=, dst
	i32.const	$push505=, src
	i32.const	$push38=, 10
	i32.call	$push39=, memcmp@FUNCTION, $pop506, $pop505, $pop38
	br_if   	0, $pop39       # 0: down to label2
# %bb.9:                                # %check.exit45
	i32.const	$push518=, 0
	i32.const	$push517=, 0
	i32.load8_u	$push40=, src+10($pop517)
	i32.store8	dst+10($pop518), $pop40
	i32.const	$push516=, 0
	i32.const	$push515=, 0
	i32.load16_u	$push41=, src+8($pop515)
	i32.store16	dst+8($pop516), $pop41
	i32.const	$push514=, 0
	i32.const	$push513=, 0
	i64.load	$push42=, src($pop513)
	i64.store	dst($pop514), $pop42
	i32.const	$push512=, dst
	i32.const	$push511=, src
	i32.const	$push43=, 11
	i32.call	$push44=, memcmp@FUNCTION, $pop512, $pop511, $pop43
	br_if   	0, $pop44       # 0: down to label2
# %bb.10:                               # %check.exit49
	i32.const	$push524=, 0
	i32.const	$push523=, 0
	i32.load	$push45=, src+8($pop523)
	i32.store	dst+8($pop524), $pop45
	i32.const	$push522=, 0
	i32.const	$push521=, 0
	i64.load	$push46=, src($pop521)
	i64.store	dst($pop522), $pop46
	i32.const	$push520=, dst
	i32.const	$push519=, src
	i32.const	$push47=, 12
	i32.call	$push48=, memcmp@FUNCTION, $pop520, $pop519, $pop47
	br_if   	0, $pop48       # 0: down to label2
# %bb.11:                               # %check.exit53
	i32.const	$push530=, 0
	i32.const	$push529=, 0
	i64.load	$push49=, src+5($pop529):p2align=0
	i64.store	dst+5($pop530):p2align=0, $pop49
	i32.const	$push528=, 0
	i32.const	$push527=, 0
	i64.load	$push50=, src($pop527)
	i64.store	dst($pop528), $pop50
	i32.const	$push526=, dst
	i32.const	$push525=, src
	i32.const	$push51=, 13
	i32.call	$push52=, memcmp@FUNCTION, $pop526, $pop525, $pop51
	br_if   	0, $pop52       # 0: down to label2
# %bb.12:                               # %check.exit57
	i32.const	$push536=, 0
	i32.const	$push535=, 0
	i64.load	$push53=, src+6($pop535):p2align=1
	i64.store	dst+6($pop536):p2align=1, $pop53
	i32.const	$push534=, 0
	i32.const	$push533=, 0
	i64.load	$push54=, src($pop533)
	i64.store	dst($pop534), $pop54
	i32.const	$push532=, dst
	i32.const	$push531=, src
	i32.const	$push55=, 14
	i32.call	$push56=, memcmp@FUNCTION, $pop532, $pop531, $pop55
	br_if   	0, $pop56       # 0: down to label2
# %bb.13:                               # %check.exit61
	i32.const	$push542=, 0
	i32.const	$push541=, 0
	i64.load	$push57=, src+7($pop541):p2align=0
	i64.store	dst+7($pop542):p2align=0, $pop57
	i32.const	$push540=, 0
	i32.const	$push539=, 0
	i64.load	$push58=, src($pop539)
	i64.store	dst($pop540), $pop58
	i32.const	$push538=, dst
	i32.const	$push537=, src
	i32.const	$push59=, 15
	i32.call	$push60=, memcmp@FUNCTION, $pop538, $pop537, $pop59
	br_if   	0, $pop60       # 0: down to label2
# %bb.14:                               # %check.exit65
	i32.const	$push548=, 0
	i32.const	$push547=, 0
	i64.load	$push61=, src+8($pop547)
	i64.store	dst+8($pop548), $pop61
	i32.const	$push546=, 0
	i32.const	$push545=, 0
	i64.load	$push62=, src($pop545)
	i64.store	dst($pop546), $pop62
	i32.const	$push544=, dst
	i32.const	$push543=, src
	i32.const	$push63=, 16
	i32.call	$push64=, memcmp@FUNCTION, $pop544, $pop543, $pop63
	br_if   	0, $pop64       # 0: down to label2
# %bb.15:                               # %check.exit69
	i32.const	$push556=, 0
	i32.const	$push555=, 0
	i32.load8_u	$push65=, src+16($pop555)
	i32.store8	dst+16($pop556), $pop65
	i32.const	$push554=, 0
	i32.const	$push553=, 0
	i64.load	$push66=, src+8($pop553)
	i64.store	dst+8($pop554), $pop66
	i32.const	$push552=, 0
	i32.const	$push551=, 0
	i64.load	$push67=, src($pop551)
	i64.store	dst($pop552), $pop67
	i32.const	$push550=, dst
	i32.const	$push549=, src
	i32.const	$push68=, 17
	i32.call	$push69=, memcmp@FUNCTION, $pop550, $pop549, $pop68
	br_if   	0, $pop69       # 0: down to label2
# %bb.16:                               # %check.exit73
	i32.const	$push564=, 0
	i32.const	$push563=, 0
	i32.load16_u	$push70=, src+16($pop563)
	i32.store16	dst+16($pop564), $pop70
	i32.const	$push562=, 0
	i32.const	$push561=, 0
	i64.load	$push71=, src+8($pop561)
	i64.store	dst+8($pop562), $pop71
	i32.const	$push560=, 0
	i32.const	$push559=, 0
	i64.load	$push72=, src($pop559)
	i64.store	dst($pop560), $pop72
	i32.const	$push558=, dst
	i32.const	$push557=, src
	i32.const	$push73=, 18
	i32.call	$push74=, memcmp@FUNCTION, $pop558, $pop557, $pop73
	br_if   	0, $pop74       # 0: down to label2
# %bb.17:                               # %check.exit77
	i32.const	$push574=, 0
	i32.const	$push573=, 0
	i32.load8_u	$push75=, src+18($pop573)
	i32.store8	dst+18($pop574), $pop75
	i32.const	$push572=, 0
	i32.const	$push571=, 0
	i32.load16_u	$push76=, src+16($pop571)
	i32.store16	dst+16($pop572), $pop76
	i32.const	$push570=, 0
	i32.const	$push569=, 0
	i64.load	$push77=, src+8($pop569)
	i64.store	dst+8($pop570), $pop77
	i32.const	$push568=, 0
	i32.const	$push567=, 0
	i64.load	$push78=, src($pop567)
	i64.store	dst($pop568), $pop78
	i32.const	$push566=, dst
	i32.const	$push565=, src
	i32.const	$push79=, 19
	i32.call	$push80=, memcmp@FUNCTION, $pop566, $pop565, $pop79
	br_if   	0, $pop80       # 0: down to label2
# %bb.18:                               # %check.exit81
	i32.const	$push582=, 0
	i32.const	$push581=, 0
	i32.load	$push81=, src+16($pop581)
	i32.store	dst+16($pop582), $pop81
	i32.const	$push580=, 0
	i32.const	$push579=, 0
	i64.load	$push82=, src+8($pop579)
	i64.store	dst+8($pop580), $pop82
	i32.const	$push578=, 0
	i32.const	$push577=, 0
	i64.load	$push83=, src($pop577)
	i64.store	dst($pop578), $pop83
	i32.const	$push576=, dst
	i32.const	$push575=, src
	i32.const	$push84=, 20
	i32.call	$push85=, memcmp@FUNCTION, $pop576, $pop575, $pop84
	br_if   	0, $pop85       # 0: down to label2
# %bb.19:                               # %check.exit85
	i32.const	$push590=, 0
	i32.const	$push589=, 0
	i64.load	$push86=, src+13($pop589):p2align=0
	i64.store	dst+13($pop590):p2align=0, $pop86
	i32.const	$push588=, 0
	i32.const	$push587=, 0
	i64.load	$push87=, src+8($pop587)
	i64.store	dst+8($pop588), $pop87
	i32.const	$push586=, 0
	i32.const	$push585=, 0
	i64.load	$push88=, src($pop585)
	i64.store	dst($pop586), $pop88
	i32.const	$push584=, dst
	i32.const	$push583=, src
	i32.const	$push89=, 21
	i32.call	$push90=, memcmp@FUNCTION, $pop584, $pop583, $pop89
	br_if   	0, $pop90       # 0: down to label2
# %bb.20:                               # %check.exit89
	i32.const	$push598=, 0
	i32.const	$push597=, 0
	i64.load	$push91=, src+14($pop597):p2align=1
	i64.store	dst+14($pop598):p2align=1, $pop91
	i32.const	$push596=, 0
	i32.const	$push595=, 0
	i64.load	$push92=, src+8($pop595)
	i64.store	dst+8($pop596), $pop92
	i32.const	$push594=, 0
	i32.const	$push593=, 0
	i64.load	$push93=, src($pop593)
	i64.store	dst($pop594), $pop93
	i32.const	$push592=, dst
	i32.const	$push591=, src
	i32.const	$push94=, 22
	i32.call	$push95=, memcmp@FUNCTION, $pop592, $pop591, $pop94
	br_if   	0, $pop95       # 0: down to label2
# %bb.21:                               # %check.exit93
	i32.const	$push606=, 0
	i32.const	$push605=, 0
	i64.load	$push96=, src+15($pop605):p2align=0
	i64.store	dst+15($pop606):p2align=0, $pop96
	i32.const	$push604=, 0
	i32.const	$push603=, 0
	i64.load	$push97=, src+8($pop603)
	i64.store	dst+8($pop604), $pop97
	i32.const	$push602=, 0
	i32.const	$push601=, 0
	i64.load	$push98=, src($pop601)
	i64.store	dst($pop602), $pop98
	i32.const	$push600=, dst
	i32.const	$push599=, src
	i32.const	$push99=, 23
	i32.call	$push100=, memcmp@FUNCTION, $pop600, $pop599, $pop99
	br_if   	0, $pop100      # 0: down to label2
# %bb.22:                               # %check.exit97
	i32.const	$push614=, 0
	i32.const	$push613=, 0
	i64.load	$push101=, src+16($pop613)
	i64.store	dst+16($pop614), $pop101
	i32.const	$push612=, 0
	i32.const	$push611=, 0
	i64.load	$push102=, src+8($pop611)
	i64.store	dst+8($pop612), $pop102
	i32.const	$push610=, 0
	i32.const	$push609=, 0
	i64.load	$push103=, src($pop609)
	i64.store	dst($pop610), $pop103
	i32.const	$push608=, dst
	i32.const	$push607=, src
	i32.const	$push104=, 24
	i32.call	$push105=, memcmp@FUNCTION, $pop608, $pop607, $pop104
	br_if   	0, $pop105      # 0: down to label2
# %bb.23:                               # %check.exit101
	i32.const	$push624=, 0
	i32.const	$push623=, 0
	i32.load8_u	$push106=, src+24($pop623)
	i32.store8	dst+24($pop624), $pop106
	i32.const	$push622=, 0
	i32.const	$push621=, 0
	i64.load	$push107=, src+16($pop621)
	i64.store	dst+16($pop622), $pop107
	i32.const	$push620=, 0
	i32.const	$push619=, 0
	i64.load	$push108=, src+8($pop619)
	i64.store	dst+8($pop620), $pop108
	i32.const	$push618=, 0
	i32.const	$push617=, 0
	i64.load	$push109=, src($pop617)
	i64.store	dst($pop618), $pop109
	i32.const	$push616=, dst
	i32.const	$push615=, src
	i32.const	$push110=, 25
	i32.call	$push111=, memcmp@FUNCTION, $pop616, $pop615, $pop110
	br_if   	0, $pop111      # 0: down to label2
# %bb.24:                               # %check.exit105
	i32.const	$push634=, 0
	i32.const	$push633=, 0
	i32.load16_u	$push112=, src+24($pop633)
	i32.store16	dst+24($pop634), $pop112
	i32.const	$push632=, 0
	i32.const	$push631=, 0
	i64.load	$push113=, src+16($pop631)
	i64.store	dst+16($pop632), $pop113
	i32.const	$push630=, 0
	i32.const	$push629=, 0
	i64.load	$push114=, src+8($pop629)
	i64.store	dst+8($pop630), $pop114
	i32.const	$push628=, 0
	i32.const	$push627=, 0
	i64.load	$push115=, src($pop627)
	i64.store	dst($pop628), $pop115
	i32.const	$push626=, dst
	i32.const	$push625=, src
	i32.const	$push116=, 26
	i32.call	$push117=, memcmp@FUNCTION, $pop626, $pop625, $pop116
	br_if   	0, $pop117      # 0: down to label2
# %bb.25:                               # %check.exit109
	i32.const	$push646=, 0
	i32.const	$push645=, 0
	i32.load8_u	$push118=, src+26($pop645)
	i32.store8	dst+26($pop646), $pop118
	i32.const	$push644=, 0
	i32.const	$push643=, 0
	i32.load16_u	$push119=, src+24($pop643)
	i32.store16	dst+24($pop644), $pop119
	i32.const	$push642=, 0
	i32.const	$push641=, 0
	i64.load	$push120=, src+16($pop641)
	i64.store	dst+16($pop642), $pop120
	i32.const	$push640=, 0
	i32.const	$push639=, 0
	i64.load	$push121=, src+8($pop639)
	i64.store	dst+8($pop640), $pop121
	i32.const	$push638=, 0
	i32.const	$push637=, 0
	i64.load	$push122=, src($pop637)
	i64.store	dst($pop638), $pop122
	i32.const	$push636=, dst
	i32.const	$push635=, src
	i32.const	$push123=, 27
	i32.call	$push124=, memcmp@FUNCTION, $pop636, $pop635, $pop123
	br_if   	0, $pop124      # 0: down to label2
# %bb.26:                               # %check.exit113
	i32.const	$push656=, 0
	i32.const	$push655=, 0
	i32.load	$push125=, src+24($pop655)
	i32.store	dst+24($pop656), $pop125
	i32.const	$push654=, 0
	i32.const	$push653=, 0
	i64.load	$push126=, src+16($pop653)
	i64.store	dst+16($pop654), $pop126
	i32.const	$push652=, 0
	i32.const	$push651=, 0
	i64.load	$push127=, src+8($pop651)
	i64.store	dst+8($pop652), $pop127
	i32.const	$push650=, 0
	i32.const	$push649=, 0
	i64.load	$push128=, src($pop649)
	i64.store	dst($pop650), $pop128
	i32.const	$push648=, dst
	i32.const	$push647=, src
	i32.const	$push129=, 28
	i32.call	$push130=, memcmp@FUNCTION, $pop648, $pop647, $pop129
	br_if   	0, $pop130      # 0: down to label2
# %bb.27:                               # %check.exit117
	i32.const	$push666=, 0
	i32.const	$push665=, 0
	i64.load	$push131=, src+21($pop665):p2align=0
	i64.store	dst+21($pop666):p2align=0, $pop131
	i32.const	$push664=, 0
	i32.const	$push663=, 0
	i64.load	$push132=, src+16($pop663)
	i64.store	dst+16($pop664), $pop132
	i32.const	$push662=, 0
	i32.const	$push661=, 0
	i64.load	$push133=, src+8($pop661)
	i64.store	dst+8($pop662), $pop133
	i32.const	$push660=, 0
	i32.const	$push659=, 0
	i64.load	$push134=, src($pop659)
	i64.store	dst($pop660), $pop134
	i32.const	$push658=, dst
	i32.const	$push657=, src
	i32.const	$push135=, 29
	i32.call	$push136=, memcmp@FUNCTION, $pop658, $pop657, $pop135
	br_if   	0, $pop136      # 0: down to label2
# %bb.28:                               # %check.exit121
	i32.const	$push676=, 0
	i32.const	$push675=, 0
	i64.load	$push137=, src+22($pop675):p2align=1
	i64.store	dst+22($pop676):p2align=1, $pop137
	i32.const	$push674=, 0
	i32.const	$push673=, 0
	i64.load	$push138=, src+16($pop673)
	i64.store	dst+16($pop674), $pop138
	i32.const	$push672=, 0
	i32.const	$push671=, 0
	i64.load	$push139=, src+8($pop671)
	i64.store	dst+8($pop672), $pop139
	i32.const	$push670=, 0
	i32.const	$push669=, 0
	i64.load	$push140=, src($pop669)
	i64.store	dst($pop670), $pop140
	i32.const	$push668=, dst
	i32.const	$push667=, src
	i32.const	$push141=, 30
	i32.call	$push142=, memcmp@FUNCTION, $pop668, $pop667, $pop141
	br_if   	0, $pop142      # 0: down to label2
# %bb.29:                               # %check.exit125
	i32.const	$push686=, 0
	i32.const	$push685=, 0
	i64.load	$push143=, src+23($pop685):p2align=0
	i64.store	dst+23($pop686):p2align=0, $pop143
	i32.const	$push684=, 0
	i32.const	$push683=, 0
	i64.load	$push144=, src+16($pop683)
	i64.store	dst+16($pop684), $pop144
	i32.const	$push682=, 0
	i32.const	$push681=, 0
	i64.load	$push145=, src+8($pop681)
	i64.store	dst+8($pop682), $pop145
	i32.const	$push680=, 0
	i32.const	$push679=, 0
	i64.load	$push146=, src($pop679)
	i64.store	dst($pop680), $pop146
	i32.const	$push678=, dst
	i32.const	$push677=, src
	i32.const	$push147=, 31
	i32.call	$push148=, memcmp@FUNCTION, $pop678, $pop677, $pop147
	br_if   	0, $pop148      # 0: down to label2
# %bb.30:                               # %check.exit129
	i32.const	$push696=, 0
	i32.const	$push695=, 0
	i64.load	$push149=, src+24($pop695)
	i64.store	dst+24($pop696), $pop149
	i32.const	$push694=, 0
	i32.const	$push693=, 0
	i64.load	$push150=, src+16($pop693)
	i64.store	dst+16($pop694), $pop150
	i32.const	$push692=, 0
	i32.const	$push691=, 0
	i64.load	$push151=, src+8($pop691)
	i64.store	dst+8($pop692), $pop151
	i32.const	$push690=, 0
	i32.const	$push689=, 0
	i64.load	$push152=, src($pop689)
	i64.store	dst($pop690), $pop152
	i32.const	$push688=, dst
	i32.const	$push687=, src
	i32.const	$push153=, 32
	i32.call	$push154=, memcmp@FUNCTION, $pop688, $pop687, $pop153
	br_if   	0, $pop154      # 0: down to label2
# %bb.31:                               # %check.exit133
	i32.const	$push708=, 0
	i32.const	$push707=, 0
	i32.load8_u	$push155=, src+32($pop707)
	i32.store8	dst+32($pop708), $pop155
	i32.const	$push706=, 0
	i32.const	$push705=, 0
	i64.load	$push156=, src+24($pop705)
	i64.store	dst+24($pop706), $pop156
	i32.const	$push704=, 0
	i32.const	$push703=, 0
	i64.load	$push157=, src+16($pop703)
	i64.store	dst+16($pop704), $pop157
	i32.const	$push702=, 0
	i32.const	$push701=, 0
	i64.load	$push158=, src+8($pop701)
	i64.store	dst+8($pop702), $pop158
	i32.const	$push700=, 0
	i32.const	$push699=, 0
	i64.load	$push159=, src($pop699)
	i64.store	dst($pop700), $pop159
	i32.const	$push698=, dst
	i32.const	$push697=, src
	i32.const	$push160=, 33
	i32.call	$push161=, memcmp@FUNCTION, $pop698, $pop697, $pop160
	br_if   	0, $pop161      # 0: down to label2
# %bb.32:                               # %check.exit137
	i32.const	$push720=, 0
	i32.const	$push719=, 0
	i32.load16_u	$push162=, src+32($pop719)
	i32.store16	dst+32($pop720), $pop162
	i32.const	$push718=, 0
	i32.const	$push717=, 0
	i64.load	$push163=, src+24($pop717)
	i64.store	dst+24($pop718), $pop163
	i32.const	$push716=, 0
	i32.const	$push715=, 0
	i64.load	$push164=, src+16($pop715)
	i64.store	dst+16($pop716), $pop164
	i32.const	$push714=, 0
	i32.const	$push713=, 0
	i64.load	$push165=, src+8($pop713)
	i64.store	dst+8($pop714), $pop165
	i32.const	$push712=, 0
	i32.const	$push711=, 0
	i64.load	$push166=, src($pop711)
	i64.store	dst($pop712), $pop166
	i32.const	$push710=, dst
	i32.const	$push709=, src
	i32.const	$push167=, 34
	i32.call	$push168=, memcmp@FUNCTION, $pop710, $pop709, $pop167
	br_if   	0, $pop168      # 0: down to label2
# %bb.33:                               # %check.exit141
	i32.const	$push734=, 0
	i32.const	$push733=, 0
	i32.load8_u	$push169=, src+34($pop733)
	i32.store8	dst+34($pop734), $pop169
	i32.const	$push732=, 0
	i32.const	$push731=, 0
	i32.load16_u	$push170=, src+32($pop731)
	i32.store16	dst+32($pop732), $pop170
	i32.const	$push730=, 0
	i32.const	$push729=, 0
	i64.load	$push171=, src+24($pop729)
	i64.store	dst+24($pop730), $pop171
	i32.const	$push728=, 0
	i32.const	$push727=, 0
	i64.load	$push172=, src+16($pop727)
	i64.store	dst+16($pop728), $pop172
	i32.const	$push726=, 0
	i32.const	$push725=, 0
	i64.load	$push173=, src+8($pop725)
	i64.store	dst+8($pop726), $pop173
	i32.const	$push724=, 0
	i32.const	$push723=, 0
	i64.load	$push174=, src($pop723)
	i64.store	dst($pop724), $pop174
	i32.const	$push722=, dst
	i32.const	$push721=, src
	i32.const	$push175=, 35
	i32.call	$push176=, memcmp@FUNCTION, $pop722, $pop721, $pop175
	br_if   	0, $pop176      # 0: down to label2
# %bb.34:                               # %check.exit145
	i32.const	$push746=, 0
	i32.const	$push745=, 0
	i32.load	$push177=, src+32($pop745)
	i32.store	dst+32($pop746), $pop177
	i32.const	$push744=, 0
	i32.const	$push743=, 0
	i64.load	$push178=, src+24($pop743)
	i64.store	dst+24($pop744), $pop178
	i32.const	$push742=, 0
	i32.const	$push741=, 0
	i64.load	$push179=, src+16($pop741)
	i64.store	dst+16($pop742), $pop179
	i32.const	$push740=, 0
	i32.const	$push739=, 0
	i64.load	$push180=, src+8($pop739)
	i64.store	dst+8($pop740), $pop180
	i32.const	$push738=, 0
	i32.const	$push737=, 0
	i64.load	$push181=, src($pop737)
	i64.store	dst($pop738), $pop181
	i32.const	$push736=, dst
	i32.const	$push735=, src
	i32.const	$push182=, 36
	i32.call	$push183=, memcmp@FUNCTION, $pop736, $pop735, $pop182
	br_if   	0, $pop183      # 0: down to label2
# %bb.35:                               # %check.exit149
	i32.const	$push758=, 0
	i32.const	$push757=, 0
	i64.load	$push184=, src+29($pop757):p2align=0
	i64.store	dst+29($pop758):p2align=0, $pop184
	i32.const	$push756=, 0
	i32.const	$push755=, 0
	i64.load	$push185=, src+24($pop755)
	i64.store	dst+24($pop756), $pop185
	i32.const	$push754=, 0
	i32.const	$push753=, 0
	i64.load	$push186=, src+16($pop753)
	i64.store	dst+16($pop754), $pop186
	i32.const	$push752=, 0
	i32.const	$push751=, 0
	i64.load	$push187=, src+8($pop751)
	i64.store	dst+8($pop752), $pop187
	i32.const	$push750=, 0
	i32.const	$push749=, 0
	i64.load	$push188=, src($pop749)
	i64.store	dst($pop750), $pop188
	i32.const	$push748=, dst
	i32.const	$push747=, src
	i32.const	$push189=, 37
	i32.call	$push190=, memcmp@FUNCTION, $pop748, $pop747, $pop189
	br_if   	0, $pop190      # 0: down to label2
# %bb.36:                               # %check.exit153
	i32.const	$push770=, 0
	i32.const	$push769=, 0
	i64.load	$push191=, src+30($pop769):p2align=1
	i64.store	dst+30($pop770):p2align=1, $pop191
	i32.const	$push768=, 0
	i32.const	$push767=, 0
	i64.load	$push192=, src+24($pop767)
	i64.store	dst+24($pop768), $pop192
	i32.const	$push766=, 0
	i32.const	$push765=, 0
	i64.load	$push193=, src+16($pop765)
	i64.store	dst+16($pop766), $pop193
	i32.const	$push764=, 0
	i32.const	$push763=, 0
	i64.load	$push194=, src+8($pop763)
	i64.store	dst+8($pop764), $pop194
	i32.const	$push762=, 0
	i32.const	$push761=, 0
	i64.load	$push195=, src($pop761)
	i64.store	dst($pop762), $pop195
	i32.const	$push760=, dst
	i32.const	$push759=, src
	i32.const	$push196=, 38
	i32.call	$push197=, memcmp@FUNCTION, $pop760, $pop759, $pop196
	br_if   	0, $pop197      # 0: down to label2
# %bb.37:                               # %check.exit157
	i32.const	$push782=, 0
	i32.const	$push781=, 0
	i64.load	$push198=, src+31($pop781):p2align=0
	i64.store	dst+31($pop782):p2align=0, $pop198
	i32.const	$push780=, 0
	i32.const	$push779=, 0
	i64.load	$push199=, src+24($pop779)
	i64.store	dst+24($pop780), $pop199
	i32.const	$push778=, 0
	i32.const	$push777=, 0
	i64.load	$push200=, src+16($pop777)
	i64.store	dst+16($pop778), $pop200
	i32.const	$push776=, 0
	i32.const	$push775=, 0
	i64.load	$push201=, src+8($pop775)
	i64.store	dst+8($pop776), $pop201
	i32.const	$push774=, 0
	i32.const	$push773=, 0
	i64.load	$push202=, src($pop773)
	i64.store	dst($pop774), $pop202
	i32.const	$push772=, dst
	i32.const	$push771=, src
	i32.const	$push203=, 39
	i32.call	$push204=, memcmp@FUNCTION, $pop772, $pop771, $pop203
	br_if   	0, $pop204      # 0: down to label2
# %bb.38:                               # %check.exit161
	i32.const	$push794=, 0
	i32.const	$push793=, 0
	i64.load	$push205=, src+32($pop793)
	i64.store	dst+32($pop794), $pop205
	i32.const	$push792=, 0
	i32.const	$push791=, 0
	i64.load	$push206=, src+24($pop791)
	i64.store	dst+24($pop792), $pop206
	i32.const	$push790=, 0
	i32.const	$push789=, 0
	i64.load	$push207=, src+16($pop789)
	i64.store	dst+16($pop790), $pop207
	i32.const	$push788=, 0
	i32.const	$push787=, 0
	i64.load	$push208=, src+8($pop787)
	i64.store	dst+8($pop788), $pop208
	i32.const	$push786=, 0
	i32.const	$push785=, 0
	i64.load	$push209=, src($pop785)
	i64.store	dst($pop786), $pop209
	i32.const	$push784=, dst
	i32.const	$push783=, src
	i32.const	$push210=, 40
	i32.call	$push211=, memcmp@FUNCTION, $pop784, $pop783, $pop210
	br_if   	0, $pop211      # 0: down to label2
# %bb.39:                               # %check.exit165
	i32.const	$push808=, 0
	i32.const	$push807=, 0
	i32.load8_u	$push212=, src+40($pop807)
	i32.store8	dst+40($pop808), $pop212
	i32.const	$push806=, 0
	i32.const	$push805=, 0
	i64.load	$push213=, src+32($pop805)
	i64.store	dst+32($pop806), $pop213
	i32.const	$push804=, 0
	i32.const	$push803=, 0
	i64.load	$push214=, src+24($pop803)
	i64.store	dst+24($pop804), $pop214
	i32.const	$push802=, 0
	i32.const	$push801=, 0
	i64.load	$push215=, src+16($pop801)
	i64.store	dst+16($pop802), $pop215
	i32.const	$push800=, 0
	i32.const	$push799=, 0
	i64.load	$push216=, src+8($pop799)
	i64.store	dst+8($pop800), $pop216
	i32.const	$push798=, 0
	i32.const	$push797=, 0
	i64.load	$push217=, src($pop797)
	i64.store	dst($pop798), $pop217
	i32.const	$push796=, dst
	i32.const	$push795=, src
	i32.const	$push218=, 41
	i32.call	$push219=, memcmp@FUNCTION, $pop796, $pop795, $pop218
	br_if   	0, $pop219      # 0: down to label2
# %bb.40:                               # %check.exit169
	i32.const	$push822=, 0
	i32.const	$push821=, 0
	i32.load16_u	$push220=, src+40($pop821)
	i32.store16	dst+40($pop822), $pop220
	i32.const	$push820=, 0
	i32.const	$push819=, 0
	i64.load	$push221=, src+32($pop819)
	i64.store	dst+32($pop820), $pop221
	i32.const	$push818=, 0
	i32.const	$push817=, 0
	i64.load	$push222=, src+24($pop817)
	i64.store	dst+24($pop818), $pop222
	i32.const	$push816=, 0
	i32.const	$push815=, 0
	i64.load	$push223=, src+16($pop815)
	i64.store	dst+16($pop816), $pop223
	i32.const	$push814=, 0
	i32.const	$push813=, 0
	i64.load	$push224=, src+8($pop813)
	i64.store	dst+8($pop814), $pop224
	i32.const	$push812=, 0
	i32.const	$push811=, 0
	i64.load	$push225=, src($pop811)
	i64.store	dst($pop812), $pop225
	i32.const	$push810=, dst
	i32.const	$push809=, src
	i32.const	$push226=, 42
	i32.call	$push227=, memcmp@FUNCTION, $pop810, $pop809, $pop226
	br_if   	0, $pop227      # 0: down to label2
# %bb.41:                               # %check.exit173
	i32.const	$push838=, 0
	i32.const	$push837=, 0
	i32.load8_u	$push228=, src+42($pop837)
	i32.store8	dst+42($pop838), $pop228
	i32.const	$push836=, 0
	i32.const	$push835=, 0
	i32.load16_u	$push229=, src+40($pop835)
	i32.store16	dst+40($pop836), $pop229
	i32.const	$push834=, 0
	i32.const	$push833=, 0
	i64.load	$push230=, src+32($pop833)
	i64.store	dst+32($pop834), $pop230
	i32.const	$push832=, 0
	i32.const	$push831=, 0
	i64.load	$push231=, src+24($pop831)
	i64.store	dst+24($pop832), $pop231
	i32.const	$push830=, 0
	i32.const	$push829=, 0
	i64.load	$push232=, src+16($pop829)
	i64.store	dst+16($pop830), $pop232
	i32.const	$push828=, 0
	i32.const	$push827=, 0
	i64.load	$push233=, src+8($pop827)
	i64.store	dst+8($pop828), $pop233
	i32.const	$push826=, 0
	i32.const	$push825=, 0
	i64.load	$push234=, src($pop825)
	i64.store	dst($pop826), $pop234
	i32.const	$push824=, dst
	i32.const	$push823=, src
	i32.const	$push235=, 43
	i32.call	$push236=, memcmp@FUNCTION, $pop824, $pop823, $pop235
	br_if   	0, $pop236      # 0: down to label2
# %bb.42:                               # %check.exit177
	i32.const	$push852=, 0
	i32.const	$push851=, 0
	i32.load	$push237=, src+40($pop851)
	i32.store	dst+40($pop852), $pop237
	i32.const	$push850=, 0
	i32.const	$push849=, 0
	i64.load	$push238=, src+32($pop849)
	i64.store	dst+32($pop850), $pop238
	i32.const	$push848=, 0
	i32.const	$push847=, 0
	i64.load	$push239=, src+24($pop847)
	i64.store	dst+24($pop848), $pop239
	i32.const	$push846=, 0
	i32.const	$push845=, 0
	i64.load	$push240=, src+16($pop845)
	i64.store	dst+16($pop846), $pop240
	i32.const	$push844=, 0
	i32.const	$push843=, 0
	i64.load	$push241=, src+8($pop843)
	i64.store	dst+8($pop844), $pop241
	i32.const	$push842=, 0
	i32.const	$push841=, 0
	i64.load	$push242=, src($pop841)
	i64.store	dst($pop842), $pop242
	i32.const	$push840=, dst
	i32.const	$push839=, src
	i32.const	$push243=, 44
	i32.call	$push244=, memcmp@FUNCTION, $pop840, $pop839, $pop243
	br_if   	0, $pop244      # 0: down to label2
# %bb.43:                               # %check.exit181
	i32.const	$push866=, 0
	i32.const	$push865=, 0
	i64.load	$push245=, src+37($pop865):p2align=0
	i64.store	dst+37($pop866):p2align=0, $pop245
	i32.const	$push864=, 0
	i32.const	$push863=, 0
	i64.load	$push246=, src+32($pop863)
	i64.store	dst+32($pop864), $pop246
	i32.const	$push862=, 0
	i32.const	$push861=, 0
	i64.load	$push247=, src+24($pop861)
	i64.store	dst+24($pop862), $pop247
	i32.const	$push860=, 0
	i32.const	$push859=, 0
	i64.load	$push248=, src+16($pop859)
	i64.store	dst+16($pop860), $pop248
	i32.const	$push858=, 0
	i32.const	$push857=, 0
	i64.load	$push249=, src+8($pop857)
	i64.store	dst+8($pop858), $pop249
	i32.const	$push856=, 0
	i32.const	$push855=, 0
	i64.load	$push250=, src($pop855)
	i64.store	dst($pop856), $pop250
	i32.const	$push854=, dst
	i32.const	$push853=, src
	i32.const	$push251=, 45
	i32.call	$push252=, memcmp@FUNCTION, $pop854, $pop853, $pop251
	br_if   	0, $pop252      # 0: down to label2
# %bb.44:                               # %check.exit185
	i32.const	$push880=, 0
	i32.const	$push879=, 0
	i64.load	$push253=, src+38($pop879):p2align=1
	i64.store	dst+38($pop880):p2align=1, $pop253
	i32.const	$push878=, 0
	i32.const	$push877=, 0
	i64.load	$push254=, src+32($pop877)
	i64.store	dst+32($pop878), $pop254
	i32.const	$push876=, 0
	i32.const	$push875=, 0
	i64.load	$push255=, src+24($pop875)
	i64.store	dst+24($pop876), $pop255
	i32.const	$push874=, 0
	i32.const	$push873=, 0
	i64.load	$push256=, src+16($pop873)
	i64.store	dst+16($pop874), $pop256
	i32.const	$push872=, 0
	i32.const	$push871=, 0
	i64.load	$push257=, src+8($pop871)
	i64.store	dst+8($pop872), $pop257
	i32.const	$push870=, 0
	i32.const	$push869=, 0
	i64.load	$push258=, src($pop869)
	i64.store	dst($pop870), $pop258
	i32.const	$push868=, dst
	i32.const	$push867=, src
	i32.const	$push259=, 46
	i32.call	$push260=, memcmp@FUNCTION, $pop868, $pop867, $pop259
	br_if   	0, $pop260      # 0: down to label2
# %bb.45:                               # %check.exit189
	i32.const	$push894=, 0
	i32.const	$push893=, 0
	i64.load	$push261=, src+39($pop893):p2align=0
	i64.store	dst+39($pop894):p2align=0, $pop261
	i32.const	$push892=, 0
	i32.const	$push891=, 0
	i64.load	$push262=, src+32($pop891)
	i64.store	dst+32($pop892), $pop262
	i32.const	$push890=, 0
	i32.const	$push889=, 0
	i64.load	$push263=, src+24($pop889)
	i64.store	dst+24($pop890), $pop263
	i32.const	$push888=, 0
	i32.const	$push887=, 0
	i64.load	$push264=, src+16($pop887)
	i64.store	dst+16($pop888), $pop264
	i32.const	$push886=, 0
	i32.const	$push885=, 0
	i64.load	$push265=, src+8($pop885)
	i64.store	dst+8($pop886), $pop265
	i32.const	$push884=, 0
	i32.const	$push883=, 0
	i64.load	$push266=, src($pop883)
	i64.store	dst($pop884), $pop266
	i32.const	$push882=, dst
	i32.const	$push881=, src
	i32.const	$push267=, 47
	i32.call	$push268=, memcmp@FUNCTION, $pop882, $pop881, $pop267
	br_if   	0, $pop268      # 0: down to label2
# %bb.46:                               # %check.exit193
	i32.const	$push908=, 0
	i32.const	$push907=, 0
	i64.load	$push269=, src+40($pop907)
	i64.store	dst+40($pop908), $pop269
	i32.const	$push906=, 0
	i32.const	$push905=, 0
	i64.load	$push270=, src+32($pop905)
	i64.store	dst+32($pop906), $pop270
	i32.const	$push904=, 0
	i32.const	$push903=, 0
	i64.load	$push271=, src+24($pop903)
	i64.store	dst+24($pop904), $pop271
	i32.const	$push902=, 0
	i32.const	$push901=, 0
	i64.load	$push272=, src+16($pop901)
	i64.store	dst+16($pop902), $pop272
	i32.const	$push900=, 0
	i32.const	$push899=, 0
	i64.load	$push273=, src+8($pop899)
	i64.store	dst+8($pop900), $pop273
	i32.const	$push898=, 0
	i32.const	$push897=, 0
	i64.load	$push274=, src($pop897)
	i64.store	dst($pop898), $pop274
	i32.const	$push896=, dst
	i32.const	$push895=, src
	i32.const	$push275=, 48
	i32.call	$push276=, memcmp@FUNCTION, $pop896, $pop895, $pop275
	br_if   	0, $pop276      # 0: down to label2
# %bb.47:                               # %check.exit197
	i32.const	$push924=, 0
	i32.const	$push923=, 0
	i32.load8_u	$push277=, src+48($pop923)
	i32.store8	dst+48($pop924), $pop277
	i32.const	$push922=, 0
	i32.const	$push921=, 0
	i64.load	$push278=, src+40($pop921)
	i64.store	dst+40($pop922), $pop278
	i32.const	$push920=, 0
	i32.const	$push919=, 0
	i64.load	$push279=, src+32($pop919)
	i64.store	dst+32($pop920), $pop279
	i32.const	$push918=, 0
	i32.const	$push917=, 0
	i64.load	$push280=, src+24($pop917)
	i64.store	dst+24($pop918), $pop280
	i32.const	$push916=, 0
	i32.const	$push915=, 0
	i64.load	$push281=, src+16($pop915)
	i64.store	dst+16($pop916), $pop281
	i32.const	$push914=, 0
	i32.const	$push913=, 0
	i64.load	$push282=, src+8($pop913)
	i64.store	dst+8($pop914), $pop282
	i32.const	$push912=, 0
	i32.const	$push911=, 0
	i64.load	$push283=, src($pop911)
	i64.store	dst($pop912), $pop283
	i32.const	$push910=, dst
	i32.const	$push909=, src
	i32.const	$push284=, 49
	i32.call	$push285=, memcmp@FUNCTION, $pop910, $pop909, $pop284
	br_if   	0, $pop285      # 0: down to label2
# %bb.48:                               # %check.exit201
	i32.const	$push940=, 0
	i32.const	$push939=, 0
	i32.load16_u	$push286=, src+48($pop939)
	i32.store16	dst+48($pop940), $pop286
	i32.const	$push938=, 0
	i32.const	$push937=, 0
	i64.load	$push287=, src+40($pop937)
	i64.store	dst+40($pop938), $pop287
	i32.const	$push936=, 0
	i32.const	$push935=, 0
	i64.load	$push288=, src+32($pop935)
	i64.store	dst+32($pop936), $pop288
	i32.const	$push934=, 0
	i32.const	$push933=, 0
	i64.load	$push289=, src+24($pop933)
	i64.store	dst+24($pop934), $pop289
	i32.const	$push932=, 0
	i32.const	$push931=, 0
	i64.load	$push290=, src+16($pop931)
	i64.store	dst+16($pop932), $pop290
	i32.const	$push930=, 0
	i32.const	$push929=, 0
	i64.load	$push291=, src+8($pop929)
	i64.store	dst+8($pop930), $pop291
	i32.const	$push928=, 0
	i32.const	$push927=, 0
	i64.load	$push292=, src($pop927)
	i64.store	dst($pop928), $pop292
	i32.const	$push926=, dst
	i32.const	$push925=, src
	i32.const	$push293=, 50
	i32.call	$push294=, memcmp@FUNCTION, $pop926, $pop925, $pop293
	br_if   	0, $pop294      # 0: down to label2
# %bb.49:                               # %check.exit205
	i32.const	$push958=, 0
	i32.const	$push957=, 0
	i32.load8_u	$push295=, src+50($pop957)
	i32.store8	dst+50($pop958), $pop295
	i32.const	$push956=, 0
	i32.const	$push955=, 0
	i32.load16_u	$push296=, src+48($pop955)
	i32.store16	dst+48($pop956), $pop296
	i32.const	$push954=, 0
	i32.const	$push953=, 0
	i64.load	$push297=, src+40($pop953)
	i64.store	dst+40($pop954), $pop297
	i32.const	$push952=, 0
	i32.const	$push951=, 0
	i64.load	$push298=, src+32($pop951)
	i64.store	dst+32($pop952), $pop298
	i32.const	$push950=, 0
	i32.const	$push949=, 0
	i64.load	$push299=, src+24($pop949)
	i64.store	dst+24($pop950), $pop299
	i32.const	$push948=, 0
	i32.const	$push947=, 0
	i64.load	$push300=, src+16($pop947)
	i64.store	dst+16($pop948), $pop300
	i32.const	$push946=, 0
	i32.const	$push945=, 0
	i64.load	$push301=, src+8($pop945)
	i64.store	dst+8($pop946), $pop301
	i32.const	$push944=, 0
	i32.const	$push943=, 0
	i64.load	$push302=, src($pop943)
	i64.store	dst($pop944), $pop302
	i32.const	$push942=, dst
	i32.const	$push941=, src
	i32.const	$push303=, 51
	i32.call	$push304=, memcmp@FUNCTION, $pop942, $pop941, $pop303
	br_if   	0, $pop304      # 0: down to label2
# %bb.50:                               # %check.exit209
	i32.const	$push974=, 0
	i32.const	$push973=, 0
	i32.load	$push305=, src+48($pop973)
	i32.store	dst+48($pop974), $pop305
	i32.const	$push972=, 0
	i32.const	$push971=, 0
	i64.load	$push306=, src+40($pop971)
	i64.store	dst+40($pop972), $pop306
	i32.const	$push970=, 0
	i32.const	$push969=, 0
	i64.load	$push307=, src+32($pop969)
	i64.store	dst+32($pop970), $pop307
	i32.const	$push968=, 0
	i32.const	$push967=, 0
	i64.load	$push308=, src+24($pop967)
	i64.store	dst+24($pop968), $pop308
	i32.const	$push966=, 0
	i32.const	$push965=, 0
	i64.load	$push309=, src+16($pop965)
	i64.store	dst+16($pop966), $pop309
	i32.const	$push964=, 0
	i32.const	$push963=, 0
	i64.load	$push310=, src+8($pop963)
	i64.store	dst+8($pop964), $pop310
	i32.const	$push962=, 0
	i32.const	$push961=, 0
	i64.load	$push311=, src($pop961)
	i64.store	dst($pop962), $pop311
	i32.const	$push960=, dst
	i32.const	$push959=, src
	i32.const	$push312=, 52
	i32.call	$push313=, memcmp@FUNCTION, $pop960, $pop959, $pop312
	br_if   	0, $pop313      # 0: down to label2
# %bb.51:                               # %check.exit213
	i32.const	$push990=, 0
	i32.const	$push989=, 0
	i64.load	$push314=, src+45($pop989):p2align=0
	i64.store	dst+45($pop990):p2align=0, $pop314
	i32.const	$push988=, 0
	i32.const	$push987=, 0
	i64.load	$push315=, src+40($pop987)
	i64.store	dst+40($pop988), $pop315
	i32.const	$push986=, 0
	i32.const	$push985=, 0
	i64.load	$push316=, src+32($pop985)
	i64.store	dst+32($pop986), $pop316
	i32.const	$push984=, 0
	i32.const	$push983=, 0
	i64.load	$push317=, src+24($pop983)
	i64.store	dst+24($pop984), $pop317
	i32.const	$push982=, 0
	i32.const	$push981=, 0
	i64.load	$push318=, src+16($pop981)
	i64.store	dst+16($pop982), $pop318
	i32.const	$push980=, 0
	i32.const	$push979=, 0
	i64.load	$push319=, src+8($pop979)
	i64.store	dst+8($pop980), $pop319
	i32.const	$push978=, 0
	i32.const	$push977=, 0
	i64.load	$push320=, src($pop977)
	i64.store	dst($pop978), $pop320
	i32.const	$push976=, dst
	i32.const	$push975=, src
	i32.const	$push321=, 53
	i32.call	$push322=, memcmp@FUNCTION, $pop976, $pop975, $pop321
	br_if   	0, $pop322      # 0: down to label2
# %bb.52:                               # %check.exit217
	i32.const	$push1006=, 0
	i32.const	$push1005=, 0
	i64.load	$push323=, src+46($pop1005):p2align=1
	i64.store	dst+46($pop1006):p2align=1, $pop323
	i32.const	$push1004=, 0
	i32.const	$push1003=, 0
	i64.load	$push324=, src+40($pop1003)
	i64.store	dst+40($pop1004), $pop324
	i32.const	$push1002=, 0
	i32.const	$push1001=, 0
	i64.load	$push325=, src+32($pop1001)
	i64.store	dst+32($pop1002), $pop325
	i32.const	$push1000=, 0
	i32.const	$push999=, 0
	i64.load	$push326=, src+24($pop999)
	i64.store	dst+24($pop1000), $pop326
	i32.const	$push998=, 0
	i32.const	$push997=, 0
	i64.load	$push327=, src+16($pop997)
	i64.store	dst+16($pop998), $pop327
	i32.const	$push996=, 0
	i32.const	$push995=, 0
	i64.load	$push328=, src+8($pop995)
	i64.store	dst+8($pop996), $pop328
	i32.const	$push994=, 0
	i32.const	$push993=, 0
	i64.load	$push329=, src($pop993)
	i64.store	dst($pop994), $pop329
	i32.const	$push992=, dst
	i32.const	$push991=, src
	i32.const	$push330=, 54
	i32.call	$push331=, memcmp@FUNCTION, $pop992, $pop991, $pop330
	br_if   	0, $pop331      # 0: down to label2
# %bb.53:                               # %check.exit221
	i32.const	$push1022=, 0
	i32.const	$push1021=, 0
	i64.load	$push332=, src+47($pop1021):p2align=0
	i64.store	dst+47($pop1022):p2align=0, $pop332
	i32.const	$push1020=, 0
	i32.const	$push1019=, 0
	i64.load	$push333=, src+40($pop1019)
	i64.store	dst+40($pop1020), $pop333
	i32.const	$push1018=, 0
	i32.const	$push1017=, 0
	i64.load	$push334=, src+32($pop1017)
	i64.store	dst+32($pop1018), $pop334
	i32.const	$push1016=, 0
	i32.const	$push1015=, 0
	i64.load	$push335=, src+24($pop1015)
	i64.store	dst+24($pop1016), $pop335
	i32.const	$push1014=, 0
	i32.const	$push1013=, 0
	i64.load	$push336=, src+16($pop1013)
	i64.store	dst+16($pop1014), $pop336
	i32.const	$push1012=, 0
	i32.const	$push1011=, 0
	i64.load	$push337=, src+8($pop1011)
	i64.store	dst+8($pop1012), $pop337
	i32.const	$push1010=, 0
	i32.const	$push1009=, 0
	i64.load	$push338=, src($pop1009)
	i64.store	dst($pop1010), $pop338
	i32.const	$push1008=, dst
	i32.const	$push1007=, src
	i32.const	$push339=, 55
	i32.call	$push340=, memcmp@FUNCTION, $pop1008, $pop1007, $pop339
	br_if   	0, $pop340      # 0: down to label2
# %bb.54:                               # %check.exit225
	i32.const	$push1038=, 0
	i32.const	$push1037=, 0
	i64.load	$push341=, src+48($pop1037)
	i64.store	dst+48($pop1038), $pop341
	i32.const	$push1036=, 0
	i32.const	$push1035=, 0
	i64.load	$push342=, src+40($pop1035)
	i64.store	dst+40($pop1036), $pop342
	i32.const	$push1034=, 0
	i32.const	$push1033=, 0
	i64.load	$push343=, src+32($pop1033)
	i64.store	dst+32($pop1034), $pop343
	i32.const	$push1032=, 0
	i32.const	$push1031=, 0
	i64.load	$push344=, src+24($pop1031)
	i64.store	dst+24($pop1032), $pop344
	i32.const	$push1030=, 0
	i32.const	$push1029=, 0
	i64.load	$push345=, src+16($pop1029)
	i64.store	dst+16($pop1030), $pop345
	i32.const	$push1028=, 0
	i32.const	$push1027=, 0
	i64.load	$push346=, src+8($pop1027)
	i64.store	dst+8($pop1028), $pop346
	i32.const	$push1026=, 0
	i32.const	$push1025=, 0
	i64.load	$push347=, src($pop1025)
	i64.store	dst($pop1026), $pop347
	i32.const	$push1024=, dst
	i32.const	$push1023=, src
	i32.const	$push348=, 56
	i32.call	$push349=, memcmp@FUNCTION, $pop1024, $pop1023, $pop348
	br_if   	0, $pop349      # 0: down to label2
# %bb.55:                               # %check.exit229
	i32.const	$push1056=, 0
	i32.const	$push1055=, 0
	i32.load8_u	$push350=, src+56($pop1055)
	i32.store8	dst+56($pop1056), $pop350
	i32.const	$push1054=, 0
	i32.const	$push1053=, 0
	i64.load	$push351=, src+48($pop1053)
	i64.store	dst+48($pop1054), $pop351
	i32.const	$push1052=, 0
	i32.const	$push1051=, 0
	i64.load	$push352=, src+40($pop1051)
	i64.store	dst+40($pop1052), $pop352
	i32.const	$push1050=, 0
	i32.const	$push1049=, 0
	i64.load	$push353=, src+32($pop1049)
	i64.store	dst+32($pop1050), $pop353
	i32.const	$push1048=, 0
	i32.const	$push1047=, 0
	i64.load	$push354=, src+24($pop1047)
	i64.store	dst+24($pop1048), $pop354
	i32.const	$push1046=, 0
	i32.const	$push1045=, 0
	i64.load	$push355=, src+16($pop1045)
	i64.store	dst+16($pop1046), $pop355
	i32.const	$push1044=, 0
	i32.const	$push1043=, 0
	i64.load	$push356=, src+8($pop1043)
	i64.store	dst+8($pop1044), $pop356
	i32.const	$push1042=, 0
	i32.const	$push1041=, 0
	i64.load	$push357=, src($pop1041)
	i64.store	dst($pop1042), $pop357
	i32.const	$push1040=, dst
	i32.const	$push1039=, src
	i32.const	$push358=, 57
	i32.call	$push359=, memcmp@FUNCTION, $pop1040, $pop1039, $pop358
	br_if   	0, $pop359      # 0: down to label2
# %bb.56:                               # %check.exit233
	i32.const	$push360=, 0
	i32.const	$push1073=, 0
	i32.load16_u	$push361=, src+56($pop1073)
	i32.store16	dst+56($pop360), $pop361
	i32.const	$push1072=, 0
	i32.const	$push1071=, 0
	i64.load	$push362=, src+48($pop1071)
	i64.store	dst+48($pop1072), $pop362
	i32.const	$push1070=, 0
	i32.const	$push1069=, 0
	i64.load	$push363=, src+40($pop1069)
	i64.store	dst+40($pop1070), $pop363
	i32.const	$push1068=, 0
	i32.const	$push1067=, 0
	i64.load	$push364=, src+32($pop1067)
	i64.store	dst+32($pop1068), $pop364
	i32.const	$push1066=, 0
	i32.const	$push1065=, 0
	i64.load	$push365=, src+24($pop1065)
	i64.store	dst+24($pop1066), $pop365
	i32.const	$push1064=, 0
	i32.const	$push1063=, 0
	i64.load	$push366=, src+16($pop1063)
	i64.store	dst+16($pop1064), $pop366
	i32.const	$push1062=, 0
	i32.const	$push1061=, 0
	i64.load	$push367=, src+8($pop1061)
	i64.store	dst+8($pop1062), $pop367
	i32.const	$push1060=, 0
	i32.const	$push1059=, 0
	i64.load	$push368=, src($pop1059)
	i64.store	dst($pop1060), $pop368
	i32.const	$push1058=, dst
	i32.const	$push1057=, src
	i32.const	$push369=, 58
	i32.call	$push370=, memcmp@FUNCTION, $pop1058, $pop1057, $pop369
	br_if   	0, $pop370      # 0: down to label2
# %bb.57:                               # %check.exit237
	i32.const	$push372=, dst
	i32.const	$push1076=, src
	i32.const	$push371=, 59
	i32.call	$0=, memcpy@FUNCTION, $pop372, $pop1076, $pop371
	i32.const	$push1075=, src
	i32.const	$push1074=, 59
	i32.call	$push373=, memcmp@FUNCTION, $0, $pop1075, $pop1074
	br_if   	0, $pop373      # 0: down to label2
# %bb.58:                               # %check.exit241
	i32.const	$push1093=, 0
	i32.const	$push1092=, 0
	i32.load	$push374=, src+56($pop1092)
	i32.store	dst+56($pop1093), $pop374
	i32.const	$push1091=, 0
	i32.const	$push1090=, 0
	i64.load	$push375=, src+48($pop1090)
	i64.store	dst+48($pop1091), $pop375
	i32.const	$push1089=, 0
	i32.const	$push1088=, 0
	i64.load	$push376=, src+40($pop1088)
	i64.store	dst+40($pop1089), $pop376
	i32.const	$push1087=, 0
	i32.const	$push1086=, 0
	i64.load	$push377=, src+32($pop1086)
	i64.store	dst+32($pop1087), $pop377
	i32.const	$push1085=, 0
	i32.const	$push1084=, 0
	i64.load	$push378=, src+24($pop1084)
	i64.store	dst+24($pop1085), $pop378
	i32.const	$push1083=, 0
	i32.const	$push1082=, 0
	i64.load	$push379=, src+16($pop1082)
	i64.store	dst+16($pop1083), $pop379
	i32.const	$push1081=, 0
	i32.const	$push1080=, 0
	i64.load	$push380=, src+8($pop1080)
	i64.store	dst+8($pop1081), $pop380
	i32.const	$push1079=, 0
	i32.const	$push1078=, 0
	i64.load	$push381=, src($pop1078)
	i64.store	dst($pop1079), $pop381
	i32.const	$push1077=, src
	i32.const	$push382=, 60
	i32.call	$push383=, memcmp@FUNCTION, $0, $pop1077, $pop382
	br_if   	0, $pop383      # 0: down to label2
# %bb.59:                               # %check.exit245
	i32.const	$push1111=, 0
	i32.const	$push1110=, 0
	i64.load	$push384=, src+53($pop1110):p2align=0
	i64.store	dst+53($pop1111):p2align=0, $pop384
	i32.const	$push1109=, 0
	i32.const	$push1108=, 0
	i64.load	$push385=, src+48($pop1108)
	i64.store	dst+48($pop1109), $pop385
	i32.const	$push1107=, 0
	i32.const	$push1106=, 0
	i64.load	$push386=, src+40($pop1106)
	i64.store	dst+40($pop1107), $pop386
	i32.const	$push1105=, 0
	i32.const	$push1104=, 0
	i64.load	$push387=, src+32($pop1104)
	i64.store	dst+32($pop1105), $pop387
	i32.const	$push1103=, 0
	i32.const	$push1102=, 0
	i64.load	$push388=, src+24($pop1102)
	i64.store	dst+24($pop1103), $pop388
	i32.const	$push1101=, 0
	i32.const	$push1100=, 0
	i64.load	$push389=, src+16($pop1100)
	i64.store	dst+16($pop1101), $pop389
	i32.const	$push1099=, 0
	i32.const	$push1098=, 0
	i64.load	$push390=, src+8($pop1098)
	i64.store	dst+8($pop1099), $pop390
	i32.const	$push1097=, 0
	i32.const	$push1096=, 0
	i64.load	$push391=, src($pop1096)
	i64.store	dst($pop1097), $pop391
	i32.const	$push1095=, dst
	i32.const	$push1094=, src
	i32.const	$push392=, 61
	i32.call	$push393=, memcmp@FUNCTION, $pop1095, $pop1094, $pop392
	br_if   	0, $pop393      # 0: down to label2
# %bb.60:                               # %check.exit249
	i32.const	$push1129=, 0
	i32.const	$push1128=, 0
	i64.load	$push394=, src+54($pop1128):p2align=1
	i64.store	dst+54($pop1129):p2align=1, $pop394
	i32.const	$push1127=, 0
	i32.const	$push1126=, 0
	i64.load	$push395=, src+48($pop1126)
	i64.store	dst+48($pop1127), $pop395
	i32.const	$push1125=, 0
	i32.const	$push1124=, 0
	i64.load	$push396=, src+40($pop1124)
	i64.store	dst+40($pop1125), $pop396
	i32.const	$push1123=, 0
	i32.const	$push1122=, 0
	i64.load	$push397=, src+32($pop1122)
	i64.store	dst+32($pop1123), $pop397
	i32.const	$push1121=, 0
	i32.const	$push1120=, 0
	i64.load	$push398=, src+24($pop1120)
	i64.store	dst+24($pop1121), $pop398
	i32.const	$push1119=, 0
	i32.const	$push1118=, 0
	i64.load	$push399=, src+16($pop1118)
	i64.store	dst+16($pop1119), $pop399
	i32.const	$push1117=, 0
	i32.const	$push1116=, 0
	i64.load	$push400=, src+8($pop1116)
	i64.store	dst+8($pop1117), $pop400
	i32.const	$push1115=, 0
	i32.const	$push1114=, 0
	i64.load	$push401=, src($pop1114)
	i64.store	dst($pop1115), $pop401
	i32.const	$push1113=, dst
	i32.const	$push1112=, src
	i32.const	$push402=, 62
	i32.call	$push403=, memcmp@FUNCTION, $pop1113, $pop1112, $pop402
	br_if   	0, $pop403      # 0: down to label2
# %bb.61:                               # %check.exit253
	i32.const	$push1147=, 0
	i32.const	$push1146=, 0
	i64.load	$push404=, src+55($pop1146):p2align=0
	i64.store	dst+55($pop1147):p2align=0, $pop404
	i32.const	$push1145=, 0
	i32.const	$push1144=, 0
	i64.load	$push405=, src+48($pop1144)
	i64.store	dst+48($pop1145), $pop405
	i32.const	$push1143=, 0
	i32.const	$push1142=, 0
	i64.load	$push406=, src+40($pop1142)
	i64.store	dst+40($pop1143), $pop406
	i32.const	$push1141=, 0
	i32.const	$push1140=, 0
	i64.load	$push407=, src+32($pop1140)
	i64.store	dst+32($pop1141), $pop407
	i32.const	$push1139=, 0
	i32.const	$push1138=, 0
	i64.load	$push408=, src+24($pop1138)
	i64.store	dst+24($pop1139), $pop408
	i32.const	$push1137=, 0
	i32.const	$push1136=, 0
	i64.load	$push409=, src+16($pop1136)
	i64.store	dst+16($pop1137), $pop409
	i32.const	$push1135=, 0
	i32.const	$push1134=, 0
	i64.load	$push410=, src+8($pop1134)
	i64.store	dst+8($pop1135), $pop410
	i32.const	$push1133=, 0
	i32.const	$push1132=, 0
	i64.load	$push411=, src($pop1132)
	i64.store	dst($pop1133), $pop411
	i32.const	$push1131=, dst
	i32.const	$push1130=, src
	i32.const	$push412=, 63
	i32.call	$push413=, memcmp@FUNCTION, $pop1131, $pop1130, $pop412
	br_if   	0, $pop413      # 0: down to label2
# %bb.62:                               # %check.exit257
	i32.const	$push414=, 0
	i32.const	$push1164=, 0
	i64.load	$push415=, src+56($pop1164)
	i64.store	dst+56($pop414), $pop415
	i32.const	$push1163=, 0
	i32.const	$push1162=, 0
	i64.load	$push416=, src+48($pop1162)
	i64.store	dst+48($pop1163), $pop416
	i32.const	$push1161=, 0
	i32.const	$push1160=, 0
	i64.load	$push417=, src+40($pop1160)
	i64.store	dst+40($pop1161), $pop417
	i32.const	$push1159=, 0
	i32.const	$push1158=, 0
	i64.load	$push418=, src+32($pop1158)
	i64.store	dst+32($pop1159), $pop418
	i32.const	$push1157=, 0
	i32.const	$push1156=, 0
	i64.load	$push419=, src+24($pop1156)
	i64.store	dst+24($pop1157), $pop419
	i32.const	$push1155=, 0
	i32.const	$push1154=, 0
	i64.load	$push420=, src+16($pop1154)
	i64.store	dst+16($pop1155), $pop420
	i32.const	$push1153=, 0
	i32.const	$push1152=, 0
	i64.load	$push421=, src+8($pop1152)
	i64.store	dst+8($pop1153), $pop421
	i32.const	$push1151=, 0
	i32.const	$push1150=, 0
	i64.load	$push422=, src($pop1150)
	i64.store	dst($pop1151), $pop422
	i32.const	$push1149=, dst
	i32.const	$push1148=, src
	i32.const	$push423=, 64
	i32.call	$push424=, memcmp@FUNCTION, $pop1149, $pop1148, $pop423
	br_if   	0, $pop424      # 0: down to label2
# %bb.63:                               # %check.exit261
	i32.const	$push426=, dst
	i32.const	$push1167=, src
	i32.const	$push425=, 65
	i32.call	$0=, memcpy@FUNCTION, $pop426, $pop1167, $pop425
	i32.const	$push1166=, src
	i32.const	$push1165=, 65
	i32.call	$push427=, memcmp@FUNCTION, $0, $pop1166, $pop1165
	br_if   	0, $pop427      # 0: down to label2
# %bb.64:                               # %check.exit265
	i32.const	$push1170=, src
	i32.const	$push428=, 66
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop1170, $pop428
	i32.const	$push1169=, src
	i32.const	$push1168=, 66
	i32.call	$push429=, memcmp@FUNCTION, $pop0, $pop1169, $pop1168
	br_if   	0, $pop429      # 0: down to label2
# %bb.65:                               # %check.exit269
	i32.const	$push431=, dst
	i32.const	$push1173=, src
	i32.const	$push430=, 67
	i32.call	$0=, memcpy@FUNCTION, $pop431, $pop1173, $pop430
	i32.const	$push1172=, src
	i32.const	$push1171=, 67
	i32.call	$push432=, memcmp@FUNCTION, $0, $pop1172, $pop1171
	br_if   	0, $pop432      # 0: down to label2
# %bb.66:                               # %check.exit273
	i32.const	$push1176=, src
	i32.const	$push433=, 68
	i32.call	$push1=, memcpy@FUNCTION, $0, $pop1176, $pop433
	i32.const	$push1175=, src
	i32.const	$push1174=, 68
	i32.call	$push434=, memcmp@FUNCTION, $pop1, $pop1175, $pop1174
	br_if   	0, $pop434      # 0: down to label2
# %bb.67:                               # %check.exit277
	i32.const	$push436=, dst
	i32.const	$push1179=, src
	i32.const	$push435=, 69
	i32.call	$0=, memcpy@FUNCTION, $pop436, $pop1179, $pop435
	i32.const	$push1178=, src
	i32.const	$push1177=, 69
	i32.call	$push437=, memcmp@FUNCTION, $0, $pop1178, $pop1177
	br_if   	0, $pop437      # 0: down to label2
# %bb.68:                               # %check.exit281
	i32.const	$push1182=, src
	i32.const	$push438=, 70
	i32.call	$push2=, memcpy@FUNCTION, $0, $pop1182, $pop438
	i32.const	$push1181=, src
	i32.const	$push1180=, 70
	i32.call	$push439=, memcmp@FUNCTION, $pop2, $pop1181, $pop1180
	br_if   	0, $pop439      # 0: down to label2
# %bb.69:                               # %check.exit285
	i32.const	$push441=, dst
	i32.const	$push1185=, src
	i32.const	$push440=, 71
	i32.call	$0=, memcpy@FUNCTION, $pop441, $pop1185, $pop440
	i32.const	$push1184=, src
	i32.const	$push1183=, 71
	i32.call	$push442=, memcmp@FUNCTION, $0, $pop1184, $pop1183
	br_if   	0, $pop442      # 0: down to label2
# %bb.70:                               # %check.exit289
	i32.const	$push1188=, src
	i32.const	$push443=, 72
	i32.call	$push3=, memcpy@FUNCTION, $0, $pop1188, $pop443
	i32.const	$push1187=, src
	i32.const	$push1186=, 72
	i32.call	$push444=, memcmp@FUNCTION, $pop3, $pop1187, $pop1186
	br_if   	0, $pop444      # 0: down to label2
# %bb.71:                               # %check.exit293
	i32.const	$push446=, dst
	i32.const	$push1191=, src
	i32.const	$push445=, 73
	i32.call	$0=, memcpy@FUNCTION, $pop446, $pop1191, $pop445
	i32.const	$push1190=, src
	i32.const	$push1189=, 73
	i32.call	$push447=, memcmp@FUNCTION, $0, $pop1190, $pop1189
	br_if   	0, $pop447      # 0: down to label2
# %bb.72:                               # %check.exit297
	i32.const	$push1194=, src
	i32.const	$push448=, 74
	i32.call	$push4=, memcpy@FUNCTION, $0, $pop1194, $pop448
	i32.const	$push1193=, src
	i32.const	$push1192=, 74
	i32.call	$push449=, memcmp@FUNCTION, $pop4, $pop1193, $pop1192
	br_if   	0, $pop449      # 0: down to label2
# %bb.73:                               # %check.exit301
	i32.const	$push451=, dst
	i32.const	$push1197=, src
	i32.const	$push450=, 75
	i32.call	$0=, memcpy@FUNCTION, $pop451, $pop1197, $pop450
	i32.const	$push1196=, src
	i32.const	$push1195=, 75
	i32.call	$push452=, memcmp@FUNCTION, $0, $pop1196, $pop1195
	br_if   	0, $pop452      # 0: down to label2
# %bb.74:                               # %check.exit305
	i32.const	$push1200=, src
	i32.const	$push453=, 76
	i32.call	$push5=, memcpy@FUNCTION, $0, $pop1200, $pop453
	i32.const	$push1199=, src
	i32.const	$push1198=, 76
	i32.call	$push454=, memcmp@FUNCTION, $pop5, $pop1199, $pop1198
	br_if   	0, $pop454      # 0: down to label2
# %bb.75:                               # %check.exit309
	i32.const	$push456=, dst
	i32.const	$push1203=, src
	i32.const	$push455=, 77
	i32.call	$0=, memcpy@FUNCTION, $pop456, $pop1203, $pop455
	i32.const	$push1202=, src
	i32.const	$push1201=, 77
	i32.call	$push457=, memcmp@FUNCTION, $0, $pop1202, $pop1201
	br_if   	0, $pop457      # 0: down to label2
# %bb.76:                               # %check.exit313
	i32.const	$push1206=, src
	i32.const	$push458=, 78
	i32.call	$push6=, memcpy@FUNCTION, $0, $pop1206, $pop458
	i32.const	$push1205=, src
	i32.const	$push1204=, 78
	i32.call	$push459=, memcmp@FUNCTION, $pop6, $pop1205, $pop1204
	br_if   	0, $pop459      # 0: down to label2
# %bb.77:                               # %check.exit317
	i32.const	$push462=, dst
	i32.const	$push461=, src
	i32.const	$push460=, 79
	i32.call	$push7=, memcpy@FUNCTION, $pop462, $pop461, $pop460
	i32.const	$push1208=, src
	i32.const	$push1207=, 79
	i32.call	$push463=, memcmp@FUNCTION, $pop7, $pop1208, $pop1207
	br_if   	0, $pop463      # 0: down to label2
# %bb.78:                               # %check.exit321
	i32.const	$push464=, 0
	return  	$pop464
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
