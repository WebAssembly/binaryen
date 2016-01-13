	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/regstack-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$20=, __stack_pointer
	i32.load	$20=, 0($20)
	i32.const	$21=, 320
	i32.sub 	$62=, $20, $21
	i32.const	$21=, __stack_pointer
	i32.store	$62=, 0($21), $62
	i32.const	$0=, 0
	i64.load	$14=, C+8($0)
	i64.load	$15=, C($0)
	i64.load	$1=, U+8($0)
	i64.load	$2=, U($0)
	i32.const	$22=, 304
	i32.add 	$22=, $62, $22
	call    	__addtf3@FUNCTION, $22, $15, $14, $2, $1
	i32.const	$3=, 8
	i32.const	$23=, 304
	i32.add 	$23=, $62, $23
	i32.add 	$push7=, $23, $3
	i64.load	$4=, 0($pop7)
	i64.load	$5=, 304($62)
	i64.load	$6=, Y2+8($0)
	i64.load	$7=, Y2($0)
	i32.const	$24=, 192
	i32.add 	$24=, $62, $24
	call    	__multf3@FUNCTION, $24, $5, $4, $7, $6
	i32.const	$25=, 192
	i32.add 	$25=, $62, $25
	i32.add 	$push8=, $25, $3
	i64.load	$8=, 0($pop8)
	i64.load	$9=, 192($62)
	i32.const	$26=, 240
	i32.add 	$26=, $62, $26
	call    	__subtf3@FUNCTION, $26, $15, $14, $2, $1
	i32.const	$27=, 240
	i32.add 	$27=, $62, $27
	i32.add 	$push9=, $27, $3
	i64.load	$10=, 0($pop9)
	i64.load	$11=, 240($62)
	i32.const	$28=, 224
	i32.add 	$28=, $62, $28
	call    	__subtf3@FUNCTION, $28, $11, $10, $2, $1
	i32.const	$29=, 224
	i32.add 	$29=, $62, $29
	i32.add 	$push10=, $29, $3
	i64.load	$12=, 0($pop10)
	i64.load	$13=, 224($62)
	i32.const	$30=, 288
	i32.add 	$30=, $62, $30
	call    	__addtf3@FUNCTION, $30, $2, $1, $5, $4
	i32.const	$31=, 288
	i32.add 	$31=, $62, $31
	i32.add 	$push11=, $31, $3
	i64.load	$4=, 0($pop11)
	i64.load	$14=, Y1+8($0)
	i64.load	$15=, Y1($0)
	i64.load	$5=, 288($62)
	i32.const	$32=, 112
	i32.add 	$32=, $62, $32
	call    	__multf3@FUNCTION, $32, $11, $10, $15, $14
	i32.const	$33=, 112
	i32.add 	$33=, $62, $33
	i32.add 	$push12=, $33, $3
	i64.load	$16=, 0($pop12)
	i64.load	$17=, 112($62)
	i32.const	$34=, 272
	i32.add 	$34=, $62, $34
	call    	__addtf3@FUNCTION, $34, $5, $4, $2, $1
	i32.const	$35=, 272
	i32.add 	$35=, $62, $35
	i32.add 	$push13=, $35, $3
	i64.load	$10=, 0($pop13)
	i64.load	$11=, 272($62)
	i32.const	$36=, 176
	i32.add 	$36=, $62, $36
	call    	__subtf3@FUNCTION, $36, $9, $8, $11, $10
	i64.load	$8=, 176($62)
	i32.const	$37=, 176
	i32.add 	$37=, $62, $37
	i32.add 	$push14=, $37, $3
	i64.load	$push6=, 0($pop14)
	i64.store	$18=, X+8($0), $pop6
	i64.store	$19=, X($0), $8
	i32.const	$38=, 80
	i32.add 	$38=, $62, $38
	call    	__multf3@FUNCTION, $38, $13, $12, $15, $14
	i32.const	$39=, 80
	i32.add 	$39=, $62, $39
	i32.add 	$push15=, $39, $3
	i64.load	$8=, 0($pop15)
	i64.load	$9=, 80($62)
	i32.const	$40=, 160
	i32.add 	$40=, $62, $40
	call    	__multf3@FUNCTION, $40, $5, $4, $7, $6
	i64.load	$5=, 160($62)
	i32.const	$41=, 160
	i32.add 	$41=, $62, $41
	i32.add 	$push16=, $41, $3
	i64.load	$push1=, 0($pop16)
	i64.store	$4=, S+8($0), $pop1
	i64.store	$discard=, S($0), $5
	i32.const	$42=, 96
	i32.add 	$42=, $62, $42
	call    	__subtf3@FUNCTION, $42, $17, $16, $13, $12
	i64.load	$16=, 96($62)
	i32.const	$43=, 96
	i32.add 	$43=, $62, $43
	i32.add 	$push17=, $43, $3
	i64.load	$push0=, 0($pop17)
	i64.store	$17=, T+8($0), $pop0
	i64.store	$discard=, T($0), $16
	i32.const	$44=, 208
	i32.add 	$44=, $62, $44
	call    	__subtf3@FUNCTION, $44, $2, $1, $13, $12
	i64.load	$push20=, 208($62)
	i32.const	$45=, 208
	i32.add 	$45=, $62, $45
	i32.add 	$push18=, $45, $3
	i64.load	$push19=, 0($pop18)
	i32.const	$46=, 64
	i32.add 	$46=, $62, $46
	call    	__addtf3@FUNCTION, $46, $pop20, $pop19, $9, $8
	i64.load	$12=, 64($62)
	i32.const	$47=, 64
	i32.add 	$47=, $62, $47
	i32.add 	$push21=, $47, $3
	i64.load	$push5=, 0($pop21)
	i64.store	$8=, Y+8($0), $pop5
	i64.store	$9=, Y($0), $12
	i32.const	$48=, 256
	i32.add 	$48=, $62, $48
	call    	__addtf3@FUNCTION, $48, $2, $1, $11, $10
	i64.load	$push24=, 256($62)
	i32.const	$49=, 256
	i32.add 	$49=, $62, $49
	i32.add 	$push22=, $49, $3
	i64.load	$push23=, 0($pop22)
	i32.const	$50=, 144
	i32.add 	$50=, $62, $50
	call    	__subtf3@FUNCTION, $50, $5, $4, $pop24, $pop23
	i64.load	$12=, 144($62)
	i32.const	$51=, 144
	i32.add 	$51=, $62, $51
	i32.add 	$push25=, $51, $3
	i64.load	$push4=, 0($pop25)
	i64.store	$10=, Z+8($0), $pop4
	i64.store	$11=, Z($0), $12
	i32.const	$52=, 128
	i32.add 	$52=, $62, $52
	call    	__addtf3@FUNCTION, $52, $2, $1, $7, $6
	i64.load	$push28=, 128($62)
	i32.const	$53=, 128
	i32.add 	$53=, $62, $53
	i32.add 	$push26=, $53, $3
	i64.load	$push27=, 0($pop26)
	i32.const	$54=, 48
	i32.add 	$54=, $62, $54
	call    	__multf3@FUNCTION, $54, $pop28, $pop27, $15, $14
	i32.const	$55=, 48
	i32.add 	$55=, $62, $55
	i32.add 	$push29=, $55, $3
	i64.load	$1=, 0($pop29)
	i64.load	$2=, 48($62)
	i32.const	$56=, 16
	i32.add 	$56=, $62, $56
	call    	__multf3@FUNCTION, $56, $7, $6, $15, $14
	i32.const	$57=, 16
	i32.add 	$57=, $62, $57
	i32.add 	$push30=, $57, $3
	i64.load	$14=, 0($pop30)
	i64.load	$15=, 16($62)
	i32.const	$58=, 32
	i32.add 	$58=, $62, $58
	call    	__subtf3@FUNCTION, $58, $2, $1, $7, $6
	i64.load	$2=, 32($62)
	i32.const	$59=, 32
	i32.add 	$59=, $62, $59
	i32.add 	$push31=, $59, $3
	i64.load	$push2=, 0($pop31)
	i64.store	$12=, R+8($0), $pop2
	i64.const	$1=, 0
	i64.store	$13=, R($0), $2
	i64.const	$push32=, -4612248968380809216
	i32.const	$60=, 0
	i32.add 	$60=, $62, $60
	call    	__addtf3@FUNCTION, $60, $15, $14, $1, $pop32
	i64.load	$2=, 0($62)
	i32.const	$61=, 0
	i32.add 	$61=, $62, $61
	i32.add 	$push33=, $61, $3
	i64.load	$push3=, 0($pop33)
	i64.store	$14=, Y1+8($0), $pop3
	i64.store	$discard=, Y1($0), $2
	block
	i64.const	$push34=, 4612354521497075712
	i32.call	$push35=, __netf2@FUNCTION, $7, $6, $1, $pop34
	br_if   	$pop35, 0       # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push36=, 4613097791357452288
	i32.call	$push37=, __netf2@FUNCTION, $16, $17, $1, $pop36
	br_if   	$pop37, 0       # 0: down to label0
# BB#2:                                 # %entry
	i64.const	$push38=, 4613150567915585536
	i32.call	$push39=, __netf2@FUNCTION, $5, $4, $1, $pop38
	br_if   	$pop39, 0       # 0: down to label0
# BB#3:                                 # %entry
	i64.const	$push40=, 4613517804799262720
	i32.call	$push41=, __netf2@FUNCTION, $13, $12, $1, $pop40
	br_if   	$pop41, 0       # 0: down to label0
# BB#4:                                 # %entry
	i64.const	$push42=, 4613503511148101632
	i32.call	$push43=, __netf2@FUNCTION, $2, $14, $1, $pop42
	br_if   	$pop43, 0       # 0: down to label0
# BB#5:                                 # %entry
	i64.const	$push44=, 4613110985496985600
	i32.call	$push45=, __netf2@FUNCTION, $11, $10, $1, $pop44
	br_if   	$pop45, 0       # 0: down to label0
# BB#6:                                 # %entry
	i64.const	$push46=, 4612961451915608064
	i32.call	$push47=, __netf2@FUNCTION, $9, $8, $1, $pop46
	br_if   	$pop47, 0       # 0: down to label0
# BB#7:                                 # %entry
	i64.const	$push48=, 4613040616752807936
	i32.call	$push49=, __eqtf2@FUNCTION, $19, $18, $1, $pop48
	br_if   	$pop49, 0       # 0: down to label0
# BB#8:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	C                       # @C
	.type	C,@object
	.section	.data.C,"aw",@progbits
	.globl	C
	.align	4
C:
	.int64	0                       # fp128 5
	.int64	4612037862148276224
	.size	C, 16

	.hidden	U                       # @U
	.type	U,@object
	.section	.data.U,"aw",@progbits
	.globl	U
	.align	4
U:
	.int64	0                       # fp128 1
	.int64	4611404543450677248
	.size	U, 16

	.hidden	Y2                      # @Y2
	.type	Y2,@object
	.section	.data.Y2,"aw",@progbits
	.globl	Y2
	.align	4
Y2:
	.int64	0                       # fp128 11
	.int64	4612354521497075712
	.size	Y2, 16

	.hidden	Y1                      # @Y1
	.type	Y1,@object
	.section	.data.Y1,"aw",@progbits
	.globl	Y1
	.align	4
Y1:
	.int64	0                       # fp128 17
	.int64	4612548035543564288
	.size	Y1, 16

	.hidden	X                       # @X
	.type	X,@object
	.section	.bss.X,"aw",@nobits
	.globl	X
	.align	4
X:
	.int64	0                       # fp128 0
	.int64	0
	.size	X, 16

	.hidden	Y                       # @Y
	.type	Y,@object
	.section	.bss.Y,"aw",@nobits
	.globl	Y
	.align	4
Y:
	.int64	0                       # fp128 0
	.int64	0
	.size	Y, 16

	.hidden	Z                       # @Z
	.type	Z,@object
	.section	.bss.Z,"aw",@nobits
	.globl	Z
	.align	4
Z:
	.int64	0                       # fp128 0
	.int64	0
	.size	Z, 16

	.hidden	T                       # @T
	.type	T,@object
	.section	.bss.T,"aw",@nobits
	.globl	T
	.align	4
T:
	.int64	0                       # fp128 0
	.int64	0
	.size	T, 16

	.hidden	R                       # @R
	.type	R,@object
	.section	.bss.R,"aw",@nobits
	.globl	R
	.align	4
R:
	.int64	0                       # fp128 0
	.int64	0
	.size	R, 16

	.hidden	S                       # @S
	.type	S,@object
	.section	.bss.S,"aw",@nobits
	.globl	S
	.align	4
S:
	.int64	0                       # fp128 0
	.int64	0
	.size	S, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
