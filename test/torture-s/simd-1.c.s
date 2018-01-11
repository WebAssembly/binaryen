	.text
	.file	"simd-1.c"
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
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push2=, j+12($pop0)
	i32.const	$push216=, 0
	i32.load	$push1=, i+12($pop216)
	i32.add 	$0=, $pop2, $pop1
	i32.const	$push215=, 0
	i32.store	k+12($pop215), $0
	i32.const	$push214=, 0
	i32.load	$push4=, j+8($pop214)
	i32.const	$push213=, 0
	i32.load	$push3=, i+8($pop213)
	i32.add 	$1=, $pop4, $pop3
	i32.const	$push212=, 0
	i32.store	k+8($pop212), $1
	i32.const	$push211=, 0
	i32.load	$push6=, j+4($pop211)
	i32.const	$push210=, 0
	i32.load	$push5=, i+4($pop210)
	i32.add 	$2=, $pop6, $pop5
	i32.const	$push209=, 0
	i32.store	k+4($pop209), $2
	i32.const	$push208=, 0
	i32.load	$push8=, j($pop208)
	i32.const	$push207=, 0
	i32.load	$push7=, i($pop207)
	i32.add 	$3=, $pop8, $pop7
	i32.const	$push206=, 0
	i32.store	k($pop206), $3
	i32.const	$push205=, 0
	i32.store	res+12($pop205), $0
	i32.const	$push204=, 0
	i32.store	res+8($pop204), $1
	i32.const	$push203=, 0
	i32.store	res+4($pop203), $2
	i32.const	$push202=, 0
	i32.store	res($pop202), $3
	i32.const	$push12=, 160
	i32.const	$push11=, 113
	i32.const	$push10=, 170
	i32.const	$push9=, 230
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop12, $pop11, $pop10, $pop9
	i32.const	$push201=, 0
	i32.load	$push14=, j+12($pop201)
	i32.const	$push200=, 0
	i32.load	$push13=, i+12($pop200)
	i32.mul 	$0=, $pop14, $pop13
	i32.const	$push199=, 0
	i32.store	k+12($pop199), $0
	i32.const	$push198=, 0
	i32.load	$push16=, j+8($pop198)
	i32.const	$push197=, 0
	i32.load	$push15=, i+8($pop197)
	i32.mul 	$1=, $pop16, $pop15
	i32.const	$push196=, 0
	i32.store	k+8($pop196), $1
	i32.const	$push195=, 0
	i32.load	$push18=, j+4($pop195)
	i32.const	$push194=, 0
	i32.load	$push17=, i+4($pop194)
	i32.mul 	$2=, $pop18, $pop17
	i32.const	$push193=, 0
	i32.store	k+4($pop193), $2
	i32.const	$push192=, 0
	i32.load	$push20=, j($pop192)
	i32.const	$push191=, 0
	i32.load	$push19=, i($pop191)
	i32.mul 	$3=, $pop20, $pop19
	i32.const	$push190=, 0
	i32.store	k($pop190), $3
	i32.const	$push189=, 0
	i32.store	res+12($pop189), $0
	i32.const	$push188=, 0
	i32.store	res+8($pop188), $1
	i32.const	$push187=, 0
	i32.store	res+4($pop187), $2
	i32.const	$push186=, 0
	i32.store	res($pop186), $3
	i32.const	$push24=, 1500
	i32.const	$push23=, 1300
	i32.const	$push22=, 3000
	i32.const	$push21=, 6000
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop24, $pop23, $pop22, $pop21
	i32.const	$push185=, 0
	i32.load	$push26=, i+12($pop185)
	i32.const	$push184=, 0
	i32.load	$push25=, j+12($pop184)
	i32.div_s	$0=, $pop26, $pop25
	i32.const	$push183=, 0
	i32.store	k+12($pop183), $0
	i32.const	$push182=, 0
	i32.load	$push28=, i+8($pop182)
	i32.const	$push181=, 0
	i32.load	$push27=, j+8($pop181)
	i32.div_s	$1=, $pop28, $pop27
	i32.const	$push180=, 0
	i32.store	k+8($pop180), $1
	i32.const	$push179=, 0
	i32.load	$push30=, i+4($pop179)
	i32.const	$push178=, 0
	i32.load	$push29=, j+4($pop178)
	i32.div_s	$2=, $pop30, $pop29
	i32.const	$push177=, 0
	i32.store	k+4($pop177), $2
	i32.const	$push176=, 0
	i32.load	$push32=, i($pop176)
	i32.const	$push175=, 0
	i32.load	$push31=, j($pop175)
	i32.div_s	$3=, $pop32, $pop31
	i32.const	$push174=, 0
	i32.store	k($pop174), $3
	i32.const	$push173=, 0
	i32.store	res+12($pop173), $0
	i32.const	$push172=, 0
	i32.store	res+8($pop172), $1
	i32.const	$push171=, 0
	i32.store	res+4($pop171), $2
	i32.const	$push170=, 0
	i32.store	res($pop170), $3
	i32.const	$push35=, 15
	i32.const	$push34=, 7
	i32.const	$push169=, 7
	i32.const	$push33=, 6
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop35, $pop34, $pop169, $pop33
	i32.const	$push168=, 0
	i32.load	$push37=, j+12($pop168)
	i32.const	$push167=, 0
	i32.load	$push36=, i+12($pop167)
	i32.and 	$0=, $pop37, $pop36
	i32.const	$push166=, 0
	i32.store	k+12($pop166), $0
	i32.const	$push165=, 0
	i32.load	$push39=, j+8($pop165)
	i32.const	$push164=, 0
	i32.load	$push38=, i+8($pop164)
	i32.and 	$1=, $pop39, $pop38
	i32.const	$push163=, 0
	i32.store	k+8($pop163), $1
	i32.const	$push162=, 0
	i32.load	$push41=, j+4($pop162)
	i32.const	$push161=, 0
	i32.load	$push40=, i+4($pop161)
	i32.and 	$2=, $pop41, $pop40
	i32.const	$push160=, 0
	i32.store	k+4($pop160), $2
	i32.const	$push159=, 0
	i32.load	$push43=, j($pop159)
	i32.const	$push158=, 0
	i32.load	$push42=, i($pop158)
	i32.and 	$3=, $pop43, $pop42
	i32.const	$push157=, 0
	i32.store	k($pop157), $3
	i32.const	$push156=, 0
	i32.store	res+12($pop156), $0
	i32.const	$push155=, 0
	i32.store	res+8($pop155), $1
	i32.const	$push154=, 0
	i32.store	res+4($pop154), $2
	i32.const	$push153=, 0
	i32.store	res($pop153), $3
	i32.const	$push47=, 2
	i32.const	$push46=, 4
	i32.const	$push45=, 20
	i32.const	$push44=, 8
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop47, $pop46, $pop45, $pop44
	i32.const	$push152=, 0
	i32.load	$push49=, j+12($pop152)
	i32.const	$push151=, 0
	i32.load	$push48=, i+12($pop151)
	i32.or  	$0=, $pop49, $pop48
	i32.const	$push150=, 0
	i32.store	k+12($pop150), $0
	i32.const	$push149=, 0
	i32.load	$push51=, j+8($pop149)
	i32.const	$push148=, 0
	i32.load	$push50=, i+8($pop148)
	i32.or  	$1=, $pop51, $pop50
	i32.const	$push147=, 0
	i32.store	k+8($pop147), $1
	i32.const	$push146=, 0
	i32.load	$push53=, j+4($pop146)
	i32.const	$push145=, 0
	i32.load	$push52=, i+4($pop145)
	i32.or  	$2=, $pop53, $pop52
	i32.const	$push144=, 0
	i32.store	k+4($pop144), $2
	i32.const	$push143=, 0
	i32.load	$push55=, j($pop143)
	i32.const	$push142=, 0
	i32.load	$push54=, i($pop142)
	i32.or  	$3=, $pop55, $pop54
	i32.const	$push141=, 0
	i32.store	k($pop141), $3
	i32.const	$push140=, 0
	i32.store	res+12($pop140), $0
	i32.const	$push139=, 0
	i32.store	res+8($pop139), $1
	i32.const	$push138=, 0
	i32.store	res+4($pop138), $2
	i32.const	$push137=, 0
	i32.store	res($pop137), $3
	i32.const	$push59=, 158
	i32.const	$push58=, 109
	i32.const	$push57=, 150
	i32.const	$push56=, 222
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop59, $pop58, $pop57, $pop56
	i32.const	$push136=, 0
	i32.load	$push61=, j+12($pop136)
	i32.const	$push135=, 0
	i32.load	$push60=, i+12($pop135)
	i32.xor 	$0=, $pop61, $pop60
	i32.const	$push134=, 0
	i32.store	k+12($pop134), $0
	i32.const	$push133=, 0
	i32.load	$push63=, j+8($pop133)
	i32.const	$push132=, 0
	i32.load	$push62=, i+8($pop132)
	i32.xor 	$1=, $pop63, $pop62
	i32.const	$push131=, 0
	i32.store	k+8($pop131), $1
	i32.const	$push130=, 0
	i32.load	$push65=, j+4($pop130)
	i32.const	$push129=, 0
	i32.load	$push64=, i+4($pop129)
	i32.xor 	$2=, $pop65, $pop64
	i32.const	$push128=, 0
	i32.store	k+4($pop128), $2
	i32.const	$push127=, 0
	i32.load	$push67=, j($pop127)
	i32.const	$push126=, 0
	i32.load	$push66=, i($pop126)
	i32.xor 	$3=, $pop67, $pop66
	i32.const	$push125=, 0
	i32.store	k($pop125), $3
	i32.const	$push124=, 0
	i32.store	res+12($pop124), $0
	i32.const	$push123=, 0
	i32.store	res+8($pop123), $1
	i32.const	$push122=, 0
	i32.store	res+4($pop122), $2
	i32.const	$push121=, 0
	i32.store	res($pop121), $3
	i32.const	$push71=, 156
	i32.const	$push70=, 105
	i32.const	$push69=, 130
	i32.const	$push68=, 214
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop71, $pop70, $pop69, $pop68
	i32.const	$push120=, 0
	i32.const	$push119=, 0
	i32.load	$push72=, i+12($pop119)
	i32.sub 	$0=, $pop120, $pop72
	i32.const	$push118=, 0
	i32.store	k+12($pop118), $0
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.load	$push73=, i+8($pop116)
	i32.sub 	$1=, $pop117, $pop73
	i32.const	$push115=, 0
	i32.store	k+8($pop115), $1
	i32.const	$push114=, 0
	i32.const	$push113=, 0
	i32.load	$push74=, i+4($pop113)
	i32.sub 	$2=, $pop114, $pop74
	i32.const	$push112=, 0
	i32.store	k+4($pop112), $2
	i32.const	$push111=, 0
	i32.const	$push110=, 0
	i32.load	$push75=, i($pop110)
	i32.sub 	$3=, $pop111, $pop75
	i32.const	$push109=, 0
	i32.store	k($pop109), $3
	i32.const	$push108=, 0
	i32.store	res+12($pop108), $0
	i32.const	$push107=, 0
	i32.store	res+8($pop107), $1
	i32.const	$push106=, 0
	i32.store	res+4($pop106), $2
	i32.const	$push105=, 0
	i32.store	res($pop105), $3
	i32.const	$push78=, -150
	i32.const	$push77=, -100
	i32.const	$push104=, -150
	i32.const	$push76=, -200
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop78, $pop77, $pop104, $pop76
	i32.const	$push103=, 0
	i32.load	$push79=, i+12($pop103)
	i32.const	$push80=, -1
	i32.xor 	$0=, $pop79, $pop80
	i32.const	$push102=, 0
	i32.store	k+12($pop102), $0
	i32.const	$push101=, 0
	i32.load	$push81=, i+8($pop101)
	i32.const	$push100=, -1
	i32.xor 	$1=, $pop81, $pop100
	i32.const	$push99=, 0
	i32.store	k+8($pop99), $1
	i32.const	$push98=, 0
	i32.load	$push82=, i+4($pop98)
	i32.const	$push97=, -1
	i32.xor 	$2=, $pop82, $pop97
	i32.const	$push96=, 0
	i32.store	k+4($pop96), $2
	i32.const	$push95=, 0
	i32.load	$push83=, i($pop95)
	i32.const	$push94=, -1
	i32.xor 	$3=, $pop83, $pop94
	i32.const	$push93=, 0
	i32.store	k($pop93), $3
	i32.const	$push92=, 0
	i32.store	res+12($pop92), $0
	i32.const	$push91=, 0
	i32.store	res+8($pop91), $1
	i32.const	$push90=, 0
	i32.store	res+4($pop90), $2
	i32.const	$push89=, 0
	i32.store	res($pop89), $3
	i32.const	$push86=, -151
	i32.const	$push85=, -101
	i32.const	$push88=, -151
	i32.const	$push84=, -201
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop86, $pop85, $pop88, $pop84
	i32.const	$push87=, 0
	call    	exit@FUNCTION, $pop87
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
