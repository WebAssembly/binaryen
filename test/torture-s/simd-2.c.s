	.text
	.file	"simd-2.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify                  # -- Begin function verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.ne  	$push0=, $0, $4
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	0, $pop2        # 0: down to label0
# %bb.3:                                # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	0, $pop3        # 0: down to label0
# %bb.4:                                # %if.end
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	verify, .Lfunc_end0-verify
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push2=, j+14($pop0)
	i32.const	$push528=, 0
	i32.load16_u	$push1=, i+14($pop528)
	i32.add 	$0=, $pop2, $pop1
	i32.const	$push527=, 0
	i32.store16	k+14($pop527), $0
	i32.const	$push526=, 0
	i32.load16_u	$push4=, j+12($pop526)
	i32.const	$push525=, 0
	i32.load16_u	$push3=, i+12($pop525)
	i32.add 	$1=, $pop4, $pop3
	i32.const	$push524=, 0
	i32.store16	k+12($pop524), $1
	i32.const	$push523=, 0
	i32.load16_u	$push6=, j+10($pop523)
	i32.const	$push522=, 0
	i32.load16_u	$push5=, i+10($pop522)
	i32.add 	$2=, $pop6, $pop5
	i32.const	$push521=, 0
	i32.store16	k+10($pop521), $2
	i32.const	$push520=, 0
	i32.load16_u	$push8=, j+8($pop520)
	i32.const	$push519=, 0
	i32.load16_u	$push7=, i+8($pop519)
	i32.add 	$3=, $pop8, $pop7
	i32.const	$push518=, 0
	i32.store16	k+8($pop518), $3
	i32.const	$push517=, 0
	i32.load16_u	$push10=, j+6($pop517)
	i32.const	$push516=, 0
	i32.load16_u	$push9=, i+6($pop516)
	i32.add 	$4=, $pop10, $pop9
	i32.const	$push515=, 0
	i32.store16	k+6($pop515), $4
	i32.const	$push514=, 0
	i32.load16_u	$push12=, j+4($pop514)
	i32.const	$push513=, 0
	i32.load16_u	$push11=, i+4($pop513)
	i32.add 	$5=, $pop12, $pop11
	i32.const	$push512=, 0
	i32.store16	k+4($pop512), $5
	i32.const	$push511=, 0
	i32.load16_u	$push14=, j+2($pop511)
	i32.const	$push510=, 0
	i32.load16_u	$push13=, i+2($pop510)
	i32.add 	$6=, $pop14, $pop13
	i32.const	$push509=, 0
	i32.store16	k+2($pop509), $6
	i32.const	$push508=, 0
	i32.load16_u	$push16=, j($pop508)
	i32.const	$push507=, 0
	i32.load16_u	$push15=, i($pop507)
	i32.add 	$7=, $pop16, $pop15
	i32.const	$push506=, 0
	i32.store16	k($pop506), $7
	i32.const	$push505=, 0
	i32.store16	res+14($pop505), $0
	i32.const	$push504=, 0
	i32.store16	res+12($pop504), $1
	i32.const	$push503=, 0
	i32.store16	res+10($pop503), $2
	i32.const	$push502=, 0
	i32.store16	res+8($pop502), $3
	i32.const	$push501=, 0
	i32.store16	res+6($pop501), $4
	i32.const	$push500=, 0
	i32.store16	res+4($pop500), $5
	i32.const	$push499=, 0
	i32.store16	res+2($pop499), $6
	i32.const	$push498=, 0
	i32.store16	res($pop498), $7
	i32.const	$push17=, 16
	i32.shl 	$push24=, $7, $pop17
	i32.const	$push497=, 16
	i32.shr_s	$push25=, $pop24, $pop497
	i32.const	$push496=, 16
	i32.shl 	$push22=, $6, $pop496
	i32.const	$push495=, 16
	i32.shr_s	$push23=, $pop22, $pop495
	i32.const	$push494=, 16
	i32.shl 	$push20=, $5, $pop494
	i32.const	$push493=, 16
	i32.shr_s	$push21=, $pop20, $pop493
	i32.const	$push492=, 16
	i32.shl 	$push18=, $4, $pop492
	i32.const	$push491=, 16
	i32.shr_s	$push19=, $pop18, $pop491
	i32.const	$push29=, 160
	i32.const	$push28=, 113
	i32.const	$push27=, 170
	i32.const	$push26=, 230
	call    	verify@FUNCTION, $pop25, $pop23, $pop21, $pop19, $pop29, $pop28, $pop27, $pop26
	i32.const	$push490=, 0
	i32.load16_u	$push31=, j+14($pop490)
	i32.const	$push489=, 0
	i32.load16_u	$push30=, i+14($pop489)
	i32.mul 	$0=, $pop31, $pop30
	i32.const	$push488=, 0
	i32.store16	k+14($pop488), $0
	i32.const	$push487=, 0
	i32.load16_u	$push33=, j+12($pop487)
	i32.const	$push486=, 0
	i32.load16_u	$push32=, i+12($pop486)
	i32.mul 	$1=, $pop33, $pop32
	i32.const	$push485=, 0
	i32.store16	k+12($pop485), $1
	i32.const	$push484=, 0
	i32.load16_u	$push35=, j+10($pop484)
	i32.const	$push483=, 0
	i32.load16_u	$push34=, i+10($pop483)
	i32.mul 	$2=, $pop35, $pop34
	i32.const	$push482=, 0
	i32.store16	k+10($pop482), $2
	i32.const	$push481=, 0
	i32.load16_u	$push37=, j+8($pop481)
	i32.const	$push480=, 0
	i32.load16_u	$push36=, i+8($pop480)
	i32.mul 	$3=, $pop37, $pop36
	i32.const	$push479=, 0
	i32.store16	k+8($pop479), $3
	i32.const	$push478=, 0
	i32.load16_u	$push39=, j+6($pop478)
	i32.const	$push477=, 0
	i32.load16_u	$push38=, i+6($pop477)
	i32.mul 	$4=, $pop39, $pop38
	i32.const	$push476=, 0
	i32.store16	k+6($pop476), $4
	i32.const	$push475=, 0
	i32.load16_u	$push41=, j+4($pop475)
	i32.const	$push474=, 0
	i32.load16_u	$push40=, i+4($pop474)
	i32.mul 	$5=, $pop41, $pop40
	i32.const	$push473=, 0
	i32.store16	k+4($pop473), $5
	i32.const	$push472=, 0
	i32.load16_u	$push43=, j+2($pop472)
	i32.const	$push471=, 0
	i32.load16_u	$push42=, i+2($pop471)
	i32.mul 	$6=, $pop43, $pop42
	i32.const	$push470=, 0
	i32.store16	k+2($pop470), $6
	i32.const	$push469=, 0
	i32.load16_u	$push45=, j($pop469)
	i32.const	$push468=, 0
	i32.load16_u	$push44=, i($pop468)
	i32.mul 	$7=, $pop45, $pop44
	i32.const	$push467=, 0
	i32.store16	k($pop467), $7
	i32.const	$push466=, 0
	i32.store16	res+14($pop466), $0
	i32.const	$push465=, 0
	i32.store16	res+12($pop465), $1
	i32.const	$push464=, 0
	i32.store16	res+10($pop464), $2
	i32.const	$push463=, 0
	i32.store16	res+8($pop463), $3
	i32.const	$push462=, 0
	i32.store16	res+6($pop462), $4
	i32.const	$push461=, 0
	i32.store16	res+4($pop461), $5
	i32.const	$push460=, 0
	i32.store16	res+2($pop460), $6
	i32.const	$push459=, 0
	i32.store16	res($pop459), $7
	i32.const	$push458=, 16
	i32.shl 	$push52=, $7, $pop458
	i32.const	$push457=, 16
	i32.shr_s	$push53=, $pop52, $pop457
	i32.const	$push456=, 16
	i32.shl 	$push50=, $6, $pop456
	i32.const	$push455=, 16
	i32.shr_s	$push51=, $pop50, $pop455
	i32.const	$push454=, 16
	i32.shl 	$push48=, $5, $pop454
	i32.const	$push453=, 16
	i32.shr_s	$push49=, $pop48, $pop453
	i32.const	$push452=, 16
	i32.shl 	$push46=, $4, $pop452
	i32.const	$push451=, 16
	i32.shr_s	$push47=, $pop46, $pop451
	i32.const	$push57=, 1500
	i32.const	$push56=, 1300
	i32.const	$push55=, 3000
	i32.const	$push54=, 6000
	call    	verify@FUNCTION, $pop53, $pop51, $pop49, $pop47, $pop57, $pop56, $pop55, $pop54
	i32.const	$push450=, 0
	i32.load16_s	$push59=, i+14($pop450)
	i32.const	$push449=, 0
	i32.load16_s	$push58=, j+14($pop449)
	i32.div_s	$0=, $pop59, $pop58
	i32.const	$push448=, 0
	i32.store16	k+14($pop448), $0
	i32.const	$push447=, 0
	i32.load16_s	$push61=, i+12($pop447)
	i32.const	$push446=, 0
	i32.load16_s	$push60=, j+12($pop446)
	i32.div_s	$1=, $pop61, $pop60
	i32.const	$push445=, 0
	i32.store16	k+12($pop445), $1
	i32.const	$push444=, 0
	i32.load16_s	$push63=, i+10($pop444)
	i32.const	$push443=, 0
	i32.load16_s	$push62=, j+10($pop443)
	i32.div_s	$2=, $pop63, $pop62
	i32.const	$push442=, 0
	i32.store16	k+10($pop442), $2
	i32.const	$push441=, 0
	i32.load16_s	$push65=, i+8($pop441)
	i32.const	$push440=, 0
	i32.load16_s	$push64=, j+8($pop440)
	i32.div_s	$3=, $pop65, $pop64
	i32.const	$push439=, 0
	i32.store16	k+8($pop439), $3
	i32.const	$push438=, 0
	i32.load16_s	$push67=, i+6($pop438)
	i32.const	$push437=, 0
	i32.load16_s	$push66=, j+6($pop437)
	i32.div_s	$4=, $pop67, $pop66
	i32.const	$push436=, 0
	i32.store16	k+6($pop436), $4
	i32.const	$push435=, 0
	i32.load16_s	$push69=, i+4($pop435)
	i32.const	$push434=, 0
	i32.load16_s	$push68=, j+4($pop434)
	i32.div_s	$5=, $pop69, $pop68
	i32.const	$push433=, 0
	i32.store16	k+4($pop433), $5
	i32.const	$push432=, 0
	i32.load16_s	$push71=, i+2($pop432)
	i32.const	$push431=, 0
	i32.load16_s	$push70=, j+2($pop431)
	i32.div_s	$6=, $pop71, $pop70
	i32.const	$push430=, 0
	i32.store16	k+2($pop430), $6
	i32.const	$push429=, 0
	i32.load16_s	$push73=, i($pop429)
	i32.const	$push428=, 0
	i32.load16_s	$push72=, j($pop428)
	i32.div_s	$7=, $pop73, $pop72
	i32.const	$push427=, 0
	i32.store16	k($pop427), $7
	i32.const	$push426=, 0
	i32.store16	res+14($pop426), $0
	i32.const	$push425=, 0
	i32.store16	res+12($pop425), $1
	i32.const	$push424=, 0
	i32.store16	res+10($pop424), $2
	i32.const	$push423=, 0
	i32.store16	res+8($pop423), $3
	i32.const	$push422=, 0
	i32.store16	res+6($pop422), $4
	i32.const	$push421=, 0
	i32.store16	res+4($pop421), $5
	i32.const	$push420=, 0
	i32.store16	res+2($pop420), $6
	i32.const	$push419=, 0
	i32.store16	res($pop419), $7
	i32.const	$push418=, 16
	i32.shl 	$push80=, $7, $pop418
	i32.const	$push417=, 16
	i32.shr_s	$push81=, $pop80, $pop417
	i32.const	$push416=, 16
	i32.shl 	$push78=, $6, $pop416
	i32.const	$push415=, 16
	i32.shr_s	$push79=, $pop78, $pop415
	i32.const	$push414=, 16
	i32.shl 	$push76=, $5, $pop414
	i32.const	$push413=, 16
	i32.shr_s	$push77=, $pop76, $pop413
	i32.const	$push412=, 16
	i32.shl 	$push74=, $4, $pop412
	i32.const	$push411=, 16
	i32.shr_s	$push75=, $pop74, $pop411
	i32.const	$push84=, 15
	i32.const	$push83=, 7
	i32.const	$push410=, 7
	i32.const	$push82=, 6
	call    	verify@FUNCTION, $pop81, $pop79, $pop77, $pop75, $pop84, $pop83, $pop410, $pop82
	i32.const	$push409=, 0
	i32.load16_u	$push86=, j+14($pop409)
	i32.const	$push408=, 0
	i32.load16_u	$push85=, i+14($pop408)
	i32.and 	$0=, $pop86, $pop85
	i32.const	$push407=, 0
	i32.store16	k+14($pop407), $0
	i32.const	$push406=, 0
	i32.load16_u	$push88=, j+12($pop406)
	i32.const	$push405=, 0
	i32.load16_u	$push87=, i+12($pop405)
	i32.and 	$1=, $pop88, $pop87
	i32.const	$push404=, 0
	i32.store16	k+12($pop404), $1
	i32.const	$push403=, 0
	i32.load16_u	$push90=, j+10($pop403)
	i32.const	$push402=, 0
	i32.load16_u	$push89=, i+10($pop402)
	i32.and 	$2=, $pop90, $pop89
	i32.const	$push401=, 0
	i32.store16	k+10($pop401), $2
	i32.const	$push400=, 0
	i32.load16_u	$push92=, j+8($pop400)
	i32.const	$push399=, 0
	i32.load16_u	$push91=, i+8($pop399)
	i32.and 	$3=, $pop92, $pop91
	i32.const	$push398=, 0
	i32.store16	k+8($pop398), $3
	i32.const	$push397=, 0
	i32.load16_u	$push94=, j+6($pop397)
	i32.const	$push396=, 0
	i32.load16_u	$push93=, i+6($pop396)
	i32.and 	$4=, $pop94, $pop93
	i32.const	$push395=, 0
	i32.store16	k+6($pop395), $4
	i32.const	$push394=, 0
	i32.load16_u	$push96=, j+4($pop394)
	i32.const	$push393=, 0
	i32.load16_u	$push95=, i+4($pop393)
	i32.and 	$5=, $pop96, $pop95
	i32.const	$push392=, 0
	i32.store16	k+4($pop392), $5
	i32.const	$push391=, 0
	i32.load16_u	$push98=, j+2($pop391)
	i32.const	$push390=, 0
	i32.load16_u	$push97=, i+2($pop390)
	i32.and 	$6=, $pop98, $pop97
	i32.const	$push389=, 0
	i32.store16	k+2($pop389), $6
	i32.const	$push388=, 0
	i32.load16_u	$push100=, j($pop388)
	i32.const	$push387=, 0
	i32.load16_u	$push99=, i($pop387)
	i32.and 	$7=, $pop100, $pop99
	i32.const	$push386=, 0
	i32.store16	k($pop386), $7
	i32.const	$push385=, 0
	i32.store16	res+14($pop385), $0
	i32.const	$push384=, 0
	i32.store16	res+12($pop384), $1
	i32.const	$push383=, 0
	i32.store16	res+10($pop383), $2
	i32.const	$push382=, 0
	i32.store16	res+8($pop382), $3
	i32.const	$push381=, 0
	i32.store16	res+6($pop381), $4
	i32.const	$push380=, 0
	i32.store16	res+4($pop380), $5
	i32.const	$push379=, 0
	i32.store16	res+2($pop379), $6
	i32.const	$push378=, 0
	i32.store16	res($pop378), $7
	i32.const	$push377=, 16
	i32.shl 	$push107=, $7, $pop377
	i32.const	$push376=, 16
	i32.shr_s	$push108=, $pop107, $pop376
	i32.const	$push375=, 16
	i32.shl 	$push105=, $6, $pop375
	i32.const	$push374=, 16
	i32.shr_s	$push106=, $pop105, $pop374
	i32.const	$push373=, 16
	i32.shl 	$push103=, $5, $pop373
	i32.const	$push372=, 16
	i32.shr_s	$push104=, $pop103, $pop372
	i32.const	$push371=, 16
	i32.shl 	$push101=, $4, $pop371
	i32.const	$push370=, 16
	i32.shr_s	$push102=, $pop101, $pop370
	i32.const	$push112=, 2
	i32.const	$push111=, 4
	i32.const	$push110=, 20
	i32.const	$push109=, 8
	call    	verify@FUNCTION, $pop108, $pop106, $pop104, $pop102, $pop112, $pop111, $pop110, $pop109
	i32.const	$push369=, 0
	i32.load16_u	$push114=, j+14($pop369)
	i32.const	$push368=, 0
	i32.load16_u	$push113=, i+14($pop368)
	i32.or  	$0=, $pop114, $pop113
	i32.const	$push367=, 0
	i32.store16	k+14($pop367), $0
	i32.const	$push366=, 0
	i32.load16_u	$push116=, j+12($pop366)
	i32.const	$push365=, 0
	i32.load16_u	$push115=, i+12($pop365)
	i32.or  	$1=, $pop116, $pop115
	i32.const	$push364=, 0
	i32.store16	k+12($pop364), $1
	i32.const	$push363=, 0
	i32.load16_u	$push118=, j+10($pop363)
	i32.const	$push362=, 0
	i32.load16_u	$push117=, i+10($pop362)
	i32.or  	$2=, $pop118, $pop117
	i32.const	$push361=, 0
	i32.store16	k+10($pop361), $2
	i32.const	$push360=, 0
	i32.load16_u	$push120=, j+8($pop360)
	i32.const	$push359=, 0
	i32.load16_u	$push119=, i+8($pop359)
	i32.or  	$3=, $pop120, $pop119
	i32.const	$push358=, 0
	i32.store16	k+8($pop358), $3
	i32.const	$push357=, 0
	i32.load16_u	$push122=, j+6($pop357)
	i32.const	$push356=, 0
	i32.load16_u	$push121=, i+6($pop356)
	i32.or  	$4=, $pop122, $pop121
	i32.const	$push355=, 0
	i32.store16	k+6($pop355), $4
	i32.const	$push354=, 0
	i32.load16_u	$push124=, j+4($pop354)
	i32.const	$push353=, 0
	i32.load16_u	$push123=, i+4($pop353)
	i32.or  	$5=, $pop124, $pop123
	i32.const	$push352=, 0
	i32.store16	k+4($pop352), $5
	i32.const	$push351=, 0
	i32.load16_u	$push126=, j+2($pop351)
	i32.const	$push350=, 0
	i32.load16_u	$push125=, i+2($pop350)
	i32.or  	$6=, $pop126, $pop125
	i32.const	$push349=, 0
	i32.store16	k+2($pop349), $6
	i32.const	$push348=, 0
	i32.load16_u	$push128=, j($pop348)
	i32.const	$push347=, 0
	i32.load16_u	$push127=, i($pop347)
	i32.or  	$7=, $pop128, $pop127
	i32.const	$push346=, 0
	i32.store16	k($pop346), $7
	i32.const	$push345=, 0
	i32.store16	res+14($pop345), $0
	i32.const	$push344=, 0
	i32.store16	res+12($pop344), $1
	i32.const	$push343=, 0
	i32.store16	res+10($pop343), $2
	i32.const	$push342=, 0
	i32.store16	res+8($pop342), $3
	i32.const	$push341=, 0
	i32.store16	res+6($pop341), $4
	i32.const	$push340=, 0
	i32.store16	res+4($pop340), $5
	i32.const	$push339=, 0
	i32.store16	res+2($pop339), $6
	i32.const	$push338=, 0
	i32.store16	res($pop338), $7
	i32.const	$push337=, 16
	i32.shl 	$push135=, $7, $pop337
	i32.const	$push336=, 16
	i32.shr_s	$push136=, $pop135, $pop336
	i32.const	$push335=, 16
	i32.shl 	$push133=, $6, $pop335
	i32.const	$push334=, 16
	i32.shr_s	$push134=, $pop133, $pop334
	i32.const	$push333=, 16
	i32.shl 	$push131=, $5, $pop333
	i32.const	$push332=, 16
	i32.shr_s	$push132=, $pop131, $pop332
	i32.const	$push331=, 16
	i32.shl 	$push129=, $4, $pop331
	i32.const	$push330=, 16
	i32.shr_s	$push130=, $pop129, $pop330
	i32.const	$push140=, 158
	i32.const	$push139=, 109
	i32.const	$push138=, 150
	i32.const	$push137=, 222
	call    	verify@FUNCTION, $pop136, $pop134, $pop132, $pop130, $pop140, $pop139, $pop138, $pop137
	i32.const	$push329=, 0
	i32.load16_u	$push142=, j+14($pop329)
	i32.const	$push328=, 0
	i32.load16_u	$push141=, i+14($pop328)
	i32.xor 	$0=, $pop142, $pop141
	i32.const	$push327=, 0
	i32.store16	k+14($pop327), $0
	i32.const	$push326=, 0
	i32.load16_u	$push144=, j+12($pop326)
	i32.const	$push325=, 0
	i32.load16_u	$push143=, i+12($pop325)
	i32.xor 	$1=, $pop144, $pop143
	i32.const	$push324=, 0
	i32.store16	k+12($pop324), $1
	i32.const	$push323=, 0
	i32.load16_u	$push146=, j+10($pop323)
	i32.const	$push322=, 0
	i32.load16_u	$push145=, i+10($pop322)
	i32.xor 	$2=, $pop146, $pop145
	i32.const	$push321=, 0
	i32.store16	k+10($pop321), $2
	i32.const	$push320=, 0
	i32.load16_u	$push148=, j+8($pop320)
	i32.const	$push319=, 0
	i32.load16_u	$push147=, i+8($pop319)
	i32.xor 	$3=, $pop148, $pop147
	i32.const	$push318=, 0
	i32.store16	k+8($pop318), $3
	i32.const	$push317=, 0
	i32.load16_u	$push150=, j+6($pop317)
	i32.const	$push316=, 0
	i32.load16_u	$push149=, i+6($pop316)
	i32.xor 	$4=, $pop150, $pop149
	i32.const	$push315=, 0
	i32.store16	k+6($pop315), $4
	i32.const	$push314=, 0
	i32.load16_u	$push152=, j+4($pop314)
	i32.const	$push313=, 0
	i32.load16_u	$push151=, i+4($pop313)
	i32.xor 	$5=, $pop152, $pop151
	i32.const	$push312=, 0
	i32.store16	k+4($pop312), $5
	i32.const	$push311=, 0
	i32.load16_u	$push154=, j+2($pop311)
	i32.const	$push310=, 0
	i32.load16_u	$push153=, i+2($pop310)
	i32.xor 	$6=, $pop154, $pop153
	i32.const	$push309=, 0
	i32.store16	k+2($pop309), $6
	i32.const	$push308=, 0
	i32.load16_u	$push156=, j($pop308)
	i32.const	$push307=, 0
	i32.load16_u	$push155=, i($pop307)
	i32.xor 	$7=, $pop156, $pop155
	i32.const	$push306=, 0
	i32.store16	k($pop306), $7
	i32.const	$push305=, 0
	i32.store16	res+14($pop305), $0
	i32.const	$push304=, 0
	i32.store16	res+12($pop304), $1
	i32.const	$push303=, 0
	i32.store16	res+10($pop303), $2
	i32.const	$push302=, 0
	i32.store16	res+8($pop302), $3
	i32.const	$push301=, 0
	i32.store16	res+6($pop301), $4
	i32.const	$push300=, 0
	i32.store16	res+4($pop300), $5
	i32.const	$push299=, 0
	i32.store16	res+2($pop299), $6
	i32.const	$push298=, 0
	i32.store16	res($pop298), $7
	i32.const	$push297=, 16
	i32.shl 	$push163=, $7, $pop297
	i32.const	$push296=, 16
	i32.shr_s	$push164=, $pop163, $pop296
	i32.const	$push295=, 16
	i32.shl 	$push161=, $6, $pop295
	i32.const	$push294=, 16
	i32.shr_s	$push162=, $pop161, $pop294
	i32.const	$push293=, 16
	i32.shl 	$push159=, $5, $pop293
	i32.const	$push292=, 16
	i32.shr_s	$push160=, $pop159, $pop292
	i32.const	$push291=, 16
	i32.shl 	$push157=, $4, $pop291
	i32.const	$push290=, 16
	i32.shr_s	$push158=, $pop157, $pop290
	i32.const	$push168=, 156
	i32.const	$push167=, 105
	i32.const	$push166=, 130
	i32.const	$push165=, 214
	call    	verify@FUNCTION, $pop164, $pop162, $pop160, $pop158, $pop168, $pop167, $pop166, $pop165
	i32.const	$push289=, 0
	i32.const	$push288=, 0
	i32.load16_u	$push169=, i+14($pop288)
	i32.sub 	$0=, $pop289, $pop169
	i32.const	$push287=, 0
	i32.store16	k+14($pop287), $0
	i32.const	$push286=, 0
	i32.const	$push285=, 0
	i32.load16_u	$push170=, i+12($pop285)
	i32.sub 	$1=, $pop286, $pop170
	i32.const	$push284=, 0
	i32.store16	k+12($pop284), $1
	i32.const	$push283=, 0
	i32.const	$push282=, 0
	i32.load16_u	$push171=, i+10($pop282)
	i32.sub 	$2=, $pop283, $pop171
	i32.const	$push281=, 0
	i32.store16	k+10($pop281), $2
	i32.const	$push280=, 0
	i32.const	$push279=, 0
	i32.load16_u	$push172=, i+8($pop279)
	i32.sub 	$3=, $pop280, $pop172
	i32.const	$push278=, 0
	i32.store16	k+8($pop278), $3
	i32.const	$push277=, 0
	i32.const	$push276=, 0
	i32.load16_u	$push173=, i+6($pop276)
	i32.sub 	$4=, $pop277, $pop173
	i32.const	$push275=, 0
	i32.store16	k+6($pop275), $4
	i32.const	$push274=, 0
	i32.const	$push273=, 0
	i32.load16_u	$push174=, i+4($pop273)
	i32.sub 	$5=, $pop274, $pop174
	i32.const	$push272=, 0
	i32.store16	k+4($pop272), $5
	i32.const	$push271=, 0
	i32.const	$push270=, 0
	i32.load16_u	$push175=, i+2($pop270)
	i32.sub 	$6=, $pop271, $pop175
	i32.const	$push269=, 0
	i32.store16	k+2($pop269), $6
	i32.const	$push268=, 0
	i32.const	$push267=, 0
	i32.load16_u	$push176=, i($pop267)
	i32.sub 	$7=, $pop268, $pop176
	i32.const	$push266=, 0
	i32.store16	k($pop266), $7
	i32.const	$push265=, 0
	i32.store16	res+14($pop265), $0
	i32.const	$push264=, 0
	i32.store16	res+12($pop264), $1
	i32.const	$push263=, 0
	i32.store16	res+10($pop263), $2
	i32.const	$push262=, 0
	i32.store16	res+8($pop262), $3
	i32.const	$push261=, 0
	i32.store16	res+6($pop261), $4
	i32.const	$push260=, 0
	i32.store16	res+4($pop260), $5
	i32.const	$push259=, 0
	i32.store16	res+2($pop259), $6
	i32.const	$push258=, 0
	i32.store16	res($pop258), $7
	i32.const	$push257=, 16
	i32.shl 	$push183=, $7, $pop257
	i32.const	$push256=, 16
	i32.shr_s	$push184=, $pop183, $pop256
	i32.const	$push255=, 16
	i32.shl 	$push181=, $6, $pop255
	i32.const	$push254=, 16
	i32.shr_s	$push182=, $pop181, $pop254
	i32.const	$push253=, 16
	i32.shl 	$push179=, $5, $pop253
	i32.const	$push252=, 16
	i32.shr_s	$push180=, $pop179, $pop252
	i32.const	$push251=, 16
	i32.shl 	$push177=, $4, $pop251
	i32.const	$push250=, 16
	i32.shr_s	$push178=, $pop177, $pop250
	i32.const	$push187=, -150
	i32.const	$push186=, -100
	i32.const	$push249=, -150
	i32.const	$push185=, -200
	call    	verify@FUNCTION, $pop184, $pop182, $pop180, $pop178, $pop187, $pop186, $pop249, $pop185
	i32.const	$push248=, 0
	i32.load16_u	$push188=, i+14($pop248)
	i32.const	$push189=, -1
	i32.xor 	$0=, $pop188, $pop189
	i32.const	$push247=, 0
	i32.store16	k+14($pop247), $0
	i32.const	$push246=, 0
	i32.load16_u	$push190=, i+12($pop246)
	i32.const	$push245=, -1
	i32.xor 	$1=, $pop190, $pop245
	i32.const	$push244=, 0
	i32.store16	k+12($pop244), $1
	i32.const	$push243=, 0
	i32.load16_u	$push191=, i+10($pop243)
	i32.const	$push242=, -1
	i32.xor 	$2=, $pop191, $pop242
	i32.const	$push241=, 0
	i32.store16	k+10($pop241), $2
	i32.const	$push240=, 0
	i32.load16_u	$push192=, i+8($pop240)
	i32.const	$push239=, -1
	i32.xor 	$3=, $pop192, $pop239
	i32.const	$push238=, 0
	i32.store16	k+8($pop238), $3
	i32.const	$push237=, 0
	i32.load16_u	$push193=, i+6($pop237)
	i32.const	$push236=, -1
	i32.xor 	$4=, $pop193, $pop236
	i32.const	$push235=, 0
	i32.store16	k+6($pop235), $4
	i32.const	$push234=, 0
	i32.load16_u	$push194=, i+4($pop234)
	i32.const	$push233=, -1
	i32.xor 	$5=, $pop194, $pop233
	i32.const	$push232=, 0
	i32.store16	k+4($pop232), $5
	i32.const	$push231=, 0
	i32.load16_u	$push195=, i+2($pop231)
	i32.const	$push230=, -1
	i32.xor 	$6=, $pop195, $pop230
	i32.const	$push229=, 0
	i32.store16	k+2($pop229), $6
	i32.const	$push228=, 0
	i32.load16_u	$push196=, i($pop228)
	i32.const	$push227=, -1
	i32.xor 	$7=, $pop196, $pop227
	i32.const	$push226=, 0
	i32.store16	k($pop226), $7
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
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
