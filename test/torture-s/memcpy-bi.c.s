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
	i32.const	$push305=, src
	i32.add 	$push24=, $0, $pop305
	i32.const	$push304=, 26
	i32.rem_u	$push25=, $0, $pop304
	i32.const	$push303=, 97
	i32.add 	$push26=, $pop25, $pop303
	i32.store8	$drop=, 0($pop24), $pop26
	i32.const	$push302=, 1
	i32.add 	$push301=, $0, $pop302
	tee_local	$push300=, $0=, $pop301
	i32.const	$push299=, 80
	i32.ne  	$push27=, $pop300, $pop299
	br_if   	0, $pop27       # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop                        # label2:
	i32.const	$push307=, 0
	i32.const	$push306=, 0
	i32.load16_u	$push28=, src($pop306)
	i32.store16	$drop=, dst($pop307), $pop28
	block
	i32.const	$push29=, 1
	i32.eqz 	$push730=, $pop29
	br_if   	0, $pop730      # 0: down to label3
# BB#3:                                 # %check.exit172
	i32.const	$push313=, 0
	i32.const	$push312=, 0
	i32.load8_u	$push30=, src+2($pop312)
	i32.store8	$drop=, dst+2($pop313), $pop30
	i32.const	$push311=, 0
	i32.const	$push310=, 0
	i32.load16_u	$push31=, src($pop310)
	i32.store16	$drop=, dst($pop311), $pop31
	i32.const	$push309=, dst
	i32.const	$push308=, src
	i32.const	$push32=, 3
	i32.call	$push33=, memcmp@FUNCTION, $pop309, $pop308, $pop32
	br_if   	0, $pop33       # 0: down to label3
# BB#4:                                 # %check.exit176
	i32.const	$push319=, 0
	i32.const	$push318=, 0
	i32.load8_u	$push34=, src+4($pop318)
	i32.store8	$drop=, dst+4($pop319), $pop34
	i32.const	$push317=, 0
	i32.const	$push316=, 0
	i32.load	$push35=, src($pop316)
	i32.store	$drop=, dst($pop317), $pop35
	i32.const	$push315=, dst
	i32.const	$push314=, src
	i32.const	$push36=, 5
	i32.call	$push37=, memcmp@FUNCTION, $pop315, $pop314, $pop36
	br_if   	0, $pop37       # 0: down to label3
# BB#5:                                 # %check.exit184
	i32.const	$push325=, 0
	i32.const	$push324=, 0
	i32.load16_u	$push38=, src+4($pop324)
	i32.store16	$drop=, dst+4($pop325), $pop38
	i32.const	$push323=, 0
	i32.const	$push322=, 0
	i32.load	$push39=, src($pop322)
	i32.store	$drop=, dst($pop323), $pop39
	i32.const	$push321=, dst
	i32.const	$push320=, src
	i32.const	$push40=, 6
	i32.call	$push41=, memcmp@FUNCTION, $pop321, $pop320, $pop40
	br_if   	0, $pop41       # 0: down to label3
# BB#6:                                 # %check.exit188
	i32.const	$push333=, 0
	i32.const	$push332=, 0
	i32.load8_u	$push42=, src+6($pop332)
	i32.store8	$drop=, dst+6($pop333), $pop42
	i32.const	$push331=, 0
	i32.const	$push330=, 0
	i32.load16_u	$push43=, src+4($pop330)
	i32.store16	$drop=, dst+4($pop331), $pop43
	i32.const	$push329=, 0
	i32.const	$push328=, 0
	i32.load	$push44=, src($pop328)
	i32.store	$drop=, dst($pop329), $pop44
	i32.const	$push327=, dst
	i32.const	$push326=, src
	i32.const	$push45=, 7
	i32.call	$push46=, memcmp@FUNCTION, $pop327, $pop326, $pop45
	br_if   	0, $pop46       # 0: down to label3
# BB#7:                                 # %check.exit192
	i32.const	$push339=, 0
	i32.const	$push338=, 0
	i32.load8_u	$push47=, src+8($pop338)
	i32.store8	$drop=, dst+8($pop339), $pop47
	i32.const	$push337=, 0
	i32.const	$push336=, 0
	i64.load	$push48=, src($pop336)
	i64.store	$drop=, dst($pop337), $pop48
	i32.const	$push335=, dst
	i32.const	$push334=, src
	i32.const	$push49=, 9
	i32.call	$push50=, memcmp@FUNCTION, $pop335, $pop334, $pop49
	br_if   	0, $pop50       # 0: down to label3
# BB#8:                                 # %check.exit200
	i32.const	$push345=, 0
	i32.const	$push344=, 0
	i32.load16_u	$push51=, src+8($pop344)
	i32.store16	$drop=, dst+8($pop345), $pop51
	i32.const	$push343=, 0
	i32.const	$push342=, 0
	i64.load	$push52=, src($pop342)
	i64.store	$drop=, dst($pop343), $pop52
	i32.const	$push341=, dst
	i32.const	$push340=, src
	i32.const	$push53=, 10
	i32.call	$push54=, memcmp@FUNCTION, $pop341, $pop340, $pop53
	br_if   	0, $pop54       # 0: down to label3
# BB#9:                                 # %check.exit204
	i32.const	$push353=, 0
	i32.const	$push352=, 0
	i32.load8_u	$push55=, src+10($pop352)
	i32.store8	$drop=, dst+10($pop353), $pop55
	i32.const	$push351=, 0
	i32.const	$push350=, 0
	i32.load16_u	$push56=, src+8($pop350)
	i32.store16	$drop=, dst+8($pop351), $pop56
	i32.const	$push349=, 0
	i32.const	$push348=, 0
	i64.load	$push57=, src($pop348)
	i64.store	$drop=, dst($pop349), $pop57
	i32.const	$push347=, dst
	i32.const	$push346=, src
	i32.const	$push58=, 11
	i32.call	$push59=, memcmp@FUNCTION, $pop347, $pop346, $pop58
	br_if   	0, $pop59       # 0: down to label3
# BB#10:                                # %check.exit208
	i32.const	$push359=, 0
	i32.const	$push358=, 0
	i32.load	$push60=, src+8($pop358)
	i32.store	$drop=, dst+8($pop359), $pop60
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i64.load	$push61=, src($pop356)
	i64.store	$drop=, dst($pop357), $pop61
	i32.const	$push355=, dst
	i32.const	$push354=, src
	i32.const	$push62=, 12
	i32.call	$push63=, memcmp@FUNCTION, $pop355, $pop354, $pop62
	br_if   	0, $pop63       # 0: down to label3
# BB#11:                                # %check.exit212
	i32.const	$push367=, 0
	i32.const	$push366=, 0
	i32.load8_u	$push64=, src+12($pop366)
	i32.store8	$drop=, dst+12($pop367), $pop64
	i32.const	$push365=, 0
	i32.const	$push364=, 0
	i32.load	$push65=, src+8($pop364)
	i32.store	$drop=, dst+8($pop365), $pop65
	i32.const	$push363=, 0
	i32.const	$push362=, 0
	i64.load	$push66=, src($pop362)
	i64.store	$drop=, dst($pop363), $pop66
	i32.const	$push361=, dst
	i32.const	$push360=, src
	i32.const	$push67=, 13
	i32.call	$push68=, memcmp@FUNCTION, $pop361, $pop360, $pop67
	br_if   	0, $pop68       # 0: down to label3
# BB#12:                                # %check.exit216
	i32.const	$push375=, 0
	i32.const	$push374=, 0
	i32.load16_u	$push69=, src+12($pop374)
	i32.store16	$drop=, dst+12($pop375), $pop69
	i32.const	$push373=, 0
	i32.const	$push372=, 0
	i32.load	$push70=, src+8($pop372)
	i32.store	$drop=, dst+8($pop373), $pop70
	i32.const	$push371=, 0
	i32.const	$push370=, 0
	i64.load	$push71=, src($pop370)
	i64.store	$drop=, dst($pop371), $pop71
	i32.const	$push369=, dst
	i32.const	$push368=, src
	i32.const	$push72=, 14
	i32.call	$push73=, memcmp@FUNCTION, $pop369, $pop368, $pop72
	br_if   	0, $pop73       # 0: down to label3
# BB#13:                                # %check.exit220
	i32.const	$push385=, 0
	i32.const	$push384=, 0
	i32.load8_u	$push74=, src+14($pop384)
	i32.store8	$drop=, dst+14($pop385), $pop74
	i32.const	$push383=, 0
	i32.const	$push382=, 0
	i32.load16_u	$push75=, src+12($pop382)
	i32.store16	$drop=, dst+12($pop383), $pop75
	i32.const	$push381=, 0
	i32.const	$push380=, 0
	i32.load	$push76=, src+8($pop380)
	i32.store	$drop=, dst+8($pop381), $pop76
	i32.const	$push379=, 0
	i32.const	$push378=, 0
	i64.load	$push77=, src($pop378)
	i64.store	$drop=, dst($pop379), $pop77
	i32.const	$push377=, dst
	i32.const	$push376=, src
	i32.const	$push78=, 15
	i32.call	$push79=, memcmp@FUNCTION, $pop377, $pop376, $pop78
	br_if   	0, $pop79       # 0: down to label3
# BB#14:                                # %check.exit224
	i32.const	$push391=, 0
	i32.const	$push390=, 0
	i64.load	$push80=, src+8($pop390)
	i64.store	$drop=, dst+8($pop391), $pop80
	i32.const	$push389=, 0
	i32.const	$push388=, 0
	i64.load	$push81=, src($pop388)
	i64.store	$drop=, dst($pop389), $pop81
	i32.const	$push387=, dst
	i32.const	$push386=, src
	i32.const	$push82=, 16
	i32.call	$push83=, memcmp@FUNCTION, $pop387, $pop386, $pop82
	br_if   	0, $pop83       # 0: down to label3
# BB#15:                                # %check.exit228
	i32.const	$push399=, 0
	i32.const	$push398=, 0
	i32.load8_u	$push84=, src+16($pop398)
	i32.store8	$drop=, dst+16($pop399), $pop84
	i32.const	$push397=, 0
	i32.const	$push396=, 0
	i64.load	$push85=, src+8($pop396)
	i64.store	$drop=, dst+8($pop397), $pop85
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i64.load	$push86=, src($pop394)
	i64.store	$drop=, dst($pop395), $pop86
	i32.const	$push393=, dst
	i32.const	$push392=, src
	i32.const	$push87=, 17
	i32.call	$push88=, memcmp@FUNCTION, $pop393, $pop392, $pop87
	br_if   	0, $pop88       # 0: down to label3
# BB#16:                                # %check.exit232
	i32.const	$push407=, 0
	i32.const	$push406=, 0
	i32.load16_u	$push89=, src+16($pop406)
	i32.store16	$drop=, dst+16($pop407), $pop89
	i32.const	$push405=, 0
	i32.const	$push404=, 0
	i64.load	$push90=, src+8($pop404)
	i64.store	$drop=, dst+8($pop405), $pop90
	i32.const	$push403=, 0
	i32.const	$push402=, 0
	i64.load	$push91=, src($pop402)
	i64.store	$drop=, dst($pop403), $pop91
	i32.const	$push401=, dst
	i32.const	$push400=, src
	i32.const	$push92=, 18
	i32.call	$push93=, memcmp@FUNCTION, $pop401, $pop400, $pop92
	br_if   	0, $pop93       # 0: down to label3
# BB#17:                                # %check.exit236
	i32.const	$push417=, 0
	i32.const	$push416=, 0
	i32.load8_u	$push94=, src+18($pop416)
	i32.store8	$drop=, dst+18($pop417), $pop94
	i32.const	$push415=, 0
	i32.const	$push414=, 0
	i32.load16_u	$push95=, src+16($pop414)
	i32.store16	$drop=, dst+16($pop415), $pop95
	i32.const	$push413=, 0
	i32.const	$push412=, 0
	i64.load	$push96=, src+8($pop412)
	i64.store	$drop=, dst+8($pop413), $pop96
	i32.const	$push411=, 0
	i32.const	$push410=, 0
	i64.load	$push97=, src($pop410)
	i64.store	$drop=, dst($pop411), $pop97
	i32.const	$push409=, dst
	i32.const	$push408=, src
	i32.const	$push98=, 19
	i32.call	$push99=, memcmp@FUNCTION, $pop409, $pop408, $pop98
	br_if   	0, $pop99       # 0: down to label3
# BB#18:                                # %check.exit240
	i32.const	$push425=, 0
	i32.const	$push424=, 0
	i32.load	$push100=, src+16($pop424)
	i32.store	$drop=, dst+16($pop425), $pop100
	i32.const	$push423=, 0
	i32.const	$push422=, 0
	i64.load	$push101=, src+8($pop422)
	i64.store	$drop=, dst+8($pop423), $pop101
	i32.const	$push421=, 0
	i32.const	$push420=, 0
	i64.load	$push102=, src($pop420)
	i64.store	$drop=, dst($pop421), $pop102
	i32.const	$push419=, dst
	i32.const	$push418=, src
	i32.const	$push103=, 20
	i32.call	$push104=, memcmp@FUNCTION, $pop419, $pop418, $pop103
	br_if   	0, $pop104      # 0: down to label3
# BB#19:                                # %check.exit244
	i32.const	$push435=, 0
	i32.const	$push434=, 0
	i32.load8_u	$push105=, src+20($pop434)
	i32.store8	$drop=, dst+20($pop435), $pop105
	i32.const	$push433=, 0
	i32.const	$push432=, 0
	i32.load	$push106=, src+16($pop432)
	i32.store	$drop=, dst+16($pop433), $pop106
	i32.const	$push431=, 0
	i32.const	$push430=, 0
	i64.load	$push107=, src+8($pop430)
	i64.store	$drop=, dst+8($pop431), $pop107
	i32.const	$push429=, 0
	i32.const	$push428=, 0
	i64.load	$push108=, src($pop428)
	i64.store	$drop=, dst($pop429), $pop108
	i32.const	$push427=, dst
	i32.const	$push426=, src
	i32.const	$push109=, 21
	i32.call	$push110=, memcmp@FUNCTION, $pop427, $pop426, $pop109
	br_if   	0, $pop110      # 0: down to label3
# BB#20:                                # %check.exit248
	i32.const	$push445=, 0
	i32.const	$push444=, 0
	i32.load16_u	$push111=, src+20($pop444)
	i32.store16	$drop=, dst+20($pop445), $pop111
	i32.const	$push443=, 0
	i32.const	$push442=, 0
	i32.load	$push112=, src+16($pop442)
	i32.store	$drop=, dst+16($pop443), $pop112
	i32.const	$push441=, 0
	i32.const	$push440=, 0
	i64.load	$push113=, src+8($pop440)
	i64.store	$drop=, dst+8($pop441), $pop113
	i32.const	$push439=, 0
	i32.const	$push438=, 0
	i64.load	$push114=, src($pop438)
	i64.store	$drop=, dst($pop439), $pop114
	i32.const	$push437=, dst
	i32.const	$push436=, src
	i32.const	$push115=, 22
	i32.call	$push116=, memcmp@FUNCTION, $pop437, $pop436, $pop115
	br_if   	0, $pop116      # 0: down to label3
# BB#21:                                # %check.exit252
	i32.const	$push457=, 0
	i32.const	$push456=, 0
	i32.load8_u	$push117=, src+22($pop456)
	i32.store8	$drop=, dst+22($pop457), $pop117
	i32.const	$push455=, 0
	i32.const	$push454=, 0
	i32.load16_u	$push118=, src+20($pop454)
	i32.store16	$drop=, dst+20($pop455), $pop118
	i32.const	$push453=, 0
	i32.const	$push452=, 0
	i32.load	$push119=, src+16($pop452)
	i32.store	$drop=, dst+16($pop453), $pop119
	i32.const	$push451=, 0
	i32.const	$push450=, 0
	i64.load	$push120=, src+8($pop450)
	i64.store	$drop=, dst+8($pop451), $pop120
	i32.const	$push449=, 0
	i32.const	$push448=, 0
	i64.load	$push121=, src($pop448)
	i64.store	$drop=, dst($pop449), $pop121
	i32.const	$push447=, dst
	i32.const	$push446=, src
	i32.const	$push122=, 23
	i32.call	$push123=, memcmp@FUNCTION, $pop447, $pop446, $pop122
	br_if   	0, $pop123      # 0: down to label3
# BB#22:                                # %check.exit256
	i32.const	$push465=, 0
	i32.const	$push464=, 0
	i64.load	$push124=, src+16($pop464)
	i64.store	$drop=, dst+16($pop465), $pop124
	i32.const	$push463=, 0
	i32.const	$push462=, 0
	i64.load	$push125=, src+8($pop462)
	i64.store	$drop=, dst+8($pop463), $pop125
	i32.const	$push461=, 0
	i32.const	$push460=, 0
	i64.load	$push126=, src($pop460)
	i64.store	$drop=, dst($pop461), $pop126
	i32.const	$push459=, dst
	i32.const	$push458=, src
	i32.const	$push127=, 24
	i32.call	$push128=, memcmp@FUNCTION, $pop459, $pop458, $pop127
	br_if   	0, $pop128      # 0: down to label3
# BB#23:                                # %check.exit260
	i32.const	$push475=, 0
	i32.const	$push474=, 0
	i32.load8_u	$push129=, src+24($pop474)
	i32.store8	$drop=, dst+24($pop475), $pop129
	i32.const	$push473=, 0
	i32.const	$push472=, 0
	i64.load	$push130=, src+16($pop472)
	i64.store	$drop=, dst+16($pop473), $pop130
	i32.const	$push471=, 0
	i32.const	$push470=, 0
	i64.load	$push131=, src+8($pop470)
	i64.store	$drop=, dst+8($pop471), $pop131
	i32.const	$push469=, 0
	i32.const	$push468=, 0
	i64.load	$push132=, src($pop468)
	i64.store	$drop=, dst($pop469), $pop132
	i32.const	$push467=, dst
	i32.const	$push466=, src
	i32.const	$push133=, 25
	i32.call	$push134=, memcmp@FUNCTION, $pop467, $pop466, $pop133
	br_if   	0, $pop134      # 0: down to label3
# BB#24:                                # %check.exit264
	i32.const	$push485=, 0
	i32.const	$push484=, 0
	i32.load16_u	$push135=, src+24($pop484)
	i32.store16	$drop=, dst+24($pop485), $pop135
	i32.const	$push483=, 0
	i32.const	$push482=, 0
	i64.load	$push136=, src+16($pop482)
	i64.store	$drop=, dst+16($pop483), $pop136
	i32.const	$push481=, 0
	i32.const	$push480=, 0
	i64.load	$push137=, src+8($pop480)
	i64.store	$drop=, dst+8($pop481), $pop137
	i32.const	$push479=, 0
	i32.const	$push478=, 0
	i64.load	$push138=, src($pop478)
	i64.store	$drop=, dst($pop479), $pop138
	i32.const	$push477=, dst
	i32.const	$push476=, src
	i32.const	$push139=, 26
	i32.call	$push140=, memcmp@FUNCTION, $pop477, $pop476, $pop139
	br_if   	0, $pop140      # 0: down to label3
# BB#25:                                # %check.exit268
	i32.const	$push497=, 0
	i32.const	$push496=, 0
	i32.load8_u	$push141=, src+26($pop496)
	i32.store8	$drop=, dst+26($pop497), $pop141
	i32.const	$push495=, 0
	i32.const	$push494=, 0
	i32.load16_u	$push142=, src+24($pop494)
	i32.store16	$drop=, dst+24($pop495), $pop142
	i32.const	$push493=, 0
	i32.const	$push492=, 0
	i64.load	$push143=, src+16($pop492)
	i64.store	$drop=, dst+16($pop493), $pop143
	i32.const	$push491=, 0
	i32.const	$push490=, 0
	i64.load	$push144=, src+8($pop490)
	i64.store	$drop=, dst+8($pop491), $pop144
	i32.const	$push489=, 0
	i32.const	$push488=, 0
	i64.load	$push145=, src($pop488)
	i64.store	$drop=, dst($pop489), $pop145
	i32.const	$push487=, dst
	i32.const	$push486=, src
	i32.const	$push146=, 27
	i32.call	$push147=, memcmp@FUNCTION, $pop487, $pop486, $pop146
	br_if   	0, $pop147      # 0: down to label3
# BB#26:                                # %check.exit272
	i32.const	$push507=, 0
	i32.const	$push506=, 0
	i32.load	$push148=, src+24($pop506)
	i32.store	$drop=, dst+24($pop507), $pop148
	i32.const	$push505=, 0
	i32.const	$push504=, 0
	i64.load	$push149=, src+16($pop504)
	i64.store	$drop=, dst+16($pop505), $pop149
	i32.const	$push503=, 0
	i32.const	$push502=, 0
	i64.load	$push150=, src+8($pop502)
	i64.store	$drop=, dst+8($pop503), $pop150
	i32.const	$push501=, 0
	i32.const	$push500=, 0
	i64.load	$push151=, src($pop500)
	i64.store	$drop=, dst($pop501), $pop151
	i32.const	$push499=, dst
	i32.const	$push498=, src
	i32.const	$push152=, 28
	i32.call	$push153=, memcmp@FUNCTION, $pop499, $pop498, $pop152
	br_if   	0, $pop153      # 0: down to label3
# BB#27:                                # %check.exit276
	i32.const	$push519=, 0
	i32.const	$push518=, 0
	i32.load8_u	$push154=, src+28($pop518)
	i32.store8	$drop=, dst+28($pop519), $pop154
	i32.const	$push517=, 0
	i32.const	$push516=, 0
	i32.load	$push155=, src+24($pop516)
	i32.store	$drop=, dst+24($pop517), $pop155
	i32.const	$push515=, 0
	i32.const	$push514=, 0
	i64.load	$push156=, src+16($pop514)
	i64.store	$drop=, dst+16($pop515), $pop156
	i32.const	$push513=, 0
	i32.const	$push512=, 0
	i64.load	$push157=, src+8($pop512)
	i64.store	$drop=, dst+8($pop513), $pop157
	i32.const	$push511=, 0
	i32.const	$push510=, 0
	i64.load	$push158=, src($pop510)
	i64.store	$drop=, dst($pop511), $pop158
	i32.const	$push509=, dst
	i32.const	$push508=, src
	i32.const	$push159=, 29
	i32.call	$push160=, memcmp@FUNCTION, $pop509, $pop508, $pop159
	br_if   	0, $pop160      # 0: down to label3
# BB#28:                                # %check.exit280
	i32.const	$push161=, 0
	i32.const	$push530=, 0
	i32.load16_u	$push162=, src+28($pop530)
	i32.store16	$drop=, dst+28($pop161), $pop162
	i32.const	$push529=, 0
	i32.const	$push528=, 0
	i32.load	$push163=, src+24($pop528)
	i32.store	$drop=, dst+24($pop529), $pop163
	i32.const	$push527=, 0
	i32.const	$push526=, 0
	i64.load	$push164=, src+16($pop526)
	i64.store	$drop=, dst+16($pop527), $pop164
	i32.const	$push525=, 0
	i32.const	$push524=, 0
	i64.load	$push165=, src+8($pop524)
	i64.store	$drop=, dst+8($pop525), $pop165
	i32.const	$push523=, 0
	i32.const	$push522=, 0
	i64.load	$push166=, src($pop522)
	i64.store	$drop=, dst($pop523), $pop166
	i32.const	$push521=, dst
	i32.const	$push520=, src
	i32.const	$push167=, 30
	i32.call	$push168=, memcmp@FUNCTION, $pop521, $pop520, $pop167
	br_if   	0, $pop168      # 0: down to label3
# BB#29:                                # %check.exit284
	i32.const	$push170=, dst
	i32.const	$push535=, src
	i32.const	$push169=, 31
	i32.call	$push534=, memcpy@FUNCTION, $pop170, $pop535, $pop169
	tee_local	$push533=, $0=, $pop534
	i32.const	$push532=, src
	i32.const	$push531=, 31
	i32.call	$push171=, memcmp@FUNCTION, $pop533, $pop532, $pop531
	br_if   	0, $pop171      # 0: down to label3
# BB#30:                                # %check.exit288
	i32.const	$push172=, 0
	i32.const	$push543=, 0
	i64.load	$push173=, src+24($pop543)
	i64.store	$drop=, dst+24($pop172), $pop173
	i32.const	$push542=, 0
	i32.const	$push541=, 0
	i64.load	$push174=, src+16($pop541)
	i64.store	$drop=, dst+16($pop542), $pop174
	i32.const	$push540=, 0
	i32.const	$push539=, 0
	i64.load	$push175=, src+8($pop539)
	i64.store	$drop=, dst+8($pop540), $pop175
	i32.const	$push538=, 0
	i32.const	$push537=, 0
	i64.load	$push176=, src($pop537)
	i64.store	$drop=, dst($pop538), $pop176
	i32.const	$push536=, src
	i32.const	$push177=, 32
	i32.call	$push178=, memcmp@FUNCTION, $0, $pop536, $pop177
	br_if   	0, $pop178      # 0: down to label3
# BB#31:                                # %check.exit292
	i32.const	$push180=, dst
	i32.const	$push548=, src
	i32.const	$push179=, 33
	i32.call	$push547=, memcpy@FUNCTION, $pop180, $pop548, $pop179
	tee_local	$push546=, $0=, $pop547
	i32.const	$push545=, src
	i32.const	$push544=, 33
	i32.call	$push181=, memcmp@FUNCTION, $pop546, $pop545, $pop544
	br_if   	0, $pop181      # 0: down to label3
# BB#32:                                # %check.exit296
	i32.const	$push551=, src
	i32.const	$push182=, 34
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop551, $pop182
	i32.const	$push550=, src
	i32.const	$push549=, 34
	i32.call	$push183=, memcmp@FUNCTION, $pop0, $pop550, $pop549
	br_if   	0, $pop183      # 0: down to label3
# BB#33:                                # %check.exit300
	i32.const	$push185=, dst
	i32.const	$push556=, src
	i32.const	$push184=, 35
	i32.call	$push555=, memcpy@FUNCTION, $pop185, $pop556, $pop184
	tee_local	$push554=, $0=, $pop555
	i32.const	$push553=, src
	i32.const	$push552=, 35
	i32.call	$push186=, memcmp@FUNCTION, $pop554, $pop553, $pop552
	br_if   	0, $pop186      # 0: down to label3
# BB#34:                                # %check.exit304
	i32.const	$push559=, src
	i32.const	$push187=, 36
	i32.call	$push1=, memcpy@FUNCTION, $0, $pop559, $pop187
	i32.const	$push558=, src
	i32.const	$push557=, 36
	i32.call	$push188=, memcmp@FUNCTION, $pop1, $pop558, $pop557
	br_if   	0, $pop188      # 0: down to label3
# BB#35:                                # %check.exit308
	i32.const	$push190=, dst
	i32.const	$push564=, src
	i32.const	$push189=, 37
	i32.call	$push563=, memcpy@FUNCTION, $pop190, $pop564, $pop189
	tee_local	$push562=, $0=, $pop563
	i32.const	$push561=, src
	i32.const	$push560=, 37
	i32.call	$push191=, memcmp@FUNCTION, $pop562, $pop561, $pop560
	br_if   	0, $pop191      # 0: down to label3
# BB#36:                                # %check.exit312
	i32.const	$push567=, src
	i32.const	$push192=, 38
	i32.call	$push2=, memcpy@FUNCTION, $0, $pop567, $pop192
	i32.const	$push566=, src
	i32.const	$push565=, 38
	i32.call	$push193=, memcmp@FUNCTION, $pop2, $pop566, $pop565
	br_if   	0, $pop193      # 0: down to label3
# BB#37:                                # %check.exit316
	i32.const	$push195=, dst
	i32.const	$push572=, src
	i32.const	$push194=, 39
	i32.call	$push571=, memcpy@FUNCTION, $pop195, $pop572, $pop194
	tee_local	$push570=, $0=, $pop571
	i32.const	$push569=, src
	i32.const	$push568=, 39
	i32.call	$push196=, memcmp@FUNCTION, $pop570, $pop569, $pop568
	br_if   	0, $pop196      # 0: down to label3
# BB#38:                                # %check.exit320
	i32.const	$push575=, src
	i32.const	$push197=, 40
	i32.call	$push3=, memcpy@FUNCTION, $0, $pop575, $pop197
	i32.const	$push574=, src
	i32.const	$push573=, 40
	i32.call	$push198=, memcmp@FUNCTION, $pop3, $pop574, $pop573
	br_if   	0, $pop198      # 0: down to label3
# BB#39:                                # %check.exit324
	i32.const	$push200=, dst
	i32.const	$push580=, src
	i32.const	$push199=, 41
	i32.call	$push579=, memcpy@FUNCTION, $pop200, $pop580, $pop199
	tee_local	$push578=, $0=, $pop579
	i32.const	$push577=, src
	i32.const	$push576=, 41
	i32.call	$push201=, memcmp@FUNCTION, $pop578, $pop577, $pop576
	br_if   	0, $pop201      # 0: down to label3
# BB#40:                                # %check.exit328
	i32.const	$push583=, src
	i32.const	$push202=, 42
	i32.call	$push4=, memcpy@FUNCTION, $0, $pop583, $pop202
	i32.const	$push582=, src
	i32.const	$push581=, 42
	i32.call	$push203=, memcmp@FUNCTION, $pop4, $pop582, $pop581
	br_if   	0, $pop203      # 0: down to label3
# BB#41:                                # %check.exit332
	i32.const	$push205=, dst
	i32.const	$push588=, src
	i32.const	$push204=, 43
	i32.call	$push587=, memcpy@FUNCTION, $pop205, $pop588, $pop204
	tee_local	$push586=, $0=, $pop587
	i32.const	$push585=, src
	i32.const	$push584=, 43
	i32.call	$push206=, memcmp@FUNCTION, $pop586, $pop585, $pop584
	br_if   	0, $pop206      # 0: down to label3
# BB#42:                                # %check.exit336
	i32.const	$push591=, src
	i32.const	$push207=, 44
	i32.call	$push5=, memcpy@FUNCTION, $0, $pop591, $pop207
	i32.const	$push590=, src
	i32.const	$push589=, 44
	i32.call	$push208=, memcmp@FUNCTION, $pop5, $pop590, $pop589
	br_if   	0, $pop208      # 0: down to label3
# BB#43:                                # %check.exit340
	i32.const	$push210=, dst
	i32.const	$push596=, src
	i32.const	$push209=, 45
	i32.call	$push595=, memcpy@FUNCTION, $pop210, $pop596, $pop209
	tee_local	$push594=, $0=, $pop595
	i32.const	$push593=, src
	i32.const	$push592=, 45
	i32.call	$push211=, memcmp@FUNCTION, $pop594, $pop593, $pop592
	br_if   	0, $pop211      # 0: down to label3
# BB#44:                                # %check.exit344
	i32.const	$push599=, src
	i32.const	$push212=, 46
	i32.call	$push6=, memcpy@FUNCTION, $0, $pop599, $pop212
	i32.const	$push598=, src
	i32.const	$push597=, 46
	i32.call	$push213=, memcmp@FUNCTION, $pop6, $pop598, $pop597
	br_if   	0, $pop213      # 0: down to label3
# BB#45:                                # %check.exit348
	i32.const	$push215=, dst
	i32.const	$push604=, src
	i32.const	$push214=, 47
	i32.call	$push603=, memcpy@FUNCTION, $pop215, $pop604, $pop214
	tee_local	$push602=, $0=, $pop603
	i32.const	$push601=, src
	i32.const	$push600=, 47
	i32.call	$push216=, memcmp@FUNCTION, $pop602, $pop601, $pop600
	br_if   	0, $pop216      # 0: down to label3
# BB#46:                                # %check.exit352
	i32.const	$push607=, src
	i32.const	$push217=, 48
	i32.call	$push7=, memcpy@FUNCTION, $0, $pop607, $pop217
	i32.const	$push606=, src
	i32.const	$push605=, 48
	i32.call	$push218=, memcmp@FUNCTION, $pop7, $pop606, $pop605
	br_if   	0, $pop218      # 0: down to label3
# BB#47:                                # %check.exit356
	i32.const	$push220=, dst
	i32.const	$push612=, src
	i32.const	$push219=, 49
	i32.call	$push611=, memcpy@FUNCTION, $pop220, $pop612, $pop219
	tee_local	$push610=, $0=, $pop611
	i32.const	$push609=, src
	i32.const	$push608=, 49
	i32.call	$push221=, memcmp@FUNCTION, $pop610, $pop609, $pop608
	br_if   	0, $pop221      # 0: down to label3
# BB#48:                                # %check.exit360
	i32.const	$push615=, src
	i32.const	$push222=, 50
	i32.call	$push8=, memcpy@FUNCTION, $0, $pop615, $pop222
	i32.const	$push614=, src
	i32.const	$push613=, 50
	i32.call	$push223=, memcmp@FUNCTION, $pop8, $pop614, $pop613
	br_if   	0, $pop223      # 0: down to label3
# BB#49:                                # %check.exit364
	i32.const	$push225=, dst
	i32.const	$push620=, src
	i32.const	$push224=, 51
	i32.call	$push619=, memcpy@FUNCTION, $pop225, $pop620, $pop224
	tee_local	$push618=, $0=, $pop619
	i32.const	$push617=, src
	i32.const	$push616=, 51
	i32.call	$push226=, memcmp@FUNCTION, $pop618, $pop617, $pop616
	br_if   	0, $pop226      # 0: down to label3
# BB#50:                                # %check.exit368
	i32.const	$push623=, src
	i32.const	$push227=, 52
	i32.call	$push9=, memcpy@FUNCTION, $0, $pop623, $pop227
	i32.const	$push622=, src
	i32.const	$push621=, 52
	i32.call	$push228=, memcmp@FUNCTION, $pop9, $pop622, $pop621
	br_if   	0, $pop228      # 0: down to label3
# BB#51:                                # %check.exit372
	i32.const	$push230=, dst
	i32.const	$push628=, src
	i32.const	$push229=, 53
	i32.call	$push627=, memcpy@FUNCTION, $pop230, $pop628, $pop229
	tee_local	$push626=, $0=, $pop627
	i32.const	$push625=, src
	i32.const	$push624=, 53
	i32.call	$push231=, memcmp@FUNCTION, $pop626, $pop625, $pop624
	br_if   	0, $pop231      # 0: down to label3
# BB#52:                                # %check.exit376
	i32.const	$push631=, src
	i32.const	$push232=, 54
	i32.call	$push10=, memcpy@FUNCTION, $0, $pop631, $pop232
	i32.const	$push630=, src
	i32.const	$push629=, 54
	i32.call	$push233=, memcmp@FUNCTION, $pop10, $pop630, $pop629
	br_if   	0, $pop233      # 0: down to label3
# BB#53:                                # %check.exit380
	i32.const	$push235=, dst
	i32.const	$push636=, src
	i32.const	$push234=, 55
	i32.call	$push635=, memcpy@FUNCTION, $pop235, $pop636, $pop234
	tee_local	$push634=, $0=, $pop635
	i32.const	$push633=, src
	i32.const	$push632=, 55
	i32.call	$push236=, memcmp@FUNCTION, $pop634, $pop633, $pop632
	br_if   	0, $pop236      # 0: down to label3
# BB#54:                                # %check.exit384
	i32.const	$push639=, src
	i32.const	$push237=, 56
	i32.call	$push11=, memcpy@FUNCTION, $0, $pop639, $pop237
	i32.const	$push638=, src
	i32.const	$push637=, 56
	i32.call	$push238=, memcmp@FUNCTION, $pop11, $pop638, $pop637
	br_if   	0, $pop238      # 0: down to label3
# BB#55:                                # %check.exit388
	i32.const	$push240=, dst
	i32.const	$push644=, src
	i32.const	$push239=, 57
	i32.call	$push643=, memcpy@FUNCTION, $pop240, $pop644, $pop239
	tee_local	$push642=, $0=, $pop643
	i32.const	$push641=, src
	i32.const	$push640=, 57
	i32.call	$push241=, memcmp@FUNCTION, $pop642, $pop641, $pop640
	br_if   	0, $pop241      # 0: down to label3
# BB#56:                                # %check.exit392
	i32.const	$push647=, src
	i32.const	$push242=, 58
	i32.call	$push12=, memcpy@FUNCTION, $0, $pop647, $pop242
	i32.const	$push646=, src
	i32.const	$push645=, 58
	i32.call	$push243=, memcmp@FUNCTION, $pop12, $pop646, $pop645
	br_if   	0, $pop243      # 0: down to label3
# BB#57:                                # %check.exit396
	i32.const	$push245=, dst
	i32.const	$push652=, src
	i32.const	$push244=, 59
	i32.call	$push651=, memcpy@FUNCTION, $pop245, $pop652, $pop244
	tee_local	$push650=, $0=, $pop651
	i32.const	$push649=, src
	i32.const	$push648=, 59
	i32.call	$push246=, memcmp@FUNCTION, $pop650, $pop649, $pop648
	br_if   	0, $pop246      # 0: down to label3
# BB#58:                                # %check.exit400
	i32.const	$push655=, src
	i32.const	$push247=, 60
	i32.call	$push13=, memcpy@FUNCTION, $0, $pop655, $pop247
	i32.const	$push654=, src
	i32.const	$push653=, 60
	i32.call	$push248=, memcmp@FUNCTION, $pop13, $pop654, $pop653
	br_if   	0, $pop248      # 0: down to label3
# BB#59:                                # %check.exit404
	i32.const	$push250=, dst
	i32.const	$push660=, src
	i32.const	$push249=, 61
	i32.call	$push659=, memcpy@FUNCTION, $pop250, $pop660, $pop249
	tee_local	$push658=, $0=, $pop659
	i32.const	$push657=, src
	i32.const	$push656=, 61
	i32.call	$push251=, memcmp@FUNCTION, $pop658, $pop657, $pop656
	br_if   	0, $pop251      # 0: down to label3
# BB#60:                                # %check.exit408
	i32.const	$push663=, src
	i32.const	$push252=, 62
	i32.call	$push14=, memcpy@FUNCTION, $0, $pop663, $pop252
	i32.const	$push662=, src
	i32.const	$push661=, 62
	i32.call	$push253=, memcmp@FUNCTION, $pop14, $pop662, $pop661
	br_if   	0, $pop253      # 0: down to label3
# BB#61:                                # %check.exit412
	i32.const	$push255=, dst
	i32.const	$push668=, src
	i32.const	$push254=, 63
	i32.call	$push667=, memcpy@FUNCTION, $pop255, $pop668, $pop254
	tee_local	$push666=, $0=, $pop667
	i32.const	$push665=, src
	i32.const	$push664=, 63
	i32.call	$push256=, memcmp@FUNCTION, $pop666, $pop665, $pop664
	br_if   	0, $pop256      # 0: down to label3
# BB#62:                                # %check.exit416
	i32.const	$push671=, src
	i32.const	$push257=, 64
	i32.call	$push15=, memcpy@FUNCTION, $0, $pop671, $pop257
	i32.const	$push670=, src
	i32.const	$push669=, 64
	i32.call	$push258=, memcmp@FUNCTION, $pop15, $pop670, $pop669
	br_if   	0, $pop258      # 0: down to label3
# BB#63:                                # %check.exit420
	i32.const	$push260=, dst
	i32.const	$push676=, src
	i32.const	$push259=, 65
	i32.call	$push675=, memcpy@FUNCTION, $pop260, $pop676, $pop259
	tee_local	$push674=, $0=, $pop675
	i32.const	$push673=, src
	i32.const	$push672=, 65
	i32.call	$push261=, memcmp@FUNCTION, $pop674, $pop673, $pop672
	br_if   	0, $pop261      # 0: down to label3
# BB#64:                                # %check.exit424
	i32.const	$push679=, src
	i32.const	$push262=, 66
	i32.call	$push16=, memcpy@FUNCTION, $0, $pop679, $pop262
	i32.const	$push678=, src
	i32.const	$push677=, 66
	i32.call	$push263=, memcmp@FUNCTION, $pop16, $pop678, $pop677
	br_if   	0, $pop263      # 0: down to label3
# BB#65:                                # %check.exit428
	i32.const	$push265=, dst
	i32.const	$push684=, src
	i32.const	$push264=, 67
	i32.call	$push683=, memcpy@FUNCTION, $pop265, $pop684, $pop264
	tee_local	$push682=, $0=, $pop683
	i32.const	$push681=, src
	i32.const	$push680=, 67
	i32.call	$push266=, memcmp@FUNCTION, $pop682, $pop681, $pop680
	br_if   	0, $pop266      # 0: down to label3
# BB#66:                                # %check.exit432
	i32.const	$push687=, src
	i32.const	$push267=, 68
	i32.call	$push17=, memcpy@FUNCTION, $0, $pop687, $pop267
	i32.const	$push686=, src
	i32.const	$push685=, 68
	i32.call	$push268=, memcmp@FUNCTION, $pop17, $pop686, $pop685
	br_if   	0, $pop268      # 0: down to label3
# BB#67:                                # %check.exit436
	i32.const	$push270=, dst
	i32.const	$push692=, src
	i32.const	$push269=, 69
	i32.call	$push691=, memcpy@FUNCTION, $pop270, $pop692, $pop269
	tee_local	$push690=, $0=, $pop691
	i32.const	$push689=, src
	i32.const	$push688=, 69
	i32.call	$push271=, memcmp@FUNCTION, $pop690, $pop689, $pop688
	br_if   	0, $pop271      # 0: down to label3
# BB#68:                                # %check.exit440
	i32.const	$push695=, src
	i32.const	$push272=, 70
	i32.call	$push18=, memcpy@FUNCTION, $0, $pop695, $pop272
	i32.const	$push694=, src
	i32.const	$push693=, 70
	i32.call	$push273=, memcmp@FUNCTION, $pop18, $pop694, $pop693
	br_if   	0, $pop273      # 0: down to label3
# BB#69:                                # %check.exit444
	i32.const	$push275=, dst
	i32.const	$push700=, src
	i32.const	$push274=, 71
	i32.call	$push699=, memcpy@FUNCTION, $pop275, $pop700, $pop274
	tee_local	$push698=, $0=, $pop699
	i32.const	$push697=, src
	i32.const	$push696=, 71
	i32.call	$push276=, memcmp@FUNCTION, $pop698, $pop697, $pop696
	br_if   	0, $pop276      # 0: down to label3
# BB#70:                                # %check.exit448
	i32.const	$push703=, src
	i32.const	$push277=, 72
	i32.call	$push19=, memcpy@FUNCTION, $0, $pop703, $pop277
	i32.const	$push702=, src
	i32.const	$push701=, 72
	i32.call	$push278=, memcmp@FUNCTION, $pop19, $pop702, $pop701
	br_if   	0, $pop278      # 0: down to label3
# BB#71:                                # %check.exit452
	i32.const	$push280=, dst
	i32.const	$push708=, src
	i32.const	$push279=, 73
	i32.call	$push707=, memcpy@FUNCTION, $pop280, $pop708, $pop279
	tee_local	$push706=, $0=, $pop707
	i32.const	$push705=, src
	i32.const	$push704=, 73
	i32.call	$push281=, memcmp@FUNCTION, $pop706, $pop705, $pop704
	br_if   	0, $pop281      # 0: down to label3
# BB#72:                                # %check.exit456
	i32.const	$push711=, src
	i32.const	$push282=, 74
	i32.call	$push20=, memcpy@FUNCTION, $0, $pop711, $pop282
	i32.const	$push710=, src
	i32.const	$push709=, 74
	i32.call	$push283=, memcmp@FUNCTION, $pop20, $pop710, $pop709
	br_if   	0, $pop283      # 0: down to label3
# BB#73:                                # %check.exit460
	i32.const	$push285=, dst
	i32.const	$push716=, src
	i32.const	$push284=, 75
	i32.call	$push715=, memcpy@FUNCTION, $pop285, $pop716, $pop284
	tee_local	$push714=, $0=, $pop715
	i32.const	$push713=, src
	i32.const	$push712=, 75
	i32.call	$push286=, memcmp@FUNCTION, $pop714, $pop713, $pop712
	br_if   	0, $pop286      # 0: down to label3
# BB#74:                                # %check.exit464
	i32.const	$push719=, src
	i32.const	$push287=, 76
	i32.call	$push21=, memcpy@FUNCTION, $0, $pop719, $pop287
	i32.const	$push718=, src
	i32.const	$push717=, 76
	i32.call	$push288=, memcmp@FUNCTION, $pop21, $pop718, $pop717
	br_if   	0, $pop288      # 0: down to label3
# BB#75:                                # %check.exit468
	i32.const	$push290=, dst
	i32.const	$push724=, src
	i32.const	$push289=, 77
	i32.call	$push723=, memcpy@FUNCTION, $pop290, $pop724, $pop289
	tee_local	$push722=, $0=, $pop723
	i32.const	$push721=, src
	i32.const	$push720=, 77
	i32.call	$push291=, memcmp@FUNCTION, $pop722, $pop721, $pop720
	br_if   	0, $pop291      # 0: down to label3
# BB#76:                                # %check.exit472
	i32.const	$push727=, src
	i32.const	$push292=, 78
	i32.call	$push22=, memcpy@FUNCTION, $0, $pop727, $pop292
	i32.const	$push726=, src
	i32.const	$push725=, 78
	i32.call	$push293=, memcmp@FUNCTION, $pop22, $pop726, $pop725
	br_if   	0, $pop293      # 0: down to label3
# BB#77:                                # %check.exit476
	i32.const	$push296=, dst
	i32.const	$push295=, src
	i32.const	$push294=, 79
	i32.call	$push23=, memcpy@FUNCTION, $pop296, $pop295, $pop294
	i32.const	$push729=, src
	i32.const	$push728=, 79
	i32.call	$push297=, memcmp@FUNCTION, $pop23, $pop729, $pop728
	br_if   	0, $pop297      # 0: down to label3
# BB#78:                                # %check.exit480
	i32.const	$push298=, 0
	return  	$pop298
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


	.ident	"clang version 4.0.0 "
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
