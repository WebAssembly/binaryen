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
	i32.const	$push130=, __stack_pointer
	i32.load	$push131=, 0($pop130)
	i32.const	$push132=, 320
	i32.sub 	$18=, $pop131, $pop132
	i32.const	$push133=, __stack_pointer
	i32.store	$discard=, 0($pop133), $18
	i32.const	$push134=, 304
	i32.add 	$push135=, $18, $pop134
	i32.const	$push7=, 0
	i64.load	$push122=, C($pop7)
	tee_local	$push121=, $2=, $pop122
	i32.const	$push120=, 0
	i64.load	$push119=, C+8($pop120)
	tee_local	$push118=, $3=, $pop119
	i32.const	$push117=, 0
	i64.load	$push116=, U($pop117)
	tee_local	$push115=, $17=, $pop116
	i32.const	$push114=, 0
	i64.load	$push113=, U+8($pop114)
	tee_local	$push112=, $16=, $pop113
	call    	__addtf3@FUNCTION, $pop135, $pop121, $pop118, $pop115, $pop112
	i32.const	$push138=, 192
	i32.add 	$push139=, $18, $pop138
	i64.load	$push111=, 304($18)
	tee_local	$push110=, $11=, $pop111
	i32.const	$push136=, 304
	i32.add 	$push137=, $18, $pop136
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop137, $pop8
	i64.load	$push109=, 0($pop9)
	tee_local	$push108=, $10=, $pop109
	i32.const	$push107=, 0
	i64.load	$push106=, Y2($pop107)
	tee_local	$push105=, $15=, $pop106
	i32.const	$push104=, 0
	i64.load	$push103=, Y2+8($pop104)
	tee_local	$push102=, $14=, $pop103
	call    	__multf3@FUNCTION, $pop139, $pop110, $pop108, $pop105, $pop102
	i32.const	$push140=, 192
	i32.add 	$push141=, $18, $pop140
	i32.const	$push101=, 8
	i32.add 	$push10=, $pop141, $pop101
	i64.load	$0=, 0($pop10)
	i64.load	$1=, 192($18)
	i32.const	$push142=, 240
	i32.add 	$push143=, $18, $pop142
	call    	__subtf3@FUNCTION, $pop143, $2, $3, $17, $16
	i32.const	$push146=, 224
	i32.add 	$push147=, $18, $pop146
	i64.load	$push100=, 240($18)
	tee_local	$push99=, $13=, $pop100
	i32.const	$push144=, 240
	i32.add 	$push145=, $18, $pop144
	i32.const	$push98=, 8
	i32.add 	$push11=, $pop145, $pop98
	i64.load	$push97=, 0($pop11)
	tee_local	$push96=, $12=, $pop97
	call    	__subtf3@FUNCTION, $pop147, $pop99, $pop96, $17, $16
	i32.const	$push148=, 224
	i32.add 	$push149=, $18, $pop148
	i32.const	$push95=, 8
	i32.add 	$push12=, $pop149, $pop95
	i64.load	$2=, 0($pop12)
	i64.load	$3=, 224($18)
	i32.const	$push150=, 288
	i32.add 	$push151=, $18, $pop150
	call    	__addtf3@FUNCTION, $pop151, $17, $16, $11, $10
	i32.const	$push152=, 288
	i32.add 	$push153=, $18, $pop152
	i32.const	$push94=, 8
	i32.add 	$push13=, $pop153, $pop94
	i64.load	$4=, 0($pop13)
	i64.load	$5=, 288($18)
	i32.const	$push154=, 112
	i32.add 	$push155=, $18, $pop154
	i32.const	$push93=, 0
	i64.load	$push92=, Y1($pop93)
	tee_local	$push91=, $11=, $pop92
	i32.const	$push90=, 0
	i64.load	$push89=, Y1+8($pop90)
	tee_local	$push88=, $10=, $pop89
	call    	__multf3@FUNCTION, $pop155, $13, $12, $pop91, $pop88
	i32.const	$push156=, 112
	i32.add 	$push157=, $18, $pop156
	i32.const	$push87=, 8
	i32.add 	$push14=, $pop157, $pop87
	i64.load	$13=, 0($pop14)
	i64.load	$12=, 112($18)
	i32.const	$push158=, 272
	i32.add 	$push159=, $18, $pop158
	call    	__addtf3@FUNCTION, $pop159, $5, $4, $17, $16
	i32.const	$push162=, 176
	i32.add 	$push163=, $18, $pop162
	i64.load	$push86=, 272($18)
	tee_local	$push85=, $9=, $pop86
	i32.const	$push160=, 272
	i32.add 	$push161=, $18, $pop160
	i32.const	$push84=, 8
	i32.add 	$push15=, $pop161, $pop84
	i64.load	$push83=, 0($pop15)
	tee_local	$push82=, $8=, $pop83
	call    	__subtf3@FUNCTION, $pop163, $1, $0, $pop85, $pop82
	i64.load	$0=, 176($18)
	i32.const	$push81=, 0
	i32.const	$push164=, 176
	i32.add 	$push165=, $18, $pop164
	i32.const	$push80=, 8
	i32.add 	$push16=, $pop165, $pop80
	i64.load	$push6=, 0($pop16)
	i64.store	$6=, X+8($pop81), $pop6
	i32.const	$push79=, 0
	i64.store	$7=, X($pop79), $0
	i32.const	$push166=, 80
	i32.add 	$push167=, $18, $pop166
	call    	__multf3@FUNCTION, $pop167, $3, $2, $11, $10
	i32.const	$push168=, 80
	i32.add 	$push169=, $18, $pop168
	i32.const	$push78=, 8
	i32.add 	$push17=, $pop169, $pop78
	i64.load	$0=, 0($pop17)
	i64.load	$1=, 80($18)
	i32.const	$push170=, 160
	i32.add 	$push171=, $18, $pop170
	call    	__multf3@FUNCTION, $pop171, $5, $4, $15, $14
	i64.load	$5=, 160($18)
	i32.const	$push77=, 0
	i32.const	$push172=, 160
	i32.add 	$push173=, $18, $pop172
	i32.const	$push76=, 8
	i32.add 	$push18=, $pop173, $pop76
	i64.load	$push1=, 0($pop18)
	i64.store	$4=, S+8($pop77), $pop1
	i32.const	$push75=, 0
	i64.store	$discard=, S($pop75), $5
	i32.const	$push174=, 96
	i32.add 	$push175=, $18, $pop174
	call    	__subtf3@FUNCTION, $pop175, $12, $13, $3, $2
	i64.load	$13=, 96($18)
	i32.const	$push74=, 0
	i32.const	$push176=, 96
	i32.add 	$push177=, $18, $pop176
	i32.const	$push73=, 8
	i32.add 	$push19=, $pop177, $pop73
	i64.load	$push0=, 0($pop19)
	i64.store	$12=, T+8($pop74), $pop0
	i32.const	$push72=, 0
	i64.store	$discard=, T($pop72), $13
	i32.const	$push178=, 208
	i32.add 	$push179=, $18, $pop178
	call    	__subtf3@FUNCTION, $pop179, $17, $16, $3, $2
	i32.const	$push182=, 64
	i32.add 	$push183=, $18, $pop182
	i64.load	$push22=, 208($18)
	i32.const	$push180=, 208
	i32.add 	$push181=, $18, $pop180
	i32.const	$push71=, 8
	i32.add 	$push20=, $pop181, $pop71
	i64.load	$push21=, 0($pop20)
	call    	__addtf3@FUNCTION, $pop183, $pop22, $pop21, $1, $0
	i64.load	$2=, 64($18)
	i32.const	$push70=, 0
	i32.const	$push184=, 64
	i32.add 	$push185=, $18, $pop184
	i32.const	$push69=, 8
	i32.add 	$push23=, $pop185, $pop69
	i64.load	$push5=, 0($pop23)
	i64.store	$0=, Y+8($pop70), $pop5
	i32.const	$push68=, 0
	i64.store	$1=, Y($pop68), $2
	i32.const	$push186=, 256
	i32.add 	$push187=, $18, $pop186
	call    	__addtf3@FUNCTION, $pop187, $17, $16, $9, $8
	i32.const	$push190=, 144
	i32.add 	$push191=, $18, $pop190
	i64.load	$push26=, 256($18)
	i32.const	$push188=, 256
	i32.add 	$push189=, $18, $pop188
	i32.const	$push67=, 8
	i32.add 	$push24=, $pop189, $pop67
	i64.load	$push25=, 0($pop24)
	call    	__subtf3@FUNCTION, $pop191, $5, $4, $pop26, $pop25
	i64.load	$2=, 144($18)
	i32.const	$push66=, 0
	i32.const	$push192=, 144
	i32.add 	$push193=, $18, $pop192
	i32.const	$push65=, 8
	i32.add 	$push27=, $pop193, $pop65
	i64.load	$push4=, 0($pop27)
	i64.store	$9=, Z+8($pop66), $pop4
	i32.const	$push64=, 0
	i64.store	$8=, Z($pop64), $2
	i32.const	$push194=, 128
	i32.add 	$push195=, $18, $pop194
	call    	__addtf3@FUNCTION, $pop195, $17, $16, $15, $14
	i32.const	$push198=, 48
	i32.add 	$push199=, $18, $pop198
	i64.load	$push30=, 128($18)
	i32.const	$push196=, 128
	i32.add 	$push197=, $18, $pop196
	i32.const	$push63=, 8
	i32.add 	$push28=, $pop197, $pop63
	i64.load	$push29=, 0($pop28)
	call    	__multf3@FUNCTION, $pop199, $pop30, $pop29, $11, $10
	i32.const	$push200=, 48
	i32.add 	$push201=, $18, $pop200
	i32.const	$push62=, 8
	i32.add 	$push31=, $pop201, $pop62
	i64.load	$17=, 0($pop31)
	i64.load	$16=, 48($18)
	i32.const	$push202=, 16
	i32.add 	$push203=, $18, $pop202
	call    	__multf3@FUNCTION, $pop203, $15, $14, $11, $10
	i32.const	$push204=, 16
	i32.add 	$push205=, $18, $pop204
	i32.const	$push61=, 8
	i32.add 	$push32=, $pop205, $pop61
	i64.load	$2=, 0($pop32)
	i64.load	$3=, 16($18)
	i32.const	$push206=, 32
	i32.add 	$push207=, $18, $pop206
	call    	__subtf3@FUNCTION, $pop207, $16, $17, $15, $14
	i64.load	$17=, 32($18)
	i32.const	$push60=, 0
	i32.const	$push208=, 32
	i32.add 	$push209=, $18, $pop208
	i32.const	$push59=, 8
	i32.add 	$push33=, $pop209, $pop59
	i64.load	$push2=, 0($pop33)
	i64.store	$16=, R+8($pop60), $pop2
	i32.const	$push58=, 0
	i64.store	$11=, R($pop58), $17
	i64.const	$push57=, 0
	i64.const	$push34=, -4612248968380809216
	call    	__addtf3@FUNCTION, $18, $3, $2, $pop57, $pop34
	i64.load	$17=, 0($18)
	i32.const	$push56=, 0
	i32.const	$push55=, 8
	i32.add 	$push35=, $18, $pop55
	i64.load	$push3=, 0($pop35)
	i64.store	$2=, Y1+8($pop56), $pop3
	i32.const	$push54=, 0
	i64.store	$discard=, Y1($pop54), $17
	block
	i64.const	$push53=, 0
	i64.const	$push36=, 4612354521497075712
	i32.call	$push37=, __netf2@FUNCTION, $15, $14, $pop53, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push123=, 0
	i64.const	$push38=, 4613097791357452288
	i32.call	$push39=, __netf2@FUNCTION, $13, $12, $pop123, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#2:                                 # %entry
	i64.const	$push124=, 0
	i64.const	$push40=, 4613150567915585536
	i32.call	$push41=, __netf2@FUNCTION, $5, $4, $pop124, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#3:                                 # %entry
	i64.const	$push125=, 0
	i64.const	$push42=, 4613517804799262720
	i32.call	$push43=, __netf2@FUNCTION, $11, $16, $pop125, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#4:                                 # %entry
	i64.const	$push126=, 0
	i64.const	$push44=, 4613503511148101632
	i32.call	$push45=, __netf2@FUNCTION, $17, $2, $pop126, $pop44
	br_if   	0, $pop45       # 0: down to label0
# BB#5:                                 # %entry
	i64.const	$push127=, 0
	i64.const	$push46=, 4613110985496985600
	i32.call	$push47=, __netf2@FUNCTION, $8, $9, $pop127, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#6:                                 # %entry
	i64.const	$push128=, 0
	i64.const	$push48=, 4612961451915608064
	i32.call	$push49=, __netf2@FUNCTION, $1, $0, $pop128, $pop48
	br_if   	0, $pop49       # 0: down to label0
# BB#7:                                 # %entry
	i64.const	$push129=, 0
	i64.const	$push50=, 4613040616752807936
	i32.call	$push51=, __eqtf2@FUNCTION, $7, $6, $pop129, $pop50
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
