	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-bi.c"
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
	loop    	                # label1:
	i32.const	$push304=, src
	i32.add 	$push24=, $0, $pop304
	i32.const	$push303=, 26
	i32.rem_u	$push25=, $0, $pop303
	i32.const	$push302=, 97
	i32.add 	$push26=, $pop25, $pop302
	i32.store8	0($pop24), $pop26
	i32.const	$push301=, 1
	i32.add 	$push300=, $0, $pop301
	tee_local	$push299=, $0=, $pop300
	i32.const	$push298=, 80
	i32.ne  	$push27=, $pop299, $pop298
	br_if   	0, $pop27       # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop
	i32.const	$push308=, 0
	i32.const	$push307=, 0
	i32.load16_u	$push306=, src($pop307)
	tee_local	$push305=, $0=, $pop306
	i32.store16	dst($pop308), $pop305
	block   	
	i32.ne  	$push28=, $0, $0
	br_if   	0, $pop28       # 0: down to label2
# BB#3:                                 # %check.exit13
	i32.const	$push314=, 0
	i32.const	$push313=, 0
	i32.load8_u	$push29=, src+2($pop313)
	i32.store8	dst+2($pop314), $pop29
	i32.const	$push312=, 0
	i32.const	$push311=, 0
	i32.load16_u	$push30=, src($pop311)
	i32.store16	dst($pop312), $pop30
	i32.const	$push310=, dst
	i32.const	$push309=, src
	i32.const	$push31=, 3
	i32.call	$push32=, memcmp@FUNCTION, $pop310, $pop309, $pop31
	br_if   	0, $pop32       # 0: down to label2
# BB#4:                                 # %check.exit17
	i32.const	$push320=, 0
	i32.const	$push319=, 0
	i32.load8_u	$push33=, src+4($pop319)
	i32.store8	dst+4($pop320), $pop33
	i32.const	$push318=, 0
	i32.const	$push317=, 0
	i32.load	$push34=, src($pop317)
	i32.store	dst($pop318), $pop34
	i32.const	$push316=, dst
	i32.const	$push315=, src
	i32.const	$push35=, 5
	i32.call	$push36=, memcmp@FUNCTION, $pop316, $pop315, $pop35
	br_if   	0, $pop36       # 0: down to label2
# BB#5:                                 # %check.exit25
	i32.const	$push326=, 0
	i32.const	$push325=, 0
	i32.load16_u	$push37=, src+4($pop325)
	i32.store16	dst+4($pop326), $pop37
	i32.const	$push324=, 0
	i32.const	$push323=, 0
	i32.load	$push38=, src($pop323)
	i32.store	dst($pop324), $pop38
	i32.const	$push322=, dst
	i32.const	$push321=, src
	i32.const	$push39=, 6
	i32.call	$push40=, memcmp@FUNCTION, $pop322, $pop321, $pop39
	br_if   	0, $pop40       # 0: down to label2
# BB#6:                                 # %check.exit29
	i32.const	$push334=, 0
	i32.const	$push333=, 0
	i32.load8_u	$push41=, src+6($pop333)
	i32.store8	dst+6($pop334), $pop41
	i32.const	$push332=, 0
	i32.const	$push331=, 0
	i32.load16_u	$push42=, src+4($pop331)
	i32.store16	dst+4($pop332), $pop42
	i32.const	$push330=, 0
	i32.const	$push329=, 0
	i32.load	$push43=, src($pop329)
	i32.store	dst($pop330), $pop43
	i32.const	$push328=, dst
	i32.const	$push327=, src
	i32.const	$push44=, 7
	i32.call	$push45=, memcmp@FUNCTION, $pop328, $pop327, $pop44
	br_if   	0, $pop45       # 0: down to label2
# BB#7:                                 # %check.exit33
	i32.const	$push340=, 0
	i32.const	$push339=, 0
	i32.load8_u	$push46=, src+8($pop339)
	i32.store8	dst+8($pop340), $pop46
	i32.const	$push338=, 0
	i32.const	$push337=, 0
	i64.load	$push47=, src($pop337)
	i64.store	dst($pop338), $pop47
	i32.const	$push336=, dst
	i32.const	$push335=, src
	i32.const	$push48=, 9
	i32.call	$push49=, memcmp@FUNCTION, $pop336, $pop335, $pop48
	br_if   	0, $pop49       # 0: down to label2
# BB#8:                                 # %check.exit41
	i32.const	$push346=, 0
	i32.const	$push345=, 0
	i32.load16_u	$push50=, src+8($pop345)
	i32.store16	dst+8($pop346), $pop50
	i32.const	$push344=, 0
	i32.const	$push343=, 0
	i64.load	$push51=, src($pop343)
	i64.store	dst($pop344), $pop51
	i32.const	$push342=, dst
	i32.const	$push341=, src
	i32.const	$push52=, 10
	i32.call	$push53=, memcmp@FUNCTION, $pop342, $pop341, $pop52
	br_if   	0, $pop53       # 0: down to label2
# BB#9:                                 # %check.exit45
	i32.const	$push354=, 0
	i32.const	$push353=, 0
	i32.load8_u	$push54=, src+10($pop353)
	i32.store8	dst+10($pop354), $pop54
	i32.const	$push352=, 0
	i32.const	$push351=, 0
	i32.load16_u	$push55=, src+8($pop351)
	i32.store16	dst+8($pop352), $pop55
	i32.const	$push350=, 0
	i32.const	$push349=, 0
	i64.load	$push56=, src($pop349)
	i64.store	dst($pop350), $pop56
	i32.const	$push348=, dst
	i32.const	$push347=, src
	i32.const	$push57=, 11
	i32.call	$push58=, memcmp@FUNCTION, $pop348, $pop347, $pop57
	br_if   	0, $pop58       # 0: down to label2
# BB#10:                                # %check.exit49
	i32.const	$push360=, 0
	i32.const	$push359=, 0
	i32.load	$push59=, src+8($pop359)
	i32.store	dst+8($pop360), $pop59
	i32.const	$push358=, 0
	i32.const	$push357=, 0
	i64.load	$push60=, src($pop357)
	i64.store	dst($pop358), $pop60
	i32.const	$push356=, dst
	i32.const	$push355=, src
	i32.const	$push61=, 12
	i32.call	$push62=, memcmp@FUNCTION, $pop356, $pop355, $pop61
	br_if   	0, $pop62       # 0: down to label2
# BB#11:                                # %check.exit53
	i32.const	$push368=, 0
	i32.const	$push367=, 0
	i32.load8_u	$push63=, src+12($pop367)
	i32.store8	dst+12($pop368), $pop63
	i32.const	$push366=, 0
	i32.const	$push365=, 0
	i32.load	$push64=, src+8($pop365)
	i32.store	dst+8($pop366), $pop64
	i32.const	$push364=, 0
	i32.const	$push363=, 0
	i64.load	$push65=, src($pop363)
	i64.store	dst($pop364), $pop65
	i32.const	$push362=, dst
	i32.const	$push361=, src
	i32.const	$push66=, 13
	i32.call	$push67=, memcmp@FUNCTION, $pop362, $pop361, $pop66
	br_if   	0, $pop67       # 0: down to label2
# BB#12:                                # %check.exit57
	i32.const	$push376=, 0
	i32.const	$push375=, 0
	i32.load16_u	$push68=, src+12($pop375)
	i32.store16	dst+12($pop376), $pop68
	i32.const	$push374=, 0
	i32.const	$push373=, 0
	i32.load	$push69=, src+8($pop373)
	i32.store	dst+8($pop374), $pop69
	i32.const	$push372=, 0
	i32.const	$push371=, 0
	i64.load	$push70=, src($pop371)
	i64.store	dst($pop372), $pop70
	i32.const	$push370=, dst
	i32.const	$push369=, src
	i32.const	$push71=, 14
	i32.call	$push72=, memcmp@FUNCTION, $pop370, $pop369, $pop71
	br_if   	0, $pop72       # 0: down to label2
# BB#13:                                # %check.exit61
	i32.const	$push386=, 0
	i32.const	$push385=, 0
	i32.load8_u	$push73=, src+14($pop385)
	i32.store8	dst+14($pop386), $pop73
	i32.const	$push384=, 0
	i32.const	$push383=, 0
	i32.load16_u	$push74=, src+12($pop383)
	i32.store16	dst+12($pop384), $pop74
	i32.const	$push382=, 0
	i32.const	$push381=, 0
	i32.load	$push75=, src+8($pop381)
	i32.store	dst+8($pop382), $pop75
	i32.const	$push380=, 0
	i32.const	$push379=, 0
	i64.load	$push76=, src($pop379)
	i64.store	dst($pop380), $pop76
	i32.const	$push378=, dst
	i32.const	$push377=, src
	i32.const	$push77=, 15
	i32.call	$push78=, memcmp@FUNCTION, $pop378, $pop377, $pop77
	br_if   	0, $pop78       # 0: down to label2
# BB#14:                                # %check.exit65
	i32.const	$push392=, 0
	i32.const	$push391=, 0
	i64.load	$push79=, src+8($pop391)
	i64.store	dst+8($pop392), $pop79
	i32.const	$push390=, 0
	i32.const	$push389=, 0
	i64.load	$push80=, src($pop389)
	i64.store	dst($pop390), $pop80
	i32.const	$push388=, dst
	i32.const	$push387=, src
	i32.const	$push81=, 16
	i32.call	$push82=, memcmp@FUNCTION, $pop388, $pop387, $pop81
	br_if   	0, $pop82       # 0: down to label2
# BB#15:                                # %check.exit69
	i32.const	$push400=, 0
	i32.const	$push399=, 0
	i32.load8_u	$push83=, src+16($pop399)
	i32.store8	dst+16($pop400), $pop83
	i32.const	$push398=, 0
	i32.const	$push397=, 0
	i64.load	$push84=, src+8($pop397)
	i64.store	dst+8($pop398), $pop84
	i32.const	$push396=, 0
	i32.const	$push395=, 0
	i64.load	$push85=, src($pop395)
	i64.store	dst($pop396), $pop85
	i32.const	$push394=, dst
	i32.const	$push393=, src
	i32.const	$push86=, 17
	i32.call	$push87=, memcmp@FUNCTION, $pop394, $pop393, $pop86
	br_if   	0, $pop87       # 0: down to label2
# BB#16:                                # %check.exit73
	i32.const	$push408=, 0
	i32.const	$push407=, 0
	i32.load16_u	$push88=, src+16($pop407)
	i32.store16	dst+16($pop408), $pop88
	i32.const	$push406=, 0
	i32.const	$push405=, 0
	i64.load	$push89=, src+8($pop405)
	i64.store	dst+8($pop406), $pop89
	i32.const	$push404=, 0
	i32.const	$push403=, 0
	i64.load	$push90=, src($pop403)
	i64.store	dst($pop404), $pop90
	i32.const	$push402=, dst
	i32.const	$push401=, src
	i32.const	$push91=, 18
	i32.call	$push92=, memcmp@FUNCTION, $pop402, $pop401, $pop91
	br_if   	0, $pop92       # 0: down to label2
# BB#17:                                # %check.exit77
	i32.const	$push418=, 0
	i32.const	$push417=, 0
	i32.load8_u	$push93=, src+18($pop417)
	i32.store8	dst+18($pop418), $pop93
	i32.const	$push416=, 0
	i32.const	$push415=, 0
	i32.load16_u	$push94=, src+16($pop415)
	i32.store16	dst+16($pop416), $pop94
	i32.const	$push414=, 0
	i32.const	$push413=, 0
	i64.load	$push95=, src+8($pop413)
	i64.store	dst+8($pop414), $pop95
	i32.const	$push412=, 0
	i32.const	$push411=, 0
	i64.load	$push96=, src($pop411)
	i64.store	dst($pop412), $pop96
	i32.const	$push410=, dst
	i32.const	$push409=, src
	i32.const	$push97=, 19
	i32.call	$push98=, memcmp@FUNCTION, $pop410, $pop409, $pop97
	br_if   	0, $pop98       # 0: down to label2
# BB#18:                                # %check.exit81
	i32.const	$push426=, 0
	i32.const	$push425=, 0
	i32.load	$push99=, src+16($pop425)
	i32.store	dst+16($pop426), $pop99
	i32.const	$push424=, 0
	i32.const	$push423=, 0
	i64.load	$push100=, src+8($pop423)
	i64.store	dst+8($pop424), $pop100
	i32.const	$push422=, 0
	i32.const	$push421=, 0
	i64.load	$push101=, src($pop421)
	i64.store	dst($pop422), $pop101
	i32.const	$push420=, dst
	i32.const	$push419=, src
	i32.const	$push102=, 20
	i32.call	$push103=, memcmp@FUNCTION, $pop420, $pop419, $pop102
	br_if   	0, $pop103      # 0: down to label2
# BB#19:                                # %check.exit85
	i32.const	$push436=, 0
	i32.const	$push435=, 0
	i32.load8_u	$push104=, src+20($pop435)
	i32.store8	dst+20($pop436), $pop104
	i32.const	$push434=, 0
	i32.const	$push433=, 0
	i32.load	$push105=, src+16($pop433)
	i32.store	dst+16($pop434), $pop105
	i32.const	$push432=, 0
	i32.const	$push431=, 0
	i64.load	$push106=, src+8($pop431)
	i64.store	dst+8($pop432), $pop106
	i32.const	$push430=, 0
	i32.const	$push429=, 0
	i64.load	$push107=, src($pop429)
	i64.store	dst($pop430), $pop107
	i32.const	$push428=, dst
	i32.const	$push427=, src
	i32.const	$push108=, 21
	i32.call	$push109=, memcmp@FUNCTION, $pop428, $pop427, $pop108
	br_if   	0, $pop109      # 0: down to label2
# BB#20:                                # %check.exit89
	i32.const	$push446=, 0
	i32.const	$push445=, 0
	i32.load16_u	$push110=, src+20($pop445)
	i32.store16	dst+20($pop446), $pop110
	i32.const	$push444=, 0
	i32.const	$push443=, 0
	i32.load	$push111=, src+16($pop443)
	i32.store	dst+16($pop444), $pop111
	i32.const	$push442=, 0
	i32.const	$push441=, 0
	i64.load	$push112=, src+8($pop441)
	i64.store	dst+8($pop442), $pop112
	i32.const	$push440=, 0
	i32.const	$push439=, 0
	i64.load	$push113=, src($pop439)
	i64.store	dst($pop440), $pop113
	i32.const	$push438=, dst
	i32.const	$push437=, src
	i32.const	$push114=, 22
	i32.call	$push115=, memcmp@FUNCTION, $pop438, $pop437, $pop114
	br_if   	0, $pop115      # 0: down to label2
# BB#21:                                # %check.exit93
	i32.const	$push458=, 0
	i32.const	$push457=, 0
	i32.load8_u	$push116=, src+22($pop457)
	i32.store8	dst+22($pop458), $pop116
	i32.const	$push456=, 0
	i32.const	$push455=, 0
	i32.load16_u	$push117=, src+20($pop455)
	i32.store16	dst+20($pop456), $pop117
	i32.const	$push454=, 0
	i32.const	$push453=, 0
	i32.load	$push118=, src+16($pop453)
	i32.store	dst+16($pop454), $pop118
	i32.const	$push452=, 0
	i32.const	$push451=, 0
	i64.load	$push119=, src+8($pop451)
	i64.store	dst+8($pop452), $pop119
	i32.const	$push450=, 0
	i32.const	$push449=, 0
	i64.load	$push120=, src($pop449)
	i64.store	dst($pop450), $pop120
	i32.const	$push448=, dst
	i32.const	$push447=, src
	i32.const	$push121=, 23
	i32.call	$push122=, memcmp@FUNCTION, $pop448, $pop447, $pop121
	br_if   	0, $pop122      # 0: down to label2
# BB#22:                                # %check.exit97
	i32.const	$push466=, 0
	i32.const	$push465=, 0
	i64.load	$push123=, src+16($pop465)
	i64.store	dst+16($pop466), $pop123
	i32.const	$push464=, 0
	i32.const	$push463=, 0
	i64.load	$push124=, src+8($pop463)
	i64.store	dst+8($pop464), $pop124
	i32.const	$push462=, 0
	i32.const	$push461=, 0
	i64.load	$push125=, src($pop461)
	i64.store	dst($pop462), $pop125
	i32.const	$push460=, dst
	i32.const	$push459=, src
	i32.const	$push126=, 24
	i32.call	$push127=, memcmp@FUNCTION, $pop460, $pop459, $pop126
	br_if   	0, $pop127      # 0: down to label2
# BB#23:                                # %check.exit101
	i32.const	$push476=, 0
	i32.const	$push475=, 0
	i32.load8_u	$push128=, src+24($pop475)
	i32.store8	dst+24($pop476), $pop128
	i32.const	$push474=, 0
	i32.const	$push473=, 0
	i64.load	$push129=, src+16($pop473)
	i64.store	dst+16($pop474), $pop129
	i32.const	$push472=, 0
	i32.const	$push471=, 0
	i64.load	$push130=, src+8($pop471)
	i64.store	dst+8($pop472), $pop130
	i32.const	$push470=, 0
	i32.const	$push469=, 0
	i64.load	$push131=, src($pop469)
	i64.store	dst($pop470), $pop131
	i32.const	$push468=, dst
	i32.const	$push467=, src
	i32.const	$push132=, 25
	i32.call	$push133=, memcmp@FUNCTION, $pop468, $pop467, $pop132
	br_if   	0, $pop133      # 0: down to label2
# BB#24:                                # %check.exit105
	i32.const	$push486=, 0
	i32.const	$push485=, 0
	i32.load16_u	$push134=, src+24($pop485)
	i32.store16	dst+24($pop486), $pop134
	i32.const	$push484=, 0
	i32.const	$push483=, 0
	i64.load	$push135=, src+16($pop483)
	i64.store	dst+16($pop484), $pop135
	i32.const	$push482=, 0
	i32.const	$push481=, 0
	i64.load	$push136=, src+8($pop481)
	i64.store	dst+8($pop482), $pop136
	i32.const	$push480=, 0
	i32.const	$push479=, 0
	i64.load	$push137=, src($pop479)
	i64.store	dst($pop480), $pop137
	i32.const	$push478=, dst
	i32.const	$push477=, src
	i32.const	$push138=, 26
	i32.call	$push139=, memcmp@FUNCTION, $pop478, $pop477, $pop138
	br_if   	0, $pop139      # 0: down to label2
# BB#25:                                # %check.exit109
	i32.const	$push498=, 0
	i32.const	$push497=, 0
	i32.load8_u	$push140=, src+26($pop497)
	i32.store8	dst+26($pop498), $pop140
	i32.const	$push496=, 0
	i32.const	$push495=, 0
	i32.load16_u	$push141=, src+24($pop495)
	i32.store16	dst+24($pop496), $pop141
	i32.const	$push494=, 0
	i32.const	$push493=, 0
	i64.load	$push142=, src+16($pop493)
	i64.store	dst+16($pop494), $pop142
	i32.const	$push492=, 0
	i32.const	$push491=, 0
	i64.load	$push143=, src+8($pop491)
	i64.store	dst+8($pop492), $pop143
	i32.const	$push490=, 0
	i32.const	$push489=, 0
	i64.load	$push144=, src($pop489)
	i64.store	dst($pop490), $pop144
	i32.const	$push488=, dst
	i32.const	$push487=, src
	i32.const	$push145=, 27
	i32.call	$push146=, memcmp@FUNCTION, $pop488, $pop487, $pop145
	br_if   	0, $pop146      # 0: down to label2
# BB#26:                                # %check.exit113
	i32.const	$push508=, 0
	i32.const	$push507=, 0
	i32.load	$push147=, src+24($pop507)
	i32.store	dst+24($pop508), $pop147
	i32.const	$push506=, 0
	i32.const	$push505=, 0
	i64.load	$push148=, src+16($pop505)
	i64.store	dst+16($pop506), $pop148
	i32.const	$push504=, 0
	i32.const	$push503=, 0
	i64.load	$push149=, src+8($pop503)
	i64.store	dst+8($pop504), $pop149
	i32.const	$push502=, 0
	i32.const	$push501=, 0
	i64.load	$push150=, src($pop501)
	i64.store	dst($pop502), $pop150
	i32.const	$push500=, dst
	i32.const	$push499=, src
	i32.const	$push151=, 28
	i32.call	$push152=, memcmp@FUNCTION, $pop500, $pop499, $pop151
	br_if   	0, $pop152      # 0: down to label2
# BB#27:                                # %check.exit117
	i32.const	$push520=, 0
	i32.const	$push519=, 0
	i32.load8_u	$push153=, src+28($pop519)
	i32.store8	dst+28($pop520), $pop153
	i32.const	$push518=, 0
	i32.const	$push517=, 0
	i32.load	$push154=, src+24($pop517)
	i32.store	dst+24($pop518), $pop154
	i32.const	$push516=, 0
	i32.const	$push515=, 0
	i64.load	$push155=, src+16($pop515)
	i64.store	dst+16($pop516), $pop155
	i32.const	$push514=, 0
	i32.const	$push513=, 0
	i64.load	$push156=, src+8($pop513)
	i64.store	dst+8($pop514), $pop156
	i32.const	$push512=, 0
	i32.const	$push511=, 0
	i64.load	$push157=, src($pop511)
	i64.store	dst($pop512), $pop157
	i32.const	$push510=, dst
	i32.const	$push509=, src
	i32.const	$push158=, 29
	i32.call	$push159=, memcmp@FUNCTION, $pop510, $pop509, $pop158
	br_if   	0, $pop159      # 0: down to label2
# BB#28:                                # %check.exit121
	i32.const	$push160=, 0
	i32.const	$push531=, 0
	i32.load16_u	$push161=, src+28($pop531)
	i32.store16	dst+28($pop160), $pop161
	i32.const	$push530=, 0
	i32.const	$push529=, 0
	i32.load	$push162=, src+24($pop529)
	i32.store	dst+24($pop530), $pop162
	i32.const	$push528=, 0
	i32.const	$push527=, 0
	i64.load	$push163=, src+16($pop527)
	i64.store	dst+16($pop528), $pop163
	i32.const	$push526=, 0
	i32.const	$push525=, 0
	i64.load	$push164=, src+8($pop525)
	i64.store	dst+8($pop526), $pop164
	i32.const	$push524=, 0
	i32.const	$push523=, 0
	i64.load	$push165=, src($pop523)
	i64.store	dst($pop524), $pop165
	i32.const	$push522=, dst
	i32.const	$push521=, src
	i32.const	$push166=, 30
	i32.call	$push167=, memcmp@FUNCTION, $pop522, $pop521, $pop166
	br_if   	0, $pop167      # 0: down to label2
# BB#29:                                # %check.exit125
	i32.const	$push169=, dst
	i32.const	$push536=, src
	i32.const	$push168=, 31
	i32.call	$push535=, memcpy@FUNCTION, $pop169, $pop536, $pop168
	tee_local	$push534=, $0=, $pop535
	i32.const	$push533=, src
	i32.const	$push532=, 31
	i32.call	$push170=, memcmp@FUNCTION, $pop534, $pop533, $pop532
	br_if   	0, $pop170      # 0: down to label2
# BB#30:                                # %check.exit129
	i32.const	$push171=, 0
	i32.const	$push544=, 0
	i64.load	$push172=, src+24($pop544)
	i64.store	dst+24($pop171), $pop172
	i32.const	$push543=, 0
	i32.const	$push542=, 0
	i64.load	$push173=, src+16($pop542)
	i64.store	dst+16($pop543), $pop173
	i32.const	$push541=, 0
	i32.const	$push540=, 0
	i64.load	$push174=, src+8($pop540)
	i64.store	dst+8($pop541), $pop174
	i32.const	$push539=, 0
	i32.const	$push538=, 0
	i64.load	$push175=, src($pop538)
	i64.store	dst($pop539), $pop175
	i32.const	$push537=, src
	i32.const	$push176=, 32
	i32.call	$push177=, memcmp@FUNCTION, $0, $pop537, $pop176
	br_if   	0, $pop177      # 0: down to label2
# BB#31:                                # %check.exit133
	i32.const	$push179=, dst
	i32.const	$push549=, src
	i32.const	$push178=, 33
	i32.call	$push548=, memcpy@FUNCTION, $pop179, $pop549, $pop178
	tee_local	$push547=, $0=, $pop548
	i32.const	$push546=, src
	i32.const	$push545=, 33
	i32.call	$push180=, memcmp@FUNCTION, $pop547, $pop546, $pop545
	br_if   	0, $pop180      # 0: down to label2
# BB#32:                                # %check.exit137
	i32.const	$push552=, src
	i32.const	$push181=, 34
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop552, $pop181
	i32.const	$push551=, src
	i32.const	$push550=, 34
	i32.call	$push182=, memcmp@FUNCTION, $pop0, $pop551, $pop550
	br_if   	0, $pop182      # 0: down to label2
# BB#33:                                # %check.exit141
	i32.const	$push184=, dst
	i32.const	$push557=, src
	i32.const	$push183=, 35
	i32.call	$push556=, memcpy@FUNCTION, $pop184, $pop557, $pop183
	tee_local	$push555=, $0=, $pop556
	i32.const	$push554=, src
	i32.const	$push553=, 35
	i32.call	$push185=, memcmp@FUNCTION, $pop555, $pop554, $pop553
	br_if   	0, $pop185      # 0: down to label2
# BB#34:                                # %check.exit145
	i32.const	$push560=, src
	i32.const	$push186=, 36
	i32.call	$push1=, memcpy@FUNCTION, $0, $pop560, $pop186
	i32.const	$push559=, src
	i32.const	$push558=, 36
	i32.call	$push187=, memcmp@FUNCTION, $pop1, $pop559, $pop558
	br_if   	0, $pop187      # 0: down to label2
# BB#35:                                # %check.exit149
	i32.const	$push189=, dst
	i32.const	$push565=, src
	i32.const	$push188=, 37
	i32.call	$push564=, memcpy@FUNCTION, $pop189, $pop565, $pop188
	tee_local	$push563=, $0=, $pop564
	i32.const	$push562=, src
	i32.const	$push561=, 37
	i32.call	$push190=, memcmp@FUNCTION, $pop563, $pop562, $pop561
	br_if   	0, $pop190      # 0: down to label2
# BB#36:                                # %check.exit153
	i32.const	$push568=, src
	i32.const	$push191=, 38
	i32.call	$push2=, memcpy@FUNCTION, $0, $pop568, $pop191
	i32.const	$push567=, src
	i32.const	$push566=, 38
	i32.call	$push192=, memcmp@FUNCTION, $pop2, $pop567, $pop566
	br_if   	0, $pop192      # 0: down to label2
# BB#37:                                # %check.exit157
	i32.const	$push194=, dst
	i32.const	$push573=, src
	i32.const	$push193=, 39
	i32.call	$push572=, memcpy@FUNCTION, $pop194, $pop573, $pop193
	tee_local	$push571=, $0=, $pop572
	i32.const	$push570=, src
	i32.const	$push569=, 39
	i32.call	$push195=, memcmp@FUNCTION, $pop571, $pop570, $pop569
	br_if   	0, $pop195      # 0: down to label2
# BB#38:                                # %check.exit161
	i32.const	$push576=, src
	i32.const	$push196=, 40
	i32.call	$push3=, memcpy@FUNCTION, $0, $pop576, $pop196
	i32.const	$push575=, src
	i32.const	$push574=, 40
	i32.call	$push197=, memcmp@FUNCTION, $pop3, $pop575, $pop574
	br_if   	0, $pop197      # 0: down to label2
# BB#39:                                # %check.exit165
	i32.const	$push199=, dst
	i32.const	$push581=, src
	i32.const	$push198=, 41
	i32.call	$push580=, memcpy@FUNCTION, $pop199, $pop581, $pop198
	tee_local	$push579=, $0=, $pop580
	i32.const	$push578=, src
	i32.const	$push577=, 41
	i32.call	$push200=, memcmp@FUNCTION, $pop579, $pop578, $pop577
	br_if   	0, $pop200      # 0: down to label2
# BB#40:                                # %check.exit169
	i32.const	$push584=, src
	i32.const	$push201=, 42
	i32.call	$push4=, memcpy@FUNCTION, $0, $pop584, $pop201
	i32.const	$push583=, src
	i32.const	$push582=, 42
	i32.call	$push202=, memcmp@FUNCTION, $pop4, $pop583, $pop582
	br_if   	0, $pop202      # 0: down to label2
# BB#41:                                # %check.exit173
	i32.const	$push204=, dst
	i32.const	$push589=, src
	i32.const	$push203=, 43
	i32.call	$push588=, memcpy@FUNCTION, $pop204, $pop589, $pop203
	tee_local	$push587=, $0=, $pop588
	i32.const	$push586=, src
	i32.const	$push585=, 43
	i32.call	$push205=, memcmp@FUNCTION, $pop587, $pop586, $pop585
	br_if   	0, $pop205      # 0: down to label2
# BB#42:                                # %check.exit177
	i32.const	$push592=, src
	i32.const	$push206=, 44
	i32.call	$push5=, memcpy@FUNCTION, $0, $pop592, $pop206
	i32.const	$push591=, src
	i32.const	$push590=, 44
	i32.call	$push207=, memcmp@FUNCTION, $pop5, $pop591, $pop590
	br_if   	0, $pop207      # 0: down to label2
# BB#43:                                # %check.exit181
	i32.const	$push209=, dst
	i32.const	$push597=, src
	i32.const	$push208=, 45
	i32.call	$push596=, memcpy@FUNCTION, $pop209, $pop597, $pop208
	tee_local	$push595=, $0=, $pop596
	i32.const	$push594=, src
	i32.const	$push593=, 45
	i32.call	$push210=, memcmp@FUNCTION, $pop595, $pop594, $pop593
	br_if   	0, $pop210      # 0: down to label2
# BB#44:                                # %check.exit185
	i32.const	$push600=, src
	i32.const	$push211=, 46
	i32.call	$push6=, memcpy@FUNCTION, $0, $pop600, $pop211
	i32.const	$push599=, src
	i32.const	$push598=, 46
	i32.call	$push212=, memcmp@FUNCTION, $pop6, $pop599, $pop598
	br_if   	0, $pop212      # 0: down to label2
# BB#45:                                # %check.exit189
	i32.const	$push214=, dst
	i32.const	$push605=, src
	i32.const	$push213=, 47
	i32.call	$push604=, memcpy@FUNCTION, $pop214, $pop605, $pop213
	tee_local	$push603=, $0=, $pop604
	i32.const	$push602=, src
	i32.const	$push601=, 47
	i32.call	$push215=, memcmp@FUNCTION, $pop603, $pop602, $pop601
	br_if   	0, $pop215      # 0: down to label2
# BB#46:                                # %check.exit193
	i32.const	$push608=, src
	i32.const	$push216=, 48
	i32.call	$push7=, memcpy@FUNCTION, $0, $pop608, $pop216
	i32.const	$push607=, src
	i32.const	$push606=, 48
	i32.call	$push217=, memcmp@FUNCTION, $pop7, $pop607, $pop606
	br_if   	0, $pop217      # 0: down to label2
# BB#47:                                # %check.exit197
	i32.const	$push219=, dst
	i32.const	$push613=, src
	i32.const	$push218=, 49
	i32.call	$push612=, memcpy@FUNCTION, $pop219, $pop613, $pop218
	tee_local	$push611=, $0=, $pop612
	i32.const	$push610=, src
	i32.const	$push609=, 49
	i32.call	$push220=, memcmp@FUNCTION, $pop611, $pop610, $pop609
	br_if   	0, $pop220      # 0: down to label2
# BB#48:                                # %check.exit201
	i32.const	$push616=, src
	i32.const	$push221=, 50
	i32.call	$push8=, memcpy@FUNCTION, $0, $pop616, $pop221
	i32.const	$push615=, src
	i32.const	$push614=, 50
	i32.call	$push222=, memcmp@FUNCTION, $pop8, $pop615, $pop614
	br_if   	0, $pop222      # 0: down to label2
# BB#49:                                # %check.exit205
	i32.const	$push224=, dst
	i32.const	$push621=, src
	i32.const	$push223=, 51
	i32.call	$push620=, memcpy@FUNCTION, $pop224, $pop621, $pop223
	tee_local	$push619=, $0=, $pop620
	i32.const	$push618=, src
	i32.const	$push617=, 51
	i32.call	$push225=, memcmp@FUNCTION, $pop619, $pop618, $pop617
	br_if   	0, $pop225      # 0: down to label2
# BB#50:                                # %check.exit209
	i32.const	$push624=, src
	i32.const	$push226=, 52
	i32.call	$push9=, memcpy@FUNCTION, $0, $pop624, $pop226
	i32.const	$push623=, src
	i32.const	$push622=, 52
	i32.call	$push227=, memcmp@FUNCTION, $pop9, $pop623, $pop622
	br_if   	0, $pop227      # 0: down to label2
# BB#51:                                # %check.exit213
	i32.const	$push229=, dst
	i32.const	$push629=, src
	i32.const	$push228=, 53
	i32.call	$push628=, memcpy@FUNCTION, $pop229, $pop629, $pop228
	tee_local	$push627=, $0=, $pop628
	i32.const	$push626=, src
	i32.const	$push625=, 53
	i32.call	$push230=, memcmp@FUNCTION, $pop627, $pop626, $pop625
	br_if   	0, $pop230      # 0: down to label2
# BB#52:                                # %check.exit217
	i32.const	$push632=, src
	i32.const	$push231=, 54
	i32.call	$push10=, memcpy@FUNCTION, $0, $pop632, $pop231
	i32.const	$push631=, src
	i32.const	$push630=, 54
	i32.call	$push232=, memcmp@FUNCTION, $pop10, $pop631, $pop630
	br_if   	0, $pop232      # 0: down to label2
# BB#53:                                # %check.exit221
	i32.const	$push234=, dst
	i32.const	$push637=, src
	i32.const	$push233=, 55
	i32.call	$push636=, memcpy@FUNCTION, $pop234, $pop637, $pop233
	tee_local	$push635=, $0=, $pop636
	i32.const	$push634=, src
	i32.const	$push633=, 55
	i32.call	$push235=, memcmp@FUNCTION, $pop635, $pop634, $pop633
	br_if   	0, $pop235      # 0: down to label2
# BB#54:                                # %check.exit225
	i32.const	$push640=, src
	i32.const	$push236=, 56
	i32.call	$push11=, memcpy@FUNCTION, $0, $pop640, $pop236
	i32.const	$push639=, src
	i32.const	$push638=, 56
	i32.call	$push237=, memcmp@FUNCTION, $pop11, $pop639, $pop638
	br_if   	0, $pop237      # 0: down to label2
# BB#55:                                # %check.exit229
	i32.const	$push239=, dst
	i32.const	$push645=, src
	i32.const	$push238=, 57
	i32.call	$push644=, memcpy@FUNCTION, $pop239, $pop645, $pop238
	tee_local	$push643=, $0=, $pop644
	i32.const	$push642=, src
	i32.const	$push641=, 57
	i32.call	$push240=, memcmp@FUNCTION, $pop643, $pop642, $pop641
	br_if   	0, $pop240      # 0: down to label2
# BB#56:                                # %check.exit233
	i32.const	$push648=, src
	i32.const	$push241=, 58
	i32.call	$push12=, memcpy@FUNCTION, $0, $pop648, $pop241
	i32.const	$push647=, src
	i32.const	$push646=, 58
	i32.call	$push242=, memcmp@FUNCTION, $pop12, $pop647, $pop646
	br_if   	0, $pop242      # 0: down to label2
# BB#57:                                # %check.exit237
	i32.const	$push244=, dst
	i32.const	$push653=, src
	i32.const	$push243=, 59
	i32.call	$push652=, memcpy@FUNCTION, $pop244, $pop653, $pop243
	tee_local	$push651=, $0=, $pop652
	i32.const	$push650=, src
	i32.const	$push649=, 59
	i32.call	$push245=, memcmp@FUNCTION, $pop651, $pop650, $pop649
	br_if   	0, $pop245      # 0: down to label2
# BB#58:                                # %check.exit241
	i32.const	$push656=, src
	i32.const	$push246=, 60
	i32.call	$push13=, memcpy@FUNCTION, $0, $pop656, $pop246
	i32.const	$push655=, src
	i32.const	$push654=, 60
	i32.call	$push247=, memcmp@FUNCTION, $pop13, $pop655, $pop654
	br_if   	0, $pop247      # 0: down to label2
# BB#59:                                # %check.exit245
	i32.const	$push249=, dst
	i32.const	$push661=, src
	i32.const	$push248=, 61
	i32.call	$push660=, memcpy@FUNCTION, $pop249, $pop661, $pop248
	tee_local	$push659=, $0=, $pop660
	i32.const	$push658=, src
	i32.const	$push657=, 61
	i32.call	$push250=, memcmp@FUNCTION, $pop659, $pop658, $pop657
	br_if   	0, $pop250      # 0: down to label2
# BB#60:                                # %check.exit249
	i32.const	$push664=, src
	i32.const	$push251=, 62
	i32.call	$push14=, memcpy@FUNCTION, $0, $pop664, $pop251
	i32.const	$push663=, src
	i32.const	$push662=, 62
	i32.call	$push252=, memcmp@FUNCTION, $pop14, $pop663, $pop662
	br_if   	0, $pop252      # 0: down to label2
# BB#61:                                # %check.exit253
	i32.const	$push254=, dst
	i32.const	$push669=, src
	i32.const	$push253=, 63
	i32.call	$push668=, memcpy@FUNCTION, $pop254, $pop669, $pop253
	tee_local	$push667=, $0=, $pop668
	i32.const	$push666=, src
	i32.const	$push665=, 63
	i32.call	$push255=, memcmp@FUNCTION, $pop667, $pop666, $pop665
	br_if   	0, $pop255      # 0: down to label2
# BB#62:                                # %check.exit257
	i32.const	$push672=, src
	i32.const	$push256=, 64
	i32.call	$push15=, memcpy@FUNCTION, $0, $pop672, $pop256
	i32.const	$push671=, src
	i32.const	$push670=, 64
	i32.call	$push257=, memcmp@FUNCTION, $pop15, $pop671, $pop670
	br_if   	0, $pop257      # 0: down to label2
# BB#63:                                # %check.exit261
	i32.const	$push259=, dst
	i32.const	$push677=, src
	i32.const	$push258=, 65
	i32.call	$push676=, memcpy@FUNCTION, $pop259, $pop677, $pop258
	tee_local	$push675=, $0=, $pop676
	i32.const	$push674=, src
	i32.const	$push673=, 65
	i32.call	$push260=, memcmp@FUNCTION, $pop675, $pop674, $pop673
	br_if   	0, $pop260      # 0: down to label2
# BB#64:                                # %check.exit265
	i32.const	$push680=, src
	i32.const	$push261=, 66
	i32.call	$push16=, memcpy@FUNCTION, $0, $pop680, $pop261
	i32.const	$push679=, src
	i32.const	$push678=, 66
	i32.call	$push262=, memcmp@FUNCTION, $pop16, $pop679, $pop678
	br_if   	0, $pop262      # 0: down to label2
# BB#65:                                # %check.exit269
	i32.const	$push264=, dst
	i32.const	$push685=, src
	i32.const	$push263=, 67
	i32.call	$push684=, memcpy@FUNCTION, $pop264, $pop685, $pop263
	tee_local	$push683=, $0=, $pop684
	i32.const	$push682=, src
	i32.const	$push681=, 67
	i32.call	$push265=, memcmp@FUNCTION, $pop683, $pop682, $pop681
	br_if   	0, $pop265      # 0: down to label2
# BB#66:                                # %check.exit273
	i32.const	$push688=, src
	i32.const	$push266=, 68
	i32.call	$push17=, memcpy@FUNCTION, $0, $pop688, $pop266
	i32.const	$push687=, src
	i32.const	$push686=, 68
	i32.call	$push267=, memcmp@FUNCTION, $pop17, $pop687, $pop686
	br_if   	0, $pop267      # 0: down to label2
# BB#67:                                # %check.exit277
	i32.const	$push269=, dst
	i32.const	$push693=, src
	i32.const	$push268=, 69
	i32.call	$push692=, memcpy@FUNCTION, $pop269, $pop693, $pop268
	tee_local	$push691=, $0=, $pop692
	i32.const	$push690=, src
	i32.const	$push689=, 69
	i32.call	$push270=, memcmp@FUNCTION, $pop691, $pop690, $pop689
	br_if   	0, $pop270      # 0: down to label2
# BB#68:                                # %check.exit281
	i32.const	$push696=, src
	i32.const	$push271=, 70
	i32.call	$push18=, memcpy@FUNCTION, $0, $pop696, $pop271
	i32.const	$push695=, src
	i32.const	$push694=, 70
	i32.call	$push272=, memcmp@FUNCTION, $pop18, $pop695, $pop694
	br_if   	0, $pop272      # 0: down to label2
# BB#69:                                # %check.exit285
	i32.const	$push274=, dst
	i32.const	$push701=, src
	i32.const	$push273=, 71
	i32.call	$push700=, memcpy@FUNCTION, $pop274, $pop701, $pop273
	tee_local	$push699=, $0=, $pop700
	i32.const	$push698=, src
	i32.const	$push697=, 71
	i32.call	$push275=, memcmp@FUNCTION, $pop699, $pop698, $pop697
	br_if   	0, $pop275      # 0: down to label2
# BB#70:                                # %check.exit289
	i32.const	$push704=, src
	i32.const	$push276=, 72
	i32.call	$push19=, memcpy@FUNCTION, $0, $pop704, $pop276
	i32.const	$push703=, src
	i32.const	$push702=, 72
	i32.call	$push277=, memcmp@FUNCTION, $pop19, $pop703, $pop702
	br_if   	0, $pop277      # 0: down to label2
# BB#71:                                # %check.exit293
	i32.const	$push279=, dst
	i32.const	$push709=, src
	i32.const	$push278=, 73
	i32.call	$push708=, memcpy@FUNCTION, $pop279, $pop709, $pop278
	tee_local	$push707=, $0=, $pop708
	i32.const	$push706=, src
	i32.const	$push705=, 73
	i32.call	$push280=, memcmp@FUNCTION, $pop707, $pop706, $pop705
	br_if   	0, $pop280      # 0: down to label2
# BB#72:                                # %check.exit297
	i32.const	$push712=, src
	i32.const	$push281=, 74
	i32.call	$push20=, memcpy@FUNCTION, $0, $pop712, $pop281
	i32.const	$push711=, src
	i32.const	$push710=, 74
	i32.call	$push282=, memcmp@FUNCTION, $pop20, $pop711, $pop710
	br_if   	0, $pop282      # 0: down to label2
# BB#73:                                # %check.exit301
	i32.const	$push284=, dst
	i32.const	$push717=, src
	i32.const	$push283=, 75
	i32.call	$push716=, memcpy@FUNCTION, $pop284, $pop717, $pop283
	tee_local	$push715=, $0=, $pop716
	i32.const	$push714=, src
	i32.const	$push713=, 75
	i32.call	$push285=, memcmp@FUNCTION, $pop715, $pop714, $pop713
	br_if   	0, $pop285      # 0: down to label2
# BB#74:                                # %check.exit305
	i32.const	$push720=, src
	i32.const	$push286=, 76
	i32.call	$push21=, memcpy@FUNCTION, $0, $pop720, $pop286
	i32.const	$push719=, src
	i32.const	$push718=, 76
	i32.call	$push287=, memcmp@FUNCTION, $pop21, $pop719, $pop718
	br_if   	0, $pop287      # 0: down to label2
# BB#75:                                # %check.exit309
	i32.const	$push289=, dst
	i32.const	$push725=, src
	i32.const	$push288=, 77
	i32.call	$push724=, memcpy@FUNCTION, $pop289, $pop725, $pop288
	tee_local	$push723=, $0=, $pop724
	i32.const	$push722=, src
	i32.const	$push721=, 77
	i32.call	$push290=, memcmp@FUNCTION, $pop723, $pop722, $pop721
	br_if   	0, $pop290      # 0: down to label2
# BB#76:                                # %check.exit313
	i32.const	$push728=, src
	i32.const	$push291=, 78
	i32.call	$push22=, memcpy@FUNCTION, $0, $pop728, $pop291
	i32.const	$push727=, src
	i32.const	$push726=, 78
	i32.call	$push292=, memcmp@FUNCTION, $pop22, $pop727, $pop726
	br_if   	0, $pop292      # 0: down to label2
# BB#77:                                # %check.exit317
	i32.const	$push295=, dst
	i32.const	$push294=, src
	i32.const	$push293=, 79
	i32.call	$push23=, memcpy@FUNCTION, $pop295, $pop294, $pop293
	i32.const	$push730=, src
	i32.const	$push729=, 79
	i32.call	$push296=, memcmp@FUNCTION, $pop23, $pop730, $pop729
	br_if   	0, $pop296      # 0: down to label2
# BB#78:                                # %check.exit321
	i32.const	$push297=, 0
	return  	$pop297
.LBB1_79:                               # %if.then.i320
	end_block                       # label2:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
