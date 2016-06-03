	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-16.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	f64, f64, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push56=, 0
	i32.const	$push53=, 0
	i32.load	$push54=, __stack_pointer($pop53)
	i32.const	$push55=, 16
	i32.sub 	$push60=, $pop54, $pop55
	i32.store	$push62=, __stack_pointer($pop56), $pop60
	tee_local	$push61=, $5=, $pop62
	i32.store	$drop=, 12($pop61), $2
	block
	f64.const	$push0=, 0x1.bcp9
	f64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	f64.const	$push2=, 0x1.f38p9
	f64.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.load	$push5=, 12($5)
	i32.const	$push4=, 7
	i32.add 	$push6=, $pop5, $pop4
	i32.const	$push7=, -8
	i32.and 	$push64=, $pop6, $pop7
	tee_local	$push63=, $2=, $pop64
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop63, $pop8
	i32.store	$3=, 12($5), $pop9
	f64.load	$push10=, 0($2)
	f64.const	$push11=, 0x1p0
	f64.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end7
	i32.const	$push13=, 16
	i32.add 	$push14=, $2, $pop13
	i32.store	$4=, 12($5), $pop14
	f64.load	$push15=, 0($3)
	f64.const	$push16=, 0x1p1
	f64.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#4:                                 # %if.end12
	i32.const	$push18=, 24
	i32.add 	$push19=, $2, $pop18
	i32.store	$3=, 12($5), $pop19
	f64.load	$push20=, 0($4)
	f64.const	$push21=, 0x1.8p1
	f64.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#5:                                 # %if.end17
	i32.const	$push23=, 32
	i32.add 	$push24=, $2, $pop23
	i32.store	$4=, 12($5), $pop24
	f64.load	$push25=, 0($3)
	f64.const	$push26=, 0x1p2
	f64.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#6:                                 # %if.end22
	i32.const	$push28=, 40
	i32.add 	$push29=, $2, $pop28
	i32.store	$3=, 12($5), $pop29
	f64.load	$push30=, 0($4)
	f64.const	$push31=, 0x1.4p2
	f64.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label0
# BB#7:                                 # %if.end27
	i32.const	$push33=, 48
	i32.add 	$push34=, $2, $pop33
	i32.store	$4=, 12($5), $pop34
	f64.load	$push35=, 0($3)
	f64.const	$push36=, 0x1.8p2
	f64.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#8:                                 # %if.end32
	i32.const	$push38=, 56
	i32.add 	$push39=, $2, $pop38
	i32.store	$3=, 12($5), $pop39
	f64.load	$push40=, 0($4)
	f64.const	$push41=, 0x1.cp2
	f64.ne  	$push42=, $pop40, $pop41
	br_if   	0, $pop42       # 0: down to label0
# BB#9:                                 # %if.end37
	i32.const	$push43=, 64
	i32.add 	$push44=, $2, $pop43
	i32.store	$4=, 12($5), $pop44
	f64.load	$push45=, 0($3)
	f64.const	$push46=, 0x1p3
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#10:                                # %if.end42
	i32.const	$push48=, 72
	i32.add 	$push49=, $2, $pop48
	i32.store	$drop=, 12($5), $pop49
	f64.load	$push50=, 0($4)
	f64.const	$push51=, 0x1.2p3
	f64.ne  	$push52=, $pop50, $pop51
	br_if   	0, $pop52       # 0: down to label0
# BB#11:                                # %if.end47
	i32.const	$push59=, 0
	i32.const	$push57=, 16
	i32.add 	$push58=, $5, $pop57
	i32.store	$drop=, __stack_pointer($pop59), $pop58
	return
.LBB0_12:                               # %if.then46
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push29=, 0
	i32.const	$push26=, 0
	i32.load	$push27=, __stack_pointer($pop26)
	i32.const	$push28=, 80
	i32.sub 	$push30=, $pop27, $pop28
	i32.store	$push32=, __stack_pointer($pop29), $pop30
	tee_local	$push31=, $0=, $pop32
	i32.const	$push0=, 64
	i32.add 	$push1=, $pop31, $pop0
	i64.const	$push2=, 4621256167635550208
	i64.store	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 4620693217682128896
	i64.store	$drop=, 0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 4619567317775286272
	i64.store	$drop=, 0($pop7), $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 4618441417868443648
	i64.store	$drop=, 0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4617315517961601024
	i64.store	$drop=, 0($pop13), $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, 4616189618054758400
	i64.store	$drop=, 0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, 4613937818241073152
	i64.store	$drop=, 0($pop19), $pop20
	i64.const	$push21=, 4611686018427387904
	i64.store	$drop=, 8($0), $pop21
	i64.const	$push22=, 4607182418800017408
	i64.store	$drop=, 0($0), $pop22
	f64.const	$push24=, 0x1.bcp9
	f64.const	$push23=, 0x1.f38p9
	call    	vafunction@FUNCTION, $pop24, $pop23, $0
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
