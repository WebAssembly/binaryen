	.text
	.file	"regstack-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push57=, 0
	i32.load	$push56=, __stack_pointer($pop57)
	i32.const	$push58=, 320
	i32.sub 	$16=, $pop56, $pop58
	i32.const	$push59=, 0
	i32.store	__stack_pointer($pop59), $16
	i32.const	$push0=, 0
	i64.load	$4=, U+8($pop0)
	i32.const	$push177=, 0
	i64.load	$5=, U($pop177)
	i32.const	$push176=, 0
	i64.load	$6=, C+8($pop176)
	i32.const	$push175=, 0
	i64.load	$7=, C($pop175)
	i32.const	$push60=, 304
	i32.add 	$push61=, $16, $pop60
	call    	__addtf3@FUNCTION, $pop61, $7, $6, $5, $4
	i32.const	$push62=, 240
	i32.add 	$push63=, $16, $pop62
	call    	__subtf3@FUNCTION, $pop63, $7, $6, $5, $4
	i32.const	$push64=, 304
	i32.add 	$push65=, $16, $pop64
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop65, $pop1
	i64.load	$14=, 0($pop2)
	i64.load	$15=, 304($16)
	i32.const	$push66=, 288
	i32.add 	$push67=, $16, $pop66
	call    	__addtf3@FUNCTION, $pop67, $5, $4, $15, $14
	i32.const	$push174=, 0
	i64.load	$6=, Y2+8($pop174)
	i32.const	$push173=, 0
	i64.load	$7=, Y2($pop173)
	i32.const	$push68=, 128
	i32.add 	$push69=, $16, $pop68
	call    	__addtf3@FUNCTION, $pop69, $5, $4, $7, $6
	i32.const	$push70=, 240
	i32.add 	$push71=, $16, $pop70
	i32.const	$push172=, 8
	i32.add 	$push3=, $pop71, $pop172
	i64.load	$8=, 0($pop3)
	i64.load	$9=, 240($16)
	i32.const	$push72=, 224
	i32.add 	$push73=, $16, $pop72
	call    	__subtf3@FUNCTION, $pop73, $9, $8, $5, $4
	i32.const	$push74=, 288
	i32.add 	$push75=, $16, $pop74
	i32.const	$push171=, 8
	i32.add 	$push4=, $pop75, $pop171
	i64.load	$10=, 0($pop4)
	i64.load	$11=, 288($16)
	i32.const	$push76=, 272
	i32.add 	$push77=, $16, $pop76
	call    	__addtf3@FUNCTION, $pop77, $5, $4, $11, $10
	i32.const	$push170=, 0
	i64.load	$12=, Y1+8($pop170)
	i32.const	$push169=, 0
	i64.load	$13=, Y1($pop169)
	i32.const	$push78=, 16
	i32.add 	$push79=, $16, $pop78
	call    	__multf3@FUNCTION, $pop79, $7, $6, $13, $12
	i32.const	$push80=, 112
	i32.add 	$push81=, $16, $pop80
	call    	__multf3@FUNCTION, $pop81, $9, $8, $13, $12
	i32.const	$push84=, 48
	i32.add 	$push85=, $16, $pop84
	i64.load	$push7=, 128($16)
	i32.const	$push82=, 128
	i32.add 	$push83=, $16, $pop82
	i32.const	$push168=, 8
	i32.add 	$push5=, $pop83, $pop168
	i64.load	$push6=, 0($pop5)
	call    	__multf3@FUNCTION, $pop85, $pop7, $pop6, $13, $12
	i32.const	$push86=, 192
	i32.add 	$push87=, $16, $pop86
	call    	__multf3@FUNCTION, $pop87, $15, $14, $7, $6
	i32.const	$push88=, 224
	i32.add 	$push89=, $16, $pop88
	i32.const	$push167=, 8
	i32.add 	$push8=, $pop89, $pop167
	i64.load	$14=, 0($pop8)
	i64.load	$15=, 224($16)
	i32.const	$push90=, 80
	i32.add 	$push91=, $16, $pop90
	call    	__multf3@FUNCTION, $pop91, $15, $14, $13, $12
	i32.const	$push92=, 208
	i32.add 	$push93=, $16, $pop92
	call    	__subtf3@FUNCTION, $pop93, $5, $4, $15, $14
	i32.const	$push94=, 160
	i32.add 	$push95=, $16, $pop94
	call    	__multf3@FUNCTION, $pop95, $7, $6, $11, $10
	i32.const	$push96=, 272
	i32.add 	$push97=, $16, $pop96
	i32.const	$push166=, 8
	i32.add 	$push9=, $pop97, $pop166
	i64.load	$12=, 0($pop9)
	i64.load	$13=, 272($16)
	i32.const	$push98=, 256
	i32.add 	$push99=, $16, $pop98
	call    	__addtf3@FUNCTION, $pop99, $5, $4, $13, $12
	i64.load	$push13=, 16($16)
	i32.const	$push100=, 16
	i32.add 	$push101=, $16, $pop100
	i32.const	$push165=, 8
	i32.add 	$push10=, $pop101, $pop165
	i64.load	$push11=, 0($pop10)
	i64.const	$push164=, 0
	i64.const	$push12=, -4612248968380809216
	call    	__addtf3@FUNCTION, $16, $pop13, $pop11, $pop164, $pop12
	i32.const	$push104=, 96
	i32.add 	$push105=, $16, $pop104
	i64.load	$push16=, 112($16)
	i32.const	$push102=, 112
	i32.add 	$push103=, $16, $pop102
	i32.const	$push163=, 8
	i32.add 	$push14=, $pop103, $pop163
	i64.load	$push15=, 0($pop14)
	call    	__subtf3@FUNCTION, $pop105, $pop16, $pop15, $15, $14
	i32.const	$push108=, 32
	i32.add 	$push109=, $16, $pop108
	i64.load	$push19=, 48($16)
	i32.const	$push106=, 48
	i32.add 	$push107=, $16, $pop106
	i32.const	$push162=, 8
	i32.add 	$push17=, $pop107, $pop162
	i64.load	$push18=, 0($pop17)
	call    	__subtf3@FUNCTION, $pop109, $pop19, $pop18, $7, $6
	i32.const	$push112=, 176
	i32.add 	$push113=, $16, $pop112
	i64.load	$push22=, 192($16)
	i32.const	$push110=, 192
	i32.add 	$push111=, $16, $pop110
	i32.const	$push161=, 8
	i32.add 	$push20=, $pop111, $pop161
	i64.load	$push21=, 0($pop20)
	call    	__subtf3@FUNCTION, $pop113, $pop22, $pop21, $13, $12
	i32.const	$push118=, 64
	i32.add 	$push119=, $16, $pop118
	i64.load	$push28=, 208($16)
	i32.const	$push116=, 208
	i32.add 	$push117=, $16, $pop116
	i32.const	$push160=, 8
	i32.add 	$push25=, $pop117, $pop160
	i64.load	$push26=, 0($pop25)
	i64.load	$push27=, 80($16)
	i32.const	$push114=, 80
	i32.add 	$push115=, $16, $pop114
	i32.const	$push159=, 8
	i32.add 	$push23=, $pop115, $pop159
	i64.load	$push24=, 0($pop23)
	call    	__addtf3@FUNCTION, $pop119, $pop28, $pop26, $pop27, $pop24
	i32.const	$push120=, 160
	i32.add 	$push121=, $16, $pop120
	i32.const	$push158=, 8
	i32.add 	$push29=, $pop121, $pop158
	i64.load	$4=, 0($pop29)
	i64.load	$5=, 160($16)
	i32.const	$push124=, 144
	i32.add 	$push125=, $16, $pop124
	i64.load	$push32=, 256($16)
	i32.const	$push122=, 256
	i32.add 	$push123=, $16, $pop122
	i32.const	$push157=, 8
	i32.add 	$push30=, $pop123, $pop157
	i64.load	$push31=, 0($pop30)
	call    	__subtf3@FUNCTION, $pop125, $5, $4, $pop32, $pop31
	i32.const	$push156=, 8
	i32.add 	$push33=, $16, $pop156
	i64.load	$8=, 0($pop33)
	i32.const	$push155=, 0
	i64.store	Y1+8($pop155), $8
	i64.load	$9=, 0($16)
	i32.const	$push154=, 0
	i64.store	Y1($pop154), $9
	i32.const	$push153=, 0
	i64.store	S+8($pop153), $4
	i32.const	$push152=, 0
	i64.store	S($pop152), $5
	i32.const	$push126=, 96
	i32.add 	$push127=, $16, $pop126
	i32.const	$push151=, 8
	i32.add 	$push34=, $pop127, $pop151
	i64.load	$12=, 0($pop34)
	i32.const	$push150=, 0
	i64.store	T+8($pop150), $12
	i64.load	$13=, 96($16)
	i32.const	$push149=, 0
	i64.store	T($pop149), $13
	i32.const	$push128=, 32
	i32.add 	$push129=, $16, $pop128
	i32.const	$push148=, 8
	i32.add 	$push35=, $pop129, $pop148
	i64.load	$14=, 0($pop35)
	i32.const	$push147=, 0
	i64.store	R+8($pop147), $14
	i64.load	$15=, 32($16)
	i32.const	$push146=, 0
	i64.store	R($pop146), $15
	i32.const	$push130=, 176
	i32.add 	$push131=, $16, $pop130
	i32.const	$push145=, 8
	i32.add 	$push36=, $pop131, $pop145
	i64.load	$10=, 0($pop36)
	i32.const	$push144=, 0
	i64.store	X+8($pop144), $10
	i64.load	$11=, 176($16)
	i32.const	$push143=, 0
	i64.store	X($pop143), $11
	i32.const	$push132=, 64
	i32.add 	$push133=, $16, $pop132
	i32.const	$push142=, 8
	i32.add 	$push37=, $pop133, $pop142
	i64.load	$3=, 0($pop37)
	i32.const	$push141=, 0
	i64.store	Y+8($pop141), $3
	i64.load	$2=, 64($16)
	i32.const	$push140=, 0
	i64.store	Y($pop140), $2
	i32.const	$push134=, 144
	i32.add 	$push135=, $16, $pop134
	i32.const	$push139=, 8
	i32.add 	$push38=, $pop135, $pop139
	i64.load	$1=, 0($pop38)
	i32.const	$push138=, 0
	i64.store	Z+8($pop138), $1
	i64.load	$0=, 144($16)
	i32.const	$push137=, 0
	i64.store	Z($pop137), $0
	block   	
	i64.const	$push136=, 0
	i64.const	$push39=, 4612354521497075712
	i32.call	$push40=, __netf2@FUNCTION, $7, $6, $pop136, $pop39
	br_if   	0, $pop40       # 0: down to label0
# %bb.1:                                # %entry
	i64.const	$push178=, 0
	i64.const	$push41=, 4613097791357452288
	i32.call	$push42=, __netf2@FUNCTION, $13, $12, $pop178, $pop41
	br_if   	0, $pop42       # 0: down to label0
# %bb.2:                                # %entry
	i64.const	$push179=, 0
	i64.const	$push43=, 4613150567915585536
	i32.call	$push44=, __netf2@FUNCTION, $5, $4, $pop179, $pop43
	br_if   	0, $pop44       # 0: down to label0
# %bb.3:                                # %entry
	i64.const	$push180=, 0
	i64.const	$push45=, 4613517804799262720
	i32.call	$push46=, __netf2@FUNCTION, $15, $14, $pop180, $pop45
	br_if   	0, $pop46       # 0: down to label0
# %bb.4:                                # %entry
	i64.const	$push181=, 0
	i64.const	$push47=, 4613503511148101632
	i32.call	$push48=, __netf2@FUNCTION, $9, $8, $pop181, $pop47
	br_if   	0, $pop48       # 0: down to label0
# %bb.5:                                # %entry
	i64.const	$push182=, 0
	i64.const	$push49=, 4613040616752807936
	i32.call	$push50=, __netf2@FUNCTION, $11, $10, $pop182, $pop49
	br_if   	0, $pop50       # 0: down to label0
# %bb.6:                                # %entry
	i64.const	$push183=, 0
	i64.const	$push51=, 4613110985496985600
	i32.call	$push52=, __netf2@FUNCTION, $0, $1, $pop183, $pop51
	br_if   	0, $pop52       # 0: down to label0
# %bb.7:                                # %entry
	i64.const	$push184=, 0
	i64.const	$push53=, 4612961451915608064
	i32.call	$push54=, __eqtf2@FUNCTION, $2, $3, $pop184, $pop53
	br_if   	0, $pop54       # 0: down to label0
# %bb.8:                                # %if.end
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
