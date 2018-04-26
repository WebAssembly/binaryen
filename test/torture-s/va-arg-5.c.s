	.text
	.file	"va-arg-5.c"
	.section	.text.va_double,"ax",@progbits
	.hidden	va_double               # -- Begin function va_double
	.globl	va_double
	.type	va_double,@function
va_double:                              # @va_double
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push21=, 0
	i32.load	$push20=, __stack_pointer($pop21)
	i32.const	$push22=, 16
	i32.sub 	$4=, $pop20, $pop22
	i32.const	$push23=, 0
	i32.store	__stack_pointer($pop23), $4
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$1=, $pop1, $pop2
	i32.const	$push3=, 8
	i32.add 	$2=, $1, $pop3
	i32.store	12($4), $2
	block   	
	f64.load	$push4=, 0($1)
	f64.const	$push5=, 0x1.921fafc8b007ap1
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push7=, 16
	i32.add 	$3=, $1, $pop7
	i32.store	12($4), $3
	f64.load	$push8=, 0($2)
	f64.const	$push9=, 0x1.5bf04577d9557p1
	f64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push11=, 24
	i32.add 	$2=, $1, $pop11
	i32.store	12($4), $2
	f64.load	$push12=, 0($3)
	f64.const	$push13=, 0x1.1e3779131154cp1
	f64.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push15=, 32
	i32.add 	$push16=, $1, $pop15
	i32.store	12($4), $pop16
	f64.load	$push17=, 0($2)
	f64.const	$push18=, 0x1.12e0be1b5921ep1
	f64.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.4:                                # %if.end16
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $4, $pop24
	i32.store	__stack_pointer($pop26), $pop25
	return  	$4
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	va_double, .Lfunc_end0-va_double
                                        # -- End function
	.section	.text.va_long_double,"ax",@progbits
	.hidden	va_long_double          # -- Begin function va_long_double
	.globl	va_long_double
	.type	va_long_double,@function
va_long_double:                         # @va_long_double
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push35=, 0
	i32.load	$push34=, __stack_pointer($pop35)
	i32.const	$push36=, 16
	i32.sub 	$4=, $pop34, $pop36
	i32.const	$push37=, 0
	i32.store	__stack_pointer($pop37), $4
	i32.const	$push0=, 15
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -16
	i32.and 	$1=, $pop1, $pop2
	i32.const	$push3=, 16
	i32.add 	$2=, $1, $pop3
	i32.store	12($4), $2
	block   	
	i64.load	$push5=, 0($1)
	i64.load	$push4=, 8($1)
	i64.const	$push7=, -7338557514379428662
	i64.const	$push6=, 4611846683218194439
	i32.call	$push8=, __eqtf2@FUNCTION, $pop5, $pop4, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push9=, 32
	i32.add 	$3=, $1, $pop9
	i32.store	12($4), $3
	i64.load	$push13=, 0($2)
	i32.const	$push10=, 24
	i32.add 	$push11=, $1, $pop10
	i64.load	$push12=, 0($pop11)
	i64.const	$push15=, 8163791057260899163
	i64.const	$push14=, 4611787105943148885
	i32.call	$push16=, __eqtf2@FUNCTION, $pop13, $pop12, $pop15, $pop14
	br_if   	0, $pop16       # 0: down to label1
# %bb.2:                                # %if.end6
	i32.const	$push17=, 48
	i32.add 	$2=, $1, $pop17
	i32.store	12($4), $2
	i64.load	$push21=, 0($3)
	i32.const	$push18=, 40
	i32.add 	$push19=, $1, $pop18
	i64.load	$push20=, 0($pop19)
	i64.const	$push23=, -4892607794577095924
	i64.const	$push22=, 4611719242030715220
	i32.call	$push24=, __eqtf2@FUNCTION, $pop21, $pop20, $pop23, $pop22
	br_if   	0, $pop24       # 0: down to label1
# %bb.3:                                # %if.end11
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
# %bb.4:                                # %if.end16
	i32.const	$push40=, 0
	i32.const	$push38=, 16
	i32.add 	$push39=, $4, $pop38
	i32.store	__stack_pointer($pop40), $pop39
	return  	$1
.LBB1_5:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	va_long_double, .Lfunc_end1-va_long_double
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 96
	i32.sub 	$0=, $pop27, $pop29
	i32.const	$push30=, 0
	i32.store	__stack_pointer($pop30), $0
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
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
