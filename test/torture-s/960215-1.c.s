	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$18=, __stack_pointer
	i32.load	$18=, 0($18)
	i32.const	$19=, 320
	i32.sub 	$60=, $18, $19
	i32.const	$19=, __stack_pointer
	i32.store	$60=, 0($19), $60
	i32.const	$0=, 0
	i64.load	$14=, C+8($0)
	i64.load	$15=, C($0)
	i64.load	$1=, U+8($0)
	i64.load	$2=, U($0)
	i32.const	$20=, 304
	i32.add 	$20=, $60, $20
	call    	__addtf3@FUNCTION, $20, $15, $14, $2, $1
	i32.const	$3=, 8
	i32.const	$21=, 304
	i32.add 	$21=, $60, $21
	i32.add 	$push0=, $21, $3
	i64.load	$4=, 0($pop0)
	i64.load	$5=, 304($60)
	i64.load	$6=, Y2+8($0)
	i64.load	$7=, Y2($0)
	i32.const	$22=, 192
	i32.add 	$22=, $60, $22
	call    	__multf3@FUNCTION, $22, $5, $4, $7, $6
	i32.const	$23=, 192
	i32.add 	$23=, $60, $23
	i32.add 	$push1=, $23, $3
	i64.load	$8=, 0($pop1)
	i64.load	$9=, 192($60)
	i32.const	$24=, 240
	i32.add 	$24=, $60, $24
	call    	__subtf3@FUNCTION, $24, $15, $14, $2, $1
	i32.const	$25=, 240
	i32.add 	$25=, $60, $25
	i32.add 	$push2=, $25, $3
	i64.load	$10=, 0($pop2)
	i64.load	$11=, 240($60)
	i32.const	$26=, 224
	i32.add 	$26=, $60, $26
	call    	__subtf3@FUNCTION, $26, $11, $10, $2, $1
	i32.const	$27=, 224
	i32.add 	$27=, $60, $27
	i32.add 	$push3=, $27, $3
	i64.load	$12=, 0($pop3)
	i64.load	$13=, 224($60)
	i32.const	$28=, 288
	i32.add 	$28=, $60, $28
	call    	__addtf3@FUNCTION, $28, $2, $1, $5, $4
	i32.const	$29=, 288
	i32.add 	$29=, $60, $29
	i32.add 	$push4=, $29, $3
	i64.load	$4=, 0($pop4)
	i64.load	$14=, Y1+8($0)
	i64.load	$15=, Y1($0)
	i64.load	$5=, 288($60)
	i32.const	$30=, 112
	i32.add 	$30=, $60, $30
	call    	__multf3@FUNCTION, $30, $11, $10, $15, $14
	i32.const	$31=, 112
	i32.add 	$31=, $60, $31
	i32.add 	$push5=, $31, $3
	i64.load	$16=, 0($pop5)
	i64.load	$17=, 112($60)
	i32.const	$32=, 272
	i32.add 	$32=, $60, $32
	call    	__addtf3@FUNCTION, $32, $5, $4, $2, $1
	i32.const	$33=, 272
	i32.add 	$33=, $60, $33
	i32.add 	$push6=, $33, $3
	i64.load	$10=, 0($pop6)
	i64.load	$11=, 272($60)
	i32.const	$34=, 176
	i32.add 	$34=, $60, $34
	call    	__subtf3@FUNCTION, $34, $9, $8, $11, $10
	i64.load	$8=, 176($60)
	i32.const	$35=, 176
	i32.add 	$35=, $60, $35
	i32.add 	$push7=, $35, $3
	i64.load	$push8=, 0($pop7)
	i64.store	$discard=, X+8($0), $pop8
	i64.store	$discard=, X($0), $8
	i32.const	$36=, 80
	i32.add 	$36=, $60, $36
	call    	__multf3@FUNCTION, $36, $13, $12, $15, $14
	i32.const	$37=, 80
	i32.add 	$37=, $60, $37
	i32.add 	$push9=, $37, $3
	i64.load	$8=, 0($pop9)
	i64.load	$9=, 80($60)
	i32.const	$38=, 160
	i32.add 	$38=, $60, $38
	call    	__multf3@FUNCTION, $38, $5, $4, $7, $6
	i64.load	$4=, 160($60)
	i32.const	$39=, 160
	i32.add 	$39=, $60, $39
	i32.add 	$push10=, $39, $3
	i64.load	$push11=, 0($pop10)
	i64.store	$5=, S+8($0), $pop11
	i64.store	$discard=, S($0), $4
	i32.const	$40=, 96
	i32.add 	$40=, $60, $40
	call    	__subtf3@FUNCTION, $40, $17, $16, $13, $12
	i64.load	$16=, 96($60)
	i32.const	$41=, 96
	i32.add 	$41=, $60, $41
	i32.add 	$push12=, $41, $3
	i64.load	$push13=, 0($pop12)
	i64.store	$discard=, T+8($0), $pop13
	i64.store	$discard=, T($0), $16
	i32.const	$42=, 208
	i32.add 	$42=, $60, $42
	call    	__subtf3@FUNCTION, $42, $2, $1, $13, $12
	i64.load	$push16=, 208($60)
	i32.const	$43=, 208
	i32.add 	$43=, $60, $43
	i32.add 	$push14=, $43, $3
	i64.load	$push15=, 0($pop14)
	i32.const	$44=, 64
	i32.add 	$44=, $60, $44
	call    	__addtf3@FUNCTION, $44, $pop16, $pop15, $9, $8
	i64.load	$12=, 64($60)
	i32.const	$45=, 64
	i32.add 	$45=, $60, $45
	i32.add 	$push17=, $45, $3
	i64.load	$push18=, 0($pop17)
	i64.store	$discard=, Y+8($0), $pop18
	i64.store	$discard=, Y($0), $12
	i32.const	$46=, 256
	i32.add 	$46=, $60, $46
	call    	__addtf3@FUNCTION, $46, $2, $1, $11, $10
	i64.load	$push21=, 256($60)
	i32.const	$47=, 256
	i32.add 	$47=, $60, $47
	i32.add 	$push19=, $47, $3
	i64.load	$push20=, 0($pop19)
	i32.const	$48=, 144
	i32.add 	$48=, $60, $48
	call    	__subtf3@FUNCTION, $48, $4, $5, $pop21, $pop20
	i64.load	$12=, 144($60)
	i32.const	$49=, 144
	i32.add 	$49=, $60, $49
	i32.add 	$push22=, $49, $3
	i64.load	$push23=, 0($pop22)
	i64.store	$13=, Z+8($0), $pop23
	i64.store	$discard=, Z($0), $12
	i32.const	$50=, 128
	i32.add 	$50=, $60, $50
	call    	__addtf3@FUNCTION, $50, $2, $1, $7, $6
	i64.load	$push26=, 128($60)
	i32.const	$51=, 128
	i32.add 	$51=, $60, $51
	i32.add 	$push24=, $51, $3
	i64.load	$push25=, 0($pop24)
	i32.const	$52=, 48
	i32.add 	$52=, $60, $52
	call    	__multf3@FUNCTION, $52, $pop26, $pop25, $15, $14
	i32.const	$53=, 48
	i32.add 	$53=, $60, $53
	i32.add 	$push27=, $53, $3
	i64.load	$1=, 0($pop27)
	i64.load	$2=, 48($60)
	i32.const	$54=, 16
	i32.add 	$54=, $60, $54
	call    	__multf3@FUNCTION, $54, $7, $6, $15, $14
	i32.const	$55=, 16
	i32.add 	$55=, $60, $55
	i32.add 	$push28=, $55, $3
	i64.load	$14=, 0($pop28)
	i64.load	$15=, 16($60)
	i32.const	$56=, 32
	i32.add 	$56=, $60, $56
	call    	__subtf3@FUNCTION, $56, $2, $1, $7, $6
	i64.load	$2=, 32($60)
	i32.const	$57=, 32
	i32.add 	$57=, $60, $57
	i32.add 	$push29=, $57, $3
	i64.load	$push30=, 0($pop29)
	i64.store	$discard=, R+8($0), $pop30
	i64.const	$1=, 0
	i64.store	$discard=, R($0), $2
	i64.const	$push31=, -4612248968380809216
	i32.const	$58=, 0
	i32.add 	$58=, $60, $58
	call    	__addtf3@FUNCTION, $58, $15, $14, $1, $pop31
	i64.load	$2=, 0($60)
	i32.const	$59=, 0
	i32.add 	$59=, $60, $59
	i32.add 	$push32=, $59, $3
	i64.load	$push33=, 0($pop32)
	i64.store	$discard=, Y1+8($0), $pop33
	i64.store	$discard=, Y1($0), $2
	block
	i64.const	$push34=, 4612108230892453888
	i32.call	$push35=, __eqtf2@FUNCTION, $12, $13, $1, $pop34
	i32.const	$push36=, 0
	i32.eq  	$push37=, $pop35, $pop36
	br_if   	$pop37, 0       # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	C                       # @C
	.type	C,@object
	.section	.data.C,"aw",@progbits
	.globl	C
	.align	4
C:
	.int64	0                       # fp128 2
	.int64	4611686018427387904
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
	.int64	0                       # fp128 3
	.int64	4611826755915743232
	.size	Y2, 16

	.hidden	Y1                      # @Y1
	.type	Y1,@object
	.section	.data.Y1,"aw",@progbits
	.globl	Y1
	.align	4
Y1:
	.int64	0                       # fp128 1
	.int64	4611404543450677248
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


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
