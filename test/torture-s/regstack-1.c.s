	.text
	.file	"regstack-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push59=, 0
	i32.const	$push57=, 0
	i32.load	$push56=, __stack_pointer($pop57)
	i32.const	$push58=, 320
	i32.sub 	$push243=, $pop56, $pop58
	tee_local	$push242=, $16=, $pop243
	i32.store	__stack_pointer($pop59), $pop242
	i32.const	$push60=, 304
	i32.add 	$push61=, $16, $pop60
	i32.const	$push0=, 0
	i64.load	$push241=, C($pop0)
	tee_local	$push240=, $7=, $pop241
	i32.const	$push239=, 0
	i64.load	$push238=, C+8($pop239)
	tee_local	$push237=, $6=, $pop238
	i32.const	$push236=, 0
	i64.load	$push235=, U($pop236)
	tee_local	$push234=, $5=, $pop235
	i32.const	$push233=, 0
	i64.load	$push232=, U+8($pop233)
	tee_local	$push231=, $4=, $pop232
	call    	__addtf3@FUNCTION, $pop61, $pop240, $pop237, $pop234, $pop231
	i32.const	$push62=, 240
	i32.add 	$push63=, $16, $pop62
	call    	__subtf3@FUNCTION, $pop63, $7, $6, $5, $4
	i32.const	$push66=, 288
	i32.add 	$push67=, $16, $pop66
	i64.load	$push230=, 304($16)
	tee_local	$push229=, $15=, $pop230
	i32.const	$push64=, 304
	i32.add 	$push65=, $16, $pop64
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop65, $pop1
	i64.load	$push228=, 0($pop2)
	tee_local	$push227=, $14=, $pop228
	call    	__addtf3@FUNCTION, $pop67, $5, $4, $pop229, $pop227
	i32.const	$push68=, 128
	i32.add 	$push69=, $16, $pop68
	i32.const	$push226=, 0
	i64.load	$push225=, Y2($pop226)
	tee_local	$push224=, $7=, $pop225
	i32.const	$push223=, 0
	i64.load	$push222=, Y2+8($pop223)
	tee_local	$push221=, $6=, $pop222
	call    	__addtf3@FUNCTION, $pop69, $5, $4, $pop224, $pop221
	i32.const	$push72=, 224
	i32.add 	$push73=, $16, $pop72
	i64.load	$push220=, 240($16)
	tee_local	$push219=, $9=, $pop220
	i32.const	$push70=, 240
	i32.add 	$push71=, $16, $pop70
	i32.const	$push218=, 8
	i32.add 	$push3=, $pop71, $pop218
	i64.load	$push217=, 0($pop3)
	tee_local	$push216=, $8=, $pop217
	call    	__subtf3@FUNCTION, $pop73, $pop219, $pop216, $5, $4
	i32.const	$push76=, 272
	i32.add 	$push77=, $16, $pop76
	i64.load	$push215=, 288($16)
	tee_local	$push214=, $11=, $pop215
	i32.const	$push74=, 288
	i32.add 	$push75=, $16, $pop74
	i32.const	$push213=, 8
	i32.add 	$push4=, $pop75, $pop213
	i64.load	$push212=, 0($pop4)
	tee_local	$push211=, $10=, $pop212
	call    	__addtf3@FUNCTION, $pop77, $5, $4, $pop214, $pop211
	i32.const	$push78=, 16
	i32.add 	$push79=, $16, $pop78
	i32.const	$push210=, 0
	i64.load	$push209=, Y1($pop210)
	tee_local	$push208=, $13=, $pop209
	i32.const	$push207=, 0
	i64.load	$push206=, Y1+8($pop207)
	tee_local	$push205=, $12=, $pop206
	call    	__multf3@FUNCTION, $pop79, $7, $6, $pop208, $pop205
	i32.const	$push80=, 112
	i32.add 	$push81=, $16, $pop80
	call    	__multf3@FUNCTION, $pop81, $9, $8, $13, $12
	i32.const	$push84=, 48
	i32.add 	$push85=, $16, $pop84
	i64.load	$push7=, 128($16)
	i32.const	$push82=, 128
	i32.add 	$push83=, $16, $pop82
	i32.const	$push204=, 8
	i32.add 	$push5=, $pop83, $pop204
	i64.load	$push6=, 0($pop5)
	call    	__multf3@FUNCTION, $pop85, $pop7, $pop6, $13, $12
	i32.const	$push86=, 192
	i32.add 	$push87=, $16, $pop86
	call    	__multf3@FUNCTION, $pop87, $15, $14, $7, $6
	i32.const	$push90=, 80
	i32.add 	$push91=, $16, $pop90
	i64.load	$push203=, 224($16)
	tee_local	$push202=, $15=, $pop203
	i32.const	$push88=, 224
	i32.add 	$push89=, $16, $pop88
	i32.const	$push201=, 8
	i32.add 	$push8=, $pop89, $pop201
	i64.load	$push200=, 0($pop8)
	tee_local	$push199=, $14=, $pop200
	call    	__multf3@FUNCTION, $pop91, $pop202, $pop199, $13, $12
	i32.const	$push92=, 208
	i32.add 	$push93=, $16, $pop92
	call    	__subtf3@FUNCTION, $pop93, $5, $4, $15, $14
	i32.const	$push94=, 160
	i32.add 	$push95=, $16, $pop94
	call    	__multf3@FUNCTION, $pop95, $7, $6, $11, $10
	i32.const	$push98=, 256
	i32.add 	$push99=, $16, $pop98
	i64.load	$push198=, 272($16)
	tee_local	$push197=, $13=, $pop198
	i32.const	$push96=, 272
	i32.add 	$push97=, $16, $pop96
	i32.const	$push196=, 8
	i32.add 	$push9=, $pop97, $pop196
	i64.load	$push195=, 0($pop9)
	tee_local	$push194=, $12=, $pop195
	call    	__addtf3@FUNCTION, $pop99, $5, $4, $pop197, $pop194
	i64.load	$push13=, 16($16)
	i32.const	$push100=, 16
	i32.add 	$push101=, $16, $pop100
	i32.const	$push193=, 8
	i32.add 	$push10=, $pop101, $pop193
	i64.load	$push11=, 0($pop10)
	i64.const	$push192=, 0
	i64.const	$push12=, -4612248968380809216
	call    	__addtf3@FUNCTION, $16, $pop13, $pop11, $pop192, $pop12
	i32.const	$push104=, 96
	i32.add 	$push105=, $16, $pop104
	i64.load	$push16=, 112($16)
	i32.const	$push102=, 112
	i32.add 	$push103=, $16, $pop102
	i32.const	$push191=, 8
	i32.add 	$push14=, $pop103, $pop191
	i64.load	$push15=, 0($pop14)
	call    	__subtf3@FUNCTION, $pop105, $pop16, $pop15, $15, $14
	i32.const	$push108=, 32
	i32.add 	$push109=, $16, $pop108
	i64.load	$push19=, 48($16)
	i32.const	$push106=, 48
	i32.add 	$push107=, $16, $pop106
	i32.const	$push190=, 8
	i32.add 	$push17=, $pop107, $pop190
	i64.load	$push18=, 0($pop17)
	call    	__subtf3@FUNCTION, $pop109, $pop19, $pop18, $7, $6
	i32.const	$push112=, 176
	i32.add 	$push113=, $16, $pop112
	i64.load	$push22=, 192($16)
	i32.const	$push110=, 192
	i32.add 	$push111=, $16, $pop110
	i32.const	$push189=, 8
	i32.add 	$push20=, $pop111, $pop189
	i64.load	$push21=, 0($pop20)
	call    	__subtf3@FUNCTION, $pop113, $pop22, $pop21, $13, $12
	i32.const	$push118=, 64
	i32.add 	$push119=, $16, $pop118
	i64.load	$push28=, 208($16)
	i32.const	$push116=, 208
	i32.add 	$push117=, $16, $pop116
	i32.const	$push188=, 8
	i32.add 	$push25=, $pop117, $pop188
	i64.load	$push26=, 0($pop25)
	i64.load	$push27=, 80($16)
	i32.const	$push114=, 80
	i32.add 	$push115=, $16, $pop114
	i32.const	$push187=, 8
	i32.add 	$push23=, $pop115, $pop187
	i64.load	$push24=, 0($pop23)
	call    	__addtf3@FUNCTION, $pop119, $pop28, $pop26, $pop27, $pop24
	i32.const	$push124=, 144
	i32.add 	$push125=, $16, $pop124
	i64.load	$push186=, 160($16)
	tee_local	$push185=, $5=, $pop186
	i32.const	$push120=, 160
	i32.add 	$push121=, $16, $pop120
	i32.const	$push184=, 8
	i32.add 	$push29=, $pop121, $pop184
	i64.load	$push183=, 0($pop29)
	tee_local	$push182=, $4=, $pop183
	i64.load	$push32=, 256($16)
	i32.const	$push122=, 256
	i32.add 	$push123=, $16, $pop122
	i32.const	$push181=, 8
	i32.add 	$push30=, $pop123, $pop181
	i64.load	$push31=, 0($pop30)
	call    	__subtf3@FUNCTION, $pop125, $pop185, $pop182, $pop32, $pop31
	i32.const	$push180=, 0
	i32.const	$push179=, 8
	i32.add 	$push33=, $16, $pop179
	i64.load	$push178=, 0($pop33)
	tee_local	$push177=, $9=, $pop178
	i64.store	Y1+8($pop180), $pop177
	i32.const	$push176=, 0
	i64.load	$push175=, 0($16)
	tee_local	$push174=, $8=, $pop175
	i64.store	Y1($pop176), $pop174
	i32.const	$push173=, 0
	i64.store	S+8($pop173), $4
	i32.const	$push172=, 0
	i64.store	S($pop172), $5
	i32.const	$push171=, 0
	i32.const	$push126=, 96
	i32.add 	$push127=, $16, $pop126
	i32.const	$push170=, 8
	i32.add 	$push34=, $pop127, $pop170
	i64.load	$push169=, 0($pop34)
	tee_local	$push168=, $13=, $pop169
	i64.store	T+8($pop171), $pop168
	i32.const	$push167=, 0
	i64.load	$push166=, 96($16)
	tee_local	$push165=, $12=, $pop166
	i64.store	T($pop167), $pop165
	i32.const	$push164=, 0
	i32.const	$push128=, 32
	i32.add 	$push129=, $16, $pop128
	i32.const	$push163=, 8
	i32.add 	$push35=, $pop129, $pop163
	i64.load	$push162=, 0($pop35)
	tee_local	$push161=, $15=, $pop162
	i64.store	R+8($pop164), $pop161
	i32.const	$push160=, 0
	i64.load	$push159=, 32($16)
	tee_local	$push158=, $14=, $pop159
	i64.store	R($pop160), $pop158
	i32.const	$push157=, 0
	i32.const	$push130=, 176
	i32.add 	$push131=, $16, $pop130
	i32.const	$push156=, 8
	i32.add 	$push36=, $pop131, $pop156
	i64.load	$push155=, 0($pop36)
	tee_local	$push154=, $11=, $pop155
	i64.store	X+8($pop157), $pop154
	i32.const	$push153=, 0
	i64.load	$push152=, 176($16)
	tee_local	$push151=, $10=, $pop152
	i64.store	X($pop153), $pop151
	i32.const	$push150=, 0
	i32.const	$push132=, 64
	i32.add 	$push133=, $16, $pop132
	i32.const	$push149=, 8
	i32.add 	$push37=, $pop133, $pop149
	i64.load	$push148=, 0($pop37)
	tee_local	$push147=, $3=, $pop148
	i64.store	Y+8($pop150), $pop147
	i32.const	$push146=, 0
	i64.load	$push145=, 64($16)
	tee_local	$push144=, $2=, $pop145
	i64.store	Y($pop146), $pop144
	i32.const	$push143=, 0
	i32.const	$push134=, 144
	i32.add 	$push135=, $16, $pop134
	i32.const	$push142=, 8
	i32.add 	$push38=, $pop135, $pop142
	i64.load	$push141=, 0($pop38)
	tee_local	$push140=, $1=, $pop141
	i64.store	Z+8($pop143), $pop140
	i32.const	$push139=, 0
	i64.load	$push138=, 144($16)
	tee_local	$push137=, $0=, $pop138
	i64.store	Z($pop139), $pop137
	block   	
	i64.const	$push136=, 0
	i64.const	$push39=, 4612354521497075712
	i32.call	$push40=, __netf2@FUNCTION, $7, $6, $pop136, $pop39
	br_if   	0, $pop40       # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push244=, 0
	i64.const	$push41=, 4613097791357452288
	i32.call	$push42=, __netf2@FUNCTION, $12, $13, $pop244, $pop41
	br_if   	0, $pop42       # 0: down to label0
# BB#2:                                 # %entry
	i64.const	$push245=, 0
	i64.const	$push43=, 4613150567915585536
	i32.call	$push44=, __netf2@FUNCTION, $5, $4, $pop245, $pop43
	br_if   	0, $pop44       # 0: down to label0
# BB#3:                                 # %entry
	i64.const	$push246=, 0
	i64.const	$push45=, 4613517804799262720
	i32.call	$push46=, __netf2@FUNCTION, $14, $15, $pop246, $pop45
	br_if   	0, $pop46       # 0: down to label0
# BB#4:                                 # %entry
	i64.const	$push247=, 0
	i64.const	$push47=, 4613503511148101632
	i32.call	$push48=, __netf2@FUNCTION, $8, $9, $pop247, $pop47
	br_if   	0, $pop48       # 0: down to label0
# BB#5:                                 # %entry
	i64.const	$push248=, 0
	i64.const	$push49=, 4613040616752807936
	i32.call	$push50=, __netf2@FUNCTION, $10, $11, $pop248, $pop49
	br_if   	0, $pop50       # 0: down to label0
# BB#6:                                 # %entry
	i64.const	$push249=, 0
	i64.const	$push51=, 4613110985496985600
	i32.call	$push52=, __netf2@FUNCTION, $0, $1, $pop249, $pop51
	br_if   	0, $pop52       # 0: down to label0
# BB#7:                                 # %entry
	i64.const	$push250=, 0
	i64.const	$push53=, 4612961451915608064
	i32.call	$push54=, __eqtf2@FUNCTION, $2, $3, $pop250, $pop53
	br_if   	0, $pop54       # 0: down to label0
# BB#8:                                 # %if.end
	i32.const	$push55=, 0
	call    	exit@FUNCTION, $pop55
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	C                       # @C
	.type	C,@object
	.section	.data.C,"aw",@progbits
	.globl	C
	.p2align	4
C:
	.int64	0                       # fp128 5
	.int64	4612037862148276224
	.size	C, 16

	.hidden	U                       # @U
	.type	U,@object
	.section	.data.U,"aw",@progbits
	.globl	U
	.p2align	4
U:
	.int64	0                       # fp128 1
	.int64	4611404543450677248
	.size	U, 16

	.hidden	Y2                      # @Y2
	.type	Y2,@object
	.section	.data.Y2,"aw",@progbits
	.globl	Y2
	.p2align	4
Y2:
	.int64	0                       # fp128 11
	.int64	4612354521497075712
	.size	Y2, 16

	.hidden	Y1                      # @Y1
	.type	Y1,@object
	.section	.data.Y1,"aw",@progbits
	.globl	Y1
	.p2align	4
Y1:
	.int64	0                       # fp128 17
	.int64	4612548035543564288
	.size	Y1, 16

	.hidden	X                       # @X
	.type	X,@object
	.section	.bss.X,"aw",@nobits
	.globl	X
	.p2align	4
X:
	.int64	0                       # fp128 0
	.int64	0
	.size	X, 16

	.hidden	Y                       # @Y
	.type	Y,@object
	.section	.bss.Y,"aw",@nobits
	.globl	Y
	.p2align	4
Y:
	.int64	0                       # fp128 0
	.int64	0
	.size	Y, 16

	.hidden	Z                       # @Z
	.type	Z,@object
	.section	.bss.Z,"aw",@nobits
	.globl	Z
	.p2align	4
Z:
	.int64	0                       # fp128 0
	.int64	0
	.size	Z, 16

	.hidden	T                       # @T
	.type	T,@object
	.section	.bss.T,"aw",@nobits
	.globl	T
	.p2align	4
T:
	.int64	0                       # fp128 0
	.int64	0
	.size	T, 16

	.hidden	R                       # @R
	.type	R,@object
	.section	.bss.R,"aw",@nobits
	.globl	R
	.p2align	4
R:
	.int64	0                       # fp128 0
	.int64	0
	.size	R, 16

	.hidden	S                       # @S
	.type	S,@object
	.section	.bss.S,"aw",@nobits
	.globl	S
	.p2align	4
S:
	.int64	0                       # fp128 0
	.int64	0
	.size	S, 16


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
