	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920625-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push33=, __stack_pointer
	i32.load	$push34=, 0($pop33)
	i32.const	$push35=, 128
	i32.sub 	$14=, $pop34, $pop35
	i32.const	$push36=, __stack_pointer
	i32.store	$discard=, 0($pop36), $14
	i32.const	$push2=, 8
	i32.const	$1=, 112
	i32.add 	$1=, $14, $1
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, pts+8($pop0)
	i64.store	$discard=, 0($pop3), $pop1
	i32.const	$push32=, 0
	i64.load	$push4=, pts($pop32):p2align=4
	i64.store	$discard=, 112($14), $pop4
	i32.const	$push31=, 8
	i32.const	$2=, 96
	i32.add 	$2=, $14, $2
	i32.add 	$push5=, $2, $pop31
	i32.const	$push30=, 0
	i64.load	$push6=, pts+24($pop30)
	i64.store	$discard=, 0($pop5), $pop6
	i32.const	$push29=, 0
	i64.load	$push7=, pts+16($pop29):p2align=4
	i64.store	$discard=, 96($14), $pop7
	i32.const	$push28=, 8
	i32.const	$3=, 80
	i32.add 	$3=, $14, $3
	i32.add 	$push8=, $3, $pop28
	i32.const	$push27=, 0
	i64.load	$push9=, pts+40($pop27)
	i64.store	$discard=, 0($pop8), $pop9
	i32.const	$push26=, 0
	i64.load	$push10=, pts+32($pop26):p2align=4
	i64.store	$discard=, 80($14), $pop10
	i32.const	$push25=, 8
	i32.const	$4=, 64
	i32.add 	$4=, $14, $4
	i32.add 	$push11=, $4, $pop25
	i32.const	$push24=, 0
	i64.load	$push12=, pts+56($pop24)
	i64.store	$discard=, 0($pop11), $pop12
	i32.const	$push23=, 0
	i64.load	$push13=, pts+48($pop23):p2align=4
	i64.store	$discard=, 64($14), $pop13
	i32.const	$5=, 64
	i32.add 	$5=, $14, $5
	i32.store	$discard=, 60($14), $5
	i32.const	$6=, 80
	i32.add 	$6=, $14, $6
	i32.store	$discard=, 56($14):p2align=3, $6
	i32.const	$7=, 96
	i32.add 	$7=, $14, $7
	i32.store	$discard=, 52($14), $7
	i32.const	$8=, 112
	i32.add 	$8=, $14, $8
	i32.store	$discard=, 48($14):p2align=4, $8
	i32.const	$9=, 48
	i32.add 	$9=, $14, $9
	call    	va1@FUNCTION, $0, $9
	i32.const	$push22=, 0
	i64.load	$push14=, ipts($pop22):p2align=4
	i64.store	$discard=, 40($14):p2align=2, $pop14
	i32.const	$push21=, 0
	i64.load	$push15=, ipts+8($pop21)
	i64.store	$discard=, 32($14):p2align=2, $pop15
	i32.const	$push20=, 0
	i64.load	$push16=, ipts+16($pop20):p2align=4
	i64.store	$discard=, 24($14):p2align=2, $pop16
	i32.const	$push19=, 0
	i64.load	$push17=, ipts+24($pop19)
	i64.store	$discard=, 16($14):p2align=2, $pop17
	i32.const	$10=, 16
	i32.add 	$10=, $14, $10
	i32.store	$discard=, 12($14), $10
	i32.const	$11=, 24
	i32.add 	$11=, $14, $11
	i32.store	$discard=, 8($14):p2align=3, $11
	i32.const	$12=, 32
	i32.add 	$12=, $14, $12
	i32.store	$discard=, 4($14), $12
	i32.const	$13=, 40
	i32.add 	$13=, $14, $13
	i32.store	$discard=, 0($14):p2align=4, $13
	call    	va2@FUNCTION, $0, $14
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.va1,"ax",@progbits
	.type	va1,@function
va1:                                    # @va1
	.param  	i32, i32
	.local  	f64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push44=, __stack_pointer
	i32.load	$push45=, 0($pop44)
	i32.const	$push46=, 16
	i32.sub 	$4=, $pop45, $pop46
	i32.const	$push47=, __stack_pointer
	i32.store	$discard=, 0($pop47), $4
	i32.store	$push0=, 12($4), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push36=, $pop2, $pop3
	tee_local	$push35=, $1=, $pop36
	f64.load	$2=, 0($pop35)
	i32.const	$push34=, 0
	f64.load	$3=, pts($pop34):p2align=4
	i32.const	$push4=, 16
	i32.add 	$push5=, $1, $pop4
	i32.store	$discard=, 12($4), $pop5
	block
	f64.ne  	$push6=, $3, $2
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push38=, 0
	f64.load	$push8=, pts+8($pop38)
	f64.load	$push7=, 8($1)
	f64.ne  	$push9=, $pop8, $pop7
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %for.cond
	i32.const	$push12=, 16
	i32.add 	$push13=, $1, $pop12
	f64.load	$2=, 0($pop13)
	i32.const	$push37=, 0
	f64.load	$3=, pts+16($pop37):p2align=4
	i32.const	$push10=, 32
	i32.add 	$push11=, $1, $pop10
	i32.store	$discard=, 12($4), $pop11
	f64.ne  	$push14=, $3, $2
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %lor.lhs.false.1
	i32.const	$push39=, 0
	f64.load	$push16=, pts+24($pop39)
	f64.load	$push15=, 24($1)
	f64.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label0
# BB#4:                                 # %for.cond.1
	i32.const	$push20=, 32
	i32.add 	$push21=, $1, $pop20
	f64.load	$2=, 0($pop21)
	i32.const	$push40=, 0
	f64.load	$3=, pts+32($pop40):p2align=4
	i32.const	$push18=, 48
	i32.add 	$push19=, $1, $pop18
	i32.store	$discard=, 12($4), $pop19
	f64.ne  	$push22=, $3, $2
	br_if   	0, $pop22       # 0: down to label0
# BB#5:                                 # %lor.lhs.false.2
	i32.const	$push41=, 0
	f64.load	$push24=, pts+40($pop41)
	f64.load	$push23=, 40($1)
	f64.ne  	$push25=, $pop24, $pop23
	br_if   	0, $pop25       # 0: down to label0
# BB#6:                                 # %for.cond.2
	i32.const	$push28=, 48
	i32.add 	$push29=, $1, $pop28
	f64.load	$2=, 0($pop29)
	i32.const	$push42=, 0
	f64.load	$3=, pts+48($pop42):p2align=4
	i32.const	$push26=, 64
	i32.add 	$push27=, $1, $pop26
	i32.store	$discard=, 12($4), $pop27
	f64.ne  	$push30=, $3, $2
	br_if   	0, $pop30       # 0: down to label0
# BB#7:                                 # %lor.lhs.false.3
	i32.const	$push43=, 0
	f64.load	$push32=, pts+56($pop43)
	f64.load	$push31=, 56($1)
	f64.ne  	$push33=, $pop32, $pop31
	br_if   	0, $pop33       # 0: down to label0
# BB#8:                                 # %for.cond.3
	i32.const	$push48=, 16
	i32.add 	$4=, $4, $pop48
	i32.const	$push49=, __stack_pointer
	i32.store	$discard=, 0($pop49), $4
	return
.LBB1_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	va1, .Lfunc_end1-va1

	.section	.text.va2,"ax",@progbits
	.type	va2,@function
va2:                                    # @va2
	.param  	i32, i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push60=, __stack_pointer
	i32.load	$push61=, 0($pop60)
	i32.const	$push62=, 16
	i32.sub 	$3=, $pop61, $pop62
	i32.const	$push63=, __stack_pointer
	i32.store	$discard=, 0($pop63), $3
	i32.store	$push53=, 12($3), $1
	tee_local	$push52=, $1=, $pop53
	i32.const	$push0=, 8
	i32.add 	$push1=, $pop52, $pop0
	i32.store	$discard=, 12($3), $pop1
	block
	i32.const	$push3=, 0
	i64.load	$push51=, ipts($pop3):p2align=4
	tee_local	$push50=, $2=, $pop51
	i32.wrap/i64	$push4=, $pop50
	i32.load	$push2=, 0($1)
	i32.ne  	$push5=, $pop4, $pop2
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	i64.const	$push6=, 32
	i64.shr_u	$push7=, $2, $pop6
	i32.wrap/i64	$push8=, $pop7
	i32.load	$push9=, 4($1)
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#2:                                 # %for.cond
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	$discard=, 12($3), $pop12
	i32.const	$push16=, 0
	i64.load	$push55=, ipts+8($pop16)
	tee_local	$push54=, $2=, $pop55
	i32.wrap/i64	$push17=, $pop54
	i32.const	$push13=, 8
	i32.add 	$push14=, $1, $pop13
	i32.load	$push15=, 0($pop14)
	i32.ne  	$push18=, $pop17, $pop15
	br_if   	0, $pop18       # 0: down to label1
# BB#3:                                 # %lor.lhs.false.1
	i64.const	$push19=, 32
	i64.shr_u	$push20=, $2, $pop19
	i32.wrap/i64	$push21=, $pop20
	i32.load	$push22=, 12($1)
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label1
# BB#4:                                 # %for.cond.1
	i32.const	$push24=, 24
	i32.add 	$push25=, $1, $pop24
	i32.store	$discard=, 12($3), $pop25
	i32.const	$push29=, 0
	i64.load	$push57=, ipts+16($pop29):p2align=4
	tee_local	$push56=, $2=, $pop57
	i32.wrap/i64	$push30=, $pop56
	i32.const	$push26=, 16
	i32.add 	$push27=, $1, $pop26
	i32.load	$push28=, 0($pop27)
	i32.ne  	$push31=, $pop30, $pop28
	br_if   	0, $pop31       # 0: down to label1
# BB#5:                                 # %lor.lhs.false.2
	i64.const	$push32=, 32
	i64.shr_u	$push33=, $2, $pop32
	i32.wrap/i64	$push34=, $pop33
	i32.load	$push35=, 20($1)
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label1
# BB#6:                                 # %for.cond.2
	i32.const	$push37=, 32
	i32.add 	$push38=, $1, $pop37
	i32.store	$discard=, 12($3), $pop38
	i32.const	$push42=, 0
	i64.load	$push59=, ipts+24($pop42)
	tee_local	$push58=, $2=, $pop59
	i32.wrap/i64	$push43=, $pop58
	i32.const	$push39=, 24
	i32.add 	$push40=, $1, $pop39
	i32.load	$push41=, 0($pop40)
	i32.ne  	$push44=, $pop43, $pop41
	br_if   	0, $pop44       # 0: down to label1
# BB#7:                                 # %lor.lhs.false.3
	i64.const	$push45=, 32
	i64.shr_u	$push46=, $2, $pop45
	i32.wrap/i64	$push47=, $pop46
	i32.load	$push48=, 28($1)
	i32.ne  	$push49=, $pop47, $pop48
	br_if   	0, $pop49       # 0: down to label1
# BB#8:                                 # %for.cond.3
	i32.const	$push64=, 16
	i32.add 	$3=, $3, $pop64
	i32.const	$push65=, __stack_pointer
	i32.store	$discard=, 0($pop65), $3
	return
.LBB2_9:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	va2, .Lfunc_end2-va2

	.hidden	pts                     # @pts
	.type	pts,@object
	.section	.data.pts,"aw",@progbits
	.globl	pts
	.p2align	4
pts:
	.int64	4607182418800017408     # double 1
	.int64	4611686018427387904     # double 2
	.int64	4613937818241073152     # double 3
	.int64	4616189618054758400     # double 4
	.int64	4617315517961601024     # double 5
	.int64	4618441417868443648     # double 6
	.int64	4619567317775286272     # double 7
	.int64	4620693217682128896     # double 8
	.size	pts, 64

	.hidden	ipts                    # @ipts
	.type	ipts,@object
	.section	.data.ipts,"aw",@progbits
	.globl	ipts
	.p2align	4
ipts:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.size	ipts, 32


	.ident	"clang version 3.9.0 "
