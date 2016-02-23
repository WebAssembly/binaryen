	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push109=, __stack_pointer
	i32.load	$push110=, 0($pop109)
	i32.const	$push111=, 320
	i32.sub 	$54=, $pop110, $pop111
	i32.const	$push112=, __stack_pointer
	i32.store	$discard=, 0($pop112), $54
	i32.const	$push107=, 0
	i64.load	$push106=, C($pop107):p2align=4
	tee_local	$push105=, $2=, $pop106
	i32.const	$push104=, 0
	i64.load	$push103=, C+8($pop104)
	tee_local	$push102=, $3=, $pop103
	i32.const	$push101=, 0
	i64.load	$push100=, U($pop101):p2align=4
	tee_local	$push99=, $15=, $pop100
	i32.const	$push98=, 0
	i64.load	$push97=, U+8($pop98)
	tee_local	$push96=, $14=, $pop97
	i32.const	$16=, 304
	i32.add 	$16=, $54, $16
	call    	__addtf3@FUNCTION, $16, $pop105, $pop102, $pop99, $pop96
	i64.load	$push95=, 304($54)
	tee_local	$push94=, $9=, $pop95
	i32.const	$push0=, 8
	i32.const	$17=, 304
	i32.add 	$17=, $54, $17
	i32.add 	$push1=, $17, $pop0
	i64.load	$push93=, 0($pop1)
	tee_local	$push92=, $8=, $pop93
	i32.const	$push91=, 0
	i64.load	$push90=, Y2($pop91):p2align=4
	tee_local	$push89=, $13=, $pop90
	i32.const	$push88=, 0
	i64.load	$push87=, Y2+8($pop88)
	tee_local	$push86=, $12=, $pop87
	i32.const	$18=, 192
	i32.add 	$18=, $54, $18
	call    	__multf3@FUNCTION, $18, $pop94, $pop92, $pop89, $pop86
	i32.const	$push85=, 8
	i32.const	$19=, 192
	i32.add 	$19=, $54, $19
	i32.add 	$push2=, $19, $pop85
	i64.load	$0=, 0($pop2)
	i64.load	$1=, 192($54)
	i32.const	$20=, 240
	i32.add 	$20=, $54, $20
	call    	__subtf3@FUNCTION, $20, $2, $3, $15, $14
	i64.load	$push84=, 240($54)
	tee_local	$push83=, $11=, $pop84
	i32.const	$push82=, 8
	i32.const	$21=, 240
	i32.add 	$21=, $54, $21
	i32.add 	$push3=, $21, $pop82
	i64.load	$push81=, 0($pop3)
	tee_local	$push80=, $10=, $pop81
	i32.const	$22=, 224
	i32.add 	$22=, $54, $22
	call    	__subtf3@FUNCTION, $22, $pop83, $pop80, $15, $14
	i32.const	$push79=, 8
	i32.const	$23=, 224
	i32.add 	$23=, $54, $23
	i32.add 	$push4=, $23, $pop79
	i64.load	$2=, 0($pop4)
	i64.load	$3=, 224($54)
	i32.const	$24=, 288
	i32.add 	$24=, $54, $24
	call    	__addtf3@FUNCTION, $24, $15, $14, $9, $8
	i32.const	$push78=, 8
	i32.const	$25=, 288
	i32.add 	$25=, $54, $25
	i32.add 	$push5=, $25, $pop78
	i64.load	$4=, 0($pop5)
	i64.load	$5=, 288($54)
	i32.const	$push77=, 0
	i64.load	$push76=, Y1($pop77):p2align=4
	tee_local	$push75=, $9=, $pop76
	i32.const	$push74=, 0
	i64.load	$push73=, Y1+8($pop74)
	tee_local	$push72=, $8=, $pop73
	i32.const	$26=, 112
	i32.add 	$26=, $54, $26
	call    	__multf3@FUNCTION, $26, $11, $10, $pop75, $pop72
	i32.const	$push71=, 8
	i32.const	$27=, 112
	i32.add 	$27=, $54, $27
	i32.add 	$push6=, $27, $pop71
	i64.load	$11=, 0($pop6)
	i64.load	$10=, 112($54)
	i32.const	$28=, 272
	i32.add 	$28=, $54, $28
	call    	__addtf3@FUNCTION, $28, $5, $4, $15, $14
	i64.load	$push70=, 272($54)
	tee_local	$push69=, $7=, $pop70
	i32.const	$push68=, 8
	i32.const	$29=, 272
	i32.add 	$29=, $54, $29
	i32.add 	$push7=, $29, $pop68
	i64.load	$push67=, 0($pop7)
	tee_local	$push66=, $6=, $pop67
	i32.const	$30=, 176
	i32.add 	$30=, $54, $30
	call    	__subtf3@FUNCTION, $30, $1, $0, $pop69, $pop66
	i64.load	$0=, 176($54)
	i32.const	$push65=, 0
	i32.const	$push64=, 8
	i32.const	$31=, 176
	i32.add 	$31=, $54, $31
	i32.add 	$push8=, $31, $pop64
	i64.load	$push9=, 0($pop8)
	i64.store	$discard=, X+8($pop65), $pop9
	i32.const	$push63=, 0
	i64.store	$discard=, X($pop63):p2align=4, $0
	i32.const	$32=, 80
	i32.add 	$32=, $54, $32
	call    	__multf3@FUNCTION, $32, $3, $2, $9, $8
	i32.const	$push62=, 8
	i32.const	$33=, 80
	i32.add 	$33=, $54, $33
	i32.add 	$push10=, $33, $pop62
	i64.load	$0=, 0($pop10)
	i64.load	$1=, 80($54)
	i32.const	$34=, 160
	i32.add 	$34=, $54, $34
	call    	__multf3@FUNCTION, $34, $5, $4, $13, $12
	i64.load	$4=, 160($54)
	i32.const	$push61=, 0
	i32.const	$push60=, 8
	i32.const	$35=, 160
	i32.add 	$35=, $54, $35
	i32.add 	$push11=, $35, $pop60
	i64.load	$push12=, 0($pop11)
	i64.store	$5=, S+8($pop61), $pop12
	i32.const	$push59=, 0
	i64.store	$discard=, S($pop59):p2align=4, $4
	i32.const	$36=, 96
	i32.add 	$36=, $54, $36
	call    	__subtf3@FUNCTION, $36, $10, $11, $3, $2
	i64.load	$11=, 96($54)
	i32.const	$push58=, 0
	i32.const	$push57=, 8
	i32.const	$37=, 96
	i32.add 	$37=, $54, $37
	i32.add 	$push13=, $37, $pop57
	i64.load	$push14=, 0($pop13)
	i64.store	$discard=, T+8($pop58), $pop14
	i32.const	$push56=, 0
	i64.store	$discard=, T($pop56):p2align=4, $11
	i32.const	$38=, 208
	i32.add 	$38=, $54, $38
	call    	__subtf3@FUNCTION, $38, $15, $14, $3, $2
	i64.load	$push17=, 208($54)
	i32.const	$push55=, 8
	i32.const	$39=, 208
	i32.add 	$39=, $54, $39
	i32.add 	$push15=, $39, $pop55
	i64.load	$push16=, 0($pop15)
	i32.const	$40=, 64
	i32.add 	$40=, $54, $40
	call    	__addtf3@FUNCTION, $40, $pop17, $pop16, $1, $0
	i64.load	$2=, 64($54)
	i32.const	$push54=, 0
	i32.const	$push53=, 8
	i32.const	$41=, 64
	i32.add 	$41=, $54, $41
	i32.add 	$push18=, $41, $pop53
	i64.load	$push19=, 0($pop18)
	i64.store	$discard=, Y+8($pop54), $pop19
	i32.const	$push52=, 0
	i64.store	$discard=, Y($pop52):p2align=4, $2
	i32.const	$42=, 256
	i32.add 	$42=, $54, $42
	call    	__addtf3@FUNCTION, $42, $15, $14, $7, $6
	i64.load	$push22=, 256($54)
	i32.const	$push51=, 8
	i32.const	$43=, 256
	i32.add 	$43=, $54, $43
	i32.add 	$push20=, $43, $pop51
	i64.load	$push21=, 0($pop20)
	i32.const	$44=, 144
	i32.add 	$44=, $54, $44
	call    	__subtf3@FUNCTION, $44, $4, $5, $pop22, $pop21
	i64.load	$2=, 144($54)
	i32.const	$push50=, 0
	i32.const	$push49=, 8
	i32.const	$45=, 144
	i32.add 	$45=, $54, $45
	i32.add 	$push23=, $45, $pop49
	i64.load	$push24=, 0($pop23)
	i64.store	$3=, Z+8($pop50), $pop24
	i32.const	$push48=, 0
	i64.store	$discard=, Z($pop48):p2align=4, $2
	i32.const	$46=, 128
	i32.add 	$46=, $54, $46
	call    	__addtf3@FUNCTION, $46, $15, $14, $13, $12
	i64.load	$push27=, 128($54)
	i32.const	$push47=, 8
	i32.const	$47=, 128
	i32.add 	$47=, $54, $47
	i32.add 	$push25=, $47, $pop47
	i64.load	$push26=, 0($pop25)
	i32.const	$48=, 48
	i32.add 	$48=, $54, $48
	call    	__multf3@FUNCTION, $48, $pop27, $pop26, $9, $8
	i32.const	$push46=, 8
	i32.const	$49=, 48
	i32.add 	$49=, $54, $49
	i32.add 	$push28=, $49, $pop46
	i64.load	$15=, 0($pop28)
	i64.load	$14=, 48($54)
	i32.const	$50=, 16
	i32.add 	$50=, $54, $50
	call    	__multf3@FUNCTION, $50, $13, $12, $9, $8
	i32.const	$push45=, 8
	i32.const	$51=, 16
	i32.add 	$51=, $54, $51
	i32.add 	$push29=, $51, $pop45
	i64.load	$9=, 0($pop29)
	i64.load	$8=, 16($54)
	i32.const	$52=, 32
	i32.add 	$52=, $54, $52
	call    	__subtf3@FUNCTION, $52, $14, $15, $13, $12
	i64.load	$15=, 32($54)
	i32.const	$push44=, 0
	i32.const	$push43=, 8
	i32.const	$53=, 32
	i32.add 	$53=, $54, $53
	i32.add 	$push30=, $53, $pop43
	i64.load	$push31=, 0($pop30)
	i64.store	$discard=, R+8($pop44), $pop31
	i32.const	$push42=, 0
	i64.store	$discard=, R($pop42):p2align=4, $15
	i64.const	$push33=, 0
	i64.const	$push32=, -4612248968380809216
	call    	__addtf3@FUNCTION, $54, $8, $9, $pop33, $pop32
	i64.load	$15=, 0($54)
	i32.const	$push41=, 0
	i32.const	$push40=, 8
	i32.add 	$push34=, $54, $pop40
	i64.load	$push35=, 0($pop34)
	i64.store	$discard=, Y1+8($pop41), $pop35
	i32.const	$push39=, 0
	i64.store	$discard=, Y1($pop39):p2align=4, $15
	block
	i64.const	$push38=, 0
	i64.const	$push36=, 4612108230892453888
	i32.call	$push37=, __eqtf2@FUNCTION, $2, $3, $pop38, $pop36
	i32.const	$push113=, 0
	i32.eq  	$push114=, $pop37, $pop113
	br_if   	0, $pop114      # 0: down to label0
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
