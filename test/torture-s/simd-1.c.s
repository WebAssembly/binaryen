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
	i32.const	$push214=, 0
	i32.load	$2=, i+4($pop214)
	i32.const	$push213=, 0
	i32.load	$3=, i($pop213)
	i32.const	$push212=, 0
	i32.load	$6=, j($pop212)
	i32.const	$push211=, 0
	i32.load	$5=, j+4($pop211)
	i32.const	$push210=, 0
	i32.load	$4=, j+8($pop210)
	i32.const	$push209=, 0
	i32.const	$push208=, 0
	i32.load	$push10=, j+12($pop208)
	i32.const	$push207=, 0
	i32.load	$push9=, i+12($pop207)
	i32.add 	$push14=, $pop10, $pop9
	i32.store	$0=, k+12($pop209), $pop14
	i32.const	$push206=, 0
	i32.add 	$push13=, $4, $1
	i32.store	$1=, k+8($pop206), $pop13
	i32.const	$push205=, 0
	i32.add 	$push12=, $5, $2
	i32.store	$2=, k+4($pop205), $pop12
	i32.const	$push204=, 0
	i32.add 	$push11=, $6, $3
	i32.store	$3=, k($pop204), $pop11
	i32.const	$push203=, 0
	i32.store	$6=, res+12($pop203), $0
	i32.const	$push202=, 0
	i32.store	$discard=, res+8($pop202), $1
	i32.const	$push201=, 0
	i32.store	$discard=, res+4($pop201), $2
	i32.const	$push200=, 0
	i32.store	$push0=, res($pop200), $3
	i32.const	$push18=, 160
	i32.const	$push17=, 113
	i32.const	$push16=, 170
	i32.const	$push15=, 230
	call    	verify@FUNCTION, $pop0, $2, $1, $6, $pop18, $pop17, $pop16, $pop15
	i32.const	$push199=, 0
	i32.load	$1=, i+8($pop199)
	i32.const	$push198=, 0
	i32.load	$2=, i+4($pop198)
	i32.const	$push197=, 0
	i32.load	$3=, i($pop197)
	i32.const	$push196=, 0
	i32.load	$6=, j($pop196)
	i32.const	$push195=, 0
	i32.load	$5=, j+4($pop195)
	i32.const	$push194=, 0
	i32.load	$4=, j+8($pop194)
	i32.const	$push193=, 0
	i32.const	$push192=, 0
	i32.load	$push20=, j+12($pop192)
	i32.const	$push191=, 0
	i32.load	$push19=, i+12($pop191)
	i32.mul 	$push24=, $pop20, $pop19
	i32.store	$0=, k+12($pop193), $pop24
	i32.const	$push190=, 0
	i32.mul 	$push23=, $4, $1
	i32.store	$1=, k+8($pop190), $pop23
	i32.const	$push189=, 0
	i32.mul 	$push22=, $5, $2
	i32.store	$2=, k+4($pop189), $pop22
	i32.const	$push188=, 0
	i32.mul 	$push21=, $6, $3
	i32.store	$3=, k($pop188), $pop21
	i32.const	$push187=, 0
	i32.store	$6=, res+12($pop187), $0
	i32.const	$push186=, 0
	i32.store	$discard=, res+8($pop186), $1
	i32.const	$push185=, 0
	i32.store	$discard=, res+4($pop185), $2
	i32.const	$push184=, 0
	i32.store	$push1=, res($pop184), $3
	i32.const	$push28=, 1500
	i32.const	$push27=, 1300
	i32.const	$push26=, 3000
	i32.const	$push25=, 6000
	call    	verify@FUNCTION, $pop1, $2, $1, $6, $pop28, $pop27, $pop26, $pop25
	i32.const	$push183=, 0
	i32.load	$1=, i+8($pop183)
	i32.const	$push182=, 0
	i32.load	$2=, i+4($pop182)
	i32.const	$push181=, 0
	i32.load	$3=, i($pop181)
	i32.const	$push180=, 0
	i32.load	$6=, j($pop180)
	i32.const	$push179=, 0
	i32.load	$5=, j+4($pop179)
	i32.const	$push178=, 0
	i32.load	$4=, j+8($pop178)
	i32.const	$push177=, 0
	i32.const	$push176=, 0
	i32.load	$push29=, i+12($pop176)
	i32.const	$push175=, 0
	i32.load	$push30=, j+12($pop175)
	i32.div_s	$push34=, $pop29, $pop30
	i32.store	$0=, k+12($pop177), $pop34
	i32.const	$push174=, 0
	i32.div_s	$push33=, $1, $4
	i32.store	$1=, k+8($pop174), $pop33
	i32.const	$push173=, 0
	i32.div_s	$push32=, $2, $5
	i32.store	$2=, k+4($pop173), $pop32
	i32.const	$push172=, 0
	i32.div_s	$push31=, $3, $6
	i32.store	$3=, k($pop172), $pop31
	i32.const	$push171=, 0
	i32.store	$6=, res+12($pop171), $0
	i32.const	$push170=, 0
	i32.store	$discard=, res+8($pop170), $1
	i32.const	$push169=, 0
	i32.store	$discard=, res+4($pop169), $2
	i32.const	$push168=, 0
	i32.store	$push2=, res($pop168), $3
	i32.const	$push37=, 15
	i32.const	$push36=, 7
	i32.const	$push167=, 7
	i32.const	$push35=, 6
	call    	verify@FUNCTION, $pop2, $2, $1, $6, $pop37, $pop36, $pop167, $pop35
	i32.const	$push166=, 0
	i32.load	$1=, i+8($pop166)
	i32.const	$push165=, 0
	i32.load	$2=, i+4($pop165)
	i32.const	$push164=, 0
	i32.load	$3=, i($pop164)
	i32.const	$push163=, 0
	i32.load	$6=, j($pop163)
	i32.const	$push162=, 0
	i32.load	$5=, j+4($pop162)
	i32.const	$push161=, 0
	i32.load	$4=, j+8($pop161)
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.load	$push39=, j+12($pop159)
	i32.const	$push158=, 0
	i32.load	$push38=, i+12($pop158)
	i32.and 	$push43=, $pop39, $pop38
	i32.store	$0=, k+12($pop160), $pop43
	i32.const	$push157=, 0
	i32.and 	$push42=, $4, $1
	i32.store	$1=, k+8($pop157), $pop42
	i32.const	$push156=, 0
	i32.and 	$push41=, $5, $2
	i32.store	$2=, k+4($pop156), $pop41
	i32.const	$push155=, 0
	i32.and 	$push40=, $6, $3
	i32.store	$3=, k($pop155), $pop40
	i32.const	$push154=, 0
	i32.store	$6=, res+12($pop154), $0
	i32.const	$push153=, 0
	i32.store	$discard=, res+8($pop153), $1
	i32.const	$push152=, 0
	i32.store	$discard=, res+4($pop152), $2
	i32.const	$push151=, 0
	i32.store	$push3=, res($pop151), $3
	i32.const	$push47=, 2
	i32.const	$push46=, 4
	i32.const	$push45=, 20
	i32.const	$push44=, 8
	call    	verify@FUNCTION, $pop3, $2, $1, $6, $pop47, $pop46, $pop45, $pop44
	i32.const	$push150=, 0
	i32.load	$1=, i+8($pop150)
	i32.const	$push149=, 0
	i32.load	$2=, i+4($pop149)
	i32.const	$push148=, 0
	i32.load	$3=, i($pop148)
	i32.const	$push147=, 0
	i32.load	$6=, j($pop147)
	i32.const	$push146=, 0
	i32.load	$5=, j+4($pop146)
	i32.const	$push145=, 0
	i32.load	$4=, j+8($pop145)
	i32.const	$push144=, 0
	i32.const	$push143=, 0
	i32.load	$push49=, j+12($pop143)
	i32.const	$push142=, 0
	i32.load	$push48=, i+12($pop142)
	i32.or  	$push53=, $pop49, $pop48
	i32.store	$0=, k+12($pop144), $pop53
	i32.const	$push141=, 0
	i32.or  	$push52=, $4, $1
	i32.store	$1=, k+8($pop141), $pop52
	i32.const	$push140=, 0
	i32.or  	$push51=, $5, $2
	i32.store	$2=, k+4($pop140), $pop51
	i32.const	$push139=, 0
	i32.or  	$push50=, $6, $3
	i32.store	$3=, k($pop139), $pop50
	i32.const	$push138=, 0
	i32.store	$6=, res+12($pop138), $0
	i32.const	$push137=, 0
	i32.store	$discard=, res+8($pop137), $1
	i32.const	$push136=, 0
	i32.store	$discard=, res+4($pop136), $2
	i32.const	$push135=, 0
	i32.store	$push4=, res($pop135), $3
	i32.const	$push57=, 158
	i32.const	$push56=, 109
	i32.const	$push55=, 150
	i32.const	$push54=, 222
	call    	verify@FUNCTION, $pop4, $2, $1, $6, $pop57, $pop56, $pop55, $pop54
	i32.const	$push134=, 0
	i32.load	$1=, i+8($pop134)
	i32.const	$push133=, 0
	i32.load	$2=, i+4($pop133)
	i32.const	$push132=, 0
	i32.load	$3=, i($pop132)
	i32.const	$push131=, 0
	i32.load	$6=, j($pop131)
	i32.const	$push130=, 0
	i32.load	$5=, j+4($pop130)
	i32.const	$push129=, 0
	i32.load	$4=, j+8($pop129)
	i32.const	$push128=, 0
	i32.const	$push127=, 0
	i32.load	$push58=, i+12($pop127)
	i32.const	$push126=, 0
	i32.load	$push59=, j+12($pop126)
	i32.xor 	$push63=, $pop58, $pop59
	i32.store	$0=, k+12($pop128), $pop63
	i32.const	$push125=, 0
	i32.xor 	$push62=, $1, $4
	i32.store	$1=, k+8($pop125), $pop62
	i32.const	$push124=, 0
	i32.xor 	$push61=, $2, $5
	i32.store	$2=, k+4($pop124), $pop61
	i32.const	$push123=, 0
	i32.xor 	$push60=, $3, $6
	i32.store	$3=, k($pop123), $pop60
	i32.const	$push122=, 0
	i32.store	$6=, res+12($pop122), $0
	i32.const	$push121=, 0
	i32.store	$discard=, res+8($pop121), $1
	i32.const	$push120=, 0
	i32.store	$discard=, res+4($pop120), $2
	i32.const	$push119=, 0
	i32.store	$push5=, res($pop119), $3
	i32.const	$push67=, 156
	i32.const	$push66=, 105
	i32.const	$push65=, 130
	i32.const	$push64=, 214
	call    	verify@FUNCTION, $pop5, $2, $1, $6, $pop67, $pop66, $pop65, $pop64
	i32.const	$push118=, 0
	i32.load	$1=, i($pop118)
	i32.const	$push117=, 0
	i32.load	$2=, i+4($pop117)
	i32.const	$push116=, 0
	i32.load	$3=, i+8($pop116)
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.const	$push113=, 0
	i32.load	$push68=, i+12($pop113)
	i32.sub 	$push72=, $pop114, $pop68
	i32.store	$6=, k+12($pop115), $pop72
	i32.const	$push112=, 0
	i32.const	$push111=, 0
	i32.sub 	$push71=, $pop111, $3
	i32.store	$3=, k+8($pop112), $pop71
	i32.const	$push110=, 0
	i32.const	$push109=, 0
	i32.sub 	$push70=, $pop109, $2
	i32.store	$2=, k+4($pop110), $pop70
	i32.const	$push108=, 0
	i32.const	$push107=, 0
	i32.sub 	$push69=, $pop107, $1
	i32.store	$1=, k($pop108), $pop69
	i32.const	$push106=, 0
	i32.store	$discard=, res+12($pop106), $6
	i32.const	$push105=, 0
	i32.store	$discard=, res+8($pop105), $3
	i32.const	$push104=, 0
	i32.store	$discard=, res+4($pop104), $2
	i32.const	$push103=, 0
	i32.store	$push6=, res($pop103), $1
	i32.const	$push75=, -150
	i32.const	$push74=, -100
	i32.const	$push102=, -150
	i32.const	$push73=, -200
	call    	verify@FUNCTION, $pop6, $2, $3, $6, $pop75, $pop74, $pop102, $pop73
	i32.const	$push101=, 0
	i32.load	$1=, i($pop101)
	i32.const	$push100=, 0
	i32.load	$2=, i+4($pop100)
	i32.const	$push99=, 0
	i32.load	$3=, i+8($pop99)
	i32.const	$push98=, 0
	i32.const	$push97=, 0
	i32.load	$push76=, i+12($pop97)
	i32.const	$push77=, -1
	i32.xor 	$push81=, $pop76, $pop77
	i32.store	$6=, k+12($pop98), $pop81
	i32.const	$push96=, 0
	i32.const	$push95=, -1
	i32.xor 	$push80=, $3, $pop95
	i32.store	$3=, k+8($pop96), $pop80
	i32.const	$push94=, 0
	i32.const	$push93=, -1
	i32.xor 	$push79=, $2, $pop93
	i32.store	$2=, k+4($pop94), $pop79
	i32.const	$push92=, 0
	i32.const	$push91=, -1
	i32.xor 	$push78=, $1, $pop91
	i32.store	$1=, k($pop92), $pop78
	i32.const	$push90=, 0
	i32.store	$discard=, res+12($pop90), $6
	i32.const	$push89=, 0
	i32.store	$discard=, res+8($pop89), $3
	i32.const	$push88=, 0
	i32.store	$discard=, res+4($pop88), $2
	i32.const	$push87=, 0
	i32.store	$push7=, res($pop87), $1
	i32.const	$push84=, -151
	i32.const	$push83=, -101
	i32.const	$push86=, -151
	i32.const	$push82=, -201
	call    	verify@FUNCTION, $pop7, $2, $3, $6, $pop84, $pop83, $pop86, $pop82
	i32.const	$push85=, 0
	call    	exit@FUNCTION, $pop85
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
