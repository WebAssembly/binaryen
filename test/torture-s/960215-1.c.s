	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$push56=, 0
	i32.const	$push53=, 0
	i32.load	$push54=, __stack_pointer($pop53)
	i32.const	$push55=, 320
	i32.sub 	$push133=, $pop54, $pop55
	i32.store	$push217=, __stack_pointer($pop56), $pop133
	tee_local	$push216=, $0=, $pop217
	i32.const	$push57=, 304
	i32.add 	$push58=, $pop216, $pop57
	i32.const	$push215=, 0
	i64.load	$push214=, C($pop215)
	tee_local	$push213=, $6=, $pop214
	i32.const	$push212=, 0
	i64.load	$push211=, C+8($pop212)
	tee_local	$push210=, $5=, $pop211
	i32.const	$push209=, 0
	i64.load	$push208=, U($pop209)
	tee_local	$push207=, $2=, $pop208
	i32.const	$push206=, 0
	i64.load	$push205=, U+8($pop206)
	tee_local	$push204=, $1=, $pop205
	call    	__addtf3@FUNCTION, $pop58, $pop213, $pop210, $pop207, $pop204
	i32.const	$push59=, 240
	i32.add 	$push60=, $0, $pop59
	call    	__subtf3@FUNCTION, $pop60, $6, $5, $2, $1
	i32.const	$push63=, 288
	i32.add 	$push64=, $0, $pop63
	i64.load	$push203=, 304($0)
	tee_local	$push202=, $8=, $pop203
	i32.const	$push61=, 304
	i32.add 	$push62=, $0, $pop61
	i32.const	$push0=, 8
	i32.add 	$push1=, $pop62, $pop0
	i64.load	$push201=, 0($pop1)
	tee_local	$push200=, $7=, $pop201
	call    	__addtf3@FUNCTION, $pop64, $2, $1, $pop202, $pop200
	i32.const	$push67=, 224
	i32.add 	$push68=, $0, $pop67
	i64.load	$push199=, 240($0)
	tee_local	$push198=, $10=, $pop199
	i32.const	$push65=, 240
	i32.add 	$push66=, $0, $pop65
	i32.const	$push197=, 8
	i32.add 	$push2=, $pop66, $pop197
	i64.load	$push196=, 0($pop2)
	tee_local	$push195=, $9=, $pop196
	call    	__subtf3@FUNCTION, $pop68, $pop198, $pop195, $2, $1
	i32.const	$push71=, 272
	i32.add 	$push72=, $0, $pop71
	i64.load	$push194=, 288($0)
	tee_local	$push193=, $4=, $pop194
	i32.const	$push69=, 288
	i32.add 	$push70=, $0, $pop69
	i32.const	$push192=, 8
	i32.add 	$push3=, $pop70, $pop192
	i64.load	$push191=, 0($pop3)
	tee_local	$push190=, $3=, $pop191
	call    	__addtf3@FUNCTION, $pop72, $pop193, $pop190, $2, $1
	i32.const	$push73=, 128
	i32.add 	$push74=, $0, $pop73
	i32.const	$push189=, 0
	i64.load	$push188=, Y2($pop189)
	tee_local	$push187=, $6=, $pop188
	i32.const	$push186=, 0
	i64.load	$push185=, Y2+8($pop186)
	tee_local	$push184=, $5=, $pop185
	call    	__addtf3@FUNCTION, $pop74, $2, $1, $pop187, $pop184
	i32.const	$push75=, 192
	i32.add 	$push76=, $0, $pop75
	call    	__multf3@FUNCTION, $pop76, $8, $7, $6, $5
	i32.const	$push77=, 112
	i32.add 	$push78=, $0, $pop77
	i32.const	$push183=, 0
	i64.load	$push182=, Y1($pop183)
	tee_local	$push181=, $8=, $pop182
	i32.const	$push180=, 0
	i64.load	$push179=, Y1+8($pop180)
	tee_local	$push178=, $7=, $pop179
	call    	__multf3@FUNCTION, $pop78, $10, $9, $pop181, $pop178
	i32.const	$push81=, 80
	i32.add 	$push82=, $0, $pop81
	i64.load	$push177=, 224($0)
	tee_local	$push176=, $10=, $pop177
	i32.const	$push79=, 224
	i32.add 	$push80=, $0, $pop79
	i32.const	$push175=, 8
	i32.add 	$push4=, $pop80, $pop175
	i64.load	$push174=, 0($pop4)
	tee_local	$push173=, $9=, $pop174
	call    	__multf3@FUNCTION, $pop82, $pop176, $pop173, $8, $7
	i32.const	$push83=, 208
	i32.add 	$push84=, $0, $pop83
	call    	__subtf3@FUNCTION, $pop84, $2, $1, $10, $9
	i32.const	$push85=, 160
	i32.add 	$push86=, $0, $pop85
	call    	__multf3@FUNCTION, $pop86, $4, $3, $6, $5
	i32.const	$push89=, 256
	i32.add 	$push90=, $0, $pop89
	i64.load	$push172=, 272($0)
	tee_local	$push171=, $4=, $pop172
	i32.const	$push87=, 272
	i32.add 	$push88=, $0, $pop87
	i32.const	$push170=, 8
	i32.add 	$push5=, $pop88, $pop170
	i64.load	$push169=, 0($pop5)
	tee_local	$push168=, $3=, $pop169
	call    	__addtf3@FUNCTION, $pop90, $2, $1, $pop171, $pop168
	i32.const	$push93=, 48
	i32.add 	$push94=, $0, $pop93
	i64.load	$push8=, 128($0)
	i32.const	$push91=, 128
	i32.add 	$push92=, $0, $pop91
	i32.const	$push167=, 8
	i32.add 	$push6=, $pop92, $pop167
	i64.load	$push7=, 0($pop6)
	call    	__multf3@FUNCTION, $pop94, $pop8, $pop7, $8, $7
	i32.const	$push95=, 16
	i32.add 	$push96=, $0, $pop95
	call    	__multf3@FUNCTION, $pop96, $6, $5, $8, $7
	i32.const	$push99=, 176
	i32.add 	$push100=, $0, $pop99
	i64.load	$push11=, 192($0)
	i32.const	$push97=, 192
	i32.add 	$push98=, $0, $pop97
	i32.const	$push166=, 8
	i32.add 	$push9=, $pop98, $pop166
	i64.load	$push10=, 0($pop9)
	call    	__subtf3@FUNCTION, $pop100, $pop11, $pop10, $4, $3
	i32.const	$push103=, 96
	i32.add 	$push104=, $0, $pop103
	i64.load	$push14=, 112($0)
	i32.const	$push101=, 112
	i32.add 	$push102=, $0, $pop101
	i32.const	$push165=, 8
	i32.add 	$push12=, $pop102, $pop165
	i64.load	$push13=, 0($pop12)
	call    	__subtf3@FUNCTION, $pop104, $pop14, $pop13, $10, $9
	i32.const	$push109=, 64
	i32.add 	$push110=, $0, $pop109
	i64.load	$push20=, 208($0)
	i32.const	$push107=, 208
	i32.add 	$push108=, $0, $pop107
	i32.const	$push164=, 8
	i32.add 	$push17=, $pop108, $pop164
	i64.load	$push18=, 0($pop17)
	i64.load	$push19=, 80($0)
	i32.const	$push105=, 80
	i32.add 	$push106=, $0, $pop105
	i32.const	$push163=, 8
	i32.add 	$push15=, $pop106, $pop163
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $pop110, $pop20, $pop18, $pop19, $pop16
	i32.const	$push115=, 144
	i32.add 	$push116=, $0, $pop115
	i64.load	$push162=, 160($0)
	tee_local	$push161=, $2=, $pop162
	i32.const	$push111=, 160
	i32.add 	$push112=, $0, $pop111
	i32.const	$push160=, 8
	i32.add 	$push21=, $pop112, $pop160
	i64.load	$push159=, 0($pop21)
	tee_local	$push158=, $1=, $pop159
	i64.load	$push24=, 256($0)
	i32.const	$push113=, 256
	i32.add 	$push114=, $0, $pop113
	i32.const	$push157=, 8
	i32.add 	$push22=, $pop114, $pop157
	i64.load	$push23=, 0($pop22)
	call    	__subtf3@FUNCTION, $pop116, $pop161, $pop158, $pop24, $pop23
	i32.const	$push119=, 32
	i32.add 	$push120=, $0, $pop119
	i64.load	$push27=, 48($0)
	i32.const	$push117=, 48
	i32.add 	$push118=, $0, $pop117
	i32.const	$push156=, 8
	i32.add 	$push25=, $pop118, $pop156
	i64.load	$push26=, 0($pop25)
	call    	__subtf3@FUNCTION, $pop120, $pop27, $pop26, $6, $5
	i64.load	$push32=, 16($0)
	i32.const	$push121=, 16
	i32.add 	$push122=, $0, $pop121
	i32.const	$push155=, 8
	i32.add 	$push28=, $pop122, $pop155
	i64.load	$push29=, 0($pop28)
	i64.const	$push31=, 0
	i64.const	$push30=, -4612248968380809216
	call    	__addtf3@FUNCTION, $0, $pop32, $pop29, $pop31, $pop30
	i32.const	$push154=, 0
	i64.store	$drop=, S+8($pop154), $1
	i32.const	$push153=, 0
	i64.store	$drop=, S($pop153), $2
	i32.const	$push152=, 0
	i32.const	$push123=, 176
	i32.add 	$push124=, $0, $pop123
	i32.const	$push151=, 8
	i32.add 	$push33=, $pop124, $pop151
	i64.load	$push34=, 0($pop33)
	i64.store	$drop=, X+8($pop152), $pop34
	i32.const	$push150=, 0
	i64.load	$push35=, 176($0)
	i64.store	$drop=, X($pop150), $pop35
	i32.const	$push149=, 0
	i32.const	$push125=, 96
	i32.add 	$push126=, $0, $pop125
	i32.const	$push148=, 8
	i32.add 	$push36=, $pop126, $pop148
	i64.load	$push37=, 0($pop36)
	i64.store	$drop=, T+8($pop149), $pop37
	i32.const	$push147=, 0
	i64.load	$push38=, 96($0)
	i64.store	$drop=, T($pop147), $pop38
	i32.const	$push146=, 0
	i32.const	$push127=, 64
	i32.add 	$push128=, $0, $pop127
	i32.const	$push145=, 8
	i32.add 	$push39=, $pop128, $pop145
	i64.load	$push40=, 0($pop39)
	i64.store	$drop=, Y+8($pop146), $pop40
	i32.const	$push144=, 0
	i64.load	$push41=, 64($0)
	i64.store	$drop=, Y($pop144), $pop41
	i32.const	$push143=, 0
	i32.const	$push129=, 144
	i32.add 	$push130=, $0, $pop129
	i32.const	$push142=, 8
	i32.add 	$push42=, $pop130, $pop142
	i64.load	$push43=, 0($pop42)
	i64.store	$2=, Z+8($pop143), $pop43
	i32.const	$push141=, 0
	i64.load	$push44=, 144($0)
	i64.store	$1=, Z($pop141), $pop44
	i32.const	$push140=, 0
	i32.const	$push131=, 32
	i32.add 	$push132=, $0, $pop131
	i32.const	$push139=, 8
	i32.add 	$push45=, $pop132, $pop139
	i64.load	$push46=, 0($pop45)
	i64.store	$drop=, R+8($pop140), $pop46
	i32.const	$push138=, 0
	i64.load	$push47=, 32($0)
	i64.store	$drop=, R($pop138), $pop47
	i32.const	$push137=, 0
	i32.const	$push136=, 8
	i32.add 	$push48=, $0, $pop136
	i64.load	$push49=, 0($pop48)
	i64.store	$drop=, Y1+8($pop137), $pop49
	i32.const	$push135=, 0
	i64.load	$push50=, 0($0)
	i64.store	$drop=, Y1($pop135), $pop50
	block
	i64.const	$push134=, 0
	i64.const	$push51=, 4612108230892453888
	i32.call	$push52=, __eqtf2@FUNCTION, $1, $2, $pop134, $pop51
	i32.eqz 	$push219=, $pop52
	br_if   	0, $pop219      # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push218=, 0
	call    	exit@FUNCTION, $pop218
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
