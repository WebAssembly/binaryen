	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-bi.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push303=, 26
	i32.rem_s	$push24=, $0, $pop303
	i32.const	$push302=, 97
	i32.add 	$push25=, $pop24, $pop302
	i32.store8	$drop=, src($0), $pop25
	i32.const	$push301=, 1
	i32.add 	$push300=, $0, $pop301
	tee_local	$push299=, $0=, $pop300
	i32.const	$push298=, 80
	i32.ne  	$push26=, $pop299, $pop298
	br_if   	0, $pop26       # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop                        # label2:
	i32.const	$push305=, 0
	i32.const	$push304=, 0
	i32.load16_u	$push27=, src($pop304)
	i32.store16	$drop=, dst($pop305), $pop27
	block
	i32.const	$push28=, 1
	i32.eqz 	$push728=, $pop28
	br_if   	0, $pop728      # 0: down to label3
# BB#3:                                 # %check.exit172
	i32.const	$push311=, 0
	i32.const	$push310=, 0
	i32.load8_u	$push29=, src+2($pop310)
	i32.store8	$drop=, dst+2($pop311), $pop29
	i32.const	$push309=, 0
	i32.const	$push308=, 0
	i32.load16_u	$push30=, src($pop308)
	i32.store16	$drop=, dst($pop309), $pop30
	i32.const	$push307=, dst
	i32.const	$push306=, src
	i32.const	$push31=, 3
	i32.call	$push32=, memcmp@FUNCTION, $pop307, $pop306, $pop31
	br_if   	0, $pop32       # 0: down to label3
# BB#4:                                 # %check.exit176
	i32.const	$push317=, 0
	i32.const	$push316=, 0
	i32.load8_u	$push33=, src+4($pop316)
	i32.store8	$drop=, dst+4($pop317), $pop33
	i32.const	$push315=, 0
	i32.const	$push314=, 0
	i32.load	$push34=, src($pop314)
	i32.store	$drop=, dst($pop315), $pop34
	i32.const	$push313=, dst
	i32.const	$push312=, src
	i32.const	$push35=, 5
	i32.call	$push36=, memcmp@FUNCTION, $pop313, $pop312, $pop35
	br_if   	0, $pop36       # 0: down to label3
# BB#5:                                 # %check.exit184
	i32.const	$push323=, 0
	i32.const	$push322=, 0
	i32.load16_u	$push37=, src+4($pop322)
	i32.store16	$drop=, dst+4($pop323), $pop37
	i32.const	$push321=, 0
	i32.const	$push320=, 0
	i32.load	$push38=, src($pop320)
	i32.store	$drop=, dst($pop321), $pop38
	i32.const	$push319=, dst
	i32.const	$push318=, src
	i32.const	$push39=, 6
	i32.call	$push40=, memcmp@FUNCTION, $pop319, $pop318, $pop39
	br_if   	0, $pop40       # 0: down to label3
# BB#6:                                 # %check.exit188
	i32.const	$push331=, 0
	i32.const	$push330=, 0
	i32.load8_u	$push41=, src+6($pop330)
	i32.store8	$drop=, dst+6($pop331), $pop41
	i32.const	$push329=, 0
	i32.const	$push328=, 0
	i32.load16_u	$push42=, src+4($pop328)
	i32.store16	$drop=, dst+4($pop329), $pop42
	i32.const	$push327=, 0
	i32.const	$push326=, 0
	i32.load	$push43=, src($pop326)
	i32.store	$drop=, dst($pop327), $pop43
	i32.const	$push325=, dst
	i32.const	$push324=, src
	i32.const	$push44=, 7
	i32.call	$push45=, memcmp@FUNCTION, $pop325, $pop324, $pop44
	br_if   	0, $pop45       # 0: down to label3
# BB#7:                                 # %check.exit192
	i32.const	$push337=, 0
	i32.const	$push336=, 0
	i32.load8_u	$push46=, src+8($pop336)
	i32.store8	$drop=, dst+8($pop337), $pop46
	i32.const	$push335=, 0
	i32.const	$push334=, 0
	i64.load	$push47=, src($pop334)
	i64.store	$drop=, dst($pop335), $pop47
	i32.const	$push333=, dst
	i32.const	$push332=, src
	i32.const	$push48=, 9
	i32.call	$push49=, memcmp@FUNCTION, $pop333, $pop332, $pop48
	br_if   	0, $pop49       # 0: down to label3
# BB#8:                                 # %check.exit200
	i32.const	$push343=, 0
	i32.const	$push342=, 0
	i32.load16_u	$push50=, src+8($pop342)
	i32.store16	$drop=, dst+8($pop343), $pop50
	i32.const	$push341=, 0
	i32.const	$push340=, 0
	i64.load	$push51=, src($pop340)
	i64.store	$drop=, dst($pop341), $pop51
	i32.const	$push339=, dst
	i32.const	$push338=, src
	i32.const	$push52=, 10
	i32.call	$push53=, memcmp@FUNCTION, $pop339, $pop338, $pop52
	br_if   	0, $pop53       # 0: down to label3
# BB#9:                                 # %check.exit204
	i32.const	$push351=, 0
	i32.const	$push350=, 0
	i32.load8_u	$push54=, src+10($pop350)
	i32.store8	$drop=, dst+10($pop351), $pop54
	i32.const	$push349=, 0
	i32.const	$push348=, 0
	i32.load16_u	$push55=, src+8($pop348)
	i32.store16	$drop=, dst+8($pop349), $pop55
	i32.const	$push347=, 0
	i32.const	$push346=, 0
	i64.load	$push56=, src($pop346)
	i64.store	$drop=, dst($pop347), $pop56
	i32.const	$push345=, dst
	i32.const	$push344=, src
	i32.const	$push57=, 11
	i32.call	$push58=, memcmp@FUNCTION, $pop345, $pop344, $pop57
	br_if   	0, $pop58       # 0: down to label3
# BB#10:                                # %check.exit208
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i32.load	$push59=, src+8($pop356)
	i32.store	$drop=, dst+8($pop357), $pop59
	i32.const	$push355=, 0
	i32.const	$push354=, 0
	i64.load	$push60=, src($pop354)
	i64.store	$drop=, dst($pop355), $pop60
	i32.const	$push353=, dst
	i32.const	$push352=, src
	i32.const	$push61=, 12
	i32.call	$push62=, memcmp@FUNCTION, $pop353, $pop352, $pop61
	br_if   	0, $pop62       # 0: down to label3
# BB#11:                                # %check.exit212
	i32.const	$push365=, 0
	i32.const	$push364=, 0
	i32.load8_u	$push63=, src+12($pop364)
	i32.store8	$drop=, dst+12($pop365), $pop63
	i32.const	$push363=, 0
	i32.const	$push362=, 0
	i32.load	$push64=, src+8($pop362)
	i32.store	$drop=, dst+8($pop363), $pop64
	i32.const	$push361=, 0
	i32.const	$push360=, 0
	i64.load	$push65=, src($pop360)
	i64.store	$drop=, dst($pop361), $pop65
	i32.const	$push359=, dst
	i32.const	$push358=, src
	i32.const	$push66=, 13
	i32.call	$push67=, memcmp@FUNCTION, $pop359, $pop358, $pop66
	br_if   	0, $pop67       # 0: down to label3
# BB#12:                                # %check.exit216
	i32.const	$push373=, 0
	i32.const	$push372=, 0
	i32.load16_u	$push68=, src+12($pop372)
	i32.store16	$drop=, dst+12($pop373), $pop68
	i32.const	$push371=, 0
	i32.const	$push370=, 0
	i32.load	$push69=, src+8($pop370)
	i32.store	$drop=, dst+8($pop371), $pop69
	i32.const	$push369=, 0
	i32.const	$push368=, 0
	i64.load	$push70=, src($pop368)
	i64.store	$drop=, dst($pop369), $pop70
	i32.const	$push367=, dst
	i32.const	$push366=, src
	i32.const	$push71=, 14
	i32.call	$push72=, memcmp@FUNCTION, $pop367, $pop366, $pop71
	br_if   	0, $pop72       # 0: down to label3
# BB#13:                                # %check.exit220
	i32.const	$push383=, 0
	i32.const	$push382=, 0
	i32.load8_u	$push73=, src+14($pop382)
	i32.store8	$drop=, dst+14($pop383), $pop73
	i32.const	$push381=, 0
	i32.const	$push380=, 0
	i32.load16_u	$push74=, src+12($pop380)
	i32.store16	$drop=, dst+12($pop381), $pop74
	i32.const	$push379=, 0
	i32.const	$push378=, 0
	i32.load	$push75=, src+8($pop378)
	i32.store	$drop=, dst+8($pop379), $pop75
	i32.const	$push377=, 0
	i32.const	$push376=, 0
	i64.load	$push76=, src($pop376)
	i64.store	$drop=, dst($pop377), $pop76
	i32.const	$push375=, dst
	i32.const	$push374=, src
	i32.const	$push77=, 15
	i32.call	$push78=, memcmp@FUNCTION, $pop375, $pop374, $pop77
	br_if   	0, $pop78       # 0: down to label3
# BB#14:                                # %check.exit224
	i32.const	$push389=, 0
	i32.const	$push388=, 0
	i64.load	$push79=, src+8($pop388)
	i64.store	$drop=, dst+8($pop389), $pop79
	i32.const	$push387=, 0
	i32.const	$push386=, 0
	i64.load	$push80=, src($pop386)
	i64.store	$drop=, dst($pop387), $pop80
	i32.const	$push385=, dst
	i32.const	$push384=, src
	i32.const	$push81=, 16
	i32.call	$push82=, memcmp@FUNCTION, $pop385, $pop384, $pop81
	br_if   	0, $pop82       # 0: down to label3
# BB#15:                                # %check.exit228
	i32.const	$push397=, 0
	i32.const	$push396=, 0
	i32.load8_u	$push83=, src+16($pop396)
	i32.store8	$drop=, dst+16($pop397), $pop83
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i64.load	$push84=, src+8($pop394)
	i64.store	$drop=, dst+8($pop395), $pop84
	i32.const	$push393=, 0
	i32.const	$push392=, 0
	i64.load	$push85=, src($pop392)
	i64.store	$drop=, dst($pop393), $pop85
	i32.const	$push391=, dst
	i32.const	$push390=, src
	i32.const	$push86=, 17
	i32.call	$push87=, memcmp@FUNCTION, $pop391, $pop390, $pop86
	br_if   	0, $pop87       # 0: down to label3
# BB#16:                                # %check.exit232
	i32.const	$push405=, 0
	i32.const	$push404=, 0
	i32.load16_u	$push88=, src+16($pop404)
	i32.store16	$drop=, dst+16($pop405), $pop88
	i32.const	$push403=, 0
	i32.const	$push402=, 0
	i64.load	$push89=, src+8($pop402)
	i64.store	$drop=, dst+8($pop403), $pop89
	i32.const	$push401=, 0
	i32.const	$push400=, 0
	i64.load	$push90=, src($pop400)
	i64.store	$drop=, dst($pop401), $pop90
	i32.const	$push399=, dst
	i32.const	$push398=, src
	i32.const	$push91=, 18
	i32.call	$push92=, memcmp@FUNCTION, $pop399, $pop398, $pop91
	br_if   	0, $pop92       # 0: down to label3
# BB#17:                                # %check.exit236
	i32.const	$push415=, 0
	i32.const	$push414=, 0
	i32.load8_u	$push93=, src+18($pop414)
	i32.store8	$drop=, dst+18($pop415), $pop93
	i32.const	$push413=, 0
	i32.const	$push412=, 0
	i32.load16_u	$push94=, src+16($pop412)
	i32.store16	$drop=, dst+16($pop413), $pop94
	i32.const	$push411=, 0
	i32.const	$push410=, 0
	i64.load	$push95=, src+8($pop410)
	i64.store	$drop=, dst+8($pop411), $pop95
	i32.const	$push409=, 0
	i32.const	$push408=, 0
	i64.load	$push96=, src($pop408)
	i64.store	$drop=, dst($pop409), $pop96
	i32.const	$push407=, dst
	i32.const	$push406=, src
	i32.const	$push97=, 19
	i32.call	$push98=, memcmp@FUNCTION, $pop407, $pop406, $pop97
	br_if   	0, $pop98       # 0: down to label3
# BB#18:                                # %check.exit240
	i32.const	$push423=, 0
	i32.const	$push422=, 0
	i32.load	$push99=, src+16($pop422)
	i32.store	$drop=, dst+16($pop423), $pop99
	i32.const	$push421=, 0
	i32.const	$push420=, 0
	i64.load	$push100=, src+8($pop420)
	i64.store	$drop=, dst+8($pop421), $pop100
	i32.const	$push419=, 0
	i32.const	$push418=, 0
	i64.load	$push101=, src($pop418)
	i64.store	$drop=, dst($pop419), $pop101
	i32.const	$push417=, dst
	i32.const	$push416=, src
	i32.const	$push102=, 20
	i32.call	$push103=, memcmp@FUNCTION, $pop417, $pop416, $pop102
	br_if   	0, $pop103      # 0: down to label3
# BB#19:                                # %check.exit244
	i32.const	$push433=, 0
	i32.const	$push432=, 0
	i32.load8_u	$push104=, src+20($pop432)
	i32.store8	$drop=, dst+20($pop433), $pop104
	i32.const	$push431=, 0
	i32.const	$push430=, 0
	i32.load	$push105=, src+16($pop430)
	i32.store	$drop=, dst+16($pop431), $pop105
	i32.const	$push429=, 0
	i32.const	$push428=, 0
	i64.load	$push106=, src+8($pop428)
	i64.store	$drop=, dst+8($pop429), $pop106
	i32.const	$push427=, 0
	i32.const	$push426=, 0
	i64.load	$push107=, src($pop426)
	i64.store	$drop=, dst($pop427), $pop107
	i32.const	$push425=, dst
	i32.const	$push424=, src
	i32.const	$push108=, 21
	i32.call	$push109=, memcmp@FUNCTION, $pop425, $pop424, $pop108
	br_if   	0, $pop109      # 0: down to label3
# BB#20:                                # %check.exit248
	i32.const	$push443=, 0
	i32.const	$push442=, 0
	i32.load16_u	$push110=, src+20($pop442)
	i32.store16	$drop=, dst+20($pop443), $pop110
	i32.const	$push441=, 0
	i32.const	$push440=, 0
	i32.load	$push111=, src+16($pop440)
	i32.store	$drop=, dst+16($pop441), $pop111
	i32.const	$push439=, 0
	i32.const	$push438=, 0
	i64.load	$push112=, src+8($pop438)
	i64.store	$drop=, dst+8($pop439), $pop112
	i32.const	$push437=, 0
	i32.const	$push436=, 0
	i64.load	$push113=, src($pop436)
	i64.store	$drop=, dst($pop437), $pop113
	i32.const	$push435=, dst
	i32.const	$push434=, src
	i32.const	$push114=, 22
	i32.call	$push115=, memcmp@FUNCTION, $pop435, $pop434, $pop114
	br_if   	0, $pop115      # 0: down to label3
# BB#21:                                # %check.exit252
	i32.const	$push455=, 0
	i32.const	$push454=, 0
	i32.load8_u	$push116=, src+22($pop454)
	i32.store8	$drop=, dst+22($pop455), $pop116
	i32.const	$push453=, 0
	i32.const	$push452=, 0
	i32.load16_u	$push117=, src+20($pop452)
	i32.store16	$drop=, dst+20($pop453), $pop117
	i32.const	$push451=, 0
	i32.const	$push450=, 0
	i32.load	$push118=, src+16($pop450)
	i32.store	$drop=, dst+16($pop451), $pop118
	i32.const	$push449=, 0
	i32.const	$push448=, 0
	i64.load	$push119=, src+8($pop448)
	i64.store	$drop=, dst+8($pop449), $pop119
	i32.const	$push447=, 0
	i32.const	$push446=, 0
	i64.load	$push120=, src($pop446)
	i64.store	$drop=, dst($pop447), $pop120
	i32.const	$push445=, dst
	i32.const	$push444=, src
	i32.const	$push121=, 23
	i32.call	$push122=, memcmp@FUNCTION, $pop445, $pop444, $pop121
	br_if   	0, $pop122      # 0: down to label3
# BB#22:                                # %check.exit256
	i32.const	$push463=, 0
	i32.const	$push462=, 0
	i64.load	$push123=, src+16($pop462)
	i64.store	$drop=, dst+16($pop463), $pop123
	i32.const	$push461=, 0
	i32.const	$push460=, 0
	i64.load	$push124=, src+8($pop460)
	i64.store	$drop=, dst+8($pop461), $pop124
	i32.const	$push459=, 0
	i32.const	$push458=, 0
	i64.load	$push125=, src($pop458)
	i64.store	$drop=, dst($pop459), $pop125
	i32.const	$push457=, dst
	i32.const	$push456=, src
	i32.const	$push126=, 24
	i32.call	$push127=, memcmp@FUNCTION, $pop457, $pop456, $pop126
	br_if   	0, $pop127      # 0: down to label3
# BB#23:                                # %check.exit260
	i32.const	$push473=, 0
	i32.const	$push472=, 0
	i32.load8_u	$push128=, src+24($pop472)
	i32.store8	$drop=, dst+24($pop473), $pop128
	i32.const	$push471=, 0
	i32.const	$push470=, 0
	i64.load	$push129=, src+16($pop470)
	i64.store	$drop=, dst+16($pop471), $pop129
	i32.const	$push469=, 0
	i32.const	$push468=, 0
	i64.load	$push130=, src+8($pop468)
	i64.store	$drop=, dst+8($pop469), $pop130
	i32.const	$push467=, 0
	i32.const	$push466=, 0
	i64.load	$push131=, src($pop466)
	i64.store	$drop=, dst($pop467), $pop131
	i32.const	$push465=, dst
	i32.const	$push464=, src
	i32.const	$push132=, 25
	i32.call	$push133=, memcmp@FUNCTION, $pop465, $pop464, $pop132
	br_if   	0, $pop133      # 0: down to label3
# BB#24:                                # %check.exit264
	i32.const	$push483=, 0
	i32.const	$push482=, 0
	i32.load16_u	$push134=, src+24($pop482)
	i32.store16	$drop=, dst+24($pop483), $pop134
	i32.const	$push481=, 0
	i32.const	$push480=, 0
	i64.load	$push135=, src+16($pop480)
	i64.store	$drop=, dst+16($pop481), $pop135
	i32.const	$push479=, 0
	i32.const	$push478=, 0
	i64.load	$push136=, src+8($pop478)
	i64.store	$drop=, dst+8($pop479), $pop136
	i32.const	$push477=, 0
	i32.const	$push476=, 0
	i64.load	$push137=, src($pop476)
	i64.store	$drop=, dst($pop477), $pop137
	i32.const	$push475=, dst
	i32.const	$push474=, src
	i32.const	$push138=, 26
	i32.call	$push139=, memcmp@FUNCTION, $pop475, $pop474, $pop138
	br_if   	0, $pop139      # 0: down to label3
# BB#25:                                # %check.exit268
	i32.const	$push495=, 0
	i32.const	$push494=, 0
	i32.load8_u	$push140=, src+26($pop494)
	i32.store8	$drop=, dst+26($pop495), $pop140
	i32.const	$push493=, 0
	i32.const	$push492=, 0
	i32.load16_u	$push141=, src+24($pop492)
	i32.store16	$drop=, dst+24($pop493), $pop141
	i32.const	$push491=, 0
	i32.const	$push490=, 0
	i64.load	$push142=, src+16($pop490)
	i64.store	$drop=, dst+16($pop491), $pop142
	i32.const	$push489=, 0
	i32.const	$push488=, 0
	i64.load	$push143=, src+8($pop488)
	i64.store	$drop=, dst+8($pop489), $pop143
	i32.const	$push487=, 0
	i32.const	$push486=, 0
	i64.load	$push144=, src($pop486)
	i64.store	$drop=, dst($pop487), $pop144
	i32.const	$push485=, dst
	i32.const	$push484=, src
	i32.const	$push145=, 27
	i32.call	$push146=, memcmp@FUNCTION, $pop485, $pop484, $pop145
	br_if   	0, $pop146      # 0: down to label3
# BB#26:                                # %check.exit272
	i32.const	$push505=, 0
	i32.const	$push504=, 0
	i32.load	$push147=, src+24($pop504)
	i32.store	$drop=, dst+24($pop505), $pop147
	i32.const	$push503=, 0
	i32.const	$push502=, 0
	i64.load	$push148=, src+16($pop502)
	i64.store	$drop=, dst+16($pop503), $pop148
	i32.const	$push501=, 0
	i32.const	$push500=, 0
	i64.load	$push149=, src+8($pop500)
	i64.store	$drop=, dst+8($pop501), $pop149
	i32.const	$push499=, 0
	i32.const	$push498=, 0
	i64.load	$push150=, src($pop498)
	i64.store	$drop=, dst($pop499), $pop150
	i32.const	$push497=, dst
	i32.const	$push496=, src
	i32.const	$push151=, 28
	i32.call	$push152=, memcmp@FUNCTION, $pop497, $pop496, $pop151
	br_if   	0, $pop152      # 0: down to label3
# BB#27:                                # %check.exit276
	i32.const	$push517=, 0
	i32.const	$push516=, 0
	i32.load8_u	$push153=, src+28($pop516)
	i32.store8	$drop=, dst+28($pop517), $pop153
	i32.const	$push515=, 0
	i32.const	$push514=, 0
	i32.load	$push154=, src+24($pop514)
	i32.store	$drop=, dst+24($pop515), $pop154
	i32.const	$push513=, 0
	i32.const	$push512=, 0
	i64.load	$push155=, src+16($pop512)
	i64.store	$drop=, dst+16($pop513), $pop155
	i32.const	$push511=, 0
	i32.const	$push510=, 0
	i64.load	$push156=, src+8($pop510)
	i64.store	$drop=, dst+8($pop511), $pop156
	i32.const	$push509=, 0
	i32.const	$push508=, 0
	i64.load	$push157=, src($pop508)
	i64.store	$drop=, dst($pop509), $pop157
	i32.const	$push507=, dst
	i32.const	$push506=, src
	i32.const	$push158=, 29
	i32.call	$push159=, memcmp@FUNCTION, $pop507, $pop506, $pop158
	br_if   	0, $pop159      # 0: down to label3
# BB#28:                                # %check.exit280
	i32.const	$push160=, 0
	i32.const	$push528=, 0
	i32.load16_u	$push161=, src+28($pop528)
	i32.store16	$drop=, dst+28($pop160), $pop161
	i32.const	$push527=, 0
	i32.const	$push526=, 0
	i32.load	$push162=, src+24($pop526)
	i32.store	$drop=, dst+24($pop527), $pop162
	i32.const	$push525=, 0
	i32.const	$push524=, 0
	i64.load	$push163=, src+16($pop524)
	i64.store	$drop=, dst+16($pop525), $pop163
	i32.const	$push523=, 0
	i32.const	$push522=, 0
	i64.load	$push164=, src+8($pop522)
	i64.store	$drop=, dst+8($pop523), $pop164
	i32.const	$push521=, 0
	i32.const	$push520=, 0
	i64.load	$push165=, src($pop520)
	i64.store	$drop=, dst($pop521), $pop165
	i32.const	$push519=, dst
	i32.const	$push518=, src
	i32.const	$push166=, 30
	i32.call	$push167=, memcmp@FUNCTION, $pop519, $pop518, $pop166
	br_if   	0, $pop167      # 0: down to label3
# BB#29:                                # %check.exit284
	i32.const	$push169=, dst
	i32.const	$push533=, src
	i32.const	$push168=, 31
	i32.call	$push532=, memcpy@FUNCTION, $pop169, $pop533, $pop168
	tee_local	$push531=, $0=, $pop532
	i32.const	$push530=, src
	i32.const	$push529=, 31
	i32.call	$push170=, memcmp@FUNCTION, $pop531, $pop530, $pop529
	br_if   	0, $pop170      # 0: down to label3
# BB#30:                                # %check.exit288
	i32.const	$push171=, 0
	i32.const	$push541=, 0
	i64.load	$push172=, src+24($pop541)
	i64.store	$drop=, dst+24($pop171), $pop172
	i32.const	$push540=, 0
	i32.const	$push539=, 0
	i64.load	$push173=, src+16($pop539)
	i64.store	$drop=, dst+16($pop540), $pop173
	i32.const	$push538=, 0
	i32.const	$push537=, 0
	i64.load	$push174=, src+8($pop537)
	i64.store	$drop=, dst+8($pop538), $pop174
	i32.const	$push536=, 0
	i32.const	$push535=, 0
	i64.load	$push175=, src($pop535)
	i64.store	$drop=, dst($pop536), $pop175
	i32.const	$push534=, src
	i32.const	$push176=, 32
	i32.call	$push177=, memcmp@FUNCTION, $0, $pop534, $pop176
	br_if   	0, $pop177      # 0: down to label3
# BB#31:                                # %check.exit292
	i32.const	$push179=, dst
	i32.const	$push546=, src
	i32.const	$push178=, 33
	i32.call	$push545=, memcpy@FUNCTION, $pop179, $pop546, $pop178
	tee_local	$push544=, $0=, $pop545
	i32.const	$push543=, src
	i32.const	$push542=, 33
	i32.call	$push180=, memcmp@FUNCTION, $pop544, $pop543, $pop542
	br_if   	0, $pop180      # 0: down to label3
# BB#32:                                # %check.exit296
	i32.const	$push549=, src
	i32.const	$push181=, 34
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop549, $pop181
	i32.const	$push548=, src
	i32.const	$push547=, 34
	i32.call	$push182=, memcmp@FUNCTION, $pop0, $pop548, $pop547
	br_if   	0, $pop182      # 0: down to label3
# BB#33:                                # %check.exit300
	i32.const	$push184=, dst
	i32.const	$push554=, src
	i32.const	$push183=, 35
	i32.call	$push553=, memcpy@FUNCTION, $pop184, $pop554, $pop183
	tee_local	$push552=, $0=, $pop553
	i32.const	$push551=, src
	i32.const	$push550=, 35
	i32.call	$push185=, memcmp@FUNCTION, $pop552, $pop551, $pop550
	br_if   	0, $pop185      # 0: down to label3
# BB#34:                                # %check.exit304
	i32.const	$push557=, src
	i32.const	$push186=, 36
	i32.call	$push1=, memcpy@FUNCTION, $0, $pop557, $pop186
	i32.const	$push556=, src
	i32.const	$push555=, 36
	i32.call	$push187=, memcmp@FUNCTION, $pop1, $pop556, $pop555
	br_if   	0, $pop187      # 0: down to label3
# BB#35:                                # %check.exit308
	i32.const	$push189=, dst
	i32.const	$push562=, src
	i32.const	$push188=, 37
	i32.call	$push561=, memcpy@FUNCTION, $pop189, $pop562, $pop188
	tee_local	$push560=, $0=, $pop561
	i32.const	$push559=, src
	i32.const	$push558=, 37
	i32.call	$push190=, memcmp@FUNCTION, $pop560, $pop559, $pop558
	br_if   	0, $pop190      # 0: down to label3
# BB#36:                                # %check.exit312
	i32.const	$push565=, src
	i32.const	$push191=, 38
	i32.call	$push2=, memcpy@FUNCTION, $0, $pop565, $pop191
	i32.const	$push564=, src
	i32.const	$push563=, 38
	i32.call	$push192=, memcmp@FUNCTION, $pop2, $pop564, $pop563
	br_if   	0, $pop192      # 0: down to label3
# BB#37:                                # %check.exit316
	i32.const	$push194=, dst
	i32.const	$push570=, src
	i32.const	$push193=, 39
	i32.call	$push569=, memcpy@FUNCTION, $pop194, $pop570, $pop193
	tee_local	$push568=, $0=, $pop569
	i32.const	$push567=, src
	i32.const	$push566=, 39
	i32.call	$push195=, memcmp@FUNCTION, $pop568, $pop567, $pop566
	br_if   	0, $pop195      # 0: down to label3
# BB#38:                                # %check.exit320
	i32.const	$push573=, src
	i32.const	$push196=, 40
	i32.call	$push3=, memcpy@FUNCTION, $0, $pop573, $pop196
	i32.const	$push572=, src
	i32.const	$push571=, 40
	i32.call	$push197=, memcmp@FUNCTION, $pop3, $pop572, $pop571
	br_if   	0, $pop197      # 0: down to label3
# BB#39:                                # %check.exit324
	i32.const	$push199=, dst
	i32.const	$push578=, src
	i32.const	$push198=, 41
	i32.call	$push577=, memcpy@FUNCTION, $pop199, $pop578, $pop198
	tee_local	$push576=, $0=, $pop577
	i32.const	$push575=, src
	i32.const	$push574=, 41
	i32.call	$push200=, memcmp@FUNCTION, $pop576, $pop575, $pop574
	br_if   	0, $pop200      # 0: down to label3
# BB#40:                                # %check.exit328
	i32.const	$push581=, src
	i32.const	$push201=, 42
	i32.call	$push4=, memcpy@FUNCTION, $0, $pop581, $pop201
	i32.const	$push580=, src
	i32.const	$push579=, 42
	i32.call	$push202=, memcmp@FUNCTION, $pop4, $pop580, $pop579
	br_if   	0, $pop202      # 0: down to label3
# BB#41:                                # %check.exit332
	i32.const	$push204=, dst
	i32.const	$push586=, src
	i32.const	$push203=, 43
	i32.call	$push585=, memcpy@FUNCTION, $pop204, $pop586, $pop203
	tee_local	$push584=, $0=, $pop585
	i32.const	$push583=, src
	i32.const	$push582=, 43
	i32.call	$push205=, memcmp@FUNCTION, $pop584, $pop583, $pop582
	br_if   	0, $pop205      # 0: down to label3
# BB#42:                                # %check.exit336
	i32.const	$push589=, src
	i32.const	$push206=, 44
	i32.call	$push5=, memcpy@FUNCTION, $0, $pop589, $pop206
	i32.const	$push588=, src
	i32.const	$push587=, 44
	i32.call	$push207=, memcmp@FUNCTION, $pop5, $pop588, $pop587
	br_if   	0, $pop207      # 0: down to label3
# BB#43:                                # %check.exit340
	i32.const	$push209=, dst
	i32.const	$push594=, src
	i32.const	$push208=, 45
	i32.call	$push593=, memcpy@FUNCTION, $pop209, $pop594, $pop208
	tee_local	$push592=, $0=, $pop593
	i32.const	$push591=, src
	i32.const	$push590=, 45
	i32.call	$push210=, memcmp@FUNCTION, $pop592, $pop591, $pop590
	br_if   	0, $pop210      # 0: down to label3
# BB#44:                                # %check.exit344
	i32.const	$push597=, src
	i32.const	$push211=, 46
	i32.call	$push6=, memcpy@FUNCTION, $0, $pop597, $pop211
	i32.const	$push596=, src
	i32.const	$push595=, 46
	i32.call	$push212=, memcmp@FUNCTION, $pop6, $pop596, $pop595
	br_if   	0, $pop212      # 0: down to label3
# BB#45:                                # %check.exit348
	i32.const	$push214=, dst
	i32.const	$push602=, src
	i32.const	$push213=, 47
	i32.call	$push601=, memcpy@FUNCTION, $pop214, $pop602, $pop213
	tee_local	$push600=, $0=, $pop601
	i32.const	$push599=, src
	i32.const	$push598=, 47
	i32.call	$push215=, memcmp@FUNCTION, $pop600, $pop599, $pop598
	br_if   	0, $pop215      # 0: down to label3
# BB#46:                                # %check.exit352
	i32.const	$push605=, src
	i32.const	$push216=, 48
	i32.call	$push7=, memcpy@FUNCTION, $0, $pop605, $pop216
	i32.const	$push604=, src
	i32.const	$push603=, 48
	i32.call	$push217=, memcmp@FUNCTION, $pop7, $pop604, $pop603
	br_if   	0, $pop217      # 0: down to label3
# BB#47:                                # %check.exit356
	i32.const	$push219=, dst
	i32.const	$push610=, src
	i32.const	$push218=, 49
	i32.call	$push609=, memcpy@FUNCTION, $pop219, $pop610, $pop218
	tee_local	$push608=, $0=, $pop609
	i32.const	$push607=, src
	i32.const	$push606=, 49
	i32.call	$push220=, memcmp@FUNCTION, $pop608, $pop607, $pop606
	br_if   	0, $pop220      # 0: down to label3
# BB#48:                                # %check.exit360
	i32.const	$push613=, src
	i32.const	$push221=, 50
	i32.call	$push8=, memcpy@FUNCTION, $0, $pop613, $pop221
	i32.const	$push612=, src
	i32.const	$push611=, 50
	i32.call	$push222=, memcmp@FUNCTION, $pop8, $pop612, $pop611
	br_if   	0, $pop222      # 0: down to label3
# BB#49:                                # %check.exit364
	i32.const	$push224=, dst
	i32.const	$push618=, src
	i32.const	$push223=, 51
	i32.call	$push617=, memcpy@FUNCTION, $pop224, $pop618, $pop223
	tee_local	$push616=, $0=, $pop617
	i32.const	$push615=, src
	i32.const	$push614=, 51
	i32.call	$push225=, memcmp@FUNCTION, $pop616, $pop615, $pop614
	br_if   	0, $pop225      # 0: down to label3
# BB#50:                                # %check.exit368
	i32.const	$push621=, src
	i32.const	$push226=, 52
	i32.call	$push9=, memcpy@FUNCTION, $0, $pop621, $pop226
	i32.const	$push620=, src
	i32.const	$push619=, 52
	i32.call	$push227=, memcmp@FUNCTION, $pop9, $pop620, $pop619
	br_if   	0, $pop227      # 0: down to label3
# BB#51:                                # %check.exit372
	i32.const	$push229=, dst
	i32.const	$push626=, src
	i32.const	$push228=, 53
	i32.call	$push625=, memcpy@FUNCTION, $pop229, $pop626, $pop228
	tee_local	$push624=, $0=, $pop625
	i32.const	$push623=, src
	i32.const	$push622=, 53
	i32.call	$push230=, memcmp@FUNCTION, $pop624, $pop623, $pop622
	br_if   	0, $pop230      # 0: down to label3
# BB#52:                                # %check.exit376
	i32.const	$push629=, src
	i32.const	$push231=, 54
	i32.call	$push10=, memcpy@FUNCTION, $0, $pop629, $pop231
	i32.const	$push628=, src
	i32.const	$push627=, 54
	i32.call	$push232=, memcmp@FUNCTION, $pop10, $pop628, $pop627
	br_if   	0, $pop232      # 0: down to label3
# BB#53:                                # %check.exit380
	i32.const	$push234=, dst
	i32.const	$push634=, src
	i32.const	$push233=, 55
	i32.call	$push633=, memcpy@FUNCTION, $pop234, $pop634, $pop233
	tee_local	$push632=, $0=, $pop633
	i32.const	$push631=, src
	i32.const	$push630=, 55
	i32.call	$push235=, memcmp@FUNCTION, $pop632, $pop631, $pop630
	br_if   	0, $pop235      # 0: down to label3
# BB#54:                                # %check.exit384
	i32.const	$push637=, src
	i32.const	$push236=, 56
	i32.call	$push11=, memcpy@FUNCTION, $0, $pop637, $pop236
	i32.const	$push636=, src
	i32.const	$push635=, 56
	i32.call	$push237=, memcmp@FUNCTION, $pop11, $pop636, $pop635
	br_if   	0, $pop237      # 0: down to label3
# BB#55:                                # %check.exit388
	i32.const	$push239=, dst
	i32.const	$push642=, src
	i32.const	$push238=, 57
	i32.call	$push641=, memcpy@FUNCTION, $pop239, $pop642, $pop238
	tee_local	$push640=, $0=, $pop641
	i32.const	$push639=, src
	i32.const	$push638=, 57
	i32.call	$push240=, memcmp@FUNCTION, $pop640, $pop639, $pop638
	br_if   	0, $pop240      # 0: down to label3
# BB#56:                                # %check.exit392
	i32.const	$push645=, src
	i32.const	$push241=, 58
	i32.call	$push12=, memcpy@FUNCTION, $0, $pop645, $pop241
	i32.const	$push644=, src
	i32.const	$push643=, 58
	i32.call	$push242=, memcmp@FUNCTION, $pop12, $pop644, $pop643
	br_if   	0, $pop242      # 0: down to label3
# BB#57:                                # %check.exit396
	i32.const	$push244=, dst
	i32.const	$push650=, src
	i32.const	$push243=, 59
	i32.call	$push649=, memcpy@FUNCTION, $pop244, $pop650, $pop243
	tee_local	$push648=, $0=, $pop649
	i32.const	$push647=, src
	i32.const	$push646=, 59
	i32.call	$push245=, memcmp@FUNCTION, $pop648, $pop647, $pop646
	br_if   	0, $pop245      # 0: down to label3
# BB#58:                                # %check.exit400
	i32.const	$push653=, src
	i32.const	$push246=, 60
	i32.call	$push13=, memcpy@FUNCTION, $0, $pop653, $pop246
	i32.const	$push652=, src
	i32.const	$push651=, 60
	i32.call	$push247=, memcmp@FUNCTION, $pop13, $pop652, $pop651
	br_if   	0, $pop247      # 0: down to label3
# BB#59:                                # %check.exit404
	i32.const	$push249=, dst
	i32.const	$push658=, src
	i32.const	$push248=, 61
	i32.call	$push657=, memcpy@FUNCTION, $pop249, $pop658, $pop248
	tee_local	$push656=, $0=, $pop657
	i32.const	$push655=, src
	i32.const	$push654=, 61
	i32.call	$push250=, memcmp@FUNCTION, $pop656, $pop655, $pop654
	br_if   	0, $pop250      # 0: down to label3
# BB#60:                                # %check.exit408
	i32.const	$push661=, src
	i32.const	$push251=, 62
	i32.call	$push14=, memcpy@FUNCTION, $0, $pop661, $pop251
	i32.const	$push660=, src
	i32.const	$push659=, 62
	i32.call	$push252=, memcmp@FUNCTION, $pop14, $pop660, $pop659
	br_if   	0, $pop252      # 0: down to label3
# BB#61:                                # %check.exit412
	i32.const	$push254=, dst
	i32.const	$push666=, src
	i32.const	$push253=, 63
	i32.call	$push665=, memcpy@FUNCTION, $pop254, $pop666, $pop253
	tee_local	$push664=, $0=, $pop665
	i32.const	$push663=, src
	i32.const	$push662=, 63
	i32.call	$push255=, memcmp@FUNCTION, $pop664, $pop663, $pop662
	br_if   	0, $pop255      # 0: down to label3
# BB#62:                                # %check.exit416
	i32.const	$push669=, src
	i32.const	$push256=, 64
	i32.call	$push15=, memcpy@FUNCTION, $0, $pop669, $pop256
	i32.const	$push668=, src
	i32.const	$push667=, 64
	i32.call	$push257=, memcmp@FUNCTION, $pop15, $pop668, $pop667
	br_if   	0, $pop257      # 0: down to label3
# BB#63:                                # %check.exit420
	i32.const	$push259=, dst
	i32.const	$push674=, src
	i32.const	$push258=, 65
	i32.call	$push673=, memcpy@FUNCTION, $pop259, $pop674, $pop258
	tee_local	$push672=, $0=, $pop673
	i32.const	$push671=, src
	i32.const	$push670=, 65
	i32.call	$push260=, memcmp@FUNCTION, $pop672, $pop671, $pop670
	br_if   	0, $pop260      # 0: down to label3
# BB#64:                                # %check.exit424
	i32.const	$push677=, src
	i32.const	$push261=, 66
	i32.call	$push16=, memcpy@FUNCTION, $0, $pop677, $pop261
	i32.const	$push676=, src
	i32.const	$push675=, 66
	i32.call	$push262=, memcmp@FUNCTION, $pop16, $pop676, $pop675
	br_if   	0, $pop262      # 0: down to label3
# BB#65:                                # %check.exit428
	i32.const	$push264=, dst
	i32.const	$push682=, src
	i32.const	$push263=, 67
	i32.call	$push681=, memcpy@FUNCTION, $pop264, $pop682, $pop263
	tee_local	$push680=, $0=, $pop681
	i32.const	$push679=, src
	i32.const	$push678=, 67
	i32.call	$push265=, memcmp@FUNCTION, $pop680, $pop679, $pop678
	br_if   	0, $pop265      # 0: down to label3
# BB#66:                                # %check.exit432
	i32.const	$push685=, src
	i32.const	$push266=, 68
	i32.call	$push17=, memcpy@FUNCTION, $0, $pop685, $pop266
	i32.const	$push684=, src
	i32.const	$push683=, 68
	i32.call	$push267=, memcmp@FUNCTION, $pop17, $pop684, $pop683
	br_if   	0, $pop267      # 0: down to label3
# BB#67:                                # %check.exit436
	i32.const	$push269=, dst
	i32.const	$push690=, src
	i32.const	$push268=, 69
	i32.call	$push689=, memcpy@FUNCTION, $pop269, $pop690, $pop268
	tee_local	$push688=, $0=, $pop689
	i32.const	$push687=, src
	i32.const	$push686=, 69
	i32.call	$push270=, memcmp@FUNCTION, $pop688, $pop687, $pop686
	br_if   	0, $pop270      # 0: down to label3
# BB#68:                                # %check.exit440
	i32.const	$push693=, src
	i32.const	$push271=, 70
	i32.call	$push18=, memcpy@FUNCTION, $0, $pop693, $pop271
	i32.const	$push692=, src
	i32.const	$push691=, 70
	i32.call	$push272=, memcmp@FUNCTION, $pop18, $pop692, $pop691
	br_if   	0, $pop272      # 0: down to label3
# BB#69:                                # %check.exit444
	i32.const	$push274=, dst
	i32.const	$push698=, src
	i32.const	$push273=, 71
	i32.call	$push697=, memcpy@FUNCTION, $pop274, $pop698, $pop273
	tee_local	$push696=, $0=, $pop697
	i32.const	$push695=, src
	i32.const	$push694=, 71
	i32.call	$push275=, memcmp@FUNCTION, $pop696, $pop695, $pop694
	br_if   	0, $pop275      # 0: down to label3
# BB#70:                                # %check.exit448
	i32.const	$push701=, src
	i32.const	$push276=, 72
	i32.call	$push19=, memcpy@FUNCTION, $0, $pop701, $pop276
	i32.const	$push700=, src
	i32.const	$push699=, 72
	i32.call	$push277=, memcmp@FUNCTION, $pop19, $pop700, $pop699
	br_if   	0, $pop277      # 0: down to label3
# BB#71:                                # %check.exit452
	i32.const	$push279=, dst
	i32.const	$push706=, src
	i32.const	$push278=, 73
	i32.call	$push705=, memcpy@FUNCTION, $pop279, $pop706, $pop278
	tee_local	$push704=, $0=, $pop705
	i32.const	$push703=, src
	i32.const	$push702=, 73
	i32.call	$push280=, memcmp@FUNCTION, $pop704, $pop703, $pop702
	br_if   	0, $pop280      # 0: down to label3
# BB#72:                                # %check.exit456
	i32.const	$push709=, src
	i32.const	$push281=, 74
	i32.call	$push20=, memcpy@FUNCTION, $0, $pop709, $pop281
	i32.const	$push708=, src
	i32.const	$push707=, 74
	i32.call	$push282=, memcmp@FUNCTION, $pop20, $pop708, $pop707
	br_if   	0, $pop282      # 0: down to label3
# BB#73:                                # %check.exit460
	i32.const	$push284=, dst
	i32.const	$push714=, src
	i32.const	$push283=, 75
	i32.call	$push713=, memcpy@FUNCTION, $pop284, $pop714, $pop283
	tee_local	$push712=, $0=, $pop713
	i32.const	$push711=, src
	i32.const	$push710=, 75
	i32.call	$push285=, memcmp@FUNCTION, $pop712, $pop711, $pop710
	br_if   	0, $pop285      # 0: down to label3
# BB#74:                                # %check.exit464
	i32.const	$push717=, src
	i32.const	$push286=, 76
	i32.call	$push21=, memcpy@FUNCTION, $0, $pop717, $pop286
	i32.const	$push716=, src
	i32.const	$push715=, 76
	i32.call	$push287=, memcmp@FUNCTION, $pop21, $pop716, $pop715
	br_if   	0, $pop287      # 0: down to label3
# BB#75:                                # %check.exit468
	i32.const	$push289=, dst
	i32.const	$push722=, src
	i32.const	$push288=, 77
	i32.call	$push721=, memcpy@FUNCTION, $pop289, $pop722, $pop288
	tee_local	$push720=, $0=, $pop721
	i32.const	$push719=, src
	i32.const	$push718=, 77
	i32.call	$push290=, memcmp@FUNCTION, $pop720, $pop719, $pop718
	br_if   	0, $pop290      # 0: down to label3
# BB#76:                                # %check.exit472
	i32.const	$push725=, src
	i32.const	$push291=, 78
	i32.call	$push22=, memcpy@FUNCTION, $0, $pop725, $pop291
	i32.const	$push724=, src
	i32.const	$push723=, 78
	i32.call	$push292=, memcmp@FUNCTION, $pop22, $pop724, $pop723
	br_if   	0, $pop292      # 0: down to label3
# BB#77:                                # %check.exit476
	i32.const	$push295=, dst
	i32.const	$push294=, src
	i32.const	$push293=, 79
	i32.call	$push23=, memcpy@FUNCTION, $pop295, $pop294, $pop293
	i32.const	$push727=, src
	i32.const	$push726=, 79
	i32.call	$push296=, memcmp@FUNCTION, $pop23, $pop727, $pop726
	br_if   	0, $pop296      # 0: down to label3
# BB#78:                                # %check.exit480
	i32.const	$push297=, 0
	return  	$pop297
.LBB1_79:                               # %if.then.i479
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 3.9.0 "
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
