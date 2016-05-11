	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-5.c"
	.section	.text.va_double,"ax",@progbits
	.hidden	va_double
	.globl	va_double
	.type	va_double,@function
va_double:                              # @va_double
	.param  	i32, i32
	.result 	i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push22=, __stack_pointer
	i32.const	$push19=, __stack_pointer
	i32.load	$push20=, 0($pop19)
	i32.const	$push21=, 16
	i32.sub 	$push26=, $pop20, $pop21
	i32.store	$2=, 0($pop22), $pop26
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push28=, $pop1, $pop2
	tee_local	$push27=, $4=, $pop28
	f64.load	$3=, 0($pop27)
	i32.store	$discard=, 12($2), $1
	i32.const	$push3=, 8
	i32.add 	$push4=, $4, $pop3
	i32.store	$1=, 12($2), $pop4
	block
	f64.const	$push5=, 0x1.921fafc8b007ap1
	f64.ne  	$push6=, $3, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	f64.load	$3=, 0($1)
	i32.const	$push7=, 16
	i32.add 	$push8=, $4, $pop7
	i32.store	$1=, 12($2), $pop8
	f64.const	$push9=, 0x1.5bf04577d9557p1
	f64.ne  	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end6
	f64.load	$3=, 0($1)
	i32.const	$push11=, 24
	i32.add 	$push12=, $4, $pop11
	i32.store	$1=, 12($2), $pop12
	f64.const	$push13=, 0x1.1e3779131154cp1
	f64.ne  	$push14=, $3, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	f64.load	$3=, 0($1)
	i32.const	$push15=, 32
	i32.add 	$push16=, $4, $pop15
	i32.store	$discard=, 12($2), $pop16
	f64.const	$push17=, 0x1.12e0be1b5921ep1
	f64.ne  	$push18=, $3, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push25=, __stack_pointer
	i32.const	$push23=, 16
	i32.add 	$push24=, $2, $pop23
	i32.store	$discard=, 0($pop25), $pop24
	return  	$2
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
	.local  	i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push33=, __stack_pointer
	i32.const	$push30=, __stack_pointer
	i32.load	$push31=, 0($pop30)
	i32.const	$push32=, 16
	i32.sub 	$push37=, $pop31, $pop32
	i32.store	$push41=, 0($pop33), $pop37
	tee_local	$push40=, $5=, $pop41
	i32.store	$push0=, 12($pop40), $1
	i32.const	$push1=, 15
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -16
	i32.and 	$push39=, $pop2, $pop3
	tee_local	$push38=, $1=, $pop39
	i64.load	$3=, 8($pop38)
	i64.load	$4=, 0($1)
	i32.const	$push4=, 16
	i32.add 	$push5=, $1, $pop4
	i32.store	$2=, 12($5), $pop5
	block
	i64.const	$push7=, -7338557514379428662
	i64.const	$push6=, 4611846683218194439
	i32.call	$push8=, __eqtf2@FUNCTION, $4, $3, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push11=, 24
	i32.add 	$push12=, $1, $pop11
	i64.load	$3=, 0($pop12)
	i64.load	$4=, 0($2)
	i32.const	$push9=, 32
	i32.add 	$push10=, $1, $pop9
	i32.store	$2=, 12($5), $pop10
	i64.const	$push14=, 8163791057260899163
	i64.const	$push13=, 4611787105943148885
	i32.call	$push15=, __eqtf2@FUNCTION, $4, $3, $pop14, $pop13
	br_if   	0, $pop15       # 0: down to label1
# BB#2:                                 # %if.end6
	i32.const	$push18=, 40
	i32.add 	$push19=, $1, $pop18
	i64.load	$3=, 0($pop19)
	i64.load	$4=, 0($2)
	i32.const	$push16=, 48
	i32.add 	$push17=, $1, $pop16
	i32.store	$2=, 12($5), $pop17
	i64.const	$push21=, -4892607794577095924
	i64.const	$push20=, 4611719242030715220
	i32.call	$push22=, __eqtf2@FUNCTION, $4, $3, $pop21, $pop20
	br_if   	0, $pop22       # 0: down to label1
# BB#3:                                 # %if.end11
	i32.const	$push25=, 56
	i32.add 	$push26=, $1, $pop25
	i64.load	$3=, 0($pop26)
	i64.load	$4=, 0($2)
	i32.const	$push23=, 64
	i32.add 	$push24=, $1, $pop23
	i32.store	$discard=, 12($5), $pop24
	i64.const	$push28=, -2718666384188054750
	i64.const	$push27=, 4611706774898825505
	i32.call	$push29=, __eqtf2@FUNCTION, $4, $3, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label1
# BB#4:                                 # %if.end16
	i32.const	$push36=, __stack_pointer
	i32.const	$push34=, 16
	i32.add 	$push35=, $5, $pop34
	i32.store	$discard=, 0($pop36), $pop35
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
	i32.const	$push30=, __stack_pointer
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 96
	i32.sub 	$push37=, $pop28, $pop29
	i32.store	$push41=, 0($pop30), $pop37
	tee_local	$push40=, $0=, $pop41
	i32.const	$push31=, 64
	i32.add 	$push32=, $pop40, $pop31
	i32.const	$push0=, 24
	i32.add 	$push1=, $pop32, $pop0
	i64.const	$push2=, 4612018121970389534
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push33=, 64
	i32.add 	$push34=, $0, $pop33
	i32.const	$push3=, 16
	i32.add 	$push4=, $pop34, $pop3
	i64.const	$push5=, 4612217596080624972
	i64.store	$discard=, 0($pop4), $pop5
	i64.const	$push6=, 4613303418679563607
	i64.store	$discard=, 72($0), $pop6
	i64.const	$push7=, 4614256655080292474
	i64.store	$discard=, 64($0), $pop7
	i32.const	$push35=, 64
	i32.add 	$push36=, $0, $pop35
	i32.call	$discard=, va_double@FUNCTION, $0, $pop36
	i32.const	$push8=, 56
	i32.add 	$push9=, $0, $pop8
	i64.const	$push10=, 4611706774898825505
	i64.store	$discard=, 0($pop9), $pop10
	i32.const	$push11=, 48
	i32.add 	$push12=, $0, $pop11
	i64.const	$push13=, -2718666384188054750
	i64.store	$discard=, 0($pop12), $pop13
	i32.const	$push14=, 40
	i32.add 	$push15=, $0, $pop14
	i64.const	$push16=, 4611719242030715220
	i64.store	$discard=, 0($pop15), $pop16
	i32.const	$push17=, 32
	i32.add 	$push18=, $0, $pop17
	i64.const	$push19=, -4892607794577095924
	i64.store	$discard=, 0($pop18), $pop19
	i32.const	$push39=, 24
	i32.add 	$push20=, $0, $pop39
	i64.const	$push21=, 4611787105943148885
	i64.store	$discard=, 0($pop20), $pop21
	i32.const	$push38=, 16
	i32.add 	$push22=, $0, $pop38
	i64.const	$push23=, 8163791057260899163
	i64.store	$discard=, 0($pop22), $pop23
	i64.const	$push24=, 4611846683218194439
	i64.store	$discard=, 8($0), $pop24
	i64.const	$push25=, -7338557514379428662
	i64.store	$discard=, 0($0), $pop25
	i32.call	$discard=, va_long_double@FUNCTION, $0, $0
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
