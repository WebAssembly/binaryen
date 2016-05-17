	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-16.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	f64, f64, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push47=, __stack_pointer
	i32.const	$push44=, __stack_pointer
	i32.load	$push45=, 0($pop44)
	i32.const	$push46=, 16
	i32.sub 	$push51=, $pop45, $pop46
	i32.store	$push53=, 0($pop47), $pop51
	tee_local	$push52=, $4=, $pop53
	i32.store	$drop=, 12($pop52), $2
	block
	f64.const	$push0=, 0x1.bcp9
	f64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	f64.const	$push2=, 0x1.f38p9
	f64.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.load	$push4=, 12($4)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push55=, $pop6, $pop7
	tee_local	$push54=, $2=, $pop55
	f64.load	$0=, 0($pop54)
	i32.const	$push8=, 8
	i32.add 	$push9=, $2, $pop8
	i32.store	$3=, 12($4), $pop9
	f64.const	$push10=, 0x1p0
	f64.ne  	$push11=, $0, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end7
	f64.load	$0=, 0($3)
	i32.const	$push12=, 16
	i32.add 	$push13=, $2, $pop12
	i32.store	$3=, 12($4), $pop13
	f64.const	$push14=, 0x1p1
	f64.ne  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end12
	f64.load	$0=, 0($3)
	i32.const	$push16=, 24
	i32.add 	$push17=, $2, $pop16
	i32.store	$3=, 12($4), $pop17
	f64.const	$push18=, 0x1.8p1
	f64.ne  	$push19=, $0, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#5:                                 # %if.end17
	f64.load	$0=, 0($3)
	i32.const	$push20=, 32
	i32.add 	$push21=, $2, $pop20
	i32.store	$3=, 12($4), $pop21
	f64.const	$push22=, 0x1p2
	f64.ne  	$push23=, $0, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#6:                                 # %if.end22
	f64.load	$0=, 0($3)
	i32.const	$push24=, 40
	i32.add 	$push25=, $2, $pop24
	i32.store	$3=, 12($4), $pop25
	f64.const	$push26=, 0x1.4p2
	f64.ne  	$push27=, $0, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end27
	f64.load	$0=, 0($3)
	i32.const	$push28=, 48
	i32.add 	$push29=, $2, $pop28
	i32.store	$3=, 12($4), $pop29
	f64.const	$push30=, 0x1.8p2
	f64.ne  	$push31=, $0, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#8:                                 # %if.end32
	f64.load	$0=, 0($3)
	i32.const	$push32=, 56
	i32.add 	$push33=, $2, $pop32
	i32.store	$3=, 12($4), $pop33
	f64.const	$push34=, 0x1.cp2
	f64.ne  	$push35=, $0, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#9:                                 # %if.end37
	f64.load	$0=, 0($3)
	i32.const	$push36=, 64
	i32.add 	$push37=, $2, $pop36
	i32.store	$3=, 12($4), $pop37
	f64.const	$push38=, 0x1p3
	f64.ne  	$push39=, $0, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#10:                                # %if.end42
	f64.load	$0=, 0($3)
	i32.const	$push40=, 72
	i32.add 	$push41=, $2, $pop40
	i32.store	$drop=, 12($4), $pop41
	f64.const	$push42=, 0x1.2p3
	f64.ne  	$push43=, $0, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#11:                                # %if.end47
	i32.const	$push50=, __stack_pointer
	i32.const	$push48=, 16
	i32.add 	$push49=, $4, $pop48
	i32.store	$drop=, 0($pop50), $pop49
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
	i32.const	$push29=, __stack_pointer
	i32.const	$push26=, __stack_pointer
	i32.load	$push27=, 0($pop26)
	i32.const	$push28=, 80
	i32.sub 	$push30=, $pop27, $pop28
	i32.store	$push32=, 0($pop29), $pop30
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
