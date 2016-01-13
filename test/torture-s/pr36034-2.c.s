	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36034-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i64, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$5=, tmp
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push0=, x
	i32.add 	$0=, $pop0, $6
	i32.const	$2=, 8
	i64.load	$1=, 0($0)
	i32.add 	$push3=, $5, $2
	i32.add 	$push1=, $0, $2
	i64.load	$push2=, 0($pop1)
	i64.store	$discard=, 0($pop3), $pop2
	i32.const	$2=, 16
	i32.const	$3=, 24
	i32.add 	$push7=, $0, $3
	i64.load	$4=, 0($pop7)
	i32.add 	$push6=, $5, $2
	i32.add 	$push4=, $0, $2
	i64.load	$push5=, 0($pop4)
	i64.store	$discard=, 0($pop6), $pop5
	i32.add 	$push8=, $5, $3
	i64.store	$discard=, 0($pop8), $4
	i32.const	$2=, 32
	i32.const	$3=, 40
	i32.add 	$push12=, $0, $3
	i64.load	$4=, 0($pop12)
	i32.add 	$push11=, $5, $2
	i32.add 	$push9=, $0, $2
	i64.load	$push10=, 0($pop9)
	i64.store	$discard=, 0($pop11), $pop10
	i32.add 	$push13=, $5, $3
	i64.store	$discard=, 0($pop13), $4
	i32.const	$push14=, 80
	i32.add 	$6=, $6, $pop14
	i64.store	$discard=, 0($5), $1
	i32.const	$push15=, 48
	i32.add 	$5=, $5, $pop15
	i32.const	$push16=, 400
	i32.ne  	$push17=, $6, $pop16
	br_if   	$pop17, .LBB0_1
.LBB0_2:                                # %for.end
	return
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i32, i32
# BB#0:                                 # %entry
	call    	test@FUNCTION
	i32.const	$2=, 0
	i32.const	$1=, tmp
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB1_9
	loop    	.LBB1_8
	f64.const	$0=, -0x1p0
	f64.load	$push0=, 0($1)
	f64.eq  	$push1=, $pop0, $0
	br_if   	$pop1, .LBB1_9
# BB#2:                                 # %for.cond1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push2=, 8
	i32.add 	$push3=, $1, $pop2
	f64.load	$push4=, 0($pop3)
	f64.eq  	$push5=, $pop4, $0
	br_if   	$pop5, .LBB1_9
# BB#3:                                 # %for.cond1.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	f64.load	$push8=, 0($pop7)
	f64.eq  	$push9=, $pop8, $0
	br_if   	$pop9, .LBB1_9
# BB#4:                                 # %for.cond1.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, 24
	i32.add 	$push11=, $1, $pop10
	f64.load	$push12=, 0($pop11)
	f64.eq  	$push13=, $pop12, $0
	br_if   	$pop13, .LBB1_9
# BB#5:                                 # %for.cond1.3
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push14=, 32
	i32.add 	$push15=, $1, $pop14
	f64.load	$push16=, 0($pop15)
	f64.eq  	$push17=, $pop16, $0
	br_if   	$pop17, .LBB1_9
# BB#6:                                 # %for.cond1.4
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, 40
	i32.add 	$push19=, $1, $pop18
	f64.load	$push20=, 0($pop19)
	f64.eq  	$push21=, $pop20, $0
	br_if   	$pop21, .LBB1_9
# BB#7:                                 # %for.cond1.5
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push22=, 1
	i32.add 	$2=, $2, $pop22
	i32.const	$push23=, 48
	i32.add 	$1=, $1, $pop23
	i32.const	$push24=, 5
	i32.lt_s	$push25=, $2, $pop24
	br_if   	$pop25, .LBB1_1
.LBB1_8:                                # %for.end7
	i32.const	$push26=, 0
	return  	$pop26
.LBB1_9:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	4
x:
	.int64	4621819117588971520     # double 10
	.int64	4622382067542392832     # double 11
	.int64	4622945017495814144     # double 12
	.int64	4623507967449235456     # double 13
	.int64	4624070917402656768     # double 14
	.int64	4624633867356078080     # double 15
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	4626604192193052672     # double 21
	.int64	4626885667169763328     # double 22
	.int64	4627167142146473984     # double 23
	.int64	4627448617123184640     # double 24
	.int64	4627730092099895296     # double 25
	.int64	4628011567076605952     # double 26
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	4629700416936869888     # double 32
	.int64	4629841154425225216     # double 33
	.int64	4629981891913580544     # double 34
	.int64	4630122629401935872     # double 35
	.int64	4630263366890291200     # double 36
	.int64	4630404104378646528     # double 37
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	4631248529308778496     # double 43
	.int64	4631389266797133824     # double 44
	.int64	4631530004285489152     # double 45
	.int64	4631670741773844480     # double 46
	.int64	4631811479262199808     # double 47
	.int64	4631952216750555136     # double 48
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	4632796641680687104     # double 54
	.int64	4632937379169042432     # double 55
	.int64	4633078116657397760     # double 56
	.int64	4633218854145753088     # double 57
	.int64	4633359591634108416     # double 58
	.int64	4633500329122463744     # double 59
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.int64	-4616189618054758400    # double -1
	.size	x, 400

	.hidden	tmp                     # @tmp
	.type	tmp,@object
	.section	.bss.tmp,"aw",@nobits
	.globl	tmp
	.align	4
tmp:
	.skip	240
	.size	tmp, 240


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
