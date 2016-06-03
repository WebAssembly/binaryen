	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-1.c"
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push256=, 0
	i32.load	$push10=, j+12($pop256)
	i32.const	$push255=, 0
	i32.load	$push9=, i+12($pop255)
	i32.add 	$push11=, $pop10, $pop9
	i32.store	$0=, k+12($pop8), $pop11
	i32.const	$push254=, 0
	i32.const	$push253=, 0
	i32.load	$push13=, j+8($pop253)
	i32.const	$push252=, 0
	i32.load	$push12=, i+8($pop252)
	i32.add 	$push14=, $pop13, $pop12
	i32.store	$1=, k+8($pop254), $pop14
	i32.const	$push251=, 0
	i32.const	$push250=, 0
	i32.load	$push16=, j+4($pop250)
	i32.const	$push249=, 0
	i32.load	$push15=, i+4($pop249)
	i32.add 	$push17=, $pop16, $pop15
	i32.store	$2=, k+4($pop251), $pop17
	i32.const	$push248=, 0
	i32.const	$push247=, 0
	i32.load	$push19=, j($pop247)
	i32.const	$push246=, 0
	i32.load	$push18=, i($pop246)
	i32.add 	$push20=, $pop19, $pop18
	i32.store	$3=, k($pop248), $pop20
	i32.const	$push245=, 0
	i32.store	$drop=, res+12($pop245), $0
	i32.const	$push244=, 0
	i32.store	$drop=, res+8($pop244), $1
	i32.const	$push243=, 0
	i32.store	$drop=, res+4($pop243), $2
	i32.const	$push242=, 0
	i32.store	$push0=, res($pop242), $3
	i32.const	$push24=, 160
	i32.const	$push23=, 113
	i32.const	$push22=, 170
	i32.const	$push21=, 230
	call    	verify@FUNCTION, $pop0, $2, $1, $0, $pop24, $pop23, $pop22, $pop21
	i32.const	$push241=, 0
	i32.const	$push240=, 0
	i32.load	$push26=, j+12($pop240)
	i32.const	$push239=, 0
	i32.load	$push25=, i+12($pop239)
	i32.mul 	$push27=, $pop26, $pop25
	i32.store	$0=, k+12($pop241), $pop27
	i32.const	$push238=, 0
	i32.const	$push237=, 0
	i32.load	$push29=, j+8($pop237)
	i32.const	$push236=, 0
	i32.load	$push28=, i+8($pop236)
	i32.mul 	$push30=, $pop29, $pop28
	i32.store	$1=, k+8($pop238), $pop30
	i32.const	$push235=, 0
	i32.const	$push234=, 0
	i32.load	$push32=, j+4($pop234)
	i32.const	$push233=, 0
	i32.load	$push31=, i+4($pop233)
	i32.mul 	$push33=, $pop32, $pop31
	i32.store	$2=, k+4($pop235), $pop33
	i32.const	$push232=, 0
	i32.const	$push231=, 0
	i32.load	$push35=, j($pop231)
	i32.const	$push230=, 0
	i32.load	$push34=, i($pop230)
	i32.mul 	$push36=, $pop35, $pop34
	i32.store	$3=, k($pop232), $pop36
	i32.const	$push229=, 0
	i32.store	$drop=, res+12($pop229), $0
	i32.const	$push228=, 0
	i32.store	$drop=, res+8($pop228), $1
	i32.const	$push227=, 0
	i32.store	$drop=, res+4($pop227), $2
	i32.const	$push226=, 0
	i32.store	$push1=, res($pop226), $3
	i32.const	$push40=, 1500
	i32.const	$push39=, 1300
	i32.const	$push38=, 3000
	i32.const	$push37=, 6000
	call    	verify@FUNCTION, $pop1, $2, $1, $0, $pop40, $pop39, $pop38, $pop37
	i32.const	$push225=, 0
	i32.const	$push224=, 0
	i32.load	$push42=, i+12($pop224)
	i32.const	$push223=, 0
	i32.load	$push41=, j+12($pop223)
	i32.div_s	$push43=, $pop42, $pop41
	i32.store	$0=, k+12($pop225), $pop43
	i32.const	$push222=, 0
	i32.const	$push221=, 0
	i32.load	$push45=, i+8($pop221)
	i32.const	$push220=, 0
	i32.load	$push44=, j+8($pop220)
	i32.div_s	$push46=, $pop45, $pop44
	i32.store	$1=, k+8($pop222), $pop46
	i32.const	$push219=, 0
	i32.const	$push218=, 0
	i32.load	$push48=, i+4($pop218)
	i32.const	$push217=, 0
	i32.load	$push47=, j+4($pop217)
	i32.div_s	$push49=, $pop48, $pop47
	i32.store	$2=, k+4($pop219), $pop49
	i32.const	$push216=, 0
	i32.const	$push215=, 0
	i32.load	$push51=, i($pop215)
	i32.const	$push214=, 0
	i32.load	$push50=, j($pop214)
	i32.div_s	$push52=, $pop51, $pop50
	i32.store	$3=, k($pop216), $pop52
	i32.const	$push213=, 0
	i32.store	$drop=, res+12($pop213), $0
	i32.const	$push212=, 0
	i32.store	$drop=, res+8($pop212), $1
	i32.const	$push211=, 0
	i32.store	$drop=, res+4($pop211), $2
	i32.const	$push210=, 0
	i32.store	$push2=, res($pop210), $3
	i32.const	$push55=, 15
	i32.const	$push54=, 7
	i32.const	$push209=, 7
	i32.const	$push53=, 6
	call    	verify@FUNCTION, $pop2, $2, $1, $0, $pop55, $pop54, $pop209, $pop53
	i32.const	$push208=, 0
	i32.const	$push207=, 0
	i32.load	$push57=, j+12($pop207)
	i32.const	$push206=, 0
	i32.load	$push56=, i+12($pop206)
	i32.and 	$push58=, $pop57, $pop56
	i32.store	$0=, k+12($pop208), $pop58
	i32.const	$push205=, 0
	i32.const	$push204=, 0
	i32.load	$push60=, j+8($pop204)
	i32.const	$push203=, 0
	i32.load	$push59=, i+8($pop203)
	i32.and 	$push61=, $pop60, $pop59
	i32.store	$1=, k+8($pop205), $pop61
	i32.const	$push202=, 0
	i32.const	$push201=, 0
	i32.load	$push63=, j+4($pop201)
	i32.const	$push200=, 0
	i32.load	$push62=, i+4($pop200)
	i32.and 	$push64=, $pop63, $pop62
	i32.store	$2=, k+4($pop202), $pop64
	i32.const	$push199=, 0
	i32.const	$push198=, 0
	i32.load	$push66=, j($pop198)
	i32.const	$push197=, 0
	i32.load	$push65=, i($pop197)
	i32.and 	$push67=, $pop66, $pop65
	i32.store	$3=, k($pop199), $pop67
	i32.const	$push196=, 0
	i32.store	$drop=, res+12($pop196), $0
	i32.const	$push195=, 0
	i32.store	$drop=, res+8($pop195), $1
	i32.const	$push194=, 0
	i32.store	$drop=, res+4($pop194), $2
	i32.const	$push193=, 0
	i32.store	$push3=, res($pop193), $3
	i32.const	$push71=, 2
	i32.const	$push70=, 4
	i32.const	$push69=, 20
	i32.const	$push68=, 8
	call    	verify@FUNCTION, $pop3, $2, $1, $0, $pop71, $pop70, $pop69, $pop68
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.load	$push73=, j+12($pop191)
	i32.const	$push190=, 0
	i32.load	$push72=, i+12($pop190)
	i32.or  	$push74=, $pop73, $pop72
	i32.store	$0=, k+12($pop192), $pop74
	i32.const	$push189=, 0
	i32.const	$push188=, 0
	i32.load	$push76=, j+8($pop188)
	i32.const	$push187=, 0
	i32.load	$push75=, i+8($pop187)
	i32.or  	$push77=, $pop76, $pop75
	i32.store	$1=, k+8($pop189), $pop77
	i32.const	$push186=, 0
	i32.const	$push185=, 0
	i32.load	$push79=, j+4($pop185)
	i32.const	$push184=, 0
	i32.load	$push78=, i+4($pop184)
	i32.or  	$push80=, $pop79, $pop78
	i32.store	$2=, k+4($pop186), $pop80
	i32.const	$push183=, 0
	i32.const	$push182=, 0
	i32.load	$push82=, j($pop182)
	i32.const	$push181=, 0
	i32.load	$push81=, i($pop181)
	i32.or  	$push83=, $pop82, $pop81
	i32.store	$3=, k($pop183), $pop83
	i32.const	$push180=, 0
	i32.store	$drop=, res+12($pop180), $0
	i32.const	$push179=, 0
	i32.store	$drop=, res+8($pop179), $1
	i32.const	$push178=, 0
	i32.store	$drop=, res+4($pop178), $2
	i32.const	$push177=, 0
	i32.store	$push4=, res($pop177), $3
	i32.const	$push87=, 158
	i32.const	$push86=, 109
	i32.const	$push85=, 150
	i32.const	$push84=, 222
	call    	verify@FUNCTION, $pop4, $2, $1, $0, $pop87, $pop86, $pop85, $pop84
	i32.const	$push176=, 0
	i32.const	$push175=, 0
	i32.load	$push89=, i+12($pop175)
	i32.const	$push174=, 0
	i32.load	$push88=, j+12($pop174)
	i32.xor 	$push90=, $pop89, $pop88
	i32.store	$0=, k+12($pop176), $pop90
	i32.const	$push173=, 0
	i32.const	$push172=, 0
	i32.load	$push92=, i+8($pop172)
	i32.const	$push171=, 0
	i32.load	$push91=, j+8($pop171)
	i32.xor 	$push93=, $pop92, $pop91
	i32.store	$1=, k+8($pop173), $pop93
	i32.const	$push170=, 0
	i32.const	$push169=, 0
	i32.load	$push95=, i+4($pop169)
	i32.const	$push168=, 0
	i32.load	$push94=, j+4($pop168)
	i32.xor 	$push96=, $pop95, $pop94
	i32.store	$2=, k+4($pop170), $pop96
	i32.const	$push167=, 0
	i32.const	$push166=, 0
	i32.load	$push98=, i($pop166)
	i32.const	$push165=, 0
	i32.load	$push97=, j($pop165)
	i32.xor 	$push99=, $pop98, $pop97
	i32.store	$3=, k($pop167), $pop99
	i32.const	$push164=, 0
	i32.store	$drop=, res+12($pop164), $0
	i32.const	$push163=, 0
	i32.store	$drop=, res+8($pop163), $1
	i32.const	$push162=, 0
	i32.store	$drop=, res+4($pop162), $2
	i32.const	$push161=, 0
	i32.store	$push5=, res($pop161), $3
	i32.const	$push103=, 156
	i32.const	$push102=, 105
	i32.const	$push101=, 130
	i32.const	$push100=, 214
	call    	verify@FUNCTION, $pop5, $2, $1, $0, $pop103, $pop102, $pop101, $pop100
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.const	$push158=, 0
	i32.load	$push104=, i+12($pop158)
	i32.sub 	$push105=, $pop159, $pop104
	i32.store	$0=, k+12($pop160), $pop105
	i32.const	$push157=, 0
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.load	$push106=, i+8($pop155)
	i32.sub 	$push107=, $pop156, $pop106
	i32.store	$1=, k+8($pop157), $pop107
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.const	$push152=, 0
	i32.load	$push108=, i+4($pop152)
	i32.sub 	$push109=, $pop153, $pop108
	i32.store	$2=, k+4($pop154), $pop109
	i32.const	$push151=, 0
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push110=, i($pop149)
	i32.sub 	$push111=, $pop150, $pop110
	i32.store	$3=, k($pop151), $pop111
	i32.const	$push148=, 0
	i32.store	$drop=, res+12($pop148), $0
	i32.const	$push147=, 0
	i32.store	$drop=, res+8($pop147), $1
	i32.const	$push146=, 0
	i32.store	$drop=, res+4($pop146), $2
	i32.const	$push145=, 0
	i32.store	$push6=, res($pop145), $3
	i32.const	$push114=, -150
	i32.const	$push113=, -100
	i32.const	$push144=, -150
	i32.const	$push112=, -200
	call    	verify@FUNCTION, $pop6, $2, $1, $0, $pop114, $pop113, $pop144, $pop112
	i32.const	$push143=, 0
	i32.const	$push142=, 0
	i32.load	$push115=, i+12($pop142)
	i32.const	$push116=, -1
	i32.xor 	$push117=, $pop115, $pop116
	i32.store	$0=, k+12($pop143), $pop117
	i32.const	$push141=, 0
	i32.const	$push140=, 0
	i32.load	$push118=, i+8($pop140)
	i32.const	$push139=, -1
	i32.xor 	$push119=, $pop118, $pop139
	i32.store	$1=, k+8($pop141), $pop119
	i32.const	$push138=, 0
	i32.const	$push137=, 0
	i32.load	$push120=, i+4($pop137)
	i32.const	$push136=, -1
	i32.xor 	$push121=, $pop120, $pop136
	i32.store	$2=, k+4($pop138), $pop121
	i32.const	$push135=, 0
	i32.const	$push134=, 0
	i32.load	$push122=, i($pop134)
	i32.const	$push133=, -1
	i32.xor 	$push123=, $pop122, $pop133
	i32.store	$3=, k($pop135), $pop123
	i32.const	$push132=, 0
	i32.store	$drop=, res+12($pop132), $0
	i32.const	$push131=, 0
	i32.store	$drop=, res+8($pop131), $1
	i32.const	$push130=, 0
	i32.store	$drop=, res+4($pop130), $2
	i32.const	$push129=, 0
	i32.store	$push7=, res($pop129), $3
	i32.const	$push126=, -151
	i32.const	$push125=, -101
	i32.const	$push128=, -151
	i32.const	$push124=, -201
	call    	verify@FUNCTION, $pop7, $2, $1, $0, $pop126, $pop125, $pop128, $pop124
	i32.const	$push127=, 0
	call    	exit@FUNCTION, $pop127
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
	.int32	150                     # 0x96
	.int32	100                     # 0x64
	.int32	150                     # 0x96
	.int32	200                     # 0xc8
	.size	i, 16

	.hidden	j                       # @j
	.type	j,@object
	.section	.data.j,"aw",@progbits
	.globl	j
	.p2align	4
j:
	.int32	10                      # 0xa
	.int32	13                      # 0xd
	.int32	20                      # 0x14
	.int32	30                      # 0x1e
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
