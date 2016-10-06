	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36034-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push89=, 0
	i64.load	$push1=, x($pop89)
	i64.store	tmp($pop0), $pop1
	i32.const	$push88=, 0
	i32.const	$push87=, 0
	i64.load	$push2=, x+8($pop87)
	i64.store	tmp+8($pop88), $pop2
	i32.const	$push86=, 0
	i32.const	$push85=, 0
	i64.load	$push3=, x+16($pop85)
	i64.store	tmp+16($pop86), $pop3
	i32.const	$push84=, 0
	i32.const	$push83=, 0
	i64.load	$push4=, x+24($pop83)
	i64.store	tmp+24($pop84), $pop4
	i32.const	$push82=, 0
	i32.const	$push81=, 0
	i64.load	$push5=, x+32($pop81)
	i64.store	tmp+32($pop82), $pop5
	i32.const	$push80=, 0
	i32.const	$push79=, 0
	i64.load	$push6=, x+40($pop79)
	i64.store	tmp+40($pop80), $pop6
	i32.const	$push78=, 0
	i32.const	$push77=, 0
	i64.load	$push7=, x+80($pop77)
	i64.store	tmp+48($pop78), $pop7
	i32.const	$push76=, 0
	i32.const	$push75=, 0
	i64.load	$push8=, x+88($pop75)
	i64.store	tmp+56($pop76), $pop8
	i32.const	$push74=, 0
	i32.const	$push73=, 0
	i64.load	$push9=, x+96($pop73)
	i64.store	tmp+64($pop74), $pop9
	i32.const	$push72=, 0
	i32.const	$push71=, 0
	i64.load	$push10=, x+104($pop71)
	i64.store	tmp+72($pop72), $pop10
	i32.const	$push70=, 0
	i32.const	$push69=, 0
	i64.load	$push11=, x+112($pop69)
	i64.store	tmp+80($pop70), $pop11
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i64.load	$push12=, x+120($pop67)
	i64.store	tmp+88($pop68), $pop12
	i32.const	$push66=, 0
	i32.const	$push65=, 0
	i64.load	$push13=, x+160($pop65)
	i64.store	tmp+96($pop66), $pop13
	i32.const	$push64=, 0
	i32.const	$push63=, 0
	i64.load	$push14=, x+168($pop63)
	i64.store	tmp+104($pop64), $pop14
	i32.const	$push62=, 0
	i32.const	$push61=, 0
	i64.load	$push15=, x+176($pop61)
	i64.store	tmp+112($pop62), $pop15
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i64.load	$push16=, x+184($pop59)
	i64.store	tmp+120($pop60), $pop16
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i64.load	$push17=, x+192($pop57)
	i64.store	tmp+128($pop58), $pop17
	i32.const	$push56=, 0
	i32.const	$push55=, 0
	i64.load	$push18=, x+200($pop55)
	i64.store	tmp+136($pop56), $pop18
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	i64.load	$push19=, x+240($pop53)
	i64.store	tmp+144($pop54), $pop19
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i64.load	$push20=, x+248($pop51)
	i64.store	tmp+152($pop52), $pop20
	i32.const	$push50=, 0
	i32.const	$push49=, 0
	i64.load	$push21=, x+256($pop49)
	i64.store	tmp+160($pop50), $pop21
	i32.const	$push48=, 0
	i32.const	$push47=, 0
	i64.load	$push22=, x+264($pop47)
	i64.store	tmp+168($pop48), $pop22
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i64.load	$push23=, x+272($pop45)
	i64.store	tmp+176($pop46), $pop23
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i64.load	$push24=, x+280($pop43)
	i64.store	tmp+184($pop44), $pop24
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i64.load	$push25=, x+320($pop41)
	i64.store	tmp+192($pop42), $pop25
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i64.load	$push26=, x+328($pop39)
	i64.store	tmp+200($pop40), $pop26
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i64.load	$push27=, x+336($pop37)
	i64.store	tmp+208($pop38), $pop27
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i64.load	$push28=, x+344($pop35)
	i64.store	tmp+216($pop36), $pop28
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i64.load	$push29=, x+352($pop33)
	i64.store	tmp+224($pop34), $pop29
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i64.load	$push30=, x+360($pop31)
	i64.store	tmp+232($pop32), $pop30
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	test@FUNCTION
	block   	
	i32.const	$push62=, 0
	f64.load	$push29=, tmp($pop62)
	f64.const	$push61=, -0x1p0
	f64.eq  	$push30=, $pop29, $pop61
	br_if   	0, $pop30       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push64=, 0
	f64.load	$push0=, tmp+8($pop64)
	f64.const	$push63=, -0x1p0
	f64.eq  	$push31=, $pop0, $pop63
	br_if   	0, $pop31       # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push66=, 0
	f64.load	$push1=, tmp+16($pop66)
	f64.const	$push65=, -0x1p0
	f64.eq  	$push32=, $pop1, $pop65
	br_if   	0, $pop32       # 0: down to label0
# BB#3:                                 # %entry
	i32.const	$push68=, 0
	f64.load	$push2=, tmp+24($pop68)
	f64.const	$push67=, -0x1p0
	f64.eq  	$push33=, $pop2, $pop67
	br_if   	0, $pop33       # 0: down to label0
# BB#4:                                 # %entry
	i32.const	$push70=, 0
	f64.load	$push3=, tmp+32($pop70)
	f64.const	$push69=, -0x1p0
	f64.eq  	$push34=, $pop3, $pop69
	br_if   	0, $pop34       # 0: down to label0
# BB#5:                                 # %entry
	i32.const	$push72=, 0
	f64.load	$push4=, tmp+40($pop72)
	f64.const	$push71=, -0x1p0
	f64.eq  	$push35=, $pop4, $pop71
	br_if   	0, $pop35       # 0: down to label0
# BB#6:                                 # %entry
	i32.const	$push74=, 0
	f64.load	$push5=, tmp+48($pop74)
	f64.const	$push73=, -0x1p0
	f64.eq  	$push36=, $pop5, $pop73
	br_if   	0, $pop36       # 0: down to label0
# BB#7:                                 # %entry
	i32.const	$push76=, 0
	f64.load	$push6=, tmp+56($pop76)
	f64.const	$push75=, -0x1p0
	f64.eq  	$push37=, $pop6, $pop75
	br_if   	0, $pop37       # 0: down to label0
# BB#8:                                 # %entry
	i32.const	$push78=, 0
	f64.load	$push7=, tmp+64($pop78)
	f64.const	$push77=, -0x1p0
	f64.eq  	$push38=, $pop7, $pop77
	br_if   	0, $pop38       # 0: down to label0
# BB#9:                                 # %entry
	i32.const	$push80=, 0
	f64.load	$push8=, tmp+72($pop80)
	f64.const	$push79=, -0x1p0
	f64.eq  	$push39=, $pop8, $pop79
	br_if   	0, $pop39       # 0: down to label0
# BB#10:                                # %entry
	i32.const	$push82=, 0
	f64.load	$push9=, tmp+80($pop82)
	f64.const	$push81=, -0x1p0
	f64.eq  	$push40=, $pop9, $pop81
	br_if   	0, $pop40       # 0: down to label0
# BB#11:                                # %entry
	i32.const	$push84=, 0
	f64.load	$push10=, tmp+88($pop84)
	f64.const	$push83=, -0x1p0
	f64.eq  	$push41=, $pop10, $pop83
	br_if   	0, $pop41       # 0: down to label0
# BB#12:                                # %entry
	i32.const	$push86=, 0
	f64.load	$push11=, tmp+96($pop86)
	f64.const	$push85=, -0x1p0
	f64.eq  	$push42=, $pop11, $pop85
	br_if   	0, $pop42       # 0: down to label0
# BB#13:                                # %entry
	i32.const	$push88=, 0
	f64.load	$push12=, tmp+104($pop88)
	f64.const	$push87=, -0x1p0
	f64.eq  	$push43=, $pop12, $pop87
	br_if   	0, $pop43       # 0: down to label0
# BB#14:                                # %entry
	i32.const	$push90=, 0
	f64.load	$push13=, tmp+112($pop90)
	f64.const	$push89=, -0x1p0
	f64.eq  	$push44=, $pop13, $pop89
	br_if   	0, $pop44       # 0: down to label0
# BB#15:                                # %entry
	i32.const	$push92=, 0
	f64.load	$push14=, tmp+120($pop92)
	f64.const	$push91=, -0x1p0
	f64.eq  	$push45=, $pop14, $pop91
	br_if   	0, $pop45       # 0: down to label0
# BB#16:                                # %entry
	i32.const	$push94=, 0
	f64.load	$push15=, tmp+128($pop94)
	f64.const	$push93=, -0x1p0
	f64.eq  	$push46=, $pop15, $pop93
	br_if   	0, $pop46       # 0: down to label0
# BB#17:                                # %entry
	i32.const	$push96=, 0
	f64.load	$push16=, tmp+136($pop96)
	f64.const	$push95=, -0x1p0
	f64.eq  	$push47=, $pop16, $pop95
	br_if   	0, $pop47       # 0: down to label0
# BB#18:                                # %entry
	i32.const	$push98=, 0
	f64.load	$push17=, tmp+144($pop98)
	f64.const	$push97=, -0x1p0
	f64.eq  	$push48=, $pop17, $pop97
	br_if   	0, $pop48       # 0: down to label0
# BB#19:                                # %entry
	i32.const	$push100=, 0
	f64.load	$push18=, tmp+152($pop100)
	f64.const	$push99=, -0x1p0
	f64.eq  	$push49=, $pop18, $pop99
	br_if   	0, $pop49       # 0: down to label0
# BB#20:                                # %entry
	i32.const	$push102=, 0
	f64.load	$push19=, tmp+160($pop102)
	f64.const	$push101=, -0x1p0
	f64.eq  	$push50=, $pop19, $pop101
	br_if   	0, $pop50       # 0: down to label0
# BB#21:                                # %entry
	i32.const	$push104=, 0
	f64.load	$push20=, tmp+168($pop104)
	f64.const	$push103=, -0x1p0
	f64.eq  	$push51=, $pop20, $pop103
	br_if   	0, $pop51       # 0: down to label0
# BB#22:                                # %entry
	i32.const	$push106=, 0
	f64.load	$push21=, tmp+176($pop106)
	f64.const	$push105=, -0x1p0
	f64.eq  	$push52=, $pop21, $pop105
	br_if   	0, $pop52       # 0: down to label0
# BB#23:                                # %entry
	i32.const	$push108=, 0
	f64.load	$push22=, tmp+184($pop108)
	f64.const	$push107=, -0x1p0
	f64.eq  	$push53=, $pop22, $pop107
	br_if   	0, $pop53       # 0: down to label0
# BB#24:                                # %entry
	i32.const	$push110=, 0
	f64.load	$push23=, tmp+192($pop110)
	f64.const	$push109=, -0x1p0
	f64.eq  	$push54=, $pop23, $pop109
	br_if   	0, $pop54       # 0: down to label0
# BB#25:                                # %entry
	i32.const	$push112=, 0
	f64.load	$push24=, tmp+200($pop112)
	f64.const	$push111=, -0x1p0
	f64.eq  	$push55=, $pop24, $pop111
	br_if   	0, $pop55       # 0: down to label0
# BB#26:                                # %entry
	i32.const	$push114=, 0
	f64.load	$push25=, tmp+208($pop114)
	f64.const	$push113=, -0x1p0
	f64.eq  	$push56=, $pop25, $pop113
	br_if   	0, $pop56       # 0: down to label0
# BB#27:                                # %entry
	i32.const	$push116=, 0
	f64.load	$push26=, tmp+216($pop116)
	f64.const	$push115=, -0x1p0
	f64.eq  	$push57=, $pop26, $pop115
	br_if   	0, $pop57       # 0: down to label0
# BB#28:                                # %entry
	i32.const	$push118=, 0
	f64.load	$push27=, tmp+224($pop118)
	f64.const	$push117=, -0x1p0
	f64.eq  	$push58=, $pop27, $pop117
	br_if   	0, $pop58       # 0: down to label0
# BB#29:                                # %entry
	i32.const	$push120=, 0
	f64.load	$push28=, tmp+232($pop120)
	f64.const	$push119=, -0x1p0
	f64.eq  	$push59=, $pop28, $pop119
	br_if   	0, $pop59       # 0: down to label0
# BB#30:                                # %for.cond1.5.4
	i32.const	$push60=, 0
	return  	$pop60
.LBB1_31:                               # %if.then
	end_block                       # label0:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
