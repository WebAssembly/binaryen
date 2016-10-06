	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-1.c"
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
	i32.const	$push0=, 0
	i32.const	$push280=, 0
	i32.load	$push2=, j+12($pop280)
	i32.const	$push279=, 0
	i32.load	$push1=, i+12($pop279)
	i32.add 	$push278=, $pop2, $pop1
	tee_local	$push277=, $0=, $pop278
	i32.store	k+12($pop0), $pop277
	i32.const	$push276=, 0
	i32.const	$push275=, 0
	i32.load	$push4=, j+8($pop275)
	i32.const	$push274=, 0
	i32.load	$push3=, i+8($pop274)
	i32.add 	$push273=, $pop4, $pop3
	tee_local	$push272=, $1=, $pop273
	i32.store	k+8($pop276), $pop272
	i32.const	$push271=, 0
	i32.const	$push270=, 0
	i32.load	$push6=, j+4($pop270)
	i32.const	$push269=, 0
	i32.load	$push5=, i+4($pop269)
	i32.add 	$push268=, $pop6, $pop5
	tee_local	$push267=, $2=, $pop268
	i32.store	k+4($pop271), $pop267
	i32.const	$push266=, 0
	i32.const	$push265=, 0
	i32.load	$push8=, j($pop265)
	i32.const	$push264=, 0
	i32.load	$push7=, i($pop264)
	i32.add 	$push263=, $pop8, $pop7
	tee_local	$push262=, $3=, $pop263
	i32.store	k($pop266), $pop262
	i32.const	$push261=, 0
	i32.store	res+12($pop261), $0
	i32.const	$push260=, 0
	i32.store	res+8($pop260), $1
	i32.const	$push259=, 0
	i32.store	res+4($pop259), $2
	i32.const	$push258=, 0
	i32.store	res($pop258), $3
	i32.const	$push12=, 160
	i32.const	$push11=, 113
	i32.const	$push10=, 170
	i32.const	$push9=, 230
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop12, $pop11, $pop10, $pop9
	i32.const	$push257=, 0
	i32.const	$push256=, 0
	i32.load	$push14=, j+12($pop256)
	i32.const	$push255=, 0
	i32.load	$push13=, i+12($pop255)
	i32.mul 	$push254=, $pop14, $pop13
	tee_local	$push253=, $0=, $pop254
	i32.store	k+12($pop257), $pop253
	i32.const	$push252=, 0
	i32.const	$push251=, 0
	i32.load	$push16=, j+8($pop251)
	i32.const	$push250=, 0
	i32.load	$push15=, i+8($pop250)
	i32.mul 	$push249=, $pop16, $pop15
	tee_local	$push248=, $1=, $pop249
	i32.store	k+8($pop252), $pop248
	i32.const	$push247=, 0
	i32.const	$push246=, 0
	i32.load	$push18=, j+4($pop246)
	i32.const	$push245=, 0
	i32.load	$push17=, i+4($pop245)
	i32.mul 	$push244=, $pop18, $pop17
	tee_local	$push243=, $2=, $pop244
	i32.store	k+4($pop247), $pop243
	i32.const	$push242=, 0
	i32.const	$push241=, 0
	i32.load	$push20=, j($pop241)
	i32.const	$push240=, 0
	i32.load	$push19=, i($pop240)
	i32.mul 	$push239=, $pop20, $pop19
	tee_local	$push238=, $3=, $pop239
	i32.store	k($pop242), $pop238
	i32.const	$push237=, 0
	i32.store	res+12($pop237), $0
	i32.const	$push236=, 0
	i32.store	res+8($pop236), $1
	i32.const	$push235=, 0
	i32.store	res+4($pop235), $2
	i32.const	$push234=, 0
	i32.store	res($pop234), $3
	i32.const	$push24=, 1500
	i32.const	$push23=, 1300
	i32.const	$push22=, 3000
	i32.const	$push21=, 6000
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop24, $pop23, $pop22, $pop21
	i32.const	$push233=, 0
	i32.const	$push232=, 0
	i32.load	$push26=, i+12($pop232)
	i32.const	$push231=, 0
	i32.load	$push25=, j+12($pop231)
	i32.div_s	$push230=, $pop26, $pop25
	tee_local	$push229=, $0=, $pop230
	i32.store	k+12($pop233), $pop229
	i32.const	$push228=, 0
	i32.const	$push227=, 0
	i32.load	$push28=, i+8($pop227)
	i32.const	$push226=, 0
	i32.load	$push27=, j+8($pop226)
	i32.div_s	$push225=, $pop28, $pop27
	tee_local	$push224=, $1=, $pop225
	i32.store	k+8($pop228), $pop224
	i32.const	$push223=, 0
	i32.const	$push222=, 0
	i32.load	$push30=, i+4($pop222)
	i32.const	$push221=, 0
	i32.load	$push29=, j+4($pop221)
	i32.div_s	$push220=, $pop30, $pop29
	tee_local	$push219=, $2=, $pop220
	i32.store	k+4($pop223), $pop219
	i32.const	$push218=, 0
	i32.const	$push217=, 0
	i32.load	$push32=, i($pop217)
	i32.const	$push216=, 0
	i32.load	$push31=, j($pop216)
	i32.div_s	$push215=, $pop32, $pop31
	tee_local	$push214=, $3=, $pop215
	i32.store	k($pop218), $pop214
	i32.const	$push213=, 0
	i32.store	res+12($pop213), $0
	i32.const	$push212=, 0
	i32.store	res+8($pop212), $1
	i32.const	$push211=, 0
	i32.store	res+4($pop211), $2
	i32.const	$push210=, 0
	i32.store	res($pop210), $3
	i32.const	$push35=, 15
	i32.const	$push34=, 7
	i32.const	$push209=, 7
	i32.const	$push33=, 6
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop35, $pop34, $pop209, $pop33
	i32.const	$push208=, 0
	i32.const	$push207=, 0
	i32.load	$push37=, j+12($pop207)
	i32.const	$push206=, 0
	i32.load	$push36=, i+12($pop206)
	i32.and 	$push205=, $pop37, $pop36
	tee_local	$push204=, $0=, $pop205
	i32.store	k+12($pop208), $pop204
	i32.const	$push203=, 0
	i32.const	$push202=, 0
	i32.load	$push39=, j+8($pop202)
	i32.const	$push201=, 0
	i32.load	$push38=, i+8($pop201)
	i32.and 	$push200=, $pop39, $pop38
	tee_local	$push199=, $1=, $pop200
	i32.store	k+8($pop203), $pop199
	i32.const	$push198=, 0
	i32.const	$push197=, 0
	i32.load	$push41=, j+4($pop197)
	i32.const	$push196=, 0
	i32.load	$push40=, i+4($pop196)
	i32.and 	$push195=, $pop41, $pop40
	tee_local	$push194=, $2=, $pop195
	i32.store	k+4($pop198), $pop194
	i32.const	$push193=, 0
	i32.const	$push192=, 0
	i32.load	$push43=, j($pop192)
	i32.const	$push191=, 0
	i32.load	$push42=, i($pop191)
	i32.and 	$push190=, $pop43, $pop42
	tee_local	$push189=, $3=, $pop190
	i32.store	k($pop193), $pop189
	i32.const	$push188=, 0
	i32.store	res+12($pop188), $0
	i32.const	$push187=, 0
	i32.store	res+8($pop187), $1
	i32.const	$push186=, 0
	i32.store	res+4($pop186), $2
	i32.const	$push185=, 0
	i32.store	res($pop185), $3
	i32.const	$push47=, 2
	i32.const	$push46=, 4
	i32.const	$push45=, 20
	i32.const	$push44=, 8
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop47, $pop46, $pop45, $pop44
	i32.const	$push184=, 0
	i32.const	$push183=, 0
	i32.load	$push49=, j+12($pop183)
	i32.const	$push182=, 0
	i32.load	$push48=, i+12($pop182)
	i32.or  	$push181=, $pop49, $pop48
	tee_local	$push180=, $0=, $pop181
	i32.store	k+12($pop184), $pop180
	i32.const	$push179=, 0
	i32.const	$push178=, 0
	i32.load	$push51=, j+8($pop178)
	i32.const	$push177=, 0
	i32.load	$push50=, i+8($pop177)
	i32.or  	$push176=, $pop51, $pop50
	tee_local	$push175=, $1=, $pop176
	i32.store	k+8($pop179), $pop175
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.load	$push53=, j+4($pop173)
	i32.const	$push172=, 0
	i32.load	$push52=, i+4($pop172)
	i32.or  	$push171=, $pop53, $pop52
	tee_local	$push170=, $2=, $pop171
	i32.store	k+4($pop174), $pop170
	i32.const	$push169=, 0
	i32.const	$push168=, 0
	i32.load	$push55=, j($pop168)
	i32.const	$push167=, 0
	i32.load	$push54=, i($pop167)
	i32.or  	$push166=, $pop55, $pop54
	tee_local	$push165=, $3=, $pop166
	i32.store	k($pop169), $pop165
	i32.const	$push164=, 0
	i32.store	res+12($pop164), $0
	i32.const	$push163=, 0
	i32.store	res+8($pop163), $1
	i32.const	$push162=, 0
	i32.store	res+4($pop162), $2
	i32.const	$push161=, 0
	i32.store	res($pop161), $3
	i32.const	$push59=, 158
	i32.const	$push58=, 109
	i32.const	$push57=, 150
	i32.const	$push56=, 222
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop59, $pop58, $pop57, $pop56
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.load	$push61=, i+12($pop159)
	i32.const	$push158=, 0
	i32.load	$push60=, j+12($pop158)
	i32.xor 	$push157=, $pop61, $pop60
	tee_local	$push156=, $0=, $pop157
	i32.store	k+12($pop160), $pop156
	i32.const	$push155=, 0
	i32.const	$push154=, 0
	i32.load	$push63=, i+8($pop154)
	i32.const	$push153=, 0
	i32.load	$push62=, j+8($pop153)
	i32.xor 	$push152=, $pop63, $pop62
	tee_local	$push151=, $1=, $pop152
	i32.store	k+8($pop155), $pop151
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push65=, i+4($pop149)
	i32.const	$push148=, 0
	i32.load	$push64=, j+4($pop148)
	i32.xor 	$push147=, $pop65, $pop64
	tee_local	$push146=, $2=, $pop147
	i32.store	k+4($pop150), $pop146
	i32.const	$push145=, 0
	i32.const	$push144=, 0
	i32.load	$push67=, i($pop144)
	i32.const	$push143=, 0
	i32.load	$push66=, j($pop143)
	i32.xor 	$push142=, $pop67, $pop66
	tee_local	$push141=, $3=, $pop142
	i32.store	k($pop145), $pop141
	i32.const	$push140=, 0
	i32.store	res+12($pop140), $0
	i32.const	$push139=, 0
	i32.store	res+8($pop139), $1
	i32.const	$push138=, 0
	i32.store	res+4($pop138), $2
	i32.const	$push137=, 0
	i32.store	res($pop137), $3
	i32.const	$push71=, 156
	i32.const	$push70=, 105
	i32.const	$push69=, 130
	i32.const	$push68=, 214
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop71, $pop70, $pop69, $pop68
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.const	$push134=, 0
	i32.load	$push72=, i+12($pop134)
	i32.sub 	$push133=, $pop135, $pop72
	tee_local	$push132=, $0=, $pop133
	i32.store	k+12($pop136), $pop132
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.load	$push73=, i+8($pop129)
	i32.sub 	$push128=, $pop130, $pop73
	tee_local	$push127=, $1=, $pop128
	i32.store	k+8($pop131), $pop127
	i32.const	$push126=, 0
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.load	$push74=, i+4($pop124)
	i32.sub 	$push123=, $pop125, $pop74
	tee_local	$push122=, $2=, $pop123
	i32.store	k+4($pop126), $pop122
	i32.const	$push121=, 0
	i32.const	$push120=, 0
	i32.const	$push119=, 0
	i32.load	$push75=, i($pop119)
	i32.sub 	$push118=, $pop120, $pop75
	tee_local	$push117=, $3=, $pop118
	i32.store	k($pop121), $pop117
	i32.const	$push116=, 0
	i32.store	res+12($pop116), $0
	i32.const	$push115=, 0
	i32.store	res+8($pop115), $1
	i32.const	$push114=, 0
	i32.store	res+4($pop114), $2
	i32.const	$push113=, 0
	i32.store	res($pop113), $3
	i32.const	$push78=, -150
	i32.const	$push77=, -100
	i32.const	$push112=, -150
	i32.const	$push76=, -200
	call    	verify@FUNCTION, $3, $2, $1, $0, $pop78, $pop77, $pop112, $pop76
	i32.const	$push111=, 0
	i32.const	$push110=, 0
	i32.load	$push79=, i+12($pop110)
	i32.const	$push80=, -1
	i32.xor 	$push109=, $pop79, $pop80
	tee_local	$push108=, $0=, $pop109
	i32.store	k+12($pop111), $pop108
	i32.const	$push107=, 0
	i32.const	$push106=, 0
	i32.load	$push81=, i+8($pop106)
	i32.const	$push105=, -1
	i32.xor 	$push104=, $pop81, $pop105
	tee_local	$push103=, $1=, $pop104
	i32.store	k+8($pop107), $pop103
	i32.const	$push102=, 0
	i32.const	$push101=, 0
	i32.load	$push82=, i+4($pop101)
	i32.const	$push100=, -1
	i32.xor 	$push99=, $pop82, $pop100
	tee_local	$push98=, $2=, $pop99
	i32.store	k+4($pop102), $pop98
	i32.const	$push97=, 0
	i32.const	$push96=, 0
	i32.load	$push83=, i($pop96)
	i32.const	$push95=, -1
	i32.xor 	$push94=, $pop83, $pop95
	tee_local	$push93=, $3=, $pop94
	i32.store	k($pop97), $pop93
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
