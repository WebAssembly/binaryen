	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-17.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push52=, 0
	i32.const	$push49=, 0
	i32.load	$push50=, __stack_pointer($pop49)
	i32.const	$push51=, 16
	i32.sub 	$push56=, $pop50, $pop51
	i32.store	$push60=, __stack_pointer($pop52), $pop56
	tee_local	$push59=, $4=, $pop60
	i32.store	$push0=, 12($4), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push58=, $pop2, $pop3
	tee_local	$push57=, $1=, $pop58
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop57, $pop4
	i32.store	$2=, 12($pop59), $pop5
	block
	f64.load	$push6=, 0($1)
	f64.const	$push7=, 0x1p0
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	$3=, 12($4), $pop10
	f64.load	$push11=, 0($2)
	f64.const	$push12=, 0x1p1
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push14=, 24
	i32.add 	$push15=, $1, $pop14
	i32.store	$2=, 12($4), $pop15
	f64.load	$push16=, 0($3)
	f64.const	$push17=, 0x1.8p1
	f64.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push19=, 32
	i32.add 	$push20=, $1, $pop19
	i32.store	$3=, 12($4), $pop20
	f64.load	$push21=, 0($2)
	f64.const	$push22=, 0x1p2
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push24=, 40
	i32.add 	$push25=, $1, $pop24
	i32.store	$2=, 12($4), $pop25
	f64.load	$push26=, 0($3)
	f64.const	$push27=, 0x1.4p2
	f64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push29=, 48
	i32.add 	$push30=, $1, $pop29
	i32.store	$3=, 12($4), $pop30
	f64.load	$push31=, 0($2)
	f64.const	$push32=, 0x1.8p2
	f64.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push34=, 56
	i32.add 	$push35=, $1, $pop34
	i32.store	$2=, 12($4), $pop35
	f64.load	$push36=, 0($3)
	f64.const	$push37=, 0x1.cp2
	f64.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push39=, 64
	i32.add 	$push40=, $1, $pop39
	i32.store	$3=, 12($4), $pop40
	f64.load	$push41=, 0($2)
	f64.const	$push42=, 0x1p3
	f64.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push44=, 72
	i32.add 	$push45=, $1, $pop44
	i32.store	$drop=, 12($4), $pop45
	f64.load	$push46=, 0($3)
	f64.const	$push47=, 0x1.2p3
	f64.ne  	$push48=, $pop46, $pop47
	br_if   	0, $pop48       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push55=, 0
	i32.const	$push53=, 16
	i32.add 	$push54=, $4, $pop53
	i32.store	$drop=, __stack_pointer($pop55), $pop54
	return
.LBB0_10:                               # %if.then40
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
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 80
	i32.sub 	$push28=, $pop25, $pop26
	i32.store	$push30=, __stack_pointer($pop27), $pop28
	tee_local	$push29=, $0=, $pop30
	i32.const	$push0=, 64
	i32.add 	$push1=, $pop29, $pop0
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
	call    	vafunction@FUNCTION, $0, $0
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
