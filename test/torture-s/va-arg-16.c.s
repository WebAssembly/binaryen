	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-16.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	f64, f64, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $2
	block
	f64.const	$push0=, 0x1.bcp9
	f64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	f64.const	$push2=, 0x1.f38p9
	f64.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.load	$push4=, 12($6)
	i32.const	$push65=, 7
	i32.add 	$push5=, $pop4, $pop65
	i32.const	$push64=, -8
	i32.and 	$push63=, $pop5, $pop64
	tee_local	$push62=, $2=, $pop63
	i32.const	$push61=, 8
	i32.add 	$push6=, $pop62, $pop61
	i32.store	$discard=, 12($6), $pop6
	f64.load	$push7=, 0($2)
	f64.const	$push8=, 0x1p0
	f64.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %if.end7
	i32.load	$push10=, 12($6)
	i32.const	$push70=, 7
	i32.add 	$push11=, $pop10, $pop70
	i32.const	$push69=, -8
	i32.and 	$push68=, $pop11, $pop69
	tee_local	$push67=, $2=, $pop68
	i32.const	$push66=, 8
	i32.add 	$push12=, $pop67, $pop66
	i32.store	$discard=, 12($6), $pop12
	f64.load	$push13=, 0($2)
	f64.const	$push14=, 0x1p1
	f64.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end10
	i32.load	$push16=, 12($6)
	i32.const	$push75=, 7
	i32.add 	$push17=, $pop16, $pop75
	i32.const	$push74=, -8
	i32.and 	$push73=, $pop17, $pop74
	tee_local	$push72=, $2=, $pop73
	i32.const	$push71=, 8
	i32.add 	$push18=, $pop72, $pop71
	i32.store	$discard=, 12($6), $pop18
	f64.load	$push19=, 0($2)
	f64.const	$push20=, 0x1.8p1
	f64.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#5:                                 # %if.end13
	i32.load	$push22=, 12($6)
	i32.const	$push80=, 7
	i32.add 	$push23=, $pop22, $pop80
	i32.const	$push79=, -8
	i32.and 	$push78=, $pop23, $pop79
	tee_local	$push77=, $2=, $pop78
	i32.const	$push76=, 8
	i32.add 	$push24=, $pop77, $pop76
	i32.store	$discard=, 12($6), $pop24
	f64.load	$push25=, 0($2)
	f64.const	$push26=, 0x1p2
	f64.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#6:                                 # %if.end16
	i32.load	$push28=, 12($6)
	i32.const	$push85=, 7
	i32.add 	$push29=, $pop28, $pop85
	i32.const	$push84=, -8
	i32.and 	$push83=, $pop29, $pop84
	tee_local	$push82=, $2=, $pop83
	i32.const	$push81=, 8
	i32.add 	$push30=, $pop82, $pop81
	i32.store	$discard=, 12($6), $pop30
	f64.load	$push31=, 0($2)
	f64.const	$push32=, 0x1.4p2
	f64.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#7:                                 # %if.end19
	i32.load	$push34=, 12($6)
	i32.const	$push90=, 7
	i32.add 	$push35=, $pop34, $pop90
	i32.const	$push89=, -8
	i32.and 	$push88=, $pop35, $pop89
	tee_local	$push87=, $2=, $pop88
	i32.const	$push86=, 8
	i32.add 	$push36=, $pop87, $pop86
	i32.store	$discard=, 12($6), $pop36
	f64.load	$push37=, 0($2)
	f64.const	$push38=, 0x1.8p2
	f64.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#8:                                 # %if.end22
	i32.load	$push40=, 12($6)
	i32.const	$push95=, 7
	i32.add 	$push41=, $pop40, $pop95
	i32.const	$push94=, -8
	i32.and 	$push93=, $pop41, $pop94
	tee_local	$push92=, $2=, $pop93
	i32.const	$push91=, 8
	i32.add 	$push42=, $pop92, $pop91
	i32.store	$discard=, 12($6), $pop42
	f64.load	$push43=, 0($2)
	f64.const	$push44=, 0x1.cp2
	f64.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label0
# BB#9:                                 # %if.end25
	i32.load	$push46=, 12($6)
	i32.const	$push100=, 7
	i32.add 	$push47=, $pop46, $pop100
	i32.const	$push99=, -8
	i32.and 	$push98=, $pop47, $pop99
	tee_local	$push97=, $2=, $pop98
	i32.const	$push96=, 8
	i32.add 	$push48=, $pop97, $pop96
	i32.store	$discard=, 12($6), $pop48
	f64.load	$push49=, 0($2)
	f64.const	$push50=, 0x1p3
	f64.ne  	$push51=, $pop49, $pop50
	br_if   	0, $pop51       # 0: down to label0
# BB#10:                                # %if.end28
	i32.load	$push52=, 12($6)
	i32.const	$push53=, 7
	i32.add 	$push54=, $pop52, $pop53
	i32.const	$push55=, -8
	i32.and 	$push102=, $pop54, $pop55
	tee_local	$push101=, $2=, $pop102
	i32.const	$push56=, 8
	i32.add 	$push57=, $pop101, $pop56
	i32.store	$discard=, 12($6), $pop57
	f64.load	$push58=, 0($2)
	f64.const	$push59=, 0x1.2p3
	f64.ne  	$push60=, $pop58, $pop59
	br_if   	0, $pop60       # 0: down to label0
# BB#11:                                # %if.end31
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB0_12:                               # %if.then30
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vafunction, .Lfunc_end0-vafunction

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 80
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	i32.const	$push0=, 64
	i32.add 	$push1=, $2, $pop0
	i64.const	$push2=, 4621256167635550208
	i64.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $2, $pop3
	i64.const	$push5=, 4620693217682128896
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $2, $pop6
	i64.const	$push8=, 4619567317775286272
	i64.store	$discard=, 0($pop7):p2align=4, $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $2, $pop9
	i64.const	$push11=, 4618441417868443648
	i64.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $2, $pop12
	i64.const	$push14=, 4617315517961601024
	i64.store	$discard=, 0($pop13):p2align=4, $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $2, $pop15
	i64.const	$push17=, 4616189618054758400
	i64.store	$discard=, 0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $2, $pop18
	i64.const	$push20=, 4613937818241073152
	i64.store	$discard=, 0($pop19):p2align=4, $pop20
	i32.const	$push21=, 8
	i32.or  	$push22=, $2, $pop21
	i64.const	$push23=, 4611686018427387904
	i64.store	$discard=, 0($pop22), $pop23
	i64.const	$push24=, 4607182418800017408
	i64.store	$discard=, 0($2):p2align=4, $pop24
	f64.const	$push26=, 0x1.bcp9
	f64.const	$push25=, 0x1.f38p9
	call    	vafunction@FUNCTION, $pop26, $pop25, $2
	i32.const	$push27=, 0
	call    	exit@FUNCTION, $pop27
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
