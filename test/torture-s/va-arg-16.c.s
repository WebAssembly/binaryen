	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-16.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	f64, f64, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push48=, 0
	i32.const	$push45=, 0
	i32.load	$push46=, __stack_pointer($pop45)
	i32.const	$push47=, 16
	i32.sub 	$push53=, $pop46, $pop47
	tee_local	$push52=, $5=, $pop53
	i32.store	__stack_pointer($pop48), $pop52
	i32.store	12($5), $2
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
	i32.and 	$push57=, $pop6, $pop7
	tee_local	$push56=, $2=, $pop57
	i32.const	$push8=, 8
	i32.add 	$push55=, $pop56, $pop8
	tee_local	$push54=, $3=, $pop55
	i32.store	12($5), $pop54
	f64.load	$push9=, 0($2)
	f64.const	$push10=, 0x1p0
	f64.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end7
	i32.const	$push12=, 16
	i32.add 	$push59=, $2, $pop12
	tee_local	$push58=, $4=, $pop59
	i32.store	12($5), $pop58
	f64.load	$push13=, 0($3)
	f64.const	$push14=, 0x1p1
	f64.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end12
	i32.const	$push16=, 24
	i32.add 	$push61=, $2, $pop16
	tee_local	$push60=, $3=, $pop61
	i32.store	12($5), $pop60
	f64.load	$push17=, 0($4)
	f64.const	$push18=, 0x1.8p1
	f64.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#5:                                 # %if.end17
	i32.const	$push20=, 32
	i32.add 	$push63=, $2, $pop20
	tee_local	$push62=, $4=, $pop63
	i32.store	12($5), $pop62
	f64.load	$push21=, 0($3)
	f64.const	$push22=, 0x1p2
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#6:                                 # %if.end22
	i32.const	$push24=, 40
	i32.add 	$push65=, $2, $pop24
	tee_local	$push64=, $3=, $pop65
	i32.store	12($5), $pop64
	f64.load	$push25=, 0($4)
	f64.const	$push26=, 0x1.4p2
	f64.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end27
	i32.const	$push28=, 48
	i32.add 	$push67=, $2, $pop28
	tee_local	$push66=, $4=, $pop67
	i32.store	12($5), $pop66
	f64.load	$push29=, 0($3)
	f64.const	$push30=, 0x1.8p2
	f64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#8:                                 # %if.end32
	i32.const	$push32=, 56
	i32.add 	$push69=, $2, $pop32
	tee_local	$push68=, $3=, $pop69
	i32.store	12($5), $pop68
	f64.load	$push33=, 0($4)
	f64.const	$push34=, 0x1.cp2
	f64.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#9:                                 # %if.end37
	i32.const	$push36=, 64
	i32.add 	$push71=, $2, $pop36
	tee_local	$push70=, $4=, $pop71
	i32.store	12($5), $pop70
	f64.load	$push37=, 0($3)
	f64.const	$push38=, 0x1p3
	f64.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#10:                                # %if.end42
	i32.const	$push40=, 72
	i32.add 	$push41=, $2, $pop40
	i32.store	12($5), $pop41
	f64.load	$push42=, 0($4)
	f64.const	$push43=, 0x1.2p3
	f64.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label0
# BB#11:                                # %if.end47
	i32.const	$push51=, 0
	i32.const	$push49=, 16
	i32.add 	$push50=, $5, $pop49
	i32.store	__stack_pointer($pop51), $pop50
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
	i32.sub 	$push31=, $pop27, $pop28
	tee_local	$push30=, $0=, $pop31
	i32.store	__stack_pointer($pop29), $pop30
	i32.const	$push0=, 64
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 4621256167635550208
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 4620693217682128896
	i64.store	0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 4619567317775286272
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 4618441417868443648
	i64.store	0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4617315517961601024
	i64.store	0($pop13), $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, 4616189618054758400
	i64.store	0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, 4613937818241073152
	i64.store	0($pop19), $pop20
	i64.const	$push21=, 4611686018427387904
	i64.store	8($0), $pop21
	i64.const	$push22=, 4607182418800017408
	i64.store	0($0), $pop22
	f64.const	$push24=, 0x1.bcp9
	f64.const	$push23=, 0x1.f38p9
	call    	vafunction@FUNCTION, $pop24, $pop23, $0
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
