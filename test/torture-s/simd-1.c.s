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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$1=, i+8($pop8)
	i32.const	$push217=, 0
	i32.load	$2=, i+4($pop217)
	i32.const	$push216=, 0
	i32.load	$3=, i($pop216)
	i32.const	$push215=, 0
	i32.load	$6=, j($pop215)
	i32.const	$push214=, 0
	i32.load	$5=, j+4($pop214)
	i32.const	$push213=, 0
	i32.load	$4=, j+8($pop213)
	i32.const	$push212=, 0
	i32.const	$push211=, 0
	i32.load	$push10=, j+12($pop211)
	i32.const	$push210=, 0
	i32.load	$push9=, i+12($pop210)
	i32.add 	$push14=, $pop10, $pop9
	i32.store	$0=, k+12($pop212), $pop14
	i32.const	$push209=, 0
	i32.add 	$push13=, $4, $1
	i32.store	$1=, k+8($pop209), $pop13
	i32.const	$push208=, 0
	i32.add 	$push12=, $5, $2
	i32.store	$2=, k+4($pop208), $pop12
	i32.const	$push207=, 0
	i32.add 	$push11=, $6, $3
	i32.store	$3=, k($pop207), $pop11
	i32.const	$push206=, 0
	i32.store	$6=, res+12($pop206), $0
	i32.const	$push205=, 0
	i32.store	$discard=, res+8($pop205), $1
	i32.const	$push204=, 0
	i32.store	$discard=, res+4($pop204), $2
	i32.const	$push203=, 0
	i32.store	$push0=, res($pop203), $3
	i32.const	$push18=, 160
	i32.const	$push17=, 113
	i32.const	$push16=, 170
	i32.const	$push15=, 230
	call    	verify@FUNCTION, $pop0, $2, $1, $6, $pop18, $pop17, $pop16, $pop15
	i32.const	$push202=, 0
	i32.load	$1=, i+8($pop202)
	i32.const	$push201=, 0
	i32.load	$2=, i+4($pop201)
	i32.const	$push200=, 0
	i32.load	$3=, i($pop200)
	i32.const	$push199=, 0
	i32.load	$6=, j($pop199)
	i32.const	$push198=, 0
	i32.load	$5=, j+4($pop198)
	i32.const	$push197=, 0
	i32.load	$4=, j+8($pop197)
	i32.const	$push196=, 0
	i32.const	$push195=, 0
	i32.load	$push20=, j+12($pop195)
	i32.const	$push194=, 0
	i32.load	$push19=, i+12($pop194)
	i32.mul 	$push24=, $pop20, $pop19
	i32.store	$0=, k+12($pop196), $pop24
	i32.const	$push193=, 0
	i32.mul 	$push23=, $4, $1
	i32.store	$1=, k+8($pop193), $pop23
	i32.const	$push192=, 0
	i32.mul 	$push22=, $5, $2
	i32.store	$2=, k+4($pop192), $pop22
	i32.const	$push191=, 0
	i32.mul 	$push21=, $6, $3
	i32.store	$3=, k($pop191), $pop21
	i32.const	$push190=, 0
	i32.store	$6=, res+12($pop190), $0
	i32.const	$push189=, 0
	i32.store	$discard=, res+8($pop189), $1
	i32.const	$push188=, 0
	i32.store	$discard=, res+4($pop188), $2
	i32.const	$push187=, 0
	i32.store	$push1=, res($pop187), $3
	i32.const	$push28=, 1500
	i32.const	$push27=, 1300
	i32.const	$push26=, 3000
	i32.const	$push25=, 6000
	call    	verify@FUNCTION, $pop1, $2, $1, $6, $pop28, $pop27, $pop26, $pop25
	i32.const	$push186=, 0
	i32.load	$push32=, i($pop186)
	i32.const	$push185=, 0
	i32.load	$push36=, j($pop185)
	i32.div_s	$1=, $pop32, $pop36
	i32.const	$push184=, 0
	i32.load	$push31=, i+4($pop184)
	i32.const	$push183=, 0
	i32.load	$push35=, j+4($pop183)
	i32.div_s	$2=, $pop31, $pop35
	i32.const	$push182=, 0
	i32.load	$push30=, i+8($pop182)
	i32.const	$push181=, 0
	i32.load	$push34=, j+8($pop181)
	i32.div_s	$3=, $pop30, $pop34
	i32.const	$push180=, 0
	i32.const	$push179=, 0
	i32.load	$push29=, i+12($pop179)
	i32.const	$push178=, 0
	i32.load	$push33=, j+12($pop178)
	i32.div_s	$push37=, $pop29, $pop33
	i32.store	$6=, k+12($pop180), $pop37
	i32.const	$push177=, 0
	i32.store	$discard=, k+8($pop177), $3
	i32.const	$push176=, 0
	i32.store	$discard=, k+4($pop176), $2
	i32.const	$push175=, 0
	i32.store	$discard=, k($pop175), $1
	i32.const	$push174=, 0
	i32.store	$discard=, res+12($pop174), $6
	i32.const	$push173=, 0
	i32.store	$discard=, res+8($pop173), $3
	i32.const	$push172=, 0
	i32.store	$discard=, res+4($pop172), $2
	i32.const	$push171=, 0
	i32.store	$push2=, res($pop171), $1
	i32.const	$push40=, 15
	i32.const	$push39=, 7
	i32.const	$push170=, 7
	i32.const	$push38=, 6
	call    	verify@FUNCTION, $pop2, $2, $3, $6, $pop40, $pop39, $pop170, $pop38
	i32.const	$push169=, 0
	i32.load	$1=, i+8($pop169)
	i32.const	$push168=, 0
	i32.load	$2=, i+4($pop168)
	i32.const	$push167=, 0
	i32.load	$3=, i($pop167)
	i32.const	$push166=, 0
	i32.load	$6=, j($pop166)
	i32.const	$push165=, 0
	i32.load	$5=, j+4($pop165)
	i32.const	$push164=, 0
	i32.load	$4=, j+8($pop164)
	i32.const	$push163=, 0
	i32.const	$push162=, 0
	i32.load	$push42=, j+12($pop162)
	i32.const	$push161=, 0
	i32.load	$push41=, i+12($pop161)
	i32.and 	$push46=, $pop42, $pop41
	i32.store	$0=, k+12($pop163), $pop46
	i32.const	$push160=, 0
	i32.and 	$push45=, $4, $1
	i32.store	$1=, k+8($pop160), $pop45
	i32.const	$push159=, 0
	i32.and 	$push44=, $5, $2
	i32.store	$2=, k+4($pop159), $pop44
	i32.const	$push158=, 0
	i32.and 	$push43=, $6, $3
	i32.store	$3=, k($pop158), $pop43
	i32.const	$push157=, 0
	i32.store	$6=, res+12($pop157), $0
	i32.const	$push156=, 0
	i32.store	$discard=, res+8($pop156), $1
	i32.const	$push155=, 0
	i32.store	$discard=, res+4($pop155), $2
	i32.const	$push154=, 0
	i32.store	$push3=, res($pop154), $3
	i32.const	$push50=, 2
	i32.const	$push49=, 4
	i32.const	$push48=, 20
	i32.const	$push47=, 8
	call    	verify@FUNCTION, $pop3, $2, $1, $6, $pop50, $pop49, $pop48, $pop47
	i32.const	$push153=, 0
	i32.load	$1=, i+8($pop153)
	i32.const	$push152=, 0
	i32.load	$2=, i+4($pop152)
	i32.const	$push151=, 0
	i32.load	$3=, i($pop151)
	i32.const	$push150=, 0
	i32.load	$6=, j($pop150)
	i32.const	$push149=, 0
	i32.load	$5=, j+4($pop149)
	i32.const	$push148=, 0
	i32.load	$4=, j+8($pop148)
	i32.const	$push147=, 0
	i32.const	$push146=, 0
	i32.load	$push52=, j+12($pop146)
	i32.const	$push145=, 0
	i32.load	$push51=, i+12($pop145)
	i32.or  	$push56=, $pop52, $pop51
	i32.store	$0=, k+12($pop147), $pop56
	i32.const	$push144=, 0
	i32.or  	$push55=, $4, $1
	i32.store	$1=, k+8($pop144), $pop55
	i32.const	$push143=, 0
	i32.or  	$push54=, $5, $2
	i32.store	$2=, k+4($pop143), $pop54
	i32.const	$push142=, 0
	i32.or  	$push53=, $6, $3
	i32.store	$3=, k($pop142), $pop53
	i32.const	$push141=, 0
	i32.store	$6=, res+12($pop141), $0
	i32.const	$push140=, 0
	i32.store	$discard=, res+8($pop140), $1
	i32.const	$push139=, 0
	i32.store	$discard=, res+4($pop139), $2
	i32.const	$push138=, 0
	i32.store	$push4=, res($pop138), $3
	i32.const	$push60=, 158
	i32.const	$push59=, 109
	i32.const	$push58=, 150
	i32.const	$push57=, 222
	call    	verify@FUNCTION, $pop4, $2, $1, $6, $pop60, $pop59, $pop58, $pop57
	i32.const	$push137=, 0
	i32.load	$1=, i+8($pop137)
	i32.const	$push136=, 0
	i32.load	$2=, i+4($pop136)
	i32.const	$push135=, 0
	i32.load	$3=, i($pop135)
	i32.const	$push134=, 0
	i32.load	$6=, j($pop134)
	i32.const	$push133=, 0
	i32.load	$5=, j+4($pop133)
	i32.const	$push132=, 0
	i32.load	$4=, j+8($pop132)
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.load	$push61=, i+12($pop130)
	i32.const	$push129=, 0
	i32.load	$push62=, j+12($pop129)
	i32.xor 	$push66=, $pop61, $pop62
	i32.store	$0=, k+12($pop131), $pop66
	i32.const	$push128=, 0
	i32.xor 	$push65=, $1, $4
	i32.store	$1=, k+8($pop128), $pop65
	i32.const	$push127=, 0
	i32.xor 	$push64=, $2, $5
	i32.store	$2=, k+4($pop127), $pop64
	i32.const	$push126=, 0
	i32.xor 	$push63=, $3, $6
	i32.store	$3=, k($pop126), $pop63
	i32.const	$push125=, 0
	i32.store	$6=, res+12($pop125), $0
	i32.const	$push124=, 0
	i32.store	$discard=, res+8($pop124), $1
	i32.const	$push123=, 0
	i32.store	$discard=, res+4($pop123), $2
	i32.const	$push122=, 0
	i32.store	$push5=, res($pop122), $3
	i32.const	$push70=, 156
	i32.const	$push69=, 105
	i32.const	$push68=, 130
	i32.const	$push67=, 214
	call    	verify@FUNCTION, $pop5, $2, $1, $6, $pop70, $pop69, $pop68, $pop67
	i32.const	$push121=, 0
	i32.load	$1=, i($pop121)
	i32.const	$push120=, 0
	i32.load	$2=, i+4($pop120)
	i32.const	$push119=, 0
	i32.load	$3=, i+8($pop119)
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.load	$push71=, i+12($pop116)
	i32.sub 	$push75=, $pop117, $pop71
	i32.store	$6=, k+12($pop118), $pop75
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.sub 	$push74=, $pop114, $3
	i32.store	$3=, k+8($pop115), $pop74
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i32.sub 	$push73=, $pop112, $2
	i32.store	$2=, k+4($pop113), $pop73
	i32.const	$push111=, 0
	i32.const	$push110=, 0
	i32.sub 	$push72=, $pop110, $1
	i32.store	$1=, k($pop111), $pop72
	i32.const	$push109=, 0
	i32.store	$discard=, res+12($pop109), $6
	i32.const	$push108=, 0
	i32.store	$discard=, res+8($pop108), $3
	i32.const	$push107=, 0
	i32.store	$discard=, res+4($pop107), $2
	i32.const	$push106=, 0
	i32.store	$push6=, res($pop106), $1
	i32.const	$push78=, -150
	i32.const	$push77=, -100
	i32.const	$push105=, -150
	i32.const	$push76=, -200
	call    	verify@FUNCTION, $pop6, $2, $3, $6, $pop78, $pop77, $pop105, $pop76
	i32.const	$push104=, 0
	i32.load	$1=, i($pop104)
	i32.const	$push103=, 0
	i32.load	$2=, i+4($pop103)
	i32.const	$push102=, 0
	i32.load	$3=, i+8($pop102)
	i32.const	$push101=, 0
	i32.const	$push100=, 0
	i32.load	$push79=, i+12($pop100)
	i32.const	$push80=, -1
	i32.xor 	$push84=, $pop79, $pop80
	i32.store	$6=, k+12($pop101), $pop84
	i32.const	$push99=, 0
	i32.const	$push98=, -1
	i32.xor 	$push83=, $3, $pop98
	i32.store	$3=, k+8($pop99), $pop83
	i32.const	$push97=, 0
	i32.const	$push96=, -1
	i32.xor 	$push82=, $2, $pop96
	i32.store	$2=, k+4($pop97), $pop82
	i32.const	$push95=, 0
	i32.const	$push94=, -1
	i32.xor 	$push81=, $1, $pop94
	i32.store	$1=, k($pop95), $pop81
	i32.const	$push93=, 0
	i32.store	$discard=, res+12($pop93), $6
	i32.const	$push92=, 0
	i32.store	$discard=, res+8($pop92), $3
	i32.const	$push91=, 0
	i32.store	$discard=, res+4($pop91), $2
	i32.const	$push90=, 0
	i32.store	$push7=, res($pop90), $1
	i32.const	$push87=, -151
	i32.const	$push86=, -101
	i32.const	$push89=, -151
	i32.const	$push85=, -201
	call    	verify@FUNCTION, $pop7, $2, $3, $6, $pop87, $pop86, $pop89, $pop85
	i32.const	$push88=, 0
	call    	exit@FUNCTION, $pop88
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
