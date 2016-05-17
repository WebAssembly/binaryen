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
	i32.const	$push529=, 0
	i32.load16_u	$4=, i+4($pop529)
	i32.const	$push528=, 0
	i32.load16_u	$5=, i+2($pop528)
	i32.const	$push527=, 0
	i32.load16_u	$6=, i($pop527)
	i32.const	$push526=, 0
	i32.load16_u	$13=, j($pop526)
	i32.const	$push525=, 0
	i32.load16_u	$12=, j+2($pop525)
	i32.const	$push524=, 0
	i32.load16_u	$11=, j+4($pop524)
	i32.const	$push523=, 0
	i32.load16_u	$10=, j+6($pop523)
	i32.const	$push522=, 0
	i32.load16_u	$1=, i+12($pop522)
	i32.const	$push521=, 0
	i32.load16_u	$2=, i+10($pop521)
	i32.const	$push520=, 0
	i32.load16_u	$3=, i+8($pop520)
	i32.const	$push519=, 0
	i32.load16_u	$9=, j+8($pop519)
	i32.const	$push518=, 0
	i32.load16_u	$8=, j+10($pop518)
	i32.const	$push517=, 0
	i32.load16_u	$7=, j+12($pop517)
	i32.const	$push516=, 0
	i32.const	$push515=, 0
	i32.const	$push514=, 0
	i32.load16_u	$push35=, j+14($pop514)
	i32.const	$push513=, 0
	i32.load16_u	$push34=, i+14($pop513)
	i32.add 	$push43=, $pop35, $pop34
	i32.store16	$push0=, k+14($pop515), $pop43
	i32.store16	$drop=, res+14($pop516), $pop0
	i32.const	$push512=, 0
	i32.const	$push511=, 0
	i32.add 	$push42=, $7, $1
	i32.store16	$push1=, k+12($pop511), $pop42
	i32.store16	$drop=, res+12($pop512), $pop1
	i32.const	$push510=, 0
	i32.const	$push509=, 0
	i32.add 	$push41=, $8, $2
	i32.store16	$push2=, k+10($pop509), $pop41
	i32.store16	$drop=, res+10($pop510), $pop2
	i32.const	$push508=, 0
	i32.const	$push507=, 0
	i32.add 	$push40=, $9, $3
	i32.store16	$push3=, k+8($pop507), $pop40
	i32.store16	$drop=, res+8($pop508), $pop3
	i32.const	$push506=, 0
	i32.add 	$push39=, $10, $0
	i32.store16	$10=, k+6($pop506), $pop39
	i32.const	$push505=, 0
	i32.add 	$push38=, $11, $4
	i32.store16	$4=, k+4($pop505), $pop38
	i32.const	$push504=, 0
	i32.add 	$push37=, $12, $5
	i32.store16	$5=, k+2($pop504), $pop37
	i32.const	$push503=, 0
	i32.add 	$push36=, $13, $6
	i32.store16	$0=, k($pop503), $pop36
	i32.const	$push502=, 0
	i32.store16	$6=, res+6($pop502), $10
	i32.const	$push501=, 0
	i32.store16	$drop=, res+4($pop501), $4
	i32.const	$push500=, 0
	i32.store16	$drop=, res+2($pop500), $5
	i32.const	$push499=, 0
	i32.store16	$drop=, res($pop499), $0
	i32.const	$push44=, 16
	i32.shl 	$push45=, $0, $pop44
	i32.const	$push498=, 16
	i32.shr_s	$push46=, $pop45, $pop498
	i32.const	$push497=, 16
	i32.shl 	$push47=, $5, $pop497
	i32.const	$push496=, 16
	i32.shr_s	$push48=, $pop47, $pop496
	i32.const	$push495=, 16
	i32.shl 	$push49=, $4, $pop495
	i32.const	$push494=, 16
	i32.shr_s	$push50=, $pop49, $pop494
	i32.const	$push493=, 16
	i32.shl 	$push51=, $6, $pop493
	i32.const	$push492=, 16
	i32.shr_s	$push52=, $pop51, $pop492
	i32.const	$push56=, 160
	i32.const	$push55=, 113
	i32.const	$push54=, 170
	i32.const	$push53=, 230
	call    	verify@FUNCTION, $pop46, $pop48, $pop50, $pop52, $pop56, $pop55, $pop54, $pop53
	i32.const	$push491=, 0
	i32.load16_u	$0=, i+6($pop491)
	i32.const	$push490=, 0
	i32.load16_u	$4=, i+4($pop490)
	i32.const	$push489=, 0
	i32.load16_u	$5=, i+2($pop489)
	i32.const	$push488=, 0
	i32.load16_u	$6=, i($pop488)
	i32.const	$push487=, 0
	i32.load16_u	$13=, j($pop487)
	i32.const	$push486=, 0
	i32.load16_u	$12=, j+2($pop486)
	i32.const	$push485=, 0
	i32.load16_u	$11=, j+4($pop485)
	i32.const	$push484=, 0
	i32.load16_u	$10=, j+6($pop484)
	i32.const	$push483=, 0
	i32.load16_u	$1=, i+12($pop483)
	i32.const	$push482=, 0
	i32.load16_u	$2=, i+10($pop482)
	i32.const	$push481=, 0
	i32.load16_u	$3=, i+8($pop481)
	i32.const	$push480=, 0
	i32.load16_u	$9=, j+8($pop480)
	i32.const	$push479=, 0
	i32.load16_u	$8=, j+10($pop479)
	i32.const	$push478=, 0
	i32.load16_u	$7=, j+12($pop478)
	i32.const	$push477=, 0
	i32.const	$push476=, 0
	i32.const	$push475=, 0
	i32.load16_u	$push58=, j+14($pop475)
	i32.const	$push474=, 0
	i32.load16_u	$push57=, i+14($pop474)
	i32.mul 	$push66=, $pop58, $pop57
	i32.store16	$push4=, k+14($pop476), $pop66
	i32.store16	$drop=, res+14($pop477), $pop4
	i32.const	$push473=, 0
	i32.const	$push472=, 0
	i32.mul 	$push65=, $7, $1
	i32.store16	$push5=, k+12($pop472), $pop65
	i32.store16	$drop=, res+12($pop473), $pop5
	i32.const	$push471=, 0
	i32.const	$push470=, 0
	i32.mul 	$push64=, $8, $2
	i32.store16	$push6=, k+10($pop470), $pop64
	i32.store16	$drop=, res+10($pop471), $pop6
	i32.const	$push469=, 0
	i32.const	$push468=, 0
	i32.mul 	$push63=, $9, $3
	i32.store16	$push7=, k+8($pop468), $pop63
	i32.store16	$drop=, res+8($pop469), $pop7
	i32.const	$push467=, 0
	i32.mul 	$push62=, $10, $0
	i32.store16	$10=, k+6($pop467), $pop62
	i32.const	$push466=, 0
	i32.mul 	$push61=, $11, $4
	i32.store16	$4=, k+4($pop466), $pop61
	i32.const	$push465=, 0
	i32.mul 	$push60=, $12, $5
	i32.store16	$5=, k+2($pop465), $pop60
	i32.const	$push464=, 0
	i32.mul 	$push59=, $13, $6
	i32.store16	$0=, k($pop464), $pop59
	i32.const	$push463=, 0
	i32.store16	$6=, res+6($pop463), $10
	i32.const	$push462=, 0
	i32.store16	$drop=, res+4($pop462), $4
	i32.const	$push461=, 0
	i32.store16	$drop=, res+2($pop461), $5
	i32.const	$push460=, 0
	i32.store16	$drop=, res($pop460), $0
	i32.const	$push459=, 16
	i32.shl 	$push67=, $0, $pop459
	i32.const	$push458=, 16
	i32.shr_s	$push68=, $pop67, $pop458
	i32.const	$push457=, 16
	i32.shl 	$push69=, $5, $pop457
	i32.const	$push456=, 16
	i32.shr_s	$push70=, $pop69, $pop456
	i32.const	$push455=, 16
	i32.shl 	$push71=, $4, $pop455
	i32.const	$push454=, 16
	i32.shr_s	$push72=, $pop71, $pop454
	i32.const	$push453=, 16
	i32.shl 	$push73=, $6, $pop453
	i32.const	$push452=, 16
	i32.shr_s	$push74=, $pop73, $pop452
	i32.const	$push78=, 1500
	i32.const	$push77=, 1300
	i32.const	$push76=, 3000
	i32.const	$push75=, 6000
	call    	verify@FUNCTION, $pop68, $pop70, $pop72, $pop74, $pop78, $pop77, $pop76, $pop75
	i32.const	$push451=, 0
	i32.load16_s	$0=, i+12($pop451)
	i32.const	$push450=, 0
	i32.load16_s	$4=, i+10($pop450)
	i32.const	$push449=, 0
	i32.load16_s	$5=, i+8($pop449)
	i32.const	$push448=, 0
	i32.load16_s	$6=, i+6($pop448)
	i32.const	$push447=, 0
	i32.load16_s	$13=, i+4($pop447)
	i32.const	$push446=, 0
	i32.load16_s	$12=, i+2($pop446)
	i32.const	$push445=, 0
	i32.load16_s	$11=, i($pop445)
	i32.const	$push444=, 0
	i32.load16_s	$10=, j+12($pop444)
	i32.const	$push443=, 0
	i32.load16_s	$1=, j+10($pop443)
	i32.const	$push442=, 0
	i32.load16_s	$2=, j+8($pop442)
	i32.const	$push441=, 0
	i32.load16_s	$3=, j($pop441)
	i32.const	$push440=, 0
	i32.load16_s	$9=, j+2($pop440)
	i32.const	$push439=, 0
	i32.load16_s	$8=, j+4($pop439)
	i32.const	$push438=, 0
	i32.load16_s	$7=, j+6($pop438)
	i32.const	$push437=, 0
	i32.const	$push436=, 0
	i32.const	$push435=, 0
	i32.load16_s	$push79=, i+14($pop435)
	i32.const	$push434=, 0
	i32.load16_s	$push80=, j+14($pop434)
	i32.div_s	$push88=, $pop79, $pop80
	i32.store16	$push8=, k+14($pop436), $pop88
	i32.store16	$drop=, res+14($pop437), $pop8
	i32.const	$push433=, 0
	i32.const	$push432=, 0
	i32.div_s	$push87=, $0, $10
	i32.store16	$push9=, k+12($pop432), $pop87
	i32.store16	$drop=, res+12($pop433), $pop9
	i32.const	$push431=, 0
	i32.const	$push430=, 0
	i32.div_s	$push86=, $4, $1
	i32.store16	$push10=, k+10($pop430), $pop86
	i32.store16	$drop=, res+10($pop431), $pop10
	i32.const	$push429=, 0
	i32.const	$push428=, 0
	i32.div_s	$push85=, $5, $2
	i32.store16	$push11=, k+8($pop428), $pop85
	i32.store16	$drop=, res+8($pop429), $pop11
	i32.const	$push427=, 0
	i32.div_s	$push84=, $6, $7
	i32.store16	$4=, k+6($pop427), $pop84
	i32.const	$push426=, 0
	i32.div_s	$push83=, $13, $8
	i32.store16	$5=, k+4($pop426), $pop83
	i32.const	$push425=, 0
	i32.div_s	$push82=, $12, $9
	i32.store16	$6=, k+2($pop425), $pop82
	i32.const	$push424=, 0
	i32.div_s	$push81=, $11, $3
	i32.store16	$0=, k($pop424), $pop81
	i32.const	$push423=, 0
	i32.store16	$drop=, res+6($pop423), $4
	i32.const	$push422=, 0
	i32.store16	$drop=, res+4($pop422), $5
	i32.const	$push421=, 0
	i32.store16	$drop=, res+2($pop421), $6
	i32.const	$push420=, 0
	i32.store16	$drop=, res($pop420), $0
	i32.const	$push419=, 16
	i32.shl 	$push89=, $0, $pop419
	i32.const	$push418=, 16
	i32.shr_s	$push90=, $pop89, $pop418
	i32.const	$push417=, 16
	i32.shl 	$push91=, $6, $pop417
	i32.const	$push416=, 16
	i32.shr_s	$push92=, $pop91, $pop416
	i32.const	$push415=, 16
	i32.shl 	$push93=, $5, $pop415
	i32.const	$push414=, 16
	i32.shr_s	$push94=, $pop93, $pop414
	i32.const	$push413=, 16
	i32.shl 	$push95=, $4, $pop413
	i32.const	$push412=, 16
	i32.shr_s	$push96=, $pop95, $pop412
	i32.const	$push99=, 15
	i32.const	$push98=, 7
	i32.const	$push411=, 7
	i32.const	$push97=, 6
	call    	verify@FUNCTION, $pop90, $pop92, $pop94, $pop96, $pop99, $pop98, $pop411, $pop97
	i32.const	$push410=, 0
	i32.load16_u	$0=, i+6($pop410)
	i32.const	$push409=, 0
	i32.load16_u	$4=, i+4($pop409)
	i32.const	$push408=, 0
	i32.load16_u	$5=, i+2($pop408)
	i32.const	$push407=, 0
	i32.load16_u	$6=, i($pop407)
	i32.const	$push406=, 0
	i32.load16_u	$13=, j($pop406)
	i32.const	$push405=, 0
	i32.load16_u	$12=, j+2($pop405)
	i32.const	$push404=, 0
	i32.load16_u	$11=, j+4($pop404)
	i32.const	$push403=, 0
	i32.load16_u	$10=, j+6($pop403)
	i32.const	$push402=, 0
	i32.load16_u	$1=, i+12($pop402)
	i32.const	$push401=, 0
	i32.load16_u	$2=, i+10($pop401)
	i32.const	$push400=, 0
	i32.load16_u	$3=, i+8($pop400)
	i32.const	$push399=, 0
	i32.load16_u	$9=, j+8($pop399)
	i32.const	$push398=, 0
	i32.load16_u	$8=, j+10($pop398)
	i32.const	$push397=, 0
	i32.load16_u	$7=, j+12($pop397)
	i32.const	$push396=, 0
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i32.load16_u	$push101=, j+14($pop394)
	i32.const	$push393=, 0
	i32.load16_u	$push100=, i+14($pop393)
	i32.and 	$push109=, $pop101, $pop100
	i32.store16	$push12=, k+14($pop395), $pop109
	i32.store16	$drop=, res+14($pop396), $pop12
	i32.const	$push392=, 0
	i32.const	$push391=, 0
	i32.and 	$push108=, $7, $1
	i32.store16	$push13=, k+12($pop391), $pop108
	i32.store16	$drop=, res+12($pop392), $pop13
	i32.const	$push390=, 0
	i32.const	$push389=, 0
	i32.and 	$push107=, $8, $2
	i32.store16	$push14=, k+10($pop389), $pop107
	i32.store16	$drop=, res+10($pop390), $pop14
	i32.const	$push388=, 0
	i32.const	$push387=, 0
	i32.and 	$push106=, $9, $3
	i32.store16	$push15=, k+8($pop387), $pop106
	i32.store16	$drop=, res+8($pop388), $pop15
	i32.const	$push386=, 0
	i32.and 	$push105=, $10, $0
	i32.store16	$10=, k+6($pop386), $pop105
	i32.const	$push385=, 0
	i32.and 	$push104=, $11, $4
	i32.store16	$4=, k+4($pop385), $pop104
	i32.const	$push384=, 0
	i32.and 	$push103=, $12, $5
	i32.store16	$5=, k+2($pop384), $pop103
	i32.const	$push383=, 0
	i32.and 	$push102=, $13, $6
	i32.store16	$0=, k($pop383), $pop102
	i32.const	$push382=, 0
	i32.store16	$6=, res+6($pop382), $10
	i32.const	$push381=, 0
	i32.store16	$drop=, res+4($pop381), $4
	i32.const	$push380=, 0
	i32.store16	$drop=, res+2($pop380), $5
	i32.const	$push379=, 0
	i32.store16	$drop=, res($pop379), $0
	i32.const	$push378=, 16
	i32.shl 	$push110=, $0, $pop378
	i32.const	$push377=, 16
	i32.shr_s	$push111=, $pop110, $pop377
	i32.const	$push376=, 16
	i32.shl 	$push112=, $5, $pop376
	i32.const	$push375=, 16
	i32.shr_s	$push113=, $pop112, $pop375
	i32.const	$push374=, 16
	i32.shl 	$push114=, $4, $pop374
	i32.const	$push373=, 16
	i32.shr_s	$push115=, $pop114, $pop373
	i32.const	$push372=, 16
	i32.shl 	$push116=, $6, $pop372
	i32.const	$push371=, 16
	i32.shr_s	$push117=, $pop116, $pop371
	i32.const	$push121=, 2
	i32.const	$push120=, 4
	i32.const	$push119=, 20
	i32.const	$push118=, 8
	call    	verify@FUNCTION, $pop111, $pop113, $pop115, $pop117, $pop121, $pop120, $pop119, $pop118
	i32.const	$push370=, 0
	i32.load16_u	$0=, i+6($pop370)
	i32.const	$push369=, 0
	i32.load16_u	$4=, i+4($pop369)
	i32.const	$push368=, 0
	i32.load16_u	$5=, i+2($pop368)
	i32.const	$push367=, 0
	i32.load16_u	$6=, i($pop367)
	i32.const	$push366=, 0
	i32.load16_u	$13=, j($pop366)
	i32.const	$push365=, 0
	i32.load16_u	$12=, j+2($pop365)
	i32.const	$push364=, 0
	i32.load16_u	$11=, j+4($pop364)
	i32.const	$push363=, 0
	i32.load16_u	$10=, j+6($pop363)
	i32.const	$push362=, 0
	i32.load16_u	$1=, i+12($pop362)
	i32.const	$push361=, 0
	i32.load16_u	$2=, i+10($pop361)
	i32.const	$push360=, 0
	i32.load16_u	$3=, i+8($pop360)
	i32.const	$push359=, 0
	i32.load16_u	$9=, j+8($pop359)
	i32.const	$push358=, 0
	i32.load16_u	$8=, j+10($pop358)
	i32.const	$push357=, 0
	i32.load16_u	$7=, j+12($pop357)
	i32.const	$push356=, 0
	i32.const	$push355=, 0
	i32.const	$push354=, 0
	i32.load16_u	$push123=, j+14($pop354)
	i32.const	$push353=, 0
	i32.load16_u	$push122=, i+14($pop353)
	i32.or  	$push131=, $pop123, $pop122
	i32.store16	$push16=, k+14($pop355), $pop131
	i32.store16	$drop=, res+14($pop356), $pop16
	i32.const	$push352=, 0
	i32.const	$push351=, 0
	i32.or  	$push130=, $7, $1
	i32.store16	$push17=, k+12($pop351), $pop130
	i32.store16	$drop=, res+12($pop352), $pop17
	i32.const	$push350=, 0
	i32.const	$push349=, 0
	i32.or  	$push129=, $8, $2
	i32.store16	$push18=, k+10($pop349), $pop129
	i32.store16	$drop=, res+10($pop350), $pop18
	i32.const	$push348=, 0
	i32.const	$push347=, 0
	i32.or  	$push128=, $9, $3
	i32.store16	$push19=, k+8($pop347), $pop128
	i32.store16	$drop=, res+8($pop348), $pop19
	i32.const	$push346=, 0
	i32.or  	$push127=, $10, $0
	i32.store16	$10=, k+6($pop346), $pop127
	i32.const	$push345=, 0
	i32.or  	$push126=, $11, $4
	i32.store16	$4=, k+4($pop345), $pop126
	i32.const	$push344=, 0
	i32.or  	$push125=, $12, $5
	i32.store16	$5=, k+2($pop344), $pop125
	i32.const	$push343=, 0
	i32.or  	$push124=, $13, $6
	i32.store16	$0=, k($pop343), $pop124
	i32.const	$push342=, 0
	i32.store16	$6=, res+6($pop342), $10
	i32.const	$push341=, 0
	i32.store16	$drop=, res+4($pop341), $4
	i32.const	$push340=, 0
	i32.store16	$drop=, res+2($pop340), $5
	i32.const	$push339=, 0
	i32.store16	$drop=, res($pop339), $0
	i32.const	$push338=, 16
	i32.shl 	$push132=, $0, $pop338
	i32.const	$push337=, 16
	i32.shr_s	$push133=, $pop132, $pop337
	i32.const	$push336=, 16
	i32.shl 	$push134=, $5, $pop336
	i32.const	$push335=, 16
	i32.shr_s	$push135=, $pop134, $pop335
	i32.const	$push334=, 16
	i32.shl 	$push136=, $4, $pop334
	i32.const	$push333=, 16
	i32.shr_s	$push137=, $pop136, $pop333
	i32.const	$push332=, 16
	i32.shl 	$push138=, $6, $pop332
	i32.const	$push331=, 16
	i32.shr_s	$push139=, $pop138, $pop331
	i32.const	$push143=, 158
	i32.const	$push142=, 109
	i32.const	$push141=, 150
	i32.const	$push140=, 222
	call    	verify@FUNCTION, $pop133, $pop135, $pop137, $pop139, $pop143, $pop142, $pop141, $pop140
	i32.const	$push330=, 0
	i32.load16_u	$0=, i+6($pop330)
	i32.const	$push329=, 0
	i32.load16_u	$4=, i+4($pop329)
	i32.const	$push328=, 0
	i32.load16_u	$5=, i+2($pop328)
	i32.const	$push327=, 0
	i32.load16_u	$6=, i($pop327)
	i32.const	$push326=, 0
	i32.load16_u	$13=, j($pop326)
	i32.const	$push325=, 0
	i32.load16_u	$12=, j+2($pop325)
	i32.const	$push324=, 0
	i32.load16_u	$11=, j+4($pop324)
	i32.const	$push323=, 0
	i32.load16_u	$10=, j+6($pop323)
	i32.const	$push322=, 0
	i32.load16_u	$1=, i+12($pop322)
	i32.const	$push321=, 0
	i32.load16_u	$2=, i+10($pop321)
	i32.const	$push320=, 0
	i32.load16_u	$3=, i+8($pop320)
	i32.const	$push319=, 0
	i32.load16_u	$9=, j+8($pop319)
	i32.const	$push318=, 0
	i32.load16_u	$8=, j+10($pop318)
	i32.const	$push317=, 0
	i32.load16_u	$7=, j+12($pop317)
	i32.const	$push316=, 0
	i32.const	$push315=, 0
	i32.const	$push314=, 0
	i32.load16_u	$push144=, i+14($pop314)
	i32.const	$push313=, 0
	i32.load16_u	$push145=, j+14($pop313)
	i32.xor 	$push153=, $pop144, $pop145
	i32.store16	$push20=, k+14($pop315), $pop153
	i32.store16	$drop=, res+14($pop316), $pop20
	i32.const	$push312=, 0
	i32.const	$push311=, 0
	i32.xor 	$push152=, $1, $7
	i32.store16	$push21=, k+12($pop311), $pop152
	i32.store16	$drop=, res+12($pop312), $pop21
	i32.const	$push310=, 0
	i32.const	$push309=, 0
	i32.xor 	$push151=, $2, $8
	i32.store16	$push22=, k+10($pop309), $pop151
	i32.store16	$drop=, res+10($pop310), $pop22
	i32.const	$push308=, 0
	i32.const	$push307=, 0
	i32.xor 	$push150=, $3, $9
	i32.store16	$push23=, k+8($pop307), $pop150
	i32.store16	$drop=, res+8($pop308), $pop23
	i32.const	$push306=, 0
	i32.xor 	$push149=, $0, $10
	i32.store16	$10=, k+6($pop306), $pop149
	i32.const	$push305=, 0
	i32.xor 	$push148=, $4, $11
	i32.store16	$4=, k+4($pop305), $pop148
	i32.const	$push304=, 0
	i32.xor 	$push147=, $5, $12
	i32.store16	$5=, k+2($pop304), $pop147
	i32.const	$push303=, 0
	i32.xor 	$push146=, $6, $13
	i32.store16	$0=, k($pop303), $pop146
	i32.const	$push302=, 0
	i32.store16	$6=, res+6($pop302), $10
	i32.const	$push301=, 0
	i32.store16	$drop=, res+4($pop301), $4
	i32.const	$push300=, 0
	i32.store16	$drop=, res+2($pop300), $5
	i32.const	$push299=, 0
	i32.store16	$drop=, res($pop299), $0
	i32.const	$push298=, 16
	i32.shl 	$push154=, $0, $pop298
	i32.const	$push297=, 16
	i32.shr_s	$push155=, $pop154, $pop297
	i32.const	$push296=, 16
	i32.shl 	$push156=, $5, $pop296
	i32.const	$push295=, 16
	i32.shr_s	$push157=, $pop156, $pop295
	i32.const	$push294=, 16
	i32.shl 	$push158=, $4, $pop294
	i32.const	$push293=, 16
	i32.shr_s	$push159=, $pop158, $pop293
	i32.const	$push292=, 16
	i32.shl 	$push160=, $6, $pop292
	i32.const	$push291=, 16
	i32.shr_s	$push161=, $pop160, $pop291
	i32.const	$push165=, 156
	i32.const	$push164=, 105
	i32.const	$push163=, 130
	i32.const	$push162=, 214
	call    	verify@FUNCTION, $pop155, $pop157, $pop159, $pop161, $pop165, $pop164, $pop163, $pop162
	i32.const	$push290=, 0
	i32.load16_u	$0=, i+12($pop290)
	i32.const	$push289=, 0
	i32.const	$push288=, 0
	i32.const	$push287=, 0
	i32.const	$push286=, 0
	i32.load16_u	$push166=, i+14($pop286)
	i32.sub 	$push175=, $pop287, $pop166
	i32.store16	$push24=, k+14($pop288), $pop175
	i32.store16	$drop=, res+14($pop289), $pop24
	i32.const	$push285=, 0
	i32.load16_u	$4=, i+10($pop285)
	i32.const	$push284=, 0
	i32.const	$push283=, 0
	i32.const	$push282=, 0
	i32.sub 	$push174=, $pop282, $0
	i32.store16	$push25=, k+12($pop283), $pop174
	i32.store16	$drop=, res+12($pop284), $pop25
	i32.const	$push281=, 0
	i32.load16_u	$0=, i+8($pop281)
	i32.const	$push280=, 0
	i32.const	$push279=, 0
	i32.const	$push278=, 0
	i32.sub 	$push173=, $pop278, $4
	i32.store16	$push26=, k+10($pop279), $pop173
	i32.store16	$drop=, res+10($pop280), $pop26
	i32.const	$push277=, 0
	i32.const	$push276=, 0
	i32.const	$push275=, 0
	i32.sub 	$push172=, $pop275, $0
	i32.store16	$push27=, k+8($pop276), $pop172
	i32.store16	$drop=, res+8($pop277), $pop27
	i32.const	$push274=, 0
	i32.load16_u	$0=, i($pop274)
	i32.const	$push273=, 0
	i32.load16_u	$4=, i+2($pop273)
	i32.const	$push272=, 0
	i32.load16_u	$5=, i+4($pop272)
	i32.const	$push271=, 0
	i32.const	$push270=, 0
	i32.const	$push269=, 0
	i32.load16_u	$push167=, i+6($pop269)
	i32.sub 	$push171=, $pop270, $pop167
	i32.store16	$6=, k+6($pop271), $pop171
	i32.const	$push268=, 0
	i32.const	$push267=, 0
	i32.sub 	$push170=, $pop267, $5
	i32.store16	$5=, k+4($pop268), $pop170
	i32.const	$push266=, 0
	i32.const	$push265=, 0
	i32.sub 	$push169=, $pop265, $4
	i32.store16	$4=, k+2($pop266), $pop169
	i32.const	$push264=, 0
	i32.const	$push263=, 0
	i32.sub 	$push168=, $pop263, $0
	i32.store16	$0=, k($pop264), $pop168
	i32.const	$push262=, 0
	i32.store16	$drop=, res+6($pop262), $6
	i32.const	$push261=, 0
	i32.store16	$drop=, res+4($pop261), $5
	i32.const	$push260=, 0
	i32.store16	$drop=, res+2($pop260), $4
	i32.const	$push259=, 0
	i32.store16	$drop=, res($pop259), $0
	i32.const	$push258=, 16
	i32.shl 	$push176=, $0, $pop258
	i32.const	$push257=, 16
	i32.shr_s	$push177=, $pop176, $pop257
	i32.const	$push256=, 16
	i32.shl 	$push178=, $4, $pop256
	i32.const	$push255=, 16
	i32.shr_s	$push179=, $pop178, $pop255
	i32.const	$push254=, 16
	i32.shl 	$push180=, $5, $pop254
	i32.const	$push253=, 16
	i32.shr_s	$push181=, $pop180, $pop253
	i32.const	$push252=, 16
	i32.shl 	$push182=, $6, $pop252
	i32.const	$push251=, 16
	i32.shr_s	$push183=, $pop182, $pop251
	i32.const	$push186=, -150
	i32.const	$push185=, -100
	i32.const	$push250=, -150
	i32.const	$push184=, -200
	call    	verify@FUNCTION, $pop177, $pop179, $pop181, $pop183, $pop186, $pop185, $pop250, $pop184
	i32.const	$push249=, 0
	i32.load16_u	$0=, i+6($pop249)
	i32.const	$push248=, 0
	i32.load16_u	$4=, i($pop248)
	i32.const	$push247=, 0
	i32.load16_u	$5=, i+2($pop247)
	i32.const	$push246=, 0
	i32.load16_u	$6=, i+4($pop246)
	i32.const	$push245=, 0
	i32.load16_u	$13=, i+8($pop245)
	i32.const	$push244=, 0
	i32.load16_u	$12=, i+10($pop244)
	i32.const	$push243=, 0
	i32.load16_u	$11=, i+12($pop243)
	i32.const	$push242=, 0
	i32.const	$push241=, 0
	i32.const	$push240=, 0
	i32.load16_u	$push187=, i+14($pop240)
	i32.const	$push188=, -1
	i32.xor 	$push195=, $pop187, $pop188
	i32.store16	$push28=, k+14($pop241), $pop195
	i32.store16	$drop=, res+14($pop242), $pop28
	i32.const	$push239=, 0
	i32.const	$push238=, 0
	i32.const	$push237=, -1
	i32.xor 	$push194=, $11, $pop237
	i32.store16	$push29=, k+12($pop238), $pop194
	i32.store16	$drop=, res+12($pop239), $pop29
	i32.const	$push236=, 0
	i32.const	$push235=, 0
	i32.const	$push234=, -1
	i32.xor 	$push193=, $12, $pop234
	i32.store16	$push30=, k+10($pop235), $pop193
	i32.store16	$drop=, res+10($pop236), $pop30
	i32.const	$push233=, 0
	i32.const	$push232=, 0
	i32.const	$push231=, -1
	i32.xor 	$push192=, $13, $pop231
	i32.store16	$push31=, k+8($pop232), $pop192
	i32.store16	$drop=, res+8($pop233), $pop31
	i32.const	$push230=, 0
	i32.const	$push229=, -1
	i32.xor 	$push191=, $0, $pop229
	i32.store16	$0=, k+6($pop230), $pop191
	i32.const	$push228=, 0
	i32.const	$push227=, -1
	i32.xor 	$push190=, $6, $pop227
	i32.store16	$6=, k+4($pop228), $pop190
	i32.const	$push226=, 0
	i32.const	$push225=, -1
	i32.xor 	$push189=, $5, $pop225
	i32.store16	$5=, k+2($pop226), $pop189
	i32.const	$push224=, 0
	i32.store16	$drop=, res+6($pop224), $0
	i32.const	$push223=, 0
	i32.store16	$drop=, res+4($pop223), $6
	i32.const	$push222=, 0
	i32.store16	$drop=, res+2($pop222), $5
	i32.const	$push221=, 0
	i32.const	$push220=, 0
	i32.const	$push219=, -1
	i32.xor 	$push218=, $4, $pop219
	tee_local	$push217=, $4=, $pop218
	i32.store16	$push32=, k($pop220), $pop217
	i32.store16	$drop=, res($pop221), $pop32
	i32.const	$push216=, 16
	i32.shl 	$push196=, $4, $pop216
	i32.const	$push215=, 16
	i32.shr_s	$push197=, $pop196, $pop215
	i32.const	$push214=, 16
	i32.shl 	$push198=, $5, $pop214
	i32.const	$push213=, 16
	i32.shr_s	$push199=, $pop198, $pop213
	i32.const	$push212=, 16
	i32.shl 	$push200=, $6, $pop212
	i32.const	$push211=, 16
	i32.shr_s	$push201=, $pop200, $pop211
	i32.const	$push210=, 16
	i32.shl 	$push202=, $0, $pop210
	i32.const	$push209=, 16
	i32.shr_s	$push203=, $pop202, $pop209
	i32.const	$push206=, -151
	i32.const	$push205=, -101
	i32.const	$push208=, -151
	i32.const	$push204=, -201
	call    	verify@FUNCTION, $pop197, $pop199, $pop201, $pop203, $pop206, $pop205, $pop208, $pop204
	i32.const	$push207=, 0
	call    	exit@FUNCTION, $pop207
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
