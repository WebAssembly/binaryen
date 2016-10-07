	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push54=, 0
	i32.const	$push51=, 0
	i32.load	$push52=, __stack_pointer($pop51)
	i32.const	$push53=, 320
	i32.sub 	$push218=, $pop52, $pop53
	tee_local	$push217=, $10=, $pop218
	i32.store	__stack_pointer($pop54), $pop217
	i32.const	$push55=, 304
	i32.add 	$push56=, $10, $pop55
	i32.const	$push216=, 0
	i64.load	$push215=, C($pop216)
	tee_local	$push214=, $5=, $pop215
	i32.const	$push213=, 0
	i64.load	$push212=, C+8($pop213)
	tee_local	$push211=, $4=, $pop212
	i32.const	$push210=, 0
	i64.load	$push209=, U($pop210)
	tee_local	$push208=, $1=, $pop209
	i32.const	$push207=, 0
	i64.load	$push206=, U+8($pop207)
	tee_local	$push205=, $0=, $pop206
	call    	__addtf3@FUNCTION, $pop56, $pop214, $pop211, $pop208, $pop205
	i32.const	$push57=, 240
	i32.add 	$push58=, $10, $pop57
	call    	__subtf3@FUNCTION, $pop58, $5, $4, $1, $0
	i32.const	$push61=, 288
	i32.add 	$push62=, $10, $pop61
	i64.load	$push204=, 304($10)
	tee_local	$push203=, $7=, $pop204
	i32.const	$push59=, 304
	i32.add 	$push60=, $10, $pop59
	i32.const	$push0=, 8
	i32.add 	$push1=, $pop60, $pop0
	i64.load	$push202=, 0($pop1)
	tee_local	$push201=, $6=, $pop202
	call    	__addtf3@FUNCTION, $pop62, $1, $0, $pop203, $pop201
	i32.const	$push65=, 224
	i32.add 	$push66=, $10, $pop65
	i64.load	$push200=, 240($10)
	tee_local	$push199=, $9=, $pop200
	i32.const	$push63=, 240
	i32.add 	$push64=, $10, $pop63
	i32.const	$push198=, 8
	i32.add 	$push2=, $pop64, $pop198
	i64.load	$push197=, 0($pop2)
	tee_local	$push196=, $8=, $pop197
	call    	__subtf3@FUNCTION, $pop66, $pop199, $pop196, $1, $0
	i32.const	$push69=, 272
	i32.add 	$push70=, $10, $pop69
	i64.load	$push195=, 288($10)
	tee_local	$push194=, $3=, $pop195
	i32.const	$push67=, 288
	i32.add 	$push68=, $10, $pop67
	i32.const	$push193=, 8
	i32.add 	$push3=, $pop68, $pop193
	i64.load	$push192=, 0($pop3)
	tee_local	$push191=, $2=, $pop192
	call    	__addtf3@FUNCTION, $pop70, $1, $0, $pop194, $pop191
	i32.const	$push71=, 128
	i32.add 	$push72=, $10, $pop71
	i32.const	$push190=, 0
	i64.load	$push189=, Y2($pop190)
	tee_local	$push188=, $5=, $pop189
	i32.const	$push187=, 0
	i64.load	$push186=, Y2+8($pop187)
	tee_local	$push185=, $4=, $pop186
	call    	__addtf3@FUNCTION, $pop72, $1, $0, $pop188, $pop185
	i32.const	$push73=, 192
	i32.add 	$push74=, $10, $pop73
	call    	__multf3@FUNCTION, $pop74, $7, $6, $5, $4
	i32.const	$push75=, 112
	i32.add 	$push76=, $10, $pop75
	i32.const	$push184=, 0
	i64.load	$push183=, Y1($pop184)
	tee_local	$push182=, $7=, $pop183
	i32.const	$push181=, 0
	i64.load	$push180=, Y1+8($pop181)
	tee_local	$push179=, $6=, $pop180
	call    	__multf3@FUNCTION, $pop76, $9, $8, $pop182, $pop179
	i32.const	$push79=, 80
	i32.add 	$push80=, $10, $pop79
	i64.load	$push178=, 224($10)
	tee_local	$push177=, $9=, $pop178
	i32.const	$push77=, 224
	i32.add 	$push78=, $10, $pop77
	i32.const	$push176=, 8
	i32.add 	$push4=, $pop78, $pop176
	i64.load	$push175=, 0($pop4)
	tee_local	$push174=, $8=, $pop175
	call    	__multf3@FUNCTION, $pop80, $7, $6, $pop177, $pop174
	i32.const	$push81=, 208
	i32.add 	$push82=, $10, $pop81
	call    	__subtf3@FUNCTION, $pop82, $1, $0, $9, $8
	i32.const	$push83=, 160
	i32.add 	$push84=, $10, $pop83
	call    	__multf3@FUNCTION, $pop84, $5, $4, $3, $2
	i32.const	$push87=, 256
	i32.add 	$push88=, $10, $pop87
	i64.load	$push173=, 272($10)
	tee_local	$push172=, $3=, $pop173
	i32.const	$push85=, 272
	i32.add 	$push86=, $10, $pop85
	i32.const	$push171=, 8
	i32.add 	$push5=, $pop86, $pop171
	i64.load	$push170=, 0($pop5)
	tee_local	$push169=, $2=, $pop170
	call    	__addtf3@FUNCTION, $pop88, $1, $0, $pop172, $pop169
	i32.const	$push91=, 48
	i32.add 	$push92=, $10, $pop91
	i64.load	$push8=, 128($10)
	i32.const	$push89=, 128
	i32.add 	$push90=, $10, $pop89
	i32.const	$push168=, 8
	i32.add 	$push6=, $pop90, $pop168
	i64.load	$push7=, 0($pop6)
	call    	__multf3@FUNCTION, $pop92, $pop8, $pop7, $7, $6
	i32.const	$push93=, 16
	i32.add 	$push94=, $10, $pop93
	call    	__multf3@FUNCTION, $pop94, $5, $4, $7, $6
	i32.const	$push97=, 176
	i32.add 	$push98=, $10, $pop97
	i64.load	$push11=, 192($10)
	i32.const	$push95=, 192
	i32.add 	$push96=, $10, $pop95
	i32.const	$push167=, 8
	i32.add 	$push9=, $pop96, $pop167
	i64.load	$push10=, 0($pop9)
	call    	__subtf3@FUNCTION, $pop98, $pop11, $pop10, $3, $2
	i32.const	$push101=, 96
	i32.add 	$push102=, $10, $pop101
	i64.load	$push14=, 112($10)
	i32.const	$push99=, 112
	i32.add 	$push100=, $10, $pop99
	i32.const	$push166=, 8
	i32.add 	$push12=, $pop100, $pop166
	i64.load	$push13=, 0($pop12)
	call    	__subtf3@FUNCTION, $pop102, $pop14, $pop13, $9, $8
	i32.const	$push107=, 64
	i32.add 	$push108=, $10, $pop107
	i64.load	$push20=, 208($10)
	i32.const	$push105=, 208
	i32.add 	$push106=, $10, $pop105
	i32.const	$push165=, 8
	i32.add 	$push17=, $pop106, $pop165
	i64.load	$push18=, 0($pop17)
	i64.load	$push19=, 80($10)
	i32.const	$push103=, 80
	i32.add 	$push104=, $10, $pop103
	i32.const	$push164=, 8
	i32.add 	$push15=, $pop104, $pop164
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $pop108, $pop20, $pop18, $pop19, $pop16
	i32.const	$push113=, 144
	i32.add 	$push114=, $10, $pop113
	i64.load	$push163=, 160($10)
	tee_local	$push162=, $1=, $pop163
	i32.const	$push109=, 160
	i32.add 	$push110=, $10, $pop109
	i32.const	$push161=, 8
	i32.add 	$push21=, $pop110, $pop161
	i64.load	$push160=, 0($pop21)
	tee_local	$push159=, $0=, $pop160
	i64.load	$push24=, 256($10)
	i32.const	$push111=, 256
	i32.add 	$push112=, $10, $pop111
	i32.const	$push158=, 8
	i32.add 	$push22=, $pop112, $pop158
	i64.load	$push23=, 0($pop22)
	call    	__subtf3@FUNCTION, $pop114, $pop162, $pop159, $pop24, $pop23
	i32.const	$push117=, 32
	i32.add 	$push118=, $10, $pop117
	i64.load	$push27=, 48($10)
	i32.const	$push115=, 48
	i32.add 	$push116=, $10, $pop115
	i32.const	$push157=, 8
	i32.add 	$push25=, $pop116, $pop157
	i64.load	$push26=, 0($pop25)
	call    	__subtf3@FUNCTION, $pop118, $pop27, $pop26, $5, $4
	i64.load	$push32=, 16($10)
	i32.const	$push119=, 16
	i32.add 	$push120=, $10, $pop119
	i32.const	$push156=, 8
	i32.add 	$push28=, $pop120, $pop156
	i64.load	$push29=, 0($pop28)
	i64.const	$push31=, 0
	i64.const	$push30=, -4612248968380809216
	call    	__addtf3@FUNCTION, $10, $pop32, $pop29, $pop31, $pop30
	i32.const	$push155=, 0
	i64.store	S+8($pop155), $0
	i32.const	$push154=, 0
	i64.store	S($pop154), $1
	i32.const	$push153=, 0
	i32.const	$push121=, 176
	i32.add 	$push122=, $10, $pop121
	i32.const	$push152=, 8
	i32.add 	$push33=, $pop122, $pop152
	i64.load	$push34=, 0($pop33)
	i64.store	X+8($pop153), $pop34
	i32.const	$push151=, 0
	i64.load	$push35=, 176($10)
	i64.store	X($pop151), $pop35
	i32.const	$push150=, 0
	i32.const	$push123=, 96
	i32.add 	$push124=, $10, $pop123
	i32.const	$push149=, 8
	i32.add 	$push36=, $pop124, $pop149
	i64.load	$push37=, 0($pop36)
	i64.store	T+8($pop150), $pop37
	i32.const	$push148=, 0
	i64.load	$push38=, 96($10)
	i64.store	T($pop148), $pop38
	i32.const	$push147=, 0
	i32.const	$push125=, 64
	i32.add 	$push126=, $10, $pop125
	i32.const	$push146=, 8
	i32.add 	$push39=, $pop126, $pop146
	i64.load	$push40=, 0($pop39)
	i64.store	Y+8($pop147), $pop40
	i32.const	$push145=, 0
	i64.load	$push41=, 64($10)
	i64.store	Y($pop145), $pop41
	i32.const	$push144=, 0
	i32.const	$push127=, 144
	i32.add 	$push128=, $10, $pop127
	i32.const	$push143=, 8
	i32.add 	$push42=, $pop128, $pop143
	i64.load	$push142=, 0($pop42)
	tee_local	$push141=, $1=, $pop142
	i64.store	Z+8($pop144), $pop141
	i32.const	$push140=, 0
	i64.load	$push139=, 144($10)
	tee_local	$push138=, $0=, $pop139
	i64.store	Z($pop140), $pop138
	i32.const	$push137=, 0
	i32.const	$push129=, 32
	i32.add 	$push130=, $10, $pop129
	i32.const	$push136=, 8
	i32.add 	$push43=, $pop130, $pop136
	i64.load	$push44=, 0($pop43)
	i64.store	R+8($pop137), $pop44
	i32.const	$push135=, 0
	i64.load	$push45=, 32($10)
	i64.store	R($pop135), $pop45
	i32.const	$push134=, 0
	i32.const	$push133=, 8
	i32.add 	$push46=, $10, $pop133
	i64.load	$push47=, 0($pop46)
	i64.store	Y1+8($pop134), $pop47
	i32.const	$push132=, 0
	i64.load	$push48=, 0($10)
	i64.store	Y1($pop132), $pop48
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
