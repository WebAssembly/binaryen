	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push109=, __stack_pointer
	i32.load	$push110=, 0($pop109)
	i32.const	$push111=, 320
	i32.sub 	$16=, $pop110, $pop111
	i32.const	$push112=, __stack_pointer
	i32.store	$discard=, 0($pop112), $16
	i32.const	$push113=, 304
	i32.add 	$push114=, $16, $pop113
	i32.const	$push107=, 0
	i64.load	$push106=, C($pop107)
	tee_local	$push105=, $2=, $pop106
	i32.const	$push104=, 0
	i64.load	$push103=, C+8($pop104)
	tee_local	$push102=, $3=, $pop103
	i32.const	$push101=, 0
	i64.load	$push100=, U($pop101)
	tee_local	$push99=, $15=, $pop100
	i32.const	$push98=, 0
	i64.load	$push97=, U+8($pop98)
	tee_local	$push96=, $14=, $pop97
	call    	__addtf3@FUNCTION, $pop114, $pop105, $pop102, $pop99, $pop96
	i32.const	$push117=, 192
	i32.add 	$push118=, $16, $pop117
	i64.load	$push95=, 304($16)
	tee_local	$push94=, $9=, $pop95
	i32.const	$push115=, 304
	i32.add 	$push116=, $16, $pop115
	i32.const	$push0=, 8
	i32.add 	$push1=, $pop116, $pop0
	i64.load	$push93=, 0($pop1)
	tee_local	$push92=, $8=, $pop93
	i32.const	$push91=, 0
	i64.load	$push90=, Y2($pop91)
	tee_local	$push89=, $13=, $pop90
	i32.const	$push88=, 0
	i64.load	$push87=, Y2+8($pop88)
	tee_local	$push86=, $12=, $pop87
	call    	__multf3@FUNCTION, $pop118, $pop94, $pop92, $pop89, $pop86
	i32.const	$push119=, 192
	i32.add 	$push120=, $16, $pop119
	i32.const	$push85=, 8
	i32.add 	$push2=, $pop120, $pop85
	i64.load	$0=, 0($pop2)
	i64.load	$1=, 192($16)
	i32.const	$push121=, 240
	i32.add 	$push122=, $16, $pop121
	call    	__subtf3@FUNCTION, $pop122, $2, $3, $15, $14
	i32.const	$push125=, 224
	i32.add 	$push126=, $16, $pop125
	i64.load	$push84=, 240($16)
	tee_local	$push83=, $11=, $pop84
	i32.const	$push123=, 240
	i32.add 	$push124=, $16, $pop123
	i32.const	$push82=, 8
	i32.add 	$push3=, $pop124, $pop82
	i64.load	$push81=, 0($pop3)
	tee_local	$push80=, $10=, $pop81
	call    	__subtf3@FUNCTION, $pop126, $pop83, $pop80, $15, $14
	i32.const	$push127=, 224
	i32.add 	$push128=, $16, $pop127
	i32.const	$push79=, 8
	i32.add 	$push4=, $pop128, $pop79
	i64.load	$2=, 0($pop4)
	i64.load	$3=, 224($16)
	i32.const	$push129=, 288
	i32.add 	$push130=, $16, $pop129
	call    	__addtf3@FUNCTION, $pop130, $15, $14, $9, $8
	i32.const	$push131=, 288
	i32.add 	$push132=, $16, $pop131
	i32.const	$push78=, 8
	i32.add 	$push5=, $pop132, $pop78
	i64.load	$4=, 0($pop5)
	i64.load	$5=, 288($16)
	i32.const	$push133=, 112
	i32.add 	$push134=, $16, $pop133
	i32.const	$push77=, 0
	i64.load	$push76=, Y1($pop77)
	tee_local	$push75=, $9=, $pop76
	i32.const	$push74=, 0
	i64.load	$push73=, Y1+8($pop74)
	tee_local	$push72=, $8=, $pop73
	call    	__multf3@FUNCTION, $pop134, $11, $10, $pop75, $pop72
	i32.const	$push135=, 112
	i32.add 	$push136=, $16, $pop135
	i32.const	$push71=, 8
	i32.add 	$push6=, $pop136, $pop71
	i64.load	$11=, 0($pop6)
	i64.load	$10=, 112($16)
	i32.const	$push137=, 272
	i32.add 	$push138=, $16, $pop137
	call    	__addtf3@FUNCTION, $pop138, $5, $4, $15, $14
	i32.const	$push141=, 176
	i32.add 	$push142=, $16, $pop141
	i64.load	$push70=, 272($16)
	tee_local	$push69=, $7=, $pop70
	i32.const	$push139=, 272
	i32.add 	$push140=, $16, $pop139
	i32.const	$push68=, 8
	i32.add 	$push7=, $pop140, $pop68
	i64.load	$push67=, 0($pop7)
	tee_local	$push66=, $6=, $pop67
	call    	__subtf3@FUNCTION, $pop142, $1, $0, $pop69, $pop66
	i64.load	$0=, 176($16)
	i32.const	$push65=, 0
	i32.const	$push143=, 176
	i32.add 	$push144=, $16, $pop143
	i32.const	$push64=, 8
	i32.add 	$push8=, $pop144, $pop64
	i64.load	$push9=, 0($pop8)
	i64.store	$discard=, X+8($pop65), $pop9
	i32.const	$push63=, 0
	i64.store	$discard=, X($pop63), $0
	i32.const	$push145=, 80
	i32.add 	$push146=, $16, $pop145
	call    	__multf3@FUNCTION, $pop146, $3, $2, $9, $8
	i32.const	$push147=, 80
	i32.add 	$push148=, $16, $pop147
	i32.const	$push62=, 8
	i32.add 	$push10=, $pop148, $pop62
	i64.load	$0=, 0($pop10)
	i64.load	$1=, 80($16)
	i32.const	$push149=, 160
	i32.add 	$push150=, $16, $pop149
	call    	__multf3@FUNCTION, $pop150, $5, $4, $13, $12
	i64.load	$4=, 160($16)
	i32.const	$push61=, 0
	i32.const	$push151=, 160
	i32.add 	$push152=, $16, $pop151
	i32.const	$push60=, 8
	i32.add 	$push11=, $pop152, $pop60
	i64.load	$push12=, 0($pop11)
	i64.store	$5=, S+8($pop61), $pop12
	i32.const	$push59=, 0
	i64.store	$discard=, S($pop59), $4
	i32.const	$push153=, 96
	i32.add 	$push154=, $16, $pop153
	call    	__subtf3@FUNCTION, $pop154, $10, $11, $3, $2
	i64.load	$11=, 96($16)
	i32.const	$push58=, 0
	i32.const	$push155=, 96
	i32.add 	$push156=, $16, $pop155
	i32.const	$push57=, 8
	i32.add 	$push13=, $pop156, $pop57
	i64.load	$push14=, 0($pop13)
	i64.store	$discard=, T+8($pop58), $pop14
	i32.const	$push56=, 0
	i64.store	$discard=, T($pop56), $11
	i32.const	$push157=, 208
	i32.add 	$push158=, $16, $pop157
	call    	__subtf3@FUNCTION, $pop158, $15, $14, $3, $2
	i32.const	$push161=, 64
	i32.add 	$push162=, $16, $pop161
	i64.load	$push17=, 208($16)
	i32.const	$push159=, 208
	i32.add 	$push160=, $16, $pop159
	i32.const	$push55=, 8
	i32.add 	$push15=, $pop160, $pop55
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $pop162, $pop17, $pop16, $1, $0
	i64.load	$2=, 64($16)
	i32.const	$push54=, 0
	i32.const	$push163=, 64
	i32.add 	$push164=, $16, $pop163
	i32.const	$push53=, 8
	i32.add 	$push18=, $pop164, $pop53
	i64.load	$push19=, 0($pop18)
	i64.store	$discard=, Y+8($pop54), $pop19
	i32.const	$push52=, 0
	i64.store	$discard=, Y($pop52), $2
	i32.const	$push165=, 256
	i32.add 	$push166=, $16, $pop165
	call    	__addtf3@FUNCTION, $pop166, $15, $14, $7, $6
	i32.const	$push169=, 144
	i32.add 	$push170=, $16, $pop169
	i64.load	$push22=, 256($16)
	i32.const	$push167=, 256
	i32.add 	$push168=, $16, $pop167
	i32.const	$push51=, 8
	i32.add 	$push20=, $pop168, $pop51
	i64.load	$push21=, 0($pop20)
	call    	__subtf3@FUNCTION, $pop170, $4, $5, $pop22, $pop21
	i64.load	$2=, 144($16)
	i32.const	$push50=, 0
	i32.const	$push171=, 144
	i32.add 	$push172=, $16, $pop171
	i32.const	$push49=, 8
	i32.add 	$push23=, $pop172, $pop49
	i64.load	$push24=, 0($pop23)
	i64.store	$3=, Z+8($pop50), $pop24
	i32.const	$push48=, 0
	i64.store	$discard=, Z($pop48), $2
	i32.const	$push173=, 128
	i32.add 	$push174=, $16, $pop173
	call    	__addtf3@FUNCTION, $pop174, $15, $14, $13, $12
	i32.const	$push177=, 48
	i32.add 	$push178=, $16, $pop177
	i64.load	$push27=, 128($16)
	i32.const	$push175=, 128
	i32.add 	$push176=, $16, $pop175
	i32.const	$push47=, 8
	i32.add 	$push25=, $pop176, $pop47
	i64.load	$push26=, 0($pop25)
	call    	__multf3@FUNCTION, $pop178, $pop27, $pop26, $9, $8
	i32.const	$push179=, 48
	i32.add 	$push180=, $16, $pop179
	i32.const	$push46=, 8
	i32.add 	$push28=, $pop180, $pop46
	i64.load	$15=, 0($pop28)
	i64.load	$14=, 48($16)
	i32.const	$push181=, 16
	i32.add 	$push182=, $16, $pop181
	call    	__multf3@FUNCTION, $pop182, $13, $12, $9, $8
	i32.const	$push183=, 16
	i32.add 	$push184=, $16, $pop183
	i32.const	$push45=, 8
	i32.add 	$push29=, $pop184, $pop45
	i64.load	$9=, 0($pop29)
	i64.load	$8=, 16($16)
	i32.const	$push185=, 32
	i32.add 	$push186=, $16, $pop185
	call    	__subtf3@FUNCTION, $pop186, $14, $15, $13, $12
	i64.load	$15=, 32($16)
	i32.const	$push44=, 0
	i32.const	$push187=, 32
	i32.add 	$push188=, $16, $pop187
	i32.const	$push43=, 8
	i32.add 	$push30=, $pop188, $pop43
	i64.load	$push31=, 0($pop30)
	i64.store	$discard=, R+8($pop44), $pop31
	i32.const	$push42=, 0
	i64.store	$discard=, R($pop42), $15
	i64.const	$push33=, 0
	i64.const	$push32=, -4612248968380809216
	call    	__addtf3@FUNCTION, $16, $8, $9, $pop33, $pop32
	i64.load	$15=, 0($16)
	i32.const	$push41=, 0
	i32.const	$push40=, 8
	i32.add 	$push34=, $16, $pop40
	i64.load	$push35=, 0($pop34)
	i64.store	$discard=, Y1+8($pop41), $pop35
	i32.const	$push39=, 0
	i64.store	$discard=, Y1($pop39), $15
	block
	i64.const	$push38=, 0
	i64.const	$push36=, 4612108230892453888
	i32.call	$push37=, __eqtf2@FUNCTION, $2, $3, $pop38, $pop36
	i32.const	$push189=, 0
	i32.eq  	$push190=, $pop37, $pop189
	br_if   	0, $pop190      # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push108=, 0
	call    	exit@FUNCTION, $pop108
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
