	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-17.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push42=, __stack_pointer
	i32.const	$push39=, __stack_pointer
	i32.load	$push40=, 0($pop39)
	i32.const	$push41=, 16
	i32.sub 	$push46=, $pop40, $pop41
	i32.store	$2=, 0($pop42), $pop46
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push48=, $pop1, $pop2
	tee_local	$push47=, $4=, $pop48
	f64.load	$3=, 0($pop47)
	i32.store	$discard=, 12($2), $1
	i32.const	$push3=, 8
	i32.add 	$push4=, $4, $pop3
	i32.store	$1=, 12($2), $pop4
	block
	f64.const	$push5=, 0x1p0
	f64.ne  	$push6=, $3, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	f64.load	$3=, 0($1)
	i32.const	$push7=, 16
	i32.add 	$push8=, $4, $pop7
	i32.store	$1=, 12($2), $pop8
	f64.const	$push9=, 0x1p1
	f64.ne  	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end6
	f64.load	$3=, 0($1)
	i32.const	$push11=, 24
	i32.add 	$push12=, $4, $pop11
	i32.store	$1=, 12($2), $pop12
	f64.const	$push13=, 0x1.8p1
	f64.ne  	$push14=, $3, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	f64.load	$3=, 0($1)
	i32.const	$push15=, 32
	i32.add 	$push16=, $4, $pop15
	i32.store	$1=, 12($2), $pop16
	f64.const	$push17=, 0x1p2
	f64.ne  	$push18=, $3, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#4:                                 # %if.end16
	f64.load	$3=, 0($1)
	i32.const	$push19=, 40
	i32.add 	$push20=, $4, $pop19
	i32.store	$1=, 12($2), $pop20
	f64.const	$push21=, 0x1.4p2
	f64.ne  	$push22=, $3, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#5:                                 # %if.end21
	f64.load	$3=, 0($1)
	i32.const	$push23=, 48
	i32.add 	$push24=, $4, $pop23
	i32.store	$1=, 12($2), $pop24
	f64.const	$push25=, 0x1.8p2
	f64.ne  	$push26=, $3, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#6:                                 # %if.end26
	f64.load	$3=, 0($1)
	i32.const	$push27=, 56
	i32.add 	$push28=, $4, $pop27
	i32.store	$1=, 12($2), $pop28
	f64.const	$push29=, 0x1.cp2
	f64.ne  	$push30=, $3, $pop29
	br_if   	0, $pop30       # 0: down to label0
# BB#7:                                 # %if.end31
	f64.load	$3=, 0($1)
	i32.const	$push31=, 64
	i32.add 	$push32=, $4, $pop31
	i32.store	$1=, 12($2), $pop32
	f64.const	$push33=, 0x1p3
	f64.ne  	$push34=, $3, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#8:                                 # %if.end36
	f64.load	$3=, 0($1)
	i32.const	$push35=, 72
	i32.add 	$push36=, $4, $pop35
	i32.store	$discard=, 12($2), $pop36
	f64.const	$push37=, 0x1.2p3
	f64.ne  	$push38=, $3, $pop37
	br_if   	0, $pop38       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push45=, __stack_pointer
	i32.const	$push43=, 16
	i32.add 	$push44=, $2, $pop43
	i32.store	$discard=, 0($pop45), $pop44
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
	i32.const	$push27=, __stack_pointer
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 80
	i32.sub 	$push28=, $pop25, $pop26
	i32.store	$push30=, 0($pop27), $pop28
	tee_local	$push29=, $0=, $pop30
	i32.const	$push0=, 64
	i32.add 	$push1=, $pop29, $pop0
	i64.const	$push2=, 4621256167635550208
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 4620693217682128896
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 4619567317775286272
	i64.store	$discard=, 0($pop7), $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 4618441417868443648
	i64.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4617315517961601024
	i64.store	$discard=, 0($pop13), $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, 4616189618054758400
	i64.store	$discard=, 0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, 4613937818241073152
	i64.store	$discard=, 0($pop19), $pop20
	i64.const	$push21=, 4611686018427387904
	i64.store	$discard=, 8($0), $pop21
	i64.const	$push22=, 4607182418800017408
	i64.store	$discard=, 0($0), $pop22
	call    	vafunction@FUNCTION, $0, $0
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
