	.text
	.file	"960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push54=, 0
	i32.const	$push52=, 0
	i32.load	$push51=, __stack_pointer($pop52)
	i32.const	$push53=, 320
	i32.sub 	$push218=, $pop51, $pop53
	tee_local	$push217=, $12=, $pop218
	i32.store	__stack_pointer($pop54), $pop217
	i32.const	$push55=, 304
	i32.add 	$push56=, $12, $pop55
	i32.const	$push216=, 0
	i64.load	$push215=, C($pop216)
	tee_local	$push214=, $3=, $pop215
	i32.const	$push213=, 0
	i64.load	$push212=, C+8($pop213)
	tee_local	$push211=, $2=, $pop212
	i32.const	$push210=, 0
	i64.load	$push209=, U($pop210)
	tee_local	$push208=, $1=, $pop209
	i32.const	$push207=, 0
	i64.load	$push206=, U+8($pop207)
	tee_local	$push205=, $0=, $pop206
	call    	__addtf3@FUNCTION, $pop56, $pop214, $pop211, $pop208, $pop205
	i32.const	$push57=, 240
	i32.add 	$push58=, $12, $pop57
	call    	__subtf3@FUNCTION, $pop58, $3, $2, $1, $0
	i32.const	$push61=, 288
	i32.add 	$push62=, $12, $pop61
	i64.load	$push204=, 304($12)
	tee_local	$push203=, $11=, $pop204
	i32.const	$push59=, 304
	i32.add 	$push60=, $12, $pop59
	i32.const	$push0=, 8
	i32.add 	$push1=, $pop60, $pop0
	i64.load	$push202=, 0($pop1)
	tee_local	$push201=, $10=, $pop202
	call    	__addtf3@FUNCTION, $pop62, $1, $0, $pop203, $pop201
	i32.const	$push63=, 128
	i32.add 	$push64=, $12, $pop63
	i32.const	$push200=, 0
	i64.load	$push199=, Y2($pop200)
	tee_local	$push198=, $3=, $pop199
	i32.const	$push197=, 0
	i64.load	$push196=, Y2+8($pop197)
	tee_local	$push195=, $2=, $pop196
	call    	__addtf3@FUNCTION, $pop64, $1, $0, $pop198, $pop195
	i32.const	$push67=, 224
	i32.add 	$push68=, $12, $pop67
	i64.load	$push194=, 240($12)
	tee_local	$push193=, $5=, $pop194
	i32.const	$push65=, 240
	i32.add 	$push66=, $12, $pop65
	i32.const	$push192=, 8
	i32.add 	$push2=, $pop66, $pop192
	i64.load	$push191=, 0($pop2)
	tee_local	$push190=, $4=, $pop191
	call    	__subtf3@FUNCTION, $pop68, $pop193, $pop190, $1, $0
	i32.const	$push71=, 272
	i32.add 	$push72=, $12, $pop71
	i64.load	$push189=, 288($12)
	tee_local	$push188=, $7=, $pop189
	i32.const	$push69=, 288
	i32.add 	$push70=, $12, $pop69
	i32.const	$push187=, 8
	i32.add 	$push3=, $pop70, $pop187
	i64.load	$push186=, 0($pop3)
	tee_local	$push185=, $6=, $pop186
	call    	__addtf3@FUNCTION, $pop72, $1, $0, $pop188, $pop185
	i32.const	$push73=, 16
	i32.add 	$push74=, $12, $pop73
	i32.const	$push184=, 0
	i64.load	$push183=, Y1($pop184)
	tee_local	$push182=, $9=, $pop183
	i32.const	$push181=, 0
	i64.load	$push180=, Y1+8($pop181)
	tee_local	$push179=, $8=, $pop180
	call    	__multf3@FUNCTION, $pop74, $3, $2, $pop182, $pop179
	i32.const	$push75=, 112
	i32.add 	$push76=, $12, $pop75
	call    	__multf3@FUNCTION, $pop76, $5, $4, $9, $8
	i32.const	$push79=, 48
	i32.add 	$push80=, $12, $pop79
	i64.load	$push6=, 128($12)
	i32.const	$push77=, 128
	i32.add 	$push78=, $12, $pop77
	i32.const	$push178=, 8
	i32.add 	$push4=, $pop78, $pop178
	i64.load	$push5=, 0($pop4)
	call    	__multf3@FUNCTION, $pop80, $pop6, $pop5, $9, $8
	i32.const	$push81=, 192
	i32.add 	$push82=, $12, $pop81
	call    	__multf3@FUNCTION, $pop82, $11, $10, $3, $2
	i32.const	$push85=, 80
	i32.add 	$push86=, $12, $pop85
	i64.load	$push177=, 224($12)
	tee_local	$push176=, $11=, $pop177
	i32.const	$push83=, 224
	i32.add 	$push84=, $12, $pop83
	i32.const	$push175=, 8
	i32.add 	$push7=, $pop84, $pop175
	i64.load	$push174=, 0($pop7)
	tee_local	$push173=, $10=, $pop174
	call    	__multf3@FUNCTION, $pop86, $pop176, $pop173, $9, $8
	i32.const	$push87=, 208
	i32.add 	$push88=, $12, $pop87
	call    	__subtf3@FUNCTION, $pop88, $1, $0, $11, $10
	i32.const	$push89=, 160
	i32.add 	$push90=, $12, $pop89
	call    	__multf3@FUNCTION, $pop90, $3, $2, $7, $6
	i32.const	$push93=, 256
	i32.add 	$push94=, $12, $pop93
	i64.load	$push172=, 272($12)
	tee_local	$push171=, $9=, $pop172
	i32.const	$push91=, 272
	i32.add 	$push92=, $12, $pop91
	i32.const	$push170=, 8
	i32.add 	$push8=, $pop92, $pop170
	i64.load	$push169=, 0($pop8)
	tee_local	$push168=, $8=, $pop169
	call    	__addtf3@FUNCTION, $pop94, $1, $0, $pop171, $pop168
	i64.load	$push13=, 16($12)
	i32.const	$push95=, 16
	i32.add 	$push96=, $12, $pop95
	i32.const	$push167=, 8
	i32.add 	$push9=, $pop96, $pop167
	i64.load	$push10=, 0($pop9)
	i64.const	$push12=, 0
	i64.const	$push11=, -4612248968380809216
	call    	__addtf3@FUNCTION, $12, $pop13, $pop10, $pop12, $pop11
	i32.const	$push99=, 96
	i32.add 	$push100=, $12, $pop99
	i64.load	$push16=, 112($12)
	i32.const	$push97=, 112
	i32.add 	$push98=, $12, $pop97
	i32.const	$push166=, 8
	i32.add 	$push14=, $pop98, $pop166
	i64.load	$push15=, 0($pop14)
	call    	__subtf3@FUNCTION, $pop100, $pop16, $pop15, $11, $10
	i32.const	$push103=, 32
	i32.add 	$push104=, $12, $pop103
	i64.load	$push19=, 48($12)
	i32.const	$push101=, 48
	i32.add 	$push102=, $12, $pop101
	i32.const	$push165=, 8
	i32.add 	$push17=, $pop102, $pop165
	i64.load	$push18=, 0($pop17)
	call    	__subtf3@FUNCTION, $pop104, $pop19, $pop18, $3, $2
	i32.const	$push107=, 176
	i32.add 	$push108=, $12, $pop107
	i64.load	$push22=, 192($12)
	i32.const	$push105=, 192
	i32.add 	$push106=, $12, $pop105
	i32.const	$push164=, 8
	i32.add 	$push20=, $pop106, $pop164
	i64.load	$push21=, 0($pop20)
	call    	__subtf3@FUNCTION, $pop108, $pop22, $pop21, $9, $8
	i32.const	$push113=, 64
	i32.add 	$push114=, $12, $pop113
	i64.load	$push28=, 208($12)
	i32.const	$push111=, 208
	i32.add 	$push112=, $12, $pop111
	i32.const	$push163=, 8
	i32.add 	$push25=, $pop112, $pop163
	i64.load	$push26=, 0($pop25)
	i64.load	$push27=, 80($12)
	i32.const	$push109=, 80
	i32.add 	$push110=, $12, $pop109
	i32.const	$push162=, 8
	i32.add 	$push23=, $pop110, $pop162
	i64.load	$push24=, 0($pop23)
	call    	__addtf3@FUNCTION, $pop114, $pop28, $pop26, $pop27, $pop24
	i32.const	$push119=, 144
	i32.add 	$push120=, $12, $pop119
	i64.load	$push161=, 160($12)
	tee_local	$push160=, $1=, $pop161
	i32.const	$push115=, 160
	i32.add 	$push116=, $12, $pop115
	i32.const	$push159=, 8
	i32.add 	$push29=, $pop116, $pop159
	i64.load	$push158=, 0($pop29)
	tee_local	$push157=, $0=, $pop158
	i64.load	$push32=, 256($12)
	i32.const	$push117=, 256
	i32.add 	$push118=, $12, $pop117
	i32.const	$push156=, 8
	i32.add 	$push30=, $pop118, $pop156
	i64.load	$push31=, 0($pop30)
	call    	__subtf3@FUNCTION, $pop120, $pop160, $pop157, $pop32, $pop31
	i32.const	$push155=, 0
	i32.const	$push154=, 8
	i32.add 	$push33=, $12, $pop154
	i64.load	$push34=, 0($pop33)
	i64.store	Y1+8($pop155), $pop34
	i32.const	$push153=, 0
	i64.load	$push35=, 0($12)
	i64.store	Y1($pop153), $pop35
	i32.const	$push152=, 0
	i64.store	S+8($pop152), $0
	i32.const	$push151=, 0
	i64.store	S($pop151), $1
	i32.const	$push150=, 0
	i32.const	$push121=, 96
	i32.add 	$push122=, $12, $pop121
	i32.const	$push149=, 8
	i32.add 	$push36=, $pop122, $pop149
	i64.load	$push37=, 0($pop36)
	i64.store	T+8($pop150), $pop37
	i32.const	$push148=, 0
	i64.load	$push38=, 96($12)
	i64.store	T($pop148), $pop38
	i32.const	$push147=, 0
	i32.const	$push123=, 32
	i32.add 	$push124=, $12, $pop123
	i32.const	$push146=, 8
	i32.add 	$push39=, $pop124, $pop146
	i64.load	$push40=, 0($pop39)
	i64.store	R+8($pop147), $pop40
	i32.const	$push145=, 0
	i64.load	$push41=, 32($12)
	i64.store	R($pop145), $pop41
	i32.const	$push144=, 0
	i32.const	$push125=, 176
	i32.add 	$push126=, $12, $pop125
	i32.const	$push143=, 8
	i32.add 	$push42=, $pop126, $pop143
	i64.load	$push43=, 0($pop42)
	i64.store	X+8($pop144), $pop43
	i32.const	$push142=, 0
	i64.load	$push44=, 176($12)
	i64.store	X($pop142), $pop44
	i32.const	$push141=, 0
	i32.const	$push127=, 64
	i32.add 	$push128=, $12, $pop127
	i32.const	$push140=, 8
	i32.add 	$push45=, $pop128, $pop140
	i64.load	$push46=, 0($pop45)
	i64.store	Y+8($pop141), $pop46
	i32.const	$push139=, 0
	i64.load	$push47=, 64($12)
	i64.store	Y($pop139), $pop47
	i32.const	$push138=, 0
	i32.const	$push129=, 144
	i32.add 	$push130=, $12, $pop129
	i32.const	$push137=, 8
	i32.add 	$push48=, $pop130, $pop137
	i64.load	$push136=, 0($pop48)
	tee_local	$push135=, $1=, $pop136
	i64.store	Z+8($pop138), $pop135
	i32.const	$push134=, 0
	i64.load	$push133=, 144($12)
	tee_local	$push132=, $0=, $pop133
	i64.store	Z($pop134), $pop132
	block   	
	i64.const	$push131=, 0
	i64.const	$push49=, 4612108230892453888
	i32.call	$push50=, __eqtf2@FUNCTION, $0, $1, $pop131, $pop49
	i32.eqz 	$push220=, $pop50
	br_if   	0, $pop220      # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push219=, 0
	call    	exit@FUNCTION, $pop219
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
	.int64	0                       # fp128 2
	.int64	4611686018427387904
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
	.int64	0                       # fp128 3
	.int64	4611826755915743232
	.size	Y2, 16

	.hidden	Y1                      # @Y1
	.type	Y1,@object
	.section	.data.Y1,"aw",@progbits
	.globl	Y1
	.p2align	4
Y1:
	.int64	0                       # fp128 1
	.int64	4611404543450677248
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
