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
	i32.const	$push0=, 0
	i32.load	$0=, i+8($pop0):p2align=3
	i32.const	$push217=, 0
	i32.load	$1=, i+4($pop217)
	i32.const	$push216=, 0
	i32.load	$2=, i($pop216):p2align=4
	i32.const	$push215=, 0
	i32.load	$5=, j($pop215):p2align=4
	i32.const	$push214=, 0
	i32.load	$4=, j+4($pop214)
	i32.const	$push213=, 0
	i32.load	$3=, j+8($pop213):p2align=3
	i32.const	$push212=, 0
	i32.const	$push211=, 0
	i32.load	$push2=, j+12($pop211)
	i32.const	$push210=, 0
	i32.load	$push1=, i+12($pop210)
	i32.add 	$push6=, $pop2, $pop1
	i32.store	$6=, k+12($pop212), $pop6
	i32.const	$push209=, 0
	i32.add 	$push5=, $3, $0
	i32.store	$0=, k+8($pop209):p2align=3, $pop5
	i32.const	$push208=, 0
	i32.add 	$push4=, $4, $1
	i32.store	$1=, k+4($pop208), $pop4
	i32.const	$push207=, 0
	i32.add 	$push3=, $5, $2
	i32.store	$2=, k($pop207):p2align=4, $pop3
	i32.const	$push206=, 0
	i32.store	$5=, res+12($pop206), $6
	i32.const	$push205=, 0
	i32.store	$discard=, res+8($pop205):p2align=3, $0
	i32.const	$push204=, 0
	i32.store	$discard=, res+4($pop204), $1
	i32.const	$push203=, 0
	i32.store	$push7=, res($pop203):p2align=4, $2
	i32.const	$push11=, 160
	i32.const	$push10=, 113
	i32.const	$push9=, 170
	i32.const	$push8=, 230
	call    	verify@FUNCTION, $pop7, $1, $0, $5, $pop11, $pop10, $pop9, $pop8
	i32.const	$push202=, 0
	i32.load	$0=, i+8($pop202):p2align=3
	i32.const	$push201=, 0
	i32.load	$1=, i+4($pop201)
	i32.const	$push200=, 0
	i32.load	$2=, i($pop200):p2align=4
	i32.const	$push199=, 0
	i32.load	$5=, j($pop199):p2align=4
	i32.const	$push198=, 0
	i32.load	$4=, j+4($pop198)
	i32.const	$push197=, 0
	i32.load	$3=, j+8($pop197):p2align=3
	i32.const	$push196=, 0
	i32.const	$push195=, 0
	i32.load	$push13=, j+12($pop195)
	i32.const	$push194=, 0
	i32.load	$push12=, i+12($pop194)
	i32.mul 	$push17=, $pop13, $pop12
	i32.store	$6=, k+12($pop196), $pop17
	i32.const	$push193=, 0
	i32.mul 	$push16=, $3, $0
	i32.store	$0=, k+8($pop193):p2align=3, $pop16
	i32.const	$push192=, 0
	i32.mul 	$push15=, $4, $1
	i32.store	$1=, k+4($pop192), $pop15
	i32.const	$push191=, 0
	i32.mul 	$push14=, $5, $2
	i32.store	$2=, k($pop191):p2align=4, $pop14
	i32.const	$push190=, 0
	i32.store	$5=, res+12($pop190), $6
	i32.const	$push189=, 0
	i32.store	$discard=, res+8($pop189):p2align=3, $0
	i32.const	$push188=, 0
	i32.store	$discard=, res+4($pop188), $1
	i32.const	$push187=, 0
	i32.store	$push18=, res($pop187):p2align=4, $2
	i32.const	$push22=, 1500
	i32.const	$push21=, 1300
	i32.const	$push20=, 3000
	i32.const	$push19=, 6000
	call    	verify@FUNCTION, $pop18, $1, $0, $5, $pop22, $pop21, $pop20, $pop19
	i32.const	$push186=, 0
	i32.load	$push26=, i($pop186):p2align=4
	i32.const	$push185=, 0
	i32.load	$push30=, j($pop185):p2align=4
	i32.div_s	$0=, $pop26, $pop30
	i32.const	$push184=, 0
	i32.load	$push25=, i+4($pop184)
	i32.const	$push183=, 0
	i32.load	$push29=, j+4($pop183)
	i32.div_s	$1=, $pop25, $pop29
	i32.const	$push182=, 0
	i32.load	$push24=, i+8($pop182):p2align=3
	i32.const	$push181=, 0
	i32.load	$push28=, j+8($pop181):p2align=3
	i32.div_s	$2=, $pop24, $pop28
	i32.const	$push180=, 0
	i32.const	$push179=, 0
	i32.load	$push23=, i+12($pop179)
	i32.const	$push178=, 0
	i32.load	$push27=, j+12($pop178)
	i32.div_s	$push31=, $pop23, $pop27
	i32.store	$5=, k+12($pop180), $pop31
	i32.const	$push177=, 0
	i32.store	$discard=, k+8($pop177):p2align=3, $2
	i32.const	$push176=, 0
	i32.store	$discard=, k+4($pop176), $1
	i32.const	$push175=, 0
	i32.store	$discard=, k($pop175):p2align=4, $0
	i32.const	$push174=, 0
	i32.store	$discard=, res+12($pop174), $5
	i32.const	$push173=, 0
	i32.store	$discard=, res+8($pop173):p2align=3, $2
	i32.const	$push172=, 0
	i32.store	$discard=, res+4($pop172), $1
	i32.const	$push171=, 0
	i32.store	$push32=, res($pop171):p2align=4, $0
	i32.const	$push35=, 15
	i32.const	$push34=, 7
	i32.const	$push170=, 7
	i32.const	$push33=, 6
	call    	verify@FUNCTION, $pop32, $1, $2, $5, $pop35, $pop34, $pop170, $pop33
	i32.const	$push169=, 0
	i32.load	$0=, i+8($pop169):p2align=3
	i32.const	$push168=, 0
	i32.load	$1=, i+4($pop168)
	i32.const	$push167=, 0
	i32.load	$2=, i($pop167):p2align=4
	i32.const	$push166=, 0
	i32.load	$5=, j($pop166):p2align=4
	i32.const	$push165=, 0
	i32.load	$4=, j+4($pop165)
	i32.const	$push164=, 0
	i32.load	$3=, j+8($pop164):p2align=3
	i32.const	$push163=, 0
	i32.const	$push162=, 0
	i32.load	$push37=, j+12($pop162)
	i32.const	$push161=, 0
	i32.load	$push36=, i+12($pop161)
	i32.and 	$push41=, $pop37, $pop36
	i32.store	$6=, k+12($pop163), $pop41
	i32.const	$push160=, 0
	i32.and 	$push40=, $3, $0
	i32.store	$0=, k+8($pop160):p2align=3, $pop40
	i32.const	$push159=, 0
	i32.and 	$push39=, $4, $1
	i32.store	$1=, k+4($pop159), $pop39
	i32.const	$push158=, 0
	i32.and 	$push38=, $5, $2
	i32.store	$2=, k($pop158):p2align=4, $pop38
	i32.const	$push157=, 0
	i32.store	$5=, res+12($pop157), $6
	i32.const	$push156=, 0
	i32.store	$discard=, res+8($pop156):p2align=3, $0
	i32.const	$push155=, 0
	i32.store	$discard=, res+4($pop155), $1
	i32.const	$push154=, 0
	i32.store	$push42=, res($pop154):p2align=4, $2
	i32.const	$push46=, 2
	i32.const	$push45=, 4
	i32.const	$push44=, 20
	i32.const	$push43=, 8
	call    	verify@FUNCTION, $pop42, $1, $0, $5, $pop46, $pop45, $pop44, $pop43
	i32.const	$push153=, 0
	i32.load	$0=, i+8($pop153):p2align=3
	i32.const	$push152=, 0
	i32.load	$1=, i+4($pop152)
	i32.const	$push151=, 0
	i32.load	$2=, i($pop151):p2align=4
	i32.const	$push150=, 0
	i32.load	$5=, j($pop150):p2align=4
	i32.const	$push149=, 0
	i32.load	$4=, j+4($pop149)
	i32.const	$push148=, 0
	i32.load	$3=, j+8($pop148):p2align=3
	i32.const	$push147=, 0
	i32.const	$push146=, 0
	i32.load	$push48=, j+12($pop146)
	i32.const	$push145=, 0
	i32.load	$push47=, i+12($pop145)
	i32.or  	$push52=, $pop48, $pop47
	i32.store	$6=, k+12($pop147), $pop52
	i32.const	$push144=, 0
	i32.or  	$push51=, $3, $0
	i32.store	$0=, k+8($pop144):p2align=3, $pop51
	i32.const	$push143=, 0
	i32.or  	$push50=, $4, $1
	i32.store	$1=, k+4($pop143), $pop50
	i32.const	$push142=, 0
	i32.or  	$push49=, $5, $2
	i32.store	$2=, k($pop142):p2align=4, $pop49
	i32.const	$push141=, 0
	i32.store	$5=, res+12($pop141), $6
	i32.const	$push140=, 0
	i32.store	$discard=, res+8($pop140):p2align=3, $0
	i32.const	$push139=, 0
	i32.store	$discard=, res+4($pop139), $1
	i32.const	$push138=, 0
	i32.store	$push53=, res($pop138):p2align=4, $2
	i32.const	$push57=, 158
	i32.const	$push56=, 109
	i32.const	$push55=, 150
	i32.const	$push54=, 222
	call    	verify@FUNCTION, $pop53, $1, $0, $5, $pop57, $pop56, $pop55, $pop54
	i32.const	$push137=, 0
	i32.load	$0=, i+8($pop137):p2align=3
	i32.const	$push136=, 0
	i32.load	$1=, i+4($pop136)
	i32.const	$push135=, 0
	i32.load	$2=, i($pop135):p2align=4
	i32.const	$push134=, 0
	i32.load	$5=, j($pop134):p2align=4
	i32.const	$push133=, 0
	i32.load	$4=, j+4($pop133)
	i32.const	$push132=, 0
	i32.load	$3=, j+8($pop132):p2align=3
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.load	$push58=, i+12($pop130)
	i32.const	$push129=, 0
	i32.load	$push59=, j+12($pop129)
	i32.xor 	$push63=, $pop58, $pop59
	i32.store	$6=, k+12($pop131), $pop63
	i32.const	$push128=, 0
	i32.xor 	$push62=, $0, $3
	i32.store	$0=, k+8($pop128):p2align=3, $pop62
	i32.const	$push127=, 0
	i32.xor 	$push61=, $1, $4
	i32.store	$1=, k+4($pop127), $pop61
	i32.const	$push126=, 0
	i32.xor 	$push60=, $2, $5
	i32.store	$2=, k($pop126):p2align=4, $pop60
	i32.const	$push125=, 0
	i32.store	$5=, res+12($pop125), $6
	i32.const	$push124=, 0
	i32.store	$discard=, res+8($pop124):p2align=3, $0
	i32.const	$push123=, 0
	i32.store	$discard=, res+4($pop123), $1
	i32.const	$push122=, 0
	i32.store	$push64=, res($pop122):p2align=4, $2
	i32.const	$push68=, 156
	i32.const	$push67=, 105
	i32.const	$push66=, 130
	i32.const	$push65=, 214
	call    	verify@FUNCTION, $pop64, $1, $0, $5, $pop68, $pop67, $pop66, $pop65
	i32.const	$push121=, 0
	i32.load	$0=, i($pop121):p2align=4
	i32.const	$push120=, 0
	i32.load	$1=, i+4($pop120)
	i32.const	$push119=, 0
	i32.load	$2=, i+8($pop119):p2align=3
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.load	$push69=, i+12($pop116)
	i32.sub 	$push73=, $pop117, $pop69
	i32.store	$5=, k+12($pop118), $pop73
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.sub 	$push72=, $pop114, $2
	i32.store	$2=, k+8($pop115):p2align=3, $pop72
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i32.sub 	$push71=, $pop112, $1
	i32.store	$1=, k+4($pop113), $pop71
	i32.const	$push111=, 0
	i32.const	$push110=, 0
	i32.sub 	$push70=, $pop110, $0
	i32.store	$0=, k($pop111):p2align=4, $pop70
	i32.const	$push109=, 0
	i32.store	$discard=, res+12($pop109), $5
	i32.const	$push108=, 0
	i32.store	$discard=, res+8($pop108):p2align=3, $2
	i32.const	$push107=, 0
	i32.store	$discard=, res+4($pop107), $1
	i32.const	$push106=, 0
	i32.store	$push74=, res($pop106):p2align=4, $0
	i32.const	$push77=, -150
	i32.const	$push76=, -100
	i32.const	$push105=, -150
	i32.const	$push75=, -200
	call    	verify@FUNCTION, $pop74, $1, $2, $5, $pop77, $pop76, $pop105, $pop75
	i32.const	$push104=, 0
	i32.load	$0=, i($pop104):p2align=4
	i32.const	$push103=, 0
	i32.load	$1=, i+4($pop103)
	i32.const	$push102=, 0
	i32.load	$2=, i+8($pop102):p2align=3
	i32.const	$push101=, 0
	i32.const	$push100=, 0
	i32.load	$push78=, i+12($pop100)
	i32.const	$push79=, -1
	i32.xor 	$push83=, $pop78, $pop79
	i32.store	$5=, k+12($pop101), $pop83
	i32.const	$push99=, 0
	i32.const	$push98=, -1
	i32.xor 	$push82=, $2, $pop98
	i32.store	$2=, k+8($pop99):p2align=3, $pop82
	i32.const	$push97=, 0
	i32.const	$push96=, -1
	i32.xor 	$push81=, $1, $pop96
	i32.store	$1=, k+4($pop97), $pop81
	i32.const	$push95=, 0
	i32.const	$push94=, -1
	i32.xor 	$push80=, $0, $pop94
	i32.store	$0=, k($pop95):p2align=4, $pop80
	i32.const	$push93=, 0
	i32.store	$discard=, res+12($pop93), $5
	i32.const	$push92=, 0
	i32.store	$discard=, res+8($pop92):p2align=3, $2
	i32.const	$push91=, 0
	i32.store	$discard=, res+4($pop91), $1
	i32.const	$push90=, 0
	i32.store	$push84=, res($pop90):p2align=4, $0
	i32.const	$push87=, -151
	i32.const	$push86=, -101
	i32.const	$push89=, -151
	i32.const	$push85=, -201
	call    	verify@FUNCTION, $pop84, $1, $2, $5, $pop87, $pop86, $pop89, $pop85
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
