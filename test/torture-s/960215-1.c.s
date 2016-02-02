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
	i64.load	$push1=, C($pop107):p2align=4
	tee_local	$push106=, $2=, $pop1
	i32.const	$push105=, 0
	i64.load	$push0=, C+8($pop105)
	tee_local	$push104=, $3=, $pop0
	i32.const	$push103=, 0
	i64.load	$push3=, U($pop103):p2align=4
	tee_local	$push102=, $15=, $pop3
	i32.const	$push101=, 0
	i64.load	$push2=, U+8($pop101)
	tee_local	$push100=, $14=, $pop2
	i32.const	$18=, 304
	i32.add 	$18=, $56, $18
	call    	__addtf3@FUNCTION, $18, $pop106, $pop104, $pop102, $pop100
	i64.load	$push7=, 304($56)
	tee_local	$push99=, $9=, $pop7
	i32.const	$push4=, 8
	i32.const	$19=, 304
	i32.add 	$19=, $56, $19
	i32.add 	$push5=, $19, $pop4
	i64.load	$push6=, 0($pop5)
	tee_local	$push98=, $8=, $pop6
	i32.const	$push97=, 0
	i64.load	$push9=, Y2($pop97):p2align=4
	tee_local	$push96=, $13=, $pop9
	i32.const	$push95=, 0
	i64.load	$push8=, Y2+8($pop95)
	tee_local	$push94=, $12=, $pop8
	i32.const	$20=, 192
	i32.add 	$20=, $56, $20
	call    	__multf3@FUNCTION, $20, $pop99, $pop98, $pop96, $pop94
	i32.const	$push93=, 8
	i32.const	$21=, 192
	i32.add 	$21=, $56, $21
	i32.add 	$push10=, $21, $pop93
	i64.load	$0=, 0($pop10)
	i64.load	$1=, 192($56)
	i32.const	$22=, 240
	i32.add 	$22=, $56, $22
	call    	__subtf3@FUNCTION, $22, $2, $3, $15, $14
	i64.load	$push13=, 240($56)
	tee_local	$push92=, $11=, $pop13
	i32.const	$push91=, 8
	i32.const	$23=, 240
	i32.add 	$23=, $56, $23
	i32.add 	$push11=, $23, $pop91
	i64.load	$push12=, 0($pop11)
	tee_local	$push90=, $10=, $pop12
	i32.const	$24=, 224
	i32.add 	$24=, $56, $24
	call    	__subtf3@FUNCTION, $24, $pop92, $pop90, $15, $14
	i32.const	$push89=, 8
	i32.const	$25=, 224
	i32.add 	$25=, $56, $25
	i32.add 	$push14=, $25, $pop89
	i64.load	$2=, 0($pop14)
	i64.load	$3=, 224($56)
	i32.const	$26=, 288
	i32.add 	$26=, $56, $26
	call    	__addtf3@FUNCTION, $26, $15, $14, $9, $8
	i32.const	$push88=, 8
	i32.const	$27=, 288
	i32.add 	$27=, $56, $27
	i32.add 	$push15=, $27, $pop88
	i64.load	$4=, 0($pop15)
	i64.load	$5=, 288($56)
	i32.const	$push87=, 0
	i64.load	$push17=, Y1($pop87):p2align=4
	tee_local	$push86=, $9=, $pop17
	i32.const	$push85=, 0
	i64.load	$push16=, Y1+8($pop85)
	tee_local	$push84=, $8=, $pop16
	i32.const	$28=, 112
	i32.add 	$28=, $56, $28
	call    	__multf3@FUNCTION, $28, $11, $10, $pop86, $pop84
	i32.const	$push83=, 8
	i32.const	$29=, 112
	i32.add 	$29=, $56, $29
	i32.add 	$push18=, $29, $pop83
	i64.load	$11=, 0($pop18)
	i64.load	$10=, 112($56)
	i32.const	$30=, 272
	i32.add 	$30=, $56, $30
	call    	__addtf3@FUNCTION, $30, $5, $4, $15, $14
	i64.load	$push21=, 272($56)
	tee_local	$push82=, $7=, $pop21
	i32.const	$push81=, 8
	i32.const	$31=, 272
	i32.add 	$31=, $56, $31
	i32.add 	$push19=, $31, $pop81
	i64.load	$push20=, 0($pop19)
	tee_local	$push80=, $6=, $pop20
	i32.const	$32=, 176
	i32.add 	$32=, $56, $32
	call    	__subtf3@FUNCTION, $32, $1, $0, $pop82, $pop80
	i64.load	$0=, 176($56)
	i32.const	$push79=, 0
	i32.const	$push78=, 8
	i32.const	$33=, 176
	i32.add 	$33=, $56, $33
	i32.add 	$push22=, $33, $pop78
	i64.load	$push23=, 0($pop22)
	i64.store	$discard=, X+8($pop79), $pop23
	i32.const	$push77=, 0
	i64.store	$discard=, X($pop77):p2align=4, $0
	i32.const	$34=, 80
	i32.add 	$34=, $56, $34
	call    	__multf3@FUNCTION, $34, $3, $2, $9, $8
	i32.const	$push76=, 8
	i32.const	$35=, 80
	i32.add 	$35=, $56, $35
	i32.add 	$push24=, $35, $pop76
	i64.load	$0=, 0($pop24)
	i64.load	$1=, 80($56)
	i32.const	$36=, 160
	i32.add 	$36=, $56, $36
	call    	__multf3@FUNCTION, $36, $5, $4, $13, $12
	i64.load	$4=, 160($56)
	i32.const	$push75=, 0
	i32.const	$push74=, 8
	i32.const	$37=, 160
	i32.add 	$37=, $56, $37
	i32.add 	$push25=, $37, $pop74
	i64.load	$push26=, 0($pop25)
	i64.store	$5=, S+8($pop75), $pop26
	i32.const	$push73=, 0
	i64.store	$discard=, S($pop73):p2align=4, $4
	i32.const	$38=, 96
	i32.add 	$38=, $56, $38
	call    	__subtf3@FUNCTION, $38, $10, $11, $3, $2
	i64.load	$11=, 96($56)
	i32.const	$push72=, 0
	i32.const	$push71=, 8
	i32.const	$39=, 96
	i32.add 	$39=, $56, $39
	i32.add 	$push27=, $39, $pop71
	i64.load	$push28=, 0($pop27)
	i64.store	$discard=, T+8($pop72), $pop28
	i32.const	$push70=, 0
	i64.store	$discard=, T($pop70):p2align=4, $11
	i32.const	$40=, 208
	i32.add 	$40=, $56, $40
	call    	__subtf3@FUNCTION, $40, $15, $14, $3, $2
	i64.load	$push31=, 208($56)
	i32.const	$push69=, 8
	i32.const	$41=, 208
	i32.add 	$41=, $56, $41
	i32.add 	$push29=, $41, $pop69
	i64.load	$push30=, 0($pop29)
	i32.const	$42=, 64
	i32.add 	$42=, $56, $42
	call    	__addtf3@FUNCTION, $42, $pop31, $pop30, $1, $0
	i64.load	$2=, 64($56)
	i32.const	$push68=, 0
	i32.const	$push67=, 8
	i32.const	$43=, 64
	i32.add 	$43=, $56, $43
	i32.add 	$push32=, $43, $pop67
	i64.load	$push33=, 0($pop32)
	i64.store	$discard=, Y+8($pop68), $pop33
	i32.const	$push66=, 0
	i64.store	$discard=, Y($pop66):p2align=4, $2
	i32.const	$44=, 256
	i32.add 	$44=, $56, $44
	call    	__addtf3@FUNCTION, $44, $15, $14, $7, $6
	i64.load	$push36=, 256($56)
	i32.const	$push65=, 8
	i32.const	$45=, 256
	i32.add 	$45=, $56, $45
	i32.add 	$push34=, $45, $pop65
	i64.load	$push35=, 0($pop34)
	i32.const	$46=, 144
	i32.add 	$46=, $56, $46
	call    	__subtf3@FUNCTION, $46, $4, $5, $pop36, $pop35
	i64.load	$2=, 144($56)
	i32.const	$push64=, 0
	i32.const	$push63=, 8
	i32.const	$47=, 144
	i32.add 	$47=, $56, $47
	i32.add 	$push37=, $47, $pop63
	i64.load	$push38=, 0($pop37)
	i64.store	$3=, Z+8($pop64), $pop38
	i32.const	$push62=, 0
	i64.store	$discard=, Z($pop62):p2align=4, $2
	i32.const	$48=, 128
	i32.add 	$48=, $56, $48
	call    	__addtf3@FUNCTION, $48, $15, $14, $13, $12
	i64.load	$push41=, 128($56)
	i32.const	$push61=, 8
	i32.const	$49=, 128
	i32.add 	$49=, $56, $49
	i32.add 	$push39=, $49, $pop61
	i64.load	$push40=, 0($pop39)
	i32.const	$50=, 48
	i32.add 	$50=, $56, $50
	call    	__multf3@FUNCTION, $50, $pop41, $pop40, $9, $8
	i32.const	$push60=, 8
	i32.const	$51=, 48
	i32.add 	$51=, $56, $51
	i32.add 	$push42=, $51, $pop60
	i64.load	$15=, 0($pop42)
	i64.load	$14=, 48($56)
	i32.const	$52=, 16
	i32.add 	$52=, $56, $52
	call    	__multf3@FUNCTION, $52, $13, $12, $9, $8
	i32.const	$push59=, 8
	i32.const	$53=, 16
	i32.add 	$53=, $56, $53
	i32.add 	$push43=, $53, $pop59
	i64.load	$9=, 0($pop43)
	i64.load	$8=, 16($56)
	i32.const	$54=, 32
	i32.add 	$54=, $56, $54
	call    	__subtf3@FUNCTION, $54, $14, $15, $13, $12
	i64.load	$15=, 32($56)
	i32.const	$push58=, 0
	i32.const	$push57=, 8
	i32.const	$55=, 32
	i32.add 	$55=, $56, $55
	i32.add 	$push44=, $55, $pop57
	i64.load	$push45=, 0($pop44)
	i64.store	$discard=, R+8($pop58), $pop45
	i32.const	$push56=, 0
	i64.store	$discard=, R($pop56):p2align=4, $15
	i64.const	$push47=, 0
	i64.const	$push46=, -4612248968380809216
	call    	__addtf3@FUNCTION, $56, $8, $9, $pop47, $pop46
	i64.load	$15=, 0($56)
	i32.const	$push55=, 0
	i32.const	$push54=, 8
	i32.add 	$push48=, $56, $pop54
	i64.load	$push49=, 0($pop48)
	i64.store	$discard=, Y1+8($pop55), $pop49
	i32.const	$push53=, 0
	i64.store	$discard=, Y1($pop53):p2align=4, $15
	block
	i64.const	$push52=, 0
	i64.const	$push50=, 4612108230892453888
	i32.call	$push51=, __eqtf2@FUNCTION, $2, $3, $pop52, $pop50
	i32.const	$push109=, 0
	i32.eq  	$push110=, $pop51, $pop109
	br_if   	$pop110, 0      # 0: down to label0
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
