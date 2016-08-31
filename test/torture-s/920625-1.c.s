	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920625-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push18=, 0
	i32.load	$push19=, __stack_pointer($pop18)
	i32.const	$push20=, 128
	i32.sub 	$push64=, $pop19, $pop20
	tee_local	$push63=, $0=, $pop64
	i32.store	$drop=, __stack_pointer($pop21), $pop63
	i32.const	$push22=, 112
	i32.add 	$push23=, $0, $pop22
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop23, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, pts+8($pop0)
	i64.store	$drop=, 0($pop3), $pop1
	i32.const	$push24=, 96
	i32.add 	$push25=, $0, $pop24
	i32.const	$push62=, 8
	i32.add 	$push5=, $pop25, $pop62
	i32.const	$push61=, 0
	i64.load	$push4=, pts+24($pop61)
	i64.store	$drop=, 0($pop5), $pop4
	i32.const	$push60=, 0
	i64.load	$push6=, pts($pop60)
	i64.store	$drop=, 112($0), $pop6
	i32.const	$push59=, 0
	i64.load	$push7=, pts+16($pop59)
	i64.store	$drop=, 96($0), $pop7
	i32.const	$push26=, 80
	i32.add 	$push27=, $0, $pop26
	i32.const	$push58=, 8
	i32.add 	$push8=, $pop27, $pop58
	i32.const	$push57=, 0
	i64.load	$push9=, pts+40($pop57)
	i64.store	$drop=, 0($pop8), $pop9
	i32.const	$push56=, 0
	i64.load	$push10=, pts+32($pop56)
	i64.store	$drop=, 80($0), $pop10
	i32.const	$push28=, 64
	i32.add 	$push29=, $0, $pop28
	i32.const	$push55=, 8
	i32.add 	$push11=, $pop29, $pop55
	i32.const	$push54=, 0
	i64.load	$push12=, pts+56($pop54)
	i64.store	$drop=, 0($pop11), $pop12
	i32.const	$push53=, 0
	i64.load	$push13=, pts+48($pop53)
	i64.store	$drop=, 64($0), $pop13
	i32.const	$push30=, 64
	i32.add 	$push31=, $0, $pop30
	i32.store	$drop=, 60($0), $pop31
	i32.const	$push32=, 80
	i32.add 	$push33=, $0, $pop32
	i32.store	$drop=, 56($0), $pop33
	i32.const	$push34=, 96
	i32.add 	$push35=, $0, $pop34
	i32.store	$drop=, 52($0), $pop35
	i32.const	$push36=, 112
	i32.add 	$push37=, $0, $pop36
	i32.store	$drop=, 48($0), $pop37
	i32.const	$push38=, 48
	i32.add 	$push39=, $0, $pop38
	call    	va1@FUNCTION, $0, $pop39
	i32.const	$push52=, 0
	i64.load	$push14=, ipts($pop52)
	i64.store	$drop=, 40($0):p2align=2, $pop14
	i32.const	$push51=, 0
	i64.load	$push15=, ipts+8($pop51)
	i64.store	$drop=, 32($0):p2align=2, $pop15
	i32.const	$push50=, 0
	i64.load	$push16=, ipts+16($pop50)
	i64.store	$drop=, 24($0):p2align=2, $pop16
	i32.const	$push49=, 0
	i64.load	$push17=, ipts+24($pop49)
	i64.store	$drop=, 16($0):p2align=2, $pop17
	i32.const	$push40=, 16
	i32.add 	$push41=, $0, $pop40
	i32.store	$drop=, 12($0), $pop41
	i32.const	$push42=, 24
	i32.add 	$push43=, $0, $pop42
	i32.store	$drop=, 8($0), $pop43
	i32.const	$push44=, 32
	i32.add 	$push45=, $0, $pop44
	i32.store	$drop=, 4($0), $pop45
	i32.const	$push46=, 40
	i32.add 	$push47=, $0, $pop46
	i32.store	$drop=, 0($0), $pop47
	call    	va2@FUNCTION, $0, $0
	i32.const	$push48=, 0
	call    	exit@FUNCTION, $pop48
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.va1,"ax",@progbits
	.type	va1,@function
va1:                                    # @va1
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push44=, 0
	i32.const	$push41=, 0
	i32.load	$push42=, __stack_pointer($pop41)
	i32.const	$push43=, 16
	i32.sub 	$push52=, $pop42, $pop43
	tee_local	$push51=, $2=, $pop52
	i32.store	$drop=, __stack_pointer($pop44), $pop51
	i32.store	$drop=, 12($2), $1
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push50=, $pop1, $pop2
	tee_local	$push49=, $1=, $pop50
	i32.const	$push3=, 16
	i32.add 	$push4=, $pop49, $pop3
	i32.store	$drop=, 12($2), $pop4
	block
	i32.const	$push48=, 0
	f64.load	$push6=, pts($pop48)
	f64.load	$push5=, 0($1)
	f64.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push53=, 0
	f64.load	$push9=, pts+8($pop53)
	f64.load	$push8=, 8($1)
	f64.ne  	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %for.cond
	i32.const	$push11=, 32
	i32.add 	$push12=, $1, $pop11
	i32.store	$drop=, 12($2), $pop12
	i32.const	$push54=, 0
	f64.load	$push16=, pts+16($pop54)
	i32.const	$push13=, 16
	i32.add 	$push14=, $1, $pop13
	f64.load	$push15=, 0($pop14)
	f64.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label0
# BB#3:                                 # %lor.lhs.false.1
	i32.const	$push55=, 0
	f64.load	$push19=, pts+24($pop55)
	f64.load	$push18=, 24($1)
	f64.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label0
# BB#4:                                 # %for.cond.1
	i32.const	$push21=, 48
	i32.add 	$push22=, $1, $pop21
	i32.store	$drop=, 12($2), $pop22
	i32.const	$push56=, 0
	f64.load	$push26=, pts+32($pop56)
	i32.const	$push23=, 32
	i32.add 	$push24=, $1, $pop23
	f64.load	$push25=, 0($pop24)
	f64.ne  	$push27=, $pop26, $pop25
	br_if   	0, $pop27       # 0: down to label0
# BB#5:                                 # %lor.lhs.false.2
	i32.const	$push57=, 0
	f64.load	$push29=, pts+40($pop57)
	f64.load	$push28=, 40($1)
	f64.ne  	$push30=, $pop29, $pop28
	br_if   	0, $pop30       # 0: down to label0
# BB#6:                                 # %for.cond.2
	i32.const	$push31=, 64
	i32.add 	$push32=, $1, $pop31
	i32.store	$drop=, 12($2), $pop32
	i32.const	$push58=, 0
	f64.load	$push36=, pts+48($pop58)
	i32.const	$push33=, 48
	i32.add 	$push34=, $1, $pop33
	f64.load	$push35=, 0($pop34)
	f64.ne  	$push37=, $pop36, $pop35
	br_if   	0, $pop37       # 0: down to label0
# BB#7:                                 # %lor.lhs.false.3
	i32.const	$push59=, 0
	f64.load	$push39=, pts+56($pop59)
	f64.load	$push38=, 56($1)
	f64.ne  	$push40=, $pop39, $pop38
	br_if   	0, $pop40       # 0: down to label0
# BB#8:                                 # %for.cond.3
	i32.const	$push47=, 0
	i32.const	$push45=, 16
	i32.add 	$push46=, $2, $pop45
	i32.store	$drop=, __stack_pointer($pop47), $pop46
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
	i32.const	$push53=, 0
	i32.const	$push50=, 0
	i32.load	$push51=, __stack_pointer($pop50)
	i32.const	$push52=, 16
	i32.sub 	$push60=, $pop51, $pop52
	tee_local	$push59=, $3=, $pop60
	i32.store	$drop=, __stack_pointer($pop53), $pop59
	i32.store	$drop=, 12($3), $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $1, $pop0
	i32.store	$drop=, 12($3), $pop1
	block
	i32.const	$push2=, 0
	i64.load	$push58=, ipts($pop2)
	tee_local	$push57=, $2=, $pop58
	i32.wrap/i64	$push3=, $pop57
	i32.load	$push4=, 0($1)
	i32.ne  	$push5=, $pop3, $pop4
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
	i32.store	$drop=, 12($3), $pop12
	i32.const	$push16=, 0
	i64.load	$push62=, ipts+8($pop16)
	tee_local	$push61=, $2=, $pop62
	i32.wrap/i64	$push17=, $pop61
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
	i32.store	$drop=, 12($3), $pop25
	i32.const	$push29=, 0
	i64.load	$push64=, ipts+16($pop29)
	tee_local	$push63=, $2=, $pop64
	i32.wrap/i64	$push30=, $pop63
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
	i32.store	$drop=, 12($3), $pop38
	i32.const	$push42=, 0
	i64.load	$push66=, ipts+24($pop42)
	tee_local	$push65=, $2=, $pop66
	i32.wrap/i64	$push43=, $pop65
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
	i32.const	$push56=, 0
	i32.const	$push54=, 16
	i32.add 	$push55=, $3, $pop54
	i32.store	$drop=, __stack_pointer($pop56), $pop55
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


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
	.functype	abort, void
