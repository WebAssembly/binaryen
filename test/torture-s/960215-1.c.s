	.text
	.file	"960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push52=, 0
	i32.load	$push51=, __stack_pointer($pop52)
	i32.const	$push53=, 320
	i32.sub 	$12=, $pop51, $pop53
	i32.const	$push54=, 0
	i32.store	__stack_pointer($pop54), $12
	i32.const	$push172=, 0
	i64.load	$0=, U+8($pop172)
	i32.const	$push171=, 0
	i64.load	$1=, U($pop171)
	i32.const	$push170=, 0
	i64.load	$2=, C+8($pop170)
	i32.const	$push169=, 0
	i64.load	$3=, C($pop169)
	i32.const	$push55=, 304
	i32.add 	$push56=, $12, $pop55
	call    	__addtf3@FUNCTION, $pop56, $3, $2, $1, $0
	i32.const	$push57=, 240
	i32.add 	$push58=, $12, $pop57
	call    	__subtf3@FUNCTION, $pop58, $3, $2, $1, $0
	i32.const	$push59=, 304
	i32.add 	$push60=, $12, $pop59
	i32.const	$push0=, 8
	i32.add 	$push1=, $pop60, $pop0
	i64.load	$10=, 0($pop1)
	i64.load	$11=, 304($12)
	i32.const	$push61=, 288
	i32.add 	$push62=, $12, $pop61
	call    	__addtf3@FUNCTION, $pop62, $1, $0, $11, $10
	i32.const	$push168=, 0
	i64.load	$2=, Y2+8($pop168)
	i32.const	$push167=, 0
	i64.load	$3=, Y2($pop167)
	i32.const	$push63=, 128
	i32.add 	$push64=, $12, $pop63
	call    	__addtf3@FUNCTION, $pop64, $1, $0, $3, $2
	i32.const	$push65=, 240
	i32.add 	$push66=, $12, $pop65
	i32.const	$push166=, 8
	i32.add 	$push2=, $pop66, $pop166
	i64.load	$4=, 0($pop2)
	i64.load	$5=, 240($12)
	i32.const	$push67=, 224
	i32.add 	$push68=, $12, $pop67
	call    	__subtf3@FUNCTION, $pop68, $5, $4, $1, $0
	i32.const	$push69=, 288
	i32.add 	$push70=, $12, $pop69
	i32.const	$push165=, 8
	i32.add 	$push3=, $pop70, $pop165
	i64.load	$6=, 0($pop3)
	i64.load	$7=, 288($12)
	i32.const	$push71=, 272
	i32.add 	$push72=, $12, $pop71
	call    	__addtf3@FUNCTION, $pop72, $1, $0, $7, $6
	i32.const	$push164=, 0
	i64.load	$8=, Y1+8($pop164)
	i32.const	$push163=, 0
	i64.load	$9=, Y1($pop163)
	i32.const	$push73=, 16
	i32.add 	$push74=, $12, $pop73
	call    	__multf3@FUNCTION, $pop74, $3, $2, $9, $8
	i32.const	$push75=, 112
	i32.add 	$push76=, $12, $pop75
	call    	__multf3@FUNCTION, $pop76, $5, $4, $9, $8
	i32.const	$push79=, 48
	i32.add 	$push80=, $12, $pop79
	i64.load	$push6=, 128($12)
	i32.const	$push77=, 128
	i32.add 	$push78=, $12, $pop77
	i32.const	$push162=, 8
	i32.add 	$push4=, $pop78, $pop162
	i64.load	$push5=, 0($pop4)
	call    	__multf3@FUNCTION, $pop80, $pop6, $pop5, $9, $8
	i32.const	$push81=, 192
	i32.add 	$push82=, $12, $pop81
	call    	__multf3@FUNCTION, $pop82, $11, $10, $3, $2
	i32.const	$push83=, 224
	i32.add 	$push84=, $12, $pop83
	i32.const	$push161=, 8
	i32.add 	$push7=, $pop84, $pop161
	i64.load	$10=, 0($pop7)
	i64.load	$11=, 224($12)
	i32.const	$push85=, 80
	i32.add 	$push86=, $12, $pop85
	call    	__multf3@FUNCTION, $pop86, $11, $10, $9, $8
	i32.const	$push87=, 208
	i32.add 	$push88=, $12, $pop87
	call    	__subtf3@FUNCTION, $pop88, $1, $0, $11, $10
	i32.const	$push89=, 160
	i32.add 	$push90=, $12, $pop89
	call    	__multf3@FUNCTION, $pop90, $3, $2, $7, $6
	i32.const	$push91=, 272
	i32.add 	$push92=, $12, $pop91
	i32.const	$push160=, 8
	i32.add 	$push8=, $pop92, $pop160
	i64.load	$8=, 0($pop8)
	i64.load	$9=, 272($12)
	i32.const	$push93=, 256
	i32.add 	$push94=, $12, $pop93
	call    	__addtf3@FUNCTION, $pop94, $1, $0, $9, $8
	i64.load	$push13=, 16($12)
	i32.const	$push95=, 16
	i32.add 	$push96=, $12, $pop95
	i32.const	$push159=, 8
	i32.add 	$push9=, $pop96, $pop159
	i64.load	$push10=, 0($pop9)
	i64.const	$push12=, 0
	i64.const	$push11=, -4612248968380809216
	call    	__addtf3@FUNCTION, $12, $pop13, $pop10, $pop12, $pop11
	i32.const	$push99=, 96
	i32.add 	$push100=, $12, $pop99
	i64.load	$push16=, 112($12)
	i32.const	$push97=, 112
	i32.add 	$push98=, $12, $pop97
	i32.const	$push158=, 8
	i32.add 	$push14=, $pop98, $pop158
	i64.load	$push15=, 0($pop14)
	call    	__subtf3@FUNCTION, $pop100, $pop16, $pop15, $11, $10
	i32.const	$push103=, 32
	i32.add 	$push104=, $12, $pop103
	i64.load	$push19=, 48($12)
	i32.const	$push101=, 48
	i32.add 	$push102=, $12, $pop101
	i32.const	$push157=, 8
	i32.add 	$push17=, $pop102, $pop157
	i64.load	$push18=, 0($pop17)
	call    	__subtf3@FUNCTION, $pop104, $pop19, $pop18, $3, $2
	i32.const	$push107=, 176
	i32.add 	$push108=, $12, $pop107
	i64.load	$push22=, 192($12)
	i32.const	$push105=, 192
	i32.add 	$push106=, $12, $pop105
	i32.const	$push156=, 8
	i32.add 	$push20=, $pop106, $pop156
	i64.load	$push21=, 0($pop20)
	call    	__subtf3@FUNCTION, $pop108, $pop22, $pop21, $9, $8
	i32.const	$push113=, 64
	i32.add 	$push114=, $12, $pop113
	i64.load	$push28=, 208($12)
	i32.const	$push111=, 208
	i32.add 	$push112=, $12, $pop111
	i32.const	$push155=, 8
	i32.add 	$push25=, $pop112, $pop155
	i64.load	$push26=, 0($pop25)
	i64.load	$push27=, 80($12)
	i32.const	$push109=, 80
	i32.add 	$push110=, $12, $pop109
	i32.const	$push154=, 8
	i32.add 	$push23=, $pop110, $pop154
	i64.load	$push24=, 0($pop23)
	call    	__addtf3@FUNCTION, $pop114, $pop28, $pop26, $pop27, $pop24
	i32.const	$push115=, 160
	i32.add 	$push116=, $12, $pop115
	i32.const	$push153=, 8
	i32.add 	$push29=, $pop116, $pop153
	i64.load	$0=, 0($pop29)
	i64.load	$1=, 160($12)
	i32.const	$push119=, 144
	i32.add 	$push120=, $12, $pop119
	i64.load	$push32=, 256($12)
	i32.const	$push117=, 256
	i32.add 	$push118=, $12, $pop117
	i32.const	$push152=, 8
	i32.add 	$push30=, $pop118, $pop152
	i64.load	$push31=, 0($pop30)
	call    	__subtf3@FUNCTION, $pop120, $1, $0, $pop32, $pop31
	i32.const	$push151=, 0
	i32.const	$push150=, 8
	i32.add 	$push33=, $12, $pop150
	i64.load	$push34=, 0($pop33)
	i64.store	Y1+8($pop151), $pop34
	i32.const	$push149=, 0
	i64.load	$push35=, 0($12)
	i64.store	Y1($pop149), $pop35
	i32.const	$push148=, 0
	i64.store	S+8($pop148), $0
	i32.const	$push147=, 0
	i64.store	S($pop147), $1
	i32.const	$push146=, 0
	i32.const	$push121=, 96
	i32.add 	$push122=, $12, $pop121
	i32.const	$push145=, 8
	i32.add 	$push36=, $pop122, $pop145
	i64.load	$push37=, 0($pop36)
	i64.store	T+8($pop146), $pop37
	i32.const	$push144=, 0
	i64.load	$push38=, 96($12)
	i64.store	T($pop144), $pop38
	i32.const	$push143=, 0
	i32.const	$push123=, 32
	i32.add 	$push124=, $12, $pop123
	i32.const	$push142=, 8
	i32.add 	$push39=, $pop124, $pop142
	i64.load	$push40=, 0($pop39)
	i64.store	R+8($pop143), $pop40
	i32.const	$push141=, 0
	i64.load	$push41=, 32($12)
	i64.store	R($pop141), $pop41
	i32.const	$push140=, 0
	i32.const	$push125=, 176
	i32.add 	$push126=, $12, $pop125
	i32.const	$push139=, 8
	i32.add 	$push42=, $pop126, $pop139
	i64.load	$push43=, 0($pop42)
	i64.store	X+8($pop140), $pop43
	i32.const	$push138=, 0
	i64.load	$push44=, 176($12)
	i64.store	X($pop138), $pop44
	i32.const	$push137=, 0
	i32.const	$push127=, 64
	i32.add 	$push128=, $12, $pop127
	i32.const	$push136=, 8
	i32.add 	$push45=, $pop128, $pop136
	i64.load	$push46=, 0($pop45)
	i64.store	Y+8($pop137), $pop46
	i32.const	$push135=, 0
	i64.load	$push47=, 64($12)
	i64.store	Y($pop135), $pop47
	i32.const	$push129=, 144
	i32.add 	$push130=, $12, $pop129
	i32.const	$push134=, 8
	i32.add 	$push48=, $pop130, $pop134
	i64.load	$0=, 0($pop48)
	i32.const	$push133=, 0
	i64.store	Z+8($pop133), $0
	i64.load	$1=, 144($12)
	i32.const	$push132=, 0
	i64.store	Z($pop132), $1
	block   	
	i64.const	$push131=, 0
	i64.const	$push49=, 4612108230892453888
	i32.call	$push50=, __eqtf2@FUNCTION, $1, $0, $pop131, $pop49
	i32.eqz 	$push174=, $pop50
	br_if   	0, $pop174      # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push173=, 0
	call    	exit@FUNCTION, $pop173
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
