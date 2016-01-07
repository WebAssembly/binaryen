	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36034-1.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.load	$1=, x+8($0)
	i64.load	$push0=, x($0)
	i64.store	$discard=, tmp($0), $pop0
	i64.store	$discard=, tmp+8($0), $1
	i64.load	$1=, x+24($0)
	i64.load	$2=, x+32($0)
	i64.load	$3=, x+40($0)
	i64.load	$push1=, x+16($0)
	i64.store	$discard=, tmp+16($0), $pop1
	i64.store	$discard=, tmp+24($0), $1
	i64.store	$discard=, tmp+32($0), $2
	i64.store	$discard=, tmp+40($0), $3
	i64.load	$1=, x+88($0)
	i64.load	$2=, x+96($0)
	i64.load	$3=, x+104($0)
	i64.load	$push2=, x+80($0)
	i64.store	$discard=, tmp+48($0), $pop2
	i64.store	$discard=, tmp+56($0), $1
	i64.store	$discard=, tmp+64($0), $2
	i64.store	$discard=, tmp+72($0), $3
	i64.load	$1=, x+120($0)
	i64.load	$2=, x+160($0)
	i64.load	$3=, x+168($0)
	i64.load	$push3=, x+112($0)
	i64.store	$discard=, tmp+80($0), $pop3
	i64.store	$discard=, tmp+88($0), $1
	i64.store	$discard=, tmp+96($0), $2
	i64.store	$discard=, tmp+104($0), $3
	i64.load	$1=, x+184($0)
	i64.load	$2=, x+192($0)
	i64.load	$3=, x+200($0)
	i64.load	$push4=, x+176($0)
	i64.store	$discard=, tmp+112($0), $pop4
	i64.store	$discard=, tmp+120($0), $1
	i64.store	$discard=, tmp+128($0), $2
	i64.store	$discard=, tmp+136($0), $3
	i64.load	$1=, x+248($0)
	i64.load	$2=, x+256($0)
	i64.load	$3=, x+264($0)
	i64.load	$push5=, x+240($0)
	i64.store	$discard=, tmp+144($0), $pop5
	i64.store	$discard=, tmp+152($0), $1
	i64.store	$discard=, tmp+160($0), $2
	i64.store	$discard=, tmp+168($0), $3
	i64.load	$1=, x+280($0)
	i64.load	$2=, x+320($0)
	i64.load	$3=, x+328($0)
	i64.load	$push6=, x+272($0)
	i64.store	$discard=, tmp+176($0), $pop6
	i64.store	$discard=, tmp+184($0), $1
	i64.store	$discard=, tmp+192($0), $2
	i64.store	$discard=, tmp+200($0), $3
	i64.load	$1=, x+344($0)
	i64.load	$2=, x+352($0)
	i64.load	$3=, x+360($0)
	i64.load	$push7=, x+336($0)
	i64.store	$discard=, tmp+208($0), $pop7
	i64.store	$discard=, tmp+216($0), $1
	i64.store	$discard=, tmp+224($0), $2
	i64.store	$discard=, tmp+232($0), $3
	return
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64
# BB#0:                                 # %entry
	call    	test
	i32.const	$0=, 0
	f64.const	$1=, -0x1p0
	block   	.LBB1_31
	f64.load	$push29=, tmp($0)
	f64.eq  	$push30=, $pop29, $1
	br_if   	$pop30, .LBB1_31
# BB#1:                                 # %entry
	f64.load	$push0=, tmp+8($0)
	f64.eq  	$push31=, $pop0, $1
	br_if   	$pop31, .LBB1_31
# BB#2:                                 # %entry
	f64.load	$push1=, tmp+16($0)
	f64.eq  	$push32=, $pop1, $1
	br_if   	$pop32, .LBB1_31
# BB#3:                                 # %entry
	f64.load	$push2=, tmp+24($0)
	f64.eq  	$push33=, $pop2, $1
	br_if   	$pop33, .LBB1_31
# BB#4:                                 # %entry
	f64.load	$push3=, tmp+32($0)
	f64.eq  	$push34=, $pop3, $1
	br_if   	$pop34, .LBB1_31
# BB#5:                                 # %entry
	f64.load	$push4=, tmp+40($0)
	f64.eq  	$push35=, $pop4, $1
	br_if   	$pop35, .LBB1_31
# BB#6:                                 # %entry
	f64.load	$push5=, tmp+48($0)
	f64.eq  	$push36=, $pop5, $1
	br_if   	$pop36, .LBB1_31
# BB#7:                                 # %entry
	f64.load	$push6=, tmp+56($0)
	f64.eq  	$push37=, $pop6, $1
	br_if   	$pop37, .LBB1_31
# BB#8:                                 # %entry
	f64.load	$push7=, tmp+64($0)
	f64.eq  	$push38=, $pop7, $1
	br_if   	$pop38, .LBB1_31
# BB#9:                                 # %entry
	f64.load	$push8=, tmp+72($0)
	f64.eq  	$push39=, $pop8, $1
	br_if   	$pop39, .LBB1_31
# BB#10:                                # %entry
	f64.load	$push9=, tmp+80($0)
	f64.eq  	$push40=, $pop9, $1
	br_if   	$pop40, .LBB1_31
# BB#11:                                # %entry
	f64.load	$push10=, tmp+88($0)
	f64.eq  	$push41=, $pop10, $1
	br_if   	$pop41, .LBB1_31
# BB#12:                                # %entry
	f64.load	$push11=, tmp+96($0)
	f64.eq  	$push42=, $pop11, $1
	br_if   	$pop42, .LBB1_31
# BB#13:                                # %entry
	f64.load	$push12=, tmp+104($0)
	f64.eq  	$push43=, $pop12, $1
	br_if   	$pop43, .LBB1_31
# BB#14:                                # %entry
	f64.load	$push13=, tmp+112($0)
	f64.eq  	$push44=, $pop13, $1
	br_if   	$pop44, .LBB1_31
# BB#15:                                # %entry
	f64.load	$push14=, tmp+120($0)
	f64.eq  	$push45=, $pop14, $1
	br_if   	$pop45, .LBB1_31
# BB#16:                                # %entry
	f64.load	$push15=, tmp+128($0)
	f64.eq  	$push46=, $pop15, $1
	br_if   	$pop46, .LBB1_31
# BB#17:                                # %entry
	f64.load	$push16=, tmp+136($0)
	f64.eq  	$push47=, $pop16, $1
	br_if   	$pop47, .LBB1_31
# BB#18:                                # %entry
	f64.load	$push17=, tmp+144($0)
	f64.eq  	$push48=, $pop17, $1
	br_if   	$pop48, .LBB1_31
# BB#19:                                # %entry
	f64.load	$push18=, tmp+152($0)
	f64.eq  	$push49=, $pop18, $1
	br_if   	$pop49, .LBB1_31
# BB#20:                                # %entry
	f64.load	$push19=, tmp+160($0)
	f64.eq  	$push50=, $pop19, $1
	br_if   	$pop50, .LBB1_31
# BB#21:                                # %entry
	f64.load	$push20=, tmp+168($0)
	f64.eq  	$push51=, $pop20, $1
	br_if   	$pop51, .LBB1_31
# BB#22:                                # %entry
	f64.load	$push21=, tmp+176($0)
	f64.eq  	$push52=, $pop21, $1
	br_if   	$pop52, .LBB1_31
# BB#23:                                # %entry
	f64.load	$push22=, tmp+184($0)
	f64.eq  	$push53=, $pop22, $1
	br_if   	$pop53, .LBB1_31
# BB#24:                                # %entry
	f64.load	$push23=, tmp+192($0)
	f64.eq  	$push54=, $pop23, $1
	br_if   	$pop54, .LBB1_31
# BB#25:                                # %entry
	f64.load	$push24=, tmp+200($0)
	f64.eq  	$push55=, $pop24, $1
	br_if   	$pop55, .LBB1_31
# BB#26:                                # %entry
	f64.load	$push25=, tmp+208($0)
	f64.eq  	$push56=, $pop25, $1
	br_if   	$pop56, .LBB1_31
# BB#27:                                # %entry
	f64.load	$push26=, tmp+216($0)
	f64.eq  	$push57=, $pop26, $1
	br_if   	$pop57, .LBB1_31
# BB#28:                                # %entry
	f64.load	$push27=, tmp+224($0)
	f64.eq  	$push58=, $pop27, $1
	br_if   	$pop58, .LBB1_31
# BB#29:                                # %entry
	f64.load	$push28=, tmp+232($0)
	f64.eq  	$push59=, $pop28, $1
	br_if   	$pop59, .LBB1_31
# BB#30:                                # %for.cond1.5.4
	return  	$0
.LBB1_31:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	x,@object               # @x
	.data
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

	.type	tmp,@object             # @tmp
	.bss
	.globl	tmp
	.align	4
tmp:
	.zero	240
	.size	tmp, 240


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
