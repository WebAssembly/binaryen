	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36034-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, tmp
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i64.load	$0=, x+16($3)
	i32.const	$push15=, 8
	i32.add 	$push1=, $2, $pop15
	i64.load	$push0=, x+8($3)
	i64.store	$discard=, 0($pop1), $pop0
	i64.load	$1=, x+24($3)
	i32.const	$push14=, 16
	i32.add 	$push2=, $2, $pop14
	i64.store	$discard=, 0($pop2), $0
	i32.const	$push13=, 24
	i32.add 	$push3=, $2, $pop13
	i64.store	$discard=, 0($pop3), $1
	i64.load	$0=, x($3)
	i64.load	$1=, x+40($3)
	i32.const	$push12=, 32
	i32.add 	$push5=, $2, $pop12
	i64.load	$push4=, x+32($3)
	i64.store	$discard=, 0($pop5), $pop4
	i32.const	$push11=, 40
	i32.add 	$push6=, $2, $pop11
	i64.store	$discard=, 0($pop6), $1
	i64.store	$discard=, 0($2), $0
	i32.const	$push10=, 80
	i32.add 	$3=, $3, $pop10
	i32.const	$push9=, 48
	i32.add 	$2=, $2, $pop9
	i32.const	$push8=, 400
	i32.ne  	$push7=, $3, $pop8
	br_if   	0, $pop7        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	return
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	call    	test@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, tmp
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	f64.load	$push0=, 0($0)
	f64.const	$push19=, -0x1p0
	f64.eq  	$push1=, $pop0, $pop19
	br_if   	2, $pop1        # 2: down to label2
# BB#2:                                 # %for.cond1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push21=, 8
	i32.add 	$push2=, $0, $pop21
	f64.load	$push3=, 0($pop2)
	f64.const	$push20=, -0x1p0
	f64.eq  	$push4=, $pop3, $pop20
	br_if   	2, $pop4        # 2: down to label2
# BB#3:                                 # %for.cond1.1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push23=, 16
	i32.add 	$push5=, $0, $pop23
	f64.load	$push6=, 0($pop5)
	f64.const	$push22=, -0x1p0
	f64.eq  	$push7=, $pop6, $pop22
	br_if   	2, $pop7        # 2: down to label2
# BB#4:                                 # %for.cond1.2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push25=, 24
	i32.add 	$push8=, $0, $pop25
	f64.load	$push9=, 0($pop8)
	f64.const	$push24=, -0x1p0
	f64.eq  	$push10=, $pop9, $pop24
	br_if   	2, $pop10       # 2: down to label2
# BB#5:                                 # %for.cond1.3
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push27=, 32
	i32.add 	$push11=, $0, $pop27
	f64.load	$push12=, 0($pop11)
	f64.const	$push26=, -0x1p0
	f64.eq  	$push13=, $pop12, $pop26
	br_if   	2, $pop13       # 2: down to label2
# BB#6:                                 # %for.cond1.4
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push29=, 40
	i32.add 	$push14=, $0, $pop29
	f64.load	$push15=, 0($pop14)
	f64.const	$push28=, -0x1p0
	f64.eq  	$push16=, $pop15, $pop28
	br_if   	2, $pop16       # 2: down to label2
# BB#7:                                 # %for.cond1.5
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push32=, 1
	i32.add 	$1=, $1, $pop32
	i32.const	$push31=, 48
	i32.add 	$0=, $0, $pop31
	i32.const	$push30=, 5
	i32.lt_s	$push17=, $1, $pop30
	br_if   	0, $pop17       # 0: up to label3
# BB#8:                                 # %for.end7
	end_loop                        # label4:
	i32.const	$push18=, 0
	return  	$pop18
.LBB1_9:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	4
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
	.p2align	4
tmp:
	.skip	240
	.size	tmp, 240


	.ident	"clang version 3.9.0 "
