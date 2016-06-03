	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/regstack-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$push71=, 0
	i32.const	$push68=, 0
	i32.load	$push69=, __stack_pointer($pop68)
	i32.const	$push70=, 320
	i32.sub 	$push148=, $pop69, $pop70
	i32.store	$push232=, __stack_pointer($pop71), $pop148
	tee_local	$push231=, $6=, $pop232
	i32.const	$push72=, 304
	i32.add 	$push73=, $pop231, $pop72
	i32.const	$push12=, 0
	i64.load	$push230=, C($pop12)
	tee_local	$push229=, $12=, $pop230
	i32.const	$push228=, 0
	i64.load	$push227=, C+8($pop228)
	tee_local	$push226=, $11=, $pop227
	i32.const	$push225=, 0
	i64.load	$push224=, U($pop225)
	tee_local	$push223=, $8=, $pop224
	i32.const	$push222=, 0
	i64.load	$push221=, U+8($pop222)
	tee_local	$push220=, $7=, $pop221
	call    	__addtf3@FUNCTION, $pop73, $pop229, $pop226, $pop223, $pop220
	i32.const	$push74=, 240
	i32.add 	$push75=, $6, $pop74
	call    	__subtf3@FUNCTION, $pop75, $12, $11, $8, $7
	i32.const	$push78=, 288
	i32.add 	$push79=, $6, $pop78
	i64.load	$push219=, 304($6)
	tee_local	$push218=, $14=, $pop219
	i32.const	$push76=, 304
	i32.add 	$push77=, $6, $pop76
	i32.const	$push13=, 8
	i32.add 	$push14=, $pop77, $pop13
	i64.load	$push217=, 0($pop14)
	tee_local	$push216=, $13=, $pop217
	call    	__addtf3@FUNCTION, $pop79, $8, $7, $pop218, $pop216
	i32.const	$push82=, 224
	i32.add 	$push83=, $6, $pop82
	i64.load	$push215=, 240($6)
	tee_local	$push214=, $16=, $pop215
	i32.const	$push80=, 240
	i32.add 	$push81=, $6, $pop80
	i32.const	$push213=, 8
	i32.add 	$push15=, $pop81, $pop213
	i64.load	$push212=, 0($pop15)
	tee_local	$push211=, $15=, $pop212
	call    	__subtf3@FUNCTION, $pop83, $pop214, $pop211, $8, $7
	i32.const	$push86=, 272
	i32.add 	$push87=, $6, $pop86
	i64.load	$push210=, 288($6)
	tee_local	$push209=, $10=, $pop210
	i32.const	$push84=, 288
	i32.add 	$push85=, $6, $pop84
	i32.const	$push208=, 8
	i32.add 	$push16=, $pop85, $pop208
	i64.load	$push207=, 0($pop16)
	tee_local	$push206=, $9=, $pop207
	call    	__addtf3@FUNCTION, $pop87, $pop209, $pop206, $8, $7
	i32.const	$push88=, 128
	i32.add 	$push89=, $6, $pop88
	i32.const	$push205=, 0
	i64.load	$push204=, Y2($pop205)
	tee_local	$push203=, $12=, $pop204
	i32.const	$push202=, 0
	i64.load	$push201=, Y2+8($pop202)
	tee_local	$push200=, $11=, $pop201
	call    	__addtf3@FUNCTION, $pop89, $8, $7, $pop203, $pop200
	i32.const	$push90=, 192
	i32.add 	$push91=, $6, $pop90
	call    	__multf3@FUNCTION, $pop91, $14, $13, $12, $11
	i32.const	$push92=, 112
	i32.add 	$push93=, $6, $pop92
	i32.const	$push199=, 0
	i64.load	$push198=, Y1($pop199)
	tee_local	$push197=, $14=, $pop198
	i32.const	$push196=, 0
	i64.load	$push195=, Y1+8($pop196)
	tee_local	$push194=, $13=, $pop195
	call    	__multf3@FUNCTION, $pop93, $16, $15, $pop197, $pop194
	i32.const	$push96=, 80
	i32.add 	$push97=, $6, $pop96
	i64.load	$push193=, 224($6)
	tee_local	$push192=, $16=, $pop193
	i32.const	$push94=, 224
	i32.add 	$push95=, $6, $pop94
	i32.const	$push191=, 8
	i32.add 	$push17=, $pop95, $pop191
	i64.load	$push190=, 0($pop17)
	tee_local	$push189=, $15=, $pop190
	call    	__multf3@FUNCTION, $pop97, $pop192, $pop189, $14, $13
	i32.const	$push98=, 208
	i32.add 	$push99=, $6, $pop98
	call    	__subtf3@FUNCTION, $pop99, $8, $7, $16, $15
	i32.const	$push100=, 160
	i32.add 	$push101=, $6, $pop100
	call    	__multf3@FUNCTION, $pop101, $10, $9, $12, $11
	i32.const	$push104=, 256
	i32.add 	$push105=, $6, $pop104
	i64.load	$push188=, 272($6)
	tee_local	$push187=, $10=, $pop188
	i32.const	$push102=, 272
	i32.add 	$push103=, $6, $pop102
	i32.const	$push186=, 8
	i32.add 	$push18=, $pop103, $pop186
	i64.load	$push185=, 0($pop18)
	tee_local	$push184=, $9=, $pop185
	call    	__addtf3@FUNCTION, $pop105, $8, $7, $pop187, $pop184
	i32.const	$push108=, 48
	i32.add 	$push109=, $6, $pop108
	i64.load	$push21=, 128($6)
	i32.const	$push106=, 128
	i32.add 	$push107=, $6, $pop106
	i32.const	$push183=, 8
	i32.add 	$push19=, $pop107, $pop183
	i64.load	$push20=, 0($pop19)
	call    	__multf3@FUNCTION, $pop109, $pop21, $pop20, $14, $13
	i32.const	$push110=, 16
	i32.add 	$push111=, $6, $pop110
	call    	__multf3@FUNCTION, $pop111, $12, $11, $14, $13
	i32.const	$push114=, 176
	i32.add 	$push115=, $6, $pop114
	i64.load	$push24=, 192($6)
	i32.const	$push112=, 192
	i32.add 	$push113=, $6, $pop112
	i32.const	$push182=, 8
	i32.add 	$push22=, $pop113, $pop182
	i64.load	$push23=, 0($pop22)
	call    	__subtf3@FUNCTION, $pop115, $pop24, $pop23, $10, $9
	i32.const	$push118=, 96
	i32.add 	$push119=, $6, $pop118
	i64.load	$push27=, 112($6)
	i32.const	$push116=, 112
	i32.add 	$push117=, $6, $pop116
	i32.const	$push181=, 8
	i32.add 	$push25=, $pop117, $pop181
	i64.load	$push26=, 0($pop25)
	call    	__subtf3@FUNCTION, $pop119, $pop27, $pop26, $16, $15
	i32.const	$push124=, 64
	i32.add 	$push125=, $6, $pop124
	i64.load	$push33=, 208($6)
	i32.const	$push122=, 208
	i32.add 	$push123=, $6, $pop122
	i32.const	$push180=, 8
	i32.add 	$push30=, $pop123, $pop180
	i64.load	$push31=, 0($pop30)
	i64.load	$push32=, 80($6)
	i32.const	$push120=, 80
	i32.add 	$push121=, $6, $pop120
	i32.const	$push179=, 8
	i32.add 	$push28=, $pop121, $pop179
	i64.load	$push29=, 0($pop28)
	call    	__addtf3@FUNCTION, $pop125, $pop33, $pop31, $pop32, $pop29
	i32.const	$push130=, 144
	i32.add 	$push131=, $6, $pop130
	i64.load	$push178=, 160($6)
	tee_local	$push177=, $8=, $pop178
	i32.const	$push126=, 160
	i32.add 	$push127=, $6, $pop126
	i32.const	$push176=, 8
	i32.add 	$push34=, $pop127, $pop176
	i64.load	$push175=, 0($pop34)
	tee_local	$push174=, $7=, $pop175
	i64.load	$push37=, 256($6)
	i32.const	$push128=, 256
	i32.add 	$push129=, $6, $pop128
	i32.const	$push173=, 8
	i32.add 	$push35=, $pop129, $pop173
	i64.load	$push36=, 0($pop35)
	call    	__subtf3@FUNCTION, $pop131, $pop177, $pop174, $pop37, $pop36
	i32.const	$push134=, 32
	i32.add 	$push135=, $6, $pop134
	i64.load	$push40=, 48($6)
	i32.const	$push132=, 48
	i32.add 	$push133=, $6, $pop132
	i32.const	$push172=, 8
	i32.add 	$push38=, $pop133, $pop172
	i64.load	$push39=, 0($pop38)
	call    	__subtf3@FUNCTION, $pop135, $pop40, $pop39, $12, $11
	i64.load	$push44=, 16($6)
	i32.const	$push136=, 16
	i32.add 	$push137=, $6, $pop136
	i32.const	$push171=, 8
	i32.add 	$push41=, $pop137, $pop171
	i64.load	$push42=, 0($pop41)
	i64.const	$push170=, 0
	i64.const	$push43=, -4612248968380809216
	call    	__addtf3@FUNCTION, $6, $pop44, $pop42, $pop170, $pop43
	i32.const	$push169=, 0
	i64.store	$14=, S+8($pop169), $7
	i32.const	$push168=, 0
	i64.store	$13=, S($pop168), $8
	i32.const	$push167=, 0
	i32.const	$push138=, 176
	i32.add 	$push139=, $6, $pop138
	i32.const	$push166=, 8
	i32.add 	$push45=, $pop139, $pop166
	i64.load	$push11=, 0($pop45)
	i64.store	$10=, X+8($pop167), $pop11
	i32.const	$push165=, 0
	i64.load	$push10=, 176($6)
	i64.store	$9=, X($pop165), $pop10
	i32.const	$push164=, 0
	i32.const	$push140=, 96
	i32.add 	$push141=, $6, $pop140
	i32.const	$push163=, 8
	i32.add 	$push46=, $pop141, $pop163
	i64.load	$push1=, 0($pop46)
	i64.store	$8=, T+8($pop164), $pop1
	i32.const	$push162=, 0
	i64.load	$push0=, 96($6)
	i64.store	$7=, T($pop162), $pop0
	i32.const	$push161=, 0
	i32.const	$push142=, 64
	i32.add 	$push143=, $6, $pop142
	i32.const	$push160=, 8
	i32.add 	$push47=, $pop143, $pop160
	i64.load	$push9=, 0($pop47)
	i64.store	$0=, Y+8($pop161), $pop9
	i32.const	$push159=, 0
	i64.load	$push8=, 64($6)
	i64.store	$1=, Y($pop159), $pop8
	i32.const	$push158=, 0
	i32.const	$push144=, 144
	i32.add 	$push145=, $6, $pop144
	i32.const	$push157=, 8
	i32.add 	$push48=, $pop145, $pop157
	i64.load	$push7=, 0($pop48)
	i64.store	$2=, Z+8($pop158), $pop7
	i32.const	$push156=, 0
	i64.load	$push6=, 144($6)
	i64.store	$3=, Z($pop156), $pop6
	i32.const	$push155=, 0
	i32.const	$push146=, 32
	i32.add 	$push147=, $6, $pop146
	i32.const	$push154=, 8
	i32.add 	$push49=, $pop147, $pop154
	i64.load	$push3=, 0($pop49)
	i64.store	$16=, R+8($pop155), $pop3
	i32.const	$push153=, 0
	i64.load	$push2=, 32($6)
	i64.store	$15=, R($pop153), $pop2
	i32.const	$push152=, 0
	i32.const	$push151=, 8
	i32.add 	$push50=, $6, $pop151
	i64.load	$push5=, 0($pop50)
	i64.store	$4=, Y1+8($pop152), $pop5
	i32.const	$push150=, 0
	i64.load	$push4=, 0($6)
	i64.store	$5=, Y1($pop150), $pop4
	block
	i64.const	$push149=, 0
	i64.const	$push51=, 4612354521497075712
	i32.call	$push52=, __netf2@FUNCTION, $12, $11, $pop149, $pop51
	br_if   	0, $pop52       # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push233=, 0
	i64.const	$push53=, 4613097791357452288
	i32.call	$push54=, __netf2@FUNCTION, $7, $8, $pop233, $pop53
	br_if   	0, $pop54       # 0: down to label0
# BB#2:                                 # %entry
	i64.const	$push234=, 0
	i64.const	$push55=, 4613150567915585536
	i32.call	$push56=, __netf2@FUNCTION, $13, $14, $pop234, $pop55
	br_if   	0, $pop56       # 0: down to label0
# BB#3:                                 # %entry
	i64.const	$push235=, 0
	i64.const	$push57=, 4613517804799262720
	i32.call	$push58=, __netf2@FUNCTION, $15, $16, $pop235, $pop57
	br_if   	0, $pop58       # 0: down to label0
# BB#4:                                 # %entry
	i64.const	$push236=, 0
	i64.const	$push59=, 4613503511148101632
	i32.call	$push60=, __netf2@FUNCTION, $5, $4, $pop236, $pop59
	br_if   	0, $pop60       # 0: down to label0
# BB#5:                                 # %entry
	i64.const	$push237=, 0
	i64.const	$push61=, 4613110985496985600
	i32.call	$push62=, __netf2@FUNCTION, $3, $2, $pop237, $pop61
	br_if   	0, $pop62       # 0: down to label0
# BB#6:                                 # %entry
	i64.const	$push238=, 0
	i64.const	$push63=, 4612961451915608064
	i32.call	$push64=, __netf2@FUNCTION, $1, $0, $pop238, $pop63
	br_if   	0, $pop64       # 0: down to label0
# BB#7:                                 # %entry
	i64.const	$push239=, 0
	i64.const	$push65=, 4613040616752807936
	i32.call	$push66=, __eqtf2@FUNCTION, $9, $10, $pop239, $pop65
	br_if   	0, $pop66       # 0: down to label0
# BB#8:                                 # %if.end
	i32.const	$push67=, 0
	call    	exit@FUNCTION, $pop67
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
