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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push33=, 0
	i32.load16_u	$0=, i+6($pop33)
	i32.const	$push536=, 0
	i32.load16_u	$4=, i+4($pop536)
	i32.const	$push535=, 0
	i32.load16_u	$5=, i+2($pop535)
	i32.const	$push534=, 0
	i32.load16_u	$6=, i($pop534)
	i32.const	$push533=, 0
	i32.load16_u	$13=, j($pop533)
	i32.const	$push532=, 0
	i32.load16_u	$12=, j+2($pop532)
	i32.const	$push531=, 0
	i32.load16_u	$11=, j+4($pop531)
	i32.const	$push530=, 0
	i32.load16_u	$10=, j+6($pop530)
	i32.const	$push529=, 0
	i32.load16_u	$1=, i+12($pop529)
	i32.const	$push528=, 0
	i32.load16_u	$2=, i+10($pop528)
	i32.const	$push527=, 0
	i32.load16_u	$3=, i+8($pop527)
	i32.const	$push526=, 0
	i32.load16_u	$9=, j+8($pop526)
	i32.const	$push525=, 0
	i32.load16_u	$8=, j+10($pop525)
	i32.const	$push524=, 0
	i32.load16_u	$7=, j+12($pop524)
	i32.const	$push523=, 0
	i32.const	$push522=, 0
	i32.const	$push521=, 0
	i32.load16_u	$push35=, j+14($pop521)
	i32.const	$push520=, 0
	i32.load16_u	$push34=, i+14($pop520)
	i32.add 	$push43=, $pop35, $pop34
	i32.store16	$push0=, k+14($pop522), $pop43
	i32.store16	$discard=, res+14($pop523), $pop0
	i32.const	$push519=, 0
	i32.const	$push518=, 0
	i32.add 	$push42=, $7, $1
	i32.store16	$push1=, k+12($pop518), $pop42
	i32.store16	$discard=, res+12($pop519), $pop1
	i32.const	$push517=, 0
	i32.const	$push516=, 0
	i32.add 	$push41=, $8, $2
	i32.store16	$push2=, k+10($pop516), $pop41
	i32.store16	$discard=, res+10($pop517), $pop2
	i32.const	$push515=, 0
	i32.const	$push514=, 0
	i32.add 	$push40=, $9, $3
	i32.store16	$push3=, k+8($pop514), $pop40
	i32.store16	$discard=, res+8($pop515), $pop3
	i32.const	$push513=, 0
	i32.add 	$push39=, $10, $0
	i32.store16	$10=, k+6($pop513), $pop39
	i32.const	$push512=, 0
	i32.add 	$push38=, $11, $4
	i32.store16	$4=, k+4($pop512), $pop38
	i32.const	$push511=, 0
	i32.add 	$push37=, $12, $5
	i32.store16	$5=, k+2($pop511), $pop37
	i32.const	$push510=, 0
	i32.add 	$push36=, $13, $6
	i32.store16	$0=, k($pop510), $pop36
	i32.const	$push509=, 0
	i32.store16	$6=, res+6($pop509), $10
	i32.const	$push508=, 0
	i32.store16	$discard=, res+4($pop508), $4
	i32.const	$push507=, 0
	i32.store16	$discard=, res+2($pop507), $5
	i32.const	$push506=, 0
	i32.store16	$discard=, res($pop506), $0
	i32.const	$push44=, 16
	i32.shl 	$push45=, $0, $pop44
	i32.const	$push505=, 16
	i32.shr_s	$push46=, $pop45, $pop505
	i32.const	$push504=, 16
	i32.shl 	$push47=, $5, $pop504
	i32.const	$push503=, 16
	i32.shr_s	$push48=, $pop47, $pop503
	i32.const	$push502=, 16
	i32.shl 	$push49=, $4, $pop502
	i32.const	$push501=, 16
	i32.shr_s	$push50=, $pop49, $pop501
	i32.const	$push500=, 16
	i32.shl 	$push51=, $6, $pop500
	i32.const	$push499=, 16
	i32.shr_s	$push52=, $pop51, $pop499
	i32.const	$push56=, 160
	i32.const	$push55=, 113
	i32.const	$push54=, 170
	i32.const	$push53=, 230
	call    	verify@FUNCTION, $pop46, $pop48, $pop50, $pop52, $pop56, $pop55, $pop54, $pop53
	i32.const	$push498=, 0
	i32.load16_u	$0=, i+6($pop498)
	i32.const	$push497=, 0
	i32.load16_u	$4=, i+4($pop497)
	i32.const	$push496=, 0
	i32.load16_u	$5=, i+2($pop496)
	i32.const	$push495=, 0
	i32.load16_u	$6=, i($pop495)
	i32.const	$push494=, 0
	i32.load16_u	$13=, j($pop494)
	i32.const	$push493=, 0
	i32.load16_u	$12=, j+2($pop493)
	i32.const	$push492=, 0
	i32.load16_u	$11=, j+4($pop492)
	i32.const	$push491=, 0
	i32.load16_u	$10=, j+6($pop491)
	i32.const	$push490=, 0
	i32.load16_u	$1=, i+12($pop490)
	i32.const	$push489=, 0
	i32.load16_u	$2=, i+10($pop489)
	i32.const	$push488=, 0
	i32.load16_u	$3=, i+8($pop488)
	i32.const	$push487=, 0
	i32.load16_u	$9=, j+8($pop487)
	i32.const	$push486=, 0
	i32.load16_u	$8=, j+10($pop486)
	i32.const	$push485=, 0
	i32.load16_u	$7=, j+12($pop485)
	i32.const	$push484=, 0
	i32.const	$push483=, 0
	i32.const	$push482=, 0
	i32.load16_u	$push58=, j+14($pop482)
	i32.const	$push481=, 0
	i32.load16_u	$push57=, i+14($pop481)
	i32.mul 	$push66=, $pop58, $pop57
	i32.store16	$push4=, k+14($pop483), $pop66
	i32.store16	$discard=, res+14($pop484), $pop4
	i32.const	$push480=, 0
	i32.const	$push479=, 0
	i32.mul 	$push65=, $7, $1
	i32.store16	$push5=, k+12($pop479), $pop65
	i32.store16	$discard=, res+12($pop480), $pop5
	i32.const	$push478=, 0
	i32.const	$push477=, 0
	i32.mul 	$push64=, $8, $2
	i32.store16	$push6=, k+10($pop477), $pop64
	i32.store16	$discard=, res+10($pop478), $pop6
	i32.const	$push476=, 0
	i32.const	$push475=, 0
	i32.mul 	$push63=, $9, $3
	i32.store16	$push7=, k+8($pop475), $pop63
	i32.store16	$discard=, res+8($pop476), $pop7
	i32.const	$push474=, 0
	i32.mul 	$push62=, $10, $0
	i32.store16	$10=, k+6($pop474), $pop62
	i32.const	$push473=, 0
	i32.mul 	$push61=, $11, $4
	i32.store16	$4=, k+4($pop473), $pop61
	i32.const	$push472=, 0
	i32.mul 	$push60=, $12, $5
	i32.store16	$5=, k+2($pop472), $pop60
	i32.const	$push471=, 0
	i32.mul 	$push59=, $13, $6
	i32.store16	$0=, k($pop471), $pop59
	i32.const	$push470=, 0
	i32.store16	$6=, res+6($pop470), $10
	i32.const	$push469=, 0
	i32.store16	$discard=, res+4($pop469), $4
	i32.const	$push468=, 0
	i32.store16	$discard=, res+2($pop468), $5
	i32.const	$push467=, 0
	i32.store16	$discard=, res($pop467), $0
	i32.const	$push466=, 16
	i32.shl 	$push67=, $0, $pop466
	i32.const	$push465=, 16
	i32.shr_s	$push68=, $pop67, $pop465
	i32.const	$push464=, 16
	i32.shl 	$push69=, $5, $pop464
	i32.const	$push463=, 16
	i32.shr_s	$push70=, $pop69, $pop463
	i32.const	$push462=, 16
	i32.shl 	$push71=, $4, $pop462
	i32.const	$push461=, 16
	i32.shr_s	$push72=, $pop71, $pop461
	i32.const	$push460=, 16
	i32.shl 	$push73=, $6, $pop460
	i32.const	$push459=, 16
	i32.shr_s	$push74=, $pop73, $pop459
	i32.const	$push78=, 1500
	i32.const	$push77=, 1300
	i32.const	$push76=, 3000
	i32.const	$push75=, 6000
	call    	verify@FUNCTION, $pop68, $pop70, $pop72, $pop74, $pop78, $pop77, $pop76, $pop75
	i32.const	$push458=, 0
	i32.load16_s	$push86=, i($pop458)
	i32.const	$push457=, 0
	i32.load16_s	$push94=, j($pop457)
	i32.div_s	$0=, $pop86, $pop94
	i32.const	$push456=, 0
	i32.load16_s	$push85=, i+2($pop456)
	i32.const	$push455=, 0
	i32.load16_s	$push93=, j+2($pop455)
	i32.div_s	$4=, $pop85, $pop93
	i32.const	$push454=, 0
	i32.load16_s	$push84=, i+4($pop454)
	i32.const	$push453=, 0
	i32.load16_s	$push92=, j+4($pop453)
	i32.div_s	$5=, $pop84, $pop92
	i32.const	$push452=, 0
	i32.load16_s	$push83=, i+6($pop452)
	i32.const	$push451=, 0
	i32.load16_s	$push91=, j+6($pop451)
	i32.div_s	$6=, $pop83, $pop91
	i32.const	$push450=, 0
	i32.load16_s	$push82=, i+8($pop450)
	i32.const	$push449=, 0
	i32.load16_s	$push90=, j+8($pop449)
	i32.div_s	$13=, $pop82, $pop90
	i32.const	$push448=, 0
	i32.load16_s	$push81=, i+10($pop448)
	i32.const	$push447=, 0
	i32.load16_s	$push89=, j+10($pop447)
	i32.div_s	$12=, $pop81, $pop89
	i32.const	$push446=, 0
	i32.load16_s	$push80=, i+12($pop446)
	i32.const	$push445=, 0
	i32.load16_s	$push88=, j+12($pop445)
	i32.div_s	$11=, $pop80, $pop88
	i32.const	$push444=, 0
	i32.const	$push443=, 0
	i32.const	$push442=, 0
	i32.load16_s	$push79=, i+14($pop442)
	i32.const	$push441=, 0
	i32.load16_s	$push87=, j+14($pop441)
	i32.div_s	$push95=, $pop79, $pop87
	i32.store16	$push8=, k+14($pop443), $pop95
	i32.store16	$discard=, res+14($pop444), $pop8
	i32.const	$push440=, 0
	i32.const	$push439=, 0
	i32.store16	$push9=, k+12($pop439), $11
	i32.store16	$discard=, res+12($pop440), $pop9
	i32.const	$push438=, 0
	i32.const	$push437=, 0
	i32.store16	$push10=, k+10($pop437), $12
	i32.store16	$discard=, res+10($pop438), $pop10
	i32.const	$push436=, 0
	i32.const	$push435=, 0
	i32.store16	$push11=, k+8($pop435), $13
	i32.store16	$discard=, res+8($pop436), $pop11
	i32.const	$push434=, 0
	i32.store16	$discard=, k+6($pop434), $6
	i32.const	$push433=, 0
	i32.store16	$discard=, k+4($pop433), $5
	i32.const	$push432=, 0
	i32.store16	$discard=, k+2($pop432), $4
	i32.const	$push431=, 0
	i32.store16	$discard=, k($pop431), $0
	i32.const	$push430=, 0
	i32.store16	$discard=, res+6($pop430), $6
	i32.const	$push429=, 0
	i32.store16	$discard=, res+4($pop429), $5
	i32.const	$push428=, 0
	i32.store16	$discard=, res+2($pop428), $4
	i32.const	$push427=, 0
	i32.store16	$discard=, res($pop427), $0
	i32.const	$push426=, 16
	i32.shl 	$push96=, $0, $pop426
	i32.const	$push425=, 16
	i32.shr_s	$push97=, $pop96, $pop425
	i32.const	$push424=, 16
	i32.shl 	$push98=, $4, $pop424
	i32.const	$push423=, 16
	i32.shr_s	$push99=, $pop98, $pop423
	i32.const	$push422=, 16
	i32.shl 	$push100=, $5, $pop422
	i32.const	$push421=, 16
	i32.shr_s	$push101=, $pop100, $pop421
	i32.const	$push420=, 16
	i32.shl 	$push102=, $6, $pop420
	i32.const	$push419=, 16
	i32.shr_s	$push103=, $pop102, $pop419
	i32.const	$push106=, 15
	i32.const	$push105=, 7
	i32.const	$push418=, 7
	i32.const	$push104=, 6
	call    	verify@FUNCTION, $pop97, $pop99, $pop101, $pop103, $pop106, $pop105, $pop418, $pop104
	i32.const	$push417=, 0
	i32.load16_u	$0=, i+6($pop417)
	i32.const	$push416=, 0
	i32.load16_u	$4=, i+4($pop416)
	i32.const	$push415=, 0
	i32.load16_u	$5=, i+2($pop415)
	i32.const	$push414=, 0
	i32.load16_u	$6=, i($pop414)
	i32.const	$push413=, 0
	i32.load16_u	$13=, j($pop413)
	i32.const	$push412=, 0
	i32.load16_u	$12=, j+2($pop412)
	i32.const	$push411=, 0
	i32.load16_u	$11=, j+4($pop411)
	i32.const	$push410=, 0
	i32.load16_u	$10=, j+6($pop410)
	i32.const	$push409=, 0
	i32.load16_u	$1=, i+12($pop409)
	i32.const	$push408=, 0
	i32.load16_u	$2=, i+10($pop408)
	i32.const	$push407=, 0
	i32.load16_u	$3=, i+8($pop407)
	i32.const	$push406=, 0
	i32.load16_u	$9=, j+8($pop406)
	i32.const	$push405=, 0
	i32.load16_u	$8=, j+10($pop405)
	i32.const	$push404=, 0
	i32.load16_u	$7=, j+12($pop404)
	i32.const	$push403=, 0
	i32.const	$push402=, 0
	i32.const	$push401=, 0
	i32.load16_u	$push108=, j+14($pop401)
	i32.const	$push400=, 0
	i32.load16_u	$push107=, i+14($pop400)
	i32.and 	$push116=, $pop108, $pop107
	i32.store16	$push12=, k+14($pop402), $pop116
	i32.store16	$discard=, res+14($pop403), $pop12
	i32.const	$push399=, 0
	i32.const	$push398=, 0
	i32.and 	$push115=, $7, $1
	i32.store16	$push13=, k+12($pop398), $pop115
	i32.store16	$discard=, res+12($pop399), $pop13
	i32.const	$push397=, 0
	i32.const	$push396=, 0
	i32.and 	$push114=, $8, $2
	i32.store16	$push14=, k+10($pop396), $pop114
	i32.store16	$discard=, res+10($pop397), $pop14
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i32.and 	$push113=, $9, $3
	i32.store16	$push15=, k+8($pop394), $pop113
	i32.store16	$discard=, res+8($pop395), $pop15
	i32.const	$push393=, 0
	i32.and 	$push112=, $10, $0
	i32.store16	$10=, k+6($pop393), $pop112
	i32.const	$push392=, 0
	i32.and 	$push111=, $11, $4
	i32.store16	$4=, k+4($pop392), $pop111
	i32.const	$push391=, 0
	i32.and 	$push110=, $12, $5
	i32.store16	$5=, k+2($pop391), $pop110
	i32.const	$push390=, 0
	i32.and 	$push109=, $13, $6
	i32.store16	$0=, k($pop390), $pop109
	i32.const	$push389=, 0
	i32.store16	$6=, res+6($pop389), $10
	i32.const	$push388=, 0
	i32.store16	$discard=, res+4($pop388), $4
	i32.const	$push387=, 0
	i32.store16	$discard=, res+2($pop387), $5
	i32.const	$push386=, 0
	i32.store16	$discard=, res($pop386), $0
	i32.const	$push385=, 16
	i32.shl 	$push117=, $0, $pop385
	i32.const	$push384=, 16
	i32.shr_s	$push118=, $pop117, $pop384
	i32.const	$push383=, 16
	i32.shl 	$push119=, $5, $pop383
	i32.const	$push382=, 16
	i32.shr_s	$push120=, $pop119, $pop382
	i32.const	$push381=, 16
	i32.shl 	$push121=, $4, $pop381
	i32.const	$push380=, 16
	i32.shr_s	$push122=, $pop121, $pop380
	i32.const	$push379=, 16
	i32.shl 	$push123=, $6, $pop379
	i32.const	$push378=, 16
	i32.shr_s	$push124=, $pop123, $pop378
	i32.const	$push128=, 2
	i32.const	$push127=, 4
	i32.const	$push126=, 20
	i32.const	$push125=, 8
	call    	verify@FUNCTION, $pop118, $pop120, $pop122, $pop124, $pop128, $pop127, $pop126, $pop125
	i32.const	$push377=, 0
	i32.load16_u	$0=, i+6($pop377)
	i32.const	$push376=, 0
	i32.load16_u	$4=, i+4($pop376)
	i32.const	$push375=, 0
	i32.load16_u	$5=, i+2($pop375)
	i32.const	$push374=, 0
	i32.load16_u	$6=, i($pop374)
	i32.const	$push373=, 0
	i32.load16_u	$13=, j($pop373)
	i32.const	$push372=, 0
	i32.load16_u	$12=, j+2($pop372)
	i32.const	$push371=, 0
	i32.load16_u	$11=, j+4($pop371)
	i32.const	$push370=, 0
	i32.load16_u	$10=, j+6($pop370)
	i32.const	$push369=, 0
	i32.load16_u	$1=, i+12($pop369)
	i32.const	$push368=, 0
	i32.load16_u	$2=, i+10($pop368)
	i32.const	$push367=, 0
	i32.load16_u	$3=, i+8($pop367)
	i32.const	$push366=, 0
	i32.load16_u	$9=, j+8($pop366)
	i32.const	$push365=, 0
	i32.load16_u	$8=, j+10($pop365)
	i32.const	$push364=, 0
	i32.load16_u	$7=, j+12($pop364)
	i32.const	$push363=, 0
	i32.const	$push362=, 0
	i32.const	$push361=, 0
	i32.load16_u	$push130=, j+14($pop361)
	i32.const	$push360=, 0
	i32.load16_u	$push129=, i+14($pop360)
	i32.or  	$push138=, $pop130, $pop129
	i32.store16	$push16=, k+14($pop362), $pop138
	i32.store16	$discard=, res+14($pop363), $pop16
	i32.const	$push359=, 0
	i32.const	$push358=, 0
	i32.or  	$push137=, $7, $1
	i32.store16	$push17=, k+12($pop358), $pop137
	i32.store16	$discard=, res+12($pop359), $pop17
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i32.or  	$push136=, $8, $2
	i32.store16	$push18=, k+10($pop356), $pop136
	i32.store16	$discard=, res+10($pop357), $pop18
	i32.const	$push355=, 0
	i32.const	$push354=, 0
	i32.or  	$push135=, $9, $3
	i32.store16	$push19=, k+8($pop354), $pop135
	i32.store16	$discard=, res+8($pop355), $pop19
	i32.const	$push353=, 0
	i32.or  	$push134=, $10, $0
	i32.store16	$10=, k+6($pop353), $pop134
	i32.const	$push352=, 0
	i32.or  	$push133=, $11, $4
	i32.store16	$4=, k+4($pop352), $pop133
	i32.const	$push351=, 0
	i32.or  	$push132=, $12, $5
	i32.store16	$5=, k+2($pop351), $pop132
	i32.const	$push350=, 0
	i32.or  	$push131=, $13, $6
	i32.store16	$0=, k($pop350), $pop131
	i32.const	$push349=, 0
	i32.store16	$6=, res+6($pop349), $10
	i32.const	$push348=, 0
	i32.store16	$discard=, res+4($pop348), $4
	i32.const	$push347=, 0
	i32.store16	$discard=, res+2($pop347), $5
	i32.const	$push346=, 0
	i32.store16	$discard=, res($pop346), $0
	i32.const	$push345=, 16
	i32.shl 	$push139=, $0, $pop345
	i32.const	$push344=, 16
	i32.shr_s	$push140=, $pop139, $pop344
	i32.const	$push343=, 16
	i32.shl 	$push141=, $5, $pop343
	i32.const	$push342=, 16
	i32.shr_s	$push142=, $pop141, $pop342
	i32.const	$push341=, 16
	i32.shl 	$push143=, $4, $pop341
	i32.const	$push340=, 16
	i32.shr_s	$push144=, $pop143, $pop340
	i32.const	$push339=, 16
	i32.shl 	$push145=, $6, $pop339
	i32.const	$push338=, 16
	i32.shr_s	$push146=, $pop145, $pop338
	i32.const	$push150=, 158
	i32.const	$push149=, 109
	i32.const	$push148=, 150
	i32.const	$push147=, 222
	call    	verify@FUNCTION, $pop140, $pop142, $pop144, $pop146, $pop150, $pop149, $pop148, $pop147
	i32.const	$push337=, 0
	i32.load16_u	$0=, i+6($pop337)
	i32.const	$push336=, 0
	i32.load16_u	$4=, i+4($pop336)
	i32.const	$push335=, 0
	i32.load16_u	$5=, i+2($pop335)
	i32.const	$push334=, 0
	i32.load16_u	$6=, i($pop334)
	i32.const	$push333=, 0
	i32.load16_u	$13=, j($pop333)
	i32.const	$push332=, 0
	i32.load16_u	$12=, j+2($pop332)
	i32.const	$push331=, 0
	i32.load16_u	$11=, j+4($pop331)
	i32.const	$push330=, 0
	i32.load16_u	$10=, j+6($pop330)
	i32.const	$push329=, 0
	i32.load16_u	$1=, i+12($pop329)
	i32.const	$push328=, 0
	i32.load16_u	$2=, i+10($pop328)
	i32.const	$push327=, 0
	i32.load16_u	$3=, i+8($pop327)
	i32.const	$push326=, 0
	i32.load16_u	$9=, j+8($pop326)
	i32.const	$push325=, 0
	i32.load16_u	$8=, j+10($pop325)
	i32.const	$push324=, 0
	i32.load16_u	$7=, j+12($pop324)
	i32.const	$push323=, 0
	i32.const	$push322=, 0
	i32.const	$push321=, 0
	i32.load16_u	$push151=, i+14($pop321)
	i32.const	$push320=, 0
	i32.load16_u	$push152=, j+14($pop320)
	i32.xor 	$push160=, $pop151, $pop152
	i32.store16	$push20=, k+14($pop322), $pop160
	i32.store16	$discard=, res+14($pop323), $pop20
	i32.const	$push319=, 0
	i32.const	$push318=, 0
	i32.xor 	$push159=, $1, $7
	i32.store16	$push21=, k+12($pop318), $pop159
	i32.store16	$discard=, res+12($pop319), $pop21
	i32.const	$push317=, 0
	i32.const	$push316=, 0
	i32.xor 	$push158=, $2, $8
	i32.store16	$push22=, k+10($pop316), $pop158
	i32.store16	$discard=, res+10($pop317), $pop22
	i32.const	$push315=, 0
	i32.const	$push314=, 0
	i32.xor 	$push157=, $3, $9
	i32.store16	$push23=, k+8($pop314), $pop157
	i32.store16	$discard=, res+8($pop315), $pop23
	i32.const	$push313=, 0
	i32.xor 	$push156=, $0, $10
	i32.store16	$10=, k+6($pop313), $pop156
	i32.const	$push312=, 0
	i32.xor 	$push155=, $4, $11
	i32.store16	$4=, k+4($pop312), $pop155
	i32.const	$push311=, 0
	i32.xor 	$push154=, $5, $12
	i32.store16	$5=, k+2($pop311), $pop154
	i32.const	$push310=, 0
	i32.xor 	$push153=, $6, $13
	i32.store16	$0=, k($pop310), $pop153
	i32.const	$push309=, 0
	i32.store16	$6=, res+6($pop309), $10
	i32.const	$push308=, 0
	i32.store16	$discard=, res+4($pop308), $4
	i32.const	$push307=, 0
	i32.store16	$discard=, res+2($pop307), $5
	i32.const	$push306=, 0
	i32.store16	$discard=, res($pop306), $0
	i32.const	$push305=, 16
	i32.shl 	$push161=, $0, $pop305
	i32.const	$push304=, 16
	i32.shr_s	$push162=, $pop161, $pop304
	i32.const	$push303=, 16
	i32.shl 	$push163=, $5, $pop303
	i32.const	$push302=, 16
	i32.shr_s	$push164=, $pop163, $pop302
	i32.const	$push301=, 16
	i32.shl 	$push165=, $4, $pop301
	i32.const	$push300=, 16
	i32.shr_s	$push166=, $pop165, $pop300
	i32.const	$push299=, 16
	i32.shl 	$push167=, $6, $pop299
	i32.const	$push298=, 16
	i32.shr_s	$push168=, $pop167, $pop298
	i32.const	$push172=, 156
	i32.const	$push171=, 105
	i32.const	$push170=, 130
	i32.const	$push169=, 214
	call    	verify@FUNCTION, $pop162, $pop164, $pop166, $pop168, $pop172, $pop171, $pop170, $pop169
	i32.const	$push297=, 0
	i32.load16_u	$0=, i+12($pop297)
	i32.const	$push296=, 0
	i32.const	$push295=, 0
	i32.const	$push294=, 0
	i32.const	$push293=, 0
	i32.load16_u	$push173=, i+14($pop293)
	i32.sub 	$push182=, $pop294, $pop173
	i32.store16	$push24=, k+14($pop295), $pop182
	i32.store16	$discard=, res+14($pop296), $pop24
	i32.const	$push292=, 0
	i32.load16_u	$4=, i+10($pop292)
	i32.const	$push291=, 0
	i32.const	$push290=, 0
	i32.const	$push289=, 0
	i32.sub 	$push181=, $pop289, $0
	i32.store16	$push25=, k+12($pop290), $pop181
	i32.store16	$discard=, res+12($pop291), $pop25
	i32.const	$push288=, 0
	i32.load16_u	$0=, i+8($pop288)
	i32.const	$push287=, 0
	i32.const	$push286=, 0
	i32.const	$push285=, 0
	i32.sub 	$push180=, $pop285, $4
	i32.store16	$push26=, k+10($pop286), $pop180
	i32.store16	$discard=, res+10($pop287), $pop26
	i32.const	$push284=, 0
	i32.const	$push283=, 0
	i32.const	$push282=, 0
	i32.sub 	$push179=, $pop282, $0
	i32.store16	$push27=, k+8($pop283), $pop179
	i32.store16	$discard=, res+8($pop284), $pop27
	i32.const	$push281=, 0
	i32.load16_u	$0=, i($pop281)
	i32.const	$push280=, 0
	i32.load16_u	$4=, i+2($pop280)
	i32.const	$push279=, 0
	i32.load16_u	$5=, i+4($pop279)
	i32.const	$push278=, 0
	i32.const	$push277=, 0
	i32.const	$push276=, 0
	i32.load16_u	$push174=, i+6($pop276)
	i32.sub 	$push178=, $pop277, $pop174
	i32.store16	$6=, k+6($pop278), $pop178
	i32.const	$push275=, 0
	i32.const	$push274=, 0
	i32.sub 	$push177=, $pop274, $5
	i32.store16	$5=, k+4($pop275), $pop177
	i32.const	$push273=, 0
	i32.const	$push272=, 0
	i32.sub 	$push176=, $pop272, $4
	i32.store16	$4=, k+2($pop273), $pop176
	i32.const	$push271=, 0
	i32.const	$push270=, 0
	i32.sub 	$push175=, $pop270, $0
	i32.store16	$0=, k($pop271), $pop175
	i32.const	$push269=, 0
	i32.store16	$discard=, res+6($pop269), $6
	i32.const	$push268=, 0
	i32.store16	$discard=, res+4($pop268), $5
	i32.const	$push267=, 0
	i32.store16	$discard=, res+2($pop267), $4
	i32.const	$push266=, 0
	i32.store16	$discard=, res($pop266), $0
	i32.const	$push265=, 16
	i32.shl 	$push183=, $0, $pop265
	i32.const	$push264=, 16
	i32.shr_s	$push184=, $pop183, $pop264
	i32.const	$push263=, 16
	i32.shl 	$push185=, $4, $pop263
	i32.const	$push262=, 16
	i32.shr_s	$push186=, $pop185, $pop262
	i32.const	$push261=, 16
	i32.shl 	$push187=, $5, $pop261
	i32.const	$push260=, 16
	i32.shr_s	$push188=, $pop187, $pop260
	i32.const	$push259=, 16
	i32.shl 	$push189=, $6, $pop259
	i32.const	$push258=, 16
	i32.shr_s	$push190=, $pop189, $pop258
	i32.const	$push193=, -150
	i32.const	$push192=, -100
	i32.const	$push257=, -150
	i32.const	$push191=, -200
	call    	verify@FUNCTION, $pop184, $pop186, $pop188, $pop190, $pop193, $pop192, $pop257, $pop191
	i32.const	$push256=, 0
	i32.load16_u	$0=, i+6($pop256)
	i32.const	$push255=, 0
	i32.load16_u	$4=, i($pop255)
	i32.const	$push254=, 0
	i32.load16_u	$5=, i+2($pop254)
	i32.const	$push253=, 0
	i32.load16_u	$6=, i+4($pop253)
	i32.const	$push252=, 0
	i32.load16_u	$13=, i+8($pop252)
	i32.const	$push251=, 0
	i32.load16_u	$12=, i+10($pop251)
	i32.const	$push250=, 0
	i32.load16_u	$11=, i+12($pop250)
	i32.const	$push249=, 0
	i32.const	$push248=, 0
	i32.const	$push247=, 0
	i32.load16_u	$push194=, i+14($pop247)
	i32.const	$push195=, -1
	i32.xor 	$push202=, $pop194, $pop195
	i32.store16	$push28=, k+14($pop248), $pop202
	i32.store16	$discard=, res+14($pop249), $pop28
	i32.const	$push246=, 0
	i32.const	$push245=, 0
	i32.const	$push244=, -1
	i32.xor 	$push201=, $11, $pop244
	i32.store16	$push29=, k+12($pop245), $pop201
	i32.store16	$discard=, res+12($pop246), $pop29
	i32.const	$push243=, 0
	i32.const	$push242=, 0
	i32.const	$push241=, -1
	i32.xor 	$push200=, $12, $pop241
	i32.store16	$push30=, k+10($pop242), $pop200
	i32.store16	$discard=, res+10($pop243), $pop30
	i32.const	$push240=, 0
	i32.const	$push239=, 0
	i32.const	$push238=, -1
	i32.xor 	$push199=, $13, $pop238
	i32.store16	$push31=, k+8($pop239), $pop199
	i32.store16	$discard=, res+8($pop240), $pop31
	i32.const	$push237=, 0
	i32.const	$push236=, -1
	i32.xor 	$push198=, $0, $pop236
	i32.store16	$0=, k+6($pop237), $pop198
	i32.const	$push235=, 0
	i32.const	$push234=, -1
	i32.xor 	$push197=, $6, $pop234
	i32.store16	$6=, k+4($pop235), $pop197
	i32.const	$push233=, 0
	i32.const	$push232=, -1
	i32.xor 	$push196=, $5, $pop232
	i32.store16	$5=, k+2($pop233), $pop196
	i32.const	$push231=, 0
	i32.store16	$discard=, res+6($pop231), $0
	i32.const	$push230=, 0
	i32.store16	$discard=, res+4($pop230), $6
	i32.const	$push229=, 0
	i32.store16	$discard=, res+2($pop229), $5
	i32.const	$push228=, 0
	i32.const	$push227=, 0
	i32.const	$push226=, -1
	i32.xor 	$push225=, $4, $pop226
	tee_local	$push224=, $4=, $pop225
	i32.store16	$push32=, k($pop227), $pop224
	i32.store16	$discard=, res($pop228), $pop32
	i32.const	$push223=, 16
	i32.shl 	$push203=, $4, $pop223
	i32.const	$push222=, 16
	i32.shr_s	$push204=, $pop203, $pop222
	i32.const	$push221=, 16
	i32.shl 	$push205=, $5, $pop221
	i32.const	$push220=, 16
	i32.shr_s	$push206=, $pop205, $pop220
	i32.const	$push219=, 16
	i32.shl 	$push207=, $6, $pop219
	i32.const	$push218=, 16
	i32.shr_s	$push208=, $pop207, $pop218
	i32.const	$push217=, 16
	i32.shl 	$push209=, $0, $pop217
	i32.const	$push216=, 16
	i32.shr_s	$push210=, $pop209, $pop216
	i32.const	$push213=, -151
	i32.const	$push212=, -101
	i32.const	$push215=, -151
	i32.const	$push211=, -201
	call    	verify@FUNCTION, $pop204, $pop206, $pop208, $pop210, $pop213, $pop212, $pop215, $pop211
	i32.const	$push214=, 0
	call    	exit@FUNCTION, $pop214
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
