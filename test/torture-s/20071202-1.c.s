	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071202-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 64
	i32.sub 	$22=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$22=, 0($11), $22
	i32.load	$9=, 4($0)
	i32.load	$1=, 0($0)
	i32.const	$2=, 16
	i32.const	$13=, 40
	i32.add 	$13=, $22, $13
	i32.add 	$3=, $13, $2
	i64.const	$push0=, 0
	i64.store	$7=, 0($3), $pop0
	i32.const	$4=, 8
	i32.const	$14=, 40
	i32.add 	$14=, $22, $14
	i32.add 	$5=, $14, $4
	i64.store	$push1=, 0($5), $7
	i64.store	$discard=, 40($22), $pop1
	i32.const	$6=, 32
	i32.const	$15=, 0
	i32.add 	$15=, $22, $15
	i32.add 	$push6=, $15, $6
	i32.const	$push3=, 64
	i32.add 	$push4=, $0, $pop3
	i32.load	$push5=, 0($pop4)
	i32.store	$discard=, 0($pop6), $pop5
	i64.const	$7=, 32
	i32.const	$16=, 0
	i32.add 	$16=, $22, $16
	i32.add 	$push15=, $16, $2
	i32.const	$push7=, 52
	i32.add 	$push8=, $0, $pop7
	i64.load32_u	$push9=, 0($pop8)
	i64.shl 	$push10=, $pop9, $7
	i32.const	$push11=, 48
	i32.add 	$push12=, $0, $pop11
	i64.load32_u	$push13=, 0($pop12)
	i64.or  	$push14=, $pop10, $pop13
	i64.store	$discard=, 0($pop15), $pop14
	i32.const	$8=, 24
	i32.const	$17=, 0
	i32.add 	$17=, $22, $17
	i32.add 	$push24=, $17, $8
	i32.const	$push16=, 60
	i32.add 	$push17=, $0, $pop16
	i64.load32_u	$push18=, 0($pop17)
	i64.shl 	$push19=, $pop18, $7
	i32.const	$push20=, 56
	i32.add 	$push21=, $0, $pop20
	i64.load32_u	$push22=, 0($pop21)
	i64.or  	$push23=, $pop19, $pop22
	i64.store	$discard=, 0($pop24), $pop23
	i32.const	$18=, 0
	i32.add 	$18=, $22, $18
	i32.add 	$push33=, $18, $4
	i32.const	$push25=, 44
	i32.add 	$push26=, $0, $pop25
	i64.load32_u	$push27=, 0($pop26)
	i64.shl 	$push28=, $pop27, $7
	i32.const	$push29=, 40
	i32.add 	$push30=, $0, $pop29
	i64.load32_u	$push31=, 0($pop30)
	i64.or  	$push32=, $pop28, $pop31
	i64.store	$discard=, 0($pop33), $pop32
	i32.const	$4=, 36
	i32.add 	$push34=, $0, $4
	i64.load32_u	$push35=, 0($pop34)
	i64.shl 	$push36=, $pop35, $7
	i64.load32_u	$push37=, 32($0)
	i64.or  	$push38=, $pop36, $pop37
	i64.store	$discard=, 0($22), $pop38
	i32.store	$discard=, 0($0), $9
	i32.store	$discard=, 4($0), $1
	i32.const	$9=, 20
	i32.const	$push39=, 28
	i32.add 	$push40=, $0, $pop39
	i32.const	$19=, 40
	i32.add 	$19=, $22, $19
	i32.add 	$push41=, $19, $9
	i32.load	$push42=, 0($pop41)
	i32.store	$discard=, 0($pop40), $pop42
	i32.add 	$push43=, $0, $8
	i32.load	$push44=, 0($3)
	i32.store	$discard=, 0($pop43), $pop44
	i32.const	$3=, 12
	i32.add 	$push45=, $0, $9
	i32.const	$20=, 40
	i32.add 	$20=, $22, $20
	i32.add 	$push46=, $20, $3
	i32.load	$push47=, 0($pop46)
	i32.store	$discard=, 0($pop45), $pop47
	i32.add 	$push48=, $0, $2
	i32.load	$push49=, 0($5)
	i32.store	$discard=, 0($pop48), $pop49
	i32.add 	$push50=, $0, $3
	i32.const	$push51=, 4
	i32.const	$21=, 40
	i32.add 	$21=, $22, $21
	i32.or  	$push52=, $21, $pop51
	i32.load	$push53=, 0($pop52)
	i32.store	$discard=, 0($pop50), $pop53
	i32.load	$push54=, 40($22)
	i32.store	$discard=, 8($0), $pop54
	i32.add 	$push2=, $0, $6
	i32.const	$22=, 0
	i32.add 	$22=, $22, $22
	call    	memcpy@FUNCTION, $pop2, $22, $4
	i32.const	$12=, 64
	i32.add 	$22=, $22, $12
	i32.const	$12=, __stack_pointer
	i32.store	$22=, 0($12), $22
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 80
	i32.sub 	$20=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$20=, 0($2), $20
	i32.const	$push0=, .Lmain.s
	i32.const	$push1=, 68
	i32.const	$4=, 8
	i32.add 	$4=, $20, $4
	call    	memcpy@FUNCTION, $4, $pop0, $pop1
	i32.const	$5=, 8
	i32.add 	$5=, $20, $5
	call    	foo@FUNCTION, $5
	i32.const	$0=, 12
	block
	i32.load	$push2=, 8($20)
	i32.ne  	$push3=, $pop2, $0
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push4=, 4
	i32.const	$6=, 8
	i32.add 	$6=, $20, $6
	i32.or  	$push5=, $6, $pop4
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 6
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push9=, 16($20)
	br_if   	$pop9, 0        # 0: down to label0
# BB#3:                                 # %lor.lhs.false3
	i32.const	$7=, 8
	i32.add 	$7=, $20, $7
	i32.add 	$push10=, $7, $0
	i32.load	$push11=, 0($pop10)
	br_if   	$pop11, 0       # 0: down to label0
# BB#4:                                 # %lor.lhs.false7
	i32.const	$push12=, 16
	i32.const	$8=, 8
	i32.add 	$8=, $20, $8
	i32.add 	$push13=, $8, $pop12
	i32.load	$push14=, 0($pop13)
	br_if   	$pop14, 0       # 0: down to label0
# BB#5:                                 # %lor.lhs.false11
	i32.const	$push15=, 20
	i32.const	$9=, 8
	i32.add 	$9=, $20, $9
	i32.add 	$push16=, $9, $pop15
	i32.load	$push17=, 0($pop16)
	br_if   	$pop17, 0       # 0: down to label0
# BB#6:                                 # %lor.lhs.false15
	i32.const	$push18=, 24
	i32.const	$10=, 8
	i32.add 	$10=, $20, $10
	i32.add 	$push19=, $10, $pop18
	i32.load	$push20=, 0($pop19)
	br_if   	$pop20, 0       # 0: down to label0
# BB#7:                                 # %lor.lhs.false19
	i32.const	$push21=, 28
	i32.const	$11=, 8
	i32.add 	$11=, $20, $11
	i32.add 	$push22=, $11, $pop21
	i32.load	$push23=, 0($pop22)
	br_if   	$pop23, 0       # 0: down to label0
# BB#8:                                 # %if.end
	block
	i32.load	$push24=, 40($20)
	i32.const	$push25=, 7
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	$pop26, 0       # 0: down to label1
# BB#9:                                 # %lor.lhs.false24
	i32.const	$push27=, 36
	i32.const	$12=, 8
	i32.add 	$12=, $20, $12
	i32.add 	$push28=, $12, $pop27
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 8
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	$pop31, 0       # 0: down to label1
# BB#10:                                # %lor.lhs.false28
	i32.const	$push32=, 40
	i32.const	$13=, 8
	i32.add 	$13=, $20, $13
	i32.add 	$push33=, $13, $pop32
	i32.load	$push34=, 0($pop33)
	i32.const	$push35=, 9
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	$pop36, 0       # 0: down to label1
# BB#11:                                # %lor.lhs.false33
	i32.const	$push37=, 44
	i32.const	$14=, 8
	i32.add 	$14=, $20, $14
	i32.add 	$push38=, $14, $pop37
	i32.load	$push39=, 0($pop38)
	i32.const	$push40=, 10
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	$pop41, 0       # 0: down to label1
# BB#12:                                # %lor.lhs.false38
	i32.const	$push42=, 48
	i32.const	$15=, 8
	i32.add 	$15=, $20, $15
	i32.add 	$push43=, $15, $pop42
	i32.load	$push44=, 0($pop43)
	i32.const	$push45=, 11
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	$pop46, 0       # 0: down to label1
# BB#13:                                # %lor.lhs.false43
	i32.const	$push47=, 52
	i32.const	$16=, 8
	i32.add 	$16=, $20, $16
	i32.add 	$push48=, $16, $pop47
	i32.load	$push49=, 0($pop48)
	i32.ne  	$push50=, $pop49, $0
	br_if   	$pop50, 0       # 0: down to label1
# BB#14:                                # %lor.lhs.false48
	i32.const	$push51=, 56
	i32.const	$17=, 8
	i32.add 	$17=, $20, $17
	i32.add 	$push52=, $17, $pop51
	i32.load	$push53=, 0($pop52)
	i32.const	$push54=, 13
	i32.ne  	$push55=, $pop53, $pop54
	br_if   	$pop55, 0       # 0: down to label1
# BB#15:                                # %lor.lhs.false53
	i32.const	$push56=, 60
	i32.const	$18=, 8
	i32.add 	$18=, $20, $18
	i32.add 	$push57=, $18, $pop56
	i32.load	$push58=, 0($pop57)
	i32.const	$push59=, 14
	i32.ne  	$push60=, $pop58, $pop59
	br_if   	$pop60, 0       # 0: down to label1
# BB#16:                                # %lor.lhs.false58
	i32.const	$push61=, 64
	i32.const	$19=, 8
	i32.add 	$19=, $20, $19
	i32.add 	$push62=, $19, $pop61
	i32.load	$push63=, 0($pop62)
	i32.const	$push64=, 15
	i32.ne  	$push65=, $pop63, $pop64
	br_if   	$pop65, 0       # 0: down to label1
# BB#17:                                # %if.end64
	i32.const	$push66=, 0
	i32.const	$3=, 80
	i32.add 	$20=, $20, $3
	i32.const	$3=, __stack_pointer
	i32.store	$20=, 0($3), $20
	return  	$pop66
.LBB1_18:                               # %if.then63
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
	.align	2
.Lmain.s:
	.int32	6                       # 0x6
	.int32	12                      # 0xc
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.int32	11                      # 0xb
	.int32	12                      # 0xc
	.int32	13                      # 0xd
	.int32	14                      # 0xe
	.int32	15                      # 0xf
	.size	.Lmain.s, 68


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
