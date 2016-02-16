	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 320
	i32.sub 	$56=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$56=, 0($17), $56
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
	i32.const	$18=, 304
	i32.add 	$18=, $56, $18
	call    	__addtf3@FUNCTION, $18, $pop105, $pop102, $pop99, $pop96
	i64.load	$push95=, 304($56)
	tee_local	$push94=, $9=, $pop95
	i32.const	$push0=, 8
	i32.const	$19=, 304
	i32.add 	$19=, $56, $19
	i32.add 	$push1=, $19, $pop0
	i64.load	$push93=, 0($pop1)
	tee_local	$push92=, $8=, $pop93
	i32.const	$push91=, 0
	i64.load	$push90=, Y2($pop91):p2align=4
	tee_local	$push89=, $13=, $pop90
	i32.const	$push88=, 0
	i64.load	$push87=, Y2+8($pop88)
	tee_local	$push86=, $12=, $pop87
	i32.const	$20=, 192
	i32.add 	$20=, $56, $20
	call    	__multf3@FUNCTION, $20, $pop94, $pop92, $pop89, $pop86
	i32.const	$push85=, 8
	i32.const	$21=, 192
	i32.add 	$21=, $56, $21
	i32.add 	$push2=, $21, $pop85
	i64.load	$0=, 0($pop2)
	i64.load	$1=, 192($56)
	i32.const	$22=, 240
	i32.add 	$22=, $56, $22
	call    	__subtf3@FUNCTION, $22, $2, $3, $15, $14
	i64.load	$push84=, 240($56)
	tee_local	$push83=, $11=, $pop84
	i32.const	$push82=, 8
	i32.const	$23=, 240
	i32.add 	$23=, $56, $23
	i32.add 	$push3=, $23, $pop82
	i64.load	$push81=, 0($pop3)
	tee_local	$push80=, $10=, $pop81
	i32.const	$24=, 224
	i32.add 	$24=, $56, $24
	call    	__subtf3@FUNCTION, $24, $pop83, $pop80, $15, $14
	i32.const	$push79=, 8
	i32.const	$25=, 224
	i32.add 	$25=, $56, $25
	i32.add 	$push4=, $25, $pop79
	i64.load	$2=, 0($pop4)
	i64.load	$3=, 224($56)
	i32.const	$26=, 288
	i32.add 	$26=, $56, $26
	call    	__addtf3@FUNCTION, $26, $15, $14, $9, $8
	i32.const	$push78=, 8
	i32.const	$27=, 288
	i32.add 	$27=, $56, $27
	i32.add 	$push5=, $27, $pop78
	i64.load	$4=, 0($pop5)
	i64.load	$5=, 288($56)
	i32.const	$push77=, 0
	i64.load	$push76=, Y1($pop77):p2align=4
	tee_local	$push75=, $9=, $pop76
	i32.const	$push74=, 0
	i64.load	$push73=, Y1+8($pop74)
	tee_local	$push72=, $8=, $pop73
	i32.const	$28=, 112
	i32.add 	$28=, $56, $28
	call    	__multf3@FUNCTION, $28, $11, $10, $pop75, $pop72
	i32.const	$push71=, 8
	i32.const	$29=, 112
	i32.add 	$29=, $56, $29
	i32.add 	$push6=, $29, $pop71
	i64.load	$11=, 0($pop6)
	i64.load	$10=, 112($56)
	i32.const	$30=, 272
	i32.add 	$30=, $56, $30
	call    	__addtf3@FUNCTION, $30, $5, $4, $15, $14
	i64.load	$push70=, 272($56)
	tee_local	$push69=, $7=, $pop70
	i32.const	$push68=, 8
	i32.const	$31=, 272
	i32.add 	$31=, $56, $31
	i32.add 	$push7=, $31, $pop68
	i64.load	$push67=, 0($pop7)
	tee_local	$push66=, $6=, $pop67
	i32.const	$32=, 176
	i32.add 	$32=, $56, $32
	call    	__subtf3@FUNCTION, $32, $1, $0, $pop69, $pop66
	i64.load	$0=, 176($56)
	i32.const	$push65=, 0
	i32.const	$push64=, 8
	i32.const	$33=, 176
	i32.add 	$33=, $56, $33
	i32.add 	$push8=, $33, $pop64
	i64.load	$push9=, 0($pop8)
	i64.store	$discard=, X+8($pop65), $pop9
	i32.const	$push63=, 0
	i64.store	$discard=, X($pop63):p2align=4, $0
	i32.const	$34=, 80
	i32.add 	$34=, $56, $34
	call    	__multf3@FUNCTION, $34, $3, $2, $9, $8
	i32.const	$push62=, 8
	i32.const	$35=, 80
	i32.add 	$35=, $56, $35
	i32.add 	$push10=, $35, $pop62
	i64.load	$0=, 0($pop10)
	i64.load	$1=, 80($56)
	i32.const	$36=, 160
	i32.add 	$36=, $56, $36
	call    	__multf3@FUNCTION, $36, $5, $4, $13, $12
	i64.load	$4=, 160($56)
	i32.const	$push61=, 0
	i32.const	$push60=, 8
	i32.const	$37=, 160
	i32.add 	$37=, $56, $37
	i32.add 	$push11=, $37, $pop60
	i64.load	$push12=, 0($pop11)
	i64.store	$5=, S+8($pop61), $pop12
	i32.const	$push59=, 0
	i64.store	$discard=, S($pop59):p2align=4, $4
	i32.const	$38=, 96
	i32.add 	$38=, $56, $38
	call    	__subtf3@FUNCTION, $38, $10, $11, $3, $2
	i64.load	$11=, 96($56)
	i32.const	$push58=, 0
	i32.const	$push57=, 8
	i32.const	$39=, 96
	i32.add 	$39=, $56, $39
	i32.add 	$push13=, $39, $pop57
	i64.load	$push14=, 0($pop13)
	i64.store	$discard=, T+8($pop58), $pop14
	i32.const	$push56=, 0
	i64.store	$discard=, T($pop56):p2align=4, $11
	i32.const	$40=, 208
	i32.add 	$40=, $56, $40
	call    	__subtf3@FUNCTION, $40, $15, $14, $3, $2
	i64.load	$push17=, 208($56)
	i32.const	$push55=, 8
	i32.const	$41=, 208
	i32.add 	$41=, $56, $41
	i32.add 	$push15=, $41, $pop55
	i64.load	$push16=, 0($pop15)
	i32.const	$42=, 64
	i32.add 	$42=, $56, $42
	call    	__addtf3@FUNCTION, $42, $pop17, $pop16, $1, $0
	i64.load	$2=, 64($56)
	i32.const	$push54=, 0
	i32.const	$push53=, 8
	i32.const	$43=, 64
	i32.add 	$43=, $56, $43
	i32.add 	$push18=, $43, $pop53
	i64.load	$push19=, 0($pop18)
	i64.store	$discard=, Y+8($pop54), $pop19
	i32.const	$push52=, 0
	i64.store	$discard=, Y($pop52):p2align=4, $2
	i32.const	$44=, 256
	i32.add 	$44=, $56, $44
	call    	__addtf3@FUNCTION, $44, $15, $14, $7, $6
	i64.load	$push22=, 256($56)
	i32.const	$push51=, 8
	i32.const	$45=, 256
	i32.add 	$45=, $56, $45
	i32.add 	$push20=, $45, $pop51
	i64.load	$push21=, 0($pop20)
	i32.const	$46=, 144
	i32.add 	$46=, $56, $46
	call    	__subtf3@FUNCTION, $46, $4, $5, $pop22, $pop21
	i64.load	$2=, 144($56)
	i32.const	$push50=, 0
	i32.const	$push49=, 8
	i32.const	$47=, 144
	i32.add 	$47=, $56, $47
	i32.add 	$push23=, $47, $pop49
	i64.load	$push24=, 0($pop23)
	i64.store	$3=, Z+8($pop50), $pop24
	i32.const	$push48=, 0
	i64.store	$discard=, Z($pop48):p2align=4, $2
	i32.const	$48=, 128
	i32.add 	$48=, $56, $48
	call    	__addtf3@FUNCTION, $48, $15, $14, $13, $12
	i64.load	$push27=, 128($56)
	i32.const	$push47=, 8
	i32.const	$49=, 128
	i32.add 	$49=, $56, $49
	i32.add 	$push25=, $49, $pop47
	i64.load	$push26=, 0($pop25)
	i32.const	$50=, 48
	i32.add 	$50=, $56, $50
	call    	__multf3@FUNCTION, $50, $pop27, $pop26, $9, $8
	i32.const	$push46=, 8
	i32.const	$51=, 48
	i32.add 	$51=, $56, $51
	i32.add 	$push28=, $51, $pop46
	i64.load	$15=, 0($pop28)
	i64.load	$14=, 48($56)
	i32.const	$52=, 16
	i32.add 	$52=, $56, $52
	call    	__multf3@FUNCTION, $52, $13, $12, $9, $8
	i32.const	$push45=, 8
	i32.const	$53=, 16
	i32.add 	$53=, $56, $53
	i32.add 	$push29=, $53, $pop45
	i64.load	$9=, 0($pop29)
	i64.load	$8=, 16($56)
	i32.const	$54=, 32
	i32.add 	$54=, $56, $54
	call    	__subtf3@FUNCTION, $54, $14, $15, $13, $12
	i64.load	$15=, 32($56)
	i32.const	$push44=, 0
	i32.const	$push43=, 8
	i32.const	$55=, 32
	i32.add 	$55=, $56, $55
	i32.add 	$push30=, $55, $pop43
	i64.load	$push31=, 0($pop30)
	i64.store	$discard=, R+8($pop44), $pop31
	i32.const	$push42=, 0
	i64.store	$discard=, R($pop42):p2align=4, $15
	i64.const	$push33=, 0
	i64.const	$push32=, -4612248968380809216
	call    	__addtf3@FUNCTION, $56, $8, $9, $pop33, $pop32
	i64.load	$15=, 0($56)
	i32.const	$push41=, 0
	i32.const	$push40=, 8
	i32.add 	$push34=, $56, $pop40
	i64.load	$push35=, 0($pop34)
	i64.store	$discard=, Y1+8($pop41), $pop35
	i32.const	$push39=, 0
	i64.store	$discard=, Y1($pop39):p2align=4, $15
	block
	i64.const	$push38=, 0
	i64.const	$push36=, 4612108230892453888
	i32.call	$push37=, __eqtf2@FUNCTION, $2, $3, $pop38, $pop36
	i32.const	$push109=, 0
	i32.eq  	$push110=, $pop37, $pop109
	br_if   	0, $pop110      # 0: down to label0
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
