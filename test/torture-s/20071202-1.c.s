	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071202-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.load	$push0=, 4($0)
	i32.store	$discard=, 0($0), $pop0
	i32.store	$discard=, 4($0), $1
	i32.const	$push1=, 28
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 0
	i32.store	$1=, 0($pop2), $pop3
	i32.const	$push8=, 12
	i32.add 	$push9=, $0, $pop8
	i32.const	$push4=, 20
	i32.add 	$push5=, $0, $pop4
	i64.const	$push6=, 0
	i64.store	$push7=, 0($pop5):p2align=2, $pop6
	i64.store	$discard=, 0($pop9):p2align=2, $pop7
	i32.store	$discard=, 8($0), $1
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 80
	i32.sub 	$19=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$19=, 0($1), $19
	i32.const	$push0=, .Lmain.s
	i32.const	$push1=, 68
	i32.const	$3=, 8
	i32.add 	$3=, $19, $3
	i32.call	$discard=, memcpy@FUNCTION, $3, $pop0, $pop1
	i32.const	$4=, 8
	i32.add 	$4=, $19, $4
	call    	foo@FUNCTION, $4
	block
	block
	i32.load	$push2=, 8($19):p2align=3
	i32.const	$push3=, 12
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	i32.const	$push5=, 4
	i32.const	$5=, 8
	i32.add 	$5=, $19, $5
	i32.or  	$push6=, $5, $pop5
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 6
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push10=, 16($19):p2align=3
	br_if   	0, $pop10       # 0: down to label1
# BB#3:                                 # %lor.lhs.false3
	i32.const	$push11=, 12
	i32.const	$6=, 8
	i32.add 	$6=, $19, $6
	i32.add 	$push12=, $6, $pop11
	i32.load	$push13=, 0($pop12)
	br_if   	0, $pop13       # 0: down to label1
# BB#4:                                 # %lor.lhs.false7
	i32.const	$push14=, 16
	i32.const	$7=, 8
	i32.add 	$7=, $19, $7
	i32.add 	$push15=, $7, $pop14
	i32.load	$push16=, 0($pop15):p2align=3
	br_if   	0, $pop16       # 0: down to label1
# BB#5:                                 # %lor.lhs.false11
	i32.const	$push17=, 20
	i32.const	$8=, 8
	i32.add 	$8=, $19, $8
	i32.add 	$push18=, $8, $pop17
	i32.load	$push19=, 0($pop18)
	br_if   	0, $pop19       # 0: down to label1
# BB#6:                                 # %lor.lhs.false15
	i32.const	$push20=, 24
	i32.const	$9=, 8
	i32.add 	$9=, $19, $9
	i32.add 	$push21=, $9, $pop20
	i32.load	$push22=, 0($pop21):p2align=3
	br_if   	0, $pop22       # 0: down to label1
# BB#7:                                 # %lor.lhs.false19
	i32.const	$push23=, 28
	i32.const	$10=, 8
	i32.add 	$10=, $19, $10
	i32.add 	$push24=, $10, $pop23
	i32.load	$push25=, 0($pop24)
	br_if   	0, $pop25       # 0: down to label1
# BB#8:                                 # %if.end
	i32.load	$push26=, 40($19):p2align=3
	i32.const	$push27=, 7
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	1, $pop28       # 1: down to label0
# BB#9:                                 # %lor.lhs.false24
	i32.const	$push29=, 36
	i32.const	$11=, 8
	i32.add 	$11=, $19, $11
	i32.add 	$push30=, $11, $pop29
	i32.load	$push31=, 0($pop30)
	i32.const	$push32=, 8
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	1, $pop33       # 1: down to label0
# BB#10:                                # %lor.lhs.false28
	i32.const	$push34=, 40
	i32.const	$12=, 8
	i32.add 	$12=, $19, $12
	i32.add 	$push35=, $12, $pop34
	i32.load	$push36=, 0($pop35):p2align=3
	i32.const	$push37=, 9
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	1, $pop38       # 1: down to label0
# BB#11:                                # %lor.lhs.false33
	i32.const	$push39=, 44
	i32.const	$13=, 8
	i32.add 	$13=, $19, $13
	i32.add 	$push40=, $13, $pop39
	i32.load	$push41=, 0($pop40)
	i32.const	$push42=, 10
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	1, $pop43       # 1: down to label0
# BB#12:                                # %lor.lhs.false38
	i32.const	$push44=, 48
	i32.const	$14=, 8
	i32.add 	$14=, $19, $14
	i32.add 	$push45=, $14, $pop44
	i32.load	$push46=, 0($pop45):p2align=3
	i32.const	$push47=, 11
	i32.ne  	$push48=, $pop46, $pop47
	br_if   	1, $pop48       # 1: down to label0
# BB#13:                                # %lor.lhs.false43
	i32.const	$push49=, 52
	i32.const	$15=, 8
	i32.add 	$15=, $19, $15
	i32.add 	$push50=, $15, $pop49
	i32.load	$push51=, 0($pop50)
	i32.const	$push52=, 12
	i32.ne  	$push53=, $pop51, $pop52
	br_if   	1, $pop53       # 1: down to label0
# BB#14:                                # %lor.lhs.false48
	i32.const	$push54=, 56
	i32.const	$16=, 8
	i32.add 	$16=, $19, $16
	i32.add 	$push55=, $16, $pop54
	i32.load	$push56=, 0($pop55):p2align=3
	i32.const	$push57=, 13
	i32.ne  	$push58=, $pop56, $pop57
	br_if   	1, $pop58       # 1: down to label0
# BB#15:                                # %lor.lhs.false53
	i32.const	$push59=, 60
	i32.const	$17=, 8
	i32.add 	$17=, $19, $17
	i32.add 	$push60=, $17, $pop59
	i32.load	$push61=, 0($pop60)
	i32.const	$push62=, 14
	i32.ne  	$push63=, $pop61, $pop62
	br_if   	1, $pop63       # 1: down to label0
# BB#16:                                # %lor.lhs.false58
	i32.const	$push64=, 64
	i32.const	$18=, 8
	i32.add 	$18=, $19, $18
	i32.add 	$push65=, $18, $pop64
	i32.load	$push66=, 0($pop65):p2align=3
	i32.const	$push67=, 15
	i32.ne  	$push68=, $pop66, $pop67
	br_if   	1, $pop68       # 1: down to label0
# BB#17:                                # %if.end64
	i32.const	$push69=, 0
	i32.const	$2=, 80
	i32.add 	$19=, $19, $2
	i32.const	$2=, __stack_pointer
	i32.store	$19=, 0($2), $19
	return  	$pop69
.LBB1_18:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.then63
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
	.p2align	2
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


	.ident	"clang version 3.9.0 "
