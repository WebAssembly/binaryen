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
	i32.const	$push41=, __stack_pointer
	i32.const	$push38=, __stack_pointer
	i32.load	$push39=, 0($pop38)
	i32.const	$push40=, 320
	i32.sub 	$push118=, $pop39, $pop40
	i32.store	$push190=, 0($pop41), $pop118
	tee_local	$push189=, $16=, $pop190
	i32.const	$push42=, 304
	i32.add 	$push43=, $pop189, $pop42
	i32.const	$push188=, 0
	i64.load	$push187=, C($pop188)
	tee_local	$push186=, $2=, $pop187
	i32.const	$push185=, 0
	i64.load	$push184=, C+8($pop185)
	tee_local	$push183=, $3=, $pop184
	i32.const	$push182=, 0
	i64.load	$push181=, U($pop182)
	tee_local	$push180=, $15=, $pop181
	i32.const	$push179=, 0
	i64.load	$push178=, U+8($pop179)
	tee_local	$push177=, $14=, $pop178
	call    	__addtf3@FUNCTION, $pop43, $pop186, $pop183, $pop180, $pop177
	i32.const	$push46=, 192
	i32.add 	$push47=, $16, $pop46
	i64.load	$push176=, 304($16)
	tee_local	$push175=, $9=, $pop176
	i32.const	$push44=, 304
	i32.add 	$push45=, $16, $pop44
	i32.const	$push0=, 8
	i32.add 	$push1=, $pop45, $pop0
	i64.load	$push174=, 0($pop1)
	tee_local	$push173=, $8=, $pop174
	i32.const	$push172=, 0
	i64.load	$push171=, Y2($pop172)
	tee_local	$push170=, $13=, $pop171
	i32.const	$push169=, 0
	i64.load	$push168=, Y2+8($pop169)
	tee_local	$push167=, $12=, $pop168
	call    	__multf3@FUNCTION, $pop47, $pop175, $pop173, $pop170, $pop167
	i32.const	$push48=, 192
	i32.add 	$push49=, $16, $pop48
	i32.const	$push166=, 8
	i32.add 	$push2=, $pop49, $pop166
	i64.load	$0=, 0($pop2)
	i64.load	$1=, 192($16)
	i32.const	$push50=, 240
	i32.add 	$push51=, $16, $pop50
	call    	__subtf3@FUNCTION, $pop51, $2, $3, $15, $14
	i32.const	$push54=, 224
	i32.add 	$push55=, $16, $pop54
	i64.load	$push165=, 240($16)
	tee_local	$push164=, $11=, $pop165
	i32.const	$push52=, 240
	i32.add 	$push53=, $16, $pop52
	i32.const	$push163=, 8
	i32.add 	$push3=, $pop53, $pop163
	i64.load	$push162=, 0($pop3)
	tee_local	$push161=, $10=, $pop162
	call    	__subtf3@FUNCTION, $pop55, $pop164, $pop161, $15, $14
	i32.const	$push56=, 224
	i32.add 	$push57=, $16, $pop56
	i32.const	$push160=, 8
	i32.add 	$push4=, $pop57, $pop160
	i64.load	$2=, 0($pop4)
	i64.load	$3=, 224($16)
	i32.const	$push58=, 288
	i32.add 	$push59=, $16, $pop58
	call    	__addtf3@FUNCTION, $pop59, $15, $14, $9, $8
	i32.const	$push60=, 288
	i32.add 	$push61=, $16, $pop60
	i32.const	$push159=, 8
	i32.add 	$push5=, $pop61, $pop159
	i64.load	$4=, 0($pop5)
	i64.load	$5=, 288($16)
	i32.const	$push62=, 112
	i32.add 	$push63=, $16, $pop62
	i32.const	$push158=, 0
	i64.load	$push157=, Y1($pop158)
	tee_local	$push156=, $9=, $pop157
	i32.const	$push155=, 0
	i64.load	$push154=, Y1+8($pop155)
	tee_local	$push153=, $8=, $pop154
	call    	__multf3@FUNCTION, $pop63, $11, $10, $pop156, $pop153
	i32.const	$push64=, 112
	i32.add 	$push65=, $16, $pop64
	i32.const	$push152=, 8
	i32.add 	$push6=, $pop65, $pop152
	i64.load	$11=, 0($pop6)
	i64.load	$10=, 112($16)
	i32.const	$push66=, 272
	i32.add 	$push67=, $16, $pop66
	call    	__addtf3@FUNCTION, $pop67, $5, $4, $15, $14
	i32.const	$push70=, 176
	i32.add 	$push71=, $16, $pop70
	i64.load	$push151=, 272($16)
	tee_local	$push150=, $7=, $pop151
	i32.const	$push68=, 272
	i32.add 	$push69=, $16, $pop68
	i32.const	$push149=, 8
	i32.add 	$push7=, $pop69, $pop149
	i64.load	$push148=, 0($pop7)
	tee_local	$push147=, $6=, $pop148
	call    	__subtf3@FUNCTION, $pop71, $1, $0, $pop150, $pop147
	i64.load	$0=, 176($16)
	i32.const	$push146=, 0
	i32.const	$push72=, 176
	i32.add 	$push73=, $16, $pop72
	i32.const	$push145=, 8
	i32.add 	$push8=, $pop73, $pop145
	i64.load	$push9=, 0($pop8)
	i64.store	$discard=, X+8($pop146), $pop9
	i32.const	$push144=, 0
	i64.store	$discard=, X($pop144), $0
	i32.const	$push74=, 80
	i32.add 	$push75=, $16, $pop74
	call    	__multf3@FUNCTION, $pop75, $3, $2, $9, $8
	i32.const	$push76=, 80
	i32.add 	$push77=, $16, $pop76
	i32.const	$push143=, 8
	i32.add 	$push10=, $pop77, $pop143
	i64.load	$0=, 0($pop10)
	i64.load	$1=, 80($16)
	i32.const	$push78=, 160
	i32.add 	$push79=, $16, $pop78
	call    	__multf3@FUNCTION, $pop79, $5, $4, $13, $12
	i64.load	$4=, 160($16)
	i32.const	$push142=, 0
	i32.const	$push80=, 160
	i32.add 	$push81=, $16, $pop80
	i32.const	$push141=, 8
	i32.add 	$push11=, $pop81, $pop141
	i64.load	$push12=, 0($pop11)
	i64.store	$5=, S+8($pop142), $pop12
	i32.const	$push140=, 0
	i64.store	$discard=, S($pop140), $4
	i32.const	$push82=, 96
	i32.add 	$push83=, $16, $pop82
	call    	__subtf3@FUNCTION, $pop83, $10, $11, $3, $2
	i64.load	$11=, 96($16)
	i32.const	$push139=, 0
	i32.const	$push84=, 96
	i32.add 	$push85=, $16, $pop84
	i32.const	$push138=, 8
	i32.add 	$push13=, $pop85, $pop138
	i64.load	$push14=, 0($pop13)
	i64.store	$discard=, T+8($pop139), $pop14
	i32.const	$push137=, 0
	i64.store	$discard=, T($pop137), $11
	i32.const	$push86=, 208
	i32.add 	$push87=, $16, $pop86
	call    	__subtf3@FUNCTION, $pop87, $15, $14, $3, $2
	i32.const	$push90=, 64
	i32.add 	$push91=, $16, $pop90
	i64.load	$push17=, 208($16)
	i32.const	$push88=, 208
	i32.add 	$push89=, $16, $pop88
	i32.const	$push136=, 8
	i32.add 	$push15=, $pop89, $pop136
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $pop91, $pop17, $pop16, $1, $0
	i64.load	$2=, 64($16)
	i32.const	$push135=, 0
	i32.const	$push92=, 64
	i32.add 	$push93=, $16, $pop92
	i32.const	$push134=, 8
	i32.add 	$push18=, $pop93, $pop134
	i64.load	$push19=, 0($pop18)
	i64.store	$discard=, Y+8($pop135), $pop19
	i32.const	$push133=, 0
	i64.store	$discard=, Y($pop133), $2
	i32.const	$push94=, 256
	i32.add 	$push95=, $16, $pop94
	call    	__addtf3@FUNCTION, $pop95, $15, $14, $7, $6
	i32.const	$push98=, 144
	i32.add 	$push99=, $16, $pop98
	i64.load	$push22=, 256($16)
	i32.const	$push96=, 256
	i32.add 	$push97=, $16, $pop96
	i32.const	$push132=, 8
	i32.add 	$push20=, $pop97, $pop132
	i64.load	$push21=, 0($pop20)
	call    	__subtf3@FUNCTION, $pop99, $4, $5, $pop22, $pop21
	i64.load	$2=, 144($16)
	i32.const	$push131=, 0
	i32.const	$push100=, 144
	i32.add 	$push101=, $16, $pop100
	i32.const	$push130=, 8
	i32.add 	$push23=, $pop101, $pop130
	i64.load	$push24=, 0($pop23)
	i64.store	$3=, Z+8($pop131), $pop24
	i32.const	$push129=, 0
	i64.store	$discard=, Z($pop129), $2
	i32.const	$push102=, 128
	i32.add 	$push103=, $16, $pop102
	call    	__addtf3@FUNCTION, $pop103, $15, $14, $13, $12
	i32.const	$push106=, 48
	i32.add 	$push107=, $16, $pop106
	i64.load	$push27=, 128($16)
	i32.const	$push104=, 128
	i32.add 	$push105=, $16, $pop104
	i32.const	$push128=, 8
	i32.add 	$push25=, $pop105, $pop128
	i64.load	$push26=, 0($pop25)
	call    	__multf3@FUNCTION, $pop107, $pop27, $pop26, $9, $8
	i32.const	$push108=, 48
	i32.add 	$push109=, $16, $pop108
	i32.const	$push127=, 8
	i32.add 	$push28=, $pop109, $pop127
	i64.load	$15=, 0($pop28)
	i64.load	$14=, 48($16)
	i32.const	$push110=, 16
	i32.add 	$push111=, $16, $pop110
	call    	__multf3@FUNCTION, $pop111, $13, $12, $9, $8
	i32.const	$push112=, 16
	i32.add 	$push113=, $16, $pop112
	i32.const	$push126=, 8
	i32.add 	$push29=, $pop113, $pop126
	i64.load	$9=, 0($pop29)
	i64.load	$8=, 16($16)
	i32.const	$push114=, 32
	i32.add 	$push115=, $16, $pop114
	call    	__subtf3@FUNCTION, $pop115, $14, $15, $13, $12
	i64.load	$15=, 32($16)
	i32.const	$push125=, 0
	i32.const	$push116=, 32
	i32.add 	$push117=, $16, $pop116
	i32.const	$push124=, 8
	i32.add 	$push30=, $pop117, $pop124
	i64.load	$push31=, 0($pop30)
	i64.store	$discard=, R+8($pop125), $pop31
	i32.const	$push123=, 0
	i64.store	$discard=, R($pop123), $15
	i64.const	$push33=, 0
	i64.const	$push32=, -4612248968380809216
	call    	__addtf3@FUNCTION, $16, $8, $9, $pop33, $pop32
	i64.load	$15=, 0($16)
	i32.const	$push122=, 0
	i32.const	$push121=, 8
	i32.add 	$push34=, $16, $pop121
	i64.load	$push35=, 0($pop34)
	i64.store	$discard=, Y1+8($pop122), $pop35
	i32.const	$push120=, 0
	i64.store	$discard=, Y1($pop120), $15
	block
	i64.const	$push119=, 0
	i64.const	$push36=, 4612108230892453888
	i32.call	$push37=, __eqtf2@FUNCTION, $2, $3, $pop119, $pop36
	i32.const	$push192=, 0
	i32.eq  	$push193=, $pop37, $pop192
	br_if   	0, $pop193      # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push191=, 0
	call    	exit@FUNCTION, $pop191
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
