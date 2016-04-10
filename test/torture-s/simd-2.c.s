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
	i32.const	$push0=, 0
	i32.load16_u	$3=, i+6($pop0)
	i32.const	$push542=, 0
	i32.load16_u	$4=, i+4($pop542):p2align=2
	i32.const	$push541=, 0
	i32.load16_u	$5=, i+2($pop541)
	i32.const	$push540=, 0
	i32.load16_u	$6=, i($pop540):p2align=4
	i32.const	$push539=, 0
	i32.load16_u	$13=, j($pop539):p2align=4
	i32.const	$push538=, 0
	i32.load16_u	$12=, j+2($pop538)
	i32.const	$push537=, 0
	i32.load16_u	$11=, j+4($pop537):p2align=2
	i32.const	$push536=, 0
	i32.load16_u	$10=, j+6($pop536)
	i32.const	$push535=, 0
	i32.load16_u	$0=, i+12($pop535):p2align=2
	i32.const	$push534=, 0
	i32.load16_u	$1=, i+10($pop534)
	i32.const	$push533=, 0
	i32.load16_u	$2=, i+8($pop533):p2align=3
	i32.const	$push532=, 0
	i32.load16_u	$9=, j+8($pop532):p2align=3
	i32.const	$push531=, 0
	i32.load16_u	$8=, j+10($pop531)
	i32.const	$push530=, 0
	i32.load16_u	$7=, j+12($pop530):p2align=2
	i32.const	$push529=, 0
	i32.const	$push528=, 0
	i32.const	$push527=, 0
	i32.load16_u	$push2=, j+14($pop527)
	i32.const	$push526=, 0
	i32.load16_u	$push1=, i+14($pop526)
	i32.add 	$push10=, $pop2, $pop1
	i32.store16	$push11=, k+14($pop528), $pop10
	i32.store16	$discard=, res+14($pop529), $pop11
	i32.const	$push525=, 0
	i32.const	$push524=, 0
	i32.add 	$push9=, $7, $0
	i32.store16	$push12=, k+12($pop524):p2align=2, $pop9
	i32.store16	$discard=, res+12($pop525):p2align=2, $pop12
	i32.const	$push523=, 0
	i32.const	$push522=, 0
	i32.add 	$push8=, $8, $1
	i32.store16	$push13=, k+10($pop522), $pop8
	i32.store16	$discard=, res+10($pop523), $pop13
	i32.const	$push521=, 0
	i32.const	$push520=, 0
	i32.add 	$push7=, $9, $2
	i32.store16	$push14=, k+8($pop520):p2align=3, $pop7
	i32.store16	$discard=, res+8($pop521):p2align=3, $pop14
	i32.const	$push519=, 0
	i32.add 	$push6=, $10, $3
	i32.store16	$3=, k+6($pop519), $pop6
	i32.const	$push518=, 0
	i32.add 	$push5=, $11, $4
	i32.store16	$4=, k+4($pop518):p2align=2, $pop5
	i32.const	$push517=, 0
	i32.add 	$push4=, $12, $5
	i32.store16	$5=, k+2($pop517), $pop4
	i32.const	$push516=, 0
	i32.add 	$push3=, $13, $6
	i32.store16	$6=, k($pop516):p2align=4, $pop3
	i32.const	$push515=, 0
	i32.store16	$discard=, res+6($pop515), $3
	i32.const	$push514=, 0
	i32.store16	$discard=, res+4($pop514):p2align=2, $4
	i32.const	$push513=, 0
	i32.store16	$discard=, res+2($pop513), $5
	i32.const	$push512=, 0
	i32.store16	$push15=, res($pop512):p2align=4, $6
	i32.const	$push16=, 16
	i32.shl 	$push17=, $pop15, $pop16
	i32.const	$push511=, 16
	i32.shr_s	$push18=, $pop17, $pop511
	i32.const	$push510=, 16
	i32.shl 	$push19=, $5, $pop510
	i32.const	$push509=, 16
	i32.shr_s	$push20=, $pop19, $pop509
	i32.const	$push508=, 16
	i32.shl 	$push21=, $4, $pop508
	i32.const	$push507=, 16
	i32.shr_s	$push22=, $pop21, $pop507
	i32.const	$push506=, 16
	i32.shl 	$push23=, $3, $pop506
	i32.const	$push505=, 16
	i32.shr_s	$push24=, $pop23, $pop505
	i32.const	$push28=, 160
	i32.const	$push27=, 113
	i32.const	$push26=, 170
	i32.const	$push25=, 230
	call    	verify@FUNCTION, $pop18, $pop20, $pop22, $pop24, $pop28, $pop27, $pop26, $pop25
	i32.const	$push504=, 0
	i32.load16_u	$3=, i+6($pop504)
	i32.const	$push503=, 0
	i32.load16_u	$4=, i+4($pop503):p2align=2
	i32.const	$push502=, 0
	i32.load16_u	$5=, i+2($pop502)
	i32.const	$push501=, 0
	i32.load16_u	$6=, i($pop501):p2align=4
	i32.const	$push500=, 0
	i32.load16_u	$13=, j($pop500):p2align=4
	i32.const	$push499=, 0
	i32.load16_u	$12=, j+2($pop499)
	i32.const	$push498=, 0
	i32.load16_u	$11=, j+4($pop498):p2align=2
	i32.const	$push497=, 0
	i32.load16_u	$10=, j+6($pop497)
	i32.const	$push496=, 0
	i32.load16_u	$0=, i+12($pop496):p2align=2
	i32.const	$push495=, 0
	i32.load16_u	$1=, i+10($pop495)
	i32.const	$push494=, 0
	i32.load16_u	$2=, i+8($pop494):p2align=3
	i32.const	$push493=, 0
	i32.load16_u	$9=, j+8($pop493):p2align=3
	i32.const	$push492=, 0
	i32.load16_u	$8=, j+10($pop492)
	i32.const	$push491=, 0
	i32.load16_u	$7=, j+12($pop491):p2align=2
	i32.const	$push490=, 0
	i32.const	$push489=, 0
	i32.const	$push488=, 0
	i32.load16_u	$push30=, j+14($pop488)
	i32.const	$push487=, 0
	i32.load16_u	$push29=, i+14($pop487)
	i32.mul 	$push38=, $pop30, $pop29
	i32.store16	$push39=, k+14($pop489), $pop38
	i32.store16	$discard=, res+14($pop490), $pop39
	i32.const	$push486=, 0
	i32.const	$push485=, 0
	i32.mul 	$push37=, $7, $0
	i32.store16	$push40=, k+12($pop485):p2align=2, $pop37
	i32.store16	$discard=, res+12($pop486):p2align=2, $pop40
	i32.const	$push484=, 0
	i32.const	$push483=, 0
	i32.mul 	$push36=, $8, $1
	i32.store16	$push41=, k+10($pop483), $pop36
	i32.store16	$discard=, res+10($pop484), $pop41
	i32.const	$push482=, 0
	i32.const	$push481=, 0
	i32.mul 	$push35=, $9, $2
	i32.store16	$push42=, k+8($pop481):p2align=3, $pop35
	i32.store16	$discard=, res+8($pop482):p2align=3, $pop42
	i32.const	$push480=, 0
	i32.mul 	$push34=, $10, $3
	i32.store16	$3=, k+6($pop480), $pop34
	i32.const	$push479=, 0
	i32.mul 	$push33=, $11, $4
	i32.store16	$4=, k+4($pop479):p2align=2, $pop33
	i32.const	$push478=, 0
	i32.mul 	$push32=, $12, $5
	i32.store16	$5=, k+2($pop478), $pop32
	i32.const	$push477=, 0
	i32.mul 	$push31=, $13, $6
	i32.store16	$6=, k($pop477):p2align=4, $pop31
	i32.const	$push476=, 0
	i32.store16	$discard=, res+6($pop476), $3
	i32.const	$push475=, 0
	i32.store16	$discard=, res+4($pop475):p2align=2, $4
	i32.const	$push474=, 0
	i32.store16	$discard=, res+2($pop474), $5
	i32.const	$push473=, 0
	i32.store16	$push43=, res($pop473):p2align=4, $6
	i32.const	$push472=, 16
	i32.shl 	$push44=, $pop43, $pop472
	i32.const	$push471=, 16
	i32.shr_s	$push45=, $pop44, $pop471
	i32.const	$push470=, 16
	i32.shl 	$push46=, $5, $pop470
	i32.const	$push469=, 16
	i32.shr_s	$push47=, $pop46, $pop469
	i32.const	$push468=, 16
	i32.shl 	$push48=, $4, $pop468
	i32.const	$push467=, 16
	i32.shr_s	$push49=, $pop48, $pop467
	i32.const	$push466=, 16
	i32.shl 	$push50=, $3, $pop466
	i32.const	$push465=, 16
	i32.shr_s	$push51=, $pop50, $pop465
	i32.const	$push55=, 1500
	i32.const	$push54=, 1300
	i32.const	$push53=, 3000
	i32.const	$push52=, 6000
	call    	verify@FUNCTION, $pop45, $pop47, $pop49, $pop51, $pop55, $pop54, $pop53, $pop52
	i32.const	$push464=, 0
	i32.load16_s	$push63=, i($pop464):p2align=4
	i32.const	$push463=, 0
	i32.load16_s	$push71=, j($pop463):p2align=4
	i32.div_s	$3=, $pop63, $pop71
	i32.const	$push462=, 0
	i32.load16_s	$push62=, i+2($pop462)
	i32.const	$push461=, 0
	i32.load16_s	$push70=, j+2($pop461)
	i32.div_s	$4=, $pop62, $pop70
	i32.const	$push460=, 0
	i32.load16_s	$push61=, i+4($pop460):p2align=2
	i32.const	$push459=, 0
	i32.load16_s	$push69=, j+4($pop459):p2align=2
	i32.div_s	$5=, $pop61, $pop69
	i32.const	$push458=, 0
	i32.load16_s	$push60=, i+6($pop458)
	i32.const	$push457=, 0
	i32.load16_s	$push68=, j+6($pop457)
	i32.div_s	$6=, $pop60, $pop68
	i32.const	$push456=, 0
	i32.load16_s	$push59=, i+8($pop456):p2align=3
	i32.const	$push455=, 0
	i32.load16_s	$push67=, j+8($pop455):p2align=3
	i32.div_s	$13=, $pop59, $pop67
	i32.const	$push454=, 0
	i32.load16_s	$push58=, i+10($pop454)
	i32.const	$push453=, 0
	i32.load16_s	$push66=, j+10($pop453)
	i32.div_s	$12=, $pop58, $pop66
	i32.const	$push452=, 0
	i32.load16_s	$push57=, i+12($pop452):p2align=2
	i32.const	$push451=, 0
	i32.load16_s	$push65=, j+12($pop451):p2align=2
	i32.div_s	$11=, $pop57, $pop65
	i32.const	$push450=, 0
	i32.const	$push449=, 0
	i32.const	$push448=, 0
	i32.load16_s	$push56=, i+14($pop448)
	i32.const	$push447=, 0
	i32.load16_s	$push64=, j+14($pop447)
	i32.div_s	$push72=, $pop56, $pop64
	i32.store16	$push73=, k+14($pop449), $pop72
	i32.store16	$discard=, res+14($pop450), $pop73
	i32.const	$push446=, 0
	i32.const	$push445=, 0
	i32.store16	$push74=, k+12($pop445):p2align=2, $11
	i32.store16	$discard=, res+12($pop446):p2align=2, $pop74
	i32.const	$push444=, 0
	i32.const	$push443=, 0
	i32.store16	$push75=, k+10($pop443), $12
	i32.store16	$discard=, res+10($pop444), $pop75
	i32.const	$push442=, 0
	i32.const	$push441=, 0
	i32.store16	$push76=, k+8($pop441):p2align=3, $13
	i32.store16	$discard=, res+8($pop442):p2align=3, $pop76
	i32.const	$push440=, 0
	i32.store16	$discard=, k+6($pop440), $6
	i32.const	$push439=, 0
	i32.store16	$discard=, k+4($pop439):p2align=2, $5
	i32.const	$push438=, 0
	i32.store16	$discard=, k+2($pop438), $4
	i32.const	$push437=, 0
	i32.store16	$discard=, k($pop437):p2align=4, $3
	i32.const	$push436=, 0
	i32.store16	$discard=, res+6($pop436), $6
	i32.const	$push435=, 0
	i32.store16	$discard=, res+4($pop435):p2align=2, $5
	i32.const	$push434=, 0
	i32.store16	$discard=, res+2($pop434), $4
	i32.const	$push433=, 0
	i32.store16	$push77=, res($pop433):p2align=4, $3
	i32.const	$push432=, 16
	i32.shl 	$push78=, $pop77, $pop432
	i32.const	$push431=, 16
	i32.shr_s	$push79=, $pop78, $pop431
	i32.const	$push430=, 16
	i32.shl 	$push80=, $4, $pop430
	i32.const	$push429=, 16
	i32.shr_s	$push81=, $pop80, $pop429
	i32.const	$push428=, 16
	i32.shl 	$push82=, $5, $pop428
	i32.const	$push427=, 16
	i32.shr_s	$push83=, $pop82, $pop427
	i32.const	$push426=, 16
	i32.shl 	$push84=, $6, $pop426
	i32.const	$push425=, 16
	i32.shr_s	$push85=, $pop84, $pop425
	i32.const	$push88=, 15
	i32.const	$push87=, 7
	i32.const	$push424=, 7
	i32.const	$push86=, 6
	call    	verify@FUNCTION, $pop79, $pop81, $pop83, $pop85, $pop88, $pop87, $pop424, $pop86
	i32.const	$push423=, 0
	i32.load16_u	$3=, i+6($pop423)
	i32.const	$push422=, 0
	i32.load16_u	$4=, i+4($pop422):p2align=2
	i32.const	$push421=, 0
	i32.load16_u	$5=, i+2($pop421)
	i32.const	$push420=, 0
	i32.load16_u	$6=, i($pop420):p2align=4
	i32.const	$push419=, 0
	i32.load16_u	$13=, j($pop419):p2align=4
	i32.const	$push418=, 0
	i32.load16_u	$12=, j+2($pop418)
	i32.const	$push417=, 0
	i32.load16_u	$11=, j+4($pop417):p2align=2
	i32.const	$push416=, 0
	i32.load16_u	$10=, j+6($pop416)
	i32.const	$push415=, 0
	i32.load16_u	$0=, i+12($pop415):p2align=2
	i32.const	$push414=, 0
	i32.load16_u	$1=, i+10($pop414)
	i32.const	$push413=, 0
	i32.load16_u	$2=, i+8($pop413):p2align=3
	i32.const	$push412=, 0
	i32.load16_u	$9=, j+8($pop412):p2align=3
	i32.const	$push411=, 0
	i32.load16_u	$8=, j+10($pop411)
	i32.const	$push410=, 0
	i32.load16_u	$7=, j+12($pop410):p2align=2
	i32.const	$push409=, 0
	i32.const	$push408=, 0
	i32.const	$push407=, 0
	i32.load16_u	$push90=, j+14($pop407)
	i32.const	$push406=, 0
	i32.load16_u	$push89=, i+14($pop406)
	i32.and 	$push98=, $pop90, $pop89
	i32.store16	$push99=, k+14($pop408), $pop98
	i32.store16	$discard=, res+14($pop409), $pop99
	i32.const	$push405=, 0
	i32.const	$push404=, 0
	i32.and 	$push97=, $7, $0
	i32.store16	$push100=, k+12($pop404):p2align=2, $pop97
	i32.store16	$discard=, res+12($pop405):p2align=2, $pop100
	i32.const	$push403=, 0
	i32.const	$push402=, 0
	i32.and 	$push96=, $8, $1
	i32.store16	$push101=, k+10($pop402), $pop96
	i32.store16	$discard=, res+10($pop403), $pop101
	i32.const	$push401=, 0
	i32.const	$push400=, 0
	i32.and 	$push95=, $9, $2
	i32.store16	$push102=, k+8($pop400):p2align=3, $pop95
	i32.store16	$discard=, res+8($pop401):p2align=3, $pop102
	i32.const	$push399=, 0
	i32.and 	$push94=, $10, $3
	i32.store16	$3=, k+6($pop399), $pop94
	i32.const	$push398=, 0
	i32.and 	$push93=, $11, $4
	i32.store16	$4=, k+4($pop398):p2align=2, $pop93
	i32.const	$push397=, 0
	i32.and 	$push92=, $12, $5
	i32.store16	$5=, k+2($pop397), $pop92
	i32.const	$push396=, 0
	i32.and 	$push91=, $13, $6
	i32.store16	$6=, k($pop396):p2align=4, $pop91
	i32.const	$push395=, 0
	i32.store16	$discard=, res+6($pop395), $3
	i32.const	$push394=, 0
	i32.store16	$discard=, res+4($pop394):p2align=2, $4
	i32.const	$push393=, 0
	i32.store16	$discard=, res+2($pop393), $5
	i32.const	$push392=, 0
	i32.store16	$push103=, res($pop392):p2align=4, $6
	i32.const	$push391=, 16
	i32.shl 	$push104=, $pop103, $pop391
	i32.const	$push390=, 16
	i32.shr_s	$push105=, $pop104, $pop390
	i32.const	$push389=, 16
	i32.shl 	$push106=, $5, $pop389
	i32.const	$push388=, 16
	i32.shr_s	$push107=, $pop106, $pop388
	i32.const	$push387=, 16
	i32.shl 	$push108=, $4, $pop387
	i32.const	$push386=, 16
	i32.shr_s	$push109=, $pop108, $pop386
	i32.const	$push385=, 16
	i32.shl 	$push110=, $3, $pop385
	i32.const	$push384=, 16
	i32.shr_s	$push111=, $pop110, $pop384
	i32.const	$push115=, 2
	i32.const	$push114=, 4
	i32.const	$push113=, 20
	i32.const	$push112=, 8
	call    	verify@FUNCTION, $pop105, $pop107, $pop109, $pop111, $pop115, $pop114, $pop113, $pop112
	i32.const	$push383=, 0
	i32.load16_u	$3=, i+6($pop383)
	i32.const	$push382=, 0
	i32.load16_u	$4=, i+4($pop382):p2align=2
	i32.const	$push381=, 0
	i32.load16_u	$5=, i+2($pop381)
	i32.const	$push380=, 0
	i32.load16_u	$6=, i($pop380):p2align=4
	i32.const	$push379=, 0
	i32.load16_u	$13=, j($pop379):p2align=4
	i32.const	$push378=, 0
	i32.load16_u	$12=, j+2($pop378)
	i32.const	$push377=, 0
	i32.load16_u	$11=, j+4($pop377):p2align=2
	i32.const	$push376=, 0
	i32.load16_u	$10=, j+6($pop376)
	i32.const	$push375=, 0
	i32.load16_u	$0=, i+12($pop375):p2align=2
	i32.const	$push374=, 0
	i32.load16_u	$1=, i+10($pop374)
	i32.const	$push373=, 0
	i32.load16_u	$2=, i+8($pop373):p2align=3
	i32.const	$push372=, 0
	i32.load16_u	$9=, j+8($pop372):p2align=3
	i32.const	$push371=, 0
	i32.load16_u	$8=, j+10($pop371)
	i32.const	$push370=, 0
	i32.load16_u	$7=, j+12($pop370):p2align=2
	i32.const	$push369=, 0
	i32.const	$push368=, 0
	i32.const	$push367=, 0
	i32.load16_u	$push117=, j+14($pop367)
	i32.const	$push366=, 0
	i32.load16_u	$push116=, i+14($pop366)
	i32.or  	$push125=, $pop117, $pop116
	i32.store16	$push126=, k+14($pop368), $pop125
	i32.store16	$discard=, res+14($pop369), $pop126
	i32.const	$push365=, 0
	i32.const	$push364=, 0
	i32.or  	$push124=, $7, $0
	i32.store16	$push127=, k+12($pop364):p2align=2, $pop124
	i32.store16	$discard=, res+12($pop365):p2align=2, $pop127
	i32.const	$push363=, 0
	i32.const	$push362=, 0
	i32.or  	$push123=, $8, $1
	i32.store16	$push128=, k+10($pop362), $pop123
	i32.store16	$discard=, res+10($pop363), $pop128
	i32.const	$push361=, 0
	i32.const	$push360=, 0
	i32.or  	$push122=, $9, $2
	i32.store16	$push129=, k+8($pop360):p2align=3, $pop122
	i32.store16	$discard=, res+8($pop361):p2align=3, $pop129
	i32.const	$push359=, 0
	i32.or  	$push121=, $10, $3
	i32.store16	$3=, k+6($pop359), $pop121
	i32.const	$push358=, 0
	i32.or  	$push120=, $11, $4
	i32.store16	$4=, k+4($pop358):p2align=2, $pop120
	i32.const	$push357=, 0
	i32.or  	$push119=, $12, $5
	i32.store16	$5=, k+2($pop357), $pop119
	i32.const	$push356=, 0
	i32.or  	$push118=, $13, $6
	i32.store16	$6=, k($pop356):p2align=4, $pop118
	i32.const	$push355=, 0
	i32.store16	$discard=, res+6($pop355), $3
	i32.const	$push354=, 0
	i32.store16	$discard=, res+4($pop354):p2align=2, $4
	i32.const	$push353=, 0
	i32.store16	$discard=, res+2($pop353), $5
	i32.const	$push352=, 0
	i32.store16	$push130=, res($pop352):p2align=4, $6
	i32.const	$push351=, 16
	i32.shl 	$push131=, $pop130, $pop351
	i32.const	$push350=, 16
	i32.shr_s	$push132=, $pop131, $pop350
	i32.const	$push349=, 16
	i32.shl 	$push133=, $5, $pop349
	i32.const	$push348=, 16
	i32.shr_s	$push134=, $pop133, $pop348
	i32.const	$push347=, 16
	i32.shl 	$push135=, $4, $pop347
	i32.const	$push346=, 16
	i32.shr_s	$push136=, $pop135, $pop346
	i32.const	$push345=, 16
	i32.shl 	$push137=, $3, $pop345
	i32.const	$push344=, 16
	i32.shr_s	$push138=, $pop137, $pop344
	i32.const	$push142=, 158
	i32.const	$push141=, 109
	i32.const	$push140=, 150
	i32.const	$push139=, 222
	call    	verify@FUNCTION, $pop132, $pop134, $pop136, $pop138, $pop142, $pop141, $pop140, $pop139
	i32.const	$push343=, 0
	i32.load16_u	$3=, i+6($pop343)
	i32.const	$push342=, 0
	i32.load16_u	$4=, i+4($pop342):p2align=2
	i32.const	$push341=, 0
	i32.load16_u	$5=, i+2($pop341)
	i32.const	$push340=, 0
	i32.load16_u	$6=, i($pop340):p2align=4
	i32.const	$push339=, 0
	i32.load16_u	$13=, j($pop339):p2align=4
	i32.const	$push338=, 0
	i32.load16_u	$12=, j+2($pop338)
	i32.const	$push337=, 0
	i32.load16_u	$11=, j+4($pop337):p2align=2
	i32.const	$push336=, 0
	i32.load16_u	$10=, j+6($pop336)
	i32.const	$push335=, 0
	i32.load16_u	$0=, i+12($pop335):p2align=2
	i32.const	$push334=, 0
	i32.load16_u	$1=, i+10($pop334)
	i32.const	$push333=, 0
	i32.load16_u	$2=, i+8($pop333):p2align=3
	i32.const	$push332=, 0
	i32.load16_u	$9=, j+8($pop332):p2align=3
	i32.const	$push331=, 0
	i32.load16_u	$8=, j+10($pop331)
	i32.const	$push330=, 0
	i32.load16_u	$7=, j+12($pop330):p2align=2
	i32.const	$push329=, 0
	i32.const	$push328=, 0
	i32.const	$push327=, 0
	i32.load16_u	$push143=, i+14($pop327)
	i32.const	$push326=, 0
	i32.load16_u	$push144=, j+14($pop326)
	i32.xor 	$push152=, $pop143, $pop144
	i32.store16	$push153=, k+14($pop328), $pop152
	i32.store16	$discard=, res+14($pop329), $pop153
	i32.const	$push325=, 0
	i32.const	$push324=, 0
	i32.xor 	$push151=, $0, $7
	i32.store16	$push154=, k+12($pop324):p2align=2, $pop151
	i32.store16	$discard=, res+12($pop325):p2align=2, $pop154
	i32.const	$push323=, 0
	i32.const	$push322=, 0
	i32.xor 	$push150=, $1, $8
	i32.store16	$push155=, k+10($pop322), $pop150
	i32.store16	$discard=, res+10($pop323), $pop155
	i32.const	$push321=, 0
	i32.const	$push320=, 0
	i32.xor 	$push149=, $2, $9
	i32.store16	$push156=, k+8($pop320):p2align=3, $pop149
	i32.store16	$discard=, res+8($pop321):p2align=3, $pop156
	i32.const	$push319=, 0
	i32.xor 	$push148=, $3, $10
	i32.store16	$3=, k+6($pop319), $pop148
	i32.const	$push318=, 0
	i32.xor 	$push147=, $4, $11
	i32.store16	$4=, k+4($pop318):p2align=2, $pop147
	i32.const	$push317=, 0
	i32.xor 	$push146=, $5, $12
	i32.store16	$5=, k+2($pop317), $pop146
	i32.const	$push316=, 0
	i32.xor 	$push145=, $6, $13
	i32.store16	$6=, k($pop316):p2align=4, $pop145
	i32.const	$push315=, 0
	i32.store16	$discard=, res+6($pop315), $3
	i32.const	$push314=, 0
	i32.store16	$discard=, res+4($pop314):p2align=2, $4
	i32.const	$push313=, 0
	i32.store16	$discard=, res+2($pop313), $5
	i32.const	$push312=, 0
	i32.store16	$push157=, res($pop312):p2align=4, $6
	i32.const	$push311=, 16
	i32.shl 	$push158=, $pop157, $pop311
	i32.const	$push310=, 16
	i32.shr_s	$push159=, $pop158, $pop310
	i32.const	$push309=, 16
	i32.shl 	$push160=, $5, $pop309
	i32.const	$push308=, 16
	i32.shr_s	$push161=, $pop160, $pop308
	i32.const	$push307=, 16
	i32.shl 	$push162=, $4, $pop307
	i32.const	$push306=, 16
	i32.shr_s	$push163=, $pop162, $pop306
	i32.const	$push305=, 16
	i32.shl 	$push164=, $3, $pop305
	i32.const	$push304=, 16
	i32.shr_s	$push165=, $pop164, $pop304
	i32.const	$push169=, 156
	i32.const	$push168=, 105
	i32.const	$push167=, 130
	i32.const	$push166=, 214
	call    	verify@FUNCTION, $pop159, $pop161, $pop163, $pop165, $pop169, $pop168, $pop167, $pop166
	i32.const	$push303=, 0
	i32.load16_u	$3=, i+12($pop303):p2align=2
	i32.const	$push302=, 0
	i32.const	$push301=, 0
	i32.const	$push300=, 0
	i32.const	$push299=, 0
	i32.load16_u	$push170=, i+14($pop299)
	i32.sub 	$push179=, $pop300, $pop170
	i32.store16	$push180=, k+14($pop301), $pop179
	i32.store16	$discard=, res+14($pop302), $pop180
	i32.const	$push298=, 0
	i32.load16_u	$4=, i+10($pop298)
	i32.const	$push297=, 0
	i32.const	$push296=, 0
	i32.const	$push295=, 0
	i32.sub 	$push178=, $pop295, $3
	i32.store16	$push181=, k+12($pop296):p2align=2, $pop178
	i32.store16	$discard=, res+12($pop297):p2align=2, $pop181
	i32.const	$push294=, 0
	i32.load16_u	$3=, i+8($pop294):p2align=3
	i32.const	$push293=, 0
	i32.const	$push292=, 0
	i32.const	$push291=, 0
	i32.sub 	$push177=, $pop291, $4
	i32.store16	$push182=, k+10($pop292), $pop177
	i32.store16	$discard=, res+10($pop293), $pop182
	i32.const	$push290=, 0
	i32.const	$push289=, 0
	i32.const	$push288=, 0
	i32.sub 	$push176=, $pop288, $3
	i32.store16	$push183=, k+8($pop289):p2align=3, $pop176
	i32.store16	$discard=, res+8($pop290):p2align=3, $pop183
	i32.const	$push287=, 0
	i32.load16_u	$3=, i($pop287):p2align=4
	i32.const	$push286=, 0
	i32.load16_u	$4=, i+2($pop286)
	i32.const	$push285=, 0
	i32.load16_u	$5=, i+4($pop285):p2align=2
	i32.const	$push284=, 0
	i32.const	$push283=, 0
	i32.const	$push282=, 0
	i32.load16_u	$push171=, i+6($pop282)
	i32.sub 	$push175=, $pop283, $pop171
	i32.store16	$6=, k+6($pop284), $pop175
	i32.const	$push281=, 0
	i32.const	$push280=, 0
	i32.sub 	$push174=, $pop280, $5
	i32.store16	$5=, k+4($pop281):p2align=2, $pop174
	i32.const	$push279=, 0
	i32.const	$push278=, 0
	i32.sub 	$push173=, $pop278, $4
	i32.store16	$4=, k+2($pop279), $pop173
	i32.const	$push277=, 0
	i32.const	$push276=, 0
	i32.sub 	$push172=, $pop276, $3
	i32.store16	$3=, k($pop277):p2align=4, $pop172
	i32.const	$push275=, 0
	i32.store16	$discard=, res+6($pop275), $6
	i32.const	$push274=, 0
	i32.store16	$discard=, res+4($pop274):p2align=2, $5
	i32.const	$push273=, 0
	i32.store16	$discard=, res+2($pop273), $4
	i32.const	$push272=, 0
	i32.store16	$push184=, res($pop272):p2align=4, $3
	i32.const	$push271=, 16
	i32.shl 	$push185=, $pop184, $pop271
	i32.const	$push270=, 16
	i32.shr_s	$push186=, $pop185, $pop270
	i32.const	$push269=, 16
	i32.shl 	$push187=, $4, $pop269
	i32.const	$push268=, 16
	i32.shr_s	$push188=, $pop187, $pop268
	i32.const	$push267=, 16
	i32.shl 	$push189=, $5, $pop267
	i32.const	$push266=, 16
	i32.shr_s	$push190=, $pop189, $pop266
	i32.const	$push265=, 16
	i32.shl 	$push191=, $6, $pop265
	i32.const	$push264=, 16
	i32.shr_s	$push192=, $pop191, $pop264
	i32.const	$push195=, -150
	i32.const	$push194=, -100
	i32.const	$push263=, -150
	i32.const	$push193=, -200
	call    	verify@FUNCTION, $pop186, $pop188, $pop190, $pop192, $pop195, $pop194, $pop263, $pop193
	i32.const	$push262=, 0
	i32.load16_u	$3=, i+6($pop262)
	i32.const	$push261=, 0
	i32.load16_u	$4=, i($pop261):p2align=4
	i32.const	$push260=, 0
	i32.load16_u	$5=, i+2($pop260)
	i32.const	$push259=, 0
	i32.load16_u	$6=, i+4($pop259):p2align=2
	i32.const	$push258=, 0
	i32.load16_u	$13=, i+8($pop258):p2align=3
	i32.const	$push257=, 0
	i32.load16_u	$12=, i+10($pop257)
	i32.const	$push256=, 0
	i32.load16_u	$11=, i+12($pop256):p2align=2
	i32.const	$push255=, 0
	i32.const	$push254=, 0
	i32.const	$push253=, 0
	i32.load16_u	$push196=, i+14($pop253)
	i32.const	$push197=, -1
	i32.xor 	$push205=, $pop196, $pop197
	i32.store16	$push206=, k+14($pop254), $pop205
	i32.store16	$discard=, res+14($pop255), $pop206
	i32.const	$push252=, 0
	i32.const	$push251=, 0
	i32.const	$push250=, -1
	i32.xor 	$push204=, $11, $pop250
	i32.store16	$push207=, k+12($pop251):p2align=2, $pop204
	i32.store16	$discard=, res+12($pop252):p2align=2, $pop207
	i32.const	$push249=, 0
	i32.const	$push248=, 0
	i32.const	$push247=, -1
	i32.xor 	$push203=, $12, $pop247
	i32.store16	$push208=, k+10($pop248), $pop203
	i32.store16	$discard=, res+10($pop249), $pop208
	i32.const	$push246=, 0
	i32.const	$push245=, 0
	i32.const	$push244=, -1
	i32.xor 	$push202=, $13, $pop244
	i32.store16	$push209=, k+8($pop245):p2align=3, $pop202
	i32.store16	$discard=, res+8($pop246):p2align=3, $pop209
	i32.const	$push243=, 0
	i32.const	$push242=, -1
	i32.xor 	$push201=, $3, $pop242
	i32.store16	$3=, k+6($pop243), $pop201
	i32.const	$push241=, 0
	i32.const	$push240=, -1
	i32.xor 	$push200=, $6, $pop240
	i32.store16	$6=, k+4($pop241):p2align=2, $pop200
	i32.const	$push239=, 0
	i32.const	$push238=, -1
	i32.xor 	$push199=, $5, $pop238
	i32.store16	$5=, k+2($pop239), $pop199
	i32.const	$push237=, 0
	i32.const	$push236=, -1
	i32.xor 	$push198=, $4, $pop236
	i32.store16	$4=, k($pop237):p2align=4, $pop198
	i32.const	$push235=, 0
	i32.store16	$discard=, res+6($pop235), $3
	i32.const	$push234=, 0
	i32.store16	$discard=, res+4($pop234):p2align=2, $6
	i32.const	$push233=, 0
	i32.store16	$discard=, res+2($pop233), $5
	i32.const	$push232=, 0
	i32.store16	$push210=, res($pop232):p2align=4, $4
	i32.const	$push231=, 16
	i32.shl 	$push211=, $pop210, $pop231
	i32.const	$push230=, 16
	i32.shr_s	$push212=, $pop211, $pop230
	i32.const	$push229=, 16
	i32.shl 	$push213=, $5, $pop229
	i32.const	$push228=, 16
	i32.shr_s	$push214=, $pop213, $pop228
	i32.const	$push227=, 16
	i32.shl 	$push215=, $6, $pop227
	i32.const	$push226=, 16
	i32.shr_s	$push216=, $pop215, $pop226
	i32.const	$push225=, 16
	i32.shl 	$push217=, $3, $pop225
	i32.const	$push224=, 16
	i32.shr_s	$push218=, $pop217, $pop224
	i32.const	$push221=, -151
	i32.const	$push220=, -101
	i32.const	$push223=, -151
	i32.const	$push219=, -201
	call    	verify@FUNCTION, $pop212, $pop214, $pop216, $pop218, $pop221, $pop220, $pop223, $pop219
	i32.const	$push222=, 0
	call    	exit@FUNCTION, $pop222
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
