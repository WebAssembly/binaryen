	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-5.c"
	.section	.text.va_double,"ax",@progbits
	.hidden	va_double
	.globl	va_double
	.type	va_double,@function
va_double:                              # @va_double
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push20=, 0
	i32.load	$push21=, __stack_pointer($pop20)
	i32.const	$push22=, 16
	i32.sub 	$push32=, $pop21, $pop22
	tee_local	$push31=, $4=, $pop32
	i32.store	__stack_pointer($pop23), $pop31
	i32.store	12($4), $1
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push30=, $pop1, $pop2
	tee_local	$push29=, $1=, $pop30
	i32.const	$push3=, 8
	i32.add 	$push28=, $pop29, $pop3
	tee_local	$push27=, $2=, $pop28
	i32.store	12($4), $pop27
	block   	
	f64.load	$push4=, 0($1)
	f64.const	$push5=, 0x1.921fafc8b007ap1
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 16
	i32.add 	$push34=, $1, $pop7
	tee_local	$push33=, $3=, $pop34
	i32.store	12($4), $pop33
	f64.load	$push8=, 0($2)
	f64.const	$push9=, 0x1.5bf04577d9557p1
	f64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push11=, 24
	i32.add 	$push36=, $1, $pop11
	tee_local	$push35=, $2=, $pop36
	i32.store	12($4), $pop35
	f64.load	$push12=, 0($3)
	f64.const	$push13=, 0x1.1e3779131154cp1
	f64.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push15=, 32
	i32.add 	$push16=, $1, $pop15
	i32.store	12($4), $pop16
	f64.load	$push17=, 0($2)
	f64.const	$push18=, 0x1.12e0be1b5921ep1
	f64.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $4, $pop24
	i32.store	__stack_pointer($pop26), $pop25
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
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 16
	i32.sub 	$push46=, $pop35, $pop36
	tee_local	$push45=, $4=, $pop46
	i32.store	__stack_pointer($pop37), $pop45
	i32.store	12($4), $1
	i32.const	$push0=, 15
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -16
	i32.and 	$push44=, $pop1, $pop2
	tee_local	$push43=, $1=, $pop44
	i32.const	$push3=, 16
	i32.add 	$push42=, $pop43, $pop3
	tee_local	$push41=, $2=, $pop42
	i32.store	12($4), $pop41
	block   	
	i64.load	$push5=, 0($1)
	i64.load	$push4=, 8($1)
	i64.const	$push7=, -7338557514379428662
	i64.const	$push6=, 4611846683218194439
	i32.call	$push8=, __eqtf2@FUNCTION, $pop5, $pop4, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push9=, 32
	i32.add 	$push48=, $1, $pop9
	tee_local	$push47=, $3=, $pop48
	i32.store	12($4), $pop47
	i64.load	$push13=, 0($2)
	i32.const	$push10=, 24
	i32.add 	$push11=, $1, $pop10
	i64.load	$push12=, 0($pop11)
	i64.const	$push15=, 8163791057260899163
	i64.const	$push14=, 4611787105943148885
	i32.call	$push16=, __eqtf2@FUNCTION, $pop13, $pop12, $pop15, $pop14
	br_if   	0, $pop16       # 0: down to label1
# BB#2:                                 # %if.end6
	i32.const	$push17=, 48
	i32.add 	$push50=, $1, $pop17
	tee_local	$push49=, $2=, $pop50
	i32.store	12($4), $pop49
	i64.load	$push21=, 0($3)
	i32.const	$push18=, 40
	i32.add 	$push19=, $1, $pop18
	i64.load	$push20=, 0($pop19)
	i64.const	$push23=, -4892607794577095924
	i64.const	$push22=, 4611719242030715220
	i32.call	$push24=, __eqtf2@FUNCTION, $pop21, $pop20, $pop23, $pop22
	br_if   	0, $pop24       # 0: down to label1
# BB#3:                                 # %if.end11
	i32.const	$push25=, 64
	i32.add 	$push26=, $1, $pop25
	i32.store	12($4), $pop26
	i64.load	$push30=, 0($2)
	i32.const	$push27=, 56
	i32.add 	$push28=, $1, $pop27
	i64.load	$push29=, 0($pop28)
	i64.const	$push32=, -2718666384188054750
	i64.const	$push31=, 4611706774898825505
	i32.call	$push33=, __eqtf2@FUNCTION, $pop30, $pop29, $pop32, $pop31
	br_if   	0, $pop33       # 0: down to label1
# BB#4:                                 # %if.end16
	i32.const	$push40=, 0
	i32.const	$push38=, 16
	i32.add 	$push39=, $4, $pop38
	i32.store	__stack_pointer($pop40), $pop39
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
	i32.sub 	$push40=, $pop28, $pop29
	tee_local	$push39=, $0=, $pop40
	i32.store	__stack_pointer($pop30), $pop39
	i32.const	$push31=, 64
	i32.add 	$push32=, $0, $pop31
	i32.const	$push0=, 24
	i32.add 	$push1=, $pop32, $pop0
	i64.const	$push2=, 4612018121970389534
	i64.store	0($pop1), $pop2
	i32.const	$push33=, 64
	i32.add 	$push34=, $0, $pop33
	i32.const	$push3=, 16
	i32.add 	$push4=, $pop34, $pop3
	i64.const	$push5=, 4612217596080624972
	i64.store	0($pop4), $pop5
	i64.const	$push6=, 4613303418679563607
	i64.store	72($0), $pop6
	i64.const	$push7=, 4614256655080292474
	i64.store	64($0), $pop7
	i32.const	$push35=, 64
	i32.add 	$push36=, $0, $pop35
	i32.call	$drop=, va_double@FUNCTION, $0, $pop36
	i32.const	$push8=, 56
	i32.add 	$push9=, $0, $pop8
	i64.const	$push10=, 4611706774898825505
	i64.store	0($pop9), $pop10
	i32.const	$push11=, 48
	i32.add 	$push12=, $0, $pop11
	i64.const	$push13=, -2718666384188054750
	i64.store	0($pop12), $pop13
	i32.const	$push14=, 40
	i32.add 	$push15=, $0, $pop14
	i64.const	$push16=, 4611719242030715220
	i64.store	0($pop15), $pop16
	i32.const	$push17=, 32
	i32.add 	$push18=, $0, $pop17
	i64.const	$push19=, -4892607794577095924
	i64.store	0($pop18), $pop19
	i32.const	$push38=, 24
	i32.add 	$push20=, $0, $pop38
	i64.const	$push21=, 4611787105943148885
	i64.store	0($pop20), $pop21
	i32.const	$push37=, 16
	i32.add 	$push22=, $0, $pop37
	i64.const	$push23=, 8163791057260899163
	i64.store	0($pop22), $pop23
	i64.const	$push24=, 4611846683218194439
	i64.store	8($0), $pop24
	i64.const	$push25=, -7338557514379428662
	i64.store	0($0), $pop25
	i32.call	$drop=, va_long_double@FUNCTION, $0, $0
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
