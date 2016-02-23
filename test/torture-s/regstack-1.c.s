	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/regstack-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push130=, __stack_pointer
	i32.load	$push131=, 0($pop130)
	i32.const	$push132=, 320
	i32.sub 	$56=, $pop131, $pop132
	i32.const	$push133=, __stack_pointer
	i32.store	$discard=, 0($pop133), $56
	i32.const	$push7=, 0
	i64.load	$push122=, C($pop7):p2align=4
	tee_local	$push121=, $2=, $pop122
	i32.const	$push120=, 0
	i64.load	$push119=, C+8($pop120)
	tee_local	$push118=, $3=, $pop119
	i32.const	$push117=, 0
	i64.load	$push116=, U($pop117):p2align=4
	tee_local	$push115=, $17=, $pop116
	i32.const	$push114=, 0
	i64.load	$push113=, U+8($pop114)
	tee_local	$push112=, $16=, $pop113
	i32.const	$18=, 304
	i32.add 	$18=, $56, $18
	call    	__addtf3@FUNCTION, $18, $pop121, $pop118, $pop115, $pop112
	i64.load	$push111=, 304($56)
	tee_local	$push110=, $11=, $pop111
	i32.const	$push8=, 8
	i32.const	$19=, 304
	i32.add 	$19=, $56, $19
	i32.add 	$push9=, $19, $pop8
	i64.load	$push109=, 0($pop9)
	tee_local	$push108=, $10=, $pop109
	i32.const	$push107=, 0
	i64.load	$push106=, Y2($pop107):p2align=4
	tee_local	$push105=, $15=, $pop106
	i32.const	$push104=, 0
	i64.load	$push103=, Y2+8($pop104)
	tee_local	$push102=, $14=, $pop103
	i32.const	$20=, 192
	i32.add 	$20=, $56, $20
	call    	__multf3@FUNCTION, $20, $pop110, $pop108, $pop105, $pop102
	i32.const	$push101=, 8
	i32.const	$21=, 192
	i32.add 	$21=, $56, $21
	i32.add 	$push10=, $21, $pop101
	i64.load	$0=, 0($pop10)
	i64.load	$1=, 192($56)
	i32.const	$22=, 240
	i32.add 	$22=, $56, $22
	call    	__subtf3@FUNCTION, $22, $2, $3, $17, $16
	i64.load	$push100=, 240($56)
	tee_local	$push99=, $13=, $pop100
	i32.const	$push98=, 8
	i32.const	$23=, 240
	i32.add 	$23=, $56, $23
	i32.add 	$push11=, $23, $pop98
	i64.load	$push97=, 0($pop11)
	tee_local	$push96=, $12=, $pop97
	i32.const	$24=, 224
	i32.add 	$24=, $56, $24
	call    	__subtf3@FUNCTION, $24, $pop99, $pop96, $17, $16
	i32.const	$push95=, 8
	i32.const	$25=, 224
	i32.add 	$25=, $56, $25
	i32.add 	$push12=, $25, $pop95
	i64.load	$2=, 0($pop12)
	i64.load	$3=, 224($56)
	i32.const	$26=, 288
	i32.add 	$26=, $56, $26
	call    	__addtf3@FUNCTION, $26, $17, $16, $11, $10
	i32.const	$push94=, 8
	i32.const	$27=, 288
	i32.add 	$27=, $56, $27
	i32.add 	$push13=, $27, $pop94
	i64.load	$4=, 0($pop13)
	i64.load	$5=, 288($56)
	i32.const	$push93=, 0
	i64.load	$push92=, Y1($pop93):p2align=4
	tee_local	$push91=, $11=, $pop92
	i32.const	$push90=, 0
	i64.load	$push89=, Y1+8($pop90)
	tee_local	$push88=, $10=, $pop89
	i32.const	$28=, 112
	i32.add 	$28=, $56, $28
	call    	__multf3@FUNCTION, $28, $13, $12, $pop91, $pop88
	i32.const	$push87=, 8
	i32.const	$29=, 112
	i32.add 	$29=, $56, $29
	i32.add 	$push14=, $29, $pop87
	i64.load	$13=, 0($pop14)
	i64.load	$12=, 112($56)
	i32.const	$30=, 272
	i32.add 	$30=, $56, $30
	call    	__addtf3@FUNCTION, $30, $5, $4, $17, $16
	i64.load	$push86=, 272($56)
	tee_local	$push85=, $9=, $pop86
	i32.const	$push84=, 8
	i32.const	$31=, 272
	i32.add 	$31=, $56, $31
	i32.add 	$push15=, $31, $pop84
	i64.load	$push83=, 0($pop15)
	tee_local	$push82=, $8=, $pop83
	i32.const	$32=, 176
	i32.add 	$32=, $56, $32
	call    	__subtf3@FUNCTION, $32, $1, $0, $pop85, $pop82
	i64.load	$0=, 176($56)
	i32.const	$push81=, 0
	i32.const	$push80=, 8
	i32.const	$33=, 176
	i32.add 	$33=, $56, $33
	i32.add 	$push16=, $33, $pop80
	i64.load	$push6=, 0($pop16)
	i64.store	$6=, X+8($pop81), $pop6
	i32.const	$push79=, 0
	i64.store	$7=, X($pop79):p2align=4, $0
	i32.const	$34=, 80
	i32.add 	$34=, $56, $34
	call    	__multf3@FUNCTION, $34, $3, $2, $11, $10
	i32.const	$push78=, 8
	i32.const	$35=, 80
	i32.add 	$35=, $56, $35
	i32.add 	$push17=, $35, $pop78
	i64.load	$0=, 0($pop17)
	i64.load	$1=, 80($56)
	i32.const	$36=, 160
	i32.add 	$36=, $56, $36
	call    	__multf3@FUNCTION, $36, $5, $4, $15, $14
	i64.load	$5=, 160($56)
	i32.const	$push77=, 0
	i32.const	$push76=, 8
	i32.const	$37=, 160
	i32.add 	$37=, $56, $37
	i32.add 	$push18=, $37, $pop76
	i64.load	$push1=, 0($pop18)
	i64.store	$4=, S+8($pop77), $pop1
	i32.const	$push75=, 0
	i64.store	$discard=, S($pop75):p2align=4, $5
	i32.const	$38=, 96
	i32.add 	$38=, $56, $38
	call    	__subtf3@FUNCTION, $38, $12, $13, $3, $2
	i64.load	$13=, 96($56)
	i32.const	$push74=, 0
	i32.const	$push73=, 8
	i32.const	$39=, 96
	i32.add 	$39=, $56, $39
	i32.add 	$push19=, $39, $pop73
	i64.load	$push0=, 0($pop19)
	i64.store	$12=, T+8($pop74), $pop0
	i32.const	$push72=, 0
	i64.store	$discard=, T($pop72):p2align=4, $13
	i32.const	$40=, 208
	i32.add 	$40=, $56, $40
	call    	__subtf3@FUNCTION, $40, $17, $16, $3, $2
	i64.load	$push22=, 208($56)
	i32.const	$push71=, 8
	i32.const	$41=, 208
	i32.add 	$41=, $56, $41
	i32.add 	$push20=, $41, $pop71
	i64.load	$push21=, 0($pop20)
	i32.const	$42=, 64
	i32.add 	$42=, $56, $42
	call    	__addtf3@FUNCTION, $42, $pop22, $pop21, $1, $0
	i64.load	$2=, 64($56)
	i32.const	$push70=, 0
	i32.const	$push69=, 8
	i32.const	$43=, 64
	i32.add 	$43=, $56, $43
	i32.add 	$push23=, $43, $pop69
	i64.load	$push5=, 0($pop23)
	i64.store	$0=, Y+8($pop70), $pop5
	i32.const	$push68=, 0
	i64.store	$1=, Y($pop68):p2align=4, $2
	i32.const	$44=, 256
	i32.add 	$44=, $56, $44
	call    	__addtf3@FUNCTION, $44, $17, $16, $9, $8
	i64.load	$push26=, 256($56)
	i32.const	$push67=, 8
	i32.const	$45=, 256
	i32.add 	$45=, $56, $45
	i32.add 	$push24=, $45, $pop67
	i64.load	$push25=, 0($pop24)
	i32.const	$46=, 144
	i32.add 	$46=, $56, $46
	call    	__subtf3@FUNCTION, $46, $5, $4, $pop26, $pop25
	i64.load	$2=, 144($56)
	i32.const	$push66=, 0
	i32.const	$push65=, 8
	i32.const	$47=, 144
	i32.add 	$47=, $56, $47
	i32.add 	$push27=, $47, $pop65
	i64.load	$push4=, 0($pop27)
	i64.store	$9=, Z+8($pop66), $pop4
	i32.const	$push64=, 0
	i64.store	$8=, Z($pop64):p2align=4, $2
	i32.const	$48=, 128
	i32.add 	$48=, $56, $48
	call    	__addtf3@FUNCTION, $48, $17, $16, $15, $14
	i64.load	$push30=, 128($56)
	i32.const	$push63=, 8
	i32.const	$49=, 128
	i32.add 	$49=, $56, $49
	i32.add 	$push28=, $49, $pop63
	i64.load	$push29=, 0($pop28)
	i32.const	$50=, 48
	i32.add 	$50=, $56, $50
	call    	__multf3@FUNCTION, $50, $pop30, $pop29, $11, $10
	i32.const	$push62=, 8
	i32.const	$51=, 48
	i32.add 	$51=, $56, $51
	i32.add 	$push31=, $51, $pop62
	i64.load	$17=, 0($pop31)
	i64.load	$16=, 48($56)
	i32.const	$52=, 16
	i32.add 	$52=, $56, $52
	call    	__multf3@FUNCTION, $52, $15, $14, $11, $10
	i32.const	$push61=, 8
	i32.const	$53=, 16
	i32.add 	$53=, $56, $53
	i32.add 	$push32=, $53, $pop61
	i64.load	$2=, 0($pop32)
	i64.load	$3=, 16($56)
	i32.const	$54=, 32
	i32.add 	$54=, $56, $54
	call    	__subtf3@FUNCTION, $54, $16, $17, $15, $14
	i64.load	$17=, 32($56)
	i32.const	$push60=, 0
	i32.const	$push59=, 8
	i32.const	$55=, 32
	i32.add 	$55=, $56, $55
	i32.add 	$push33=, $55, $pop59
	i64.load	$push2=, 0($pop33)
	i64.store	$16=, R+8($pop60), $pop2
	i32.const	$push58=, 0
	i64.store	$11=, R($pop58):p2align=4, $17
	i64.const	$push57=, 0
	i64.const	$push34=, -4612248968380809216
	call    	__addtf3@FUNCTION, $56, $3, $2, $pop57, $pop34
	i64.load	$17=, 0($56)
	i32.const	$push56=, 0
	i32.const	$push55=, 8
	i32.add 	$push35=, $56, $pop55
	i64.load	$push3=, 0($pop35)
	i64.store	$2=, Y1+8($pop56), $pop3
	i32.const	$push54=, 0
	i64.store	$discard=, Y1($pop54):p2align=4, $17
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
