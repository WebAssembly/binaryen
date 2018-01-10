	.text
	.file	"920625-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 128
	i32.sub 	$0=, $pop18, $pop20
	i32.const	$push21=, 0
	i32.store	__stack_pointer($pop21), $0
	i32.const	$push22=, 112
	i32.add 	$push23=, $0, $pop22
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop23, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, pts+8($pop0)
	i64.store	0($pop3), $pop1
	i32.const	$push24=, 96
	i32.add 	$push25=, $0, $pop24
	i32.const	$push62=, 8
	i32.add 	$push5=, $pop25, $pop62
	i32.const	$push61=, 0
	i64.load	$push4=, pts+24($pop61)
	i64.store	0($pop5), $pop4
	i32.const	$push26=, 80
	i32.add 	$push27=, $0, $pop26
	i32.const	$push60=, 8
	i32.add 	$push7=, $pop27, $pop60
	i32.const	$push59=, 0
	i64.load	$push6=, pts+40($pop59)
	i64.store	0($pop7), $pop6
	i32.const	$push28=, 64
	i32.add 	$push29=, $0, $pop28
	i32.const	$push58=, 8
	i32.add 	$push9=, $pop29, $pop58
	i32.const	$push57=, 0
	i64.load	$push8=, pts+56($pop57)
	i64.store	0($pop9), $pop8
	i32.const	$push56=, 0
	i64.load	$push10=, pts($pop56)
	i64.store	112($0), $pop10
	i32.const	$push55=, 0
	i64.load	$push11=, pts+16($pop55)
	i64.store	96($0), $pop11
	i32.const	$push54=, 0
	i64.load	$push12=, pts+32($pop54)
	i64.store	80($0), $pop12
	i32.const	$push53=, 0
	i64.load	$push13=, pts+48($pop53)
	i64.store	64($0), $pop13
	i32.const	$push30=, 64
	i32.add 	$push31=, $0, $pop30
	i32.store	60($0), $pop31
	i32.const	$push32=, 80
	i32.add 	$push33=, $0, $pop32
	i32.store	56($0), $pop33
	i32.const	$push34=, 96
	i32.add 	$push35=, $0, $pop34
	i32.store	52($0), $pop35
	i32.const	$push36=, 112
	i32.add 	$push37=, $0, $pop36
	i32.store	48($0), $pop37
	i32.const	$push38=, 48
	i32.add 	$push39=, $0, $pop38
	call    	va1@FUNCTION, $0, $pop39
	i32.const	$push52=, 0
	i64.load	$push14=, ipts($pop52)
	i64.store	40($0), $pop14
	i32.const	$push51=, 0
	i64.load	$push15=, ipts+8($pop51)
	i64.store	32($0), $pop15
	i32.const	$push50=, 0
	i64.load	$push16=, ipts+16($pop50)
	i64.store	24($0), $pop16
	i32.const	$push49=, 0
	i64.load	$push17=, ipts+24($pop49)
	i64.store	16($0), $pop17
	i32.const	$push40=, 16
	i32.add 	$push41=, $0, $pop40
	i32.store	12($0), $pop41
	i32.const	$push42=, 24
	i32.add 	$push43=, $0, $pop42
	i32.store	8($0), $pop43
	i32.const	$push44=, 32
	i32.add 	$push45=, $0, $pop44
	i32.store	4($0), $pop45
	i32.const	$push46=, 40
	i32.add 	$push47=, $0, $pop46
	i32.store	0($0), $pop47
	call    	va2@FUNCTION, $0, $0
	i32.const	$push48=, 0
	call    	exit@FUNCTION, $pop48
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.va1,"ax",@progbits
	.type	va1,@function           # -- Begin function va1
va1:                                    # @va1
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push42=, 0
	i32.load	$push41=, __stack_pointer($pop42)
	i32.const	$push43=, 16
	i32.sub 	$2=, $pop41, $pop43
	i32.const	$push44=, 0
	i32.store	__stack_pointer($pop44), $2
	i32.store	12($2), $1
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$1=, $pop1, $pop2
	i32.const	$push3=, 16
	i32.add 	$push4=, $1, $pop3
	i32.store	12($2), $pop4
	block   	
	i32.const	$push48=, 0
	f64.load	$push6=, pts($pop48)
	f64.load	$push5=, 0($1)
	f64.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push49=, 0
	f64.load	$push9=, pts+8($pop49)
	f64.load	$push8=, 8($1)
	f64.ne  	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label0
# %bb.2:                                # %for.cond
	i32.const	$push11=, 32
	i32.add 	$push12=, $1, $pop11
	i32.store	12($2), $pop12
	i32.const	$push50=, 0
	f64.load	$push16=, pts+16($pop50)
	i32.const	$push13=, 16
	i32.add 	$push14=, $1, $pop13
	f64.load	$push15=, 0($pop14)
	f64.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label0
# %bb.3:                                # %lor.lhs.false.1
	i32.const	$push51=, 0
	f64.load	$push19=, pts+24($pop51)
	f64.load	$push18=, 24($1)
	f64.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label0
# %bb.4:                                # %for.cond.1
	i32.const	$push21=, 48
	i32.add 	$push22=, $1, $pop21
	i32.store	12($2), $pop22
	i32.const	$push52=, 0
	f64.load	$push26=, pts+32($pop52)
	i32.const	$push23=, 32
	i32.add 	$push24=, $1, $pop23
	f64.load	$push25=, 0($pop24)
	f64.ne  	$push27=, $pop26, $pop25
	br_if   	0, $pop27       # 0: down to label0
# %bb.5:                                # %lor.lhs.false.2
	i32.const	$push53=, 0
	f64.load	$push29=, pts+40($pop53)
	f64.load	$push28=, 40($1)
	f64.ne  	$push30=, $pop29, $pop28
	br_if   	0, $pop30       # 0: down to label0
# %bb.6:                                # %for.cond.2
	i32.const	$push31=, 64
	i32.add 	$push32=, $1, $pop31
	i32.store	12($2), $pop32
	i32.const	$push54=, 0
	f64.load	$push36=, pts+48($pop54)
	i32.const	$push33=, 48
	i32.add 	$push34=, $1, $pop33
	f64.load	$push35=, 0($pop34)
	f64.ne  	$push37=, $pop36, $pop35
	br_if   	0, $pop37       # 0: down to label0
# %bb.7:                                # %lor.lhs.false.3
	i32.const	$push55=, 0
	f64.load	$push39=, pts+56($pop55)
	f64.load	$push38=, 56($1)
	f64.ne  	$push40=, $pop39, $pop38
	br_if   	0, $pop40       # 0: down to label0
# %bb.8:                                # %for.cond.3
	i32.const	$push47=, 0
	i32.const	$push45=, 16
	i32.add 	$push46=, $2, $pop45
	i32.store	__stack_pointer($pop47), $pop46
	return
.LBB1_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	va1, .Lfunc_end1-va1
                                        # -- End function
	.section	.text.va2,"ax",@progbits
	.type	va2,@function           # -- Begin function va2
va2:                                    # @va2
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push39=, 0
	i32.load	$push38=, __stack_pointer($pop39)
	i32.const	$push40=, 16
	i32.sub 	$2=, $pop38, $pop40
	i32.const	$push41=, 0
	i32.store	__stack_pointer($pop41), $2
	i32.store	12($2), $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $1, $pop0
	i32.store	12($2), $pop1
	block   	
	i32.const	$push45=, 0
	i32.load	$push2=, ipts($pop45)
	i32.load	$push3=, 0($1)
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# %bb.1:                                # %lor.lhs.false
	i32.const	$push46=, 0
	i32.load	$push6=, ipts+4($pop46)
	i32.load	$push5=, 4($1)
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label1
# %bb.2:                                # %for.cond
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.store	12($2), $pop9
	i32.const	$push47=, 0
	i32.load	$push13=, ipts+8($pop47)
	i32.const	$push10=, 8
	i32.add 	$push11=, $1, $pop10
	i32.load	$push12=, 0($pop11)
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	0, $pop14       # 0: down to label1
# %bb.3:                                # %lor.lhs.false.1
	i32.const	$push48=, 0
	i32.load	$push16=, ipts+12($pop48)
	i32.load	$push15=, 12($1)
	i32.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label1
# %bb.4:                                # %for.cond.1
	i32.const	$push18=, 24
	i32.add 	$push19=, $1, $pop18
	i32.store	12($2), $pop19
	i32.const	$push49=, 0
	i32.load	$push23=, ipts+16($pop49)
	i32.const	$push20=, 16
	i32.add 	$push21=, $1, $pop20
	i32.load	$push22=, 0($pop21)
	i32.ne  	$push24=, $pop23, $pop22
	br_if   	0, $pop24       # 0: down to label1
# %bb.5:                                # %lor.lhs.false.2
	i32.const	$push50=, 0
	i32.load	$push26=, ipts+20($pop50)
	i32.load	$push25=, 20($1)
	i32.ne  	$push27=, $pop26, $pop25
	br_if   	0, $pop27       # 0: down to label1
# %bb.6:                                # %for.cond.2
	i32.const	$push28=, 32
	i32.add 	$push29=, $1, $pop28
	i32.store	12($2), $pop29
	i32.const	$push51=, 0
	i32.load	$push33=, ipts+24($pop51)
	i32.const	$push30=, 24
	i32.add 	$push31=, $1, $pop30
	i32.load	$push32=, 0($pop31)
	i32.ne  	$push34=, $pop33, $pop32
	br_if   	0, $pop34       # 0: down to label1
# %bb.7:                                # %lor.lhs.false.3
	i32.const	$push52=, 0
	i32.load	$push36=, ipts+28($pop52)
	i32.load	$push35=, 28($1)
	i32.ne  	$push37=, $pop36, $pop35
	br_if   	0, $pop37       # 0: down to label1
# %bb.8:                                # %for.cond.3
	i32.const	$push44=, 0
	i32.const	$push42=, 16
	i32.add 	$push43=, $2, $pop42
	i32.store	__stack_pointer($pop44), $pop43
	return
.LBB2_9:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	va2, .Lfunc_end2-va2
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
