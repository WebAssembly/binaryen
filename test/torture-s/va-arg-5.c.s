	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-5.c"
	.section	.text.va_double,"ax",@progbits
	.hidden	va_double
	.globl	va_double
	.type	va_double,@function
va_double:                              # @va_double
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 16
	i32.sub 	$push31=, $pop25, $pop26
	i32.store	$push35=, __stack_pointer($pop27), $pop31
	tee_local	$push34=, $4=, $pop35
	i32.store	$push0=, 12($4), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push33=, $pop2, $pop3
	tee_local	$push32=, $1=, $pop33
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop32, $pop4
	i32.store	$2=, 12($pop34), $pop5
	block
	f64.load	$push6=, 0($1)
	f64.const	$push7=, 0x1.921fafc8b007ap1
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	$3=, 12($4), $pop10
	f64.load	$push11=, 0($2)
	f64.const	$push12=, 0x1.5bf04577d9557p1
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push14=, 24
	i32.add 	$push15=, $1, $pop14
	i32.store	$2=, 12($4), $pop15
	f64.load	$push16=, 0($3)
	f64.const	$push17=, 0x1.1e3779131154cp1
	f64.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push19=, 32
	i32.add 	$push20=, $1, $pop19
	i32.store	$drop=, 12($4), $pop20
	f64.load	$push21=, 0($2)
	f64.const	$push22=, 0x1.12e0be1b5921ep1
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $4, $pop28
	i32.store	$drop=, __stack_pointer($pop30), $pop29
	return  	$4
.LBB0_5:                                # %if.then15
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	va_double, .Lfunc_end0-va_double

	.section	.text.va_long_double,"ax",@progbits
	.hidden	va_long_double
	.globl	va_long_double
	.type	va_long_double,@function
va_long_double:                         # @va_long_double
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push41=, 0
	i32.const	$push38=, 0
	i32.load	$push39=, __stack_pointer($pop38)
	i32.const	$push40=, 16
	i32.sub 	$push45=, $pop39, $pop40
	i32.store	$push49=, __stack_pointer($pop41), $pop45
	tee_local	$push48=, $4=, $pop49
	i32.store	$push0=, 12($4), $1
	i32.const	$push1=, 15
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -16
	i32.and 	$push47=, $pop2, $pop3
	tee_local	$push46=, $1=, $pop47
	i32.const	$push4=, 16
	i32.add 	$push5=, $pop46, $pop4
	i32.store	$2=, 12($pop48), $pop5
	block
	i64.load	$push7=, 0($1)
	i64.load	$push6=, 8($1)
	i64.const	$push9=, -7338557514379428662
	i64.const	$push8=, 4611846683218194439
	i32.call	$push10=, __eqtf2@FUNCTION, $pop7, $pop6, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push11=, 32
	i32.add 	$push12=, $1, $pop11
	i32.store	$3=, 12($4), $pop12
	i64.load	$push16=, 0($2)
	i32.const	$push13=, 24
	i32.add 	$push14=, $1, $pop13
	i64.load	$push15=, 0($pop14)
	i64.const	$push18=, 8163791057260899163
	i64.const	$push17=, 4611787105943148885
	i32.call	$push19=, __eqtf2@FUNCTION, $pop16, $pop15, $pop18, $pop17
	br_if   	0, $pop19       # 0: down to label1
# BB#2:                                 # %if.end6
	i32.const	$push20=, 48
	i32.add 	$push21=, $1, $pop20
	i32.store	$2=, 12($4), $pop21
	i64.load	$push25=, 0($3)
	i32.const	$push22=, 40
	i32.add 	$push23=, $1, $pop22
	i64.load	$push24=, 0($pop23)
	i64.const	$push27=, -4892607794577095924
	i64.const	$push26=, 4611719242030715220
	i32.call	$push28=, __eqtf2@FUNCTION, $pop25, $pop24, $pop27, $pop26
	br_if   	0, $pop28       # 0: down to label1
# BB#3:                                 # %if.end11
	i32.const	$push29=, 64
	i32.add 	$push30=, $1, $pop29
	i32.store	$drop=, 12($4), $pop30
	i64.load	$push34=, 0($2)
	i32.const	$push31=, 56
	i32.add 	$push32=, $1, $pop31
	i64.load	$push33=, 0($pop32)
	i64.const	$push36=, -2718666384188054750
	i64.const	$push35=, 4611706774898825505
	i32.call	$push37=, __eqtf2@FUNCTION, $pop34, $pop33, $pop36, $pop35
	br_if   	0, $pop37       # 0: down to label1
# BB#4:                                 # %if.end16
	i32.const	$push44=, 0
	i32.const	$push42=, 16
	i32.add 	$push43=, $4, $pop42
	i32.store	$drop=, __stack_pointer($pop44), $pop43
	return  	$1
.LBB1_5:                                # %if.then15
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	va_long_double, .Lfunc_end1-va_long_double

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 96
	i32.sub 	$push37=, $pop28, $pop29
	i32.store	$push41=, __stack_pointer($pop30), $pop37
	tee_local	$push40=, $0=, $pop41
	i32.const	$push31=, 64
	i32.add 	$push32=, $pop40, $pop31
	i32.const	$push0=, 24
	i32.add 	$push1=, $pop32, $pop0
	i64.const	$push2=, 4612018121970389534
	i64.store	$drop=, 0($pop1), $pop2
	i32.const	$push33=, 64
	i32.add 	$push34=, $0, $pop33
	i32.const	$push3=, 16
	i32.add 	$push4=, $pop34, $pop3
	i64.const	$push5=, 4612217596080624972
	i64.store	$drop=, 0($pop4), $pop5
	i64.const	$push6=, 4613303418679563607
	i64.store	$drop=, 72($0), $pop6
	i64.const	$push7=, 4614256655080292474
	i64.store	$drop=, 64($0), $pop7
	i32.const	$push35=, 64
	i32.add 	$push36=, $0, $pop35
	i32.call	$drop=, va_double@FUNCTION, $0, $pop36
	i32.const	$push8=, 56
	i32.add 	$push9=, $0, $pop8
	i64.const	$push10=, 4611706774898825505
	i64.store	$drop=, 0($pop9), $pop10
	i32.const	$push11=, 48
	i32.add 	$push12=, $0, $pop11
	i64.const	$push13=, -2718666384188054750
	i64.store	$drop=, 0($pop12), $pop13
	i32.const	$push14=, 40
	i32.add 	$push15=, $0, $pop14
	i64.const	$push16=, 4611719242030715220
	i64.store	$drop=, 0($pop15), $pop16
	i32.const	$push17=, 32
	i32.add 	$push18=, $0, $pop17
	i64.const	$push19=, -4892607794577095924
	i64.store	$drop=, 0($pop18), $pop19
	i32.const	$push39=, 24
	i32.add 	$push20=, $0, $pop39
	i64.const	$push21=, 4611787105943148885
	i64.store	$drop=, 0($pop20), $pop21
	i32.const	$push38=, 16
	i32.add 	$push22=, $0, $pop38
	i64.const	$push23=, 8163791057260899163
	i64.store	$drop=, 0($pop22), $pop23
	i64.const	$push24=, 4611846683218194439
	i64.store	$drop=, 8($0), $pop24
	i64.const	$push25=, -7338557514379428662
	i64.store	$drop=, 0($0), $pop25
	i32.call	$drop=, va_long_double@FUNCTION, $0, $0
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
