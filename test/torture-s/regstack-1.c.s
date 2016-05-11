	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/regstack-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push56=, __stack_pointer
	i32.const	$push53=, __stack_pointer
	i32.load	$push54=, 0($pop53)
	i32.const	$push55=, 320
	i32.sub 	$push133=, $pop54, $pop55
	i32.store	$push205=, 0($pop56), $pop133
	tee_local	$push204=, $18=, $pop205
	i32.const	$push57=, 304
	i32.add 	$push58=, $pop204, $pop57
	i32.const	$push7=, 0
	i64.load	$push203=, C($pop7)
	tee_local	$push202=, $4=, $pop203
	i32.const	$push201=, 0
	i64.load	$push200=, C+8($pop201)
	tee_local	$push199=, $5=, $pop200
	i32.const	$push198=, 0
	i64.load	$push197=, U($pop198)
	tee_local	$push196=, $17=, $pop197
	i32.const	$push195=, 0
	i64.load	$push194=, U+8($pop195)
	tee_local	$push193=, $16=, $pop194
	call    	__addtf3@FUNCTION, $pop58, $pop202, $pop199, $pop196, $pop193
	i32.const	$push61=, 192
	i32.add 	$push62=, $18, $pop61
	i64.load	$push192=, 304($18)
	tee_local	$push191=, $11=, $pop192
	i32.const	$push59=, 304
	i32.add 	$push60=, $18, $pop59
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop60, $pop8
	i64.load	$push190=, 0($pop9)
	tee_local	$push189=, $10=, $pop190
	i32.const	$push188=, 0
	i64.load	$push187=, Y2($pop188)
	tee_local	$push186=, $15=, $pop187
	i32.const	$push185=, 0
	i64.load	$push184=, Y2+8($pop185)
	tee_local	$push183=, $14=, $pop184
	call    	__multf3@FUNCTION, $pop62, $pop191, $pop189, $pop186, $pop183
	i32.const	$push63=, 192
	i32.add 	$push64=, $18, $pop63
	i32.const	$push182=, 8
	i32.add 	$push10=, $pop64, $pop182
	i64.load	$2=, 0($pop10)
	i64.load	$3=, 192($18)
	i32.const	$push65=, 240
	i32.add 	$push66=, $18, $pop65
	call    	__subtf3@FUNCTION, $pop66, $4, $5, $17, $16
	i32.const	$push69=, 224
	i32.add 	$push70=, $18, $pop69
	i64.load	$push181=, 240($18)
	tee_local	$push180=, $13=, $pop181
	i32.const	$push67=, 240
	i32.add 	$push68=, $18, $pop67
	i32.const	$push179=, 8
	i32.add 	$push11=, $pop68, $pop179
	i64.load	$push178=, 0($pop11)
	tee_local	$push177=, $12=, $pop178
	call    	__subtf3@FUNCTION, $pop70, $pop180, $pop177, $17, $16
	i32.const	$push71=, 224
	i32.add 	$push72=, $18, $pop71
	i32.const	$push176=, 8
	i32.add 	$push12=, $pop72, $pop176
	i64.load	$4=, 0($pop12)
	i64.load	$5=, 224($18)
	i32.const	$push73=, 288
	i32.add 	$push74=, $18, $pop73
	call    	__addtf3@FUNCTION, $pop74, $17, $16, $11, $10
	i32.const	$push75=, 288
	i32.add 	$push76=, $18, $pop75
	i32.const	$push175=, 8
	i32.add 	$push13=, $pop76, $pop175
	i64.load	$6=, 0($pop13)
	i64.load	$7=, 288($18)
	i32.const	$push77=, 112
	i32.add 	$push78=, $18, $pop77
	i32.const	$push174=, 0
	i64.load	$push173=, Y1($pop174)
	tee_local	$push172=, $11=, $pop173
	i32.const	$push171=, 0
	i64.load	$push170=, Y1+8($pop171)
	tee_local	$push169=, $10=, $pop170
	call    	__multf3@FUNCTION, $pop78, $13, $12, $pop172, $pop169
	i32.const	$push79=, 112
	i32.add 	$push80=, $18, $pop79
	i32.const	$push168=, 8
	i32.add 	$push14=, $pop80, $pop168
	i64.load	$13=, 0($pop14)
	i64.load	$12=, 112($18)
	i32.const	$push81=, 272
	i32.add 	$push82=, $18, $pop81
	call    	__addtf3@FUNCTION, $pop82, $7, $6, $17, $16
	i32.const	$push85=, 176
	i32.add 	$push86=, $18, $pop85
	i64.load	$push167=, 272($18)
	tee_local	$push166=, $9=, $pop167
	i32.const	$push83=, 272
	i32.add 	$push84=, $18, $pop83
	i32.const	$push165=, 8
	i32.add 	$push15=, $pop84, $pop165
	i64.load	$push164=, 0($pop15)
	tee_local	$push163=, $8=, $pop164
	call    	__subtf3@FUNCTION, $pop86, $3, $2, $pop166, $pop163
	i64.load	$2=, 176($18)
	i32.const	$push162=, 0
	i32.const	$push87=, 176
	i32.add 	$push88=, $18, $pop87
	i32.const	$push161=, 8
	i32.add 	$push16=, $pop88, $pop161
	i64.load	$push6=, 0($pop16)
	i64.store	$0=, X+8($pop162), $pop6
	i32.const	$push160=, 0
	i64.store	$1=, X($pop160), $2
	i32.const	$push89=, 80
	i32.add 	$push90=, $18, $pop89
	call    	__multf3@FUNCTION, $pop90, $5, $4, $11, $10
	i32.const	$push91=, 80
	i32.add 	$push92=, $18, $pop91
	i32.const	$push159=, 8
	i32.add 	$push17=, $pop92, $pop159
	i64.load	$2=, 0($pop17)
	i64.load	$3=, 80($18)
	i32.const	$push93=, 160
	i32.add 	$push94=, $18, $pop93
	call    	__multf3@FUNCTION, $pop94, $7, $6, $15, $14
	i64.load	$7=, 160($18)
	i32.const	$push158=, 0
	i32.const	$push95=, 160
	i32.add 	$push96=, $18, $pop95
	i32.const	$push157=, 8
	i32.add 	$push18=, $pop96, $pop157
	i64.load	$push1=, 0($pop18)
	i64.store	$6=, S+8($pop158), $pop1
	i32.const	$push156=, 0
	i64.store	$discard=, S($pop156), $7
	i32.const	$push97=, 96
	i32.add 	$push98=, $18, $pop97
	call    	__subtf3@FUNCTION, $pop98, $12, $13, $5, $4
	i64.load	$13=, 96($18)
	i32.const	$push155=, 0
	i32.const	$push99=, 96
	i32.add 	$push100=, $18, $pop99
	i32.const	$push154=, 8
	i32.add 	$push19=, $pop100, $pop154
	i64.load	$push0=, 0($pop19)
	i64.store	$12=, T+8($pop155), $pop0
	i32.const	$push153=, 0
	i64.store	$discard=, T($pop153), $13
	i32.const	$push101=, 208
	i32.add 	$push102=, $18, $pop101
	call    	__subtf3@FUNCTION, $pop102, $17, $16, $5, $4
	i32.const	$push105=, 64
	i32.add 	$push106=, $18, $pop105
	i64.load	$push22=, 208($18)
	i32.const	$push103=, 208
	i32.add 	$push104=, $18, $pop103
	i32.const	$push152=, 8
	i32.add 	$push20=, $pop104, $pop152
	i64.load	$push21=, 0($pop20)
	call    	__addtf3@FUNCTION, $pop106, $pop22, $pop21, $3, $2
	i64.load	$4=, 64($18)
	i32.const	$push151=, 0
	i32.const	$push107=, 64
	i32.add 	$push108=, $18, $pop107
	i32.const	$push150=, 8
	i32.add 	$push23=, $pop108, $pop150
	i64.load	$push5=, 0($pop23)
	i64.store	$2=, Y+8($pop151), $pop5
	i32.const	$push149=, 0
	i64.store	$3=, Y($pop149), $4
	i32.const	$push109=, 256
	i32.add 	$push110=, $18, $pop109
	call    	__addtf3@FUNCTION, $pop110, $17, $16, $9, $8
	i32.const	$push113=, 144
	i32.add 	$push114=, $18, $pop113
	i64.load	$push26=, 256($18)
	i32.const	$push111=, 256
	i32.add 	$push112=, $18, $pop111
	i32.const	$push148=, 8
	i32.add 	$push24=, $pop112, $pop148
	i64.load	$push25=, 0($pop24)
	call    	__subtf3@FUNCTION, $pop114, $7, $6, $pop26, $pop25
	i64.load	$4=, 144($18)
	i32.const	$push147=, 0
	i32.const	$push115=, 144
	i32.add 	$push116=, $18, $pop115
	i32.const	$push146=, 8
	i32.add 	$push27=, $pop116, $pop146
	i64.load	$push4=, 0($pop27)
	i64.store	$9=, Z+8($pop147), $pop4
	i32.const	$push145=, 0
	i64.store	$8=, Z($pop145), $4
	i32.const	$push117=, 128
	i32.add 	$push118=, $18, $pop117
	call    	__addtf3@FUNCTION, $pop118, $17, $16, $15, $14
	i32.const	$push121=, 48
	i32.add 	$push122=, $18, $pop121
	i64.load	$push30=, 128($18)
	i32.const	$push119=, 128
	i32.add 	$push120=, $18, $pop119
	i32.const	$push144=, 8
	i32.add 	$push28=, $pop120, $pop144
	i64.load	$push29=, 0($pop28)
	call    	__multf3@FUNCTION, $pop122, $pop30, $pop29, $11, $10
	i32.const	$push123=, 48
	i32.add 	$push124=, $18, $pop123
	i32.const	$push143=, 8
	i32.add 	$push31=, $pop124, $pop143
	i64.load	$17=, 0($pop31)
	i64.load	$16=, 48($18)
	i32.const	$push125=, 16
	i32.add 	$push126=, $18, $pop125
	call    	__multf3@FUNCTION, $pop126, $15, $14, $11, $10
	i32.const	$push127=, 16
	i32.add 	$push128=, $18, $pop127
	i32.const	$push142=, 8
	i32.add 	$push32=, $pop128, $pop142
	i64.load	$4=, 0($pop32)
	i64.load	$5=, 16($18)
	i32.const	$push129=, 32
	i32.add 	$push130=, $18, $pop129
	call    	__subtf3@FUNCTION, $pop130, $16, $17, $15, $14
	i64.load	$17=, 32($18)
	i32.const	$push141=, 0
	i32.const	$push131=, 32
	i32.add 	$push132=, $18, $pop131
	i32.const	$push140=, 8
	i32.add 	$push33=, $pop132, $pop140
	i64.load	$push2=, 0($pop33)
	i64.store	$16=, R+8($pop141), $pop2
	i32.const	$push139=, 0
	i64.store	$11=, R($pop139), $17
	i64.const	$push138=, 0
	i64.const	$push34=, -4612248968380809216
	call    	__addtf3@FUNCTION, $18, $5, $4, $pop138, $pop34
	i64.load	$17=, 0($18)
	i32.const	$push137=, 0
	i32.const	$push136=, 8
	i32.add 	$push35=, $18, $pop136
	i64.load	$push3=, 0($pop35)
	i64.store	$4=, Y1+8($pop137), $pop3
	i32.const	$push135=, 0
	i64.store	$discard=, Y1($pop135), $17
	block
	i64.const	$push134=, 0
	i64.const	$push36=, 4612354521497075712
	i32.call	$push37=, __netf2@FUNCTION, $15, $14, $pop134, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push206=, 0
	i64.const	$push38=, 4613097791357452288
	i32.call	$push39=, __netf2@FUNCTION, $13, $12, $pop206, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#2:                                 # %entry
	i64.const	$push207=, 0
	i64.const	$push40=, 4613150567915585536
	i32.call	$push41=, __netf2@FUNCTION, $7, $6, $pop207, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#3:                                 # %entry
	i64.const	$push208=, 0
	i64.const	$push42=, 4613517804799262720
	i32.call	$push43=, __netf2@FUNCTION, $11, $16, $pop208, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#4:                                 # %entry
	i64.const	$push209=, 0
	i64.const	$push44=, 4613503511148101632
	i32.call	$push45=, __netf2@FUNCTION, $17, $4, $pop209, $pop44
	br_if   	0, $pop45       # 0: down to label0
# BB#5:                                 # %entry
	i64.const	$push210=, 0
	i64.const	$push46=, 4613110985496985600
	i32.call	$push47=, __netf2@FUNCTION, $8, $9, $pop210, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#6:                                 # %entry
	i64.const	$push211=, 0
	i64.const	$push48=, 4612961451915608064
	i32.call	$push49=, __netf2@FUNCTION, $3, $2, $pop211, $pop48
	br_if   	0, $pop49       # 0: down to label0
# BB#7:                                 # %entry
	i64.const	$push212=, 0
	i64.const	$push50=, 4613040616752807936
	i32.call	$push51=, __eqtf2@FUNCTION, $1, $0, $pop212, $pop50
	br_if   	0, $pop51       # 0: down to label0
# BB#8:                                 # %if.end
	i32.const	$push52=, 0
	call    	exit@FUNCTION, $pop52
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
